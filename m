Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6547F27965C
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 05:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729008AbgIZDFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 23:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727495AbgIZDFO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 23:05:14 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB2BC0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 20:05:14 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id h17so4234430otr.1
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 20:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FqctY5OawTqFmwLWj4/Q+jPwVS9yjPn9vr0uzwKZIWQ=;
        b=N+rbUj9/fKfxL5brIBmFQ14gPzkNcsC3mcIeN3qTz745mtdhYAhXJW8DwNV2KT3zbT
         57VeZrjG76JVcFQl6+e+3T9Iye/k3B5tXDoS2jx7dejIewKEb4clwsHEMS5CZWPDwKbV
         WYnjmu5ec4I0mNizYsD1jIL3XNa6XD3pO5Eq0jltrvqD3AXmKiB+9tD14Umce5x7yuJ9
         HWkFtph1BfOpp4wBU4xc1ugFn+LYeesXSZqwt1UnrTBMBuwqQuXeEnU4BhtLBWGBzf3Z
         16MgBwkEQOQHjV8vfZz5AMJs0bw+AJd4K9eQ7fvXBZp+xzvhizFQprm33TL5mRgXNi9r
         PtvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FqctY5OawTqFmwLWj4/Q+jPwVS9yjPn9vr0uzwKZIWQ=;
        b=pI36mYVkoAOG1wSrbAaF/+rSN7Uri1RF2wnCMgJEBNJQ0InfmyIfw/6q5xf9x4LEMK
         LthuuoWoMMmP2CMg3OKulwVtjCTn6QLWXELXqTQjP9OfaWoyUMnip9Nxyq4lC+Kze2Vm
         xD84pn+UkmaDy+ResyhRpEBt9pr+wFB3Ixwlj0LvTAPEEwBEETCIxIuT18RtyGwugKpv
         +He31oEO4y/kT6uun3VWf3IcKmx7rLflpuvu0wmpuqB+JQtWsxtb1ikNhiaTUmFWpXeP
         L8BOqq2JxWKsfp8woHy7UlKvwq/4d2o0c+DGLGXtyyi8GIDtmChVJO3+D1llzPPs5UNx
         DvtA==
X-Gm-Message-State: AOAM5337EnMGpWamLqWfPYz08rOxV90xemAOZWf9XkuHkg8vnebR/AAZ
        L3BtyIFV+GHS9l0S3nhnkdM=
X-Google-Smtp-Source: ABdhPJyIMXKFhLdXTICTWsIYNQxUP22QEfbZFpjI0CG89JXdRpwiaOwL4lTUCvMrq5EMdqj6BgEHmQ==
X-Received: by 2002:a9d:6b9a:: with SMTP id b26mr2211920otq.189.1601089514043;
        Fri, 25 Sep 2020 20:05:14 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:2422:e33f:5844:d27])
        by smtp.googlemail.com with ESMTPSA id g3sm1147086otp.14.2020.09.25.20.05.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 20:05:13 -0700 (PDT)
Subject: Re: [PATCH 1/1] Network: support default route metric per interface
To:     Qingtao Cao <qingtao.cao.au@gmail.com>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, corbet@lwn.net
Cc:     Qingtao Cao <qingtao.cao@digi.com>,
        David Leonard <david.leonard@digi.com>
References: <20200925231159.945-1-qingtao.cao.au@gmail.com>
 <20200925231159.945-2-qingtao.cao.au@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <609cfeac-5056-1668-46ca-e083aa6b06b5@gmail.com>
Date:   Fri, 25 Sep 2020 21:05:10 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200925231159.945-2-qingtao.cao.au@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/25/20 5:11 PM, Qingtao Cao wrote:
> From: Qingtao Cao <qingtao.cao@digi.com>
> 
> Add /proc/sys/net/ipv[4|6]/conf/<device>/def_rt_metric sysfs attribute
> file for each network interface so that userspace programs can specify
> different default route metrics for each interface, which will also be
> applied by the kernel when new routes are automatically created for
> relevant interfaces, when userspace programs may have not specified
> metrics via relevant netlink messages for example.
> 
> Signed-off-by: Qingtao Cao <qingtao.cao@digi.com>
> Signed-off-by: David Leonard <david.leonard@digi.com>
> ---
>  Documentation/networking/ip-sysctl.rst |  8 +++++
>  include/linux/inetdevice.h             |  4 +++
>  include/linux/ipv6.h                   |  3 ++
>  include/net/ip6_route.h                | 15 ++++++++
>  include/uapi/linux/ip.h                |  1 +
>  include/uapi/linux/ipv6.h              |  1 +
>  net/ipv4/Kconfig                       | 13 +++++++
>  net/ipv4/devinet.c                     |  3 ++
>  net/ipv4/fib_frontend.c                | 27 ++++++++++++++
>  net/ipv6/addrconf.c                    | 30 ++++++++++++++--
>  net/ipv6/route.c                       | 50 ++++++++++++++++++++++++--
>  11 files changed, 150 insertions(+), 5 deletions(-)

uh, no.

The metric can be specified for prefix routes via IFA_RT_PRIORITY. There
is no reason for bloating the code and adding another sys knob for this.
Fix your network manager to set the priority when the address is created.

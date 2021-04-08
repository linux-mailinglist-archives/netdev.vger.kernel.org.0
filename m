Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9B6358854
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 17:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232045AbhDHP0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 11:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231940AbhDHP0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 11:26:16 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E28C061761;
        Thu,  8 Apr 2021 08:26:03 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id a6so2568944wrw.8;
        Thu, 08 Apr 2021 08:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ro0Cl2ZMCuXrJ9b0fwLjjBLrLgPpPx9T1CglyBY8Flg=;
        b=P85wMwKSOkDlLreR0HNgYwJ1GmjO4jq9t5vfV7E89O+QZXOoYFAkX6SjMlB+uxsw+p
         BoeunuwoUC81jaKLFHWHpr9SdclpMnmlDPI/LODZugl2ZakbfcBqoWogM0gIB4B5OY//
         rYLHvt62VJheycqLfTRe+eZoL93Zl418mvZDWWrYt9R4q7VUzu1HSyR5KdK1YoSNNVOX
         PisULAy8S8r3a3UdVT5MB82WlwWeSRb9/atdSk+V4fAYqOhCnGLbarrRh/W3lORYstW/
         QjPJJZm26UY5xmh2S2rQlFnmrOjI4vbIGhZYMiK5rA5LqWLci+uCfcxEJufHEEO8mIzq
         oTQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ro0Cl2ZMCuXrJ9b0fwLjjBLrLgPpPx9T1CglyBY8Flg=;
        b=Zq8WJZdfsv6S0FAjPJf5Ylmv1feYHxn75aH+MGkX0QPej0Q8QDxAvSIVKib4UfKZ8j
         Lzsam2fYufXvZv8/6jRZBJva/zJx8M/YM7sTG64BqnORvxxp0y5bAUPiCAK4htqs6HYA
         q7XWn5s8KffQqvlhL/eg2Nf1gyZdKn8raJex6k3eWgTlPajupcT3jy1vrq3cYQZ0Gmfn
         RaCuA1T+ye0Wm+IWQ4gdUtOzOEIFQosrQcmeUS4mf0CgqeZ9KqxgpwhRquUTH0cAFcgy
         S57PwSjpGyyHoZL4kHetEE5inclPP6TDNVeuiLIemUI/oNlRWsWaYEHt9tTz9okLbkpZ
         l2/Q==
X-Gm-Message-State: AOAM5327z1tk5c9/lPtpyAA2yivPB5TWc7fLcxuqnCjPChKeL/ftvZl6
        j1l6gS2X5kvnNXgoNDpcWnYWVmHvUVo=
X-Google-Smtp-Source: ABdhPJzQTZpDMTEJAtpbeLvim8ocsgXHIy0vNqV+oCBbYFFS74wHPGylxgWdlTuc2AJXqKjZBhxbvQ==
X-Received: by 2002:a5d:564a:: with SMTP id j10mr12047785wrw.120.1617895562259;
        Thu, 08 Apr 2021 08:26:02 -0700 (PDT)
Received: from [192.168.1.101] ([37.165.75.160])
        by smtp.gmail.com with ESMTPSA id 91sm51459253wrl.20.2021.04.08.08.26.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Apr 2021 08:26:01 -0700 (PDT)
Subject: Re: [PATCH] net: sched: sch_teql: fix null-pointer dereference
To:     Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210408151431.9512-1-ptikhomirov@virtuozzo.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <0c385039-3780-b5d0-ba36-c1c51da9bc08@gmail.com>
Date:   Thu, 8 Apr 2021 17:26:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210408151431.9512-1-ptikhomirov@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/8/21 5:14 PM, Pavel Tikhomirov wrote:
> Reproduce:
> 
>   modprobe sch_teql
>   tc qdisc add dev teql0 root teql0
> 
> This leads to (for instance in Centos 7 VM) OOPS:
> 
>
> 
> Null pointer dereference happens on master->slaves dereference in
> teql_destroy() as master is null-pointer.
> 
> When qdisc_create() calls teql_qdisc_init() it imediately fails after
> check "if (m->dev == dev)" because both devices are teql0, and it does
> not set qdisc_priv(sch)->m leaving it zero on error path, then
> qdisc_create() imediately calls teql_destroy() which does not expect
> zero master pointer and we get OOPS.
> 
> Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
> ---

This makes sense, thanks !

Reviewed-by: Eric Dumazet <edumazet@google.com>

I would think bug origin is 

Fixes: 87b60cfacf9f ("net_sched: fix error recovery at qdisc creation")

Can you confirm you have this backported to 3.10.0-1062.7.1.el7.x86_64 ?



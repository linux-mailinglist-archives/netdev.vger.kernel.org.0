Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEFD11B6CAB
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 06:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726008AbgDXEZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 00:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbgDXEZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 00:25:21 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 931B3C09B045
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 21:25:21 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id x2so8042749ilp.13
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 21:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hpIY/dmhIszPLDYQq7M9kP9jP0FcXewg/wqYNkwxSrs=;
        b=Ry6FX8JnhrqcfHjkAda0rQMpHNmQGpT7ZY8/Y0Lf2pasQQTW4pTUeukOAINRLePZjB
         2ycR1/wS1/siD5x6qoWgRbyzhu0CHWZe9uUhplLlr8VCft+wCkYsRKD6dYOAPIWApW6U
         fGNAJys6oTSHZp5FLoCh1FwYLvyK6skjAtnW1HienOlPJprTIzbMRtP91shjj1sE5tM8
         AlSy9DJMDs9+4I0AlxCdvSbFpiojSWhvjEjVe5HF10dDUbNvNxkSQgh16U39ly9PtBMI
         lyCtQm9XU3KNs90aY2caMdGT+06w/ltiAqfA+TaNnZrx1QaLf46gUgGOVDQ3wFAgGuWq
         SeEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hpIY/dmhIszPLDYQq7M9kP9jP0FcXewg/wqYNkwxSrs=;
        b=C+n5Cs9D2wtW2tPY1RNMSobUXJcJWq9+Xb9hzZ+kNDtX+s9Dr2U3KNXImFq5slFGcZ
         JOdFup74MR7ZuKSxLHsYczAIqQn3gT0rOsiExMGxMn38Fpbx2FNkTYoliP7XcZWvIA5A
         wRDreOxxVLDzcDJA1kt/8be50EyNhMnH6yYoLnwjbsYdFoFzJl/Wcm1vXac+Iya1EMJg
         8EO85dm+BXGUlfJMqZrevuSOX6iVCGICUIdVv6/NlCJpDK7h6CPn0U6CunTYJlKUv1iJ
         YCtGRjC+eVo/Qw4BxAHdozuv9UZ6YYBFJcFSLFEGfjbOTRxihqn3Db0duioy8NRAjZqX
         7GWg==
X-Gm-Message-State: AGi0PuYMRNyT0GrlcRgNgGk0ZYKeHj6ulIXpBMUd4la0ltOZmUE3ZurZ
        pXgloKhHxC7XIwtYE56coZs=
X-Google-Smtp-Source: APiQypJzs5V7v8vEGYnPsg+AknMGH4bjQcL3ktGEgWpxT0FSLSRFqnYPL3SEcpo8osnq5GfQcDqG2w==
X-Received: by 2002:a92:d2c1:: with SMTP id w1mr6181407ilg.96.1587702320964;
        Thu, 23 Apr 2020 21:25:20 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:2064:c3f6:4748:be84? ([2601:282:803:7700:2064:c3f6:4748:be84])
        by smtp.googlemail.com with ESMTPSA id l23sm1648865ilh.71.2020.04.23.21.25.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2020 21:25:20 -0700 (PDT)
Subject: Re: [PATCH v2 bpf-next 00/17] net: Add support for XDP in egress path
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com
References: <20200424021148.83015-1-dsahern@kernel.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <90cb3817-cf9b-67dd-f050-f15aaddaa545@gmail.com>
Date:   Thu, 23 Apr 2020 22:25:18 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200424021148.83015-1-dsahern@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/23/20 8:11 PM, David Ahern wrote:
> 
> v1:
> - add selftests

BTW, tests fail on bpf-next until the next merge with bpf tree because
of this commit:

https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git/commit/?id=257d7d4f0e69f5e8e3d38351bdcab896719dba04


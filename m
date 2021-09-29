Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9C3741D020
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 01:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347659AbhI2Xol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 19:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346682AbhI2Xok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 19:44:40 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DB68C06161C
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 16:42:59 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id r7so2847146pjo.3
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 16:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=TdR5bI0uurOU8G8Vpp68i9aXBNZXWpN0xXsFlLfLK0w=;
        b=VlQwDr5Om4SVLBu7Mru0biY5+AwUvyUhtiuZw1UzxPWUF3aq391NvMO/5wMui1g0cM
         0B9ceg2jTz47mQtHxP4qc9z88BIMkLExxXkWN9qh9Gx25vyUm0Ml3N74kJMPCczu/gtL
         FU0eoEw8If+andn63PfgaiCmfAQYfdgtbmupNBxZNjHEYUkV36Baonv2ET7z6ZCjvm5K
         YlzLocJp8QtXgktjWUjhPkUowwZuzA55vSCv0mgAhJ56bn0e5Mzx+A1X5mgkr+sUKJTW
         AD/KwhGOzkd/luPznlWSsTaaeDFD62+r4Z/Jc9nZmE8E4TgXJA7eRTJvRixk/6nrQwvy
         Ft2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TdR5bI0uurOU8G8Vpp68i9aXBNZXWpN0xXsFlLfLK0w=;
        b=46bkVbghXgTqt2Co8vdDIpQX11l0W+iPRgYCcnwxzEZujwxBsBSveooUCdJ84RwGW3
         UpDgvH/yMGhb1W+OZe188UIFtWjL61FITmqlL0stQfj7ZS1Rr2WInsT5MOCcDBC0UNN5
         xrjHIsh46ZEEmRR42N6xhVGsFzRZLfVhGYkM5rm/kYGbPUwstXVCyt55FdKfMsP7MRU4
         q2oLzjIN9onJFD/gfB/zc+jnKNerncuViMKRP8oiy6Xm4w1Q53EWra5ZEXR9WlzlmJwx
         2RVtUUTuZR/YS/NxxMB1ZTglr6SnNQfwaISpQLybfeexrmEotxGv2cNlQOaAnacsJQsw
         Y6pA==
X-Gm-Message-State: AOAM530Dfn4ZJdPv4mw5xdXOHbPnsc4qMSQP1NXiTZmHbNCqBEVSTi+c
        62FdfKRezJTl8cY0bFWmUkMM0th7DTA=
X-Google-Smtp-Source: ABdhPJzm8AS/s+yAm1SZdjIpbH/abx3fu2Ug53KbkOKhYIqU0jQylKj0osPYiHVnXWCszBLti4R5pg==
X-Received: by 2002:a17:90b:4f85:: with SMTP id qe5mr2359215pjb.47.1632958978245;
        Wed, 29 Sep 2021 16:42:58 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id i5sm2798622pjk.47.2021.09.29.16.42.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Sep 2021 16:42:57 -0700 (PDT)
Subject: Re: 5.15-rc3+ crash in fq-codel?
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     Ben Greear <greearb@candelatech.com>,
        netdev <netdev@vger.kernel.org>
References: <dfa032f3-18f2-22a3-80bf-f0f570892478@candelatech.com>
 <b6e8155e-7fae-16b0-59f0-2a2e6f5142de@gmail.com>
 <00e495ba-391e-6ad8-94a2-930fbc826a37@candelatech.com>
 <296232ac-e7ed-6e3c-36b9-ed430a21f632@candelatech.com>
 <7e87883e-42f5-2341-ab67-9f1614fb8b86@candelatech.com>
 <7f1d67f1-3a2c-2e74-bb86-c02a56370526@gmail.com>
 <88bc8a03-da44-fc15-f032-fe5cb592958b@candelatech.com>
 <b537053d-498d-928b-8ca0-e9daf5909128@gmail.com>
 <f3f1378d-6839-cd23-9e2c-4668947c2345@gmail.com>
Message-ID: <41b4221b-be68-da96-8cbf-4297bb7ba821@gmail.com>
Date:   Wed, 29 Sep 2021 16:42:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <f3f1378d-6839-cd23-9e2c-4668947c2345@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/29/21 4:28 PM, Eric Dumazet wrote:
> 

> 
> Actually the bug seems to be in pktgen, vs NET_XMIT_CN
> 
> You probably would hit the same issues with other qdisc also using NET_XMIT_CN
> 

I would try the following patch :

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index a3d74e2704c42e3bec1aa502b911c1b952a56cf1..0a2d9534f8d08d1da5dfc68c631f3a07f95c6f77 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -3567,6 +3567,7 @@ static void pktgen_xmit(struct pktgen_dev *pkt_dev)
        case NET_XMIT_DROP:
        case NET_XMIT_CN:
                /* skb has been consumed */
+               pkt_dev->last_ok = 1;
                pkt_dev->errors++;
                break;
        default: /* Drivers are not supposed to return other values! */

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA6793E5589
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 10:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233486AbhHJIfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 04:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbhHJIfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 04:35:00 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 385EDC0613D3
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 01:34:38 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id c9so25094857wri.8
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 01:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Vq7XYhltDAjKrGLRSgmTaATnQoHpMD07O7/b2SGHsgI=;
        b=SWvYBHg+If+578k7jmbxPJwCTnusZtDbCx5XAmD+JQIc8625umR47s3pHr0au5McfO
         Zs6DTLxPNptnhOb/1kYYYcv9x/EO2rjLP12TkpGXqzeKoNgMzXhEGsOqKeBOYe5xYBCm
         QiWbl21Oqhry7MGAqxi8+uigEbH26C5m4eXVJpCWAj4bQa4jzUuhfjteOOeD5UKnlHk5
         Rd+y5yTFuDCZdu4zvJS6c2X+wBS1lwHuybPZstVVAPm38JlEKE2r/RjGSVKKOpL1xQ2N
         cHtMxs79Jw0Hyu7HyuRhIR8a4yh3Btx22q8GsclT4TZXdXu4G225MwTayUbpjIMKQUCU
         Q6Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Vq7XYhltDAjKrGLRSgmTaATnQoHpMD07O7/b2SGHsgI=;
        b=rt2gpj5e71f76B1LFQvItp8QQynXlwTf3DQpLDKeatSsROtVKVS7WQOC9WbafXvSJ5
         IhGY64Ptd7PX6tUmEJaGNFqKEzBHaH8fiu7KeIlj0rLaN57puPVhP19gMOidKfrF48PA
         IMFnAwluyCES3K7NlnNc065Phjjd10NKedzZSPlft2zlEd703+Yvhf5Zj8S3hGjiJ4RL
         1b8ILfKqQiwaBS+Db9K9a+HTB6mBQEMJzInRMfXcQ4EF/UbgJvrLtKfCLFND7TOD8E5/
         QOKzUAbSmfRkJAfwjRwSK4gLvuT/3a/v07MEJn1qfjZ/kcd8ynlK+hX6F6uac/KUC9n5
         XPIw==
X-Gm-Message-State: AOAM531vjiFkAM0T7j0cTHtPHirXAiS3GRZvrs7wnI/64ziBcthm8Zty
        6R4+pVluUdSagJglu+Q81P3NDiTVdcM=
X-Google-Smtp-Source: ABdhPJzTS0TYqLYivOIo1vZIlAcrlyMaZd0cYZwBa7zNsJRBvr2fj/uNf8Dd0SpWg+9AiloB2VjRbw==
X-Received: by 2002:a5d:42c2:: with SMTP id t2mr12910237wrr.49.1628584476465;
        Tue, 10 Aug 2021 01:34:36 -0700 (PDT)
Received: from [10.0.0.18] ([37.165.16.90])
        by smtp.gmail.com with ESMTPSA id z2sm20324963wma.45.2021.08.10.01.34.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 01:34:36 -0700 (PDT)
Subject: Re: Intro into qdisc writing?
To:     Thorsten Glaser <t.glaser@tarent.de>, netdev@vger.kernel.org
References: <1e2625bd-f0e5-b5cf-8f57-c58968a0d1e5@tarent.de>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <d14be9a8-85b2-010e-16f3-cae1587f8471@gmail.com>
Date:   Tue, 10 Aug 2021 10:34:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <1e2625bd-f0e5-b5cf-8f57-c58968a0d1e5@tarent.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/10/21 5:17 AM, Thorsten Glaser wrote:
> Hi,
> 
> I hope this is the right place to ask this kind of questions,
> and not just send patches ☺
> 
> I’m currently working with a… network simulator of sorts, which
> has so far mostly used htb, netem, dualpi2 and fq_codel to do the
> various tricks needed for whatever they do, but now I have rather
> specific change requests (one of which I already implemented).
> 
> The next things on my list basically involve delaying all traffic
> or a subset of traffic for a certain amount of time (in the one‑ to
> two-digit millisecond ballpark, so rather long, in CPU time). I’ve
> seen the netem source use qdisc_watchdog_schedule_ns for this, but,
> unlike the functions I used in my earlier module changes, I cannot
> find any documentation for this.
> 
> Similarily, is there an intro of sorts for qdisc writing, the things
> to know, concepts, locking, whatever is needed?
> 
> My background is multi-decade low-level programmer, but so far only
> userland, libc variants and bootloaders, not kernel, and what bit of
> kernel I touched so far was in BSD land so any pointers welcome.
> 
> If it helps: while this is for a customer project, so far everything
> coming out of it is published under OSS licences; mostly at
> https://github.com/tarent/sch_jens/tree/master/sch_jens as regards
> the kernel module (and ../jens/ for the relayfs client example) but
> https://github.com/tarent/ECN-Bits has a related userspace project.
> 
> Thanks in advance,
> //mirabilos
> 

Instead of writing a new qdisc, you could simply use FQ packet scheduler,
and a eBPF program adjusting skb->tstamp depending on your needs.

https://legacy.netdevconf.info/0x14/session.html?talk-replacing-HTB-with-EDT-and-BPF

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D09A470668
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 17:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244210AbhLJQ4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 11:56:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240946AbhLJQ4G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 11:56:06 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6C6DC061746
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 08:52:30 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id m6so14026816oim.2
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 08:52:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=2xtdh4wdBVz94bDpVXdLWduDzK1M5xMEVd1Ftm+SOt4=;
        b=AjevYMSBRh88DbACbTSGjl0Xzc60sFmBHrrRkdKLpRaTdkEmidHHgl4p+jVDFq5CvZ
         dmxAr0IHQ3lsRqR26JikSWa7PSLFGgj7rGKgp/Vyz6iArVpDuL4mZgqpUdXAWmVtx8mR
         vH2wcQXzwXkdEcOFTf/pizSDA687OCz5OstPXXVZwX5tU2MT8iRfMCoGjD+shfd5QS1+
         /x3ujEPO2rai6Bx1oeLdvbMr1qw6+cNeQOWohAX41vPVNshfgIsJwtzJ140a1ItMdoH5
         rGZAiHSMPCb5CMIbW/BVmTiOMemuxLVBnLjLWtucuQKrng7cDUPMzAYhtffqq9J90sPw
         f3Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=2xtdh4wdBVz94bDpVXdLWduDzK1M5xMEVd1Ftm+SOt4=;
        b=MJ5CjhstlxSRYFWYDXsW4+xF/Jo4sjs/HU/3zAdnRe1xZbKSM3z0G6vhGRhchLbgFu
         3Ul5nTqt4cZWnP7aASgnb2Gt2iRvJ0FAVS3zBRs5chm9PwyjN6TmuBVldW4HDE4sl2IK
         +jHY4RFUnuQ8KkNmAkzv53M/njQihC0BeA+MjSAelFbsdUqKJ6nxd6LdVSFGwRGf4zi5
         LKHtpv8GoD116j5XdQ8M8I/AdnHyiJ4pjttXN4d1QxsW62oSPr+FXg7wya7EE5p+r5s0
         gDm7JLhMKrea2b58VuHrJpEnRmLtzsZz2jLgGGLvgX2woJ6RGkdhpn+SED5q6DbPhKub
         M4pA==
X-Gm-Message-State: AOAM531AS1WPIz/4IdrJ7HZUYYKxuXxzQrYpk7iI217MKMqDwSn8+Xas
        wUHnyD+Fr7O6P0eWsT5KkMU=
X-Google-Smtp-Source: ABdhPJzhlgIaaBTk+Ru1G6t4Mlko9m2icdxMWty5eD1MHcZofrCubXa+PTwPq98lFZZ1kvf9v0pHcQ==
X-Received: by 2002:a54:4692:: with SMTP id k18mr13427034oic.93.1639155150202;
        Fri, 10 Dec 2021 08:52:30 -0800 (PST)
Received: from localhost ([172.243.151.11])
        by smtp.gmail.com with ESMTPSA id bq5sm864656oib.55.2021.12.10.08.52.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 08:52:29 -0800 (PST)
Date:   Fri, 10 Dec 2021 08:52:21 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        xiangxia.m.yue@gmail.com, netdev@vger.kernel.org
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>
Message-ID: <61b385c5c21c3_203252085a@john.notmuch>
In-Reply-To: <61b383c6373ca_1f50e20816@john.notmuch>
References: <20211208145459.9590-1-xiangxia.m.yue@gmail.com>
 <20211208145459.9590-3-xiangxia.m.yue@gmail.com>
 <61b383c6373ca_1f50e20816@john.notmuch>
Subject: RE: [net v5 2/3] net: sched: add check tc_skip_classify in sch egress
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend wrote:
> xiangxia.m.yue@ wrote:
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > 
> > Try to resolve the issues as below:
> > * We look up and then check tc_skip_classify flag in net
> >   sched layer, even though skb don't want to be classified.
> >   That case may consume a lot of cpu cycles. This patch
> >   is useful when there are a lot of filters with different
> >   prio. There is ~5 prio in in production, ~1% improvement.
> > 
> >   Rules as below:
> >   $ for id in $(seq 1 5); do
> >   $       tc filter add ... egress prio $id ... action mirred egress redirect dev ifb0
> >   $ done
> > 
> > * bpf_redirect may be invoked in egress path. If we don't
> >   check the flags and then return immediately, the packets
> >   will loopback.
> 
> This would be the naive case right? Meaning the BPF program is
> doing a redirect without any logic or is buggy?
> 
> Can you map out how this happens for me, I'm not fully sure I
> understand the exact concern. Is it possible for BPF programs
> that used to see packets no longer see the packet as expected?
> 
> Is this the path you are talking about?
> 
>  rx ethx  ->
>    execute BPF program on ethx with bpf_redirect(ifb0) ->
>      __skb_dequeue @ifb tc_skip_classify = 1 ->
>        dev_queue_xmit() -> 
>           sch_handle_egress() ->
>             execute BPF program again
> 
> I can't see why you want to skip that second tc BPF program,
> or for that matter any tc filter there. In general how do you
> know that is the correct/expected behavior? Before the above
> change it would have been called, what if its doing useful
> work.
> 
> Also its not clear how your ifb setup is built or used. That
> might help understand your use case. I would just remove the
> IFB altogether and the above discussion is mute.
> 
> Thanks,
> John

After a bit further thought (and coffee) I think this will
break some programs that exist today. Consider the case
where I pop a header off and resubmit to the same device
intentionally to reprocess the pkt without the header. I've
used this pattern in BPF a few times.

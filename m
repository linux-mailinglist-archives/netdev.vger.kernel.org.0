Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A57C41A3EF
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 01:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238189AbhI0XvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 19:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231674AbhI0XvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 19:51:12 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D29AC061575
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 16:49:33 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 17so19311578pgp.4
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 16:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=DIkEEOztiUobA4+zTt9x58SWGDtenR6YvwBF7kf5zlc=;
        b=XrQkAm8enPfZr1n7T8pE61tCOmMGqG6/qJV7L3+wvPPhE9A/rwV5HJc78pWSa4TBKJ
         5FrNyNse4V/Rb0J/oFQmr9502B5E/ZtTikxuSVsXwEqxtD12GfvgqvGzcnGLRMLJ/9by
         ct+0k8gyIjL5+o91k9Mlm+dwjd6U1W6TgTcp9ID0pSwnhEpgujGS2QLgmKTkYw7mgF+X
         tgFGRUX5JGItrE9MWWYnIiV/T2pmgeDZN8PgJF1h3+gi2EW1ojuJKoaBdA4f76fMyRN7
         wKFneppc8wBsgCdwTOV7TbLX2lYjVcDCfxsZHqlos/xEoiQn2QmVBM+IMHtjmGlayHCi
         9uBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DIkEEOztiUobA4+zTt9x58SWGDtenR6YvwBF7kf5zlc=;
        b=gMmRNL3n0MYgZpqnA+J8sJKA9iFw+MDAPGnQtKEUVzwFew6B+PRcSj2P4xDHFFQRkN
         qPCoNt2ReSyDfPF8VAC4445f1XtA0LjM+0fWCOr/yKSeX32yN/CUg3MkPB6bgE9olx3H
         HqFX2GI36fiDUabNg2NU8AZCe+ppbd4TiK/nVdPAQf/k2teHgzQ3fJXfjWDGvaLEUbZq
         AHKpx+REmSa1bWo/TXso7/WgwrgG4hX55b3y+lYz5hWVz6S1pvirZwSM9BePSwHg7+5m
         Lout3NqdI7SHPBz0ReE9M7FGicNJSnQ/SOQKfp/JvszLrbFdYC0PWhSl2DRfa2LSG/C2
         GELA==
X-Gm-Message-State: AOAM531clyNLW+eqHib1gn8V/OkJ9IGObLIvg0JN4HFcrWzNV8zm9qoI
        b5xm4mRUdg7N1ZPuqNDth+CxMwH92xY=
X-Google-Smtp-Source: ABdhPJyoFZlLvJAxwY9RuiiFaJg9nzY2smnEEq4eitSt5ARL9zsf5bnGbXDOMUOAhjYmI2sqjqYRQw==
X-Received: by 2002:aa7:9561:0:b0:44b:45ea:806b with SMTP id x1-20020aa79561000000b0044b45ea806bmr2594785pfq.57.1632786572609;
        Mon, 27 Sep 2021 16:49:32 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id g22sm17899920pfb.191.2021.09.27.16.49.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Sep 2021 16:49:32 -0700 (PDT)
Subject: Re: 5.15-rc3+ crash in fq-codel?
To:     Ben Greear <greearb@candelatech.com>,
        netdev <netdev@vger.kernel.org>
References: <dfa032f3-18f2-22a3-80bf-f0f570892478@candelatech.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <b6e8155e-7fae-16b0-59f0-2a2e6f5142de@gmail.com>
Date:   Mon, 27 Sep 2021 16:49:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <dfa032f3-18f2-22a3-80bf-f0f570892478@candelatech.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/27/21 4:30 PM, Ben Greear wrote:
> Hello,
> 
> In a hacked upon kernel, I'm getting crashes in fq-codel when doing bi-directional
> pktgen traffic on top of mac-vlans.  Unfortunately for me, I've made big changes to
> pktgen so I cannot easily run this test on stock kernels, and there is some chance
> some of my hackings have caused this issue.
> 
> But, in case others have seen similar, please let me know.  I shall go digging
> in the meantime...
> 
> Looks to me like 'skb' is NULL in line 120 below.


pktgen must not be used in a mode where a single skb
is cloned and reused, if packet needs to be stored in a qdisc.

qdisc of all sorts assume skb->next/prev can be used as
anchor in their list.

If the same skb is queued multiple times, lists are corrupted.

Please double check your clone_skb pktgen setup.

I thought we had IFF_TX_SKB_SHARING for this, and that macvlan was properly clearing this bit.

> 
> For help, type "help".
> Type "apropos word" to search for commands related to "word"...
> Reading symbols from ./net/sched/sch_fq_codel.ko...done.
> "/home/greearb/kernel/2.6/linux-5.15.x64/vmlinux" is not a core dump: file format not recognized
> (gdb) l *(fq_codel_enqueue+0x24b)
> 0x76b is in fq_codel_enqueue (/home/greearb/git/linux-5.15.dev.y/net/sched/sch_fq_codel.c:120).
> 115    /* remove one skb from head of slot queue */
> 116    static inline struct sk_buff *dequeue_head(struct fq_codel_flow *flow)
> 117    {
> 118        struct sk_buff *skb = flow->head;
> 119   
> 120        flow->head = skb->next;
> 121        skb_mark_not_on_list(skb);
> 122        return skb;
> 123    }
> 124   
> (gdb)
> 
> 
> BUG: kernel NULL pointer dereference, address: 0000000000000000
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page
> PGD 0 P4D 0
> Oops: 0000 [#1] PREEMPT SMP
> CPU: 3 PID: 2077 Comm: kpktgend_3 Not tainted 5.15.0-rc3+ #2
> Hardware name: Default string Default string/SKYBAY, BIOS 5.12 02/19/2019
> RIP: 0010:fq_codel_enqueue+0x24b/0x380 [sch_fq_codel]
> Code: e0 02 48 89 44 24 08 49 c1 e0 06 4c 03 83 50 01 00 00 45 31 f6 45 31 c9 31 c9 89 74 24 10 eb 04 39 fa 73 33 49 8b 00 83 c13
> RSP: 0018:ffffc9000030fd10 EFLAGS: 00010202
> RAX: 0000000000000000 RBX: ffff88810a78f600 RCX: 0000000000000032
> RDX: 00000000000121ca RSI: ffff88812d716900 RDI: 00000000003b26f5
> RBP: ffffc9000030fd78 R08: ffff8881311dd340 R09: 00000000000121ca
> R10: 000000000000034d R11: 0000000001680900 R12: ffffc9000030fde0
> R13: 000000000001b900 R14: 000000000001b900 R15: 0000000000000040
> FS:  0000000000000000(0000) GS:ffff888265cc0000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 000000000260f003 CR4: 00000000003706e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  dev_qdisc_enqueue+0x35/0x90
>  __dev_queue_xmit+0x647/0xb70
>  macvlan_start_xmit+0x4a/0x110 [macvlan]
>  pktgen_thread_worker+0x19fe/0x20ed [pktgen]
>  ? wait_woken+0x60/0x60
>  ? pktgen_rem_all_ifs+0x70/0x70 [pktgen]
>  kthread+0x11e/0x150
>  ? set_kthread_struct+0x40/0x40
>  ret_from_fork+0x1f/0x30
> 
> 
> Thanks,
> Ben
> 

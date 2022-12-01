Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 605FF63EDA6
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 11:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbiLAKZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 05:25:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbiLAKZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 05:25:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA4769950C
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 02:24:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669890265;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bmBnBm4vsYyGCCu3ovFDuG2h1IVfzb0MiBStdNV5Cdw=;
        b=Tm+vDqalxffaSBYdXgyMGazHBTIMThSQq/lGurowheoGE7JF5v4mezPAgRJhBLMPptGOfB
        6tSjRpQRtM0v+/ENlqJ3IvhRKjABtRmIv0ZTlSG5wmVgGC3w51pKFmLy3j3hOQbkqBWkJo
        4su0eO8QuOkDuCxKruHI++1qfwZgzts=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-556-D4wtMacBM_emXAdB0ENHAQ-1; Thu, 01 Dec 2022 05:24:24 -0500
X-MC-Unique: D4wtMacBM_emXAdB0ENHAQ-1
Received: by mail-qt1-f198.google.com with SMTP id fz10-20020a05622a5a8a00b003a4f466998cso3240660qtb.16
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 02:24:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bmBnBm4vsYyGCCu3ovFDuG2h1IVfzb0MiBStdNV5Cdw=;
        b=WnQNTkpi+S35Aopap9cvAWqsGryur1q49/LNFISmlNqpr2UYKti6HLpQzXYQiXJsL/
         4aDZRFWd1KX5g8kcdgi3JB2Satu7AeyzHExdsIrFi5XbyozW7H0lChsMboWkXoztVqqR
         2sVwjlEocDWFLXx1EI4nv83XwcaD9Vp/ZfS+UKuCAbmfsZsxSoVyEA/Tz6IODv3IbZPt
         O+TXh6p/+Jc3703eFNuFNG1JvwWj/RVQfaO6X9ia1OfFTATjY9Jonjn1yeWBxyExrQfS
         SL7UpCIWJciszB6PD8Dwgr2+uP8Y1wPnPGl561xaP4RV9PogzDdlBxKiHKP8X6UmblQK
         ebdg==
X-Gm-Message-State: ANoB5pmZkQYPY0Z+QvOWUNKLmEoqZUoIgeeiIneh0PTozKPLf3hiXzEE
        ZMlNxTZ0gTEVyX7EfOYNine6cgktFPuQdngGwAw22e5aO73lZf01imULmqQskuKFV9KZE2vWOKl
        WhevdPXcyopMXeOy/
X-Received: by 2002:ac8:48d1:0:b0:3a5:c86a:aa46 with SMTP id l17-20020ac848d1000000b003a5c86aaa46mr43891816qtr.534.1669890262344;
        Thu, 01 Dec 2022 02:24:22 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6B8d/wzBVQ7rtNSYOWOGURgQ/e5A38CmiuDOPmZM2XjCAgWap/ePJI8iE81OPeQx9Z0kUGig==
X-Received: by 2002:ac8:48d1:0:b0:3a5:c86a:aa46 with SMTP id l17-20020ac848d1000000b003a5c86aaa46mr43891791qtr.534.1669890262052;
        Thu, 01 Dec 2022 02:24:22 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-203.dyn.eolo.it. [146.241.120.203])
        by smtp.gmail.com with ESMTPSA id s18-20020a05620a29d200b006fba0a389a4sm3309399qkp.88.2022.12.01.02.24.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 02:24:21 -0800 (PST)
Message-ID: <a45ab50d7566913913be41336e6e37369c073925.camel@redhat.com>
Subject: Re: [PATCH v3] net: sched: fix memory leak in tcindex_set_parms
From:   Paolo Abeni <pabeni@redhat.com>
To:     Hawkins Jiawei <yin31149@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     18801353760@163.com,
        syzbot+232ebdbd36706c965ebf@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com,
        Cong Wang <cong.wang@bytedance.com>,
        Dmitry Vyukov <dvyukov@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 01 Dec 2022 11:24:17 +0100
In-Reply-To: <20221129025249.463833-1-yin31149@gmail.com>
References: <20221129025249.463833-1-yin31149@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-11-29 at 10:52 +0800, Hawkins Jiawei wrote:
> Syzkaller reports a memory leak as follows:
> ====================================
> BUG: memory leak
> unreferenced object 0xffff88810c287f00 (size 256):
>   comm "syz-executor105", pid 3600, jiffies 4294943292 (age 12.990s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<ffffffff814cf9f0>] kmalloc_trace+0x20/0x90 mm/slab_common.c:1046
>     [<ffffffff839c9e07>] kmalloc include/linux/slab.h:576 [inline]
>     [<ffffffff839c9e07>] kmalloc_array include/linux/slab.h:627 [inline]
>     [<ffffffff839c9e07>] kcalloc include/linux/slab.h:659 [inline]
>     [<ffffffff839c9e07>] tcf_exts_init include/net/pkt_cls.h:250 [inline]
>     [<ffffffff839c9e07>] tcindex_set_parms+0xa7/0xbe0 net/sched/cls_tcindex.c:342
>     [<ffffffff839caa1f>] tcindex_change+0xdf/0x120 net/sched/cls_tcindex.c:553
>     [<ffffffff8394db62>] tc_new_tfilter+0x4f2/0x1100 net/sched/cls_api.c:2147
>     [<ffffffff8389e91c>] rtnetlink_rcv_msg+0x4dc/0x5d0 net/core/rtnetlink.c:6082
>     [<ffffffff839eba67>] netlink_rcv_skb+0x87/0x1d0 net/netlink/af_netlink.c:2540
>     [<ffffffff839eab87>] netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>     [<ffffffff839eab87>] netlink_unicast+0x397/0x4c0 net/netlink/af_netlink.c:1345
>     [<ffffffff839eb046>] netlink_sendmsg+0x396/0x710 net/netlink/af_netlink.c:1921
>     [<ffffffff8383e796>] sock_sendmsg_nosec net/socket.c:714 [inline]
>     [<ffffffff8383e796>] sock_sendmsg+0x56/0x80 net/socket.c:734
>     [<ffffffff8383eb08>] ____sys_sendmsg+0x178/0x410 net/socket.c:2482
>     [<ffffffff83843678>] ___sys_sendmsg+0xa8/0x110 net/socket.c:2536
>     [<ffffffff838439c5>] __sys_sendmmsg+0x105/0x330 net/socket.c:2622
>     [<ffffffff83843c14>] __do_sys_sendmmsg net/socket.c:2651 [inline]
>     [<ffffffff83843c14>] __se_sys_sendmmsg net/socket.c:2648 [inline]
>     [<ffffffff83843c14>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2648
>     [<ffffffff84605fd5>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>     [<ffffffff84605fd5>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>     [<ffffffff84800087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> ====================================
> 
> Kernel uses tcindex_change() to change an existing
> filter properties. During the process of changing,
> kernel uses tcindex_alloc_perfect_hash() to newly
> allocate filter results, uses tcindex_filter_result_init()
> to clear the old filter result.
> 
> Yet the problem is that, kernel clears the old
> filter result, without destroying its tcf_exts structure,
> which triggers the above memory leak.
> 
> Considering that there already extis a tc_filter_wq workqueue
> to destroy the old tcindex_data by tcindex_partial_destroy_work()
> at the end of tcindex_set_parms(), this patch solves this memory
> leak bug by removing this old filter result clearing part,
> and delegating it to the tc_filter_wq workqueue.
> 
> [Thanks to the suggestion from Jakub Kicinski, Cong Wang, Paolo Abeni
> and Dmitry Vyukov]
> 
> Fixes: b9a24bb76bf6 ("net_sched: properly handle failure case of tcf_exts_init()")
> Link: https://lore.kernel.org/all/0000000000001de5c505ebc9ec59@google.com/
> Reported-by: syzbot+232ebdbd36706c965ebf@syzkaller.appspotmail.com
> Tested-by: syzbot+232ebdbd36706c965ebf@syzkaller.appspotmail.com
> Cc: Cong Wang <cong.wang@bytedance.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Dmitry Vyukov <dvyukov@google.com> 
> Signed-off-by: Hawkins Jiawei <yin31149@gmail.com>

The patch looks correct to me, but we are very late in this release
cycle, and I fear there is a chance of introducing some regression. The
issue addressed here is present since quite some time, I suggest to
postpone this fix to the beginning of the next release cycle.

Please, repost this patch after that 6.1 is released, thanks! (And feel
free to add my Acked-by).

Paolo


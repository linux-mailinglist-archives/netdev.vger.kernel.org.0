Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6A0653B04
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 04:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234675AbiLVDvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 22:51:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiLVDva (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 22:51:30 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A3FDE03B;
        Wed, 21 Dec 2022 19:51:28 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id gt4so645515pjb.1;
        Wed, 21 Dec 2022 19:51:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JVzO4A59GJB73e9OIQftd9aBkwarFNLE+P23ExPClEM=;
        b=qW0XcbZxdZyDL63iJUAiP669akZV9hxLJMLxmTAcNnpxiuAgGR9EZ5FNZugHi0GlUJ
         Wuj1LB8OSAxTDa7IQsG8OUFKErmWK32XlMTRplVIgSu+Mq2yPhJrtln77I8LW2de33x4
         fJA6C3DeyUjHD7sBNkAzITWZpbWvhXUEA+2e+EK3Q/v33ASzmyxMYc1fKdsMvmJmWirM
         e40iaKjXBNH9ENfxteeX0xV8SLB1S2u5BGvSAGfcRmez5Hdc4yJ2x6DWK6j0pVqATm26
         6W+ToaURZ1+X9qqSIn52WMCoXUS2AaDSHNb00sf9AQtI5Yi+1IVIHTC2Sk/dFCi39fIA
         VRRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JVzO4A59GJB73e9OIQftd9aBkwarFNLE+P23ExPClEM=;
        b=TuSluhaMnr5sKjHJrroCzE9zLZpypAoPWn4CrBJBulRn1vINBEbkd98qLmqHpLtibF
         wWSZ+gDnikv6Xpx+ipF/fHjaKkMplMvhwg6SC10gfrYlzp51mhrAM7nu978H/beGVtKU
         xVHwUMiilZaZqopuOAhG+DUJAA/1cpiFkwPl/qboYQG8rNtiB+7xEZyLnQ8UvOrQoPV+
         qzPPK99Cla9QTKdNX34dYOKfQuYSnxqFxmg8WeN61Zw4Q+BQyLcxs+1g02NpsVpLiQKL
         9SBMxHjkmzq8a8IqWjtCGV//f+4REs7w9GmaJhMGcfiNonBTQbT52ItkEmUqi7i851VO
         jElg==
X-Gm-Message-State: AFqh2ko7GfUQuBkUwDY2iC9XIIgyIioK7EICD32WAEPy9E/6XgsUtTfB
        +uhrUNfhi4qY0W32mYR/cv0=
X-Google-Smtp-Source: AMrXdXu5K0IVh5WW/L2+I5GfrbR4kt3moFA+mACbA5AQURZtGwmoducJ5x5qgAMOOAftQzS4z9er7A==
X-Received: by 2002:a17:90a:a08c:b0:223:4bfe:f215 with SMTP id r12-20020a17090aa08c00b002234bfef215mr4883914pjp.15.1671681087961;
        Wed, 21 Dec 2022 19:51:27 -0800 (PST)
Received: from localhost ([1.83.245.70])
        by smtp.gmail.com with ESMTPSA id x11-20020a17090a294b00b00225a127b2a2sm1991748pjf.5.2022.12.21.19.51.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Dec 2022 19:51:27 -0800 (PST)
From:   Hawkins Jiawei <yin31149@gmail.com>
To:     yin31149@gmail.com, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     18801353760@163.com, cong.wang@bytedance.com, dvyukov@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzbot+232ebdbd36706c965ebf@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com
Subject: [PATCH v4] net: sched: fix memory leak in tcindex_set_parms
Date:   Thu, 22 Dec 2022 11:51:19 +0800
Message-Id: <20221222035119.7118-1-yin31149@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzkaller reports a memory leak as follows:
====================================
BUG: memory leak
unreferenced object 0xffff88810c287f00 (size 256):
  comm "syz-executor105", pid 3600, jiffies 4294943292 (age 12.990s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff814cf9f0>] kmalloc_trace+0x20/0x90 mm/slab_common.c:1046
    [<ffffffff839c9e07>] kmalloc include/linux/slab.h:576 [inline]
    [<ffffffff839c9e07>] kmalloc_array include/linux/slab.h:627 [inline]
    [<ffffffff839c9e07>] kcalloc include/linux/slab.h:659 [inline]
    [<ffffffff839c9e07>] tcf_exts_init include/net/pkt_cls.h:250 [inline]
    [<ffffffff839c9e07>] tcindex_set_parms+0xa7/0xbe0 net/sched/cls_tcindex.c:342
    [<ffffffff839caa1f>] tcindex_change+0xdf/0x120 net/sched/cls_tcindex.c:553
    [<ffffffff8394db62>] tc_new_tfilter+0x4f2/0x1100 net/sched/cls_api.c:2147
    [<ffffffff8389e91c>] rtnetlink_rcv_msg+0x4dc/0x5d0 net/core/rtnetlink.c:6082
    [<ffffffff839eba67>] netlink_rcv_skb+0x87/0x1d0 net/netlink/af_netlink.c:2540
    [<ffffffff839eab87>] netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
    [<ffffffff839eab87>] netlink_unicast+0x397/0x4c0 net/netlink/af_netlink.c:1345
    [<ffffffff839eb046>] netlink_sendmsg+0x396/0x710 net/netlink/af_netlink.c:1921
    [<ffffffff8383e796>] sock_sendmsg_nosec net/socket.c:714 [inline]
    [<ffffffff8383e796>] sock_sendmsg+0x56/0x80 net/socket.c:734
    [<ffffffff8383eb08>] ____sys_sendmsg+0x178/0x410 net/socket.c:2482
    [<ffffffff83843678>] ___sys_sendmsg+0xa8/0x110 net/socket.c:2536
    [<ffffffff838439c5>] __sys_sendmmsg+0x105/0x330 net/socket.c:2622
    [<ffffffff83843c14>] __do_sys_sendmmsg net/socket.c:2651 [inline]
    [<ffffffff83843c14>] __se_sys_sendmmsg net/socket.c:2648 [inline]
    [<ffffffff83843c14>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2648
    [<ffffffff84605fd5>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff84605fd5>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84800087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
====================================

Kernel uses tcindex_change() to change an existing
filter properties.

Yet the problem is that, during the process of changing,
if `old_r` is retrieved from `p->perfect`, then
kernel uses tcindex_alloc_perfect_hash() to newly
allocate filter results, uses tcindex_filter_result_init()
to clear the old filter result, without destroying
its tcf_exts structure, which triggers the above memory leak.

To be more specific, there are only two source for the `old_r`,
according to the tcindex_lookup(). `old_r` is retrieved from
`p->perfect`, or `old_r` is retrieved from `p->h`.

  * If `old_r` is retrieved from `p->perfect`, kernel uses
tcindex_alloc_perfect_hash() to newly allocate the
filter results. Then `r` is assigned with `cp->perfect + handle`,
which is newly allocated. So condition `old_r && old_r != r` is
true in this situation, and kernel uses tcindex_filter_result_init()
to clear the old filter result, without destroying
its tcf_exts structure

  * If `old_r` is retrieved from `p->h`, then `p->perfect` is NULL
according to the tcindex_lookup(). Considering that `cp->h`
is directly copied from `p->h` and `p->perfect` is NULL,
`r` is assigned with `tcindex_lookup(cp, handle)`, whose value
should be the same as `old_r`, so condition `old_r && old_r != r`
is false in this situation, kernel ignores using
tcindex_filter_result_init() to clear the old filter result.

So only when `old_r` is retrieved from `p->perfect` does kernel use
tcindex_filter_result_init() to clear the old filter result, which
triggers the above memory leak.

Considering that there already exists a tc_filter_wq workqueue
to destroy the old tcindex_data by tcindex_partial_destroy_work()
at the end of tcindex_set_parms(), this patch solves
this memory leak bug by removing this old filter result
clearing part and delegating it to the tc_filter_wq workqueue.

Note that this patch doesn't introduce any other issues. If
`old_r` is retrieved from `p->perfect`, this patch just
delegates old filter result clearing part to the
tc_filter_wq workqueue; If `old_r` is retrieved from `p->h`,
kernel doesn't reach the old filter result clearing part, so
removing this part has no effect.

[Thanks to the suggestion from Jakub Kicinski, Cong Wang, Paolo Abeni
and Dmitry Vyukov]

Fixes: b9a24bb76bf6 ("net_sched: properly handle failure case of tcf_exts_init()")
Link: https://lore.kernel.org/all/0000000000001de5c505ebc9ec59@google.com/
Reported-by: syzbot+232ebdbd36706c965ebf@syzkaller.appspotmail.com
Tested-by: syzbot+232ebdbd36706c965ebf@syzkaller.appspotmail.com
Cc: Cong Wang <cong.wang@bytedance.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Hawkins Jiawei <yin31149@gmail.com>
---
v4:
 - make commit message clearer
 - clean up the `old_r`
 - retest the patch on kernel v6.1 suggested by
Paolo Abeni

v3: https://lore.kernel.org/all/20221129025249.463833-1-yin31149@gmail.com/
v2: https://lore.kernel.org/all/20221113170507.8205-1-yin31149@gmail.com/
v1: https://lore.kernel.org/all/20221031060835.11722-1-yin31149@gmail.com/

 net/sched/cls_tcindex.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
index eb0e9458e722..ee2a050c887b 100644
--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -333,7 +333,7 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
 		  struct tcindex_filter_result *r, struct nlattr **tb,
 		  struct nlattr *est, u32 flags, struct netlink_ext_ack *extack)
 {
-	struct tcindex_filter_result new_filter_result, *old_r = r;
+	struct tcindex_filter_result new_filter_result;
 	struct tcindex_data *cp = NULL, *oldp;
 	struct tcindex_filter *f = NULL; /* make gcc behave */
 	struct tcf_result cr = {};
@@ -402,7 +402,7 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
 	err = tcindex_filter_result_init(&new_filter_result, cp, net);
 	if (err < 0)
 		goto errout_alloc;
-	if (old_r)
+	if (r)
 		cr = r->res;
 
 	err = -EBUSY;
@@ -479,14 +479,6 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
 		tcf_bind_filter(tp, &cr, base);
 	}
 
-	if (old_r && old_r != r) {
-		err = tcindex_filter_result_init(old_r, cp, net);
-		if (err < 0) {
-			kfree(f);
-			goto errout_alloc;
-		}
-	}
-
 	oldp = p;
 	r->res = cr;
 	tcf_exts_change(&r->exts, &e);
-- 
2.25.1


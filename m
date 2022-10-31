Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4D31613027
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 07:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbiJaGIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 02:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiJaGIk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 02:08:40 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B301310CE;
        Sun, 30 Oct 2022 23:08:39 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id e129so9840243pgc.9;
        Sun, 30 Oct 2022 23:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iEE08gyNxXm/V2oNqjJuD7X/v5POQZGV6saTMMYOy0I=;
        b=pe7Z/HoFYVd22iReZXMg/yQhJGXQCbDTDTjxqJoDfsGnPXU2r6xPW1xBStxvz+u9Uj
         NlGCW++oC0//NtdCNnfGpcYAoz38+o27CfDgLkpZ6Ucqf3GrZwamjIETWPsdjQMQYBow
         W2BWEMUAsAdjkIWNorvzojKqgxMpwgGdkUhPp+izVwoF9/PBhYVYrozupT8TO/GjYQxS
         Ac49G9tiMena5j3mB0m2HRExHdN2prqCK1K80opvSfkcnkWpG8RREY0fiGVy4RC37IO5
         NGaLOBNRGnzceorVhG1+tA08H9Wuby7xcyGjeAiAFrPiGTvMo9YF0a5y7XgSPWf9oEWS
         4wPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iEE08gyNxXm/V2oNqjJuD7X/v5POQZGV6saTMMYOy0I=;
        b=gjXaZCNGpiAEuZkQOgqO5TdLS+fdZRRZL47mpmY2sDXU5huq196cF2yusgx4QsXMza
         y9cjwlcAGddazgDtxLxeCzFnB8BTWzYpV/duRvxa5WILquBvCJT3mjDGmZD0um6zRxVW
         P7+IBeGfSGTREZGtD1crTDdIUxI5groR1r8KT+M+GZnti//MyiuHrSrMfPZ8b0WvCVog
         bVbXs5dB0hKqLhY8u5wi+VWlRJs1OsfTbS9EDY7aWaTC+jtH1+qnePXu/nNH6YkdQsHj
         CVc1CkVo2pzL+ED/K9/+Fx0Lwt1HDAnx6+hb9S0Eu7xHOu3tRuyMeRwRDY2bjBdZJ56r
         3H9Q==
X-Gm-Message-State: ACrzQf0eKLD1eoMkmywngb9kfA0RcFcF4+tSJdeB2bbJDhnl0uV9V1VU
        +YzHjtfPhUPXC3pfEy2Kfvw=
X-Google-Smtp-Source: AMsMyM4eag2Tjic63uXgSpJBkNHOPb3Ibcy9CUWLoFzAaSQoDSjqm7KWDcD9v2ojOjmkQo8HrICcaA==
X-Received: by 2002:a63:5455:0:b0:46f:be60:af9b with SMTP id e21-20020a635455000000b0046fbe60af9bmr3441248pgm.307.1667196519118;
        Sun, 30 Oct 2022 23:08:39 -0700 (PDT)
Received: from localhost ([159.226.94.113])
        by smtp.gmail.com with ESMTPSA id n6-20020a170902d2c600b00181f8523f60sm3583174plc.225.2022.10.30.23.08.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Oct 2022 23:08:38 -0700 (PDT)
From:   Hawkins Jiawei <yin31149@gmail.com>
To:     yin31149@gmail.com, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     syzbot+232ebdbd36706c965ebf@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, 18801353760@163.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: sched: fix memory leak in tcindex_set_parms
Date:   Mon, 31 Oct 2022 14:08:35 +0800
Message-Id: <20221031060835.11722-1-yin31149@gmail.com>
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

Kernel will uses tcindex_change() to change an existing
traffic-control-indices filter properties. During the
process of changing, kernel will clears the old
traffic-control-indices filter result, and updates it
by RCU assigning new traffic-control-indices data.

Yet the problem is that, kernel will clears the old
traffic-control-indices filter result, without destroying
its tcf_exts structure, which triggers the above
memory leak.

This patch solves it by using tcf_exts_destroy() to
destroy the tcf_exts structure in old
traffic-control-indices filter result.

Link: https://lore.kernel.org/all/0000000000001de5c505ebc9ec59@google.com/
Reported-by: syzbot+232ebdbd36706c965ebf@syzkaller.appspotmail.com
Tested-by: syzbot+232ebdbd36706c965ebf@syzkaller.appspotmail.com
Signed-off-by: Hawkins Jiawei <yin31149@gmail.com>
---
 net/sched/cls_tcindex.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
index 1c9eeb98d826..dc872a794337 100644
--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -338,6 +338,9 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
 	struct tcf_result cr = {};
 	int err, balloc = 0;
 	struct tcf_exts e;
+#ifdef CONFIG_NET_CLS_ACT
+	struct tcf_exts old_e = {};
+#endif
 
 	err = tcf_exts_init(&e, net, TCA_TCINDEX_ACT, TCA_TCINDEX_POLICE);
 	if (err < 0)
@@ -479,6 +482,14 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
 	}
 
 	if (old_r && old_r != r) {
+#ifdef CONFIG_NET_CLS_ACT
+		/* r->exts is not copied from old_r->exts, and
+		 * the following code will clears the old_r, so
+		 * we need to destroy it after updating the tp->root,
+		 * to avoid memory leak bug.
+		 */
+		old_e = old_r->exts;
+#endif
 		err = tcindex_filter_result_init(old_r, cp, net);
 		if (err < 0) {
 			kfree(f);
@@ -510,6 +521,9 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
 		tcf_exts_destroy(&new_filter_result.exts);
 	}
 
+#ifdef CONFIG_NET_CLS_ACT
+	tcf_exts_destroy(&old_e);
+#endif
 	if (oldp)
 		tcf_queue_work(&oldp->rwork, tcindex_partial_destroy_work);
 	return 0;
-- 
2.25.1


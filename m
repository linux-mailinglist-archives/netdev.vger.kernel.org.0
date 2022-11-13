Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4067F62711B
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 18:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235144AbiKMRFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 12:05:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232799AbiKMRFX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 12:05:23 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 630E9DEE6;
        Sun, 13 Nov 2022 09:05:22 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id 140so7560344pfz.6;
        Sun, 13 Nov 2022 09:05:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gA2/oZmfwkbn2XDHTL8FyR2xx1wlqu47HFzJm5YeRu8=;
        b=FrzKq3sBcmK7w6Lr9PwFG56hYyGXGffSTIj2Ql2D/MKxaBY8nj8NZJLjY9UaXriiIx
         0l32NyLQBGptP9cgRHIMDael4OQRYPSeoEjVjaza7akvqdsA4lrcH97hlf3wLwiCnrWC
         lJNTv5AZx34ySde+Dz9TMpQQ/PoUdgpBb4l6IbQFrVA8/Gbr3EBuwbEPA/K87byw6sH+
         ReFIpcy83XfwFDZXPe8TLKFtf0/Bnc1In8lWM6ed4985ArYSftD+LK2iyOz/IFCuFY3q
         kg+crTLR+M2L83c1fTp5JvcO/YhBwu+XBt0eTAjkDNmG2kyuDUAlSqq9rS870C0DUyFY
         DJsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gA2/oZmfwkbn2XDHTL8FyR2xx1wlqu47HFzJm5YeRu8=;
        b=VMldAU1sq9t+9h0R6dWOAqy+06Mr1lgavjnjyU1AbVjAoBnL6hipx6QFqThd/ZUuR8
         28jBdx9wzP1vQI68n57PuyNtoWfrc6wlY0QvlJl9maPu8xPULg/3KSkOBblIr81J2b+a
         bzdwuickIwTtns+1LKvr0NRiMUnf07pRxfKWqOIN/a0gjdt4GIisMIfJVwsqkYuJStsm
         AzNtFVDOQk7YvSLCPO3Ln08Xgbu5Mx/5UzR1CDldWRcHHpgmW5C46W++UDNg6yLpKPq9
         ITvMef7H26+xW76O3FXStzaCK8GbTpopFhVuUSMNbHW2ZJCy8yS0iWlL3CDuHynvZTyV
         OrJw==
X-Gm-Message-State: ANoB5pkUBkXd/L4VPV2wzDTtXHqFM2SD9mtBzkVPv4hwt6RLWE005wyg
        WuUf7xoexkb0TuOu7Hs4qM4=
X-Google-Smtp-Source: AA0mqf5D99zy5/RvFZfaOGTNub+6Lugep+Fe3re3vYLt08FgSPu5U36c4ZT7799vqGP91WXn7NhIcQ==
X-Received: by 2002:a05:6a00:1f13:b0:567:546c:718b with SMTP id be19-20020a056a001f1300b00567546c718bmr10846747pfb.17.1668359121826;
        Sun, 13 Nov 2022 09:05:21 -0800 (PST)
Received: from localhost ([114.254.0.245])
        by smtp.gmail.com with ESMTPSA id x66-20020a626345000000b0053e4296e1d3sm4938132pfb.198.2022.11.13.09.05.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Nov 2022 09:05:21 -0800 (PST)
From:   Hawkins Jiawei <yin31149@gmail.com>
To:     yin31149@gmail.com, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     18801353760@163.com,
        syzbot+232ebdbd36706c965ebf@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com,
        Cong Wang <cong.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: sched: fix memory leak in tcindex_set_parms
Date:   Mon, 14 Nov 2022 01:05:08 +0800
Message-Id: <20221113170507.8205-1-yin31149@gmail.com>
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
traffic-control-indices filter properties. During the
process of changing, kernel clears the old
traffic-control-indices filter result, and updates it
by RCU assigning new traffic-control-indices data.

Yet the problem is that, kernel clears the old
traffic-control-indices filter result, without destroying
its tcf_exts structure, which triggers the above
memory leak.

This patch solves it by using tcf_exts_destroy() to
destroy the tcf_exts structure in old
traffic-control-indices filter result, after the
RCU grace period.

[Thanks to the suggestion from Jakub Kicinski and Cong Wang]

Fixes: b9a24bb76bf6 ("net_sched: properly handle failure case of tcf_exts_init()")
Link: https://lore.kernel.org/all/0000000000001de5c505ebc9ec59@google.com/
Reported-by: syzbot+232ebdbd36706c965ebf@syzkaller.appspotmail.com
Tested-by: syzbot+232ebdbd36706c965ebf@syzkaller.appspotmail.com
Cc: Cong Wang <cong.wang@bytedance.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Hawkins Jiawei <yin31149@gmail.com>
---
v2:
  - remove all 'will' in commit message according to Jakub Kicinski
  - add Fixes tag according to Jakub Kicinski
  - remove all ifdefs according to Jakub Kicinski and Cong Wang
  - add synchronize_rcu() before destorying old_e according to
Cong Wang

v1: https://lore.kernel.org/all/20221031060835.11722-1-yin31149@gmail.com/
 net/sched/cls_tcindex.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
index 1c9eeb98d826..d2fac9559d3e 100644
--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -338,6 +338,7 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
 	struct tcf_result cr = {};
 	int err, balloc = 0;
 	struct tcf_exts e;
+	struct tcf_exts old_e = {};
 
 	err = tcf_exts_init(&e, net, TCA_TCINDEX_ACT, TCA_TCINDEX_POLICE);
 	if (err < 0)
@@ -479,6 +480,7 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
 	}
 
 	if (old_r && old_r != r) {
+		old_e = old_r->exts;
 		err = tcindex_filter_result_init(old_r, cp, net);
 		if (err < 0) {
 			kfree(f);
@@ -510,6 +512,12 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
 		tcf_exts_destroy(&new_filter_result.exts);
 	}
 
+	/* Note: old_e should be destroyed after the RCU grace period,
+	 * to avoid possible use-after-free by concurrent readers.
+	 */
+	synchronize_rcu();
+	tcf_exts_destroy(&old_e);
+
 	if (oldp)
 		tcf_queue_work(&oldp->rwork, tcindex_partial_destroy_work);
 	return 0;
-- 
2.25.1


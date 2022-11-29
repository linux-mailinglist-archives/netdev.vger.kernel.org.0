Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3C463B845
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 03:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235263AbiK2CxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 21:53:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235206AbiK2CxA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 21:53:00 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDBDF2A428;
        Mon, 28 Nov 2022 18:52:57 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id 82so4278797pgc.0;
        Mon, 28 Nov 2022 18:52:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=35p5Pzvij06883L5xcotqkJm3JL5Gnq7PcCbaLDkUh8=;
        b=Y7b9duHr6K89L/ohp2M0hPG3B89OYr6vF9bFrfIiCWJBLHgcnXkP9P1WwonJ2c//51
         XKIIu36s6NdzF4oIuGKkjPxIMjGaK5aZfnAqlwWqnVmuhFiNGCzMedTU7ZRjP2NSqt8w
         JEOpANuinneiS1fYdV3K0TjMkeuCPBMc9DCoPYox/4Lp812J+9vbKQJndbflPdeM0vHX
         kpMJNSvcOOepdfEZ4cyCLp9zyScncvgNtpSE788m1zhCckPRO3An4UZdM0hnZcwaW2M0
         hoSbv2BCs2mAciVXknzwAynj8LLHl3mfMBLZ1XZgwsprWd2h/R1kC9OVLRgHVuMtonsd
         wNFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=35p5Pzvij06883L5xcotqkJm3JL5Gnq7PcCbaLDkUh8=;
        b=ZbqBevg3VloFVrujeQ31ijYaoW75FeB/E2QtVexgvpdobN74uk4//MEW4HixXH9Mt1
         JN5vIgYqm7PKOAYG3QlstHJgdL7HmUeGRk5YChJllf5/UNdh+IHFHDE+4M2NAD3VMNZN
         9iJp2TGI/LmLxnUH+5VqE+wALIW7IOTRcjie7r/xFSBZWU4jSRHxt2TBf60mJR23HknD
         mkxVq/bKmPZQCHIbdEPfxOUOn4zzDch/C+xQf01vNnOWRC+3NefcSaxGHQRXSXJD4HhT
         xCbx3ESTnjJu9JBcV+MmP33MBzeDDKINClpw3eUafQuHA1cqnUbApwvM0eXId+9ly0bd
         FLiA==
X-Gm-Message-State: ANoB5plmi034WwBbeayD4bxQOV1Pt4sGuEj4nFHhyh58f9LNvOPoiXep
        jkgoUcNSlCkSpEnAMIYJRLo=
X-Google-Smtp-Source: AA0mqf7Tjpn4WAePefz0sLICTbs/gASw+w8ggwNV0ibHiC1F0Nu9VpXXTFnOY+jU/lsv4xinlY4IkQ==
X-Received: by 2002:a65:4c85:0:b0:46f:59bd:6125 with SMTP id m5-20020a654c85000000b0046f59bd6125mr48407772pgt.147.1669690376990;
        Mon, 28 Nov 2022 18:52:56 -0800 (PST)
Received: from localhost ([183.242.254.166])
        by smtp.gmail.com with ESMTPSA id p21-20020a631e55000000b004597e92f99dsm7233338pgm.66.2022.11.28.18.52.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 18:52:55 -0800 (PST)
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
        Cong Wang <cong.wang@bytedance.com>,
        Dmitry Vyukov <dvyukov@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] net: sched: fix memory leak in tcindex_set_parms
Date:   Tue, 29 Nov 2022 10:52:49 +0800
Message-Id: <20221129025249.463833-1-yin31149@gmail.com>
X-Mailer: git-send-email 2.34.1
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
filter properties. During the process of changing,
kernel uses tcindex_alloc_perfect_hash() to newly
allocate filter results, uses tcindex_filter_result_init()
to clear the old filter result.

Yet the problem is that, kernel clears the old
filter result, without destroying its tcf_exts structure,
which triggers the above memory leak.

Considering that there already extis a tc_filter_wq workqueue
to destroy the old tcindex_data by tcindex_partial_destroy_work()
at the end of tcindex_set_parms(), this patch solves this memory
leak bug by removing this old filter result clearing part,
and delegating it to the tc_filter_wq workqueue.

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
Signed-off-by: Hawkins Jiawei <yin31149@gmail.com>
---
v3:
  - refactor the commit message
  - delegate the tcf_exts_destroy() to tc_filter_wq workqueue,
suggested by Paolo Abeni and Dmitry Vyukov

v2: https://lore.kernel.org/all/20221113170507.8205-1-yin31149@gmail.com/

v1: https://lore.kernel.org/all/20221031060835.11722-1-yin31149@gmail.com/

 net/sched/cls_tcindex.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
index 1c9eeb98d826..3f4e7a6cdd96 100644
--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -478,14 +478,6 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
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
2.34.1


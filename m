Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B813D612B42
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 16:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiJ3Pi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 11:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiJ3Pi1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 11:38:27 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73256B2;
        Sun, 30 Oct 2022 08:38:26 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id b185so8710987pfb.9;
        Sun, 30 Oct 2022 08:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+PvCkPISlYqOaqNi7qtyaLQ7Xo92J5QGXXYeL+Jnj/c=;
        b=k5npBXaNxgT0HvAYn1w3doWTt6Dj+4WV5vPdBaTrAm711iCGDHosMpqYL/Z+JLGH0w
         bYbA771qH58clU8G64cr/AJsDtlnB4oLvyglpFX2IrhfYJB9ee1NFBpGDUmPFk04C9vG
         1mGRVgKwcfgGnu9buxkGIzd0mIY+ZaAONl2hXZ2d/UEnM3Y8LXQmTPXJVfcD7qUnUmZZ
         1Dc1b0LcJ0/fwTSUOVq+Wt3KjKCZ2nNW1QNZIUABL3ycn0Lvzohpoi8i8GRGRmX4phA3
         IBQSJ2JSy2dPvK5y+Q2sROKcq3hGHFUuQWAG5nuxKXIJlMoRgNqwphrrvopZpap37OfP
         iMOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+PvCkPISlYqOaqNi7qtyaLQ7Xo92J5QGXXYeL+Jnj/c=;
        b=tIi5MZHJb1g18plXYYXl8Ew+EVWSi5NioKfYjB/n8pPLc+pB2+M/MTZXRgCbBKuWDX
         3g2lfU+e+BcHihgoRSi/RJMrbaxnU+K6flz3NeMfGAUZCRYfAkQXAMPGUaVcmDAjIYS6
         7f7ul+UjSEDn1vPNUu8xHg/4sPnJQp/fnucZ/bwUIzNszRFG1c3wpJsTvs4siYWON6YM
         Y+k13hPt1eRinhksAe0Emu5vU58DRcr4S5JRC6R+MgHQhZBo5x5iI/cUTtQfKbNcj9Yj
         xSSkVR57JYGiDq9CYJGN7CLBsaSWQHp1mIlwPrTjhPYACNUSICJlxharn8yGMe8DQXmM
         jfQQ==
X-Gm-Message-State: ACrzQf2V31sstdeWskAdjaK8Y4PHUD1pQ5byX388GGbhsim+0rTNIzE8
        EzXFtC768LYtu7vdOGyDPOk=
X-Google-Smtp-Source: AMsMyM5Xyakulw1g5qUR/wXCBOS0VUn5ULKF0DI0LEBLZMeUEzTiGQpcT7kKvoWiYhIUFBGUa5awTw==
X-Received: by 2002:a05:6a00:e1b:b0:537:7c74:c405 with SMTP id bq27-20020a056a000e1b00b005377c74c405mr9599151pfb.43.1667144305806;
        Sun, 30 Oct 2022 08:38:25 -0700 (PDT)
Received: from localhost ([183.242.254.175])
        by smtp.gmail.com with ESMTPSA id ix22-20020a170902f81600b001769206a766sm2800121plb.307.2022.10.30.08.38.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Oct 2022 08:38:25 -0700 (PDT)
From:   Hawkins Jiawei <yin31149@gmail.com>
To:     syzbot+232ebdbd36706c965ebf@syzkaller.appspotmail.com,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     18801353760@163.com, johannes@sipsolutions.net,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        yin31149@gmail.com
Subject: Re: [syzbot] memory leak in regulatory_hint_core
Date:   Sun, 30 Oct 2022 23:36:23 +0800
Message-Id: <20221030153622.22720-1-yin31149@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <0000000000007fa5c805ec39f00a@google.com>
References: <0000000000007fa5c805ec39f00a@google.com>
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

On Sun, 30 Oct 2022 at 00:14, Hawkins Jiawei <yin31149@gmail.com> wrote:
>
> Hi,
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    aae703b02f92 Merge tag 'for-6.1-rc1-tag' of git://git.kern..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=113ed1b4880000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=d2f454d7d3b63980
> > dashboard link: https://syzkaller.appspot.com/bug?extid=232ebdbd36706c965ebf
> > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=124b8de2880000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12ae6a4a880000
> >
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/a6542869e73f/disk-aae703b0.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/1a8ac40b2df8/vmlinux-aae703b0.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+232ebdbd36706c965ebf@syzkaller.appspotmail.com
> >
> > executing program
> > BUG: memory leak
> > unreferenced object 0xffff8881450a3900 (size 64):
> >   comm "swapper/0", pid 1, jiffies 4294937964 (age 66.260s)
> >   hex dump (first 32 bytes):
> >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >     ff ff ff ff 00 00 00 00 00 00 00 00 30 30 00 00  ............00..
> >   backtrace:
> >     [<ffffffff814cf9f0>] kmalloc_trace+0x20/0x90 mm/slab_common.c:1046
> >     [<ffffffff84070f62>] kmalloc include/linux/slab.h:576 [inline]
> >     [<ffffffff84070f62>] kzalloc include/linux/slab.h:712 [inline]
> >     [<ffffffff84070f62>] regulatory_hint_core+0x22/0x60 net/wireless/reg.c:3242
> >     [<ffffffff8722bfc1>] regulatory_init_db+0x222/0x2de net/wireless/reg.c:4312
> >     [<ffffffff81000fde>] do_one_initcall+0x5e/0x2e0 init/main.c:1303
> >     [<ffffffff8718db35>] do_initcall_level init/main.c:1376 [inline]
> >     [<ffffffff8718db35>] do_initcalls init/main.c:1392 [inline]
> >     [<ffffffff8718db35>] do_basic_setup init/main.c:1411 [inline]
> >     [<ffffffff8718db35>] kernel_init_freeable+0x255/0x2cf init/main.c:1631
> >     [<ffffffff8460cb9a>] kernel_init+0x1a/0x1c0 init/main.c:1519
> >     [<ffffffff8100224f>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
> >
> > BUG: memory leak
> > unreferenced object 0xffff88810c287f00 (size 256):
> >   comm "syz-executor105", pid 3600, jiffies 4294943292 (age 12.990s)
> >   hex dump (first 32 bytes):
> >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >   backtrace:
> >     [<ffffffff814cf9f0>] kmalloc_trace+0x20/0x90 mm/slab_common.c:1046
> >     [<ffffffff839c9e07>] kmalloc include/linux/slab.h:576 [inline]
> >     [<ffffffff839c9e07>] kmalloc_array include/linux/slab.h:627 [inline]
> >     [<ffffffff839c9e07>] kcalloc include/linux/slab.h:659 [inline]
> >     [<ffffffff839c9e07>] tcf_exts_init include/net/pkt_cls.h:250 [inline]
> >     [<ffffffff839c9e07>] tcindex_set_parms+0xa7/0xbe0 net/sched/cls_tcindex.c:342
> >     [<ffffffff839caa1f>] tcindex_change+0xdf/0x120 net/sched/cls_tcindex.c:553
> >     [<ffffffff8394db62>] tc_new_tfilter+0x4f2/0x1100 net/sched/cls_api.c:2147
> >     [<ffffffff8389e91c>] rtnetlink_rcv_msg+0x4dc/0x5d0 net/core/rtnetlink.c:6082
> >     [<ffffffff839eba67>] netlink_rcv_skb+0x87/0x1d0 net/netlink/af_netlink.c:2540
> >     [<ffffffff839eab87>] netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
> >     [<ffffffff839eab87>] netlink_unicast+0x397/0x4c0 net/netlink/af_netlink.c:1345
> >     [<ffffffff839eb046>] netlink_sendmsg+0x396/0x710 net/netlink/af_netlink.c:1921
> >     [<ffffffff8383e796>] sock_sendmsg_nosec net/socket.c:714 [inline]
> >     [<ffffffff8383e796>] sock_sendmsg+0x56/0x80 net/socket.c:734
> >     [<ffffffff8383eb08>] ____sys_sendmsg+0x178/0x410 net/socket.c:2482
> >     [<ffffffff83843678>] ___sys_sendmsg+0xa8/0x110 net/socket.c:2536
> >     [<ffffffff838439c5>] __sys_sendmmsg+0x105/0x330 net/socket.c:2622
> >     [<ffffffff83843c14>] __do_sys_sendmmsg net/socket.c:2651 [inline]
> >     [<ffffffff83843c14>] __se_sys_sendmmsg net/socket.c:2648 [inline]
> >     [<ffffffff83843c14>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2648
> >     [<ffffffff84605fd5>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >     [<ffffffff84605fd5>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> >     [<ffffffff84800087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> >
> > BUG: memory leak
> > unreferenced object 0xffff88810c287e00 (size 256):
> >   comm "syz-executor105", pid 3600, jiffies 4294943292 (age 12.990s)
> >   hex dump (first 32 bytes):
> >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >   backtrace:
> >     [<ffffffff814cf9f0>] kmalloc_trace+0x20/0x90 mm/slab_common.c:1046
> >     [<ffffffff839c9e07>] kmalloc include/linux/slab.h:576 [inline]
> >     [<ffffffff839c9e07>] kmalloc_array include/linux/slab.h:627 [inline]
> >     [<ffffffff839c9e07>] kcalloc include/linux/slab.h:659 [inline]
> >     [<ffffffff839c9e07>] tcf_exts_init include/net/pkt_cls.h:250 [inline]
> >     [<ffffffff839c9e07>] tcindex_set_parms+0xa7/0xbe0 net/sched/cls_tcindex.c:342
> >     [<ffffffff839caa1f>] tcindex_change+0xdf/0x120 net/sched/cls_tcindex.c:553
> >     [<ffffffff8394db62>] tc_new_tfilter+0x4f2/0x1100 net/sched/cls_api.c:2147
> >     [<ffffffff8389e91c>] rtnetlink_rcv_msg+0x4dc/0x5d0 net/core/rtnetlink.c:6082
> >     [<ffffffff839eba67>] netlink_rcv_skb+0x87/0x1d0 net/netlink/af_netlink.c:2540
> >     [<ffffffff839eab87>] netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
> >     [<ffffffff839eab87>] netlink_unicast+0x397/0x4c0 net/netlink/af_netlink.c:1345
> >     [<ffffffff839eb046>] netlink_sendmsg+0x396/0x710 net/netlink/af_netlink.c:1921
> >     [<ffffffff8383e796>] sock_sendmsg_nosec net/socket.c:714 [inline]
> >     [<ffffffff8383e796>] sock_sendmsg+0x56/0x80 net/socket.c:734
> >     [<ffffffff8383eb08>] ____sys_sendmsg+0x178/0x410 net/socket.c:2482
> >     [<ffffffff83843678>] ___sys_sendmsg+0xa8/0x110 net/socket.c:2536
> >     [<ffffffff838439c5>] __sys_sendmmsg+0x105/0x330 net/socket.c:2622
> >     [<ffffffff83843c14>] __do_sys_sendmmsg net/socket.c:2651 [inline]
> >     [<ffffffff83843c14>] __se_sys_sendmmsg net/socket.c:2648 [inline]
> >     [<ffffffff83843c14>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2648
> >     [<ffffffff84605fd5>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >     [<ffffffff84605fd5>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> >     [<ffffffff84800087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> >
> > BUG: memory leak
> > unreferenced object 0xffff88810c1c6d00 (size 256):
> >   comm "syz-executor105", pid 3601, jiffies 4294943831 (age 7.600s)
> >   hex dump (first 32 bytes):
> >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >   backtrace:
> >     [<ffffffff814cf9f0>] kmalloc_trace+0x20/0x90 mm/slab_common.c:1046
> >     [<ffffffff839c9e07>] kmalloc include/linux/slab.h:576 [inline]
> >     [<ffffffff839c9e07>] kmalloc_array include/linux/slab.h:627 [inline]
> >     [<ffffffff839c9e07>] kcalloc include/linux/slab.h:659 [inline]
> >     [<ffffffff839c9e07>] tcf_exts_init include/net/pkt_cls.h:250 [inline]
> >     [<ffffffff839c9e07>] tcindex_set_parms+0xa7/0xbe0 net/sched/cls_tcindex.c:342
> >     [<ffffffff839caa1f>] tcindex_change+0xdf/0x120 net/sched/cls_tcindex.c:553
> >     [<ffffffff8394db62>] tc_new_tfilter+0x4f2/0x1100 net/sched/cls_api.c:2147
> >     [<ffffffff8389e91c>] rtnetlink_rcv_msg+0x4dc/0x5d0 net/core/rtnetlink.c:6082
> >     [<ffffffff839eba67>] netlink_rcv_skb+0x87/0x1d0 net/netlink/af_netlink.c:2540
> >     [<ffffffff839eab87>] netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
> >     [<ffffffff839eab87>] netlink_unicast+0x397/0x4c0 net/netlink/af_netlink.c:1345
> >     [<ffffffff839eb046>] netlink_sendmsg+0x396/0x710 net/netlink/af_netlink.c:1921
> >     [<ffffffff8383e796>] sock_sendmsg_nosec net/socket.c:714 [inline]
> >     [<ffffffff8383e796>] sock_sendmsg+0x56/0x80 net/socket.c:734
> >     [<ffffffff8383eb08>] ____sys_sendmsg+0x178/0x410 net/socket.c:2482
> >     [<ffffffff83843678>] ___sys_sendmsg+0xa8/0x110 net/socket.c:2536
> >     [<ffffffff838439c5>] __sys_sendmmsg+0x105/0x330 net/socket.c:2622
> >     [<ffffffff83843c14>] __do_sys_sendmmsg net/socket.c:2651 [inline]
> >     [<ffffffff83843c14>] __se_sys_sendmmsg net/socket.c:2648 [inline]
> >     [<ffffffff83843c14>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2648
> >     [<ffffffff84605fd5>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >     [<ffffffff84605fd5>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> >     [<ffffffff84800087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
>
> This bug seems to be related to tcindex_set_parms().
>
> To be more specific, kernel should release the old_r->exts before
> initializing it. Let us test it.
Test if we need to release the old_r->exts after RCU assign.

#syz test https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
aae703b02f92bde9264366c545e87cec451de471

diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
index 1c9eeb98d826..1c0bee2544d9 100644
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
+		 * we need to destroy it after update the tp->root,
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

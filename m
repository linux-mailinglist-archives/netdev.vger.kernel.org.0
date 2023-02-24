Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B05A36A1464
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 01:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbjBXAnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 19:43:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjBXAnl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 19:43:41 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2588EF761
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 16:43:40 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id d6so3325084pgu.2
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 16:43:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ewbhxrHysa0CBo8g6Tru01F1kcPvwaMU9rbWlTpYZbQ=;
        b=KiBigz9iSfoXMAiGk2Fcm+tWqKwaeFDXjbWLTcnRU0GcRSl1lInWI2sIJISNpzrrZK
         /lPpN+VkTrjeAzP6UVAswsafR1WOIQWktwipmpsa+XawGdlwyfeG2oUP8JX7c6AO8ZfM
         Uc6EKW+QA0NyMZzWDYnZkQiQ5WpyTcXk2eet8HB/PyFPToOMLG3NJGx4K3oTVqlIhqJy
         7XAQP8ttZH8a5pl1hcnbFX9Mv2xlwo1JDa6Oggy8JQ2K3w1byJl4sGCD2fa6GwYIaF4+
         GkdrqqpR9mIc8u2YAcBugvsj64BDQnjQoBxRmd5OTlTsTuW8KV+bSifO/AtMu04ncwbr
         ZKvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ewbhxrHysa0CBo8g6Tru01F1kcPvwaMU9rbWlTpYZbQ=;
        b=dmTPfXoGOifi+EnSeO/5brd/wtd9mEwhpLr9eh4+wrgws7Xn3g8alRbbM1jXN63+vz
         SY5a7hO5+5ADblV/XVZDf7fzMGEy+t5etbtRk5jRBCvYNeFaVGaM3LQwpdqitR0iwTOh
         dYLuTJ8pJ/vOIdsfNG3b80Tisds9FKnRTBBGfh39ZbfD8FCKfVUoFfKFNna1jI0S1jJ/
         43He2/I8LIwUJ2OjSb+4JtUX0IaLUiIcPJU18efKqUSTAVl08kaHBnCUmFeewLEO8KmL
         j42LYBqi9pF2PzMixF9CW1lbV/DvCq9etDgZqYQ5SwmPq+Nhhy7RkYeROTllKygn/xFW
         mpRg==
X-Gm-Message-State: AO0yUKVNFoRXW3q+JMrQxmf/kkPsnuTwwgIFvGPk8JQdGs5nPjON1j4n
        iurDUIQXwSip8V1aE+9Z72gvZWuR8g9GuulhZm4mkIwiyuNnwg==
X-Google-Smtp-Source: AK7set+udFbe1PcqnJCQbW05QbJca2HY4MN17T1agyjZn4z9dhzuvsDfzjnUV0o/C9m3GZ48LNoOiWkqmqgOY0DmGfY=
X-Received: by 2002:a63:3f88:0:b0:4fb:d2a9:6ff2 with SMTP id
 m130-20020a633f88000000b004fbd2a96ff2mr2132388pga.7.1677199418839; Thu, 23
 Feb 2023 16:43:38 -0800 (PST)
MIME-Version: 1.0
From:   Homin Rhee <hominlab@gmail.com>
Date:   Fri, 24 Feb 2023 09:43:02 +0900
Message-ID: <CAA2QpBccQ+cjCg3DFD-Y_XrFWp2OrpKC3hTqVUq0ZtJfRsyhRg@mail.gmail.com>
Subject: [Net][Taprio?][report] KASAN: Null-Ptr-Deref read in __fl_put:cls_flower.c
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,
I'm iCAROS7 & my syzkaller hit Null-Ptr-Deref at last night.

Attached C reproducer and syzkaller report.
In my opinion, On __must_check bool refcount_inc_not_zreo() in
refcount.h:243, caller hasn't guaranteed the object memory.

Thank you for your deication.

From iCAORS7.

< Information of my syzkaller system >
Host
CPU: Intel i7-12700K
OS: Kubuntu 22.04.1 LTS
Kernel: 5.18.19-051819-generic

Syzkaller
Build: bcdf85f8
Target: linux-next a5c95ca1 & 6.2

Syzkaller hit 'KASAN: null-ptr-deref Read in __fl_put' bug.

=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=
=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D
=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=
=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D
=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=
=3D3D
BUG: KASAN: null-ptr-deref in instrument_atomic_read
include/linux/instrumented.h:72 [inline]
BUG: KASAN: null-ptr-deref in atomic_read
include/linux/atomic/atomic-instrumented.h:27 [inline]
BUG: KASAN: null-ptr-deref in refcount_read
include/linux/refcount.h:147 [inline]
BUG: KASAN: null-ptr-deref in __refcount_add_not_zero
include/linux/refcount.h:152 [inline]
BUG: KASAN: null-ptr-deref in __refcount_inc_not_zero
include/linux/refcount.h:227 [inline]
BUG: KASAN: null-ptr-deref in refcount_inc_not_zero
include/linux/refcount.h:245 [inline]
BUG: KASAN: null-ptr-deref in maybe_get_net
include/net/net_namespace.h:269 [inline]
BUG: KASAN: null-ptr-deref in tcf_exts_get_net
include/net/pkt_cls.h:260 [inline]
BUG: KASAN: null-ptr-deref in __fl_put+0x13e/0x3a0 net/sched/cls_flower.c:5=
=3D
13
Read of size 4 at addr 000000000000014c by task syz-executor109/8049

CPU: 0 PID: 8049 Comm: syz-executor109 Not tainted 6.2.0-09654-ga5c95ca18a9=
=3D
8 #14
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/=
=3D
2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd9/0x150 lib/dump_stack.c:106
 kasan_report+0xc0/0xf0 mm/kasan/report.c:517
 check_region_inline mm/kasan/generic.c:183 [inline]
 kasan_check_range+0x144/0x190 mm/kasan/generic.c:189
 instrument_atomic_read include/linux/instrumented.h:72 [inline]
 atomic_read include/linux/atomic/atomic-instrumented.h:27 [inline]
 refcount_read include/linux/refcount.h:147 [inline]
 __refcount_add_not_zero include/linux/refcount.h:152 [inline]
 __refcount_inc_not_zero include/linux/refcount.h:227 [inline]
 refcount_inc_not_zero include/linux/refcount.h:245 [inline]
 maybe_get_net include/net/net_namespace.h:269 [inline]
 tcf_exts_get_net include/net/pkt_cls.h:260 [inline]
 __fl_put+0x13e/0x3a0 net/sched/cls_flower.c:513
 fl_change+0x12b3/0x4b30 net/sched/cls_flower.c:2341
 tc_new_tfilter+0x947/0x2220 net/sched/cls_api.c:2310
 rtnetlink_rcv_msg+0x98d/0xd40 net/core/rtnetlink.c:6165
 netlink_rcv_skb+0x165/0x440 net/netlink/af_netlink.c:2574
 netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
 netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1365
 netlink_sendmsg+0x92f/0xe50 net/netlink/af_netlink.c:1942
 sock_sendmsg_nosec net/socket.c:722 [inline]
 sock_sendmsg+0xde/0x190 net/socket.c:745
 ____sys_sendmsg+0x331/0x900 net/socket.c:2504
 ___sys_sendmsg+0x11d/0x1b0 net/socket.c:2558
 __sys_sendmmsg+0x18c/0x450 net/socket.c:2644
 __do_sys_sendmmsg net/socket.c:2673 [inline]
 __se_sys_sendmmsg net/socket.c:2670 [inline]
 __x64_sys_sendmmsg+0x9c/0x100 net/socket.c:2670
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f7ad02aa31d
Code: 28 c3 e8 76 1f 00 00 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffeef4d0cb8 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00007f7ad03274f0 RCX: 00007f7ad02aa31d
RDX: 040000000000009f RSI: 00000000200002c0 RDI: 0000000000000004
RBP: 00007f7ad02fb02d R08: 0000000120080522 R09: 0000000120080522
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffeef4d0cd0
R13: 00007ffeef4d0ee8 R14: 00007f7ad0327470 R15: 0000000000000001
 </TASK>


--=20
Homin Rhee (=EC=9D=B4=ED=98=B8=EB=AF=BC,=EF=A7=A1=E6=98=8A=E7=8F=89)

OpenPGP fingerprint: 1D94 A708 6346 FBF1 1DD1  6E1F 4957 8AFE D221 9C6A
You can see the more information about my OpenPGP at https://minnote.net/gp=
g

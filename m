Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07B1464F86F
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 10:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbiLQJZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Dec 2022 04:25:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiLQJZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Dec 2022 04:25:22 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B25BB1E9;
        Sat, 17 Dec 2022 01:25:21 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id r26so6647964edc.10;
        Sat, 17 Dec 2022 01:25:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9SEYu3CD2lscfQ36Ylbp9Rqo5knyPNps9HHg3nLsTAU=;
        b=CZDcwRmSfxElaHhnrnXV1dK0HsrFk3xCvzEl6BkQxbzqw143BmQplGWtgEuPJHC8mg
         2dljFg/+cH2ktnIjAuWwIF44uKYEMnvIvdpNJ4i1p2q1TrOq72jQsaizUs7XFPJHB4tJ
         NinrO3Ws4lP5IRylp9LKeC4jQohtke27qBwQXcJ4EbRI8TNinh50rQpE/skQTg07pJN3
         BJfr2DRt5gypWLSqh4YgOiggtTnORTV/6WLC8K0OB+IL8PeVQedoKeDockMu1uGmhyyu
         4rHUIl6ICgBjPTytT6CFeBgBQXyVlYQyW0EJnOqi7DFKSsAq72aqJd1ByGZI/hKlAKYU
         Ys2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9SEYu3CD2lscfQ36Ylbp9Rqo5knyPNps9HHg3nLsTAU=;
        b=fmwrRBP4AeDIXdeRgN1WJoG/qW8DX6qxKBTyZN6qp8YCgTUfB2mLjiorzwUYN/ZfQO
         zQiOdYcVo+Js/1ypjqJ3mLVpPyvPXLJ9a/ajSzObo/ZrSZQxGW+V4wogFIZdNOO5+/7R
         zlqSH7mi0NZbS0UhvaYCJN93veHPLEClhwaLYlzB4CkL1/Wc6RQ8ovXVg3oCBErItvS4
         HdKCw/je1jxLVSldZJUD9or3KRTtzS4vdcPXF10J3zm3TxjBBV9PEgxYHpxw/ZfqS7Uw
         3c3aXEDKeQ+Fk6XrJUUp+O/7cfOg/yC4TRbZysNDp97MkiwUI+q6TjufUy0DtKhhSA0f
         HpdA==
X-Gm-Message-State: ANoB5plX9jMr9bleYwm2R1BJ+l6efG7zQl/ouDAbsOOT4M68B/KKezYS
        LyjQqhiVATkHcMq1jUfGhAqLMsWaUtd6UO8P0lojAQlRclI=
X-Google-Smtp-Source: AA0mqf5NIw5Y+h7F6m+nXVsCJPl61RfC9zGdCMU+KR8GxKCkveAAUWN4fZbxs4vgB2vP0G7rIky8AJDAOCkMrwmH+/w=
X-Received: by 2002:a05:6402:4023:b0:46c:f631:c0e6 with SMTP id
 d35-20020a056402402300b0046cf631c0e6mr16410969eda.251.1671269119483; Sat, 17
 Dec 2022 01:25:19 -0800 (PST)
MIME-Version: 1.0
References: <CAO4mrffa_3PhjfA9hxTq_U9GjC++0suGnme9oNcKE=Gn+g1iRg@mail.gmail.com>
In-Reply-To: <CAO4mrffa_3PhjfA9hxTq_U9GjC++0suGnme9oNcKE=Gn+g1iRg@mail.gmail.com>
From:   Wei Chen <harperchen1110@gmail.com>
Date:   Sat, 17 Dec 2022 17:24:43 +0800
Message-ID: <CAO4mrfdmjvRUNbDyP0R03_DrD_eFCLCguz6OxZ2TYRSv0K9gxA@mail.gmail.com>
Subject: WARNING in nla_get_range_unsigned
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Linux Developers,

Recently, when using our tool to fuzz kernel, the following crash was
triggered. Although this crash has been reported by syzbot
https://syzkaller.appspot.com/bug?id=32e20c07949c6d6006f26466022469e33ae69108
and fixed in commit netlink: policy: correct validation type check
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=c30a3c957c885e618ddffc065f888be4f8d5a9bd,
it still happens in the latest kernel version.

HEAD commit:  76dcd734eca
git tree: linux-next
compiler: clang 12.0.0
console output:
https://drive.google.com/file/d/1reeOfFkfJp4-GUz_uMTh-uWXPLBJDcA6/view?usp=share_link
kernel config: https://drive.google.com/file/d/1jH4qV5XblPADvMDUlvS7DwtW0FroMoVB/view?usp=share_link
syz repro: https://drive.google.com/file/d/1Ong8vQn675RFU7R1O5HfiwWxp4UhnaIF/view?usp=share_link

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: Wei Chen <harperchen1110@gmail.com>

------------[ cut here ]------------
WARNING: CPU: 0 PID: 17743 at lib/nlattr.c:118
nla_get_range_unsigned+0x1d8/0x1e0 lib/nlattr.c:117
Modules linked in:
CPU: 0 PID: 17743 Comm: syz-executor.0 Not tainted 6.1.0-rc8 #3
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.13.0-48-gd9c812dda519-prebuilt.qemu.org 04/01/2014
RIP: 0010:nla_get_range_unsigned+0x1d8/0x1e0 lib/nlattr.c:117
Code: 8d ff 49 8b 75 08 ba 10 00 00 00 4c 89 f7 e8 0f d8 f8 02 5b 41
5c 41 5d 41 5e 41 5f 5d c3 e8 0f 57 7a ff eb 05 e8 08 57 7a ff <0f> 0b
e9 a9 fe ff ff 90 55 41 57 41 56 41 54 53 49 89 f6 49 89 fc
RSP: 0018:ffffc90002df39b8 EFLAGS: 00010287
RAX: ffffffff81ad2f51 RBX: ffffffff85364d28 RCX: 0000000000040000
RDX: ffffc90000add000 RSI: 0000000000000268 RDI: 0000000000000269
RBP: 000000000000f940 R08: ffffffff81ad2dd8 R09: 0000000000000000
R10: 0001ffffffffffff R11: ffff888045136780 R12: ffff88803e174000
R13: ffffffff85364d20 R14: ffffc90002df3a30 R15: ffffffff85364d21
FS:  00007fab1e5c8700(0000) GS:ffff88807dc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000073f8d0 CR3: 000000004a789000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
Call Trace:
 <TASK>
 __netlink_policy_dump_write_attr+0x23d/0x990 net/netlink/policy.c:310
 netlink_policy_dump_write_attr+0x22/0x30 net/netlink/policy.c:411
 netlink_ack_tlv_fill net/netlink/af_netlink.c:2454 [inline]
 netlink_ack+0x546/0x760 net/netlink/af_netlink.c:2506
 netlink_rcv_skb+0x1b7/0x240 net/netlink/af_netlink.c:2546
 rtnetlink_rcv+0x18/0x20 net/core/rtnetlink.c:6109
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x5e9/0x6b0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x739/0x860 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg net/socket.c:734 [inline]
 ____sys_sendmsg+0x38f/0x500 net/socket.c:2482
 ___sys_sendmsg net/socket.c:2536 [inline]
 __sys_sendmsg+0x197/0x230 net/socket.c:2565
 __do_sys_sendmsg net/socket.c:2574 [inline]
 __se_sys_sendmsg net/socket.c:2572 [inline]
 __x64_sys_sendmsg+0x42/0x50 net/socket.c:2572
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x4697f9
Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fab1e5c7c48 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000077bf80 RCX: 00000000004697f9
RDX: 0000000000000000 RSI: 0000000020000000 RDI: 0000000000000003
RBP: 00000000004d29e9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000077bf80
R13: 0000000000000000 R14: 000000000077bf80 R15: 00007ffd7c0e6920
 </TASK>
---[ end trace 0000000000000000 ]---

Best,
Wei

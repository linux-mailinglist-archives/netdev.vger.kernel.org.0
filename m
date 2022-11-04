Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1FB619BDB
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 16:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232670AbiKDPjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 11:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232657AbiKDPjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 11:39:20 -0400
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC732627D;
        Fri,  4 Nov 2022 08:39:18 -0700 (PDT)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-13b103a3e5dso5938950fac.2;
        Fri, 04 Nov 2022 08:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iGFzmiGQlUlHm0R4DDnnBk35cJc4UPbmyhgnCQR1pYw=;
        b=VYKLuhUdBoVVirbMpoctEQ55/+wcR0nvbLTAcsMh3SSl6lZsTPiFtT1qp8mHyZsSBH
         2Sfw8kCzxZylZb6HwzCmumiuf9JPdEKr4gx+5YKG0DxsFAI5Q9dRZrxkX2FRygAvi0R6
         tXhTSAEu6aFvZST6NaXnEZSKMkGsYyirkaeSgUKbKKaF6ORI36eCKZ2LZourXaiGf9AQ
         Hs/DDyisj7330ly2FN6r2qi1FphUkEg5l8ibdiMT+9La5oD4T12KZT4Ns3y0OvE6suU3
         Z6hrYG2/D8c6lxBMM5yLgcIwEo6zqecvg8liwjIFaGFEADcRG/vq7D1HVTrnwQtAMiuI
         iVkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iGFzmiGQlUlHm0R4DDnnBk35cJc4UPbmyhgnCQR1pYw=;
        b=1alcAv1eS82BU4s8Smt+nv5hIJ+5otEF1uZ7vr3X0oY5FRKCWlHM6OMQSCK2Y5BGS0
         CLSyPU+VlL9fZngISZ0e1JzDLVgaAH6Y0j0ptsxws9AdZCgf+lhyyYOl8UfG6fVfaaSB
         QgyfHqNfNFriY6zIZ/fw1MCSb7TGv8UcqhbBjvXv0kSsl8wjbY0k2eQIStZhuCIa5TcT
         UrkPNZEADWvTm/je/9vdZCRUR7jMyTqZ026eU4C8C76l80NjPXeM+8M8u51/mkKuXDyz
         eiNOZufvQ5wF0PsxaiCCsqvHhj3AVgY/IPmdEpu65CsLkRsREk7wsCu11P1lBwq+pdTv
         85NQ==
X-Gm-Message-State: ACrzQf0a5mvPrlWwIuDzGXxqho9tJ6YYFE9eGl95n6ljaIo3n351ar9N
        kq2Bb/KdZGtgeyF5u4vPdOcGiT83/j7DKL2MQyI=
X-Google-Smtp-Source: AMsMyM4hLfv3x6/HdWAQDrg0ibvLQse4DRYygfEMbgxa4GrAL0x4cjDYEkhBTBa/W8ctg4McM9OELC+itM6QzjEOKPs=
X-Received: by 2002:a05:6870:9614:b0:11d:3906:18fc with SMTP id
 d20-20020a056870961400b0011d390618fcmr31716276oaq.190.1667576358139; Fri, 04
 Nov 2022 08:39:18 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000d285ef05ec935d9e@google.com>
In-Reply-To: <000000000000d285ef05ec935d9e@google.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Fri, 4 Nov 2022 11:38:51 -0400
Message-ID: <CADvbK_foAqKqpSp1YNNRE4HdXkUV+BXrtFAO_6u455DYrBUnGw@mail.gmail.com>
Subject: Re: [syzbot] KMSAN: uninit-value in tipc_nl_compat_name_table_dump (3)
To:     syzbot <syzbot+e5dbaaa238680ce206ea@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, glider@google.com,
        jmaloy@redhat.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, ying.xue@windriver.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 3, 2022 at 12:28 PM syzbot
<syzbot+e5dbaaa238680ce206ea@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    8f4ae27df775 Revert "Revert "crypto: kmsan: disable accele..
> git tree:       https://github.com/google/kmsan.git master
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=142d16cf080000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=121c7ef28ec597bd
> dashboard link: https://syzkaller.appspot.com/bug?extid=e5dbaaa238680ce206ea
> compiler:       clang version 15.0.0 (https://github.com/llvm/llvm-project.git 610139d2d9ce6746b3c617fb3e2f7886272d26ff), GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=176a716f080000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=140256a0880000
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+e5dbaaa238680ce206ea@syzkaller.appspotmail.com
>
> =====================================================
> BUG: KMSAN: uninit-value in tipc_nl_compat_name_table_dump+0x841/0xea0 net/tipc/netlink_compat.c:934
looks we need this:

@@ -880,7 +880,7 @@ static int
tipc_nl_compat_name_table_dump_header(struct tipc_nl_compat_msg *msg)
        };

        ntq = (struct tipc_name_table_query *)TLV_DATA(msg->req);
-       if (TLV_GET_DATA_LEN(msg->req) < sizeof(struct tipc_name_table_query))
+       if (TLV_GET_DATA_LEN(msg->req) < (int)sizeof(struct
tipc_name_table_query))
                return -EINVAL;

        depth = ntohl(ntq->depth);

as a follow-up of:

commit 974cb0e3e7c963ced06c4e32c5b2884173fa5e01
Author: Ying Xue <ying.xue@windriver.com>
Date:   Mon Jan 14 17:22:28 2019 +0800

    tipc: fix uninit-value in tipc_nl_compat_name_table_dump

>  tipc_nl_compat_name_table_dump+0x841/0xea0 net/tipc/netlink_compat.c:934
>  __tipc_nl_compat_dumpit+0xab2/0x1320 net/tipc/netlink_compat.c:238
>  tipc_nl_compat_dumpit+0x991/0xb50 net/tipc/netlink_compat.c:321
>  tipc_nl_compat_recv+0xb6e/0x1640 net/tipc/netlink_compat.c:1324
>  genl_family_rcv_msg_doit net/netlink/genetlink.c:731 [inline]
>  genl_family_rcv_msg net/netlink/genetlink.c:775 [inline]
>  genl_rcv_msg+0x103f/0x1260 net/netlink/genetlink.c:792
>  netlink_rcv_skb+0x3a5/0x6c0 net/netlink/af_netlink.c:2501
>  genl_rcv+0x3c/0x50 net/netlink/genetlink.c:803
>  netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>  netlink_unicast+0xf3b/0x1270 net/netlink/af_netlink.c:1345
>  netlink_sendmsg+0x1288/0x1440 net/netlink/af_netlink.c:1921
>  sock_sendmsg_nosec net/socket.c:714 [inline]
>  sock_sendmsg net/socket.c:734 [inline]
>  ____sys_sendmsg+0xabc/0xe90 net/socket.c:2482
>  ___sys_sendmsg+0x2a1/0x3f0 net/socket.c:2536
>  __sys_sendmsg net/socket.c:2565 [inline]
>  __do_sys_sendmsg net/socket.c:2574 [inline]
>  __se_sys_sendmsg net/socket.c:2572 [inline]
>  __x64_sys_sendmsg+0x367/0x540 net/socket.c:2572
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>
> Uninit was created at:
>  slab_post_alloc_hook mm/slab.h:732 [inline]
>  slab_alloc_node mm/slub.c:3258 [inline]
>  __kmalloc_node_track_caller+0x814/0x1250 mm/slub.c:4970
>  kmalloc_reserve net/core/skbuff.c:362 [inline]
>  __alloc_skb+0x346/0xcf0 net/core/skbuff.c:434
>  alloc_skb include/linux/skbuff.h:1257 [inline]
>  netlink_alloc_large_skb net/netlink/af_netlink.c:1191 [inline]
>  netlink_sendmsg+0xb71/0x1440 net/netlink/af_netlink.c:1896
>  sock_sendmsg_nosec net/socket.c:714 [inline]
>  sock_sendmsg net/socket.c:734 [inline]
>  ____sys_sendmsg+0xabc/0xe90 net/socket.c:2482
>  ___sys_sendmsg+0x2a1/0x3f0 net/socket.c:2536
>  __sys_sendmsg net/socket.c:2565 [inline]
>  __do_sys_sendmsg net/socket.c:2574 [inline]
>  __se_sys_sendmsg net/socket.c:2572 [inline]
>  __x64_sys_sendmsg+0x367/0x540 net/socket.c:2572
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>
> CPU: 1 PID: 3490 Comm: syz-executor155 Not tainted 6.0.0-rc5-syzkaller-48538-g8f4ae27df775 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2022
> =====================================================
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches

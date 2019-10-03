Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80496CAEB6
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 21:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730593AbfJCTCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 15:02:21 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:39669 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729781AbfJCTCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 15:02:21 -0400
Received: by mail-yw1-f68.google.com with SMTP id n11so1422267ywn.6
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 12:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UGaQ5a4UfgO2XBcZKKXJwoDm3OP4drYQUzfwdWpV5hY=;
        b=DNp3HZejAbkHQ7jtX6SU4DU4hNQWHmvLXe60v8PFyXE96mzSPZVlsn4qQtLzN/sfoC
         aNATWcLkyiFS3TCaFlTjf/4TqjZfiuh5eaUVTaGtnNblgaCJEYxK3H1MuMRmllGLbXSA
         McHDjIArq9mAYnoCCHm9dYvdj2+ULmT4gfsBu+gMZNCgdrxXHm672HYlEKchfwDUTfO7
         orivS7tdFmnr8b7guQ/oXjpAcwClPEdLPZ2EXQJP2aYGzMMnzQCyGnABY50Agr3hovXz
         n4BAuzmJhRi1oYVSaYjRP8rhX/razb7rgIE8rUYKyojxs8MjmiCIV1P4JmJ7J2jtHEZ6
         m0xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UGaQ5a4UfgO2XBcZKKXJwoDm3OP4drYQUzfwdWpV5hY=;
        b=LKYTY8DQEBgProXtB6hJvrJVduyBVLha027JnBUf8vY+JZNi5ANxLWFnNomUhRRWPi
         kJ0/KPG4WSqInI5neQlwe3uh6ozfKTpFGqZDFwZv60ixy9w2NKqqk3edocYcdEd3Outn
         FDEch3iwTrzaylmB2qWvAqg0EDKKQ/kMg1hHu2dCD9IxWKOdX89AwMBI7eUd0Xj9ekd+
         b0epS+jHMmIB4mPImrcD9rma0cFjm5wYrl/PQsXjca0LhsHj8GoXemEkcrVsISpr3a8J
         5i4YaS/o/2MoMwbX9/W/+oUHs/5bBeuyC9M/kbVZKPtdF9DC5zgg96A66X9Fp9XHSEuP
         KkbQ==
X-Gm-Message-State: APjAAAXD+Q5dQvlDRBMg4ZhBrHbAGx0n/ajwnDW53BITcxXnIQ4dsWEC
        Gefv/9sA2YzysX4w1iMt605BYQDy
X-Google-Smtp-Source: APXvYqxnwALASIgQVmCbCU7/wnczBf6/DBFrYCOW+L1+i+bEOyX+N3bmj8bRe0CXS/lpQCccaTmDtg==
X-Received: by 2002:a0d:e087:: with SMTP id j129mr7353554ywe.244.1570129339685;
        Thu, 03 Oct 2019 12:02:19 -0700 (PDT)
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com. [209.85.219.172])
        by smtp.gmail.com with ESMTPSA id l40sm837415ywk.79.2019.10.03.12.02.18
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Oct 2019 12:02:19 -0700 (PDT)
Received: by mail-yb1-f172.google.com with SMTP id v37so1286983ybi.6
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 12:02:18 -0700 (PDT)
X-Received: by 2002:a25:83d0:: with SMTP id v16mr1526711ybm.337.1570129337920;
 Thu, 03 Oct 2019 12:02:17 -0700 (PDT)
MIME-Version: 1.0
References: <20191003155924.71666-1-edumazet@google.com>
In-Reply-To: <20191003155924.71666-1-edumazet@google.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 3 Oct 2019 15:01:41 -0400
X-Gmail-Original-Message-ID: <CA+FuTSe_DwroMFW4NxEXMORLusUfA=GXq0BLLDQnB2wzU5pDiA@mail.gmail.com>
Message-ID: <CA+FuTSe_DwroMFW4NxEXMORLusUfA=GXq0BLLDQnB2wzU5pDiA@mail.gmail.com>
Subject: Re: [PATCH net-next] net: propagate errors correctly in register_netdevice()
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 3, 2019 at 1:43 PM Eric Dumazet <edumazet@google.com> wrote:
>
> If netdev_name_node_head_alloc() fails to allocate
> memory, we absolutely want register_netdevice() to return
> -ENOMEM instead of zero :/
>
> One of the syzbot report looked like :
>
> general protection fault: 0000 [#1] PREEMPT SMP KASAN
> CPU: 1 PID: 8760 Comm: syz-executor839 Not tainted 5.3.0+ #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:ovs_vport_add+0x185/0x500 net/openvswitch/vport.c:205
> Code: 89 c6 e8 3e b6 3a fa 49 81 fc 00 f0 ff ff 0f 87 6d 02 00 00 e8 8c b4 3a fa 4c 89 e2 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <80> 3c 02 00 0f 85 d3 02 00 00 49 8d 7c 24 08 49 8b 34 24 48 b8 00
> RSP: 0018:ffff88808fe5f4e0 EFLAGS: 00010247
> RAX: dffffc0000000000 RBX: ffffffff89be8820 RCX: ffffffff87385162
> RDX: 0000000000000000 RSI: ffffffff87385174 RDI: 0000000000000007
> RBP: ffff88808fe5f510 R08: ffff8880933c6600 R09: fffffbfff14ee13c
> R10: fffffbfff14ee13b R11: ffffffff8a7709df R12: 0000000000000004
> R13: ffffffff89be8850 R14: ffff88808fe5f5e0 R15: 0000000000000002
> FS:  0000000001d71880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020000280 CR3: 0000000096e4c000 CR4: 00000000001406e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  new_vport+0x1b/0x1d0 net/openvswitch/datapath.c:194
>  ovs_dp_cmd_new+0x5e5/0xe30 net/openvswitch/datapath.c:1644
>  genl_family_rcv_msg+0x74b/0xf90 net/netlink/genetlink.c:629
>  genl_rcv_msg+0xca/0x170 net/netlink/genetlink.c:654
>  netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
>  genl_rcv+0x29/0x40 net/netlink/genetlink.c:665
>  netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
>  netlink_unicast+0x531/0x710 net/netlink/af_netlink.c:1328
>  netlink_sendmsg+0x8a5/0xd60 net/netlink/af_netlink.c:1917
>  sock_sendmsg_nosec net/socket.c:637 [inline]
>  sock_sendmsg+0xd7/0x130 net/socket.c:657
>  ___sys_sendmsg+0x803/0x920 net/socket.c:2311
>  __sys_sendmsg+0x105/0x1d0 net/socket.c:2356
>  __do_sys_sendmsg net/socket.c:2365 [inline]
>  __se_sys_sendmsg net/socket.c:2363 [inline]
>  __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2363
>
> Fixes: ff92741270bf ("net: introduce name_node struct to be used in hashlist")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Jiri Pirko <jiri@mellanox.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Tested-by: Willem de Bruijn <willemb@google.com>

Thanks Eric. This also fixes the veth_get_stats64 syzbot report.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7DF3FF87F
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 02:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244552AbhICAzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 20:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231161AbhICAzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 20:55:54 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1016C061575
        for <netdev@vger.kernel.org>; Thu,  2 Sep 2021 17:54:55 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id u11-20020a17090adb4b00b00181668a56d6so2771835pjx.5
        for <netdev@vger.kernel.org>; Thu, 02 Sep 2021 17:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Lca39X6rvURTsp0gssNupZzTtHHtG1UchATZDWZ5nVQ=;
        b=Twuz9BzCAkSKWnAh6Qz2Awx43kfMjg+gkxTXvQ0ZnIzCLRphyPyewuZL5YJgTI8UTv
         DI6lSKgwZhFJoyBjSZnfbHo5A+BDS4jILZO/C1o/5Ti1kgXUIbGUfDaWnuW1bkr6ku9r
         VV77+QYAug0cM2ar/EHDhYUj2sJY31jrC8Tp4ktYtGVrtft1D1rC+ouobrMamvYlGrnc
         0G0kxyJ8/GP07JqJGa9ROFgnnMLjHmbg7zeGqquFQiNEWlSWIluKvJUyHvi9Fri0ib6A
         48NLa63CUI9sEtY0GhDzUiUlP+noaZBKcAdUgJNr4GWwggEzNmcwST3ILNECmOUTAvgD
         9KEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Lca39X6rvURTsp0gssNupZzTtHHtG1UchATZDWZ5nVQ=;
        b=qeQPtpbkJJ066x5qlm2AyYkMPFBxqlOyfZ6Pl2mOFsq9jDkRmRx57xxsyaSMatcGDI
         UVxqXa8DBMuURyRxbPrAiYq/E+lQqyLJXgoym6psOIECak07DXI2+cWG+xQQMGRI0LoJ
         oaeElZaWvLcyNj2VK0v2cL9dwycpT/a3ujd0vltyj6JtsAsqf35jqbHYpbuP4HGKqcT9
         2Zo6b+81NQP8dZz1p7+cU/mI+F1Cx1ZWQKxL4lmbzbMQ1eCkSpIzB7DWm+Ucm16QzIUs
         HFWDmnH5A65jBoOUNH6z6uJnWe9rNnnaH4AmU758E+8kyHTikGpQOdC0nCeBTyp2Uj6P
         pGow==
X-Gm-Message-State: AOAM5333OytJxw1zwsp4AE2Yp7fLsfvm5fYL2pqgofzH2HFkOxP6qS7r
        pPUOvP+Dg+crAxL8XU03Y+CPETUzMMVWsEbcKUE=
X-Google-Smtp-Source: ABdhPJwYVaUtrPtOcocVPCPbr4B+KZJ5Kr/cR8wHXPyp1Wr47EY/q8z0daZUTzvc8kZ9JzqXwICMQAKBOLNP30tULfk=
X-Received: by 2002:a17:90a:31b:: with SMTP id 27mr7082070pje.6.1630630495373;
 Thu, 02 Sep 2021 17:54:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210902185119.283187-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20210902185119.283187-1-mathew.j.martineau@linux.intel.com>
From:   Geliang Tang <geliangtang@gmail.com>
Date:   Fri, 3 Sep 2021 08:54:44 +0800
Message-ID: <CA+WQbwsyNse7yE4tujakK_W68sXg4GMfB-Z5545xvUWny+eG2A@mail.gmail.com>
Subject: Re: [PATCH net] mptcp: Only send extra TCP acks in eligible socket states
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        MPTCP Upstream <mptcp@lists.linux.dev>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mat Martineau <mathew.j.martineau@linux.intel.com> =E4=BA=8E2021=E5=B9=B49=
=E6=9C=883=E6=97=A5=E5=91=A8=E4=BA=94 =E4=B8=8A=E5=8D=882:51=E5=86=99=E9=81=
=93=EF=BC=9A
>
> Recent changes exposed a bug where specifically-timed requests to the
> path manager netlink API could trigger a divide-by-zero in
> __tcp_select_window(), as syzkaller does:
>
> divide error: 0000 [#1] SMP KASAN NOPTI
> CPU: 0 PID: 9667 Comm: syz-executor.0 Not tainted 5.14.0-rc6+ #3
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubunt=
u1.1 04/01/2014
> RIP: 0010:__tcp_select_window+0x509/0xa60 net/ipv4/tcp_output.c:3016
> Code: 44 89 ff e8 c9 29 e9 fd 45 39 e7 0f 8d 20 ff ff ff e8 db 28 e9 fd 4=
4 89 e3 e9 13 ff ff ff e8 ce 28 e9 fd 44 89 e0 44 89 e3 99 <f7> 7c 24 04 29=
 d3 e9 fc fe ff ff e8 b7 28 e9 fd 44 89 f1 48 89 ea
> RSP: 0018:ffff888031ccf020 EFLAGS: 00010216
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000040000
> RDX: 0000000000000000 RSI: ffff88811532c080 RDI: 0000000000000002
> RBP: 0000000000000000 R08: ffffffff835807c2 R09: 0000000000000000
> R10: 0000000000000004 R11: ffffed1020b92441 R12: 0000000000000000
> R13: 1ffff11006399e08 R14: 0000000000000000 R15: 0000000000000000
> FS:  00007fa4c8344700(0000) GS:ffff88811ae00000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b2f424000 CR3: 000000003e4e2003 CR4: 0000000000770ef0
> PKRU: 55555554
> Call Trace:
>  tcp_select_window net/ipv4/tcp_output.c:264 [inline]
>  __tcp_transmit_skb+0xc00/0x37a0 net/ipv4/tcp_output.c:1351
>  __tcp_send_ack.part.0+0x3ec/0x760 net/ipv4/tcp_output.c:3972
>  __tcp_send_ack net/ipv4/tcp_output.c:3978 [inline]
>  tcp_send_ack+0x7d/0xa0 net/ipv4/tcp_output.c:3978
>  mptcp_pm_nl_addr_send_ack+0x1ab/0x380 net/mptcp/pm_netlink.c:654
>  mptcp_pm_remove_addr+0x161/0x200 net/mptcp/pm.c:58
>  mptcp_nl_remove_id_zero_address+0x197/0x460 net/mptcp/pm_netlink.c:1328
>  mptcp_nl_cmd_del_addr+0x98b/0xd40 net/mptcp/pm_netlink.c:1359
>  genl_family_rcv_msg_doit.isra.0+0x225/0x340 net/netlink/genetlink.c:731
>  genl_family_rcv_msg net/netlink/genetlink.c:775 [inline]
>  genl_rcv_msg+0x341/0x5b0 net/netlink/genetlink.c:792
>  netlink_rcv_skb+0x148/0x430 net/netlink/af_netlink.c:2504
>  genl_rcv+0x24/0x40 net/netlink/genetlink.c:803
>  netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
>  netlink_unicast+0x537/0x750 net/netlink/af_netlink.c:1340
>  netlink_sendmsg+0x846/0xd80 net/netlink/af_netlink.c:1929
>  sock_sendmsg_nosec net/socket.c:704 [inline]
>  sock_sendmsg+0x14e/0x190 net/socket.c:724
>  ____sys_sendmsg+0x709/0x870 net/socket.c:2403
>  ___sys_sendmsg+0xff/0x170 net/socket.c:2457
>  __sys_sendmsg+0xe5/0x1b0 net/socket.c:2486
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x38/0x90 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> mptcp_pm_nl_addr_send_ack() was attempting to send a TCP ACK on the
> first subflow in the MPTCP socket's connection list without validating
> that the subflow was in a suitable connection state. To address this,
> always validate subflow state when sending extra ACKs on subflows
> for address advertisement or subflow priority change.
>
> Fixes: 84dfe3677a6f ("mptcp: send out dedicated ADD_ADDR packet")

Acked-by: Geliang Tang <geliangtang@gmail.com>

> Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/229
> Co-developed-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> ---
>  net/mptcp/pm_netlink.c | 10 ++--------
>  net/mptcp/protocol.c   | 21 ++++++++++++---------
>  net/mptcp/protocol.h   |  1 +
>  3 files changed, 15 insertions(+), 17 deletions(-)
>
> diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
> index 1e4289c507ff..c4f9a5ce3815 100644
> --- a/net/mptcp/pm_netlink.c
> +++ b/net/mptcp/pm_netlink.c
> @@ -644,15 +644,12 @@ void mptcp_pm_nl_addr_send_ack(struct mptcp_sock *m=
sk)
>         subflow =3D list_first_entry_or_null(&msk->conn_list, typeof(*sub=
flow), node);
>         if (subflow) {
>                 struct sock *ssk =3D mptcp_subflow_tcp_sock(subflow);
> -               bool slow;
>
>                 spin_unlock_bh(&msk->pm.lock);
>                 pr_debug("send ack for %s",
>                          mptcp_pm_should_add_signal(msk) ? "add_addr" : "=
rm_addr");
>
> -               slow =3D lock_sock_fast(ssk);
> -               tcp_send_ack(ssk);
> -               unlock_sock_fast(ssk, slow);
> +               mptcp_subflow_send_ack(ssk);
>                 spin_lock_bh(&msk->pm.lock);
>         }
>  }
> @@ -669,7 +666,6 @@ int mptcp_pm_nl_mp_prio_send_ack(struct mptcp_sock *m=
sk,
>                 struct sock *ssk =3D mptcp_subflow_tcp_sock(subflow);
>                 struct sock *sk =3D (struct sock *)msk;
>                 struct mptcp_addr_info local;
> -               bool slow;
>
>                 local_address((struct sock_common *)ssk, &local);
>                 if (!addresses_equal(&local, addr, addr->port))
> @@ -682,9 +678,7 @@ int mptcp_pm_nl_mp_prio_send_ack(struct mptcp_sock *m=
sk,
>
>                 spin_unlock_bh(&msk->pm.lock);
>                 pr_debug("send ack for mp_prio");
> -               slow =3D lock_sock_fast(ssk);
> -               tcp_send_ack(ssk);
> -               unlock_sock_fast(ssk, slow);
> +               mptcp_subflow_send_ack(ssk);
>                 spin_lock_bh(&msk->pm.lock);
>
>                 return 0;
> diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
> index a4c6e37e07c9..2602f1386160 100644
> --- a/net/mptcp/protocol.c
> +++ b/net/mptcp/protocol.c
> @@ -440,19 +440,22 @@ static bool tcp_can_send_ack(const struct sock *ssk=
)
>                (TCPF_SYN_SENT | TCPF_SYN_RECV | TCPF_TIME_WAIT | TCPF_CLO=
SE | TCPF_LISTEN));
>  }
>
> +void mptcp_subflow_send_ack(struct sock *ssk)
> +{
> +       bool slow;
> +
> +       slow =3D lock_sock_fast(ssk);
> +       if (tcp_can_send_ack(ssk))
> +               tcp_send_ack(ssk);
> +       unlock_sock_fast(ssk, slow);
> +}
> +
>  static void mptcp_send_ack(struct mptcp_sock *msk)
>  {
>         struct mptcp_subflow_context *subflow;
>
> -       mptcp_for_each_subflow(msk, subflow) {
> -               struct sock *ssk =3D mptcp_subflow_tcp_sock(subflow);
> -               bool slow;
> -
> -               slow =3D lock_sock_fast(ssk);
> -               if (tcp_can_send_ack(ssk))
> -                       tcp_send_ack(ssk);
> -               unlock_sock_fast(ssk, slow);
> -       }
> +       mptcp_for_each_subflow(msk, subflow)
> +               mptcp_subflow_send_ack(mptcp_subflow_tcp_sock(subflow));
>  }
>
>  static void mptcp_subflow_cleanup_rbuf(struct sock *ssk)
> diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
> index 64c9a30e0871..d3e6fd1615f1 100644
> --- a/net/mptcp/protocol.h
> +++ b/net/mptcp/protocol.h
> @@ -573,6 +573,7 @@ void __init mptcp_subflow_init(void);
>  void mptcp_subflow_shutdown(struct sock *sk, struct sock *ssk, int how);
>  void mptcp_close_ssk(struct sock *sk, struct sock *ssk,
>                      struct mptcp_subflow_context *subflow);
> +void mptcp_subflow_send_ack(struct sock *ssk);
>  void mptcp_subflow_reset(struct sock *ssk);
>  void mptcp_sock_graft(struct sock *sk, struct socket *parent);
>  struct socket *__mptcp_nmpc_socket(const struct mptcp_sock *msk);
>
> base-commit: d12e1c4649883e8ca5e8ff341e1948b3b6313259
> --
> 2.33.0
>
>

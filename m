Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22E9A6B7CD1
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 16:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbjCMPxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 11:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231218AbjCMPxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 11:53:41 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8274A1DBBF
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 08:53:20 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id cj14so1278698ybb.12
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 08:53:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678722797;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=16JjMrO3QG/ZrySP5VOWfhPacyT/2JiqlpwGEEQSn4g=;
        b=IjQ799fG3QQYJrYyD6Sl41BaTdNl0U5GezZT8fZJIBehUBYx9XHPEjFQH7VKwq5+U3
         hERRo8JcKX1rjX3ENRezXtIuxQZmhvgO90uZRg21i2QqyF+gTLbD8JvfiAWTzcruGGJQ
         3ZfXTYLpwacaEVAkvJsSxs8phUKmipMT1RU/xVgKpTjCkUS7ygvZfI/tZilrFhLS8aiO
         gxNs0ySA0BIlR47wH3ca/+nwm+XxSmDIJ2dZFGV4uiAkZNg7JlkSnWnPhg7jd3vjNBMr
         fmf0CYZ8FXqpQldCtWf65s/yUnRanjb86xiAhoRTtfGKdNqW23G23sRdf/deBVgmTpPW
         Xf3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678722797;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=16JjMrO3QG/ZrySP5VOWfhPacyT/2JiqlpwGEEQSn4g=;
        b=LJ4kirpxdmJA7RcR3EFu7zKSH8D/D7060QCbIsGvg0DtfhCLGR87lfOkBCU9ZgdL/Z
         p7T/ivIxK+/mXEAoTSxB6EnyaC3k9iVGTlWI5orXNcPFl/cX64x8Dv3fSj2bam6gy5mR
         x/oZCmUyh/7DLzJbAU/Wsa091XjYdrUPAK5WRqSxtndMkVFW8o/Tsgjg+ODxMyvP99qo
         aKUbzVuryhldxv1o8QVZ0dsw/z1U3RCVbR6x47YYK1Au6dGO8VrVodiaO6Yjt3jK/NT0
         jCHgYX5WC8Y1gOzzt9jzzlx3d+SgHFPlaTor+Zi1EnrvMF/SoYzWgHal98ngjvABFuDD
         K1aQ==
X-Gm-Message-State: AO0yUKWrUsm+jip+YwUaNs1M6SAikPzB+uL/WU/BlUtk3KIFqrgnxelv
        4g2EAEjDY4hYTFezrc4D9DO8nVdRvO077HuRstTVOA==
X-Google-Smtp-Source: AK7set8joi/wCFJKA8C/n3FKRkZPOy0oHtK2w69y80BoqQ1pxY4FPxffIIPt95164+0sjPZiRFHGFcdwGpChrNpnkRk=
X-Received: by 2002:a25:928f:0:b0:b3e:c715:c313 with SMTP id
 y15-20020a25928f000000b00b3ec715c313mr1386965ybl.6.1678722796752; Mon, 13 Mar
 2023 08:53:16 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1678364612.git.lorenzo@kernel.org> <f20cfdb08d7357b0853d25be3b34ace4408693be.1678364613.git.lorenzo@kernel.org>
 <f5167659-99d7-04a1-2175-60ff1dabae71@tessares.net> <CANn89i+4F0QUqyDTqJ8GWrWvGnTyLTxja2hbL1W_rVdMqqmxaQ@mail.gmail.com>
In-Reply-To: <CANn89i+4F0QUqyDTqJ8GWrWvGnTyLTxja2hbL1W_rVdMqqmxaQ@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 13 Mar 2023 08:53:05 -0700
Message-ID: <CANn89iL=zQQygGg4mkAG+MES6-CpkYBL5KY+kn4j=hAowexVZw@mail.gmail.com>
Subject: Re: [PATCH net v2 6/8] veth: take into account device reconfiguration
 for xdp_features flag
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, saeedm@nvidia.com,
        leon@kernel.org, shayagr@amazon.com, akiyano@amazon.com,
        darinzon@amazon.com, sgoutham@marvell.com,
        lorenzo.bianconi@redhat.com, toke@redhat.com, teknoraver@meta.com,
        ttoukan.linux@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 8:50=E2=80=AFAM Eric Dumazet <edumazet@google.com> =
wrote:
>
> On Mon, Mar 13, 2023 at 7:15=E2=80=AFAM Matthieu Baerts
> <matthieu.baerts@tessares.net> wrote:
> >
> > Hi Lorenzo,
> >
> > On 09/03/2023 13:25, Lorenzo Bianconi wrote:
> > > Take into account tx/rx queues reconfiguration setting device
> > > xdp_features flag. Moreover consider NETIF_F_GRO flag in order to ena=
ble
> > > ndo_xdp_xmit callback.
> > >
> > > Fixes: 66c0e13ad236 ("drivers: net: turn on XDP features")
> > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> >
> > Thank you for the modification.
> >
> > Unfortunately, 'git bisect' just told me this modification is the origi=
n
> > of a new WARN when using veth in a netns:
> >
> >
> > ###################### 8< ######################
> >
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> > WARNING: suspicious RCU usage
> > 6.3.0-rc1-00144-g064d70527aaa #149 Not tainted
> > -----------------------------
> > drivers/net/veth.c:1265 suspicious rcu_dereference_check() usage!
> >
> > other info that might help us debug this:
> >
>
> Same observation here, I am releasing a syzbot report with a repro.
>
>

I guess a fix would be:

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 293dc3b2c84a6c1931e8df42cdcd5f2798004f3c..4da74ac27f9a2425d8d3f4ffcc9=
3f453bd58e3a5
100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1262,7 +1262,7 @@ static void veth_set_xdp_features(struct net_device *=
dev)
        struct veth_priv *priv =3D netdev_priv(dev);
        struct net_device *peer;

-       peer =3D rcu_dereference(priv->peer);
+       peer =3D rtnl_dereference(priv->peer);
        if (peer && peer->real_num_tx_queues <=3D dev->real_num_rx_queues) =
{
                xdp_features_t val =3D NETDEV_XDP_ACT_BASIC |
                                     NETDEV_XDP_ACT_REDIRECT |


>
> >
> > rcu_scheduler_active =3D 2, debug_locks =3D 1
> > 1 lock held by ip/135:
> > #0: ffffffff8dc4b108 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg
> > (net/core/rtnetlink.c:6172)
> >
> > stack backtrace:
> > CPU: 1 PID: 135 Comm: ip Not tainted 6.3.0-rc1-00144-g064d70527aaa #149
> > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1
> > 04/01/2014
> > Call Trace:
> >  <TASK>
> > dump_stack_lvl (lib/dump_stack.c:107)
> > lockdep_rcu_suspicious (include/linux/context_tracking.h:152)
> > veth_set_xdp_features (drivers/net/veth.c:1265 (discriminator 9))
> > veth_newlink (drivers/net/veth.c:1892)
> > ? veth_set_features (drivers/net/veth.c:1774)
> > ? kasan_save_stack (mm/kasan/common.c:47)
> > ? kasan_save_stack (mm/kasan/common.c:46)
> > ? kasan_set_track (mm/kasan/common.c:52)
> > ? alloc_netdev_mqs (include/linux/slab.h:737)
> > ? rcu_read_lock_sched_held (kernel/rcu/update.c:125)
> > ? trace_kmalloc (include/trace/events/kmem.h:54)
> > ? __xdp_rxq_info_reg (net/core/xdp.c:188)
> > ? alloc_netdev_mqs (net/core/dev.c:10657)
> > ? rtnl_create_link (net/core/rtnetlink.c:3312)
> > rtnl_newlink_create (net/core/rtnetlink.c:3440)
> > ? rtnl_link_get_net_capable.constprop.0 (net/core/rtnetlink.c:3391)
> > __rtnl_newlink (net/core/rtnetlink.c:3657)
> > ? lock_downgrade (kernel/locking/lockdep.c:5321)
> > ? rtnl_link_unregister (net/core/rtnetlink.c:3487)
> > rtnl_newlink (net/core/rtnetlink.c:3671)
> > rtnetlink_rcv_msg (net/core/rtnetlink.c:6174)
> > ? rtnl_link_fill (net/core/rtnetlink.c:6070)
> > ? mark_usage (kernel/locking/lockdep.c:4914)
> > ? mark_usage (kernel/locking/lockdep.c:4914)
> > netlink_rcv_skb (net/netlink/af_netlink.c:2574)
> > ? rtnl_link_fill (net/core/rtnetlink.c:6070)
> > ? netlink_ack (net/netlink/af_netlink.c:2551)
> > ? lock_acquire (kernel/locking/lockdep.c:467)
> > ? net_generic (include/linux/rcupdate.h:805)
> > ? netlink_deliver_tap (include/linux/rcupdate.h:805)
> > netlink_unicast (net/netlink/af_netlink.c:1340)
> > ? netlink_attachskb (net/netlink/af_netlink.c:1350)
> > netlink_sendmsg (net/netlink/af_netlink.c:1942)
> > ? netlink_unicast (net/netlink/af_netlink.c:1861)
> > ? netlink_unicast (net/netlink/af_netlink.c:1861)
> > sock_sendmsg (net/socket.c:727)
> > ____sys_sendmsg (net/socket.c:2501)
> > ? kernel_sendmsg (net/socket.c:2448)
> > ? __copy_msghdr (net/socket.c:2428)
> > ___sys_sendmsg (net/socket.c:2557)
> > ? mark_usage (kernel/locking/lockdep.c:4914)
> > ? do_recvmmsg (net/socket.c:2544)
> > ? lock_acquire (kernel/locking/lockdep.c:467)
> > ? find_held_lock (kernel/locking/lockdep.c:5159)
> > ? __lock_release (kernel/locking/lockdep.c:5345)
> > ? __might_fault (mm/memory.c:5625)
> > ? lock_downgrade (kernel/locking/lockdep.c:5321)
> > ? __fget_light (include/linux/atomic/atomic-arch-fallback.h:227)
> > __sys_sendmsg (include/linux/file.h:31)
> > ? __sys_sendmsg_sock (net/socket.c:2572)
> > ? rseq_get_rseq_cs (kernel/rseq.c:275)
> > ? lockdep_hardirqs_on_prepare.part.0 (kernel/locking/lockdep.c:4263)
> > do_syscall_64 (arch/x86/entry/common.c:50)
> > entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120)
> > RIP: 0033:0x7f0d1aadeb17
> > Code: 0f 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b9 0f 1f 00 f3 0f 1e
> > fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 2e 00 00 00 0f 05 <48> 3d 00
> > f0 ff ff 77 51 c3 48 83 ec 28 89 54 24 1c 48 89 74 24 10
> > All code
> > =3D=3D=3D=3D=3D=3D=3D=3D
> >    0:   0f 00                   (bad)
> >    2:   f7 d8                   neg    %eax
> >    4:   64 89 02                mov    %eax,%fs:(%rdx)
> >    7:   48 c7 c0 ff ff ff ff    mov    $0xffffffffffffffff,%rax
> >    e:   eb b9                   jmp    0xffffffffffffffc9
> >   10:   0f 1f 00                nopl   (%rax)
> >   13:   f3 0f 1e fa             endbr64
> >   17:   64 8b 04 25 18 00 00    mov    %fs:0x18,%eax
> >   1e:   00
> >   1f:   85 c0                   test   %eax,%eax
> >   21:   75 10                   jne    0x33
> >   23:   b8 2e 00 00 00          mov    $0x2e,%eax
> >   28:   0f 05                   syscall
> >   2a:*  48 3d 00 f0 ff ff       cmp    $0xfffffffffffff000,%rax
> > <-- trapping instruction
> >   30:   77 51                   ja     0x83
> >   32:   c3                      ret
> >   33:   48 83 ec 28             sub    $0x28,%rsp
> >   37:   89 54 24 1c             mov    %edx,0x1c(%rsp)
> >   3b:   48 89 74 24 10          mov    %rsi,0x10(%rsp)
> >
> > Code starting with the faulting instruction
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >    0:   48 3d 00 f0 ff ff       cmp    $0xfffffffffffff000,%rax
> >    6:   77 51                   ja     0x59
> >    8:   c3                      ret
> >    9:   48 83 ec 28             sub    $0x28,%rsp
> >    d:   89 54 24 1c             mov    %edx,0x1c(%rsp)
> >   11:   48 89 74 24 10          mov    %rsi,0x10(%rsp)
> > RSP: 002b:00007ffca3305d48 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> > RAX: ffffffffffffffda RBX: 00000000640f2bb2 RCX: 00007f0d1aadeb17
> > RDX: 0000000000000000 RSI: 00007ffca3305db0 RDI: 0000000000000003
> > RBP: 0000000000000000 R08: 0000000000000001 R09: 00007ffca3304ae0
> > R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
> > R13: 00007ffca3305eb4 R14: 00007ffca3305e80 R15: 0000561e28bf5020
> >  </TASK>
> > ip (135) used greatest stack depth: 24544 bytes left
> >
> > ###################### 8< ######################
> >
> >
> > I can reproduce the issue on the "net" tree with just these 3 commands:
> >
> > # ip netns add ns1
> > # ip netns add ns2
> > # ip link add ns1eth1 netns ns1 type veth peer name ns2eth1 netns ns2
> >
> > Without this commit fccca038f300 ("veth: take into account device
> > reconfiguration for xdp_features flag"), I don't have the issue.
> >
> > For more details about the issue detected by CIs validating our MPTCP
> > tree, including kconfig and vmlinux if needed:
> >
> >   https://github.com/multipath-tcp/mptcp_net-next/issues/372
> >
> >
> > Do you mind looking at this regression please? :)
> >
> >
> > On our side, we will revert this patch in our tree for the moment to
> > unblock our CI jobs.
> >
> > Cheers,
> > Matt
> > --
> > Tessares | Belgium | Hybrid Access Solutions
> > www.tessares.net

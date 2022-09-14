Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B837C5B8E65
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 19:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbiINR4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 13:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiINR4n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 13:56:43 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84B5983BC1
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 10:56:42 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id a67so23956802ybb.3
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 10:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=c6cSMgOvPaHundQ9+y+KZ95hMAdIVrUDqCcFSiVF8dE=;
        b=pBc43sdsS6OvN916tV5em864gdR8OJVQ2yKeaICnaO9iyWUvlYvIQdzIuVB+QZYAtw
         rCe9a2UrVI4422nzdUIlcZmmEVLU9rNJayEKWurv1HrF1nxYPC9Q4r5DHO3thXFyANi6
         muBQi518+giFA2abogAbVv83oNLcBj9dFxrd9FhHbkvAhjCZXZFDc1cER/B6Ft33IK46
         6ZfWffY7zNyQxB6379shX7IWcm1YsiaJR54Jk2B3mI7u5vF18neh/3R+mB13L5/r4z3s
         gPysh98fN+qt/XH2aIBso6+2BG7ncBmyIPmkKMwHrsT0v6IiN/xcBWqFu1DqXSe9Y3ir
         n5bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=c6cSMgOvPaHundQ9+y+KZ95hMAdIVrUDqCcFSiVF8dE=;
        b=Qp12oWwuxdwMKmsPh4to3Z+vwtelk7L/vB3sex6hyZIuS7P1y/5kEcgdjMxO1fg5zW
         oeUaFuUagRmAYZKirHNqkMYubofOTEQelrNzKzHyxdwTgO3J9Yy5i0kqyhkJ+lrbSTzr
         pRt8cFlASaBMc+PyK/VorqcgQxt1HtfyzxtcKl/LbZsL7rraYCpE81HTUMGb8O5yQF5u
         bApGf+IrbYv7mPJHQkZWQhdHPwwQPWvo5EF2eN2/G+QZtH/X24Hbg9oRU/q/YOd6B2y1
         7SVk3AcmL/vCXogDXaiHUbGo6K9kSkLaMX49useHTBhF8u4lBLqd8ZXxHtDvg6yHVBOk
         woWA==
X-Gm-Message-State: ACgBeo2RYy3+I8roadgEdqfTuqM7X7SaEqtLzlaieNaASn9Zugr3mwW0
        5OfSlmarSJLliuNC2oqx22USvNgh5YEq1sKT48hjjw==
X-Google-Smtp-Source: AA6agR7DYdFynhauPAEovqsyZU+MuLmwL/B4GXIwPwSOv+x230Pt4Fik+o8L2sG3dv/qE2+uJ4Ex2zUl1oBUrrRzysk=
X-Received: by 2002:a25:f823:0:b0:6a9:4227:8f79 with SMTP id
 u35-20020a25f823000000b006a942278f79mr30197182ybd.55.1663178201469; Wed, 14
 Sep 2022 10:56:41 -0700 (PDT)
MIME-Version: 1.0
References: <YyD0kMC7qIBNOE3j@riccipc> <YyH3gBoUNT9yqrUx@shredder>
In-Reply-To: <YyH3gBoUNT9yqrUx@shredder>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 14 Sep 2022 10:56:30 -0700
Message-ID: <CANn89iJyfkUN45mSPVkLF-ygik9AUzhUhE7UWLEFGswXaosAjQ@mail.gmail.com>
Subject: Re: BUG: unable to handle page fault for address, with ipv6.disable=1
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Roberto Ricci <rroberto2r@gmail.com>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 14, 2022 at 8:47 AM Ido Schimmel <idosch@idosch.org> wrote:
>
> + Eric
>
> Original report:
> https://lore.kernel.org/netdev/YyD0kMC7qIBNOE3j@riccipc/T/#u
>
> On Tue, Sep 13, 2022 at 11:22:24PM +0200, Roberto Ricci wrote:
> > Executing the `ss` command in a system with kernel 5.19.8, booted with
> > the "ipv6.disable=3D1" parameter, causes this oops:
> >
> >
> > [   74.952477] BUG: unable to handle page fault for address: ffffffffff=
ffffc8
> > [   74.952568] #PF: supervisor read access in kernel mode
> > [   74.952632] #PF: error_code(0x0000) - not-present page
> > [   74.952695] PGD 25814067 P4D 25814067 PUD 25816067 PMD 0
> > [   74.952770] Oops: 0000 [#1] PREEMPT SMP PTI
> > [   74.952816] CPU: 0 PID: 704 Comm: ss Not tainted 5.19.8_1 #1
> > [   74.952869] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), B=
IOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
> > WARNING! Modules path isn't set, but is needed to parse this symbol
> > [   74.953292] RIP: 0010:raw_diag_dump+0xea/0x1d0 raw_diag
> [...]
> > [   74.954188] Call Trace:
> > [   74.954221]  <TASK>
> > [   74.954248] __inet_diag_dump (net/ipv4/inet_diag.c:1179)
> > [   74.954462] netlink_dump (net/netlink/af_netlink.c:2276)
> > [   74.954549] __netlink_dump_start (net/netlink/af_netlink.c:2380)
> > [   74.954613] inet_diag_handler_cmd (net/ipv4/inet_diag.c:1347)
> > [   74.954672] ? inet_diag_dump_start_compat (net/ipv4/inet_diag.c:1244=
)
> > [   74.954725] ? inet_diag_dump_compat (net/ipv4/inet_diag.c:1197)
> > [   74.954768] ? inet_diag_unregister (net/ipv4/inet_diag.c:1254)
> > [   74.954811] sock_diag_rcv_msg (net/core/sock_diag.c:235 net/core/soc=
k_diag.c:266)
> > [   74.954905] ? sock_diag_bind (net/core/sock_diag.c:247)
> > [   74.954950] netlink_rcv_skb (net/netlink/af_netlink.c:2501)
> > [   74.954993] sock_diag_rcv (net/core/sock_diag.c:278)
> > [   74.955032] netlink_unicast (net/netlink/af_netlink.c:1320 net/netli=
nk/af_netlink.c:1345)
> > [   74.955074] netlink_sendmsg (net/netlink/af_netlink.c:1921)
> > [   74.955116] sock_sendmsg (net/socket.c:714 net/socket.c:734)
> > [   74.955199] ____sys_sendmsg (net/socket.c:2488)
> > [   74.955245] ? import_iovec (lib/iov_iter.c:2008)
> > [   74.955302] ? sendmsg_copy_msghdr (net/socket.c:2429 net/socket.c:25=
19)
> > [   74.955348] ___sys_sendmsg (net/socket.c:2544)
> > [   74.955447] ? __schedule (kernel/sched/core.c:6476)
> > [   74.955522] ? _raw_spin_unlock_irqrestore (./arch/x86/include/asm/pr=
eempt.h:103 ./include/linux/spinlock_api_smp.h:152 kernel/locking/spinlock.=
c:194)
> > [   74.955583] ? do_notify_parent_cldstop (kernel/signal.c:2191)
> > [   74.955656] ? preempt_count_add (./include/linux/ftrace.h:910 kernel=
/sched/core.c:5598 kernel/sched/core.c:5595 kernel/sched/core.c:5623)
> > [   74.955712] ? _raw_spin_lock_irq (./arch/x86/include/asm/atomic.h:20=
2 ./include/linux/atomic/atomic-instrumented.h:543 ./include/asm-generic/qs=
pinlock.h:111 ./include/linux/spinlock.h:185 ./include/linux/spinlock_api_s=
mp.h:120 kernel/locking/spinlock.c:170)
> > [   74.955752] ? ptrace_stop.part.0 (kernel/signal.c:2331)
> > [   74.955795] __sys_sendmsg (./include/linux/file.h:31 net/socket.c:25=
73)
> > [   74.955835] do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry=
/common.c:80)
> > [   74.955914] ? syscall_exit_to_user_mode (./arch/x86/include/asm/jump=
_label.h:55 ./arch/x86/include/asm/nospec-branch.h:382 ./arch/x86/include/a=
sm/entry-common.h:94 kernel/entry/common.c:133 kernel/entry/common.c:296)
> > [   74.955965] ? do_syscall_64 (arch/x86/entry/common.c:87)
> > [   74.957786] ? do_syscall_64 (arch/x86/entry/common.c:87)
> > [   74.959896] ? handle_mm_fault (mm/memory.c:5144)
> > [   74.961184] ? do_user_addr_fault (arch/x86/mm/fault.c:1422)
> > [   74.962609] ? fpregs_assert_state_consistent (arch/x86/kernel/fpu/co=
ntext.h:39 arch/x86/kernel/fpu/core.c:772)
> > [   74.964171] ? exit_to_user_mode_prepare (./arch/x86/include/asm/entr=
y-common.h:57 kernel/entry/common.c:203)
> > [   74.965968] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.=
S:120)
> > [   74.967266] RIP: 0033:0x7f66aac577d3
>
> [...]
>
> > I reproduced this with Void Linux x86_64 in a virtual machine. The kern=
els are
> > those provided by the distribution (Void uses vanilla kernels, I don't =
believe
> > these very small patches make any difference
> > https://github.com/void-linux/void-packages/tree/0a87c670f35e01a3ac1d85=
0f628fe1bab5d3c433/srcpkgs/linux5.19/patches).
> >
> > Kernels 5.19.8 and 5.18.19 are affected, 5.16.20 is not.
> > I don't know about 5.17.x because Void doesn't package it.
> > The iproute2 version is 5.16.0 (but this also happens with 5.19.0).
>
> This is most likely caused by commit 0daf07e52709 ("raw: convert raw
> sockets to RCU") which is being back ported to stable kernels.
>
> It made the initialization of 'raw_v6_hashinfo' conditional on IPv6
> being enabled. Can you try the following patch (works on my end)?
>
> diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
> index 19732b5dce23..d40b7d60e00e 100644
> --- a/net/ipv6/af_inet6.c
> +++ b/net/ipv6/af_inet6.c
> @@ -1072,13 +1072,13 @@ static int __init inet6_init(void)
>         for (r =3D &inetsw6[0]; r < &inetsw6[SOCK_MAX]; ++r)
>                 INIT_LIST_HEAD(r);
>
> +       raw_hashinfo_init(&raw_v6_hashinfo);
> +
>         if (disable_ipv6_mod) {
>                 pr_info("Loaded, but administratively disabled, reboot re=
quired to enable\n");
>                 goto out;
>         }
>
> -       raw_hashinfo_init(&raw_v6_hashinfo);
> -
>         err =3D proto_register(&tcpv6_prot, 1);
>         if (err)
>                 goto out;
>
> Another approach is the following, but I prefer the first:

+1, thanks for looking at this Ido !

>
> diff --git a/net/ipv4/raw_diag.c b/net/ipv4/raw_diag.c
> index 999321834b94..4fbdd69a2be8 100644
> --- a/net/ipv4/raw_diag.c
> +++ b/net/ipv4/raw_diag.c
> @@ -20,7 +20,7 @@ raw_get_hashinfo(const struct inet_diag_req_v2 *r)
>         if (r->sdiag_family =3D=3D AF_INET) {
>                 return &raw_v4_hashinfo;
>  #if IS_ENABLED(CONFIG_IPV6)
> -       } else if (r->sdiag_family =3D=3D AF_INET6) {
> +       } else if (r->sdiag_family =3D=3D AF_INET6 && ipv6_mod_enabled())=
 {
>                 return &raw_v6_hashinfo;
>  #endif
>         } else {

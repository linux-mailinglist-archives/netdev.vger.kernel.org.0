Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1575B8C30
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 17:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbiINPrX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 11:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiINPrW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 11:47:22 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FBAE7F12E;
        Wed, 14 Sep 2022 08:47:21 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id E0DA75C00C0;
        Wed, 14 Sep 2022 11:47:17 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 14 Sep 2022 11:47:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1663170437; x=1663256837; bh=h167GJbr58GYNjPPrdQId1YXiLBY
        5PhUv/Q/LmnvJDY=; b=zkrQU4KfxoCkH7L7NzS0HhjITPM62n2OSVSwNVBrFJol
        1yWPN/BNUbtzwZ9iqcrqO3EoL7bmtvt3hUFtK783gTjcJ+pxCeizpK/QZjBAukko
        N8oGM5gRRX2iFubteeIpC8tCseSFo8V7Fen9vEHpicQLlaYic0cCw9UiRJ2zSNdG
        cTo8EDvuVQ28N0tNde+5HLHZ7icaVldzzHKQ81iAVNu73XfNpe5WOrLmzKbU30Bf
        6niFkIcFA2AGYylc1vv6Fys6V4eoz/YHabaQiGi8pbnr5pDhIyp2PmBWt7j6zSDA
        vy5B6hwWnwm0M+5HSpBW+amlZ9tWKKL3ec1G9VoG+w==
X-ME-Sender: <xms:hfchY3W_1zh6K5lLSMGFuhq9gmwpmIMFrv2w2MTYaTQnaS42piwHBA>
    <xme:hfchY_m-sUdQRwu2zDLEeVA_tphp8q2SZnKz8WjXj6sIA_2fuEGMc49CewTmZr5YD
    nM_4fH_kWoNDVM>
X-ME-Received: <xmr:hfchYzZeLivKd45Sd0Ge3O6wOMeYwI49RreKdSv2XokxQPw3RZMrzvRv2-oRjQZuCTEUyGpX8OssTvOuga99S7W9KNH1Qw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfeduiedgleehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfhfgggtuggjsehttd
    ertddttddvnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpefgueeugeegvedvueevveetfeekhe
    ehveeffeehveeuhfdvvdelveeugeeivdevueenucffohhmrghinhepkhgvrhhnvghlrdho
    rhhgpdhqvghmuhdrohhrghdpghhithhhuhgsrdgtohhmnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhr
    gh
X-ME-Proxy: <xmx:hfchYyUNDv74LpuKt6dcNeCJDxNyAzK81WJM0vIJMHKG14-1hc_n5A>
    <xmx:hfchYxmbKjyqVUL9DWQRgnk8L6qYWCtKq4pHIMdTjjj5rxlKiwO_gQ>
    <xmx:hfchY_cbbw9c5E4CXiGp_AMkV3N26jzo7ff7fEkCKhVfS-Ski8k6nA>
    <xmx:hfchY6BXPjTHGudXaS9mMi6xNS_7RxZz-eFZJEGmBjV3UaJrzKsWWQ>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 14 Sep 2022 11:47:16 -0400 (EDT)
Date:   Wed, 14 Sep 2022 18:47:12 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Roberto Ricci <rroberto2r@gmail.com>, edumazet@google.com
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: BUG: unable to handle page fault for address, with ipv6.disable=1
Message-ID: <YyH3gBoUNT9yqrUx@shredder>
References: <YyD0kMC7qIBNOE3j@riccipc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YyD0kMC7qIBNOE3j@riccipc>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ Eric

Original report:
https://lore.kernel.org/netdev/YyD0kMC7qIBNOE3j@riccipc/T/#u

On Tue, Sep 13, 2022 at 11:22:24PM +0200, Roberto Ricci wrote:
> Executing the `ss` command in a system with kernel 5.19.8, booted with
> the "ipv6.disable=1" parameter, causes this oops:
> 
> 
> [   74.952477] BUG: unable to handle page fault for address: ffffffffffffffc8
> [   74.952568] #PF: supervisor read access in kernel mode
> [   74.952632] #PF: error_code(0x0000) - not-present page
> [   74.952695] PGD 25814067 P4D 25814067 PUD 25816067 PMD 0
> [   74.952770] Oops: 0000 [#1] PREEMPT SMP PTI
> [   74.952816] CPU: 0 PID: 704 Comm: ss Not tainted 5.19.8_1 #1
> [   74.952869] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
> WARNING! Modules path isn't set, but is needed to parse this symbol
> [   74.953292] RIP: 0010:raw_diag_dump+0xea/0x1d0 raw_diag
[...]
> [   74.954188] Call Trace:
> [   74.954221]  <TASK>
> [   74.954248] __inet_diag_dump (net/ipv4/inet_diag.c:1179) 
> [   74.954462] netlink_dump (net/netlink/af_netlink.c:2276) 
> [   74.954549] __netlink_dump_start (net/netlink/af_netlink.c:2380) 
> [   74.954613] inet_diag_handler_cmd (net/ipv4/inet_diag.c:1347) 
> [   74.954672] ? inet_diag_dump_start_compat (net/ipv4/inet_diag.c:1244) 
> [   74.954725] ? inet_diag_dump_compat (net/ipv4/inet_diag.c:1197) 
> [   74.954768] ? inet_diag_unregister (net/ipv4/inet_diag.c:1254) 
> [   74.954811] sock_diag_rcv_msg (net/core/sock_diag.c:235 net/core/sock_diag.c:266) 
> [   74.954905] ? sock_diag_bind (net/core/sock_diag.c:247) 
> [   74.954950] netlink_rcv_skb (net/netlink/af_netlink.c:2501) 
> [   74.954993] sock_diag_rcv (net/core/sock_diag.c:278) 
> [   74.955032] netlink_unicast (net/netlink/af_netlink.c:1320 net/netlink/af_netlink.c:1345) 
> [   74.955074] netlink_sendmsg (net/netlink/af_netlink.c:1921) 
> [   74.955116] sock_sendmsg (net/socket.c:714 net/socket.c:734) 
> [   74.955199] ____sys_sendmsg (net/socket.c:2488) 
> [   74.955245] ? import_iovec (lib/iov_iter.c:2008) 
> [   74.955302] ? sendmsg_copy_msghdr (net/socket.c:2429 net/socket.c:2519) 
> [   74.955348] ___sys_sendmsg (net/socket.c:2544) 
> [   74.955447] ? __schedule (kernel/sched/core.c:6476) 
> [   74.955522] ? _raw_spin_unlock_irqrestore (./arch/x86/include/asm/preempt.h:103 ./include/linux/spinlock_api_smp.h:152 kernel/locking/spinlock.c:194) 
> [   74.955583] ? do_notify_parent_cldstop (kernel/signal.c:2191) 
> [   74.955656] ? preempt_count_add (./include/linux/ftrace.h:910 kernel/sched/core.c:5598 kernel/sched/core.c:5595 kernel/sched/core.c:5623) 
> [   74.955712] ? _raw_spin_lock_irq (./arch/x86/include/asm/atomic.h:202 ./include/linux/atomic/atomic-instrumented.h:543 ./include/asm-generic/qspinlock.h:111 ./include/linux/spinlock.h:185 ./include/linux/spinlock_api_smp.h:120 kernel/locking/spinlock.c:170) 
> [   74.955752] ? ptrace_stop.part.0 (kernel/signal.c:2331) 
> [   74.955795] __sys_sendmsg (./include/linux/file.h:31 net/socket.c:2573) 
> [   74.955835] do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80) 
> [   74.955914] ? syscall_exit_to_user_mode (./arch/x86/include/asm/jump_label.h:55 ./arch/x86/include/asm/nospec-branch.h:382 ./arch/x86/include/asm/entry-common.h:94 kernel/entry/common.c:133 kernel/entry/common.c:296) 
> [   74.955965] ? do_syscall_64 (arch/x86/entry/common.c:87) 
> [   74.957786] ? do_syscall_64 (arch/x86/entry/common.c:87) 
> [   74.959896] ? handle_mm_fault (mm/memory.c:5144) 
> [   74.961184] ? do_user_addr_fault (arch/x86/mm/fault.c:1422) 
> [   74.962609] ? fpregs_assert_state_consistent (arch/x86/kernel/fpu/context.h:39 arch/x86/kernel/fpu/core.c:772) 
> [   74.964171] ? exit_to_user_mode_prepare (./arch/x86/include/asm/entry-common.h:57 kernel/entry/common.c:203) 
> [   74.965968] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120) 
> [   74.967266] RIP: 0033:0x7f66aac577d3

[...]

> I reproduced this with Void Linux x86_64 in a virtual machine. The kernels are
> those provided by the distribution (Void uses vanilla kernels, I don't believe
> these very small patches make any difference
> https://github.com/void-linux/void-packages/tree/0a87c670f35e01a3ac1d850f628fe1bab5d3c433/srcpkgs/linux5.19/patches).
> 
> Kernels 5.19.8 and 5.18.19 are affected, 5.16.20 is not.
> I don't know about 5.17.x because Void doesn't package it.
> The iproute2 version is 5.16.0 (but this also happens with 5.19.0).

This is most likely caused by commit 0daf07e52709 ("raw: convert raw
sockets to RCU") which is being back ported to stable kernels.

It made the initialization of 'raw_v6_hashinfo' conditional on IPv6
being enabled. Can you try the following patch (works on my end)?

diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 19732b5dce23..d40b7d60e00e 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -1072,13 +1072,13 @@ static int __init inet6_init(void)
 	for (r = &inetsw6[0]; r < &inetsw6[SOCK_MAX]; ++r)
 		INIT_LIST_HEAD(r);
 
+	raw_hashinfo_init(&raw_v6_hashinfo);
+
 	if (disable_ipv6_mod) {
 		pr_info("Loaded, but administratively disabled, reboot required to enable\n");
 		goto out;
 	}
 
-	raw_hashinfo_init(&raw_v6_hashinfo);
-
 	err = proto_register(&tcpv6_prot, 1);
 	if (err)
 		goto out;

Another approach is the following, but I prefer the first:

diff --git a/net/ipv4/raw_diag.c b/net/ipv4/raw_diag.c
index 999321834b94..4fbdd69a2be8 100644
--- a/net/ipv4/raw_diag.c
+++ b/net/ipv4/raw_diag.c
@@ -20,7 +20,7 @@ raw_get_hashinfo(const struct inet_diag_req_v2 *r)
 	if (r->sdiag_family == AF_INET) {
 		return &raw_v4_hashinfo;
 #if IS_ENABLED(CONFIG_IPV6)
-	} else if (r->sdiag_family == AF_INET6) {
+	} else if (r->sdiag_family == AF_INET6 && ipv6_mod_enabled()) {
 		return &raw_v6_hashinfo;
 #endif
 	} else {

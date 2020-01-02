Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C490412E6AA
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 14:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728376AbgABNYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 08:24:03 -0500
Received: from mx2.suse.de ([195.135.220.15]:57440 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728323AbgABNYB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jan 2020 08:24:01 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C5EFDB24A;
        Thu,  2 Jan 2020 13:23:58 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 22CF5E0095; Thu,  2 Jan 2020 14:23:58 +0100 (CET)
Date:   Thu, 2 Jan 2020 14:23:58 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Firo Yang <firo.yang@suse.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        rcu@vger.kernel.org, lkft-triage@lists.linaro.org
Subject: Re: stable-rc-4.19.93-rc1/4e040169e8b7 : kernel panic RIP:
 0010:__inet_lookup_listener
Message-ID: <20200102132358.GD22327@unicorn.suse.cz>
References: <CA+G9fYv3=oJSFodFp4wwF7G7_g5FWYRYbc4F0AMU6jyfLT689A@mail.gmail.com>
 <20200102092611.GB22327@unicorn.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200102092611.GB22327@unicorn.suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 02, 2020 at 10:26:11AM +0100, Michal Kubecek wrote:
> On Thu, Jan 02, 2020 at 12:24:35PM +0530, Naresh Kamboju wrote:
> > Results from Linaro’s test farm.
> > Regressions on arm64, arm, x86_64, and i386.
> > 
> > While running LTP syscalls accept* test cases on stable-rc-4.19 branch kernel.
> > This report log extracted from qemu_x86_64.
> > 
> > metadata:
> >   git branch: linux-4.19.y
> >   git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> >   git commit: 4e040169e8b7f4e1c50ceb0f6596015ecc67a052
> >   git describe: v4.19.92-112-g4e040169e8b7
> >   make_kernelversion: 4.19.93-rc1
> >   kernel-config:
> > http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/intel-corei7-64/lkft/linux-stable-rc-4.19/396/config
> > 
> > Crash log,
> > 
> > BUG: unable to handle kernel paging request at 0000000040000001
> > [   23.578222] PGD 138f25067 P4D 138f25067 PUD 0
> > er run is 0h 15m[   23.578222] Oops: 0000 [#1] SMP NOPTI
> > [   23.578222] CPU: 1 PID: 2216 Comm: accept02 Not tainted 4.19.93-rc1 #1
> > [   23.578222] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> > BIOS 1.12.0-1 04/01/2014
> > [   23.578222] RIP: 0010:__inet_lookup_listener+0x12d/0x300
> >  00s
> > [ts t_buffe r 23.578222] Code: 18 48 85 db 0f 84 fe 00 00 00 48 83 eb
> > 68 0f 84 f4 00 00 00 0f b7 75 d0 44 8b 55 10 45 89 f1 45 31 ff 31 c0
> > 45 89 de 89 75 b0 <4c> 3b 63 30 75 43 66 44 3b 6b 0e 75 3c 0f b6 73 13
> > 40 f6 c6 20 75
> > [   23.578222] RSP: 0018:ffff9e0dbba83c38 EFLAGS: 00010206
> > [   23.578222] RAX: ffff9e0db6ff8a80 RBX: 000000003fffffd1 RCX: 0000000000000000
> > [   23.578222] RDX: 0000000000000006 RSI: 0000000000000000 RDI: 00000000ffffffff
> > [   23.578222] RBP: ffff9e0dbba83c88 R08: 000000000100007f R09: 0000000000000000
> > [   23.578222] R10: 000000000100007f R11: 0000000000000000 R12: ffffffffbeb2fe40
> > [   23.578222] R13: 000000000000d59f R14: 0000000000000000 R15: 0000000000000006
> > [   23.578222] FS:  00007fbb30e57700(0000) GS:ffff9e0dbba80000(0000)
> > knlGS:0000000000000000
> > [   23.578222] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [   23.578222] CR2: 0000000040000001 CR3: 000000013276c000 CR4: 00000000003406e0
> > [   23.578222] Call Trace:
> > [   23.578222]  <IRQ>
> > [   23.578222]  tcp_v4_rcv+0x4fe/0xc80
> > [   23.578222]  ip_local_deliver_finish+0xaf/0x390
> > [   23.578222]  ip_local_deliver+0x1a1/0x200
> > [   23.578222]  ? ip_sublist_rcv+0x420/0x420
> > [   23.578222]  ip_rcv_finish+0x88/0xd0
> > s.c:55: INFO: Te[   23.578222]  ip_rcv+0x142/0x200
> > [   23.578222]  ? ip_rcv_finish_core.isra.18+0x4e0/0x4e0
> > st is[ us ing guar  23.578222]  ? process_backlog+0x6d/0x230
> > [   23.578222]  __netif_receive_skb_one_core+0x57/0x80
> > ded [bu ffe rs
> >  ac2c3.578222]  __netif_receive_skb+0x18/0x60
> > [   23.578222]  process_backlog+0xd4/0x230
> > [   23.578222]  net_rx_action+0x13e/0x420
> > [   23.578222]  ? __do_softirq+0x9b/0x426
> > [   23.578222]  __do_softirq+0xc7/0x426
> > [   23.578222]  ? ip_finish_output2+0x255/0x660
> > [   23.578222]  do_softirq_own_stack+0x2a/0x40
> > [   23.578222]  </IRQ>
> > [   23.578222]  do_softirq.part.19+0x4d/0x60
> > [   23.578222]  __local_bh_enable_ip+0xd9/0xf0
> > [   23.578222]  ip_finish_output2+0x27e/0x660
> > [   23.578222]  ip_finish_output+0x235/0x370
> > [   23.578222]  ? ip_finish_output+0x235/0x370
> > [   23.578222]  ip_output+0x76/0x250
> > [   23.578222]  ? ip_fragment.constprop.50+0x80/0x80
> > [   23.578222]  ip_local_out+0x3f/0x70
> > [   23.578222]  __ip_queue_xmit+0x1ea/0x5f0
> > [   23.578222]  ? __lock_is_held+0x5a/0xa0
> > [   23.578222]  ip_queue_xmit+0x10/0x20
> > [   23.578222]  __tcp_transmit_skb+0x57c/0xb60
> > [   23.578222]  tcp_connect+0xccd/0x1030
> > [   23.578222]  tcp_v4_connect+0x515/0x550
> > [   23.578222]  __inet_stream_connect+0x249/0x390
> > [   23.578222]  ? __local_bh_enable_ip+0x7f/0xf0
> > [   23.578222]  inet_stream_connect+0x3b/0x60
> > [   23.578222]  __sys_connect+0xa3/0x120
> > [   23.578222]  ? kfree+0x203/0x240
> > [   23.578222]  ? syscall_trace_enter+0x1e3/0x350
> > [   23.578222]  ? trace_hardirqs_off_caller+0x22/0xf0
> > [   23.578222]  ? do_syscall_64+0x17/0x1a0
> > [   23.578222]  ? lockdep_hardirqs_on+0xef/0x180
> > [   23.578222]  ? do_syscall_64+0x17/0x1a0
> > [   23.578222]  __x64_sys_connect+0x1a/0x20
> > [   23.578222]  do_syscall_64+0x55/0x1a0
> > [   23.578222]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > [   23.578222] RIP: 0033:0x7fbb31a1c927
> > [   23.578222] Code: 44 00 00 41 54 41 89 d4 55 48 89 f5 53 89 fb 48
> > 83 ec 10 e8 0b f9 ff ff 44 89 e2 48 89 ee 89 df 41 89 c0 b8 2a 00 00
> > 00 0f 05 <48> 3d 00 f0 ff ff 77 33 44 89 c7 89 44 24 0c e8 45 f9 ff ff
> > 8b 44
> 
> In __inet_lookup_listener(), we need to replace
> 
> 	sk_for_each_rcu(sk, &ilb->head) 
> 
> by
> 
> 	sk_nulls_for_each_rcu(sk2, node, &ilb->nulls_head)
> 
> This loop was eliminated in mainline 5.0-rc1 by commit d9fbc7f6431f
> ("net: tcp: prefer listeners bound to an address"). I'll have to check
> if there are more places in stable-4.14 and stable-4.19 which also need
> to be updated.

There is the same issue in inet6_lookup_listener(). So the follow-up fix
should look like below. I still should check stable-4.14 and stable-4.9
and also find out why IPv6 lookup used sk_for_each() and IPv4 lookup
needed sk_for_each_rcu().

Sasha/Greg: would you prefer updated backport or a separate follow-up
fix? (The backport is not in git yet, AFAICS.)

Michal


diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 900756b3defb..b53da2691adb 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -308,6 +308,7 @@ struct sock *__inet_lookup_listener(struct net *net,
 	bool exact_dif = inet_exact_dif_match(net, skb);
 	struct inet_listen_hashbucket *ilb2;
 	struct sock *sk, *result = NULL;
+	struct hlist_nulls_node *node;
 	int score, hiscore = 0;
 	unsigned int hash2;
 	u32 phash = 0;
@@ -343,7 +344,7 @@ struct sock *__inet_lookup_listener(struct net *net,
 	goto done;
 
 port_lookup:
-	sk_for_each_rcu(sk, &ilb->head) {
+	sk_nulls_for_each_rcu(sk, node, &ilb->nulls_head) {
 		score = compute_score(sk, net, hnum, daddr,
 				      dif, sdif, exact_dif);
 		if (score > hiscore) {
diff --git a/net/ipv6/inet6_hashtables.c b/net/ipv6/inet6_hashtables.c
index 91d6ea937ffb..d9e2575dad94 100644
--- a/net/ipv6/inet6_hashtables.c
+++ b/net/ipv6/inet6_hashtables.c
@@ -171,6 +171,7 @@ struct sock *inet6_lookup_listener(struct net *net,
 	bool exact_dif = inet6_exact_dif_match(net, skb);
 	struct inet_listen_hashbucket *ilb2;
 	struct sock *sk, *result = NULL;
+	struct hlist_nulls_node *node;
 	int score, hiscore = 0;
 	unsigned int hash2;
 	u32 phash = 0;
@@ -206,7 +207,7 @@ struct sock *inet6_lookup_listener(struct net *net,
 	goto done;
 
 port_lookup:
-	sk_for_each(sk, &ilb->head) {
+	sk_nulls_for_each(sk, node, &ilb->nulls_head) {
 		score = compute_score(sk, net, hnum, daddr, dif, sdif, exact_dif);
 		if (score > hiscore) {
 			if (sk->sk_reuseport) {

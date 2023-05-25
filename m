Return-Path: <netdev+bounces-5272-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 450B771082E
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 10:59:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EBF892811BA
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 08:59:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 464BDD300;
	Thu, 25 May 2023 08:59:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA33849C
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 08:59:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D2398
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 01:59:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685005155;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jPXW1KdbrSs0dMckNiomRMjJwvr95CqztuTR5+p1fwA=;
	b=a2jzG0p2oRbPqeMGbRI2S459HDI56t1gdFjkNqKnthy46b4YBaUoC37VV5oAD80BhfGShb
	SCQpaYfQeKvwvwuGofO4153zNtEEisXtuHGYC+tXr/UHIujtzG9wpFpnJkKqdCBTpFXPvl
	sbu2JRPx4OkKQiDkpVkrNv5HcfKmcIc=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-76-NXig8K8cM5KaZjJccAYXpw-1; Thu, 25 May 2023 04:59:14 -0400
X-MC-Unique: NXig8K8cM5KaZjJccAYXpw-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-625891d5ad5so4029896d6.0
        for <netdev@vger.kernel.org>; Thu, 25 May 2023 01:59:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685005154; x=1687597154;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jPXW1KdbrSs0dMckNiomRMjJwvr95CqztuTR5+p1fwA=;
        b=iVpEC4LQieiKgU6jSMTtsuylDcCRoUXaodE4TBOLaW9SPGbmk3Lrvt3rVlfh7LEfEh
         T7ymW/OzwcuDtyK742RpMgvRNSNmZAZZzCsZeQpgyoIjn1A36eWxI2jpDJp1WCdYLvYS
         uvA+XmMLGmqS/SpBOsnFyce4qGrt8Bnfv1nfYFUdPlxv1i9f1pCnfslrx9BgKKpMBxSg
         HTj2VwCZs2rcee/4mh/me/tXwxiwJ7BlowUDLDd4v8zlulXCXIAkVaF8DQjI6O5lOO7a
         Qvsd+qpiivlJs/O3t5wfleB/l2paCZWJ97tcHkra+46W23PxE8TbUGnGlXjO4jfW7CXG
         QNLg==
X-Gm-Message-State: AC+VfDzcTxZ4CpABr2FLhQKEoK6HGcqwEtSQd2xjCmUvPA8FYJ4G7mWs
	roOefxSFU/3sRff/OijUyz356ybKNUC+kDJjyvyL59KYfAwdaKKu0XIyw1/VWLAikv0LoHpXiVD
	1AlskYUlW1e6yvSui
X-Received: by 2002:a05:620a:2783:b0:75c:a2bb:5e10 with SMTP id g3-20020a05620a278300b0075ca2bb5e10mr598667qkp.0.1685005153796;
        Thu, 25 May 2023 01:59:13 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4/fsN0PSCQKj0ZhL1Dv6Eok+d0lZd1Bk6fQcS04ka19mo2lDvX5d/aWd2mM1fuH/QU+OPTLg==
X-Received: by 2002:a05:620a:2783:b0:75c:a2bb:5e10 with SMTP id g3-20020a05620a278300b0075ca2bb5e10mr598659qkp.0.1685005153406;
        Thu, 25 May 2023 01:59:13 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-242-207.dyn.eolo.it. [146.241.242.207])
        by smtp.gmail.com with ESMTPSA id p9-20020a05620a112900b0075ca4cd03d4sm159474qkk.64.2023.05.25.01.59.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 01:59:13 -0700 (PDT)
Message-ID: <048c84aacfe650e6602c266ff52625798fbcaa62.camel@redhat.com>
Subject: Re: [PATCH v1 net] udplite: Fix NULL pointer dereference in
 __sk_mem_raise_allocated().
From: Paolo Abeni <pabeni@redhat.com>
To: Kuniyuki Iwashima <kuniyu@amazon.com>, "David S. Miller"
	 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	 <kuba@kernel.org>
Cc: Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, 
	syzbot+444ca0907e96f7c5e48b@syzkaller.appspotmail.com
Date: Thu, 25 May 2023 10:59:09 +0200
In-Reply-To: <20230523163305.66466-1-kuniyu@amazon.com>
References: <20230523163305.66466-1-kuniyu@amazon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, 2023-05-23 at 09:33 -0700, Kuniyuki Iwashima wrote:
> syzbot reported [0] a null-ptr-deref in sk_get_rmem0() while using
> IPPROTO_UDPLITE (0x88):
>=20
>   14:25:52 executing program 1:
>   r0 =3D socket$inet6(0xa, 0x80002, 0x88)
>=20
> We had a similar report [1] for probably sk_memory_allocated_add()
> in __sk_mem_raise_allocated(), and commit c915fe13cbaa ("udplite: fix
> NULL pointer dereference") fixed it by setting .memory_allocated for
> udplite_prot and udplitev6_prot.
>=20
> To fix the variant, we need to set either .sysctl_wmem_offset or
> .sysctl_rmem.
>=20
> Now UDP and UDPLITE share the same value for .memory_allocated, so we
> use the same .sysctl_wmem_offset for UDP and UDPLITE.
>=20
> [0]:
> general protection fault, probably for non-canonical address 0xdffffc0000=
000000: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> CPU: 0 PID: 6829 Comm: syz-executor.1 Not tainted 6.4.0-rc2-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 04/28/2023
> RIP: 0010:sk_get_rmem0 include/net/sock.h:2907 [inline]
> RIP: 0010:__sk_mem_raise_allocated+0x806/0x17a0 net/core/sock.c:3006
> Code: c1 ea 03 80 3c 02 00 0f 85 23 0f 00 00 48 8b 44 24 08 48 8b 98 38 0=
1 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 da 48 c1 ea 03 <0f> b6 14 02 48=
 89 d8 83 e0 07 83 c0 03 38 d0 0f 8d 6f 0a 00 00 8b
> RSP: 0018:ffffc90005d7f450 EFLAGS: 00010246
> RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffc90004d92000
> RDX: 0000000000000000 RSI: ffffffff88066482 RDI: ffffffff8e2ccbb8
> RBP: ffff8880173f7000 R08: 0000000000000005 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000030000
> R13: 0000000000000001 R14: 0000000000000340 R15: 0000000000000001
> FS:  0000000000000000(0000) GS:ffff8880b9800000(0063) knlGS:00000000f7f1c=
b40
> CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
> CR2: 000000002e82f000 CR3: 0000000034ff0000 CR4: 00000000003506f0
> Call Trace:
>  <TASK>
>  __sk_mem_schedule+0x6c/0xe0 net/core/sock.c:3077
>  udp_rmem_schedule net/ipv4/udp.c:1539 [inline]
>  __udp_enqueue_schedule_skb+0x776/0xb30 net/ipv4/udp.c:1581
>  __udpv6_queue_rcv_skb net/ipv6/udp.c:666 [inline]
>  udpv6_queue_rcv_one_skb+0xc39/0x16c0 net/ipv6/udp.c:775
>  udpv6_queue_rcv_skb+0x194/0xa10 net/ipv6/udp.c:793
>  __udp6_lib_mcast_deliver net/ipv6/udp.c:906 [inline]
>  __udp6_lib_rcv+0x1bda/0x2bd0 net/ipv6/udp.c:1013
>  ip6_protocol_deliver_rcu+0x2e7/0x1250 net/ipv6/ip6_input.c:437
>  ip6_input_finish+0x150/0x2f0 net/ipv6/ip6_input.c:482
>  NF_HOOK include/linux/netfilter.h:303 [inline]
>  NF_HOOK include/linux/netfilter.h:297 [inline]
>  ip6_input+0xa0/0xd0 net/ipv6/ip6_input.c:491
>  ip6_mc_input+0x40b/0xf50 net/ipv6/ip6_input.c:585
>  dst_input include/net/dst.h:468 [inline]
>  ip6_rcv_finish net/ipv6/ip6_input.c:79 [inline]
>  NF_HOOK include/linux/netfilter.h:303 [inline]
>  NF_HOOK include/linux/netfilter.h:297 [inline]
>  ipv6_rcv+0x250/0x380 net/ipv6/ip6_input.c:309
>  __netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5491
>  __netif_receive_skb+0x1f/0x1c0 net/core/dev.c:5605
>  netif_receive_skb_internal net/core/dev.c:5691 [inline]
>  netif_receive_skb+0x133/0x7a0 net/core/dev.c:5750
>  tun_rx_batched+0x4b3/0x7a0 drivers/net/tun.c:1553
>  tun_get_user+0x2452/0x39c0 drivers/net/tun.c:1989
>  tun_chr_write_iter+0xdf/0x200 drivers/net/tun.c:2035
>  call_write_iter include/linux/fs.h:1868 [inline]
>  new_sync_write fs/read_write.c:491 [inline]
>  vfs_write+0x945/0xd50 fs/read_write.c:584
>  ksys_write+0x12b/0x250 fs/read_write.c:637
>  do_syscall_32_irqs_on arch/x86/entry/common.c:112 [inline]
>  __do_fast_syscall_32+0x65/0xf0 arch/x86/entry/common.c:178
>  do_fast_syscall_32+0x33/0x70 arch/x86/entry/common.c:203
>  entry_SYSENTER_compat_after_hwframe+0x70/0x82
> RIP: 0023:0xf7f21579
> Code: b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 0=
0 00 00 00 00 00 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90=
 90 90 90 8d b4 26 00 00 00 00 8d b4 26 00 00 00 00
> RSP: 002b:00000000f7f1c590 EFLAGS: 00000282 ORIG_RAX: 0000000000000004
> RAX: ffffffffffffffda RBX: 00000000000000c8 RCX: 0000000020000040
> RDX: 0000000000000083 RSI: 00000000f734e000 RDI: 0000000000000000
> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000296 R12: 0000000000000000
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>  </TASK>
> Modules linked in:
>=20
> Link: https://lore.kernel.org/netdev/CANaxB-yCk8hhP68L4Q2nFOJht8sqgXGGQO2=
AftpHs0u1xyGG5A@mail.gmail.com/ [1]
> Fixes: 850cbaddb52d ("udp: use it's own memory accounting schema")

Thanks for addressing this issue!

The patch LGTM.=20

Side note: the blamed commit is almost 7y old and the oops should not
that hard to reproduce by a real app using UDP-lite, but only syzkaller
stumbled upon it.

The above looks like a serious hint UDP-lite is not used by anyone
anymore ?!? Perhaps we could consider deprecating and dropping it? It
could simplify the UDP code a bit removing a bunch of conditionals in
fast-path, and that  nowadays would be possibly more relevant?!?

Cheers,

Paolo



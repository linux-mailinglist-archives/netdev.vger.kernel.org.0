Return-Path: <netdev+bounces-6037-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AF7571478F
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 11:59:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3F8721C20990
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 09:59:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE7CD443A;
	Mon, 29 May 2023 09:59:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7D97C
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 09:59:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88224C2
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 02:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685354344;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z+0aRYn94RFlZqZk3a24kJyF5SYL7Gz1AxmNq3eeVgc=;
	b=KB7mhsXzaKtDuddVm0Bj6SRYFVhBljhfZj6jT1ZC7oAnezHIDUM7h1FvlEzmvgX3goDeZs
	oHh6uSjmvJBFBFLSZ5uyGZcrs+LmQ/8czluWlH/ke99hlcMuHPc6cGSPGpSknXCywnZZKD
	42u3Tk3F7ZZJjJdJgDRQFDJMvAeuMSw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-578-44gKzn3_PqiJlEQMkInF-g-1; Mon, 29 May 2023 05:56:00 -0400
X-MC-Unique: 44gKzn3_PqiJlEQMkInF-g-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3f602cec801so4737365e9.1
        for <netdev@vger.kernel.org>; Mon, 29 May 2023 02:56:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685354159; x=1687946159;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z+0aRYn94RFlZqZk3a24kJyF5SYL7Gz1AxmNq3eeVgc=;
        b=XQoaW5Su9g00fO5PLGmWZV7wwMWP8sW/Hd+FwvN50cmzuxg/tTujOtZCWkjmW3BHvd
         VbW/Jl6Z4Wxd7hHSX82fhCGQhzmXsUdTvN5KC0jHu3kQmclF4ySWyQSOWmIGYjN+m7zc
         EmBWyMedwVSs2GBuR1HG2R+iZIprDYfCQ++2u+jx9L7iQXe4WodFJ5JT17R+dudYxN9y
         1xq/wl69l9ek9Kby+P2KY5KA59TpnBrg5LR5b+h61xFWvAwIHvmrbEq13wqEZqY0yPeo
         hkSR4Cy3OPfSUsMgkizVf+iWPPZCXSIf+B1i/vHJ751eNHNVmZ9ryKxKWkWBOKSLlMX2
         Qipw==
X-Gm-Message-State: AC+VfDxq0uQshiBvXWo6+DRbtIWeJjq14tIzaKtkFzzBcKg5xA/zi8Ju
	85n2P8DgFYwD+/vUOjwNnDGJ97e6A8P3ItyMot/G+KL/ebWJ7G+jKjkWBzP23yDjOeNfd1uHWLQ
	SZelAr450lJPj/K6YmNJkMiZu
X-Received: by 2002:a05:600c:5103:b0:3f6:602:97af with SMTP id o3-20020a05600c510300b003f6060297afmr9364542wms.3.1685354159326;
        Mon, 29 May 2023 02:55:59 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7C2EPn+CSRwoWj5bxJe6h2de8IFuaYOuVjn1m06OMzbdIOz3H34ihc/JqI9nVlUV/HVfN5/Q==
X-Received: by 2002:a05:600c:5103:b0:3f6:602:97af with SMTP id o3-20020a05600c510300b003f6060297afmr9364532wms.3.1685354159041;
        Mon, 29 May 2023 02:55:59 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-250-180.dyn.eolo.it. [146.241.250.180])
        by smtp.gmail.com with ESMTPSA id n5-20020a5d51c5000000b003064088a94fsm13132955wrv.16.2023.05.29.02.55.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 02:55:58 -0700 (PDT)
Message-ID: <77e15fb62e33ed7cb4577deb4b0df24ee2074997.camel@redhat.com>
Subject: Re: [PATCH net] tcp: deny tcp_disconnect() when threads are waiting
From: Paolo Abeni <pabeni@redhat.com>
To: Eric Dumazet <edumazet@google.com>, "David S . Miller"
 <davem@davemloft.net>,  Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, eric.dumazet@gmail.com, syzbot
	 <syzkaller@googlegroups.com>
Date: Mon, 29 May 2023 11:55:55 +0200
In-Reply-To: <20230526163458.2880232-1-edumazet@google.com>
References: <20230526163458.2880232-1-edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, 2023-05-26 at 16:34 +0000, Eric Dumazet wrote:
> Historically connect(AF_UNSPEC) has been abused by syzkaller
> and other fuzzers to trigger various bugs.
>=20
> A recent one triggers a divide-by-zero [1], and Paolo Abeni
> was able to diagnose the issue.
>=20
> tcp_recvmsg_locked() has tests about sk_state being not TCP_LISTEN
> and TCP REPAIR mode being not used.
>=20
> Then later if socket lock is released in sk_wait_data(),
> another thread can call connect(AF_UNSPEC), then make this
> socket a TCP listener.
>=20
> When recvmsg() is resumed, it can eventually call tcp_cleanup_rbuf()
> and attempt a divide by 0 in tcp_rcv_space_adjust() [1]
>=20
> This patch adds a new socket field, counting number of threads
> blocked in sk_wait_event() and inet_wait_for_connect().
>=20
> If this counter is not zero, tcp_disconnect() returns an error.
>=20
> This patch adds code in blocking socket system calls, thus should
> not hurt performance of non blocking ones.
>=20
> Note that we probably could revert commit 499350a5a6e7 ("tcp:
> initialize rcv_mss to TCP_MIN_MSS instead of 0") to restore
> original tcpi_rcv_mss meaning (was 0 if no payload was ever
> received on a socket)
>=20
> [1]
> divide error: 0000 [#1] PREEMPT SMP KASAN
> CPU: 0 PID: 13832 Comm: syz-executor.5 Not tainted 6.3.0-rc4-syzkaller-00=
224-g00c7b5f4ddc5 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 03/02/2023
> RIP: 0010:tcp_rcv_space_adjust+0x36e/0x9d0 net/ipv4/tcp_input.c:740
> Code: 00 00 00 00 fc ff df 4c 89 64 24 48 8b 44 24 04 44 89 f9 41 81 c7 8=
0 03 00 00 c1 e1 04 44 29 f0 48 63 c9 48 01 e9 48 0f af c1 <49> f7 f6 48 8d=
 04 41 48 89 44 24 40 48 8b 44 24 30 48 c1 e8 03 48
> RSP: 0018:ffffc900033af660 EFLAGS: 00010206
> RAX: 4a66b76cbade2c48 RBX: ffff888076640cc0 RCX: 00000000c334e4ac
> RDX: 0000000000000000 RSI: dffffc0000000000 RDI: 0000000000000001
> RBP: 00000000c324e86c R08: 0000000000000001 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: ffff8880766417f8
> R13: ffff888028fbb980 R14: 0000000000000000 R15: 0000000000010344
> FS: 00007f5bffbfe700(0000) GS:ffff8880b9800000(0000) knlGS:00000000000000=
00
> CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b32f25000 CR3: 000000007ced0000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
> <TASK>
> tcp_recvmsg_locked+0x100e/0x22e0 net/ipv4/tcp.c:2616
> tcp_recvmsg+0x117/0x620 net/ipv4/tcp.c:2681
> inet6_recvmsg+0x114/0x640 net/ipv6/af_inet6.c:670
> sock_recvmsg_nosec net/socket.c:1017 [inline]
> sock_recvmsg+0xe2/0x160 net/socket.c:1038
> ____sys_recvmsg+0x210/0x5a0 net/socket.c:2720
> ___sys_recvmsg+0xf2/0x180 net/socket.c:2762
> do_recvmmsg+0x25e/0x6e0 net/socket.c:2856
> __sys_recvmmsg net/socket.c:2935 [inline]
> __do_sys_recvmmsg net/socket.c:2958 [inline]
> __se_sys_recvmmsg net/socket.c:2951 [inline]
> __x64_sys_recvmmsg+0x20f/0x260 net/socket.c:2951
> do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
> entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7f5c0108c0f9
> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 19 00 00 90 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f5bffbfe168 EFLAGS: 00000246 ORIG_RAX: 000000000000012b
> RAX: ffffffffffffffda RBX: 00007f5c011ac050 RCX: 00007f5c0108c0f9
> RDX: 0000000000000001 RSI: 0000000020000bc0 RDI: 0000000000000003
> RBP: 00007f5c010e7b39 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000122 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f5c012cfb1f R14: 00007f5bffbfe300 R15: 0000000000022000
> </TASK>
>=20
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Reported-by: Paolo Abeni <pabeni@redhat.com>
> Diagnosed-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Thanks Eric!

FWIW I gave this a spin in my testbed and solves the issue for me.

Tested-by: Paolo Abeni <pabeni@redhat.com>



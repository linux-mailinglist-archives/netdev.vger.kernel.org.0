Return-Path: <netdev+bounces-5509-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AB5A9711F43
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 07:38:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4337E281673
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 05:38:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CF0423CD;
	Fri, 26 May 2023 05:38:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7273823AD
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 05:38:13 +0000 (UTC)
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90DCC19A
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 22:38:10 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-3f5dbd8f677so25305e9.1
        for <netdev@vger.kernel.org>; Thu, 25 May 2023 22:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685079489; x=1687671489;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gDqGly6gT3WfubutGmfynlWAfo02Gd+ncKg6DyXAbjE=;
        b=SoxgmqCnM1HjYtYLrIrMtVuUZd9zBUk/3Tu5KXeoAZfLXcfxoJn1yYbNk+abZrGezi
         TVEPwtr1W3kRxZj14/UZMP3CYiE1+MsARwMv/CGJrTAE0s1+kabgjzspujDzQJxg20v/
         eRciE8miohsuQHq/FsOiap0gg1xhxRvuM2fDXLCr2zcxbn/jzIgj17nVl/zyf5zPkNU8
         413E0OVezyI8I6YHD6YmxsXc5fSmLXIAv7B3lin85FmXuD6rXEJhZ6Nknt3xgTZW8XO7
         VGdOy0jY6i+aIO9EVotZHB8/l9uf6ujSnh6wbD4PHqMAF3iVEo4sZ3YZWXNFRe5VMPS2
         jwdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685079489; x=1687671489;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gDqGly6gT3WfubutGmfynlWAfo02Gd+ncKg6DyXAbjE=;
        b=kKluKdIDa3pcRj9m8fGR4gfFcq6XpM1Pl+vAPoItSyDlaqL6ANiw/dKxTjxBxy9npT
         EKMctp5bI2ZW8I0rhq2Q6RgYqNSvXBW7dTHNkb5WUYpgGC2c3QZlKrdjmlhg86k+DAVG
         R/8omcy/Bauibm/bUnVMyIPS/APthhofZxyGpJrTSdurmoJCsvkhg9QAZ8A7300qGCZ1
         YGx6geoa2IhFggAdq8MJUUoUMF1AqVWP1mxVWSD9WoAzHP633jJ4DSuoR+Xxb31eVCF6
         IXO+vn4IWk/o4lTwoiKR4coHAzamvdbZ3S9Rw7PdT9DPngCK0ndz9xWffHOkpTnVyVS6
         +cyQ==
X-Gm-Message-State: AC+VfDxafcJdjJvdlViOZiKsBO85ekgaPfyZXA81zRk/x6eogBTqQpEr
	WGGmlbmTAiTfO1bmARRRSbGZuwahfI5uYmhA6k7vjw==
X-Google-Smtp-Source: ACHHUZ6ocLdBjcm2nixIBGfXT5yS7vhpfoDJIl1NrBqCBSoHQhcwtHOY74V1OKg/2fKlraJerCXy7P4OBlDILl9W6u0=
X-Received: by 2002:a05:600c:3c93:b0:3f4:2594:118a with SMTP id
 bg19-20020a05600c3c9300b003f42594118amr24337wmb.2.1685079488823; Thu, 25 May
 2023 22:38:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230524232934.50950-1-kuniyu@amazon.com>
In-Reply-To: <20230524232934.50950-1-kuniyu@amazon.com>
From: Eric Dumazet <edumazet@google.com>
Date: Fri, 26 May 2023 07:37:56 +0200
Message-ID: <CANn89iJGhD_85-OJoOhmoSJ96yYMu5875AUCFwj=hSq9f6e+QA@mail.gmail.com>
Subject: Re: [PATCH v1 net] af_packet: Fix data-races of pkt_sk(sk)->num.
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
	Pavel Emelyanov <xemul@parallels.com>, Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, 
	syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,
	USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 25, 2023 at 1:30=E2=80=AFAM Kuniyuki Iwashima <kuniyu@amazon.co=
m> wrote:
>
> syzkaller found a data race of pkt_sk(sk)->num.
>
> The value is changed under lock_sock() and po->bind_lock, so we
> need READ_ONCE() to access pkt_sk(sk)->num without these locks in
> packet_bind_spkt(), packet_bind(), and sk_diag_fill().
>
> Note that WRITE_ONCE() is already added by commit c7d2ef5dd4b0
> ("net/packet: annotate accesses to po->bind").
>
> BUG: KCSAN: data-race in packet_bind / packet_do_bind
>
> write (marked) to 0xffff88802ffd1cee of 2 bytes by task 7322 on cpu 0:
>  packet_do_bind+0x446/0x640 net/packet/af_packet.c:3236
>  packet_bind+0x99/0xe0 net/packet/af_packet.c:3321
>  __sys_bind+0x19b/0x1e0 net/socket.c:1803
>  __do_sys_bind net/socket.c:1814 [inline]
>  __se_sys_bind net/socket.c:1812 [inline]
>  __x64_sys_bind+0x40/0x50 net/socket.c:1812
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x3b/0x90 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x72/0xdc
>
> read to 0xffff88802ffd1cee of 2 bytes by task 7318 on cpu 1:
>  packet_bind+0xbf/0xe0 net/packet/af_packet.c:3322
>  __sys_bind+0x19b/0x1e0 net/socket.c:1803
>  __do_sys_bind net/socket.c:1814 [inline]
>  __se_sys_bind net/socket.c:1812 [inline]
>  __x64_sys_bind+0x40/0x50 net/socket.c:1812
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x3b/0x90 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x72/0xdc
>
> value changed: 0x0300 -> 0x0000
>
> Reported by Kernel Concurrency Sanitizer on:
> CPU: 1 PID: 7318 Comm: syz-executor.4 Not tainted 6.3.0-13380-g7fddb5b530=
0c #4
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-=
gd239552ce722-prebuilt.qemu.org 04/01/2014
>
> Fixes: 96ec6327144e ("packet: Diag core and basic socket info dumping")
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: syzkaller <syzkaller@googlegroups.com>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
>  net/packet/af_packet.c | 4 ++--
>  net/packet/diag.c      | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index 94c6a1ffa459..a1f9a0e9f3c8 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -3299,7 +3299,7 @@ static int packet_bind_spkt(struct socket *sock, st=
ruct sockaddr *uaddr,
>         memcpy(name, uaddr->sa_data, sizeof(uaddr->sa_data_min));
>         name[sizeof(uaddr->sa_data_min)] =3D 0;
>
> -       return packet_do_bind(sk, name, 0, pkt_sk(sk)->num);
> +       return packet_do_bind(sk, name, 0, READ_ONCE(pkt_sk(sk)->num));
>  }
>
>  static int packet_bind(struct socket *sock, struct sockaddr *uaddr, int =
addr_len)
> @@ -3317,7 +3317,7 @@ static int packet_bind(struct socket *sock, struct =
sockaddr *uaddr, int addr_len
>                 return -EINVAL;
>
>         return packet_do_bind(sk, NULL, sll->sll_ifindex,
> -                             sll->sll_protocol ? : pkt_sk(sk)->num);
> +                             sll->sll_protocol ? : READ_ONCE(pkt_sk(sk)-=
>num));
>  }
>

Sorry for being late to the party.

Your change is still racy, and your two READ_ONCE()  hide the races.

READ_ONCE() makes sense for readers, not so much in bind() really,
this is quite confusing. (Like using rcu_read_lock() in writers is often
the sign of a misunderstanding of RCU principles)

I will send the following patch.

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index a1f9a0e9f3c8a72e5a95f96473b7b6c63f893935..a2dbeb264f260e5b8923ece9aac=
99fe19ddfeb62
100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -3201,6 +3201,9 @@ static int packet_do_bind(struct sock *sk, const
char *name, int ifindex,

        lock_sock(sk);
        spin_lock(&po->bind_lock);
+       if (!proto)
+               proto =3D po->num;
+
        rcu_read_lock();

        if (po->fanout) {
@@ -3299,7 +3302,7 @@ static int packet_bind_spkt(struct socket *sock,
struct sockaddr *uaddr,
        memcpy(name, uaddr->sa_data, sizeof(uaddr->sa_data_min));
        name[sizeof(uaddr->sa_data_min)] =3D 0;

-       return packet_do_bind(sk, name, 0, READ_ONCE(pkt_sk(sk)->num));
+       return packet_do_bind(sk, name, 0, 0);
 }

 static int packet_bind(struct socket *sock, struct sockaddr *uaddr,
int addr_len)
@@ -3316,8 +3319,7 @@ static int packet_bind(struct socket *sock,
struct sockaddr *uaddr, int addr_len
        if (sll->sll_family !=3D AF_PACKET)
                return -EINVAL;

-       return packet_do_bind(sk, NULL, sll->sll_ifindex,
-                             sll->sll_protocol ? : READ_ONCE(pkt_sk(sk)->n=
um));
+       return packet_do_bind(sk, NULL, sll->sll_ifindex, sll->sll_protocol=
);
 }

 static struct proto packet_proto =3D {


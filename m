Return-Path: <netdev+bounces-7732-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 75E067214E0
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 07:42:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7FD212815E5
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 05:42:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64F1D2101;
	Sun,  4 Jun 2023 05:42:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 589221FDF
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 05:42:32 +0000 (UTC)
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5880CE
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 22:42:30 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1b18474cbb6so20773435ad.1
        for <netdev@vger.kernel.org>; Sat, 03 Jun 2023 22:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685857350; x=1688449350;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=khBbWmfNplraP1BMDnNXfXcODmLf9hSxgU/a1/nqlFE=;
        b=lilCvV/WL7bQxOEO8F9s2iimkxatn62sqMbtIVfnTA4X4w/iSRx7P2iHh8RLnXxKeP
         DlyVVHaSJ8//6Feo/HErBbz/3XztVSwhVy4p/SWYkfwah6zi5Bnjm3yM0ZPkKJACPwhm
         pOYyFjV2E8Vn24NTqTyC1Ptul52hxYP0rTU85FCumYJbuyA50LCkOKhJCOInSw+3sCV5
         xxlsuGCzeIHOivKJAOt5CDHB2D7OM7YjBFp+UmwTyFnidpurlAIqSHU7xoAD/C7bC85N
         OCczh8Hx4fAgkpA33h1p3nD+0LK14JWvr90r9rg1iSTll08oUPIQ6R5c+d/clVMBqQeN
         KhVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685857350; x=1688449350;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=khBbWmfNplraP1BMDnNXfXcODmLf9hSxgU/a1/nqlFE=;
        b=cEI2WG6xdYIlm6yTVlR3Mn0FWV13x22xQI8WdZjEcir7rmaTmtpPw3J02VGNc8G4s7
         4OtkNV4a1fZYUOTWHGqsRAUQocuYM2DWY4qixu0TMuVFzNklxx96e1Y5ozVfU78D8r5r
         ONiO7aPAttfZP4FMqrDVonsugbG/T0GO+8rFoyOx8xz4GkWnw0IYiLGynTZLmmJOXE/Y
         ZQFQDSwbpHpzHxVzRXLW8moJSNyvLqO7ATTgdPvSe0XwcxTJLaCD19Rzso6k73caLNzE
         CFKeaGXPBnTCwjUAxYNNv4dDQkK6AjVV0HBZ5apXgOpWCavQMuz8qL9ZhpFita5YEFga
         eV2w==
X-Gm-Message-State: AC+VfDxKoaH1y9AxiPhmZK341iu/+JecXg8wQe50TrCGhCWQR/jOkSaV
	dSGQJEDpSgCsU4UpbnFntMQ=
X-Google-Smtp-Source: ACHHUZ7L/1sFXibc3UPBmkmothAnvMyNX9auZmO0c9ZmEUE22lDbrvgb3A+HQPH6kzD5ntMHZxJTMg==
X-Received: by 2002:a17:902:b284:b0:1b0:25ff:a8af with SMTP id u4-20020a170902b28400b001b025ffa8afmr2400627plr.60.1685857350116;
        Sat, 03 Jun 2023 22:42:30 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-23.three.co.id. [180.214.232.23])
        by smtp.gmail.com with ESMTPSA id h10-20020a170902748a00b001b050df0a93sm4042302pll.93.2023.06.03.22.42.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Jun 2023 22:42:29 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 16604106291; Sun,  4 Jun 2023 12:42:25 +0700 (WIB)
Date: Sun, 4 Jun 2023 12:42:25 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Martin Zaharinov <micron10@gmail.com>, netdev <netdev@vger.kernel.org>,
	Eric Dumazet <edumazet@google.com>
Cc: Linux Regressions <regressions@lists.linux.dev>
Subject: Re: Bug Report with kernel 6.3.5
Message-ID: <ZHwkQcouxweYYhTX@debian.me>
References: <20F611B6-2C76-4BD3-852D-8828D27F88EC@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="+6R2FPvIAHCaO6Yh"
Content-Disposition: inline
In-Reply-To: <20F611B6-2C76-4BD3-852D-8828D27F88EC@gmail.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--+6R2FPvIAHCaO6Yh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 04, 2023 at 07:51:36AM +0300, Martin Zaharinov wrote:
> Hi Team one bug report=20
>=20
> after upgrade from kernel 6.2.12 to 6.3.5=20
> After fell hour system get this error.
>=20
> If is possible to check.
>=20
>=20
> Jun  4 01:46:52  [12810.275218][  T587] INFO: task nginx:3977 blocked for=
 more than 609 seconds.
> Jun  4 01:46:52  [12810.275350][  T587]       Tainted: G           O     =
  6.3.5 #1
> Jun  4 01:46:52  [12810.275436][  T587] "echo 0 > /proc/sys/kernel/hung_t=
ask_timeout_secs" disables this message.
> Jun  4 01:46:52  [12810.275527][  T587] task:nginx         state:D stack:=
0     pid:3977  ppid:1      flags:0x00000006
> Jun  4 01:46:52  [12810.275624][  T587] Call Trace:
> Jun  4 01:46:52  [12810.275707][  T587]  <TASK>
> Jun  4 01:46:52  [12810.275786][  T587]  __schedule+0x352/0x820
> Jun  4 01:46:52  [12810.275878][  T587]  schedule_preempt_disabled+0x61/0=
xe0
> Jun  4 01:46:52  [12810.275963][  T587]  __mutex_lock.constprop.0+0x481/0=
x7a0
> Jun  4 01:46:52  [12810.276049][  T587]  ? __lock_sock_fast+0x1a/0xc0
> Jun  4 01:46:52  [12810.276135][  T587]  ? lock_sock_nested+0x1a/0xc0
> Jun  4 01:46:52  [12810.276217][  T587]  ? inode_wait_for_writeback+0x77/=
0xd0
> Jun  4 01:46:52  [12810.276307][  T587]  eventpoll_release_file+0x41/0x90
> Jun  4 01:46:52  [12810.276416][  T587]  __fput+0x1d9/0x240
> Jun  4 01:46:52  [12810.276517][  T587]  task_work_run+0x51/0x80
> Jun  4 01:46:52  [12810.276624][  T587]  exit_to_user_mode_prepare+0x123/=
0x130
> Jun  4 01:46:52  [12810.276732][  T587]  syscall_exit_to_user_mode+0x21/0=
x110
> Jun  4 01:46:52  [12810.276847][  T587]  entry_SYSCALL_64_after_hwframe+0=
x46/0xb0
> Jun  4 01:46:52  [12810.276954][  T587] RIP: 0033:0x15037529155a
> Jun  4 01:46:52  [12810.277056][  T587] RSP: 002b:000015036bbb6400 EFLAGS=
: 00000293 ORIG_RAX: 0000000000000003
> Jun  4 01:46:52  [12810.277185][  T587] RAX: 0000000000000000 RBX: 000015=
036bbb7420 RCX: 000015037529155a
> Jun  4 01:46:52  [12810.277311][  T587] RDX: 0000000000000000 RSI: 000000=
0000000000 RDI: 0000000000000013
> Jun  4 01:46:52  [12810.277440][  T587] RBP: 00001503647343d0 R08: 199999=
9999999999 R09: 0000000000000000
> Jun  4 01:46:52  [12810.277567][  T587] R10: 000015037531baa0 R11: 000000=
0000000293 R12: 0000000000000ba5
> Jun  4 01:46:52  [12810.277693][  T587] R13: 0000150348731f48 R14: 000000=
0000000000 R15: 000000001f5b06b0
> Jun  4 01:46:52  [12810.277820][  T587]  </TASK>
>=20

Can you clearly describe this regression? And your nginx setup? And most
importantly, can you please bisect between v6.2 and v6.3 to find the
culprit? Can you also check the mainline?

Anyway, thanks for the regression report. I'm adding it to regzbot:

#regzbot ^introduced: v6.2.12..v6.3.5
#regzbot title: nginx blocked for more than 10 minutes on 6.3.5

--=20
An old man doll... just what I always wanted! - Clara

--+6R2FPvIAHCaO6Yh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZHwkPAAKCRD2uYlJVVFO
o+sdAP4x5fQ6RZF3mP4J79IO8UzIkpPF4xZAoSzkkNN1JfrXKwEAoq1qBYJL1rNF
HL2VCQi5cl0y6LMRO1hSrzJeOI3ajQg=
=kJ0F
-----END PGP SIGNATURE-----

--+6R2FPvIAHCaO6Yh--


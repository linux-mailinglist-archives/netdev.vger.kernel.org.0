Return-Path: <netdev+bounces-5376-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 473B0710F77
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 17:24:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B944F1C20F08
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 15:24:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23C9118C1E;
	Thu, 25 May 2023 15:24:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15661182C1
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 15:24:24 +0000 (UTC)
Received: from mail-vk1-xa32.google.com (mail-vk1-xa32.google.com [IPv6:2607:f8b0:4864:20::a32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A9F3197
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 08:24:21 -0700 (PDT)
Received: by mail-vk1-xa32.google.com with SMTP id 71dfb90a1353d-456d534f403so471764e0c.2
        for <netdev@vger.kernel.org>; Thu, 25 May 2023 08:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685028260; x=1687620260;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iEjzINfXCNwDMP7Es5CWDWeJTxR6sY25UtxLByijIBQ=;
        b=oM/cNecvMWjnwu6uRVTxCcJz9YB9rW5JCXfe2yr/jFMJLucq47U46IwZSM93iJO+Pz
         eh2p9rDBtdEmniRLhtcGvixnWPFGgAwFUbrbqeNvmw+07QehXdpO/AS4m0EMk2ng1YJp
         T09Dxho1xk1u7RRUaV9fYXkPXn1cM34xZMVAhDWMMaOfZiBJaQ9Y3OxCPpZdzdpLu3qc
         hkA7nKkVCyYytFSCHiH7VJ8kfVnW0JSJUidqZnhP2O4Eux4TrjVWMKg2QKLgrUv4Xouv
         G76HFjwve3DlpnC9AVLNa9yNQafW+nTOIvlxjtbAMVHtdNevQZ54502ShCT/D8d8Z5f7
         fFCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685028260; x=1687620260;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iEjzINfXCNwDMP7Es5CWDWeJTxR6sY25UtxLByijIBQ=;
        b=k4LdMjeG7x4LltnmIQdUk1Y09O4suYs+d8vavQFUxQ8aXpIGSSq17q9lJgO3TOuXX9
         JYhzqar2ys0fRGdzBORxNmjPc20R+bBa1riPdRGmqDgAUkbK/oRgh3HC7pzIg4bOy4WB
         HUjhq7GdgKs6aLyHOdJPZnh8i+DCpnHwtF1BSrCF5LjvMfska6gkyYTqMNzKiNZs/DMb
         MkXyXfcvL9EWfgvD6DLj8EDjrbElULyOVgDXAYn6DJkakQkQvF+3mnPhRMRzWI63ItsM
         Qv33lph8DFzQ68LH35JvlDoozXp0yk7B/GfYL4bkxt/rX3K/6YVATmhGd2ymemwcDkiS
         K90g==
X-Gm-Message-State: AC+VfDwv4WkvaPd9p52qu+0n4Apes6SiqDplft/Sw1VsF40HOXcZvoKf
	4MeKTLKtvaTuVaJ7NSyIRrO76uqZUhWw+nbh5wI=
X-Google-Smtp-Source: ACHHUZ5lBRm6wWCmxUZnS6cxFlJDGKnrdWIKjd3Lz/CGNYcwMIwYeOI2k+Kqlf6v64F5tbKFzMYyto4IG8kIwnRQAeE=
X-Received: by 2002:a1f:5c10:0:b0:44f:eae4:da84 with SMTP id
 q16-20020a1f5c10000000b0044feae4da84mr8175286vkb.5.1685028260124; Thu, 25 May
 2023 08:24:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230524232934.50950-1-kuniyu@amazon.com>
In-Reply-To: <20230524232934.50950-1-kuniyu@amazon.com>
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Thu, 25 May 2023 11:23:43 -0400
Message-ID: <CAF=yD-JcOHDuOHibSJ1JCst_eKc8Qef_SKtVNGf-y+-VR93UVQ@mail.gmail.com>
Subject: Re: [PATCH v1 net] af_packet: Fix data-races of pkt_sk(sk)->num.
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Pavel Emelyanov <xemul@parallels.com>, Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, 
	syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 7:30=E2=80=AFPM Kuniyuki Iwashima <kuniyu@amazon.co=
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

Reviewed-by: Willem de Bruijn <willemb@google.com>


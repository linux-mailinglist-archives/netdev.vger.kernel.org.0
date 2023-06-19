Return-Path: <netdev+bounces-12049-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 77BC5735D0D
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 19:31:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 32E8B2810F6
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 17:31:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86D8D13AF5;
	Mon, 19 Jun 2023 17:31:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A47712B90
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 17:31:49 +0000 (UTC)
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A9671AD
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 10:31:48 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id d75a77b69052e-3ff25ca795eso158401cf.1
        for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 10:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687195907; x=1689787907;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pg4x2wrc/BYDi40teTMJvpNA51aEkrQ/RaoYrLIDS0Y=;
        b=MiTSWTsHM8wnvq9R8AiO3Kv3p+6K1MjfnH55X1y8/Vb15syn1ZrPE9i4t+tYuSmXEV
         a9mkJDNiVE+wt/nWERlEWIGprQ1Cb/7/0qMxMEWPfxvC8sA23T/6o2fszElOnKmQyNb8
         z0Q7FuZzyxVceOuJ7mxa9Grvai5h6f37Rt1DiqJj7RvwnEEwK8kzv9+4KKqD0nZ3JEbH
         0AVPXZRrBuWlLU0ge7gX53dhoY6Jgms4GqP5CWQrYIOGOImyliN2zTxEM3lJejRLCFm2
         Fht/BADb8jx4Rey4rJstDG3n7v4Q1O2f0J1kF9viLgGYz+rSUi0eF/M9pPkgHIag7qXq
         BoiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687195907; x=1689787907;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pg4x2wrc/BYDi40teTMJvpNA51aEkrQ/RaoYrLIDS0Y=;
        b=fPdwONhkTJXKzPFdPtW9/s7pCJUlL8qASzxIDZAigsYYUhEeZUEXI0kZAOKnhDDkcP
         iPz+oc27fMsB5uNhvAhKzod+CTALHkffsOLNuRdNrwwq7nIVnu8ejG4pzVPuP17Tx3lw
         gOtDlQp6yRJLmQ4da2dWfMP8nkwpAH9cEGVVCdIT1q8ghmEJ3VQU406wcmTOuh6rYeWm
         yCmYQlXFyEuQh+Zp4cF4RqbOCGf6y3MNHAJzAUvVOf8gCq6k2whZrL3vdDTqGF/LnNOh
         pze0tCZBkSdjutbjVm548sxdbdADf6r9utjMB79BsliashULm5EnNi9Z/zmdXEXRRgA0
         UMUQ==
X-Gm-Message-State: AC+VfDyYhmUipNyrPea+ZZas7XW7auZB6MD5I7ZEOy2/vWdeu/TLzwwi
	VYgjGHw2hAssWQzxSrsQkkz1Fa1Cbb/KG8vhN+9cbg==
X-Google-Smtp-Source: ACHHUZ7W/aNHplnXCqUxoG1YUUHsaB8stVrjefFKV/BaJW2xdSkNryLEWr/VqqFRA+63WNho9lTPAHwDmyTYuMq+qJw=
X-Received: by 2002:a05:622a:251:b0:3ef:4319:c6c5 with SMTP id
 c17-20020a05622a025100b003ef4319c6c5mr806588qtx.19.1687195906900; Mon, 19 Jun
 2023 10:31:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230619124336.651528-1-edumazet@google.com> <ZJBxrWmScxYvcDGv@nanopsycho>
In-Reply-To: <ZJBxrWmScxYvcDGv@nanopsycho>
From: Eric Dumazet <edumazet@google.com>
Date: Mon, 19 Jun 2023 19:31:35 +0200
Message-ID: <CANn89iL5Mjfs7orwjn+H5P6sqyeAguXkKsAj_svrkMZPNWOrbA@mail.gmail.com>
Subject: Re: [PATCH net-next] net: remove sk_is_ipmr() and sk_is_icmpv6() helpers
To: Jiri Pirko <jiri@resnulli.us>
Cc: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org, eric.dumazet@gmail.com, 
	syzbot <syzkaller@googlegroups.com>, Breno Leitao <leitao@debian.org>, 
	Willem de Bruijn <willemb@google.com>, David Ahern <dsahern@kernel.org>, 
	Kuniyuki Iwashima <kuniyu@amazon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 19, 2023 at 5:18=E2=80=AFPM Jiri Pirko <jiri@resnulli.us> wrote=
:
>
> Mon, Jun 19, 2023 at 02:43:35PM CEST, edumazet@google.com wrote:
> >Blamed commit added these helpers for sake of detecting RAW
> >sockets specific ioctl.
> >
> >syzbot complained about it [1].
> >
> >Issue here is that RAW sockets could pretend there was no need
> >to call ipmr_sk_ioctl()
> >
> >Regardless of inet_sk(sk)->inet_num, we must be prepared
> >for ipmr_ioctl() being called later. This must happen
> >from ipmr_sk_ioctl() context only.
> >
> >We could add a safety check in ipmr_ioctl() at the risk of breaking
> >applications.
> >
> >Instead, remove sk_is_ipmr() and sk_is_icmpv6() because their
> >name would be misleading, once we change their implementation.
>
> Hurts my fingers to write this, but it would be easier to follow the
> patch description and actually undestand what you do with imperative
> mood commanding the codebase, without the "we"nesses. But again,
> nevermind :)

It is not the first time you comment on the style of my changelogs.

I would prefer we spend time elsewhere, we obviously have different
ways of writing in English.

Just my two cents.



>
>
> >
> >[1]
> >BUG: KASAN: stack-out-of-bounds in ipmr_ioctl+0xb12/0xbd0 net/ipv4/ipmr.=
c:1654
> >Read of size 4 at addr ffffc90003aefae4 by task syz-executor105/5004
> >
> >CPU: 0 PID: 5004 Comm: syz-executor105 Not tainted 6.4.0-rc6-syzkaller-0=
1304-gc08afcdcf952 #0
> >Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS =
Google 05/27/2023
> >Call Trace:
> ><TASK>
> >__dump_stack lib/dump_stack.c:88 [inline]
> >dump_stack_lvl+0xd9/0x150 lib/dump_stack.c:106
> >print_address_description.constprop.0+0x2c/0x3c0 mm/kasan/report.c:351
> >print_report mm/kasan/report.c:462 [inline]
> >kasan_report+0x11c/0x130 mm/kasan/report.c:572
> >ipmr_ioctl+0xb12/0xbd0 net/ipv4/ipmr.c:1654
> >raw_ioctl+0x4e/0x1e0 net/ipv4/raw.c:881
> >sock_ioctl_out net/core/sock.c:4186 [inline]
> >sk_ioctl+0x151/0x440 net/core/sock.c:4214
> >inet_ioctl+0x18c/0x380 net/ipv4/af_inet.c:1001
> >sock_do_ioctl+0xcc/0x230 net/socket.c:1189
> >sock_ioctl+0x1f8/0x680 net/socket.c:1306
> >vfs_ioctl fs/ioctl.c:51 [inline]
> >__do_sys_ioctl fs/ioctl.c:870 [inline]
> >__se_sys_ioctl fs/ioctl.c:856 [inline]
> >__x64_sys_ioctl+0x197/0x210 fs/ioctl.c:856
> >do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
> >entry_SYSCALL_64_after_hwframe+0x63/0xcd
> >RIP: 0033:0x7f2944bf6ad9
> >Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 =
f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 f=
f ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> >RSP: 002b:00007ffd8897a028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> >RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f2944bf6ad9
> >RDX: 0000000000000000 RSI: 00000000000089e1 RDI: 0000000000000003
> >RBP: 00007f2944bbac80 R08: 0000000000000000 R09: 0000000000000000
> >R10: 0000000000000000 R11: 0000000000000246 R12: 00007f2944bbad10
> >R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> ></TASK>
> >
> >The buggy address belongs to stack of task syz-executor105/5004
> >and is located at offset 36 in frame:
> >sk_ioctl+0x0/0x440 net/core/sock.c:4172
> >
> >This frame has 2 objects:
> >[32, 36) 'karg'
> >[48, 88) 'buffer'
> >
> >Fixes: e1d001fa5b47 ("net: ioctl: Use kernel memory on protocol ioctl ca=
llbacks")
> >Reported-by: syzbot <syzkaller@googlegroups.com>
> >Signed-off-by: Eric Dumazet <edumazet@google.com>
>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>


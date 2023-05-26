Return-Path: <netdev+bounces-5794-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BB400712C0E
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 19:51:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EEC32281918
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 17:51:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D73DA290F1;
	Fri, 26 May 2023 17:51:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C81C115BD
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 17:51:37 +0000 (UTC)
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31F13C9
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:51:36 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-3f5dbd8f677so4935e9.1
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685123494; x=1687715494;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0D6WbSVOOoLij0lL6DdC5RpcoX/GKI6yMPGw+Ha3zz0=;
        b=cZxEoVnFtH9NiD2VhDbf/zG5cfw9ZLaWOsXjjKtYs86XzN+vd3zszgQ7WFnG2eKSEI
         DJF5CLmQBJSwfyatczR4yjuPOBgHEdAm+mIApIwfppx2GWCMGn4hUIF7kQlIWKIwEaMx
         SplnfaKRSUvk2vFLJfbAgcFsMwhQx6B1yNnVKkbHQGy3w9J4eXr/cfK3/174TAISqCSq
         ltOk5xF0GqI8dB1fzm8vW9S6Vnrm7+0Zb/NXrQG6Pwpbn55SP65CSA1TO7aitwo2o2MO
         2Y7Jj2GM7g2qG+I3TDCt9Zj0IYCHdd94CY/If1Tc2KvvkoBgSs5hyY6/+kn0RujPAM/D
         paKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685123494; x=1687715494;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0D6WbSVOOoLij0lL6DdC5RpcoX/GKI6yMPGw+Ha3zz0=;
        b=erFnJD1nHAOGaBBZTZKqaozZUh0IKL0GJR7ivgWKnfcl0UeJx6O2DQXERKEnaM7hiU
         H6mAdTixfILWCnV6L35K4elo0r4h0IsR6J+xMHtHJ6Dpo6RvBP23DuRlnYZ0pcmtcSBh
         88zXH0B5Bbawe7kxl4lVArjY4ncAomZGchKAFjtovLQ++lg9QpTx+cqY+OBUL3wTEaQA
         q1XXtN7EEziz3o56djOfssF4z6R7AZrCyTrpEo4wFvKOMoYJ0iri3p5Uus7wvLpUMM8L
         qijLJXPABEYfxTPFORoo9XNKC79y/vdfKSf2HcKcU6X2EyvVosnuSw3ztFislUOiIGPl
         OzVQ==
X-Gm-Message-State: AC+VfDyGVicjZ4rPQPYVlotx7faiHNETqEUP7hyhQtMZH3Xy7qO+Fkbm
	q0+jrVF39gIfMBwGfvjbyKeNQFH9kKPoVAquQDwx/Vjr2qsfYGinOvgjEA==
X-Google-Smtp-Source: ACHHUZ6IhMwEkaB0zdwKNKvMcBfOX/4g3Ax2OtcP7PUZLXFQ9EgZFR1g/cuY90EGOgiggyNPl1SF616OYaws6lQFYBY=
X-Received: by 2002:a05:600c:3b0d:b0:3f1:70d1:21a6 with SMTP id
 m13-20020a05600c3b0d00b003f170d121a6mr13262wms.0.1685123494510; Fri, 26 May
 2023 10:51:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANn89iKUbyrJ=r2+_kK+sb2ZSSHifFZ7QkPLDpAtkJ8v4WUumA@mail.gmail.com>
 <CAHk-=whqNMUPbjCyMjyxfH_5-Xass=DrMkPT5ZTJbFrtU=qDEQ@mail.gmail.com>
 <CANn89i+bExb_P6A9ROmwqNgGdO5o8wawVZ5r3MHnz0qfhxvTtA@mail.gmail.com>
 <CAHk-=wig6VizZHtRznz7uAWa-hHWjrCNANZ9B+1G=aTWPiVH4g@mail.gmail.com>
 <CAHk-=whkci5ck5Him8Lx5ECKHEtj=bipYmOCGe8DWrrp8uDq5g@mail.gmail.com>
 <CAHk-=whtDupvWtj_ow11wU4_u=KvifTqno=5mW1VofyehjdVRA@mail.gmail.com>
 <CANn89i+u8jvfSQAQ=_JY0be56deJNhKgDWbqpDAvfm-i34qX9A@mail.gmail.com> <CAHk-=wh16fVwO2yZ4Fx0kyRHsNDhGddzNxfQQz2+x08=CPvk_Q@mail.gmail.com>
In-Reply-To: <CAHk-=wh16fVwO2yZ4Fx0kyRHsNDhGddzNxfQQz2+x08=CPvk_Q@mail.gmail.com>
From: Eric Dumazet <edumazet@google.com>
Date: Fri, 26 May 2023 19:51:22 +0200
Message-ID: <CANn89iJ3=OiZEABRQQLL6z+J-Wy8AvTJz6NPLQDOtzREiiYb4Q@mail.gmail.com>
Subject: Re: x86 copy performance regression
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,
	USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 7:40=E2=80=AFPM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Fri, May 26, 2023 at 10:25=E2=80=AFAM Eric Dumazet <edumazet@google.co=
m> wrote:
> >
> > arch/x86/lib/copy_user_64.S:34:2: error: invalid instruction mnemonic
> > 'alternative'
>
> Ok, that's just odd. For me, assembler mnemonics - very much including
> macros - are case-insensitive.
>
> It's actually documented that way, with the example given is for a
> macro that is declared as "sum" and then used as "SUM":
>
>    https://sourceware.org/binutils/docs/as/Macro.html
>
> And if you want to use macros as pseudo-instructions, that's what you
> want, since typically assembler instructions are not case sensitive.
>
> But yeah, your build environment is clearly different, and yes, we
> declare the macro with all caps, and other places use it that way too.
>
> Clang?

Yes, we use clang here ...

Hmmm

[   25.532236] RIP: 0010:0xffffffffa5a85134
[   25.536173] Code: Unable to access opcode bytes at 0xffffffffa5a8510a.
[   25.542720] RSP: 0000:ffff92f08159bcd8 EFLAGS: 00050206
[   25.547960] RAX: 00007ffc3b16c318 RBX: 0000000000000000 RCX: 00000000000=
00170
[   25.555118] RDX: 0000000000000170 RSI: ffff92f0944d4c28 RDI: 00007ffc3b1=
6c1a8
[   25.562275] RBP: ffff92f08159bce0 R08: fefefefefefefeff R09: 00000000000=
0002c
[   25.569432] R10: 000000000000002c R11: ffff92f0944d5bb0 R12: 00007ffc3b1=
6cff2
[   25.576588] R13: 00007ffc3b16c1a8 R14: 0000000000000001 R15: ffff92f0944=
d4ac0
[   25.583746] FS:  0000000000000000(0000) GS:ffff934e404c0000(0000)
knlGS:0000000000000000
[   25.591862] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   25.597624] CR2: ffffffffa5a8510a CR3: 000000010e33c003 CR4: 00000000003=
706e0
[   25.604780] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[   25.611936] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[   25.619092] Call Trace:
[   25.621545]  <TASK>
[   25.623648]  ? _copy_to_user+0x20/0x30
[   25.627409]  create_elf_tables+0x528/0x5a0
[   25.631520]  load_elf_binary+0x9e7/0xce0
[   25.635453]  bprm_execve+0x2bf/0x5c0
[   25.639040]  kernel_execve+0x2ad/0x2d0
[   25.642799]  run_init_process+0xa9/0xb0
[   25.646648]  ? rest_init+0xc0/0xc0
[   25.650059]  kernel_init+0x82/0x1a0
[   25.653558]  ret_from
_fork+0x1f/0x30
[   25.657145]  </TASK>


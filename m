Return-Path: <netdev+bounces-1865-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8453F6FF5B3
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 17:19:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE2C4281774
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:19:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67A4D642;
	Thu, 11 May 2023 15:19:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531F463B
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 15:19:32 +0000 (UTC)
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E571710
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 08:19:30 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-50bd37ca954so80542380a12.0
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 08:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent.com; s=google; t=1683818369; x=1686410369;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mJpRi8U4anHxP91Og34clDJuvOhSvC/Ny6ZY6fVS6NA=;
        b=TmbsosqpHKsbyV71znStNqd9RFeitV2eXYJsFJpgGLAWKEAdwqfW53ks0v0R3avk2a
         OghVcmxL6fmRRmfoUA4i/6v/wgDgTX0cvj9AUrkOz/zF7mPs0BqHfcVS2hkuwk6XwS/l
         tgMfDkjGR3PYqyeIZy8t1VHU63NOqSI8LZ6E9Z0I7c7m6chu1sFS75o4OdKGtCdxWUy8
         oaGw6twk/jGvsUjdobAivroaAm9uEvUB5AgLXUEtT6Q+Mx6aT+2IUSp37uPhTN+O+//J
         sDyoZFGrkuM56fa5LetP7SulRGvgVJuU++QlN4eWnma9MIYk0XJiH3dWLRUMrxLfbRML
         2kdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683818369; x=1686410369;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mJpRi8U4anHxP91Og34clDJuvOhSvC/Ny6ZY6fVS6NA=;
        b=Pgzvpx7opeSqTddS1BAXD91WL0rRfdc6K8UP2IKitp5G503Tparm3giaPu2eg/B0e7
         Vj8pM11w+/j706MpZV4YZKqg9t0akT1a2kxpLMQ3Nc/EEkjGNjhXD/KwiEofZGw5vAnY
         rbDF2eId9PIYIa2XgmkMp5GajD4MsByAXVFHdbRxYQlDA+7pXJE/XPhEuwBT7yc1DOBg
         nlIdr4mvBj5R/lTpP8MyHi0OEwHAf/Kz2uXosXneN0ll/1ejmyuWWQmrZHJnpCyRVnFu
         SL774kfnG8V7K13pMNLB7JvQJADEPU5azWM48LCcDv6qrgtjM3x552kTa3lUEQ1jVplw
         J9iw==
X-Gm-Message-State: AC+VfDzN8utjgCoSgWJlosyUFJEQbkdSAD6WR6vERBYE42G+H8k6mnz9
	mFYpy9hZ849eRQBLmmFpD4cUXYtPijPEOY5T7tketA==
X-Google-Smtp-Source: ACHHUZ622cGWEkiUpT7RoLmMpy0Uatilmpa5SvU9Xkc1QW1rLBsLFS38+mmhk0wsxGczsQ251uXMbzXui36AgnhTh7U=
X-Received: by 2002:a17:907:8a08:b0:969:2df9:a0dd with SMTP id
 sc8-20020a1709078a0800b009692df9a0ddmr12191725ejc.25.1683818368935; Thu, 11
 May 2023 08:19:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <00000000000019af1d05fb5fdd99@google.com>
In-Reply-To: <00000000000019af1d05fb5fdd99@google.com>
From: Lorenz Bauer <lmb@isovalent.com>
Date: Thu, 11 May 2023 08:19:17 -0700
Message-ID: <CAN+4W8jFTcnS-EBppkoRXmfzUOgiGNwBku69==-b-Z_2fDHfUw@mail.gmail.com>
Subject: Re: [syzbot] [bpf?] KASAN: slab-out-of-bounds Write in copy_array (2)
To: syzbot <syzbot+d742fd7d34097f949179@syzkaller.appspotmail.com>
Cc: andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org, 
	daniel@iogearbox.net, davem@davemloft.net, haoluo@google.com, hawk@kernel.org, 
	john.fastabend@gmail.com, jolsa@kernel.org, kpsingh@kernel.org, 
	kuba@kernel.org, linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	martin.lau@linux.dev, nathan@kernel.org, ndesaulniers@google.com, 
	netdev@vger.kernel.org, sdf@google.com, song@kernel.org, 
	syzkaller-bugs@googlegroups.com, trix@redhat.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 5:14=E2=80=AFPM syzbot
<syzbot+d742fd7d34097f949179@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    950b879b7f02 riscv: Fixup race condition on PG_dcache_cle=
a..
> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/riscv/linux=
.git fixes
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D17eaa0c628000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3Decebece1b90c0=
342
> dashboard link: https://syzkaller.appspot.com/bug?extid=3Dd742fd7d34097f9=
49179
> compiler:       riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110, =
GNU ld (GNU Binutils for Debian) 2.35.2
> userspace arch: riscv64
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/5=
ab53d394dbf/non_bootable_disk-950b879b.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/938475579d6c/vmlinu=
x-950b879b.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/bcf263d8c574/I=
mage-950b879b.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+d742fd7d34097f949179@syzkaller.appspotmail.com

That tree doesn't have the fix yet:
https://git.kernel.org/pub/scm/linux/kernel/git/riscv/linux.git/tree/kernel=
/bpf/verifier.c?h=3Dfixes&id=3D950b879b7f02#n1065

#syz fix: bpf: Always use maximal size for copy_array()


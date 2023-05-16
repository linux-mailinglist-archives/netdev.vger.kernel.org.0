Return-Path: <netdev+bounces-2867-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AB9F7045C6
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 09:08:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B58C51C20D9F
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 07:08:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C419711C9D;
	Tue, 16 May 2023 07:08:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B0623D6
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 07:08:08 +0000 (UTC)
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 127FD18E;
	Tue, 16 May 2023 00:08:07 -0700 (PDT)
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-55a2cb9788dso194718607b3.2;
        Tue, 16 May 2023 00:08:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684220886; x=1686812886;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iTQjfNfGsMfbyHJYnY/d7iucXXNLZgToVmLQABWZsBQ=;
        b=YhXyDSyvdUe4u6/xFM86Ij/xyaP4DXwKIrkULQVAg8AZ0/T2tKz5jHhshthXm4aPt/
         v3NjSAvyjxY4bsnH6K1JAqCUGqhwQSxA3KrdLQYdbLi04fvKoTS/qnMTGCBLZhBwH7DF
         YSj2jHEup9yPLjVqNfAVuzAlQyG4X6z0oqnqENztX5ZlEPl1ikabm0+ZeDMf6J405cMP
         nU3NCiVVPCxI++BPmI2vnJdOhY8QSh3Eg6CxetYfOR80cSf809QjyzK4TnBQbctDFmrB
         Q7zGiLmvZiPcnZtXAFDK/QHlsawjZdqzaPLDgJPHtayOWZs5bYJ37wHIUxL3ob0X0iPU
         BDog==
X-Gm-Message-State: AC+VfDx/2bj8MSqa5j1UyMTE6XlMom6U5heLIf49kC3eCsBKnykufqqC
	GgDMFFlnNm4IRR6JY5RyFGyX5wUbLlAM7Q==
X-Google-Smtp-Source: ACHHUZ6J2Qc+Kx26XLblRdfwjDgjZRZhKWLZhXUGlfAZ0gb3foR9aHRoKWgfXdvUiAoplTTWq0VyDw==
X-Received: by 2002:a81:a157:0:b0:559:e240:3c27 with SMTP id y84-20020a81a157000000b00559e2403c27mr33475111ywg.23.1684220886078;
        Tue, 16 May 2023 00:08:06 -0700 (PDT)
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com. [209.85.219.180])
        by smtp.gmail.com with ESMTPSA id m81-20020a817154000000b0055a503ca1e8sm395921ywc.109.2023.05.16.00.08.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 May 2023 00:08:04 -0700 (PDT)
Received: by mail-yb1-f180.google.com with SMTP id 3f1490d57ef6-ba7730e47a4so4592961276.3;
        Tue, 16 May 2023 00:08:04 -0700 (PDT)
X-Received: by 2002:a25:1c6:0:b0:ba7:dcad:9b6 with SMTP id 189-20020a2501c6000000b00ba7dcad09b6mr4131622ybb.40.1684220883815;
 Tue, 16 May 2023 00:08:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230515090848.833045-1-bhe@redhat.com> <20230515090848.833045-2-bhe@redhat.com>
In-Reply-To: <20230515090848.833045-2-bhe@redhat.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 16 May 2023 09:07:52 +0200
X-Gmail-Original-Message-ID: <CAMuHMdU-bL-khVUN59ku1GwV6i4OC3O9AU1GQU2hfGn+JrsBXg@mail.gmail.com>
Message-ID: <CAMuHMdU-bL-khVUN59ku1GwV6i4OC3O9AU1GQU2hfGn+JrsBXg@mail.gmail.com>
Subject: Re: [PATCH v5 RESEND 01/17] asm-generic/iomap.h: remove
 ARCH_HAS_IOREMAP_xx macros
To: Baoquan He <bhe@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-mm@kvack.org, arnd@arndb.de, christophe.leroy@csgroup.eu, 
	hch@infradead.org, agordeev@linux.ibm.com, wangkefeng.wang@huawei.com, 
	schnelle@linux.ibm.com, David.Laight@aculab.com, shorne@gmail.com, 
	willy@infradead.org, deller@gmx.de, loongarch@lists.linux.dev, 
	linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, x86@kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 11:14=E2=80=AFAM Baoquan He <bhe@redhat.com> wrote:
> Let's use '#define ioremap_xx' and "#ifdef ioremap_xx" instead.
>
> For each architecture to remove defined ARCH_HAS_IOREMAP_xx macros in
> To remove defined ARCH_HAS_IOREMAP_xx macros in <asm/io.h> of each ARCH,
> the ARCH's own ioremap_wc|wt|np definition need be above
> "#include <asm-generic/iomap.h>. Otherwise the redefinition error would
> be seen during compiling. So the relevant adjustments are made to avoid
> compiling error:
>
>   loongarch:
>   - doesn't include <asm-generic/iomap.h>, defining ARCH_HAS_IOREMAP_WC
>     is redundant, so simply remove it.
>
>   m68k:
>   - selected GENERIC_IOMAP, <asm-generic/iomap.h> has been added in
>     <asm-generic/io.h>, and <asm/kmap.h> is included above
>     <asm-generic/iomap.h>, so simply remove ARCH_HAS_IOREMAP_WT defining.
>
>   mips:
>   - move "#include <asm-generic/iomap.h>" below ioremap_wc definition
>     in <asm/io.h>
>
>   powerpc:
>   - remove "#include <asm-generic/iomap.h>" in <asm/io.h> because it's
>     duplicated with the one in <asm-generic/io.h>, let's rely on the
>     latter.
>
>   x86:
>   - selected GENERIC_IOMAP, remove #include <asm-generic/iomap.h> in
>     the middle of <asm/io.h>. Let's rely on <asm-generic/io.h>.
>
> Signed-off-by: Baoquan He <bhe@redhat.com>

>  arch/m68k/include/asm/io_mm.h       | 2 --
>  arch/m68k/include/asm/kmap.h        | 2 --

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--=20
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds


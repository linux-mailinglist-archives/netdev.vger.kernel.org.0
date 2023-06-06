Return-Path: <netdev+bounces-8353-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 283DB723C99
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:10:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5CFBA1C20EAE
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:10:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BE22290EC;
	Tue,  6 Jun 2023 09:10:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20676125C0
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 09:10:06 +0000 (UTC)
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE934100;
	Tue,  6 Jun 2023 02:10:05 -0700 (PDT)
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-33b0bfb76cfso24356305ab.2;
        Tue, 06 Jun 2023 02:10:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686042605; x=1688634605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JsblPXknZ5GIdBcvT6axVzmA1IISIV/7YdlNXuNCOIg=;
        b=aXftCyN5vDj6Yk+E/L3vX1CmRx1jVHRWP0GWPUaxZ3qxKNS+JLTHs7GOAriMI/kilj
         akvPfHM0L/O/ezCAkaKRA3TExqGYWQxi7dZFNnc6R3Fg/6VU+Xw40p5k4BSx/dFC84xh
         XBG99gRsZ+UOgthiVWF9HCWR56HtTZ3OJqPzDjJy6v3gu3a8Q2eZuj4hXlSHmWtLr9hd
         IjONJBQ2b0UF72PQU6t1SdfkXZxaFALX9EUE1GGxSfINY9EyhWZ8j7vWMX8jibzjwASX
         C2jT8qzTXghJ/3cZ3tRW/upG8OZ84/+HvkKxGAfcQwtZVE/vqfiI2bXhkmLF8blBxBM4
         9JMg==
X-Gm-Message-State: AC+VfDyfaBCzAhHEOVX2mzvtbDTaUhoNDrNRpL3Bk4VC1vPcvQ08CIlo
	9TryqlEPASyRpTJlGynOszmn2NWtv2/MTQ==
X-Google-Smtp-Source: ACHHUZ5wh3jLQizgP0cwlJNWSdX88FVpA2JFJ/P2XluCzNQUJglNSRg+QbKrnfRGScboTFf92K5Aeg==
X-Received: by 2002:a92:ce46:0:b0:33c:b395:a898 with SMTP id a6-20020a92ce46000000b0033cb395a898mr1460748ilr.18.1686042604901;
        Tue, 06 Jun 2023 02:10:04 -0700 (PDT)
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com. [209.85.166.54])
        by smtp.gmail.com with ESMTPSA id c6-20020a92cf06000000b0033aa769d1a9sm2962156ilo.72.2023.06.06.02.10.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jun 2023 02:10:04 -0700 (PDT)
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-77499bf8e8bso228187139f.0;
        Tue, 06 Jun 2023 02:10:04 -0700 (PDT)
X-Received: by 2002:a0d:df90:0:b0:55a:26cf:33e with SMTP id
 i138-20020a0ddf90000000b0055a26cf033emr1300837ywe.42.1686042115920; Tue, 06
 Jun 2023 02:01:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+G9fYv0a-XxXfG6bNuPZGT=fzjtEfRGEYwk3n6M1WhEHUPo9g@mail.gmail.com>
 <CA+G9fYueN0xti1SDtYVZstPt104sUj06GfOzyqDNrd3s3xXBkA@mail.gmail.com>
In-Reply-To: <CA+G9fYueN0xti1SDtYVZstPt104sUj06GfOzyqDNrd3s3xXBkA@mail.gmail.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 6 Jun 2023 11:01:44 +0200
X-Gmail-Original-Message-ID: <CAMuHMdX7hqipiMCF9uxpU+_RbLmzyHeo-D0tCE_Hx8eTqQ7Pig@mail.gmail.com>
Message-ID: <CAMuHMdX7hqipiMCF9uxpU+_RbLmzyHeo-D0tCE_Hx8eTqQ7Pig@mail.gmail.com>
Subject: Re: arm: shmobile_defconfig: ld.lld: error: undefined symbol: lynx_pcs_destroy
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: open list <linux-kernel@vger.kernel.org>, 
	Linux-Next Mailing List <linux-next@vger.kernel.org>, lkft-triage@lists.linaro.org, 
	clang-built-linux <llvm@lists.linux.dev>, Linux-Renesas <linux-renesas-soc@vger.kernel.org>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, Netdev <netdev@vger.kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Arnd Bergmann <arnd@arndb.de>, Anders Roxell <anders.roxell@linaro.org>, 
	Geert Uytterhoeven <geert+renesas@glider.be>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Maxime Coquelin <mcoquelin.stm32@gmail.com>, maxime.chevallier@bootlin.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Naresh,

On Tue, Jun 6, 2023 at 10:53=E2=80=AFAM Naresh Kamboju
<naresh.kamboju@linaro.org> wrote:
> On Tue, 6 Jun 2023 at 14:17, Naresh Kamboju <naresh.kamboju@linaro.org> w=
rote:
> > Following build regressions found while building arm shmobile_defconfig=
 on
> > Linux next-20230606.
> >
> > Regressions found on arm:
> >
> >  - build/clang-16-shmobile_defconfig
> >  - build/gcc-8-shmobile_defconfig
> >  - build/gcc-12-shmobile_defconfig
> >  - build/clang-nightly-shmobile_defconfig
>
> And mips defconfig builds failed.
> Regressions found on mips:
>
>   - build/clang-16-defconfig
>   - build/gcc-12-defconfig
>   - build/gcc-8-defconfig
>   - build/clang-nightly-defconfig

Please give my fix a try:
https://lore.kernel.org/linux-renesas-soc/7b36ac43778b41831debd5c30b5b37d26=
8512195.1686039915.git.geert+renesas@glider.be

Thanks!

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


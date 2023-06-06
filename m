Return-Path: <netdev+bounces-8384-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 96052723DA9
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:35:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 090DA1C20F27
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:35:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4755F294E2;
	Tue,  6 Jun 2023 09:35:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C912125AB
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 09:35:28 +0000 (UTC)
Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C7CE6B;
	Tue,  6 Jun 2023 02:35:26 -0700 (PDT)
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-558cf19575dso1490483eaf.3;
        Tue, 06 Jun 2023 02:35:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686044126; x=1688636126;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/ZvMEy864MwTP2VbOIQdW/FR/SOtiCNc16GfTX7zCXs=;
        b=DL3It4Ca5xJL/vrKrqFBS9qmXsmu3UKzAg1VS+THcByn5cqRrkqYYoRy7Cx563ryEF
         +jQ8LwKnGZug6cXlyR9SDaHb2Lh+h0CWc9y/8gNGOmZyAXo1v1Y7JohAKdmu0NkIo1Mb
         aecOs4cvMhjA5j5jQIIam/rlVdRLCoaNYlS/goZjkHTaSILCJd8p2RsG1mn9tY504Ibn
         KVb+rzaSVZzPQavhuOoGaw/rcnAoOPKQMYMx1B6iez2mTBUb0XAY9SSBC9PPrlJXudUS
         KsDh8rUXLN2UxwzfhA4Av4lDw/bC5sQozlUJFUHwOaE4fvm6sz2CGhwxhNRhxdODEkSf
         0k4A==
X-Gm-Message-State: AC+VfDwP0Whb3napDvq0mUv1kUApSnDUoDg0JZJe6C8GtoNLFgzTd1jf
	4puVAT1yrGXLkR90d6VEvoA8am9aMjL3jw==
X-Google-Smtp-Source: ACHHUZ74uwk7tLOm3rALLOfpRcP3tLWD/D7I3Nks2fgxWfU5uoiBSZm7WX8ZjKo+uHkFWxJyeu3ILA==
X-Received: by 2002:a4a:a688:0:b0:558:b5b2:72fe with SMTP id f8-20020a4aa688000000b00558b5b272femr1155642oom.2.1686044125525;
        Tue, 06 Jun 2023 02:35:25 -0700 (PDT)
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com. [209.85.210.47])
        by smtp.gmail.com with ESMTPSA id j15-20020a9d7f0f000000b006a43519523fsm4207977otq.1.2023.06.06.02.35.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jun 2023 02:35:25 -0700 (PDT)
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-6b16cbe4fb6so1808314a34.1;
        Tue, 06 Jun 2023 02:35:25 -0700 (PDT)
X-Received: by 2002:a0d:cb47:0:b0:565:c96b:f526 with SMTP id
 n68-20020a0dcb47000000b00565c96bf526mr1400799ywd.19.1686043729823; Tue, 06
 Jun 2023 02:28:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+G9fYv0a-XxXfG6bNuPZGT=fzjtEfRGEYwk3n6M1WhEHUPo9g@mail.gmail.com>
 <CA+G9fYueN0xti1SDtYVZstPt104sUj06GfOzyqDNrd3s3xXBkA@mail.gmail.com>
 <CAMuHMdX7hqipiMCF9uxpU+_RbLmzyHeo-D0tCE_Hx8eTqQ7Pig@mail.gmail.com> <11bd37e9-c62e-46ba-9456-8e3b353df28f@app.fastmail.com>
In-Reply-To: <11bd37e9-c62e-46ba-9456-8e3b353df28f@app.fastmail.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 6 Jun 2023 11:28:38 +0200
X-Gmail-Original-Message-ID: <CAMuHMdUH2Grrv6842YWXHDmd+O3iHdwqTVjYf8f1nbVRzGA+6w@mail.gmail.com>
Message-ID: <CAMuHMdUH2Grrv6842YWXHDmd+O3iHdwqTVjYf8f1nbVRzGA+6w@mail.gmail.com>
Subject: Re: arm: shmobile_defconfig: ld.lld: error: undefined symbol: lynx_pcs_destroy
To: Arnd Bergmann <arnd@arndb.de>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, open list <linux-kernel@vger.kernel.org>, 
	linux-next <linux-next@vger.kernel.org>, lkft-triage@lists.linaro.org, 
	clang-built-linux <llvm@lists.linux.dev>, Linux-Renesas <linux-renesas-soc@vger.kernel.org>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, Netdev <netdev@vger.kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Anders Roxell <anders.roxell@linaro.org>, Geert Uytterhoeven <geert+renesas@glider.be>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Maxime Coquelin <mcoquelin.stm32@gmail.com>, maxime.chevallier@bootlin.com, 
	Simon Horman <simon.horman@corigine.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Arnd,

On Tue, Jun 6, 2023 at 11:16=E2=80=AFAM Arnd Bergmann <arnd@arndb.de> wrote=
:
> On Tue, Jun 6, 2023, at 11:01, Geert Uytterhoeven wrote:
> > On Tue, Jun 6, 2023 at 10:53=E2=80=AFAM Naresh Kamboju
> > <naresh.kamboju@linaro.org> wrote:
> >> On Tue, 6 Jun 2023 at 14:17, Naresh Kamboju <naresh.kamboju@linaro.org=
> wrote:
> >> > Following build regressions found while building arm shmobile_defcon=
fig on
> >> > Linux next-20230606.
> >> >
> >> > Regressions found on arm:
> >> >
> >> >  - build/clang-16-shmobile_defconfig
> >> >  - build/gcc-8-shmobile_defconfig
> >> >  - build/gcc-12-shmobile_defconfig
> >> >  - build/clang-nightly-shmobile_defconfig
> >>
> >> And mips defconfig builds failed.
> >> Regressions found on mips:
> >>
> >>   - build/clang-16-defconfig
> >>   - build/gcc-12-defconfig
> >>   - build/gcc-8-defconfig
> >>   - build/clang-nightly-defconfig
> >
> > Please give my fix a try:
> > https://lore.kernel.org/linux-renesas-soc/7b36ac43778b41831debd5c30b5b3=
7d268512195.1686039915.git.geert+renesas@glider.be
>
> This won't work when PCS_LYNX is a loadable module and
> STMMAC is built-in. I think we should just select PCS_LYNX

Oops, you're right, forgot about that case.
What about using IS_REACHABLE() instead?
No, that won't work either, as DWMAC_SOCFPGA can be modular,
with STMMAC builtin.

> unconditionally from stmmac even if no front-end driver
> using it is enabled.
>
> I tried to come up with a way to move the dependency into
> the altera specific front-end, but couldn't find an obvious
> or simple way to do this.
>
> Having a proper abstraction for PCS drivers instead of
> directly calling into exported driver symbols might help
> here, but that would add complexity elsewhere.

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


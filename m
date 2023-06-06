Return-Path: <netdev+bounces-8416-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D49A1723F88
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 12:32:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8EDAB281697
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 10:32:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECD4B33C85;
	Tue,  6 Jun 2023 10:32:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2CE915AC4
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 10:32:17 +0000 (UTC)
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8368B10C6;
	Tue,  6 Jun 2023 03:32:15 -0700 (PDT)
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-565e6beb7aaso75470907b3.2;
        Tue, 06 Jun 2023 03:32:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686047534; x=1688639534;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fJBagGQruk41RMozweoSMnqFuyRsRNH9Kz3lbWgCrDg=;
        b=ZS4n6g8Xn9pk4nj/555htUTZOSc3WAhyKl7lZxoWnNUCmiV5fgcCNC/PhotXbPf7gl
         7iGyMFv0NimGObo93vTrWfDJg4BNoGG+wE4Rm1UXTlRcH8sAHQxv2FrF8aVZoUgB2Vpi
         MvyZOtu04sl2xHpwjpKLmYiFwt4m6A8w5oTvInlNow73LPrHN9jnjelFVyTjZam0kogB
         5C5kzjKpoEUzhc+DS20k/VpFI+JG6WGtMAf7e1t6Ez6ca4Hbb1K32w9aoucDCCtx1Bjd
         HivJvd3mhkb07hftmu5NXp8MwdksBcxykdE07iuwlEBAZeh5si/zBLXvh+roetEohXzZ
         pWNQ==
X-Gm-Message-State: AC+VfDw8uO7qVNwTCLMg+fWwp27Aambqkq4WBEsVImKPQqx15B/sK/iw
	KfyS5LE5frSELhMhr90g596dAY8AFNbVvw==
X-Google-Smtp-Source: ACHHUZ4q5szX1RObq5yPUhreT12sVZhtZW/dFFxSSS4CPkePjU0Br+flDkjfHEu5G/vYpBo3/iyuXA==
X-Received: by 2002:a0d:e6d4:0:b0:565:e87f:a78f with SMTP id p203-20020a0de6d4000000b00565e87fa78fmr1872057ywe.25.1686047534573;
        Tue, 06 Jun 2023 03:32:14 -0700 (PDT)
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com. [209.85.128.171])
        by smtp.gmail.com with ESMTPSA id h66-20020a0dde45000000b0055d7f00d4f7sm3927127ywe.22.2023.06.06.03.32.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jun 2023 03:32:12 -0700 (PDT)
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-568ba7abc11so75529947b3.3;
        Tue, 06 Jun 2023 03:32:11 -0700 (PDT)
X-Received: by 2002:a0d:df91:0:b0:55a:3560:8ee0 with SMTP id
 i139-20020a0ddf91000000b0055a35608ee0mr1959649ywe.20.1686047531077; Tue, 06
 Jun 2023 03:32:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+G9fYv0a-XxXfG6bNuPZGT=fzjtEfRGEYwk3n6M1WhEHUPo9g@mail.gmail.com>
 <CA+G9fYueN0xti1SDtYVZstPt104sUj06GfOzyqDNrd3s3xXBkA@mail.gmail.com>
 <CAMuHMdX7hqipiMCF9uxpU+_RbLmzyHeo-D0tCE_Hx8eTqQ7Pig@mail.gmail.com>
 <11bd37e9-c62e-46ba-9456-8e3b353df28f@app.fastmail.com> <CAMuHMdUH2Grrv6842YWXHDmd+O3iHdwqTVjYf8f1nbVRzGA+6w@mail.gmail.com>
 <8db9886f-e24f-44ee-8f8a-880dc3e4bf75@app.fastmail.com>
In-Reply-To: <8db9886f-e24f-44ee-8f8a-880dc3e4bf75@app.fastmail.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 6 Jun 2023 12:31:59 +0200
X-Gmail-Original-Message-ID: <CAMuHMdWKL3UHzkEq3qOChMsgOsr+9uj215x55xLzbOUJWwQVzg@mail.gmail.com>
Message-ID: <CAMuHMdWKL3UHzkEq3qOChMsgOsr+9uj215x55xLzbOUJWwQVzg@mail.gmail.com>
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
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Arnd,

On Tue, Jun 6, 2023 at 12:21=E2=80=AFPM Arnd Bergmann <arnd@arndb.de> wrote=
:
> On Tue, Jun 6, 2023, at 11:28, Geert Uytterhoeven wrote:
> > On Tue, Jun 6, 2023 at 11:16=E2=80=AFAM Arnd Bergmann <arnd@arndb.de> w=
rote:
> >> On Tue, Jun 6, 2023, at 11:01, Geert Uytterhoeven wrote:
> >>
> >> This won't work when PCS_LYNX is a loadable module and
> >> STMMAC is built-in. I think we should just select PCS_LYNX
> >
> > Oops, you're right, forgot about that case.
> > What about using IS_REACHABLE() instead?
> > No, that won't work either, as DWMAC_SOCFPGA can be modular,
> > with STMMAC builtin.
>
> It would work because of the 'select PCS_LYNX' below DWMAC_SOCFPGA,

That was my first thought, but it won't work, as DWMAC_SOCFPGA=3Dm
causes PCS_LYNX=3Dm, while main STMMAC can still be builtin.

> but I think that's too fragile and would easily break when another
> dwmac front-end starts using PCS_LYNX without have the same select
> statement. I think we should always avoid IS_REACHABLE().

;-)

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


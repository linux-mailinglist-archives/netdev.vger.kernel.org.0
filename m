Return-Path: <netdev+bounces-8338-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 755EF723C41
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 10:53:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AAE46281549
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 08:53:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA9CD125C0;
	Tue,  6 Jun 2023 08:53:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE7E566C
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 08:53:53 +0000 (UTC)
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com [IPv6:2607:f8b0:4864:20::e33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAC78F4
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 01:53:51 -0700 (PDT)
Received: by mail-vs1-xe33.google.com with SMTP id ada2fe7eead31-43b87490a27so417316137.0
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 01:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686041631; x=1688633631;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DkYmQSdDH/7swAFbB+hh/UI/hl2M4IPq1cAE0sbjhj8=;
        b=BY9mJRXU5Uw4Wc3BYKAAcw5wT0xCZwCwxzc+YVOR57ZSjyQlIbSzuSe0xA1iDXYAaR
         u8t2ptPstyGfvNyzGy06ScIUbo+zrCIVC4wykhuQN2Pf9I5RIgMro6FdbXrsPuhehf16
         Ywke/gcYvszx5dlgXkDjLNQFN3lZeN7CRrVqsK1yVBrHKZGJKaXOMHXfDXSWsJEh/Gzy
         ukJ1x6Nu0Ds5xfktQ0KwztbGpIN8VgQeFvm1hZJ847GGPel4Oa42tiiPOaoRd1u8wSi7
         wAVRi9P6gK4zUQgIqYd0fSEt/+hjvZ4JYldH1sMs0GtIU7U/8s9N4p2RfLhUYRDuKGHO
         2h3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686041631; x=1688633631;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DkYmQSdDH/7swAFbB+hh/UI/hl2M4IPq1cAE0sbjhj8=;
        b=JGy3CGlGYF/4Nmy3O8WxTyB5pJFlQrvh9Pv6JjliZurUF/SowccN2XzSxmisCcZmPi
         Pj5sgUgd3HCM8q8qSv2rHOP1H2Y3hgHen+/GaZNShb6EkSApS3AHtFi212DSYQoPq6vh
         +kskGqMy5Xg+Y/cyhNcHg/nYJ7gyAKqYraSsdjFZeXtvXiX2gXsfngSTRWwV2cRv+gls
         V5t3ecE+qJ3E0TUhB5taTdLBKOeZz3D+y9j7OIdvwFWlrAL9eo6z6YYpUTTLNJTs7rIx
         sZYou/zl8wyK+ejUqLq1xyyMydf7vYkIdVy/EeXtExijWvcTLJ/HiFKIPFnYDXtzoZjI
         6GLQ==
X-Gm-Message-State: AC+VfDymqbyEPu4oeVHwl4KPBUp6+uFxELOb3KXAlRhYgpxNt/HEhSbj
	FjlvXiz6M31ePDxqW5LoSTWuGi6q3haBQSTvDdKHwQ==
X-Google-Smtp-Source: ACHHUZ6oosJ/AGBnPC00r6QaUMmoCBOhY+Q8RI7xPxjgWlVuISrs9TDVAfbGhiRpcu/E3MP9rBkDqdCkWA7eX9GNUpo=
X-Received: by 2002:a05:6102:410:b0:43b:1b47:670 with SMTP id
 d16-20020a056102041000b0043b1b470670mr889033vsq.20.1686041630760; Tue, 06 Jun
 2023 01:53:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+G9fYv0a-XxXfG6bNuPZGT=fzjtEfRGEYwk3n6M1WhEHUPo9g@mail.gmail.com>
In-Reply-To: <CA+G9fYv0a-XxXfG6bNuPZGT=fzjtEfRGEYwk3n6M1WhEHUPo9g@mail.gmail.com>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 6 Jun 2023 14:23:39 +0530
Message-ID: <CA+G9fYueN0xti1SDtYVZstPt104sUj06GfOzyqDNrd3s3xXBkA@mail.gmail.com>
Subject: Re: arm: shmobile_defconfig: ld.lld: error: undefined symbol: lynx_pcs_destroy
To: open list <linux-kernel@vger.kernel.org>, 
	Linux-Next Mailing List <linux-next@vger.kernel.org>, lkft-triage@lists.linaro.org, 
	clang-built-linux <llvm@lists.linux.dev>, Linux-Renesas <linux-renesas-soc@vger.kernel.org>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, Netdev <netdev@vger.kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Arnd Bergmann <arnd@arndb.de>, Anders Roxell <anders.roxell@linaro.org>, 
	Geert Uytterhoeven <geert+renesas@glider.be>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Maxime Coquelin <mcoquelin.stm32@gmail.com>, maxime.chevallier@bootlin.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

+ netdev



On Tue, 6 Jun 2023 at 14:17, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> Following build regressions found while building arm shmobile_defconfig on
> Linux next-20230606.
>
> Regressions found on arm:
>
>  - build/clang-16-shmobile_defconfig
>  - build/gcc-8-shmobile_defconfig
>  - build/gcc-12-shmobile_defconfig
>  - build/clang-nightly-shmobile_defconfig

And mips defconfig builds failed.
Regressions found on mips:

  - build/clang-16-defconfig
  - build/gcc-12-defconfig
  - build/gcc-8-defconfig
  - build/clang-nightly-defconfig



>
> ld.lld: error: undefined symbol: lynx_pcs_destroy
> >>> referenced by stmmac_mdio.c
> >>>               drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.o:(stmmac_mdio_unregister) in archive vmlinux.a
> make[2]: *** [scripts/Makefile.vmlinux:35: vmlinux] Error 1
>
>
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> links,
> - https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20230606/testrun/17347517/suite/build/test/gcc-12-shmobile_defconfig/history/
> - https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20230606/testrun/17347562/suite/build/test/clang-16-shmobile_defconfig/log
>
> --
> Linaro LKFT
> https://lkft.linaro.org


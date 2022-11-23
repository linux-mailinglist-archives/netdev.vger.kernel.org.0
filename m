Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3534B635F50
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 14:23:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238059AbiKWNXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 08:23:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237710AbiKWNX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 08:23:26 -0500
Received: from conssluserg-03.nifty.com (conssluserg-03.nifty.com [210.131.2.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F29445BD7E;
        Wed, 23 Nov 2022 05:03:58 -0800 (PST)
Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45]) (authenticated)
        by conssluserg-03.nifty.com with ESMTP id 2AND3ksx018934;
        Wed, 23 Nov 2022 22:03:46 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-03.nifty.com 2AND3ksx018934
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1669208627;
        bh=/0YxBwaIDdbvVmxcfiVpYWCSb8Y0z9oI7DjNyiXXRmA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=QBEOJWQJVjwDdBhOArmESrXbkAyRUdgfW7qVM/ce5NptE9qld/Am6g/R4gVeQWeec
         79z/vpXPetPHoSrw6k1es6SKSXgKTT7FyvwaSpdIRMn50Q85DkBcsUe7F69dLyoovl
         SQzYWeQRmO6RSt753kTRl3gFfi3HL1MQ09IowL15zGPdpeNeTPLYgSDcFO5v3vLVgJ
         xwtQ4GX4mXOgN/zRzc/TVYEyD7tfBhqT7KlGQAayM3rkRKBNylfeGYlI6zKkpRNqJT
         fS9bpekQXwO2ffuvJeqw/ByOhW4ABWuoIG/kpLuu2HvWelgFuNJzo5cDcQCzWGUdYU
         3F6udt6MTbqJg==
X-Nifty-SrcIP: [209.85.161.45]
Received: by mail-oo1-f45.google.com with SMTP id k12-20020a4ab08c000000b0049e2ab19e04so2688667oon.6;
        Wed, 23 Nov 2022 05:03:46 -0800 (PST)
X-Gm-Message-State: ANoB5pkY7udZ+e7yh5rpaflJmVpM53uzCsp15ua24E+yBNIgd9js8mzD
        HmIxAcHqx3EMWDIiJSuSQyEjnQ/2kh2kQu3NQEE=
X-Google-Smtp-Source: AA0mqf4feKRjreEN59r06gaU/5giz/qF+7kf1W0QTXfrbg0mfz6dgS6phb+g710SLyVU0CHHJ0eVbh9V2EaRWD+GGlk=
X-Received: by 2002:a05:6820:16a7:b0:49f:c664:44e2 with SMTP id
 bc39-20020a05682016a700b0049fc66444e2mr3980265oob.96.1669208625497; Wed, 23
 Nov 2022 05:03:45 -0800 (PST)
MIME-Version: 1.0
References: <20221119225650.1044591-1-alobakin@pm.me> <20221119225650.1044591-9-alobakin@pm.me>
In-Reply-To: <20221119225650.1044591-9-alobakin@pm.me>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Wed, 23 Nov 2022 22:03:09 +0900
X-Gmail-Original-Message-ID: <CAK7LNAT4asXORsS8Q-NRfGEYo4fsAnMVhQai3C+EeaDhoXv57Q@mail.gmail.com>
Message-ID: <CAK7LNAT4asXORsS8Q-NRfGEYo4fsAnMVhQai3C+EeaDhoXv57Q@mail.gmail.com>
Subject: Re: [PATCH 08/18] net: enetc: fix mixed module-builtin object
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     linux-kbuild@vger.kernel.org, Nicolas Schier <nicolas@fjasle.eu>,
        Jens Axboe <axboe@kernel.dk>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Derek Chickles <dchickles@marvell.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Daniel Scally <djrscally@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        NXP Linux Team <linux-imx@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_SOFTFAIL autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 20, 2022 at 8:07 AM Alexander Lobakin <alobakin@pm.me> wrote:
>
> From: Masahiro Yamada <masahiroy@kernel.org>
>
> With CONFIG_FSL_ENETC=m and CONFIG_FSL_ENETC_VF=y (or vice versa),
> $(common-objs) are linked to a module and also to vmlinux even though
> the expected CFLAGS are different between builtins and modules.
>
> This is the same situation as fixed by commit 637a642f5ca5 ("zstd:
> Fixing mixed module-builtin objects").
>
> Introduce the new module, fsl-enetc-core, to provide the common
> functions to fsl-enetc and fsl-enetc-vf.
>
> [ alobakin: add exports to common functions ]
>
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> Reviewed-by: Alexander Lobakin <alobakin@pm.me>
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> ---
>  drivers/net/ethernet/freescale/enetc/Kconfig  |  5 +++++
>  drivers/net/ethernet/freescale/enetc/Makefile |  7 ++++---
>  drivers/net/ethernet/freescale/enetc/enetc.c  | 21 +++++++++++++++++++
>  .../net/ethernet/freescale/enetc/enetc_cbdr.c |  7 +++++++
>  .../ethernet/freescale/enetc/enetc_ethtool.c  |  2 ++
>  .../net/ethernet/freescale/enetc/enetc_pf.c   |  2 ++
>  .../net/ethernet/freescale/enetc/enetc_vf.c   |  2 ++
>  7 files changed, 43 insertions(+), 3 deletions(-)



I think you can grab Author since I did not finish this patch.
(and of course, I did not test it at all)

You can remove a blank line after MODULE_IMPORT_NS()

Reviewed-by: Masahiro Yamada <masahiroy@kernel.org>






-- 
Best Regards
Masahiro Yamada

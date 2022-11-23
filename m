Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBEED63654D
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 17:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238441AbiKWQF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 11:05:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238512AbiKWQFy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 11:05:54 -0500
Received: from conssluserg-06.nifty.com (conssluserg-06.nifty.com [210.131.2.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B431F615;
        Wed, 23 Nov 2022 08:05:52 -0800 (PST)
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41]) (authenticated)
        by conssluserg-06.nifty.com with ESMTP id 2ANG5TUq009845;
        Thu, 24 Nov 2022 01:05:29 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-06.nifty.com 2ANG5TUq009845
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1669219530;
        bh=svFtEHRXI+hcu/P5T8jGVN2TIA7Yepr3md/9hK9H4Os=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=hvOdANAjjXXWAB4WMsZdDYqo0cVfVOoPZXMvA5AzP+Bqbjqrag6EYSs9UxzKC+Dnb
         wfyjYj7MZg3+gbt+18QK4OIJ/iJphcfQzYC7RSI962tkJ8j50pVCbOxRR0GgHpBh7s
         P1/M0IzZC5UThIBzH6uvdxJ5WUkEaydSN+LyQfgSmzn32dJJ4imQDAEOW6S0dx3LOP
         3F8NaLCcnlmlblM9rlg9GKqjA1P2ItrZZyKD3q+L01sAFL/jQphPgnMBuP6m6amq1d
         AN/l4BdcUMVXQd1gIVg52jgLkMwE3kUhbFXankfuFat2LJYSrUXaigGjN7+u6k8NRX
         +XrwbfrRUik8Q==
X-Nifty-SrcIP: [209.85.160.41]
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-14286d5ebc3so17990322fac.3;
        Wed, 23 Nov 2022 08:05:29 -0800 (PST)
X-Gm-Message-State: ANoB5pl3TnU217L4Ves+m82DMV2KuoNgWkxt7/ueOe6SwvZbJEOiA6lm
        yNc2BZTvNuyE7UZS1c7x2LKzNFeSG/YZYThgQSY=
X-Google-Smtp-Source: AA0mqf6HGleRbj7Qe5GzuirX/Foa0/Aoh13Y8Sr/DxGsPHT5WruP6vhcbHKUWNwUxifsPORSdReCGgryqYEYNpGynPk=
X-Received: by 2002:a05:6870:3b06:b0:13b:5d72:d2c6 with SMTP id
 gh6-20020a0568703b0600b0013b5d72d2c6mr5086727oab.287.1669219528697; Wed, 23
 Nov 2022 08:05:28 -0800 (PST)
MIME-Version: 1.0
References: <20221119225650.1044591-1-alobakin@pm.me> <20221119225650.1044591-10-alobakin@pm.me>
In-Reply-To: <20221119225650.1044591-10-alobakin@pm.me>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Thu, 24 Nov 2022 01:04:52 +0900
X-Gmail-Original-Message-ID: <CAK7LNAT4Oe1JRu5msSV6M2e5QRNTH9xuBUsOq+KrFS0H911=TQ@mail.gmail.com>
Message-ID: <CAK7LNAT4Oe1JRu5msSV6M2e5QRNTH9xuBUsOq+KrFS0H911=TQ@mail.gmail.com>
Subject: Re: [PATCH 09/18] net: emac, cpsw: fix mixed module-builtin object (davinci_cpdma)
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
> CONFIG_TI_DAVINCI_EMAC, CONFIG_TI_CPSW and CONFIG_TI_CPSW_SWITCHDEV
> are all tristate. This means that davinci_cpdma.o can be linked to
> a module and also to vmlinux even though the expected CFLAGS are
> different between builtins and modules.
>
> This is the same situation as fixed by commit 637a642f5ca5 ("zstd:
> Fixing mixed module-builtin objects").
>
> Introduce the new module, ti_davinci_cpdma, to provide the common
> functions to these three modules.
>
> [ alobakin: add exports ]
>
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> Reviewed-by: Alexander Lobakin <alobakin@pm.me>
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> ---

Please take the authorship for this patch
because I did not finish this patch
(and I am not sure if this is the correct way to fix)

As 18/18 will touch this part again,
perhaps davinci_cpdma.c can go into ti_cpsw_core.ko

Anyway, the maintainer may have a better insight.



-- 
Best Regards
Masahiro Yamada

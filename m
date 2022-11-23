Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E03E6636587
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 17:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238985AbiKWQNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 11:13:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238747AbiKWQNh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 11:13:37 -0500
Received: from conssluserg-01.nifty.com (conssluserg-01.nifty.com [210.131.2.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFF657211D;
        Wed, 23 Nov 2022 08:13:36 -0800 (PST)
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171]) (authenticated)
        by conssluserg-01.nifty.com with ESMTP id 2ANGDAh3011961;
        Thu, 24 Nov 2022 01:13:11 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-01.nifty.com 2ANGDAh3011961
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1669219991;
        bh=sTzPqhL6/cyZNPSMtdcVqn6bAW4DNLqYZywnYDqsJBc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=eA8No2Q4NNdrLH9UbP0H72OqYXl80Z6IyxvARG10leSkiBMGwd23oiDHUB+55TQbm
         XZ4XbjPDm7HaRQFbDDkCwCj9qXq+MWi6MNPQ6wu1obihRAJq3Fhhk8tkKMKAjdvuwl
         y+LSBBCDWsR0XaPFUvtzrfMqZ84fz0z3tsxUdl/OhX2dptefIkSG7CwZJUpGDGXo09
         taC+YbK0xtit5s/cJEQxmodisK71WdRI9xxK6cx2QPcuzCC3jXOfmGI7sQsWxEy88p
         NPfhpRjwYYVPnmwuYV1S0AzEvA7VbCLZ9sXAdMS4dI84IDY9B6QCakJMSiwZ472tZJ
         wGJt0InV0xahw==
X-Nifty-SrcIP: [209.85.167.171]
Received: by mail-oi1-f171.google.com with SMTP id e205so19478615oif.11;
        Wed, 23 Nov 2022 08:13:11 -0800 (PST)
X-Gm-Message-State: ANoB5pmwz0XqDoFC0nkSBBKyrJ2VWg9PuskpdZ6U1YItbk8UF5IXcjCM
        fBYy5XOPK/FeqoEGqxw921Nrxkk7xsSKHj9R+Do=
X-Google-Smtp-Source: AA0mqf547S+vrjJDP9m108ruWlerVjKS5mRICzMem99abwxZnjLXMTgoG/4tz0x+fgdPkF3l0IJe/wPyv1gzr0O7lWg=
X-Received: by 2002:a05:6808:3009:b0:354:94a6:a721 with SMTP id
 ay9-20020a056808300900b0035494a6a721mr5482733oib.194.1669219990211; Wed, 23
 Nov 2022 08:13:10 -0800 (PST)
MIME-Version: 1.0
References: <20221119225650.1044591-1-alobakin@pm.me> <20221119225650.1044591-11-alobakin@pm.me>
In-Reply-To: <20221119225650.1044591-11-alobakin@pm.me>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Thu, 24 Nov 2022 01:12:34 +0900
X-Gmail-Original-Message-ID: <CAK7LNARnb8NEH0aPDg=KxUqBkWj0+2-peFt7TKqaT7A+8hv0eQ@mail.gmail.com>
Message-ID: <CAK7LNARnb8NEH0aPDg=KxUqBkWj0+2-peFt7TKqaT7A+8hv0eQ@mail.gmail.com>
Subject: Re: [PATCH 10/18] EDAC: i10nm, skx: fix mixed module-builtin object
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

On Sun, Nov 20, 2022 at 8:08 AM Alexander Lobakin <alobakin@pm.me> wrote:
>
> With CONFIG_EDAC_SKX=m and CONFIG_EDAC_I10NM=y (or vice versa),
> skx_common.o are linked to a module and also to vmlinux even though
> the expected CFLAGS are different between builtins and modules:
>
> > scripts/Makefile.build:252: ./drivers/edac/Makefile: skx_common.o
> > is added to multiple modules: i10nm_edac skx_edac
>
> This is the same situation as fixed by commit 637a642f5ca5 ("zstd:
> Fixing mixed module-builtin objects").
>
> Introduce the new module, skx_edac_common, to provide the common
> functions to skx_edac and i10nm_edac. skx_adxl_{get,put}() loose
> their __init/__exit annotations in order to become exportable.
>
> Fixes: d4dc89d069aa ("EDAC, i10nm: Add a driver for Intel 10nm server processors")
> Suggested-by: Masahiro Yamada <masahiroy@kernel.org>
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>

Reviewed-by: Masahiro Yamada <masahiroy@kernel.org>





--
Best Regards
Masahiro Yamada

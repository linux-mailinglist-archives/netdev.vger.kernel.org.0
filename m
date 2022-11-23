Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F13E6365CE
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 17:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239148AbiKWQ2R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 11:28:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239111AbiKWQ1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 11:27:46 -0500
Received: from conssluserg-05.nifty.com (conssluserg-05.nifty.com [210.131.2.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F098C6254;
        Wed, 23 Nov 2022 08:27:41 -0800 (PST)
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44]) (authenticated)
        by conssluserg-05.nifty.com with ESMTP id 2ANGRJ49000862;
        Thu, 24 Nov 2022 01:27:20 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-05.nifty.com 2ANGRJ49000862
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1669220840;
        bh=pGYwrOBn5BOItVFutTsAWIvBBiJMVtA/X2Z+g2tncqA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=19pcjr+unQOQCjOVZVKI7joMUYCKPUSy0pVwo/9+7pOHx0RYj69coUGUjOyy3Z77u
         aQjG8QXO7giJaxZvQBqBNF3nJGAHb9IBlQrcK2T7tS2DbAsekg6i1nNTdv2OUNXL0O
         Lqty5+EnhAGd381og3dXRI5SnsZh9W2tk8ejRVr8J3Plyha1hrMsv/f8lYZs5r5HaX
         RHcOlfcHUF/EJfed7Myg1QzzAomwaO/HQFSZXKjT36SgyBL/mGxcoaOwfeG3z5jTiS
         akYY4nM72vHPEHV/vNH/JbgKvbjJCH7qONNtmUGU1VzRAApBjic6fh67A1LCHgm+KQ
         k8Vu3n2XAfR8A==
X-Nifty-SrcIP: [209.85.160.44]
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-14279410bf4so19570964fac.8;
        Wed, 23 Nov 2022 08:27:20 -0800 (PST)
X-Gm-Message-State: ANoB5pkB4sdK2i3W6LluCfQV2taq0945/8qBFuVce2eSgH0Wp+MVsATI
        6FeE4Lmq0yWx6xIz7eINqU8ruGDFnq/G8SgzYSA=
X-Google-Smtp-Source: AA0mqf76rLYya7pcOaE9FIRGHayEM3x5cxMQVljU/Ef2ZBA8L7iOg1BZVDArgFQcCCffPQnr18/N+Jl5zxEcapsqjSQ=
X-Received: by 2002:a05:6870:ea8e:b0:13b:a31f:45fd with SMTP id
 s14-20020a056870ea8e00b0013ba31f45fdmr19102212oap.194.1669220839245; Wed, 23
 Nov 2022 08:27:19 -0800 (PST)
MIME-Version: 1.0
References: <20221119225650.1044591-1-alobakin@pm.me> <20221119225650.1044591-14-alobakin@pm.me>
In-Reply-To: <20221119225650.1044591-14-alobakin@pm.me>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Thu, 24 Nov 2022 01:26:43 +0900
X-Gmail-Original-Message-ID: <CAK7LNATyMmumYek9ojw5fUsdM=F9cOuK082TOuM84tjrGVaEDA@mail.gmail.com>
Message-ID: <CAK7LNATyMmumYek9ojw5fUsdM=F9cOuK082TOuM84tjrGVaEDA@mail.gmail.com>
Subject: Re: [PATCH 13/18] crypto: octeontx2: fix objects shared between
 several modules
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

On Sun, Nov 20, 2022 at 8:09 AM Alexander Lobakin <alobakin@pm.me> wrote:
>
> cn10k_cpt.o, otx2_cptlf.o and otx2_cpt_mbox_common.o are linked
> into both rvu_cptpf and rvu_cptvf modules:
>
> > scripts/Makefile.build:252: ./drivers/crypto/marvell/octeontx2/Makefile:
> > cn10k_cpt.o is added to multiple modules: rvu_cptpf rvu_cptvf
> > scripts/Makefile.build:252: ./drivers/crypto/marvell/octeontx2/Makefile:
> > otx2_cptlf.o is added to multiple modules: rvu_cptpf rvu_cptvf
> > scripts/Makefile.build:252: ./drivers/crypto/marvell/octeontx2/Makefile:
> > otx2_cpt_mbox_common.o is added to multiple modules: rvu_cptpf rvu_cptvf
>
> Despite they're build under the same Kconfig option
> (CONFIG_CRYPTO_DEV_OCTEONTX2_CPT), it's better do link the common
> code into a standalone module and export the shared functions. Under
> certain circumstances, this can lead to the same situation as fixed
> by commit 637a642f5ca5 ("zstd: Fixing mixed module-builtin objects").
> Plus, those three common object files are relatively big to duplicate
> them several times.
>
> Introduce the new module, rvu_cptcommon, to provide the common
> functions to both modules.
>
> Fixes: 19d8e8c7be15 ("crypto: octeontx2 - add virtual function driver support")
> Suggested-by: Masahiro Yamada <masahiroy@kernel.org>
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> ---



Reviewed-by: Masahiro Yamada <masahiroy@kernel.org>




-- 
Best Regards
Masahiro Yamada

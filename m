Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC4B636BA3
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 21:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233239AbiKWUzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 15:55:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbiKWUzJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 15:55:09 -0500
Received: from conssluserg-01.nifty.com (conssluserg-01.nifty.com [210.131.2.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CAAF85EF1;
        Wed, 23 Nov 2022 12:55:08 -0800 (PST)
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169]) (authenticated)
        by conssluserg-01.nifty.com with ESMTP id 2ANKsdRn004945;
        Thu, 24 Nov 2022 05:54:39 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-01.nifty.com 2ANKsdRn004945
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1669236880;
        bh=W0Ib2SwgvlfZvFNNkHagp9wO+nNb60/k15KCdhtTNPU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=j7CKAoX5HqZvjhkRFCz8KAuwVyjkGUDoJxK3O74OqXCIuKkZycXr/QuUW95j56HE2
         Geh52K06MNb/FABpNrIwtgzErMzPcq++rKkvrEllM8+rjSdNsOGVMua8dQDoG78prk
         QRzJpz4Vr4IFma2QiB/aAAKiivl4eyARsI/9GSLaO7hQj3luez3XB5Gy5PkMU+aEi9
         UFdLJ2u4UDnPqNXdvj9ggMgH3K1dciTT+fi2G6FnRCYNPBkbji4tQ3zOBtmctzwWgu
         zAULNJHE829MEEjKS3W65mNoure9urml9vgWZIpyXv3KCFxUHaqgwdz2e+YxyxIl3x
         3HfYrdesR6q5Q==
X-Nifty-SrcIP: [209.85.167.169]
Received: by mail-oi1-f169.google.com with SMTP id t62so20290821oib.12;
        Wed, 23 Nov 2022 12:54:39 -0800 (PST)
X-Gm-Message-State: ANoB5pmwyyVjbMhDCqQMfXjsfA8BWW9YQP1TmJuq1A/kkpKVMLieYqg3
        sLeRywM/gRVUGbq4IN8Q8WEtVTMG1AAAMWuS57Q=
X-Google-Smtp-Source: AA0mqf78r/QjKF5VL2n0ZfSDGYbyxuDvPhXLHB3eOJhTrS1cycjh2C+UvutIO0XjG3CCQmml4RIm4jxZKSTA5dsrjdw=
X-Received: by 2002:aca:1c06:0:b0:354:28ae:23b3 with SMTP id
 c6-20020aca1c06000000b0035428ae23b3mr6475507oic.287.1669236878717; Wed, 23
 Nov 2022 12:54:38 -0800 (PST)
MIME-Version: 1.0
References: <20221119225650.1044591-1-alobakin@pm.me> <20221119225650.1044591-18-alobakin@pm.me>
In-Reply-To: <20221119225650.1044591-18-alobakin@pm.me>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Thu, 24 Nov 2022 05:54:02 +0900
X-Gmail-Original-Message-ID: <CAK7LNARhND_qb+m1+c+AMfT+9DawaoCjz7NT6Ox3EsDmh0F9_w@mail.gmail.com>
Message-ID: <CAK7LNARhND_qb+m1+c+AMfT+9DawaoCjz7NT6Ox3EsDmh0F9_w@mail.gmail.com>
Subject: Re: [PATCH 17/18] net: octeontx2: fix mixed module-builtin object
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

On Sun, Nov 20, 2022 at 8:10 AM Alexander Lobakin <alobakin@pm.me> wrote:
>
> With CONFIG_OCTEONTX2_PF=y and CONFIG_OCTEONTX2_VF=m, several object
> files  are linked to a module and also to vmlinux even though the
> expected CFLAGS are different between builtins and modules.
> This is the same situation as fixed by
> commit 637a642f5ca5 ("zstd: Fixing mixed module-builtin objects").
> There's also no need to duplicate relatively big piece of object
> code into two modules.
>
> Introduce the new module, rvu_niccommon, to provide the common
> functions to both rvu_nicpf and rvu_nicvf. Also, otx2_ptp.o was not
> shared, but built as a standalone module (it was fixed already a year
> ago the same way this commit does due to link issues). As it's used
> by both PF and VF modules in the same way, just link it into that new
> common one.
>
> Fixes: 2da489432747 ("octeontx2-pf: devlink params support to set mcam entry count")
> Fixes: 8e67558177f8 ("octeontx2-pf: PFC config support with DCBx")
> Suggested-by: Masahiro Yamada <masahiroy@kernel.org>
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> ---


Reviewed-by: Masahiro Yamada <masahiroy@kernel.org>

Minor:
otx2_ptp.c uses EXPORT_SYMBOL_GPL().
It is better to use either EXPORT_SYMBOL_GPL or
EXPORT_SYMBOL_NS_GPL instead of mixing them.



--
Best Regards
Masahiro Yamada

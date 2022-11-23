Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4525636BD4
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 22:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236737AbiKWVEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 16:04:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236642AbiKWVEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 16:04:06 -0500
Received: from conssluserg-04.nifty.com (conssluserg-04.nifty.com [210.131.2.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 894A72936F;
        Wed, 23 Nov 2022 13:04:03 -0800 (PST)
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44]) (authenticated)
        by conssluserg-04.nifty.com with ESMTP id 2ANL3RFg000357;
        Thu, 24 Nov 2022 06:03:28 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-04.nifty.com 2ANL3RFg000357
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1669237408;
        bh=W0nCyQqLQfReQqK54zE3fJbgqD+3GLnWxu8/PxCNlXQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=A5YMICOx+m5Mmd3hE7kvpbXpnIWzrtGftJdG06Zsk4CuHc84E51WBS2hrSC6tbQAQ
         MN6exYDV7Gutx75//uumFPJG0dlUzZJ2/CORGbcQQrprLPbQazhsFP7WWZW1fwXffa
         O5PK4IXUgJ+25kAi40oT6eOKH9NQ2+V8IP/xHrgr/QdoQsh9wbYjmntAocRI3zQcL0
         5oSCxuIJCSjxgqHbMpQ0vb69yW0SKdMDXOhCTc7OZch5hPvm9lpDGBG33IfwZS/l6N
         W+ZQoQcV799vW72oPaWF6ELpSHBvaMS5pdjvj+nPZqGpKM3lgC6ZR3q0p7PoapsZpm
         8NaBdtBj0jNZA==
X-Nifty-SrcIP: [209.85.210.44]
Received: by mail-ot1-f44.google.com with SMTP id w26-20020a056830061a00b0066c320f5b49so11995806oti.5;
        Wed, 23 Nov 2022 13:03:27 -0800 (PST)
X-Gm-Message-State: ANoB5pkc+ebPEo/YBmgFqHNolXgmJenUbjHqBQ72sgBxOO+bI0eyMpHG
        0SGN6ry11sTI9h+sHyRsq7rex+gj4E17DVNt4Ew=
X-Google-Smtp-Source: AA0mqf4FtoW/4lVAQkI/4YgB2sFM1/xO0IxB0jVFyO/6YbGnUpsxENwldQ+0E9ZFKUSx3arF7kz9NxNwfW7TnxCoDqs=
X-Received: by 2002:a05:6830:1b67:b0:661:8d9e:1959 with SMTP id
 d7-20020a0568301b6700b006618d9e1959mr15550185ote.225.1669237406822; Wed, 23
 Nov 2022 13:03:26 -0800 (PST)
MIME-Version: 1.0
References: <20221119225650.1044591-1-alobakin@pm.me> <20221119225650.1044591-16-alobakin@pm.me>
In-Reply-To: <20221119225650.1044591-16-alobakin@pm.me>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Thu, 24 Nov 2022 06:02:50 +0900
X-Gmail-Original-Message-ID: <CAK7LNARfs413qp7f1biiX7TJfbJtWyL+C4rEkzWB9TWDkD2FrQ@mail.gmail.com>
Message-ID: <CAK7LNARfs413qp7f1biiX7TJfbJtWyL+C4rEkzWB9TWDkD2FrQ@mail.gmail.com>
Subject: Re: [PATCH 15/18] net: dpaa2: fix mixed module-builtin object
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
> With CONFIG_FSL_DPAA2_ETH=m and CONFIG_FSL_DPAA2_SWITCH=y (or vice
> versa), dpaa2-mac.o and dpmac.o are linked to a module and also to
> vmlinux even though the expected CFLAGS are different between
> builtins and modules.
> This is the same situation as fixed by
> commit 637a642f5ca5 ("zstd: Fixing mixed module-builtin objects").
> There's also no need to duplicate relatively big piece of object
> code into two modules.
>
> Introduce the new module, fsl-dpaa2-mac, to provide the common
> functions to both fsl-dpaa2-eth and fsl-dpaa2-switch.
>
> Misc: constify and shrink @dpaa2_mac_ethtool_stats while at it.
>
> Fixes: 84cba72956fd ("dpaa2-switch: integrate the MAC endpoint support")
> Suggested-by: Masahiro Yamada <masahiroy@kernel.org>
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> ---

Reviewed-by: Masahiro Yamada <masahiroy@kernel.org>



-- 
Best Regards
Masahiro Yamada

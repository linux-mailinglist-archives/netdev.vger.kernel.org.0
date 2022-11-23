Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEBA9636CD8
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 23:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbiKWWIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 17:08:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbiKWWIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 17:08:24 -0500
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050:0:465::102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 452521571D;
        Wed, 23 Nov 2022 14:08:17 -0800 (PST)
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4NHZy72lqZz9sTC;
        Wed, 23 Nov 2022 23:08:15 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1669241295;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AqECxmOSPT83qOwhM+GdKNJsI17VfZH7epaT9e6tcdI=;
        b=rW1avn3NpXzn7sLiAsTnlSMg6PV6E/xIwdgcoC+gxGlnEOAghAxwNrU2qBwiUfl8eYxD4v
        XoWt+3PAKmT0WkHWaogToi7Igt0omFM5i8erCkbZgX5vKIBn3G4gWRg4hW5dQ88nkyHMtY
        FBgrOVXx77dWcMY4ZSaFeeHWeIWRd3bB3bSBWxZzguxKGADvxv4uG5gp0MC7Ix+JymFeA6
        JzlhjlGgvwwvRJejF9zDXUcmmhV3XyXMK7DGdUUEdsZaHfnH8BN4isEz/y5iUwfcJ7dXFO
        TLVV2UMap5AvLljh7E1ZJsy1i3CojSaA1pDT18pJYq6KtqJHEIrK+3SMKVq7dw==
From:   Alexander Lobakin <alobakin@mailbox.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1669241293;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AqECxmOSPT83qOwhM+GdKNJsI17VfZH7epaT9e6tcdI=;
        b=YPSIjDv9PN2kIm1grMjMSM6oVfCrHwNJYvSxrwtqNcfWlxjaH4IMw1nzvJ/vex/arwWZTk
        7/S9jFl28DmQth8C65d4trHozT+sHbtpDc6iNIOjRwIg304wpxjd6aNQhBpp43nK1gpV2d
        uL5tVbywOqZpaACZ2Uw/ZPG4xcdtAu5EC7GhAQ+uJcjaSp3+LQqAhZrZKlCe2FrHo637So
        v2c5Zjyuhl5/yuDdnZe6jHaiIQQFJTLTeOhNsOlEz4VKgAjEVc7W+DbE9wr28/V8wzQgTI
        XMO2UqJTAAcQnwNHgod3RIhetuu5UsW8I1lZVIF3qU7RkLcBXuUXJbKDy7uLow==
To:     Salil Mehta <salil.mehta@huawei.com>
Cc:     Alexander Lobakin <alobakin@mailbox.org>,
        Alexander Lobakin <alobakin@pm.me>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicolas Schier <nicolas@fjasle.eu>,
        Jens Axboe <axboe@kernel.dk>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        "Vladimir Oltean" <vladimir.oltean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Derek Chickles <dchickles@marvell.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Daniel Scally <djrscally@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 16/18] net: hns3: fix mixed module-builtin object
Date:   Wed, 23 Nov 2022 23:07:53 +0100
Message-Id: <20221123220753.65752-1-alobakin@mailbox.org>
In-Reply-To: <1d2341cc5a1843538d55fb34bd8137d8@huawei.com>
References: <20221119225650.1044591-1-alobakin@pm.me> <20221119225650.1044591-17-alobakin@pm.me> <1d2341cc5a1843538d55fb34bd8137d8@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-RS-META: ztdyaxcwfktx8pns3qxr7yfku3y5xjd7
X-MBO-RS-ID: 6b04d22ce6bbfd2fef5
X-Rspamd-Queue-Id: 4NHZy72lqZz9sTC
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Salil Mehta <salil.mehta@huawei.com>
Date: Tue, 22 Nov 2022 12:39:04 +0000

> Hi Alexander,
> 
> > From: Alexander Lobakin <alobakin@pm.me>
> > Sent: Saturday, November 19, 2022 11:10 PM
> > To: linux-kbuild@vger.kernel.org

[...]

> > diff --git a/drivers/net/ethernet/hisilicon/Kconfig
> > b/drivers/net/ethernet/hisilicon/Kconfig
> > index 3312e1d93c3b..9d2be93d0378 100644
> > --- a/drivers/net/ethernet/hisilicon/Kconfig
> > +++ b/drivers/net/ethernet/hisilicon/Kconfig
> > @@ -100,11 +100,15 @@ config HNS3
> > 
> >  if HNS3
> > 
> > +config HNS3_HCLGE_COMMON
> > +	tristate
> > +
> 
> 
> This change does not looks right to me. We do not intend to expose these

...does not looks right to me -- because? The "wrong" line?

> common files via kconfig and as a separate module. I would need time to
> address this in a different way. 

I'm curious how 40 Kb of shared code can be addressed differently :D
This Kconfig opt is hidden, it can only be selected by some other
symbol -- in this case, by the PF and VF HCLGE options. Nothing gets
exposed in a way it shouldn't be.

Lemme guess, some cross-OS "shared code" in the OOT nobody in the
upstream cares about (for good), how familiar :D IIRC ZSTD folks
also weren't happy at first.

> 
> Please do not merge this change into the mainline!
> 
> 
> Thanks
> Salil
> 
> 
> 
> >  config HNS3_HCLGE
> >  	tristate "Hisilicon HNS3 HCLGE Acceleration Engine & Compatibility
> > Layer Support"
> >  	default m
> >  	depends on PCI_MSI
> >  	depends on PTP_1588_CLOCK_OPTIONAL
> > +	select HNS3_HCLGE_COMMON

[...]

> > diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
> > b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
> > index 987271da6e9b..39a7ab51be31 100644
> > --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
> > +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
> > @@ -13133,6 +13133,8 @@ static void __exit hclge_exit(void)
> >  module_init(hclge_init);
> >  module_exit(hclge_exit);
> > 
> > +MODULE_IMPORT_NS(HNS3_HCLGE_COMMON);
> 
> 
> No, we don't want this.

I can export the common functions globally, without a namespace
if you prefer ._.

> 
> 
> 
> > +
> >  MODULE_LICENSE("GPL");
> >  MODULE_AUTHOR("Huawei Tech. Co., Ltd.");
> >  MODULE_DESCRIPTION("HCLGE Driver");

Thanks,
Olek

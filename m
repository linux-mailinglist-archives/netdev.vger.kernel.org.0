Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 091486375B7
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 10:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiKXJ6p convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 24 Nov 2022 04:58:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiKXJ63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 04:58:29 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CDD610B49;
        Thu, 24 Nov 2022 01:58:28 -0800 (PST)
Received: from fraeml741-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4NHtfL4WQMz6HJZj;
        Thu, 24 Nov 2022 17:55:38 +0800 (CST)
Received: from lhrpeml100006.china.huawei.com (7.191.160.224) by
 fraeml741-chm.china.huawei.com (10.206.15.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 10:58:24 +0100
Received: from lhrpeml500001.china.huawei.com (7.191.163.213) by
 lhrpeml100006.china.huawei.com (7.191.160.224) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 09:58:24 +0000
Received: from lhrpeml500001.china.huawei.com ([7.191.163.213]) by
 lhrpeml500001.china.huawei.com ([7.191.163.213]) with mapi id 15.01.2375.031;
 Thu, 24 Nov 2022 09:58:24 +0000
From:   Salil Mehta <salil.mehta@huawei.com>
To:     Alexander Lobakin <alobakin@mailbox.org>
CC:     Alexander Lobakin <alobakin@pm.me>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicolas Schier <nicolas@fjasle.eu>,
        Jens Axboe <axboe@kernel.dk>,
        "Boris Brezillon" <bbrezillon@kernel.org>,
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
Subject: RE: [PATCH 16/18] net: hns3: fix mixed module-builtin object
Thread-Topic: [PATCH 16/18] net: hns3: fix mixed module-builtin object
Thread-Index: AQHY/Gwia2IZVsHg6EO9Omjroyk7sK5K47QQgAIzhICAAKYBcA==
Date:   Thu, 24 Nov 2022 09:58:24 +0000
Message-ID: <1916b5a0d76e493e88ba568f9bae3f63@huawei.com>
References: <20221119225650.1044591-1-alobakin@pm.me>
 <20221119225650.1044591-17-alobakin@pm.me>
 <1d2341cc5a1843538d55fb34bd8137d8@huawei.com>
 <20221123220753.65752-1-alobakin@mailbox.org>
In-Reply-To: <20221123220753.65752-1-alobakin@mailbox.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.126.170.198]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

> From: Alexander Lobakin <alobakin@mailbox.org>
> Sent: Wednesday, November 23, 2022 10:08 PM
> To: Salil Mehta <salil.mehta@huawei.com>
> 
> From: Salil Mehta <salil.mehta@huawei.com>
> Date: Tue, 22 Nov 2022 12:39:04 +0000
> 
> > Hi Alexander,
> >
> > > From: Alexander Lobakin <alobakin@pm.me>
> > > Sent: Saturday, November 19, 2022 11:10 PM
> > > To: linux-kbuild@vger.kernel.org
> 
> [...]
> 
> > > diff --git a/drivers/net/ethernet/hisilicon/Kconfig
> > > b/drivers/net/ethernet/hisilicon/Kconfig
> > > index 3312e1d93c3b..9d2be93d0378 100644
> > > --- a/drivers/net/ethernet/hisilicon/Kconfig
> > > +++ b/drivers/net/ethernet/hisilicon/Kconfig
> > > @@ -100,11 +100,15 @@ config HNS3
> > >
> > >  if HNS3
> > >
> > > +config HNS3_HCLGE_COMMON
> > > +	tristate
> > > +
> >
> >
> > This change does not looks right to me. We do not intend to expose these
> 
> ...does not looks right to me -- because? The "wrong" line?


Agreed. Not very helpful. Sorry about that :(


> > common files via kconfig and as a separate module. I would need time to
> > address this in a different way.
> 
> I'm curious how 40 Kb of shared code can be addressed differently :D
> This Kconfig opt is hidden, it can only be selected by some other
> symbol -- in this case, by the PF and VF HCLGE options. Nothing gets
> exposed in a way it shouldn't be.


There is a discussion to unify the VF and PF HCLGE driver for HNS3.
This is to reduce the overhead of adding/maintaining features in 
both of the drivers.


> Lemme guess, some cross-OS "shared code" in the OOT nobody in the
> upstream cares about (for good), how familiar :D IIRC ZSTD folks
> also weren't happy at first.


We have HNAE interfacing layer above HCLGE, if any such out-of-tree
code maintains the sanctity of that interface then there should not be
an issue at HCLGE. These functions are never going to get directly
used by such out-of-tree code. This is by design.


> > Please do not merge this change into the mainline!
> >
> >
> > Thanks
> > Salil
> >
> >
> >
> > >  config HNS3_HCLGE
> > >  	tristate "Hisilicon HNS3 HCLGE Acceleration Engine & Compatibility
> > > Layer Support"
> > >  	default m
> > >  	depends on PCI_MSI
> > >  	depends on PTP_1588_CLOCK_OPTIONAL
> > > +	select HNS3_HCLGE_COMMON
> 
> [...]
> 
> > > diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
> > > b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
> > > index 987271da6e9b..39a7ab51be31 100644
> > > --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
> > > +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
> > > @@ -13133,6 +13133,8 @@ static void __exit hclge_exit(void)
> > >  module_init(hclge_init);
> > >  module_exit(hclge_exit);
> > >
> > > +MODULE_IMPORT_NS(HNS3_HCLGE_COMMON);
> >
> >
> > No, we don't want this.
> 
> I can export the common functions globally, without a namespace
> if you prefer ._.


I was wondering if we could detect below condition in the Makefile
itself and not depend upon separate namespace?

"With CONFIG_HNS3_HCLGE=y and CONFIG_HNS3_HCLGEVF=m "


Thanks
Salil.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96F9542206A
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 10:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233132AbhJEIQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 04:16:38 -0400
Received: from mail-dm6nam08on2084.outbound.protection.outlook.com ([40.107.102.84]:61239
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231816AbhJEIQg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 04:16:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FeWE5U6+wxtJro7bKt0AFdlG701XwOffjIsSg1T8MaftUHq0o4iR/5BJJLNwjo+MaheausghzLTcwPRqKcbdQqxfjTqFF6e+z8pryZCdeHE5s7H9Tpsbi9GB6k5hVhw3tDJyChYHYnDklCtvwjY/mI/uxWM3hOi0WXFJ5YyOxflXenC4uO2r4iU3eqZTjV5VVJ6IVYEj7SZNcEU8cXAcbMiJ7HDmk5bCMT3kZXDncsqjjC3bJ5fV7hJmyZYyXjNLuQx6v0bfCbQUTynHpUkVFLjrd9/ijvl39VRe53g9VmBqNmzwLpPFZ9e4gB54VLNvS8V6JEsEfLWfy0xyLgSc0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y6uKW/dRhrw6ee/PBXCumDSuPjDTbDnpWPhdqJbGFNA=;
 b=LwD0UgzUIOi7lyDSXrvIHdpMntcPdVQecV1l03bicrh/VfLwhbTPbiTvPF+7YdS6dgsaTKJ5buN6YQ53tNRRgj+Pjt/eDVYWOGza6YaKAFyyRPOmXTu6OTsploJL0gGoxnib3dLqWJoJMxnUiTnfxK9KMwfzFkzfIBDzHEYhGNn7sAjdfbOhYKuxN8KqYimlzZzFrt4xr6WPJi6WDGUx0FF9H4gbUaYQkK2okb92pN0gWC2Ypy/KyKz149c37gP0SNLIFi58gx4bByc+VSavKWJOlCpjbQslgwnG42f+PrP4HELQ/1eVU2jhkOmvZe2Qa0t6zSBFToqjZde0Ybe3kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y6uKW/dRhrw6ee/PBXCumDSuPjDTbDnpWPhdqJbGFNA=;
 b=RkTSKewwAnk/saH6ltUrVhLc+JLYAjWOHw6Q9muWd991msRKSDtVhNOe4kAelUQykf++2aqIl9eLKsB0u+YZ0t5JId361XoAeVmKU35wBFtLIzFY33ipBuWH+SI/yNx8EEbpJaKX7lxEWm3kYWed/1/DI8dChX+9gXIcyeZQciA=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Tue, 5 Oct
 2021 08:14:44 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::31cb:3b13:b0e8:d8f4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::31cb:3b13:b0e8:d8f4%9]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 08:14:44 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     Pali =?ISO-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        DTML <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH v7 08/24] wfx: add bus_sdio.c
Date:   Tue, 05 Oct 2021 10:14:36 +0200
Message-ID: <149139701.nbvtKH4F0p@pc-42>
Organization: Silicon Labs
In-Reply-To: <CAPDyKFoaw8rdPRdjgAJz3-T2_fS1iA9jtonbwZAYE0npUNfOQQ@mail.gmail.com>
References: <20210920161136.2398632-1-Jerome.Pouiller@silabs.com> <20210930170646.cffsuytdpa72izbh@pali> <CAPDyKFoaw8rdPRdjgAJz3-T2_fS1iA9jtonbwZAYE0npUNfOQQ@mail.gmail.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-ClientProxiedBy: PAZP264CA0042.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:1fc::23) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
Received: from pc-42.localnet (37.71.187.125) by PAZP264CA0042.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1fc::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.16 via Frontend Transport; Tue, 5 Oct 2021 08:14:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b1d684a5-e532-4738-e2f9-08d987d83034
X-MS-TrafficTypeDiagnostic: PH0PR11MB5657:
X-Microsoft-Antispam-PRVS: <PH0PR11MB56579D6E97ED5DA715B8E97793AF9@PH0PR11MB5657.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CYRNy5jJqlCPqcWbzO8MWnIGd53A/b54wjT3zya+4UNQ8gEBsvXNSaCZAUcgh3C+lLkS4G2t7wokB/KHNuhs0eGsXEm65c5jmyaP+WHQbzcb2yv5/JQZOy0qabRmPgnWlkF5Y7XDE+hGtlGO6qaDLrBY+3RiCXE7/eQ8HP1jwnwA1vy9daWpiQTOzdu8EoTRfIs4wqXiF/nvJAkIkkvKDExwLkS1srG/i691ve9szcc4lHPdVSiome3o0YKJvdYHFXmahKqSkHT9gaLwnOGOhShHMQuglAwSuWSmm4lgkXccsNCDdUQ6gDqpQr3KvrI7yrPWtV65twJzLCZA1SAb2XWpzZ8nbjCqzv+sp3G4wYnIE3mX1FZvtjfnimqMT/6SkvWiG/OgvGQOm8FMXbzmb9TA8hLX1amFOx0dyzjZVaMF+3T7hXAtO7ldoqtbBAVMoOvUam4ZKghG5DUy4DdlHjbo5BEVBIGiyiaCeXkmGIYG70oiyIIQ9m0E6FW0QDzoVYgKld7nn/10UCg8DXkaq+I31/FIE3yWa757uQhHBeWl4GPKhYM7w6kxS8Kh5KfyyCn8MF70kondF1iVP1yQuio6T7zetW4LefsE4eyygZJckDOyYTKZf/8lvvaGasFOda/PhpnXQP5XQ/L1U9Vsovhh5GDbVNwhw00cMuhkCYt0L+SMGWc9JHXckmCMxv4nlnL+yo0gpWX+NK+NVVRxltHnTACNv0ERlMEQ7ROZvxOFlKqTWtgveEN7yZX0r6UACv2f56y5yBTewMkvP0dIL4TYSSjHg5qxaLiROpQnkFCmii8OfY5/iNEv9kbsGhlj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52116002)(36916002)(33716001)(66946007)(66556008)(8676002)(83380400001)(66476007)(8936002)(6506007)(6666004)(7416002)(9686003)(54906003)(316002)(6512007)(38350700002)(38100700002)(26005)(966005)(110136005)(508600001)(186003)(4326008)(5660300002)(86362001)(2906002)(956004)(6486002)(39026012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?j/pRJS4LF+Lfh1GrhUf7OtKfTRgJtMOuSvyGRt6OZt+nASXzVE4KHkp1MS?=
 =?iso-8859-1?Q?6Fp/lHzYJYzUviqkWO9VdjX3aB3mLSrwdWLgAgPyOfsaEDd/JTsmTzoCVN?=
 =?iso-8859-1?Q?svlvdJcpfxrIcpjZVb9635QNjf4zx/MXloHDoOqCJIRzCxq6FLrR7qMrB0?=
 =?iso-8859-1?Q?RKS2N0gXmOXTPFwDGVQ6mDAsSr3RWBM49lwUBTflMf0cvKTa1qPSqrdpTJ?=
 =?iso-8859-1?Q?0sIqzkEWsVFLGVy+yCEavbgV+fHg5CBWev47whuQXulMKzKM2Qrd7pNuN7?=
 =?iso-8859-1?Q?dzmn7A6vypDW+qjc42cM5qtL67KQDuFg10LrCObL+fL8Ex+OR+cfGZIFiA?=
 =?iso-8859-1?Q?KsQTSF2uRdmtSTNtykcT2BQdDdHfSgfS/3tnil8R82yI+SQFgPCgKFXgjF?=
 =?iso-8859-1?Q?VwxtbyV74zuKvRE3r1ULqb7rMm3yYOMMdT598bseBs/LqFuVJWRf/lDEDc?=
 =?iso-8859-1?Q?01GRe21S3mg7l/Fec8TVLwByig3KGJvXHnoDZYg1vGla7oISl01qesgHFJ?=
 =?iso-8859-1?Q?N2JMRU0b+CiER0oECg+/8iYSe2T8QDVO7WqDbXxv/zcdiHPVGr3IS9F+Id?=
 =?iso-8859-1?Q?rhVhWYyLkqrAkFTvTrmbkGS753OrVbojpPSR/cO56jaB7axQh1elPiSdgA?=
 =?iso-8859-1?Q?mM87TjbdO49zNoiHMARIi9/8IX50jMVywKLOiwL9aLFw4Kj7eb2okON4LP?=
 =?iso-8859-1?Q?nGaomyy9KBYj8g8skrvVmjJ760iFPzY5m2X5+FIvvGNP5rJLwX42iwiLQm?=
 =?iso-8859-1?Q?gEDHTB69LGUeGIqtIJTRqBPitu7RzLKoMzDVJiWGr6JiLyKXDoFg6gATN9?=
 =?iso-8859-1?Q?gkfEI5sPdBzUkRSOx2/45tzA3E1Ay3d49N3SwzgVgU1urjbv6hcjL9TM4/?=
 =?iso-8859-1?Q?kvb8JZYnhvKiZVwkDZfTy5MpL/D5MpqlBMvO7BF+Ml2jllV1DtvFC0WlOd?=
 =?iso-8859-1?Q?k4KDRFboRmRZqENvYvJN1TYGVMae3gPmb/nLKRCzQSVNx1/RJawtDfKC+9?=
 =?iso-8859-1?Q?PzCqj67Inb+2AvDOcSJ17JmbY4m2/p2b8VDxUnALLvUmVTxOKW2+/jXjcO?=
 =?iso-8859-1?Q?OB/FPc8Ad4196BLaJmhNdkghgKkQuPPfI7JFLtk3X/n6AGTI7IQI8IMnrw?=
 =?iso-8859-1?Q?fsmLQuiJpPI90Wi9WetEQE/rPbMbCBqT8ATugNVJLVEMtPqwVeJyqnb7bX?=
 =?iso-8859-1?Q?AB7lFOgOA3EI8osYZbCxJ/jaYrx7kT/5pWLdOZqjS/+eleiDy+cydZJauW?=
 =?iso-8859-1?Q?UwzSI6svNl286lJqA4vWXdFWx6owLjIbZxug/Dc989nbT7fAnHWTnMVmZT?=
 =?iso-8859-1?Q?SFuKuwn70p6fi88ntwV/GHS6ZlQ5ssbkvuP4bCLM7pYjHhewfiW/nBbppZ?=
 =?iso-8859-1?Q?HwMK9498Hn?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1d684a5-e532-4738-e2f9-08d987d83034
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 08:14:44.2079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NQXzzWrvy/F5XRzUMKRpCwSc9O34yn6XZCV3aT7FV9c2dveWU04uOJKxaHNDDrkr26L4eD8uGD/ldjxsAjzMlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5657
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday 1 October 2021 17:23:16 CEST Ulf Hansson wrote:
> On Thu, 30 Sept 2021 at 19:06, Pali Roh=E1r <pali@kernel.org> wrote:
> > On Thursday 30 September 2021 18:51:09 J=E9r=F4me Pouiller wrote:
> > > On Thursday 30 September 2021 12:07:55 CEST Ulf Hansson wrote:
> > > > On Mon, 20 Sept 2021 at 18:12, Jerome Pouiller
> > > > <Jerome.Pouiller@silabs.com> wrote:
> > > > >
> > > > > From: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> > > > >
> > > > > Signed-off-by: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> > > > > ---
> > > > >  drivers/net/wireless/silabs/wfx/bus_sdio.c | 261 +++++++++++++++=
++++++
> > > > >  1 file changed, 261 insertions(+)
> > > > >  create mode 100644 drivers/net/wireless/silabs/wfx/bus_sdio.c
> > > > >
> > > > > diff --git a/drivers/net/wireless/silabs/wfx/bus_sdio.c b/drivers=
/net/wireless/silabs/wfx/bus_sdio.c
> > > >
> > > > [...]
> > > >
> > > > > +
> > > > > +static int wfx_sdio_probe(struct sdio_func *func,
> > > > > +                         const struct sdio_device_id *id)
> > > > > +{
> > > > > +       struct device_node *np =3D func->dev.of_node;
> > > > > +       struct wfx_sdio_priv *bus;
> > > > > +       int ret;
> > > > > +
> > > > > +       if (func->num !=3D 1) {
> > > > > +               dev_err(&func->dev, "SDIO function number is %d w=
hile it should always be 1 (unsupported chip?)\n",
> > > > > +                       func->num);
> > > > > +               return -ENODEV;
> > > > > +       }
> > > > > +
> > > > > +       bus =3D devm_kzalloc(&func->dev, sizeof(*bus), GFP_KERNEL=
);
> > > > > +       if (!bus)
> > > > > +               return -ENOMEM;
> > > > > +
> > > > > +       if (!np || !of_match_node(wfx_sdio_of_match, np)) {
> > > > > +               dev_warn(&func->dev, "no compatible device found =
in DT\n");
> > > > > +               return -ENODEV;
> > > > > +       }
> > > > > +
> > > > > +       bus->func =3D func;
> > > > > +       bus->of_irq =3D irq_of_parse_and_map(np, 0);
> > > > > +       sdio_set_drvdata(func, bus);
> > > > > +       func->card->quirks |=3D MMC_QUIRK_LENIENT_FN0 |
> > > > > +                             MMC_QUIRK_BLKSZ_FOR_BYTE_MODE |
> > > > > +                             MMC_QUIRK_BROKEN_BYTE_MODE_512;
> > > >
> > > > I would rather see that you add an SDIO_FIXUP for the SDIO card, to
> > > > the sdio_fixup_methods[], in drivers/mmc/core/quirks.h, instead of
> > > > this.
> > >
> > > In the current patch, these quirks are applied only if the device app=
ears
> > > in the device tree (see the condition above). If I implement them in
> > > drivers/mmc/core/quirks.h they will be applied as soon as the device =
is
> > > detected. Is it what we want?
> > >
> > > Note: we already have had a discussion about the strange VID/PID decl=
ared
> > > by this device:
> > >   https://www.spinics.net/lists/netdev/msg692577.html
> >
> > Yes, vendor id 0x0000 is invalid per SDIO spec. So based on this vendor
> > id, it is not possible to write any quirk in mmc/sdio generic code.
> >
> > Ulf, but maybe it could be possible to write quirk based on OF
> > compatible string?
>=20
> Yes, that would be better in my opinion.
>=20
> We already have DT bindings to describe embedded SDIO cards (a subnode
> to the mmc controller node), so we should be able to extend that I
> think.

So, this feature does not yet exist? Do you consider it is a blocker for
the current patch?

To be honest, I don't really want to take over this change in mmc/core.

--=20
J=E9r=F4me Pouiller




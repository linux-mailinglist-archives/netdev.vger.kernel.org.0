Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5044E315FB9
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 07:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232159AbhBJGu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 01:50:29 -0500
Received: from mail-bn7nam10on2079.outbound.protection.outlook.com ([40.107.92.79]:59616
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230185AbhBJGu1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 01:50:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y04cUwmiZ/OTV5iz0cthQRQsT0JJoyXTE567ubEqGwFbT0tRZ8T2uh5mOad7RnBxnUuSoqlvdwj5kVH93iEc9M0fyjkzQMkur7Rnb3G4kv0EGBa0W6W/aseDftsQj635lq0GgusfcHY8v2z18Mdg/GiEeVR1LRH9xpqZEAX2gAioRIpMaDhs2Wnl2iP9OiyKueraRAq1Od8ym9HsrFqGq2g3GMbP2OXInNkp6aEGsrwOQ3bqMBqlENd5+u6MJkJ6qKRMy69KwcjyxfdA0JhEBVdLUM64JObPwaBMYDbT9s3b5RmUAAOroXYUaxnlpYxdmF17nTVmIfJmLc1FddcIIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PbV6nW5baTyjEmzuxlXSA8LwDdhJlWEPQRcn+9oiSRA=;
 b=Kcom0pmEDlCEbIZ1+aa/1qy160REz0XRa+/AJ0GG1B2xN2AfWQg7cwJv7EQdUwCGghTnSSVqv/0I303GheOtPQFwe8a/qGcnq/Y5BvmSg7B4GtYzK0kQHDSXG/RsxciD2VtrkODiZMeducYjw+pwXmCbfPGx61oxQfooiSFKM3XniwWBF/e3JfBObSE20MCS0dYT4zjEPlvvJO7mXXa21DNSTZpN2Uu2itxZwkwOQ/CLBF20lFtNfCIrB2mbuto8a1s1khEWuUZMVc7srtVlPuNM67z4awSe8oqC0HNMgvwwExaDP2HCdJc6agoxlqKyo8+ADRcRNnzvHdzIe/WoRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PbV6nW5baTyjEmzuxlXSA8LwDdhJlWEPQRcn+9oiSRA=;
 b=P4SpLiKhAeagExrJvYzlWHqoC05SI2JkEHVfcEDuJe0E04szMA+kkU08irTcZhvaa7b8GKXgcdsO1jPzw0NBAPQG3A8vrYIp/8QdomxgjWkIzGSZra3yDOxbfVT5n0RI5ucBhI2xJt7xpqvVi+XJkzJ9+gYXT5j4kVW7pZ9LQZ4=
Authentication-Results: baikalelectronics.ru; dkim=none (message not signed)
 header.d=none;baikalelectronics.ru; dmarc=none action=none
 header.from=synaptics.com;
Received: from BN8PR03MB4724.namprd03.prod.outlook.com (2603:10b6:408:96::21)
 by BN6PR03MB2660.namprd03.prod.outlook.com (2603:10b6:404:53::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Wed, 10 Feb
 2021 06:49:37 +0000
Received: from BN8PR03MB4724.namprd03.prod.outlook.com
 ([fe80::34cf:5dc3:971:82a7]) by BN8PR03MB4724.namprd03.prod.outlook.com
 ([fe80::34cf:5dc3:971:82a7%5]) with mapi id 15.20.3846.026; Wed, 10 Feb 2021
 06:49:37 +0000
Date:   Wed, 10 Feb 2021 14:49:24 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Joao Pinto <jpinto@synopsys.com>,
        Lars Persson <larper@axis.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Vyacheslav Mitrofanov 
        <Vyacheslav.Mitrofanov@baikalelectronics.ru>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 16/24] net: stmmac: Use optional reset control API to
 work with stmmaceth
Message-ID: <20210210144924.6b8e7a11@xhacker.debian>
In-Reply-To: <20210208135609.7685-17-Sergey.Semin@baikalelectronics.ru>
References: <20210208135609.7685-1-Sergey.Semin@baikalelectronics.ru>
        <20210208135609.7685-17-Sergey.Semin@baikalelectronics.ru>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.147.44.204]
X-ClientProxiedBy: BY5PR04CA0025.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::35) To BN8PR03MB4724.namprd03.prod.outlook.com
 (2603:10b6:408:96::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (192.147.44.204) by BY5PR04CA0025.namprd04.prod.outlook.com (2603:10b6:a03:1d0::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Wed, 10 Feb 2021 06:49:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1a66cb2f-6bb1-4de2-2a86-08d8cd900874
X-MS-TrafficTypeDiagnostic: BN6PR03MB2660:
X-Microsoft-Antispam-PRVS: <BN6PR03MB26606B5FB6AE9163D74730B2ED8D9@BN6PR03MB2660.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B8Ytj37ZQUkkx2BbY5EchVa2+3amlGpcZWpLOX073vszfmqP29GpQ+7Po4CStvOJdMkO4c840s+LMwK0rIFQLlvXKFxaFY1Iy8fWkD/4hyzqc3ZFir6OiilZFjIS6PuJmgQjowLNOqws5LgVpYx1MC7qVQgr24DNOyETuxC06Slt1rGWtbBtcTu99o26i9vY+w/mALdJBke8EE6IWR9Xe4mqnqbCT4RymxT+Y+yep7X4GsjFPyzWrPjG1HT1oRWrQiXO+YVOrFf6wyYgbz4GViW9pmJVbFthQxdJJiv0SRr9XD+5F1NdLFIxvG2VOvGA+OtbrtZySej0WoVVn94N7aEzj/hz2fwR3k4MqCTri+Dn4CERP+4pc2cK4h6fcm94Yg9goHkm+UapsovMEFTE5emrjiruXcuLjppmP8vZx0CgFZ2aXSG0vBGTAo/0Bkh/rijkIYpmEfG3NdvgrvKhSntVsq+5XaiHEKp7L0UigX4BSvtIX/SXyga76SZtlIOVk3u5aY38FZ0nQmnHCoKnzg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR03MB4724.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(366004)(376002)(396003)(39860400002)(6916009)(6506007)(956004)(186003)(6666004)(16526019)(7416002)(86362001)(4326008)(8676002)(9686003)(316002)(55016002)(83380400001)(26005)(478600001)(66946007)(54906003)(1076003)(5660300002)(52116002)(2906002)(7696005)(66476007)(66556008)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?KDUSGnfrGT/DW3R8hCPzuG0fBRjiLE3wLDqxAKvyahhLdrZGmtCCC+XylVNb?=
 =?us-ascii?Q?kRUvaBTjas1Ag2Hz3Oc8bOsc8d4kiei04oJmGlm0SiuEwwQLPFrUpkSumIVN?=
 =?us-ascii?Q?4u0vyYWOJo/uur4MPBJOmJ+2hZSutM5eezSX31efT3GkZOUWxLB99JSNKfxN?=
 =?us-ascii?Q?2R0/diL/yFmCm2ZETcEC3Hp4I7zESUcvnblZk/5O8C972DOvyxbyHXucuxop?=
 =?us-ascii?Q?emktR6kCAykjIVhg1qCAGE6+heLBl/YodtQ/d0L6inAZ7k6O5Ba9xMesKMYn?=
 =?us-ascii?Q?M1DIun2fdT/V/cPlNcRSAHtvnEC54uX5VNDhdoDcZuiGHX22++kidp/bfPfC?=
 =?us-ascii?Q?eGERhX71djpONja7LbDA/M99gLlEOKXu1tu+4FrKXFKk9GNrtqw0fk6t3F5/?=
 =?us-ascii?Q?XseH+DU8o66aYsY6Y5hfssa92H5HIAujDjrKONGGkG/wSSevlw0Q0l6VwvCk?=
 =?us-ascii?Q?BgL/ubur0X2h8bxzWhaQq1cV8BMoJcB4cYphtM3HPQY8rdKZAAm8N8V1/HfS?=
 =?us-ascii?Q?bbv8Orf97SERClZbPn7tciPEC1rqhwpE1iH1IJThop/PK5/Y+GyD7D+yrvO7?=
 =?us-ascii?Q?0IdKIHFSFaPHwt7qY3hThAbk4G62/fu8lm4AhAz5cWaEcEhEsULvGNzFjB5L?=
 =?us-ascii?Q?792NvbyJsfdVlwqeCmzZg5QbGNNaIvjIEheNzBv0Bt46mSWrrAV57P2t5Uks?=
 =?us-ascii?Q?jxyb6pEL10Mpuuzr0e4htJfA+P8FAqjEPMkyJwiZGmcUsXGwPEZ+ICtFL9Te?=
 =?us-ascii?Q?SbQ84I8JUF3WJpmaWG2FH7VMNBdg5A+MuahEqf6XblvmvPxGeNlAPujiBsXx?=
 =?us-ascii?Q?yQkkFkvr5ugYjo6d1ZS0RfoamxbrXaZUgrWS4Og/L/+yYD1bXIHLGyYxSKJb?=
 =?us-ascii?Q?VXLOJy7qqz0HumIvrpT7SsTdElg7T5ORDk+k/TLgJvAxV0EHQAJYKdC/RbUC?=
 =?us-ascii?Q?kN5ML2xjEe8nHeQCsZZihEhb1EvY7jLIcM1LCxVRslQri0IbanSQuY4vo939?=
 =?us-ascii?Q?f6/xwDrxcgGCXbNgZeByFHXDNE2cxDd8GT8B86QCCR8PSm7i8/r5FC5R4m+u?=
 =?us-ascii?Q?WrD/Kz95AgiRZAkX5hhHqSXc60MdPe/0QOFOsMk9wlbTi6Th+Ptj+lEikXjS?=
 =?us-ascii?Q?U2EDLUh7w2cZ5Ew02bZZMxKYxK7mdl3Q+3eYIddVD+SocnKiaROyUXBmE6jf?=
 =?us-ascii?Q?DSex7HkMT19RN2wcdMlkSNJRZJgNwUbIBYNmmrdunfcfH5/rZy7rwMryiI8E?=
 =?us-ascii?Q?C4T5K8FEUulh6FqPGbqHbLh1kKrL4+eCpQuPObF9SjOT3aTg61+9kG5bgIkF?=
 =?us-ascii?Q?vxNdCwsN6UDvqkaVf+Xj861E?=
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a66cb2f-6bb1-4de2-2a86-08d8cd900874
X-MS-Exchange-CrossTenant-AuthSource: BN8PR03MB4724.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2021 06:49:37.4610
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gAV/9lfUEpc/xkeXpDRa8Snkk+P9mtmqbKLM1fxLJZn5ckEFXaZDd73/fLiko/ij3EVwLebDxadfoQ8PZvYVaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR03MB2660
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, 8 Feb 2021 16:56:00 +0300 Serge Semin wrote:


> 
> Since commit bb3222f71b57 ("net: stmmac: platform: use optional clk/reset
> get APIs") a manual implementation of the optional device reset control
> functionality has been replaced with using the
> devm_reset_control_get_optional() method. But for some reason the optional
> reset control handler usage hasn't been fixed and preserved the
> NULL-checking statements. There is no need in that in order to perform the
> reset control assertion/deassertion because the passed NULL will be
> considered by the reset framework as absent optional reset control handler
> anyway.
> 
> Fixes: bb3222f71b57 ("net: stmmac: platform: use optional clk/reset get APIs")

The patch itself looks good, but the Fix tag isn't necessary since the
patch is a clean up rather than a bug fix. Can you please drop it in next
version?

Thanks

> Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> ---
>  .../net/ethernet/stmicro/stmmac/stmmac_main.c | 19 ++++++++-----------
>  1 file changed, 8 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index 4f1bf8f6538b..a8dec219c295 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -4935,15 +4935,13 @@ int stmmac_dvr_probe(struct device *device,
>         if ((phyaddr >= 0) && (phyaddr <= 31))
>                 priv->plat->phy_addr = phyaddr;
> 
> -       if (priv->plat->stmmac_rst) {
> -               ret = reset_control_assert(priv->plat->stmmac_rst);
> -               reset_control_deassert(priv->plat->stmmac_rst);
> -               /* Some reset controllers have only reset callback instead of
> -                * assert + deassert callbacks pair.
> -                */
> -               if (ret == -ENOTSUPP)
> -                       reset_control_reset(priv->plat->stmmac_rst);
> -       }
> +       ret = reset_control_assert(priv->plat->stmmac_rst);
> +       reset_control_deassert(priv->plat->stmmac_rst);
> +       /* Some reset controllers have only reset callback instead of
> +        * assert + deassert callbacks pair.
> +        */
> +       if (ret == -ENOTSUPP)
> +               reset_control_reset(priv->plat->stmmac_rst);
> 
>         /* Init MAC and get the capabilities */
>         ret = stmmac_hw_init(priv);
> @@ -5155,8 +5153,7 @@ int stmmac_dvr_remove(struct device *dev)
>         stmmac_exit_fs(ndev);
>  #endif
>         phylink_destroy(priv->phylink);
> -       if (priv->plat->stmmac_rst)
> -               reset_control_assert(priv->plat->stmmac_rst);
> +       reset_control_assert(priv->plat->stmmac_rst);
>         if (priv->hw->pcs != STMMAC_PCS_TBI &&
>             priv->hw->pcs != STMMAC_PCS_RTBI)
>                 stmmac_mdio_unregister(ndev);
> --
> 2.29.2
> 


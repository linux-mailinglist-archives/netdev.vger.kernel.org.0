Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21CAB3C3E23
	for <lists+netdev@lfdr.de>; Sun, 11 Jul 2021 18:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbhGKRA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 13:00:58 -0400
Received: from mail-mw2nam12on2098.outbound.protection.outlook.com ([40.107.244.98]:26208
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229893AbhGKRA4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Jul 2021 13:00:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HgvXGQf9QZquOzIT6UeRt1vyoIs1/kihORYBGwRqNU/W7XbWv56tFR9RSFnY/87+Er9qcSebJbx8HePe80Sa6ae3hxi5WvTzc+ulDmZqpmmGOTVoQMeKsRK0m6Kteoi5qJjmFtewx2duenLdRl4HxTpZRfV8LnZB0H/gqnf72wG5CXtPcfjbCINynfKg7CHgQnpG3idWlhjscyrBUWFnhuYGz7EnEfXA2qyo8f1osVyiOjBWantfKO2WtTU4Gm8DzzQmprsYM7ouuXVc2lenYYexi0sDJm1Tjz8f49YsqUmsHFNfSfTYD/Ultbk5InnG0lvacGv9gyV7DqPVW0HOxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h5/PQrLBenQdivB2/wmLXu+k9MiKYb/1nnVaNaUsw3s=;
 b=Dga+mL7G4zoEO5yFfH19H4Zg85AXV1asff2dRNVNIgMlfB+/pGbu+lJuidjVpUMvT6qsP+Wna1EMaGU27vDXTEJSCWtDrbKNyjZshlVqwPr8gROMknvbph94kXWE0Bb3CkjQ8UgMc3PDkkIEztuvO+0jjxxjqTv88SE3db91G7tBiwmKk+00MHqjHtHvmQ83e1ffSVpFcNslSl6Y9jV48sAJ206d/LD3IUKPCB+swFuw42BOI5ATiq2Bg+Jyy+uAfPPMZ656wfb/BeqBMFRZ37lrUdCx882cNkzF0XoYv12gymT7sdv3Q9U30OUWBQpfwfflJlxYZkuv/2qCNHAh9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h5/PQrLBenQdivB2/wmLXu+k9MiKYb/1nnVaNaUsw3s=;
 b=SnCgk9RrW8keqAvA1S4/07TyfgIhq6Lq5s5z7NCq/HHYpMgsXefd1BKnyas/am60vM7Lk6716NreWhCoyEdDFPztNavYKvB5F0R6zi//XrLjbOGsgkCbLwQiNVnZCcPFbDn+VKCKsGNTFQWiYFrablSZyRK+2NwM/DRaxP59E/k=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR1001MB2175.namprd10.prod.outlook.com
 (2603:10b6:301:2d::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Sun, 11 Jul
 2021 16:58:08 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d%3]) with mapi id 15.20.4308.026; Sun, 11 Jul 2021
 16:58:08 +0000
Date:   Sun, 11 Jul 2021 09:58:05 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 net-next 8/8] Update documentation for the VSC7512
 SPI device
Message-ID: <20210711165805.GF2219684@euler>
References: <20210710192602.2186370-1-colin.foster@in-advantage.com>
 <20210710192602.2186370-9-colin.foster@in-advantage.com>
 <20210710203411.nahqkyy4umqbtfwm@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210710203411.nahqkyy4umqbtfwm@skbuf>
X-ClientProxiedBy: MW4PR04CA0097.namprd04.prod.outlook.com
 (2603:10b6:303:83::12) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from euler (67.185.175.147) by MW4PR04CA0097.namprd04.prod.outlook.com (2603:10b6:303:83::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21 via Frontend Transport; Sun, 11 Jul 2021 16:58:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95a37b8b-99d9-4755-dca3-08d9448d0eb8
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2175:
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2175133725C2C2222F3D6062A4169@MWHPR1001MB2175.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M01uoSjQIgUTfgbGEXJFg3ClqjwpYdb2DvK2WrDK7OO6yUO2KrIUAbMuQis7WYycnKi22qiPi9fOppCRXhqSeKbgeMPOZGmXgwktmvzd2eP/Lr7p3Rksb/QR5R8/gbpxFgIpIbFaXPc2tnDM4PIoiJCCaLBfnpUoEyMoJLduyRKQy8KreuF9g2I16c1vOIozV4hPHqj02OIzXfMRPH39h3Wxgppsxvc/n2wyFp+M+brRBdg8hL1typQJ/Wysyf8Wl/kpLQLGexdKi9o6W6UzPrs44aSiNuCOIatbUI5lwZIi4tG+kDBKK6DHqLy1kFEgyeD7WIRdEjwt/DbYf+YxxtZSeX8FvlQeevvWrbXSpTEGLIPVJ9kqB2/aurA/rmvc6v6fvGDMij50SrgR/VRJ/oPjcTy8IIpxF+dV/dmPkmTlpO4uaBKPkwowU/n8oZ//HnfGCmpHz3AvqEKCj3MayHzrtZecbQv2We2w8HtT3/BSDzx6S1G02tLHN8ksHsoSa+xMlzXAoyy5bHdLf+Zg+2wLhXrDN0+jn/LOPDtH5fQE7AwUmWuuCpL/BJItzeVZu3YhVmH1Ip39rq6IEUtg4gh2dtTLQBuZajCrxZfgb0En4etfwZ3K/q/OJKkPuZeE6B6RR1ScYPrcILrTKta5+0pzz1BBciTvqCsYGavneOGizQ5Ixtlhzil3ZVZknM01CFavfEJTz9Yf4sAJLevBTOo6q5pTi6sc3rnr9hPyZAut5kectCNhE5rKvgek8IUZYSJATn6rsBBNZoTGcOAa1avieRjWA9Hxx1p0gd3+meA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(39840400004)(396003)(346002)(376002)(66476007)(55016002)(38350700002)(38100700002)(66946007)(33656002)(86362001)(66556008)(44832011)(6916009)(8936002)(316002)(83380400001)(966005)(4326008)(956004)(2906002)(33716001)(26005)(9576002)(6496006)(52116002)(186003)(478600001)(1076003)(9686003)(7416002)(8676002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NJLF9BLmQ1A2oPhoTqEIWi0wrjx4AR40z5iapm5xRXcK1SJWbDtO+IpyyJF/?=
 =?us-ascii?Q?E9DZuFHe+X0i/3z185YPFZ8GO+z/4xCw0U0VWqF6BDfD2or31cGMj7NaE4tT?=
 =?us-ascii?Q?h15fCc/CUr3u0WZ+HLXayosU4jmAOv/2+kW/u2Cm60IEvIS8zqdUb6cab18p?=
 =?us-ascii?Q?7iIqiRL4xYb8LNhoQDqm/wUn8gZ0wHWdT1aPcd7aEAjZJNgiYFeEYwkTC/Ti?=
 =?us-ascii?Q?taTtou72EkxyElu71vub/qDRoJe4Dy9cdJLqazq0KsobsbfRrovExOf9pnkb?=
 =?us-ascii?Q?1sCwwDDSTRDflangJWl4XEfEw18QZjRDfmRjA8uqjFX9quk5Q5J/A/T6RkPV?=
 =?us-ascii?Q?1Iw9sheAAy84weHn7RyZUM3tQWUb+5RWYsxxdra2KKyKgNhOoMPo20XVVlqk?=
 =?us-ascii?Q?qkXS8TsYkPv4aRxGWmfaPCbnDUpx/ZzxALuGkqXPdPFLCIyiD5LbUyJuluuc?=
 =?us-ascii?Q?DeGvJ+RssDpuHG8oj0p+qm4dXWCrsCKUD33DeBjvNs9pmEdDZqbZeEkJogmX?=
 =?us-ascii?Q?rTtCpl2MvOVxv2dEfD9gl2dRAdbCLaSmgcjvB8mGlXuAX+irb+XDFWXMh+rc?=
 =?us-ascii?Q?iLwhXHRfXWmlhfwUB2ESmR4MhEs9mIbITQcWBwuuOWsMX89bDl6Jw7fq1b8S?=
 =?us-ascii?Q?AgF/xoHLwMfauHcKSQrnQmqcbilR8zFx/S2zHI2/mxGBgwG4P9lCbED4tKHR?=
 =?us-ascii?Q?c3yipCzUxQOAEG/EXR6gEj9/vycp7LVPtnsUoWBs04gDD2KbV06bsHW4L5yD?=
 =?us-ascii?Q?P4Vn/rF84RbiFKMjkh1gFbtIsNwew//ak/5eRuyqnURGibugHL59NdGIqMVI?=
 =?us-ascii?Q?4RhiG6tK+faExDDhbDl5AM7wyO6fQtDbiC8wpkFVmj8YHbBD/DCZ56hJ2fio?=
 =?us-ascii?Q?8kzoAT7vmZcJ1tDugm6tQ75NH80QwzcCVH/cJEfUBUmKVRj6I5L8w2x0Wagx?=
 =?us-ascii?Q?+2nUrMc8KqZKcXqBFDBoCSqxTqzpcJPabzreIoLGDboY6DUOpYsYuXj1+pft?=
 =?us-ascii?Q?RaYHKkkDallQ/GewfSuXrbFJQEdmD011Zisa2VCexlQ5qzsNFiI/V20LK1WK?=
 =?us-ascii?Q?kWJOLiiHUYNDeOSF8CaFf3niBeHo3viV4jfK++o6DRO/AFatHw0QiBIelZOE?=
 =?us-ascii?Q?fVNzo/IAn8mNO9OtPn4mOLUS9dGIOkfByIpk9ACe9EaTYq9x8jU8vfmXSVQp?=
 =?us-ascii?Q?+VDiQLPL7KPwpDTaxUah7/pawx3pjMG4sHCWQdZZlqKLxU3Az+mEOwVYxNrp?=
 =?us-ascii?Q?s8lXy3VxEpygtI0feLZwclotFBUz44KhkTZX7WArIwdOcp4Gn0tA9+rCQYkr?=
 =?us-ascii?Q?ajXhqAli1kpttLo5VGrlP5SU?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95a37b8b-99d9-4755-dca3-08d9448d0eb8
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2021 16:58:08.0118
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uE6wzgmKN6C+/8eP8p1TaKhGBqx+PviREzI9sSdQmIk37Eg4zM8p2b604NE69RQnLwxv02hyKLR2cna6+QQvjpjCkiM5uyOb+Ep4Db27qfc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2175
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 10, 2021 at 11:34:11PM +0300, Vladimir Oltean wrote:
> On Sat, Jul 10, 2021 at 12:26:02PM -0700, Colin Foster wrote:
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > ---
> >  .../devicetree/bindings/net/dsa/ocelot.txt    | 68 +++++++++++++++++++
> >  1 file changed, 68 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/dsa/ocelot.txt b/Documentation/devicetree/bindings/net/dsa/ocelot.txt
> > index 7a271d070b72..f5d05bf8b093 100644
> > --- a/Documentation/devicetree/bindings/net/dsa/ocelot.txt
> > +++ b/Documentation/devicetree/bindings/net/dsa/ocelot.txt
> > @@ -8,6 +8,7 @@ Currently the switches supported by the felix driver are:
> >  
> >  - VSC9959 (Felix)
> >  - VSC9953 (Seville)
> > +- VSC7511, VSC7512, VSC7513, VSC7514 via SPI
> >  
> >  The VSC9959 switch is found in the NXP LS1028A. It is a PCI device, part of the
> >  larger ENETC root complex. As a result, the ethernet-switch node is a sub-node
> > @@ -211,3 +212,70 @@ Example:
> >  		};
> >  	};
> >  };
> > +
> > +The VSC7513 and VSC7514 switches can be controlled internally via the MIPS
> > +processor. The VSC7511 and VSC7512 don't have this internal processor, but all
> > +four chips can be controlled externally through SPI with the following required
> > +properties:
> > +
> > +- compatible:
> > +	Can be "mscc,vsc7511", "mscc,vsc7512", "mscc,vsc7513", or
> > +	"mscc,vsc7514".
> > +
> > +Supported phy modes for all chips are:
> > +
> > +* phy_mode = "internal": on ports 0, 1, 2, 3
> > +
> > +Additionally, the VSC7512 and VSC7514 support SGMII and QSGMII on various ports,
> > +though that is currently untested.
> > +
> > +Example for control from a BeagleBone Black
> > +
> > +&spi0 {
> > +	#address-cells = <1>;
> > +	#size-cells = <0>;
> > +	status = "okay";
> > +
> > +	vsc7512: vsc7512@0 {
> 
> ethernet-switch@0
> 
> > +		compatible = "mscc,vsc7512";
> > +		spi-max-frequency = <250000>;
> > +		reg = <0>;
> > +
> > +		ports {
> > +			#address-cells = <1>;
> > +			#size-cells = <0>;
> > +
> > +			port@0 {
> > +				reg = <0>;
> > +				ethernet = <&mac>;
> > +				phy-mode = "internal";
> > +
> > +				fixed-link {
> > +					speed = <100>;
> > +					full-duplex;
> > +				};
> > +			};
> > +
> > +			port@1 {
> > +				reg = <1>;
> > +				label = "swp1";
> > +				status = "okay";
> 
> I am not convinced that the status = "okay" lines are useful in the
> example.

Fair enough

> 
> > +				phy-mode = "internal";
> 
> This syntax is ambiguous and does not obviously mean that the port has
> an internal copper PHY. Please see this discussion for other meanings of
> no 'phy-handle' and no 'fixed-link'.
> 
> https://www.mail-archive.com/u-boot@lists.denx.de/msg409571.html
> 
> I think it would be in the best interest of everyone to go through
> phylink_of_phy_connect() instead of phylink_connect_phy(), aka use the
> standard phy-handle property and create an mdio node under
> ethernet-switch@0 where the internal PHY OF nodes are defined.
> 
> I don't know if this is true for VSC7512 or not, but for example on
> NXP SJA1110, the internal PHYs can be accessed in 2 modes:
> (a) through SPI transfers
> (b) through an MDIO slave access point exposed by the switch chip, which
>     can be connected to an external MDIO controller
> 
> Some boards will use method (a), and others will use method (b).
> 
> Requiring a phy-handle under the port property is an absolutely generic
> way to seamlessly deal with both cases. In case (a), the phy-handle
> points to a child of an MDIO bus provided by the ocelot driver, in case
> (b) the phy-handle points to a child provided by some other MDIO
> controller driver.
> 

Yes, the Ocelot chips have the same functionality with the indirect /
direct access. It seems like this would be coupled with the other
discussion of updating mdio-mscc-miim.c so that the MDIO bus can be
defined.

And thank you for pointing out some examples. Having some starting
points really helps!

> > +			};
> > +
> > +			port@2 {
> > +				reg = <2>;
> > +				label = "swp2";
> > +				status = "okay";
> > +				phy-mode = "internal";
> > +			};
> > +
> > +			port@3 {
> > +				reg = <3>;
> > +				label = "swp3";
> > +				status = "okay";
> > +				phy-mode = "internal";
> > +			};
> > +		};
> > +	};
> > +};
> > -- 
> > 2.25.1
> > 

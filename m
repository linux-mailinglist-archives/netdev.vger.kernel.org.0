Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5134A4D4A
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 18:32:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380994AbiAaRcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 12:32:53 -0500
Received: from mail-mw2nam10on2123.outbound.protection.outlook.com ([40.107.94.123]:42267
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1349646AbiAaRcv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Jan 2022 12:32:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LUr6M819xU0W84MmXWmJ4N64u1GQD5PCvlf0KGJ8ZyJ1+zgj8JR/jjLqwHlOL2N+t/mYDLnZnkDFCCkACV6qHp7f42FYIjxfgUYPLFxzPQjv63M+s/coV0b/ptZ0y9Z/EhkZWcprN+/CBVARMVydDWAOf8aXwJopB9QgUuv8ehhw6TM9Fcbqf1KtnXownouQYARiM2DKy7o3imdi+OD90YJWGnHwDH7kixjpNklLK6hFs5N4PFnn8ZB1f7nTGWziad6X46yTD6YO/aIO60dv6etEawxCxoN5jq4UKkyeicO2o+hMbYcKrX6uDiJfcrcU0ET12zM9iFPo8r7GsWZ2RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6yjDTEykRe0l/vfQ+RV2PieS3wBvX/e0SdrlhVdYvug=;
 b=CB0jbYKmCyRikToowTKeKJFXtlZwR4ipDIVWhfj53cwtOOBIBgltH2XgGqXcPUYHpdwXWHZnH2Qv1sbont9Xdul1ZBDhHm2Umz0cwbOhH6a9smUKaOAkrRAyx1oDGWH9PF3NLRBOq5HOETyaa6/dMynMb8+Vkf6j9Ux3pMa0IwjFtUHzoz44u76KTCwGBamLGTDjvC2j/HBkvRGn/XGlvo5RuKnerCe4UnrA+NIV0aC9zCEkfVMPdu2ZrNqcYmpVzep2VhX19BDLTAdxLmCjzoW3iV6R+C6Bm9yVVpk9zMFKQxmp5F7mImHcbhd4gbKi+i2pj1TvHyW1RDBsitZ6Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6yjDTEykRe0l/vfQ+RV2PieS3wBvX/e0SdrlhVdYvug=;
 b=wUInG+UbxFfJsfucdX/E5tgD35Da9rQG6hpx+SgzVRBmsB0rVUmn+SeriUoBlkkEVI5FbwdUXf62VtVATwsOt6Trpg60XnyInfVMagCoMyhPHMmNf6tdjhgTUGzD1pxcmWD9CxwcvGDbDrDj+OLdMTQATNmE37FONUCgEFFVdM8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BN6PR1001MB2178.namprd10.prod.outlook.com
 (2603:10b6:405:2e::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Mon, 31 Jan
 2022 17:32:50 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4930.020; Mon, 31 Jan 2022
 17:32:50 +0000
Date:   Mon, 31 Jan 2022 09:32:58 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee.jones@linaro.org>,
        "katie.morris@in-advantage.com" <katie.morris@in-advantage.com>
Subject: Re: [RFC v6 net-next 4/9] net: mdio: mscc-miim: add ability to
 externally register phy reset control
Message-ID: <20220131173258.GA28216@COLIN-DESKTOP1.localdomain>
References: <20220129220221.2823127-1-colin.foster@in-advantage.com>
 <20220129220221.2823127-5-colin.foster@in-advantage.com>
 <20220131171318.ryule6y6ffowbrsm@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220131171318.ryule6y6ffowbrsm@skbuf>
X-ClientProxiedBy: CO2PR04CA0112.namprd04.prod.outlook.com
 (2603:10b6:104:7::14) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 19723e15-cbb9-4ea7-ff7e-08d9e4dfb40d
X-MS-TrafficTypeDiagnostic: BN6PR1001MB2178:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1001MB217834FB119E7252BE5BD551A4259@BN6PR1001MB2178.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HHt4rqIoK28wUGzC2/lSvyxar8L/muWXO4HI1HPLpgH5xi/Vl6w5wwm2mC6Q2xC+/ZToVtRXW9jVK6sCrt2YPdO9EJRPFqBzvhi8x0ym36VKeo8+xY+sZopTIqaF6XL+uv/48eewwXDeV0wJUVMU2aRuhcqvIuzc8OnN9PeTcqx81hD318ZprkOg2wSj78/SvteCyx3fm+OE3j4TBkEnBLkhK+MPtG0YWyp+/UDzUD1ywJiikGaL6v+Y+hxBOM/cryrCD/yBFBUDkkUsM/fHyMukGUyIkHzNBZcRty9Y5KFV9LB4dIh0qfo5kFmFb7TXeLV560PoaJQB5eIr2khkeJ9eA7N7c4A2tOyJ+3iD56bjJx1jTR8a+ZHaBVJEbU+AHd4putQ14XgST6Ds2mXmOGHau0SokEYwPi4ulhcmQxR9yZk+g9g/e1sgCLvryhG4I5gSoxjJUisE92+wLsZENGGK81bevPpyeZbSdXQjshK2pY6Rt6VJ4Wxm7Ou2ZxGUx4JJ2KvaiuMhnKcKBch2tayGbpQmZ2q7xglwmLU2f797CEFneG8n2Bk09lviDNfcfxOGq/H71GmBRiUik/OeOoGlZ/aY2ydMEv9HReeo/ZQaPpHtND5BqDIO4wVwMCEmPCzAi6oKYTwmnYt4zh/4K5h6uOEmci4xNn0xmOwttFUBb+8ofcc0gxaNn/oKQ5+Cmlj2n8By0gCNDENf1zGYoA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(42606007)(366004)(39830400003)(376002)(396003)(346002)(26005)(1076003)(186003)(38350700002)(6486002)(38100700002)(5660300002)(508600001)(107886003)(9686003)(6506007)(86362001)(6512007)(52116002)(83380400001)(316002)(44832011)(54906003)(8936002)(4326008)(8676002)(66556008)(6916009)(66476007)(2906002)(66946007)(7416002)(33656002)(4744005)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ckwmohITuBMnL3awEr3jzX76UzJ91GfQg4Q4IDGDLYBP6hfO/vZHSBuSvL4N?=
 =?us-ascii?Q?0D3+8t9zQeTpH2ILNALpWquHxiiF7MsK534HI1nBnjPOI7ox10aBEMZPFoSl?=
 =?us-ascii?Q?CgXIlh4sPExXti78FJvNn74MQT7K+7sImQQZ1ZkWqS3G6HwmOB9PDt0QFwys?=
 =?us-ascii?Q?cCCI2GvehnbLMa1KdgNulUrSt/qA/5Ld79Vvo/7IK3XTWIcZ7qmdMkZQpbuY?=
 =?us-ascii?Q?ZY5+no00ruZ2NGj7/oI03mdshl+BzMbW0QIF8QZWAV38pv7cruvCBM1QA8z7?=
 =?us-ascii?Q?lw0CcxOsYxOLjIGY7I4dZriUAzMf5k0uJPV1dW6/O/V8HBs1jZE9G3nVFDzJ?=
 =?us-ascii?Q?y6ToCuQ+gkuLMCUpoM3xs4e1w3+aMr/r2oOAjqdeRLk+9iXT8YsOzWQlRbvs?=
 =?us-ascii?Q?2WO2luhrTCEEv3VunzG1ijtQBhUyb057CKnP1EW2uSWOTKJXAs2i+FnXf98V?=
 =?us-ascii?Q?9aLluPLLyYM+G9N8LJcHVMqBHuFFGMttYmli2yHvWSoKH5e//HdaHV7lVH9G?=
 =?us-ascii?Q?5c/BeEVrNRCkg5ZcmGppuIaUkMdRBvnbysueIXKFKq2FG8x6Vv/cYbAkVzIS?=
 =?us-ascii?Q?xd6yxW3omSd9wp0xULxvdeGehPLWO0Z1Fail1UXjpf9hB55Bp7Dm+BpgayRk?=
 =?us-ascii?Q?h2mFWa3e6qW+EX2x3Pl3+prrJ2vGjsv+iE0Li9tqPtNKrrD2p68cT6UYGtU7?=
 =?us-ascii?Q?SWLnyrKfYIDkopLGPsEAdzjM+1WnSz+BpGCSu4VYV5EWirWZLys+3IAKIA+Z?=
 =?us-ascii?Q?ZArpYrcNWqDGWs9mXKc8izeZQzxpSxnHC1WPjcVVVNVLJndyrqMq+GuF0g2F?=
 =?us-ascii?Q?mpWmOJQDckssbiXoUuENXSfobUBHzRLVrFua+lGiyJjXbgJWFV3AdpsKRJ0E?=
 =?us-ascii?Q?DCfed80CpWIWE8c7UxT1GBfbwmlGWVmQMYd+uC6woEMiL01w5Dw/aWEVg2oK?=
 =?us-ascii?Q?/Rmhy5J+fs3OjPcGVUOiP/6nHKMCi5uHdX2jd8AFqRVHEnRIg8XJ593BntLb?=
 =?us-ascii?Q?fUs4osVT8MTCbrYnghleYDtq3L4anNTkeLsir4FNNmR0iksLCv4wcL7eitrj?=
 =?us-ascii?Q?lfG7O//SuGpkf3JrzLLn7uMh/3Hk93wBxO6p8iS+//AO4cfVbBE8nwwfiBHE?=
 =?us-ascii?Q?gcaKGpyerO2PE1vhDCZq44TOZMS8xHCD1Of45wn4dj5DwMIem+PkisO80VPM?=
 =?us-ascii?Q?VU4H34UmczDFnZvfEIn33IOVMbsfCuZoP6ZZbNQWWC9OosilyMxV+/nwFOTY?=
 =?us-ascii?Q?83okQVeyk9hwSDhSOIzP+UYGhxJGkgsz30LC8/152YofNE0v0+s1T4rw0vDG?=
 =?us-ascii?Q?LGj+bwYN0Y6q/n4RPkQBEdn3sGeVZXbz4tN17qkuGv7qeTinBjfL53I9U9o7?=
 =?us-ascii?Q?2oqxrEohua7/KqKtJgIw7eIq2PmDoSoUGPsWW1L2D+j8/FC2N18odTwEvF/6?=
 =?us-ascii?Q?BXDNC28eIIPUFuVzencmfnMa74F+iujv/pImFWNpn0QV1U+xkort13lx0Be5?=
 =?us-ascii?Q?eiQNMnaCNxvGVvd76W6RoStyobXGwOHU3SDIUO4vIcTXX+hNtAVdhloYZAbD?=
 =?us-ascii?Q?9yGwyLVfcZu7dpxCy9PBS9Wx79ouamo+rquwzzWwTc7k69Ti2awd95iI1P4A?=
 =?us-ascii?Q?pVnioDHGNMpmc4/ReRrMvXlzhnFvShcGO7hd6lec0mEi8MD6yqcJDhKOvOPF?=
 =?us-ascii?Q?KpFU2w=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19723e15-cbb9-4ea7-ff7e-08d9e4dfb40d
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2022 17:32:50.0698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BP/9ByIWZWos8jB8ugOTKR9x1OtT75eP6KCpsorxvtlu/gP0Dkm/pj0NezZPTihcQpRzFXO875Oo9U/pcg82ZzGTtfan23Gk92wnpOuVduc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1001MB2178
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Mon, Jan 31, 2022 at 05:13:19PM +0000, Vladimir Oltean wrote:
> On Sat, Jan 29, 2022 at 02:02:16PM -0800, Colin Foster wrote:
> > @@ -257,15 +260,14 @@ static int mscc_miim_probe(struct platform_device *pdev)
> >  		}
> >  	}
> >  
> > -	ret = mscc_miim_setup(dev, &bus, "mscc_miim", mii_regmap, 0);
> > +	ret = mscc_miim_setup(&pdev->dev, &bus, "mscc_miim", mii_regmap, 0,
> > +			      phy_regmap, 0);
> >  	if (ret < 0) {
> >  		dev_err(dev, "Unable to setup the MDIO bus\n");
> >  		return ret;
> >  	}
> >  
> >  	miim = bus->priv;
> 
> You left this variable set but not used. Please delete it.

Correct. Good catch. There were a couple of these in v6 that
kernel-test-robot is happy to point out to me :-)

Already fixed in my v7 branch.

> 
> > -	miim->phy_regs = phy_regmap;
> > -	miim->phy_reset_offset = 0;
> >  
> >  	ret = of_mdiobus_register(bus, dev->of_node);
> >  	if (ret < 0) {

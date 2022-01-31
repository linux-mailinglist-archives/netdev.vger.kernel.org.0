Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7024A530B
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 00:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238024AbiAaXOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 18:14:37 -0500
Received: from mail-dm6nam11on2138.outbound.protection.outlook.com ([40.107.223.138]:25857
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237951AbiAaXOg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Jan 2022 18:14:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G9ThAI/Z4048nOKVsaLYhN+Ki3MKu+y+9J1URUE2t0dL59kkT0sXz3+trNvUQu5Rs+4x6T1OYlYBxjlN8WvkvP2zNphXke55hBdiWokJsEORj0jESCNEvRx6yEYyKhgJ5kXnvBN5OM8jyLaRFgUeAgv24pXu4gY//dydn6pjHSNekN5834/CC8RUDqknvu4vay3eDKjo6Sx6wP3ODAUu+VmwdmsBWMYjIlEOZOkwM4sbFivDoC5gtbvn6AShIXTeMskS8EJE8UqUCc4xDAt3xkLca67IkZu4iSnnvRbl3JF0b3Tshlm6Vv/S/T3L9qDvnPW+LkyrLeI9JpaPpw8/+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O5YNHXmTCtoRgeA+Dcyn8bp/VRfnL62brLCbfwgyP3o=;
 b=bqgTuSCDJZCGuXR19KPd5MRu2SC4W2aYQnVepZsx2Alp6xKjZzhmHLYrJiD9kme9eZb9H7oghXc7pYxepuH4J8frcM1wSoW6OXCPqG1vlOZfz7PXcDD9vuaA2UvabtmYk+LKonMM8eKq58koexdXLjuoWxGVl6QRnyOjixbm+s/xIyj4d/B/55dqvXFu9nCbFEKJYDPqxWeBTCT9AthAMz73WseEACYPbtwDgPt5UpUU4hpTcG5riP4wbOZ8br2fMtrZplLEtmxMwAuJFyXqJYDW+9FwvqN8B/zu2iUHDzkf4mCmuVWG4PrV0hnrzSMz/2xHIIusqwwEHaSq9zDF0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O5YNHXmTCtoRgeA+Dcyn8bp/VRfnL62brLCbfwgyP3o=;
 b=M1ug1Wj5nqjk58pnSeV+MchHPvilgn3JSZPXpYb5xaqjyZmVpJ33Zvz7MbWQWMcBfaBPyHnAojxxMKaRvoellG4Vi08bZP4gVlSGgADNJBioUL/gKfMX8DLgSkm9uv6dWonvQzQpw8UOSqXDOhcVE+fDutiOiPhVONN+3j6LSCI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BY5PR10MB4274.namprd10.prod.outlook.com
 (2603:10b6:a03:206::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Mon, 31 Jan
 2022 23:14:33 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4930.020; Mon, 31 Jan 2022
 23:14:33 +0000
Date:   Mon, 31 Jan 2022 15:14:29 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>, katie.morris@in-advantage.com
Subject: Re: [RFC v6 net-next 2/9] pinctrl: microchip-sgpio: allow sgpio
 driver to be used as a module
Message-ID: <20220131231429.GA10212@COLIN-DESKTOP1.localdomain>
References: <20220129220221.2823127-1-colin.foster@in-advantage.com>
 <20220129220221.2823127-3-colin.foster@in-advantage.com>
 <f9e160d8-09e9-46af-df7d-8f128b5eab4b@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9e160d8-09e9-46af-df7d-8f128b5eab4b@gmail.com>
X-ClientProxiedBy: MW4PR04CA0048.namprd04.prod.outlook.com
 (2603:10b6:303:6a::23) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0bdd83f7-db5f-4cab-b475-08d9e50f70b7
X-MS-TrafficTypeDiagnostic: BY5PR10MB4274:EE_
X-Microsoft-Antispam-PRVS: <BY5PR10MB42749F16004F3DD7588851B1A4259@BY5PR10MB4274.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1122;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9su6U62KGL3cHbESTEgDLuklJANA8wXkTjLjFZgJHbn1Pnt4E9XtMyI+BiLM9eptSuI4q135kHbkAsBfmVqK5T4Ipq3juJximBrhTX4JsEtnKj2C5N5rS0LtJvgQs7VRNK9XJ6fB9OFblykTv8u6/xYH5UMA9nlfz+BMcI/AtECFtUgwWvrtkmjZhY08nPFE3oRho6PqdHC2k2fvPTPdnGUvENJi6cfGDdtBWcRwVQfr1UfYu0hTNYwwhEgm2QLKDbHuCPEuSUePCg58flfMxAanHlBIfiA43cRi5y0oGbaXjnH3UJ+ZYUOlwceVtev90ABtVLU8RGbwX9IRo358SJOw291L3S7OYSFr40S8yCs9+NNsQw+5wc3Afuj1FiduaAjbz4qzqxsUZ8mCgaNr8Bny/gU2Rt/dmdLcuUWGYbWjzWm8V7O1QOeOohQHxrTz5ntzD8pTwfzOHBwq+mrd+mpFd2IHHdIOJ2CVilYtW8vrSoSXmMFhH7CNuWtY9XcJX7vjatmrviQY+t/u0jMoj2w0BU/81A8B7SDG2GHCjCXzhswHL4oiq/RwboX/HYaflEy2Yk3d/clkKAFPdQQH3HGIcfPLarUBW9RVcQF23rGq4LhiIwIleqrKFVJyUo8n2bvSPSHCVdg+74qL6FLrbQUHJdiDB9VGhtHD2fhh0XqQZofMyKgRyEORHAABuZYYMOBuDp5C4rZLWGtEX44sdw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(39830400003)(376002)(366004)(136003)(42606007)(346002)(33656002)(6916009)(53546011)(52116002)(107886003)(6506007)(6512007)(6666004)(86362001)(5660300002)(1076003)(26005)(9686003)(54906003)(186003)(38350700002)(38100700002)(4744005)(2906002)(6486002)(4326008)(83380400001)(44832011)(7416002)(8936002)(66476007)(66946007)(66556008)(8676002)(508600001)(316002)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aUJlTTrSofQb2yvtS3b8DA86zsOoFXXymF8z6uNI1thxOZ8Gkx5CruN0XL3+?=
 =?us-ascii?Q?Vj/NM/nlwMSNqWrXYNtYu+Tp10MXopRCn2aWWQLuXehSwwd848xKuGX7fpke?=
 =?us-ascii?Q?M4LS9p/rqGrjO8EisK68XN42dcOgRc32CXyFOGEf8JzrubPQ58YtrRedWe40?=
 =?us-ascii?Q?f+u26blsr7x/PcxDagMOGwhjgfwisGoE1fPaNY4TjQfVtjGqTAf1OabHm3AU?=
 =?us-ascii?Q?PPXi/NTE7NgbRWHbulf4ijsArloZ2DhDRUwtm1tTVBvSwgaT700w7CN1okmX?=
 =?us-ascii?Q?rquo2e7v+D35dPyTGCoFKwK3PcpQfeRiDlO4X3AWN6+TrvOy/FXkP5fdfFYR?=
 =?us-ascii?Q?wDOjzzGjvW8wIbiPj7oD++wWcAkoXzXX6t3CJTgMj7wILsCb3KoV3DS9nPXQ?=
 =?us-ascii?Q?nBogyDV2M7o5kMKq/TBmzE8I/iwoTcztcuOzF491Te4+O6sOHDmVs0oNeH+T?=
 =?us-ascii?Q?GuX1vaqGh2VoERD6yHB9IrUjCk98Sjf+A9yVUk69E2OskznkirU8hxHa6hfI?=
 =?us-ascii?Q?Dm19+I32tIscz7924cVRf9OXqWxqS4k8kGOWIoW5/5PKRwAi1XDVwgx6c+c9?=
 =?us-ascii?Q?aqMDKmRTHpd6dvX3hgzSu3GyTss08Sws39Z2Rzbq4IUnP+TI9tPx2/D1VGwe?=
 =?us-ascii?Q?/WsWBeM+20W8rWRAlSU9QlhEjRaPVBcfnd+BpnESR8MaG0a2Z8k1LfQRzSHq?=
 =?us-ascii?Q?VaQETIwFaFUaKQHV11a/rA3HONRgPsS4l6bBhFldby/UplKgBd2qzzZAPXuY?=
 =?us-ascii?Q?v8jvJIRfh6vNjtz2sTwdpTojT41bvS0oVA2qwuZjoxE8qvkvY6ZC+iadaoUf?=
 =?us-ascii?Q?Z/mGOhiY36z16GmEtdIhcYOq8zQUvQ/U3RJNlrELSG6aW6U8+mFhen+EQVGq?=
 =?us-ascii?Q?/ULFZizeL4EDiKCjIr0ETYhe0T0tF4xDN2l278HJksrDziOUUZTBQwKhqvfU?=
 =?us-ascii?Q?826FzQwXLIEVQ4FihRDM2DKg6KaXK0dO4JHw36wADbP6PnFZNZKtufaAiZyc?=
 =?us-ascii?Q?BMIUT8GtgIt6n36beTwel1oMp7zKLLPiqT9dGjhDir2sT9ZKmchdqRkcP4gl?=
 =?us-ascii?Q?ukgP5SbRLoIVZnsW72MohSRRp7vtgmWVQYhSHlasuYSZlNUj0aH19ofM1UcJ?=
 =?us-ascii?Q?Nmadwn7p/DmtwWN4PmyOD76wy1WV8Lv3boPIIQLqslq1bGAvXIzn5vEokQQ9?=
 =?us-ascii?Q?yr4XvD2r4v1MepVwPv3AwO2qfCtg6msr6SeK9+Yd4AeppNLBgu2EEzdzLs+m?=
 =?us-ascii?Q?TwEtOYC+71MkOKmNA0pD7njnKpClbnic8hYIHkUo+nERxbI3Oouc0+wtkoHB?=
 =?us-ascii?Q?fROLuZutW6bU86MP5NtOLU2ujQDSCau6XZmn0iCLEuvBHT4eQMvTfwwVYOmx?=
 =?us-ascii?Q?kYAfopn2H0s0kivuSvTjm1HoedUp2k32yUNp/w+c0t8gLHRituZRCLINI+j/?=
 =?us-ascii?Q?FRKoWOSr8IWZUuulj1+YcYg/ygBxHYi019+rAAOQtY+gw17SXyhL3uXa1lMc?=
 =?us-ascii?Q?xrYZ7VvDVIpKyDKw1coL5+ZS/FwYpRuyKl1+vwZwjmDKh/BIUvL0msjWAUf4?=
 =?us-ascii?Q?awGY17z/AyPP4xYTG8NZ/iNSKRLG+D3NmbT4lrdN6g9r1rDqtw+YkLQQeHaa?=
 =?us-ascii?Q?4mIVkpAN2dmidnj1afVtXHZwyVIXy3GBzxoMs8qVGNoBmcxhevWM8+mTK3NU?=
 =?us-ascii?Q?HFT6oA=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bdd83f7-db5f-4cab-b475-08d9e50f70b7
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2022 23:14:33.0649
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o6yMmmN9bNzgep0ft/8VAhYQyDQVpRqWklO5u6PcovwqA/qC5WzfbcumoyVeURjZkpqSf55qZuvkq9W0Ucj+ZsnL2O2M9WjjhlWyRANHGhM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4274
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 31, 2022 at 03:11:55PM -0800, Florian Fainelli wrote:
> 
> 
> On 1/29/2022 2:02 PM, Colin Foster wrote:
> > As the commit message suggests, this simply adds the ability to select
> > SGPIO pinctrl as a module. This becomes more practical when the SGPIO
> > hardware exists on an external chip, controlled indirectly by I2C or SPI.
> > This commit enables that level of control.
> > 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> 
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Thanks Florian

> -- 
> Florian

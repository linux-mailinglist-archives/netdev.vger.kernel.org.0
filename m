Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3D46E0F37
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 15:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbjDMNvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 09:51:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbjDMNvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 09:51:40 -0400
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2048.outbound.protection.outlook.com [40.107.241.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA42133
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 06:51:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SDZjqY1UEwHw2062odnrI1477L0lH762M7k03KxhReH5RH0kQUIQ42oEnaplBcfzEy7xFTmjPzKesKx2sVTtt/xg7Qn5bgc5KYvEss1g+sHKtOd8JgssESxoHLgVtwYVh05ilgvh3yXXgfrF9IYmp6/dKwwNz99VXwyZ5GcTsLH+8ygHZlIRdgNI5OQPYNXy8fjYfY64ssbUNsvGWob+JR8Sc+RdwOVjj+Gg+rGoqfKdjXEb3Cf3V1CK4Ko/Ki48MA4wZrpbshwP7DBLQOwUqFfoEIk8mKNfEOUVfHhOSSxGN/QEfsi1Oa1NWUtSgXrxPhVHYi2syUTQkmpvEpsxRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HbDaA9T1OQtUsyAqmqXbEMqRTiwQBTJb+SxWrL0uBvI=;
 b=DSP+qkPnvG6JEPYUEzzpybOk0T1QdwSWm0sAkZD/6wP2xgqq9lGUuhiQtgVWIT3X3/56CdAcWXV0hXLxDxJQ3qtGwOAz8bV4kFvwcCCzkl6hNtbp32+gveOLzRKn5mw904XQKI2JOjw/o1EI2axKw6lB3mwGJrodIKn+nMP+sripVlvgVsYYKLA97lU1eHxvRJW9ZABWKSMNRoCLVEyRjBJ/geYSTsoNeCxiO2GC7ucqNbicYPIJmd7HN0e3EBJq7zQAbm1ePEWyzzJE7ZAgaOxeum4HDsqv1V53hAfnoksk/VvfGlrDoQTOfuik99uLAQvSAT/ju4wCm5dC+6klIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HbDaA9T1OQtUsyAqmqXbEMqRTiwQBTJb+SxWrL0uBvI=;
 b=G+Zoy5nKqlpCCg0hiCc+ReTiFXGm2WB+6OzJO+yYYACHyQo5ZbbJPxphvN0wGukSB835NaSnHybUdY9oqC0QEARfj7s+M1z4Gat5Xk7c89oT7YoL5w4+kk+lg2Ny8rz5l14gm+rHKMltuI7uQ16w8B+n+3xngg/eY3ZcTF+on/M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PAXPR04MB8765.eurprd04.prod.outlook.com (2603:10a6:102:20c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Thu, 13 Apr
 2023 13:51:36 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Thu, 13 Apr 2023
 13:51:36 +0000
Date:   Thu, 13 Apr 2023 16:51:32 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next] net: phy: add basic driver for NXP CBTX PHY
Message-ID: <20230413135132.ybakyayxflai7tzy@skbuf>
References: <20230411155706.1713311-1-vladimir.oltean@nxp.com>
 <e2ea17e9-2c6a-9a89-bb09-29eca8dbf6bc@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2ea17e9-2c6a-9a89-bb09-29eca8dbf6bc@gmail.com>
X-ClientProxiedBy: FR0P281CA0079.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::19) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PAXPR04MB8765:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a6fb89e-9b51-4374-28cb-08db3c2632d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q8FYVd5p4Pr9k7+Wp71WJiJ2eHHVi5OX70nOSuJPsTpJeYSLSKUCJ6cFlmRJu4wOi2vEs07Qo1p5JUhZ9fWP7tmYaf5zjg0TbpshV7UUsLcKW/jszwtCrfuMc5q5EJTJZtkoe1x5TSNmwQxQYiM7zeRuIozVK+jqJb5sgr1YKyppjWrXBFiFZjIHYW8jh7ja/kgRROHqTt54YrjQhXO4W++c0lHrj8Zqr+IEVd+c9UpmJ4FBoDOTRj5TMDEq4yZdEOPxz2d736JV+54RledzqIKnsIdXdYx/FYBWqolVnOkbBlUbHupMhpGn6+LtuuQsUxUDa+DzrfYmi2dYpH2bG0Wz8O3811LLWdXyGRyhN19iiMVtxza1fZjEcXiQLxnORwKh5okUraUV5TihMJc4nerYtA9umB8l9Q2qP87XfNQ9wl3qHvUbjvGDIu5kHVXgOx93TbF/AlaDFKnCuGT6GykWa8AbMT1+2zbXTSOYjloHhYn1VENFUZDkSs/T8Rjzcl5Oeu3qbauqZ+iQiQ0erUXb/ivvg96ZfmQpkN+1cLMUXuQ38agGEsbesEWLJLRY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(366004)(376002)(136003)(39860400002)(346002)(396003)(451199021)(86362001)(54906003)(44832011)(33716001)(478600001)(316002)(41300700001)(38100700002)(8676002)(8936002)(5660300002)(6916009)(66476007)(66556008)(9686003)(6512007)(6506007)(1076003)(26005)(186003)(4326008)(66946007)(6666004)(83380400001)(2906002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?up40WsB+FTjWK2X5c3Ygahro7qbC6CQjPL9dd4L6iFFO79f+C3nRQGpUCzm2?=
 =?us-ascii?Q?MtpjwurhsBXZCbjCW3S68fSphN/geyeX0KCGe/UuzuzBURV+4hQM+Bttvnd5?=
 =?us-ascii?Q?uYGSRuO9Pqt2+VHVWE5d/OfXJCGfqPG0uh/zMxhAsc1GQaxzujGck8cS8ANh?=
 =?us-ascii?Q?APe6Vs/Uxr76g6mFSmpFpqgaRRkKvSd/j9bJfqpBGCM7Gp9Mrgs8QsqSj7f/?=
 =?us-ascii?Q?xzjO6q7inhGbXrovkrW3j/ILi17CFTMyy2wSsZujINErsWPDb2Hr/B1t7w7B?=
 =?us-ascii?Q?MtyVs+tF1l2Uyi1MLEQ2Cktn+SLQ8y1uQdpm8EJwfLW3ehJudh/5CkwgY4TC?=
 =?us-ascii?Q?vWHIG/eIcdrlV0jE7Iad554XutWeN2r+YbyExC6Hq0cySo2lJRkl/AFypxQr?=
 =?us-ascii?Q?9Pm8xuTGAkCAk1U20vZc08H531kgDckrSj6lSS72pGcObKjGd0rVXN6DiIvG?=
 =?us-ascii?Q?0p9wJXhTW78AXCuL/Lov6viuzzCdmoH26bPX5WBPRRg69essK42KsNzrAfww?=
 =?us-ascii?Q?DqLsw4Mh4eIp9DXCe2Y/HgZkLViG328ABgfg+6KRKcF1lRhZeaQAZLF1jBTu?=
 =?us-ascii?Q?OE7RdN6qZUdEIdvg89tFcl+iJsBG8sRdEQClI2+uxpxLQ4c5NWpj0bVY+xkV?=
 =?us-ascii?Q?WdKbIjZrNYgHCTTF7Rz9AxgCbNjFpGRG30NI41c4c4+wXKirobzPCA471OvN?=
 =?us-ascii?Q?CkV/vAyPzEHva7on1o4tM5TZPNsEE0R8i9XJU5toV/MPF9l12QU/Pi6v3HSe?=
 =?us-ascii?Q?ZAWUSUGBNDBHGjJzkL4ZDWBLxgu4RhMIt1+92euR4W4/DSsW5jhpFygiSpKp?=
 =?us-ascii?Q?DkJ209Y56YTjQoMfn3cm/n+kIr7p0Gcq02uN7EfQud/sh9EUd4iCDv2mZm2W?=
 =?us-ascii?Q?jjS4O63vb1SkOIAHlFoO1Sl50TBzxoAaEs90cYpsS+0uWbzO8tAZ+kh92/Fo?=
 =?us-ascii?Q?u/xRW87dU6T+i/9mZoTFnePK6FGhCNBsWyXEDRrceQo8JrSgdmyX+ZYEJ81+?=
 =?us-ascii?Q?GkrHj+THCVSKbO4j/Ef+r4B7B5hQ4Ae28B8ZrY8rQPPykxZ2GdyRljrURIyX?=
 =?us-ascii?Q?/E/aYqAf+LCNxOYmGUqi5ItyJmFFEDYnyvECGi/IdxeFPSm8S5QHvxS+kbWQ?=
 =?us-ascii?Q?UbxfQM9hYBRLkbwP+y30SQr0UiVP6bHQtgAF/4Iiry0zoLby9Ip3YZMjAXD5?=
 =?us-ascii?Q?QTnTx4fgbWIzGxPrf6e56ga55fbkcwYg6YxNJz8CH5FxTvZgpDVgcI3ph80p?=
 =?us-ascii?Q?eucPtcuE+nH8MOi1gd8ntV4vNEDwfvonKasjmy6M5tE6BO1Vhk3+Ppz971WA?=
 =?us-ascii?Q?nPX9Q7GssZWEaYY9T0t5OZY0KifxBZaaAupj5UdxkPNiImESEOfFvCMAGBZR?=
 =?us-ascii?Q?LzBCeTxpGk4GkkCG6x6sYxff/QeKVdUnXFmuUO3YQbpDyEnzepX9ONQt/47Y?=
 =?us-ascii?Q?9yMJg0+hOJ9i2X5eZhIqMbcQ+r+aWx6KsOphyS201ubfPRk+vCtkhTikxO7f?=
 =?us-ascii?Q?+7aSdy8gyQuHmRHOyQiOHELVyhEfjkxHOtZYw9i25hB2WjYCxx86OZOH8s09?=
 =?us-ascii?Q?hpvFvguTU21UI+azFk3uAGrjULJk2ocPhVCP0/HpSmEjy0xmqpGUgLo33bjH?=
 =?us-ascii?Q?9A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a6fb89e-9b51-4374-28cb-08db3c2632d5
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 13:51:36.3709
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ns05naEPUyDyKr2wieSc4sLq5pdOERiDLRIa0IK6iVgvQhtvMjJ2fyhxQD91uQtX/QGmUVVzEqWZS8ZsNEJRPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8765
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Heiner,

On Tue, Apr 11, 2023 at 06:49:42PM +0200, Heiner Kallweit wrote:
> > +	return phy_set_bits(phydev, CBTX_PDOWN_CTRL,
> > +			    CBTX_PDOWN_CTL_TRUE_PDOWN);
> 
> A comment may be helpful explaining how true_pdown mode
> is different from power-down mode set by C22 standard
> bit in BMCR as part of genphy_suspend().

The NXP documentation for True Power Down vs General Power Down did not
convince me, and I don't want to speculate and give an answer that might
be incorrect.

There are not many people who can help me give an answer right now
during the holidays. The high level idea is that the PHY may enter a
mode of lower power consumption.

If it's acceptable to you, I can implement suspend and resume as direct
calls to genphy_suspend() and genphy_resume(), and make the change later,
if needed.

> > +static int cbtx_config_intr(struct phy_device *phydev)
> > +{
> > +	int ret;
> > +
> > +	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
> > +		ret = cbtx_ack_interrupts(phydev);
> > +		if (ret < 0)
> > +			return ret;
> > +
> > +		ret = phy_write(phydev, CBTX_IRQ_ENABLE,
> > +				CBTX_IRQ_AN_COMPLETE | CBTX_IRQ_LINK_DOWN);
> 
> I think you need also CBTX_IRQ_ENERGYON. Otherwise you won't get a
> link-up interrupt in forced mode.

I've tested just now with "ethtool -s p1 autoneg off speed 100 duplex full",
and you are exactly correct. I will add the media side energy detection logic
to the enabled IRQ sources in v2. Thanks.

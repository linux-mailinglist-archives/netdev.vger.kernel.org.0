Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 287656DC727
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 15:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbjDJNMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 09:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbjDJNMK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 09:12:10 -0400
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2075.outbound.protection.outlook.com [40.107.241.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09B8730D1
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 06:12:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A0u213CUJWbVCf76puCcSut+FZnwJfOqHVpQeBcHLYq8BpROgTRaCwaMe6eT7UdkYaKo0FjA1I8nnRnYdl0nu+1RhJSiJ8+uazmOBsHkZ8gVE/iMscA+owz+smW6EmgYAZUuKA6eNMejeztOQUpr70TCIB3Cui7V0grSOo8BhFQfMsKZn9mSa47Ab7spxUl3UQRwxv28Xq6WynCfG7DA3ErQ24EuY/sxz4U79BuQoR9nAP2hn03i+54FkpJ++bb68wvy5WDEg0/0yjAKJTEgywZoxtEBrDntc2uN+UWd71aB0oBF4u0plC+G1OtrwfNUVA8ueKFgdEjWruiR4P1QRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p+/v8ffR0leH2IHJY7vwoRpDpgtT3NsKiFVkFNWsLvY=;
 b=Rsdu1Jc8A3Ou/SjME5ynX0apxk6pP5Up4LcTfAVm47+bdJ+kXFS94xzFWYVr/1bFe9qBfNdBTI+t1dh9UGZrG7hK+tc7pA9TNUpv2MTFMxEBPIR0E5TQZJU2jE27hsl8n0sCwlgMtrlOdgOAtWwcQ3crQY11zf5dIkehRi0OFPBc4R1/2CugW21jdko8QiaRTSAIWblJo/4Ij4eWmoDtTK1Ng7U2jnpjMBToGb92SFIaRwWW09z04arw5XptNOfq9tOPrRMTQdAnlF24vt0PgHou69gndM6GXOmlXvTRyimI77ZFJd0ZHWudAeRYmAxoCw4YxGPaUJ+TuBEd+51Xpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p+/v8ffR0leH2IHJY7vwoRpDpgtT3NsKiFVkFNWsLvY=;
 b=O6/D9kFBGoGN9mcGpOuYUeXrh2Nr+Zj8xskvmPk4IkjcOSW2KNLq2hLRkZpQFGjWdIdfWoXmbveCeALCLoFjDsiv+vMG7SgQv1YUMHA9J/oQ9ncGnr8jW0kHr37daV47Kf3kY1k8BUecLhqYQSr6X9j/+pKMSAlf0UwyRQ9mdHc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM9PR04MB8212.eurprd04.prod.outlook.com (2603:10a6:20b:3b7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36; Mon, 10 Apr
 2023 13:12:00 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6277.033; Mon, 10 Apr 2023
 13:12:00 +0000
Date:   Mon, 10 Apr 2023 16:11:57 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>, shawnguo@kernel.org,
        s.hauer@pengutronix.de, arm-soc <arm@kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/3] ARM: dts: imx51: ZII: Add missing phy-mode
Message-ID: <20230410131157.ye3wuzs2tjsojcim@skbuf>
References: <20230407152503.2320741-1-andrew@lunn.ch>
 <20230407152503.2320741-2-andrew@lunn.ch>
 <20230407154159.upribliycphlol5u@skbuf>
 <b5e96d31-6290-44e5-b829-737e40f0ef35@lunn.ch>
 <20230410100012.esudvvyik3ck7urr@skbuf>
 <c4b386af-2a51-4690-b552-e1da074e06d2@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4b386af-2a51-4690-b552-e1da074e06d2@lunn.ch>
X-ClientProxiedBy: VI1PR02CA0077.eurprd02.prod.outlook.com
 (2603:10a6:802:14::48) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM9PR04MB8212:EE_
X-MS-Office365-Filtering-Correlation-Id: d69f08f3-c40e-4d6a-71f5-08db39c52b74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gX2fyJ5vhIVmn2ReWRnl4te0Hpjo6PBpUi9LQ4R+iTlOsfFCXBYrXgwd7y9QGDIe2VKs+TdPf5Td0UIwIuM2ik2B1KTJzQm0R2p9hVF0dQ0+QQPXcGiJQy3fwBi8+GnxyJu5176jZrvCoX88q+yH9QOV+bEjCdF+4Gbe5+/m49A1rFTeahooVgphCZhJTzWeSvg+9x3zriv+JKQiJoS5b5H7V3ZMZng7mEhXBSg+1hdxsbhlsqb/jjo4d17k4/rbjRjQ3Vr0aQYK8CjWTGVlu8lDtCVczDAknfvZj8CXdssZNJGEI3RbpP19jvN7Du1gLm4MYnZtFsUpx4ufvc1qyEKA7SSIhraLYcPNmWWZaNIKo2lvdtxQuS1ylADXfvEKcNQFVkvfqYzDzhGmK22OKKqrxoVDYDHw2/eBG2S9COW4A0/M7HTWVkJfhzyLf5thmdY/eqSUzo9pzrceu+IHFHEbQwovu8gclnr0eiUqeL7DO2gI56M70FyNgmuJ7UfGiuuI1I0P71QJ/ls6wLEaMChTShMgaeCl7o6EO4uHttpsQy+LkZx4RV15/dgr89/Y
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(136003)(376002)(396003)(346002)(366004)(39860400002)(451199021)(478600001)(316002)(54906003)(9686003)(6512007)(1076003)(6506007)(26005)(44832011)(186003)(6666004)(6486002)(2906002)(5660300002)(33716001)(4326008)(66946007)(41300700001)(8936002)(8676002)(6916009)(66476007)(66556008)(38100700002)(86362001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jr5nTfie1GEGqCc4BCrZ1hGZoNRqpJOvnwbONdtGDUB3V9PkIdS95tpUDeV6?=
 =?us-ascii?Q?pK7sO2ODW1MZozCwTJ5GuJxNYf08xofJTLKTMyeIUAdYx7naHaTXsOUh6xm/?=
 =?us-ascii?Q?nejGDK/cw7OjvnOAgVoMuVGPMqNtPWWz3ltpYOtXV12+Ywiy3JkA0iFr/uPO?=
 =?us-ascii?Q?mfJ+iy/YD9+jLk88oZVO1llPKpjNN+HgzsLZdnCYrHQs2t2FnRV/QWhCjYKy?=
 =?us-ascii?Q?kNNoDDFN+2URGlpoD6LJYnZQaglL6Xunl7rFbgIWxDyH+0gh8tmg0gEpEbNh?=
 =?us-ascii?Q?Mbv4vOtGx2bHMJTygzqS/RZBLcOhMu0n/yQ8hYHGeMRmEbziJsEU9iyR7vOn?=
 =?us-ascii?Q?1HkU+5KnWuKqR6S0xOa8+7an8BgJneiMyD/3ssY6aOi4I1/jru+9VMx6IO5W?=
 =?us-ascii?Q?JCltEhQBoWmFxN3UIVB+68X79NvMULVt0N/V9KEunU3SxYI6zFQXyHe+XGxZ?=
 =?us-ascii?Q?vMUWbXXEoKRZIVWpFB96ABtyEwk0DAZdCPOYPKY4SRdkrwsVrvIYUszORhNl?=
 =?us-ascii?Q?48QXPXXaV9S44B0AsF4QlvCY2XCy8WIDBifqG8YzxC1+PTr63gpoonF56A/R?=
 =?us-ascii?Q?//I6u4ngzLppsYmWuk0CGhg//nId27zSnN5NLdE9fHoIDnqLm8kswvUMoF2v?=
 =?us-ascii?Q?h/z7dU2gowgkNeJ84LOPkC8NhoWU0332zmG0fuMWA1wgJE3IqknDWkxp045p?=
 =?us-ascii?Q?unjdreay/NaXqObXNDL6fx+dpTY3UZPJQqV8G1AsLcqp+Hw69r5LE5x1E+dQ?=
 =?us-ascii?Q?yUESpIB6UaSGMfBTew5/cwapq1yUS8LLcL17w6fQINVqHOwRBhLsY3jRZJmT?=
 =?us-ascii?Q?OS2JhpYKqvHVHIJH1mjmD0VSrwYK8DO3QaRFJMVBGszj7Li6IG9dxYd6ULxp?=
 =?us-ascii?Q?Dd7mOnR0Yw7Svk5Y/KhW+ClTMYPaDTveK6c4R1sJ+tV8xzG7I88kDo5aXDJ1?=
 =?us-ascii?Q?92MN9WK0YnhHDRJuOcS0puutgQIuH69zTPcBuI31gsSpyK6+3wb7G48RNfa3?=
 =?us-ascii?Q?+VJB3/NEyrMAEWydpps7Ligu8Saz7LJBPE491wdVTNnPF3DTs7AhVIcpCtd5?=
 =?us-ascii?Q?xSEjfITypRvMfuLXMMhOP1/XQ4nzxhU8digl7i0qykJLZ0yyoyylgmFqupx8?=
 =?us-ascii?Q?pJbnuQNc7JIi6hRUBKN4WGVD3f83yH6GA1U9HFG64PSsk11F/gW/R+K3gfKL?=
 =?us-ascii?Q?QOJjxXBszhraSbIeZwJBW7xO4Q0n/4iSiDwBoqoNnG133NX4L8aQgN61AtrX?=
 =?us-ascii?Q?BLiOdczqXecLb0//tCVQmBMqFANj9FYlp17do6MV46/bDtFhhjXfqF/to7ci?=
 =?us-ascii?Q?0ufsv9jFz0TE6l+YjiJXbmh5Sow2Bb0Q0TcxTQPuZ0syjp2/zpuVCnr2Jvig?=
 =?us-ascii?Q?ZJdyJJI2coKtdgWxlH+5ftyiooLMYfFMBaSWtkLiS4n4YxzcJl2C4Nqy018v?=
 =?us-ascii?Q?cfWVi8XNcq686CmozbY4NZR/sL4MiE5pW9Ymyiwz2Yn/y8boQGhQHaiPerIi?=
 =?us-ascii?Q?u/Ab3oDRE0QUp0kQ3phvfxZ5JUz4O+q5jnHWmFqb8l7OaLYNN9vt0rpBVheo?=
 =?us-ascii?Q?Ic6yi1Sqy+9iWLrX8HrJETiJ7sbMinJqqKc0eLaUgUWPudMY30U4e5uwWgeq?=
 =?us-ascii?Q?pg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d69f08f3-c40e-4d6a-71f5-08db39c52b74
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 13:12:00.5677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ghJNpWs4AUlom4q3I/iEhdZZByO+kf+Al5KALW2hmHSW1U0nYNyh/ytEuXxjlOLrpR/o/phhB9H5CyEz5x5TbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8212
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 10, 2023 at 02:35:28PM +0200, Andrew Lunn wrote:
> I tested vf610-zii-devel-rev-c.dtb:
> 
> [    2.307416] mv88e6085 mdio_mux-0.1:00: configuring for fixed/rev-rmii link mode
> [    2.314459] mv88e6085 mdio_mux-0.1:00: configuring for fixed/xaui link mode
> [    2.320588] mv88e6085 mdio_mux-0.1:00: Link is Up - 100Mbps/Full - flow control off
> [    2.327722] mv88e6085 mdio_mux-0.2:00: configuring for fixed/xaui link mode
> [    2.334729] mv88e6085 mdio_mux-0.2:00: Link is Up - 10Gbps/Full - flow control off
> [    2.343263] mv88e6085 mdio_mux-0.1:00: Link is Up - 10Gbps/Full - flow control off
> [    2.396110] mv88e6085 mdio_mux-0.1:00 lan1 (uninitialized): PHY [!mdio-mux!mdio@1!switch@0!mdio:01] driver [Marvell 88E6390 Fa)
> [    2.498137] mv88e6085 mdio_mux-0.1:00 lan2 (uninitialized): PHY [!mdio-mux!mdio@1!switch@0!mdio:02] driver [Marvell 88E6390 Fa)
> [    2.566028] mv88e6085 mdio_mux-0.1:00 lan3 (uninitialized): PHY [!mdio-mux!mdio@1!switch@0!mdio:03] driver [Marvell 88E6390 Fa)
> [    2.663995] mv88e6085 mdio_mux-0.1:00 lan4 (uninitialized): PHY [!mdio-mux!mdio@1!switch@0!mdio:04] driver [Marvell 88E6390 Fa)
> [    2.746064] mv88e6085 mdio_mux-0.2:00 lan5 (uninitialized): PHY [!mdio-mux!mdio@2!switch@0!mdio:01] driver [Marvell 88E6390 Fa)
> [    2.834000] mv88e6085 mdio_mux-0.2:00 lan6 (uninitialized): PHY [!mdio-mux!mdio@2!switch@0!mdio:02] driver [Marvell 88E6390 Fa)
> [    2.933998] mv88e6085 mdio_mux-0.2:00 lan7 (uninitialized): PHY [!mdio-mux!mdio@2!switch@0!mdio:03] driver [Marvell 88E6390 Fa)
> [    3.016031] mv88e6085 mdio_mux-0.2:00 lan8 (uninitialized): PHY [!mdio-mux!mdio@2!switch@0!mdio:04] driver [Marvell 88E6390 Fa)
> [    3.033976] mv88e6085 mdio_mux-0.2:00 sff2 (uninitialized): switched to inband/2500base-x link mode
> 
> So we can see link mode rev-rmii and there are no errors.
> 
> Testing a board using mii, not rmii is going to be a bit harder. I
> don't have one set up right now.

hmmm... why does this work?

would you mind adding this small debug print and booting again?

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index a4111f1be375..0b9754d4db80 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -695,6 +695,10 @@ static int phylink_validate(struct phylink *pl, unsigned long *supported,
 {
 	const unsigned long *interfaces = pl->config->supported_interfaces;
 
+	phylink_err(pl, "%s: supported_interfaces=%*pbl, interface %s\n",
+		    __func__, (int)PHY_INTERFACE_MODE_MAX,
+		    interfaces, phy_modes(state->interface));
+
 	if (!phy_interface_empty(interfaces)) {
 		if (state->interface == PHY_INTERFACE_MODE_NA)
 			return phylink_validate_mask(pl, supported, state,

I would've thought this check below would fail:

		if (!test_bit(state->interface, interfaces))
			return -EINVAL;

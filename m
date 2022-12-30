Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 560D06598BA
	for <lists+netdev@lfdr.de>; Fri, 30 Dec 2022 14:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234793AbiL3Nce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Dec 2022 08:32:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiL3Ncd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Dec 2022 08:32:33 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2055.outbound.protection.outlook.com [40.107.6.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30471193E5;
        Fri, 30 Dec 2022 05:32:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MJjfTBZigwJQx1ZyCQFIDAoa8Rm3dHPLiqfEkxvhZZOK+1VODfjinXy4VMnP3XCEw+Vak/fLNUOcdQ5D758tDIa5hQBpSp7CmSYMKBhFFXMzxbS33alqZtHYh3RWWvLFOPcwP1Zg94pOKeAVTJ5LW4sPhl5AGYBhUETHaa4GT0jH3YVv+XTyyPf3Mx6DkI4x2uYFVDkRLFFjDgay8BmRTNwGcQu3lpNT+hpr73mTPQ6Yfm+OzX0lM1aBCegHc/2P8qq/fz/SIpqB70KHathYxeJcw0nGh3CLL8QH+mcPdM1K0sv5dLRNcyBA/Js/MwtenkwlSotrfxa7qGirpTsfQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mg1qbM58YgDsuDsdehYFajKEy2Unq6coY9Q3S5vctv0=;
 b=bZk5WZn2ApXi1Yan2OFo2JsLpZxWS3k9VOVohvjb0y/ldHzDedFXCVIdAyrntQz0QErc6kJoy6Tbwap/I2JMbHqVkVcgGTKklYqgkinUddGXYek5OgEAL+ODUn5c5q0cQH2vUOMp416E3bflO6KETXxNKEqiQ04DhnwcYQ6ZDnv5XPIPuoDFCwRpbuf5iw0XHm0zCZKEBTqGPrrsEXWp03W8aeW5NKSBp9z+rhSAQaRidCjP392kP6amr3wj/cLPng779LydZtZxJEf7mpntCwx3cCREBMQt9eIT7gPk2lWNWns7t6NGYfTfqiWVzu6Zy9JvJgaQUym/CIGUN5DTsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mg1qbM58YgDsuDsdehYFajKEy2Unq6coY9Q3S5vctv0=;
 b=XQ5xmb7mvU/5VPDbo3BFAe9JuzF1D3mi7V2CC95wziezKAns6KUiiY7mIQM2eFitMAU2KNvZb0OIOLhob8E0N3ZjI0Wf15gMl07P6hdgP8gR5mxcorCP1bbuL/ZrVSD4STb9hC3EzAmvdX7bEJEmULYmM6myAn8CxKAAg9OWgIQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by AM8PR04MB7473.eurprd04.prod.outlook.com (2603:10a6:20b:1d0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.16; Fri, 30 Dec
 2022 13:32:29 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::5863:1b8c:c11a:ad1b]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::5863:1b8c:c11a:ad1b%6]) with mapi id 15.20.5944.016; Fri, 30 Dec 2022
 13:32:29 +0000
Date:   Fri, 30 Dec 2022 15:32:24 +0200
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net] net: dpaa2-mac: Get serdes only for backplane links
Message-ID: <20221230101710.btdw227v62nnj3le@skbuf>
References: <20221227230918.2440351-1-sean.anderson@seco.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221227230918.2440351-1-sean.anderson@seco.com>
X-ClientProxiedBy: VI1PR09CA0083.eurprd09.prod.outlook.com
 (2603:10a6:802:29::27) To GV1PR04MB9055.eurprd04.prod.outlook.com
 (2603:10a6:150:1e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1PR04MB9055:EE_|AM8PR04MB7473:EE_
X-MS-Office365-Filtering-Correlation-Id: 655fd58e-c278-4454-1874-08daea6a4c0c
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T2PcaSk7mqcUBAT4pFesY8nNt/dnEmkI/fLaj0wusamk0Ee1EbJILlY6xw30D7AC9rkf/70QWs/rvQ++b3iJP9rpn2l2i4I22Ebe++RMu4o8kmP2k7Yu5vSwbGVyEKUUcfdno1wtWoX793uHoY6S26bvtq+BFPTYMpxrvZyTRjfUdTUS87ySfMZ0x6qb1RmrEvLqzbMGOkFdovc4vWz/NX6PeIKDDfel9Cu7CoaO3AwQju6DGx6nlPcdu/Q/eyb6rvS6+Bs6gdp3G2NxbztjN1O11Y9iHdLK/59J1woC2Jqb9JPE1WucJRMdb9QyD1lgej4bVMBTDDvJBWVU1MmGu6CGSe3+rzxFzJclCkxJDOO/JbOa4WqgZ0nw7ot4wPtranx2gU9m/i0QR+S2D0sHJqafCDNnagJevZ0FxfIIckjggBSj//g0KP6wtxHDw7W1BhdXU5H+TSEZtfGPD9lKCmQrsurDCvWtK72yvt1ACK+pUNvbfeKrcD5X/SOAhV3TcMkhxJKdUhGZMhtx4qCOuW18kuZzGwX3lqcSYPhwbmEXIVF8F0pV9d/Y4EaPSTDM6L2COo6/7AonywFNs3SJa2DTbpJCUFQoHuArcr8Fhta48vGLVs84d0o0613QEXY+cIvcumOoBHwuUq6HCiQ2UKQE72PdLdA/6gcOgqAHfS0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(136003)(346002)(376002)(39860400002)(366004)(396003)(451199015)(6486002)(966005)(478600001)(316002)(186003)(2906002)(54906003)(6916009)(33716001)(6506007)(83380400001)(38100700002)(6666004)(86362001)(1076003)(6512007)(66946007)(9686003)(4326008)(26005)(8936002)(66556008)(66476007)(5660300002)(8676002)(44832011)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2jz7N+b++05iA1PFVhjHb/c4O+vaKTiR/xLNizG4bMiXy9DrXUK6BktCb2Pa?=
 =?us-ascii?Q?v7YIuer0db1z9z2IAbVc0P/TXjGQnScDHDL3BRYhPBoYpgi8r4xI7zCW4c+a?=
 =?us-ascii?Q?qCizALHVBeSvnmSSsvcs6Yik5H5Vd97JWUXHI8qsK+rDv/Ewb0ERDRdmU4+v?=
 =?us-ascii?Q?iAeALLE0IwbrTbmNAsjvzBzIvrk/lXNd8BgcgroY3Oq6eP9/JF2of01TnNCy?=
 =?us-ascii?Q?U1uMAgA8G3fkyUDI3J5W79/KrOhmxdF+aB56IxquJssJVBCRm66UCQLkH6Z8?=
 =?us-ascii?Q?pfhAaKS0VyflGeD7PfNdU2vTmHuZztTcXqSPMfeZLn+JaFS6ZzM0SCUlTK0M?=
 =?us-ascii?Q?b17q8lEyHvA6MI1zY7W8C2XbaeiOaIBcy/gVhVURC80WiA7TU/2lqodCMopH?=
 =?us-ascii?Q?uYUcywAYU0EaO6nvWlOH6AAIbFDbRgAxXpy4zXfNuF6zKbnR0T9siHrHhxEG?=
 =?us-ascii?Q?VBBTDCHb+eQowSv26VWzGYjuuJSH0tK8oFKXgc36X5awjsUlZp82oQlFp/ZW?=
 =?us-ascii?Q?IF4dMNstYrSk2Yllda+5gOiIXz5dY5nqR2NCpGMOXZwiSp/t/TQWhuFvWt5T?=
 =?us-ascii?Q?6TgOLiZlfAtR5l4Z/8Ecc6OJo9EQrbjd86uirUiyGZSN/iCmGkhCaNNIyNgr?=
 =?us-ascii?Q?l8HmUvAm5tVjYA/v/BKDn5USz0ymYI7YaLqfH4Z1B6uJVyvkOouf+2ydAlzR?=
 =?us-ascii?Q?7yjtsz2W8VppU1HNUBMy+fzLiapE9e/7C0Di3r5UsxKwNk1eH5LB6cooIddD?=
 =?us-ascii?Q?ICoYZ9sBP+XnD6caRzCCIQj+/kZVUWmEvVIIJpMaqp4Cr8gbssElHAiq7Je3?=
 =?us-ascii?Q?1y470Yyhmm8nrM4BE2chfGZGwPPXGRj4mYtxOVKBCMqVv3B221UNFEW4MhxP?=
 =?us-ascii?Q?b1awII081HgkLDrqfdeR7v8LPHd1Mu3fSxpxSdDM/NkCz0MAzwSA0VJpfVn7?=
 =?us-ascii?Q?r4Zhn/pZe8mPW9Yc8GN7kDyksPBZA18F92tBBswWiNry810MbvaByxLpxk39?=
 =?us-ascii?Q?Qb+vx5oezxSWH4FXDdYZa4W0QPZCf67yEJ4BlJSDyV+8Rs1CrngeDuXTMwQa?=
 =?us-ascii?Q?F1EdrkpgIVJX1aZUiBWV53SRDBWIO/aalARf55yNfOZ+NfA2Yzu1O7Soxjew?=
 =?us-ascii?Q?MckX3ewfw2vNaI0rJfntUxnIrVkjc/5njZsGLN+mLwFRl4fz1J6JzY1esGL4?=
 =?us-ascii?Q?U3Rdwp4KNsXjEuvmvpAPfjSNqlHcniC2MgohHsFlnFRuu86nYIbIn0sH7ygQ?=
 =?us-ascii?Q?tAyi2WYClvnEnLETHSjiUdLVBzZLdXHi3zbIJRSpy9nZT+7PwmyWuToFJDax?=
 =?us-ascii?Q?dG87/uiusv22J1AWGMMqgHsIAmCf+gu2ds0cZzImz7mhoqAyeNMQ5YNi+2SQ?=
 =?us-ascii?Q?lEiygCcTzVxOl3UpxeQbRLqy7+Wpze3DaY7gNyLiSa4i23TtcC5P6mGPb8Ol?=
 =?us-ascii?Q?3qTJEOwN0D8xQplVMZB0PN1EGGlIygLYC9nVryf3hVB3jv6RM1/HtcbUmu5b?=
 =?us-ascii?Q?SD5KjXKzmmnzZUuubcYvvKymyT2jU77/oK4InRgV8xm90YZirr6MIMba6lD2?=
 =?us-ascii?Q?qf5FjIKR6ZjUllgPChz+eVhHnd6u/bHNC2L4R9gs?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 655fd58e-c278-4454-1874-08daea6a4c0c
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2022 13:32:29.7313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MchzOg+cJH1fPxcKyHhOPJkeOv5w6kHbgrt1+yADyONVWXrnCDPVRdM23OuT4L93MnHLOVaqFePSsxlbmAH6mA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7473
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sean,

On Tue, Dec 27, 2022 at 06:09:18PM -0500, Sean Anderson wrote:
> When commenting on what would become commit 085f1776fa03 ("net: dpaa2-mac:
> add backplane link mode support"), Ioana Ciornei said [1]:
> 
> > ...DPMACs in TYPE_BACKPLANE can have both their PCS and SerDes managed
> > by Linux (since the firmware is not touching these). That being said,
> > DPMACs in TYPE_PHY (the type that is already supported in dpaa2-mac) can
> > also have their PCS managed by Linux (no interraction from the
> > firmware's part with the PCS, just the SerDes).
> 
> This implies that Linux only manages the SerDes when the link type is
> backplane. From my testing, the link fails to come up when the link type is
> phy, but does come up when it is backplane. Modify the condition in
> dpaa2_mac_connect to reflect this, moving the existing conditions to more
> appropriate places.
> 

What interface mode, firmware version etc are you testing on LS1088A?
Are you using the SerDes phy driver?

> [1] https://lore.kernel.org/netdev/20210120221900.i6esmk6uadgqpdtu@skbuf/
> 
> Fixes: f978fe85b8d1 ("dpaa2-mac: configure the SerDes phy on a protocol change")
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---
> I tested this on an LS1088ARDB. I would appreciate if someone could
> verify that this doesn't break anything for the LX2160A.

I will test on a LX2160A but no sooner than next Tuesday. Sorry.

> 
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> index c886f33f8c6f..0693d3623a76 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> @@ -179,9 +179,13 @@ static void dpaa2_mac_config(struct phylink_config *config, unsigned int mode,
>  	if (err)
>  		netdev_err(mac->net_dev,  "dpmac_set_protocol() = %d\n", err);
>  
> -	err = phy_set_mode_ext(mac->serdes_phy, PHY_MODE_ETHERNET, state->interface);
> -	if (err)
> -		netdev_err(mac->net_dev, "phy_set_mode_ext() = %d\n", err);
> +	if (!phy_interface_mode_is_rgmii(mode)) {
> +		err = phy_set_mode_ext(mac->serdes_phy, PHY_MODE_ETHERNET,
> +				       state->interface);
> +		if (err)
> +			netdev_err(mac->net_dev, "phy_set_mode_ext() = %d\n",
> +				   err);
> +	}
>  }

This check is not necessary. Just above the snippet shown here is:

	if (!mac->serdes_phy)
		return;

And the 'serdes_phy' is only setup if the interface mode is not a rgmii.
	if (mac->features & DPAA2_MAC_FEATURE_PROTOCOL_CHANGE &&
	    !phy_interface_mode_is_rgmii(mac->if_mode) &&
	    is_of_node(dpmac_node)) {
		serdes_phy = of_phy_get(to_of_node(dpmac_node), NULL);
		
		if (serdes_phy == ERR_PTR(-ENODEV))
			serdes_phy = NULL;
		else if (IS_ERR(serdes_phy))
			return PTR_ERR(serdes_phy);
		else
			phy_init(serdes_phy);
	}
	mac->serdes_phy = serdes_phy;



>  
>  static void dpaa2_mac_link_up(struct phylink_config *config,
> @@ -317,7 +321,8 @@ static void dpaa2_mac_set_supported_interfaces(struct dpaa2_mac *mac)
>  		}
>  	}
>  
> -	if (!mac->serdes_phy)
> +	if (!(mac->features & !DPAA2_MAC_FEATURE_PROTOCOL_CHANGE) ||
> +	    !mac->serdes_phy)
>  		return;
>  
>  	/* In case we have access to the SerDes phy/lane, then ask the SerDes
> @@ -377,8 +382,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
>  		return -EINVAL;
>  	mac->if_mode = err;
>  
> -	if (mac->features & DPAA2_MAC_FEATURE_PROTOCOL_CHANGE &&
> -	    !phy_interface_mode_is_rgmii(mac->if_mode) &&
> +	if (mac->attr.link_type == DPMAC_LINK_TYPE_BACKPLANE &&
>  	    is_of_node(dpmac_node)) {
>  		serdes_phy = of_phy_get(to_of_node(dpmac_node), NULL);
>  

If the goal is to restrict the serdes_phy setup only if in _BACKPLANE
mode, then why not just add another restriction here directly?

What I mean is not to remove any checks from this if statement but
rather add another one. And this would be the only change needed.


Ioana


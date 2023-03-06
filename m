Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B85E86AB7F9
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 09:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjCFIKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 03:10:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjCFIKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 03:10:01 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2042.outbound.protection.outlook.com [40.107.15.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7582A25F;
        Mon,  6 Mar 2023 00:09:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TkIA53hzJ7eHVrGEQRStZFPc8i2CZn2pYMeqsHMOYDEY2hMMUawVO0z905gMv8cx0223BJhFQ1BcBR1Xs8AoQ/11+m77KfeqymXgFxTKOmt1X/Z7Doza6ZtxtL/MP8q9D7MLcOrGXN+LKrbhP2ReLz2DaOPr7rl5tuoiLEEEa3nuryaXt9FCq2umDO1SvPCgFrR1uKDAw4W/px+KDHr0nIwfc/7yXqx+9ADAZVivT0x51wCOmn08YxHAw+IKGgn9IXAUJIH0kQvocNwIWQDb38rvwACG3vuO1wCP18VglhwsfMFLlEfrOe8vbg0UX9G8znqzQIhPcLY+7Y7hkJA3xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LpvY5CPAJ9QNxlCuuuNJSNU+SRRxeNu/Vr3bmE46oUA=;
 b=CB6soEVLuy2IwqroaqgDyyV8dXUqXIttwbXgc6JPlNyWHwpw5FWsS2fkClEHURfPGCqvTzNgf9mFWZigE0sBPkEN/3EJzuqaeRBIlQ5gHc17KWDZRUgQsz52ZX2V+ixmFze1SbqGz+6C5GCkPCrzvl6W6KwngAxhrGsbLJJBxxlt9Ux4KlL0L0CbMvEzVjGMglkONVm/WQRVkYXWckTHW8iw1LsdgRNwDwvLPFg735Pw5gKshoGW8WgCle2Yana0ZIM3ttkU8y3BcO507Yk06nSj46Xy4XCBLKh/yFKxbN+WcA02mGgGnCqS5gvh9P0WaSZ1QzFdvRoRBcnKbGQoqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LpvY5CPAJ9QNxlCuuuNJSNU+SRRxeNu/Vr3bmE46oUA=;
 b=JIdrGUL0a9QzswoXsvTm87eKphG/KvqiMrVxpbwY/ILA6enwQkk1EGnXCxFRcdwJjvmOKlOhXcsa77iM0rLuH6tCZDUJuxi04oX11qyPFgFDABt/P4boIey+rFArpSd23XQ6LGSWYk4y8bUeCSCEBVXCzBV7CeCzxUthChESdQ8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by VI1PR04MB7120.eurprd04.prod.outlook.com (2603:10a6:800:124::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Mon, 6 Mar
 2023 08:09:56 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::9c6d:d40c:fbe5:58bd]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::9c6d:d40c:fbe5:58bd%9]) with mapi id 15.20.6156.028; Mon, 6 Mar 2023
 08:09:56 +0000
Date:   Mon, 6 Mar 2023 10:09:53 +0200
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net v2] net: dpaa2-mac: Get serdes only for backplane
 links
Message-ID: <20230306080953.3wbprojol4gs5bel@LXL00007.wbi.nxp.com>
References: <20230304003159.1389573-1-sean.anderson@seco.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230304003159.1389573-1-sean.anderson@seco.com>
X-ClientProxiedBy: VI1PR08CA0165.eurprd08.prod.outlook.com
 (2603:10a6:800:d1::19) To GV1PR04MB9055.eurprd04.prod.outlook.com
 (2603:10a6:150:1e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1PR04MB9055:EE_|VI1PR04MB7120:EE_
X-MS-Office365-Filtering-Correlation-Id: bcafd2e2-42dc-490d-6b7e-08db1e1a2c53
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wWUcI2VD6wLyfkeqR8g16GT6MJOjv3AvNmQVCBUBg1AFi5G6A1joT4Em611dhGVwy3ihg4k1e53aSFs2OU1Cr3u9DK/dySsCVS0y++IWe0G7RgY7m8/fdp/0hOCeXefReIstB3aKGji1zZAcDWbRNIf8LKOLVhtmbY4mdkeOAj7zujp1QdLqcVwMeOLq0SXZO7mXs5sKIbeRZ9ybXUCZqLLEGDCPOQ0+MOEOJKNyPG+/rxaI0L9eSJ2FrSMqmVt7jchozplhPPGVhVobfW7TpgKlxJrQy5wg/Q+lROaTOdG8pjkTmd1LEgqAeIt7H01OHZ3hTDuF8ZIyilQwPM2RYW7HtC8JVQwMS6GO4iHxRUCq8TMEICiSL4MWbwozIFBGiYV+h/uxf8Sktwfm9SJNhSMoxMtvHF3IA0NzlqpAnEZEfRsyQD+Sfnq4ZQUB05jwKOluG3iIbMZWf1nXSsi0sYzcHydVGLZ9uDpgp2Qjh5y7vII+EO8HWiaB7GtBoW+mAnRDDIZnfzftwwJRU+JcSfjExlDUKj8TJY+JQsywBPswVZRIxvK7xV7izfdCLlJudlNhujd7bqudAlSFnuDTG5jd4365nLGz2GKtdLvpdjssSbZa5lnj6KWBXmX0tr6Zj7qnt4jTwk4oFmqX+65uRRauq3HClTAHRhU/b4St/n4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(376002)(396003)(136003)(366004)(451199018)(54906003)(6486002)(966005)(316002)(83380400001)(86362001)(186003)(2906002)(44832011)(5660300002)(66556008)(8936002)(6916009)(8676002)(66946007)(41300700001)(66476007)(4326008)(478600001)(6512007)(1076003)(26005)(6506007)(6666004)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mvSB1kRqfTFhXpEKBrSrQIM0WlZi91mZtJNKfhiQKAvBCeXSL2bikF9L5dU2?=
 =?us-ascii?Q?5YDKzczdr9a8HHlOoLicXsmsOhYlZMLF0+omqrUIFmzdlUvVcnNQguKgPcJn?=
 =?us-ascii?Q?k0vRK2A1JPiR1cXaULtHOfpyzx3YFULzUbIH6vEbRF/MywJMDOSB7cFTo59d?=
 =?us-ascii?Q?5GGfY5Zs8FbJtuEkhvh1/ZoZoWD8DcnF59YGmdqyq0gKFGiIE/UgV35pl/PG?=
 =?us-ascii?Q?ciyB7aQ0vXgkgjU3eYzQcH1myp4Hqa8LpqOHz/TiuiQig++Ra61arhMO4sc7?=
 =?us-ascii?Q?+Tp+wFmFMZ21qpSVDQ/juFRyghpuMofxKfaOt4wZb98tNmPk7jSVCmAyIH0J?=
 =?us-ascii?Q?KYvsndo9CQnoBYF5noOLbNA66oMmX6p72bFBq8j3F2XEK0HjIWbqStGaXmzT?=
 =?us-ascii?Q?slGFOY8IJn4yVj8xrmLom8g0Q1V3fdJ9V61K/+MdmzK6U52upA0zYB923tdb?=
 =?us-ascii?Q?U+J5Z04u/EXkrIsOWNr8MrNxlPL74kD7MRCuw1O8kXglDroqRT1h1OFAPe9v?=
 =?us-ascii?Q?GrWfBJBpIZ91JoW6odtrU/TvR8sPTDD52ra9gynT82l1cQD8OfRj0CiSi7oT?=
 =?us-ascii?Q?3RO5V6IK/tQWIeef3og4B9gya/VpV13Cn8Kkrm74LorX4y9ErrKz5O5l3LkI?=
 =?us-ascii?Q?67vaW9cVUJTuUBl2dVqTaKLfVuhunVaEu4whUAFahgwc6P9NRFN7WzFMoAXd?=
 =?us-ascii?Q?j7CVmdgWRxUclOR0OrK4AIHOsKTxt9nWkP+ed7u9JYa0y4OaTSZOfDcOx0ID?=
 =?us-ascii?Q?Al2E6OpoHXtAl9sit+45Gvqtl+ROOoyM1TSKPlzn+CgHh0V3oQe9De28BHVI?=
 =?us-ascii?Q?0lcI0iZMy1/j5eFXqKO97yD9cW/XPMphTynudPONJgYm+wDPRWm13/LD2qcv?=
 =?us-ascii?Q?UKK3/2MdYUiPksDl4zFwPTualvJjaaW8ETVWUBeLCzPfrPnfgOjQa1ExsGbV?=
 =?us-ascii?Q?7hr6bWc2WetM8KuWGLNK9+nOrIj+B2TkYq8pO75EW6DnH3wH44qVp1IKa0ns?=
 =?us-ascii?Q?hES/9J712BD+ZYOIiaeEzcOeslblxjAv2t7Qs7DSHC7laySzMGlTV/VHQHzK?=
 =?us-ascii?Q?6Q8pzCEmHkdPuLmqGmEc+7EKToLOtWmnWjFqqipLoKhbljY16ergeM3N5eWH?=
 =?us-ascii?Q?PKK3GVI1+XfeT3MaGCeiO2svrN2sCIfMEbnW5xUKZNkZYWVOj8IIr941I3ep?=
 =?us-ascii?Q?raoIJ/ApCUrQwW7XbRF0K/TEKChxUcNEO1QUaXe5T8Bek1eyROBiRYwJRi4Y?=
 =?us-ascii?Q?3bGWw0qKLII4XT1EcHpPU34XsPKdhfccmCNvM7iJC2CuA0pzHpMVThQ9y0mI?=
 =?us-ascii?Q?5OABlyCavizCFtYebDMQrIWDJFHnpwAqvm9hhhRTS3UC61ZvJJ+C1gYBucic?=
 =?us-ascii?Q?KcWs87I6jmfw9cKYw3c+Atwiu+1GMvdKzkjpb7zP6TWng9+fWeeuXw17UH97?=
 =?us-ascii?Q?M+beMCbJSt+i35ikYm7GOwIx21kWAQUXfyS2okyESABoivlPcbg43e50DLvC?=
 =?us-ascii?Q?gfONknhjklFmj8QFvM5jKkvAsSmp68dPQCJB1zDBw6oIxi3xURd23yEKZ8vL?=
 =?us-ascii?Q?EFx0bAV/6NR+++jNqEfRnLL+KtPHSKgIRG1ERzdOonSb6fAWnnQ9C8uRZL+I?=
 =?us-ascii?Q?SA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcafd2e2-42dc-490d-6b7e-08db1e1a2c53
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 08:09:56.7047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0MWP+mganp6BQwT9xu+/xn8CA/71VCfQ+bZ/kMHJibN5RcreFVzknsI9tM54CfHB3UrAtGsi/G9T7LxpAsFE9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7120
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 03, 2023 at 07:31:59PM -0500, Sean Anderson wrote:
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
> backplane. Modify the condition in dpaa2_mac_connect to reflect this,
> moving the existing conditions to more appropriate places.

I am not sure I understand why are you moving the conditions to
different places. Could you please explain?

Why not just append the existing condition from dpaa2_mac_connect() with
"mac->attr.link_type == DPMAC_LINK_TYPE_BACKPLANE"?

This way, the serdes_phy is populated only if all the conditions pass
and you don't have to scatter them all around the driver.

> 
> [1] https://lore.kernel.org/netdev/20210120221900.i6esmk6uadgqpdtu@skbuf/
> 
> Fixes: f978fe85b8d1 ("dpaa2-mac: configure the SerDes phy on a protocol change")
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---
> For v2 I tested a variety of setups to try and determine what the
> behavior is. I evaluated the following branches on a variety of commits
> on an LS1088ARDB:
> 
> - net/master
> - this commit alone
> - my lynx10g series [1] alone
> - both of the above together
> 
> I also switched between MC firmware 10.30 (no protocol change support)
> and 10.34 (with protocol change support), and I tried MAC link types of
> of FIXED, PHY, and BACKPLANE. After loading the MC firmware, DPC,
> kernel, and dtb, I booted up and ran
> 
> $ ls-addni dpmac.1
> 
> I had a 10G fiber SFP module plugged in and connected on the other end
> to my computer.
> 
> My results are as follows:
> 
> - When the link type is FIXED, all configurations work.
> - PHY and BACKPLANE do not work on net/master.
> - I occasionally saw an ENOTSUPP error from dpmac_set_protocol with MC
>   version 10.30. I am not sure what the cause of this is, as I was
>   unable to reproduce it reliably.
> - Occasionally, the link did not come up with my lynx10g series without
>   this commit. Like the above issue, this would persist across reboots,
>   but switching to another configuration and back would often fix this
>   issue.
> 
> Unfortunately, I was unable to pinpoint any "smoking gun" due to
> difficulty in reproducing errors.  However, I still think this commit is
> correct, and should be applied. If Linux and the MC are out of sync,
> most of the time things will work correctly but occasionally they won't.
> 
> [1] https://lore.kernel.org/linux-arm-kernel/20221230000139.2846763-1-sean.anderson@seco.com/
>     But with some additional changes for v10.
> 
> Changes in v2:
> - Fix incorrect condition in dpaa2_mac_set_supported_interfaces
> 
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> index c886f33f8c6f..9b40c862d807 100644
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
>  
>  static void dpaa2_mac_link_up(struct phylink_config *config,
> @@ -317,7 +321,8 @@ static void dpaa2_mac_set_supported_interfaces(struct dpaa2_mac *mac)
>  		}
>  	}
>  
> -	if (!mac->serdes_phy)
> +	if (!(mac->features & DPAA2_MAC_FEATURE_PROTOCOL_CHANGE) ||
> +	    !mac->serdes_phy)
>  		return;

For example, you removed the check against
DPAA2_MAC_FEATURE_PROTOCOL_CHANGE from below in dpaa2_mac_connect() just
to put it here.

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
> -- 

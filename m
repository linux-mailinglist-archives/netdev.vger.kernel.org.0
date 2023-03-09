Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3486B26E9
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 15:31:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbjCIObi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 09:31:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230430AbjCIObf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 09:31:35 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2131.outbound.protection.outlook.com [40.107.95.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9CBCE41FF
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 06:31:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aNzwQTTBVrB4gvr7wVR3EhPx78AiwcZNBb0ZCMz6dC8WJ8omwNaxDZDqH5iT3afgqQXt+CjcpotoAd1IrqgyWs/t6+AUK9Zqv/CDKTG+LNAQJN4llpWilU+9DsWuklurE89vLU0/xkHo0A0oeIj9z2MXqHGqseytl3Pj8PTUxfNvq3vmWCzZddOjOFqTmc9I8QZjG6YtAcsRSxfXhtsZnooIt4Ooq0UMGxsmWnkq2uaI00NwtG/069fHap2X81RTbHGSq5lbnPN7zGLl5Yeeew0fR1OZqPdJGMSt7fcC4inJP3/IsaQdwTFCm2eyhLUMtBpCIY/BZvqFGapxRI42ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F1HEVepNLxhk8GsTFdkZoHPXO6AvBslEuYujXrJFkC4=;
 b=Tw4TjXsxtRIyfV9ft4WAztIM99lJRtv7xj474XO/L/Xg6xzijp5RTOsTfpNB7eGJC28+MmPpskzi7PHSTtlPyyax5FTcpCR/Jy4TVHJvi02OuWRcym1qNp9s2cLTk6YW5qsSIla+N0/WehHcMAwCkOJMHhHP0CIRCAHgVZruGyDNRizmtj/GDSkvO3UK41+OyaiLNYwZDMWJJpJOrMOU9A6UoFxxzrIsIaWkwYgxywPXkw1uSbheT5uFFJmeRxwTVf9Zq5ZbZVUMFMReGWP8xXSOfm66XAHZ6MReN502mkRbivnN++yGWcJeF7ajdBl3BpuAfTDgDZAWdvxfUw7aew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F1HEVepNLxhk8GsTFdkZoHPXO6AvBslEuYujXrJFkC4=;
 b=P/ilw/qOo8aJPMusFhftbPPlGZ5uwSkBtcvOWueiJ+g1/Rpg0H7rE5jEtZYwyRJDrOkbXKRzJjdq6jfwSK+kXEBLATbNmOp/GwenQh087BNrJPHoYbhGwMK343dOaXXe1Nhx/j4DELlscmQuGfkxQ4xu8RyMxoLST4s32/73Xc0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM8PR13MB5176.namprd13.prod.outlook.com (2603:10b6:8:6::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.16; Thu, 9 Mar 2023 14:31:32 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.019; Thu, 9 Mar 2023
 14:31:32 +0000
Date:   Thu, 9 Mar 2023 15:31:26 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: phy: smsc: use phy_clear/set_bits in
 lan87xx_read_status
Message-ID: <ZAntvsDrEtx/pIjA@corigine.com>
References: <6c4ca9e8-8b68-f730-7d88-ebb7165f6b1d@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c4ca9e8-8b68-f730-7d88-ebb7165f6b1d@gmail.com>
X-ClientProxiedBy: AM0PR02CA0079.eurprd02.prod.outlook.com
 (2603:10a6:208:154::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM8PR13MB5176:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f71d8d6-047b-4af9-41c8-08db20aafa2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +r93tRqvLDLGGapEFVsMJVnjbXdj+KK4XFhv0hkQry5lalLr8NtJC5SsKY6/Qw+KawNlfRK0pc6W9xp/7YJ/dk7fnCWPtbdVTKSOag2FYdVc9n7iwhuU2uHYH6wu6Czy5cZH27uNtebGzl8xXJSd2CxiumaqVFr1TTm8+rTgD1KNf6C1K32KcBAv1VyiblCN0VwZKMejhv6N/GomIvtZXBj/U4z+KJehgjS0UlNF/W2RzKuIwxiOmZioQ27vAAuccw2Q8okMU83lxM7ThAg2D07s0fdFqR7EwulPR4qU1MLpoD4gil763lzZm6ZgOfzUBK88PVdEzKHjcgI4xoFBXh1FcfEtM+C4ChXriQp1rnGIoPKFt1feLB4JWKAh9C7LzADKC5PiJ8kMAU3cx4/3bOqPOoQTSzKmiWBUz52d4hY5mM16uyRCeUmLRuOsRWo1nxkXaIkS36ACVScLeECubwCl5Z0ksyko+T8idJCFC5UXrvKyqxD2QAxd8647d9RgivvUrA0PSzypA2iZRxy2cUTqXP/C54Z6/i7cecQkAAKCKv0ErpAMWY0o8srHTevHncjDn+hlkDoKpTnTdgv4nRDLjaE9LjhZydUEQ1YXbJX/OmhbhaJlAEavcvKbChuETIAxAuJk/VlkihoHEjnoWB6Yn6Xt4ba6X5jsqW9X3XfxDH1JuvJSRrYD4p6neopg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(346002)(39840400004)(366004)(136003)(451199018)(44832011)(8936002)(6486002)(186003)(83380400001)(5660300002)(6506007)(36756003)(6666004)(6512007)(54906003)(316002)(2616005)(41300700001)(86362001)(66556008)(478600001)(38100700002)(66476007)(8676002)(6916009)(66946007)(2906002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1XLTKIRrOcSp5koaMGlH9pPuFCADU3NssaRbLvmdHzNaV7uTehhdfdzhLWhL?=
 =?us-ascii?Q?4cNqENrD/3L7mwcPDd75FAPGeWYwVxcjLQpTzA2wtqzgOAQcYd26InUBsmXH?=
 =?us-ascii?Q?Qd2yFMujLrfJehQ7H+1VaEPIxG9JzFQRA8j4vX23g83eTiqNBF5vWb5FBP+A?=
 =?us-ascii?Q?m1dlcSgejNelaJSFUStUcYMO+qdl/kK1UJHEWn3htmOmNfZA/yASJZgUR/wd?=
 =?us-ascii?Q?K3tyZdi1ozLFzuILtOJsqbS5zSKGiInTTVnNG2EzfqoI3SraKQZWhPCSD6O3?=
 =?us-ascii?Q?e6OpIVLHfx8J2HLYwvedTW4cYoS+MaIEwBIemrPzTaKPXabJZPzH6C88Kf02?=
 =?us-ascii?Q?0cnUM9wwqJRWlv7sqbEDEG6wW+KQ9VQMSqPd44E8yyhRMEDZulk1OrS2Zy4f?=
 =?us-ascii?Q?HBkJGncTFCRkmaxPnlN2ahxs8r2NKGVV65d/A5S+Vj6kdnvVJOLA0X2+YfRw?=
 =?us-ascii?Q?Trd3Fe+pxQPf1B2P149QX3fl7x/CxCapR1hfiNGhlS4BVmvChyCfWDEx0d2w?=
 =?us-ascii?Q?YbhYGbg4kz6Z9c7jxDFBi0MHIDl8P2bX2zt9CMYAE6oxDmcYbekbJ/hLuxBS?=
 =?us-ascii?Q?1NS0/XFqSuTl+3xtfmd3q+zmYwO/48q2EhoxbJP9VrGURxt+xFUAud8URX3b?=
 =?us-ascii?Q?/P+rihU/S1etcRFC79d66O0P8YofsmRObzMu4E9PYKuRC1/jo+R6QG6Vnvzc?=
 =?us-ascii?Q?QRMGfF19Q/VAjI24CIOq0fLa3USy7Vhkmjr1+yJznXIZZ20TA7EDH8HeFXjZ?=
 =?us-ascii?Q?X6hq5BPnT4Mal8YcdMWhsghpfo1ju8P+8XuCBu/5Uqgv3ZkuQudQDG52/DIL?=
 =?us-ascii?Q?cLrYK/yA7jJ3oQ0A8gPyxjaV+8kXEsgTAFN7tgWjEBC4DEZZ1xVjCCzHkVNu?=
 =?us-ascii?Q?E26OxQ4O2juMrynUaMNqEBGaqcMGXnvVrAKD2TSxmxC9PcMLcrHCiCBPnNvf?=
 =?us-ascii?Q?HERHrBH6wQgrJenUU1Z1LILfq2B5fjSzOmbcmYC+FMbQvQ34QwExoWe3SMve?=
 =?us-ascii?Q?fqp0tPqHSDDNB2QttKeIlurcc5v0OD/+x1G0ulXiOYQs16WK7lc7xhy1veKE?=
 =?us-ascii?Q?HTZWDus6m/eNkxkJM2WoNgCGhcJpHpMKWoJJ6e6NcDDjGkDo2QtDi0kaX9kU?=
 =?us-ascii?Q?N3zvLhf/0xNV0gJn2hf+Dfr2XM8FGHBVlbhh956jQqhd7FG6/Lpd0PcUTw8m?=
 =?us-ascii?Q?E0ylNFDkkuWXCs+0nXGc2/VFaMQvzanYk3IKpz1LVkjkRLp2PhsveoKHvkB4?=
 =?us-ascii?Q?Yd2N5s6lTH2FmHb+Fb6WZHQvJojhtgOSTTrVu3UiwlG7ePE+2K2/r3qRdR+K?=
 =?us-ascii?Q?wBrfEbVek1kUrXtnT35sg6wVncvLvxBQpgInt1W1bdxLD6l5c7bl74oPso+k?=
 =?us-ascii?Q?e9gI7WYSR5eIYqEv0jS8n1dAaIkrILXvesw2tTa4+3ywdY7H/PYu733RGXAn?=
 =?us-ascii?Q?LMqv5GP5YdCATsVU0tN+5+WViZREyNuK7XvC/mGsLKBMWjg9ahEvCkdj9X0G?=
 =?us-ascii?Q?DCFkKmZpMl4JETFmhmWb6YPm+lgOmp2K7mbQH11yzvHPCjA2atZF4j3HI3Wd?=
 =?us-ascii?Q?p0jpxOkrCEcsnMD+yTEKffYHDGyEeCmGbuh+F3AxhvNGRpPLz/78iDy3ekNn?=
 =?us-ascii?Q?2xs4fb6Gwm2YCU9OhUsMihD3J98R1dsoyWIK/9wNv21rIUDFcY6lwklU/7Ei?=
 =?us-ascii?Q?1+T21Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f71d8d6-047b-4af9-41c8-08db20aafa2d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 14:31:31.8730
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4AbAc+4ni8L7VMuJ12Q37jZsJIrJ+nNwmQT4P0kAB9VAyNod0u9dQvPvAGLfyu8I7twT4+OnkNl7pq72m5gbgmy86GQCUR5LsNxMf8mqFPA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR13MB5176
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 08, 2023 at 09:11:02PM +0100, Heiner Kallweit wrote:
> Simplify the code by using phy_clear/sert_bits().
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/phy/smsc.c | 25 ++++++++++---------------
>  1 file changed, 10 insertions(+), 15 deletions(-)

The phy_clear/sert_bits changes lookg good.
But I have a few nit-pick comments.

> diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
> index af89f3ef1..5965a8afa 100644
> --- a/drivers/net/phy/smsc.c
> +++ b/drivers/net/phy/smsc.c
> @@ -204,17 +204,16 @@ static int lan95xx_config_aneg_ext(struct phy_device *phydev)
>  static int lan87xx_read_status(struct phy_device *phydev)
>  {
>  	struct smsc_phy_priv *priv = phydev->priv;
> +	int rc;
>  
> -	int err = genphy_read_status(phydev);
> +	rc = genphy_read_status(phydev);
> +	if (rc)
> +		return rc;

nit: this seems like a separate change, possibly a fix.

>  
>  	if (!phydev->link && priv->energy_enable && phydev->irq == PHY_POLL) {
>  		/* Disable EDPD to wake up PHY */
> -		int rc = phy_read(phydev, MII_LAN83C185_CTRL_STATUS);
> -		if (rc < 0)
> -			return rc;
> -
> -		rc = phy_write(phydev, MII_LAN83C185_CTRL_STATUS,
> -			       rc & ~MII_LAN83C185_EDPWRDOWN);
> +		rc = phy_clear_bits(phydev, MII_LAN83C185_CTRL_STATUS,
> +				    MII_LAN83C185_EDPWRDOWN);
>  		if (rc < 0)
>  			return rc;
>  
> @@ -222,24 +221,20 @@ static int lan87xx_read_status(struct phy_device *phydev)
>  		 * an actual error.
>  		 */
>  		read_poll_timeout(phy_read, rc,
> -				  rc & MII_LAN83C185_ENERGYON || rc < 0,
> +				  rc < 0 || rc & MII_LAN83C185_ENERGYON,

nit: this also seems like a separate change.

>  				  10000, 640000, true, phydev,
>  				  MII_LAN83C185_CTRL_STATUS);
>  		if (rc < 0)
>  			return rc;
>  
>  		/* Re-enable EDPD */
> -		rc = phy_read(phydev, MII_LAN83C185_CTRL_STATUS);
> -		if (rc < 0)
> -			return rc;
> -
> -		rc = phy_write(phydev, MII_LAN83C185_CTRL_STATUS,
> -			       rc | MII_LAN83C185_EDPWRDOWN);
> +		rc = phy_set_bits(phydev, MII_LAN83C185_CTRL_STATUS,
> +				  MII_LAN83C185_EDPWRDOWN);
>  		if (rc < 0)
>  			return rc;
>  	}
>  
> -	return err;
> +	return 0;
>  }
>  
>  static int smsc_get_sset_count(struct phy_device *phydev)
> -- 
> 2.39.2
> 

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C71856F2589
	for <lists+netdev@lfdr.de>; Sat, 29 Apr 2023 20:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjD2R6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Apr 2023 13:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjD2R6S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Apr 2023 13:58:18 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2051.outbound.protection.outlook.com [40.107.6.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65E8F10D1
        for <netdev@vger.kernel.org>; Sat, 29 Apr 2023 10:58:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JJ+LqMfap/tW22Fb5jbA6fN6TeEigMB4cCAkau6QS5jVw2XR6GzV+stT7/7BkjdrmEHyT8SYPOD4i7RmBfTzC30u8MI1mcuKwTr9eHPU3SiHjvM8VBxb02/TTrd7qPDs3h97AsemcAXgU7BIdCruQCsinFGXq2/yzUc4+Y/VmigGD6VFmrf1yizRSCPWFQlXBvdDrxjX1Dap5OiqTfA2jWj6sPXuP8M5GBs7fj3tEP2sO/wM1DCeih3reqGzwJaGrykscw+sXq4SIjnHfIaPYPYlCetAH3QEZ5FRr0AIwfW1la2JnD7FrgilzYwBZGZ+1StJ9AjQKLs381Wd6yvJiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LX0esyLQY0UKMAemXbb+vQgWQQNYvYMfrR2q6KbPQu4=;
 b=N08OG0IYIHnckVjLFiBsOjYIq3WXcu4Gka4xw4nGwYTrVZ849wO4A4r3lYF0EWh4UpLt5IicmuYkUzYffa1RRrbOwpUIoCqJl9tcRo81A3fHwvRu3Z4fjBrl2Qn5I7P0hS3ZDchuleFSYBy0PoYhP5u1tCBLStWFXiv4NKDEJt8+OUumk0rebtw58xF973OLhX2hGPi4jA09Zt2kIm2m42mcFO5oWAKrwbB3YGko9I1mZdVauUpMYyjd+98UdcZkhsppjATThynfgYwAdQkLM6z3oWxksj2Qzsx67CLPvh0HclP9bObHjXohLe1pC0YHQBA4VJ/qgzGov4ZbkiXtpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LX0esyLQY0UKMAemXbb+vQgWQQNYvYMfrR2q6KbPQu4=;
 b=jH436nU2aRPC88KdsiFUY0NPv/B7yIC2FtrMDV4HhTDIiNiC2jtkmlpHRUlf9+W1Aci+5DlplaCIzlmsMCQ/6lphBUmJGQgPih7s/AgAOxprHcfe/vtzy74GC0A6f6Nsutnjaj9d3k7V/eBZ6js51Kaw+mvJFxa+4wEXxOOo6y4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by VI1PR04MB6975.eurprd04.prod.outlook.com (2603:10a6:803:138::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.26; Sat, 29 Apr
 2023 17:58:11 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c%3]) with mapi id 15.20.6340.025; Sat, 29 Apr 2023
 17:58:11 +0000
Date:   Sat, 29 Apr 2023 20:58:07 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     =?utf-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, glipus@gmail.com,
        maxime.chevallier@bootlin.com, vadim.fedorenko@linux.dev,
        richardcochran@gmail.com, gerhard@engleder-embedded.com,
        thomas.petazzoni@bootlin.com, krzysztof.kozlowski+dt@linaro.org,
        robh+dt@kernel.org, linux@armlinux.org.uk
Subject: Re: [PATCH net-next RFC v4 4/5] net: Let the active time stamping
 layer be selectable.
Message-ID: <20230429175807.wf3zhjbpa4swupzc@skbuf>
References: <20230406173308.401924-1-kory.maincent@bootlin.com>
 <20230406173308.401924-1-kory.maincent@bootlin.com>
 <20230406173308.401924-5-kory.maincent@bootlin.com>
 <20230406173308.401924-5-kory.maincent@bootlin.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230406173308.401924-5-kory.maincent@bootlin.com>
 <20230406173308.401924-5-kory.maincent@bootlin.com>
X-ClientProxiedBy: VI1PR0801CA0076.eurprd08.prod.outlook.com
 (2603:10a6:800:7d::20) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|VI1PR04MB6975:EE_
X-MS-Office365-Filtering-Correlation-Id: 51460777-2c5b-4396-76fd-08db48db4bbc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FsJFEDCce9vSQ7Fn+dXTxjfH6gdr+fkeY4SjTMKMKTJV3Qhg6bJsC/KxTN0zwsmewJ+pz+sQiZQ3XR3y1wKlF1DulG2YjCaQFmZh5e5IVKQyMsSuz4OxmCC2FmzKWNviMU46f23cUAusYhaDMOXXlSkOMFzvukgBF67MUmK+J7mvhrngdyWB2X4eoRdPU7lD4wKDW0+aYT3OsveTHUvbdab++T++J1+C+bi/bWYFEZ3AZ2s1xTfi8JbgOb7zqZkpgCJjNHNfrPT0ZRedSTiUv4r/TP44hGlTLd62Nt9N9R9I7oWWjign81HO3I9ARrclfE4IdY9/8IJBcQmgfbcjV7ldJoPAtWkIzMJLb61RzrL1yht3XeRRX1V4G8HCHJe+rIKz4+bnXLf6Spb7VSxmB9RycKmva5wDnGWJQ+2ttZg/j1cPJKYLSBS0TNoaqD7hCX5Rh/fmB3LejTnDQwUw+OWhfeitTcGlOEsyCBdN1UbIVbx07emqGmzjJR2u3Jx/M1qFewJQokihrzKeJKRFej0jv7AtVpBFFEg98CI3IafItzYJwHTO/lSeofzLjtw2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(346002)(396003)(366004)(376002)(39850400004)(136003)(451199021)(38100700002)(5660300002)(7416002)(44832011)(2906002)(8676002)(8936002)(86362001)(316002)(66476007)(66556008)(66946007)(41300700001)(4326008)(6916009)(66574015)(83380400001)(186003)(6512007)(6506007)(1076003)(26005)(33716001)(9686003)(478600001)(6486002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?enOWF3fby8qXShX6BeVa/K5vGxatC1XHZcvedM744ZwgJxAq+yL0VwLFe9?=
 =?iso-8859-1?Q?Gm04p8Th3T7Fg3P6s2hd1Y4/Jj1okOcRcRUl3jAgmx1ZCXTatB59Er8cZx?=
 =?iso-8859-1?Q?YwcE4Yf3TZZe4LkCE6JUltGkBeD/PwFNDwQbs7ekk0OXFxKJUEbyrG4zGv?=
 =?iso-8859-1?Q?2d0FdcrTjsl/uQffGPNk2YVR/brTdpGC9Oh9FTuWoRIsYzCSLp1ep6YPny?=
 =?iso-8859-1?Q?qCJuFpdERzS99jM8fUSj09K9j2YOnZuWQPVyKvBxKL7poYf5GumagV/vx3?=
 =?iso-8859-1?Q?LBVGKxuOv+Vx1FlLmqzkl5+8dLGZ5WXYFPOabtr0WuyUTjNkDU060L/CRo?=
 =?iso-8859-1?Q?qbVxds4up3FnNmmpVRYzFzscL3usxTLcDPCsPExssMfjnOPqygJ7xL2zIW?=
 =?iso-8859-1?Q?wePJOuZ49y8Ppn8fyi3r4AepQM7tzz9x7uZ8CaM0yLvfEX5b67vfxNAy2+?=
 =?iso-8859-1?Q?ShkxqPqPPZ7ORw2y1+N1J8yk/zkHV2rEL5zGoXBWbWbyetZAYqNp5Zb8oT?=
 =?iso-8859-1?Q?0aWX/BCNZnsipeneNk1EB01BBwuLOqPyldWR7nAOVI/CgRDRLytTtjquMW?=
 =?iso-8859-1?Q?ym8ebLfccGFRp0nATOHnBLu70T9QCrNcBMousNOSnj/O5HcIcujOwyER00?=
 =?iso-8859-1?Q?29dYaqsin85xj0II4jBLfIg9O3dqoaSFsZ0iDyUBOnc13B6dfPlkmqT3dz?=
 =?iso-8859-1?Q?p1gAlUlrqt/kFk7vzANqw1pUyTL74iCezuKT0sD3fYilrQJzSHgXJ1JZOR?=
 =?iso-8859-1?Q?12dOIZ//De1d11cpJkhkv/vSDUx7C3Wcx7N/f3cQZz0khhQ86AD66DzkO4?=
 =?iso-8859-1?Q?ZRIYY1Bw/UKjdfjl12Wn3p+z6FUJvllHW5nPutu49/EtUIHcBd0ws410Fu?=
 =?iso-8859-1?Q?Rp9Mt8Uy8avCWIUlGT/rTJSoY6q8m4ZBHouvkGmELW2XfyUy0j70CfG7o5?=
 =?iso-8859-1?Q?zhfeXlnyyJowuMbVdLpnsuPRyk14kzIQrZ1Dj8cjdTyDaOyTnM5YK2iI37?=
 =?iso-8859-1?Q?qjWJLvqCXK1XfEsAADoxU16ZvVP9SyDrvQ5TyB1SIaY9drnRwKQgLCbBNc?=
 =?iso-8859-1?Q?ACI/e55R4njvaLvhHy2zMGfRjeQL3TQeD2CyZv3FOEqjVurymhjJ8odXV3?=
 =?iso-8859-1?Q?QsSAAXyQvgzC+1Tx0dBSgHNBXCAnpVRLriVT5I/yu6C8eencD8N82ev0oS?=
 =?iso-8859-1?Q?CKF8vN+KTXuJuOn2Zb7Np+/XGX+30XglbzcSSizsPgFUinFcf+dF37TN3o?=
 =?iso-8859-1?Q?Q2fWknxnqRvMoCfORgCzpF46nkZpCCY5hBONjJyCMmbR/LPZocrX69mSjJ?=
 =?iso-8859-1?Q?JsQ0hb4Y77Z+3a6ndH7SgpNcIApl0LAV8hs1bnQT+fmbHEEPz37rlwXP08?=
 =?iso-8859-1?Q?LdfGTARVTJ1ogEk0IJ3K4lN6ZbEYo7epV13R3eqZIhB0706H9SYfZjG9XM?=
 =?iso-8859-1?Q?YB+T+CFvvCYBgj62DDvnKJxayeT8zlp11FPloqH0UwUeOep37QtZbD2LOc?=
 =?iso-8859-1?Q?J6vhTJqvLSNn9DEL+/lTdcwu+k2J9Epl4t+M0HwjZKO9RyLwWj23wV8Kyf?=
 =?iso-8859-1?Q?yeG53IvrodLAlI2Kw1eEsjpllueVN1mKEahsbuIrEX0ZDeY+GaAwyxIMmV?=
 =?iso-8859-1?Q?y4rPGmUCTwCktiTOzWlxxEk4OnCZfX9OUK1BumYPPKGRkaY54OdijVIA?=
 =?iso-8859-1?Q?=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51460777-2c5b-4396-76fd-08db48db4bbc
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2023 17:58:11.1327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OEqMrtQVUmTXi3upbuu5THJqvZBGusDoBO4XCWkhzhNU1qVrmt4KjLbnrMBHOdVhrIbbB/JbKn9bJ0FyK9TOIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6975
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 07:33:07PM +0200, Köry Maincent wrote:
> +static void of_set_timestamp(struct net_device *netdev, struct phy_device *phydev)
> +{
> +	struct device_node *node = phydev->mdio.dev.of_node;
> +	const struct ethtool_ops *ops = netdev->ethtool_ops;
> +	const char *s;
> +	enum timestamping_layer ts_layer = 0;

netdev likes variable declaration lines sorted longest to shortest

> +	int i;
> +
> +	/* Backward compatibility to old API */
> +	for (i = 0; phy_timestamping_whitelist[i] != NULL; i++)
> +	{

The kernel coding style likes the opening { on the same line as the for

> +		if (!strcmp(phy_timestamping_whitelist[i],
> +			    phydev->drv->name)) {
> +			if (phy_has_hwtstamp(phydev))
> +				ts_layer = SOF_PHY_TIMESTAMPING;
> +			else if (ops->get_ts_info)
> +				ts_layer = SOF_MAC_TIMESTAMPING;
> +			goto out;
> +		}
> +	}
> +
> +	if (ops->get_ts_info)
> +		ts_layer = SOF_MAC_TIMESTAMPING;
> +	else if (phy_has_hwtstamp(phydev))
> +		ts_layer = SOF_PHY_TIMESTAMPING;
> +
> +	if (of_property_read_string(node, "preferred-timestamp", &s))
> +		goto out;
> +
> +	if (!s)
> +		goto out;
> +
> +	if (phy_has_hwtstamp(phydev) && !strcmp(s, "phy"))
> +		ts_layer = SOF_PHY_TIMESTAMPING;
> +
> +	if (ops->get_ts_info && !strcmp(s, "mac"))
> +		ts_layer = SOF_MAC_TIMESTAMPING;
> +
> +out:
> +	netdev->selected_timestamping_layer = ts_layer;
> +}
> +
>  /**
>   * phy_attach_direct - attach a network device to a given PHY device pointer
>   * @dev: network device to attach
> @@ -1481,6 +1560,8 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
>  
>  	phydev->phy_link_change = phy_link_change;
>  	if (dev) {
> +		of_set_timestamp(dev, phydev);
> +
>  		phydev->attached_dev = dev;
>  		dev->phydev = phydev;
>  
> @@ -1811,6 +1892,10 @@ void phy_detach(struct phy_device *phydev)
>  
>  	phy_suspend(phydev);
>  	if (dev) {
> +		if (dev->ethtool_ops->get_ts_info)
> +			dev->selected_timestamping_layer = SOF_MAC_TIMESTAMPING;
> +		else
> +			dev->selected_timestamping_layer = 0;
>  		phydev->attached_dev->phydev = NULL;
>  		phydev->attached_dev = NULL;
>  	}
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index a740be3bb911..3dd6be012daf 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -48,6 +48,7 @@
>  #include <uapi/linux/if_bonding.h>
>  #include <uapi/linux/pkt_cls.h>
>  #include <uapi/linux/netdev.h>
> +#include <uapi/linux/net_tstamp.h>
>  #include <linux/hashtable.h>
>  #include <linux/rbtree.h>
>  #include <net/net_trackers.h>
> @@ -2019,6 +2020,9 @@ enum netdev_ml_priv_type {
>   *
>   *	@threaded:	napi threaded mode is enabled
>   *
> + *	@selected_timestamping_layer:	Tracks whether the MAC or the PHY
> + *					performs packet time stamping.
> + *
>   *	@net_notifier_list:	List of per-net netdev notifier block
>   *				that follow this device when it is moved
>   *				to another network namespace.
> @@ -2388,6 +2392,8 @@ struct net_device {
>  	unsigned		wol_enabled:1;
>  	unsigned		threaded:1;
>  
> +	enum timestamping_layer selected_timestamping_layer;
> +
>  	struct list_head	net_notifier_list;
>  
>  #if IS_ENABLED(CONFIG_MACSEC)
> @@ -2879,6 +2885,7 @@ enum netdev_cmd {
>  	NETDEV_OFFLOAD_XSTATS_REPORT_DELTA,
>  	NETDEV_XDP_FEAT_CHANGE,
>  	NETDEV_PRE_CHANGE_HWTSTAMP,
> +	NETDEV_CHANGE_HWTSTAMP,

Don't create new netdev notifiers with no users. Also, NETDEV_PRE_CHANGE_HWTSTAMP
has disappered.

>  };
>  const char *netdev_cmd_to_name(enum netdev_cmd cmd);
>  
> @@ -2934,6 +2941,11 @@ struct netdev_notifier_hwtstamp_info {
>  	struct kernel_hwtstamp_config *config;
>  };
>  
> +struct netdev_notifier_hwtstamp_layer {
> +	struct netdev_notifier_info info; /* must be first */
> +	enum timestamping_layer ts_layer;
> +};
> +
>  enum netdev_offload_xstats_type {
>  	NETDEV_OFFLOAD_XSTATS_TYPE_L3 = 1,
>  };
> diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
> index 447908393b91..4f03e7cde271 100644
> --- a/include/uapi/linux/ethtool_netlink.h
> +++ b/include/uapi/linux/ethtool_netlink.h
> @@ -41,6 +41,7 @@ enum {
>  	ETHTOOL_MSG_TSINFO_GET,
>  	ETHTOOL_MSG_TSLIST_GET,
>  	ETHTOOL_MSG_TS_GET,
> +	ETHTOOL_MSG_TS_SET,

The way in which the Linux kernel ensures a stable API towards user
space is that programs written against kernel headers from 5 years ago
still work with kernels from today. In your case, you would be breaking
that, because before this patch, ETHTOOL_MSG_CABLE_TEST_ACT was 26, and
after your patch it is 27. So old applications emitting a cable test
netlink message would be interpreted by new kernels as emitting a "set
timestamping layer" netlink message. Of course not only the cable test
is affected, every other netlink message until the end is now shifted by
1. This is why we put new enum values only at the very end, where it
actually says they should go:

	/* add new constants above here */

>  	ETHTOOL_MSG_CABLE_TEST_ACT,
>  	ETHTOOL_MSG_CABLE_TEST_TDR_ACT,
>  	ETHTOOL_MSG_TUNNEL_INFO_GET,
> @@ -96,6 +97,7 @@ enum {
>  	ETHTOOL_MSG_TSINFO_GET_REPLY,
>  	ETHTOOL_MSG_TSLIST_GET_REPLY,
>  	ETHTOOL_MSG_TS_GET_REPLY,
> +	ETHTOOL_MSG_TS_NTF,

Similar issue.

>  	ETHTOOL_MSG_CABLE_TEST_NTF,
>  	ETHTOOL_MSG_CABLE_TEST_TDR_NTF,
>  	ETHTOOL_MSG_TUNNEL_INFO_GET_REPLY,
> diff --git a/net/ethtool/common.c b/net/ethtool/common.c
> index 695c7c4a816b..daea7221dd25 100644
> --- a/net/ethtool/common.c
> +++ b/net/ethtool/common.c
> @@ -61,9 +55,65 @@ static int ts_fill_reply(struct sk_buff *skb,
>  			     const struct ethnl_reply_data *reply_base)
>  {
>  	struct ts_reply_data *data = TS_REPDATA(reply_base);
> +

gratuitous change

>  	return nla_put_u32(skb, ETHTOOL_A_TS_LAYER, data->ts);
>  }
>  
> +/* TS_SET */
> +const struct nla_policy ethnl_ts_set_policy[] = {
> +	[ETHTOOL_A_TS_HEADER]	= NLA_POLICY_NESTED(ethnl_header_policy),
> +	[ETHTOOL_A_TS_LAYER]	= { .type = NLA_U32 },
> +};

I wanted to explore this topic myself, but I can't seem to find the
time, so here's something a bit hand-wavey.

We should make a distinction between what the kernel exposes as UAPI
(our future selves need to work with that in a backwards-compatible way)
and the internal, unstable kernel implementation.

It would be good if, instead of the ETHTOOL_A_TS_LAYER netlink
attribute, the kernel could expose a more generic ETHTOOL_A_TS_PHC, from
which the ethtool core could deduce if the PHC number belongs to the MAC
or to the PHY. We could still keep something like netdev->selected_timestamping_layer
in code private to the kernel, but from the UAPI perspective, I agree
with Andrew that we should design something that is cleanly extensible
to N PHCs, not just to a vague "layer".

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 243F75F0F9F
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 18:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231937AbiI3QLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 12:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231944AbiI3QLX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 12:11:23 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2056.outbound.protection.outlook.com [40.107.220.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C5041003B2;
        Fri, 30 Sep 2022 09:11:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n8stm2xhnQZ6yEN7A8TLjDkH/BkfhFlV8QDXxQgZY0YTgamwf+n7nP8UCPA2vNas+2ms6asSn+QffQ5KfwaNYXSdBmQoYUuE9No1GS9sazMRD5SAzJWIT4k2FUDBHoM5I0UTcdUCgIsn4mkX1NPBj6kDNYQ9BWXUsRdHoP3DzWv+MkgDmuCSmsVZFLngrWLFs0IB/cwZq2pzpcQmX0VTfl5paUBBldKxQGthzFJmWz+PrRrMegWfwdgxnUBWSszcPXsjoacEia5PzDmIZogXb2b4cnV3320Z9nfgg/XYzohn7RuPfpSPlMA8fT6oO/36/ZbhJOqpHdqFV1R58It7RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0oX2klgM7hlb98JGbFOZo7WSyeWqWtvc+KTAEuMcsEI=;
 b=B8gXVdAohL4w+s22AWE2mJocRdCWeLsMePOW+sx8zEn0lWNXtmp4X/W1zeRvzR01S3V05Uzs3rXv9R9i44N6Ojn2AfvfEjOh/NVfWWsL98s0eIm1uZBEPBZtAp+xb6LEzImywjWb1PDsfi3PLoXm7XUo+H/zEJmOz78DLL/0/00Z3v+742DYA0SFOMmbMyz4eJ3PSAgedJrLAaBanlLuLTTMkgSP1LWzu/OApIEdG3Hk3ne84X+YI7sNL8wgW3b+iBRa/CqFRY38gRF1zvrj0b05hFfige/yueA72LXkuqZtmfb2wbNK4VmWmmdgh+myBRGsyJ0wdz1NhOyvjqwdzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.infradead.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0oX2klgM7hlb98JGbFOZo7WSyeWqWtvc+KTAEuMcsEI=;
 b=kSZ92dV5tvLI+kuXEDz1ysq2txsATCzvT/edeXoN2oofYuDSWl5UZWOVMJd9sAPxyoXDFIkDRGCNbhe34jovjyp9iqKoMD2PO+wZqqi/XDhsbdamfbx0LzNyn55rvkYuZCyJPRphgXPKt9HAzmusmngyPoMynIJqyop9RgnwmN0+0gQiezAwd6LxIz5NyfVP7g2ALv82GahBvQzUjLYhC8tuUz0dIpX7H6dfjlQEJi95LwbO89qFz5KuqXdBMNEi2ppz6JYlwvkhEiUJN1I5YItZAkdeDf4369ouW8EBsASVZC8rVnG197DoGS7dIdZq5b8/qnvEQ6+E608/auK4Yg==
Received: from MN2PR11CA0022.namprd11.prod.outlook.com (2603:10b6:208:23b::27)
 by DM4PR12MB5149.namprd12.prod.outlook.com (2603:10b6:5:390::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Fri, 30 Sep
 2022 16:11:20 +0000
Received: from BL02EPF0000C409.namprd05.prod.outlook.com
 (2603:10b6:208:23b:cafe::95) by MN2PR11CA0022.outlook.office365.com
 (2603:10b6:208:23b::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.17 via Frontend
 Transport; Fri, 30 Sep 2022 16:11:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF0000C409.mail.protection.outlook.com (10.167.241.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.17 via Frontend Transport; Fri, 30 Sep 2022 16:11:19 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Fri, 30 Sep
 2022 09:10:53 -0700
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Fri, 30 Sep
 2022 09:10:48 -0700
References: <20220929185207.2183473-1-daniel.machon@microchip.com>
 <20220929185207.2183473-5-daniel.machon@microchip.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Daniel Machon <daniel.machon@microchip.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <petrm@nvidia.com>, <maxime.chevallier@bootlin.com>,
        <thomas.petazzoni@bootlin.com>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>,
        <lars.povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <joe@perches.com>,
        <linux@armlinux.org.uk>, <horatiu.vultur@microchip.com>,
        <Julia.Lawall@inria.fr>, <vladimir.oltean@nxp.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH net-next v2 4/6] net: microchip: sparx5: add support for
 apptrust
Date:   Fri, 30 Sep 2022 17:49:15 +0200
In-Reply-To: <20220929185207.2183473-5-daniel.machon@microchip.com>
Message-ID: <87zgegu9kq.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0000C409:EE_|DM4PR12MB5149:EE_
X-MS-Office365-Filtering-Correlation-Id: dbcc487e-b23f-421a-1e6f-08daa2fe6949
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nNs41jbNN3Xia/wCh37tyxsPRdgQJ2Jcfh3gZhET5nnxOLHIjo1j8QU2XK5U1n5C3xhZZL2QOmmoBIkgnUg0HpVh3126yLCx35bZP6qoMt0stMd174cVIS64bHW6UNk69Le6Wtc+5ErFQs1um1auG1KszXcmkwnZFnDpUWvLW1l/9nPEyKLcG2DbmMWehBAIHqpXmHozjMG1puxfPLOf63Y4Q/geYaM4CXH8yNVpBL4kzbibY1KK6di/13ZzNvznpNKfC+qKvZACeRGMVk2lh+dO6MC/IUmWh848cxkWyDPvrOPHxIQdhLbFFtMvjz7yqmon61UMxZMlwHmwc2luAiuQ7x51sOKijUKTAhdMjQFhM4TDBVzmXZEtZlFmCh9tXrhnOOS2WIxzUt+300BdGQAe8JM7ImzlG7fYuh9ug/WQwdVGJDpmHFD3LL2KtoNIa/UwBUBSz7ztrDuTCScqy7XBn5gmJv1Ccdnm3xo70ZxVzkxGFbyYgdgwaDHir0m/2S1D/2Xq+cWGumfSo/uSAG0q51T0lFLVnlr4x/hVdtGVlNOsQ0InBA84mZSDJP8ZKLZ2ODrb/ApH0oBGDXtkXblt/2oE6WA0kWoPdkg7eaOg4RSIjhU8ZxZigb0dJzS5XB25VT3+kBYOY4v4mr7E19PLIZGkOH3vWXxPdZuiLVE8ABnuOHLFeHDEIuay0b02pDX9PgRF9qvwdcY9ZUOJZkHi7fzFNINZjTIU4cq1i1CJfNKZ02Ti9YznsQLQnoGB3l00LGF9aGjaUuMNH4sTQQ==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(346002)(376002)(396003)(451199015)(40470700004)(46966006)(36840700001)(86362001)(40480700001)(83380400001)(336012)(478600001)(426003)(26005)(7636003)(54906003)(82740400003)(6666004)(4326008)(36756003)(5660300002)(356005)(6916009)(316002)(8936002)(186003)(16526019)(36860700001)(40460700003)(82310400005)(47076005)(41300700001)(8676002)(2616005)(70586007)(70206006)(7416002)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2022 16:11:19.6107
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dbcc487e-b23f-421a-1e6f-08daa2fe6949
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF0000C409.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5149
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Daniel Machon <daniel.machon@microchip.com> writes:

> Make use of set/getapptrust() to implement per-selector trust and trust
> order.
>
> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
> ---
>  .../ethernet/microchip/sparx5/sparx5_dcb.c    | 116 ++++++++++++++++++
>  .../ethernet/microchip/sparx5/sparx5_main.h   |   3 +
>  .../ethernet/microchip/sparx5/sparx5_port.c   |   4 +-
>  .../ethernet/microchip/sparx5/sparx5_port.h   |   2 +
>  .../ethernet/microchip/sparx5/sparx5_qos.c    |   4 +
>  5 files changed, 127 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c b/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c
> index db17c124dac8..10aeb422b1ae 100644
> --- a/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c
> +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c
> @@ -8,6 +8,22 @@
>
>  #include "sparx5_port.h"
>
> +static const struct sparx5_dcb_apptrust {
> +	u8 selectors[256];
> +	int nselectors;
> +	char *names;

I think this should be just "name".

> +} *apptrust[SPX5_PORTS];
> +
> +/* Sparx5 supported apptrust configurations */
> +static const struct sparx5_dcb_apptrust apptrust_conf[4] = {
> +	/* Empty *must* be first */
> +	{ { 0                         }, 0, "empty"    },
> +	{ { IEEE_8021QAZ_APP_SEL_DSCP }, 1, "dscp"     },
> +	{ { DCB_APP_SEL_PCP           }, 1, "pcp"      },
> +	{ { IEEE_8021QAZ_APP_SEL_DSCP,
> +	    DCB_APP_SEL_PCP           }, 2, "dscp pcp" },
> +};
> +
>  /* Validate app entry.
>   *
>   * Check for valid selectors and valid protocol and priority ranges.
> @@ -37,12 +53,59 @@ static int sparx5_dcb_app_validate(struct net_device *dev,
>  	return err;
>  }
>
> +/* Validate apptrust configuration.
> + *
> + * Return index of supported apptrust configuration if valid, otherwise return
> + * error.
> + */
> +static int sparx5_dcb_apptrust_validate(struct net_device *dev, u8 *selectors,
> +					int nselectors, int *err)
> +{
> +	bool match;
> +	int i, ii;
> +
> +	for (i = 0; i < ARRAY_SIZE(apptrust_conf); i++) {

I would do this here:

    if (apptrust_conf[i].nselectors != nselectors) continue;

to avoid having to think about the semantics of comparing to all those
zeroes in apptrust_conf.selectors array.

> +		match = true;
> +		for (ii = 0; ii < nselectors; ii++) {
> +			if (apptrust_conf[i].selectors[ii] !=
> +			    *(selectors + ii)) {
> +				match = false;
> +				break;
> +			}
> +		}
> +		if (match)
> +			break;
> +	}
> +
> +	/* Requested trust configuration is not supported */
> +	if (!match) {
> +		netdev_err(dev, "Valid apptrust configurations are:\n");
> +		for (i = 0; i < ARRAY_SIZE(apptrust_conf); i++)
> +			pr_info("order: %s\n", apptrust_conf[i].names);
> +		*err = -EOPNOTSUPP;
> +	}
> +
> +	return i;
> +}
> +
> +static bool sparx5_dcb_apptrust_contains(int portno, u8 selector)
> +{
> +	int i;
> +
> +	for (i = 0; i < IEEE_8021QAZ_APP_SEL_MAX + 1; i++)
> +		if (apptrust[portno]->selectors[i] == selector)
> +			return true;
> +
> +	return false;
> +}
> +
>  static int sparx5_dcb_app_update(struct net_device *dev)
>  {
>  	struct dcb_app app_itr = { .selector = DCB_APP_SEL_PCP };
>  	struct sparx5_port *port = netdev_priv(dev);
>  	struct sparx5_port_qos_pcp_map *pcp_map;
>  	struct sparx5_port_qos qos = {0};
> +	int portno = port->portno;
>  	int i;
>
>  	pcp_map = &qos.pcp.map;
> @@ -53,6 +116,12 @@ static int sparx5_dcb_app_update(struct net_device *dev)
>  		pcp_map->map[i] = dcb_getapp(dev, &app_itr);
>  	}
>
> +	/* Enable use of pcp for queue classification ? */
> +	if (sparx5_dcb_apptrust_contains(portno, DCB_APP_SEL_PCP)) {
> +		qos.pcp.qos_enable = true;
> +		qos.pcp.dp_enable = qos.pcp.qos_enable;
> +	}
> +
>  	return sparx5_port_qos_set(port, &qos);
>  }
>
> @@ -95,7 +164,54 @@ static int sparx5_dcb_ieee_delapp(struct net_device *dev, struct dcb_app *app)
>  	return sparx5_dcb_app_update(dev);
>  }
>
> +static int sparx5_dcb_setapptrust(struct net_device *dev, u8 *selectors,
> +				  int nselectors)
> +{
> +	struct sparx5_port *port = netdev_priv(dev);
> +	int err = 0, idx;
> +
> +	idx = sparx5_dcb_apptrust_validate(dev, selectors, nselectors, &err);
> +	if (err < 0)
> +		return err;
> +
> +	apptrust[port->portno] = &apptrust_conf[idx];
> +
> +	return sparx5_dcb_app_update(dev);
> +}
> +
> +static int sparx5_dcb_getapptrust(struct net_device *dev, u8 *selectors,
> +				  int *nselectors)
> +{
> +	struct sparx5_port *port = netdev_priv(dev);
> +	const struct sparx5_dcb_apptrust *trust;
> +
> +	trust = apptrust[port->portno];
> +
> +	memcpy(selectors, trust->selectors, trust->nselectors);
> +	*nselectors = trust->nselectors;
> +
> +	return 0;
> +}
> +
> +int sparx5_dcb_init(struct sparx5 *sparx5)
> +{
> +	struct sparx5_port *port;
> +	int i;
> +
> +	for (i = 0; i < SPX5_PORTS; i++) {
> +		port = sparx5->ports[i];
> +		if (!port)
> +			continue;
> +		/* Initialize [dscp, pcp] default trust */
> +		apptrust[port->portno] = &apptrust_conf[3];
> +	}
> +
> +	return sparx5_dcb_app_update(port->ndev);
> +}
> +
>  const struct dcbnl_rtnl_ops sparx5_dcbnl_ops = {
>  	.ieee_setapp = sparx5_dcb_ieee_setapp,
>  	.ieee_delapp = sparx5_dcb_ieee_delapp,
> +	.dcbnl_setapptrust = sparx5_dcb_setapptrust,
> +	.dcbnl_getapptrust = sparx5_dcb_getapptrust,
>  };
> diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
> index 0d8e04c64584..d07ef2e8b321 100644
> --- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
> +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
> @@ -357,6 +357,9 @@ int sparx5_config_dsm_calendar(struct sparx5 *sparx5);
>  void sparx5_get_stats64(struct net_device *ndev, struct rtnl_link_stats64 *stats);
>  int sparx_stats_init(struct sparx5 *sparx5);
>
> +/* sparx5_dcb.c */
> +int sparx5_dcb_init(struct sparx5 *sparx5);
> +
>  /* sparx5_netdev.c */
>  void sparx5_set_port_ifh_timestamp(void *ifh_hdr, u64 timestamp);
>  void sparx5_set_port_ifh_rew_op(void *ifh_hdr, u32 rew_op);
> diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_port.c b/drivers/net/ethernet/microchip/sparx5/sparx5_port.c
> index 9ffaaf34d196..99e86e87aa16 100644
> --- a/drivers/net/ethernet/microchip/sparx5/sparx5_port.c
> +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_port.c
> @@ -1163,8 +1163,8 @@ int sparx5_port_qos_pcp_set(const struct sparx5_port *port,
>  	int i;
>
>  	/* Enable/disable pcp and dp for qos classification. */
> -	spx5_rmw(ANA_CL_QOS_CFG_PCP_DEI_QOS_ENA_SET(1) |
> -		 ANA_CL_QOS_CFG_PCP_DEI_DP_ENA_SET(1),
> +	spx5_rmw(ANA_CL_QOS_CFG_PCP_DEI_QOS_ENA_SET(qos->qos_enable) |
> +		 ANA_CL_QOS_CFG_PCP_DEI_DP_ENA_SET(qos->dp_enable),
>  		 ANA_CL_QOS_CFG_PCP_DEI_QOS_ENA | ANA_CL_QOS_CFG_PCP_DEI_DP_ENA,
>  		 sparx5, ANA_CL_QOS_CFG(port->portno));
>
> diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_port.h b/drivers/net/ethernet/microchip/sparx5/sparx5_port.h
> index 9c5fb6b651db..fae9f5464548 100644
> --- a/drivers/net/ethernet/microchip/sparx5/sparx5_port.h
> +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_port.h
> @@ -97,6 +97,8 @@ struct sparx5_port_qos_pcp_map {
>
>  struct sparx5_port_qos_pcp {
>  	struct sparx5_port_qos_pcp_map map;
> +	bool qos_enable;
> +	bool dp_enable;
>  };
>
>  struct sparx5_port_qos {
> diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_qos.c b/drivers/net/ethernet/microchip/sparx5/sparx5_qos.c
> index 1e79d0ef0cb8..379e540e5e6a 100644
> --- a/drivers/net/ethernet/microchip/sparx5/sparx5_qos.c
> +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_qos.c
> @@ -389,6 +389,10 @@ int sparx5_qos_init(struct sparx5 *sparx5)
>  	if (ret < 0)
>  		return ret;
>
> +	ret = sparx5_dcb_init(sparx5);
> +	if (ret < 0)
> +		return ret;
> +
>  	return 0;
>  }


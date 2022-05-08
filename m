Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6CC51EC25
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 10:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbiEHINH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 04:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230270AbiEHIND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 04:13:03 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2067.outbound.protection.outlook.com [40.107.93.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BAB9E038
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 01:09:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I4pxVWJnIomWg5O40b6Fmq4jjrrNXCLzy2qohUnXhRqbFzYR9AzjQl2NLDbwzNJe9QSUlfnqIpR6ZSoO4ZPnjNdr1LQGfClPQhpE1hFb9E60o+rl8ZaTL4DOW7FXQZb8nJo/+Zph/B/CTNhsOJgJvbWreerjGPBEovalSUEkUzh+WpUKCq0s6YidKCcaDxqGnKX07AhIWZHwC37psKsWzu2rsHlgko0hxsf2d2FL8Pfcm8K9OpFHfmvqvs3JrvAjv+NUQRKWbgpfH0ubiYXSkg9BcJqi7pUtqfMBwjSa5XDugBBCmLOZ9mD5mxmmFeNwVMJFzcioFh8WH80hm4z0Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3QjlM0W0NWk2ULhVqy0rfNqCAbLRcu65WcJz9Mn+DA8=;
 b=FiJH8gGIPbLomE8VP28PuAh6JWIh/hpAh7iCmSaAB8pIFRMAIkHTgOdaUNAgfDsbb0215TisIzR/uLdh7iMtvJ4L93GhA//TRUdjwuPfjqt7Y554E5311mvjDA/7qst8X1q8kqCVbVFCLHGzh/rgeO+2JieeSZp6+xAErz/S1pUo6DqPNOkhAekjGpi/RSpF4uWRj221IYjS+qc62L6Ri8Z/YfaqEqGrLKp/g2Gxbqo1A8zS4w2Mjt9zjMXcL4faTgAlbo8pkPA7UOxj0twS8rLr8b+Sz2Vx0GyRmgR8RT6wWFLreDk+NalrUOlQV4iauAUqJ/7tivNlSssmf7nvoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3QjlM0W0NWk2ULhVqy0rfNqCAbLRcu65WcJz9Mn+DA8=;
 b=DMPv0he2YKDVRLl3uUky8u91zJn2KzjTz+0daSZeuNBhfkoQ0saIk9X13t/iVPrg9krzYIDFHBlKbhrJHrsexzRGdwbh+gIhKB0gd59RjHXPM2AyY1jutbpavhfi1+485UOTJrSx9NB7b7HnmU4wzW89dFV+cYoxeYvLHoIXtT4FB/sBnUsxSLdscXyiq2OAwRCjtB+iMmrAVMh8mHAcFi6E77zSUJOR/Ru7055Go5HxJPy+/WxEzBsmmhcc3kp3H1/QmkBW+wRTE5U8x4NuHXAYCM7iozRcNIX5pumooPSNBYTks53Dzh/Megdk6dGYDKkZD3FM1byMc3CQa4OUDw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DS7PR12MB6096.namprd12.prod.outlook.com (2603:10b6:8:9b::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5227.22; Sun, 8 May 2022 08:09:13 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331%7]) with mapi id 15.20.5227.023; Sun, 8 May 2022
 08:09:13 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 04/10] mlxsw: spectrum: Move handling of HW stats events to router code
Date:   Sun,  8 May 2022 11:08:17 +0300
Message-Id: <20220508080823.32154-5-idosch@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220508080823.32154-1-idosch@nvidia.com>
References: <20220508080823.32154-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR2P264CA0105.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:33::21) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf640daf-33e2-4b86-66fc-08da30ca0995
X-MS-TrafficTypeDiagnostic: DS7PR12MB6096:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB6096E6403B3C51A8E29E9221B2C79@DS7PR12MB6096.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JpoIIeEuOmFKNJUb00ZlhvAzXziqw+0nrRYCO0eII7BgfNsgZ42ZqYmKSOb8ujCEEggNU8pgwPcyKVU4kmPF024FrPygJyn4e9pgdnMk+Wy2ZaGo6+iw2m3ltFEMBDDCYO30eIB5UrMdLn2ev+O8Ov5XWFM+T9W7Y2ccIbQfUanwJz1yyEvg2pVMnSoLy0RDhHvhHbIBx/SWAy91GkWEyxQkrHTcKmP6UKJGcKVjCvVbD29SoLN/99Eik6/z7oI6XBaToNRO4cql5UxHlE+tp3Cb0+r2OZAdjYePdpa1CwGXGz3n+BoWh8xa7fYXtOpxDyL8npYwuVcz/I2f2+4izPZCLpO7UpieJzNXJcdHcrWu3F439TYhGvvgkTTth1GqrGcyDvAeg4yGY9DwHBhJ5gbt4DVyRj+kfcj8S3g0bvGcEZ8HDT3UDBpfJMEfM5+JOI+WRtC+uQjoUHPFaQtyvwm89ywUScNjSzk0rR62U4gEh2HshE3in/0rtje+89DQTYccNTp2tYDUaqEe7zD4Y7HFm4wLfwXlatHamwnTMf6TDDWNre9bD2+D14HFBnmQSc2vVHS76vJsLRHW1+Ez/0OkvzAmdHP9FAS3Ja/42dWvV2nTmKI8I8CC3X2SH5htByZlz1rA7qrM9n4dKcle8w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(6916009)(2616005)(36756003)(316002)(83380400001)(66574015)(186003)(107886003)(8936002)(86362001)(4326008)(26005)(66476007)(66556008)(6512007)(8676002)(66946007)(38100700002)(508600001)(2906002)(6486002)(5660300002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z2zm3a6PqYVPB3q0CzA8xETLmgM+B5KgbayUDH/YuDNh1GUK7zuK5kgzj3PB?=
 =?us-ascii?Q?p3/LkHs86cmCKlkg6WOt0CEqUlgymPhF+8FdX2/EW+c6w71dmQaCk1WoDIry?=
 =?us-ascii?Q?BxWhYsWVG7ER4NjhLd0spCO+wGtLXpJWwcKZh9xf8hWj3TY4Wj+f110sqVtE?=
 =?us-ascii?Q?rTYXf7McW/pDXnte/yP8kG7aIln1CjPhrLWs7bKqwoKqt5YZaJILKjd9Y07H?=
 =?us-ascii?Q?h2UjVtAVZSAry0hlOcOuwgKgzkW+NuAoGN0bEssvocaoK4pXYv2cSUI7CmL0?=
 =?us-ascii?Q?NObAQFBBg3qPoPFRW/XMCzHzSkGbDptAe02HK7nJNjZ1pYm5BB8qW8JuzsET?=
 =?us-ascii?Q?FmjFABQdGaSWy+XWXFJ2aKM+pxMihioKrnnqxC6Khb4Xy0/7PCSD1VLdwgws?=
 =?us-ascii?Q?DYN1hJ6dH3J8e0Is8na3AUMlTdjqy8opz8slmvfdML/uqwcs2Oufl7YsoMaS?=
 =?us-ascii?Q?uR81+Ps0LqoS44OwlDI84xLxUKygG0i9wjOoW9A+YBshZfbTA45XEM7yhykQ?=
 =?us-ascii?Q?N27wDmXREdj3MQFbs23OGEYhK6M/ps8qh2gB8lnY3XWOWpYKlFOH+6/HBIVv?=
 =?us-ascii?Q?VTnusJMS/5jpBsugkEcwolZSqfBon7srGa9gPLi7+0e1pwb4v0ClqSutnMkK?=
 =?us-ascii?Q?l0Ma+oZeWIr3vY8XSvvxOlugZBsSLkOxqWnqjN5/PguQCvtUNaIsf9Pztkv9?=
 =?us-ascii?Q?Qdpeny/qaHhJTCBSdg9NVr8xCdnQcQKIQT0Um9+NovGDuvLCcT4xL2oWytNs?=
 =?us-ascii?Q?JzbvpZeVCQTXJVIvUng/ePJzKsGxKSl8jYrhL/FUROAapz+4bQ4CDW1mSQkB?=
 =?us-ascii?Q?pL5yTSJrmVij07X2zN1wA1+01lvIypyLQJh7PjIO6Lxqn/yUXS+wfCuH/x1j?=
 =?us-ascii?Q?hggPk7Ol4Hc8j/J6uTiZXo4nq876dBcyOWk3BWX7LUwNqOeYu+CaXs4rBSKu?=
 =?us-ascii?Q?iVCdJqrh/p877mwHKUQLZ3av5IySJr2rj5XKZrlpYr/a4rSSk0clP08vyFZo?=
 =?us-ascii?Q?TQXzWzHAxsP0kWHSdgBejV2hbVB1vA3IdZLi31fUsdxwY0pT6/Osvtksb+aU?=
 =?us-ascii?Q?Pouq5aanzyaPu0W93tk/skCDgrgFVH1kpocbnKSt+zqWb8SCmlA5y2+w/TUw?=
 =?us-ascii?Q?XKxaXf83eZt/4lnRCyjXexCAl20MPyVSvksmp3R0RuJR9EHoQABCfjZ0s4BX?=
 =?us-ascii?Q?at0uWOY0OczHKLqRXng3t3qDi3SrY5z+qSmBHiLNeu/ERflACJs41pCmqm3T?=
 =?us-ascii?Q?7BCDCgteRDYhaO9g9PsHnX7muhkdf45sloOwzg48cqu2Y8TFs58GptlWUxOm?=
 =?us-ascii?Q?enpvCNqwjDcJ6ToTzKpyZcVhlfLYMSzViSMCSRkJI0SBKLRMu5EcUm4Sj/6x?=
 =?us-ascii?Q?D8WcsbCx4mJ1onaGZT7Lj0UVHmjOqYxsHuNXdDokmzmJdmxqEibdftyIaiH+?=
 =?us-ascii?Q?w3go54Kk/tuMfhbI47RvOcTTuG47oWVQOWPRzMegXIhbTWO1q7L4xIcpOIrl?=
 =?us-ascii?Q?3tRTvFC+zNxdiZ8/+lskGkox35sXd8Syij962yDPgoZLZvpDJl0fDtPZUbKF?=
 =?us-ascii?Q?erv802i09QYVKNQC1RO2pvvHwVn3TVHcg5T32XXnyg78JKVza2B4p584I3Ji?=
 =?us-ascii?Q?wn9kpQ7ahQ6yf8oMLLABFzYTAVsAI5p6mtSqJSg2Ray0+bhQEYGPjgNu6oCu?=
 =?us-ascii?Q?TfFKzJmMg5UPEgwgSMlqpL6FfBOrTJVJNix8oQ0NSwuLHJ84T8lOQBQRJsec?=
 =?us-ascii?Q?izq0PRuNTA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf640daf-33e2-4b86-66fc-08da30ca0995
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 08:09:12.9909
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +U+rSw4gLDZNEDbruXoO39aIjee/dmAVY7iVb48js58bG9AKX4rzOojsBlJT0mWX/OM6zFgaNrb+NkVX28NlrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6096
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

L3 HW stats are implemented in mlxsw as RIF counters, and therefore the
code resides in spectrum_router. Exclude the offload xstats events from the
mlxsw_sp_netdevice_event_is_router() predicate, and instead recreate the
glue code in the router module.

Previously, the order of dispatch was that for events on tunnels, a
dedicated handler was called, which however did not handle HW stats events.
But there is nothing special about tunnel devices as far as HW stats: there
is a RIF associated with the tunnel netdevice, and that RIF is where the
counter should be installed. Therefore now, HW stats events are tested
first, independent of netdevice type. The upshot is that as of this commit,
mlxsw supports L3 HW stats work on GRE tunnels.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  4 --
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 47 ++++++++++++++++---
 2 files changed, 40 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 867c1f3810e6..367b9b6e040a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -5010,10 +5010,6 @@ static bool mlxsw_sp_netdevice_event_is_router(unsigned long event)
 	case NETDEV_PRE_CHANGEADDR:
 	case NETDEV_CHANGEADDR:
 	case NETDEV_CHANGEMTU:
-	case NETDEV_OFFLOAD_XSTATS_ENABLE:
-	case NETDEV_OFFLOAD_XSTATS_DISABLE:
-	case NETDEV_OFFLOAD_XSTATS_REPORT_USED:
-	case NETDEV_OFFLOAD_XSTATS_REPORT_DELTA:
 		return true;
 	default:
 		return false;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index fa4d9bf7da75..01f10200aeaa 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -9378,6 +9378,19 @@ static int mlxsw_sp_router_port_pre_changeaddr_event(struct mlxsw_sp_rif *rif,
 	return -ENOBUFS;
 }
 
+static bool mlxsw_sp_is_offload_xstats_event(unsigned long event)
+{
+	switch (event) {
+	case NETDEV_OFFLOAD_XSTATS_ENABLE:
+	case NETDEV_OFFLOAD_XSTATS_DISABLE:
+	case NETDEV_OFFLOAD_XSTATS_REPORT_USED:
+	case NETDEV_OFFLOAD_XSTATS_REPORT_DELTA:
+		return true;
+	}
+
+	return false;
+}
+
 static int
 mlxsw_sp_router_port_offload_xstats_cmd(struct mlxsw_sp_rif *rif,
 					unsigned long event,
@@ -9407,6 +9420,24 @@ mlxsw_sp_router_port_offload_xstats_cmd(struct mlxsw_sp_rif *rif,
 	return 0;
 }
 
+static int
+mlxsw_sp_netdevice_offload_xstats_cmd(struct mlxsw_sp *mlxsw_sp,
+				      struct net_device *dev,
+				      unsigned long event,
+				      struct netdev_notifier_offload_xstats_info *info)
+{
+	struct mlxsw_sp_rif *rif;
+	int err = 0;
+
+	mutex_lock(&mlxsw_sp->router->lock);
+	rif = mlxsw_sp_rif_find_by_dev(mlxsw_sp, dev);
+	if (rif)
+		err = mlxsw_sp_router_port_offload_xstats_cmd(rif, event, info);
+	mutex_unlock(&mlxsw_sp->router->lock);
+
+	return err;
+}
+
 int mlxsw_sp_netdevice_router_port_event(struct net_device *dev,
 					 unsigned long event, void *ptr)
 {
@@ -9432,12 +9463,6 @@ int mlxsw_sp_netdevice_router_port_event(struct net_device *dev,
 	case NETDEV_PRE_CHANGEADDR:
 		err = mlxsw_sp_router_port_pre_changeaddr_event(rif, ptr);
 		break;
-	case NETDEV_OFFLOAD_XSTATS_ENABLE:
-	case NETDEV_OFFLOAD_XSTATS_DISABLE:
-	case NETDEV_OFFLOAD_XSTATS_REPORT_USED:
-	case NETDEV_OFFLOAD_XSTATS_REPORT_DELTA:
-		err = mlxsw_sp_router_port_offload_xstats_cmd(rif, event, ptr);
-		break;
 	default:
 		WARN_ON_ONCE(1);
 		break;
@@ -9522,9 +9547,17 @@ static int mlxsw_sp_router_netdevice_event(struct notifier_block *nb,
 					   unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	struct mlxsw_sp_router *router;
+	struct mlxsw_sp *mlxsw_sp;
 	int err = 0;
 
-	if (mlxsw_sp_is_vrf_event(event, ptr))
+	router = container_of(nb, struct mlxsw_sp_router, netdevice_nb);
+	mlxsw_sp = router->mlxsw_sp;
+
+	if (mlxsw_sp_is_offload_xstats_event(event))
+		err = mlxsw_sp_netdevice_offload_xstats_cmd(mlxsw_sp, dev,
+							    event, ptr);
+	else if (mlxsw_sp_is_vrf_event(event, ptr))
 		err = mlxsw_sp_netdevice_vrf_event(dev, event, ptr);
 
 	return notifier_from_errno(err);
-- 
2.35.1


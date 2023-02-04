Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE3768AA5F
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 14:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233863AbjBDNxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 08:53:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233777AbjBDNxe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 08:53:34 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2077.outbound.protection.outlook.com [40.107.20.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3162C1A4BE
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 05:53:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eowhFb3sRCJ7nYgaAgOsg+1PzufpaMEfMvL3qh9vaF6q4em3ddMUGhTkICNRAiKBjROjZmV+F1EUYu/FhIxloOnZleT96NQz1eCIGXWXStf3OqdKSSVq7XHvmOxMFNnD50C5PTCtGmn0agXaZtssujI81IUYa6aZrdB95axF3Hrq3F2nmLjliysRcNsx0YCVBekVjMlPoEnUa6mGRiTKCtOZlUHGzfpPT8HRc8bgZhLmk9nrv/zp1U/ou0svMcemBGR+j8xaToiHPS+/Tq0OrYluBw3HzT6sPDchYyRbKIhrDdCSnIw+hPqaSKav8SRj8tz91udHcc0yscmcigrkmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1K/OcOJj0xS+OemUsGdbff6O7KyYYXNi2+x1OFms8Kc=;
 b=I2NUAm8lOQCBD4pLdND89tvhJ1LIa0pAvnHaxSQMlZGsjq3NSF4qWTRRjlmbxeW/QOLwGkfgSF8PJzrs+S13xyoueKxQbQTCVcQmrn3FKhk15YTUuBPBz8AZL77e07mAu+g6tnd4szOKlbjwaMxJTEFcZ3xDOQf4uEf6uaooNVc4z3i40YT79JS6vgNO/MJh3GbZIrwkNk81sdJwHh0bA0gi0eq1lv4OigGdfImNbFfCA0bfthMGSA9stytrLO42YRQiO/kQ0z/Ydi4bQhUhvdLiDBZ8G5bxo7/L2oG7MHcmkOnG/Uy6GpvYuWxRq6YOXpbK0ugJHYLRB3L5TyXHLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1K/OcOJj0xS+OemUsGdbff6O7KyYYXNi2+x1OFms8Kc=;
 b=pxBAfuEZNLgyYKqPREaispQXSBvJdtxbZvimRe5e9NSXL4a1dk0Q+36u5JLoKtccntypW5tQymnz8WAHtj1j1L6GH7kuVjsHw6Qz8eaLZ0iQ2ETvCpvYLiSSE7G/KOL1PGlk8BHQBpW8Ehgr5lYRTEiU+Fn45XSZACd+FVqESwI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8783.eurprd04.prod.outlook.com (2603:10a6:102:20e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Sat, 4 Feb
 2023 13:53:29 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6064.032; Sat, 4 Feb 2023
 13:53:29 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Simon Horman <simon.horman@corigine.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Daniel Machon <daniel.machon@microchip.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v6 net-next 03/13] net/sched: move struct tc_mqprio_qopt_offload from pkt_cls.h to pkt_sched.h
Date:   Sat,  4 Feb 2023 15:52:57 +0200
Message-Id: <20230204135307.1036988-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230204135307.1036988-1-vladimir.oltean@nxp.com>
References: <20230204135307.1036988-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0141.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7c::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB8783:EE_
X-MS-Office365-Filtering-Correlation-Id: 0af186ef-21da-4435-c1bf-08db06b73237
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ud67RPKI8rk6WBAbzh8xiYMQidGmLQiKL4jR9VJAyEgdfwgpy8K8xBvuS0tY1QTB7MvaKNL+2O+VMJefVoB19HlFEKiQzNPLChS24lxwWFiu62Q/LHHijBZs5cpN0MH5GxLUSpQtvqlveJxJHGJ5mkn9IYAQ24pyjFVjsaV6DXWObeCsSbGAhpeckE3TqSuMBSyaXpX4Yo3ifjuWiy3bqJZqhGZ+cabw/eEtwafC0ZOFPMAKDFqWZAlF5VbvTuD30cOYOvRCVxN2MS0zto3sKQRT0CvReWXu8ZHn2rY4fweVyVdiRQq//RIHwZWtl198Uf8SRda1G0Ch49Gy2CI0jhoxn9x5pQyx0Na7665NUd6xQMTxRjrssdwCtWd+5ICqWtXz0llv7teL5ywkUkWDEcTodKWcrSMlQcw0ioZSxaQo/5/fGQ9uwmy4VO4nXyaTWqKpd5CZ6myLTUEaGQbokM64dBuKQyFm13JIJkqYnhLyShkmHO8vtWw6VVDgI4+3MMTL5BRchblVg4CbX87IAb9tPlX2RoRsXM0fy5nOgg8upp9SGfdN+KG/WFf6xAk8KlttfO4Dy/0UImXsbpqxuXZNUuFsYAVzV8/pbnne5njA3DVmaHkMgDKqn20xhB586xN5ivM+r09zaOxHFBcCoyS22oCNbiVuHEtaSn7bECVyndMVjr2SdNKD0aIqemyI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(136003)(396003)(376002)(366004)(451199018)(478600001)(6486002)(2906002)(52116002)(26005)(6512007)(186003)(66476007)(66946007)(6666004)(6506007)(1076003)(41300700001)(8676002)(8936002)(6916009)(66556008)(4326008)(44832011)(7416002)(316002)(5660300002)(54906003)(38100700002)(38350700002)(86362001)(36756003)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?j9V9lkNRi/Uig7ma8mvNpqVqfkK9/e9zbECjw6c7DSafKy0rpXZNHVg0ms1A?=
 =?us-ascii?Q?H7cATaTTlyRvl0ngFtNtFjKuF4fZKxEPVOtx94Q2o63qs0qZfiRX28R6+t85?=
 =?us-ascii?Q?JMnKI5mODyOUa0YwezDprE42XHu+4gTILlWTdqvASdDoOo1nlP16x/wanXYH?=
 =?us-ascii?Q?bKyX2/PAXQt4W0hOUgrCkr4bjvlYswh6gxrzx3+93r23C0uu4pqQSjjEUXbX?=
 =?us-ascii?Q?W4RPnCGp3MpXHOhkEs9XKQuqWbQDxpwi39X8H5KeiZ4NCJfQWL1qF1bMuxkX?=
 =?us-ascii?Q?fJqZtboyqKKyumbJZSTdHE5460uDjh+uHJflerJ9DFNu7aExBWAVhopMpKTi?=
 =?us-ascii?Q?hm5k5X94DeeNV4M51tTQcJLGo51wXjyAej7EXxNG6Kz+74NSkpyf7NZ90Bks?=
 =?us-ascii?Q?VRBari+VSM8MlJgmlPiHY0mII6PDysnTk9bq7AN+YjzKVSgyz+0frOeDJYpd?=
 =?us-ascii?Q?XNCw/BNK+BY3LOIzSykyaFwh9DcyBgj7HAjKsTtPC2UGbV1BAv7LOk0LjIWg?=
 =?us-ascii?Q?CLM7Bu4gwEUW9n0C67DnPbITz/Gdrc5cKmGGL5uy49V5+ttFxjcmSBSj2vDI?=
 =?us-ascii?Q?ScP46I/2W6cjZq83VyROb3E/pDO47+MfGW3XKNEYMyT8wJtE+bJtqGQhra+Z?=
 =?us-ascii?Q?xocFNUN+/Mz9SOW9nEe9/GrJVIV8jlyzK4VggvkMzf4gRd5W7/1HOY9KBieZ?=
 =?us-ascii?Q?nu0XNigwfNZnSrAETBsZ+IT9W5/xT/K9IfWlDBrqtnW0VKb869Vz/q8jJKLT?=
 =?us-ascii?Q?8CFud35ammDXhhVKZb8VPvAAeo4+PJKYAYKeJr2RUnN/VQLSS9Ps4SRbZ3Ol?=
 =?us-ascii?Q?Yycv0HQz83Li2dpYW2jGOORE9Ff3X+fb5hMLJ7eyt2ZnY52tFeXhkaekldfz?=
 =?us-ascii?Q?SwfbekQzd3xETIsSTM2SB3pIlmUWDw4WI62K/iO/34PyXhUd61zkBirEJMXF?=
 =?us-ascii?Q?qbMx1pid9L8DdAzbBIUdE7VN5Gr251+8bCtOOGuz/vQnrGHVHX8crrTRp0De?=
 =?us-ascii?Q?IIEDwUmwNku4KrWKlEBDie0z8L0XXoFgVR/VlopMaPgoocZDLPCXNPty5pzw?=
 =?us-ascii?Q?tbbiVHj+2PVUZJcfr6md7ZJl0YvpZJuEzfXZg66os+3w3nX5aUlFZl7a1jt4?=
 =?us-ascii?Q?Anh+Ll03cfSYB+zfyGXEfHHKgTiAM6C4Au3sorveo55cjvls7qTzkHt6g+rg?=
 =?us-ascii?Q?7wp/K3RAMwy31iSH8SifvPmj/QXIs8svbWlNBi8ZXmvD/6KXtMx08+hQSvk4?=
 =?us-ascii?Q?f0pLZOl1C4Xkk5TQtx7E6CGCAv0C/XaVaLQbrb7XLwQ/MuF9/a/2U5HnMieP?=
 =?us-ascii?Q?rS5rXEx/7qrgVn7jpMn7jXxQ9JFtl44VRLY2z11GD69EnZiHJVtCqh16w9V2?=
 =?us-ascii?Q?Z0nknWvMZ5nE7+wCRFx/UvlRFktqLF56MxIl6ai0+v6CyoqbEApoFdhPZ8r0?=
 =?us-ascii?Q?0i5j14XFpJlgHRX6CH/tCluJoI5xEHRlmCWX3P3ghtA/i+0nPCA0PI+vlQSg?=
 =?us-ascii?Q?FKZD3HsUr3mesjL2rHcNxqLSVB3CFW536CY9hwrMoEvWYg82T/87nGicpHW8?=
 =?us-ascii?Q?5ISGXrSNY+caI83fucJ+D3UaODiW8ABONtMx9okXvyE6KPz3FE5pWwp7M5YP?=
 =?us-ascii?Q?cQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0af186ef-21da-4435-c1bf-08db06b73237
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 13:53:29.7009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wyWRsmoukipMDoUv0JjD6COqlaGdB+t+itO8wcmMc3u99hxHi/g7MuB0TU4609YBoIXtLsFExdW6SjUzl4m4iA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8783
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since mqprio is a scheduler and not a classifier, move its offload
structure to pkt_sched.h, where struct tc_taprio_qopt_offload also lies.

Also update some header inclusions in drivers that access this
structure, to the best of my abilities.

Cc: Igor Russkikh <irusskikh@marvell.com>
Cc: Yisen Zhuang <yisen.zhuang@huawei.com>
Cc: Salil Mehta <salil.mehta@huawei.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Horatiu Vultur <horatiu.vultur@microchip.com>
Cc: Lars Povlsen <lars.povlsen@microchip.com>
Cc: Steen Hegelund <Steen.Hegelund@microchip.com>
Cc: Daniel Machon <daniel.machon@microchip.com>
Cc: UNGLinuxDriver@microchip.com
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
v4->v6: none
v3->v4: shouldn't have removed "#include <net/pkt_sched.h>" from ti cpsw
v2->v3: none
v1->v2:
- update some header inclusions in drivers
- fix typo (said "taprio" instead of "mqprio")

 drivers/net/ethernet/aquantia/atlantic/aq_main.c     |  1 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.h |  2 +-
 drivers/net/ethernet/hisilicon/hns3/hnae3.h          |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c      |  1 +
 drivers/net/ethernet/intel/i40e/i40e.h               |  1 +
 drivers/net/ethernet/intel/iavf/iavf.h               |  1 +
 drivers/net/ethernet/intel/ice/ice.h                 |  1 +
 drivers/net/ethernet/marvell/mvneta.c                |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c    |  1 +
 drivers/net/ethernet/microchip/lan966x/lan966x_tc.c  |  1 +
 drivers/net/ethernet/microchip/sparx5/sparx5_tc.c    |  1 +
 drivers/net/ethernet/ti/cpsw_priv.c                  |  1 +
 include/net/pkt_cls.h                                | 10 ----------
 include/net/pkt_sched.h                              | 10 ++++++++++
 14 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
index 77609dc0a08d..0b2a52199914 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -21,6 +21,7 @@
 #include <linux/ip.h>
 #include <linux/udp.h>
 #include <net/pkt_cls.h>
+#include <net/pkt_sched.h>
 #include <linux/filter.h>
 
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.h
index be96f1dc0372..d4a862a9fd7d 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.h
@@ -4,7 +4,7 @@
 #ifndef __CXGB4_TC_MQPRIO_H__
 #define __CXGB4_TC_MQPRIO_H__
 
-#include <net/pkt_cls.h>
+#include <net/pkt_sched.h>
 
 #define CXGB4_EOSW_TXQ_DEFAULT_DESC_NUM 128
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 17137de9338c..40f4306449eb 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -32,6 +32,7 @@
 #include <linux/pkt_sched.h>
 #include <linux/types.h>
 #include <net/pkt_cls.h>
+#include <net/pkt_sched.h>
 
 #define HNAE3_MOD_VERSION "1.0"
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index b4c4fb873568..25be7f8ac7cd 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -20,6 +20,7 @@
 #include <net/gro.h>
 #include <net/ip6_checksum.h>
 #include <net/pkt_cls.h>
+#include <net/pkt_sched.h>
 #include <net/tcp.h>
 #include <net/vxlan.h>
 #include <net/geneve.h>
diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 60e351665c70..38c341b9f368 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -33,6 +33,7 @@
 #include <linux/net_tstamp.h>
 #include <linux/ptp_clock_kernel.h>
 #include <net/pkt_cls.h>
+#include <net/pkt_sched.h>
 #include <net/tc_act/tc_gact.h>
 #include <net/tc_act/tc_mirred.h>
 #include <net/udp_tunnel.h>
diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index 23bc000e77b8..232bc61d9eee 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -30,6 +30,7 @@
 #include <linux/jiffies.h>
 #include <net/ip6_checksum.h>
 #include <net/pkt_cls.h>
+#include <net/pkt_sched.h>
 #include <net/udp.h>
 #include <net/tc_act/tc_gact.h>
 #include <net/tc_act/tc_mirred.h>
diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 3d26ff4122e0..d684f2a8626d 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -41,6 +41,7 @@
 #include <linux/dim.h>
 #include <linux/gnss.h>
 #include <net/pkt_cls.h>
+#include <net/pkt_sched.h>
 #include <net/tc_act/tc_mirred.h>
 #include <net/tc_act/tc_gact.h>
 #include <net/ip.h>
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index f8925cac61e4..a48588c80317 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -38,7 +38,7 @@
 #include <net/ipv6.h>
 #include <net/tso.h>
 #include <net/page_pool.h>
-#include <net/pkt_cls.h>
+#include <net/pkt_sched.h>
 #include <linux/bpf_trace.h>
 
 /* Registers */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 0e87432ec6f1..7de21a1ef009 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -39,6 +39,7 @@
 #include <linux/if_bridge.h>
 #include <linux/filter.h>
 #include <net/page_pool.h>
+#include <net/pkt_sched.h>
 #include <net/xdp_sock_drv.h>
 #include "eswitch.h"
 #include "en.h"
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_tc.c b/drivers/net/ethernet/microchip/lan966x/lan966x_tc.c
index 80625ba0b354..cf0cc7562d04 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_tc.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_tc.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0+
 
 #include <net/pkt_cls.h>
+#include <net/pkt_sched.h>
 
 #include "lan966x_main.h"
 
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_tc.c b/drivers/net/ethernet/microchip/sparx5/sparx5_tc.c
index 205246b5af82..e80f3166db7d 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_tc.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc.c
@@ -5,6 +5,7 @@
  */
 
 #include <net/pkt_cls.h>
+#include <net/pkt_sched.h>
 
 #include "sparx5_tc.h"
 #include "sparx5_main.h"
diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/cpsw_priv.c
index 758295c898ac..e966dd47e2db 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.c
+++ b/drivers/net/ethernet/ti/cpsw_priv.c
@@ -20,6 +20,7 @@
 #include <linux/skbuff.h>
 #include <net/page_pool.h>
 #include <net/pkt_cls.h>
+#include <net/pkt_sched.h>
 
 #include "cpsw.h"
 #include "cpts.h"
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 4cabb32a2ad9..cd410a87517b 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -788,16 +788,6 @@ struct tc_cls_bpf_offload {
 	bool exts_integrated;
 };
 
-struct tc_mqprio_qopt_offload {
-	/* struct tc_mqprio_qopt must always be the first element */
-	struct tc_mqprio_qopt qopt;
-	u16 mode;
-	u16 shaper;
-	u32 flags;
-	u64 min_rate[TC_QOPT_MAX_QUEUE];
-	u64 max_rate[TC_QOPT_MAX_QUEUE];
-};
-
 /* This structure holds cookie structure that is passed from user
  * to the kernel for actions and classifiers
  */
diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 38207873eda6..6c5e64e0a0bb 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -160,6 +160,16 @@ struct tc_etf_qopt_offload {
 	s32 queue;
 };
 
+struct tc_mqprio_qopt_offload {
+	/* struct tc_mqprio_qopt must always be the first element */
+	struct tc_mqprio_qopt qopt;
+	u16 mode;
+	u16 shaper;
+	u32 flags;
+	u64 min_rate[TC_QOPT_MAX_QUEUE];
+	u64 max_rate[TC_QOPT_MAX_QUEUE];
+};
+
 struct tc_taprio_caps {
 	bool supports_queue_max_sdu:1;
 };
-- 
2.34.1


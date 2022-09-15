Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07DD35BA078
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 19:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiIORia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 13:38:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiIORi3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 13:38:29 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60065.outbound.protection.outlook.com [40.107.6.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A3959108C;
        Thu, 15 Sep 2022 10:38:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jfsZk7h16tobzI5ghxCOCh0vDAPJcbnrGkvzOyJ9nTDV+mwWMXBIjApeQ/jp9cfiBOulw7NnizrU9jzLYbNh02y51JjgegPopsdkU4hM2ibXfUY/+apWclH8s+xgwF28py9E/ReXkpeOXCQAZooUIsGQDJyBSiHXLqnlM3wPSdpIvi9IlqzWnBF9Y1adUHRwy6NKvUvFJPXJsBdzEzH8WdTSBuijldLAPpMHjiSq5YI8TXNCzaUiDkUL09xiMmTY4Eta1mZ4IEZA+ddufUDFFK8Ge6ZVGzkSaannrtwr3hnIxrap/1fooxHgxbkDzYrDFfSK09vR8L1XQhnQAwtyaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Yt7bxEquUJIO7w7aaWVnktjJHrHCMnp6mC6IKssfbg=;
 b=RcZd6GK3H7IYS7E9ULipBxEzSkCljjFxohPz0H4N0Ddpqn/RRy49j0Z09aRfENxmMx1T7xlyFu1hus3KFu/sMq5+DJDuRvCJu/kuT3KydusQmnnxWoYsQZSY9y/aBajIJVmgGI7vlsGsmlm2rligrDCe0OnorRBK28ikKNrJeZCNEbMIuA3laoovxoOB6npKJRCacxZY6wURQniJa02+1pSsHE27Nnw9ru+TFQHAz/U5WKXrmI2GMFG6rIXCU5dE6D7PpK0pwwSNfARBQlbremY4UyRXYSP3EZmRb+2wfgsNUJKNZiGrcJ6JbtgXPUMfhXOKLXeqFabMizwV/EGHDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Yt7bxEquUJIO7w7aaWVnktjJHrHCMnp6mC6IKssfbg=;
 b=BsVuNvd7+5PA66FfENtAnEmRS7x/XJOBKMuM2m8KdqivroUeKbUL5swMYYS3Clm6juFryyeZbP1KOW6s2fiVypbXIOQM2KS3Iliy4VnnBfcxENQiYi/FnQ6ff7IfXTudy5ZyW1iiXP9IQSG3jf9yrXxEzMzdWwZu0QkrGarK99s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB7742.eurprd04.prod.outlook.com (2603:10a6:102:b9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.15; Thu, 15 Sep
 2022 17:38:25 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Thu, 15 Sep 2022
 17:38:25 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] net: enetc: deny offload of tc-based TSN features on VF interfaces
Date:   Thu, 15 Sep 2022 20:38:13 +0300
Message-Id: <20220915173813.2759394-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0095.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:15::48) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PA4PR04MB7742:EE_
X-MS-Office365-Filtering-Correlation-Id: 761b6815-7498-45a6-0650-08da97411786
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WhDRJmvXNZ3a1woyQXXzPXpPIS+xFFn+3wZZWO3KJjqek/crex91OFfBAoqJ7dfosFQE4kClZtqFRIlgZIyXBg1mYXoXFYMF9Znb9fOwGLcC1uS4enBEPaty1n5RBVoGDYK7e2YgFwrwtKfKfL+q/tYusqrYdbS1Oe9dpRQIy/qQ/wfz8MfXrE5Q/jMpvvaSv7mwUuYHUidXFuI9KuspRXv1/4uo/nUAOHxbytn1XT/l06u6KojgFsW8i/aoPxZhsFEbDth/xGnPIe451MOEUfRc5qVDrR5gwF0lDtNcal1H3V4zmZ5NY+M6Qc/ZqmizpDSdwRaAb4umLRux0gwQmZ2puCTWfwiv0Okp/SLJzPGbUuw2sV/TjG5/xIayVn126KlWNW0ZoRA7UZ8xf9bfC13wkLTz3OZc2hvOmDMQQrnTQ/dp/tChMOUr9rFGjgT4f44bNuIesZkWln7bqf69XiQMtCBYg9VkfRXfb5AyyDbf0MkhXr71rNtNQxEGE/Dtemsb13bvFDtWqGB4eM2cqII/wDnF1Oc2Ox5vaHw59p+XBD4VxUPf2SWhS6QiLplC1Qn3O5OIY4qS5Kx5xkjP7aptrBwVlJV/DdyK2aguys0WRn/TErnWjFR2ya5aZOvl5vtdc56leueXLUoHUKF582VABwD3jhk82M4FObgKwJ6Hkj0uFszLRRURzUNGpV7tnH+qHwxk8dYj0MlHAXWapWTDjI2krnB2ryq4Goh9dzlI/K5BD0/ap8dIXbQGG6jfnamQtCOrlE8X2NcT1MAzHA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(136003)(39860400002)(376002)(396003)(451199015)(6666004)(41300700001)(26005)(6512007)(6486002)(52116002)(6506007)(186003)(1076003)(83380400001)(36756003)(2616005)(66946007)(8936002)(8676002)(44832011)(5660300002)(4326008)(38100700002)(38350700002)(66556008)(478600001)(66476007)(2906002)(6916009)(54906003)(316002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NLjl2BNcUkkJv+ismDYp7ya8HrZlEo/wA35FAYY0SbGESNZh6aw9rZ+o7CRv?=
 =?us-ascii?Q?zFVrwzTnXr/GECl2WJ6SeKzb6xUd/c6QZveCYISdBzTk902vjYWkHzPuqTwo?=
 =?us-ascii?Q?G/Esui2ux1589w4e1oK/64AeBQtruTp/CDXycW+42e/o8ngJ5Q860ZKFPu/v?=
 =?us-ascii?Q?r8Yt+L8iJVG9dzl829Do51fKZtFOeb7Q1r4H31rdZ9r8NTh0rgC0EGvyEEV4?=
 =?us-ascii?Q?3skK8u+Yob9Z08ZfLuc2dnRlMk16e6/E6EQFt43HX8Pk5lhhfTdziTJQYiik?=
 =?us-ascii?Q?74LmtERc64RELWWy2mMYUhdklecsiWrGJ3VMcUVt7d5RFzBOJIoNwcNOpQYD?=
 =?us-ascii?Q?ZtFdpYw8iRvfMrue36Yi/tzIdyuhhuII6qVRbDra0mua2wpGs4KSv3UobwRT?=
 =?us-ascii?Q?HPoO8CifwxyAqUgzE564Ets9WJC8jtFqu8zpJos9GnM1/2CY4BiwaWHRrqiE?=
 =?us-ascii?Q?uXPGJJnED7akOHWNKjiduGZ6ke23+uKynjekgGOJ1786AOu/5Eo8UHWeE8bs?=
 =?us-ascii?Q?V+av4sMbrNG2ThpNucWj+2+xfQ/Y3kEsvMyF3ysAUem/ujsOr+UWLxA4Gr48?=
 =?us-ascii?Q?fTUXr262pOJAZXBOoYdGEbwYqxdXXNBGwab1hBojXntowCJ3btYefGB6yDjH?=
 =?us-ascii?Q?Pb0vnFJ/GsYtir4IXjwqmw5Ygnq68Lk/3JLpEsvcuwbm/N0qCns+T5b6D+1F?=
 =?us-ascii?Q?wbgktig6EWfWAd+IHeEB/9apM4HzKb6TnoUnfT9iUc5bAayUrf0cJ74hro3n?=
 =?us-ascii?Q?VJTv9T4x9+0QDSsBbMj9SoPkekGGKTbImyIiHTfL/svCsjlQ25b2vRF4Fz2W?=
 =?us-ascii?Q?5lf5zUIfiAHGHd+MZEBd+hI6kF1UkcK6SKbbUI44uSf5i++lKg8BYJO9GhST?=
 =?us-ascii?Q?LHzOTJNAWsQ0h28PxEDCPQp4p2XMVejTWLa6//Y/SDx424rjWVdFFuEhHyVJ?=
 =?us-ascii?Q?QAipIXyycfyuAAFzvtf+rsAqHrN+FgsKfvFQKCv18Aw7ss8RBiWnKvJ86Rtk?=
 =?us-ascii?Q?tmcP/8VCYrYfsdzg/xmE5Sge7ObTuuf9dXROi+MvlDyrrFawexV5Np5K5W/f?=
 =?us-ascii?Q?/XCQH3fntwbhuonHZLXL5AL/oFwMRu1c/qF6KC1aUniunjaVawzuh4VLhcbY?=
 =?us-ascii?Q?VxsMaO6Rs8tqf+1N7Ipl7xaIPGcLzhi6YawPMeiRwiExyl/AvelywwrM1PGW?=
 =?us-ascii?Q?zYuzCAfuMYp7m1L/k3B9Ql+tjj+s0xlUp0CDicngEBOesp/W35VvsTblH3eR?=
 =?us-ascii?Q?6Ks2fZKM3aE997z30yoZnZdpLFhBmEYQORh/6lgvgq9Sf9Rftf+Qn6BKfg0y?=
 =?us-ascii?Q?idV95Cyp7TWdLGAlM4ZYRiFDgo4TiYiZZU7v0pIkL4DiZHu8llm21IlfXe4J?=
 =?us-ascii?Q?nQBKqMfqaBJBscx+XMG7IBbC5hfJX0KqJ03Ay7yfZBLYz433IYjatw04OXuN?=
 =?us-ascii?Q?OGXTTDMxok2JOAoaf3yMtNHeZuhjsWHwvJTD1HvqGJonq+wT3+3/PcTS3h3l?=
 =?us-ascii?Q?xiX1sjFWqrEuUZG2zuEStYPw4GcSZRaOvPMOJDmhX7GBEf4HkSaC6IeP5b05?=
 =?us-ascii?Q?rQU9QgDhR9XTC3V7Rm+Lv6IraOIz8cwl0ZerujcS7dEKNHzZ5u06ycFLbmlf?=
 =?us-ascii?Q?4g=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 761b6815-7498-45a6-0650-08da97411786
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2022 17:38:25.1549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OtmkHlUDm4rcRFLhzeFBToaX+Oh0EDztUpIv7IVMuVM/0kq9+8YY4FYw9989EzO6GQjNThbGeRiLtcnOFtnJfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7742
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TSN features on the ENETC (taprio, cbs, gate, police) are configured
through a mix of command BD ring messages and port registers:
enetc_port_rd(), enetc_port_wr().

Port registers are a region of the ENETC memory map which are only
accessible from the PCIe Physical Function. They are not accessible from
the Virtual Functions.

Moreover, attempting to access these registers crashes the kernel:

$ echo 1 > /sys/bus/pci/devices/0000\:00\:00.0/sriov_numvfs
pci 0000:00:01.0: [1957:ef00] type 00 class 0x020001
fsl_enetc_vf 0000:00:01.0: Adding to iommu group 15
fsl_enetc_vf 0000:00:01.0: enabling device (0000 -> 0002)
fsl_enetc_vf 0000:00:01.0 eno0vf0: renamed from eth0
$ tc qdisc replace dev eno0vf0 root taprio num_tc 8 map 0 1 2 3 4 5 6 7 \
	queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 base-time 0 \
	sched-entry S 0x7f 900000 sched-entry S 0x80 100000 flags 0x2
Unable to handle kernel paging request at virtual address ffff800009551a08
Internal error: Oops: 96000007 [#1] PREEMPT SMP
pc : enetc_setup_tc_taprio+0x170/0x47c
lr : enetc_setup_tc_taprio+0x16c/0x47c
Call trace:
 enetc_setup_tc_taprio+0x170/0x47c
 enetc_setup_tc+0x38/0x2dc
 taprio_change+0x43c/0x970
 taprio_init+0x188/0x1e0
 qdisc_create+0x114/0x470
 tc_modify_qdisc+0x1fc/0x6c0
 rtnetlink_rcv_msg+0x12c/0x390

Split enetc_setup_tc() into separate functions for the PF and for the
VF drivers. Also remove enetc_qos.o from being included into
enetc-vf.ko, since it serves absolutely no purpose there.

Fixes: 34c6adf1977b ("enetc: Configure the Time-Aware Scheduler via tc-taprio offload")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/Makefile |  1 -
 drivers/net/ethernet/freescale/enetc/enetc.c  | 21 +------------------
 drivers/net/ethernet/freescale/enetc/enetc.h  |  3 +--
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 21 ++++++++++++++++++-
 .../net/ethernet/freescale/enetc/enetc_vf.c   | 13 +++++++++++-
 5 files changed, 34 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/Makefile b/drivers/net/ethernet/freescale/enetc/Makefile
index a139f2e9d59f..e0e8dfd13793 100644
--- a/drivers/net/ethernet/freescale/enetc/Makefile
+++ b/drivers/net/ethernet/freescale/enetc/Makefile
@@ -9,7 +9,6 @@ fsl-enetc-$(CONFIG_FSL_ENETC_QOS) += enetc_qos.o
 
 obj-$(CONFIG_FSL_ENETC_VF) += fsl-enetc-vf.o
 fsl-enetc-vf-y := enetc_vf.o $(common-objs)
-fsl-enetc-vf-$(CONFIG_FSL_ENETC_QOS) += enetc_qos.o
 
 obj-$(CONFIG_FSL_ENETC_IERB) += fsl-enetc-ierb.o
 fsl-enetc-ierb-y := enetc_ierb.o
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 850312f00684..62b0dac03dfb 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2435,7 +2435,7 @@ int enetc_close(struct net_device *ndev)
 	return 0;
 }
 
-static int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
+int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	struct tc_mqprio_qopt *mqprio = type_data;
@@ -2490,25 +2490,6 @@ static int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 	return 0;
 }
 
-int enetc_setup_tc(struct net_device *ndev, enum tc_setup_type type,
-		   void *type_data)
-{
-	switch (type) {
-	case TC_SETUP_QDISC_MQPRIO:
-		return enetc_setup_tc_mqprio(ndev, type_data);
-	case TC_SETUP_QDISC_TAPRIO:
-		return enetc_setup_tc_taprio(ndev, type_data);
-	case TC_SETUP_QDISC_CBS:
-		return enetc_setup_tc_cbs(ndev, type_data);
-	case TC_SETUP_QDISC_ETF:
-		return enetc_setup_tc_txtime(ndev, type_data);
-	case TC_SETUP_BLOCK:
-		return enetc_setup_tc_psfp(ndev, type_data);
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
 static int enetc_setup_xdp_prog(struct net_device *dev, struct bpf_prog *prog,
 				struct netlink_ext_ack *extack)
 {
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 4d0bdfef51b7..7007959f9cc9 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -396,8 +396,7 @@ struct net_device_stats *enetc_get_stats(struct net_device *ndev);
 int enetc_set_features(struct net_device *ndev,
 		       netdev_features_t features);
 int enetc_ioctl(struct net_device *ndev, struct ifreq *rq, int cmd);
-int enetc_setup_tc(struct net_device *ndev, enum tc_setup_type type,
-		   void *type_data);
+int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data);
 int enetc_setup_bpf(struct net_device *dev, struct netdev_bpf *xdp);
 int enetc_xdp_xmit(struct net_device *ndev, int num_frames,
 		   struct xdp_frame **frames, u32 flags);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 03275846f416..28af8f5b907d 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -744,6 +744,25 @@ static int enetc_pf_set_features(struct net_device *ndev,
 	return enetc_set_features(ndev, features);
 }
 
+static int enetc_pf_setup_tc(struct net_device *ndev, enum tc_setup_type type,
+			     void *type_data)
+{
+	switch (type) {
+	case TC_SETUP_QDISC_MQPRIO:
+		return enetc_setup_tc_mqprio(ndev, type_data);
+	case TC_SETUP_QDISC_TAPRIO:
+		return enetc_setup_tc_taprio(ndev, type_data);
+	case TC_SETUP_QDISC_CBS:
+		return enetc_setup_tc_cbs(ndev, type_data);
+	case TC_SETUP_QDISC_ETF:
+		return enetc_setup_tc_txtime(ndev, type_data);
+	case TC_SETUP_BLOCK:
+		return enetc_setup_tc_psfp(ndev, type_data);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static const struct net_device_ops enetc_ndev_ops = {
 	.ndo_open		= enetc_open,
 	.ndo_stop		= enetc_close,
@@ -758,7 +777,7 @@ static const struct net_device_ops enetc_ndev_ops = {
 	.ndo_set_vf_spoofchk	= enetc_pf_set_vf_spoofchk,
 	.ndo_set_features	= enetc_pf_set_features,
 	.ndo_eth_ioctl		= enetc_ioctl,
-	.ndo_setup_tc		= enetc_setup_tc,
+	.ndo_setup_tc		= enetc_pf_setup_tc,
 	.ndo_bpf		= enetc_setup_bpf,
 	.ndo_xdp_xmit		= enetc_xdp_xmit,
 };
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_vf.c b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
index 17924305afa2..8caa0624b995 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_vf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
@@ -91,6 +91,17 @@ static int enetc_vf_set_features(struct net_device *ndev,
 	return enetc_set_features(ndev, features);
 }
 
+static int enetc_vf_setup_tc(struct net_device *ndev, enum tc_setup_type type,
+			     void *type_data)
+{
+	switch (type) {
+	case TC_SETUP_QDISC_MQPRIO:
+		return enetc_setup_tc_mqprio(ndev, type_data);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 /* Probing/ Init */
 static const struct net_device_ops enetc_ndev_ops = {
 	.ndo_open		= enetc_open,
@@ -100,7 +111,7 @@ static const struct net_device_ops enetc_ndev_ops = {
 	.ndo_set_mac_address	= enetc_vf_set_mac_addr,
 	.ndo_set_features	= enetc_vf_set_features,
 	.ndo_eth_ioctl		= enetc_ioctl,
-	.ndo_setup_tc		= enetc_setup_tc,
+	.ndo_setup_tc		= enetc_vf_setup_tc,
 };
 
 static void enetc_vf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
-- 
2.34.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A52B5E59D7
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 06:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbiIVEBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 00:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbiIVEBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 00:01:24 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2093.outbound.protection.outlook.com [40.107.94.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E5C1ABD68;
        Wed, 21 Sep 2022 21:01:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AQcc2o5djNirwFXljuhnxzaXDMkJ52zA6KUY8ou8OsLA1IAPcPxuWTFnGIs53C3zj3K8P2SdtsObLIKrTIkZZ8WuE+GrePZR13XrEs6nkbOn0tmhculS7M0NF/R0XaaDnLm7OS3VwTMLSVBsOHBEby7IaAgFZCtToJgADO/+h0Z8TstxrqHP+E6902lo/t1XfbqSHLF3Rv1E0YH6dAfT6YRsrEcBqHYCXdUL5GPiwkVf6SQoRSC62Jl82ouMVI8d3Xom0ulpB42npTw30ArcKUP2wPY5Agomg7exNviZrbzKJb3ry2W5NPwNfABjkcLh7/E1HNHsh7Q/YMRVExdvzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JTXVjLxZigSY5WQHrpgFogC1j9QeVR3uAKFZ11Wo5L4=;
 b=dcD+7vSFgHBLV+oxFKVdKip1Ge+rN+T/bs5nCkB+l+TRf/pI4n5zJkZRoXEMmBmPusC8+Ew/cdyCvJZGJc0OVwWWWUfjUCnWRBpnitvhTHSM4olK0TtHkP7Qh+10n9wd/t8IzasEOX75/g1J5hUdYUoSKILVkmTqDEx9BB9O0CxA6KqhwQMbtJSA7mjQLAleSOOwPwBg5xkq7JeX2prQJqFZH5aZLwEgv6Ag2swPOEtanF+Nl+fR71EoSim7u749onP2M33ccHPs8SkX7z5Tw6YJsswh9eaucM0w9Tof0DaTbwN7UFWT1syDcEVlvT8oULD/t/T3g8lFkpM8ytPoVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JTXVjLxZigSY5WQHrpgFogC1j9QeVR3uAKFZ11Wo5L4=;
 b=CYZvtLn/VFPNHh531lkk+6oQe/38lmsVDsuu8uICRkeigT8yuFPYTKazBJmOPlPNbQdZyWqtDSboA7PvD83agidCTH5egefxW7NEtY8z8q7dAEw3O4OZNyZdrjqaWB9YtUtSq4FNmscY/HlKySDzGbudpMP0G3slgPUt+t1nzc8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com (2603:10b6:4:2d::31)
 by BN0PR10MB5158.namprd10.prod.outlook.com (2603:10b6:408:120::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.17; Thu, 22 Sep
 2022 04:01:21 +0000
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::b594:405e:50f0:468e]) by DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::b594:405e:50f0:468e%5]) with mapi id 15.20.5654.014; Thu, 22 Sep 2022
 04:01:21 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v2 net-next 03/14] net: mscc: ocelot: expose stats layout definition to be used by other drivers
Date:   Wed, 21 Sep 2022 21:00:51 -0700
Message-Id: <20220922040102.1554459-4-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220922040102.1554459-1-colin.foster@in-advantage.com>
References: <20220922040102.1554459-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::22) To DM5PR1001MB2345.namprd10.prod.outlook.com
 (2603:10b6:4:2d::31)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2345:EE_|BN0PR10MB5158:EE_
X-MS-Office365-Filtering-Correlation-Id: ee868c1b-0128-49bd-72e7-08da9c4f1c39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FKMPX2rOAWcRvEk5DB0ILloCx3Xtk9ddLKdiAHzs+8jfQFgPSIw0F7rkzoRrC2wjhdpWMTlx5/ZYDnLIG7QDCn/7sgOfsmvyTCdpjHKmX6Sx6EPMX7W0e//yiGsRERB+j/KW+zI/TpiogPHMob0OR2x4x6zpfUVHMt1c5Eg13/HYK1VwPvY5Rrz0gxGESigXte7uXW6n2mkrPc2IjasoF52ZmMcCdB8F4c4QOeUULOPehW1jbgfwCWBpClRqgiPdJZ7rk74+co468yFMT7tDdelCUsdIcaSSjqbAsWDGQ9nie82ekO0wVN8ftxhKZtcjehOwrRqjv40XWq/Dot3pCVmYZPRY0DVBuNlejCokwVxGpJGHwizvJ+SUqcx47aRMe1P+FBCByPelD/ZX10p2MVtR+b5pZlwyfHoxSkLVbJwGQPLyO9jPTHEvhVq6sx6gdb+Vfw5RsxgRSIHMJBOWMvUabewmlCEp/CsVNDq9VfvDmblBbJQ0kBO/1IAmjK/CYuU1D0lfdsIzGZ/2nKiLjrV5PP96r5IL4yPV/4WcGE4tBYma9T7MHKJYowAINmYXnM+RDOJ3bifPMBfGmMkllS3A39lhF6iIp0tbEB/02iDx5zEkveBrS7XRIvJlpeOkJYISUnoY/irpTx1NihSWUQZqOjFK74albJMnwqkf3wbzahPpH8Gd3evi9r8X324C43L0Fh5ENWplHD2rOeFZmsxp38l1CZB9b9jivzqamNbr7EvmFgGezqENJQPW4kYtxOEBXmIvLxqzce7q5RFhig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1001MB2345.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(39840400004)(366004)(136003)(346002)(451199015)(6666004)(36756003)(41300700001)(8936002)(44832011)(26005)(6512007)(7416002)(6506007)(5660300002)(316002)(478600001)(54906003)(6486002)(38100700002)(8676002)(66476007)(66556008)(38350700002)(4326008)(66946007)(83380400001)(52116002)(1076003)(186003)(2616005)(86362001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6HYf3L6UR1mI32ngI7CqkKZnH1znH/QLpnpWx2FX6tP+tPR0l0MKeaNU85Ls?=
 =?us-ascii?Q?vdS/uugc+ZgIyRZuTng2VsS1jlRvuetCbvd6GUyTlAmzs5Yi2NROVmKmz9hy?=
 =?us-ascii?Q?VOolEGBnDbvuxYdaTK1/YTD+lcZVrqo4Dsuxg+KEoi6GpIYoj9yVGTZdOgRI?=
 =?us-ascii?Q?TsgVUQ5qvgc3ToYZGjarvUcbY33pJkJamDqWFRNrkPTPZsn+lKSA+oGvwyJl?=
 =?us-ascii?Q?Ro+SiEWl05bthQaaohdH0xwey1o7BArdXP2Tlh1nSfdsP6cH1eP8HR2nhBWS?=
 =?us-ascii?Q?uC+2fU+4CVSVQOyT8whYj+n208I29eLM633jcazUuw0MsPm6BnRNZxv00Tmr?=
 =?us-ascii?Q?sQ0GIz4HbnMQc2omPcMS1HVXM6Ntly4Km1XG/gBk4iBGxvoYJQ9jKxnu373p?=
 =?us-ascii?Q?UomZhMaLAXQAhaABI0C78R5L6XRQJIU1P/bn0I68TmziE+VjE2zA1EEjQ3UP?=
 =?us-ascii?Q?XHYwwjFiiZoXj/9VEOBUzvLu29QNTFyBjAyvOICpMY42dkQ/nFiDDiyuU7VV?=
 =?us-ascii?Q?vDjzaZizca5lBXwU17vNFb10dUgqXCBmKP7xi4g33sUd5JdKvqh1VENOEWRZ?=
 =?us-ascii?Q?0qPZMyJRfGyqteHg9sWMLBijRPWGfjtCv6PX9zjxCkzSIU3bJsuS2bprRbjQ?=
 =?us-ascii?Q?8h7Abva8w66h1lssX2KTMstabPKjkomjPb4t5xDAirRkL6wqsDrmh74Qt8Qw?=
 =?us-ascii?Q?GF+CYoSZDjAv5fYuVekknBWv7g7qrLgCsf6XNOPbzh/BtphJbBkdGR+XVCQ9?=
 =?us-ascii?Q?Fc0nW/z3Ov40oR8L91LATcoa2u/WkTpdLvD0XzFPvZTPE31Ew5u5L69bjFGG?=
 =?us-ascii?Q?3Z9fDdApukBnstu4CPMGCv4diEh/uq0LyNphOOIqO7waJ53VEL3OVteBlqK7?=
 =?us-ascii?Q?0Z/gPYIVgHgniN++g3i75L+bn+5Xf41IkZgY8td6GEcbDaX1IN210GrOsfcr?=
 =?us-ascii?Q?UVSp9pnBzYKR+jMiIwHMvJT+MqN5YPbV/zP5fsXQDZhoDvH4QuBL0Vtd+vbi?=
 =?us-ascii?Q?6HhqYxtWlzS4pOD9iOwLv3wtSeizEB7rFzQQlVLUMtRFO5vuTFRC74O+IFIQ?=
 =?us-ascii?Q?AE8/y38N7sorQRiyUqCdqjFm8gTbAi8tWhxPSfNrEYuF7xjPbod2MEnP6esF?=
 =?us-ascii?Q?obrmri1prwf7cTPbvjZvRcGxWCpFXo+JQrRIhmKakXBvHm6SPSB89hgX/e5/?=
 =?us-ascii?Q?JxGSnBQz+oOlzGnv7h2ofwQLPIjbjSv3PYg8jCHohx+ImRyojpE83ypg23Q+?=
 =?us-ascii?Q?OEE2gAVTy6cW0xDmXiiznflHSrNjorSC/VMODEd6mAl2kpaMHyMc1/bSTDI/?=
 =?us-ascii?Q?JSoJFiWIrpOq/b7KrNhjm4OmLxETYzgcbizMO57jsJfrJcrf0lUVvrAGSN4/?=
 =?us-ascii?Q?ZuPlEgspt4Nep1+hxQ9QTJ+8Jylq705HZok6FPNSjY83WNu+PzOypmaXogf4?=
 =?us-ascii?Q?Rj1e16wW/N4noRID71E4vkW4N5g1YN0Dpo13SohlzoijfzlXFOHirnLYKXCD?=
 =?us-ascii?Q?sSZ16X6FObjXDQS8Fh9pfXN066yK3MTDviL+4EFnIm3Z1id21wUXULNHgU/S?=
 =?us-ascii?Q?uyplDe7q5ID06qiwV73FVY5q4aY2R1Iu/er6hZ8RHHcB/7NrpwtE5CDJ2xJF?=
 =?us-ascii?Q?lbbWHNzckybQkJN6siik11w=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee868c1b-0128-49bd-72e7-08da9c4f1c39
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1001MB2345.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 04:01:21.7316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: POxTUdGkpNACNj+PUPNvxV0NxFuT3ddc91H89SdSJ7mMIdyK5GmIeNIk0hs2cxBOtTpa/YALGpcp6VrMbRWeWObNHW4pXwnIjfn3wEpUD+A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5158
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ocelot_stats_layout array is common between several different chips,
some of which can only be controlled externally. Export this structure so
it doesn't have to be duplicated in these other drivers.

Rename the structure as well, to follow the conventions of other shared
resources.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v2
    * No change

v1 from previous RFC:
    * Utilize OCELOT_COMMON_STATS

---
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 6 +-----
 drivers/net/ethernet/mscc/vsc7514_regs.c   | 5 +++++
 include/soc/mscc/vsc7514_regs.h            | 3 +++
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 6d695375b14b..4fb525f071ac 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -42,10 +42,6 @@ static const u32 *ocelot_regmap[TARGET_MAX] = {
 	[DEV_GMII] = vsc7514_dev_gmii_regmap,
 };
 
-static const struct ocelot_stat_layout ocelot_stats_layout[OCELOT_NUM_STATS] = {
-	OCELOT_COMMON_STATS,
-};
-
 static void ocelot_pll5_init(struct ocelot *ocelot)
 {
 	/* Configure PLL5. This will need a proper CCF driver
@@ -80,7 +76,7 @@ static int ocelot_chip_init(struct ocelot *ocelot, const struct ocelot_ops *ops)
 	int ret;
 
 	ocelot->map = ocelot_regmap;
-	ocelot->stats_layout = ocelot_stats_layout;
+	ocelot->stats_layout = vsc7514_stats_layout;
 	ocelot->num_mact_rows = 1024;
 	ocelot->ops = ops;
 
diff --git a/drivers/net/ethernet/mscc/vsc7514_regs.c b/drivers/net/ethernet/mscc/vsc7514_regs.c
index 123175618251..d665522e18c6 100644
--- a/drivers/net/ethernet/mscc/vsc7514_regs.c
+++ b/drivers/net/ethernet/mscc/vsc7514_regs.c
@@ -9,6 +9,11 @@
 #include <soc/mscc/vsc7514_regs.h>
 #include "ocelot.h"
 
+const struct ocelot_stat_layout vsc7514_stats_layout[OCELOT_NUM_STATS] = {
+	OCELOT_COMMON_STATS,
+};
+EXPORT_SYMBOL(vsc7514_stats_layout);
+
 const struct reg_field vsc7514_regfields[REGFIELD_MAX] = {
 	[ANA_ADVLEARN_VLAN_CHK] = REG_FIELD(ANA_ADVLEARN, 11, 11),
 	[ANA_ADVLEARN_LEARN_MIRROR] = REG_FIELD(ANA_ADVLEARN, 0, 10),
diff --git a/include/soc/mscc/vsc7514_regs.h b/include/soc/mscc/vsc7514_regs.h
index 9b40e7d00ec5..d2b5b6b86aff 100644
--- a/include/soc/mscc/vsc7514_regs.h
+++ b/include/soc/mscc/vsc7514_regs.h
@@ -8,8 +8,11 @@
 #ifndef VSC7514_REGS_H
 #define VSC7514_REGS_H
 
+#include <soc/mscc/ocelot.h>
 #include <soc/mscc/ocelot_vcap.h>
 
+extern const struct ocelot_stat_layout vsc7514_stats_layout[];
+
 extern const struct reg_field vsc7514_regfields[REGFIELD_MAX];
 
 extern const u32 vsc7514_ana_regmap[];
-- 
2.25.1


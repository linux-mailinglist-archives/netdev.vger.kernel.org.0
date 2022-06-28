Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC8455E940
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347409AbiF1OxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 10:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347397AbiF1Ow6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 10:52:58 -0400
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30049.outbound.protection.outlook.com [40.107.3.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0237326DD;
        Tue, 28 Jun 2022 07:52:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bs9ySQAafDk+XqUyCuogWd4LK+822l2et/JlbwuwSv6j4rkUlrzltM1zx9Nps0Lh7ayK+5RxiQtC5aupjW1X2VsJ2N3O5dwTtxGQmyKb21u5y0cFar6QayiNzGHfaQwERucuOyppKxn8PCUbJelqsajzUCDCupJWW3b7RBxkE153TxvRx8EtOe6RnvhnBzvoJi72vOoD/XGfk4sneh17ZUMNQWIzu3L9fOSkWWkVS4+b/WGKlptDOObYy1lbUBXmwbRtmOjfZZdgEy4qaOmii2vsn18WDyehzXFtkVuf7Izuslcvlr+mET2XHtx7/NEj2CAWPDo6Sar2g7L09U93gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HDICeUUAwwEEWAaVrYL2+O0y30yQirKOLe+a3ijqBWA=;
 b=TKhYFLcOU1pQ+SDabvf6DtolZdc795gxJ46EBHSwbdm/WoH6L2eWL+95iHtIwMQSHfAKKddR0SestSD42T49wtQmbZKO3zpYvjja7GP9rdNpzeyjaGLkCN6rw8tumgZjlN1v7uv81q7s4PJBc76B62t+O831sma2i57YvpI0Wcaf0QdpLB7fAD4+qPoqEJDFlu09Jzea0TWiiyCMTU1KGR+fpJd71r0pXUXDdGKl+U5IrbDYxdxqXBV0g+SJwDpxqUKKVeUOCe2wTDD+IEyAS9tdYK6q14DS+zPmn5oYSHXcE3RHTIrA6yT3hL66nlhfgeglY67mQeRp2DwS/wylMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HDICeUUAwwEEWAaVrYL2+O0y30yQirKOLe+a3ijqBWA=;
 b=cbtSFGrdJMkqVnBey3GJSSGGaooAb+ZfUpwhNN9WDPTzXbu3G9vsBi5StZsnmwUa8383ZPYJbta4S9m+lVPJgzF4UYTR4KA5LKSWI0FM1sUP+uLB4WbJvfqj2TEQRYOUT51E8qjXY6JCpJnmsAT/PisXwlpTz2XUXSvXqpqqWmk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR0402MB3810.eurprd04.prod.outlook.com (2603:10a6:208:e::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 14:52:55 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::94fe:9cbe:247b:47ea]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::94fe:9cbe:247b:47ea%7]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 14:52:55 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 2/4] net: dsa: felix: keep QSYS_TAG_CONFIG_INIT_GATE_STATE(0xFF) out of rmw
Date:   Tue, 28 Jun 2022 17:52:36 +0300
Message-Id: <20220628145238.3247853-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220628145238.3247853-1-vladimir.oltean@nxp.com>
References: <20220628145238.3247853-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0104.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c3::8) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bccabef0-e658-49c9-06f9-08da5915e286
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3810:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QUiAbLuZxBXZ8O6FogDhm0xMPABP7tR4s4+v8xdmIhEUJIXGaspAHW/3SsXXErE2reItUS1zPwFJpWbz3aE8xY+/p1lQbIWBhq/gZvVAmvfMvefsk8tz4gqYEYuDT3FdfPSKF6G/FiNFlqnRBRFClX/QP3enagUIi5Id7X6i0FadmJ4mUFi57NJXvhPsrJJxiNGoQFpT8VDxXUgTdyyVVwL4zqglhtRWxTH9Iob6kXcxtYXCBQ/1h2EaMkrHtFlN7hyurk/E+2Yasp2Wu6tvv5hQUBf3r05EHLL5Y98E6/Gnh7yp1cMcrjRLVTWIXL5URfK6GDphbCUkD5xbzFesTonmHGtFr5LmdHw/aJle412h+7kmC7YCM8e4VoVksgbSyLGsjl43DXkxZQttkd+A+iI0qqpKqmZTro1Qxt+AgNfAD5mJ7NkzrHdTbO/kLYFDdWHtCoWXvmVzP16O2VmY+Vsr1EnQDJsnQvn7ZWeF9ATBvC6DvlqGfq2MAyygBWSCoNeYJsoXWm9u40xSzay/QNuJIpnamwOUINWIJyCqnSX+rMLVjLaWiuopc2sBFOhE1tKY04E8DCgKJCd8PgMigoW1Ys7dfDZVjS5ErABL34Trev49PHjl7Q+mHt0fPLRtnJbtt3dclJ74vIARf6RWLqcfidth+1Q0yHbY58TyAc3WjojzviiHQwBnHVpO4wxFNvj7HnQUjo8MmKBg1MdTpSD2QdFQweBo5MM8KBftFKnWye61YlWfH0FiP1Vq+XcRtk3+ptG4t/flRlqnfvPOSSzslVIMK2bkcoVUmaP0jOM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(346002)(396003)(376002)(39860400002)(2616005)(38350700002)(38100700002)(41300700001)(54906003)(316002)(7416002)(44832011)(1076003)(26005)(66946007)(66476007)(6916009)(66556008)(8676002)(36756003)(4326008)(6486002)(86362001)(6512007)(2906002)(186003)(52116002)(8936002)(6666004)(478600001)(83380400001)(5660300002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/cIFBp9BsAAhoWfX7YI963i7h6fW874K4G8CIR3jBrRqtdWRnJtMBQJJ3dmI?=
 =?us-ascii?Q?IJHfpHwrLEYWTvHl7laqrbaXIJVrEoTziVIa/cIBMiDQFysq1vPu/7Ne43yr?=
 =?us-ascii?Q?dG3zlGkvXnl+/SLKrSC+lz7Z8ColFqsBWJ0OR0QpHiibZMfktU61uJDHYiy/?=
 =?us-ascii?Q?Ob6Qtba8kdxFm0Mwqhk1uStqZ8wmwQK2DvYMq3/bCfKpQelPO8n8nR2rr/Gq?=
 =?us-ascii?Q?VAj2lJW0q67qn0PCYI+EEspA4AEKx+9gy365/IdyY+fleOgy0YMBHqGCxQPr?=
 =?us-ascii?Q?osV1GS0TOFOUI3cK+IzWv9Iw23ey+qiWEyCEiR/oRmilNbZBoY7RY9LkrdFV?=
 =?us-ascii?Q?O/gKzVBxOZJwn8juX6msAFow4tPc9fLPaerV8CIYh2hdnRWsSo4HyjE3IhtP?=
 =?us-ascii?Q?Ir/xJY1jKjypYB88TP1aMadfvR8JqcrhMSTxynmOaMHeBrdW0cznDfxuMC3p?=
 =?us-ascii?Q?dzt1obGrdnKIzGluU0PvKgcO7r4vcum9H+u9Fx7dc2nOIhiF6GXoB9zIXy+A?=
 =?us-ascii?Q?lbQ3ItNA/lwW1iE91kXcJvHiEDh5PT84WQJZCMy7krwzb2RRVEvJSA6UOxIF?=
 =?us-ascii?Q?Yoj/m11FlCFWrK/aoOFlr5I8QSIWrmCYjPpaQYGMeju8+trhwnC5RkwbepOT?=
 =?us-ascii?Q?TI9YV82bQA12BiQCm8OKuhKfzHCpyMStvdbADmrg8Naim0oyqN2+eECQwpSa?=
 =?us-ascii?Q?W4ocO28eMOjZOik4r08RP4gWoyOBjCjrMiNs38LPM21N7ZZKGyocoRJ4u3mB?=
 =?us-ascii?Q?XDstIjb6jPqzmI9+Db4sqP0jMUIQHHS4FrC+OmZ6UanjpjvvqDO9GUJ33jqL?=
 =?us-ascii?Q?C3ccjyADuGSOBEMV8Xu7dZb398qZEtbh5GrTa923XsTpoe0yNmSzNqVIiwvC?=
 =?us-ascii?Q?CLjxO2S9l9AEikgkugghq0nsDN3zsloFhUnFvd/K5t3RRsO8Lnc4X1fyquLk?=
 =?us-ascii?Q?mfIWSB8+tnledBW0W317KLp9SsX45IWUWFh9Q7p+UKdizir0jJMOgvvYfzXP?=
 =?us-ascii?Q?vpiIzORuQOUzkXeUkkKbwIxrPW/PXoAf7AFNhKPzD71Q3v8ljP9Th3mzy1WV?=
 =?us-ascii?Q?U4aa++OxS/vHsyiwXmOtZMaPjktmN2LyDNqN32QcWqjl+ccxM2PMwLwhbNDm?=
 =?us-ascii?Q?vv2eeB7NduvVxNc8ES1Dd+zpyPO3MGu/MLKYMqmAOIrWTewDsP82Jal8OQL4?=
 =?us-ascii?Q?rA3UhY9mV1oZIXdvuDOYRysLfLGORxSiEYid5DXyEa/BW5r8L12N4ksOu6/x?=
 =?us-ascii?Q?v8EpJJkg0zk8cMlXNoUyyJEXqfpRBdXbWB2WBb6NjNsIoINkJ8Ml2n4E4WiN?=
 =?us-ascii?Q?4/Gwl8+k9pAfx8FqB3orCPAZyRH0OWcvFvPhMOWFbGr/XrsvG1S1elXlAFav?=
 =?us-ascii?Q?AuJGgDg21/wORVAyvvkzLN0qTNz21UMnCpGTiUaOsDwfCI0EMcgqHSX8Pjt9?=
 =?us-ascii?Q?chrag6F01i0RffBsb8dxe4eJxtB0ZklEobmQVee6g7kkwqyoIRCRaRx40Zn1?=
 =?us-ascii?Q?S4SNbkXzkciWUKD3+tN7/YdM3HSJJUaOo3o3BbtYkpJiNuQ64GjrT4zHOiqo?=
 =?us-ascii?Q?+KzsfAW6LZTXyeP/j9FIRN3knSt4KJ6RgSrjxVis4x7u5BR0x9u1ABfifgTn?=
 =?us-ascii?Q?Qg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bccabef0-e658-49c9-06f9-08da5915e286
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 14:52:55.7528
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J1hYZJKvnur/+DFS5oGdkIXHD7H29P8sZTmLEZLuIX+MbJ1yKR8SNn3eZCOn7hgRnL7FW3wcBMgCEZ26lS+WEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3810
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In vsc9959_tas_clock_adjust(), the INIT_GATE_STATE field is not changed,
only the ENABLE field. Similarly for the disabling of the time-aware
shaper in vsc9959_qos_port_tas_set().

To reflect this, keep the QSYS_TAG_CONFIG_INIT_GATE_STATE_M mask out of
the read-modify-write procedure to make it clearer what is the intention
of the code.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 drivers/net/dsa/ocelot/felix_vsc9959.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 44bbbba4d528..7573254274b3 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1204,10 +1204,7 @@ static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
 	mutex_lock(&ocelot->tas_lock);
 
 	if (!taprio->enable) {
-		ocelot_rmw_rix(ocelot,
-			       QSYS_TAG_CONFIG_INIT_GATE_STATE(0xFF),
-			       QSYS_TAG_CONFIG_ENABLE |
-			       QSYS_TAG_CONFIG_INIT_GATE_STATE_M,
+		ocelot_rmw_rix(ocelot, 0, QSYS_TAG_CONFIG_ENABLE,
 			       QSYS_TAG_CONFIG, port);
 
 		taprio_offload_free(ocelot_port->taprio);
@@ -1315,10 +1312,8 @@ static void vsc9959_tas_clock_adjust(struct ocelot *ocelot)
 			   QSYS_TAS_PARAM_CFG_CTRL_PORT_NUM_M,
 			   QSYS_TAS_PARAM_CFG_CTRL);
 
-		ocelot_rmw_rix(ocelot,
-			       QSYS_TAG_CONFIG_INIT_GATE_STATE(0xFF),
-			       QSYS_TAG_CONFIG_ENABLE |
-			       QSYS_TAG_CONFIG_INIT_GATE_STATE_M,
+		/* Disable time-aware shaper */
+		ocelot_rmw_rix(ocelot, 0, QSYS_TAG_CONFIG_ENABLE,
 			       QSYS_TAG_CONFIG, port);
 
 		vsc9959_new_base_time(ocelot, taprio->base_time,
@@ -1337,11 +1332,9 @@ static void vsc9959_tas_clock_adjust(struct ocelot *ocelot)
 			   QSYS_TAS_PARAM_CFG_CTRL_CONFIG_CHANGE,
 			   QSYS_TAS_PARAM_CFG_CTRL);
 
-		ocelot_rmw_rix(ocelot,
-			       QSYS_TAG_CONFIG_INIT_GATE_STATE(0xFF) |
+		/* Re-enable time-aware shaper */
+		ocelot_rmw_rix(ocelot, QSYS_TAG_CONFIG_ENABLE,
 			       QSYS_TAG_CONFIG_ENABLE,
-			       QSYS_TAG_CONFIG_ENABLE |
-			       QSYS_TAG_CONFIG_INIT_GATE_STATE_M,
 			       QSYS_TAG_CONFIG, port);
 	}
 	mutex_unlock(&ocelot->tas_lock);
-- 
2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89BF55AD806
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 19:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237878AbiIERCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 13:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237618AbiIERCJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 13:02:09 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50056.outbound.protection.outlook.com [40.107.5.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 946A661B08;
        Mon,  5 Sep 2022 10:02:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jO3zr214gFHTcbOVxLEli3U9CF68vE8cqgjLdEa29i3p3soAJ9+W+N5fNDjUaZp6QmVS8EzENrz76XhaAHNvQYbeuUWQo2BDhP3IEBxgFtepPUnShiq2zfzAjPb01qHzaj11V3xvyK/Bqa0tgdkcE/hQIC+fgtFhqpeikfLnKK3U1Km3dWZhVwHEoDXNrWWTIqdTKSJoQ2NGwRgqJmpmlOVTAf+AmNTn5U6c5tjfZ14XUjbm2qL9OXgIn1CoY25X/fFmr5iXGB6oIcITh/LKUlmoQxyUY8L7VRJGHgJLD26UN0uOqHR35UT+ZQ8PREIXkuNcD4odjuV57rtnE9mWjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pLduDSul0k5tZYWtZZYwVBSNR01yuZO+d3URa1bor9I=;
 b=H8yFneZRldU9KRFc2C5jx6X47NO46izqJeu59Njt16B5zyLoRCcvNNwsAIMLQERhQSpZdjMIF85Xt4trzglIyJw06xVlyjZvZJGrHm6EmSUdzxGOuLUk/hm4qcI0i0FvjkBfjzzWQz8MnPTYD0kMarQ3OKE5B6vFQrO1vyETBSRgAjh/vWgWOJVQsYWnwN5sBhJHpe6Nd9HPJVhIa7cRQ7VJ1dcORKQvFUMMrDoxJT4JvzhgDYJDbYOwHKOF6LFiquInX8DaIDPCtkJS31O5r5JkU/cel276u3JOUVu7XVIF97boN1vOIwUXPTAITHqAQ48F89YTArzjk29EVY4XQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pLduDSul0k5tZYWtZZYwVBSNR01yuZO+d3URa1bor9I=;
 b=h5B9s1CCVrwwZxxT/dljbE/b9il72UfaJlG43F1gESdCZwcber6riyfLrDf0NaipXvqI4G/zt19kvGnfwFolKk8dU/GR/ryK3HwEIdKava8ZbM/DQ8iXGHfMSTdsjyuuKl2EZRKZ9SYK62eQLTMBO5l/ZLM0RzmaV65rNfmUzk8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB3PR0402MB3897.eurprd04.prod.outlook.com (2603:10a6:8:12::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.14; Mon, 5 Sep
 2022 17:01:59 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.017; Mon, 5 Sep 2022
 17:01:59 +0000
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
Subject: [PATCH v2 net 2/3] net: dsa: felix: disable cut-through forwarding for frames oversized for tc-taprio
Date:   Mon,  5 Sep 2022 20:01:24 +0300
Message-Id: <20220905170125.1269498-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220905170125.1269498-1-vladimir.oltean@nxp.com>
References: <20220905170125.1269498-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0140.eurprd06.prod.outlook.com
 (2603:10a6:803:a0::33) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 963ebb03-c450-4044-7b28-08da8f60588f
X-MS-TrafficTypeDiagnostic: DB3PR0402MB3897:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8tW2Txd7n04iz/CCtyCl6MD0jhMyCJLhvrQFZiH8aevAMVrBTLO/BYhbiwW0RJkLryLNO7miH+NSCaCXZB9LV1VCLul4QGi1zXO6ElzT0tIPKOzWke4C5sYpKmo4Gnz+HRVQSrWeSexpR8HmvnAByuXnLmDEXCug+pbAZgU0HYYi2efvokF4VsjwVEZrvjVhId3gDN6jURPpWlG2cx5w7QOJzZ7oQzDjea6L/rPg9m212GnqQfUAsW9EsivgfT6CZHxjvZ6faUWXJF5yUqud1R30vXsFl6wDyTKOTNfZIxCIO0iSLn01bL1+hkmlGyLZDRkwryGHO7NJ0NoIO4Ff4uYOlnfF6Q9rr7EWGVWjEGDnKxYt7WY3YqZZlrOBmcvz/0H4nY3lvbpwjIUnGhNQOtG5X3PFJ164QzDZW+WQmgo0begTDcWnOJ15O3i7HchCmBNwfJgF+kqm477/0r9zGZ6KBH5qlF69Bma2pyJCPSIuMgHBtCbGgho9jX8/Feaw/4V3q75JDFC0xfAjmFO3dtTm3dqkZcWBdhcOJ6I70sWMz2LoTqbzpWArff/0GNBjfkmjeM5BLU0auJgD+Dws+vCsjhy7/I4HHIk9SOHTKjaKJm9lVW3/rN5IZw+4zBU/+sQhxGxIGn6JrpoTEmQRWs1MeY6UhwyvJDtO204Ld7Z6iUR3iA+cp0940x+YA7lkMYAsFVmT+F1vrh5mcRkcVGYLtjeHDVutiNsioPn/l9KiWBJYIMxP6W3LGJH0kJ0TzDiLWrtVgntud1RlvZYLjA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(346002)(396003)(366004)(136003)(6666004)(8676002)(36756003)(4326008)(2906002)(8936002)(66476007)(5660300002)(7416002)(66946007)(66556008)(83380400001)(86362001)(54906003)(316002)(6916009)(44832011)(2616005)(478600001)(41300700001)(6506007)(6486002)(38100700002)(26005)(6512007)(38350700002)(1076003)(186003)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gQ76oRbjhRMzUHTEHGFiDC3nuO0weWpxDwa/EE7VEb2AnG14yCmj8vTvc5/1?=
 =?us-ascii?Q?ri3T0PF4TGzatknP+VruB+fSBoL6kh0E93NlX32vngFJTHS5n81KOqBNCfV5?=
 =?us-ascii?Q?3pJhSuIWonGK+qljRkxm8es2nTYBYEuWL0IqRL6/O58r44n61ki3upjyNSF1?=
 =?us-ascii?Q?kWlqGSbT5wcMX0IV77znBCF6keJVg6+hmFRQg4GFA/+qLkVVh8DzoDEUHhfj?=
 =?us-ascii?Q?EErFCnqWyJkfjaMXYpUvpxy6EqUy4h2elcYIRJV4EN5X1D6D0oy5j34SsIBC?=
 =?us-ascii?Q?KP9TYc4zXO7nxJW/kTvzMZkuwMgmTtbIfSoDsvIqcGpTcOh5aXS3pRISjHi+?=
 =?us-ascii?Q?6O0nnLWC9FdO/0k2vGr+18uyc+cWDPsR0eNDcM1nRX75cJVhrQWUSqORSQCe?=
 =?us-ascii?Q?+5t/f84/Ps8T5ZIa8OqNxZxDYnSv9cbLoMuRyS3u9WcoQ4pypT6F8ifM+U6u?=
 =?us-ascii?Q?ONAxy8HNi6cseW+qoCB4Em1s/oxIdneOjFvxUhPljk/ruPtPC9uMPnUEf+Du?=
 =?us-ascii?Q?TW4D3x4OllP9p9dCeJytWE3PYsItHiIpiTwNwNPsDHUH6fanv0Pxptw1Uiot?=
 =?us-ascii?Q?5rfUeUWy5YKwg550ng1BWB2uxI1Xyj4hpjYRJwENvAcvrSDK+kley3rr7Y7Q?=
 =?us-ascii?Q?HrR/SXLgON/xvQ7a89B5Jkz6XDbayrMzli7V2dp3LOq94pR8asmpL5IdPcf/?=
 =?us-ascii?Q?RWyg7uBN2uDL1n3fI46dMuvvZPyJAls6uTL8KVQqx+QCgv6BmvmeFbtjVg/6?=
 =?us-ascii?Q?Er3FZ+UiTgj/SWU6Jrd//cecHtw2tG78sq+QWwgl3sdEyu80cgUkD2cNT0Vq?=
 =?us-ascii?Q?jHGEwOwEOBMkwWupoTPNbTzeWgZAm1HhXhj10nTWxrVgvwELwEY4yBDI8Mz9?=
 =?us-ascii?Q?c7iuV2C1ChMQz9G7zXY9KPDCxh2N47Tk50CwEknob6fQaSDXd200oKL1fras?=
 =?us-ascii?Q?Z42BscZfFZ746AYcfXf4RXCxkIazoHO0Go+SqFBUhs0vpfWBvX/gH84Wshsj?=
 =?us-ascii?Q?eg5fRwMZ2MH7Xg23cwSWROtRcwfVeiniETOoV6L97VENYde4caMZDlhsejJN?=
 =?us-ascii?Q?hhaWvyk8b/ITV9jCfJDlqTqkjTa9T95GBfheMXz8mJ74b4sY3SRGyMWgiFVQ?=
 =?us-ascii?Q?QzEitD+Ff68hPiyipN45yPoCN/vI3hFpOUgwdkjQVT9fsb1PEL7Jmp7Ag1pa?=
 =?us-ascii?Q?1DPHec3qkra8afXRh6avq6teER9+8cL5P6ABzybzWs6ce/3N6GGN68yKlSEl?=
 =?us-ascii?Q?KteU3HAXsVF3KuOrDiSIsKu48rc8/esbtZmgFENpmwRqINvihIg4neLnvyZ+?=
 =?us-ascii?Q?pwn+RBt3iWDKvKSetUoum+VXgL/eAQ94j+y5hQ9sayGsPQ9aEA8Bv7I42nMD?=
 =?us-ascii?Q?Waoq6GszLLH8QYAsd+cBmMsfavbxkMkVunVbe3MG8Rww8NELnj9tqZWT9xc6?=
 =?us-ascii?Q?0bTSFGPRUOVKujI1UCkTCz8nVuMPvuA0dl+2COVx8Zno/QCatXarsCPAdyFV?=
 =?us-ascii?Q?SdRGrldWT1IjneRy0xzpfuu4C5OGdW4P5O6wJzeWVnyTlIwNPTmjSBupdf5R?=
 =?us-ascii?Q?a9hnW0dbiTWRHK/L64j79F0Ss6cwFHbG61SBqofKgD526DaUkCGQm8/r0Gvx?=
 =?us-ascii?Q?RQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 963ebb03-c450-4044-7b28-08da8f60588f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2022 17:01:59.3495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gGJ45+5VZcG8eFb6vUxj2aqN+r7m2Oauv9LMm5oSYBqtK0uE6JD9zhE1esNhcaydU7BBbv1DGb6EAqu06umgjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3897
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Experimentally, it looks like when QSYS_QMAXSDU_CFG_7 is set to 605,
frames even way larger than 601 octets are transmitted even though these
should be considered as oversized, according to the documentation, and
dropped.

Since oversized frame dropping depends on frame size, which is only
known at the EOF stage, and therefore not at SOF when cut-through
forwarding begins, it means that the switch cannot take QSYS_QMAXSDU_CFG_*
into consideration for traffic classes that are cut-through.

Since cut-through forwarding has no UAPI to control it, and the driver
enables it based on the mantra "if we can, then why not", the strategy
is to alter vsc9959_cut_through_fwd() to take into consideration which
tc's have oversize frame dropping enabled, and disable cut-through for
them. Then, from vsc9959_tas_guard_bands_update(), we re-trigger the
cut-through determination process.

There are 2 strategies for vsc9959_cut_through_fwd() to determine
whether a tc has oversized dropping enabled or not. One is to keep a bit
mask of traffic classes per port, and the other is to read back from the
hardware registers (a non-zero value of QSYS_QMAXSDU_CFG_* means the
feature is enabled). We choose reading back from registers, because
struct ocelot_port is shared with drivers (ocelot, seville) that don't
support either cut-through nor tc-taprio, and we don't have a felix
specific extension of struct ocelot_port. Furthermore, reading registers
from the Felix hardware is quite cheap, since they are memory-mapped.

Fixes: 55a515b1f5a9 ("net: dsa: felix: drop oversized frames with tc-taprio instead of hanging the port")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 drivers/net/dsa/ocelot/felix_vsc9959.c | 122 ++++++++++++++++---------
 1 file changed, 79 insertions(+), 43 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 262be2cf4e4b..ad7c795d6612 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1557,6 +1557,65 @@ static void vsc9959_tas_min_gate_lengths(struct tc_taprio_qopt_offload *taprio,
 			min_gate_len[tc] = 0;
 }
 
+/* ocelot_write_rix is a macro that concatenates QSYS_MAXSDU_CFG_* with _RSZ,
+ * so we need to spell out the register access to each traffic class in helper
+ * functions, to simplify callers
+ */
+static void vsc9959_port_qmaxsdu_set(struct ocelot *ocelot, int port, int tc,
+				     u32 max_sdu)
+{
+	switch (tc) {
+	case 0:
+		ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_0,
+				 port);
+		break;
+	case 1:
+		ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_1,
+				 port);
+		break;
+	case 2:
+		ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_2,
+				 port);
+		break;
+	case 3:
+		ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_3,
+				 port);
+		break;
+	case 4:
+		ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_4,
+				 port);
+		break;
+	case 5:
+		ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_5,
+				 port);
+		break;
+	case 6:
+		ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_6,
+				 port);
+		break;
+	case 7:
+		ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_7,
+				 port);
+		break;
+	}
+}
+
+static u32 vsc9959_port_qmaxsdu_get(struct ocelot *ocelot, int port, int tc)
+{
+	switch (tc) {
+	case 0: return ocelot_read_rix(ocelot, QSYS_QMAXSDU_CFG_0, port);
+	case 1: return ocelot_read_rix(ocelot, QSYS_QMAXSDU_CFG_1, port);
+	case 2: return ocelot_read_rix(ocelot, QSYS_QMAXSDU_CFG_2, port);
+	case 3: return ocelot_read_rix(ocelot, QSYS_QMAXSDU_CFG_3, port);
+	case 4: return ocelot_read_rix(ocelot, QSYS_QMAXSDU_CFG_4, port);
+	case 5: return ocelot_read_rix(ocelot, QSYS_QMAXSDU_CFG_5, port);
+	case 6: return ocelot_read_rix(ocelot, QSYS_QMAXSDU_CFG_6, port);
+	case 7: return ocelot_read_rix(ocelot, QSYS_QMAXSDU_CFG_7, port);
+	default:
+		return 0;
+	}
+}
+
 /* Update QSYS_PORT_MAX_SDU to make sure the static guard bands added by the
  * switch (see the ALWAYS_GUARD_BAND_SCH_Q comment) are correct at all MTU
  * values (the default value is 1518). Also, for traffic class windows smaller
@@ -1613,6 +1672,8 @@ static void vsc9959_tas_guard_bands_update(struct ocelot *ocelot, int port)
 
 	vsc9959_tas_min_gate_lengths(ocelot_port->taprio, min_gate_len);
 
+	mutex_lock(&ocelot->fwd_domain_lock);
+
 	for (tc = 0; tc < OCELOT_NUM_TC; tc++) {
 		u64 remaining_gate_len_ps;
 		u32 max_sdu;
@@ -1664,47 +1725,14 @@ static void vsc9959_tas_guard_bands_update(struct ocelot *ocelot, int port)
 				 max_sdu);
 		}
 
-		/* ocelot_write_rix is a macro that concatenates
-		 * QSYS_MAXSDU_CFG_* with _RSZ, so we need to spell out
-		 * the writes to each traffic class
-		 */
-		switch (tc) {
-		case 0:
-			ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_0,
-					 port);
-			break;
-		case 1:
-			ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_1,
-					 port);
-			break;
-		case 2:
-			ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_2,
-					 port);
-			break;
-		case 3:
-			ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_3,
-					 port);
-			break;
-		case 4:
-			ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_4,
-					 port);
-			break;
-		case 5:
-			ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_5,
-					 port);
-			break;
-		case 6:
-			ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_6,
-					 port);
-			break;
-		case 7:
-			ocelot_write_rix(ocelot, max_sdu, QSYS_QMAXSDU_CFG_7,
-					 port);
-			break;
-		}
+		vsc9959_port_qmaxsdu_set(ocelot, port, tc, max_sdu);
 	}
 
 	ocelot_write_rix(ocelot, maxlen, QSYS_PORT_MAX_SDU, port);
+
+	ocelot->ops->cut_through_fwd(ocelot);
+
+	mutex_unlock(&ocelot->fwd_domain_lock);
 }
 
 static void vsc9959_sched_speed_set(struct ocelot *ocelot, int port,
@@ -2797,7 +2825,7 @@ static void vsc9959_cut_through_fwd(struct ocelot *ocelot)
 {
 	struct felix *felix = ocelot_to_felix(ocelot);
 	struct dsa_switch *ds = felix->ds;
-	int port, other_port;
+	int tc, port, other_port;
 
 	lockdep_assert_held(&ocelot->fwd_domain_lock);
 
@@ -2841,19 +2869,27 @@ static void vsc9959_cut_through_fwd(struct ocelot *ocelot)
 				min_speed = other_ocelot_port->speed;
 		}
 
-		/* Enable cut-through forwarding for all traffic classes. */
-		if (ocelot_port->speed == min_speed)
+		/* Enable cut-through forwarding for all traffic classes that
+		 * don't have oversized dropping enabled, since this check is
+		 * bypassed in cut-through mode.
+		 */
+		if (ocelot_port->speed == min_speed) {
 			val = GENMASK(7, 0);
 
+			for (tc = 0; tc < OCELOT_NUM_TC; tc++)
+				if (vsc9959_port_qmaxsdu_get(ocelot, port, tc))
+					val &= ~BIT(tc);
+		}
+
 set:
 		tmp = ocelot_read_rix(ocelot, ANA_CUT_THRU_CFG, port);
 		if (tmp == val)
 			continue;
 
 		dev_dbg(ocelot->dev,
-			"port %d fwd mask 0x%lx speed %d min_speed %d, %s cut-through forwarding\n",
+			"port %d fwd mask 0x%lx speed %d min_speed %d, %s cut-through forwarding on TC mask 0x%x\n",
 			port, mask, ocelot_port->speed, min_speed,
-			val ? "enabling" : "disabling");
+			val ? "enabling" : "disabling", val);
 
 		ocelot_write_rix(ocelot, val, ANA_CUT_THRU_CFG, port);
 	}
-- 
2.34.1


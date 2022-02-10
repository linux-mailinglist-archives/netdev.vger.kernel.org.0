Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFCB74B0DE6
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 13:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238643AbiBJMwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 07:52:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239293AbiBJMwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 07:52:23 -0500
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30081.outbound.protection.outlook.com [40.107.3.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383BB2640
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 04:52:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vy3RNjHmOFFz0sZhR/wWnK6q7uHY7Uu7HdE1TUMtBuUzVSaf64G0+RV1/7NYs6wQ2T5Gapwr57x2dZDf4wjriARBPOrIFd6BhyT16sHXMxP29+pxGVbxaC3oMnhOJZjMZ0MNf0wxsqXQQ2qsfirSuMKT6Lk3rxHaOBeKVuTTx044Nhc93oFC0FHWGdQ1o4p0pohZ8d/xq53AsSMg7Ticwne52pPThtRG+Lswgp6jaQTRFZkLELSKIC7in4hMh779LzISWKpqqGWnOMgE9ASVSIXj+aLjj6wt1HtQDLR7aUet+Z7NYFbV4gLDHsKT/0lsZNI0YOs2lg7pbhwelkMAJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yr8HF4DIa0edWiEFDqIhvmb+0zZq7KqfbQNpsQVXhtg=;
 b=UB95c+bIroeTyBN9+hlPmd2CgnIA6YKsUrPw96+XEotpJpkyHT8hPtq/1WB/vK20hOqxdze5tUqOguFf8vBl3aakVZ6WsYw5HWLTHfwDRdjOTz5rsm3mzwmv/pvu7D5o56zipEX81oF5bOsHFiMmSg5XZDwZGpRnnHakPrMSmrxIbm2tiedl4pieSVKP6t1tsnEG0csrqXKEH/0T8Q+QIRrcwC8ln3ooyOqO/2ema8N8lsPIU8v+VMU8A2xJVap6Kvu1lnuaDNIFRDSk21rzs57A219+RnZ034aE1WOZlVvsshaRz6PXV4LXEn+ja+6wuuaslNHBvPinHgPli96tRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yr8HF4DIa0edWiEFDqIhvmb+0zZq7KqfbQNpsQVXhtg=;
 b=OnYXYeGNfURKyyIdDYRUQrn6wdHfdL8Rhgcblo1ep7ViySd+SEwdNkuyNSrofu3j1/5zxPFvGHoQQ0++93Me/atL6tspKpYm6FQylpfMD+of8gyc9bXvgvkzf5jSKv01xmmLLUkuL9NbLOH/FToMrMj5Tzp726hujoSk3LAsw98=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8806.eurprd04.prod.outlook.com (2603:10a6:10:2e1::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.13; Thu, 10 Feb
 2022 12:52:21 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Thu, 10 Feb 2022
 12:52:21 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>
Subject: [PATCH v2 net-next 05/12] net: dsa: mv88e6xxx: use dsa_switch_for_each_port in mv88e6xxx_lag_sync_masks
Date:   Thu, 10 Feb 2022 14:51:54 +0200
Message-Id: <20220210125201.2859463-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220210125201.2859463-1-vladimir.oltean@nxp.com>
References: <20220210125201.2859463-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR08CA0014.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 285bd236-0948-49e5-9563-08d9ec942d35
X-MS-TrafficTypeDiagnostic: DU2PR04MB8806:EE_
X-Microsoft-Antispam-PRVS: <DU2PR04MB8806C8331EB20AE9730BA289E02F9@DU2PR04MB8806.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GlDY6Pbfnv8ey4hC+YkMoDG7N52Nby4DVnuTR0XPpF7yj1eWb4SuvUkGuPAfVnjkKgu5bA9pW8sSZPfWwVlIx6cK0Awk+RYi1f7EW54rO6JmTWGyUhDWxCTua8w1dnZl3FUmznNGXTWk1M6TPVo6lCJqb3+LXtnywM2jyb89phUPMWIkmhU9/NYzUT3Vq70aepe0RtzyH7HoAxt0LDn9d/xkcFWIQnq7JJ2TuNWx8SKZHaP9X/+zIc4Uy9Oi8Uw4b54Oaz4cJnl9t71/Mb57BhvLd/a7CwXynzjcGxle+mFT/fKdNrPc1aMIqe8GbXi14yejULvhu067StkYlcrkenvuebL+1vcRg9zpE8vnx4U+9sx5Yo2mtH8MEx3DNY1z6aDcumleZWJSw5WQPJBOjTechClJhlhLl2TpZXawbtO/n/bwoorpDPVTZwxvRedIF5X5iRG6ltpUHnoyk9S37yygXuABBStjiYJ/yRGHNvE0kszbD8yWWsJJRWhD/yjqKJuXQ3xgSuErZopfR5l1+TQmrrqJaI9KmIm1P9lGU8FTrZC5f03N6SHZFcH4/MIOb0uWGX9c2buZyEcguaQTWFfmsrdb5bSGxKLeWz3NBkzIFP2i//0mu2oIZ8vKfljYxuImC0ozmbdNnxnMN4qBaMiDlL65zQup8ifgsPcPAZhvx7/YEIBcdw0Z3jF808G3mKNFbf6C4h2YvjDeDdnwug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(316002)(4744005)(38100700002)(38350700002)(66946007)(6506007)(6666004)(6916009)(54906003)(8936002)(36756003)(6486002)(5660300002)(8676002)(66556008)(66476007)(4326008)(7416002)(52116002)(86362001)(2906002)(6512007)(44832011)(83380400001)(2616005)(1076003)(26005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AYkVpoS+NuMIa9zzsuWf/faE15ITq9ubb+LHhcGHQUu3oVu3PTN+eP2A8avl?=
 =?us-ascii?Q?UvK0gItO/kiXNVZGc5OxuK8gROltWQybog0sf3aI/tnVen5FbWkZxyk8T9t9?=
 =?us-ascii?Q?hw1wNJteKn7Aic7Vr8T+QCiZpdNnNY9QFUyXfSQSuzslHk9fE2SuuKNuWzCv?=
 =?us-ascii?Q?5QZFy0xGUaEyDLAA9iNPKnU9w5nsFexjJiVWvbITSasDRD7bIAJatediVLnv?=
 =?us-ascii?Q?Msg/Buz3fVjcy/RR8p/GtzqFrUdmORt4xJMD8lTwhYaJfYSz5Ge6lz96SV5N?=
 =?us-ascii?Q?pXyxvWR6+uWn50Ckxxh+x0KtL8HCreNclXiIzDXtgQairnuV6meVasg1p0Qs?=
 =?us-ascii?Q?oab62hfA8X1mfvI8ytXHpfKXD+GXZxeLwuFphg1JBqKOO8FWVBEqeKdtBtBc?=
 =?us-ascii?Q?fk8ILlaqdL0L5m0gvReF+4XEV892mKGm660n5b+IEt5/EheNKuyE0v7rSQVY?=
 =?us-ascii?Q?f2HcbM6+1qu2xctkaHYFpI/NrSF/hgaiFzCeAlNykVT73r/NP51PW6/LfzVp?=
 =?us-ascii?Q?i3bW/y/LpD5+dMfeUvwY6l2PKGBWF0xIvpmzV+Z4B/4/dBYMGb/5etMeuNvF?=
 =?us-ascii?Q?cXHtm2F+wiyAZGFpNoJDpQafFBs2rnA7qG+NKj05ugT9OyKPknL3MQgHDQFK?=
 =?us-ascii?Q?ae5N3/srVGaKAus+ddDz4aL+3lm0DcZ2k/0r//hDzntmI6TkkIVuVW/cprQm?=
 =?us-ascii?Q?nXWRA64rZNID/vqg2+dNlq60iRv0oJI44h91kIPw0IXIrkXl5M/sPgB6dSEo?=
 =?us-ascii?Q?QH7SNYU8wp+NhNLbEmyuJIEYzoMCe/ZgT/RgZbVMY6gPXZoJHmM49f3aVI8D?=
 =?us-ascii?Q?pbt0+Lgj3txM6SKMjRgr9RpT1KCRA3j2Exox2Xvb7qpMDqru+cHO3Fm0NBCx?=
 =?us-ascii?Q?IfOEqPp046h64bXozOTvMpB8YxkUkCSVg5dVURjU32MbSbUF5BuQY4Z2mQLz?=
 =?us-ascii?Q?wPILIK0phOH4j3VjEjbGATUubazX0YGE2YBxj6b/43so5O5olus48acgPS6+?=
 =?us-ascii?Q?Vi0yd08zt6WxzFB1RgJBhG7WzbxEA9lCGViRqNWHjVnvq2NkqOEdFT1Wjmec?=
 =?us-ascii?Q?KBC2bZxAeqZHcTXC8lpGU1r9UZGgUsmLkEBwOqvC0H5BQvpPcKo5d77Aru7q?=
 =?us-ascii?Q?vL/DjX8W0xC5MX1k4m9DzD2fAB+Euvy0IqcMpB5e0/QrNCWGohD5AyE7HviP?=
 =?us-ascii?Q?OVInUHR0JERjQFr9dJXjfI6ViTmzcWqbHSIfKbNJs2bUIKgD779HfKwSdEh5?=
 =?us-ascii?Q?iIj93ittqfL4tOVEE3DIAVOZP6hniKi4z0JHCW5udXRf0Oq6vhZ3gAhaoj9k?=
 =?us-ascii?Q?Ys/oYn9dhglTRtYvK86V75LjZAqPySylLs5GOT2WKbnx1f3dzLWfA1ioYuVr?=
 =?us-ascii?Q?cnwPO1C1/twiYW9Z/jjRetFbGZdnQGkg/Z+LHo9xqZP6V+1J/sTiDl2xLtUg?=
 =?us-ascii?Q?uv7NszS+SQhsiBC1SqjHzRpb7LFq9wYiFsFpQusUVbxbpa/qbQmwQyyf1E4d?=
 =?us-ascii?Q?NB+vON6n/TaBEBKhq4p65uO/EHkIOkz6im2e0SPTmwqSgQ93+JLfd00CfU8r?=
 =?us-ascii?Q?d1BpetHGZDs0Fj6qTKtN34iGbl11Yrsxxf1NXZ9BUfGD4tSAVEqveav4Ddtj?=
 =?us-ascii?Q?kfXWRXU4hEHHZ2pVDjGNNTw=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 285bd236-0948-49e5-9563-08d9ec942d35
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 12:52:20.9780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CsVTY4WfI4RjaZQxmosnCerqYGYCA/doOqBY/WbrEwWFGPGiEqmAMR1rvyqQY8Agrgfk2CCWRDVt2li8qJHimw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8806
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make the intent of the code more clear by using the dedicated helper for
iterating over the ports of a switch.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index fab70fd305e2..be4f185442bd 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -6219,8 +6219,8 @@ static int mv88e6xxx_lag_sync_masks(struct dsa_switch *ds)
 	ivec = BIT(mv88e6xxx_num_ports(chip)) - 1;
 
 	/* Disable all masks for ports that _are_ members of a LAG. */
-	list_for_each_entry(dp, &ds->dst->ports, list) {
-		if (!dp->lag_dev || dp->ds != ds)
+	dsa_switch_for_each_port(dp, ds) {
+		if (!dp->lag_dev)
 			continue;
 
 		ivec &= ~BIT(dp->index);
-- 
2.25.1


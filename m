Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4055E4B8B7C
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 15:33:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235129AbiBPOdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 09:33:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235071AbiBPOdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 09:33:02 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2068.outbound.protection.outlook.com [40.107.20.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF38416BCEB
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 06:32:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DdsWYRm17prELVw64ZLUx+y5JDbJ+uXvcMVwE1j1sCQETfqlNSdMfJK8DY5RIOLOoeZS1eqGaONOk4URNgcwtyOnHQXprCnyIcJFj/UZ2dKlKV4ppax2zf3bXhtshwEDz1yj5G+hXg/8ZK6PuCpcH0Mfg3+2c6ViwiPz9RS7v3OZ+iWzh2XSgq3zyhfCD5EbVXwrCvu7zY2J8CiMvD49Enj4N+dcVnAV/0PzMM1DuXLGJ55HFxhqm+VgP0LtUfyAsg27BoIQ9CGM6U6zUGzryyS2DOMRn9yvQwEKpiYNYTaqXpBvC+7Zg56WhkiV2IYCxuyGzDI3Nfqwa5FKQV/LDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4nDmIdZcegE9nJ0Ji+Po+CbYx9l9LVv1yva4r4RRd8w=;
 b=aRBFIfv8CBKUXgp314CWGXmF5PcdajWbk3KYFWfwAm78fxvDbCsaL3NWsTPZrz0/rjN01KYYUhR0mYO6zk8kBuvKHWTA6WpkY6Jv4I24BF7z1/PCNp9t2d1oYH1AQMG2WKXMfpYBRalF5k+gubi1OKiruZlc/U3d2jxdFv53itwM0qHh5JXazIOWWAhFj4O3dzyuiGfcTRxrue7lnE6G6h8J5+jwh46XRdQAFz90EkI88aatubnsDmdb7UihVK9usU6D2XWWyaZyDTVlTW/EjGHh3v+urCPC5AqlFlRMBwkqSV+9UBK2fpLbypiW3UhVg3eAjgCcMkgcrTdz49ugRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4nDmIdZcegE9nJ0Ji+Po+CbYx9l9LVv1yva4r4RRd8w=;
 b=ZK9dBqp0h1sFHCEIgLU2t9KJfDAc4LDk91BsNPLz9lSLa4N8p8MIqMDnXvT87GSiFRcjU5hcdrBUnaFPqUgzydDuTEwDCq4KlVdOXyDIvHJcrmFvpMoYw0ukw/1WSqt9lP/mhov9qVcW9xfopu4eHS6lF8rHYd2q2R7JO4BeRkU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6815.eurprd04.prod.outlook.com (2603:10a6:803:130::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Wed, 16 Feb
 2022 14:32:44 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Wed, 16 Feb 2022
 14:32:44 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>, Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 07/11] net: mscc: ocelot: keep traps in a list
Date:   Wed, 16 Feb 2022 16:30:10 +0200
Message-Id: <20220216143014.2603461-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220216143014.2603461-1-vladimir.oltean@nxp.com>
References: <20220216143014.2603461-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0094.eurprd04.prod.outlook.com
 (2603:10a6:208:be::35) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6f516189-f180-407e-82e6-08d9f1593205
X-MS-TrafficTypeDiagnostic: VI1PR04MB6815:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB68155D46D659A1B7B25B7B4BE0359@VI1PR04MB6815.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zFmthdlqKff9IfWqsBTKvnQDRgU/XcBnuKuutq1MAJUCf4t6ewUjvwtx9/SuMeZbBI3GZObT0fSKQRRgX9MupmVS5k62tuQYJ3HBpQ8r83tGFvMVyWq5G8rJKQGYcRVp+puDErsKRaHCGjraC9qddBb7uRa4I5lj+yi05Mexrm4LYIHlgD18rLETIdT347Q7Nlqc/C1c79XjMlK1sPBcdSUGr1m8GQHS+1qNvTzGYy/DXVlMT7r1EdzmbYWdiqKZOzzXcMP0p5+ic2oEAUo3hzuTYHr0Ydj47PhyXL/gvNEbBQyDVDAD8C5OYGRxeBT2B0QRxsj7w53/g1uljOECAEtAoV834nlpuzDJ41Sf7Iyg4GEKSi8xJzbG5z1GY0G+I8JE6CZMfuX1kzC4krMEdi7rOeVmv5zuuzR2MBto6+qfjtWJatPmxtnVab2beHpEUoW3chiyBna59q/sOVYVI+cqQ2mZgojC/riyMFG7gtv92LwtyQ5lp0gSJOrHgEJf++Mjrdef+SYGXCKzz3cHOL4D8TVZRVjkJiBgLboXuVcwP8Np7COtdR07k7SSh857uckmoYxqANnNvaF2pHAfYsu7rzHxQr/8qt0P/Z1I8wMH/zcZAb/VfYDvCdbh4C/Nq5Ej8l1YY4rGH/39G/b1b5qJ8X7723bZ8Wx0fOZQFXesO6BhjaJ+BlNQVfQ8AOKsE1ImrJHPCo2f/baVOxuPaw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(54906003)(8936002)(36756003)(5660300002)(44832011)(26005)(6916009)(7416002)(316002)(83380400001)(2616005)(186003)(6512007)(1076003)(6666004)(52116002)(66946007)(38350700002)(38100700002)(4326008)(2906002)(8676002)(66556008)(66476007)(86362001)(508600001)(6486002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VLTv+3d3KYpEMVfuBM+KjTWVtsiy7K31Qt7tjlLdyVnMcQwEzOJIFL9dOhG2?=
 =?us-ascii?Q?MqjFWZihKh9kxzlrytrX4I59v3e47JVwxoCF6NmdaE/TQwOiKWHlW1JTDRDG?=
 =?us-ascii?Q?oCwVaBhc2OV99sEyIAKEaNK4L55hfRMYpvod0xmOnq75lO+hD/Z0rJRFjraT?=
 =?us-ascii?Q?N7O8+YvFgyJjC25xVTyi0t1aBqnyV2ePLL/dBJRr0sXC/XAzqrDO3NbrR/WK?=
 =?us-ascii?Q?pS/lV6A1TuWGeEtwuuvnq0khtMkVXSMvcjPgS/8E6MIskJrLmmyvHQy3eYFM?=
 =?us-ascii?Q?LIif3yCqSj2hMExdPsuvQmSjBoSDnXmwokue5m4bfS91vtHaoKFu8gSpZMBh?=
 =?us-ascii?Q?y0LYtuM1/3y+W9gN2D1w56J9hqTA7ZT9b/+o1a5q9EN36oP659/sg4ivLoKZ?=
 =?us-ascii?Q?yRGJnuLia01fs9gExfLyYHjVw/QMik2b6tbfc9eJmEBdcEF31GXKiaCLe46q?=
 =?us-ascii?Q?pSsGZJ/XxefdRUyFyPFqFvHpI1UFtvPUAlZAodtQzYdMDn5u8DvKTHRHL8++?=
 =?us-ascii?Q?fRDqxMRlTz+8EdWRAB75gYM8FaSZaqzoolazqvMrtnBxzc4sMA54yCfrlBbi?=
 =?us-ascii?Q?QsV87LKmQahlwVFIRHVaGHZUUeo600wvWAlfzMvYad7dmYGbxQMR3SlAHmlo?=
 =?us-ascii?Q?ILmbrHwfJW8HctwUF33br+tR+CzIyBZxMjUC0ibYmKvzN5j+dhF/v5bfo/Qt?=
 =?us-ascii?Q?4FhAVuj2rP5Z/U+JzPM4/gGJgiVtyxCV3OCKk5+0+Lz4DeOHf//BLyBDyTYB?=
 =?us-ascii?Q?GfeYOy8Rppg8yJQqanvoJVWUve2v85XyBvuwVGVduPxJ/hHy4Fu8Bi0pv3tl?=
 =?us-ascii?Q?MJqXR+HDodmVwR1NT/7kV56O7B0jBn0yI8O2Baifxvm71jLQ5vO6ftzoJqC1?=
 =?us-ascii?Q?79BRIKpMSsxetMVfKuZzvpAufiuBE70AYRzn+hu5br7FERITIZwwoOtaggtX?=
 =?us-ascii?Q?TdyfjSjTBnU6a7EdcXRTRkaUSGPWj/r/FgqET7t00kZjOHMv5vcIhq1J9cCF?=
 =?us-ascii?Q?sc7bWCc4Ee7jqwAlHDgATsU+Z08+nGg+02TLhqbcYDm/LKezzeJWN/3qqL8a?=
 =?us-ascii?Q?0XTQJxH3D2cshEhO8Jps0/VDnr5iq9WYGpwrC9E85xA3ksHn3hJpAJx5T1Lp?=
 =?us-ascii?Q?rOhsBu8nC3gkk1BD3MZrzdwD70jBb14f8jaQd6H08WMS6zEQ117iERV1hEY2?=
 =?us-ascii?Q?YzgmyVjK/SPjlAvEFsxqc1UQzU+ToniN25vkWpoJmiXCAR2thn2Uhn965gtY?=
 =?us-ascii?Q?EXf4I+lYLNU0vETTYBklwFE0jQHzZXTNLHgG0DriJebuFrpauDJ+LL7fNk/z?=
 =?us-ascii?Q?bNTRMK/exdtmLLDg06Kv/iZ4xpz+3wYLuC/yCyfKQ34/xkEnB5ZylnlVn8xF?=
 =?us-ascii?Q?182YSCym5E+SRHqk3rfI7RxMC5A4u6l43FIUAFFfVk4LlPvIMvEnIAynRSbO?=
 =?us-ascii?Q?3RJ/fRiqbyQetv1CIGoyMzg7WP1r8sHhdiR0Ldq3anKp7NRB8JZw2uhmm86q?=
 =?us-ascii?Q?UvwLz4rVLvz2w6tN/7wN/Q9UXz1xX99Joo4LdYlAagIELxfCOX8xUWk+hfC6?=
 =?us-ascii?Q?MKDS4KZ89OkdpSCH1Cfd2U+RxMg2OGCfwpVQwDPyUMDtofikImwI2LR6mLbx?=
 =?us-ascii?Q?G644JxSyKdYAKH1XTs0UPtA=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f516189-f180-407e-82e6-08d9f1593205
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 14:32:44.4491
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WX97COTtTev6xwMCsZ1ZuxROH2bvldD2XLv0Q6r4zLAVd3s/wAuDhbF3NjFKbSe7ZoTvv/SnBYyQGX9eoVtsBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6815
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When using the ocelot-8021q tagging protocol, the CPU port isn't
configured as an NPI port, but is a regular port. So a "trap to CPU"
operation is actually a "redirect" operation. So DSA needs to set up the
trapping action one way or another, depending on the tagging protocol in
use.

To ease DSA's work of modifying the action, keep all currently installed
traps in a list, so that DSA can live-patch them when the tagging
protocol changes.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c        | 10 ++++++++--
 drivers/net/ethernet/mscc/ocelot_flower.c |  3 +++
 drivers/net/ethernet/mscc/ocelot_vcap.c   |  1 +
 include/soc/mscc/ocelot.h                 |  1 +
 include/soc/mscc/ocelot_vcap.h            |  1 +
 5 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 850ded118d86..049fa1e6d5ff 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1499,6 +1499,7 @@ int ocelot_trap_add(struct ocelot *ocelot, int port, unsigned long cookie,
 		trap->action.cpu_copy_ena = true;
 		trap->action.mask_mode = OCELOT_MASK_MODE_PERMIT_DENY;
 		trap->action.port_mask = 0;
+		list_add_tail(&trap->trap_list, &ocelot->traps);
 		new = true;
 	}
 
@@ -1510,8 +1511,10 @@ int ocelot_trap_add(struct ocelot *ocelot, int port, unsigned long cookie,
 		err = ocelot_vcap_filter_replace(ocelot, trap);
 	if (err) {
 		trap->ingress_port_mask &= ~BIT(port);
-		if (!trap->ingress_port_mask)
+		if (!trap->ingress_port_mask) {
+			list_del(&trap->trap_list);
 			kfree(trap);
+		}
 		return err;
 	}
 
@@ -1531,8 +1534,11 @@ int ocelot_trap_del(struct ocelot *ocelot, int port, unsigned long cookie)
 		return 0;
 
 	trap->ingress_port_mask &= ~BIT(port);
-	if (!trap->ingress_port_mask)
+	if (!trap->ingress_port_mask) {
+		list_del(&trap->trap_list);
+
 		return ocelot_vcap_filter_del(ocelot, trap);
+	}
 
 	return ocelot_vcap_filter_replace(ocelot, trap);
 }
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 949858891973..7106137f98ee 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -279,6 +279,7 @@ static int ocelot_flower_parse_action(struct ocelot *ocelot, int port,
 			filter->action.cpu_copy_ena = true;
 			filter->action.cpu_qu_num = 0;
 			filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
+			list_add_tail(&filter->trap_list, &ocelot->traps);
 			break;
 		case FLOW_ACTION_POLICE:
 			if (filter->block_id == PSFP_BLOCK_ID) {
@@ -840,6 +841,8 @@ int ocelot_cls_flower_replace(struct ocelot *ocelot, int port,
 
 	ret = ocelot_flower_parse(ocelot, port, ingress, f, filter);
 	if (ret) {
+		if (!list_empty(&filter->trap_list))
+			list_del(&filter->trap_list);
 		kfree(filter);
 		return ret;
 	}
diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index d3544413a8a4..852054da9db9 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -1401,6 +1401,7 @@ int ocelot_vcap_init(struct ocelot *ocelot)
 	}
 
 	INIT_LIST_HEAD(&ocelot->dummy_rules);
+	INIT_LIST_HEAD(&ocelot->traps);
 	INIT_LIST_HEAD(&ocelot->vcap_pol.pol_list);
 
 	return 0;
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 2d7456c0e77d..78f56502bc09 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -689,6 +689,7 @@ struct ocelot {
 	u8				base_mac[ETH_ALEN];
 
 	struct list_head		vlans;
+	struct list_head		traps;
 
 	/* Switches like VSC9959 have flooding per traffic class */
 	int				num_flooding_pgids;
diff --git a/include/soc/mscc/ocelot_vcap.h b/include/soc/mscc/ocelot_vcap.h
index ae0eec7f5dd2..69b3d880302d 100644
--- a/include/soc/mscc/ocelot_vcap.h
+++ b/include/soc/mscc/ocelot_vcap.h
@@ -682,6 +682,7 @@ struct ocelot_vcap_id {
 
 struct ocelot_vcap_filter {
 	struct list_head list;
+	struct list_head trap_list;
 
 	enum ocelot_vcap_filter_type type;
 	int block_id;
-- 
2.25.1


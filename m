Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32132565DB2
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 21:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234028AbiGDTDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 15:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiGDTDH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 15:03:07 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60059.outbound.protection.outlook.com [40.107.6.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 091B46471;
        Mon,  4 Jul 2022 12:03:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C8nE4kHyg7Y8GZxSC/wXPu++r5/VDpajboHFTANMWevNj4kYLg5PccEKo6C99jyVLaj19+0/sZcuCjj2tKkSFyL1o/LPw3MvN+WL4LskgOkMoqgA54smC7lFsIAJfzMmFoItf9THmnUoIo5jw+Fstdod4GHzxrdGkJI9PaoeBgNkkMF5tWJ5ydWBn1R9rat5EqBQwJoc4WAJAf1CRkRwN6RhBg8xhQDBWvS3j1SQzm1Oxyo69Io41KEPU7ohBXdkicBJktasst0Laq5NVQAc8JKS51hsuQlQKIt/JwjC4bnBau+NmIaYCgSnLjISL2rfPOBGOvryeO3c1cV1FDmANA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=segmNNjJPcKSKfDQNEd7+1fcdg25B01imJzDChAIt9Y=;
 b=QiOW4WdIoFdTyJY+XcxwdGegAYx4Kv++6C5IqLVSVl03IlnIGhGsIlausxRf0TEjn4r8yUjyBdWIwdOwa/nTs3h27pZA7FTWXa5w5KImCDjklHS+zUdknJW8YYPegFSbAv8MmL8ycZPjdhmQ4LC4bCYH1RfOAp14opnVesnt5U+rUt1fmsCa5VIWrWgVzqIQozHcN6Le9SUxVnRzcydJI1Xcm/AbUxsEmeUsXgPqpnw0fqJaUErYMNeIVCZiPtqovG/yhgC+TgrV6/Ia/KC29RvJ68Oo/XPpO7O0ME8UDhgkVElxCgeQilXCUgpiTSY/4GwAykRh03tRalGbotfrEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=segmNNjJPcKSKfDQNEd7+1fcdg25B01imJzDChAIt9Y=;
 b=HaLYSTwbN1/Q7bv5T/0eb5D9EY4xR6M8UXlggEGqVEoQnbHxJXuhqJ1Ge1m7nJlSc6DuPkdJ5E0Zy5C2Ifu+Q/+B1P0z/o9lzvBDpqdL7Vy6v4oNr6UgLoCvRnNm/SCsgx15Cmci3cQ2rqgLKOofCR8BwGKTiInk1dil4+J+kdc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM5PR0401MB2483.eurprd04.prod.outlook.com (2603:10a6:203:35::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.21; Mon, 4 Jul
 2022 19:03:04 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5395.019; Mon, 4 Jul 2022
 19:02:58 +0000
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
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/2] net: sched: provide shim definitions for taprio_offload_{get,free}
Date:   Mon,  4 Jul 2022 22:02:40 +0300
Message-Id: <20220704190241.1288847-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P18901CA0023.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:801::33) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e4b5e65c-a6c8-4e89-1824-08da5defcf42
X-MS-TrafficTypeDiagnostic: AM5PR0401MB2483:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XqvyVK2xY31ORh/p3IyGfgvXkzs9vTcwjHQFIWiWsJQDxDBReH3oHDZsym7/sMmlOwi7IKARillVUTTghOo14wDf7Mgg1j8WPOVL5MrW6M+9/Wzm/uldnMKh9pa7B4QcmqUbx6fMHIxg6hcofNDxOgoUL7HibTyquSwaFKd4fqCEJoMtvfa0+DPOfz1whUhyXu5NGgbdTdVPP9Mk8IWi3aHGeeuO3OlxZQHnrg7txRxEDLeUpTRqEhak+K3v2UtQFH4K308pmF6fPbjAN3N4x8P3TPlG+wC2mznYpbNSJYpZRplCuzlKZ64hMWorfrsFj3sPTBkTEJbL+hvOkUJUHBA4H2xEfD+NVc7hF9fxGSzY5vTuDOgKO5UL3B9oBeQRf+lVu6/0nEt6iUaul91vS4Cx8hdVSABq98PQvo45PsBggPh4VaI79J6VKq8eTtgM/rVrSPU/utBrx/mpwvUHB5Yq1c34RY8rVVghSAnrYP/MrPk1pr+kGDVcbnkTklRJ2As4yiijJPVdExamjdxdHGR3KDmwg9sPYH1YjjGHwDbZSWOAyY8U+coesIO0oxhRRgsKXzLRBJSProJvX/3+Ob9NFUIMWBX9vctxNHOAIECN39nBgnkkAq/OQcyHd1VDWNhSCNZiWuLAbwY9KI1xSIS5dXhwKXEjMkeJlDGlDkYgtaUVD0Q327o8LwGyan9Df6BmARGskA4N7MGYj4elPb0UsAA/T0UJH4GvGXg92awxHFRfe2LIWI1OBRXiZfNJEQSIuSQVP5kfAbOyajOR2Dck7UwnTPOlXuTsapqERRXgG+14TIoYgL+XV6myG8gb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(39860400002)(396003)(376002)(346002)(316002)(38350700002)(38100700002)(44832011)(7416002)(36756003)(54906003)(6916009)(6512007)(26005)(2906002)(41300700001)(6486002)(8676002)(4326008)(186003)(66476007)(66946007)(66556008)(5660300002)(8936002)(52116002)(478600001)(2616005)(1076003)(6666004)(6506007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4DiNUU6/eUYgzindNOEvLNyvjd8zCEwfw6u6RU69Szi5vUdGeUUFq/gNdk+1?=
 =?us-ascii?Q?qanO6x+vbxG0WwV2yOrKFt6io9LIj3kg2zx83uu2nwy439AsKDqQHgzviceE?=
 =?us-ascii?Q?cXJ+DzqWmrJLsXm5IdeK1ISn0FB2Y/PqpMZqmmpscT8JjtB248e9Hi4YxiHs?=
 =?us-ascii?Q?SyNUuM5J8Y55hmMHZX8lX/y8Q74DkPIzxkGE71geDOiz8GtU41erm0WOvfa4?=
 =?us-ascii?Q?c/gaWDAGnAzP4JySkrHfOJYxIX9h66qLdM0gizPgIJSH4dcn9zytgBiREOWk?=
 =?us-ascii?Q?4Um2WitK2Yy4NSHwImnKnT8cC8cNRLOAZY0tFL1wvwD5s4wBTYV5FeVWdcHm?=
 =?us-ascii?Q?IOEIw0UfBvXoQQ+vM2U20FrFv2cbRRyNOhusTEV3mrqNGJQ+w+1gY5Ei72nL?=
 =?us-ascii?Q?gjU4+ST2cIobocOmhbg7GERyJhPOTItpCYwRrS/wD18jziur0bnj9Lem5GgD?=
 =?us-ascii?Q?rkZOQH1L/KmkTRrQ9R/lxw2ziDRH1e3VpQFu2jbmCeW5KLXqvXDwZLZRIiYp?=
 =?us-ascii?Q?tcRSFZ7sD/+e99NBPKZkhKSo+6RmO6B0eO4gAtH2/+7vEXgoreQBJDKxV5Z2?=
 =?us-ascii?Q?T1TU32zfiOOtWNKEPtFKa7kwOX+GbQZRTgBLU/bNPmSlDdAO7kQtLfFMSUmT?=
 =?us-ascii?Q?q0ZFbbJiNtn6myiWpvPCyZ0tG0C9hRzRW/kFZwVmb2SepGa77eeLtXYqE11i?=
 =?us-ascii?Q?BWKcNa3w78ngVvXMTpTJIkhF74oqnmDV8t0TfASVt4P5ubUpnwtg3OXzhsXh?=
 =?us-ascii?Q?7jln4yRs7McMLxlc/C+bOmsghJCRYn6ITiFgc7vhPX3QvetkBu3d224p80xa?=
 =?us-ascii?Q?5K+esDhN2I1baGwj0zSo6LpP/mV/H2nNb3OepuEBWiYexWtws3zNgQw5ejmo?=
 =?us-ascii?Q?5jeej4XuLggBBND/iFMmkk1e7hHHxwEjnHrSdtz4MPedTMt7iPZDtV0Mf9n/?=
 =?us-ascii?Q?iDw87b3rM4LQ9URqwXEpHOjUiOfcz8jDHGy5JX1eMqgzBL+kOxxrKRSwxdQB?=
 =?us-ascii?Q?zP2Q5/Gb3E/GrSTKHSwtX8a0aNuhrK8AaJyQvriiSHjpjVUpl3bCfWivayoW?=
 =?us-ascii?Q?z9t/DhGa5/Ep+/0AHkYMm7vhVfFhkqFsjr5tcP2vr0ZPi3s7blbiexHNIjE9?=
 =?us-ascii?Q?mfXZSyABwtflPWrT3PEPSY0yAwXABWYyujDr/hOp8WsuGneXdZcign8GMMKq?=
 =?us-ascii?Q?Ax4CluxLsi6GnL9r/2/83zekkiksBHg6Ex/KZ+bS6mjrbgb+6cRkFX5uHTHn?=
 =?us-ascii?Q?xUc+NAr3QD+MP9CKdkHttwjnNtA2DSHa9lcoMXZ6e9ZMJFb7hDvZZ0np6qHY?=
 =?us-ascii?Q?Da7dAxrI7yPZMrdztvGcTGrihCP/iHoFpOgINZbiUNXLcbU6GczIErX5mtgr?=
 =?us-ascii?Q?tmNsCAM6wdUBPPWE1zwja2EvN8SchPdvq+xGKZy9Q0Uk7k8CxbR9Kt8hT4V3?=
 =?us-ascii?Q?or8X6Mrn8Hltmq39KoNE0+tD9zBeCKAsjhMlG9+i6a0c19nLsV3NmVSo0R1m?=
 =?us-ascii?Q?Hvwv7bjZ6095H3vo1v/6aLrk7BYfpxIDEm9PU6Y7VnhVZgSBEmXsS1RM6UOF?=
 =?us-ascii?Q?qI/1Est7DwrJ+Im5D8U3IC0M+X9l2w64qWQ3AGpOTU30Gw9ek2GH1caFSkaa?=
 =?us-ascii?Q?tw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4b5e65c-a6c8-4e89-1824-08da5defcf42
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2022 19:02:58.4316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vh4ozCWLjEkgQWQn4qxkyXWqJeenQWltc5D9SKC/hdYreedtawH9vLpzbAaUizXTVoJr7+puECDV/90mghH6Pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0401MB2483
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All callers of taprio_offload_get() and taprio_offload_free() prior to
the blamed commit are conditionally compiled based on CONFIG_NET_SCH_TAPRIO.

felix_vsc9959.c is different; it provides vsc9959_qos_port_tas_set()
even when taprio is compiled out.

Provide shim definitions for the functions exported by taprio so that
felix_vsc9959.c is able to compile. vsc9959_qos_port_tas_set() in that
case is dead code anyway, and ocelot_port->taprio remains NULL, which is
fine for the rest of the logic.

Fixes: 1c9017e44af2 ("net: dsa: felix: keep reference on entire tc-taprio config")
Reported-by: Colin Foster <colin.foster@in-advantage.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/pkt_sched.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 44a35531952e..3372a1f67cf4 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -173,11 +173,28 @@ struct tc_taprio_qopt_offload {
 	struct tc_taprio_sched_entry entries[];
 };
 
+#if IS_ENABLED(CONFIG_NET_SCH_TAPRIO)
+
 /* Reference counting */
 struct tc_taprio_qopt_offload *taprio_offload_get(struct tc_taprio_qopt_offload
 						  *offload);
 void taprio_offload_free(struct tc_taprio_qopt_offload *offload);
 
+#else
+
+/* Reference counting */
+static inline struct tc_taprio_qopt_offload *
+taprio_offload_get(struct tc_taprio_qopt_offload *offload)
+{
+	return NULL;
+}
+
+static inline void taprio_offload_free(struct tc_taprio_qopt_offload *offload)
+{
+}
+
+#endif
+
 /* Ensure skb_mstamp_ns, which might have been populated with the txtime, is
  * not mistaken for a software timestamp, because this will otherwise prevent
  * the dispatch of hardware timestamps to the socket.
-- 
2.25.1


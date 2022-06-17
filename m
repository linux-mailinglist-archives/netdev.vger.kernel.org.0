Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2C5754F524
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 12:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381764AbiFQKPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 06:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381770AbiFQKPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 06:15:46 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2130.outbound.protection.outlook.com [40.107.20.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F656A07C;
        Fri, 17 Jun 2022 03:15:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ki8dqTvqBAdGyj692Gd6JPO9xLqZEqRMs2g9qPVTohbY68rKnK4FLDIGmRE/VtDn9iWDzvq7yTNT0WJDtHjxMGT+kaCqVxQvW7e1Z6dHB8y5Ox+V8K2E7F0mtPBwxMKUaCGvYtAanHgEYjzQ4dIF6WPvouUo0Zle3Q4vWvQaDpqNoJSd+ZOemxfBrGWfauC7FwwDfNDTGaiQnDBMx2yHqjCwyQfP8Ap6GRL0+xgm2HbhHbwoqIfxOcVOs4d7gDpf/mtJzL/kxGYNroeV/fFAMTcb21l7Pgj4swVPXQV7OkQyKDnl1ggxkzgQj/NXq4TzPa4y/NRArkBu0V9ZNqh6nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lTu4mTM8O2MibjA6IeokDKsHzqwnh998IisC4pfR4Rc=;
 b=G6IwdM/xU0uBwv3FHxI1tQfYuVzNYFCFSkktAEr6DMsUwR+JS1TXRAfi5qcaLiuFdxkMNiQDmBCzHS5xR+Q3IqTL8Cg5GmSaayB1/JpP+Toi8r2U83IbCUVqElPEn0XakTcQbrzDNNQRfM0v8+yBBHHFzrrex/XhKLjFgvSi7NdwWeFaApSIcToO4RggFM7WvQYM6sIosF7sc4Ndkjxrtmg8L/Mb2jJMmWZu0MdCm8A2b5QIt/oo6HawlE/u/VDyf+FaIJmohhBhMTXD12qCP+sf1Fj5HLVX+gsUQiGOJfeOfGs7I75nVMckrbLS1G37ytJDH7jKXqL5hyxf8h9MfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lTu4mTM8O2MibjA6IeokDKsHzqwnh998IisC4pfR4Rc=;
 b=WiOwyRKI4YEWPiU5TUFyw96GLiTC4Rn9+pGnG7F2PQndqcmFP2GSR734AOLAtuIIwNKE5DVXoIUN4Oew4qjYktL7SWYTEKWxWSs0oMHbbCkOQ/XAc+0Im5oSzkqeCPDdjzeqPd1TDlStS+5pPmONgyXZqKS7Z64joalqGQBkIvw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:5b::20)
 by AM5P190MB0244.EURP190.PROD.OUTLOOK.COM (2603:10a6:206:17::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Fri, 17 Jun
 2022 10:15:40 +0000
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::25a3:3edc:9320:f35e]) by GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::25a3:3edc:9320:f35e%3]) with mapi id 15.20.5353.016; Fri, 17 Jun 2022
 10:15:40 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     netdev@vger.kernel.org, Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Cc:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>
Subject: [PATCH V2 net-next 4/4] net: marvell: prestera: implement software MDB entries allocation
Date:   Fri, 17 Jun 2022 13:15:20 +0300
Message-Id: <20220617101520.19794-5-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220617101520.19794-1-oleksandr.mazur@plvision.eu>
References: <20220617101520.19794-1-oleksandr.mazur@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: BEXP281CA0005.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::15)
 To GV1P190MB2019.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:5b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 23d876a0-630c-4d40-eb88-08da504a543d
X-MS-TrafficTypeDiagnostic: AM5P190MB0244:EE_
X-Microsoft-Antispam-PRVS: <AM5P190MB02443E3F78CDB1E8B6EE92FEE4AF9@AM5P190MB0244.EURP190.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wD5Il0IP473JetZAVgwOpwF/2UmJguHJ1WYQg4gb+VEAaoiCwioOHRXQwBzZLnPaPSlbhtxHX8ujJXNHaIwsvIkf4qL7mB+X2ORvtK5s4N8l4MzFouu7fa6Bxg9xvSKIsq9qlG4iFIEKiGv7aK1k6ZzhRy2Omkj7P4yFNwGd0jyKCbIWQkUfq7a5RW3+Fvv9MeUSG+kAJswY2jdyCjZIXPkh1v6r1gss4GDtO5r9MHVcTs8s4B8nI1JJibCpryR4NJJ5RDjFYC7ySfoQXoVyA2CU+eOFGe8vt6xBAGVqplyOCcSV7Vk504WjjHJbRDjP2Qv48Wk7IN6YB4kgofPC9MpLBN9sQKxYOEd1fjdqHRBvwtAPK0CiS5bWYyLqjxK28oI7kFY2K+OKUMPLgp3wMnLbXwnV8FqnfTgwM7sTYdvEuDbm4bQC/03tF6ihHD6Gw9P2lX9q49cQwXFARYpwsoHVj2W/KzWQHXt/wnBpFRHjqJkysRvwv1HGIE7Bp1qkA6RlvZLusNillYR6LffmXISqsOlpWYWWidWBdw1OTJ0dJSaXp1aUQQQY80wghGR1IRAhlTF0Bypq27i0pKoxnsuFc91SP3x2k2SlhNvGHxVnXS+8P3WQj6zCt/Leh8ymiN/Ou23Z62BtwxHLDYY+IRuZE2Tj9biBTBiwLm9ZlKKpQuhnovJ7HL3us2DY4B1KfFv7cH2VIsW+RUaSN1uPpQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1P190MB2019.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(136003)(39830400003)(366004)(2906002)(44832011)(6666004)(8936002)(8676002)(4326008)(66574015)(5660300002)(66556008)(30864003)(6486002)(6506007)(36756003)(66476007)(66946007)(54906003)(110136005)(6512007)(52116002)(316002)(508600001)(26005)(1076003)(107886003)(86362001)(83380400001)(186003)(41300700001)(2616005)(38100700002)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q1f4VrcZXZljkw11bw9JxkGcL/KB/yvPES3VYTNNAG66EA8+GHQaEyv2+Lnb?=
 =?us-ascii?Q?/09NxYEc23lc3q3XUSLrpFOyhvpcqTrtOn34+NbLOLnO6vva0C2eSZd98GjZ?=
 =?us-ascii?Q?s4ELSCmx3YvH00+10/PEt0Y/tRkTQ6zODo8y7DLSiDre1U3fz/gH1haad9oV?=
 =?us-ascii?Q?o5StAx3nSaRqOzlleEtdxBfzAzprP93e8VH9VsTYgULEdOJBeKuZx8Yq8UAm?=
 =?us-ascii?Q?4a6JG7N4g4OtaEsZvEGT6LlYeCfoxtbeZCiXxNhQ8yxaXHyRsiRUKZiM7CcT?=
 =?us-ascii?Q?ZwS4m3YOBeOKknDbb6UDfaNj9uXa+K3XZYhTJWbIwTpPUO+NI5Y3dxdmjIFh?=
 =?us-ascii?Q?5yjUPCWpa4tb229BdQzqedWTfXvT8nIbnK+U13I2fpn4/kyCWApxKVlBgTuo?=
 =?us-ascii?Q?cOEGGN7Z0M1aAWXGg2D8sz/4MMnSG4X3zwPMnF4Zs2RrokR/sm4Lv5e+ZGnB?=
 =?us-ascii?Q?FEhoqCDZTByhCbho4vsb8qKDGucD4tZkLgkzZZCgWF1MPnha61KXd8BjWIWe?=
 =?us-ascii?Q?DLcsWH9T04sgIiZSo1T1lEN6lklgNmdFG7kmjfXapCWq8HZnTHdjBegXP4e5?=
 =?us-ascii?Q?l/1d9DU7tVMxrBARDQ+fXgs4UQaWEKpBYkK9ddgGssUp014C7+IqS6tr9eSs?=
 =?us-ascii?Q?r0YQlCf73RPysakgCqjvHcFRKbjsnFJa2ysM0K3B7HaFppk0fS7KMM5HRWgn?=
 =?us-ascii?Q?valU3+qRSWMTyJaXgRAtpBMrYfbYJv523NJArxYAmi6kkSDnxWcFM6HvIHir?=
 =?us-ascii?Q?xjknZX5dFikBIGNh9sGnmi3atsdZgs92ZFjy1C4KAdg5i3wR/T/ORM6i7vf1?=
 =?us-ascii?Q?6yYYIrugUuK1RaVzQB/E3QO3wq8cVuXIuQPEDul3UKNdutWDNZh8MlwOvsQB?=
 =?us-ascii?Q?m8l0L/9sRgkF3+AzMiBwxAnc7mfKp5MfA2lwVQArjCITaP1uZszYcFA9ZVKy?=
 =?us-ascii?Q?QIKnyCV/+LezV3P1Shc5Kb8fTaVDz0vjTUEjjS7gwmv2DWPWUKCJKPPm38cM?=
 =?us-ascii?Q?JrPvHPxfZFyCk/URQNFVWHdY2Ic3Qt/SJOGpcRpgHaQIhamalNe8g+T0zd/+?=
 =?us-ascii?Q?6BoDapFZXwkD7SGif+1uJx0F+WqBBaSSGST+IHeAM+sCqFRwcWSTgupaq7JZ?=
 =?us-ascii?Q?0gfbYCYmYUICkoNrVoe/4zTFbjwE6GjjszhPQvHeYQb+0D+BxyQyhlKhuGFw?=
 =?us-ascii?Q?ZO3SPJF/yvu541ReROk/RF1Ykotc9AK7HA84WQXqsn5tgDRlmwjb2uiLhEzy?=
 =?us-ascii?Q?dMO0jxv0YTuAIRvCGW+VVAirdfyXGpLWdseRyMMab3BbuDG+70p4e0ISw0Gw?=
 =?us-ascii?Q?P8PIaZW847ZTu5h25EvlRB/mDG393Kf5FpKpqu+hokQqkWT2wCYJ+BZvDHl1?=
 =?us-ascii?Q?WhwGNfAI5ywsECejY5cBzvJXR1RJsEsMq2fRetFpMa2BuN1coRWEqJpVJRtN?=
 =?us-ascii?Q?rGWoojb6MNoVIk2fdDvETuh8MRFogztl5lBiK55Vbfi/XGJgSyNyorsAaV0r?=
 =?us-ascii?Q?dG+ZHNsewgc26xgWHd3Qj7/J8c5f7UrBqlvviAPj3ER889Zvm/hXxfClFLN/?=
 =?us-ascii?Q?VesybA3GpthtMxOHe3fwSN3+uRC5TEFcbxwqWltp3M5rh4J0LlMputrzsGsC?=
 =?us-ascii?Q?bDchVH5SfEbgNqjO0gSu3wTH1csggLBZgucssvqC/wixrS9CTUUKA4aAXJ3m?=
 =?us-ascii?Q?StqUb0OZZjxoCuA6ZPuQnyk7nGKnhvNlgaco0fuvd8MK8g9YEGzSSrXp3Rxa?=
 =?us-ascii?Q?8y6bGkJzcup15Uyr08syEOsnC6nD7f0=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 23d876a0-630c-4d40-eb88-08da504a543d
X-MS-Exchange-CrossTenant-AuthSource: GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 10:15:39.9211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e1usAB51u7ymjaxk+l8C9Lz+GhfUSBBIvh7zmzj2gu5MVdYVTHskm7Sbb11pb8HOAoxaAovgWv/rqidu1OJN6XPeAE3vngCXp9DDSFCWXU4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5P190MB0244
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define bridge MDB entry (software entry):
  - entry that get's created upon receiving MDB management events
    (create/delete), that inherently defines a software entry,
    which can be enabled (offloaded to the HW) or disabled (removed
    from HW).
    This separation is done to achieve a better highlevel
    management of HW resources - software MDB entry could exist,
    while it's not necessarily should be configured on the HW.
    For example: by default, the Linux behavior would not replicate
    multicast traffic to multicast group members if there's no
    active multicast router and thus - no actual multicast traffic
    can be received/sent. So, until multicast router appears on the
    system no HW configuration should be applied, although SW MDB entries
    should be tracked.
    Another example would be altering state of 'multicast enabled' on
    the bridge: MC_DISABLED should invoke disabling / clearing multicast
    groups of specified bridge on the HW, yet upon receiving 'multicast
    enabled' event, driver should reconfigure any existing software MDB
    groups on the HW.
    Keeping track of software MDB entries in such way makes it possible
    to properly react on such events.
Define bridge MDB port entry (software entry):
  - entry that helps keeping track (on software - driver - level) of which
    bridge mebemer interface joined any give MDB group;

Co-developed-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
 .../net/ethernet/marvell/prestera/prestera.h  |   2 +
 .../ethernet/marvell/prestera/prestera_main.c |   8 +
 .../marvell/prestera/prestera_switchdev.c     | 651 +++++++++++++++++-
 3 files changed, 659 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index 9b109ae563d1..60dbee2832dd 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -340,6 +340,8 @@ void prestera_router_fini(struct prestera_switch *sw);
 
 struct prestera_port *prestera_find_port(struct prestera_switch *sw, u32 id);
 
+struct prestera_switch *prestera_switch_get(struct net_device *dev);
+
 int prestera_port_cfg_mac_read(struct prestera_port *port,
 			       struct prestera_port_mac_config *cfg);
 
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 04abff9b049d..ea5bd5069826 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -106,6 +106,14 @@ struct prestera_port *prestera_find_port(struct prestera_switch *sw, u32 id)
 	return port;
 }
 
+struct prestera_switch *prestera_switch_get(struct net_device *dev)
+{
+	struct prestera_port *port;
+
+	port = prestera_port_dev_lower_find(dev);
+	return port ? port->sw : NULL;
+}
+
 int prestera_port_cfg_mac_read(struct prestera_port *port,
 			       struct prestera_port_mac_config *cfg)
 {
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
index 7002c35526d2..cc647a5ddb30 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
@@ -39,7 +39,10 @@ struct prestera_bridge {
 	struct net_device *dev;
 	struct prestera_switchdev *swdev;
 	struct list_head port_list;
+	struct list_head br_mdb_entry_list;
+	bool mrouter_exist;
 	bool vlan_enabled;
+	bool multicast_enabled;
 	u16 bridge_id;
 };
 
@@ -48,8 +51,10 @@ struct prestera_bridge_port {
 	struct net_device *dev;
 	struct prestera_bridge *bridge;
 	struct list_head vlan_list;
+	struct list_head br_mdb_port_list;
 	refcount_t ref_count;
 	unsigned long flags;
+	bool mrouter;
 	u8 stp_state;
 };
 
@@ -67,6 +72,43 @@ struct prestera_port_vlan {
 	u16 vid;
 };
 
+struct prestera_br_mdb_port {
+	struct prestera_bridge_port *br_port;
+	struct list_head br_mdb_port_node;
+};
+
+/* Software representation of MDB table. */
+struct prestera_br_mdb_entry {
+	struct prestera_bridge *bridge;
+	struct prestera_mdb_entry *mdb;
+	struct list_head br_mdb_port_list;
+	struct list_head br_mdb_entry_node;
+	bool enabled;
+};
+
+static int
+prestera_mdb_port_addr_obj_add(const struct switchdev_obj_port_mdb *mdb);
+static int
+prestera_mdb_port_addr_obj_del(struct prestera_port *port,
+			       const struct switchdev_obj_port_mdb *mdb);
+
+static void
+prestera_mdb_flush_bridge_port(struct prestera_bridge_port *br_port);
+static int
+prestera_mdb_port_add(struct prestera_mdb_entry *br_mdb,
+		      struct net_device *orig_dev,
+		      const unsigned char addr[ETH_ALEN], u16 vid);
+
+static void
+prestera_br_mdb_entry_put(struct prestera_br_mdb_entry *br_mdb_entry);
+static int prestera_br_mdb_mc_enable_sync(struct prestera_bridge *br_dev);
+static int prestera_br_mdb_sync(struct prestera_bridge *br_dev);
+static int prestera_br_mdb_port_add(struct prestera_br_mdb_entry *br_mdb,
+				    struct prestera_bridge_port *br_port);
+static void
+prestera_mdb_port_del(struct prestera_mdb_entry *mdb,
+		      struct net_device *orig_dev);
+
 static struct workqueue_struct *swdev_wq;
 
 static void prestera_bridge_port_put(struct prestera_bridge_port *br_port);
@@ -74,6 +116,49 @@ static void prestera_bridge_port_put(struct prestera_bridge_port *br_port);
 static int prestera_port_vid_stp_set(struct prestera_port *port, u16 vid,
 				     u8 state);
 
+static struct prestera_bridge *
+prestera_bridge_find(const struct prestera_switch *sw,
+		     const struct net_device *br_dev)
+{
+	struct prestera_bridge *bridge;
+
+	list_for_each_entry(bridge, &sw->swdev->bridge_list, head)
+		if (bridge->dev == br_dev)
+			return bridge;
+
+	return NULL;
+}
+
+static struct prestera_bridge_port *
+__prestera_bridge_port_find(const struct prestera_bridge *bridge,
+			    const struct net_device *brport_dev)
+{
+	struct prestera_bridge_port *br_port;
+
+	list_for_each_entry(br_port, &bridge->port_list, head)
+		if (br_port->dev == brport_dev)
+			return br_port;
+
+	return NULL;
+}
+
+static struct prestera_bridge_port *
+prestera_bridge_port_find(struct prestera_switch *sw,
+			  struct net_device *brport_dev)
+{
+	struct net_device *br_dev = netdev_master_upper_dev_get(brport_dev);
+	struct prestera_bridge *bridge;
+
+	if (!br_dev)
+		return NULL;
+
+	bridge = prestera_bridge_find(sw, br_dev);
+	if (!bridge)
+		return NULL;
+
+	return __prestera_bridge_port_find(bridge, brport_dev);
+}
+
 static void
 prestera_br_port_flags_reset(struct prestera_bridge_port *br_port,
 			     struct prestera_port *port)
@@ -277,6 +362,8 @@ prestera_port_vlan_bridge_leave(struct prestera_port_vlan *port_vlan)
 	else
 		prestera_fdb_flush_port_vlan(port, vid, fdb_flush_mode);
 
+	prestera_mdb_flush_bridge_port(br_port);
+
 	list_del(&port_vlan->br_vlan_head);
 	prestera_bridge_vlan_put(br_vlan);
 	prestera_bridge_port_put(br_port);
@@ -328,8 +415,10 @@ prestera_bridge_create(struct prestera_switchdev *swdev, struct net_device *dev)
 	bridge->vlan_enabled = vlan_enabled;
 	bridge->swdev = swdev;
 	bridge->dev = dev;
+	bridge->multicast_enabled = br_multicast_enabled(dev);
 
 	INIT_LIST_HEAD(&bridge->port_list);
+	INIT_LIST_HEAD(&bridge->br_mdb_entry_list);
 
 	list_add(&bridge->head, &swdev->bridge_list);
 
@@ -347,6 +436,7 @@ static void prestera_bridge_destroy(struct prestera_bridge *bridge)
 	else
 		prestera_hw_bridge_delete(swdev->sw, bridge->bridge_id);
 
+	WARN_ON(!list_empty(&bridge->br_mdb_entry_list));
 	WARN_ON(!list_empty(&bridge->port_list));
 	kfree(bridge);
 }
@@ -438,6 +528,7 @@ prestera_bridge_port_create(struct prestera_bridge *bridge,
 
 	INIT_LIST_HEAD(&br_port->vlan_list);
 	list_add(&br_port->head, &bridge->port_list);
+	INIT_LIST_HEAD(&br_port->br_mdb_port_list);
 
 	return br_port;
 }
@@ -447,6 +538,7 @@ prestera_bridge_port_destroy(struct prestera_bridge_port *br_port)
 {
 	list_del(&br_port->head);
 	WARN_ON(!list_empty(&br_port->vlan_list));
+	WARN_ON(!list_empty(&br_port->br_mdb_port_list));
 	kfree(br_port);
 }
 
@@ -619,6 +711,8 @@ void prestera_bridge_port_leave(struct net_device *br_dev,
 
 	switchdev_bridge_port_unoffload(br_port->dev, NULL, NULL, NULL);
 
+	prestera_mdb_flush_bridge_port(br_port);
+
 	prestera_br_port_flags_reset(br_port, port);
 	prestera_port_vid_stp_set(port, PRESTERA_VID_ALL, BR_STATE_FORWARDING);
 	prestera_bridge_port_put(br_port);
@@ -730,6 +824,269 @@ static int prestera_port_attr_stp_state_set(struct prestera_port *port,
 	return err;
 }
 
+static int
+prestera_br_port_lag_mdb_mc_enable_sync(struct prestera_bridge_port *br_port,
+					bool enabled)
+{
+	struct prestera_port *pr_port;
+	struct prestera_switch *sw;
+	u16 lag_id;
+	int err;
+
+	pr_port = prestera_port_dev_lower_find(br_port->dev);
+	if (!pr_port)
+		return 0;
+
+	sw = pr_port->sw;
+	err = prestera_lag_id(sw, br_port->dev, &lag_id);
+	if (err)
+		return err;
+
+	list_for_each_entry(pr_port, &sw->port_list, list) {
+		if (pr_port->lag->lag_id == lag_id) {
+			err = prestera_port_mc_flood_set(pr_port, enabled);
+			if (err)
+				return err;
+		}
+	}
+
+	return 0;
+}
+
+static int prestera_br_mdb_mc_enable_sync(struct prestera_bridge *br_dev)
+{
+	struct prestera_bridge_port *br_port;
+	struct prestera_port *port;
+	bool enabled;
+	int err;
+
+	/* if mrouter exists:
+	 *  - make sure every mrouter receives unreg mcast traffic;
+	 * if mrouter doesn't exists:
+	 *  - make sure every port receives unreg mcast traffic;
+	 */
+	list_for_each_entry(br_port, &br_dev->port_list, head) {
+		if (br_dev->multicast_enabled && br_dev->mrouter_exist)
+			enabled = br_port->mrouter;
+		else
+			enabled = br_port->flags & BR_MCAST_FLOOD;
+
+		if (netif_is_lag_master(br_port->dev)) {
+			err = prestera_br_port_lag_mdb_mc_enable_sync(br_port,
+								      enabled);
+			if (err)
+				return err;
+			continue;
+		}
+
+		port = prestera_port_dev_lower_find(br_port->dev);
+		if (!port)
+			continue;
+
+		err = prestera_port_mc_flood_set(port, enabled);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static bool
+prestera_br_mdb_port_is_member(struct prestera_br_mdb_entry *br_mdb,
+			       struct net_device *orig_dev)
+{
+	struct prestera_br_mdb_port *tmp_port;
+
+	list_for_each_entry(tmp_port, &br_mdb->br_mdb_port_list,
+			    br_mdb_port_node)
+		if (tmp_port->br_port->dev == orig_dev)
+			return true;
+
+	return false;
+}
+
+/* Sync bridge mdb (software table) with HW table (if MC is enabled). */
+static int prestera_br_mdb_sync(struct prestera_bridge *br_dev)
+{
+	struct prestera_br_mdb_port *br_mdb_port;
+	struct prestera_bridge_port *br_port;
+	struct prestera_br_mdb_entry *br_mdb;
+	struct prestera_mdb_entry *mdb;
+	struct prestera_port *pr_port;
+	int err = 0;
+
+	if (!br_dev->multicast_enabled)
+		return 0;
+
+	list_for_each_entry(br_mdb, &br_dev->br_mdb_entry_list,
+			    br_mdb_entry_node) {
+		mdb = br_mdb->mdb;
+		/* Make sure every port that explicitly been added to the mdb
+		 * joins the specified group.
+		 */
+		list_for_each_entry(br_mdb_port, &br_mdb->br_mdb_port_list,
+				    br_mdb_port_node) {
+			br_port = br_mdb_port->br_port;
+			pr_port = prestera_port_dev_lower_find(br_port->dev);
+
+			/* Match only mdb and br_mdb ports that belong to the
+			 * same broadcast domain.
+			 */
+			if (br_dev->vlan_enabled &&
+			    !prestera_port_vlan_by_vid(pr_port,
+						       mdb->vid))
+				continue;
+
+			/* If port is not in MDB or there's no Mrouter
+			 * clear HW mdb.
+			 */
+			if (prestera_br_mdb_port_is_member(br_mdb,
+							   br_mdb_port->br_port->dev) &&
+							   br_dev->mrouter_exist)
+				err = prestera_mdb_port_add(mdb, br_port->dev,
+							    mdb->addr,
+							    mdb->vid);
+			else
+				prestera_mdb_port_del(mdb, br_port->dev);
+
+			if (err)
+				return err;
+		}
+
+		/* Make sure that every mrouter port joins every MC group int
+		 * broadcast domain. If it's not an mrouter - it should leave
+		 */
+		list_for_each_entry(br_port, &br_dev->port_list, head) {
+			pr_port = prestera_port_dev_lower_find(br_port->dev);
+
+			/* Make sure mrouter woudln't receive traffci from
+			 * another broadcast domain (e.g. from a vlan, which
+			 * mrouter port is not a member of).
+			 */
+			if (br_dev->vlan_enabled &&
+			    !prestera_port_vlan_by_vid(pr_port,
+						       mdb->vid))
+				continue;
+
+			if (br_port->mrouter) {
+				err = prestera_mdb_port_add(mdb, br_port->dev,
+							    mdb->addr,
+							    mdb->vid);
+				if (err)
+					return err;
+			} else if (!br_port->mrouter &&
+				   !prestera_br_mdb_port_is_member
+				   (br_mdb, br_port->dev)) {
+				prestera_mdb_port_del(mdb, br_port->dev);
+			}
+		}
+	}
+
+	return 0;
+}
+
+static int
+prestera_mdb_enable_set(struct prestera_br_mdb_entry *br_mdb, bool enable)
+{
+	int err;
+
+	if (enable != br_mdb->enabled) {
+		if (enable)
+			err = prestera_hw_mdb_create(br_mdb->mdb);
+		else
+			err = prestera_hw_mdb_destroy(br_mdb->mdb);
+
+		if (err)
+			return err;
+
+		br_mdb->enabled = enable;
+	}
+
+	return 0;
+}
+
+static int
+prestera_br_mdb_enable_set(struct prestera_bridge *br_dev, bool enable)
+{
+	struct prestera_br_mdb_entry *br_mdb;
+	int err;
+
+	list_for_each_entry(br_mdb, &br_dev->br_mdb_entry_list,
+			    br_mdb_entry_node)
+		if (prestera_mdb_enable_set(br_mdb, enable))
+			return err;
+
+	return 0;
+}
+
+static int prestera_port_attr_br_mc_disabled_set(struct prestera_port *port,
+						 struct net_device *orig_dev,
+						 bool mc_disabled)
+{
+	struct prestera_switch *sw = port->sw;
+	struct prestera_bridge *br_dev;
+
+	br_dev = prestera_bridge_find(sw, orig_dev);
+	if (!br_dev)
+		return 0;
+
+	br_dev->multicast_enabled = !mc_disabled;
+
+	/* There's no point in enabling mdb back if router is missing. */
+	WARN_ON(prestera_br_mdb_enable_set(br_dev, br_dev->multicast_enabled &&
+					   br_dev->mrouter_exist));
+
+	WARN_ON(prestera_br_mdb_sync(br_dev));
+
+	WARN_ON(prestera_br_mdb_mc_enable_sync(br_dev));
+
+	return 0;
+}
+
+static bool
+prestera_bridge_mdb_mc_mrouter_exists(struct prestera_bridge *br_dev)
+{
+	struct prestera_bridge_port *br_port;
+
+	list_for_each_entry(br_port, &br_dev->port_list, head)
+		if (br_port->mrouter)
+			return true;
+
+	return false;
+}
+
+static int
+prestera_port_attr_mrouter_set(struct prestera_port *port,
+			       struct net_device *orig_dev,
+			       bool is_port_mrouter)
+{
+	struct prestera_bridge_port *br_port;
+	struct prestera_bridge *br_dev;
+
+	br_port = prestera_bridge_port_find(port->sw, orig_dev);
+	if (!br_port)
+		return 0;
+
+	br_dev = br_port->bridge;
+	br_port->mrouter = is_port_mrouter;
+
+	br_dev->mrouter_exist = prestera_bridge_mdb_mc_mrouter_exists(br_dev);
+
+	/* Enable MDB processing if both mrouter exists and mc is enabled.
+	 * In case if MC enabled, but there is no mrouter, device would flood
+	 * all multicast traffic (even if MDB table is not empty) with the use
+	 * of bridge's flood capabilities (without the use of flood_domain).
+	 */
+	WARN_ON(prestera_br_mdb_enable_set(br_dev, br_dev->multicast_enabled &&
+					   br_dev->mrouter_exist));
+
+	WARN_ON(prestera_br_mdb_sync(br_dev));
+
+	WARN_ON(prestera_br_mdb_mc_enable_sync(br_dev));
+
+	return 0;
+}
+
 static int prestera_port_obj_attr_set(struct net_device *dev, const void *ctx,
 				      const struct switchdev_attr *attr,
 				      struct netlink_ext_ack *extack)
@@ -759,6 +1116,14 @@ static int prestera_port_obj_attr_set(struct net_device *dev, const void *ctx,
 		err = prestera_port_attr_br_vlan_set(port, attr->orig_dev,
 						     attr->u.vlan_filtering);
 		break;
+	case SWITCHDEV_ATTR_ID_PORT_MROUTER:
+		err = prestera_port_attr_mrouter_set(port, attr->orig_dev,
+						     attr->u.mrouter);
+		break;
+	case SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED:
+		err = prestera_port_attr_br_mc_disabled_set(port, attr->orig_dev,
+							    attr->u.mc_disabled);
+		break;
 	default:
 		err = -EOPNOTSUPP;
 	}
@@ -1063,14 +1428,25 @@ static int prestera_port_obj_add(struct net_device *dev, const void *ctx,
 {
 	struct prestera_port *port = netdev_priv(dev);
 	const struct switchdev_obj_port_vlan *vlan;
+	const struct switchdev_obj_port_mdb *mdb;
+	int err = 0;
 
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
 		vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
 		return prestera_port_vlans_add(port, vlan, extack);
+	case SWITCHDEV_OBJ_ID_PORT_MDB:
+		mdb = SWITCHDEV_OBJ_PORT_MDB(obj);
+		err = prestera_mdb_port_addr_obj_add(mdb);
+		break;
+	case SWITCHDEV_OBJ_ID_HOST_MDB:
+		fallthrough;
 	default:
-		return -EOPNOTSUPP;
+		err = -EOPNOTSUPP;
+		break;
 	}
+
+	return err;
 }
 
 static int prestera_port_vlans_del(struct prestera_port *port,
@@ -1099,13 +1475,22 @@ static int prestera_port_obj_del(struct net_device *dev, const void *ctx,
 				 const struct switchdev_obj *obj)
 {
 	struct prestera_port *port = netdev_priv(dev);
+	const struct switchdev_obj_port_mdb *mdb;
+	int err = 0;
 
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
 		return prestera_port_vlans_del(port, SWITCHDEV_OBJ_PORT_VLAN(obj));
+	case SWITCHDEV_OBJ_ID_PORT_MDB:
+		mdb = SWITCHDEV_OBJ_PORT_MDB(obj);
+		err = prestera_mdb_port_addr_obj_del(port, mdb);
+		break;
 	default:
-		return -EOPNOTSUPP;
+		err = -EOPNOTSUPP;
+		break;
 	}
+
+	return err;
 }
 
 static int prestera_switchdev_blk_event(struct notifier_block *unused,
@@ -1239,6 +1624,268 @@ static void prestera_switchdev_handler_fini(struct prestera_switchdev *swdev)
 	unregister_switchdev_notifier(&swdev->swdev_nb);
 }
 
+static struct prestera_br_mdb_entry *
+prestera_br_mdb_entry_create(struct prestera_switch *sw,
+			     struct prestera_bridge *br_dev,
+			     const unsigned char *addr, u16 vid)
+{
+	struct prestera_br_mdb_entry *br_mdb_entry;
+	struct prestera_mdb_entry *mdb_entry;
+
+	br_mdb_entry = kzalloc(sizeof(*br_mdb_entry), GFP_KERNEL);
+	if (!br_mdb_entry)
+		return NULL;
+
+	mdb_entry = prestera_mdb_entry_create(sw, addr, vid);
+	if (!mdb_entry)
+		goto err_mdb_alloc;
+
+	br_mdb_entry->mdb = mdb_entry;
+	br_mdb_entry->bridge = br_dev;
+	br_mdb_entry->enabled = true;
+	INIT_LIST_HEAD(&br_mdb_entry->br_mdb_port_list);
+
+	list_add(&br_mdb_entry->br_mdb_entry_node, &br_dev->br_mdb_entry_list);
+
+	return br_mdb_entry;
+
+err_mdb_alloc:
+	kfree(br_mdb_entry);
+	return NULL;
+}
+
+static struct prestera_br_mdb_entry *
+prestera_br_mdb_entry_find(struct prestera_bridge *br_dev,
+			   const unsigned char *addr, u16 vid)
+{
+	struct prestera_br_mdb_entry *br_mdb;
+
+	list_for_each_entry(br_mdb, &br_dev->br_mdb_entry_list,
+			    br_mdb_entry_node)
+		if (ether_addr_equal(&br_mdb->mdb->addr[0], addr) &&
+		    vid == br_mdb->mdb->vid)
+			return br_mdb;
+
+	return NULL;
+}
+
+static struct prestera_br_mdb_entry *
+prestera_br_mdb_entry_get(struct prestera_switch *sw,
+			  struct prestera_bridge *br_dev,
+			  const unsigned char *addr, u16 vid)
+{
+	struct prestera_br_mdb_entry *br_mdb;
+
+	br_mdb = prestera_br_mdb_entry_find(br_dev, addr, vid);
+	if (br_mdb)
+		return br_mdb;
+
+	return prestera_br_mdb_entry_create(sw, br_dev, addr, vid);
+}
+
+static void
+prestera_br_mdb_entry_put(struct prestera_br_mdb_entry *br_mdb)
+{
+	struct prestera_bridge_port *br_port;
+
+	if (list_empty(&br_mdb->br_mdb_port_list)) {
+		list_for_each_entry(br_port, &br_mdb->bridge->port_list, head)
+			prestera_mdb_port_del(br_mdb->mdb, br_port->dev);
+
+		prestera_mdb_entry_destroy(br_mdb->mdb);
+		list_del(&br_mdb->br_mdb_entry_node);
+		kfree(br_mdb);
+	}
+}
+
+static int prestera_br_mdb_port_add(struct prestera_br_mdb_entry *br_mdb,
+				    struct prestera_bridge_port *br_port)
+{
+	struct prestera_br_mdb_port *br_mdb_port;
+
+	list_for_each_entry(br_mdb_port, &br_mdb->br_mdb_port_list,
+			    br_mdb_port_node)
+		if (br_mdb_port->br_port == br_port)
+			return 0;
+
+	br_mdb_port = kzalloc(sizeof(*br_mdb_port), GFP_KERNEL);
+	if (!br_mdb_port)
+		return -ENOMEM;
+
+	br_mdb_port->br_port = br_port;
+	list_add(&br_mdb_port->br_mdb_port_node,
+		 &br_mdb->br_mdb_port_list);
+
+	return 0;
+}
+
+static void
+prestera_br_mdb_port_del(struct prestera_br_mdb_entry *br_mdb,
+			 struct prestera_bridge_port *br_port)
+{
+	struct prestera_br_mdb_port *br_mdb_port, *tmp;
+
+	list_for_each_entry_safe(br_mdb_port, tmp, &br_mdb->br_mdb_port_list,
+				 br_mdb_port_node) {
+		if (br_mdb_port->br_port == br_port) {
+			list_del(&br_mdb_port->br_mdb_port_node);
+			kfree(br_mdb_port);
+		}
+	}
+}
+
+static int
+prestera_mdb_port_add(struct prestera_mdb_entry *mdb,
+		      struct net_device *orig_dev,
+		      const unsigned char addr[ETH_ALEN], u16 vid)
+{
+	struct prestera_flood_domain *flood_domain = mdb->flood_domain;
+	int err;
+
+	if (!prestera_flood_domain_port_find(flood_domain,
+					     orig_dev, vid)) {
+		err = prestera_flood_domain_port_create(flood_domain, orig_dev,
+							vid);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static void
+prestera_mdb_port_del(struct prestera_mdb_entry *mdb,
+		      struct net_device *orig_dev)
+{
+	struct prestera_flood_domain *fl_domain = mdb->flood_domain;
+	struct prestera_flood_domain_port *flood_domain_port;
+
+	flood_domain_port = prestera_flood_domain_port_find(fl_domain,
+							    orig_dev,
+							    mdb->vid);
+	if (flood_domain_port)
+		prestera_flood_domain_port_destroy(flood_domain_port);
+}
+
+static void
+prestera_mdb_flush_bridge_port(struct prestera_bridge_port *br_port)
+{
+	struct prestera_br_mdb_port *br_mdb_port, *tmp_port;
+	struct prestera_br_mdb_entry *br_mdb, *br_mdb_tmp;
+	struct prestera_bridge *br_dev = br_port->bridge;
+	struct prestera_mdb_entry *mdb;
+
+	list_for_each_entry_safe(br_mdb, br_mdb_tmp, &br_dev->br_mdb_entry_list,
+				 br_mdb_entry_node) {
+		mdb = br_mdb->mdb;
+
+		list_for_each_entry_safe(br_mdb_port, tmp_port,
+					 &br_mdb->br_mdb_port_list,
+					 br_mdb_port_node) {
+			prestera_mdb_port_del(br_mdb->mdb,
+					      br_mdb_port->br_port->dev);
+			prestera_br_mdb_port_del(br_mdb,  br_mdb_port->br_port);
+		}
+		prestera_br_mdb_entry_put(br_mdb);
+	}
+}
+
+static int
+prestera_mdb_port_addr_obj_add(const struct switchdev_obj_port_mdb *mdb)
+{
+	struct prestera_br_mdb_entry *br_mdb;
+	struct prestera_bridge_port *br_port;
+	struct prestera_bridge *br_dev;
+	struct prestera_switch *sw;
+	struct prestera_port *port;
+	int err;
+
+	sw = prestera_switch_get(mdb->obj.orig_dev);
+	port = prestera_port_dev_lower_find(mdb->obj.orig_dev);
+
+	br_port = prestera_bridge_port_find(sw, mdb->obj.orig_dev);
+	if (!br_port)
+		return 0;
+
+	br_dev = br_port->bridge;
+
+	if (mdb->vid && !prestera_port_vlan_by_vid(port, mdb->vid))
+		return 0;
+
+	if (mdb->vid)
+		br_mdb = prestera_br_mdb_entry_get(sw, br_dev, &mdb->addr[0],
+						   mdb->vid);
+	else
+		br_mdb = prestera_br_mdb_entry_get(sw, br_dev, &mdb->addr[0],
+						   br_dev->bridge_id);
+
+	if (!br_mdb)
+		return -ENOMEM;
+
+	/* Make sure newly allocated MDB entry gets disabled if either MC is
+	 * disabled, or the mrouter does not exist.
+	 */
+	WARN_ON(prestera_mdb_enable_set(br_mdb, br_dev->multicast_enabled &&
+					br_dev->mrouter_exist));
+
+	err = prestera_br_mdb_port_add(br_mdb, br_port);
+	if (err) {
+		prestera_br_mdb_entry_put(br_mdb);
+		return err;
+	}
+
+	err = prestera_br_mdb_sync(br_dev);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static int
+prestera_mdb_port_addr_obj_del(struct prestera_port *port,
+			       const struct switchdev_obj_port_mdb *mdb)
+{
+	struct prestera_br_mdb_entry *br_mdb;
+	struct prestera_bridge_port *br_port;
+	struct prestera_bridge *br_dev;
+	int err;
+
+	/* Bridge port no longer exists - and so does this MDB entry */
+	br_port = prestera_bridge_port_find(port->sw, mdb->obj.orig_dev);
+	if (!br_port)
+		return 0;
+
+	/* Removing MDB with non-existing VLAN - not supported; */
+	if (mdb->vid && !prestera_port_vlan_by_vid(port, mdb->vid))
+		return 0;
+
+	br_dev = br_port->bridge;
+
+	if (br_port->bridge->vlan_enabled)
+		br_mdb = prestera_br_mdb_entry_find(br_dev, &mdb->addr[0],
+						    mdb->vid);
+	else
+		br_mdb = prestera_br_mdb_entry_find(br_dev, &mdb->addr[0],
+						    br_port->bridge->bridge_id);
+
+	if (!br_mdb)
+		return 0;
+
+	/* Since there might be a situation that this port was the last in the
+	 * MDB group, we have to both remove this port from software and HW MDB,
+	 * sync MDB table, and then destroy software MDB (if needed).
+	 */
+	prestera_br_mdb_port_del(br_mdb, br_port);
+
+	prestera_br_mdb_entry_put(br_mdb);
+
+	err = prestera_br_mdb_sync(br_dev);
+	if (err)
+		return err;
+
+	return 0;
+}
+
 int prestera_switchdev_init(struct prestera_switch *sw)
 {
 	struct prestera_switchdev *swdev;
-- 
2.17.1


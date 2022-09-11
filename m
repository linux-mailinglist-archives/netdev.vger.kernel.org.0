Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A18345B4B22
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 03:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbiIKBJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Sep 2022 21:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbiIKBI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Sep 2022 21:08:57 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2087.outbound.protection.outlook.com [40.107.104.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A11A4DF04;
        Sat, 10 Sep 2022 18:08:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=epLr4vkSGywrGYfdyL+okFSMWp+Vp6VWXqi7bGLCBrZ+kQz5fygIBf+AVKAXcO4ReXKRzyXrvHJ4oGxzIsD4Zsyd+RJZ8nWWiQVb9AkN4fT+BBFz/yXpBtdrnnCZxjrYxTP9qhpXsAjUQAECcT/Nu96hn931rXbIfeo1vynx/n5TlKUUp3U7H0obQkNW7PXojpKllelWKwHdwNV3U4skOUBXlvqDIPdqrbTTrvvdjhcs7b03ECtNNNVlQvUwOLW814bmSMB6sroyHlXOQHZnfXvRF3nopC8A4Ne149czTRjN0z+GRaG9dKGdAFt4I9c+UeLgPbcG9ufWBAVzh1S+8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1hvx6qpY69YPkhOOaIXt5Eb8b5r7DBt4XoTWRjN6xEI=;
 b=BG6JFVHIlA7a+BCNTacYNy6L1vMXsJIWTBrvipPTbvqXDsFAT45xYYh7ScfTQ119ALU81XX0zuQpY5mjygQTmOFGEG9C3Xbnyx4T4JH4tXb55gPtMQXWgDKNpl5F9HcRy3qRMfr6WH6ImVlS2pRxCv+jgf/nEzz344X9k4DJAHqATbs9gFsQEHPeUOueaxwBk/OTzM5dRK4wokolSEyEFH1XiGBb1OaTp4WmsoD9zhX47vKjcyemvXK/SbJyIT0Vu9VT0yuKN1zhv2mNNwvQDlGx/I5dAz5CQo4AZCkXzLduGVT5tTR6hXeS9bk/vqrMEG/5c3QVE02rkSmY6vbx7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1hvx6qpY69YPkhOOaIXt5Eb8b5r7DBt4XoTWRjN6xEI=;
 b=PLt9NPo/Cgw3AR4OFzr/Qhcdk7xLte0sqIoaY2uzqAwsphNu6STF/cO77YEwzevxV+IzKx72r5CRqNn0nYBDg90MSyfMd2oY3F5JPvhYRDG5SqJ8vvTtw39iFgb+NKzHQxajU4RE4e3Jl74pJ822POonHAc3DNkdatkqm6AYnDQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by DBBPR04MB7739.eurprd04.prod.outlook.com (2603:10a6:10:1eb::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Sun, 11 Sep
 2022 01:08:02 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5d3b:4f24:dbeb:e292]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5d3b:4f24:dbeb:e292%5]) with mapi id 15.20.5612.020; Sun, 11 Sep 2022
 01:08:02 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v2 net-next 08/10] net: dsa: allow masters to join a LAG
Date:   Sun, 11 Sep 2022 04:07:04 +0300
Message-Id: <20220911010706.2137967-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220911010706.2137967-1-vladimir.oltean@nxp.com>
References: <20220911010706.2137967-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0129.eurprd08.prod.outlook.com
 (2603:10a6:800:d4::31) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5121:EE_|DBBPR04MB7739:EE_
X-MS-Office365-Filtering-Correlation-Id: 367674fb-2a5f-4b22-1e49-08da93921326
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wXOCeMiNIOsjteeBrUkWv9gBr+qGTj0j1cMBzZp4j6dPc0Fng4zsXr5PJv7InEEn4RzloTpTsNCBgPwMnGs2N0Z0suu125caFQtVyKAmmYKbJPSDGRoS3uTjBWwfSjWkvrSujmOvEPNaDLnI3vCtEG53pcv0oHaUxaTM3sLSvWfWKbFEKNaRSPGAZHxXMGiR83ZBTN5+oqojpXJv29Lo8wsJLN71QzXZTTFFaYtzGzsFqaD/hmIklyHrzFSeUvB/PQnDAkuZM5pG9qHkKqVG5OT1r7ljmEkzVqJqGHoxjXw9sy0cMtMjQFK5WpWArFbXlz2Xi0FR1csgSXTA+OEyqylaqi8iu8QQte0tfrCX8gZQVMpNyyeLmU8RmNyvTUb+w2psHMphNZXSODCeDkTbuLJ0MQgwBXc5h7VvLL7r3rEuIxL34nU/52BPRPpEJEfVVyNzPoqXjFEtAAYPFBWuf9yr8EMOU5waj01Yb7rMhO7WcU/qyT2KR4eBHj1NmtybLhz2T4eOeMJKHL0jo1nCfrxJ3BHRoFFQJcjQzW7QSAkmUg8GWkir8pPItKPaivdAIruEJv2UdVHMcSZRDE2SgRk3KAspoDYCDx9ExMNv4CPQJo6TONY5yG0p5NgnZnHSD6/v38bqczEUch+3aHxgAiOfoKPOPnyAS8SN9m17+lNTkMI2C6ow12bhU8wV0KAsTayXNb6WT1fjXEsJz2vYaIFf4K0AINV7LevXb90BlEj72N61yT/fFKylHXdptVyKV3bpMCy3I/XG3EecBOXJZA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(376002)(39860400002)(396003)(366004)(38100700002)(38350700002)(30864003)(2906002)(44832011)(83380400001)(2616005)(186003)(1076003)(316002)(66476007)(66556008)(4326008)(8936002)(66946007)(8676002)(54906003)(6916009)(36756003)(7416002)(5660300002)(478600001)(41300700001)(52116002)(6486002)(26005)(6512007)(86362001)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r3t5ohIs7bN//+LOvbzQqmI7TZxHPyo+4qYepcBpVRypmOMUq8yKailKD+Rr?=
 =?us-ascii?Q?r1tB7ecoqZR9cpfOkm4kZuvG2/4qIZkrsaJGjFmivyxx4EGXZifN134rbAbj?=
 =?us-ascii?Q?UiTSthXqKCT+EqVswmHh5g91mQ3mkyf2Xx8IwatuBbN9vuO+55pHwosL6dcC?=
 =?us-ascii?Q?dU2+d+AwKpqMLrillVLrWpONT4J/U2uP7Pu2tGBp4sI8e0xdnCutBe5gfQwB?=
 =?us-ascii?Q?bgwfUbGwO8yiPioAbFBNDcoZfDpprAM1y+DU9pRGPtN1LCquQ76Os8XA8cZe?=
 =?us-ascii?Q?3TaTTMdIJVPZtaZUlxV5RgEyaLX8IMqIfB9XPluOmhRafLcp2HECEZmazYw+?=
 =?us-ascii?Q?7r6zOOli9rHcAnbk6D263P/qaflNsB8D77ldLFQ51vuUoWUBMWydEW1flh/f?=
 =?us-ascii?Q?2Td86KhpKKVqeIMaLj0eB6LW76Z16wRR9ov8aOqIoJTWI04e8QBQVuG9E3oC?=
 =?us-ascii?Q?WNRCY/N3bMs6sasmk7pIbFJFcWyzCIq+tfrVAgJ83/xJjpjLA4y6evlmF8IP?=
 =?us-ascii?Q?U3bfaJyQhxDNNzAo/1Gws+0hX//jOYbLXjrukRYhQBAeNnsKwdHjK6BGbdek?=
 =?us-ascii?Q?XGJrvhlT94ANS89U/GsHq7DBcCcfpICcoeIjkPlYHruBU5Lze0NvMUgZh1Zj?=
 =?us-ascii?Q?sjnek+2O4mdWxmIPAb5JtWzWskVkE95BKgHDNKMzOSwiksTnHyyosqnrQBNn?=
 =?us-ascii?Q?DzxbsZANFW8PI43KvIX0M2C8U0pLcRBUCDqiydBSuiSQLLXHFYuQITqTKL6F?=
 =?us-ascii?Q?VaFC+Wmf+9127SjdI9as+g9fiwz4Wqu4B1xCsn3B9SSfYA7wccW8zC4NlZQU?=
 =?us-ascii?Q?ZumqtAmR4PsNsRMoh3Vlsk0r3q8dVGuZam3S2zu37pn0wUDml1B922CuJ+vl?=
 =?us-ascii?Q?KwiBPUDU+YXVVQeSXV1jTybhlR2KDEh864caVe9vv6dmcwM5pqsJt7dsE0F6?=
 =?us-ascii?Q?dVQBiKDwGd2HD4oizowvPDgPjnKVTwyptzQQ/kn4fSq+WmDRJRDrbnfCmnjk?=
 =?us-ascii?Q?Dp5Ve7R6Sc/2zxX+Z+BLZ32brmjSdxMCrcxOVO8j1ebSURbS9sbHnv+cCpvq?=
 =?us-ascii?Q?IMiL86SG/e/o8YSiwqyNVTw4r8jF90S6QrCgFcwyvUEjC8VUKhp+gMeNskdJ?=
 =?us-ascii?Q?bzCDu7GVb6tdqTgXgb8I6VL1ZDhbQEKWILH0VoaUazykJlzFlnuroQUkZZLO?=
 =?us-ascii?Q?eFwiJguZKUFxX0VrUhFBx/afZkBBAP2Qu2Ps7GZrBbkOrUyz/2D5xIELSdll?=
 =?us-ascii?Q?i6m4pHd+j96lLwhzRGultLb3GG76ZRsdey8q9m8Ng1slnLNg3fAmPaYYqIUd?=
 =?us-ascii?Q?wQf35ltK/syLu6sdhLusNq7d63md6qvBdWFWVOK/nH1yXjMQkTcX23A0M2ow?=
 =?us-ascii?Q?XoIpy6Dq5IviLo3q+un55bacr0cmC0Z4gerY6IyWZQiyfCCGZtORRWVGFNTu?=
 =?us-ascii?Q?jfCy3pI1JzHKJcFX9vNxQxtQACVOmEi2Ct3ENZqdgAA6oYtRGj4G+elHUCXa?=
 =?us-ascii?Q?JkAfBUbRZeEDgC4nq2DkOY+nRyyQdck03iiDzGmgcJ1fdiVZHSiYJLtjFlzs?=
 =?us-ascii?Q?EutMrhrEe9xKa4NkgXWsPwvH2BQMi/9vVTbEokkT8nEuArEVjiqM3iFQQamo?=
 =?us-ascii?Q?mg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 367674fb-2a5f-4b22-1e49-08da93921326
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2022 01:08:02.3369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fpDB5vORuqKCrtuOtcXI1CNpW39pJ1jRTEuqkdT77r7qxZ3rMzfHjqqrHjdSSTNfq5kqu8NVk28liF3qmP3qtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7739
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are 2 ways in which a DSA user port may become handled by 2 CPU
ports in a LAG:

(1) its current DSA master joins a LAG

 ip link del bond0 && ip link add bond0 type bond mode 802.3ad
 ip link set eno2 master bond0

When this happens, all user ports with "eno2" as DSA master get
automatically migrated to "bond0" as DSA master.

(2) it is explicitly configured as such by the user

 # Before, the DSA master was eno3
 ip link set swp0 type dsa master bond0

The design of this configuration is that the LAG device dynamically
becomes a DSA master through dsa_master_setup() when the first physical
DSA master becomes a LAG slave, and stops being so through
dsa_master_teardown() when the last physical DSA master leaves.

A LAG interface is considered as a valid DSA master only if it contains
existing DSA masters, and no other lower interfaces. Therefore, we
mainly rely on method (1) to enter this configuration.

Each physical DSA master (LAG slave) retains its dev->dsa_ptr for when
it becomes a standalone DSA master again. But the LAG master also has a
dev->dsa_ptr, and this is actually duplicated from one of the physical
LAG slaves, and therefore needs to be balanced when LAG slaves come and
go.

To the switch driver, putting DSA masters in a LAG is seen as putting
their associated CPU ports in a LAG.

We need to prepare cross-chip host FDB notifiers for CPU ports in a LAG,
by calling the driver's ->lag_fdb_add method rather than ->port_fdb_add.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2:
- add restriction that LAG slaves must be DSA masters of the same switch
  tree
- move DSA master eligibility restriction earlier, from
  dsa_master_lag_setup() to dsa_master_prechangeupper_sanity_check()
- set master_setup = true in dsa_master_lag_setup(), so that
  dsa_master_teardown() would actually get called
- don't overwrite extack in dsa_master_lag_setup() if
  dsa_port_lag_join() provided a more specific one
- add restriction that interfaces which aren't DSA masters cannot join a
  LAG DSA master

 include/net/dsa.h  |  12 +++
 net/dsa/dsa_priv.h |   5 +
 net/dsa/master.c   |  49 ++++++++++
 net/dsa/port.c     |   1 +
 net/dsa/slave.c    | 231 +++++++++++++++++++++++++++++++++++++++++++--
 net/dsa/switch.c   |  22 ++++-
 6 files changed, 310 insertions(+), 10 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 1c80e75b3cad..d777eac5694f 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -300,6 +300,9 @@ struct dsa_port {
 	u8			master_admin_up:1;
 	u8			master_oper_up:1;
 
+	/* Valid only on user ports */
+	u8			cpu_port_in_lag:1;
+
 	u8			setup:1;
 
 	struct device_node	*dn;
@@ -724,6 +727,9 @@ static inline bool dsa_port_offloads_lag(struct dsa_port *dp,
 
 static inline struct net_device *dsa_port_to_master(const struct dsa_port *dp)
 {
+	if (dp->cpu_port_in_lag)
+		return dsa_port_lag_dev_get(dp->cpu_dp);
+
 	return dp->cpu_dp->master;
 }
 
@@ -811,6 +817,12 @@ dsa_tree_offloads_bridge_dev(struct dsa_switch_tree *dst,
 	return false;
 }
 
+static inline bool dsa_port_tree_same(const struct dsa_port *a,
+				      const struct dsa_port *b)
+{
+	return a->ds->dst == b->ds->dst;
+}
+
 typedef int dsa_fdb_dump_cb_t(const unsigned char *addr, u16 vid,
 			      bool is_static, void *data);
 struct dsa_switch_ops {
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index f0ae54d0435e..129e4a649c7e 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -185,6 +185,11 @@ static inline int dsa_tag_protocol_overhead(const struct dsa_device_ops *ops)
 /* master.c */
 int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp);
 void dsa_master_teardown(struct net_device *dev);
+int dsa_master_lag_setup(struct net_device *lag_dev, struct dsa_port *cpu_dp,
+			 struct netdev_lag_upper_info *uinfo,
+			 struct netlink_ext_ack *extack);
+void dsa_master_lag_teardown(struct net_device *lag_dev,
+			     struct dsa_port *cpu_dp);
 
 static inline struct net_device *dsa_master_find_slave(struct net_device *dev,
 						       int device, int port)
diff --git a/net/dsa/master.c b/net/dsa/master.c
index 2176c14b97a8..40367ab41cf8 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -428,3 +428,52 @@ void dsa_master_teardown(struct net_device *dev)
 	 */
 	wmb();
 }
+
+int dsa_master_lag_setup(struct net_device *lag_dev, struct dsa_port *cpu_dp,
+			 struct netdev_lag_upper_info *uinfo,
+			 struct netlink_ext_ack *extack)
+{
+	bool master_setup = false;
+	int err;
+
+	if (!netdev_uses_dsa(lag_dev)) {
+		err = dsa_master_setup(lag_dev, cpu_dp);
+		if (err)
+			return err;
+
+		master_setup = true;
+	}
+
+	err = dsa_port_lag_join(cpu_dp, lag_dev, uinfo, extack);
+	if (err) {
+		if (extack && !extack->_msg)
+			NL_SET_ERR_MSG_MOD(extack,
+					   "CPU port failed to join LAG");
+		goto out_master_teardown;
+	}
+
+	return 0;
+
+out_master_teardown:
+	if (master_setup)
+		dsa_master_teardown(lag_dev);
+	return err;
+}
+
+/* Tear down a master if there isn't any other user port on it,
+ * optionally also destroying LAG information.
+ */
+void dsa_master_lag_teardown(struct net_device *lag_dev,
+			     struct dsa_port *cpu_dp)
+{
+	struct net_device *upper;
+	struct list_head *iter;
+
+	dsa_port_lag_leave(cpu_dp, lag_dev);
+
+	netdev_for_each_upper_dev_rcu(lag_dev, upper, iter)
+		if (dsa_slave_dev_check(upper))
+			return;
+
+	dsa_master_teardown(lag_dev);
+}
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 98f7fa0cdd5c..e6289a1db0a0 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1393,6 +1393,7 @@ static int dsa_port_assign_master(struct dsa_port *dp,
 		return err;
 
 	dp->cpu_dp = master->dsa_ptr;
+	dp->cpu_port_in_lag = netif_is_lag_master(master);
 
 	return 0;
 }
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 00df6cf07866..aa47ddc19fdf 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2818,11 +2818,45 @@ dsa_slave_prechangeupper_sanity_check(struct net_device *dev,
 	return NOTIFY_DONE;
 }
 
+/* To be eligible as a DSA master, a LAG must have all lower interfaces be
+ * eligible DSA masters. Additionally, all LAG slaves must be DSA masters of
+ * switches in the same switch tree.
+ */
+static int dsa_lag_master_validate(struct net_device *lag_dev,
+				   struct netlink_ext_ack *extack)
+{
+	struct net_device *lower1, *lower2;
+	struct list_head *iter1, *iter2;
+
+	netdev_for_each_lower_dev(lag_dev, lower1, iter1) {
+		netdev_for_each_lower_dev(lag_dev, lower2, iter2) {
+			if (!netdev_uses_dsa(lower1) ||
+			    !netdev_uses_dsa(lower2)) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "All LAG ports must be eligible as DSA masters");
+				return notifier_from_errno(-EINVAL);
+			}
+
+			if (lower1 == lower2)
+				continue;
+
+			if (!dsa_port_tree_same(lower1->dsa_ptr,
+						lower2->dsa_ptr)) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "LAG contains DSA masters of disjoint switch trees");
+				return notifier_from_errno(-EINVAL);
+			}
+		}
+	}
+
+	return NOTIFY_DONE;
+}
+
 static int
 dsa_master_prechangeupper_sanity_check(struct net_device *master,
 				       struct netdev_notifier_changeupper_info *info)
 {
-	struct netlink_ext_ack *extack;
+	struct netlink_ext_ack *extack = netdev_notifier_info_to_extack(&info->info);
 
 	if (!netdev_uses_dsa(master))
 		return NOTIFY_DONE;
@@ -2840,13 +2874,51 @@ dsa_master_prechangeupper_sanity_check(struct net_device *master,
 	if (netif_is_bridge_master(info->upper_dev))
 		return NOTIFY_DONE;
 
-	extack = netdev_notifier_info_to_extack(&info->info);
+	/* Allow LAG uppers, subject to further restrictions in
+	 * dsa_lag_master_prechangelower_sanity_check()
+	 */
+	if (netif_is_lag_master(info->upper_dev))
+		return dsa_lag_master_validate(info->upper_dev, extack);
 
 	NL_SET_ERR_MSG_MOD(extack,
 			   "DSA master cannot join unknown upper interfaces");
 	return notifier_from_errno(-EBUSY);
 }
 
+static int
+dsa_lag_master_prechangelower_sanity_check(struct net_device *dev,
+					   struct netdev_notifier_changeupper_info *info)
+{
+	struct netlink_ext_ack *extack = netdev_notifier_info_to_extack(&info->info);
+	struct net_device *lag_dev = info->upper_dev;
+	struct net_device *lower;
+	struct list_head *iter;
+
+	if (!netdev_uses_dsa(lag_dev) || !netif_is_lag_master(lag_dev))
+		return NOTIFY_DONE;
+
+	if (!info->linking)
+		return NOTIFY_DONE;
+
+	if (!netdev_uses_dsa(dev)) {
+		NL_SET_ERR_MSG(extack,
+			       "Only DSA masters can join a LAG DSA master");
+		return notifier_from_errno(-EINVAL);
+	}
+
+	netdev_for_each_lower_dev(lag_dev, lower, iter) {
+		if (!dsa_port_tree_same(dev->dsa_ptr, lower->dsa_ptr)) {
+			NL_SET_ERR_MSG(extack,
+				       "Interface is DSA master for a different switch tree than this LAG");
+			return notifier_from_errno(-EINVAL);
+		}
+
+		break;
+	}
+
+	return NOTIFY_DONE;
+}
+
 /* Don't allow bridging of DSA masters, since the bridge layer rx_handler
  * prevents the DSA fake ethertype handler to be invoked, so we don't get the
  * chance to strip off and parse the DSA switch tag protocol header (the bridge
@@ -2887,6 +2959,136 @@ dsa_bridge_prechangelower_sanity_check(struct net_device *new_lower,
 	return NOTIFY_DONE;
 }
 
+static void dsa_tree_migrate_ports_from_lag_master(struct dsa_switch_tree *dst,
+						   struct net_device *lag_dev)
+{
+	struct net_device *new_master = dsa_tree_find_first_master(dst);
+	struct dsa_port *dp;
+	int err;
+
+	dsa_tree_for_each_user_port(dp, dst) {
+		if (dsa_port_to_master(dp) != lag_dev)
+			continue;
+
+		err = dsa_slave_change_master(dp->slave, new_master, NULL);
+		if (err) {
+			netdev_err(dp->slave,
+				   "failed to restore master to %s: %pe\n",
+				   new_master->name, ERR_PTR(err));
+		}
+	}
+}
+
+static int dsa_master_lag_join(struct net_device *master,
+			       struct net_device *lag_dev,
+			       struct netdev_lag_upper_info *uinfo,
+			       struct netlink_ext_ack *extack)
+{
+	struct dsa_port *cpu_dp = master->dsa_ptr;
+	struct dsa_switch_tree *dst = cpu_dp->dst;
+	struct dsa_port *dp;
+	int err;
+
+	err = dsa_master_lag_setup(lag_dev, cpu_dp, uinfo, extack);
+	if (err)
+		return err;
+
+	dsa_tree_for_each_user_port(dp, dst) {
+		if (dsa_port_to_master(dp) != master)
+			continue;
+
+		err = dsa_slave_change_master(dp->slave, lag_dev, extack);
+		if (err)
+			goto restore;
+	}
+
+	return 0;
+
+restore:
+	dsa_tree_for_each_user_port_continue_reverse(dp, dst) {
+		if (dsa_port_to_master(dp) != lag_dev)
+			continue;
+
+		err = dsa_slave_change_master(dp->slave, master, NULL);
+		if (err) {
+			netdev_err(dp->slave,
+				   "failed to restore master to %s: %pe\n",
+				   master->name, ERR_PTR(err));
+		}
+	}
+
+	dsa_master_lag_teardown(lag_dev, master->dsa_ptr);
+
+	return err;
+}
+
+static void dsa_master_lag_leave(struct net_device *master,
+				 struct net_device *lag_dev)
+{
+	struct dsa_port *dp, *cpu_dp = lag_dev->dsa_ptr;
+	struct dsa_switch_tree *dst = cpu_dp->dst;
+	struct dsa_port *new_cpu_dp = NULL;
+	struct net_device *lower;
+	struct list_head *iter;
+
+	netdev_for_each_lower_dev(lag_dev, lower, iter) {
+		if (netdev_uses_dsa(lower)) {
+			new_cpu_dp = lower->dsa_ptr;
+			break;
+		}
+	}
+
+	if (new_cpu_dp) {
+		/* Update the CPU port of the user ports still under the LAG
+		 * so that dsa_port_to_master() continues to work properly
+		 */
+		dsa_tree_for_each_user_port(dp, dst)
+			if (dsa_port_to_master(dp) == lag_dev)
+				dp->cpu_dp = new_cpu_dp;
+
+		/* Update the index of the virtual CPU port to match the lowest
+		 * physical CPU port
+		 */
+		lag_dev->dsa_ptr = new_cpu_dp;
+		wmb();
+	} else {
+		/* If the LAG DSA master has no ports left, migrate back all
+		 * user ports to the first physical CPU port
+		 */
+		dsa_tree_migrate_ports_from_lag_master(dst, lag_dev);
+	}
+
+	/* This DSA master has left its LAG in any case, so let
+	 * the CPU port leave the hardware LAG as well
+	 */
+	dsa_master_lag_teardown(lag_dev, master->dsa_ptr);
+}
+
+static int dsa_master_changeupper(struct net_device *dev,
+				  struct netdev_notifier_changeupper_info *info)
+{
+	struct netlink_ext_ack *extack;
+	int err = NOTIFY_DONE;
+
+	if (!netdev_uses_dsa(dev))
+		return err;
+
+	extack = netdev_notifier_info_to_extack(&info->info);
+
+	if (netif_is_lag_master(info->upper_dev)) {
+		if (info->linking) {
+			err = dsa_master_lag_join(dev, info->upper_dev,
+						  info->upper_info, extack);
+			err = notifier_from_errno(err);
+		} else {
+			dsa_master_lag_leave(dev, info->upper_dev);
+			err = NOTIFY_OK;
+		}
+	}
+
+	return err;
+}
+
 static int dsa_slave_netdevice_event(struct notifier_block *nb,
 				     unsigned long event, void *ptr)
 {
@@ -2905,6 +3107,10 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 		if (notifier_to_errno(err))
 			return err;
 
+		err = dsa_lag_master_prechangelower_sanity_check(dev, info);
+		if (notifier_to_errno(err))
+			return err;
+
 		err = dsa_bridge_prechangelower_sanity_check(dev, info);
 		if (notifier_to_errno(err))
 			return err;
@@ -2930,6 +3136,10 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 		if (notifier_to_errno(err))
 			return err;
 
+		err = dsa_master_changeupper(dev, ptr);
+		if (notifier_to_errno(err))
+			return err;
+
 		break;
 	}
 	case NETDEV_CHANGELOWERSTATE: {
@@ -2937,12 +3147,21 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 		struct dsa_port *dp;
 		int err;
 
-		if (!dsa_slave_dev_check(dev))
-			break;
+		if (dsa_slave_dev_check(dev)) {
+			dp = dsa_slave_to_port(dev);
+
+			err = dsa_port_lag_change(dp, info->lower_state_info);
+		}
 
-		dp = dsa_slave_to_port(dev);
+		/* Mirror LAG port events on DSA masters that are in
+		 * a LAG towards their respective switch CPU ports
+		 */
+		if (netdev_uses_dsa(dev)) {
+			dp = dev->dsa_ptr;
+
+			err = dsa_port_lag_change(dp, info->lower_state_info);
+		}
 
-		err = dsa_port_lag_change(dp, info->lower_state_info);
 		return notifier_from_errno(err);
 	}
 	case NETDEV_CHANGE:
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index c2cb15e21324..ce56acdba203 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -398,8 +398,15 @@ static int dsa_switch_host_fdb_add(struct dsa_switch *ds,
 
 	dsa_switch_for_each_port(dp, ds) {
 		if (dsa_port_host_address_match(dp, info->dp)) {
-			err = dsa_port_do_fdb_add(dp, info->addr, info->vid,
-						  info->db);
+			if (dsa_port_is_cpu(dp) && info->dp->cpu_port_in_lag) {
+				err = dsa_switch_do_lag_fdb_add(ds, dp->lag,
+								info->addr,
+								info->vid,
+								info->db);
+			} else {
+				err = dsa_port_do_fdb_add(dp, info->addr,
+							  info->vid, info->db);
+			}
 			if (err)
 				break;
 		}
@@ -419,8 +426,15 @@ static int dsa_switch_host_fdb_del(struct dsa_switch *ds,
 
 	dsa_switch_for_each_port(dp, ds) {
 		if (dsa_port_host_address_match(dp, info->dp)) {
-			err = dsa_port_do_fdb_del(dp, info->addr, info->vid,
-						  info->db);
+			if (dsa_port_is_cpu(dp) && info->dp->cpu_port_in_lag) {
+				err = dsa_switch_do_lag_fdb_del(ds, dp->lag,
+								info->addr,
+								info->vid,
+								info->db);
+			} else {
+				err = dsa_port_do_fdb_del(dp, info->addr,
+							  info->vid, info->db);
+			}
 			if (err)
 				break;
 		}
-- 
2.34.1


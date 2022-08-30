Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF125A6E04
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 22:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbiH3UBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 16:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231824AbiH3UAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 16:00:54 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2063.outbound.protection.outlook.com [40.107.20.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 952E23F31C;
        Tue, 30 Aug 2022 13:00:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HNIZ/dInATCuciuwPanBcXIKdWUeyvfzyS/4ocMfwTTim0YpfLYkgFYIx5EeFwYwIaYMkxzZ4jElH571OGj55L31y7eVvQ5DVSMLEQRev8pMmrN8yQ5rPUPsDV2WrzyP+ZUOgkP2VLY/4z+73PVqIItvnQ0nMGy495DzBmofMqn5rdi0ucffe+G+6sGZS5G3iEBqdMo75hYeuYaEJBpWYhcMbqBQSUHS5PsF0rn/iGZLFhX10i3vhi2iouvPRfZRW65A8lzdT4IYE0/MwXI6ERiHJNPldrgqzUiTqYF9j9BWmG5g4B2s0kTR/VFvSkMQ7cE1ogM8hX6OnUxXRUzS3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UcAZNLbSf/yXu+eVkhbU8dgipt+q54HrAFrCu99ygdE=;
 b=SIbWLJuWelghorTTXODoYph3ZJzS5v+8xu8Zb0dEXWcXugF8HJxz5x4TyqzYiGUm3ZDDDlNqlRALUjkxOR5OOZ4M24OT9Mf8QfdGuf0nHtz47Px+dBru2BOK4bYnlKwuWjZzjG+4S4KgTY1+h05yJQKKuS0ESc6vMT+rrHm4LS+KBrcang5tcRdgmdgGHAood03L8JyCmXDk+9vVdnO2Zlr2yC7BrjrqNluRu2vq26vO8dCBV2rL7BaZ+pqXZYG3g2KkqgHBCxGYsY4Nsz/J+w7KZzoakBwapXl9qPcVfSkbCLPRQxUF3Pg63qIhuz/B9cVKG+GMnD/X+fBIPCmSUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UcAZNLbSf/yXu+eVkhbU8dgipt+q54HrAFrCu99ygdE=;
 b=B+tMAczLxusqnk+OcPw3a9nOiTzIUVTj8Int9EWnXKorOthX7sx9iyFVHTHWyPSonCoMA3YZXAZVoC45DlHAnn68AAJJEBzBl4/EznI2zRSd2Qycvo9urlmze26UDM6IWr1Qy9xVY7qYtgZHJRTizai+FPzqdrK9wk9ouv8Ekfs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6270.eurprd04.prod.outlook.com (2603:10a6:803:fb::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Tue, 30 Aug
 2022 19:59:58 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.010; Tue, 30 Aug 2022
 19:59:58 +0000
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
        Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH net-next 7/9] net: dsa: allow masters to join a LAG
Date:   Tue, 30 Aug 2022 22:59:30 +0300
Message-Id: <20220830195932.683432-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220830195932.683432-1-vladimir.oltean@nxp.com>
References: <20220830195932.683432-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE0P281CA0005.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:a::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0b411a09-3638-4a8c-85d8-08da8ac234b6
X-MS-TrafficTypeDiagnostic: VI1PR04MB6270:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8+xplekzMWFn4qAwivcTWiYwakOVhJiqacHhCWGmTrqqXKtiWJ4VCTO5mxrYwsbvLr7RC4vCzsidt5UstAPZQ1+aJseH1IK7BkP1RAK1NUONVFkMn75rEgt8yv2bG7peXmVokgUx/Jj3XujJa5n0/gweAetXgz6oHwFd9r5C/jFPftf+F9JdAQIldsZfekuN0HoNAhnmGsjH7V7tHoTuKeAK+PAJX+bTcLc7fx2ukkwgLtfwdu+HiDzEwVPmpZ1IMC9mDqOauVzR/BHGTeOrJPqhN8yo3OldZ4OJPx2rrE3ewj661HhwPtVcIf0eONCTPc3VkgtaOJer4wH7vBPJiz3prYV7pr39tj80N/vLerzF/Dbrl2zQvdLR3VrsUaWrrK6zeJrQQKVcm6O08DRE9kjjkQ0OO6N2XF+ZqRQu2HwgIqZRBPoUu6wjD8gq8v6xJT74KCDQ/anfQI71Y5s6Ol+6lb1U53ICGmIRtD8lXqSiBp+idb2OMzqdcWkXFn1hr3g6LoqhZR5nMb30viapSciTZJ6PAVZAkozdN7vOeGhSXCMcIEFThehZxG9axJQGWNg3cv6FkB+fnWyhTqtNr9Nsm5DUM7k6rIgoJyHRBYRk4gB/G0+B8pEllHzGU6UrWtnswopPbcD6KXeZeK6EwpFa771hoNhFfu4O2DKRkxdjzox8G99rwblj55njHZTANzuszBKiAH3Wml+1utH4MFUciR0JwKja6DiU4KtAbezzkLfDOKwJD4LZgUGWudl7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(366004)(39860400002)(136003)(376002)(41300700001)(66476007)(6486002)(8676002)(4326008)(66946007)(478600001)(66556008)(52116002)(2906002)(83380400001)(44832011)(26005)(5660300002)(6506007)(6512007)(7416002)(6666004)(30864003)(8936002)(2616005)(316002)(86362001)(6916009)(54906003)(36756003)(38350700002)(1076003)(38100700002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Qx0svCDuJsUnO6wVJGZq01vlEGdDKv//QVi4ee7yraFQ70UdOabIVceqtwDC?=
 =?us-ascii?Q?eV2n/KDC8mvzZ6bPH7IH1A0aDAAH9edjXoFYFhZ5US8G3VWtdkN6SE7BfaY4?=
 =?us-ascii?Q?QOTEIRSei6lDcVt+7vkzTKYoFJvbYSyYw816C+s8C9ofMzT7UAHw8xuzWlCB?=
 =?us-ascii?Q?/9WPas8NGt3HhnZLRqCKvPS68arnD/czxmlvj1Ao7cIU+2XWdRo6kdBB2var?=
 =?us-ascii?Q?el/8m2F2r+xBr0A3a6Wr5OyNa/zATsA/IMYfTcjSLnILr5sWaaImy4NFg86+?=
 =?us-ascii?Q?ZpPYJL1ICbX7s4+jq0Fsz/y4hVpIRZ5ex0UKKY1LIwd50cD+Vsr84Ypy4OWu?=
 =?us-ascii?Q?p3jlhqkyMb5MJ/61AtVSjfwuwVnU6xzdUfXXGrpNt3y4gTFbrp3ZDYb0z+Hn?=
 =?us-ascii?Q?Z47nLW68n5lfFX6J/CJg3l8dbTv49bJKBPkIHakneR7G2hude05bfDrwu+07?=
 =?us-ascii?Q?5V9G6IIes7yRgOyfc55yf5f0u8EypMQOHE01Moa1Lofz7XoAFqs8YxHbJnkB?=
 =?us-ascii?Q?j5dVF3GxgP2pHVJPISjgjsG1Vtbp0UVuavOCJzH9+UTPC8wvsE5s/QK1pYeT?=
 =?us-ascii?Q?/9Xj55XUaI8cEUHYpO48FOzERe2UBkIv1frzNoBUbFv17jy4BdOv+oQH4mcg?=
 =?us-ascii?Q?isKq+1/GSuvlBsY1QGXu28j7l8YDBNXEE62lwFJ6+1r8c1dFCBtotFPx9JlQ?=
 =?us-ascii?Q?D2j88WF3RgLPNzuLcqZVcS/Nq2FILBcZ8TjR2cq56kmTISr3QEJnc2x0qJSF?=
 =?us-ascii?Q?0rsxaB10BAhorBemW9/UJK4y6jtPPW2p9WLmu/SQYfMGldlr+z8grduu4rVr?=
 =?us-ascii?Q?eWrlUEZfh9uMdGStBQB6Soc3dlfhckdsOYn8pmlBiLkqxNOZ5cy18zNM1ycO?=
 =?us-ascii?Q?5eMxPdubEXXBAdTwwHh7+km5yFngUBvzcdfMhqpztZ+LWktggXPPGPhmL7il?=
 =?us-ascii?Q?dBbwBiirRh7ma9i9RaGnZvZBCDi9m2Bp7caNzUL2KCKGTgSzGk4zET/Oyvi9?=
 =?us-ascii?Q?ZRqznzDmaW2HguyGz7Evy1FySum9FGim9hmwZ3KuLsn9gVIcmArXhz9AKldI?=
 =?us-ascii?Q?Iz6Ysraf3ChndFNNGXiVX9VJeAPrqK0MgFnrm0cgjPOFuROimkLBcWTgdt+w?=
 =?us-ascii?Q?W3X+7r1NHlfx6MryDcRBGPsIsRgtRUC4LggerNUXbyeMzcKXOtqCckQ9xZd2?=
 =?us-ascii?Q?YUsb+442zffxPwIK8a8QrjwTIBvjbBi+sp9dq95lRp6fKpMqugtilZSLjOKA?=
 =?us-ascii?Q?ZsVLhA5Uci1pxcpKzyZ/g+Y1pFhmZ6xI71V32SE2jA7DH293MbLN0jKEq3Us?=
 =?us-ascii?Q?aWyr2ds/OAao1GNLiN6VYVCiqxP0J6m0lrjatYfrqBaeOAq7KzFHdftVWw76?=
 =?us-ascii?Q?5OA8pIB5xWEDwQrfZXV7+3NF59aRPhI0+RhXPYvS9STJiaYbOSd4PvY/5ERg?=
 =?us-ascii?Q?WBemDs4Fs9CyfkBE0ivvHr0okYdukGS4TUZ364sAcM8CVGqYJJ6Ak8zgFrdi?=
 =?us-ascii?Q?hzQ4eMhpWdnEbQhtBo5oRbqEGDYHYsUMZ2lSy7mDQh5Y8ENcB70R+J5Xuy1y?=
 =?us-ascii?Q?L5RdwXjAakSUP3kFDG8Z3awR1GCgLQI5ihlm5FZPqPoAWfBn/jtaKZDB9sfC?=
 =?us-ascii?Q?zg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b411a09-3638-4a8c-85d8-08da8ac234b6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2022 19:59:54.0730
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T/K/rCE7rf8JL+io/Zj1LICkprJCO0vvFjKBp4pSThrH7duWwSC1OP/48DkBFh23vXfguVBBqLPDLRVvW5d/RQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6270
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
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
 include/net/dsa.h  |   6 ++
 net/dsa/dsa_priv.h |   5 ++
 net/dsa/master.c   |  59 +++++++++++++++++
 net/dsa/port.c     |   2 +-
 net/dsa/slave.c    | 157 +++++++++++++++++++++++++++++++++++++++++++--
 net/dsa/switch.c   |  22 +++++--
 6 files changed, 242 insertions(+), 9 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 3f717c3fcba0..53de8effad60 100644
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
 
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index d252a04ed725..5628cd5665b0 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -184,6 +184,11 @@ static inline int dsa_tag_protocol_overhead(const struct dsa_device_ops *ops)
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
index 2176c14b97a8..9a15135f72db 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -428,3 +428,62 @@ void dsa_master_teardown(struct net_device *dev)
 	 */
 	wmb();
 }
+
+int dsa_master_lag_setup(struct net_device *lag_dev, struct dsa_port *cpu_dp,
+			 struct netdev_lag_upper_info *uinfo,
+			 struct netlink_ext_ack *extack)
+{
+	bool master_setup = false;
+	struct net_device *lower;
+	struct list_head *iter;
+	int err;
+
+	/* To be eligible as a DSA master, a LAG must have all lower
+	 * interfaces be eligible DSA masters.
+	 */
+	netdev_for_each_lower_dev(lag_dev, lower, iter) {
+		if (!netdev_uses_dsa(lower)) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "All LAG ports must be eligible as DSA masters");
+			return -EINVAL;
+		}
+	}
+
+	if (!netdev_uses_dsa(lag_dev)) {
+		err = dsa_master_setup(lag_dev, cpu_dp);
+		if (err)
+			return err;
+	}
+
+	err = dsa_port_lag_join(cpu_dp, lag_dev, uinfo, extack);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "CPU port failed to join LAG");
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
index b719763fe97d..d152f7c7eb6d 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1392,6 +1392,7 @@ static int dsa_port_assign_master(struct dsa_port *dp,
 		return err;
 
 	dp->cpu_dp = master->dsa_ptr;
+	dp->cpu_port_in_lag = netif_is_lag_master(master);
 
 	return 0;
 }
@@ -1411,7 +1412,6 @@ int dsa_port_change_master(struct dsa_port *dp, struct net_device *master,
 	struct net_device *old_master = dsa_port_to_master(dp);
 	struct net_device *dev = dp->slave;
 	struct dsa_switch *ds = dp->ds;
-	int port = dp->index;
 	bool vlan_filtering;
 	int err, tmp;
 
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 00df6cf07866..1030988d797f 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2840,6 +2840,10 @@ dsa_master_prechangeupper_sanity_check(struct net_device *master,
 	if (netif_is_bridge_master(info->upper_dev))
 		return NOTIFY_DONE;
 
+	/* Allow LAG uppers */
+	if (netif_is_lag_master(info->upper_dev))
+		return NOTIFY_DONE;
+
 	extack = netdev_notifier_info_to_extack(&info->info);
 
 	NL_SET_ERR_MSG_MOD(extack,
@@ -2887,6 +2891,138 @@ dsa_bridge_prechangelower_sanity_check(struct net_device *new_lower,
 	return NOTIFY_DONE;
 }
 
+static void dsa_tree_migrate_ports_from_lag_master(struct dsa_switch_tree *dst,
+						   struct net_device *lag_dev)
+{
+	struct net_device *new_master;
+	struct dsa_port *dp;
+	int err;
+
+	new_master = dsa_tree_find_first_master(dst);
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
@@ -2930,6 +3066,10 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 		if (notifier_to_errno(err))
 			return err;
 
+		err = dsa_master_changeupper(dev, ptr);
+		if (notifier_to_errno(err))
+			return err;
+
 		break;
 	}
 	case NETDEV_CHANGELOWERSTATE: {
@@ -2937,12 +3077,21 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
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
index 4dfd68cf61c5..5c2451fe5461 100644
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


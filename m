Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F06F4F79FA
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 10:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243196AbiDGInP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 04:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243201AbiDGInJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 04:43:09 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2081.outbound.protection.outlook.com [40.107.94.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5553C6972B
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 01:41:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g/zVUqG3f168m68OcC7LMi0li1c7qtoO77k5zB79lCBtmcSiRv1OJp6MdykCIuReUN64cQxmaNuL5+0YulgMztVsI5kE4OKs9TwC1CXjjfIbzkYlBmh/w/8DDrtKcR3x+5OVRbVtB55VVxFfBE/zq964372WLDBrXuu9iezUQZzY3u17l4aVY3xwqWfE1xQJqq7XYAsxD/A4RVo2+DQu8N6gGD/hVaB+h5Xw0bHuHhE5EhOy9W3YlJh7PIDCnJXh1b4j5zxSOwyOuo4uyCymJRzBymVJokna0GUgjXLVN8ebtL8v0ECLkP3YSR7XLmtkgctxUR/StB3hcEdb86094Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DITxtLfLjUQLZulgvRgpfIiL7mHF6XLMPQ2q+Zme0Ss=;
 b=nl6Hfd0cg07JSA/sKYmAdV103ULSoZvdyCirub36kYKCIxcU2hKLewVAwlUYg2jN6hZwJ4ruL549rHllS9Q/1CxPFtveRq3iDvNKGGwH4cyzrTympX0lNETw9L0X0y+pZqeE2zkxc6MO5Th+zkfenWyRYBuEbzHYhM0DFRIwN6YM1V5Si78lJv4eTuoZZfdCyhinBjXMNI9n1P2QiOz47ybe70sVsdFeBWKQTZKiZqD4RPvANJogmOA55342WJPzRoPYdqj2h9fe9RHqFMbIMR9j7tV9XOBmE+kNuwzE3L7JEDoOTOp8HgWSbxYtYqHAjuik0LWyG99h3R0OeMCkxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DITxtLfLjUQLZulgvRgpfIiL7mHF6XLMPQ2q+Zme0Ss=;
 b=QfdG/YEMmbJt5Grk7YqfEjgWy3xxvAN830F6hmQq+X4sahR61kUx/+RFtgJcwax8jFixJTCtHM7RoObc7qGZtwfoeznikcuCcSzx8LK7cjkqIiS2gr55rBA+aFIZEerMLYz6nm2tzJPNNRBlosBP6auhdpx6PFDOyuFuJVE2iCY4lMdNumI+dslqAQe5QKUo6HRwaHX+Or5MqEh1wjSlGuh0tNWvD/OhpINPnFamdvnGZ1MusO8p0Z6MD98nyhu8Bl5s8o7i+4EsjWyGuCwdEdaVXE9l7J8chs471N0SQ019wrweaoPKOZSG5j4rhVV+7QGNg6LbDgZZmEaOCS7LWQ==
Received: from MW4PR04CA0059.namprd04.prod.outlook.com (2603:10b6:303:6a::34)
 by BN9PR12MB5115.namprd12.prod.outlook.com (2603:10b6:408:118::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Thu, 7 Apr
 2022 08:41:07 +0000
Received: from CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6a:cafe::ae) by MW4PR04CA0059.outlook.office365.com
 (2603:10b6:303:6a::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22 via Frontend
 Transport; Thu, 7 Apr 2022 08:41:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT036.mail.protection.outlook.com (10.13.174.124) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5144.20 via Frontend Transport; Thu, 7 Apr 2022 08:41:07 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 7 Apr
 2022 08:41:06 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 7 Apr 2022
 01:41:05 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Thu, 7 Apr
 2022 01:41:03 -0700
From:   Michael Guralnik <michaelgur@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <jiri@nvidia.com>, <ariela@nvidia.com>, <maorg@nvidia.com>,
        <saeedm@nvidia.com>, <kuba@kernel.org>, <moshe@nvidia.com>,
        Michael Guralnik <michaelgur@nvidia.com>
Subject: [RFC PATCH net-next 2/2] devlink: Add statistics to port get
Date:   Thu, 7 Apr 2022 11:40:50 +0300
Message-ID: <20220407084050.184989-3-michaelgur@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220407084050.184989-1-michaelgur@nvidia.com>
References: <20220407084050.184989-1-michaelgur@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 093b664c-4ead-453b-a0a8-08da18725bfc
X-MS-TrafficTypeDiagnostic: BN9PR12MB5115:EE_
X-Microsoft-Antispam-PRVS: <BN9PR12MB5115FD0E9339EF9DD01F086CAFE69@BN9PR12MB5115.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7ytwJEGP0TD2wkSGwRWvBy4KWHtwgbo3PE+qY3y1Rv9B/5pKlXrJZ+Wk7R4g9S8zYUk3NnTuWWtjcBvCcZ9a1fPuGCbGPK3yyvv6EPqecs0kUaPnCy5qW/XO+SaTxVt/LgVGL5WbIVnC+PRh7ZoHNIyp1Sy3VmpQctouXNu+Atljn+9WJ77ofw5IqlxHSXA7BJ31N6MSDt6NnZwIR8GlNxjqXIj9S2rXexkRHOlc6fKpWlM7WmB/oPIAQyOZAkvKiIiFGODM8L3VQLNXChhXOuWDKIlVK0APb2R6v43Kdi3sHoyrPr3TxzWW1aBY9LChkFjr86TJkbLPm9J3tt6Mc4KALJiMdGPlOW1U73c3h9l1ZXrgL6tY0U1DVtWFFBIZ5DvA+0mfR9F+b7BWOwyM4yaU7Dy0pbB2QBv5RjL3qTxpIgory4ctimjOPhCSBfB6kO1UiOBx1X/02tzh7IfRrKrCO1ZYWW059yUtlZ0vy+rgPQryu4mrc68BurFi1owvCB/1Dmz2QWQejcYmX3VtzW/B6rx8qhIkllpAypJSWewBKQTTSKSeXru58RTDM+qTjDKRoLW8vEU6Tm3sYU0Gz7I5uoQCQMO6/QhCdYV9RgVfqS54EpiPXP5nS1Y2Ij1BzzbRZCnm95uPHc4qAK41xn9NxKfWoeUcBMmOmtYzw8wIYaa3f4CV93Iq2Gx/SkQpWqHJkT2L8AMElIzRsbfQgg==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(83380400001)(316002)(186003)(1076003)(40460700003)(2906002)(26005)(8936002)(54906003)(5660300002)(508600001)(6916009)(107886003)(336012)(426003)(47076005)(2616005)(36756003)(4326008)(70586007)(81166007)(70206006)(8676002)(86362001)(6666004)(82310400005)(36860700001)(7696005)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 08:41:07.4030
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 093b664c-4ead-453b-a0a8-08da18725bfc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5115
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a list of all registered stats and their value to the port get
command.

Signed-off-by: Michael Guralnik <michaelgur@nvidia.com>
---
 include/uapi/linux/devlink.h |  4 ++++
 net/core/devlink.c           | 39 ++++++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index b897b80770f6..8da01e551695 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -553,6 +553,10 @@ enum devlink_attr {
 
 	DEVLINK_ATTR_REGION_MAX_SNAPSHOTS,	/* u32 */
 
+	DEVLINK_ATTR_STATS_ENTRY,		/* nested */
+	DEVLINK_ATTR_STATS_NAME,		/* string */
+	DEVLINK_ATTR_STATS_VALUE,		/* u64 */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 9636d7998630..b735cca727a7 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -1080,6 +1080,41 @@ devlink_nl_port_function_attrs_put(struct sk_buff *msg, struct devlink_port *por
 	return err;
 }
 
+static int devlink_port_stats_get(struct devlink_port *port)
+{
+	if (!port->stats.get)
+		return -EOPNOTSUPP;
+	return port->stats.get(port);
+}
+
+static int devlink_nl_port_stats_put(struct sk_buff *msg, struct devlink_port *port)
+{
+	struct nlattr *stats_attr, *stats_entry_attr;
+	struct devlink_port_stat_item *stats_item;
+	int err;
+
+	stats_attr = nla_nest_start(msg, DEVLINK_ATTR_STATS);
+	if (!stats_attr)
+		return -EMSGSIZE;
+
+	err = devlink_port_stats_get(port);
+	if (err)
+		return err;
+
+	list_for_each_entry(stats_item, &port->stats.stats_list, list) {
+		stats_entry_attr = nla_nest_start(msg, DEVLINK_ATTR_STATS_ENTRY);
+		if (!stats_entry_attr)
+			return -EMSGSIZE;
+
+		nla_put_string(msg, DEVLINK_ATTR_STATS_NAME, stats_item->stat->name);
+		nla_put_u32(msg, DEVLINK_ATTR_STATS_VALUE, stats_item->stat->val);
+
+		nla_nest_end(msg, stats_entry_attr);
+	}
+	nla_nest_end(msg, stats_attr);
+	return 0;
+}
+
 static int devlink_nl_port_fill(struct sk_buff *msg,
 				struct devlink_port *devlink_port,
 				enum devlink_command cmd, u32 portid, u32 seq,
@@ -1132,6 +1167,8 @@ static int devlink_nl_port_fill(struct sk_buff *msg,
 	if (devlink_nl_port_function_attrs_put(msg, devlink_port, extack))
 		goto nla_put_failure;
 
+	if (devlink_nl_port_stats_put(msg, devlink_port))
+		goto nla_put_failure;
 	genlmsg_end(msg, hdr);
 	return 0;
 
@@ -8670,6 +8707,8 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_RATE_TX_MAX] = { .type = NLA_U64 },
 	[DEVLINK_ATTR_RATE_NODE_NAME] = { .type = NLA_NUL_STRING },
 	[DEVLINK_ATTR_RATE_PARENT_NODE_NAME] = { .type = NLA_NUL_STRING },
+	[DEVLINK_ATTR_STATS_NAME] = {.type = NLA_NUL_STRING },
+	[DEVLINK_ATTR_STATS_VALUE] = {.type = NLA_U64 },
 };
 
 static const struct genl_small_ops devlink_nl_ops[] = {
-- 
2.17.2


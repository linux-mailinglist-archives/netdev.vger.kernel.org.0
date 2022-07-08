Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67BE556C057
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 20:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238953AbiGHRns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 13:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238927AbiGHRnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 13:43:45 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130135.outbound.protection.outlook.com [40.107.13.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D51DD5A449;
        Fri,  8 Jul 2022 10:43:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lhjypxPtyysZT+xLzBf2efgFYxL5jENabDA+Cqh7iFZbr0zbO+YPNY3bh5+iP+oC5lJoYqRQrt8cjdX55Vdvtt8rQnvDHQ6pAJAqV5RiuviWnQw7x3snHkBMH+TM+nwUhpDsV4UD27Yl3YnCjZCdrOFEEP7p1K+aHKR1dlHRzSCheNP5BrNFjgmVWz0GTykLOvT16hmjix2l0aDLeSA2aJNJ31j/uSwxcFTfAu4Ng/jJBFRFF6iajMVT5TOUfXd+7nI1Gax17CkW30Lo/vzSByhXe0G8Uje/+hfbFH85DOe5xUmC4Z+E12cLh6/ke06W9GmLRexrKo5L2CDn6rrvlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vZ8sYFHsoS/cOOFa5qh4l4HRlGzM5FJje3Uwj9PpLQ4=;
 b=LrIvWVnuo4uXiS5xnSnEknNV3cF/BRO+nA42Hitqdxo6IrlbfcEdyOMAZglgn+ANERU31YwfNSk9aJ/PqjqUaarXXbhk/bLwYjqRWWqoZQ6RrytJkUftEb8782MjJfwDEzQoO0Xn7f5C/O3AdNkJLubu5gJfsyJXU03BgBWqTBSEJvqmazAJ9/zemXmENZeKmw9TVnzpIN4zc8GTIT84tnGnd/xjG47/hTN0h+9amSohju4Fa6D/7Y3dGbb+yFl9plV+2DHuL1W8Ghh9jiub0Qmrq6DAMGMPkPrBqfYVoRVwgjXNnqp3tK4v/ofBBU7jLa8IXpTcMUMTGqIicoou7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vZ8sYFHsoS/cOOFa5qh4l4HRlGzM5FJje3Uwj9PpLQ4=;
 b=OTYT2ThOVIK8DV1VkFhPi6TjYkmKJulNzk0QZDsApvmcitJiZB6QGDmQ017nRRrxIlw7TlIaaOTW7rJBG+K3rjZpN5rtbgybqfov2wVTXu3sV0yQlGs1NMznOuOQPCoysCQ5hVCbuQU3YlZXvCj5OZjLNwZ363M1TSwCSS2PbDM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:5b::20)
 by AS8P190MB1414.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:3f1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.15; Fri, 8 Jul
 2022 17:43:39 +0000
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::25a3:3edc:9320:f35e]) by GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::25a3:3edc:9320:f35e%3]) with mapi id 15.20.5417.016; Fri, 8 Jul 2022
 17:43:39 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, oleksandr.mazur@plvision.eu,
        tchornyi@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lkp@intel.com,
        Yevhen Orlov <yevhen.orlov@plvision.eu>
Subject: [PATCH V4 net-next 1/4] net: marvell: prestera: rework bridge flags setting
Date:   Fri,  8 Jul 2022 20:43:21 +0300
Message-Id: <20220708174324.18862-2-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220708174324.18862-1-oleksandr.mazur@plvision.eu>
References: <20220708174324.18862-1-oleksandr.mazur@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: GV3P280CA0045.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:9::18) To GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:150:5b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 86950adb-05ff-4f9b-e599-08da6109641a
X-MS-TrafficTypeDiagnostic: AS8P190MB1414:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p+zkfT04s/p+L5J0duwOSce+q2NPR2FUEBef1260WQmkL6R3u41oxYyYLELhVw91nCjy7t8lUlZ0+YxiDNCKDugV6WcQOQcxNByrzF9SjhZw8RFwd2F3b0LkLNYT2yWqYNdAiaBJkIK3KR92ANTvgsDg8/6vNKZcx/XsvDRuAfetvq/2uoOfBdC0NFPy84IL3u53bTMS1YCxCEd04gftbVbjdal+4sj3JQ84DGbhSCxdNJPVs0yMOpp4DJtNCMqZIq1teDZfdb2cu/NFbvlTVSiDl791HARfQRTKSpSt1iDsSt0NITSuxp1IdcYw2Kj3dhsB518qcXywN6nP5loERo0fGUHrbLuODWvgbs2AIFI4A5xgjQx5MNu6jE/5YsTsGmrOK864PCoe2ICwSBQsVw9GfLYcDgcrgIQh8JpB7uQSqySFrILO+T74NFY77AYLjybbJzzhE++/Gh7ijBYzp8SvwDAG7jMjFykWx2kGrvonqo2PGQ3lJ4H9HBc4kteV1OFvqIb29oqKKCJANSEe1h+Wx4jRBjV1YvVHZ061xannMhXIPQ+RU3tEiLtUGXvxplW0N0Ly1bLLBUUrpUpJes4c0KHx7R3cz7q9fDCbG47R2l5Yl0I6DEeTCLrDtIYxuaPJwzDCf9vPUlCxUlJWRvjASD6VcNOXq+UNTDQ7+KfUTF3DkRk57hzuYup5tbhZ5j5cR3d1493JHPWIfDlJMZgEFof0CgRx+cKEIdwzaAXRZKUbb2anbEPmhbkdqFQPeLKMJLEZBLMi5B+vU2swSP/9QsCdMSPmvs6Nh5m97Vf2Mekgfymn8/VmOPt47GF8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1P190MB2019.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(346002)(39830400003)(376002)(136003)(4326008)(66556008)(2906002)(52116002)(478600001)(316002)(6666004)(86362001)(6916009)(36756003)(6486002)(41300700001)(6512007)(6506007)(66946007)(26005)(8676002)(66476007)(1076003)(83380400001)(38350700002)(38100700002)(2616005)(44832011)(5660300002)(8936002)(186003)(107886003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1MvphboMDDk6EH7WAAgJiphKmdY6kh/HIFAU5xEYXEcrfW9OxbTBIEG0y3To?=
 =?us-ascii?Q?OZRCw2Q2rQb1IQDxFQhxwLKWQ1mufbS5BgPSVJuEhxJgyoXpFoV2eXvQ0cfE?=
 =?us-ascii?Q?IeZdBAZ+sqDjMIwedZCPxcH8vD6kCw4d8Le9u9CLZDHx3X+zUzXuhlV+l7od?=
 =?us-ascii?Q?fcEtQ0406x6wuTqya0+UvuWTDAhKX/UvyjkijCMJW8mvgM2ERZHUv/nffIgt?=
 =?us-ascii?Q?jvVIMNpvdokqd9BU9lqvJZS1khgwuHAKy78mm9MZwlMNgjvBNbzkMK0VhX9t?=
 =?us-ascii?Q?ks9b+MZJePHiv8qgFNshOymR3Nb+WBhFNHsteqZtv+9a6YeMm38TuUUvoIqX?=
 =?us-ascii?Q?hBhp/piludtouzjdXSxxsmSRMnJaPAbCci0RcwuHX+KWdv6NW7aqgy8X9aoz?=
 =?us-ascii?Q?MQNdkBI7o9ZrZSKL+IlKFJMWFqKnep5NuIziBHuP92RG+sgybdJsqvqRsqz8?=
 =?us-ascii?Q?IiXH2xLMduQFqWie78pFgjnWDV4EGaHz9jxy3A7zYhS10QSs0+WsPXjQXIth?=
 =?us-ascii?Q?oOK2E5aG0OldRhEz9TiUyfDAL5MYw+t7OZWMQ/mvlp/Ky8FAJROfpi48Fulw?=
 =?us-ascii?Q?lD2rrCWAkka5jAIfPpmQnbKKaqS4QWyxVkxXCSwDOzIFurAEzh+XnRfaRUuf?=
 =?us-ascii?Q?/QVCFI0jPGu13Ir/IPDxmkhE+Bq8pd9TW0FrV99QOeC16az2LgykUiWTyOnV?=
 =?us-ascii?Q?4cHkDUkXTh/YE8HrHiq2Z1svbAUvqUmFvk7mXhRcuJQQur3W3Xvjm3oHqk2s?=
 =?us-ascii?Q?Z6nMBRA6Rh9X8i7Ulk7t9OEs4K7Nb36Yd2y5DkPG8iNUr7H/4Qm7ss/kOq25?=
 =?us-ascii?Q?0bESJIPU+N1xoCagJhCXX54RTXc7YwhmDd3OiqSxKkQBp8EbFPu7xWv7tqsv?=
 =?us-ascii?Q?CDs9ike0D66YG51aDlpRWL8DbXbxqmEdiuLDCjaoCMCcv+lmxVpkZNdtZ9ZM?=
 =?us-ascii?Q?WewxmrsuT18DeuzxkDHsshkeQnn1+rdtfs+63F23/HfGMtG/NA5HlmF48Ykd?=
 =?us-ascii?Q?KSbyTq0mSmw1+QtS34ZMe4F/743JaX53aA1oeHXMqjrjnvdbNvxPkQFUz5R9?=
 =?us-ascii?Q?UBrKiM8fiNvPaCqjtMY+Crmo3ksULwdby8io4SIKqWWHe/g0s1hXo22UtfLl?=
 =?us-ascii?Q?AK5md/PFYFs6SUZeTiNtFLGQqu9hSnVWfq5OJQDAuS2P6jUXFNy8zhyrp2cM?=
 =?us-ascii?Q?jXQ1zTtyAWh30bXPWvHYM07XdRZBoduLYaZI6oE08EVrIDHiXZ3BlmYQirB8?=
 =?us-ascii?Q?nmksFx/tdzVV8NDymL1NBIa3z6QzLcnasc+8wIT7J4dbjZdTfxM4SIygt0kw?=
 =?us-ascii?Q?kBmblit/vddOWLhnB31KEsA1t8DfYi8O4cZWW/v5bHp0y0DCpb7bLMvOEWow?=
 =?us-ascii?Q?jjCX1UGPcbJ2nVeJz6LiuoRixbo7FrgEIcEpZIZdvqBGqGvn5CK+brasz79b?=
 =?us-ascii?Q?mOLWZjkxXMxX4rh0cYPNwZzE/BEPxJWlJBAMSavf4LUvMLE68T1pUT6pr0UN?=
 =?us-ascii?Q?L5+uTfSxGjwg8Fl+PWXS/fQBVhdxjXV2JsfuMgJdGimdGb6u3JCH4cUFo00r?=
 =?us-ascii?Q?DIELyMCXVIKa8BzW0VmAAXhpqqmnsnz9aREWNbafIH/fbwVZ7FLzHNQqCqJT?=
 =?us-ascii?Q?UQ=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 86950adb-05ff-4f9b-e599-08da6109641a
X-MS-Exchange-CrossTenant-AuthSource: GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2022 17:43:38.9680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QpPrmxoNC9YRQx3whKSjhqYJmJbVVGzoLHwsecNNOcQCXlmTxp6AxWoC1JhMHhofxd1plvwmJ/14vZ4kFWBNCzkoCZJa93GeZ7yjRp3h2v4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8P190MB1414
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Separate flags to make it possible to alter them separately;
Move bridge flags setting logic from HW API level to prestera_main
  where it belongs;
Move bridge flags parsing (and setting using prestera API) to
  prestera_switchdev.c - module responsible for bridge operations
  handling;

Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
 .../net/ethernet/marvell/prestera/prestera.h  |  4 +
 .../ethernet/marvell/prestera/prestera_hw.c   | 54 +------------
 .../ethernet/marvell/prestera/prestera_hw.h   |  4 +-
 .../ethernet/marvell/prestera/prestera_main.c | 15 ++++
 .../marvell/prestera/prestera_switchdev.c     | 79 +++++++++++--------
 5 files changed, 67 insertions(+), 89 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index 0bb46eee46b4..cab80e501419 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -331,6 +331,10 @@ struct prestera_port *prestera_port_dev_lower_find(struct net_device *dev);
 
 void prestera_queue_work(struct work_struct *work);
 
+int prestera_port_learning_set(struct prestera_port *port, bool learn_enable);
+int prestera_port_uc_flood_set(struct prestera_port *port, bool flood);
+int prestera_port_mc_flood_set(struct prestera_port *port, bool flood);
+
 int prestera_port_pvid_set(struct prestera_port *port, u16 vid);
 
 bool prestera_netdev_check(const struct net_device *dev);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
index 79fd3cac539d..b00e69fabc6b 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
@@ -1531,7 +1531,7 @@ int prestera_hw_port_learning_set(struct prestera_port *port, bool enable)
 			    &req.cmd, sizeof(req));
 }
 
-static int prestera_hw_port_uc_flood_set(struct prestera_port *port, bool flood)
+int prestera_hw_port_uc_flood_set(const struct prestera_port *port, bool flood)
 {
 	struct prestera_msg_port_attr_req req = {
 		.attr = __cpu_to_le32(PRESTERA_CMD_PORT_ATTR_FLOOD),
@@ -1549,7 +1549,7 @@ static int prestera_hw_port_uc_flood_set(struct prestera_port *port, bool flood)
 			    &req.cmd, sizeof(req));
 }
 
-static int prestera_hw_port_mc_flood_set(struct prestera_port *port, bool flood)
+int prestera_hw_port_mc_flood_set(const struct prestera_port *port, bool flood)
 {
 	struct prestera_msg_port_attr_req req = {
 		.attr = __cpu_to_le32(PRESTERA_CMD_PORT_ATTR_FLOOD),
@@ -1567,56 +1567,6 @@ static int prestera_hw_port_mc_flood_set(struct prestera_port *port, bool flood)
 			    &req.cmd, sizeof(req));
 }
 
-static int prestera_hw_port_flood_set_v2(struct prestera_port *port, bool flood)
-{
-	struct prestera_msg_port_attr_req req = {
-		.attr = __cpu_to_le32(PRESTERA_CMD_PORT_ATTR_FLOOD),
-		.port = __cpu_to_le32(port->hw_id),
-		.dev = __cpu_to_le32(port->dev_id),
-		.param = {
-			.flood = flood,
-		}
-	};
-
-	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_SET,
-			    &req.cmd, sizeof(req));
-}
-
-int prestera_hw_port_flood_set(struct prestera_port *port, unsigned long mask,
-			       unsigned long val)
-{
-	int err;
-
-	if (port->sw->dev->fw_rev.maj <= 2) {
-		if (!(mask & BR_FLOOD))
-			return 0;
-
-		return prestera_hw_port_flood_set_v2(port, val & BR_FLOOD);
-	}
-
-	if (mask & BR_FLOOD) {
-		err = prestera_hw_port_uc_flood_set(port, val & BR_FLOOD);
-		if (err)
-			goto err_uc_flood;
-	}
-
-	if (mask & BR_MCAST_FLOOD) {
-		err = prestera_hw_port_mc_flood_set(port, val & BR_MCAST_FLOOD);
-		if (err)
-			goto err_mc_flood;
-	}
-
-	return 0;
-
-err_mc_flood:
-	prestera_hw_port_mc_flood_set(port, 0);
-err_uc_flood:
-	if (mask & BR_FLOOD)
-		prestera_hw_port_uc_flood_set(port, 0);
-
-	return err;
-}
-
 int prestera_hw_vlan_create(struct prestera_switch *sw, u16 vid)
 {
 	struct prestera_msg_vlan_req req = {
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
index aa74f668aa3c..d3fdfe244f87 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
@@ -179,8 +179,8 @@ int prestera_hw_port_stats_get(const struct prestera_port *port,
 			       struct prestera_port_stats *stats);
 int prestera_hw_port_speed_get(const struct prestera_port *port, u32 *speed);
 int prestera_hw_port_learning_set(struct prestera_port *port, bool enable);
-int prestera_hw_port_flood_set(struct prestera_port *port, unsigned long mask,
-			       unsigned long val);
+int prestera_hw_port_uc_flood_set(const struct prestera_port *port, bool flood);
+int prestera_hw_port_mc_flood_set(const struct prestera_port *port, bool flood);
 int prestera_hw_port_accept_frm_type(struct prestera_port *port,
 				     enum prestera_accept_frm_type type);
 /* Vlan API */
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 3952fdcc9240..0e8eecbe13e1 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -35,6 +35,21 @@ void prestera_queue_work(struct work_struct *work)
 	queue_work(prestera_owq, work);
 }
 
+int prestera_port_learning_set(struct prestera_port *port, bool learn)
+{
+	return prestera_hw_port_learning_set(port, learn);
+}
+
+int prestera_port_uc_flood_set(struct prestera_port *port, bool flood)
+{
+	return prestera_hw_port_uc_flood_set(port, flood);
+}
+
+int prestera_port_mc_flood_set(struct prestera_port *port, bool flood)
+{
+	return prestera_hw_port_mc_flood_set(port, flood);
+}
+
 int prestera_port_pvid_set(struct prestera_port *port, u16 vid)
 {
 	enum prestera_accept_frm_type frm_type;
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
index b4599fe4ca8d..7002c35526d2 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
@@ -74,6 +74,39 @@ static void prestera_bridge_port_put(struct prestera_bridge_port *br_port);
 static int prestera_port_vid_stp_set(struct prestera_port *port, u16 vid,
 				     u8 state);
 
+static void
+prestera_br_port_flags_reset(struct prestera_bridge_port *br_port,
+			     struct prestera_port *port)
+{
+	prestera_port_uc_flood_set(port, false);
+	prestera_port_mc_flood_set(port, false);
+	prestera_port_learning_set(port, false);
+}
+
+static int prestera_br_port_flags_set(struct prestera_bridge_port *br_port,
+				      struct prestera_port *port)
+{
+	int err;
+
+	err = prestera_port_uc_flood_set(port, br_port->flags & BR_FLOOD);
+	if (err)
+		goto err_out;
+
+	err = prestera_port_mc_flood_set(port, br_port->flags & BR_MCAST_FLOOD);
+	if (err)
+		goto err_out;
+
+	err = prestera_port_learning_set(port, br_port->flags & BR_LEARNING);
+	if (err)
+		goto err_out;
+
+	return 0;
+
+err_out:
+	prestera_br_port_flags_reset(br_port, port);
+	return err;
+}
+
 static struct prestera_bridge_vlan *
 prestera_bridge_vlan_create(struct prestera_bridge_port *br_port, u16 vid)
 {
@@ -461,19 +494,13 @@ prestera_bridge_1d_port_join(struct prestera_bridge_port *br_port)
 	if (err)
 		return err;
 
-	err = prestera_hw_port_flood_set(port, BR_FLOOD | BR_MCAST_FLOOD,
-					 br_port->flags);
-	if (err)
-		goto err_port_flood_set;
-
-	err = prestera_hw_port_learning_set(port, br_port->flags & BR_LEARNING);
+	err = prestera_br_port_flags_set(br_port, port);
 	if (err)
-		goto err_port_learning_set;
+		goto err_flags2port_set;
 
 	return 0;
 
-err_port_learning_set:
-err_port_flood_set:
+err_flags2port_set:
 	prestera_hw_bridge_port_delete(port, bridge->bridge_id);
 
 	return err;
@@ -592,8 +619,7 @@ void prestera_bridge_port_leave(struct net_device *br_dev,
 
 	switchdev_bridge_port_unoffload(br_port->dev, NULL, NULL, NULL);
 
-	prestera_hw_port_learning_set(port, false);
-	prestera_hw_port_flood_set(port, BR_FLOOD | BR_MCAST_FLOOD, 0);
+	prestera_br_port_flags_reset(br_port, port);
 	prestera_port_vid_stp_set(port, PRESTERA_VID_ALL, BR_STATE_FORWARDING);
 	prestera_bridge_port_put(br_port);
 }
@@ -603,26 +629,14 @@ static int prestera_port_attr_br_flags_set(struct prestera_port *port,
 					   struct switchdev_brport_flags flags)
 {
 	struct prestera_bridge_port *br_port;
-	int err;
 
 	br_port = prestera_bridge_port_by_dev(port->sw->swdev, dev);
 	if (!br_port)
 		return 0;
 
-	err = prestera_hw_port_flood_set(port, flags.mask, flags.val);
-	if (err)
-		return err;
-
-	if (flags.mask & BR_LEARNING) {
-		err = prestera_hw_port_learning_set(port,
-						    flags.val & BR_LEARNING);
-		if (err)
-			return err;
-	}
-
-	memcpy(&br_port->flags, &flags.val, sizeof(flags.val));
-
-	return 0;
+	br_port->flags &= ~flags.mask;
+	br_port->flags |= flags.val & flags.mask;
+	return prestera_br_port_flags_set(br_port, port);
 }
 
 static int prestera_port_attr_br_ageing_set(struct prestera_port *port,
@@ -918,14 +932,9 @@ prestera_port_vlan_bridge_join(struct prestera_port_vlan *port_vlan,
 	if (port_vlan->br_port)
 		return 0;
 
-	err = prestera_hw_port_flood_set(port, BR_FLOOD | BR_MCAST_FLOOD,
-					 br_port->flags);
-	if (err)
-		return err;
-
-	err = prestera_hw_port_learning_set(port, br_port->flags & BR_LEARNING);
+	err = prestera_br_port_flags_set(br_port, port);
 	if (err)
-		goto err_port_learning_set;
+		goto err_flags2port_set;
 
 	err = prestera_port_vid_stp_set(port, vid, br_port->stp_state);
 	if (err)
@@ -950,8 +959,8 @@ prestera_port_vlan_bridge_join(struct prestera_port_vlan *port_vlan,
 err_bridge_vlan_get:
 	prestera_port_vid_stp_set(port, vid, BR_STATE_FORWARDING);
 err_port_vid_stp_set:
-	prestera_hw_port_learning_set(port, false);
-err_port_learning_set:
+	prestera_br_port_flags_reset(br_port, port);
+err_flags2port_set:
 	return err;
 }
 
-- 
2.17.1


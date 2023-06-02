Return-Path: <netdev+bounces-7518-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD289720866
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 19:33:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 151B62819CF
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 17:33:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26CEF3331B;
	Fri,  2 Jun 2023 17:33:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14BB3332EE
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 17:33:22 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2065.outbound.protection.outlook.com [40.107.92.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 683181B8
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 10:33:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R6knR2IN4ckM09wOHsuoyWE9Qt2AfZdsg9aj6gmLUck5bx7dzYcZY2YMS2A1cHSA3BD8q5/tRbSAtu698UfNnVEpgRDkcJ4gExq6S0cyFhKdhFn9t/+JJpjXK5xcNjDaoBOZ+yRd/j+TMQDdeE+JIynzuOPZpywqLJytOu9JFgGBtKoEnoT3yu0Tg7xDQtyLfk6Q7rMy61BuY/qVOLCjp9+ZevQy+iDratmKlqqOs/8X8w8sG/frnddjYdr4zlj/9RbL11sPaxLWM7zBGbp/keFl617KoSR6nsy8mkIBfF/01GIqXytqFnKmMjyOHSCJwqH0ui2uUPnDnDgtGwJGpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r1h+HEanQUCXpVJfxGz6o9LcO5iw+vY5ietP3ctwNtI=;
 b=W3IFD1RV+C3OxvjCAc0PNsu9EdfnUOSuo4zM4YM7p90x6p4U2sNofThme4QOZhc9zHMlYl7TviznXLkIZ7Id3dP9iJM3mT4Wo/IGSJBda0CueQ+bkM2DY26XAiUkNJjg3tGjuWDnwtcD4A9YxFAsh7D9sa7r5tHDb9hwdzNNvszhvfdnsR7QS16tgfyfbY/lyZTNfdlakBePPIs7ktQLmZ+pETNbsaZeeaFo8JPgBkYMATAOQ7sOu0ODEo4qeYAUykAlpMNEmZx64wR3FUNpOpbT/ppOnu+2Vn7vBgVamhnbqqDUodFiCbv5KXclFJ8f2/tIlPs0Wt/kuItwfb74pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r1h+HEanQUCXpVJfxGz6o9LcO5iw+vY5ietP3ctwNtI=;
 b=o1679TZCVCbDx53jrNQ1sjvCKmOUut7WbmqaoJY1VMP5lIc/DyM3bmWwEdkw4fARrI0nP7K7Mb/I1KHOhwKKCLUjJFtnEY9ap/SiO4GckAMvgkJ89BXSCUN9Ilv5bm1Je24IMs60Gu2jhp8klHSXNqqqyMX1gLKqNhd9YZdmWkA=
Received: from BY3PR05CA0024.namprd05.prod.outlook.com (2603:10b6:a03:254::29)
 by SJ0PR12MB8165.namprd12.prod.outlook.com (2603:10b6:a03:4e4::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.23; Fri, 2 Jun
 2023 17:33:18 +0000
Received: from DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:a03:254:cafe::cf) by BY3PR05CA0024.outlook.office365.com
 (2603:10b6:a03:254::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.8 via Frontend
 Transport; Fri, 2 Jun 2023 17:33:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT022.mail.protection.outlook.com (10.13.172.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6455.26 via Frontend Transport; Fri, 2 Jun 2023 17:33:17 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 2 Jun
 2023 12:33:16 -0500
From: Shannon Nelson <shannon.nelson@amd.com>
To: <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC: <brett.creeley@amd.com>, <drivers@pensando.io>, Nitya Sunkad
	<nitya.sunkad@amd.com>, Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH net-next] ionic: add support for ethtool extended stat link_down_count
Date: Fri, 2 Jun 2023 10:32:52 -0700
Message-ID: <20230602173252.35711-1-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT022:EE_|SJ0PR12MB8165:EE_
X-MS-Office365-Filtering-Correlation-Id: d229d3d5-1b51-4476-789b-08db638f73eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	YucLXmgoL0XgwTlzMIeouaiPAOYbl16q0aTA85bdawG4QuMXvJp1slHrZR/ENThowg5Enbp2xoz6pk30KkBNUFhdy8wsJZG7pfTCsOenIpEsulyF25RyYGnNHfo6RA2IF0r7jbx/umzHbCuAkWHBg+czTjvtyJ8HeM+4Ef/1yCu9uqvgM1cN+R1dedmiEfHy1CF3AoQp9PG6Zz4izmj7MtFkrmnvNHCmj+mgJAxOp5HYC5NWDs5AVaTNiZ93283bHvVAZXZRriqc/7sRHT1/R6wU4WTqoV6KHl/FZuaBvauyjSvBKIHJGrMdaHVp3H2rOcIGZXnpg0WpGFsJaQ+tZiJra2ScFLeIMGZG+rgRvymYnKqJKaCsKt7WqifUKjsDEVHFhJmQ6vemRd+RtiWVZUJSuiw3cUie1C0b49DVSXTYNmAuXOEfv6XKqShdvyrI2veqPt5U/qhblomvr+s02QrZOguh2bFk4nuqf/KHnCRwl/x0w7j7Ror55JNZUAktpNiSRlbz+5GTmojvvph9E99wGDtw2fAVleOD8xsReD/5YH6pfRw+9bW35YL0f9KKxfkoJrdlrNoMJYEosfBsA58N+wBPJ0qIaYObWhhOzObHxVYY1Thmds2uhN62VmXiw0j3xoCgJUejR06EMNN/QW4N2VzUAu+b6+W8RM6wbMRCz1vuqSUY7WD0XYqEUN7uaaMvFcR1x5lxpisfLO9h0msh/3q2gRRtRy8rc3hj61euoHBmWVICcT5Wuel71h3qyY6ppi6NDTnkzjLDIYJJXw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(346002)(396003)(39860400002)(451199021)(46966006)(40470700004)(36840700001)(82740400003)(356005)(82310400005)(81166007)(40460700003)(110136005)(86362001)(4326008)(70206006)(70586007)(54906003)(40480700001)(36756003)(478600001)(186003)(6666004)(47076005)(16526019)(26005)(1076003)(44832011)(2616005)(8936002)(8676002)(2906002)(5660300002)(336012)(36860700001)(316002)(41300700001)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 17:33:17.8560
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d229d3d5-1b51-4476-789b-08db638f73eb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8165
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Nitya Sunkad <nitya.sunkad@amd.com>

Following the example of 9a0f830f8026 ("ethtool: linkstate: add a statistic
for PHY down events"), added support for link down events.

Added callback ionic_get_link_ext_stats to ionic_ethtool.c to support
link_down_count, a property of netdev that gets incremented every time
the device link goes down.

Run ethtool -I <devname> to display the device link down count.

Signed-off-by: Nitya Sunkad <nitya.sunkad@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/net/ethernet/pensando/ionic/ionic_ethtool.c | 9 +++++++++
 drivers/net/ethernet/pensando/ionic/ionic_lif.c     | 1 +
 drivers/net/ethernet/pensando/ionic/ionic_lif.h     | 1 +
 3 files changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index 9b2b96fa36af..4c527a06e7d9 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -104,6 +104,14 @@ static void ionic_get_regs(struct net_device *netdev, struct ethtool_regs *regs,
 	memcpy_fromio(p + offset, lif->ionic->idev.dev_cmd_regs->words, size);
 }
 
+static void ionic_get_link_ext_stats(struct net_device *netdev,
+				     struct ethtool_link_ext_stats *stats)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+
+	stats->link_down_events = lif->link_down_count;
+}
+
 static int ionic_get_link_ksettings(struct net_device *netdev,
 				    struct ethtool_link_ksettings *ks)
 {
@@ -1074,6 +1082,7 @@ static const struct ethtool_ops ionic_ethtool_ops = {
 	.get_regs_len		= ionic_get_regs_len,
 	.get_regs		= ionic_get_regs,
 	.get_link		= ethtool_op_get_link,
+	.get_link_ext_stats	= ionic_get_link_ext_stats,
 	.get_link_ksettings	= ionic_get_link_ksettings,
 	.set_link_ksettings	= ionic_set_link_ksettings,
 	.get_coalesce		= ionic_get_coalesce,
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 957027e546b3..6ccc1ea91992 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -168,6 +168,7 @@ static void ionic_link_status_check(struct ionic_lif *lif)
 		}
 	} else {
 		if (netif_carrier_ok(netdev)) {
+			lif->link_down_count++;
 			netdev_info(netdev, "Link down\n");
 			netif_carrier_off(netdev);
 		}
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index c9c4c46d5a16..fd2ea670e7d8 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -201,6 +201,7 @@ struct ionic_lif {
 	u64 hw_features;
 	bool registered;
 	u16 lif_type;
+	unsigned int link_down_count;
 	unsigned int nmcast;
 	unsigned int nucast;
 	unsigned int nvlans;
-- 
2.17.1



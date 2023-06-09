Return-Path: <netdev+bounces-9435-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC007728F6C
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 07:50:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E46572817D5
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 05:50:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E025E1FD1;
	Fri,  9 Jun 2023 05:50:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE28185A
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 05:50:43 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2041.outbound.protection.outlook.com [40.107.223.41])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0262430D1
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 22:50:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hYeTcVwFolKrLeYnZuvSaD2yIsdXb/DeWH9baZC81KvAxvgkJlhE069E3yWtpDA3VL4aGdKvDVZ9HDdcS5G3TjUak/pLcmUvt5jblW716svLTT7XBU2g15QuDs/N8vsDP3MaRnNym8S1b8AssnlY+y9P0iOPgq+B763eQGz6xtmekah1ea58gmeS1wl1fs3I8oy80pFMWsHw8LxQ+7MdI/Dbpo8ha8winWZKGYFaT0tZfVF/v1jXK4m83GSQW/Icsvq4f2ykvQn6/Itq+vbnTHsKzvsRXLWPK1VtC3WXK5c1Wi8E46CF8ti5u9DOIuKVBQcZqqK9wq+9j38Q+a2ILg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XgNa6crWjFo/SsqaOfAvpEbgrxIE58bR6O/CcGkabrY=;
 b=iv53DfXF18MG4eaWlMsPHRsVlUtg6sbZfBt4vynQODEcyG7PLP+8pcBzv25V3HquWFpfqWzGVsVjox+IeJSKdVBsHIlf4Hn+2rha/7+snPIQJGH7Ql4WSw0xEHmS09qNlqreIVTg9N+rXPAzNgK6bgIFrh3eIk6DiqxuImMm62wgzQaMeOsamZWaxVsZRkOJyOCpkPWn744CCKPJDYdI3sQpu/VoKOVk7pXylzi6FPYEKJ+xS1vgLlm15Q6m97LBRBNw2AR8LI+x4cAcOuLNDxv/iNo1Do67dIWQ3KDklFxy7hwVVlVw0afj4kXFXIzi6TBAV/b1jEQFWRHE7zKvcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XgNa6crWjFo/SsqaOfAvpEbgrxIE58bR6O/CcGkabrY=;
 b=aHN3cnZup3iTeOU24vgdbWX4jiTicgjqVZfi/XQ7qRnLAfqoEKyQbc70PRDFkABH6n6wm/osJtz9Jz+TFLP/+pjB/I/bh7XLfXqY6mDMVfMz1cJXO/ZrYMBDDleZj2bw08aAImO9VVvBDnO5/xloeroJS0COzTEW5a46xMLoXqM=
Received: from SA0PR11CA0006.namprd11.prod.outlook.com (2603:10b6:806:d3::11)
 by DS7PR12MB5981.namprd12.prod.outlook.com (2603:10b6:8:7c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.19; Fri, 9 Jun
 2023 05:50:37 +0000
Received: from SN1PEPF0002636C.namprd02.prod.outlook.com
 (2603:10b6:806:d3:cafe::16) by SA0PR11CA0006.outlook.office365.com
 (2603:10b6:806:d3::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.26 via Frontend
 Transport; Fri, 9 Jun 2023 05:50:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002636C.mail.protection.outlook.com (10.167.241.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6477.24 via Frontend Transport; Fri, 9 Jun 2023 05:50:37 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 9 Jun
 2023 00:50:36 -0500
From: Shannon Nelson <shannon.nelson@amd.com>
To: <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC: <brett.creeley@amd.com>, <drivers@pensando.io>, Nitya Sunkad
	<nitya.sunkad@amd.com>, Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH v2 net-next] ionic: add support for ethtool extended stat link_down_count
Date: Thu, 8 Jun 2023 22:50:16 -0700
Message-ID: <20230609055016.44008-1-shannon.nelson@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636C:EE_|DS7PR12MB5981:EE_
X-MS-Office365-Filtering-Correlation-Id: 2335b958-b007-4128-a5ad-08db68ad7375
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ZBguUmZkSiniP/9WRfLdej5QBmgmZtV2wmjz2huc8oyJnUe7UT4EFOnksXL4R9Uh8tuHtNJGvJ58Y5EXUZiFWkkDsV+rg89XRBW6TitYYWmQ7zJJb9uvcTSfeROr9ObGRtuP9SGaITzsbHVG8PQYQAPDwHH84B5cnfBDGvXiOVVEmcLolXBoWbKNkp5BiYBGmQT3/OBV0kmXP2vOWh7li4h4wdTgSZYsTYvQnEdq86nd99sos41dmHu0fupLOYmfEyy6vZU/FahIjD94/X9lh5MVOQxFNQmY7A6ogdhJOXUJkfWPJD7JpJSfo5VMX2SR5I32Kn/MtbirzpNRnR5Y3trd20qkfPefbjVXErrJ2OvQuKtjM36brpQsl9RTKR2vVl4uWrUpSh6KZT49dnR36yAfS3SoEugIuIDLTbptB/k7tt03d8aJin3YV5dbMd6YNKFI/rWW6RzZO4Q7imGGm7sKDLm1UzZ/YUDFRY5aLbzhDZN9Ho8gxrMzuLArDRdd+7LZzf67Hw8Gxvvb+kc2lJM/a2XEW510V7Yx/TfZhcM7KH9ZfPe4+AN1HZ+wgu8xDAg+PgdD69ne8XNohjjqGNBsEcovQiZPCxmvrqBDJ6U9r8nZt9ynnUdciEdeF68YEAp0S6uOoeS+HEIufmNbBCFZWDbiAw3brfu+sUGQfmBo3e5uUYE6XXLxFjn1RXLNIOn4MUAsG30SJ0cxdoF0OtLhwz1NPZW7CS6JSdlJ3ygW3Xm1lmJf7LPXrQj+ok84Jw0fnoHTFE62HNmRyHA/PQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(376002)(39860400002)(396003)(451199021)(40470700004)(46966006)(36840700001)(86362001)(40460700003)(316002)(44832011)(2906002)(54906003)(110136005)(8676002)(8936002)(82310400005)(41300700001)(82740400003)(5660300002)(356005)(36756003)(4326008)(81166007)(70586007)(70206006)(40480700001)(6666004)(478600001)(36860700001)(16526019)(186003)(426003)(47076005)(2616005)(336012)(26005)(1076003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 05:50:37.7996
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2335b958-b007-4128-a5ad-08db68ad7375
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5981
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Nitya Sunkad <nitya.sunkad@amd.com>

Following the example of 'commit 9a0f830f8026 ("ethtool: linkstate:
add a statistic for PHY down events")', added support for link down
events.

Added callback ionic_get_link_ext_stats to ionic_ethtool.c to support
link_down_count, a property of netdev that gets reported exclusively
on physical link down events.

Run ethtool -I <devname> to display the device link down count.

Signed-off-by: Nitya Sunkad <nitya.sunkad@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
v2: Report link_down_count only on PF, not on VF

 drivers/net/ethernet/pensando/ionic/ionic_ethtool.c | 10 ++++++++++
 drivers/net/ethernet/pensando/ionic/ionic_lif.c     |  1 +
 drivers/net/ethernet/pensando/ionic/ionic_lif.h     |  1 +
 3 files changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index 9b2b96fa36af..3a6b0a9bc241 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -104,6 +104,15 @@ static void ionic_get_regs(struct net_device *netdev, struct ethtool_regs *regs,
 	memcpy_fromio(p + offset, lif->ionic->idev.dev_cmd_regs->words, size);
 }
 
+static void ionic_get_link_ext_stats(struct net_device *netdev,
+				     struct ethtool_link_ext_stats *stats)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+
+	if (lif->ionic->pdev->is_physfn)
+		stats->link_down_events = lif->link_down_count;
+}
+
 static int ionic_get_link_ksettings(struct net_device *netdev,
 				    struct ethtool_link_ksettings *ks)
 {
@@ -1074,6 +1083,7 @@ static const struct ethtool_ops ionic_ethtool_ops = {
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



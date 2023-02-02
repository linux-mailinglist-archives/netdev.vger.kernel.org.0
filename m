Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 021CA687300
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 02:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbjBBBaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 20:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbjBBBaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 20:30:24 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2087.outbound.protection.outlook.com [40.107.244.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D480A6ACA3
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 17:30:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KIgo/0XG9fauGXnJL9mENiX2fCQkO8BtdkcmdY0Z5I3UzqR3RdB84gUMp8FsA3clPO83tJp9hPkH98xzTAmjwfmNqpuXrii4VXcpbvhQdnDdC3i50Tk29JYosVWG+Pm5wGja2aa+P5HMPA0jog9bo43ZRSzxNqYmZ7qzlrOXCzqwYwJ5iUGsqqgB57n/5TZJH7W852ucZgYCbNMHLe8U/jLM4SUnnrf0p7jsROBsXALobOUfBm28vKk4oX8SNvo6q01toguh+5MsZDCVUAeyCMXN7pVNVR7a7y5RzBKzJvUbrqJrMaK7bXovlobqmlRicEkMwLEfcw2Ylou135Yxkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gecqanyhNRfzJlbBQN8X569SoerkenoN73qNymGkL2s=;
 b=l/uLRGITdY7goAwquMadq/sKzZQrdPdQGjZybPdHCLkO6GkIkLdKXt7odY65W9KWxYKDzPrS1UT8XWX4mpKL72LnxPS1E3AijNXjUXSpo1LX78ZBG+Dv8HfB5LJ89HMwgPZK5jvX7W7rcXDa852K1ZJ7hxeKfjXg2jNIgTgDyL0kbs+TwGRcOg8QBFk9kthijWAWu9sBB7dDB2xBYbgCBG+LH3OFZ743Im5f6poO761HOavyQu1io6TT9ctdgRj1K+5RWMbQmfE9G9TVg2e82RbnvAQuhpo6s8uc50tNkFPw5ecyzUakgKOFVyAIa/YkT5KygCQUBES5bwpvzXFvWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gecqanyhNRfzJlbBQN8X569SoerkenoN73qNymGkL2s=;
 b=M49KaM0QJ7TzcK4GslH7v1OKfNcRMKqpWA8Yu1rnDtp/j6chMZPscfC9gfyF966Jsyb+W5nBp15sykjrG8DHqt7LIViQ28d0TqQ4sDpecFTemk1yPHz6F41XlarvwibDYiG/76+WRsIBpkfeNCWVhdaDUXYKHynrv5EpgVbTIo8=
Received: from CY5PR15CA0100.namprd15.prod.outlook.com (2603:10b6:930:7::20)
 by SJ0PR12MB6736.namprd12.prod.outlook.com (2603:10b6:a03:47a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Thu, 2 Feb
 2023 01:30:22 +0000
Received: from CY4PEPF0000C96A.namprd02.prod.outlook.com
 (2603:10b6:930:7:cafe::be) by CY5PR15CA0100.outlook.office365.com
 (2603:10b6:930:7::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25 via Frontend
 Transport; Thu, 2 Feb 2023 01:30:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C96A.mail.protection.outlook.com (10.167.241.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6064.17 via Frontend Transport; Thu, 2 Feb 2023 01:30:21 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 1 Feb
 2023 19:30:19 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH net 1/6] ionic: remove unnecessary indirection
Date:   Wed, 1 Feb 2023 17:29:57 -0800
Message-ID: <20230202013002.34358-2-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230202013002.34358-1-shannon.nelson@amd.com>
References: <20230202013002.34358-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C96A:EE_|SJ0PR12MB6736:EE_
X-MS-Office365-Filtering-Correlation-Id: be2df3b0-0de5-402e-294c-08db04bd0d19
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WdOWOCHmU5dB8gxheU4SPXl6WXuFB3bkq3iBF56BpqKaehFOXNG0OYCp5v0ad/w2NOeIb6O62agGDa7fuLkOlDmSUqA4mSW9xO3Kgr7KJgrLjs2zdS8jCkgpv62/cnL9W/jGeQsAZO2XHqYkN/xY/onI27XCrlqASmbVJhh/9eQBfkV39djGtyhlwCJuCs8kWnlYOXmGJooK3F9Wxntia5aL5mq76hIGSEnYW4UNYNbnkQGtUHnjLAvpSPllU4kFxQWRloN70TtbeQ7BoXoIhfJx40WF7FN+hHVnGu0atlFUAgvfuafD55m3eLTESA1ihUPsGpw4wpiG8h16rfXkjNiud1WcS540qmseoGmNSbR6etduoh2jFz/InxuWVBMKbAvJIYlRHq7qhD6RSRIDJ6xL95rSovEiNvRC/EJ10cmJgdXtVt0tYxqcSGv14GL3QmJOR2AIpor3n28Dk04Vw5iARj9juJP5qxzc+1DOSc4H7lbONjQ1re1LgUymLSRqzpQSFknkNSF7drOu+LThokU+wReQcoxcqF1Yjnwe4ouNftSnsHZRf0MLuLcXvt2tqp51vODIIvr8Sa8GVa2VFAxzW0u8XGzpYsH2WZkk32V3H/b0ovzNz9lKiLwQSqLyRJ3xzHw1OfUAwVz3euJBeVIKfFX82y+fQRzjV79AlYuSZciyg3PKWh6JIJDLRHxkdQrBptUporMIVP0O1gVJP8XEQrcoqP5l5z3Qu7qQunA=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(136003)(376002)(396003)(451199018)(40470700004)(36840700001)(46966006)(36756003)(110136005)(6666004)(47076005)(54906003)(83380400001)(82310400005)(426003)(2906002)(44832011)(1076003)(82740400003)(2616005)(81166007)(316002)(478600001)(70206006)(8676002)(70586007)(40460700003)(336012)(186003)(16526019)(36860700001)(26005)(356005)(41300700001)(86362001)(8936002)(40480700001)(5660300002)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 01:30:21.7046
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: be2df3b0-0de5-402e-294c-08db04bd0d19
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C96A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6736
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have the pointer already, don't need to go through the
lif struct for it.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 4dd16c487f2b..8499165b1563 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -148,7 +148,7 @@ static void ionic_link_status_check(struct ionic_lif *lif)
 			mutex_lock(&lif->queue_lock);
 			err = ionic_start_queues(lif);
 			if (err && err != -EBUSY) {
-				netdev_err(lif->netdev,
+				netdev_err(netdev,
 					   "Failed to start queues: %d\n", err);
 				set_bit(IONIC_LIF_F_BROKEN, lif->state);
 				netif_carrier_off(lif->netdev);
@@ -2463,7 +2463,7 @@ static int ionic_set_vf_rate(struct net_device *netdev, int vf,
 
 		ret = ionic_set_vf_config(ionic, vf, &vfc);
 		if (!ret)
-			lif->ionic->vfs[vf].maxrate = cpu_to_le32(tx_max);
+			ionic->vfs[vf].maxrate = cpu_to_le32(tx_max);
 	}
 
 	up_write(&ionic->vf_op_lock);
-- 
2.17.1


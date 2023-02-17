Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 777C869B5C6
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 23:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbjBQW5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 17:57:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbjBQW5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 17:57:41 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2059.outbound.protection.outlook.com [40.107.223.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E033767478
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 14:56:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jvWv7utDr03bYu3C1BolVhK9Q587paudty+xUEzfwlAWWaqX8WmhhReJ1Na86ZW2SaGV0PitFeT1jPvlu3MYyI4tnvfdldL6/7/iK5Xs/vBGzY1XyGKsBgXEBHx7/xY+2XYGBCEsJDEBzXsvsWbPlXRKQPtNYUaAzCBulq7+UQhuNjYQAHlNVvZYrVynFJ3kSOjbXZuP6lTEpkOSOFA7DqVtiLDagjU9u7zKTWUIbt7A6BKJJgfLb7ifrLmVmOg1yx5N8HKXPd/miHbDkikYQGVpXb8EhiV1wmSt2ZUywwpxhEUEanjxLQmcAaOkcxmD3O2bjrVNJf/cKga+3dJoWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/vfcsRDPSLVYzDolLpxg5sSZFBH4yLy+ZP2VPEG2aiE=;
 b=LW0LfYsfLYCW0CqcQIsNpA/xSqreVh3Is+G+Q/mGjiO3IJbG0wTW075JcB3TNor8f0NxYrd9qvh5niyD0BAMxav2O/MzcUDWa9ezl26wBiDZG66G6frOkN2j8yuktjIHv7+nYaXcIFQNTnlldK6iEVqiEljaX+/Kw3jMHC3N8JERMYqtxQCVZ436P8snDkKehDUd4iePXHSwnfgYwfF3kknDe+rd7zTmuDJoFYxYZz2wv/9pA8SuH2IzooMJxC8WvAgQWC7uVCC/zx2++cnKzNUP6qbsS4lfD/yCciZ0YhBvS2e4G3thr9FOhprfiElmHozVlb7pKMCvkP4kbgZ2kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/vfcsRDPSLVYzDolLpxg5sSZFBH4yLy+ZP2VPEG2aiE=;
 b=5lBnJN7VzmYvI9zxWCbfD82K0gmytsnwn91AtkeFJULX7cKXpvxfwqJDPvZu5rqc80J4BIw0ly/+RbEXoVUKMTWu7rXM/AeCo74WYv3obykuYfzbYB+fduuhYZU1qhFB2el1YgXofxN+oMeJj1NVFobu7jaP+G4QvbdA94XZUKs=
Received: from DS7PR05CA0020.namprd05.prod.outlook.com (2603:10b6:5:3b9::25)
 by PH7PR12MB6000.namprd12.prod.outlook.com (2603:10b6:510:1dc::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.22; Fri, 17 Feb
 2023 22:56:49 +0000
Received: from CO1PEPF00001A63.namprd05.prod.outlook.com
 (2603:10b6:5:3b9:cafe::83) by DS7PR05CA0020.outlook.office365.com
 (2603:10b6:5:3b9::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.11 via Frontend
 Transport; Fri, 17 Feb 2023 22:56:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF00001A63.mail.protection.outlook.com (10.167.241.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6134.14 via Frontend Transport; Fri, 17 Feb 2023 22:56:49 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 17 Feb
 2023 16:56:47 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <brett.creeley@amd.com>,
        Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH v3 net-next 13/14] pds_core: publish events to the clients
Date:   Fri, 17 Feb 2023 14:55:57 -0800
Message-ID: <20230217225558.19837-14-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230217225558.19837-1-shannon.nelson@amd.com>
References: <20230217225558.19837-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF00001A63:EE_|PH7PR12MB6000:EE_
X-MS-Office365-Filtering-Correlation-Id: 05fe378e-811f-4dc2-b80c-08db113a4094
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IBzhvEtYr5DV/9iIfuTUe70W8Q9oYMAO2cAIJqn8vaAo7WDPaUojW2mCIjQ6PozgmhXumT6N5g0azGRu7wESmK//OM3Pbl5Guz7CCNUdg80l7DkkFGBXnGWS2iTZrFpIbEN/7O2ZqaWqEiRzJ+tjtc1XG4/sTWE6WyJvVxWsdgdUYE+DHh3BooaSYdbgnPA1V72eeC6tEDtAwtpXrKKBjidqOqNVEOWKLsfhtCThm+G5DlnHFOGjohgbVrNBX3yHshAmxQ5kIgmI89kUoVKDvo1LS57UMzzh5qEuIgD3C1YfiNNnT+k8Uvj8RoJjX0pts+j72yn+8AWj+oyZNH2h/vtlZSsEclQoayZoie82YMDkIzlmovw6AJ2DSVzYGvEf6i4gP7V357Ko36XqlpJNcQRxVtGQHeqTbmLesDm/tWqaYNa7U62i0ZTzPul01BmC1/GYo21CojC3QybnhOY2rINwSL68SBA3QdS0ICWSMEQaE6/bAbvrQlGGz0t6gIBd411DI6tSaCjRfMFhGb+JWoMrw6CSLPyuR/UbsfEhvDdOz0HV5z8k3MgQ41JVKteQRMRRAGzJevCjf6NYhktFfa8SP4EgMb0yvKnIYg8B4hB4lA6GDmEJA2nH11TpUWAeSAkHlxoDSAnBO/3chd8lnvFldyDudQ4K7S5U5h1WjYdYwqQ2d/tq6LYUXAiy45jt0ZTxjZBeoEyLbAYJbBqrcRErkr1CZCJPBYchXcAZKaQ=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(376002)(346002)(39860400002)(451199018)(40470700004)(36840700001)(46966006)(478600001)(356005)(26005)(16526019)(40460700003)(2616005)(6666004)(82740400003)(81166007)(82310400005)(110136005)(1076003)(5660300002)(4326008)(47076005)(54906003)(44832011)(426003)(40480700001)(186003)(70206006)(336012)(36756003)(316002)(83380400001)(70586007)(8936002)(8676002)(2906002)(41300700001)(86362001)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 22:56:49.0758
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 05fe378e-811f-4dc2-b80c-08db113a4094
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF00001A63.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6000
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the Core device gets an event from the device, or notices
the device FW to be up or down, it needs to send those events
on to the clients that have an event handler.  Add the code to
pass along the events to either the specific client or to all
the clients.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/net/ethernet/amd/pds_core/adminq.c | 17 +++++++++
 drivers/net/ethernet/amd/pds_core/auxbus.c | 40 ++++++++++++++++++++++
 drivers/net/ethernet/amd/pds_core/core.c   | 15 ++++++++
 drivers/net/ethernet/amd/pds_core/core.h   |  3 ++
 4 files changed, 75 insertions(+)

diff --git a/drivers/net/ethernet/amd/pds_core/adminq.c b/drivers/net/ethernet/amd/pds_core/adminq.c
index 59a58305a08a..64ced7851549 100644
--- a/drivers/net/ethernet/amd/pds_core/adminq.c
+++ b/drivers/net/ethernet/amd/pds_core/adminq.c
@@ -34,11 +34,13 @@ static int pdsc_process_notifyq(struct pdsc_qcq *qcq)
 		case PDS_EVENT_LINK_CHANGE:
 			dev_info(pdsc->dev, "NotifyQ LINK_CHANGE ecode %d eid %lld\n",
 				 ecode, eid);
+			pdsc_auxbus_publish(pdsc, PDSC_ALL_CLIENT_IDS, comp);
 			break;
 
 		case PDS_EVENT_RESET:
 			dev_info(pdsc->dev, "NotifyQ RESET ecode %d eid %lld\n",
 				 ecode, eid);
+			pdsc_auxbus_publish(pdsc, PDSC_ALL_CLIENT_IDS, comp);
 			break;
 
 		case PDS_EVENT_XCVR:
@@ -46,6 +48,21 @@ static int pdsc_process_notifyq(struct pdsc_qcq *qcq)
 				 ecode, eid);
 			break;
 
+		case PDS_EVENT_CLIENT:
+		{
+			struct pds_core_client_event *ce;
+			union pds_core_notifyq_comp *cc;
+			u16 client_id;
+
+			ce = (struct pds_core_client_event *)comp;
+			cc = (union pds_core_notifyq_comp *)&ce->client_event;
+			client_id = le16_to_cpu(ce->client_id);
+			dev_info(pdsc->dev, "NotifyQ CLIENT %d ecode %d eid %lld cc->ecode %d\n",
+				 client_id, ecode, eid, le16_to_cpu(cc->ecode));
+			pdsc_auxbus_publish(pdsc, client_id, cc);
+			break;
+		}
+
 		default:
 			dev_info(pdsc->dev, "NotifyQ ecode %d eid %lld\n",
 				 ecode, eid);
diff --git a/drivers/net/ethernet/amd/pds_core/auxbus.c b/drivers/net/ethernet/amd/pds_core/auxbus.c
index 6d5e7e1d176c..be2b2ab35233 100644
--- a/drivers/net/ethernet/amd/pds_core/auxbus.c
+++ b/drivers/net/ethernet/amd/pds_core/auxbus.c
@@ -205,6 +205,46 @@ static struct pds_auxiliary_dev *pdsc_auxbus_dev_register(struct pdsc *pdsc,
 	return NULL;
 }
 
+static int pdsc_core_match(struct device *dev, const void *data)
+{
+	struct pds_auxiliary_dev *curr_padev;
+	struct pdsc *curr_pdsc;
+	const struct pdsc *pdsc;
+
+	/* Match the core device searching for its clients */
+	curr_padev = container_of(dev, struct pds_auxiliary_dev, aux_dev.dev);
+	curr_pdsc = (struct pdsc *)dev_get_drvdata(curr_padev->aux_dev.dev.parent);
+	pdsc = data;
+
+	if (curr_pdsc == pdsc)
+		return 1;
+
+	return 0;
+}
+
+int pdsc_auxbus_publish(struct pdsc *pdsc, u16 client_id,
+			union pds_core_notifyq_comp *event)
+{
+	struct pds_auxiliary_dev *padev;
+	struct auxiliary_device *aux_dev;
+
+	/* Search aux bus for this core's devices */
+	aux_dev = auxiliary_find_device(NULL, pdsc, pdsc_core_match);
+	while (aux_dev) {
+		padev = container_of(aux_dev, struct pds_auxiliary_dev, aux_dev);
+		if ((padev->client_id == client_id ||
+		     client_id == PDSC_ALL_CLIENT_IDS) &&
+		    padev->event_handler)
+			padev->event_handler(padev, event);
+		put_device(&aux_dev->dev);
+
+		aux_dev = auxiliary_find_device(&aux_dev->dev,
+						pdsc, pdsc_core_match);
+	}
+
+	return 0;
+}
+
 int pdsc_auxbus_dev_add_vf(struct pdsc *pdsc, int vf_id)
 {
 	struct pds_auxiliary_dev *padev;
diff --git a/drivers/net/ethernet/amd/pds_core/core.c b/drivers/net/ethernet/amd/pds_core/core.c
index 393ec10ad745..bbbffe358406 100644
--- a/drivers/net/ethernet/amd/pds_core/core.c
+++ b/drivers/net/ethernet/amd/pds_core/core.c
@@ -520,6 +520,11 @@ void pdsc_stop(struct pdsc *pdsc)
 
 static void pdsc_fw_down(struct pdsc *pdsc)
 {
+	union pds_core_notifyq_comp reset_event = {
+		.reset.ecode = cpu_to_le16(PDS_EVENT_RESET),
+		.reset.state = 0,
+	};
+
 	mutex_lock(&pdsc->config_lock);
 
 	if (test_and_set_bit(PDSC_S_FW_DEAD, &pdsc->state)) {
@@ -528,6 +533,9 @@ static void pdsc_fw_down(struct pdsc *pdsc)
 		return;
 	}
 
+	/* Notify clients of fw_down */
+	pdsc_auxbus_publish(pdsc, PDSC_ALL_CLIENT_IDS, &reset_event);
+
 	pdsc_mask_interrupts(pdsc);
 	pdsc_teardown(pdsc, PDSC_TEARDOWN_RECOVERY);
 
@@ -536,6 +544,10 @@ static void pdsc_fw_down(struct pdsc *pdsc)
 
 static void pdsc_fw_up(struct pdsc *pdsc)
 {
+	union pds_core_notifyq_comp reset_event = {
+		.reset.ecode = cpu_to_le16(PDS_EVENT_RESET),
+		.reset.state = 1,
+	};
 	int err;
 
 	mutex_lock(&pdsc->config_lock);
@@ -556,6 +568,9 @@ static void pdsc_fw_up(struct pdsc *pdsc)
 
 	mutex_unlock(&pdsc->config_lock);
 
+	/* Notify clients of fw_up */
+	pdsc_auxbus_publish(pdsc, PDSC_ALL_CLIENT_IDS, &reset_event);
+
 	return;
 
 err_out:
diff --git a/drivers/net/ethernet/amd/pds_core/core.h b/drivers/net/ethernet/amd/pds_core/core.h
index 7abd2cc4efc7..6f2421187ad5 100644
--- a/drivers/net/ethernet/amd/pds_core/core.h
+++ b/drivers/net/ethernet/amd/pds_core/core.h
@@ -303,6 +303,9 @@ int pdsc_start(struct pdsc *pdsc);
 void pdsc_stop(struct pdsc *pdsc);
 void pdsc_health_thread(struct work_struct *work);
 
+#define PDSC_ALL_CLIENT_IDS   0xffff
+int pdsc_auxbus_publish(struct pdsc *pdsc, u16 client_id,
+			union pds_core_notifyq_comp *event);
 int pdsc_auxbus_dev_add_vf(struct pdsc *pdsc, int vf_id);
 int pdsc_auxbus_dev_del_vf(struct pdsc *pdsc, int vf_id);
 
-- 
2.17.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7B41645092
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 01:46:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbiLGAp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 19:45:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbiLGAp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 19:45:26 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2087.outbound.protection.outlook.com [40.107.237.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B477D4E680
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 16:45:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LtlrhCCkdPdSKayTTpg/YPIe8dZ6uTgaNP84h4z5WjniYlhNOvcfkmc/+fcfiDwXXKRhEhlRyQ0J0yefyTIo9XxMEwM0HFuovUdBInyj6S4ZO48o9tCAbzu1hHsVT9zvw3yMlWJ9mIGC4KV6LMbeO7hfR2mrUF0wA/XNPRcWY79B/QAsjYXN1cjMdFOZv3KZfVIq2hqo/aUT9eN3VeaNLheO2AExrQJxoLO9BBKk1+cA+vI3PF8nIn8vMjSOw4qlEZl3Ehk2BwHGBG/i/yglOguZYHIESMRtUzmSLfh3DdSNRshJRvXe3ksSULeubmyemYHxCYp0sZaWp0mvWzaMiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GdZrI+mSjKE4Yzd0HOOXSpqCjdE+E9tyCmN7tuBUkBU=;
 b=FFBVz6x1RuuAB1VjEEOe//KbIoa6sW+JNbMRQG1koe00LL76/A9qu3J+ZCYdDs0LFFo204U3oWNBnNfIayh1gAnlDbR+YmswTK2+L9bnozAmupxNL32HklsgfpEyvM8MhbthkHsd40Rjs12OT+0O6N+jR4y2oxsq5uiIFw4SGzk62YFgHrb9o+l0p1CR7EpUXpIFtjzGEOg69ZXctZeWvKn2cpaem7niVffl5vdu9+ZwSeIijy/EKlEcCcB2s5gp6LMLMQ8Zsh5sOLw63qCmYF9UkCc1waMdm3U8JPyP9iLt4BdjPs+bsRl0jKk4xlxfQdPFZp5aGQNkgVpV/kKyXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GdZrI+mSjKE4Yzd0HOOXSpqCjdE+E9tyCmN7tuBUkBU=;
 b=yyYWCgDV8xIgRw9fcmc+WvMGthu0XlDB+7iRVb+wPOnsTfFcWlSuHyMGMk9HtanEhtGudjt9XvpnSmebn4YpuwUiIa+2zb1nFPONEmmZMJpFjF1YsTfSfRlskE10ga8AlEthF0Jh243D1KlVdD+1W4lf3c0OP3gD7NlYzS9eSyk=
Received: from BN9PR03CA0148.namprd03.prod.outlook.com (2603:10b6:408:fe::33)
 by IA1PR12MB6114.namprd12.prod.outlook.com (2603:10b6:208:3ea::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 00:45:16 +0000
Received: from BN8NAM11FT073.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fe:cafe::3) by BN9PR03CA0148.outlook.office365.com
 (2603:10b6:408:fe::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Wed, 7 Dec 2022 00:45:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT073.mail.protection.outlook.com (10.13.177.231) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5901.14 via Frontend Transport; Wed, 7 Dec 2022 00:45:16 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 6 Dec
 2022 18:45:14 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH v2 net-next 15/16] pds_core: publish events to the clients
Date:   Tue, 6 Dec 2022 16:44:42 -0800
Message-ID: <20221207004443.33779-16-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221207004443.33779-1-shannon.nelson@amd.com>
References: <20221207004443.33779-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT073:EE_|IA1PR12MB6114:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a90b8ec-2657-440b-19fb-08dad7ec4f2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uEgkr9Uc8CvhwiQleJ2OJBQb7nNbFg8oOuqn99xR0hze7NoWQulzEQfjakrRRxJ3hZI+DXY3L0ZzXN/MIo9Q6OE85qYthjzzL9KMGSmeaegjFOEBmdbrdAhkUCo9VZi2gtBEAGvDfVX2748xSM9qsBcvnsOnvGN+qIkdwuSWf3ejnnoAwuISxROQFkmb+39v1L6h96p1vT1vlTfW84+AoeE1PhvvPnj+UovdgH6NGD9OutDbN9/nG0owVtWAGrMIXs9/yuwK6FLD9H2yV27iOobyfZ5/k6KwgobR/t2Y+Gglf5HDMkqhv6aPp41O91Od293YsAQ+zcQ67rCBm/s3PhurVGd4RzVxGOU53GcomWvso4mxaSOYd5eK5+DLggc0TNRRfmOXgaE8S394aOIYaw7Xl/QEJ04eOgDhCX1L6ybb8YH4eUc45bpRaLxC7iaRULHU0FC2LI7M2uWBg+4YO1g0C8RZ6Kwv9FBxukiI4RoGGw4hvook0dAPeLmtqYtWcYf2JahYX3fCXIp+mTW8wqSCQNOxDmyiKAWWNb40mAVJ+Jj8M5GTvThW7ZZREDwNuv4WC1CTaIj+OcCxwsU9Ei2jndPdUz93uuQXjFUbelBa46dbHReqEzL94yeK/7nw+HCg/U1WcoiQHQWUWwXQ4PxVrS9uWkecxxm91Gtjp/2YwoM+9ripJgJ0OeNbZ/dbspd6Ags4vPNYrPaH5valRilRHkeb1xZKdyAzLtE07ao=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39860400002)(136003)(346002)(451199015)(36840700001)(40470700004)(46966006)(40480700001)(81166007)(36756003)(356005)(82740400003)(86362001)(40460700003)(316002)(110136005)(6666004)(54906003)(478600001)(44832011)(2906002)(5660300002)(8936002)(70586007)(41300700001)(36860700001)(4326008)(8676002)(70206006)(83380400001)(47076005)(2616005)(426003)(82310400005)(26005)(1076003)(336012)(16526019)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 00:45:16.6421
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a90b8ec-2657-440b-19fb-08dad7ec4f2c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT073.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6114
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
 .../net/ethernet/pensando/pds_core/adminq.c   | 17 ++++++++
 .../net/ethernet/pensando/pds_core/auxbus.c   | 40 +++++++++++++++++++
 drivers/net/ethernet/pensando/pds_core/core.c | 15 +++++++
 drivers/net/ethernet/pensando/pds_core/core.h |  3 ++
 4 files changed, 75 insertions(+)

diff --git a/drivers/net/ethernet/pensando/pds_core/adminq.c b/drivers/net/ethernet/pensando/pds_core/adminq.c
index ba9e84a7ca92..4d2d69ce81f4 100644
--- a/drivers/net/ethernet/pensando/pds_core/adminq.c
+++ b/drivers/net/ethernet/pensando/pds_core/adminq.c
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
diff --git a/drivers/net/ethernet/pensando/pds_core/auxbus.c b/drivers/net/ethernet/pensando/pds_core/auxbus.c
index e82f4e2ef458..55507a690a79 100644
--- a/drivers/net/ethernet/pensando/pds_core/auxbus.c
+++ b/drivers/net/ethernet/pensando/pds_core/auxbus.c
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
diff --git a/drivers/net/ethernet/pensando/pds_core/core.c b/drivers/net/ethernet/pensando/pds_core/core.c
index e6810f43df26..ac9fe716fb52 100644
--- a/drivers/net/ethernet/pensando/pds_core/core.c
+++ b/drivers/net/ethernet/pensando/pds_core/core.c
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
diff --git a/drivers/net/ethernet/pensando/pds_core/core.h b/drivers/net/ethernet/pensando/pds_core/core.h
index dbf1fe5135ad..ace1a1b1ec8f 100644
--- a/drivers/net/ethernet/pensando/pds_core/core.h
+++ b/drivers/net/ethernet/pensando/pds_core/core.h
@@ -302,6 +302,9 @@ int pdsc_start(struct pdsc *pdsc);
 void pdsc_stop(struct pdsc *pdsc);
 void pdsc_health_thread(struct work_struct *work);
 
+#define PDSC_ALL_CLIENT_IDS   0xffff
+int pdsc_auxbus_publish(struct pdsc *pdsc, u16 client_id,
+			union pds_core_notifyq_comp *event);
 int pdsc_auxbus_dev_add_vf(struct pdsc *pdsc, int vf_id);
 int pdsc_auxbus_dev_del_vf(struct pdsc *pdsc, int vf_id);
 
-- 
2.17.1


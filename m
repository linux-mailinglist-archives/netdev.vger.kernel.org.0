Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 982ED6AFE29
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 06:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbjCHFO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 00:14:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbjCHFOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 00:14:22 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2078.outbound.protection.outlook.com [40.107.102.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D172968F2
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 21:13:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WFQywoiJlR12e3p5HeW57TUiyI+3a12Sqeu18GdytBPsIjG3PiF9sfJbfAKBjA5dsawQNuhhnKkyvb4VV8EL+oBXL1w+99hCF4Jh2R7t71i9Yrdx7IJm+GFvdOe9DmGAkvGzxv2OXzoOlQJfqo6BIH+M0I4TVMog7kFBlrfruukCmNQZmwrzXku2yIuKN+huvreFzjRgmsKPcf8ZsMjgz31S/zAvalHpCMePzF8PiVs73TVNyzSYzajhXuKCL+tDmAgfxyvk9/6ZaZmDDeBdqu+bQafouPouhplOInhGWgMyincHD1EG5+x0uofqYMBcb1DQpYv8IyFMVjUarZngRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nFm8XLcfyQFphW2E6knbQPf7UnwLp3IU7KHAdZa0kLg=;
 b=VyxruA9PnG4jJYCL+5TUZyTMwFpFY/p+BjGoXR/V7+Zz6Ug95MCp1/SZAy1iTHvG9MOAAeYYf9UoGazoD+eE7xr1JP6kyESqE/Z16vps+nPMTXtokz9QgZHAmBy1wcbl+O+f+uJ5E/cx3oVmELnTZP17PVckz3fain6758NzaGkUIqFgg9Zpva+2wW22vfk7tHQQ2Oiri0gTCPnQdQa79AjzXQSydUZRlyo9YJESapy3cUhbCm+kL7W4OVs+ld4+W2qgS0nGJPc19rFigqi3pgJCtT9GNIWO/mgTJUxumwHuIgkWy0IV/aiuPFc8fH1IL9WHl7dB7n4kv5HmrhFMvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nFm8XLcfyQFphW2E6knbQPf7UnwLp3IU7KHAdZa0kLg=;
 b=eZytNyV9sgX1CT4ugUG0CQtmSJNmEhYIrHxcYcCLqlSTAhAoAsbrSwJVy8w5G5tHgEYXE/rQP2uwL6VhQsh6/Yyo1J7XOxFL0R7yyPkWD5iukHF/nqFSWokpBmqicWr05YS+gqx48vB8pa6a7CefWL/z4jv49mGLeBTCCugtc5U=
Received: from BN9P223CA0016.NAMP223.PROD.OUTLOOK.COM (2603:10b6:408:10b::21)
 by MW5PR12MB5683.namprd12.prod.outlook.com (2603:10b6:303:1a0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Wed, 8 Mar
 2023 05:13:45 +0000
Received: from BN8NAM11FT080.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10b:cafe::3e) by BN9P223CA0016.outlook.office365.com
 (2603:10b6:408:10b::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29 via Frontend
 Transport; Wed, 8 Mar 2023 05:13:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT080.mail.protection.outlook.com (10.13.176.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.17 via Frontend Transport; Wed, 8 Mar 2023 05:13:45 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 7 Mar
 2023 23:13:43 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH RFC v4 net-next 12/13] pds_core: publish events to the clients
Date:   Tue, 7 Mar 2023 21:13:09 -0800
Message-ID: <20230308051310.12544-13-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230308051310.12544-1-shannon.nelson@amd.com>
References: <20230308051310.12544-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT080:EE_|MW5PR12MB5683:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b22da47-c33f-4b8f-fe9b-08db1f93e448
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dCidH3YSzK7ySxsfHN5O/hXP6SvhQqo+OPMtrOdnMzoHse+zr/JK9M+ZJ26IRy9JJkLiqguFjCL2iKWtEag+/G7EBPSWubGtbX7NNkOwZ6dxnvPw1wxaP4pB1zKfqu0q2mQeLUBCrvnfvsw5ZNGY3BuT1iMYFEs8FonhXQ+BoYT43YlDcIslm5lrPcN6F2H03KRTPEWhDHVnuba0u/4Hg3b+nDsIohHKAiIgvVE4buuyi7R9T5YtdSJpyvinO06Mlfpm8eKIsm9S72TuPzgIyNJw8VgYq8dyF+lIzUvOadTz1tJyJT+N5KgNOHKbMR65fFdVB1YY2PkhjNeuSq1KZ15gKX9JinrjsIaapb5vdDt7fY7jHBEKNqEB9FOEugIE0QAIyao9Y/A/p1YJHILrDNbpSezQkTinWOYObcg6zEI8L3gTb+bNkgmTiU1j0p0djcrVZmR0i9MacJpDUMBSghFzTMaEfJX+l3eIZqKTNoSaq4MJi1Vv6DtWhfQkQGQ18EYcPumZpWcPCsfIGDqcwBQq2FIzQAgAc5teLFuW8XTdLUuugdWklt6VD7utVRadloQG2Q6tlZ+uoo8EjCls/+nn9lVn2S1Vbo6b6fMP1YA+FdNSsgJH8+1vbro160JlpTh8O64zgbxOa9aPsGHG2Zr13EWoeIXqCm9LNwVK+mnuVKtjcD7SyjMUG5Bw63f1bVpKbsiS/R8zw+1YGtXJAJCfJW12JcRU7tFNqF7qqJ0=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(39860400002)(376002)(136003)(451199018)(40470700004)(36840700001)(46966006)(8936002)(6666004)(5660300002)(36860700001)(40480700001)(82310400005)(4326008)(8676002)(70206006)(86362001)(70586007)(83380400001)(36756003)(54906003)(478600001)(426003)(316002)(110136005)(47076005)(41300700001)(40460700003)(336012)(82740400003)(2906002)(16526019)(186003)(356005)(81166007)(44832011)(1076003)(2616005)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 05:13:45.3387
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b22da47-c33f-4b8f-fe9b-08db1f93e448
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT080.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5683
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the Core device gets an event from the device, or notices
the device FW to be up or down, it needs to send those events
on to the clients that have an event handler.  Add the code to
pass along the events to the clients.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/net/ethernet/amd/pds_core/adminq.c |  2 ++
 drivers/net/ethernet/amd/pds_core/core.c   | 34 ++++++++++++++++++++++
 include/linux/pds/pds_core.h               |  3 ++
 3 files changed, 39 insertions(+)

diff --git a/drivers/net/ethernet/amd/pds_core/adminq.c b/drivers/net/ethernet/amd/pds_core/adminq.c
index c063e269c1d6..f6b6307390ec 100644
--- a/drivers/net/ethernet/amd/pds_core/adminq.c
+++ b/drivers/net/ethernet/amd/pds_core/adminq.c
@@ -28,11 +28,13 @@ static int pdsc_process_notifyq(struct pdsc_qcq *qcq)
 		case PDS_EVENT_LINK_CHANGE:
 			dev_info(pdsc->dev, "NotifyQ LINK_CHANGE ecode %d eid %lld\n",
 				 ecode, eid);
+			pdsc_notify(pdsc, PDS_EVENT_LINK_CHANGE, comp);
 			break;
 
 		case PDS_EVENT_RESET:
 			dev_info(pdsc->dev, "NotifyQ RESET ecode %d eid %lld\n",
 				 ecode, eid);
+			pdsc_notify(pdsc, PDS_EVENT_RESET, comp);
 			break;
 
 		case PDS_EVENT_XCVR:
diff --git a/drivers/net/ethernet/amd/pds_core/core.c b/drivers/net/ethernet/amd/pds_core/core.c
index 96b0522c0306..8e9999049595 100644
--- a/drivers/net/ethernet/amd/pds_core/core.c
+++ b/drivers/net/ethernet/amd/pds_core/core.c
@@ -7,6 +7,25 @@
 
 #include <linux/pds/pds_adminq.h>
 
+static BLOCKING_NOTIFIER_HEAD(pds_notify_chain);
+
+int pdsc_register_notify(struct notifier_block *nb)
+{
+	return blocking_notifier_chain_register(&pds_notify_chain, nb);
+}
+EXPORT_SYMBOL_GPL(pdsc_register_notify);
+
+void pdsc_unregister_notify(struct notifier_block *nb)
+{
+	blocking_notifier_chain_unregister(&pds_notify_chain, nb);
+}
+EXPORT_SYMBOL_GPL(pdsc_unregister_notify);
+
+void pdsc_notify(struct pdsc *pdsc, unsigned long event, void *data)
+{
+	blocking_notifier_call_chain(&pds_notify_chain, event, data);
+}
+
 void pdsc_intr_free(struct pdsc *pdsc, int index)
 {
 	struct pdsc_intr_info *intr_info;
@@ -507,6 +526,11 @@ void pdsc_stop(struct pdsc *pdsc)
 
 static void pdsc_fw_down(struct pdsc *pdsc)
 {
+	union pds_core_notifyq_comp reset_event = {
+		.reset.ecode = cpu_to_le16(PDS_EVENT_RESET),
+		.reset.state = 0,
+	};
+
 	mutex_lock(&pdsc->config_lock);
 
 	if (test_and_set_bit(PDSC_S_FW_DEAD, &pdsc->state)) {
@@ -515,6 +539,9 @@ static void pdsc_fw_down(struct pdsc *pdsc)
 		return;
 	}
 
+	/* Notify clients of fw_down */
+	pdsc_notify(pdsc, PDS_EVENT_RESET, &reset_event);
+
 	pdsc_mask_interrupts(pdsc);
 	pdsc_teardown(pdsc, PDSC_TEARDOWN_RECOVERY);
 
@@ -523,6 +550,10 @@ static void pdsc_fw_down(struct pdsc *pdsc)
 
 static void pdsc_fw_up(struct pdsc *pdsc)
 {
+	union pds_core_notifyq_comp reset_event = {
+		.reset.ecode = cpu_to_le16(PDS_EVENT_RESET),
+		.reset.state = 1,
+	};
 	int err;
 
 	mutex_lock(&pdsc->config_lock);
@@ -543,6 +574,9 @@ static void pdsc_fw_up(struct pdsc *pdsc)
 
 	mutex_unlock(&pdsc->config_lock);
 
+	/* Notify clients of fw_up */
+	pdsc_notify(pdsc, PDS_EVENT_RESET, &reset_event);
+
 	return;
 
 err_out:
diff --git a/include/linux/pds/pds_core.h b/include/linux/pds/pds_core.h
index e6d18f219033..3f6cbef4e8f2 100644
--- a/include/linux/pds/pds_core.h
+++ b/include/linux/pds/pds_core.h
@@ -305,6 +305,9 @@ int pdsc_start(struct pdsc *pdsc);
 void pdsc_stop(struct pdsc *pdsc);
 void pdsc_health_thread(struct work_struct *work);
 
+int pdsc_register_notify(struct notifier_block *nb);
+void pdsc_unregister_notify(struct notifier_block *nb);
+void pdsc_notify(struct pdsc *pdsc, unsigned long event, void *data);
 int pdsc_auxbus_dev_add_vf(struct pdsc *pdsc_vf, struct pdsc *pdsc_pf);
 int pdsc_auxbus_dev_del_vf(struct pdsc *pdsc_vf, struct pdsc *pdsc_pf);
 
-- 
2.17.1


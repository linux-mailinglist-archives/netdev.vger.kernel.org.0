Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A57C36E55EF
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 02:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbjDRAd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 20:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbjDRAdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 20:33:32 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2076.outbound.protection.outlook.com [40.107.243.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FA7755B5
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 17:33:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hxJCwbH/aJpeM2jsn5nnHti0p+Q4Le0BOtH8h7wISeXcX/UJ+y4tc8wwm/Uayd9nmPIrCBUmmaEdWvBoY+vCZlvYYMqLR3IeSBl+kyXCg0fblbhIrt+et0MLor97nst42+CQKj06+mEEzBWtZpXFS53yWJsSaOVNOpskYphXq+G0KZ+bXU3afRMrA2SOggPGxDq21MA0SbbUgVdWvJHe6XlbYon4I22OEuZgZw69rMC+XRGtLK6VOw+z0SnRiocRbcwwWRwZLIzF02KAroOZRWAFcJgsMbZ59E+/bEWNJY8Nan7F4GnTnaRi/EB0OZL1ab3RzqMeABxLYmeI8yF2yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KHdOSs9yNm+/Y1DCP/+Fb93S3MpAMu3PTckC73LJ+I0=;
 b=ddezWEWrBox1rHkT6PxQTZcnTiu9ZQzyLY+ZpmUhZx3uY0XCFj7bcF1cGadKNvYbnA8/l/YS+tFmbF12ENMaDNQTMeKLtw61+M2Drzi/p5a7AtdDuIvOkajnIGhiqdpDSZNjfqa6cUUNM+md9fMSh9YmzQ3xCfjfHo7mIErESTUUsj/5GrGJ+4P5/IlezGal++ToGJSItx5LhUQlABw1IM4jroGBLow8Mg+RyzjRgUvaiRjOExc7FdjpNfRckgdcsdsAos3iRjDLPUnuIKDe1HZW/PLEVarcTFVclx9ey37d5ry2fQUscziPlSt3chLNE+oddmFquZw9Nr0hzkZUig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=temperror action=none header.from=amd.com; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KHdOSs9yNm+/Y1DCP/+Fb93S3MpAMu3PTckC73LJ+I0=;
 b=p90kO13L6YA7X8R7FNplFM/VbVMx8YHGDn7TYGstlFWkOkPl7GoNTdcD+84sWE5f2tMbfSe3p7zzRdWdYnPKPvTu0E9QFuTsp8E4IiQcj5XvT1ORbJIu3PDMaJKDX4jRRVnY8xsWJO/zf/kD6Bn49h7uNoDgtDM77cuHlEAT0rI=
Received: from BN9PR03CA0137.namprd03.prod.outlook.com (2603:10b6:408:fe::22)
 by PH0PR12MB8007.namprd12.prod.outlook.com (2603:10b6:510:28e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 00:33:10 +0000
Received: from BN8NAM11FT075.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fe:cafe::6c) by BN9PR03CA0137.outlook.office365.com
 (2603:10b6:408:fe::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.46 via Frontend
 Transport; Tue, 18 Apr 2023 00:33:10 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is
 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=temperror action=none header.from=amd.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of amd.com: DNS Timeout)
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT075.mail.protection.outlook.com (10.13.176.208) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6319.20 via Frontend Transport; Tue, 18 Apr 2023 00:33:10 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 17 Apr
 2023 19:33:05 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>,
        <simon.horman@corigine.com>
Subject: [PATCH v10 net-next 13/14] pds_core: publish events to the clients
Date:   Mon, 17 Apr 2023 17:32:27 -0700
Message-ID: <20230418003228.28234-14-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230418003228.28234-1-shannon.nelson@amd.com>
References: <20230418003228.28234-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT075:EE_|PH0PR12MB8007:EE_
X-MS-Office365-Filtering-Correlation-Id: 90020d43-477b-456b-e943-08db3fa47c95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rHrdA2hCZ3tgYFw+AF6TVTY20OzVDoKpXRwMlJnsR9qaUBhXNl5Uy70gSMun4aPVY3yfFMiUNI/1YUDrF5HtuTsfTGo2QUFXG0Qw0hXD148vz21Ic/LaMtYPmVqzLq5Dwx6vil07GcucmcvL3s4UyHO7hBapHXMERgoCquMo9YUWmWPqZvbYnXSpqL5bbRvxokiZQ3BtTtZ70GpfqNFsc2kcyXSp6vm+fsmP2436M8ShXlYLaHERZ6JkwCHlTri4ELf7V8vOdyLHpWj14eKEWtMBrt/94b3IkuedMRWxeeQB6GOw0SrKnZvmsTAG84hV42d1Dzb0tZ6jYjJQG6UWB8Km/I+rzcLBtaSTcigqF8M8jM2WZ60FTDno7vO1uhO27Uop4kzvdx1n1S5KjJx+rgWxKnp3CuLlXTqqCXyp1ta8cyW02uTrFTG6JjsnN9Z5ldqwul4GJT/7OCfNZGx40rMClwC6du3ysAkPhhv8IN6xSHfoY7cFrik/TypvgvHsp5ZtZCZeUlNHLEfRtO8Fz29sGieIwjoV+laKN0uJZP10bV1Y8zdvTzJMcNuHB9a0BXOnyK5CCDzz97bYZ9W3epWoJArj/k5Cld50PniNM3bjC81v218gdtPG7F12nMQuc4Jq8xBZBQ1wvmJUopV0zMVXXQUOySH71sYZh89YAVDNnfUflrN8GYnmGl9rlGQNMW3qjHOZ5fbR77BxtXMdi4jonCWUqD75DPprLrzgwNY=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(376002)(39860400002)(346002)(451199021)(36840700001)(40470700004)(46966006)(36756003)(82310400005)(36860700001)(4326008)(26005)(1076003)(8676002)(8936002)(41300700001)(86362001)(316002)(44832011)(5660300002)(70586007)(70206006)(54906003)(40460700003)(356005)(110136005)(81166007)(2906002)(82740400003)(6666004)(47076005)(186003)(2616005)(16526019)(478600001)(40480700001)(336012)(426003)(83380400001)(63370400001)(63350400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 00:33:10.0130
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 90020d43-477b-456b-e943-08db3fa47c95
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT075.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8007
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the Core device gets an event from the device, or notices
the device FW to be up or down, it needs to send those events
on to the clients that have an event handler.  Add the code to
pass along the events to the clients.

The entry points pdsc_register_notify() and pdsc_unregister_notify()
are EXPORTed for other drivers that want to listen for these events.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/adminq.c |  2 ++
 drivers/net/ethernet/amd/pds_core/core.c   | 32 ++++++++++++++++++++++
 drivers/net/ethernet/amd/pds_core/core.h   |  3 ++
 include/linux/pds/pds_common.h             |  2 ++
 4 files changed, 39 insertions(+)

diff --git a/drivers/net/ethernet/amd/pds_core/adminq.c b/drivers/net/ethernet/amd/pds_core/adminq.c
index fb2ba3f62480..045fe133f6ee 100644
--- a/drivers/net/ethernet/amd/pds_core/adminq.c
+++ b/drivers/net/ethernet/amd/pds_core/adminq.c
@@ -29,11 +29,13 @@ static int pdsc_process_notifyq(struct pdsc_qcq *qcq)
 		case PDS_EVENT_LINK_CHANGE:
 			dev_info(pdsc->dev, "NotifyQ LINK_CHANGE ecode %d eid %lld\n",
 				 ecode, eid);
+			pdsc_notify(PDS_EVENT_LINK_CHANGE, comp);
 			break;
 
 		case PDS_EVENT_RESET:
 			dev_info(pdsc->dev, "NotifyQ RESET ecode %d eid %lld\n",
 				 ecode, eid);
+			pdsc_notify(PDS_EVENT_RESET, comp);
 			break;
 
 		case PDS_EVENT_XCVR:
diff --git a/drivers/net/ethernet/amd/pds_core/core.c b/drivers/net/ethernet/amd/pds_core/core.c
index b2fca3b99f02..483a070d96fa 100644
--- a/drivers/net/ethernet/amd/pds_core/core.c
+++ b/drivers/net/ethernet/amd/pds_core/core.c
@@ -6,6 +6,25 @@
 
 #include "core.h"
 
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
+void pdsc_notify(unsigned long event, void *data)
+{
+	blocking_notifier_call_chain(&pds_notify_chain, event, data);
+}
+
 void pdsc_intr_free(struct pdsc *pdsc, int index)
 {
 	struct pdsc_intr_info *intr_info;
@@ -494,12 +513,19 @@ void pdsc_stop(struct pdsc *pdsc)
 
 static void pdsc_fw_down(struct pdsc *pdsc)
 {
+	union pds_core_notifyq_comp reset_event = {
+		.reset.ecode = cpu_to_le16(PDS_EVENT_RESET),
+		.reset.state = 0,
+	};
+
 	if (test_and_set_bit(PDSC_S_FW_DEAD, &pdsc->state)) {
 		dev_err(pdsc->dev, "%s: already happening\n", __func__);
 		return;
 	}
 
+	/* Notify clients of fw_down */
 	devlink_health_report(pdsc->fw_reporter, "FW down reported", pdsc);
+	pdsc_notify(PDS_EVENT_RESET, &reset_event);
 
 	pdsc_stop(pdsc);
 	pdsc_teardown(pdsc, PDSC_TEARDOWN_RECOVERY);
@@ -507,6 +533,10 @@ static void pdsc_fw_down(struct pdsc *pdsc)
 
 static void pdsc_fw_up(struct pdsc *pdsc)
 {
+	union pds_core_notifyq_comp reset_event = {
+		.reset.ecode = cpu_to_le16(PDS_EVENT_RESET),
+		.reset.state = 1,
+	};
 	int err;
 
 	if (!test_bit(PDSC_S_FW_DEAD, &pdsc->state)) {
@@ -522,9 +552,11 @@ static void pdsc_fw_up(struct pdsc *pdsc)
 	if (err)
 		goto err_out;
 
+	/* Notify clients of fw_up */
 	pdsc->fw_recoveries++;
 	devlink_health_reporter_state_update(pdsc->fw_reporter,
 					     DEVLINK_HEALTH_REPORTER_STATE_HEALTHY);
+	pdsc_notify(PDS_EVENT_RESET, &reset_event);
 
 	return;
 
diff --git a/drivers/net/ethernet/amd/pds_core/core.h b/drivers/net/ethernet/amd/pds_core/core.h
index 9e01a9ee6868..e545fafc4819 100644
--- a/drivers/net/ethernet/amd/pds_core/core.h
+++ b/drivers/net/ethernet/amd/pds_core/core.h
@@ -297,6 +297,9 @@ int pdsc_start(struct pdsc *pdsc);
 void pdsc_stop(struct pdsc *pdsc);
 void pdsc_health_thread(struct work_struct *work);
 
+int pdsc_register_notify(struct notifier_block *nb);
+void pdsc_unregister_notify(struct notifier_block *nb);
+void pdsc_notify(unsigned long event, void *data);
 int pdsc_auxbus_dev_add(struct pdsc *cf, struct pdsc *pf);
 int pdsc_auxbus_dev_del(struct pdsc *cf, struct pdsc *pf);
 
diff --git a/include/linux/pds/pds_common.h b/include/linux/pds/pds_common.h
index 4b37675fde3e..060331486d50 100644
--- a/include/linux/pds/pds_common.h
+++ b/include/linux/pds/pds_common.h
@@ -60,6 +60,8 @@ enum pds_core_logical_qtype {
 	PDS_CORE_QTYPE_MAX     = 16   /* don't change - used in struct size */
 };
 
+int pdsc_register_notify(struct notifier_block *nb);
+void pdsc_unregister_notify(struct notifier_block *nb);
 void *pdsc_get_pf_struct(struct pci_dev *vf_pdev);
 int pds_client_register(struct pci_dev *pf_pdev, char *devname);
 int pds_client_unregister(struct pci_dev *pf_pdev, u16 client_id);
-- 
2.17.1


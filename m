Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83A2764508C
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 01:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiLGAp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 19:45:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiLGApN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 19:45:13 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2052.outbound.protection.outlook.com [40.107.243.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8B8A32051
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 16:45:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TaVs4f2rl8SaBH33yBxEGYdV4bLtUwS5SAqHwMsz8RUnnboQJ774LjPZRXVmFjV3nKytz7X7z+rM1ZtW+v03kPYfaQQJGJRpMUNfYj267BbvAeAcOe4J0DMb0KrYSucab4y5wOle9GEAWHskClow7J5EGh1g1MrsEhj4KnDdjSIVPhaC8dXdIxz5Pmm7SwH81fYZOwckHyKC6Q87Qv+tgzmvBc6brSvf+7XNlt0soveCGY/2xkt64R09Ua1Udu2J5WnRzTOwjmHTvfZxeUo3Fao0HPogAvvYhiHo1TpNJGniOjR5x9KIEqT2lSBSMgqFvbZYwiFX0kTVQBMbs4SJcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HWbWQ++unlN+XhCdTD+fXVkmSciqcCrecxDLmHgrzWw=;
 b=NCP3BvJWtfJ6gIyL18bx1FcV5eRbgbHmkbRekiMYh4UyjamY0Ci1nMTAkdKeowPrICS3EA/uOI/qHK5mBfWIixjCEzVGB0Ugm1HYHtf2UDZ4FkmBhDxY60ASgObx5zkPI11nWoXICS6/g3IBMp/hxT+8xrW/1djmzzM1Z0Szz/CuRJylRgyO1EOcYHDBWjzSJzKX076PBG+BQUtozOyL8lu5fQ0yuCAExioJmZ9nwSIs2C/qchj+5VnPCyt7mW+suyO+Jt8z9HmQOEtpSsIgHfuQS0AuUTi4DTa8ETxxTX8JUwHAxZtHmt0K8VwPB8MgNh7K6uM5+YG8FXbGvkebhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HWbWQ++unlN+XhCdTD+fXVkmSciqcCrecxDLmHgrzWw=;
 b=ffweg+q8Ik1kt2jliQK9aKy7AUf8qcc8VaC6Ztkx347IXbkGJAnCZATZnWd2c/T7xwJY3UUZoK6Idd8ymd8QiuM2OkBk1WokXKhthbDXepX4kwY1OOMZWmWG4UA0WBKx9nE0pdXkwK5vmM1mlj+fuV4sLkCcaFzWDmnYKQXNpko=
Received: from BN9PR03CA0262.namprd03.prod.outlook.com (2603:10b6:408:ff::27)
 by IA1PR12MB6555.namprd12.prod.outlook.com (2603:10b6:208:3a1::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 00:45:10 +0000
Received: from BN8NAM11FT112.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ff:cafe::ae) by BN9PR03CA0262.outlook.office365.com
 (2603:10b6:408:ff::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Wed, 7 Dec 2022 00:45:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT112.mail.protection.outlook.com (10.13.176.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5901.14 via Frontend Transport; Wed, 7 Dec 2022 00:45:10 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 6 Dec
 2022 18:45:09 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH v2 net-next 08/16] pds_core: add fw bank select
Date:   Tue, 6 Dec 2022 16:44:35 -0800
Message-ID: <20221207004443.33779-9-shannon.nelson@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT112:EE_|IA1PR12MB6555:EE_
X-MS-Office365-Filtering-Correlation-Id: 989ae6a3-23de-494a-ea32-08dad7ec4bb9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5UlFMs6z6I+LkPQO8Jo5idI+4vR49io6+BklOO4bqRxu1pOQxIbTBjqqD6kvWUegaidwgmm5FPDsQZZeBIP2rLChESknl5tTpei3WBJi9YygXI/qmW8Akl4cYEdSv/X5Jgy17fk6tEi8qng0E1/Y4JXw0/qgyDmEEdFfY6nTnuzwx2sBZf1Q5tiaZMK13CKczppdDYynZT+jXxA1eafm99//FcRE3vVkNDXKK6cb0nN8uM1v7Al2X64ric9K8sG6sRfd0C/vWIhy+uLq5gKYJ/2XdeyDlJ2t2rc7LUgJfs6DqYzvlIxu1WZ67dt3DVrM3W6LrZELDCr75vD9hxbPiyY67cFY8BFT/YkLt6VlwHqNj2tM9WKdqq9RjL5BYU2CjkXEzsCjR/fxi5ZrmSt8lY66VdGdLMF/jin2qDXcW57RbMhsE1jIVGVXhhulgBHZDCqEvIE1F+t1nItuKi7mjhkZE4ClQav0CAw1aLQT9Zg8D91dPfO3/ZTEOMyHUuqEyHIJVj0uQFv+BPfQtCg8dNgnK0FTZDWRd7Eq6S6thdB/O/5eCntHDGQzws3KSkIKWWmVu3aephRno8KGr3J9cGsG9IyfVPpVN3HrC7kcSDCx3QzfkxTXpvTmY+6yw6mTGwcsj8hucUFEDKtZosilu+WbkfJJoSTdaKdvk6JBpw5boDHRbAzW6sfoGhrUgbKQf9xREzd9YkpGXoJz+YDq/mI0UagbL2j5UTA99Kl2T4o=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(396003)(376002)(136003)(451199015)(46966006)(36840700001)(40470700004)(15650500001)(2906002)(8936002)(44832011)(83380400001)(8676002)(86362001)(36756003)(70206006)(4326008)(16526019)(81166007)(356005)(426003)(41300700001)(186003)(47076005)(82310400005)(2616005)(82740400003)(1076003)(5660300002)(336012)(110136005)(26005)(316002)(54906003)(36860700001)(6666004)(70586007)(478600001)(40460700003)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 00:45:10.8763
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 989ae6a3-23de-494a-ea32-08dad7ec4bb9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT112.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6555
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the fw_bank parameter to select the next
bootup firmware.  This can be selected at any time, and is
also selected automatically when a new firmware is flashed
into the device.

There are three banks available in this device: 1 and 2 are
the primaries for normal operations, while bank 3 has 'gold'
firmware that can be selected and used as recovery fw
in the case that both 1 and 2 become corrupt.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 .../net/ethernet/pensando/pds_core/devlink.c  | 71 +++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/drivers/net/ethernet/pensando/pds_core/devlink.c b/drivers/net/ethernet/pensando/pds_core/devlink.c
index 78fe657f6532..cd132573cbe0 100644
--- a/drivers/net/ethernet/pensando/pds_core/devlink.c
+++ b/drivers/net/ethernet/pensando/pds_core/devlink.c
@@ -8,6 +8,69 @@
 
 #include "core.h"
 
+static int pdsc_dl_fw_bank_get(struct devlink *dl, u32 id,
+			       struct devlink_param_gset_ctx *ctx)
+{
+	struct pdsc *pdsc = devlink_priv(dl);
+	union pds_core_dev_cmd cmd = {
+		.fw_control.opcode = PDS_CORE_CMD_FW_CONTROL,
+		.fw_control.oper = PDS_CORE_FW_GET_BOOT,
+	};
+	union pds_core_dev_comp comp;
+	int err;
+
+	err = pdsc_devcmd(pdsc, &cmd, &comp, pdsc->devcmd_timeout);
+	if (err)
+		return err;
+
+	ctx->val.vu8 = comp.fw_control.slot;
+
+	return 0;
+}
+
+static int pdsc_dl_fw_bank_set(struct devlink *dl, u32 id,
+			       struct devlink_param_gset_ctx *ctx)
+{
+	struct pdsc *pdsc = devlink_priv(dl);
+	union pds_core_dev_cmd cmd = {
+		.fw_control.opcode = PDS_CORE_CMD_FW_CONTROL,
+		.fw_control.oper = PDS_CORE_FW_SET_BOOT,
+	};
+	union pds_core_dev_comp comp;
+	int timeout;
+
+	cmd.fw_control.slot = ctx->val.vu8;
+
+	/* This is known to be a longer running command, so be sure
+	 * to use a larger timeout on the command than usual
+	 */
+#define PDSC_SET_BOOT_TIMEOUT	10
+	timeout = max_t(int, PDSC_SET_BOOT_TIMEOUT, pdsc->devcmd_timeout);
+	return pdsc_devcmd(pdsc, &cmd, &comp, timeout);
+}
+
+static int pdsc_dl_fw_bank_validate(struct devlink *dl, u32 id,
+				    union devlink_param_value val,
+				    struct netlink_ext_ack *extack)
+{
+	switch (val.vu8) {
+	case PDS_CORE_FW_SLOT_A:
+	case PDS_CORE_FW_SLOT_B:
+	case PDS_CORE_FW_SLOT_GOLD:
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
+static const struct devlink_param pdsc_dl_params[] = {
+	DEVLINK_PARAM_GENERIC(FW_BANK,
+			      BIT(DEVLINK_PARAM_CMODE_PERMANENT),
+			      pdsc_dl_fw_bank_get,
+			      pdsc_dl_fw_bank_set,
+			      pdsc_dl_fw_bank_validate),
+};
+
 static int pdsc_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 			    struct netlink_ext_ack *extack)
 {
@@ -87,6 +150,12 @@ void pdsc_dl_free(struct pdsc *pdsc)
 int pdsc_dl_register(struct pdsc *pdsc)
 {
 	struct devlink *dl = priv_to_devlink(pdsc);
+	int err;
+
+	err = devlink_params_register(dl, pdsc_dl_params,
+				      ARRAY_SIZE(pdsc_dl_params));
+	if (err)
+		return err;
 
 	devlink_register(dl);
 
@@ -98,4 +167,6 @@ void pdsc_dl_unregister(struct pdsc *pdsc)
 	struct devlink *dl = priv_to_devlink(pdsc);
 
 	devlink_unregister(dl);
+	devlink_params_unregister(dl, pdsc_dl_params,
+				  ARRAY_SIZE(pdsc_dl_params));
 }
-- 
2.17.1


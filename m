Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE7D8691F75
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 14:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232148AbjBJNEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 08:04:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232078AbjBJNEB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 08:04:01 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2058.outbound.protection.outlook.com [40.107.93.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5211F7396E
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 05:03:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UQbMC0pemaCH3F+pnDcDi2lu0nVX7uAl+uNbPYrnP807ZahYGMA09eibVQpU3rkIA2+Sib85ZSK1DMoeNTNDw/QFfqgQW5nXKmn9b2N25PjjomjahGyL4A3qRnwIY6EMH+0muJMMJ5pvN1kVGb4YKbw3JsrEdZ5CzDKbMkx2/uPPYltrKMz8eluJ0JD2XuqeBsS6GMx5kWOyJr2oMINCrKhrOVrAJvpGyz9KsKR+oWN8MizJVmUIVRx8mrh7O2vnEvJEgw5KervMg8kAkTJ7PHBRX9s8LoBFlbsXPKeH1+cRGLVQ0Dt6hQY7RTEQxHVQkJ+3M1PWZQ+AKlNsFfLdBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gLBeuoaBJfyZ+exIkZwYFELOkM6oZ7ru7j4IFh3aZpY=;
 b=htjD6hyChcWZKyitSUR/NJJIK9UKcAjRWAyaw/y9DlFQNNml3BfGchUzbtYR+KszA+iXkdbeRK2hgmoXM0evPm5SV3t0+n0DeHCd9CTQ/LdAJMP177N7yho0GKIR2EVicKF5TfaSXf2Uk5o+8h4MAoVMjSrC48db1CACl0YSXV//WY0JBYp+Y+45O9uDfwiKQS8HN/nNAovCuOHv14+CXyGPbxknhSDGv9pLqMiRH3onx3+oh2yvdbRqqY/n58ccZ+jCNAIexs2HP6Xx7OitalqrYTAsKynccrMs0Z1IBO/za8eXwcyl3doxzhz15sK6WzLkVG5gPB1zZBpN40QqYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gLBeuoaBJfyZ+exIkZwYFELOkM6oZ7ru7j4IFh3aZpY=;
 b=uDUccbpxOlYeg7oBO6WV6f1Caqa/MCiIpcOFiclQtMICAYVRqLGQkcjOvG0A1BEU5iEa0O1H6JEybuGcWP3+XUdgq9CBIj3Q0mRBJ/xQ0P+3cedhlkiPdj6Txbqe8rtwHl3KFCdRDbgk7DumXM94OQGG5W4Bm5omUpBymlB0kpk=
Received: from DS7PR03CA0217.namprd03.prod.outlook.com (2603:10b6:5:3ba::12)
 by PH0PR12MB5466.namprd12.prod.outlook.com (2603:10b6:510:d7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Fri, 10 Feb
 2023 13:03:48 +0000
Received: from DM6NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ba:cafe::4d) by DS7PR03CA0217.outlook.office365.com
 (2603:10b6:5:3ba::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.21 via Frontend
 Transport; Fri, 10 Feb 2023 13:03:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT026.mail.protection.outlook.com (10.13.172.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6086.21 via Frontend Transport; Fri, 10 Feb 2023 13:03:47 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 10 Feb
 2023 07:03:47 -0600
Received: from xhdipdslab59.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Fri, 10 Feb 2023 07:03:43 -0600
From:   Harsh Jain <h.jain@amd.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <thomas.lendacky@amd.com>,
        <Raju.Rangoju@amd.com>, <Shyam-sundar.S-k@amd.com>,
        <harshjain.prof@gmail.com>, <abhijit.gangurde@amd.com>,
        <puneet.gupta@amd.com>, <nikhil.agarwal@amd.com>,
        <tarak.reddy@amd.com>, <netdev@vger.kernel.org>
CC:     Harsh Jain <h.jain@amd.com>
Subject: [PATCH  3/6] net: ethernet: efct: Add devlink support
Date:   Fri, 10 Feb 2023 18:33:18 +0530
Message-ID: <20230210130321.2898-4-h.jain@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230210130321.2898-1-h.jain@amd.com>
References: <20230210130321.2898-1-h.jain@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT026:EE_|PH0PR12MB5466:EE_
X-MS-Office365-Filtering-Correlation-Id: cf81aad5-41e9-4221-bb61-08db0b673f9e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tGorokujXZFn4MMh289LaR9LzqV+ZEMsLRYao8UpYFXg59PKNdSOZC1RMN/yO676VE3nbs4U7294fdk77PMgS15xiLMHG4eMZWemytivbNiktbpoElMLeDxru5ocjVVMeGnGDXE3k1eEF7rtxAstwJoFo8r+kyOWk8oxbrQ7GaPQpg/v1tc7NS7gAhCJiYZbuRBuR9grykyjhPQsB7ZPz1NXxKzcsTaOvenUev+NYwyFTwPfHMxYix9yu8L7aJ/Z7e4gD+BHmzgp0sEw8deLAnpWcSpnZq0GjMvQMueG6IesoutcVwO5YNC1dVbOGk4z/TesTd0GLkezzaA6dfFWicAX80JMGR4LHr8QnRMM4+HCecNshfItXKT1tBChHSKIDoUNDjZt66Eu9jsTjRN3jpZjAFSYNuaLdr7kTh8qdXDXR2ClATtdANC/yH+sPiwtXAW6tIIg+gtRbB4ZZrm3ed1wr2s3El0pH4epTzXPtkCKy+xz/8WkrcS3ACkWVtB8iAk9xmwuU+dckRD7wASlCyvPB3eLALGWo8YfM3H7VZTcxoh3cAvuwZWY0NfZM85EBIDpDwsaONmt8K6OMuhcSuYdMep+Ck9M1fHrUVCXMKhAdlahpCg1nZz6C1erXM1/SaaKkW9wjd+QVZU6J08+jLIqJW4T4qk6AcCNV1tmdzAPP3S7R7AM++VHMHCB4RTbJ4ky+NgQJ37Vhgm41+mUNqllei+yADGymRFYTRbOQlE40coaQJ/9qKodcbKj/eBq
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(396003)(346002)(376002)(451199018)(36840700001)(40470700004)(46966006)(8936002)(8676002)(41300700001)(186003)(26005)(2616005)(83380400001)(30864003)(336012)(426003)(82740400003)(2906002)(70206006)(70586007)(4326008)(110136005)(316002)(5660300002)(86362001)(478600001)(6666004)(40480700001)(1076003)(81166007)(356005)(66899018)(36756003)(921005)(36860700001)(82310400005)(47076005)(40460700003)(36900700001)(579004)(559001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 13:03:47.9024
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cf81aad5-41e9-4221-bb61-08db0b673f9e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5466
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add devlink support.

Signed-off-by: Abhijit Gangurde<abhijit.gangurde@amd.com>
Signed-off-by: Puneet Gupta <puneet.gupta@amd.com>
Signed-off-by: Nikhil Agarwal<nikhil.agarwal@amd.com>
Signed-off-by: Tarak Reddy<tarak.reddy@amd.com>
Signed-off-by: Harsh Jain <h.jain@amd.com>
---
 drivers/net/ethernet/amd/efct/efct_devlink.c | 829 +++++++++++++++++++
 drivers/net/ethernet/amd/efct/efct_devlink.h |  21 +
 drivers/net/ethernet/amd/efct/efct_driver.h  |   3 +
 drivers/net/ethernet/amd/efct/efct_netdev.c  |   1 +
 drivers/net/ethernet/amd/efct/efct_pci.c     |  24 +-
 drivers/net/ethernet/amd/efct/efct_reflash.c | 564 +++++++++++++
 drivers/net/ethernet/amd/efct/efct_reflash.h |  16 +
 7 files changed, 1457 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/amd/efct/efct_devlink.c
 create mode 100644 drivers/net/ethernet/amd/efct/efct_devlink.h
 create mode 100644 drivers/net/ethernet/amd/efct/efct_reflash.c
 create mode 100644 drivers/net/ethernet/amd/efct/efct_reflash.h

diff --git a/drivers/net/ethernet/amd/efct/efct_devlink.c b/drivers/net/ethernet/amd/efct/efct_devlink.c
new file mode 100644
index 000000000000..64217337f80a
--- /dev/null
+++ b/drivers/net/ethernet/amd/efct/efct_devlink.c
@@ -0,0 +1,829 @@
+// SPDX-License-Identifier: GPL-2.0
+/****************************************************************************
+ * Driver for AMD/Xilinx network controllers and boards
+ * Copyright (C) 2021, Xilinx, Inc.
+ * Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
+ */
+
+#include <linux/rtc.h>
+#include "efct_devlink.h"
+#include "mcdi.h"
+#include "mcdi_functions.h"
+#include "mcdi_pcol.h"
+#include "efct_reflash.h"
+#include "efct_netdev.h"
+
+/* Custom devlink-info version object names for details that do not map to the
+ * generic standardized names.
+ */
+#define EFCT_DEVLINK_INFO_VERSION_FW_MGMT_SUC	"fw.mgmt.suc"
+#define EFCT_DEVLINK_INFO_VERSION_FW_MGMT_CMC	"fw.mgmt.cmc"
+#define EFCT_DEVLINK_INFO_VERSION_FPGA_REV	"fpga.rev"
+#define EFCT_DEVLINK_INFO_VERSION_DATAPATH_HW	"fpga.app"
+#define EFCT_DEVLINK_INFO_VERSION_DATAPATH_FW	DEVLINK_INFO_VERSION_GENERIC_FW_APP
+#define EFCT_DEVLINK_INFO_VERSION_SOC_BOOT	"coproc.boot"
+#define EFCT_DEVLINK_INFO_VERSION_SOC_UBOOT	"coproc.uboot"
+#define EFCT_DEVLINK_INFO_VERSION_SOC_MAIN	"coproc.main"
+#define EFCT_DEVLINK_INFO_VERSION_SOC_RECOVERY	"coproc.recovery"
+#define EFCT_DEVLINK_INFO_VERSION_FW_EXPROM	"fw.exprom"
+#define EFCT_DEVLINK_INFO_VERSION_FW_UEFI	"fw.uefi"
+
+static int efct_devlink_info_user_cfg(struct efct_nic *efct,
+				      struct devlink_info_req *req)
+{
+	char *buf, *desc;
+	u16 version[4];
+	int offset;
+	int rc;
+
+	offset = 0;
+	buf = kmalloc(MC_CMD_NVRAM_METADATA_OUT_DESCRIPTION_MAXNUM_MCDI2 +
+		      EFCT_MAX_VERSION_INFO_LEN, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	desc = kmalloc(MC_CMD_NVRAM_METADATA_OUT_DESCRIPTION_MAXNUM_MCDI2, GFP_KERNEL);
+	if (!desc) {
+		kfree(buf);
+		return -ENOMEM;
+	}
+
+	rc = efct_mcdi_nvram_metadata(efct, NVRAM_PARTITION_TYPE_USER_CONFIG, NULL, version,
+				      desc, MC_CMD_NVRAM_METADATA_OUT_DESCRIPTION_MAXNUM_MCDI2);
+	if (rc)
+		goto out;
+	if (version[0] || version[1] || version[2] || version[3])
+		offset = snprintf(buf, (EFCT_MAX_VERSION_INFO_LEN +
+				  MC_CMD_NVRAM_METADATA_OUT_DESCRIPTION_MAXNUM_MCDI2),
+				  "%u.%u.%u.%u ", version[0], version[1], version[2], version[3]);
+
+	snprintf(buf + offset, (EFCT_MAX_VERSION_INFO_LEN +
+				MC_CMD_NVRAM_METADATA_OUT_DESCRIPTION_MAXNUM_MCDI2),
+		 "%s", desc);
+
+	devlink_info_version_stored_put(req, DEVLINK_INFO_VERSION_GENERIC_FW_PSID, buf);
+
+out:
+	kfree(buf);
+	kfree(desc);
+	return rc;
+}
+
+static int efct_devlink_info_nvram_partition(struct efct_nic *efct,
+					     struct devlink_info_req *req,
+					    u32 partition_type,
+					    const char *version_name)
+{
+	char buf[EFCT_MAX_VERSION_INFO_LEN];
+	u16 version[4];
+	int rc;
+
+	rc = efct_mcdi_nvram_metadata(efct, partition_type, NULL, version, NULL, 0);
+	if (rc)
+		return rc;
+
+	snprintf(buf, EFCT_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u", version[0],
+		 version[1], version[2], version[3]);
+	devlink_info_version_stored_put(req, version_name, buf);
+
+	return 0;
+}
+
+static void efct_devlink_info_stored_versions(struct efct_nic *efct,
+					      struct devlink_info_req *req)
+{
+	efct_devlink_info_nvram_partition(efct, req, NVRAM_PARTITION_TYPE_BUNDLE,
+					  DEVLINK_INFO_VERSION_GENERIC_FW_BUNDLE_ID);
+	efct_devlink_info_nvram_partition(efct, req,
+					  NVRAM_PARTITION_TYPE_MC_FIRMWARE,
+					 DEVLINK_INFO_VERSION_GENERIC_FW_MGMT);
+	efct_devlink_info_nvram_partition(efct, req,
+					  NVRAM_PARTITION_TYPE_SUC_FIRMWARE,
+					 EFCT_DEVLINK_INFO_VERSION_FW_MGMT_SUC);
+	efct_devlink_info_nvram_partition(efct, req,
+					  NVRAM_PARTITION_TYPE_EXPANSION_ROM,
+					 EFCT_DEVLINK_INFO_VERSION_FW_EXPROM);
+	efct_devlink_info_nvram_partition(efct, req,
+					  NVRAM_PARTITION_TYPE_EXPANSION_UEFI,
+					 EFCT_DEVLINK_INFO_VERSION_FW_UEFI);
+	efct_devlink_info_user_cfg(efct, req);
+}
+
+#define EFCT_MAX_SERIALNUM_LEN	(ETH_ALEN * 2 + 1)
+
+static void efct_devlink_info_board_cfg(struct efct_nic *efct,
+					struct devlink_info_req *req)
+{
+	char sn[EFCT_MAX_SERIALNUM_LEN];
+	u8 maddr[ETH_ALEN];
+	u32 mac;
+	int rc;
+
+	mac = 0;
+	rc = efct_get_mac_address(efct, maddr);
+	if (rc)
+		return;
+	mac  = maddr[3];
+	mac = (mac << 8) | maddr[4];
+	mac = (mac << 8) | maddr[5];
+	/* Calculate base mac address of device*/
+	mac -= efct->port_num;
+	maddr[3] = (mac >> 16) & 0xff;
+	maddr[4] = (mac >> 8) & 0xff;
+	maddr[5] = mac & 0xff;
+
+	snprintf(sn, EFCT_MAX_SERIALNUM_LEN, "%pm", maddr);
+	devlink_info_serial_number_put(req, sn);
+}
+
+#define EFCT_VER_FLAG(_f)	\
+	(MC_CMD_GET_VERSION_V5_OUT_ ## _f ## _PRESENT_LBN)
+
+static void efct_devlink_info_running_versions(struct efct_nic *efct,
+					       struct devlink_info_req *req)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_VERSION_V5_OUT_LEN);
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_GET_VERSION_EXT_IN_LEN);
+	char buf[EFCT_MAX_VERSION_INFO_LEN];
+	struct rtc_time build_date;
+	size_t outlength, offset;
+	const __le32 *dwords;
+	const __le16 *words;
+	u32 flags, build_id;
+	const char *str;
+	u64 tstamp;
+	int rc;
+
+	rc = efct_mcdi_rpc(efct, MC_CMD_GET_VERSION, inbuf, sizeof(inbuf),
+			   outbuf, sizeof(outbuf), &outlength);
+	if (rc || outlength < MC_CMD_GET_VERSION_V5_OUT_LEN)
+		return;
+
+	/* Handle previous output */
+	words = (__le16 *)MCDI_PTR(outbuf,
+				       GET_VERSION_V5_OUT_VERSION);
+	offset = snprintf(buf, EFCT_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
+			  le16_to_cpu(words[0]),
+			  le16_to_cpu(words[1]),
+			  le16_to_cpu(words[2]),
+			  le16_to_cpu(words[3]));
+
+	devlink_info_version_running_put(req, DEVLINK_INFO_VERSION_GENERIC_FW_MGMT, buf);
+
+	flags = MCDI_DWORD(outbuf, GET_VERSION_V5_OUT_FLAGS);
+	if (flags & BIT(EFCT_VER_FLAG(BOARD_EXT_INFO))) {
+		snprintf(buf, EFCT_MAX_VERSION_INFO_LEN, "%s",
+			 MCDI_PTR(outbuf, GET_VERSION_V5_OUT_BOARD_NAME));
+		devlink_info_version_fixed_put(req, DEVLINK_INFO_VERSION_GENERIC_BOARD_ID, buf);
+		/* Favour full board version if present (in V5 or later) */
+		if (~flags & BIT(EFCT_VER_FLAG(BOARD_VERSION))) {
+			snprintf(buf, EFCT_MAX_VERSION_INFO_LEN, "%u",
+				 MCDI_DWORD(outbuf, GET_VERSION_V5_OUT_BOARD_REVISION));
+			devlink_info_version_fixed_put(req, DEVLINK_INFO_VERSION_GENERIC_BOARD_REV,
+						       buf);
+		}
+
+		str = MCDI_PTR(outbuf, GET_VERSION_V5_OUT_BOARD_SERIAL);
+		if (str[0])
+			devlink_info_board_serial_number_put(req, str);
+	}
+
+	if (flags & BIT(EFCT_VER_FLAG(FPGA_EXT_INFO))) {
+		dwords = (__le32 *)MCDI_PTR(outbuf,
+						GET_VERSION_V5_OUT_FPGA_VERSION);
+		offset = snprintf(buf, EFCT_MAX_VERSION_INFO_LEN, "%u_%c%u",
+				  le32_to_cpu(dwords[0]),
+				  'A' + le32_to_cpu(dwords[1]),
+				  le32_to_cpu(dwords[2]));
+
+		str = MCDI_PTR(outbuf, GET_VERSION_V5_OUT_FPGA_EXTRA);
+		if (str[0])
+			snprintf(&buf[offset], EFCT_MAX_VERSION_INFO_LEN - offset,
+				 " (%s)", str);
+
+		devlink_info_version_running_put(req, EFCT_DEVLINK_INFO_VERSION_FPGA_REV, buf);
+	}
+
+	if (flags & BIT(EFCT_VER_FLAG(CMC_EXT_INFO))) {
+		dwords = (__le32 *)MCDI_PTR(outbuf, GET_VERSION_V5_OUT_CMCFW_VERSION);
+		offset = snprintf(buf, EFCT_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
+				  le32_to_cpu(dwords[0]),
+				  le32_to_cpu(dwords[1]),
+				  le32_to_cpu(dwords[2]),
+				  le32_to_cpu(dwords[3]));
+
+		tstamp = MCDI_QWORD(outbuf, GET_VERSION_V5_OUT_CMCFW_BUILD_DATE);
+		if (tstamp) {
+			rtc_time64_to_tm(tstamp, &build_date);
+			snprintf(&buf[offset], EFCT_MAX_VERSION_INFO_LEN - offset,
+				 " (%ptRd)", &build_date);
+		}
+
+		devlink_info_version_running_put(req, EFCT_DEVLINK_INFO_VERSION_FW_MGMT_CMC, buf);
+	}
+
+	words = (__le16 *)MCDI_PTR(outbuf, GET_VERSION_V5_OUT_VERSION);
+	offset = snprintf(buf, EFCT_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
+			  le16_to_cpu(words[0]), le16_to_cpu(words[1]),
+			  le16_to_cpu(words[2]), le16_to_cpu(words[3]));
+	if (flags & BIT(EFCT_VER_FLAG(MCFW_EXT_INFO))) {
+		build_id = MCDI_DWORD(outbuf, GET_VERSION_V5_OUT_MCFW_BUILD_ID);
+		snprintf(&buf[offset], EFCT_MAX_VERSION_INFO_LEN - offset,
+			 " (%x) %s", build_id,
+			 MCDI_PTR(outbuf, GET_VERSION_V5_OUT_MCFW_BUILD_NAME));
+	}
+	devlink_info_version_running_put(req, DEVLINK_INFO_VERSION_GENERIC_FW_MGMT, buf);
+
+	if (flags & BIT(EFCT_VER_FLAG(SUCFW_EXT_INFO))) {
+		dwords = (__le32 *)MCDI_PTR(outbuf,	GET_VERSION_V5_OUT_SUCFW_VERSION);
+		tstamp = MCDI_QWORD(outbuf, GET_VERSION_V5_OUT_SUCFW_BUILD_DATE);
+		rtc_time64_to_tm(tstamp, &build_date);
+		build_id = MCDI_DWORD(outbuf, GET_VERSION_V5_OUT_SUCFW_CHIP_ID);
+
+		snprintf(buf, EFCT_MAX_VERSION_INFO_LEN,
+			 "%u.%u.%u.%u type %x (%ptRd)",
+			 le32_to_cpu(dwords[0]), le32_to_cpu(dwords[1]),
+			 le32_to_cpu(dwords[2]), le32_to_cpu(dwords[3]),
+			 build_id, &build_date);
+
+		devlink_info_version_running_put(req, EFCT_DEVLINK_INFO_VERSION_FW_MGMT_SUC, buf);
+	}
+
+	if (flags & BIT(EFCT_VER_FLAG(DATAPATH_HW_VERSION))) {
+		dwords = (__le32 *)MCDI_PTR(outbuf,	GET_VERSION_V5_OUT_DATAPATH_HW_VERSION);
+
+		snprintf(buf, EFCT_MAX_VERSION_INFO_LEN, "%u.%u.%u",
+			 le32_to_cpu(dwords[0]), le32_to_cpu(dwords[1]),
+			 le32_to_cpu(dwords[2]));
+
+		devlink_info_version_running_put(req, EFCT_DEVLINK_INFO_VERSION_DATAPATH_HW, buf);
+	}
+
+	if (flags & BIT(EFCT_VER_FLAG(DATAPATH_FW_VERSION))) {
+		dwords = (__le32 *)MCDI_PTR(outbuf, GET_VERSION_V5_OUT_DATAPATH_FW_VERSION);
+
+		snprintf(buf, EFCT_MAX_VERSION_INFO_LEN, "%u.%u.%u",
+			 le32_to_cpu(dwords[0]), le32_to_cpu(dwords[1]),
+			 le32_to_cpu(dwords[2]));
+
+		devlink_info_version_running_put(req, EFCT_DEVLINK_INFO_VERSION_DATAPATH_FW,
+						 buf);
+	}
+
+	if (flags & BIT(EFCT_VER_FLAG(SOC_BOOT_VERSION))) {
+		dwords = (__le32 *)MCDI_PTR(outbuf, GET_VERSION_V5_OUT_SOC_BOOT_VERSION);
+
+		snprintf(buf, EFCT_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
+			 le32_to_cpu(dwords[0]), le32_to_cpu(dwords[1]),
+			 le32_to_cpu(dwords[2]),
+			 le32_to_cpu(dwords[3]));
+
+		devlink_info_version_running_put(req, EFCT_DEVLINK_INFO_VERSION_SOC_BOOT, buf);
+	}
+
+	if (flags & BIT(EFCT_VER_FLAG(SOC_UBOOT_VERSION))) {
+		dwords = (__le32 *)MCDI_PTR(outbuf, GET_VERSION_V5_OUT_SOC_UBOOT_VERSION);
+
+		snprintf(buf, EFCT_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
+			 le32_to_cpu(dwords[0]), le32_to_cpu(dwords[1]),
+			 le32_to_cpu(dwords[2]),
+			 le32_to_cpu(dwords[3]));
+
+		devlink_info_version_running_put(req, EFCT_DEVLINK_INFO_VERSION_SOC_UBOOT, buf);
+	}
+
+	if (flags & BIT(EFCT_VER_FLAG(SOC_MAIN_ROOTFS_VERSION))) {
+		dwords = (__le32 *)MCDI_PTR(outbuf, GET_VERSION_V5_OUT_SOC_MAIN_ROOTFS_VERSION);
+
+		snprintf(buf, EFCT_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
+			 le32_to_cpu(dwords[0]), le32_to_cpu(dwords[1]),
+			 le32_to_cpu(dwords[2]),
+			 le32_to_cpu(dwords[3]));
+
+		devlink_info_version_running_put(req, EFCT_DEVLINK_INFO_VERSION_SOC_MAIN, buf);
+	}
+
+	if (flags & BIT(EFCT_VER_FLAG(SOC_RECOVERY_BUILDROOT_VERSION))) {
+		dwords = (__le32 *)MCDI_PTR(outbuf,
+				GET_VERSION_V5_OUT_SOC_RECOVERY_BUILDROOT_VERSION);
+
+		snprintf(buf, EFCT_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
+			 le32_to_cpu(dwords[0]), le32_to_cpu(dwords[1]),
+			 le32_to_cpu(dwords[2]),
+			 le32_to_cpu(dwords[3]));
+
+		devlink_info_version_running_put(req, EFCT_DEVLINK_INFO_VERSION_SOC_RECOVERY, buf);
+	}
+
+	if (flags & BIT(EFCT_VER_FLAG(SUCFW_VERSION)) &&
+	    ~flags & BIT(EFCT_VER_FLAG(SUCFW_EXT_INFO))) {
+		dwords = (__le32 *)MCDI_PTR(outbuf, GET_VERSION_V5_OUT_SUCFW_VERSION);
+		snprintf(buf, EFCT_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
+			 le32_to_cpu(dwords[0]), le32_to_cpu(dwords[1]),
+			 le32_to_cpu(dwords[2]),
+			 le32_to_cpu(dwords[3]));
+		devlink_info_version_running_put(req, EFCT_DEVLINK_INFO_VERSION_FW_MGMT_SUC, buf);
+	}
+
+	if (flags & BIT(EFCT_VER_FLAG(BOARD_VERSION))) {
+		dwords = (__le32 *)MCDI_PTR(outbuf, GET_VERSION_V5_OUT_BOARD_VERSION);
+
+		snprintf(buf, EFCT_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
+			 le32_to_cpu(dwords[0]), le32_to_cpu(dwords[1]),
+			 le32_to_cpu(dwords[2]),
+			 le32_to_cpu(dwords[3]));
+
+		devlink_info_version_running_put(req, DEVLINK_INFO_VERSION_GENERIC_BOARD_REV, buf);
+	}
+
+	if (flags & BIT(EFCT_VER_FLAG(BUNDLE_VERSION))) {
+		dwords = (__le32 *)MCDI_PTR(outbuf, GET_VERSION_V5_OUT_BUNDLE_VERSION);
+
+		snprintf(buf, EFCT_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
+			 le32_to_cpu(dwords[0]), le32_to_cpu(dwords[1]),
+			 le32_to_cpu(dwords[2]),
+			 le32_to_cpu(dwords[3]));
+
+		devlink_info_version_running_put(req, DEVLINK_INFO_VERSION_GENERIC_FW_BUNDLE_ID,
+						 buf);
+	}
+}
+
+#undef EFCT_VER_FLAG
+
+static void efct_devlink_info_query_all(struct efct_nic *efct,
+					struct devlink_info_req *req)
+{
+	efct_devlink_info_board_cfg(efct, req);
+	efct_devlink_info_stored_versions(efct, req);
+	efct_devlink_info_running_versions(efct, req);
+}
+
+enum efct_devlink_param_id {
+	EFCT_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
+	EFCT_DEVLINK_PARAM_ID_CT_THRESH,
+	EFCT_DEVLINK_PARAM_ID_DIST_LAYOUT,
+	EFCT_DEVLINK_PARAM_ID_SEPARATED_CPU,
+	EFCT_DEVLINK_PARAM_ID_IRQ_ADAPT_LOW_THRESH,
+	EFCT_DEVLINK_PARAM_ID_IRQ_ADAPT_HIGH_THRESH,
+	EFCT_DEVLINK_PARAM_ID_IRQ_ADAPT_IRQS,
+	EFCT_DEVLINK_PARAM_ID_RX_MERGE_TIMEOUT_NS,
+	EFCT_DEVLINK_PARAM_ID_TX_MERGE_TIMEOUT_NS,
+};
+
+static int efct_irq_adapt_low_thresh_param_get(struct devlink *dl, u32 id,
+					       struct devlink_param_gset_ctx *ctx)
+{
+	struct efct_device **efct_dev = devlink_priv(dl);
+	struct efct_nic *efct = (*efct_dev)->efct[0];
+
+	ctx->val.vu32 = efct->evq[0].irq_adapt_low_thresh;
+
+	return 0;
+}
+
+static int efct_irq_adapt_low_thresh_param_set(struct devlink *dl, u32 id,
+					       struct devlink_param_gset_ctx *ctx)
+{
+	struct efct_device **efct_dev = devlink_priv(dl);
+	struct efct_nic *efct;
+	int i, j;
+
+	for (i = 0; i < (*efct_dev)->num_ports; i++) {
+		efct = (*efct_dev)->efct[i];
+		for (j = 0; j < efct->max_evq_count; j++)
+			efct->evq[j].irq_adapt_low_thresh = ctx->val.vu32;
+	}
+	return 0;
+}
+
+static int efct_irq_adapt_high_thresh_param_get(struct devlink *dl, u32 id,
+						struct devlink_param_gset_ctx *ctx)
+{
+	struct efct_device **efct_dev = devlink_priv(dl);
+	struct efct_nic *efct = (*efct_dev)->efct[0];
+
+	ctx->val.vu32 = efct->evq[0].irq_adapt_high_thresh;
+
+	return 0;
+}
+
+static int efct_irq_adapt_high_thresh_param_set(struct devlink *dl, u32 id,
+						struct devlink_param_gset_ctx *ctx)
+{
+	struct efct_device **efct_dev = devlink_priv(dl);
+	struct efct_nic *efct;
+	int i, j;
+
+	for (i = 0; i < (*efct_dev)->num_ports; i++) {
+		efct = (*efct_dev)->efct[i];
+		for (j = 0; j < efct->max_evq_count; j++)
+			efct->evq[j].irq_adapt_high_thresh = ctx->val.vu32;
+	}
+	return 0;
+}
+
+static int efct_irq_adapt_irqs_param_get(struct devlink *dl, u32 id,
+					 struct devlink_param_gset_ctx *ctx)
+{
+	struct efct_device **efct_dev = devlink_priv(dl);
+	struct efct_nic *efct = (*efct_dev)->efct[0];
+
+	ctx->val.vu32 = efct->evq[0].irq_adapt_irqs;
+
+	return 0;
+}
+
+static int efct_irq_adapt_irqs_param_set(struct devlink *dl, u32 id,
+					 struct devlink_param_gset_ctx *ctx)
+{
+	struct efct_device **efct_dev = devlink_priv(dl);
+	struct efct_nic *efct;
+	int i, j;
+
+	for (i = 0; i < (*efct_dev)->num_ports; i++) {
+		efct = (*efct_dev)->efct[i];
+		for (j = 0; j < efct->max_evq_count; j++)
+			efct->evq[j].irq_adapt_irqs = ctx->val.vu32;
+	}
+	return 0;
+}
+
+static int efct_rx_merge_timeout_get(struct devlink *dl, u32 id,
+				     struct devlink_param_gset_ctx *ctx)
+{
+	struct efct_device **efct_dev = devlink_priv(dl);
+	struct efct_nic *efct = (*efct_dev)->efct[0];
+
+	ctx->val.vu32 = efct->evq[0].rx_merge_timeout_ns;
+
+	return 0;
+}
+
+static int efct_rx_merge_timeout_set(struct devlink *dl, u32 id,
+				     struct devlink_param_gset_ctx *ctx)
+{
+	struct efct_device **efct_dev = devlink_priv(dl);
+	struct efct_nic *efct;
+	int i, j;
+
+	for (i = 0; i < (*efct_dev)->num_ports; i++) {
+		efct = (*efct_dev)->efct[i];
+		for (j = 0; j < efct->max_evq_count; j++)
+			efct->evq[j].rx_merge_timeout_ns = ctx->val.vu32;
+	}
+	return 0;
+}
+
+static int efct_rx_merge_timeout_validate(struct devlink *dl, u32 id, union devlink_param_value val,
+					  struct netlink_ext_ack *extack)
+{
+	if (val.vu32 > MAX_RX_MERGE_TIMEOUT_NS_VALUE) {
+		pr_info("Receive event merge timeout too large for X3, It shall be less than %u\n",
+			MAX_RX_MERGE_TIMEOUT_NS_VALUE);
+		return -EINVAL;
+	}
+
+	if (val.vu32 > 0 && (val.vu32 % EV_TIMER_GRANULARITY_NS != 0)) {
+		pr_info("Receive event merge timeout must be a multiple of %u\n",
+			EV_TIMER_GRANULARITY_NS);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int efct_tx_merge_timeout_get(struct devlink *dl, u32 id, struct devlink_param_gset_ctx *ctx)
+{
+	struct efct_device **efct_dev = devlink_priv(dl);
+	struct efct_nic *efct = (*efct_dev)->efct[0];
+
+	ctx->val.vu32 = efct->evq[0].tx_merge_timeout_ns;
+
+	return 0;
+}
+
+static int efct_tx_merge_timeout_set(struct devlink *dl, u32 id, struct devlink_param_gset_ctx *ctx)
+{
+	struct efct_device **efct_dev = devlink_priv(dl);
+	struct efct_nic *efct;
+	int i, j;
+
+	for (i = 0; i < (*efct_dev)->num_ports; i++) {
+		efct = (*efct_dev)->efct[i];
+		for (j = 0; j < efct->max_evq_count; j++)
+			efct->evq[j].tx_merge_timeout_ns = ctx->val.vu32;
+	}
+	return 0;
+}
+
+static int efct_tx_merge_timeout_validate(struct devlink *dl, u32 id, union devlink_param_value val,
+					  struct netlink_ext_ack *extack)
+{
+	if (val.vu32 > MAX_TX_MERGE_TIMEOUT_NS_VALUE) {
+		pr_info("Transmit event merge timeout too large for X3, It shall be less than %u\n",
+			MAX_TX_MERGE_TIMEOUT_NS_VALUE);
+		return -EINVAL;
+	}
+
+	if (val.vu32 > 0 && (val.vu32 % EV_TIMER_GRANULARITY_NS != 0)) {
+		pr_info("Transmit event merge timeout must be a multiple of %u\n",
+			EV_TIMER_GRANULARITY_NS);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int efct_ct_thresh_param_get(struct devlink *dl, u32 id, struct devlink_param_gset_ctx *ctx)
+{
+	struct efct_device **efct_dev = devlink_priv(dl);
+	struct efct_nic *efct = (*efct_dev)->efct[0];
+
+	ctx->val.vu16 = efct->ct_thresh * 64;
+
+	return 0;
+}
+
+static int efct_ct_thresh_param_set(struct devlink *dl, u32 id, struct devlink_param_gset_ctx *ctx)
+{
+	struct efct_device **efct_dev = devlink_priv(dl);
+	struct efct_nic *efct;
+	int i, j;
+
+	for (i = 0; i < (*efct_dev)->num_ports; i++) {
+		efct = (*efct_dev)->efct[i];
+		efct->ct_thresh = ctx->val.vu16 / 64;
+		for (j = 0; j < EFCT_MAX_CORE_TX_QUEUES; j++)
+			efct->txq[j].ct_thresh = efct->ct_thresh;
+	}
+	return 0;
+}
+
+static int efct_ct_thresh_param_validate(struct devlink *dl, u32 id, union devlink_param_value val,
+					 struct netlink_ext_ack *extack)
+{
+	if (((val.vu16 % 64) != 0) || val.vu16 > MAX_CT_THRESHOLD_VALUE) {
+		pr_info("Invalid CTPIO Threshold value passed. It shall be less than %d and a multiple of 64",
+			MAX_CT_THRESHOLD_VALUE);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int efct_dist_layout_param_get(struct devlink *dl, u32 id,
+				      struct devlink_param_gset_ctx *ctx)
+{
+	struct efct_device **efct_dev = devlink_priv(dl);
+
+	ctx->val.vu8 = (*efct_dev)->dist_layout;
+
+	return 0;
+}
+
+static int efct_dist_layout_param_set(struct devlink *dl, u32 id,
+				      struct devlink_param_gset_ctx *ctx)
+{
+	struct efct_device **efct_dev = devlink_priv(dl);
+	struct efct_nic *efct;
+	int i;
+
+	if ((*efct_dev)->dist_layout == ctx->val.vu8)
+		return 0;
+
+	(*efct_dev)->dist_layout = ctx->val.vu8;
+	for (i = 0; i < (*efct_dev)->num_ports; i++) {
+		efct = (*efct_dev)->efct[i];
+		mutex_lock(&efct->state_lock);
+		if (efct->state == STATE_NET_UP)
+			efct_set_interrupt_affinity(efct);
+		mutex_unlock(&efct->state_lock);
+	}
+
+	return 0;
+}
+
+static int efct_dist_layout_param_validate(struct devlink *dl, u32 id,
+					   union devlink_param_value val,
+					  struct netlink_ext_ack *extack)
+{
+	if (val.vu8 != RX_LAYOUT_DISTRIBUTED && val.vu8 != RX_LAYOUT_SEPARATED) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid Layout value.Use 0-Distributed,1-Separated");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int efct_separated_cpu_param_get(struct devlink *dl, u32 id,
+					struct devlink_param_gset_ctx *ctx)
+{
+	struct efct_device **efct_dev = devlink_priv(dl);
+
+	ctx->val.vu8 = (*efct_dev)->separated_rx_cpu;
+
+	return 0;
+}
+
+static int efct_separated_cpu_param_set(struct devlink *dl, u32 id,
+					struct devlink_param_gset_ctx *ctx)
+{
+	struct efct_device **efct_dev = devlink_priv(dl);
+	struct efct_nic *efct;
+	int i;
+
+	if ((*efct_dev)->separated_rx_cpu == ctx->val.vu8)
+		return 0;
+
+	(*efct_dev)->separated_rx_cpu = ctx->val.vu8;
+	for (i = 0; i < (*efct_dev)->num_ports; i++) {
+		efct = (*efct_dev)->efct[i];
+		mutex_lock(&efct->state_lock);
+		if (efct->state == STATE_NET_UP)
+			efct_set_interrupt_affinity(efct);
+		mutex_unlock(&efct->state_lock);
+	}
+
+	return 0;
+}
+
+static int efct_separated_cpu_param_validate(struct devlink *dl, u32 id,
+					     union devlink_param_value val,
+					     struct netlink_ext_ack *extack)
+{
+	struct efct_device **efct_dev = devlink_priv(dl);
+
+	if ((*efct_dev)->dist_layout == RX_LAYOUT_DISTRIBUTED) {
+		NL_SET_ERR_MSG_MOD(extack, "Current layout is distributed. Use separated layout");
+		return -EINVAL;
+	}
+
+	if (val.vu8 > num_online_cpus()) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Invalid CPU value passed. Value exceeds current online CPUS");
+		pr_info("Invalid CPU value. Exceeds current online CPUS [%u]", num_online_cpus());
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static const struct devlink_param efct_devlink_params[] = {
+	DEVLINK_PARAM_DRIVER(EFCT_DEVLINK_PARAM_ID_CT_THRESH,
+			     "ct_thresh", DEVLINK_PARAM_TYPE_U16,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     efct_ct_thresh_param_get,
+			     efct_ct_thresh_param_set,
+			     efct_ct_thresh_param_validate),
+	DEVLINK_PARAM_DRIVER(EFCT_DEVLINK_PARAM_ID_DIST_LAYOUT,
+			     "dist_layout", DEVLINK_PARAM_TYPE_U8,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     efct_dist_layout_param_get,
+			     efct_dist_layout_param_set,
+			     efct_dist_layout_param_validate),
+	DEVLINK_PARAM_DRIVER(EFCT_DEVLINK_PARAM_ID_SEPARATED_CPU,
+			     "separated_cpu", DEVLINK_PARAM_TYPE_U8,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     efct_separated_cpu_param_get,
+			     efct_separated_cpu_param_set,
+			     efct_separated_cpu_param_validate),
+	DEVLINK_PARAM_DRIVER(EFCT_DEVLINK_PARAM_ID_IRQ_ADAPT_LOW_THRESH,
+			     "irq_adapt_low_thresh", DEVLINK_PARAM_TYPE_U32,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     efct_irq_adapt_low_thresh_param_get,
+			     efct_irq_adapt_low_thresh_param_set,
+			     NULL),
+	DEVLINK_PARAM_DRIVER(EFCT_DEVLINK_PARAM_ID_IRQ_ADAPT_HIGH_THRESH,
+			     "irq_adapt_high_thresh", DEVLINK_PARAM_TYPE_U32,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     efct_irq_adapt_high_thresh_param_get,
+			     efct_irq_adapt_high_thresh_param_set,
+			     NULL),
+	DEVLINK_PARAM_DRIVER(EFCT_DEVLINK_PARAM_ID_IRQ_ADAPT_IRQS,
+			     "irq_adapt_irqs", DEVLINK_PARAM_TYPE_U32,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     efct_irq_adapt_irqs_param_get,
+			     efct_irq_adapt_irqs_param_set,
+			     NULL),
+	DEVLINK_PARAM_DRIVER(EFCT_DEVLINK_PARAM_ID_RX_MERGE_TIMEOUT_NS,
+			     "rx_merge_timeout", DEVLINK_PARAM_TYPE_U32,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     efct_rx_merge_timeout_get,
+			     efct_rx_merge_timeout_set,
+			     efct_rx_merge_timeout_validate),
+	DEVLINK_PARAM_DRIVER(EFCT_DEVLINK_PARAM_ID_TX_MERGE_TIMEOUT_NS,
+			     "tx_merge_timeout", DEVLINK_PARAM_TYPE_U32,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     efct_tx_merge_timeout_get,
+			     efct_tx_merge_timeout_set,
+			     efct_tx_merge_timeout_validate),
+};
+
+static int efct_devlink_info_get(struct devlink *devlink,
+				 struct devlink_info_req *req,
+				struct netlink_ext_ack *extack)
+{
+	struct efct_device **efct_dev = devlink_priv(devlink);
+	struct efct_nic *efct = (*efct_dev)->efct[0];
+
+	efct_devlink_info_query_all(efct, req);
+	return 0;
+}
+
+static int efct_devlink_flash_update(struct devlink *devlink,
+				     struct devlink_flash_update_params *params,
+				    struct netlink_ext_ack *extack)
+{
+	struct efct_device **efct_dev = devlink_priv(devlink);
+	struct efct_nic *efct = (*efct_dev)->efct[0];
+
+	return efct_reflash_flash_firmware(efct, params->fw);
+}
+
+static const struct devlink_ops efct_devlink_ops = {
+	.supported_flash_update_params	= 0,
+	.flash_update			= efct_devlink_flash_update,
+	.info_get			= efct_devlink_info_get,
+};
+
+static void efct_devlink_params_unregister(struct efct_device *efct_dev)
+{
+	if (efct_dev->devlink) {
+		devlink_params_unregister(efct_dev->devlink, efct_devlink_params,
+					  ARRAY_SIZE(efct_devlink_params));
+	}
+}
+
+void efct_fini_devlink(struct efct_device *efct_dev)
+{
+	if (efct_dev->devlink)
+		devlink_free(efct_dev->devlink);
+	efct_dev->devlink = NULL;
+}
+
+int efct_probe_devlink(struct efct_device *efct_dev)
+{
+	struct efct_device **devlink_private;
+
+	int rc = 0;
+
+	efct_dev->devlink = devlink_alloc(&efct_devlink_ops,
+					  sizeof(struct efct_device **),
+					  &efct_dev->pci_dev->dev);
+	if (!efct_dev->devlink)
+		return -ENOMEM;
+
+	devlink_private = devlink_priv(efct_dev->devlink);
+	*devlink_private = efct_dev;
+
+	return rc;
+}
+
+int efct_devlink_port_register(struct efct_nic *efct)
+{
+	struct devlink_port_attrs attrs = {};
+	int rc;
+
+	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
+	attrs.phys.port_number = efct->port_num;
+	devlink_port_attrs_set(&efct->dl_port, &attrs);
+	SET_NETDEV_DEVLINK_PORT(efct->net_dev, &efct->dl_port);
+	rc = devlink_port_register(efct->efct_dev->devlink, &efct->dl_port,
+				   efct->port_num);
+	if (rc)
+		return rc;
+
+	return 0;
+}
+
+static int efct_devlink_params_register(struct efct_device *efct_dev)
+{
+	int rc;
+
+	rc = devlink_params_register(efct_dev->devlink, efct_devlink_params,
+				     ARRAY_SIZE(efct_devlink_params));
+	if (rc)
+		return rc;
+
+	return 0;
+}
+
+int efct_devlink_register(struct efct_device *efct_dev)
+{
+	int rc = 0;
+
+	rc = efct_devlink_params_register(efct_dev);
+	if (rc)
+		return rc;
+
+	devlink_register(efct_dev->devlink);
+
+	return rc;
+}
+
+void efct_devlink_unregister(struct efct_device *efct_dev)
+{
+	devlink_unregister(efct_dev->devlink);
+	efct_devlink_params_unregister(efct_dev);
+}
diff --git a/drivers/net/ethernet/amd/efct/efct_devlink.h b/drivers/net/ethernet/amd/efct/efct_devlink.h
new file mode 100644
index 000000000000..8e3720262820
--- /dev/null
+++ b/drivers/net/ethernet/amd/efct/efct_devlink.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0
+ ****************************************************************************
+ * Driver for AMD/Xilinx network controllers and boards
+ * Copyright (C) 2021, Xilinx, Inc.
+ * Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
+ */
+#ifndef _EFCT_DEVLINK_H
+#define _EFCT_DEVLINK_H
+
+#include "efct_driver.h"
+#include <net/devlink.h>
+
+int efct_probe_devlink(struct efct_device *efct_dev);
+int efct_devlink_port_register(struct efct_nic *efct);
+void efct_fini_devlink(struct efct_device *efct_dev);
+int efct_devlink_register(struct efct_device *efct_dev);
+void efct_devlink_unregister(struct efct_device *efct_dev);
+
+struct devlink_port *efct_get_devlink_port(struct net_device *dev);
+
+#endif	/* _EFCT_DEVLINK_H */
diff --git a/drivers/net/ethernet/amd/efct/efct_driver.h b/drivers/net/ethernet/amd/efct/efct_driver.h
index a8d396ecee49..eb110895cb18 100644
--- a/drivers/net/ethernet/amd/efct/efct_driver.h
+++ b/drivers/net/ethernet/amd/efct/efct_driver.h
@@ -20,6 +20,7 @@
 #include <linux/netdevice.h>
 #include <linux/pci.h>
 
+#include <net/devlink.h>
 #include "efct_enum.h"
 #include "efct_bitfield.h"
 
@@ -585,6 +586,7 @@ struct efct_nic {
 	/* Mutex for serializing firmware reflash operations.*/
 	struct mutex reflash_mutex;
 	struct efct_mcdi_filter_table *filter_table;
+	struct devlink_port dl_port;
 };
 
 struct design_params {
@@ -644,6 +646,7 @@ struct efct_device {
 	resource_size_t bar_len;
 	bool mcdi_logging;
 	struct efct_nic *efct[MAX_PORTS];
+	void *devlink;
 	/*IRQ vectors per port*/
 	u16 vec_per_port;
 	struct msix_entry *xentries;
diff --git a/drivers/net/ethernet/amd/efct/efct_netdev.c b/drivers/net/ethernet/amd/efct/efct_netdev.c
index 23a776ab88a3..a7814a1b1386 100644
--- a/drivers/net/ethernet/amd/efct/efct_netdev.c
+++ b/drivers/net/ethernet/amd/efct/efct_netdev.c
@@ -11,6 +11,7 @@
 #include "efct_nic.h"
 #include "mcdi.h"
 #include "mcdi_port_common.h"
+#include "efct_devlink.h"
 
 static int efct_netdev_event(struct notifier_block *this,
 			     unsigned long event, void *ptr)
diff --git a/drivers/net/ethernet/amd/efct/efct_pci.c b/drivers/net/ethernet/amd/efct/efct_pci.c
index af76ae37e040..6933ad634411 100644
--- a/drivers/net/ethernet/amd/efct/efct_pci.c
+++ b/drivers/net/ethernet/amd/efct/efct_pci.c
@@ -14,6 +14,7 @@
 #include "efct_common.h"
 #include "efct_netdev.h"
 #include "efct_nic.h"
+#include "efct_devlink.h"
 
 /**************************************************************************
  *
@@ -664,6 +665,7 @@ static u32 efct_get_num_ports(struct efct_device *efct_dev)
 static void efct_free_dev(struct efct_nic *efct)
 {
 	efct_unregister_netdev(efct);
+	devlink_port_unregister(&efct->dl_port);
 	efct->type->remove(efct);
 	efct_unmap_membase(efct);
 	free_netdev(efct->net_dev);
@@ -907,6 +909,9 @@ static int efct_pci_probe
 	rc = efct_alloc_msix(efct_dev);
 	if (rc)
 		goto fail2;
+	rc = efct_probe_devlink(efct_dev);
+	if (rc)
+		goto free_msi;
 	efct_nic_check_pcie_link(efct_dev, EFCT_BW_PCIE_GEN3_X8, NULL, NULL);
 
 	for (i = 0; i < efct_dev->num_ports; i++) {
@@ -957,6 +962,12 @@ static int efct_pci_probe
 			pci_err(pci_dev, "Unable to probe net device, rc=%d\n", rc);
 			goto fail6;
 		}
+		/*Devlink port register*/
+		rc = efct_devlink_port_register(efct);
+		if (rc) {
+			pci_err(pci_dev, "Unable to register devlink port, rc=%d\n", rc);
+			goto fail6;
+		}
 		rc = efct_register_netdev(efct);
 		if (rc) {
 			pci_err(pci_dev, "Unable to register net device, rc=%d\n", rc);
@@ -965,9 +976,14 @@ static int efct_pci_probe
 		/*Populating IRQ numbers in aux resources*/
 		efct_assign_msix(efct, i);
 	}
-	rc = efct_init_stats_wq(efct_dev);
+	rc = efct_devlink_register(efct_dev);
 	if (rc)
 		goto freep0;
+	rc = efct_init_stats_wq(efct_dev);
+	if (rc) {
+		efct_devlink_unregister(efct_dev);
+		goto freep0;
+	}
 
 	pr_info("EFCT X3 NIC detected: device %04x:%04x subsys %04x:%04x\n",
 		pci_dev->vendor, pci_dev->device,
@@ -976,6 +992,7 @@ static int efct_pci_probe
 	return 0;
 
 fail7:
+	devlink_port_unregister(&efct->dl_port);
 fail6:
 	efct->type->remove(efct);
 fail5:
@@ -987,6 +1004,8 @@ static int efct_pci_probe
 freep0:
 	for (j = 0; j < i ; j++)
 		efct_free_dev(efct_dev->efct[j]);
+	efct_fini_devlink(efct_dev);
+free_msi:
 	efct_free_msix(efct_dev);
 fail2:
 #ifdef CONFIG_EFCT_MCDI_LOGGING
@@ -1015,14 +1034,17 @@ static void efct_pci_remove(struct pci_dev *pci_dev)
 		return;
 
 	efct_fini_stats_wq(efct_dev);
+	efct_devlink_unregister(efct_dev);
 	for (i = 0; i < efct_dev->num_ports; i++) {
 		efct_close_netdev(efct_dev->efct[i]);
 		efct_remove_netdev(efct_dev->efct[i]);
+		devlink_port_unregister(&efct_dev->efct[i]->dl_port);
 		efct_dev->efct[i]->type->remove(efct_dev->efct[i]);
 		efct_flush_reset_workqueue();
 		efct_unmap_membase(efct_dev->efct[i]);
 		free_netdev(efct_dev->efct[i]->net_dev);
 	}
+	efct_fini_devlink(efct_dev);
 	efct_free_msix(efct_dev);
 #ifdef CONFIG_EFCT_MCDI_LOGGING
 	efct_fini_mcdi_logging(efct_dev);
diff --git a/drivers/net/ethernet/amd/efct/efct_reflash.c b/drivers/net/ethernet/amd/efct/efct_reflash.c
new file mode 100644
index 000000000000..9061dce05d4e
--- /dev/null
+++ b/drivers/net/ethernet/amd/efct/efct_reflash.c
@@ -0,0 +1,564 @@
+// SPDX-License-Identifier: GPL-2.0
+/****************************************************************************
+ * Driver for AMD/Xilinx network controllers and boards
+ * Copyright (C) 2021, Xilinx, Inc.
+ * Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
+ */
+#include <linux/crc32.h>
+
+#include "mcdi.h"
+#include "efct_reflash.h"
+#include "efct_devlink.h"
+#include "mcdi_functions.h"
+
+/* Reflash firmware data header and trailer fields (see SF-121352-AN) */
+#define EFCT_REFLASH_HEADER_MAGIC_OFST 0
+#define EFCT_REFLASH_HEADER_MAGIC_LEN 4
+#define EFCT_REFLASH_HEADER_MAGIC_VALUE 0x106F1A5
+
+#define EFCT_REFLASH_HEADER_VERSION_OFST 4
+#define EFCT_REFLASH_HEADER_VERSION_LEN 4
+#define EFCT_REFLASH_HEADER_VERSION_VALUE 4
+
+#define EFCT_REFLASH_HEADER_FIRMWARE_TYPE_OFST 8
+#define EFCT_REFLASH_HEADER_FIRMWARE_TYPE_LEN 4
+#define EFCT_REFLASH_FIRMWARE_TYPE_BOOTROM 0x2
+#define EFCT_REFLASH_FIRMWARE_TYPE_BUNDLE 0xd
+
+#define EFCT_REFLASH_HEADER_FIRMWARE_SUBTYPE_OFST 12
+#define EFCT_REFLASH_HEADER_FIRMWARE_SUBTYPE_LEN 4
+
+#define EFCT_REFLASH_HEADER_PAYLOAD_SIZE_OFST 16
+#define EFCT_REFLASH_HEADER_PAYLOAD_SIZE_LEN 4
+
+#define EFCT_REFLASH_HEADER_LENGTH_OFST 20
+#define EFCT_REFLASH_HEADER_LENGTH_LEN 4
+
+#define EFCT_REFLASH_HEADER_MINLEN	\
+	(EFCT_REFLASH_HEADER_LENGTH_OFST + EFCT_REFLASH_HEADER_LENGTH_LEN)
+
+#define EFCT_REFLASH_TRAILER_CRC_OFST 0
+#define EFCT_REFLASH_TRAILER_CRC_LEN 4
+
+#define EFCT_REFLASH_TRAILER_LEN	\
+	(EFCT_REFLASH_TRAILER_CRC_OFST + EFCT_REFLASH_TRAILER_CRC_LEN)
+
+static bool efct_reflash_parse_reflash_header(const struct firmware *fw,
+					      size_t header_offset, u32 *type,
+					     u32 *subtype, const u8 **data,
+					     size_t *data_size)
+{
+	u32 magic, version, payload_size, header_len, trailer_offset;
+	const u8 *header, *trailer;
+	u32 expected_crc, crc;
+
+	if (fw->size < header_offset + EFCT_REFLASH_HEADER_MINLEN)
+		return false;
+
+	header = fw->data + header_offset;
+	magic = get_unaligned_le32(header + EFCT_REFLASH_HEADER_MAGIC_OFST);
+	if (magic != EFCT_REFLASH_HEADER_MAGIC_VALUE)
+		return false;
+
+	version = get_unaligned_le32(header + EFCT_REFLASH_HEADER_VERSION_OFST);
+	if (version != EFCT_REFLASH_HEADER_VERSION_VALUE)
+		return false;
+
+	payload_size = get_unaligned_le32(header + EFCT_REFLASH_HEADER_PAYLOAD_SIZE_OFST);
+	header_len = get_unaligned_le32(header + EFCT_REFLASH_HEADER_LENGTH_OFST);
+	trailer_offset = header_offset + header_len + payload_size;
+	if (fw->size < trailer_offset + EFCT_REFLASH_TRAILER_LEN)
+		return false;
+
+	trailer = fw->data + trailer_offset;
+	expected_crc = get_unaligned_le32(trailer + EFCT_REFLASH_TRAILER_CRC_OFST);
+	crc = crc32_le(0, header, header_len + payload_size);
+	if (crc != expected_crc)
+		return false;
+
+	*type = get_unaligned_le32(header + EFCT_REFLASH_HEADER_FIRMWARE_TYPE_OFST);
+	*subtype = get_unaligned_le32(header + EFCT_REFLASH_HEADER_FIRMWARE_SUBTYPE_OFST);
+	if (*type == EFCT_REFLASH_FIRMWARE_TYPE_BUNDLE) {
+		/* All the bundle data is written verbatim to NVRAM */
+		*data = fw->data;
+		*data_size = fw->size;
+	} else {
+		/* Other payload types strip the reflash header and trailer
+		 * from the data written to NVRAM
+		 */
+		*data = header + header_len;
+		*data_size = payload_size;
+	}
+
+	return true;
+}
+
+static int efct_reflash_partition_type(u32 type, u32 subtype,
+				       u32 *partition_type,
+				      u32 *partition_subtype)
+{
+	int rc = 0;
+
+	/* Map from FIRMWARE_TYPE to NVRAM_PARTITION_TYPE */
+	switch (type) {
+	case EFCT_REFLASH_FIRMWARE_TYPE_BOOTROM:
+		*partition_type = NVRAM_PARTITION_TYPE_EXPANSION_ROM;
+		*partition_subtype = subtype;
+		break;
+	case EFCT_REFLASH_FIRMWARE_TYPE_BUNDLE:
+		*partition_type = NVRAM_PARTITION_TYPE_BUNDLE;
+		*partition_subtype = subtype;
+		break;
+	default:
+		/* Not supported */
+		rc = -EINVAL;
+	}
+
+	return rc;
+}
+
+/* SmartNIC image header fields */
+#define EFCT_SNICIMAGE_HEADER_MAGIC_OFST 16
+#define EFCT_SNICIMAGE_HEADER_MAGIC_LEN 4
+#define EFCT_SNICIMAGE_HEADER_MAGIC_VALUE 0x541C057A
+
+#define EFCT_SNICIMAGE_HEADER_VERSION_OFST 20
+#define EFCT_SNICIMAGE_HEADER_VERSION_LEN 4
+#define EFCT_SNICIMAGE_HEADER_VERSION_VALUE 1
+
+#define EFCT_SNICIMAGE_HEADER_LENGTH_OFST 24
+#define EFCT_SNICIMAGE_HEADER_LENGTH_LEN 4
+
+#define EFCT_SNICIMAGE_HEADER_PARTITION_TYPE_OFST 36
+#define EFCT_SNICIMAGE_HEADER_PARTITION_TYPE_LEN 4
+
+#define EFCT_SNICIMAGE_HEADER_PARTITION_SUBTYPE_OFST 40
+#define EFCT_SNICIMAGE_HEADER_PARTITION_SUBTYPE_LEN 4
+
+#define EFCT_SNICIMAGE_HEADER_PAYLOAD_SIZE_OFST 60
+#define EFCT_SNICIMAGE_HEADER_PAYLOAD_SIZE_LEN 4
+
+#define EFCT_SNICIMAGE_HEADER_CRC_OFST 64
+#define EFCT_SNICIMAGE_HEADER_CRC_LEN 4
+
+#define EFCT_SNICIMAGE_HEADER_MINLEN 256
+
+static bool efct_reflash_parse_snic_header(const struct firmware *fw,
+					   size_t header_offset,
+					  u32 *partition_type,
+					  u32 *partition_subtype,
+					  const u8 **data, size_t *data_size)
+{
+	u32 magic, version, payload_size, header_len, expected_crc, crc;
+	const u8 *header;
+
+	if (fw->size < header_offset + EFCT_SNICIMAGE_HEADER_MINLEN)
+		return false;
+
+	header = fw->data + header_offset;
+	magic = get_unaligned_le32(header + EFCT_SNICIMAGE_HEADER_MAGIC_OFST);
+	if (magic != EFCT_SNICIMAGE_HEADER_MAGIC_VALUE)
+		return false;
+
+	version = get_unaligned_le32(header + EFCT_SNICIMAGE_HEADER_VERSION_OFST);
+	if (version != EFCT_SNICIMAGE_HEADER_VERSION_VALUE)
+		return false;
+
+	header_len = get_unaligned_le32(header + EFCT_SNICIMAGE_HEADER_LENGTH_OFST);
+	payload_size = get_unaligned_le32(header + EFCT_SNICIMAGE_HEADER_PAYLOAD_SIZE_OFST);
+	if (fw->size < header_len + payload_size)
+		return false;
+
+	expected_crc = get_unaligned_le32(header + EFCT_SNICIMAGE_HEADER_CRC_OFST);
+
+	/* Calculate CRC omitting the expected CRC field itself */
+	crc = crc32_le(~0, header, EFCT_SNICIMAGE_HEADER_CRC_OFST);
+	crc = ~crc32_le(crc,
+			header + EFCT_SNICIMAGE_HEADER_CRC_OFST +
+			EFCT_SNICIMAGE_HEADER_CRC_LEN,
+			header_len + payload_size - EFCT_SNICIMAGE_HEADER_CRC_OFST -
+			EFCT_SNICIMAGE_HEADER_CRC_LEN);
+	if (crc != expected_crc)
+		return false;
+
+	*partition_type =
+		get_unaligned_le32(header + EFCT_SNICIMAGE_HEADER_PARTITION_TYPE_OFST);
+	*partition_subtype =
+		get_unaligned_le32(header + EFCT_SNICIMAGE_HEADER_PARTITION_SUBTYPE_OFST);
+	*data = fw->data;
+	*data_size = fw->size;
+	return true;
+}
+
+/* SmartNIC bundle header fields (see SF-122606-TC) */
+#define EFCT_SNICBUNDLE_HEADER_MAGIC_OFST 0
+#define EFCT_SNICBUNDLE_HEADER_MAGIC_LEN 4
+#define EFCT_SNICBUNDLE_HEADER_MAGIC_VALUE 0xB1001001
+
+#define EFCT_SNICBUNDLE_HEADER_VERSION_OFST 4
+#define EFCT_SNICBUNDLE_HEADER_VERSION_LEN 4
+#define EFCT_SNICBUNDLE_HEADER_VERSION_VALUE 1
+
+#define EFCT_SNICBUNDLE_HEADER_BUNDLE_TYPE_OFST 8
+#define EFCT_SNICBUNDLE_HEADER_BUNDLE_TYPE_LEN 4
+
+#define EFCT_SNICBUNDLE_HEADER_BUNDLE_SUBTYPE_OFST 12
+#define EFCT_SNICBUNDLE_HEADER_BUNDLE_SUBTYPE_LEN 4
+
+#define EFCT_SNICBUNDLE_HEADER_LENGTH_OFST 20
+#define EFCT_SNICBUNDLE_HEADER_LENGTH_LEN 4
+
+#define EFCT_SNICBUNDLE_HEADER_CRC_OFST 224
+#define EFCT_SNICBUNDLE_HEADER_CRC_LEN 4
+
+#define EFCT_SNICBUNDLE_HEADER_LEN	\
+	(EFCT_SNICBUNDLE_HEADER_CRC_OFST + EFCT_SNICBUNDLE_HEADER_CRC_LEN)
+
+static bool efct_reflash_parse_snic_bundle_header(const struct firmware *fw,
+						  size_t header_offset,
+						 u32 *partition_type,
+						 u32 *partition_subtype,
+						 const u8 **data,
+						 size_t *data_size)
+{
+	u32 magic, version, bundle_type, header_len, expected_crc, crc;
+	const u8 *header;
+
+	if (fw->size < header_offset + EFCT_SNICBUNDLE_HEADER_LEN)
+		return false;
+
+	header = fw->data + header_offset;
+	magic = get_unaligned_le32(header + EFCT_SNICBUNDLE_HEADER_MAGIC_OFST);
+	if (magic != EFCT_SNICBUNDLE_HEADER_MAGIC_VALUE)
+		return false;
+
+	version = get_unaligned_le32(header + EFCT_SNICBUNDLE_HEADER_VERSION_OFST);
+	if (version != EFCT_SNICBUNDLE_HEADER_VERSION_VALUE)
+		return false;
+
+	bundle_type = get_unaligned_le32(header + EFCT_SNICBUNDLE_HEADER_BUNDLE_TYPE_OFST);
+	if (bundle_type != NVRAM_PARTITION_TYPE_BUNDLE)
+		return false;
+
+	header_len = get_unaligned_le32(header + EFCT_SNICBUNDLE_HEADER_LENGTH_OFST);
+	if (header_len != EFCT_SNICBUNDLE_HEADER_LEN)
+		return false;
+
+	expected_crc = get_unaligned_le32(header + EFCT_SNICBUNDLE_HEADER_CRC_OFST);
+	crc = ~crc32_le(~0, header, EFCT_SNICBUNDLE_HEADER_CRC_OFST);
+	if (crc != expected_crc)
+		return false;
+
+	*partition_type = NVRAM_PARTITION_TYPE_BUNDLE;
+	*partition_subtype = get_unaligned_le32(header +
+			     EFCT_SNICBUNDLE_HEADER_BUNDLE_SUBTYPE_OFST);
+	*data = fw->data;
+	*data_size = fw->size;
+	return true;
+}
+
+static int efct_reflash_parse_firmware_data(const struct firmware *fw,
+					    u32 *partition_type,
+					   u32 *partition_subtype,
+					   const u8 **data, size_t *data_size)
+{
+	size_t header_offset;
+	u32 type, subtype;
+
+	/* Try to find a valid firmware payload in the firmware data.  Some
+	 * packaging formats (such as CMS/PKCS#7 signed images) prepend a
+	 * header for which finding the size is a non-trivial task.
+	 *
+	 * The checks are intended to reject firmware data that is clearly not
+	 * in the expected format.  They do not need to be exhaustive as the
+	 * running firmware will perform its own comprehensive validity and
+	 * compatibility checks during the update procedure.
+	 *
+	 * Firmware packages may contain multiple reflash images, e.g. a
+	 * bundle containing one or more other images.  Only check the
+	 * outermost container by stopping after the first candidate image
+	 * found even it is for an unsupported partition type.
+	 */
+	for (header_offset = 0; header_offset < fw->size; header_offset++) {
+		if (efct_reflash_parse_snic_bundle_header(fw, header_offset,
+							  partition_type,
+							 partition_subtype,
+							 data, data_size))
+			return 0;
+
+		if (efct_reflash_parse_snic_header(fw, header_offset,
+						   partition_type,
+						  partition_subtype, data,
+						  data_size))
+			return 0;
+
+		if (efct_reflash_parse_reflash_header(fw, header_offset, &type,
+						      &subtype, data, data_size))
+			return efct_reflash_partition_type(type, subtype,
+							  partition_type,
+							  partition_subtype);
+	}
+
+	return -EINVAL;
+}
+
+/* Limit the number of status updates during the erase or write phases */
+#define EFCT_DEVLINK_STATUS_UPDATE_COUNT		50
+
+/* Expected timeout for the efct_mcdi_nvram_update_finish_polled() */
+#define EFCT_DEVLINK_UPDATE_FINISH_TIMEOUT	900
+
+/* Ideal erase chunk size.  This is a balance between minimising the number of
+ * MCDI requests to erase an entire partition whilst avoiding tripping the MCDI
+ * RPC timeout.
+ */
+#define EFCT_NVRAM_ERASE_IDEAL_CHUNK_SIZE	(64 * 1024)
+
+static int efct_reflash_erase_partition(struct efct_nic *efct,
+					struct devlink *devlink, u32 type,
+				       size_t partition_size,
+				       size_t align)
+{
+	size_t chunk, offset, next_update;
+	int rc;
+
+	/* Partitions that cannot be erased or do not require erase before
+	 * write are advertised with a erase alignment/sector size of zero.
+	 */
+	if (align == 0)
+		/* Nothing to do */
+		return 0;
+
+	if (partition_size % align)
+		return -EINVAL;
+
+	/* Erase the entire NVRAM partition a chunk at a time to avoid
+	 * potentially tripping the MCDI RPC timeout.
+	 */
+	if (align >= EFCT_NVRAM_ERASE_IDEAL_CHUNK_SIZE)
+		chunk = align;
+	else
+		chunk = rounddown(EFCT_NVRAM_ERASE_IDEAL_CHUNK_SIZE, align);
+
+	for (offset = 0, next_update = 0; offset < partition_size; offset += chunk) {
+		if (offset >= next_update) {
+			devlink_flash_update_status_notify(devlink, "Erasing",
+							   NULL, offset,
+							   partition_size);
+			next_update += partition_size / EFCT_DEVLINK_STATUS_UPDATE_COUNT;
+		}
+
+		chunk = min_t(size_t, partition_size - offset, chunk);
+		rc = efct_mcdi_nvram_erase(efct, type, offset, chunk);
+		if (rc) {
+			netif_err(efct, hw, efct->net_dev,
+				  "Erase failed for NVRAM partition %#x at %#zx-%#zx with error %d\n",
+				  type, offset, offset + chunk - 1, rc);
+			return rc;
+		}
+	}
+
+	devlink_flash_update_status_notify(devlink, "Erasing", NULL,
+					   partition_size, partition_size);
+
+	return 0;
+}
+
+static int efct_reflash_write_partition(struct efct_nic *efct,
+					struct devlink *devlink, u32 type,
+				       const u8 *data, size_t data_size,
+				       size_t align)
+{
+	size_t write_max, chunk, offset, next_update;
+	int rc;
+
+	if (align == 0)
+		return -EINVAL;
+
+	/* Write the NVRAM partition in chunks that are the largest multiple
+	 * of the partiion's required write alignment that will fit into the
+	 * MCDI NVRAM_WRITE RPC payload.
+	 */
+	if (efct->type->mcdi_max_ver < 2)
+		write_max = MC_CMD_NVRAM_WRITE_IN_WRITE_BUFFER_LEN *
+			    MC_CMD_NVRAM_WRITE_IN_WRITE_BUFFER_MAXNUM;
+	else
+		write_max = MC_CMD_NVRAM_WRITE_IN_WRITE_BUFFER_LEN *
+			    MC_CMD_NVRAM_WRITE_IN_WRITE_BUFFER_MAXNUM_MCDI2;
+	chunk = rounddown(write_max, align);
+
+	for (offset = 0, next_update = 0; offset + chunk <= data_size; offset += chunk) {
+		if (offset >= next_update) {
+			devlink_flash_update_status_notify(devlink, "Writing",
+							   NULL, offset,
+							   data_size);
+			next_update += data_size / EFCT_DEVLINK_STATUS_UPDATE_COUNT;
+		}
+
+		rc = efct_mcdi_nvram_write(efct, type, offset, data + offset, chunk);
+		if (rc) {
+			netif_err(efct, hw, efct->net_dev,
+				  "Write failed for NVRAM partition %#x at %#zx-%#zx with error %d\n",
+				  type, offset, offset + chunk - 1, rc);
+			return rc;
+		}
+	}
+
+	/* Round up left over data to satisfy write alignment */
+	if (offset < data_size) {
+		size_t remaining = data_size - offset;
+		u8 *buf;
+
+		if (offset >= next_update)
+			devlink_flash_update_status_notify(devlink, "Writing",
+							   NULL, offset,
+							   data_size);
+
+		chunk = roundup(remaining, align);
+		buf = kmalloc(chunk, GFP_KERNEL);
+		if (!buf)
+			return -ENOMEM;
+
+		memcpy(buf, data + offset, remaining);
+		memset(buf + remaining, 0xFF, chunk - remaining);
+		rc = efct_mcdi_nvram_write(efct, type, offset, buf, chunk);
+		kfree(buf);
+		if (rc) {
+			netif_err(efct, hw, efct->net_dev,
+				  "Write failed for NVRAM partition %#x at %#zx-%#zx with error %d\n",
+				  type, offset, offset + chunk - 1, rc);
+			return rc;
+		}
+	}
+
+	devlink_flash_update_status_notify(devlink, "Writing", NULL, data_size,
+					   data_size);
+
+	return 0;
+}
+
+int efct_reflash_flash_firmware(struct efct_nic *efct, const struct firmware *fw)
+{
+	struct devlink *devlink = efct->efct_dev->devlink;
+	size_t data_size, size, erase_align, write_align;
+	u32 type, data_subtype, subtype;
+	const u8 *data;
+	bool protected;
+	int rc;
+
+	if (!efct_has_cap(efct, BUNDLE_UPDATE)) {
+		netif_err(efct, hw, efct->net_dev,
+			  "NVRAM bundle updates are not supported by the firmware\n");
+		return -EOPNOTSUPP;
+	}
+
+	mutex_lock(&efct->reflash_mutex);
+
+	devlink_flash_update_status_notify(devlink, "Checking update", NULL, 0, 0);
+
+	rc = efct_reflash_parse_firmware_data(fw, &type, &data_subtype, &data,
+					      &data_size);
+	if (rc) {
+		netif_err(efct, drv, efct->net_dev,
+			  "Firmware image validation check failed with error %d\n",
+			  rc);
+		goto out;
+	}
+
+	rc = efct_mcdi_nvram_metadata(efct, type, &subtype, NULL, NULL, 0);
+	if (rc) {
+		netif_err(efct, drv, efct->net_dev,
+			  "Metadata query for NVRAM partition %#x failed with error %d\n",
+			  type, rc);
+		goto out;
+	}
+
+	if (subtype != data_subtype) {
+		netif_err(efct, drv, efct->net_dev,
+			  "Firmware image is not appropriate for this adapter");
+		rc = -EINVAL;
+		goto out;
+	}
+
+	rc = efct_mcdi_nvram_info(efct, type, &size, &erase_align, &write_align,
+				  &protected);
+	if (rc) {
+		netif_err(efct, hw, efct->net_dev,
+			  "Info query for NVRAM partition %#x failed with error %d\n",
+			  type, rc);
+		goto out;
+	}
+
+	if (protected) {
+		netif_err(efct, drv, efct->net_dev,
+			  "NVRAM partition %#x is protected\n", type);
+		rc = -EPERM;
+		goto out;
+	}
+
+	if (write_align == 0) {
+		netif_err(efct, drv, efct->net_dev,
+			  "NVRAM partition %#x is not writable\n", type);
+		rc = -EACCES;
+		goto out;
+	}
+
+	if (erase_align != 0 && size % erase_align) {
+		netif_err(efct, drv, efct->net_dev,
+			  "NVRAM partition %#x has a bad partition table entry and therefore is not erasable\n",
+			  type);
+		rc = -EACCES;
+		goto out;
+	}
+
+	if (data_size > size) {
+		netif_err(efct, drv, efct->net_dev,
+			  "Firmware image is too big for NVRAM partition %#x\n",
+			  type);
+		rc = -EFBIG;
+		goto out;
+	}
+
+	devlink_flash_update_status_notify(devlink, "Starting update", NULL, 0, 0);
+
+	rc = efct_mcdi_nvram_update_start(efct, type);
+	if (rc) {
+		netif_err(efct, hw, efct->net_dev,
+			  "Update start request for NVRAM partition %#x failed with error %d\n",
+			  type, rc);
+		goto out;
+	}
+
+	rc = efct_reflash_erase_partition(efct, devlink, type, size, erase_align);
+	if (rc)
+		goto out_update_finish;
+
+	rc = efct_reflash_write_partition(efct, devlink, type, data, data_size,
+					  write_align);
+	if (rc)
+		goto out_update_finish;
+
+	devlink_flash_update_timeout_notify(devlink, "Finishing update", NULL,
+					    EFCT_DEVLINK_UPDATE_FINISH_TIMEOUT);
+
+out_update_finish:
+	if (rc)
+		/* Don't obscure the return code from an earlier failure */
+		(void)efct_mcdi_nvram_update_finish(efct, type,
+						    EFCT_UPDATE_FINISH_ABORT);
+	else
+		rc = efct_mcdi_nvram_update_finish_polled(efct, type);
+
+out:
+	if (!rc) {
+		devlink_flash_update_status_notify(devlink, "Update complete",
+						   NULL, 0, 0);
+	} else {
+		devlink_flash_update_status_notify(devlink, "Update failed",
+						   NULL, 0, 0);
+	}
+
+	mutex_unlock(&efct->reflash_mutex);
+
+	return rc;
+}
diff --git a/drivers/net/ethernet/amd/efct/efct_reflash.h b/drivers/net/ethernet/amd/efct/efct_reflash.h
new file mode 100644
index 000000000000..d48b6e7a0675
--- /dev/null
+++ b/drivers/net/ethernet/amd/efct/efct_reflash.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0
+ ****************************************************************************
+ * Driver for AMD/Xilinx network controllers and boards
+ * Copyright (C) 2021, Xilinx, Inc.
+ * Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
+ */
+
+#ifndef _EFCT_REFLASH_H
+#define _EFCT_REFLASH_H
+
+#include "efct_driver.h"
+#include <linux/firmware.h>
+
+int efct_reflash_flash_firmware(struct efct_nic *efct, const struct firmware *fw);
+
+#endif  /* _EFCT_REFLASH_H */
-- 
2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C32D687BEC
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 12:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231893AbjBBLOx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 06:14:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232176AbjBBLOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 06:14:47 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2044.outbound.protection.outlook.com [40.107.237.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 780DC87D22;
        Thu,  2 Feb 2023 03:14:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hmUWdnTTI1h5zVBx7QE1TrubPSeKTD4nY6kT7rIMlnmkwwsLg3QfLIYynwlOzbw5w4+WEiB4OtVHx7PPV8WJsnzSGeqmvHZSYeSceb4uHu26yKBem1MedyHnf216/hv6OOLK6XrkFVq6ydBg4k/oLgIgNjndZ+5mubD+RSuEoz8RGeZty823UgMqUfsnhYtEjJwi6Eqxk+CDi51YRuDr0pS9EQ3/cISPJKyKM9ejQeXBPrHhDzHcda/bDAq9ncw65X5jJHbJfGlp+DFwAqmKyye4H2X4PQ7jZ8uWAIPbTuhCgV6Lud56Vm0AIoiQNT8g43woEMPhKZdYx/CFd95YTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yokxIDgtsWOtVxT87JpEs88//UB+RVcD+nCW/vyU0i8=;
 b=nWwT58tFQ/G5CE77j3fZargo1UGjOPdAA1YfI2GGZzBy5PxdODyCXI9f/KIYpCb9lECdjkaZoeOgpQjrfGf7rqi+eo66mGSK63Wa0bHtc7cgEm6I3ZMWJD1gCE+XNR+bBCAlstjrWqob8uRhQltO8Fasl0zgSR7uPxnbO+t2W8appXCpwKK3dIF9z20chH/F1828mvYUNh1fxds+0hCjL0ipHMc0a6l9adp+mKqywHMuz2HwKgCAThu/MYDAH9kSsLPEvwQ99/CrCs/m6SlvEtuec9Tjz1CfC/uu3uIMTBrGIGAYXNOruo3rUSm8ngFSy7cfYMeUKEDJ0Bhr/YrvIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yokxIDgtsWOtVxT87JpEs88//UB+RVcD+nCW/vyU0i8=;
 b=j8Qv7ZXzZEYFZkgnW50LyhtAxzY5hsUaryW8KRXTDxwqPIbvIWF4CgoonHUHnViVDdzGFQTkhwNdFal8Y56E0Yz5f4ARuIlBgGgONSG9MDfyTIoSD+ld/P5CBHWPNrR8UeZDA/GBI5ATXf3GkxawNGn9H8ytT93TDd8y4c0Ud4I=
Received: from DS7PR03CA0131.namprd03.prod.outlook.com (2603:10b6:5:3b4::16)
 by BY5PR12MB4292.namprd12.prod.outlook.com (2603:10b6:a03:212::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.22; Thu, 2 Feb
 2023 11:14:42 +0000
Received: from DM6NAM11FT111.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b4:cafe::b) by DS7PR03CA0131.outlook.office365.com
 (2603:10b6:5:3b4::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25 via Frontend
 Transport; Thu, 2 Feb 2023 11:14:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT111.mail.protection.outlook.com (10.13.173.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6064.27 via Frontend Transport; Thu, 2 Feb 2023 11:14:42 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 2 Feb
 2023 05:14:41 -0600
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Thu, 2 Feb 2023 05:14:39 -0600
From:   <alejandro.lucero-palau@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <ecree.xilinx@gmail.com>, <linux-doc@vger.kernel.org>,
        <corbet@lwn.net>, <jiri@nvidia.com>,
        "Alejandro Lucero" <alejandro.lucero-palau@amd.com>
Subject: [PATCH v5 net-next 2/8] sfc: add devlink info support for ef100
Date:   Thu, 2 Feb 2023 11:14:17 +0000
Message-ID: <20230202111423.56831-3-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230202111423.56831-1-alejandro.lucero-palau@amd.com>
References: <20230202111423.56831-1-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT111:EE_|BY5PR12MB4292:EE_
X-MS-Office365-Filtering-Correlation-Id: cd788b72-faff-49bb-27d9-08db050eaec4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iH8NPAN3MRXcx3qEvZcis7DwrhdMf/GGyK0zii4dL7EfPZ8VD7QKf8P/Bt3ZBx3OxxeSGLD2HPuT1EnoSi950a4MIbdf2aGRmas3Rw++h/YM9o3wQ7q3DxrOY/z82N0xAFeGKsucc5bfr5p3WLoIbs8c8doFtxdh7eo9DQmTR+Ir44vCFVayPPU1P6JFfx0tddq1NsHyqxncSXzfqw8urswhNJJBC9VZtD+xba6BVki6PAjtkPfkTvYzcD3HOo16AiU8W2QCToJAgMBuxEf0Ez+Lg4gr9+5+zsTdhOk9x7UXUkI5NAIZFU9aNwrtM346JgoxVw2KfG/8+dZr620CeeOi/IVOMYY6bO31pouSDGY7/gOmgMSeKjE6AtDHbZoud1dFbUWTwhSpUOeYF8MntZKAfIVPVWS5I9OU3TOXE17hbGJrBv1dKmjxoi833UHrQif+J1ZsnNSbSrdcA2phL7yMa4+0RtptRiV2NEX7u7PUHCf/n0x5cabq4/7ZMf8AQYzv7eXa7uqlME9n0E6lY/X2j/+YihCbyO3T6ngrfU1vTiIQMls6iWf3LecWOFY959MKfEe0w3/viBcjEcRBjMcxcJUA571cEK5q4bf4ygIL2WRrYyjCtNaZ6XHmwfbG/ZvrkuJgA7f4kOgJi9JZRnTD5IfwrGiowBAeln6kxi4SrH7PtD4VbgT2S/VXkFsgFE9ZBHbdRuyRHqNfZp5joleTFpnuO27Ar8tEx0utwTs=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(396003)(136003)(376002)(451199018)(46966006)(36840700001)(40470700004)(81166007)(86362001)(82310400005)(356005)(36756003)(6666004)(83380400001)(82740400003)(1076003)(336012)(36860700001)(186003)(426003)(47076005)(26005)(2616005)(70586007)(6636002)(2876002)(316002)(2906002)(478600001)(110136005)(8676002)(54906003)(40480700001)(30864003)(4326008)(70206006)(7416002)(5660300002)(41300700001)(40460700003)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 11:14:42.2047
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cd788b72-faff-49bb-27d9-08db050eaec4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT111.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4292
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alejandro Lucero <alejandro.lucero-palau@amd.com>

Support for devlink info command.

Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
---
 Documentation/networking/devlink/sfc.rst |  57 +++
 MAINTAINERS                              |   1 +
 drivers/net/ethernet/sfc/efx_devlink.c   | 459 +++++++++++++++++++++++
 drivers/net/ethernet/sfc/efx_devlink.h   |  17 +
 drivers/net/ethernet/sfc/mcdi.c          |  72 ++++
 drivers/net/ethernet/sfc/mcdi.h          |   3 +
 6 files changed, 609 insertions(+)
 create mode 100644 Documentation/networking/devlink/sfc.rst

diff --git a/Documentation/networking/devlink/sfc.rst b/Documentation/networking/devlink/sfc.rst
new file mode 100644
index 000000000000..a8c0eb69f0b6
--- /dev/null
+++ b/Documentation/networking/devlink/sfc.rst
@@ -0,0 +1,57 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===================
+sfc devlink support
+===================
+
+This document describes the devlink features implemented by the ``sfc``
+device driver for the ef100 device.
+
+Info versions
+=============
+
+The ``sfc`` driver reports the following versions
+
+.. list-table:: devlink info versions implemented
+    :widths: 5 5 90
+
+   * - Name
+     - Type
+     - Description
+   * - ``fw.mgmt.suc``
+     - running
+     - For boards where the management function is split between multiple
+       control units, this is the SUC control unit's firmware version.
+   * - ``fw.mgmt.cmc``
+     - running
+    - For boards where the management function is split between multiple
+       control units, this is the CMC control unit's firmware version.
+   * - ``fpga.rev``
+     - running
+     - FPGA design revision.
+   * - ``fpga.app``
+     - running
+     - Datapath programmable logic version.
+   * - ``fw.app``
+     - running
+     - Datapath software/microcode/firmware version.
+   * - ``coproc.boot``
+     - running
+     - SmartNIC application co-processor (APU) first stage boot loader version.
+   * - ``coproc.uboot``
+     - running
+     - SmartNIC application co-processor (APU) co-operating system loader version.
+   * - ``coproc.main``
+     - running
+     - SmartNIC application co-processor (APU) main operating system version.
+   * - ``coproc.recovery``
+     - running
+     - SmartNIC application co-processor (APU) recovery operating system version.
+   * - ``fw.exprom``
+     - running
+     - Expansion ROM version. For boards where the expansion ROM is split between
+       multiple images (e.g. PXE and UEFI), this is the specifically the PXE boot
+       ROM version.
+   * - ``fw.uefi``
+     - running
+    - UEFI driver version (No UNDI support).
diff --git a/MAINTAINERS b/MAINTAINERS
index f82dd8d43c2b..f3ee2845e562 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18919,6 +18919,7 @@ M:	Edward Cree <ecree.xilinx@gmail.com>
 M:	Martin Habets <habetsm.xilinx@gmail.com>
 L:	netdev@vger.kernel.org
 S:	Supported
+F:	Documentation/networking/devlink/sfc.rst
 F:	drivers/net/ethernet/sfc/
 
 SFF/SFP/SFP+ MODULE SUPPORT
diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
index 933e60876a93..ad6be8d09e96 100644
--- a/drivers/net/ethernet/sfc/efx_devlink.c
+++ b/drivers/net/ethernet/sfc/efx_devlink.c
@@ -21,7 +21,466 @@ struct efx_devlink {
 	struct efx_nic *efx;
 };
 
+static int efx_devlink_info_nvram_partition(struct efx_nic *efx,
+					    struct devlink_info_req *req,
+					    unsigned int partition_type,
+					    const char *version_name)
+{
+	char buf[EFX_MAX_VERSION_INFO_LEN];
+	u16 version[4];
+	int rc;
+
+	rc = efx_mcdi_nvram_metadata(efx, partition_type, NULL, version, NULL,
+				     0);
+	if (rc) {
+		netif_err(efx, drv, efx->net_dev, "mcdi nvram %s: failed\n",
+			  version_name);
+		return rc;
+	}
+
+	snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u", version[0],
+		 version[1], version[2], version[3]);
+	devlink_info_version_stored_put(req, version_name, buf);
+
+	return 0;
+}
+
+static int efx_devlink_info_stored_versions(struct efx_nic *efx,
+					    struct devlink_info_req *req)
+{
+	int errors = 0;
+	int rc;
+
+	rc = efx_devlink_info_nvram_partition(efx, req,
+					      NVRAM_PARTITION_TYPE_BUNDLE,
+					      DEVLINK_INFO_VERSION_GENERIC_FW_BUNDLE_ID);
+	if (rc)
+		errors++;
+
+	rc = efx_devlink_info_nvram_partition(efx, req,
+					      NVRAM_PARTITION_TYPE_MC_FIRMWARE,
+					      DEVLINK_INFO_VERSION_GENERIC_FW_MGMT);
+	if (rc)
+		errors++;
+
+	rc = efx_devlink_info_nvram_partition(efx, req,
+					      NVRAM_PARTITION_TYPE_SUC_FIRMWARE,
+					      EFX_DEVLINK_INFO_VERSION_FW_MGMT_SUC);
+	if (rc)
+		errors++;
+
+	rc = efx_devlink_info_nvram_partition(efx, req,
+					      NVRAM_PARTITION_TYPE_EXPANSION_ROM,
+					      EFX_DEVLINK_INFO_VERSION_FW_EXPROM);
+	if (rc)
+		errors++;
+
+	rc = efx_devlink_info_nvram_partition(efx, req,
+					      NVRAM_PARTITION_TYPE_EXPANSION_UEFI,
+					      EFX_DEVLINK_INFO_VERSION_FW_UEFI);
+	if (rc)
+		errors++;
+
+	return errors;
+}
+
+#define EFX_VER_FLAG(_f)	\
+	(MC_CMD_GET_VERSION_V5_OUT_ ## _f ## _PRESENT_LBN)
+
+static void efx_devlink_info_running_v2(struct efx_nic *efx,
+					struct devlink_info_req *req,
+					unsigned int flags, efx_dword_t *outbuf)
+{
+	char buf[EFX_MAX_VERSION_INFO_LEN];
+	union {
+		const __le32 *dwords;
+		const __le16 *words;
+		const char *str;
+	} ver;
+	struct rtc_time build_date;
+	unsigned int build_id;
+	size_t offset;
+	u64 tstamp;
+
+	if (flags & BIT(EFX_VER_FLAG(BOARD_EXT_INFO))) {
+		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%s",
+			 MCDI_PTR(outbuf, GET_VERSION_V2_OUT_BOARD_NAME));
+		devlink_info_version_fixed_put(req,
+					       DEVLINK_INFO_VERSION_GENERIC_BOARD_ID,
+					       buf);
+
+		/* Favour full board version if present (in V5 or later) */
+		if (~flags & BIT(EFX_VER_FLAG(BOARD_VERSION))) {
+			snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u",
+				 MCDI_DWORD(outbuf,
+					    GET_VERSION_V2_OUT_BOARD_REVISION));
+			devlink_info_version_fixed_put(req,
+						       DEVLINK_INFO_VERSION_GENERIC_BOARD_REV,
+						       buf);
+		}
+
+		ver.str = MCDI_PTR(outbuf, GET_VERSION_V2_OUT_BOARD_SERIAL);
+		if (ver.str[0])
+			devlink_info_board_serial_number_put(req, ver.str);
+	}
+
+	if (flags & BIT(EFX_VER_FLAG(FPGA_EXT_INFO))) {
+		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
+						GET_VERSION_V2_OUT_FPGA_VERSION);
+		offset = snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u_%c%u",
+				  le32_to_cpu(ver.dwords[0]),
+				  'A' + le32_to_cpu(ver.dwords[1]),
+				  le32_to_cpu(ver.dwords[2]));
+
+		ver.str = MCDI_PTR(outbuf, GET_VERSION_V2_OUT_FPGA_EXTRA);
+		if (ver.str[0])
+			snprintf(&buf[offset], EFX_MAX_VERSION_INFO_LEN - offset,
+				 " (%s)", ver.str);
+
+		devlink_info_version_running_put(req,
+						 EFX_DEVLINK_INFO_VERSION_FPGA_REV,
+						 buf);
+	}
+
+	if (flags & BIT(EFX_VER_FLAG(CMC_EXT_INFO))) {
+		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
+						GET_VERSION_V2_OUT_CMCFW_VERSION);
+		offset = snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
+				  le32_to_cpu(ver.dwords[0]),
+				  le32_to_cpu(ver.dwords[1]),
+				  le32_to_cpu(ver.dwords[2]),
+				  le32_to_cpu(ver.dwords[3]));
+
+		tstamp = MCDI_QWORD(outbuf,
+				    GET_VERSION_V2_OUT_CMCFW_BUILD_DATE);
+		if (tstamp) {
+			rtc_time64_to_tm(tstamp, &build_date);
+			snprintf(&buf[offset], EFX_MAX_VERSION_INFO_LEN - offset,
+				 " (%ptRd)", &build_date);
+		}
+
+		devlink_info_version_running_put(req,
+						 EFX_DEVLINK_INFO_VERSION_FW_MGMT_CMC,
+						 buf);
+	}
+
+	ver.words = (__le16 *)MCDI_PTR(outbuf, GET_VERSION_V2_OUT_VERSION);
+	offset = snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
+			  le16_to_cpu(ver.words[0]), le16_to_cpu(ver.words[1]),
+			  le16_to_cpu(ver.words[2]), le16_to_cpu(ver.words[3]));
+	if (flags & BIT(EFX_VER_FLAG(MCFW_EXT_INFO))) {
+		build_id = MCDI_DWORD(outbuf, GET_VERSION_V2_OUT_MCFW_BUILD_ID);
+		snprintf(&buf[offset], EFX_MAX_VERSION_INFO_LEN - offset,
+			 " (%x) %s", build_id,
+			 MCDI_PTR(outbuf, GET_VERSION_V2_OUT_MCFW_BUILD_NAME));
+	}
+	devlink_info_version_running_put(req,
+					 DEVLINK_INFO_VERSION_GENERIC_FW_MGMT,
+					 buf);
+
+	if (flags & BIT(EFX_VER_FLAG(SUCFW_EXT_INFO))) {
+		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
+						GET_VERSION_V2_OUT_SUCFW_VERSION);
+		tstamp = MCDI_QWORD(outbuf,
+				    GET_VERSION_V2_OUT_SUCFW_BUILD_DATE);
+		rtc_time64_to_tm(tstamp, &build_date);
+		build_id = MCDI_DWORD(outbuf, GET_VERSION_V2_OUT_SUCFW_CHIP_ID);
+
+		snprintf(buf, EFX_MAX_VERSION_INFO_LEN,
+			 "%u.%u.%u.%u type %x (%ptRd)",
+			 le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
+			 le32_to_cpu(ver.dwords[2]), le32_to_cpu(ver.dwords[3]),
+			 build_id, &build_date);
+
+		devlink_info_version_running_put(req,
+						 EFX_DEVLINK_INFO_VERSION_FW_MGMT_SUC,
+						 buf);
+	}
+}
+
+static void efx_devlink_info_running_v3(struct efx_nic *efx,
+					struct devlink_info_req *req,
+					unsigned int flags, efx_dword_t *outbuf)
+{
+	char buf[EFX_MAX_VERSION_INFO_LEN];
+	union {
+		const __le32 *dwords;
+		const __le16 *words;
+		const char *str;
+	} ver;
+
+	if (flags & BIT(EFX_VER_FLAG(DATAPATH_HW_VERSION))) {
+		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
+						GET_VERSION_V3_OUT_DATAPATH_HW_VERSION);
+
+		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u",
+			 le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
+			 le32_to_cpu(ver.dwords[2]));
+
+		devlink_info_version_running_put(req,
+						 EFX_DEVLINK_INFO_VERSION_DATAPATH_HW,
+						 buf);
+	}
+
+	if (flags & BIT(EFX_VER_FLAG(DATAPATH_FW_VERSION))) {
+		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
+						GET_VERSION_V3_OUT_DATAPATH_FW_VERSION);
+
+		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u",
+			 le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
+			 le32_to_cpu(ver.dwords[2]));
+
+		devlink_info_version_running_put(req,
+						 EFX_DEVLINK_INFO_VERSION_DATAPATH_FW,
+						 buf);
+	}
+}
+
+static void efx_devlink_info_running_v4(struct efx_nic *efx,
+					struct devlink_info_req *req,
+					unsigned int flags, efx_dword_t *outbuf)
+{
+	char buf[EFX_MAX_VERSION_INFO_LEN];
+	union {
+		const __le32 *dwords;
+		const __le16 *words;
+		const char *str;
+	} ver;
+
+	if (flags & BIT(EFX_VER_FLAG(SOC_BOOT_VERSION))) {
+		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
+						GET_VERSION_V4_OUT_SOC_BOOT_VERSION);
+
+		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
+			 le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
+			 le32_to_cpu(ver.dwords[2]),
+			 le32_to_cpu(ver.dwords[3]));
+
+		devlink_info_version_running_put(req,
+						 EFX_DEVLINK_INFO_VERSION_SOC_BOOT,
+						 buf);
+	}
+
+	if (flags & BIT(EFX_VER_FLAG(SOC_UBOOT_VERSION))) {
+		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
+						GET_VERSION_V4_OUT_SOC_UBOOT_VERSION);
+
+		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
+			 le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
+			 le32_to_cpu(ver.dwords[2]),
+			 le32_to_cpu(ver.dwords[3]));
+
+		devlink_info_version_running_put(req,
+						 EFX_DEVLINK_INFO_VERSION_SOC_UBOOT,
+						 buf);
+	}
+
+	if (flags & BIT(EFX_VER_FLAG(SOC_MAIN_ROOTFS_VERSION))) {
+		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
+					GET_VERSION_V4_OUT_SOC_MAIN_ROOTFS_VERSION);
+
+		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
+			 le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
+			 le32_to_cpu(ver.dwords[2]),
+			 le32_to_cpu(ver.dwords[3]));
+
+		devlink_info_version_running_put(req,
+						 EFX_DEVLINK_INFO_VERSION_SOC_MAIN,
+						 buf);
+	}
+
+	if (flags & BIT(EFX_VER_FLAG(SOC_RECOVERY_BUILDROOT_VERSION))) {
+		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
+						GET_VERSION_V4_OUT_SOC_RECOVERY_BUILDROOT_VERSION);
+
+		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
+			 le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
+			 le32_to_cpu(ver.dwords[2]),
+			 le32_to_cpu(ver.dwords[3]));
+
+		devlink_info_version_running_put(req,
+						 EFX_DEVLINK_INFO_VERSION_SOC_RECOVERY,
+						 buf);
+	}
+
+	if (flags & BIT(EFX_VER_FLAG(SUCFW_VERSION)) &&
+	    ~flags & BIT(EFX_VER_FLAG(SUCFW_EXT_INFO))) {
+		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
+						GET_VERSION_V4_OUT_SUCFW_VERSION);
+
+		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
+			 le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
+			 le32_to_cpu(ver.dwords[2]),
+			 le32_to_cpu(ver.dwords[3]));
+
+		devlink_info_version_running_put(req,
+						 EFX_DEVLINK_INFO_VERSION_FW_MGMT_SUC,
+						 buf);
+	}
+}
+
+static void efx_devlink_info_running_v5(struct efx_nic *efx,
+					struct devlink_info_req *req,
+					unsigned int flags, efx_dword_t *outbuf)
+{
+	char buf[EFX_MAX_VERSION_INFO_LEN];
+	union {
+		const __le32 *dwords;
+		const __le16 *words;
+		const char *str;
+	} ver;
+
+	if (flags & BIT(EFX_VER_FLAG(BOARD_VERSION))) {
+		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
+						GET_VERSION_V5_OUT_BOARD_VERSION);
+
+		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
+			 le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
+			 le32_to_cpu(ver.dwords[2]),
+			 le32_to_cpu(ver.dwords[3]));
+
+		devlink_info_version_running_put(req,
+						 DEVLINK_INFO_VERSION_GENERIC_BOARD_REV,
+						 buf);
+	}
+
+	if (flags & BIT(EFX_VER_FLAG(BUNDLE_VERSION))) {
+		ver.dwords = (__le32 *)MCDI_PTR(outbuf,
+						GET_VERSION_V5_OUT_BUNDLE_VERSION);
+
+		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
+			 le32_to_cpu(ver.dwords[0]), le32_to_cpu(ver.dwords[1]),
+			 le32_to_cpu(ver.dwords[2]),
+			 le32_to_cpu(ver.dwords[3]));
+
+		devlink_info_version_running_put(req,
+						 DEVLINK_INFO_VERSION_GENERIC_FW_BUNDLE_ID,
+						 buf);
+	}
+}
+
+static int efx_devlink_info_running_versions(struct efx_nic *efx,
+					     struct devlink_info_req *req)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_VERSION_V5_OUT_LEN);
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_GET_VERSION_EXT_IN_LEN);
+	char buf[EFX_MAX_VERSION_INFO_LEN];
+	union {
+		const __le32 *dwords;
+		const __le16 *words;
+		const char *str;
+	} ver;
+	size_t outlength;
+	unsigned int flags;
+	int rc;
+
+	rc = efx_mcdi_rpc(efx, MC_CMD_GET_VERSION, inbuf, sizeof(inbuf),
+			  outbuf, sizeof(outbuf), &outlength);
+	if (rc || outlength < MC_CMD_GET_VERSION_OUT_LEN) {
+		netif_err(efx, drv, efx->net_dev,
+			  "mcdi MC_CMD_GET_VERSION failed\n");
+		return rc;
+	}
+
+	/* Handle previous output */
+	if (outlength < MC_CMD_GET_VERSION_V2_OUT_LEN) {
+		ver.words = (__le16 *)MCDI_PTR(outbuf,
+					       GET_VERSION_EXT_OUT_VERSION);
+		snprintf(buf, EFX_MAX_VERSION_INFO_LEN, "%u.%u.%u.%u",
+			 le16_to_cpu(ver.words[0]),
+			 le16_to_cpu(ver.words[1]),
+			 le16_to_cpu(ver.words[2]),
+			 le16_to_cpu(ver.words[3]));
+
+		devlink_info_version_running_put(req,
+						 DEVLINK_INFO_VERSION_GENERIC_FW_MGMT,
+						 buf);
+		return 0;
+	}
+
+	/* Handle V2 additions */
+	flags = MCDI_DWORD(outbuf, GET_VERSION_V2_OUT_FLAGS);
+	efx_devlink_info_running_v2(efx, req, flags, outbuf);
+
+	if (outlength < MC_CMD_GET_VERSION_V3_OUT_LEN)
+		return 0;
+
+	/* Handle V3 additions */
+	efx_devlink_info_running_v3(efx, req, flags, outbuf);
+
+	if (outlength < MC_CMD_GET_VERSION_V4_OUT_LEN)
+		return 0;
+
+	/* Handle V4 additions */
+	efx_devlink_info_running_v4(efx, req, flags, outbuf);
+
+	if (outlength < MC_CMD_GET_VERSION_V5_OUT_LEN)
+		return 0;
+
+	/* Handle V5 additions */
+	efx_devlink_info_running_v5(efx, req, flags, outbuf);
+
+	return 0;
+}
+
+#define EFX_MAX_SERIALNUM_LEN	(ETH_ALEN * 2 + 1)
+
+static int efx_devlink_info_board_cfg(struct efx_nic *efx,
+				      struct devlink_info_req *req)
+{
+	char sn[EFX_MAX_SERIALNUM_LEN];
+	u8 mac_address[ETH_ALEN];
+	int rc;
+
+	rc = efx_mcdi_get_board_cfg(efx, (u8 *)mac_address, NULL, NULL);
+	if (!rc) {
+		snprintf(sn, EFX_MAX_SERIALNUM_LEN, "%pm", mac_address);
+		devlink_info_serial_number_put(req, sn);
+	}
+	return rc;
+}
+
+static int efx_devlink_info_get(struct devlink *devlink,
+				struct devlink_info_req *req,
+				struct netlink_ext_ack *extack)
+{
+	struct efx_devlink *devlink_private = devlink_priv(devlink);
+	struct efx_nic *efx = devlink_private->efx;
+	char msg[NETLINK_MAX_FMTMSG_LEN];
+	int errors_reported = 0;
+	int rc;
+
+	/* Several different MCDI commands are used. We report first error
+	 * through extack along with total number of errors. Specific error
+	 * information via system messages.
+	 */
+	rc = efx_devlink_info_board_cfg(efx, req);
+	if (rc) {
+		sprintf(msg, "Getting board info failed");
+		errors_reported++;
+	}
+	rc = efx_devlink_info_stored_versions(efx, req);
+	if (rc) {
+		if (!errors_reported)
+			sprintf(msg, "Getting stored versions failed");
+		errors_reported += rc;
+	}
+	rc = efx_devlink_info_running_versions(efx, req);
+	if (rc) {
+		if (!errors_reported)
+			sprintf(msg, "Getting board info failed");
+		errors_reported++;
+	}
+
+	if (errors_reported)
+		NL_SET_ERR_MSG_FMT(extack,
+				   "%s. %d total errors. Check system messages",
+				   msg, errors_reported);
+	return 0;
+}
+
 static const struct devlink_ops sfc_devlink_ops = {
+	.info_get			= efx_devlink_info_get,
 };
 
 void efx_fini_devlink_lock(struct efx_nic *efx)
diff --git a/drivers/net/ethernet/sfc/efx_devlink.h b/drivers/net/ethernet/sfc/efx_devlink.h
index 8ff85b035e87..a5269361c3e0 100644
--- a/drivers/net/ethernet/sfc/efx_devlink.h
+++ b/drivers/net/ethernet/sfc/efx_devlink.h
@@ -14,6 +14,23 @@
 #include "net_driver.h"
 #include <net/devlink.h>
 
+/* Custom devlink-info version object names for details that do not map to the
+ * generic standardized names.
+ */
+#define EFX_DEVLINK_INFO_VERSION_FW_MGMT_SUC	"fw.mgmt.suc"
+#define EFX_DEVLINK_INFO_VERSION_FW_MGMT_CMC	"fw.mgmt.cmc"
+#define EFX_DEVLINK_INFO_VERSION_FPGA_REV	"fpga.rev"
+#define EFX_DEVLINK_INFO_VERSION_DATAPATH_HW	"fpga.app"
+#define EFX_DEVLINK_INFO_VERSION_DATAPATH_FW	DEVLINK_INFO_VERSION_GENERIC_FW_APP
+#define EFX_DEVLINK_INFO_VERSION_SOC_BOOT	"coproc.boot"
+#define EFX_DEVLINK_INFO_VERSION_SOC_UBOOT	"coproc.uboot"
+#define EFX_DEVLINK_INFO_VERSION_SOC_MAIN	"coproc.main"
+#define EFX_DEVLINK_INFO_VERSION_SOC_RECOVERY	"coproc.recovery"
+#define EFX_DEVLINK_INFO_VERSION_FW_EXPROM	"fw.exprom"
+#define EFX_DEVLINK_INFO_VERSION_FW_UEFI	"fw.uefi"
+
+#define EFX_MAX_VERSION_INFO_LEN	64
+
 int efx_probe_devlink_and_lock(struct efx_nic *efx);
 void efx_probe_devlink_unlock(struct efx_nic *efx);
 void efx_fini_devlink_lock(struct efx_nic *efx);
diff --git a/drivers/net/ethernet/sfc/mcdi.c b/drivers/net/ethernet/sfc/mcdi.c
index af338208eae9..a7f2c31071e8 100644
--- a/drivers/net/ethernet/sfc/mcdi.c
+++ b/drivers/net/ethernet/sfc/mcdi.c
@@ -2175,6 +2175,78 @@ int efx_mcdi_get_privilege_mask(struct efx_nic *efx, u32 *mask)
 	return 0;
 }
 
+int efx_mcdi_nvram_metadata(struct efx_nic *efx, unsigned int type,
+			    u32 *subtype, u16 version[4], char *desc,
+			    size_t descsize)
+{
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_NVRAM_METADATA_IN_LEN);
+	efx_dword_t *outbuf;
+	size_t outlen;
+	u32 flags;
+	int rc;
+
+	outbuf = kzalloc(MC_CMD_NVRAM_METADATA_OUT_LENMAX_MCDI2, GFP_KERNEL);
+	if (!outbuf)
+		return -ENOMEM;
+
+	MCDI_SET_DWORD(inbuf, NVRAM_METADATA_IN_TYPE, type);
+
+	rc = efx_mcdi_rpc_quiet(efx, MC_CMD_NVRAM_METADATA, inbuf,
+				sizeof(inbuf), outbuf,
+				MC_CMD_NVRAM_METADATA_OUT_LENMAX_MCDI2,
+				&outlen);
+	if (rc)
+		goto out_free;
+	if (outlen < MC_CMD_NVRAM_METADATA_OUT_LENMIN) {
+		rc = -EIO;
+		goto out_free;
+	}
+
+	flags = MCDI_DWORD(outbuf, NVRAM_METADATA_OUT_FLAGS);
+
+	if (desc && descsize > 0) {
+		if (flags & BIT(MC_CMD_NVRAM_METADATA_OUT_DESCRIPTION_VALID_LBN)) {
+			if (descsize <=
+			    MC_CMD_NVRAM_METADATA_OUT_DESCRIPTION_NUM(outlen)) {
+				rc = -E2BIG;
+				goto out_free;
+			}
+
+			strncpy(desc,
+				MCDI_PTR(outbuf, NVRAM_METADATA_OUT_DESCRIPTION),
+				MC_CMD_NVRAM_METADATA_OUT_DESCRIPTION_NUM(outlen));
+			desc[MC_CMD_NVRAM_METADATA_OUT_DESCRIPTION_NUM(outlen)] = '\0';
+		} else {
+			desc[0] = '\0';
+		}
+	}
+
+	if (subtype) {
+		if (flags & BIT(MC_CMD_NVRAM_METADATA_OUT_SUBTYPE_VALID_LBN))
+			*subtype = MCDI_DWORD(outbuf, NVRAM_METADATA_OUT_SUBTYPE);
+		else
+			*subtype = 0;
+	}
+
+	if (version) {
+		if (flags & BIT(MC_CMD_NVRAM_METADATA_OUT_VERSION_VALID_LBN)) {
+			version[0] = MCDI_WORD(outbuf, NVRAM_METADATA_OUT_VERSION_W);
+			version[1] = MCDI_WORD(outbuf, NVRAM_METADATA_OUT_VERSION_X);
+			version[2] = MCDI_WORD(outbuf, NVRAM_METADATA_OUT_VERSION_Y);
+			version[3] = MCDI_WORD(outbuf, NVRAM_METADATA_OUT_VERSION_Z);
+		} else {
+			version[0] = 0;
+			version[1] = 0;
+			version[2] = 0;
+			version[3] = 0;
+		}
+	}
+
+out_free:
+	kfree(outbuf);
+	return rc;
+}
+
 #ifdef CONFIG_SFC_MTD
 
 #define EFX_MCDI_NVRAM_LEN_MAX 128
diff --git a/drivers/net/ethernet/sfc/mcdi.h b/drivers/net/ethernet/sfc/mcdi.h
index 7e35fec9da35..5cb202684858 100644
--- a/drivers/net/ethernet/sfc/mcdi.h
+++ b/drivers/net/ethernet/sfc/mcdi.h
@@ -378,6 +378,9 @@ int efx_mcdi_nvram_info(struct efx_nic *efx, unsigned int type,
 			size_t *size_out, size_t *erase_size_out,
 			bool *protected_out);
 int efx_new_mcdi_nvram_test_all(struct efx_nic *efx);
+int efx_mcdi_nvram_metadata(struct efx_nic *efx, unsigned int type,
+			    u32 *subtype, u16 version[4], char *desc,
+			    size_t descsize);
 int efx_mcdi_nvram_test_all(struct efx_nic *efx);
 int efx_mcdi_handle_assertion(struct efx_nic *efx);
 int efx_mcdi_set_id_led(struct efx_nic *efx, enum efx_led_mode mode);
-- 
2.17.1


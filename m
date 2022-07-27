Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55108583267
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 20:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233061AbiG0Sv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 14:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236698AbiG0Su7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 14:50:59 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2040.outbound.protection.outlook.com [40.107.220.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 359B26A482
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 10:47:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UzmmIw8rFkPsiJNJvC9CzxmkmKGcviBEW+PpP60GfoWKTbBLp4hgjd73qIt/NAlV4nR1820DntZmUB98zVogr+xX4dNWScM/nJol+0br8OfXkZliVj/4Hi6uvBEwR3AjF7zAO4g3Ew8DErPWEn++SGcPtdyGivmD7bJAWT/XwH2QNZBtzVzWd9Ls+LRk3o6qGg20SWGaT7Sqd7hy6Y+/LFtz2D87U4QHGr+lwyVG0gSa67vjqB/5GuxFwmsB6Q8L8CdhuaPUMHxmkjyMJOBn/278HvXN3nRW37CUIkZ3InlpiorsD88Crid+70T+Yna2wSEtBkoxoZ2pfPEZkUUT/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cTpqR1vQVoqnscV+oBNnupJ+FuTrEdbhvQYz5t/ji1c=;
 b=PUHAmBpYrCh6fj2Fq4fyPf8MIvi817rCQbHyaBGPZYF6qYsmrelDDUabUrSc8ptSvjqUg5ZSkRBoyxnzpyn3xK9Gx7/rcoKIz3d33KrK2QVQF5toMDlGuTV6uIR1T6x6UUWtPM/zM/yZxDU6Y5v8x0P1QiLHA1G9XypnzIGcN1fSZfSS1VlFL5yfulY2/AZ6u9RAbOVCBz2cMLCbPNv6ApO9uHwmhgyH9WAwBvzedWKBWAPZnKAcqhB41zPBOPuyO0zS/aknE5mMZ/VpScigb+siy1n7T3lxZGt5PTKCECKCC9onJuEqKXTLvPfUYCKLiHlwATugm71i4Wo7uOl/pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cTpqR1vQVoqnscV+oBNnupJ+FuTrEdbhvQYz5t/ji1c=;
 b=msBkyIgvGd9BG/gAraRYzHvow1i4I/sKLsv3DKzF8LURfqJvHPQg8vU212ybEKL4YLyDlcik9QNRQzVhZVCErleviruEo5iJroZ/D7199nGjLs0aZxWyBxakhUdDexUzYKV2P/R0o0v1kyw3xN+nmwJmLnr/EVO4lfUbO0g7wFNCI0YwVCEkNcWxv0JSCQLNkXjsGA2VAqi58nOCFuRy+UMh1I+bdYvOYDiqN83cTgZWr2CAoNFELBj+L12vcpCTStc57MTYiPU0Mnnf4qaaCqsH3fIEz7o3rhzSvFZ7VLbacXM8BqGOr5TS3ZaGgwHkuCc2VYexMOZNL7qrGTueJA==
Received: from MW4PR04CA0318.namprd04.prod.outlook.com (2603:10b6:303:82::23)
 by MN2PR12MB3246.namprd12.prod.outlook.com (2603:10b6:208:af::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Wed, 27 Jul
 2022 17:47:07 +0000
Received: from CO1NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:82:cafe::57) by MW4PR04CA0318.outlook.office365.com
 (2603:10b6:303:82::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19 via Frontend
 Transport; Wed, 27 Jul 2022 17:47:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT044.mail.protection.outlook.com (10.13.175.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5482.10 via Frontend Transport; Wed, 27 Jul 2022 17:47:07 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 27 Jul
 2022 12:47:04 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 27 Jul
 2022 10:47:03 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Wed, 27 Jul 2022 12:47:02 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next v2 10/14] sfc: look up VF's client ID when creating representor
Date:   Wed, 27 Jul 2022 18:46:00 +0100
Message-ID: <3cd59ffc0ca93e9936940aa402eb27584131eca0.1658943677.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1658943677.git.ecree.xilinx@gmail.com>
References: <cover.1658943677.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1bec4442-9f60-4f6b-29e5-08da6ff80638
X-MS-TrafficTypeDiagnostic: MN2PR12MB3246:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DlSDHkrx758rH7Igq78wyEWbXiIkAHmtJYU7T+J4qc/A7PWmIa75abzv7P7F/702paTCP0UFx6B4uezb6YTTFFBQIB2M4Abg88PUksmrkK15V6nWV2Wf+V+4jJkdDJGc+lGYhnr7QVQ8bjqiMvP9FHHfGvfEpZizlxl0r64BJIsEWt1O9Fzp2TeeHVTt+hO61rEqgPBgYEYYYJzIJ7KOEDjIwGaWmogjGBwWZnThjsm+cgrnIK1SefbQEXYTl3Az/90ghuS3S12QCuK9RIqHjuzd0MmOuh6QewwdC+tnW9TsWk18PrsYg9wT2HwZlp5AJEADdxLk+cEuSvNUNCTppChG0ngbwJ3vX27fTUBzZA2eJMY1YXcr5uavk/zUcXIoMhcRUqqk7cTV4C0Jr2cV73cn1cV/hzQVw5ldOP10LVYjT2OLMSG7jo2C14ZVOzydkdG7CKMgCxrEasmVkGFAk+utPJHE/umVZefsxhwGCwIWuJssWcVW7YCRPdm62OQ0RxbWn+nV93bpq+MoH4LCada/0qw0xUncp6Xj9l/Zu2QKhoZ8Sqb6x3dhLjEQBxJ/F8zMt0AdnzcBzfabMmT0oArWUj6M3QUd4lc4RtvJfdN51EYjrjH0/HQ4G7X7yxLs6p4YFAK117dSGYeomvcpTwytU/6G+aj6vAo8xPMF/D1lKPPpThdZ3XUw3JVqfql7bY8rS0LtpRrdl5DVNeKiFIkMLTzWQIr15HJ6iJYFGMsfQuBhN/fSfG/YeOU5FVmEe5R28TMKudFzVJRM5bS8mNps5BYfpcMgR8tou5JpjpHDJuvTGQ0tUeOoUXoFeeV1zK3lI9ffIA5QPHUY14hpVQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(136003)(376002)(396003)(46966006)(40470700004)(36840700001)(478600001)(8936002)(9686003)(82740400003)(40480700001)(26005)(47076005)(83170400001)(81166007)(70206006)(8676002)(54906003)(36860700001)(110136005)(55446002)(2876002)(4326008)(41300700001)(70586007)(36756003)(186003)(42882007)(2906002)(336012)(40460700003)(356005)(5660300002)(82310400005)(316002)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 17:47:07.1544
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bec4442-9f60-4f6b-29e5-08da6ff80638
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3246
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

Firmware gives us a handle which we will later use to administrate the
 VF's virtual MAC configuration.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef100_nic.c | 23 +++++++++++++++++++++++
 drivers/net/ethernet/sfc/ef100_nic.h |  1 +
 drivers/net/ethernet/sfc/ef100_rep.c | 17 +++++++++++++++++
 drivers/net/ethernet/sfc/ef100_rep.h |  2 ++
 4 files changed, 43 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 8061efdaf82c..f79587a2f4ab 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -1098,6 +1098,29 @@ static int ef100_probe_main(struct efx_nic *efx)
 	return rc;
 }
 
+int efx_ef100_lookup_client_id(struct efx_nic *efx, efx_qword_t pciefn, u32 *id)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_CLIENT_HANDLE_OUT_LEN);
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_GET_CLIENT_HANDLE_IN_LEN);
+	u64 pciefn_flat = le64_to_cpu(pciefn.u64[0]);
+	size_t outlen;
+	int rc;
+
+	MCDI_SET_DWORD(inbuf, GET_CLIENT_HANDLE_IN_TYPE,
+		       MC_CMD_GET_CLIENT_HANDLE_IN_TYPE_FUNC);
+	MCDI_SET_QWORD(inbuf, GET_CLIENT_HANDLE_IN_FUNC,
+		       pciefn_flat);
+
+	rc = efx_mcdi_rpc(efx, MC_CMD_GET_CLIENT_HANDLE, inbuf,
+			  sizeof(inbuf), outbuf, sizeof(outbuf), &outlen);
+	if (rc)
+		return rc;
+	if (outlen < sizeof(outbuf))
+		return -EIO;
+	*id = MCDI_DWORD(outbuf, GET_CLIENT_HANDLE_OUT_HANDLE);
+	return 0;
+}
+
 int ef100_probe_netdev_pf(struct efx_nic *efx)
 {
 	struct ef100_nic_data *nic_data = efx->nic_data;
diff --git a/drivers/net/ethernet/sfc/ef100_nic.h b/drivers/net/ethernet/sfc/ef100_nic.h
index 0295933145fa..cf78a5a2b7d6 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.h
+++ b/drivers/net/ethernet/sfc/ef100_nic.h
@@ -17,6 +17,7 @@
 extern const struct efx_nic_type ef100_pf_nic_type;
 extern const struct efx_nic_type ef100_vf_nic_type;
 
+int efx_ef100_lookup_client_id(struct efx_nic *efx, efx_qword_t pciefn, u32 *id);
 int ef100_probe_netdev_pf(struct efx_nic *efx);
 int ef100_probe_vf(struct efx_nic *efx);
 void ef100_remove(struct efx_nic *efx);
diff --git a/drivers/net/ethernet/sfc/ef100_rep.c b/drivers/net/ethernet/sfc/ef100_rep.c
index eac932710c63..3c5f22a6c3b5 100644
--- a/drivers/net/ethernet/sfc/ef100_rep.c
+++ b/drivers/net/ethernet/sfc/ef100_rep.c
@@ -200,6 +200,7 @@ static struct efx_rep *efx_ef100_rep_create_netdev(struct efx_nic *efx,
 static int efx_ef100_configure_rep(struct efx_rep *efv)
 {
 	struct efx_nic *efx = efv->parent;
+	efx_qword_t pciefn;
 	u32 selector;
 	int rc;
 
@@ -214,6 +215,22 @@ static int efx_ef100_configure_rep(struct efx_rep *efv)
 	/* mport label should fit in 16 bits */
 	WARN_ON(efv->mport >> 16);
 
+	/* Construct PCIE_FUNCTION structure for the representee */
+	EFX_POPULATE_QWORD_3(pciefn,
+			     PCIE_FUNCTION_PF, PCIE_FUNCTION_PF_NULL,
+			     PCIE_FUNCTION_VF, efv->idx,
+			     PCIE_FUNCTION_INTF, PCIE_INTERFACE_CALLER);
+	/* look up representee's client ID */
+	rc = efx_ef100_lookup_client_id(efx, pciefn, &efv->clid);
+	if (rc) {
+		efv->clid = CLIENT_HANDLE_NULL;
+		pci_dbg(efx->pci_dev, "Failed to get VF %u client ID, rc %d\n",
+			efv->idx, rc);
+	} else {
+		pci_dbg(efx->pci_dev, "VF %u client ID %#x\n",
+			efv->idx, efv->clid);
+	}
+
 	return efx_tc_configure_default_rule_rep(efv);
 }
 
diff --git a/drivers/net/ethernet/sfc/ef100_rep.h b/drivers/net/ethernet/sfc/ef100_rep.h
index 070f700893c1..0fa6ad6b2c92 100644
--- a/drivers/net/ethernet/sfc/ef100_rep.h
+++ b/drivers/net/ethernet/sfc/ef100_rep.h
@@ -29,6 +29,7 @@ struct efx_rep_sw_stats {
  * @net_dev: representor netdevice
  * @msg_enable: log message enable flags
  * @mport: m-port ID of corresponding VF
+ * @clid: client ID of corresponding VF
  * @idx: VF index
  * @write_index: number of packets enqueued to @rx_list
  * @read_index: number of packets consumed from @rx_list
@@ -45,6 +46,7 @@ struct efx_rep {
 	struct net_device *net_dev;
 	u32 msg_enable;
 	u32 mport;
+	u32 clid;
 	unsigned int idx;
 	unsigned int write_index, read_index;
 	unsigned int rx_pring_size;

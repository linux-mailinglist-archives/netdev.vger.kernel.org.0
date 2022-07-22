Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4337157E426
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 18:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235627AbiGVQGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 12:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235522AbiGVQGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 12:06:42 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2043.outbound.protection.outlook.com [40.107.94.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35F26402D4
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 09:06:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OMg99p68UNSQZ8Au7L5l5JmCYVM9WrC1HYIusSGO06rHUDcDyNnLpNPYYb6t/ebGgKEJYqHTlaCJHVYGwBBhCaWz5/JoTxNygDx+e4c1a0wcZP80Hfbdc3+wqAAmqHA7+9IB2QgbIC1giGMz5E4Hop0zQ/6QtMOx3iZYSVEHAnRMamOEavieq3MabxqoSwfIfsZk/YMVRIoGXps174A8WRpjG03ZV/lp73VmPPCHXLIHZy4yUE1CZJzepTFicCnpPcvscEoi1Eh1cobAKBkvKorBQn6+YPMNpqWJOPfN6L4MQObf5pGx0JTq8BbIP7NEeNb0XmmUU4cPSpC8+BuboQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=95cooFVS0qY9S+Sk+7elZwdC/Da4alCDECDIvBgJ1XY=;
 b=Dk8T+4WoWN5LirurjIgi5QM8zxbOeRQkmVp8tyb2hyy8xhqkzZqLby2DlaLvJa+YTGglZYLPyshyIl7svlIc9bqJiSOV7/obqvWp1weg7xr0SvtfRFC/yB+ZjtBQ8f1xGj7H4HlqJFiZtrcQXFcuAaNOu1CPlzqq0Aph1sibPhkTymWhJtad3Qwd+NTb9F0/N5fisa+6mkvBW6JtY9/tYiPbsQeqQgj9aExCpA8A+ldLlwag7byyv1CDGX5awLoGswP1a3R7cweXcK5AzBlh+ZclVXMv6DjSiqNQCK6NFRb1HCEO/W8pyYspRptGdcXgeObIN98hkU9Xb4tqgw7Ndw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=95cooFVS0qY9S+Sk+7elZwdC/Da4alCDECDIvBgJ1XY=;
 b=GnoC+63D3kGxxPqw0nY2xeV1wVRZsjacrPBRhEClAD2ro3RTjYbW4rWgPe3X/IKeTEOSHAsdnFbzjSMMhferbeDyt3hHjKiPEv7pQ/rH6yoQIVzJ5EQppt/SnNT0N7+FEQp1X6y8EbHAwPoOZBNjYarVSibRu8zEiUBAIssgr128Hg6V15oYWctk9OZrdCTStibgIVKqLpUNreNxyjP/Kuvgj9oGlUvILHnHz7GDka+p0M6SE1Nl16SCbx9aQwoee28OviuxSPvjjOkCj31RbqmuYkch0F51c57Y4rhG1fOPVsB4zgmJXvCv2hFXiugMOHCjXmL50LOrNU2bTs9/RQ==
Received: from DS7PR03CA0237.namprd03.prod.outlook.com (2603:10b6:5:3ba::32)
 by BYAPR12MB2837.namprd12.prod.outlook.com (2603:10b6:a03:68::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.21; Fri, 22 Jul
 2022 16:06:32 +0000
Received: from DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ba:cafe::73) by DS7PR03CA0237.outlook.office365.com
 (2603:10b6:5:3ba::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.24 via Frontend
 Transport; Fri, 22 Jul 2022 16:06:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT011.mail.protection.outlook.com (10.13.172.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5458.17 via Frontend Transport; Fri, 22 Jul 2022 16:06:31 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 22 Jul
 2022 11:06:28 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 22 Jul
 2022 09:06:28 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Fri, 22 Jul 2022 11:06:27 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next 10/14] sfc: look up VF's client ID when creating representor
Date:   Fri, 22 Jul 2022 17:04:19 +0100
Message-ID: <aadb017384b20e23615f01e6e48ab052a3a19585.1658497661.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1658497661.git.ecree.xilinx@gmail.com>
References: <cover.1658497661.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0fcde5a0-63d3-4f07-b759-08da6bfc24cc
X-MS-TrafficTypeDiagnostic: BYAPR12MB2837:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 420Cl8o97k6t/XMNBQEkL1rwptqRwMF93wd9tg2ZoyCnXeaBaJ5+wztorMri2cRuGsHScToRZOwutNXXcQDDa6abkeYs7FEHAEpHsNfjj326M7bYY0C2KfwtqoVDs0DhQhzuLP7s5aLsa/a+TgUt7Uvv+iM4FU+dVMt3vBE/pQt0xy2FlUsTuIudlyn9OMDJyG24B3nov6x91qEFBsz5L+cNNPNvl1JmQfHO0P9wbT3W49Aiyt5Qb8J/9UbDUxCtoJ5bR/NQ9vvTDwO2ShNKjRGqu2kPxzJJ2hFqgGBa7lNjDnq4KFEzSVdzaspPBc6QfMV4CjsyiOCVWIh6rQCmzVFardnrbnNk7asN35JglevjCYQTozp6Nf3HmA4AFOz4rhNxgBYvTWFiAo+qsEDU4Y94110HZkfrJRbyGzXBN1TZ3cfB44mIpIU5jIHxLxjTn+VMXmWaUvX1WUJkJUBPaopM57Bx3t3o66Bl/vYVOvbGmis/mguwCezjYkJ24lgJZoe71ByYsFtClkpA50JP0KA+HLP4VOBLjK0yogGvjr7wfNLaZV+Bl3oXtCJs2NPDg9u3F6fVirZKHskVNdMa0pKHEnSd8IAvpTusippXDQIxFPE/mvLOxw6gyuAdR3N597YorMRf9d/wnfwrBkwoa068ijcSJbxt5Y4HwX7rs4o6ciCBNJhRbTjZth9+nEUoDSTpTe1Vzl5yAzmegx60glLWlN5FWA7I+SVqhlvFFdeNC+YAm5VbWhWPiaYGrVta+icQJktrLnAKi5a5pQdJyaRwfKJANUxstN7YqyQya8f68fhgwxZagkgsXiuso9CNUZ6UtDCjEn2a6dFPiyCnlw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(396003)(136003)(376002)(36840700001)(46966006)(40470700004)(40480700001)(316002)(36756003)(8676002)(478600001)(110136005)(36860700001)(8936002)(26005)(54906003)(47076005)(5660300002)(41300700001)(9686003)(42882007)(336012)(70206006)(6666004)(186003)(55446002)(83380400001)(81166007)(2906002)(2876002)(82310400005)(82740400003)(4326008)(356005)(83170400001)(70586007)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2022 16:06:31.8579
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fcde5a0-63d3-4f07-b759-08da6bfc24cc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2837
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
index 0ae27de314b5..7ca4e9769455 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -1092,6 +1092,29 @@ static int ef100_probe_main(struct efx_nic *efx)
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

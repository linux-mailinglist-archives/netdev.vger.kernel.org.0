Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E88825FD761
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 11:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbiJMJ4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 05:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiJMJ4G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 05:56:06 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2084.outbound.protection.outlook.com [40.107.244.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DAF4118774
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 02:56:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iPb9WpsExg9txwItgs+v/q6MQKrtPJDLvkc+YCFa+6+WKCT0WIVDjdtb3FOQTppQRNWHt3+BInu095WRANZjkTa4d/ckPrPmXmtvrlHc7SZXV2IlLNXFsLFNMIVUyWv6Ph6BXPSM1jaf04s4ERMJoGo4HwmG2x4f8y+q+U0wl+azwLWWNW/yL1Ac7QDblfsZkeiLboL+b4XzhKqquC9Zq51ap/x6WQKFSIT/aUVuEPP0TZVBL5vks0jrgnHThEfjZDL9HiBXhzrGMRKhioIm/gRv2JrvUoCejPzZy7bbtHrXAVJPWKNe84kfIaU3m/wuWqKV5w5XmmD3eKm+ZbqX5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DImmRowV71sAgKidQVbYhVueBTqDaAfwHdBZ+6PeA4s=;
 b=STf8dhER23uuy5Hoerew2fvRdu7RM0d67B8Z557NTYn/t3HXmuDFCTbsNkC0y2GwbKUTAFkXTBHxz9/zLERdo5FLfCeGLVlz67Ll2znl9+bI0P1UOVuPyYKVc2F1s9orpP+cn9Mooww8bMLz3xPs1mNht7XU8YIbi+b7+SBoGOku1W62cme5nvQhFC2PBJLcvHmm0Yi86X9SM3bcp593Q+T0QAmGVWf24eVqjNIMUsHsMCfVRfzLBu868Kbl41FVBOsePTcMiHpLl38Mxe76JpaBp1qxOTIOb8vuZRB5wxkviuOerT3GLpTM2b+TNkYWp3tw9uQYFAdUSt1Ji6tb4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DImmRowV71sAgKidQVbYhVueBTqDaAfwHdBZ+6PeA4s=;
 b=lJ7g1eU6X33lMYt5gfzQB470dDjI0XW1Jw0dcbMTcqRqDIlonWNLRPQUY+tLp/urHuFGmkPkCEiEPVE4rHSKyQMvxO85PW1hXhvs5E3FYV1qPwBpWtf4lxiqniriOsIODvuW3v+paS3lAAvA0TelCOUTt3bfz9m+vgCefCkPOLU=
Received: from MW4PR03CA0075.namprd03.prod.outlook.com (2603:10b6:303:b6::20)
 by PH7PR12MB7116.namprd12.prod.outlook.com (2603:10b6:510:1ef::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.22; Thu, 13 Oct
 2022 09:56:02 +0000
Received: from CO1NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b6:cafe::4c) by MW4PR03CA0075.outlook.office365.com
 (2603:10b6:303:b6::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.22 via Frontend
 Transport; Thu, 13 Oct 2022 09:56:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT068.mail.protection.outlook.com (10.13.175.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5723.20 via Frontend Transport; Thu, 13 Oct 2022 09:56:02 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 13 Oct
 2022 04:56:00 -0500
Received: from xcbjco41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Thu, 13 Oct 2022 04:55:59 -0500
From:   Jonathan Cooper <jonathan.s.cooper@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net] sfc: Change VF mac via PF as first preference if available.
Date:   Thu, 13 Oct 2022 10:55:53 +0100
Message-ID: <20221013095553.52957-1-jonathan.s.cooper@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT068:EE_|PH7PR12MB7116:EE_
X-MS-Office365-Filtering-Correlation-Id: c5ee7e84-5347-4b7f-4cb0-08daad01231b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CqOtWEkb3k6oE8nHYNvgmflCbC6a+TUUu7z2/xX7nECEz3EUAdFTBDcS3LI0/i6IqV2WwvAeIhVE4iQAILAg45FvR/kg99+gM2DTJZT5ryK7JEc+e2ZcIDzT81EWoxRn51Xx52wqwVDNNiJhdCGuGGENgNrqP5ECUaW8MsH0KZSdqeQWWkUGFpACvmaXbYr6+IzOUAxnIO56i62RBeN40zXvzlfSwr4jXbr8uBEmwyEkOGoxNJhPV8fxUBcn48qucs1Cw+Q1cp2G1hjXetEb+k2b3ivT+dOwQx2XEBmF8wXiO4ZPDwEqArnP0mhCql57R7OC6CGjgFdR2gZxX+OwCLgA+kmoq7jOc3oZ4xf2IW6CJjbZngpDzLCob4wzhIM7hpjPlEpmDj/IXs5WR2OIERV/TARGoCisdDRmzLcQm6+mOiv6gkobkNBk2Xmf1UWlfR4BgKutalVHny/R0KM5zQnIqEBlvkRoArebKMwjq86YN89phjTlKB7OMcIpI1YYlWX46VXVTWQIlkyyL74RGV2+KiRdZOqsGkAi1/6GCc5VHXS/G09WI/rqqxDlAkAzkgkPlEEvYUCUshPNpYJta4o66BfAcHpRzxK+UNLvnxtblP95S+6IJPWae0Nhuhfst6jaX79TUtdlpeiYuCyvZSGHdAzDPOLLXPeAdkCBvY35rgYxrqjhwhzw58dacT1tEkRqR4bOYhs28/lfR/hbEbraWR39dbhkjzv+Gp9HCNjGemppCk/tJ5KU00nTkOfPGXX5LlrQdHzpsMSYpov9z5kdZPaBQCFJVfOOduxKTgFvzSwIY+OnWWOIurVKJLLH
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(346002)(396003)(136003)(451199015)(36840700001)(46966006)(40470700004)(6636002)(316002)(110136005)(2906002)(8936002)(478600001)(54906003)(356005)(2616005)(36756003)(40480700001)(82310400005)(103116003)(86362001)(40460700003)(8676002)(83380400001)(4326008)(70206006)(5660300002)(41300700001)(70586007)(6666004)(26005)(1076003)(47076005)(426003)(82740400003)(36860700001)(336012)(186003)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2022 09:56:02.0192
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c5ee7e84-5347-4b7f-4cb0-08daad01231b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7116
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changing a VF's mac address through the VF (rather than via the PF)
fails with EPERM because the latter part of efx_ef10_set_mac_address
attempts to change the vport mac address list as the VF.
Even with this fixed it still fails with EBUSY because the vadaptor
is still assigned on the VF - the vadaptor reassignment must be within
a section where the VF has torn down its state.

A major reason this has broken is because we have two functions that
ostensibly do the same thing - have a PF and VF cooperate to change a
VF mac address. Rather than do this, if we are changing the mac of a VF
that has a link to the PF in the same VM then simply call
sriov_set_vf_mac instead, which is a proven working function that does
that.

If there is no PF available, or that fails non-fatally, then attempt to
change the VF's mac address as we would a PF, without updating the PF's
data.

Test case:
Create a VF:
  echo 1 > /sys/class/net/<if>/device/sriov_numvfs
Set the mac address of the VF directly:
  ip link set <vf> addr 00:11:22:33:44:55
Set the MAC address of the VF via the PF:
  ip link set <pf> vf 0 mac 00:11:22:33:44:66
Without this patch the last command will fail with ENOENT.

Signed-off-by: Jonathan Cooper <jonathan.s.cooper@amd.com>
Reported-by: Íñigo Huguet <ihuguet@redhat.com>
Fixes: 910c8789a777 ("set the MAC address using MC_CMD_VADAPTOR_SET_MAC")
---
 drivers/net/ethernet/sfc/ef10.c | 58 ++++++++++++++-------------------
 1 file changed, 24 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index d1e1aa19a68e..7022fb2005a2 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -3277,6 +3277,30 @@ static int efx_ef10_set_mac_address(struct efx_nic *efx)
 	bool was_enabled = efx->port_enabled;
 	int rc;
 
+#ifdef CONFIG_SFC_SRIOV
+	/* If this function is a VF and we have access to the parent PF,
+	 * then use the PF control path to attempt to change the VF MAC address.
+	 */
+	if (efx->pci_dev->is_virtfn && efx->pci_dev->physfn) {
+		struct efx_nic *efx_pf = pci_get_drvdata(efx->pci_dev->physfn);
+		struct efx_ef10_nic_data *nic_data = efx->nic_data;
+		u8 mac[ETH_ALEN];
+
+		/* net_dev->dev_addr can be zeroed by efx_net_stop in
+		 * efx_ef10_sriov_set_vf_mac, so pass in a copy.
+		 */
+		ether_addr_copy(mac, efx->net_dev->dev_addr);
+
+		rc = efx_ef10_sriov_set_vf_mac(efx_pf, nic_data->vf_index, mac);
+		if (!rc)
+			return 0;
+
+		netif_dbg(efx, drv, efx->net_dev,
+			  "Updating VF mac via PF failed (%d), setting directly\n",
+			  rc);
+	}
+#endif
+
 	efx_device_detach_sync(efx);
 	efx_net_stop(efx->net_dev);
 
@@ -3297,40 +3321,6 @@ static int efx_ef10_set_mac_address(struct efx_nic *efx)
 		efx_net_open(efx->net_dev);
 	efx_device_attach_if_not_resetting(efx);
 
-#ifdef CONFIG_SFC_SRIOV
-	if (efx->pci_dev->is_virtfn && efx->pci_dev->physfn) {
-		struct efx_ef10_nic_data *nic_data = efx->nic_data;
-		struct pci_dev *pci_dev_pf = efx->pci_dev->physfn;
-
-		if (rc == -EPERM) {
-			struct efx_nic *efx_pf;
-
-			/* Switch to PF and change MAC address on vport */
-			efx_pf = pci_get_drvdata(pci_dev_pf);
-
-			rc = efx_ef10_sriov_set_vf_mac(efx_pf,
-						       nic_data->vf_index,
-						       efx->net_dev->dev_addr);
-		} else if (!rc) {
-			struct efx_nic *efx_pf = pci_get_drvdata(pci_dev_pf);
-			struct efx_ef10_nic_data *nic_data = efx_pf->nic_data;
-			unsigned int i;
-
-			/* MAC address successfully changed by VF (with MAC
-			 * spoofing) so update the parent PF if possible.
-			 */
-			for (i = 0; i < efx_pf->vf_count; ++i) {
-				struct ef10_vf *vf = nic_data->vf + i;
-
-				if (vf->efx == efx) {
-					ether_addr_copy(vf->mac,
-							efx->net_dev->dev_addr);
-					return 0;
-				}
-			}
-		}
-	} else
-#endif
 	if (rc == -EPERM) {
 		netif_err(efx, drv, efx->net_dev,
 			  "Cannot change MAC address; use sfboot to enable"
-- 
2.17.1


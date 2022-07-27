Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C689D58325F
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 20:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233314AbiG0SvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 14:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234589AbiG0Suw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 14:50:52 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2089.outbound.protection.outlook.com [40.107.244.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 152FD4D4C1
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 10:47:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SP3PWAa/4xYBSr9WGa+qg0XLWt3L3bdl8veAhFGFyCa3DdtkkUieonm6PX8w5/0HSkDeMg+BY8fEnefOrCjf7owFFftiC8bkbst8HeiXDWaIh7nMmt73ssHkDtDIYK4cPe/Cg/CJWbdaRg1UjAA7PoHRfqDR15DMtKrg5WaGiSmDKVZUD64JLF1E/B6KLpQK7Ttf0bmGah4UbHzj4y3u1Z0iX8TuminLsITI/u8nCWCVtIMtzbEsiUrsBm+yUnJHUeoUTRXRlK80YRhJ2Su/Cqcv8imLwIb9VEWPV1kg7czxM+QpaVCDPgz6OmNIBrQ+l5FucjHm2SCP3kqRsL7b2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZsxzpVA0evyMd+LHcvf0PtSRKmgHQWQFg5kaQMjSEfA=;
 b=HIWZfWuWPi1ElfWErR0V0LniRD+aV1JSD9wiSlrQBSsVeHJf8XPp5hqxJhpd5uW7m8jM3YGF1bQMQsmgls+N0IM5AXvLJ5GGvq+rJnm8xIHXDoISd5E24pXqNsdwelUbi5GgK6aCi64fBaPHQXtghRWVa+7XVXnwQirc6YRdQKXXQXVsGsBNkRirreOVDv/BNtpafLynSKchbC2KvuySMIrQsZJ4WrnnKPdf3DlzX5Ds13PJ1DYasiQJg0bWXYjC+XRx/1MLfvG4O0j0C1DvljW5vWPPkVBAJ719JMPiQkDlsVol1UnS+QJoRVCHK7UvUKteyvncqIM16TGR12MsLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZsxzpVA0evyMd+LHcvf0PtSRKmgHQWQFg5kaQMjSEfA=;
 b=d/VgYTyAXyZkzw/WSE6vXf4OUvDetYXDBASMpO6CBGo25jm9zpVn1Yn+JZJZ3AHZqgeO36iCcv6CFpvZxgdaMYdHAY03G4fq1SwfVDRBpa/yN+8Ws6C7Fs0peW5BPGkBfnrRdH63Vw1N249h6Mx+Y0X9TA4UHmyl29tjCwD9OeU1iHiDcAg1bLj0xmhD2V0CF0pWMpm2BXIyx7KUJUbxwRCbTYEawyeTPYTwcRthsZTLsQ7Fc+LJpE5SUDbOlAtZWorxRewXsm9CONDHvNy8YI2wY/pTtd3AwnjBYh5qRJw4cGQdGiuGx4YYWqYHY6WtljdETlx6IziulCXSb2ADHw==
Received: from MW4PR04CA0317.namprd04.prod.outlook.com (2603:10b6:303:82::22)
 by CY4PR12MB1461.namprd12.prod.outlook.com (2603:10b6:910:f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.20; Wed, 27 Jul
 2022 17:47:05 +0000
Received: from CO1NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:82:cafe::65) by MW4PR04CA0317.outlook.office365.com
 (2603:10b6:303:82::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.10 via Frontend
 Transport; Wed, 27 Jul 2022 17:47:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT044.mail.protection.outlook.com (10.13.175.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5482.10 via Frontend Transport; Wed, 27 Jul 2022 17:47:04 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 27 Jul
 2022 12:46:58 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Wed, 27 Jul 2022 12:46:57 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next v2 06/14] sfc: receive packets from EF100 VFs into representors
Date:   Wed, 27 Jul 2022 18:45:56 +0100
Message-ID: <11428650a4f0a3f23336b51ea60f0dd677125f88.1658943677.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1658943677.git.ecree.xilinx@gmail.com>
References: <cover.1658943677.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 84418f32-37a9-4e10-52eb-08da6ff804d7
X-MS-TrafficTypeDiagnostic: CY4PR12MB1461:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vPrGg96zdJz2dKmzshqtWNOKdNGerjXRKOiK/0rpIWf08psCGnoWTcYlICB8UByEn2UbkBMP8BWoyAVUCGo1yTf414YTBVFTIGwWUhi9zyblsPaTqvuNT3NXBM1Nbdmf7fTa5rxxu2Hvs3ohe9vVPCUF+RTmgGxSZn3NMtxc6jqAXvFuy+7lP2I/bpy76RX90PLb6ujaxRWqKSk90HbTegIsQAc+gwcNTDrlqcpxP56WxUnq2NdyrycjazSgH25jrIUQFxsCX/sAqsSqHcsiDl9rl5UZbTq4trtz1DPFhM/g25B59G1YFOk/9OLKLXSC01099r9L9CC7ixjAdYi2W8O5xaoUZhVocEqI7vV129FSkPn2DQDCDGeBV1i5eSr8fXypJ9lER+dYyGBX5LYIEMNy8MkIxNfiY9h/uBGo5XuBIkSCihhWnwp1Vj1RnEHVGmsbOBMntwXO6UZmetGoMf0ilO3KgILgjccgHP1msKir8M9TFexjJqbUtfwjcoDy9idFyRfGog+2lIVhHSnLUWg1RnPEDVRUHbfmwiMj/0rQ4T6iNNoGsGDSVVvCXNsOnZX55zGe4ONF1PG3EhziAGVW6GeaNA2Jnq+chOLYzEnnyvEpG2jAoMFaHpm74U4NwyBNYbEA5ZzWfl7koYrJmuP0DBlhlXc+UkPF28V+KKhL6b9AVC6TZ3PeOjNYLgJrZvpCYLAogYovm5d23ezKa6rXYvc0c86fAOGAvtqUtIeTbKL9/j1UrQRp5OQ1jh+I/sWdq8d5twnXTeA3618ZFKJt0D6D1SUZUFNxakRhj97wS9jObE8IZYkKfm2iHskq9kt/gMuKxowNbAiEPpOFuw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(396003)(346002)(39860400002)(36840700001)(46966006)(40470700004)(36860700001)(8936002)(83170400001)(36756003)(9686003)(316002)(478600001)(54906003)(82740400003)(41300700001)(356005)(26005)(42882007)(40460700003)(5660300002)(186003)(110136005)(55446002)(2876002)(336012)(70206006)(4326008)(70586007)(82310400005)(8676002)(47076005)(2906002)(81166007)(40480700001)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 17:47:04.8264
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 84418f32-37a9-4e10-52eb-08da6ff804d7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1461
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

If the source m-port of a packet in __ef100_rx_packet() is a VF,
 hand off the packet to the corresponding representor with
 efx_ef100_rep_rx_packet().

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef100_rep.c | 19 +++++++++++++++++++
 drivers/net/ethernet/sfc/ef100_rep.h |  5 +++++
 drivers/net/ethernet/sfc/ef100_rx.c  | 18 ++++++++++++++++++
 3 files changed, 42 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_rep.c b/drivers/net/ethernet/sfc/ef100_rep.c
index e6c6e9e764b2..c0bc12b9e348 100644
--- a/drivers/net/ethernet/sfc/ef100_rep.c
+++ b/drivers/net/ethernet/sfc/ef100_rep.c
@@ -224,6 +224,7 @@ static void efx_ef100_rep_destroy_netdev(struct efx_rep *efv)
 	list_del(&efv->list);
 	spin_unlock_bh(&efx->vf_reps_lock);
 	rtnl_unlock();
+	synchronize_rcu();
 	free_netdev(efv->net_dev);
 }
 
@@ -375,3 +376,21 @@ void efx_ef100_rep_rx_packet(struct efx_rep *efv, struct efx_rx_buffer *rx_buf)
 	if (primed)
 		napi_schedule(&efv->napi);
 }
+
+struct efx_rep *efx_ef100_find_rep_by_mport(struct efx_nic *efx, u16 mport)
+{
+	struct efx_rep *efv, *out = NULL;
+
+	/* spinlock guards against list mutation while we're walking it;
+	 * but caller must also hold rcu_read_lock() to ensure the netdev
+	 * isn't freed after we drop the spinlock.
+	 */
+	spin_lock_bh(&efx->vf_reps_lock);
+	list_for_each_entry(efv, &efx->vf_reps, list)
+		if (efv->mport == mport) {
+			out = efv;
+			break;
+		}
+	spin_unlock_bh(&efx->vf_reps_lock);
+	return out;
+}
diff --git a/drivers/net/ethernet/sfc/ef100_rep.h b/drivers/net/ethernet/sfc/ef100_rep.h
index 7d2f15cee8d1..f3787133f793 100644
--- a/drivers/net/ethernet/sfc/ef100_rep.h
+++ b/drivers/net/ethernet/sfc/ef100_rep.h
@@ -58,4 +58,9 @@ void efx_ef100_vfrep_destroy(struct efx_nic *efx, struct efx_rep *efv);
 void efx_ef100_fini_vfreps(struct efx_nic *efx);
 
 void efx_ef100_rep_rx_packet(struct efx_rep *efv, struct efx_rx_buffer *rx_buf);
+/* Returns the representor corresponding to a VF m-port, or NULL
+ * @mport is an m-port label, *not* an m-port ID!
+ * Caller must hold rcu_read_lock().
+ */
+struct efx_rep *efx_ef100_find_rep_by_mport(struct efx_nic *efx, u16 mport);
 #endif /* EF100_REP_H */
diff --git a/drivers/net/ethernet/sfc/ef100_rx.c b/drivers/net/ethernet/sfc/ef100_rx.c
index b8da9e3b7bf2..65bbe37753e6 100644
--- a/drivers/net/ethernet/sfc/ef100_rx.c
+++ b/drivers/net/ethernet/sfc/ef100_rx.c
@@ -85,6 +85,24 @@ void __ef100_rx_packet(struct efx_channel *channel)
 	nic_data = efx->nic_data;
 
 	if (nic_data->have_mport && ing_port != nic_data->base_mport) {
+#ifdef CONFIG_SFC_SRIOV
+		struct efx_rep *efv;
+
+		rcu_read_lock();
+		efv = efx_ef100_find_rep_by_mport(efx, ing_port);
+		if (efv) {
+			if (efv->net_dev->flags & IFF_UP)
+				efx_ef100_rep_rx_packet(efv, rx_buf);
+			rcu_read_unlock();
+			/* Representor Rx doesn't care about PF Rx buffer
+			 * ownership, it just makes a copy. So, we are done
+			 * with the Rx buffer from PF point of view and should
+			 * free it.
+			 */
+			goto free_rx_buffer;
+		}
+		rcu_read_unlock();
+#endif
 		if (net_ratelimit())
 			netif_warn(efx, drv, efx->net_dev,
 				   "Unrecognised ing_port %04x (base %04x), dropping\n",

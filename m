Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D32B9584650
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 21:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbiG1S7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 14:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231693AbiG1S6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 14:58:49 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2047.outbound.protection.outlook.com [40.107.212.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8845376471
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 11:58:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UJgoCQIZTS9CIbiB7slbejIwEDa/pGaNJk0x7lHeIuxaLEv2cZw36C6A9eRGNfGgR8xGqa0C0pZdZtbRlJvlWnyQGvV3Mi3vLfC/P9iUq+v76iglp1h5qNzKSCOnpDtdN09JHRnZl5pObuBRHJYJPEkNhMmHFKln51ywbdmYj205iAddguGCNFBfQle2A1k0HuKVyVZli3YGzuxF6oguADpuVYOa1EBx9q+R52EOCxHoAuCMpsKq5+DCH2qiRDfYYMm/+5/102hcv6wRgOW5tCC9TNEUKxrVBusIFS3/HA88yGK+BZwwg4cAILQbezkhG1AW0oRCcLkEw7Z119gAkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZsxzpVA0evyMd+LHcvf0PtSRKmgHQWQFg5kaQMjSEfA=;
 b=OCx2sTA3QROcbkePl+v1tsbhtqxSdLES/UHkHSy8qufz0kZyTFrS8QSqHFRSdeL6IP5UPHyBXWQoTujb5AONU6hEdVOY4HqjuCNLCeDmSbNvJcVtZvHJzvvzX8xqaRfbQkmMPLG9lruJC1NEIiMDmATouypUSVFy6tLlLnyolzv2c34dSuj+98M26eAWnsSJD7jwFmax3AcHl4/CW7Anc2+7x/aEjoimsDgV0Ca7un64jNttq2wHKrxz11e2VgsuB53OS5JyFuKQKsZFKKpc5MIZ9/gq202QjLyYjkZg+XxgJR7SYK4kVAz+EA5Qoi2xz+I0tJgIN3AxpM9dQusoDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZsxzpVA0evyMd+LHcvf0PtSRKmgHQWQFg5kaQMjSEfA=;
 b=rzZPSUTFBdsLf1LDH6AMXWqN04FMpSoKPcpATjE9peZhzdHRTfkQAIxnqhyIrdusRERrclOQG0wGhpYcOog+xpATMg8noMwYYQ/kY1RCP8ScMf0bH1eKSmVs46ydEBEaiQ6fGou0e84xOuWGTUKrzHLmBCcSQDv0M+Szq8M/kSJALhtsIeRYA/pDWp+cm7lnGglktX5pqHPK2fbWEIvWv9ACGpgC3Umd2HzDYwwWoHmo//210C843A51jKNoz58zYiPy3elmyQ7miinDFOowHalRGTPgFi/GC/PlKWmPOQJbZAO+08HL7uyjIbYK8Lho+59FpJbDI6kGy21t6kHvew==
Received: from BN8PR15CA0048.namprd15.prod.outlook.com (2603:10b6:408:80::25)
 by PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Thu, 28 Jul
 2022 18:58:46 +0000
Received: from BN8NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:80:cafe::34) by BN8PR15CA0048.outlook.office365.com
 (2603:10b6:408:80::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.23 via Frontend
 Transport; Thu, 28 Jul 2022 18:58:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT054.mail.protection.outlook.com (10.13.177.102) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5482.10 via Frontend Transport; Thu, 28 Jul 2022 18:58:45 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 28 Jul
 2022 13:58:44 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 28 Jul
 2022 11:58:44 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Thu, 28 Jul 2022 13:58:43 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next v3 06/10] sfc: receive packets from EF100 VFs into representors
Date:   Thu, 28 Jul 2022 19:57:48 +0100
Message-ID: <af1aebe0593de86f04b085507d66901ebc1fe9a8.1659034549.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1659034549.git.ecree.xilinx@gmail.com>
References: <cover.1659034549.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b375b239-4334-415e-d42d-08da70cb328d
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mlQpvH/AfDTcuFEN3AzeXl5ymamQq431y9zZbgIJ+VPH17PjNxMfJIu6+aP2GFKmpLWP5yeTg7cVxj5JVRr5LAmJuyhg5HlMDT8BQw3Lzw/dJnEH68t384jvULEJJEE1OYbotz6uJHb3RsKFIAp1j2aKvEebmtv1ky2yzwAc0v4uDi0chsfjrpdUoIwzurmjPbi8yNkTGtX0QhcMwaTxfeP2UZCmfykvMu1OHiemVkGAlpZXUO8I1iQXz8jHsp9/OHUYf+9v8MDDTXiPvZDXPW3MzgPF6XZuixR5/GPkVynEJXVzymTBlg4Rq9DIbveUg6wI6IJH6G9cOfRYxyU1aqYPlZRZV7IhSdYKyYNVKIgpKeeYAeNA8byP7IIJ5v1v/7Rbr8sWvanIS5UKVkyEjwTxdZljWHVggWcQJyMl4eErht703CRQBy//g+PEujzbGPzyCWl6osRsJx4qULBh5xRwnqy8PwieylcNHRxbZ3Thh3Mt4dn7l1OAgs7ju6dx30K7FLgp2QtapvIeMQ81x8Pru7yMD7Z3/XbTDpcmYCPHZwsAm2G/cf6mSq6R8DxLLwL2x0/os0YrkIzT7N1zJVTjEv+r98FTm2eIY0GRwDiOXc1wD4LxpXPO7EfSUbeeeUI58VAEiDMovF2BR8ZTLMLJeDBT76lHP2xOoVgOzeFiw2j1uUgr1Vsy+e9UVg/A+eu4rq5cFAy0gg1OP0oy3OhaHoJn1zXS+vLThqwMMw1g8UuF13MspyYxVxEx5N+Ci/hHrJkUTQQsRcf+dw/M3UfFbbAI0cMmV6Vx59AjDHgXwCD/DSv0J+L7WUXv3tZT+LWlej0wa6Y28youWbzfnA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(376002)(136003)(396003)(40470700004)(36840700001)(46966006)(336012)(82740400003)(70206006)(2876002)(478600001)(26005)(70586007)(4326008)(47076005)(40460700003)(186003)(8676002)(42882007)(8936002)(2906002)(356005)(54906003)(81166007)(9686003)(83170400001)(5660300002)(40480700001)(83380400001)(82310400005)(41300700001)(110136005)(36860700001)(316002)(36756003)(55446002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 18:58:45.4549
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b375b239-4334-415e-d42d-08da70cb328d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5757
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

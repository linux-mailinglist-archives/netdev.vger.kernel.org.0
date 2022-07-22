Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B78357E417
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 18:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235401AbiGVQGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 12:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235462AbiGVQGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 12:06:33 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2040.outbound.protection.outlook.com [40.107.220.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B63FC65D7B
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 09:06:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ImotXCpZzW5AHdwCRD5iPp2kPNK7kZUnbreXjjLT/5h6OA0jRTx6DPyiRuyR+r11whHvwj+ffx/tmSN1/8dSn0mK+6qnRc9cdmLAmm/bWkgbeCjKIE9JxvXckzj5VAzS6EZ2i/5T3mZTfizBqNwAjiP+wVVb2ggobgXxJ3Yt3xuBaprunMaPTgsJEn/Zve9UOzjI4AmCdDCaJ0jFRChiYih+Uic8pGoyfQXYDSs/huAuQWVPjRlJ+e7vGEY1VKyIC9o5Gjldn6QffO56yHaRn6OI1Jiy22ZT1Ui3xw2IGyl+HyQGpI2FlyBrhwk9w3ceWJiBzgOJBmPsKw0q73ZA0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ykAFBtEJJ4mY+6wZ9Djqt9+VQoa3IB5NvErk1/f7Ii8=;
 b=VA69DWmMje6DT4QJe0pwuhUsBqvPPCV5iko7YOs3Oh3k8pzoUzjuhwctTmD5HabJRsBtjx+eKNhEjjpIVoENfPTz+nZY8gWlf60Pd/uUaxDsh1/vw5zwPa7ikbDv8vRKp35pzf364djEgSzdi/FHAz7fSoK903FkXtvUVnepF/apMs1+X/VT2e2/sVKL4YQI981AyDQQtZiw8qh3UHXo/zB3z74CgYmuUbRZ19GKOCZPFvN45w9nRN19yE9bP0A2CPxTeptWIDDRI3zgr2BmMoRRL9TeNhPSwl9xidgumysUNaSBi/dpou8pRSVhRU3ibVgSd51DdvkUlo0XUMKhPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ykAFBtEJJ4mY+6wZ9Djqt9+VQoa3IB5NvErk1/f7Ii8=;
 b=jrm6CZot9u+WLPnJz8b2l9Q4zcnlXjRuA5KI4A7xSKmdTAmYDw9Yj/7S7vBnBIxD6rZ0tvXRMS9RHlUF5to+nAnwbn4/fNlQO5ZnWWZ1sMPcy9m+g3LVgnbGofcCgykJM/8bCrY8UimNUNn9GXCpWdH8fN9U+kmihBOr/9Hjec1FmvewNlUKvD/7WDxlg0aQdjVrP+NktwI13qwU5gMmbplfVKQF4nJLWScMw/FYngud4jQOSMSrp7DMxxCJdxC8hdO2yjdn7zzsNqQuM/uItd7jQUG6A0nxl6JlZgA+6pvAiczinxaZ7wmveYAZQhpJLx3ZiWpQBb+1bGaYu0m3Zw==
Received: from DS7PR03CA0039.namprd03.prod.outlook.com (2603:10b6:5:3b5::14)
 by BY5PR12MB4936.namprd12.prod.outlook.com (2603:10b6:a03:1d4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Fri, 22 Jul
 2022 16:06:28 +0000
Received: from DM6NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b5:cafe::b2) by DS7PR03CA0039.outlook.office365.com
 (2603:10b6:5:3b5::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18 via Frontend
 Transport; Fri, 22 Jul 2022 16:06:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT019.mail.protection.outlook.com (10.13.172.172) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5458.17 via Frontend Transport; Fri, 22 Jul 2022 16:06:27 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 22 Jul
 2022 11:06:23 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Fri, 22 Jul 2022 11:06:22 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next 06/14] sfc: receive packets from EF100 VFs into representors
Date:   Fri, 22 Jul 2022 17:04:15 +0100
Message-ID: <539b243ca106075d1ed1b78e4eb6b38ba3b92ec1.1658497661.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1658497661.git.ecree.xilinx@gmail.com>
References: <cover.1658497661.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 03f8f535-069f-4537-7902-08da6bfc226e
X-MS-TrafficTypeDiagnostic: BY5PR12MB4936:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lKl51Z1mnyMeYOb0KEpv+cGtrU0d4ow7qD3AKY4fDNnFvOEEeX/VkFeWZV0l9XRsFH8M3JdYDnZoTHk0ZU/UVDf6788JXVZRCc5Nbz9WY+PvxMErTWVZCtisqFkspVWuQWny0vXJGsKy8uVkaH/ZraugUdMYZK6WA8E6wL6TKJIicqRrjI3vx0hcQQAiARcqmXVUzxDTlD/xU8GHGSZDUAASegRxka/i9h8v+eG5znGDTq4vkuRt96pAjpe5DFHH3N8L2n9ID9zdI8v9ERDkYH6lmpWpSQtSGDRtYMob+26lI9aD6SS/V7qfBbV4BvesZ7Ouq3pvxLLqyCSxMbgMRFhQYwAUQYWc8z2xaZWRVKSlBCtXyNcX+xU9TyAG9a30arEumZCWEzhiAPYAcXUGyk07ykXlF6R8W09foUy5dK8dLk6x8yvmA8/Fu36mIAVrcxjhQmrHIS8AA1ykkF/GyL6FxGYePsjFJVlpqHCJgFFTDWaq4XvzGOYbAeRePUb9L2m9kfipvO2aRD4+QnKltBYalD+YPeZ9rAoVOR0Qbm3LNI2CtsvDhLc9Q4/MSo0dPM22KZJg283JytoQsAunFuBj0G+/EH1t3507OsnW0M1dEsmaZhw2/XacA9MoSVxnYmHkK68l2g9FANX6Aiue6uoBHPd0i0GXuvHIf9jpACzb95mYNLP8HJvmdeLguM2U+IJ55zV9GEVuuSqd4I3HV0PDQoydyqEKykGj/3zsKzftSGGOYDx3swShk5e0QNmFOI163aIhnZn9Fd6+ub2yu7VOqH8t17IGAx1MFyH53TtqiGTs50O+ZVzxjRts6XzZrD2VjvQ8UmRoDMtwOAYcxw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(136003)(346002)(376002)(46966006)(40470700004)(36840700001)(83170400001)(478600001)(36860700001)(356005)(81166007)(82740400003)(47076005)(41300700001)(6666004)(36756003)(26005)(110136005)(42882007)(316002)(54906003)(186003)(8676002)(5660300002)(82310400005)(40480700001)(4326008)(8936002)(336012)(70206006)(70586007)(2876002)(83380400001)(9686003)(2906002)(40460700003)(55446002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2022 16:06:27.8848
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 03f8f535-069f-4537-7902-08da6bfc226e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4936
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
 drivers/net/ethernet/sfc/ef100_rx.c  | 17 +++++++++++++++++
 3 files changed, 41 insertions(+)

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
index b8da9e3b7bf2..2b5568170340 100644
--- a/drivers/net/ethernet/sfc/ef100_rx.c
+++ b/drivers/net/ethernet/sfc/ef100_rx.c
@@ -85,6 +85,23 @@ void __ef100_rx_packet(struct efx_channel *channel)
 	nic_data = efx->nic_data;
 
 	if (nic_data->have_mport && ing_port != nic_data->base_mport) {
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
+
 		if (net_ratelimit())
 			netif_warn(efx, drv, efx->net_dev,
 				   "Unrecognised ing_port %04x (base %04x), dropping\n",

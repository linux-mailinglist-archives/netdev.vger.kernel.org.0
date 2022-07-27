Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98EC258325D
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 20:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233630AbiG0SvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 14:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238574AbiG0Suu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 14:50:50 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 334F38C760
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 10:47:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kG03W7ldgtS/Zo46yOLHjYqYaJ4jqxhePYnMCgVqoX/FqaovpIDqRTuf0h4OKTuthmg/jXVCfAgaxB3QZ6b6043ElsVxobxfKgvjWA1ygE9QzretyKwlMv5eqPbgQ1Ct5KXgonmst2SnllwoejPkuVQzGKm8t4/5xfo3Tb8nBHVBL1vj9djQ43VCBmpZOhtivNylubv9lMTMpRqtyznZu9b1sak8BsJ2rZKLJmo8NyWc3eb4/9NZpRS2ROL7C2QGagsELsVxT+Y7tyLl3EOTYxLwqZCQl/8Rubl9pIM0OYiNTR1dpfXzOj1l80l1g651A3qS/RH+6f0KMPgL9sQdPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DggtUei1bA7tcaYBGILcO8uL6PwnvobY/ZfO76mhf5U=;
 b=DCf9HABn07/3L/ZmUJ+HcVhK/t7HMsyWHL3cydMH7Es2MRB+yRGP8K9KyVjs1KnMhV4ghDk1P5mLUqSESk0kB8IhzJnt0Oy0FF/qVegvDfxXVLsCuV0PmoB9Z9ct0gBT77FijglQRFedF/TLl0ntLnBZmtxCnDVAvNfwKj9dgxW/1rVHcvVYdshFKpukk6/tiBkPhV8L5AaY/b0KW20eeNvLBtVngtivsiCdOjf9l0ylaF/GpSClJytE1NGWXIz5hOar+MoN6zpIUNwjAylsGGt7W9Jdy/H7h3k6Ghb6r77N+grT1xCbfchqch6hkveZjocXwCmch1MOq2RG7RTGZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DggtUei1bA7tcaYBGILcO8uL6PwnvobY/ZfO76mhf5U=;
 b=beE8E3ycx0AlAjHM2V49Zl4Uo8MTIGo94NXGP7IfTl4wG5GMVU80aVpwqnWwvipXJa6owHoZQId9O9L1Y3E0tDCWMIeD2LyUjlToYq0d8EuQ43pRQIW6esqwrdh8wSbw3o+1l/ZykvY6BmpRyaDPoW/2+xPFomcxFb4Q0nwdXojvT7f0mlZ3EOHqdogjSNTRwA/zhcLKJXjUXRH6dPdHOvxeEBA0rxQ2UOpT0v/VRXK8AKVEkrExT2UFjnq+zaLVjgLUaF03ZyuKTEXUYgpRrNkJVh/WImyGTs8qhhNgbrKO/hMxvZyB6bqYWWbpb2k9GHo7Zw/nqIDk0g0aPawtSA==
Received: from MW3PR06CA0029.namprd06.prod.outlook.com (2603:10b6:303:2a::34)
 by BL1PR12MB5207.namprd12.prod.outlook.com (2603:10b6:208:318::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Wed, 27 Jul
 2022 17:46:59 +0000
Received: from CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2a:cafe::75) by MW3PR06CA0029.outlook.office365.com
 (2603:10b6:303:2a::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.24 via Frontend
 Transport; Wed, 27 Jul 2022 17:46:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT008.mail.protection.outlook.com (10.13.175.191) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5482.10 via Frontend Transport; Wed, 27 Jul 2022 17:46:58 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 27 Jul
 2022 12:46:53 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Wed, 27 Jul 2022 12:46:52 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next v2 02/14] sfc: ef100 representor RX NAPI poll
Date:   Wed, 27 Jul 2022 18:45:52 +0100
Message-ID: <c26137affc7ba063849972d850db07b00e7fc572.1658943677.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1658943677.git.ecree.xilinx@gmail.com>
References: <cover.1658943677.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f0073e8c-358e-464a-d3c2-08da6ff800f2
X-MS-TrafficTypeDiagnostic: BL1PR12MB5207:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XWtOj3A7UlwKe7w0HXbkBkfv8nCXU6RF5u6cnpkjOKvycElycbq7pTXi1WmwKycUU+sIx6sdXE9LsfQZts36uEAMGozvnFrWMSeHDCUwS4VrPwhfbBU3fxSkO2CRlpNiBs6sYNflLi9I3X1IkAipDKN+eRKWS4P5Mmf/zw/WiLNO3vOS4oKW+d3aDmGRD3LxK3d85AQIodISonZPr+3qvA4OGjL6dkjQL1aXfkeIV71+287mTCqVNkumMVEamxz5G0PNDIV0+tCLMN2V/4KKdjeQG75zO313NSqNNCebXUem6fkQJayhyBjK+RqMAU7mXQ/7RkLHFyznB5g0Y2ijspm4nSSDTV4iggW4wIfpmZlTmWJTkmZsJfDEZiETUx6jQp8Ij/VO/9GdY85yG2xeCYSX7zViuwvi1+qPb7vDviFi+2yfQEr7S6U+MB44OLGOOa6wzRs3Si2ShqWqGTF19Z1KTC8DsaaCFEqhjLcJ894tK+CescMiK5L7w7IIWuzTEJ790Nthw1dyS2kNukhnGDdIh8CzUn5ehO1AqXYCPIIKjCYgV72KMuFK+sIvvArwj1O1gVYuvs08GpTIB5bWJJTeQxMlGdTSACXZ/UmMTOmWOHSpZz7cUO9idNgEpiF0e82ilfC1Wh4qmSQYRm4L8MhOyUqUJDOMyWRtv/wNvBik9VVKh6NEpobIq8oy6ee+9lvVK0UgyGx5+hDP2IdhjqHzBpLKs8V3Uaza51if53AgS9hNVetQjhVGauZoot6U5OI3opTbp/OdkmDIQU8t9mdn7c8aGCA09yW7QsryeVSZK+0kjFtNWk20RmBF0kdkCZczP7T1y2yvTSTz0w2Opg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(396003)(136003)(346002)(36840700001)(40470700004)(46966006)(41300700001)(70206006)(40460700003)(336012)(186003)(47076005)(5660300002)(55446002)(2906002)(9686003)(8936002)(478600001)(110136005)(54906003)(2876002)(316002)(36860700001)(26005)(42882007)(83170400001)(82740400003)(356005)(81166007)(83380400001)(4326008)(40480700001)(8676002)(70586007)(82310400005)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 17:46:58.3114
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f0073e8c-358e-464a-d3c2-08da6ff800f2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5207
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

This patch adds the 'bottom half' napi->poll routine for representor RX.
See the next patch (with the top half) for an explanation of the 'fake
 interrupt' scheme used to drive this NAPI context.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef100_rep.c | 64 ++++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/ef100_rep.h | 11 +++++
 2 files changed, 75 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_rep.c b/drivers/net/ethernet/sfc/ef100_rep.c
index 102071ed051b..fe45ae963391 100644
--- a/drivers/net/ethernet/sfc/ef100_rep.c
+++ b/drivers/net/ethernet/sfc/ef100_rep.c
@@ -16,12 +16,16 @@
 
 #define EFX_EF100_REP_DRIVER	"efx_ef100_rep"
 
+static int efx_ef100_rep_poll(struct napi_struct *napi, int weight);
+
 static int efx_ef100_rep_init_struct(struct efx_nic *efx, struct efx_rep *efv,
 				     unsigned int i)
 {
 	efv->parent = efx;
 	efv->idx = i;
 	INIT_LIST_HEAD(&efv->list);
+	INIT_LIST_HEAD(&efv->rx_list);
+	spin_lock_init(&efv->rx_lock);
 	efv->msg_enable = NETIF_MSG_DRV | NETIF_MSG_PROBE |
 			  NETIF_MSG_LINK | NETIF_MSG_IFDOWN |
 			  NETIF_MSG_IFUP | NETIF_MSG_RX_ERR |
@@ -29,6 +33,25 @@ static int efx_ef100_rep_init_struct(struct efx_nic *efx, struct efx_rep *efv,
 	return 0;
 }
 
+static int efx_ef100_rep_open(struct net_device *net_dev)
+{
+	struct efx_rep *efv = netdev_priv(net_dev);
+
+	netif_napi_add(net_dev, &efv->napi, efx_ef100_rep_poll,
+		       NAPI_POLL_WEIGHT);
+	napi_enable(&efv->napi);
+	return 0;
+}
+
+static int efx_ef100_rep_close(struct net_device *net_dev)
+{
+	struct efx_rep *efv = netdev_priv(net_dev);
+
+	napi_disable(&efv->napi);
+	netif_napi_del(&efv->napi);
+	return 0;
+}
+
 static netdev_tx_t efx_ef100_rep_xmit(struct sk_buff *skb,
 				      struct net_device *dev)
 {
@@ -93,6 +116,8 @@ static void efx_ef100_rep_get_stats64(struct net_device *dev,
 }
 
 static const struct net_device_ops efx_ef100_rep_netdev_ops = {
+	.ndo_open		= efx_ef100_rep_open,
+	.ndo_stop		= efx_ef100_rep_close,
 	.ndo_start_xmit		= efx_ef100_rep_xmit,
 	.ndo_get_port_parent_id	= efx_ef100_rep_get_port_parent_id,
 	.ndo_get_phys_port_name	= efx_ef100_rep_get_phys_port_name,
@@ -256,3 +281,42 @@ void efx_ef100_fini_vfreps(struct efx_nic *efx)
 	list_for_each_entry_safe(efv, next, &efx->vf_reps, list)
 		efx_ef100_vfrep_destroy(efx, efv);
 }
+
+static int efx_ef100_rep_poll(struct napi_struct *napi, int weight)
+{
+	struct efx_rep *efv = container_of(napi, struct efx_rep, napi);
+	unsigned int read_index;
+	struct list_head head;
+	struct sk_buff *skb;
+	bool need_resched;
+	int spent = 0;
+
+	INIT_LIST_HEAD(&head);
+	/* Grab up to 'weight' pending SKBs */
+	spin_lock_bh(&efv->rx_lock);
+	read_index = efv->write_index;
+	while (spent < weight && !list_empty(&efv->rx_list)) {
+		skb = list_first_entry(&efv->rx_list, struct sk_buff, list);
+		list_del(&skb->list);
+		list_add_tail(&skb->list, &head);
+		spent++;
+	}
+	spin_unlock_bh(&efv->rx_lock);
+	/* Receive them */
+	netif_receive_skb_list(&head);
+	if (spent < weight)
+		if (napi_complete_done(napi, spent)) {
+			spin_lock_bh(&efv->rx_lock);
+			efv->read_index = read_index;
+			/* If write_index advanced while we were doing the
+			 * RX, then storing our read_index won't re-prime the
+			 * fake-interrupt.  In that case, we need to schedule
+			 * NAPI again to consume the additional packet(s).
+			 */
+			need_resched = efv->write_index != read_index;
+			spin_unlock_bh(&efv->rx_lock);
+			if (need_resched)
+				napi_schedule(&efv->napi);
+		}
+	return spent;
+}
diff --git a/drivers/net/ethernet/sfc/ef100_rep.h b/drivers/net/ethernet/sfc/ef100_rep.h
index d47fd8ff6220..77037ab22052 100644
--- a/drivers/net/ethernet/sfc/ef100_rep.h
+++ b/drivers/net/ethernet/sfc/ef100_rep.h
@@ -29,7 +29,13 @@ struct efx_rep_sw_stats {
  * @msg_enable: log message enable flags
  * @mport: m-port ID of corresponding VF
  * @idx: VF index
+ * @write_index: number of packets enqueued to @rx_list
+ * @read_index: number of packets consumed from @rx_list
+ * @rx_pring_size: max length of RX list
  * @list: entry on efx->vf_reps
+ * @rx_list: list of SKBs queued for receive in NAPI poll
+ * @rx_lock: protects @rx_list
+ * @napi: NAPI control structure
  * @stats: software traffic counters for netdev stats
  */
 struct efx_rep {
@@ -38,7 +44,12 @@ struct efx_rep {
 	u32 msg_enable;
 	u32 mport;
 	unsigned int idx;
+	unsigned int write_index, read_index;
+	unsigned int rx_pring_size;
 	struct list_head list;
+	struct list_head rx_list;
+	spinlock_t rx_lock;
+	struct napi_struct napi;
 	struct efx_rep_sw_stats stats;
 };
 

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4B7438E65E
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 14:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232830AbhEXMOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 08:14:03 -0400
Received: from mail-dm3nam07on2078.outbound.protection.outlook.com ([40.107.95.78]:41312
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232808AbhEXMOC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 08:14:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FuGdrfPc3Ne57OFOnZATSHDcUSXqO00iXQZgHf8gYaf6pqitQoPDO03K1eW9DQGVXmiOzJBhdr0j7cgqr5Pc4m4YqUwAE98cvNUlwc4d+8kWa+wbrObqA7aRK6bfq2EUcTL0Xwgi7bp3Hbz6uwTef8pL+qv44mTp+zg7YdaBx7CmS7dBuLA62MkCjwcE87F0B+g+n8gOfdHW9HrLevJW7MuB9cFSWsf0NfojZVEj9EaXmIQ8vDWseoFvM4S5B4y3stH+7lld/ZI4Wjcq6PgxEnFyO7EwZtDZ7fmYmVvMWhtvVnSI6FCL8fA/eE26whzATpoI9DjKTDKvCs1nwIKtAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Irq85Yi1QK+EeQU4ZXsdlvhNSDTOqwn07z1ft1P2+OY=;
 b=h5YiTnqDX3Vy7HtgH+4dMgZJKRJFBDXnK0I1lqgFS9rF07z7aniJClexu3BJTW6OCJj6J1xVPuRwSaT8OkJT7IEjS4XSLRPA5BzdMS/Sd1shvN7naNhJQeNzr3HXnTqm3x5xnVK6LKQAEmpSJJ8fMYzNy8oeUhoKZ5XBNUQhCa0B72theb8YA8tEaJKtAJjWZdDtNVjtdA05nqO8l2UeH5ouCy/i+bmHkEl3RVpLvrtle8KiIx/ScaFm06JEpmuTTl7U8NgUbErFNYoUHQquVcEKmw3d+Zec8VvAccQew43p0meLoZJRYzEOa5ESKV1D7MgX03EtgOyjqNCvqI7ibQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Irq85Yi1QK+EeQU4ZXsdlvhNSDTOqwn07z1ft1P2+OY=;
 b=VBLct+Te+x3KIzMbffL50wyAy0LxHYZO80zwQG/Op/iIu+LtvpWj+nYOim8XnY2jjGEKRI5sgIpRjh22Us85BVpye3uU2EZKDgR6X01BKzgB3DW5mZec8ZNRBzv0Sk/LFDm9h5zlqWqOo6Oyj1ZZHX0TDIQwUmzAD40LlPNg9urAjMrVrN+PcYY+/wfsKHBMq4D+llnGmziKFkJJiwN4NRnr9PXggz1hNphWbOEOhu1RpFb/x0G6fLc1Pk5q7mpRI4xbUSqLk3OmdCcjhw55mzoV9KuQkLP1nk9qSdWbbJf20QmuCmm5M0PoPCWPNqF7ygRNBMbDDK3VUCdExofwLw==
Received: from MWHPR11CA0031.namprd11.prod.outlook.com (2603:10b6:300:115::17)
 by MW3PR12MB4409.namprd12.prod.outlook.com (2603:10b6:303:2d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Mon, 24 May
 2021 12:12:32 +0000
Received: from CO1NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:115:cafe::b4) by MWHPR11CA0031.outlook.office365.com
 (2603:10b6:300:115::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend
 Transport; Mon, 24 May 2021 12:12:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT054.mail.protection.outlook.com (10.13.174.70) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Mon, 24 May 2021 12:12:31 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 24 May
 2021 05:12:31 -0700
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 24 May 2021 12:12:28 +0000
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Aviad Yehezkel" <aviadye@nvidia.com>
CC:     Tariq Toukan <tariqt@nvidia.com>, <netdev@vger.kernel.org>,
        "Maxim Mikityanskiy" <maximmi@nvidia.com>
Subject: [PATCH net 1/2] net/tls: Replace TLS_RX_SYNC_RUNNING with RCU
Date:   Mon, 24 May 2021 15:12:19 +0300
Message-ID: <20210524121220.1577321-2-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210524121220.1577321-1-maximmi@nvidia.com>
References: <20210524121220.1577321-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0bce038b-a7d7-4c84-607c-08d91ead34fc
X-MS-TrafficTypeDiagnostic: MW3PR12MB4409:
X-Microsoft-Antispam-PRVS: <MW3PR12MB440972380732BB8033C4C1F3DC269@MW3PR12MB4409.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pVEe1v2/ri2dheu3QSxKJyw1919bneZid2Z3j/gbcoD/bldZVPXBuMUAtk+j+/eyG/J0uM7DqHpCN08snd742CDFca8nvcj+N1clwtIzdAkANq7oZ3/4eLJZOHo3KCkCcQz6DJu0S9c5EARGh+kHgrLFwuZFjI/pZDCAdAy2WtBnTxJdSKF9vN7wb7XYmvICXgBIezq7GRkEsyeMfQ+XQMGysIy/JjXfYvcBd4bsBvmLWc3xCGfjFCaRg2p6twQwu6y0vRB1KbntXQvDmadybKvzZj2FJXquZSOBB4vdcsaF9u1z33XgPaNA9TLQTF1tPZVHzWLDCf3utN8j3TEey5FfWrIugvSLOBNvOeTKoMTdZhC0yd032/KtWwzdxYgqEYihEua//ztchQ8cCMKxzyKVmYViBFWf17d9vZHR9m+v+eST4oi/zFxFx6tJiSEn524rDjLb/hay/loeChtaW7tVWRhaqkCOb2gixL5ySsvIiVlGOtZ2kllkp+PlTITDrH7j4Hs2sGryXHeuJtttLfPsn72OVrO5kxoJVn0v22DAsw/teVmno1D8EhQVNn0WP0+Vz3nL4n1/9mrGTCFsfnaTpF++PFQ6fyVtccFBV+uXW6tYHJuObHhxmSY8vZ55soPsHnWG62XXZf2+/Rlqej7WqzEJim2LYTYL2vE7pQs=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(376002)(39860400002)(36840700001)(46966006)(36860700001)(186003)(8936002)(6636002)(70586007)(110136005)(54906003)(7696005)(356005)(478600001)(83380400001)(7636003)(70206006)(36756003)(107886003)(316002)(26005)(2906002)(86362001)(6666004)(1076003)(4326008)(5660300002)(82310400003)(2616005)(47076005)(8676002)(82740400003)(336012)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2021 12:12:31.5706
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bce038b-a7d7-4c84-607c-08d91ead34fc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4409
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RCU synchronization is guaranteed to finish in finite time, unlike a
busy loop that polls a flag. This patch is a preparation for the bugfix
in the next patch, where the same synchronize_net() call will also be
used to sync with the TX datapath.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 include/net/tls.h    |  1 -
 net/tls/tls_device.c | 10 +++-------
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index 3eccb525e8f7..6531ace2a68b 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -193,7 +193,6 @@ struct tls_offload_context_tx {
 	(sizeof(struct tls_offload_context_tx) + TLS_DRIVER_STATE_SIZE_TX)
 
 enum tls_context_flags {
-	TLS_RX_SYNC_RUNNING = 0,
 	/* Unlike RX where resync is driven entirely by the core in TX only
 	 * the driver knows when things went out of sync, so we need the flag
 	 * to be atomic.
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 76a6f8c2eec4..171752cd6910 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -680,15 +680,13 @@ static void tls_device_resync_rx(struct tls_context *tls_ctx,
 	struct tls_offload_context_rx *rx_ctx = tls_offload_ctx_rx(tls_ctx);
 	struct net_device *netdev;
 
-	if (WARN_ON(test_and_set_bit(TLS_RX_SYNC_RUNNING, &tls_ctx->flags)))
-		return;
-
 	trace_tls_device_rx_resync_send(sk, seq, rcd_sn, rx_ctx->resync_type);
+	rcu_read_lock();
 	netdev = READ_ONCE(tls_ctx->netdev);
 	if (netdev)
 		netdev->tlsdev_ops->tls_dev_resync(netdev, sk, seq, rcd_sn,
 						   TLS_OFFLOAD_CTX_DIR_RX);
-	clear_bit_unlock(TLS_RX_SYNC_RUNNING, &tls_ctx->flags);
+	rcu_read_unlock();
 	TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSRXDEVICERESYNC);
 }
 
@@ -1300,9 +1298,7 @@ static int tls_device_down(struct net_device *netdev)
 			netdev->tlsdev_ops->tls_dev_del(netdev, ctx,
 							TLS_OFFLOAD_CTX_DIR_RX);
 		WRITE_ONCE(ctx->netdev, NULL);
-		smp_mb__before_atomic(); /* pairs with test_and_set_bit() */
-		while (test_bit(TLS_RX_SYNC_RUNNING, &ctx->flags))
-			usleep_range(10, 200);
+		synchronize_net();
 		dev_put(netdev);
 		list_del_init(&ctx->list);
 
-- 
2.25.1


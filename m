Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63D793972FE
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 14:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233758AbhFAMKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 08:10:03 -0400
Received: from mail-co1nam11on2064.outbound.protection.outlook.com ([40.107.220.64]:64128
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231201AbhFAMKC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 08:10:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nCHix1ZwGQL7YATHLViX5seTNoPvEi34GFow5mo6CeaOtCgZN3tS38zJysiOchoAGeAGLYDo5RbZOjCcEBVvlxSjipRFqfVmBCVty9xkRO+2JOChXk6IYiNecIoTLI7M36cjQyzysxP6hRTONjtKLfkp/Co2oTfHRskZ9CSOyekWUI3sRlXdqqpbHwNSdgQL+iEPL6QuflW6bQtKrmxepv0yCOapttym3ZHvvJ3d4p4ZybVHQOKR8jFZHJ4Ex0pdplmez+AhpaCaSonHRrpSDprIDZSMxwTI1U9lIMkLYIrU0omUU1o/NnlT/VCoC3HsP18GhucW36BEH4SzNsFd0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Irq85Yi1QK+EeQU4ZXsdlvhNSDTOqwn07z1ft1P2+OY=;
 b=FvTnHc4MOX8IaRUTGJyYmImT3cqF9UVxYoTeBB5MVXNMACaQaf0hWdtS04VfIhbtdo8EjGjB8biXaEaYZ5ZQvxOIZQyFC3s+aScqAx7v1mCeWYAWfnthmRYTHpiGY3tljSaJS1Kc97RZrrM98s8ngZhC3IncsM9nXA973+TlqzLvNQlZABTKD1G6ADvzDRe5Thd0hJGBBTexb8JJuPVkkusZe2ehyYfdpxBFvAofFTqT+s2hveIVn6EE7JSGIceIMQ+xsjgjxPnwddgAWx9b/tMItLXUlzu/6/t4oxX/td6P8wH7h2a61kDMDG5Vkn2t2QUbs3hXUgwsDJZ3/PD1ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Irq85Yi1QK+EeQU4ZXsdlvhNSDTOqwn07z1ft1P2+OY=;
 b=X5OCYg8PcLHWy/GdNgbamq0TwC861CT2IBZHn2NgZXOGeZQN58Fzvg5fFsk1ZRBIiji/OEWBMssGpNM/E6G3kMXXaZw9r+R0ToHFnMkoluu/VQet5MM80OjEN/IyzwWWokQNkxiHyeB5loKCO2P8Nm2T0KN5LPNz9cCtDkHWOf2Us90/0hRsKR56Llb3ZHRo+UKDs8nHkvKU4fouYuVLJBdcAAXi8DayOLFqbAL5Uk74AGK0ch6TLVWSC3L45GMPqqn+m/oivsMfZsftL0wZUah1t3/WAsqE+yJYkVkPnNObT/oa6sVTnLzDSdmcW+IhfAURr3tBY03C/cC9DVqyBQ==
Received: from DM3PR11CA0011.namprd11.prod.outlook.com (2603:10b6:0:54::21) by
 BYAPR12MB3573.namprd12.prod.outlook.com (2603:10b6:a03:df::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4173.26; Tue, 1 Jun 2021 12:08:20 +0000
Received: from DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:54:cafe::b3) by DM3PR11CA0011.outlook.office365.com
 (2603:10b6:0:54::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend
 Transport; Tue, 1 Jun 2021 12:08:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT066.mail.protection.outlook.com (10.13.173.179) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4150.30 via Frontend Transport; Tue, 1 Jun 2021 12:08:19 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 1 Jun
 2021 12:08:18 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 1 Jun 2021 05:08:12 -0700
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Aviad Yehezkel" <aviadye@nvidia.com>
CC:     Tariq Toukan <tariqt@nvidia.com>, <netdev@vger.kernel.org>,
        "Maxim Mikityanskiy" <maximmi@nvidia.com>
Subject: [PATCH net v2 1/2] net/tls: Replace TLS_RX_SYNC_RUNNING with RCU
Date:   Tue, 1 Jun 2021 15:07:59 +0300
Message-ID: <20210601120800.2177503-2-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210601120800.2177503-1-maximmi@nvidia.com>
References: <20210601120800.2177503-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e3212aee-9c44-4644-c70a-08d924f5f214
X-MS-TrafficTypeDiagnostic: BYAPR12MB3573:
X-Microsoft-Antispam-PRVS: <BYAPR12MB3573BFC95DE2A6D14812021DDC3E9@BYAPR12MB3573.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T8CNT2wumxgwCOFLCNUr2s7xD2e9ZKa8WJKM2AkT4XgiccRP5O89XhdWiLs2HNot95s0t/VSw3Y2SxnHvG62u4B4zJkuVovC9X14YQW27u2caQh4iIVAyXB9SpyJI4aBrRrqm3FPexHI5B0La20gcGeVSXFceU+shfZ4R9u5/eIO9ckBrTMDYWd8KGvEdInyFOa8DtD3FxVXKQx6iEMuWAU5KMF1ElPKHQDeaWh/ERLkx1UxnaN2Gtf+hhNfsrg/tUqZ1fFWsvUzcc+etpJn5FJSqGeVaKfO8Xb2rNrba8URwRBxA2rf7PVsjC7jt7Df0m0UKSxdVNIXGbn3/M7avKHnCkQ197LrikelGfX1infq+swuwVPmQle1iBavdcKyTgy8uZ8hyF/5fSk7642h97aEw9BXtl66Y9csUuJACmvoDuDzPFjKWwTJxe7QIKpYbkLgpeZgHYtaIwzt6vVGQPDKpuVTjbjQxc/wqfC1CZe8Hpzh3CUnGJi9V0S0G6B/16aNssf+meeMIshEg5OnI2bGN9iUTbDF5Bq9x3D9gQlHit6chv6V8QJUGLQ7OVoj9HUjZNvGpTcCpnTlpIjZYKIowe0Cf3ePy+K6xK3Z1WOnRsCToFn6wv9LzvVYSJl1bnSaqs/bKsX5bmt5qC4GG5Bm7a+dLKUL5+Wjsg8bfMc=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(376002)(136003)(346002)(46966006)(36840700001)(47076005)(5660300002)(6636002)(110136005)(82740400003)(86362001)(36860700001)(36756003)(70206006)(1076003)(70586007)(83380400001)(478600001)(8676002)(107886003)(2906002)(2616005)(356005)(426003)(4326008)(336012)(7696005)(26005)(316002)(6666004)(54906003)(7636003)(8936002)(186003)(82310400003)(36906005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2021 12:08:19.5691
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e3212aee-9c44-4644-c70a-08d924f5f214
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3573
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


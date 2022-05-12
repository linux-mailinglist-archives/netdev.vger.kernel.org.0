Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9625248BB
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 11:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351885AbiELJSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 05:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351874AbiELJSr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 05:18:47 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2048.outbound.protection.outlook.com [40.107.223.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5697E223872
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 02:18:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JRkLmYKYjwx5ALpuogVzdsfODFXB5sk3EaNdoONwuawe5ABu2LG7BDS0Six+QB0m87NMEc3NvU/Xsa8I8Lzxnp45zvfzgwlr5O1/AoWN83Wy0IVfyASx7QvjFsrMM7QzrpffzOUXl8hbKQpd56HshYzNLPYG2MdNLfBZvDbINFANr7eOZrb4Op5PcinEpL/FW3H7TeO8mnKS2Z2h/cxsTpRAJm6UpSgAmLzYtiXxmrhkNhiCiozutBbzER2hG/LelsRAXcYw+HS61TTiw3MlkVnSV9pLSqTQxFPoHLjFdT4nQpocDje4+37toTCq7Epfqtxfpc4jT7mJMQe/h/TWnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qMnXIjojI3MdD2NW4ItHsYn3nUUzcadZLtDAKUDcjVE=;
 b=eH0/QHIgRZ+Zqrnd0bSSVSutGuRKGfaGbZspg651xYRtqsAE2rzabHrC338HbrsRylhZD2OtO1vxZ+10FCnsMx47gRzrsVYF1OV3FQHpGxPSUil5jMlMpSmrPYppUXDikYffrV7BJl3smSpl35q2CavH0AKArzKT0YIcfD8mxr9GMXZtFtNUB0gRr+4k1D0bwovN4TIwKEtVqs1v9/t5cVWbM7WkInJYVQuncppn63MTq0qqoIvqOFPk6N1Dd8HlNwsM8gVU4N/dZZt1cQZRHWW7QY0Axwl06v3YDMvkRw1DeiI+jcDDDVVLzGBpkoQhg9TXJkmAB/Ldyu+XFUy0/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qMnXIjojI3MdD2NW4ItHsYn3nUUzcadZLtDAKUDcjVE=;
 b=d3gq+odPVTxV2+F1wLkWgaOpRNH+aciAgO+Zc8a6d10UEQtzyS3wDKXlsNsJj4y6VDRa9O+mm+g/IOmMyCWN6RZcmpBLg2J4LG0k6AFhuc1y8/w9aIDI7RCVx5BpuB1fAxCFeRIOuszrHzK5ed4jFSmMuc3sPei+zgw923MECZ025jk3PGmHBU6GnqABVilfnR9a96qsR9196CIxhbJfjtCT4KeHUnjO1i+pOXckjn/FJVKYQbx1BZ0CFbho8Mxg0AmLbNhuQYrYGmQYfpN7lgKERldDuOGluew3IRIxhB2ZX8fhUr/e0rXal2NDHc1ZywyN+jb6NCPSj2e/fB+VTw==
Received: from BN9PR03CA0200.namprd03.prod.outlook.com (2603:10b6:408:f9::25)
 by SN6PR12MB4766.namprd12.prod.outlook.com (2603:10b6:805:e2::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Thu, 12 May
 2022 09:18:43 +0000
Received: from BN8NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f9:cafe::f2) by BN9PR03CA0200.outlook.office365.com
 (2603:10b6:408:f9::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22 via Frontend
 Transport; Thu, 12 May 2022 09:18:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT011.mail.protection.outlook.com (10.13.176.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5250.13 via Frontend Transport; Thu, 12 May 2022 09:18:42 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 12 May
 2022 09:18:41 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 12 May
 2022 02:18:41 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Thu, 12 May
 2022 02:18:38 -0700
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>
CC:     Paolo Abeni <pabeni@redhat.com>,
        Boris Pismenny <borisp@nvidia.com>,
        "Tariq Toukan" <tariqt@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, <netdev@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net] tls: Fix context leak on tls_device_down
Date:   Thu, 12 May 2022 12:18:30 +0300
Message-ID: <20220512091830.678684-1-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0aa29c14-bc67-4ac1-3b06-08da33f868aa
X-MS-TrafficTypeDiagnostic: SN6PR12MB4766:EE_
X-Microsoft-Antispam-PRVS: <SN6PR12MB476638F8B510874BD7BD79FADCCB9@SN6PR12MB4766.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5J7T5/QOkVCUl1uQbq2NOuRsM0WRb4WAxmBIlxBposJ6ZUV2HOrEmg+FYLHdxOlozwjZaxIVB1vtsENj1LjdAD5DIBZVdqQEzqTG/CfqW06z6XYt69pxIoZqCAEsdsybnug9Vv+FU42g65lB1AW9mWRmpAZmKEHnr4gq8UOkzABhvwb7iaSI59MVrlencKZdBhVjvFMXcswh/wK8UpdxhdWEFn7weL1sGPxxUfa7YkAo5uhI+rzzgpLQYpL4bZgqWBn+WpitjVO7YMKZVquGngWUgsSUwtXussRZ7e+UhayMf0qPaIYf/JT/Su19km3V1mCv95eAwbVjKs3nbC6Us2CIkg8xDvOzJIfu+SFPMiIoXIpYM6/QZ9N9hh9ZW60xGSqlwnApR3FtVeMHbmzjctyNrIlW5lezaduTxc76xlfonUlMbrytP87cDHR0l3CIQ3jUvwBcJDiguZhucA2S6VRNKlkAM6C4rY2JPiY8l4XriVlMEPcrWQL260UWksUvYURDj3LPDaSz7PR3dcgPUc+z73GZLM6Djg/SiwoeWyc7AcaJiOWOPMc44IKiMJ+lc95U18maJ1OtJsqRFiZ/vGMwP7yKOa3VjC9ufQkttS3aPupz49xPU/fDVCU7mHCqpQ86iXXLyLW4YMes5qXEKoc/ApLq8knleG6yI/SJ4Mj3zaDYlScHoK99BiS8nZI/CKeEWRtTxHprXxcTErDdcQ==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(83380400001)(82310400005)(7696005)(36756003)(81166007)(356005)(110136005)(8936002)(8676002)(70206006)(54906003)(70586007)(4326008)(36860700001)(26005)(107886003)(336012)(2616005)(426003)(40460700003)(47076005)(508600001)(2906002)(5660300002)(186003)(6666004)(86362001)(1076003)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2022 09:18:42.5520
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0aa29c14-bc67-4ac1-3b06-08da33f868aa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4766
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit cited below claims to fix a use-after-free condition after
tls_device_down. Apparently, the description wasn't fully accurate. The
context stayed alive, but ctx->netdev became NULL, and the offload was
torn down without a proper fallback, so a bug was present, but a
different kind of bug.

Due to misunderstanding of the issue, the original patch dropped the
refcount_dec_and_test line for the context to avoid the alleged
premature deallocation. That line has to be restored, because it matches
the refcount_inc_not_zero from the same function, otherwise the contexts
that survived tls_device_down are leaked.

This patch fixes the described issue by restoring refcount_dec_and_test.
After this change, there is no leak anymore, and the fallback to
software kTLS still works.

Fixes: c55dcdd435aa ("net/tls: Fix use-after-free after the TLS device goes down and up")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 net/tls/tls_device.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index af875ad4a822..3919fe2c58c5 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -1347,7 +1347,10 @@ static int tls_device_down(struct net_device *netdev)
 
 		/* Device contexts for RX and TX will be freed in on sk_destruct
 		 * by tls_device_free_ctx. rx_conf and tx_conf stay in TLS_HW.
+		 * Now release the ref taken above.
 		 */
+		if (refcount_dec_and_test(&ctx->refcount))
+			tls_device_free_ctx(ctx);
 	}
 
 	up_write(&device_offload_lock);
-- 
2.25.1


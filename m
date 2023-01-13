Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC82E66A5FF
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 23:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbjAMWhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 17:37:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbjAMWg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 17:36:58 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2055.outbound.protection.outlook.com [40.107.244.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB1176EE0
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 14:36:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=euHYenux/x9w6pTas6jjp1W+mEj4ZPVXC4/Qwg58EdF2dV0U6zmj8GKn4KyttZHPhFuay1I/WqWeUjWTn5iE4D2y4UGtWJU7E5gQltAL0io2wW+TBJUn7GqE6uarGroyR6z+bYy2cnne8QAdjH/WpxWBVofB0Y8aUbQqyl9E1emWTkiWqO61BBdAd3ZFcKrIAkN42bM/mgehKXnZbNmKeL7wncNZeneoraKVOXErcl85dVUU2oDvbGPRAk8iQsAH3/ymVkEXlvkBz4ciPjSxwBTdTlWRIV+PyMBmdXEA4letoQk33SfNIrluXMdIvbP3iQ9JBXAoEX55imYGyYhJXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fs8cexyEPQtXe/Wqt6dzVZq7uTF0aQLnToWno15hkGs=;
 b=K0FVWDGljnHDhgTlpdKD+YD7NQmzlvglCwRzI4NOACPhA+mS5M5bcRD7LXV3VS7Jruz+Chvyy16zqeiHmdDYkO0OtLRpol1KA7lD/RyJcyAMkM0RWu0xXV2xU9a1kQcNJLHYEIwreAxXzTyEKnrcGdO+1RdpqHhPjo/xYJNAvofJ3o4BTpxBZdiOXsjEB6lriJPchLqL91PoPoXxpjfnoqBpoemJ/iICqEw1h2KnyJNCIxu9JgVRaXWc1P0tBCf4XBPg+IyFh0fj7E/jzzhRw+YeGOgIzKRshnqE76FIedNR6lTLkzU7TMOTM9V1NPGOMm+CYlY/moS80NdnPevZ/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fs8cexyEPQtXe/Wqt6dzVZq7uTF0aQLnToWno15hkGs=;
 b=k786YXipiebdNoBTZG62Sa0hUqWJyc2xQe3M4UinrQQIenpSxWNe7zaElGvmJ7eZOF/Gw9LF3rasg9LGX4Cp8d5hWrS5hzQshIytFhb2TQnrXRWAbpmuEwZ9bnpbgNV/WdrFhhxvd0SCOBDECl3J8oJ62gaKtddgKpJHHGvbYeV3uXtO29otpTy9w4vBNjlCU9AMoSnlGKUf9LRLodnk5xzoft75Xd6ERheBf8RGak3MEFrtqN7qgQ+6UU30dSQU6mGyArLa0pMSA4w0I1UENh6sAxeslFjw0kOX81WHM9mcNsr87SbqxVHxYekwod46f/3s/o4LwkrChwIMUNMqBA==
Received: from BN0PR04CA0172.namprd04.prod.outlook.com (2603:10b6:408:eb::27)
 by DS0PR12MB7745.namprd12.prod.outlook.com (2603:10b6:8:130::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Fri, 13 Jan
 2023 22:36:57 +0000
Received: from BN8NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:eb:cafe::c7) by BN0PR04CA0172.outlook.office365.com
 (2603:10b6:408:eb::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.16 via Frontend
 Transport; Fri, 13 Jan 2023 22:36:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT057.mail.protection.outlook.com (10.13.177.49) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Fri, 13 Jan 2023 22:36:56 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 13 Jan
 2023 14:36:43 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (10.126.230.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Fri, 13 Jan 2023 14:36:41 -0800
From:   Parav Pandit <parav@nvidia.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <edumazet@google.com>, <pabeni@redhat.com>,
        <virtualization@lists.linux-foundation.org>,
        Parav Pandit <parav@nvidia.com>
Subject: [PATCH net-next 2/2] virtio_net: Reuse buffer free function
Date:   Sat, 14 Jan 2023 00:36:19 +0200
Message-ID: <20230113223619.162405-3-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20230113223619.162405-1-parav@nvidia.com>
References: <20230113223619.162405-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT057:EE_|DS0PR12MB7745:EE_
X-MS-Office365-Filtering-Correlation-Id: d399f21b-bcfc-4c71-62f1-08daf5b6ad60
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X2DVKPyGPdCGSiql2j8m7AVOThJskJ8K2DVAzL9+HBsO0buHSu5g3Cq2e4Heg8AIKUSxyU8Oxn9reIEgTuqFBWyGaYZkeekXuBrXRSqXxjxznLIu9tj4OEydxUyU2/6g3OhZV7+53i/Ol3K5slOo8fhiKOSv06gKgDli710qTIiy/AdvJeY+F6V/HmVgTdvKJvSvJ9+e1iINz4eORjYF3BcWC10vSHRX34Mi4rLCJIKy73DhHgpxigefKt72I9K7+eadx5wYmPASYLG43oJ+8SkWyMvFdPQSJBwTV8g8gY7doCbta1uOLCIGERYBPvLLSMpPeOJVI/+9dPYOpP7YQun5Y3cNxzsiVJlJZNINZCzLEfHAtygTxg9b45o8Q7ejmtU7yDkcB7jwNk9u9aW1s4WVuTYI6CWlBffmFRyxq/qWDo8eTEJw4mqdC16ygSgkV9uhH2hwWHGqjWOMulf7nO3DTYS7qbewRuhxmkj2NWTaQlyPwae69ZSdfmsRDe5JKZ/zRSBAh02pegtdlGWrCM9t24psDtyIOk1tOegvo5i4n5H+MmX2QvbjDTvtUDaTpTk19r1s8NOzlHTIV+5dFqfpDIh9ogTncqOpH2GlR17cirE+dLb8jf4bIuVu3GDJYK4Khhcb2D5FhhKyvu/JLlLjPaL9/Uu2qALRT0TgY89j6QcPkoT1GFnOCoNtc2zV/GGO0R5Qs95Z2jL9Q88Y3g==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(346002)(376002)(39860400002)(451199015)(40470700004)(46966006)(36840700001)(82740400003)(7636003)(36860700001)(4744005)(54906003)(356005)(70206006)(6666004)(86362001)(8676002)(70586007)(41300700001)(110136005)(40460700003)(40480700001)(83380400001)(5660300002)(107886003)(8936002)(16526019)(1076003)(336012)(316002)(2616005)(2906002)(47076005)(26005)(82310400005)(186003)(478600001)(426003)(4326008)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 22:36:56.5943
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d399f21b-bcfc-4c71-62f1-08daf5b6ad60
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7745
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

virtnet_rq_free_unused_buf() helper function to free the buffer
already exists. Avoid code duplication by reusing existing function.

Signed-off-by: Parav Pandit <parav@nvidia.com>
---
 drivers/net/virtio_net.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index d45e140b6852..c1faaf11fbcd 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1251,13 +1251,7 @@ static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
 	if (unlikely(len < vi->hdr_len + ETH_ZLEN)) {
 		pr_debug("%s: short packet %i\n", dev->name, len);
 		dev->stats.rx_length_errors++;
-		if (vi->mergeable_rx_bufs) {
-			put_page(virt_to_head_page(buf));
-		} else if (vi->big_packets) {
-			give_pages(rq, buf);
-		} else {
-			put_page(virt_to_head_page(buf));
-		}
+		virtnet_rq_free_unused_buf(rq->vq, buf);
 		return;
 	}
 
-- 
2.26.2


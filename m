Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4484067748A
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 05:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbjAWDzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 22:55:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjAWDzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 22:55:39 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2050.outbound.protection.outlook.com [40.107.102.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83CFF16AC9
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 19:55:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GKBzViYXUbZdJjv8A0/tdppfkrDVVuFBDF2sajpVTEkX+qEZSblKKJUjImSErzHX3L/fjxAxhHcme4TRFMZshPxAz/X/n71mRL0g+p5J0qZcLjZS7wHxDZtgCdhwAjiXam0mVgjJ5CfIEqyBmEOxbg/4hVn5C9dK1HMepx4Ac8Bg70Cf7L2GD5Yz7hImR7Aky2iu6YL5z5q6jyTgfjTuLmbzt11xESHNHkunUYmp/L3v9/LI9R9fENQjjfhecwPBWlVcFJXmw+IKDU+MafJ8OV2YSaOaaPavFclQTHLABFHC5WzkAVKV2FAW26AJcAULljltJbhIIRPEOY7+lEWWlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XCnHu4wsacYOVaYBphaL5EeP/I8WJThhsx/mbzhJVv0=;
 b=Ay7xNrj37rChf6f8YiQVPEBNbJpIeUJMx4YSbzmAFy8A7nEJ7tUqypILcx7rE1HvLraY3xuQjtHAQz11vwlq5MWhHhjQl1ie4UbQigc00w1ZTL27N3Hk2muwUuk40nKoXArhekvjJS1Nh2L0CTT7zlKkSQ38zQmqrbi6BqYdvt4qr26SKfpbfYYpjI2JH4JmhUjkDvUBFNyfqJqr8aMl3NchYz09mM9ghhwlGTUhTmX5xQLbL+lXMfBN3p+XMuewALUe+j5LEeiYwWgcHWKgl0ApvBVOahktOtqDZbnPkUR+phUblFvwAzjbHSnx8TU4II7Zs3tayLjMNkSJklR80A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XCnHu4wsacYOVaYBphaL5EeP/I8WJThhsx/mbzhJVv0=;
 b=kLWnhIsvkmcQLTGLWe8C0FAECMSUWDtunuhTBKZv+VUPJCV6uKehJxZwNXIz3TDU/nVolQCUmTEAPQc5GtG98SrgX/oAkvCNdnTX+FK8ZdBoIRvpABCSLwt4sdd2TudhbCdWQCG3AKUMBEDmtnZNE3KRUh4giqHNm56LBlAkKijxnldFVJMYzm0jiVbEzy6T0F0HXFlgbSXqawtD+8IQSGZLWEOYUWwPQJrkb8/WaHCGo8IkWJ5Jj0k3MD6m1u8/murCgpnnMPaYsA4cudxPO4j8Sa+z603Tm1VEOA35a/pBw9oDxQc4v+M5Rz1Wyx0anlS6xkDQcUNw6yAXB+19Mw==
Received: from DS7PR03CA0138.namprd03.prod.outlook.com (2603:10b6:5:3b4::23)
 by SA0PR12MB7075.namprd12.prod.outlook.com (2603:10b6:806:2d5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.28; Mon, 23 Jan
 2023 03:55:35 +0000
Received: from DM6NAM11FT108.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b4:cafe::78) by DS7PR03CA0138.outlook.office365.com
 (2603:10b6:5:3b4::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33 via Frontend
 Transport; Mon, 23 Jan 2023 03:55:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT108.mail.protection.outlook.com (10.13.172.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6023.16 via Frontend Transport; Mon, 23 Jan 2023 03:55:35 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 22 Jan
 2023 19:55:33 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (10.126.231.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Sun, 22 Jan 2023 19:55:32 -0800
From:   Parav Pandit <parav@nvidia.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <edumazet@google.com>, <pabeni@redhat.com>,
        <virtualization@lists.linux-foundation.org>,
        Parav Pandit <parav@nvidia.com>
Subject: [PATCH net-next] virtio-net: Reduce debug name field size to 16 bytes
Date:   Mon, 23 Jan 2023 05:55:11 +0200
Message-ID: <20230123035511.1122358-1-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT108:EE_|SA0PR12MB7075:EE_
X-MS-Office365-Filtering-Correlation-Id: 8262218f-7de6-42fd-604b-08dafcf5aea2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QrPdfIP8OAYzi5E8KaJBre+Pri2o1DHay9NkJuMvUOUemLEmhflpFkodl5P8Yf7gsUauIqk95JtpRQh8XBtfVStIl7Mc93roOs4FkDM8kJKv5k6OgHfZSh0nJwrF6NG5VaTBRQRjnmEqN5sRJE/K63VEQ+j6sryUj/JSxcrQcHdhf+fuB0mIWvqYH7iEnil5lsl4DqcgKdEVltVJoCvGeiw5J4Ps9kiR7bjMUp+YAShHrpVqjQ8HxmWhRW6TXApWgHz4S690i3M+lfeYLPzULD00RbUUTGLmZPsjkpgN/PilCxlLnViJBusXzyDibTUExQUkGYZyv3+dCp2MSKQflEqiIiQRUUOPilw15XboVJFR0dYLbtOTbc7EJmLuHhr4K0cMcRG1kAeSwabSIYgIzGk7fpVJCyuaW4j34k8LeCbjsSInut815Ak9RSh5qm1pP3eCyOpHFaVkhwehSZv8J5S9ZvdtLI+Gn0e2iSaz0UTLvQPP3Ggoy5E5V3vE0FwGhs0dskmJYlukD9F8TSG0QEtk8bM6XwfGsIXRi69y/Gf0OA/GEgz8Ax0AXRpQs15ldI0GAJON2UNS30dHPA+pYznRL5/uYVWOESgCKwmvl6juNpP2mn66VFv44oZOBjDqqU3q9FIufJgQ/lkKFGLLS8XkW9Wr9K+A2NYvbysJNpbCd07ExgNYXxAtzESIePdx5/5LGaLAHRhazah/dTlPwQ==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(136003)(39860400002)(376002)(451199015)(40470700004)(36840700001)(46966006)(83380400001)(36860700001)(82740400003)(7636003)(356005)(86362001)(2906002)(41300700001)(4326008)(5660300002)(8936002)(82310400005)(40460700003)(40480700001)(8676002)(16526019)(186003)(26005)(6666004)(107886003)(47076005)(426003)(336012)(2616005)(316002)(1076003)(54906003)(70586007)(70206006)(110136005)(478600001)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 03:55:35.2004
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8262218f-7de6-42fd-604b-08dafcf5aea2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT108.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7075
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

virtio queue index can be maximum of 65535. 16 bytes are enough to store
the vq name with the existing string prefix.

With this change, send queue struct saves 24 bytes and receive
queue saves whole cache line worth 64 bytes per structure
due to saving in alignment bytes.

Pahole results before:

pahole -s drivers/net/virtio_net.o | \
    grep -e "send_queue" -e "receive_queue"
send_queue      1112    0
receive_queue   1280    1

Pahole results after:
pahole -s drivers/net/virtio_net.o | \
    grep -e "send_queue" -e "receive_queue"
send_queue      1088    0
receive_queue   1216    1

Signed-off-by: Parav Pandit <parav@nvidia.com>
---
 drivers/net/virtio_net.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index a170b0075dcf..3855b8524300 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -134,7 +134,7 @@ struct send_queue {
 	struct scatterlist sg[MAX_SKB_FRAGS + 2];
 
 	/* Name of the send queue: output.$index */
-	char name[40];
+	char name[16];
 
 	struct virtnet_sq_stats stats;
 
@@ -171,7 +171,7 @@ struct receive_queue {
 	unsigned int min_buf_len;
 
 	/* Name of this receive queue: input.$index */
-	char name[40];
+	char name[16];
 
 	struct xdp_rxq_info xdp_rxq;
 };
-- 
2.26.2


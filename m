Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 110355A10B6
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 14:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241927AbiHYMjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 08:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241961AbiHYMjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 08:39:12 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2085.outbound.protection.outlook.com [40.107.93.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE56DB4418
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 05:39:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fc5rIPP0oaVWeNIZxMf2EMa19kqPmzc/DN5r3vzdnbdZd8zJFsuqYniWwpcI6zlSgY5lNCr0W3uNz0ruaLTcj41ZL294qVPUo0qxbU1KWNxSZyexviaXIU6nHuh4xKX7HqPJSswvfA3Yyq8PcMPbc0oJobNnWFPYWQy1mP9A/Hcql8Id5CJgPJUZ6kMazelhZ5Pj4H6ENAxjYyFmXLUEP5JIXwu6zUcrbD57KNjeQ1iI68YofFXtXeKIouCAUGhj8HgKKoFc4fyhQONgdf1rY3Le98+vM2VDCVLPYZyJM7dUtJB8vhQjxVP7P9LPtqU+TG9JIC5yQZWOyk+XvFPZjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wP590Bu0rBC23wy+9IS7M1cj6941SHg2afMEMPE1jqw=;
 b=IBk+sX+SFGcZOaUNIKf62FeO5+s4BJcK7E+tJWrqwCk40ecGiVePQbBiFB+f0tgTuQ/+qzyqDxsguA1se5u6KqjSMJEIQTl+AvRFtdbulYs0bJVf7V9fknidQns4lTyE6p+wVfT0wFjLfZJeqCliXieAtySmRnTAViPyfUnrcDbGf8cn6QlFF1hLnCjn8258DTXk4oitNX/tX+X5l89rR8IIOrP3yeboV88ckdVGtxVVHmijetbbSe2JP769NWYJUUQj7AAHe4WCe6mJ8W79GNSKxAh6HpxFY+Y/J0gJE7dQzPoOvrXc/F8g6ZcRXQMsJcm5iKFvlLm/WQPwZ8/HKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wP590Bu0rBC23wy+9IS7M1cj6941SHg2afMEMPE1jqw=;
 b=gRsGyHb3fNbEm/+NrU+eFJW1aj8v1cXb+bUOPvrFRuAE89xDoTg9ah6fFPDivQYdjz7d7qrXPgklgxQFIqUYyd1UzSubT3NfolVxYNMp8goJuloP0zrk/BQNSVKpa6ctg2ybNFIHw3gl2J6o+jD/jvNwrHYfFBm0bcJ1JjtpOMbNtZHGY0MsxRkCRY4NbKQz9Ia4I/j+j7c/fAG20+FFX9G3dyYia0+rttbES9lqZf/ZV4VgnG7WjQlJymFbtvZ6Y2/6kRXYkiyIQXNz3jXzikQpZgpPdie9a8nmEf/on9DNM4HYrw42ggHGV5ijSdnyc0Ml9SanEu7zDPmOH5rN9Q==
Received: from MW4PR04CA0360.namprd04.prod.outlook.com (2603:10b6:303:8a::35)
 by DM5PR12MB1561.namprd12.prod.outlook.com (2603:10b6:4:b::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5546.22; Thu, 25 Aug 2022 12:39:06 +0000
Received: from CO1NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8a:cafe::8b) by MW4PR04CA0360.outlook.office365.com
 (2603:10b6:303:8a::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15 via Frontend
 Transport; Thu, 25 Aug 2022 12:39:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT024.mail.protection.outlook.com (10.13.174.162) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5566.15 via Frontend Transport; Thu, 25 Aug 2022 12:39:06 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Thu, 25 Aug
 2022 12:39:04 +0000
Received: from nvidia.com (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Thu, 25 Aug
 2022 05:39:00 -0700
From:   Gavin Li <gavinl@nvidia.com>
To:     <stephen@networkplumber.org>, <davem@davemloft.net>,
        <jesse.brandeburg@intel.com>, <alexander.h.duyck@intel.com>,
        <kuba@kernel.org>, <sridhar.samudrala@intel.com>,
        <jasowang@redhat.com>, <loseweigh@gmail.com>,
        <netdev@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <virtio-dev@lists.oasis-open.org>, <mst@redhat.com>
CC:     <gavi@nvidia.com>, <parav@nvidia.com>
Subject: [PATCH RESEND v2 1/2] virtio-net: introduce and use helper function for guest gso support checks
Date:   Thu, 25 Aug 2022 15:38:39 +0300
Message-ID: <20220825123840.20239-2-gavinl@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220825123840.20239-1-gavinl@nvidia.com>
References: <20220825123840.20239-1-gavinl@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c4ca51a4-b91d-489a-7596-08da8696ccb8
X-MS-TrafficTypeDiagnostic: DM5PR12MB1561:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vTAdKk+7xI08e5FHPUIARvQiejaw4oxCQFuSLpYCnZhzu3Nc7IW5KsDZAZENaFu9MeLSVEEVrtcI3vfGrRy06IxCOUblUeV0+WOEmQytOdXPOrJbQJrVl5hN7zjOhAsoloyJPdSJsRTX7rI6XwK1tmk2GQ/xzJVF2ucXWY7CGHNXPHno9W2VYhVUi5A6YJ8P3godJC82iNcmMdyKThhcYKWGmfCvISIeSGhESqgTOCzzWYs11zX14IXJU1U85hhts6u70833XvSMFfkGoDg30zN78uTHXHWDjbhAFniRliq9Q5NxEqX16A9thmR0dfMop5aaeGAlipiWX0MLb4rXjsKHx3Ya3nyva66b0raE5bAaFRSf+anQfI4ZoupZzXfylLnhNlrv+V6d3nt//B4mXZ0eORHAUtJpvnI17sVxDHiJF6jNtnW3/ezSsAa+pbga3l0eVDeCA6qyj1VZwpiJHLsr9R2VVxfoD0RP1PABnqkvbWk2OANg/nCoYOfYT8a2WQ+LDcWyzgk3x+kArjkjX9P/Z4nukcMnfNXPX6lgG+RAHND9kkcUi1XZ2+fTwdS7vWx4QKP1CT0AFqJQmHFXuukJbMSR/eJ6+IJgblur2fHXb6Jc5nfrjv43sVaL9GhtEnalGTFHhrUMxwB+VMpzK2QqqRkHIiwa2r6PwFRSsoKj2YVQ1lj1//RjvSI3XGvjo1W7hvuzUR12gnp+pKEJz3zrvg7zV7FzatM8GMNomPUP7tLWqKy7Utk9wwFvsryXpFzGTjarj8FzO2o8TF4o9BiEivXcvaVkcZD5KR3Y9z3XtXgtwom3f5W2/+mFoTTw
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(376002)(396003)(346002)(46966006)(36840700001)(40470700004)(4326008)(107886003)(186003)(478600001)(5660300002)(7416002)(8936002)(2906002)(6286002)(86362001)(41300700001)(6666004)(336012)(36756003)(26005)(47076005)(16526019)(426003)(2616005)(54906003)(7696005)(356005)(81166007)(82740400003)(83380400001)(36860700001)(1076003)(921005)(55016003)(70586007)(70206006)(40480700001)(8676002)(316002)(110136005)(82310400005)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 12:39:06.3110
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c4ca51a4-b91d-489a-7596-08da8696ccb8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1561
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Probe routine is already several hundred lines.
Use helper function for guest gso support check.

Signed-off-by: Gavin Li <gavinl@nvidia.com>
Reviewed-by: Gavi Teitz <gavi@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
---
changelog:
v1->v2
- Add new patch
---
 drivers/net/virtio_net.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 9cce7dec7366..e1904877d461 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3682,6 +3682,14 @@ static int virtnet_validate(struct virtio_device *vdev)
 	return 0;
 }
 
+static bool virtnet_check_guest_gso(const struct virtnet_info *vi)
+{
+	return (virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO4) ||
+		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO6) ||
+		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_ECN) ||
+		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_UFO));
+}
+
 static int virtnet_probe(struct virtio_device *vdev)
 {
 	int i, err = -ENOMEM;
@@ -3777,10 +3785,7 @@ static int virtnet_probe(struct virtio_device *vdev)
 	spin_lock_init(&vi->refill_lock);
 
 	/* If we can receive ANY GSO packets, we must allocate large ones. */
-	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
-	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6) ||
-	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_ECN) ||
-	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_UFO))
+	if (virtnet_check_guest_gso(vi))
 		vi->big_packets = true;
 
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
-- 
2.31.1


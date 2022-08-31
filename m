Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 691375A79B3
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 11:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbiHaJDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 05:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231717AbiHaJDj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 05:03:39 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2051.outbound.protection.outlook.com [40.107.92.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F3D3C04E1
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 02:03:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cLGVxDN0lZVFbMoW6f+LFLxqfwWMt4zKxU4yYLm7pql7jCbto81nJs/tS52OX9zEKh17K48Xwxv9kVI2TCVHY8l9FD9y39gHUgSO9vaK5NF6wOoLgXHLnT3JxTMzxprVwGD3FvAkhCN4g4nTD0+NyFtagWCiIat7zX41NOGJpgAlIpdv4nwnI+MjB4VrikgwmC6SZ39MWOQyiYnFol6yPgNG8Ct5bJPKdjbIeWOaz8LWFV8+ST0/sKng1sHnS1aUpqfCEpPwTWWsDguPO3o7geM07uIl5fOgtChuIsx1EQeuA4/9XSAm3E4Who1bpiuaGfLxs6IDSsE1eoCPZnyisw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wP590Bu0rBC23wy+9IS7M1cj6941SHg2afMEMPE1jqw=;
 b=edk6QDVmNlkNASdBhvseqV1yQFTc4C2mc46jBZdLIPsDptolk82jTDzNiVFm0Kb/xWStHQiNAj8x0+ZltYtTqQIpFkSOmfvpMJgLRWQ0YZqwbqaGy4qgWuWqV4oBNTduyVLDjAEPvjenC4GuTDId33FfVojogKEb4RcrRLTURsGza6An0cKVe9cBNQ0NHeSTix5o37aTweq5l7Pir5NO8GufTEom8A7Qa9x+o9E1xufnKZ2/SojiHgTJ3dz/C1xvtFUCsDSYwJ4N0kQwpwLir4GV7NODTXpBfZpZn2Nss0dS8BzZCrvF0jvPdDy0ewlP8QeXPc9o35dZwXOKaoBCpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wP590Bu0rBC23wy+9IS7M1cj6941SHg2afMEMPE1jqw=;
 b=UR2PDOCLLLnHxxC7a4mAUAuEjbeFX2lUXJKadFVu0LP/8FQymC7xsfN2FkDKG8qeEuL8pB1PW3gu9RGAvwudH2UJzJiMWGM3kYOqsjt96IdAsByCISLT0Xv/+n/86MHbntfWjypVOW8UQQe3Em9eAuQs8gDNYtXYtDihBlPWFTLaX2nd4p7qWvO5G/89aScbV/yHseli76rNByk6PgHg/ZDCSYoXyRKzL2wrwnDqI2x52VYb4AmZNnrys6inruMUBdij+C/yuG4oKO5GeraCcLls4yE8HEGs/hLQbY3K2NP+tczVwC2X2bTYV990YWHJRMB4YTY7+w0iiJoz4y8gxg==
Received: from MW3PR06CA0022.namprd06.prod.outlook.com (2603:10b6:303:2a::27)
 by SA0PR12MB4430.namprd12.prod.outlook.com (2603:10b6:806:70::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Wed, 31 Aug
 2022 09:03:35 +0000
Received: from CO1NAM11FT077.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2a:cafe::83) by MW3PR06CA0022.outlook.office365.com
 (2603:10b6:303:2a::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15 via Frontend
 Transport; Wed, 31 Aug 2022 09:03:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT077.mail.protection.outlook.com (10.13.175.55) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5588.10 via Frontend Transport; Wed, 31 Aug 2022 09:03:35 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Wed, 31 Aug
 2022 09:03:34 +0000
Received: from nvidia.com (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 31 Aug
 2022 02:03:30 -0700
From:   Gavin Li <gavinl@nvidia.com>
To:     <stephen@networkplumber.org>, <davem@davemloft.net>,
        <jesse.brandeburg@intel.com>, <alexander.h.duyck@intel.com>,
        <kuba@kernel.org>, <sridhar.samudrala@intel.com>,
        <jasowang@redhat.com>, <loseweigh@gmail.com>,
        <netdev@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <virtio-dev@lists.oasis-open.org>, <mst@redhat.com>
CC:     <gavi@nvidia.com>, <parav@nvidia.com>
Subject: [PATCH v4 1/2] virtio-net: introduce and use helper function for guest gso support checks
Date:   Wed, 31 Aug 2022 12:03:04 +0300
Message-ID: <20220831090305.63510-2-gavinl@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220831090305.63510-1-gavinl@nvidia.com>
References: <20220831090305.63510-1-gavinl@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d2037364-62ef-4cb6-9a0b-08da8b2faf9e
X-MS-TrafficTypeDiagnostic: SA0PR12MB4430:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vnpvSgHtV1nYrxnfjYCL1ostCiaGNlfaw3dX+3Jq52ij3xmEeTS9vFZrdk4v08Rk8Ck87oo1+Os5uuKUosHzCi60BZQLno8d/OzvMK+XG+TuEQYrZHLDNXnOEdlQxID1rlHapLwhZnUyPx1AwU91OWbFDAql2THqX2zkmHm3uNgof/OBWUn6e3+q3NfEEPc5eW7aFnd7m7vEybAMRjVOzVcmSKtWsqh3YqX/EY0VP1qc7MNEGU3gu9m2MhPIGO/nmyFxfg2co4P5X5o7x1nAJ3xymHXiiGCF1NnlqukjMpd5f2jneI+tyETEZAVJEAPcq+BJeYv28DYGpGAp2r0Bmh41MC06C7hoe+cV8Pq0N1xnE3mAg90N80dNS52reA4fXtOujqdYwiHwnMmg4V2v0qjThkUnTZLiY0e0+sxvoeZ2hf8exZKMyR4+QsvJvPJ8mF8xtRt7eg96xpowSvGLiW8qtjQ+41M+TivMTEmG5Flt17UM0U2OGvJuyhO18tFSGRFWL5KxPKIIdYB0W1zPJUfjple2RjaDfE2xOpvTHCn/aLDaiipxDS7B9LfrQPsbij8Xs4o8UPAn0cuoZS/heH8R+ynSzxHK7fMBZL6vYioe22y3d3QgS57VzKtb4o4p7pzZ4yH5vLNq9NhXal0JaZmcfCUcG1NQVRJw99kSdjtFlhFC8TI7+u/9qSrsEyfY7AJFdWx/697u6Cp6xo5E57kWsg3x2wMu59ffQGxn3N1vuBFcvphvWJ4YrRKE13L+zKJTERrYzH0pDo/1RbJjggBu+771qFq0qZpj3ztQkEUY8vLggo0bEnEL1fA8uf2V
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(136003)(39860400002)(396003)(36840700001)(40470700004)(46966006)(55016003)(40480700001)(36860700001)(921005)(356005)(86362001)(40460700003)(82740400003)(81166007)(82310400005)(8676002)(4326008)(478600001)(7416002)(6666004)(5660300002)(41300700001)(70206006)(70586007)(8936002)(110136005)(54906003)(316002)(47076005)(83380400001)(336012)(16526019)(1076003)(186003)(426003)(26005)(6286002)(2906002)(7696005)(2616005)(107886003)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 09:03:35.1383
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d2037364-62ef-4cb6-9a0b-08da8b2faf9e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT077.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4430
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F26DC5B8B03
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 16:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbiINOuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 10:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbiINOuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 10:50:18 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2063.outbound.protection.outlook.com [40.107.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA0731A395
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 07:50:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nVFocuWGJbqC+v2Z/PpYIWEw6+csg+0uKHeGKFdyK1fMOGm8B3a/2jEj/CZfEpsaHNUDK3lQ09UcdRH5SHuIssHPx0ax6TDoG+wAZIuHjWIkY0UDcELErpzWHLHJWJUndLCxW3ieE7uRPSh/FjyQ690THHWBBmiAepfGPBKaA9EJBwwm6iUrYHt/T11OKnh8bkPxLdzxWNfGfRaTh+9BekfXFu5JWOLq28th13wiDbaJtsZBN0E00JKJwwSXBgVDoo/63XbTwy/G83XrOlfXv7BITZRfw1jvlmeJArcltQMeZiC+HxnRRrE8Av1wLpQbxX5mtRLiuR/jh8f/Qps1cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fBK+xwnv+khClREf0TThCvaCu57MkGoZHI0O86YM4JA=;
 b=PQRmqRSk2CqM8FfuB4jisBazP+BxJgeLO/WpEBjvxN3hr8C1RpF47UyPqmMztobfLh3b6B/8wEfid1rOeyFU1D7ySSGWAlTHLhOFIxWBhh975xgsLuARydcY0lo7SU3YqkI32DEDDcptbi1GN79ASwxKz5p5ItroUgzuAUEgWb+UpOQeUicCtI+lzwiZgR6HTF4NzhfFCC3SI+y8cJ1irC5NmTTyOJOXReGrnT1ToNy44fes3CD2IuJIIenqVyzH7xPSZC3TWrGxNtE5REYRciC/7Fv1I5nXNTx7d7o5N9LdhBN2jnkLyE21+fKfjD4bID9C9YX3TfvJJa4Hf6gl0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fBK+xwnv+khClREf0TThCvaCu57MkGoZHI0O86YM4JA=;
 b=me3iYXLP4+VdFnuGh4m3Vayq7Hty91DoBnsbrUZODF1ITq3EYmgqoSP/RybN+kgv+148SzOBEIy0cPc04OjxkXIOsFG2SHWH6860yYTaJ0a5ae4QRjWGv5VbbBIzqpao8BlPsULoMJUyvpKxNoT+ahBjFo66AHguG/0CXD+4YTgFhyu7DhmPS8iFXu7+c/eH33URXyPldHoEX56IaKfbusE2HyXRsw5S6qlu/P181XTTCx6gUyBAMVPn+nQ7pgYA23d22QDOiCAZW4vkKgjWQsn5Xo7YHH37N1afPawq/OSDYEhcGMkrNtog6Ct5cKkULTVOP2M3xDc3+MotqsWuFA==
Received: from BN8PR12CA0036.namprd12.prod.outlook.com (2603:10b6:408:60::49)
 by IA1PR12MB7520.namprd12.prod.outlook.com (2603:10b6:208:42f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Wed, 14 Sep
 2022 14:50:10 +0000
Received: from BN8NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:60:cafe::bb) by BN8PR12CA0036.outlook.office365.com
 (2603:10b6:408:60::49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.14 via Frontend
 Transport; Wed, 14 Sep 2022 14:50:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT016.mail.protection.outlook.com (10.13.176.97) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.12 via Frontend Transport; Wed, 14 Sep 2022 14:50:10 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 14 Sep
 2022 07:49:57 -0700
Received: from nvidia.com (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 14 Sep
 2022 07:49:53 -0700
From:   Gavin Li <gavinl@nvidia.com>
To:     <mst@redhat.com>, <stephen@networkplumber.org>,
        <davem@davemloft.net>, <jesse.brandeburg@intel.com>,
        <kuba@kernel.org>, <sridhar.samudrala@intel.com>,
        <jasowang@redhat.com>, <loseweigh@gmail.com>,
        <netdev@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <virtio-dev@lists.oasis-open.org>
CC:     Gavi Teitz <gavi@nvidia.com>, Parav Pandit <parav@nvidia.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>
Subject: [PATCH v6 1/2] virtio-net: introduce and use helper function for guest gso support checks
Date:   Wed, 14 Sep 2022 17:49:10 +0300
Message-ID: <20220914144911.56422-2-gavinl@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220914144911.56422-1-gavinl@nvidia.com>
References: <20220914144911.56422-1-gavinl@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT016:EE_|IA1PR12MB7520:EE_
X-MS-Office365-Filtering-Correlation-Id: 97f038cc-6175-411c-7db0-08da96606c8c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M2EJoYPd9T988i3ZXCKE1iZnD1RUeoeEfpc1Zc+JaEEhoL7TPQ0BLnCi+Kk/V4uiBWns9oUutaHoJcBXF9ro+X5e3/xk+CKSCllvquoL8KPYObqCkfxzF73IhNCmB+P08I+TS/P+lBJNMl0oUV0CkqZDS4DfgZaDRAEhUwGsYV+ZtchQljG3xGxWa9HkkWzDT1o9PiRG2IZPO/NoOguLPctg8u1rWHhlABimib2uSp8S0CPHyE/tp7gxUjvO233BLHtR+ucs+md2TdlLrcc1bVhL3x/oClFFANswHli2+9G9eM9QiZ1KutVlXd/OXIqO8LyfmwY+6wyCozUsKE+VfTlaC8zUTOQbt3ZVdxkh56eDs1jnlp4DEcqdIAWxjq6zrJ7gWnrbWkUBfZhnbEjUAXcVIhSi6yU6LbUBn7kSLA+4qi4c2hlj5kifYYB6LgZDtRpNyG+dqt0o3o/muzc9tLwg1AubDHM0h1OdqOSZfQLx3DIDOWuJsCtX3e+QcGKKwwVYGFFWJ7Db66suGvPCRd2fx39trqfbTyva4XgNE7F78weW2vkObHtkfj2b680TB6uVE9z67EMkr6+05TcXnasixUAPodw2fITWyhZBoLN4OycFjwfk0wBKHUonCuK234qpD0OfZUjNDYdmf0tZAk2nbk+pEVSn+lSrMEfFiPP4TQdCTcW1cX4d47yxx5eNsep1JmOUR/ySEmvytiX2AJuOl8Gatn7TNOozeKVuobnX8QDjzSrj9n7y0odrh/4scdGDayFFX+M97Ay5GzkP611la3zpkuWIW3g5OKl1MXI=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(39860400002)(136003)(376002)(451199015)(36840700001)(46966006)(40470700004)(36756003)(478600001)(2616005)(47076005)(6666004)(40480700001)(316002)(40460700003)(82310400005)(356005)(70206006)(41300700001)(7696005)(4326008)(86362001)(8676002)(1076003)(921005)(82740400003)(26005)(83380400001)(8936002)(54906003)(6286002)(7636003)(70586007)(186003)(426003)(55016003)(36860700001)(336012)(16526019)(2906002)(110136005)(7416002)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 14:50:10.6332
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 97f038cc-6175-411c-7db0-08da96606c8c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7520
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
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Reviewed-by: Si-Wei Liu <si-wei.liu@oracle.com>
---
changelog:
v4->v5
- Addressed comments from Michael S. Tsirkin
- Remove unnecessary () in return clause
v1->v2
- Add new patch
---
 drivers/net/virtio_net.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index e0e57083d442..f54c7182758f 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3682,6 +3682,14 @@ static int virtnet_validate(struct virtio_device *vdev)
 	return 0;
 }
 
+static bool virtnet_check_guest_gso(const struct virtnet_info *vi)
+{
+	return virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO4) ||
+		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO6) ||
+		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_ECN) ||
+		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_UFO);
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


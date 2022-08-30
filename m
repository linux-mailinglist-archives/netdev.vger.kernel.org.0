Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D41AE5A5965
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 04:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbiH3C1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 22:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbiH3C1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 22:27:05 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2044.outbound.protection.outlook.com [40.107.220.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 792349E110
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 19:27:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FKQ4Ydpl0B56oNOfTeLF77rJdh6GBdIp5ptbKWYOUXRew5lFidJ03gHN/Z5KXx4/QlhL4iVqLrag0v/duRLpownt7B5+ADreai0iD/zIfJW5za2kMy+fEk8BBBreXtts10ahAjM+T9OtfJMrkGgmx8AhuPWKt0YP0IOywC2j0JHrzZd+M4uKFEmcuTPtWOF0BxF6TgLFUfeYUyb9U+F21pLlii2JjpyG8PgcguP7enCrLtJOgWO7UHkEwdq8EYsUza++QY1IWtyucnO8GjY7CCfU2zr2Zn12mY7n7sBix9TcjyqS7r9aXpIUMn5phbNr7OqwLSbzG0jkCTahWZIhuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wP590Bu0rBC23wy+9IS7M1cj6941SHg2afMEMPE1jqw=;
 b=MBOylBzuQSTo5WrWhEgS8iqBqlMa6AeEC3VlZSPO9kZ3bq2j5J92VM+cViOrpaoDrgqTF5YwXtRdE/AVJC8hDfV+0jpl5eUDbmPwNQg0xrFLftZ0t1ZHKBMm3CElDrO28hDBxqJQlwRx/2slGj9Jg5LcPu0m/pQVtcvVCy+bz8Mr7op2yDpQ40gBRzOMoxeQ3P6Fd/3aKCxEAJx9vql+fBaYAd6XmRFEN19I8qAomgGFFSA+oPtMr+BPhP64uAK7cuaK67YVfrlTRvZu0mf2nIGl04yo4mz0NIvuAvkQL3w1hXVAbqijRH7OI25+XsZW9nV8RufV1+SJSuSPyBYkLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wP590Bu0rBC23wy+9IS7M1cj6941SHg2afMEMPE1jqw=;
 b=B5wW68GkYY3PBQfDbRRh5SiTPLSBXgRKFdgSPq3L2PEk9K6Hrp11enzs+7Dw4RudTdAtlGWVe8YQg1heFTH/MH+o4X50Ph7HqbI48dPQLm5KJ+7nR4bQB3x+SvFYAAXf/ilSs64sktHJGkiOcVer707zPCG6tyZgmgMDl9LTPOPYOjOq6UX+22jdW87mcZeokBlgFw6O+Es4UrskdwKKpoxxzPWEnSyT6PM06/xQnlurqFTrEoXey2Uh4cj4K/MuYqSg2l4PX/wNUG155ncJMMLtGb/p3hyNXsd8ImWHMV1IfGqsKWjQgoU+Tb8GPXWXhMAWLqhe/eA6EV4g73Odhw==
Received: from MW4PR04CA0251.namprd04.prod.outlook.com (2603:10b6:303:88::16)
 by MW4PR12MB6779.namprd12.prod.outlook.com (2603:10b6:303:20f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Tue, 30 Aug
 2022 02:27:02 +0000
Received: from CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:88:cafe::24) by MW4PR04CA0251.outlook.office365.com
 (2603:10b6:303:88::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15 via Frontend
 Transport; Tue, 30 Aug 2022 02:27:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT066.mail.protection.outlook.com (10.13.175.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5566.15 via Frontend Transport; Tue, 30 Aug 2022 02:27:01 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Tue, 30 Aug
 2022 02:27:01 +0000
Received: from nvidia.com (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Mon, 29 Aug
 2022 19:26:57 -0700
From:   Gavin Li <gavinl@nvidia.com>
To:     <stephen@networkplumber.org>, <davem@davemloft.net>,
        <jesse.brandeburg@intel.com>, <alexander.h.duyck@intel.com>,
        <kuba@kernel.org>, <sridhar.samudrala@intel.com>,
        <jasowang@redhat.com>, <loseweigh@gmail.com>,
        <netdev@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <virtio-dev@lists.oasis-open.org>, <mst@redhat.com>
CC:     <gavi@nvidia.com>, <parav@nvidia.com>
Subject: [PATCH v3 1/2] virtio-net: introduce and use helper function for guest gso support checks
Date:   Tue, 30 Aug 2022 05:26:33 +0300
Message-ID: <20220830022634.69686-2-gavinl@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220830022634.69686-1-gavinl@nvidia.com>
References: <20220830022634.69686-1-gavinl@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3b3f4b7a-8f20-46f0-c463-08da8a2f1f58
X-MS-TrafficTypeDiagnostic: MW4PR12MB6779:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GI4EM9BzZ+M7P9k5prPK/L9wF8aIDtLHO0/smkZHAhH3caWkyI6D/jJz9U/M0TIwUAhxukSM41H3j8CvXaGhP0XtljbawflZhJ2C5HprtKcrgSkzsWpsx6y8ZGEMwU4oH5CK44PC1LvDr80ndVQl32HxxM2DIjaxYlc4eYH2mcsFB8xEwV6I3To8JLA7alDSgkIr4iDeWDxk+NySRBaHg85YC50dhiuwVDrWUKgCoyCRMU94mkHu3CvJzontdxYJxbKEKbVH4XuhXRY4+VCCxZvtd6ovjWy1aA2Czr8GMW6OJzDDIb9Y1Q0SzPF8xVRYIiQScdNiPfFuEu5AI8996WJ1+ThzQYBD/7lR6+Mf/TTDYyw+VIzrfA2xp0iCPNFX3szNBLxLWfmaBgeMMaoOrHZoH/zNFWataBC4U/W/qxjPAq2xu35mATgqrb9C1tLhA3M7VdS9s5MR8u1fNLABcu69dapjM2p6zU3bCdCUf98nrRg9uZTEmk7G7NnGxIuHvs7MveNXGYsvUT97/4RH4ltzVAWYHIkldQ3qsnaH4cJwE1jxSI62S4ujTS6U5GuanYBHMhiMK+l5+sxWUeXJgzZx1zp3nji5mh/fEvn7ZAMt+AOGVKpRwEkG++YPR3+MLiAhD4qtiVkEhKlFcUzPn4jjA00KUDWkhZU0UkCQzjq0vndXN/TcI6BbeVe6E8zcDQkt3YXx5KgYBLjqHki0eH2uGSdENn1UlOEcAHcgJ3MCN+ILoG9Stb+GA6JupJSVjvs73YRHbrMEfPxc/SNUdTax2sKshSf82nQqeyE67WGR7fc+YOsQ2F2vIyNUbgYX
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(136003)(39860400002)(376002)(40470700004)(36840700001)(46966006)(82740400003)(6286002)(26005)(7696005)(6666004)(82310400005)(2616005)(1076003)(16526019)(40480700001)(55016003)(426003)(336012)(186003)(47076005)(2906002)(36860700001)(40460700003)(83380400001)(8936002)(54906003)(316002)(110136005)(8676002)(4326008)(70586007)(70206006)(107886003)(7416002)(81166007)(356005)(36756003)(41300700001)(86362001)(5660300002)(921005)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2022 02:27:01.9259
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b3f4b7a-8f20-46f0-c463-08da8a2f1f58
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6779
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


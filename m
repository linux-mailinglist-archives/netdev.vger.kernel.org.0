Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 369A85B8B01
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 16:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbiINOuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 10:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbiINOuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 10:50:15 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2043.outbound.protection.outlook.com [40.107.96.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1BBC2E9E5
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 07:50:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZsRlm2yUE4nc9hhJLErc7fSc2gmTd+gTek27xlmqsR9Kf74hCuUCqxqh2c0+9sJLm0CEPHYy+w+0u8T6I+y4O3i89t1fBBEMnEQruCeeuu3fEvgbePChm8ilI8rDmUuDPGaDfUe8iznvau25vCck7u9idWZD6ToDc+e9GIwi9qWuRqAWqu31WJrG5RKnnqidGkORna6yB5dth0yh688WY4V28pQhAFXBcCsiS2qSxIPk7flEfcqEfrNIGBtaJ82b1Vw3CDCAUh/O1sLGwFj4gbJa7/mgzKfahMwxBBRHZvgd+KUNna3gtRjUB2ta3umDJwFq0V0UaJI5TmbMQ54q/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2OlQeM87hPEkYVd8N93zK6McVDJOBYHEkTT9Hhm51xI=;
 b=MSQhm+5TNtdZs4Tq0bYi8rXZsL5oUag9ldRX/iLbf4gYjIlhybhWBCw+dMlOt11/crapehA0Wb0oKLfb8zEkQtQ/Nykl11YB5PjEk6Se57nrkWI+BaY+gNDPvpCe3VU4yTVXUv1zvqIjjKgGrBUWCcRSAGOI4JPU/Vzzrt3LkalCqDptSnrFnP5RnkUBFD1cRF4a9sVNIRWBW8fdRRspkslmI2uak2ZrfjFeVAJSSTrrtOHF8VyyQciqCLHj9SFCIZzgUigf8IXI/CN5rbg7QJH/1V24E0YCHwGauvf08YBaG5+hvfpGqsDuB7rPD12wIiKaiXK9eAqCZ0cvO9P4iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2OlQeM87hPEkYVd8N93zK6McVDJOBYHEkTT9Hhm51xI=;
 b=HyMZfgwe7tMMPeH80jIO3RZbZQlhQvUurhYnuWMq/LXpMRCc8jFLnf94pQ+YddkpL4sOGfxOiKw3AeHKmkhN2jf0ys3TzUvCfY21RrOQXoRViL/5zEH9oQTQ37nBEgkj4OW+FbAdGrSGJbMXGm7VojcvQrMwHzkGys8L1dY4Hl6VsdeCgCVp/rp9zb+1OFzdjMrCNEjAJfISbtmjLcIkKiaxc0HgEjNstQBqqKE8qp2NQWzU7hpEYaarz3PQW2lLP0gPoV55xmzxNikX7KWaZaaewE2F6M7LpSW+HtlbI6/BYJSCfcLE5+Vcbyym0lMNv7HVFLv8y1FnGq2YZO94NQ==
Received: from BN0PR04CA0082.namprd04.prod.outlook.com (2603:10b6:408:ea::27)
 by DM6PR12MB4315.namprd12.prod.outlook.com (2603:10b6:5:223::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.20; Wed, 14 Sep
 2022 14:50:07 +0000
Received: from BN8NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ea:cafe::70) by BN0PR04CA0082.outlook.office365.com
 (2603:10b6:408:ea::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14 via Frontend
 Transport; Wed, 14 Sep 2022 14:50:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT059.mail.protection.outlook.com (10.13.177.120) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.12 via Frontend Transport; Wed, 14 Sep 2022 14:50:06 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 14 Sep
 2022 07:49:53 -0700
Received: from nvidia.com (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 14 Sep
 2022 07:49:49 -0700
From:   Gavin Li <gavinl@nvidia.com>
To:     <mst@redhat.com>, <stephen@networkplumber.org>,
        <davem@davemloft.net>, <jesse.brandeburg@intel.com>,
        <kuba@kernel.org>, <sridhar.samudrala@intel.com>,
        <jasowang@redhat.com>, <loseweigh@gmail.com>,
        <netdev@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <virtio-dev@lists.oasis-open.org>
Subject: [PATCH v6 0/2] Improve virtio performance for 9k mtu
Date:   Wed, 14 Sep 2022 17:49:09 +0300
Message-ID: <20220914144911.56422-1-gavinl@nvidia.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT059:EE_|DM6PR12MB4315:EE_
X-MS-Office365-Filtering-Correlation-Id: b7ebd390-b18b-40ed-f46f-08da96606a5d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rAo0w5DsvXK2t5SGV6jGXlAIK6qHC1nI53+ff+jCEGL+Zg6PCL6OvfNHI6Py1Im4YdOTfsVp55fhP0jQtgy9/qtY1LdmVetzABjTXBZcPqXteB3iBsMPAU4QQcy+i7Rt6y6p1tGxrZMAM/ndTNGBkPfb1p2X0/OS0TI18ueTfn1QZE9BEVZQXdIXwk4Dq53SMQ8Aoft7bwxBBk3I8+p0qfNm+nXgZ9rhh6QCRVJmo6zQYI7zyy1KJZleRQmGwZRqWWIEiyhoaLtgWL5ELZW/+g1SkPHf1l+88IMO4TpPE4nZa/KHxwC0lh1IMjHAZrtmtcN1jWOH+yJyPHdSznui8A9hDWd/xCjmPPLjpKnGrPfwlfNhH98oDpXSY/lrgkdnxA4QEn1hxeA47Yq5CjzvTDSw+iC13Aoyqy3fRH1WlHdamYQaEQDG9vCgUFTY02B8n0jnMfdJgtfwQhdhJ2JKlGj0A2tOKMu8V0ZDNT7unfu1AdEJKhRXgndt6l9PHuY3H3fEtyph8Y6NGSpGH1WmwnAWZktFE2ZYKPQrSs9ibTXdvei88Ycr9XLlt0TmFXZnllD31nYO0xB/ZLBr7+tFvQ8fMMeu7PD7nSBUTXoM1thziUYqbG6SUQ0Ni3B2bX4SZmuRxskX6NL1UaSC4YZlCJWwEHw0fcCp6mjL8lObARFa61ughvSV+Dj4eORAS32v8GMfQZ9HvaGxE4CF3mtkPJNqMHC3zOFI77uJngXp+zcbfQI4kVxBNwWkqSpoLGHkSilXzE0C4LP/QlMDC+trnN5dXoI45ICTZ06y9zbeDsk=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39860400002)(346002)(136003)(451199015)(46966006)(40470700004)(36840700001)(8676002)(1076003)(86362001)(7696005)(40460700003)(2906002)(110136005)(41300700001)(8936002)(921005)(36756003)(40480700001)(70206006)(478600001)(316002)(82740400003)(5660300002)(2616005)(47076005)(6666004)(55016003)(426003)(6286002)(83380400001)(70586007)(7416002)(356005)(82310400005)(26005)(186003)(336012)(7636003)(16526019)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 14:50:06.9884
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b7ebd390-b18b-40ed-f46f-08da96606a5d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4315
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This small series contains two patches that improves virtio netdevice
performance for 9K mtu when GRO/ guest TSO is disabled.

Gavin Li (2):
  virtio-net: introduce and use helper function for guest gso support
    checks
---
changelog:
v4->v5
- Addressed comments from Michael S. Tsirkin
- Remove unnecessary () in return clause
v1->v2
- Add new patch
---
  virtio-net: use mtu size as buffer length for big packets
---
changelog:
v5->v6
- Addressed comments from Jason and Michael S. Tsirkin
- Remove wrong commit log description
- Rename virtnet_set_big_packets_fields with virtnet_set_big_packets
- Add more test results for different feature combinations
v4->v5
- Addressed comments from Michael S. Tsirkin
- Improve commit message
v3->v4
- Addressed comments from Si-Wei
- Rename big_packets_sg_num with big_packets_num_skbfrags
v2->v3
- Addressed comments from Si-Wei
- Simplify the condition check to enable the optimization
v1->v2
- Addressed comments from Jason, Michael, Si-Wei.
- Remove the flag of guest GSO support, set sg_num for big packets and
  use it directly
- Recalculate sg_num for big packets in virtnet_set_guest_offloads
- Replace the round up algorithm with DIV_ROUND_UP
---

 drivers/net/virtio_net.c | 48 ++++++++++++++++++++++++++--------------
 1 file changed, 32 insertions(+), 16 deletions(-)

-- 
2.31.1


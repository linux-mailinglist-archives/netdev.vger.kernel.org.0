Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00E9A5972F3
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 17:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236797AbiHQP3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 11:29:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235568AbiHQP3C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 11:29:02 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2056.outbound.protection.outlook.com [40.107.220.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DC7058B4B
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 08:29:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WRF8tSuKbFH1FMyNw0Rf5myGJUD20KJYgzAUSIgPQ9SRodm5lCGfPjGqaILgTUPi6kV+qSjofl3GCaeAnbVYK34X0n2sWwK7TDQpZYrcd0kLtkY0+lIMk72OKky2FR394WYIl1Fh8dgUW7X5Qq1gI66EOJtbwz2r+2UAQGCpU+vrcoPKFedF6uM54A+lcv42Y32JIgw9wo9Em5pgHSI+7YVN1ICs630goXIzwFAF6lDvW/RSnHZyFLD34DfZAR5imOsCLTBesLNwTruTLTvgwVeRozHQk6DmU/jpS0wuUzSfhs2lMbqO5jXR/Y4fsFS9UeHi3Pqq+jqkuy63Wx41tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WRTosQOJw84glQZF2iKA2eJu2v67XWgpS1PDJ2Zx/1s=;
 b=PKKVZlzMbnoWEKMsx42vdb5Tf4IM1mceWNf+ZTqEMSnDXPIFgau/2IEy0gb2JOrGSYedzJpaSbXEREjLjoSOfMKC27b8OHsLWovDietUYjd5W/AYfKQuKZfMFm7kEe4PCn3S4kEjUA+z+kLxZUTqPtZNgwbquyNKqDMLzzX+JEco7aHFcpA75KgZgLrxOX6HuSthqNa3SVvvDHQC+1757a116jhjIuABwTFOq9sExv9MSVmq+/vqPLu4/InGozv7vo1jl1m0kYsE9+DskB40mWdbH9YCQcyk5izKkeINhKUnp4ZcCfQZMUk66zFlDWfsOim7HOlcXXFjQKwJm8MjOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WRTosQOJw84glQZF2iKA2eJu2v67XWgpS1PDJ2Zx/1s=;
 b=UmBOaGcfUQOegPPpkXefMhi+PZKdWx5Fxwu0WIBqsx9fE3wAuB7J55eLQ1IBT/6ZX8f8DDJflxE6W0U+9NEIFExX4y0pMSxT9tJJnen67skCgS/a/q1NAObun+ef4DpWXbWlEuM79hARV2HakuuV1ptyEhXBRSdZwTi8nyr3g6T9eGYgXIt//+b4gu5hYVg+WXhXy5lCImpMsFzNEDHDJiH10y89RcapeqWL5BF/rzIjch/+rz7Efue46d/BzRK6i1iyBo3R12TAjwIzTmjbmbgzuEmyHPHSlhKEveiYG+HIkoTFKxiPeStghBmvqfyynur31aCFjjdl2Kjkg9bzDA==
Received: from DS7PR03CA0247.namprd03.prod.outlook.com (2603:10b6:5:3b3::12)
 by DM5PR12MB1177.namprd12.prod.outlook.com (2603:10b6:3:6d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.19; Wed, 17 Aug
 2022 15:28:59 +0000
Received: from DM6NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b3:cafe::ed) by DS7PR03CA0247.outlook.office365.com
 (2603:10b6:5:3b3::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.19 via Frontend
 Transport; Wed, 17 Aug 2022 15:28:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT013.mail.protection.outlook.com (10.13.173.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5546.15 via Frontend Transport; Wed, 17 Aug 2022 15:28:59 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Wed, 17 Aug
 2022 15:28:58 +0000
Received: from localhost.localdomain (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 17 Aug
 2022 08:28:55 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
        "Shuah Khan" <shuah@kernel.org>, Petr Machata <petrm@nvidia.com>,
        <mlxsw@nvidia.com>
Subject: [PATCH net-next 0/4] selftests: mlxsw: Add ordering tests for unified bridge model
Date:   Wed, 17 Aug 2022 17:28:24 +0200
Message-ID: <cover.1660747162.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ccff8542-3464-4c81-b910-08da80653527
X-MS-TrafficTypeDiagnostic: DM5PR12MB1177:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3C0I5nHPiahrqkUmJDa+jOjxE/Dv/WBvUxHCr12lb04EkS7yIE42zGoe4p2QHQe+dXHheoKFsnjotFX8oul8ysw+oaEwGg9Dm10NcECh73z3EMkuy322sUsc7RxPKPKPdDUaIfR2Kw0UZGsSMn4FaXBtjqfqepD4KzvBB5U1XJGu/SxK5TT1TtaIRIHoCZb07a7q+0O5/iVdXGYxe4yDkJNjmNzyhr7FEbCwEPl0TRUlhuE/8GtxidEJosnCFsQztYJTep5eu/AYwAKG9MTvX9u25KMDu3ouRNUkgSTZYDAOPl3vf74PuKqvrnfYJQTSJecxO17lRzbhFiFJcE5xIe+p7PyxeIN3VQSV3UBhpHgdFqPQ3j+ZW6Pf4lyujuShWpsl8n5gI+0wm1ibokKtq3yMqs4+A2ImX+qi4NlHOCafaYGzQIKRjpAOn3ML4vWpSj/vduFBUAU4wdiX7cy+2kOlTMmxPOit5PY6qORz6qmhdHi1oKfArh4djLBdjPnxqfrPp/2b0WQ/xz6zD/YIPaF4yaKA2HO179xjwDz6NY58haz13YyCIdCJiOP+dGN7BQCGUVz+pFdFPxAM3CmQP+cLUpQ85vzKjbjQamO0pbKdWh9eFqWUCQBNrIrfIPFs54vi190H+U5nW29QwOo9pa33qRsfso2aZGfZ8Ciymj//mDPHgwmVu1/WNVQxF+38XdyTXL3k85SL3Cwp5DowwfEQYBr3Q7I95ye0WH13qwPE9aV/NM+jVkU4GASd9zUz4tIyCaRdmRusk3ZVL1tHaHCSYJUKyXWvbz2FK9Gg+YGZNl1NYLzcd6BeqIzzq+pDdrh7tuz+6lWOFnzKf9hBGQ==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(376002)(39860400002)(396003)(40470700004)(46966006)(36840700001)(478600001)(40460700003)(41300700001)(6666004)(26005)(8676002)(40480700001)(82310400005)(2906002)(86362001)(36756003)(316002)(54906003)(110136005)(356005)(81166007)(186003)(426003)(2616005)(16526019)(107886003)(47076005)(336012)(82740400003)(5660300002)(8936002)(70586007)(4326008)(70206006)(83380400001)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 15:28:59.5225
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ccff8542-3464-4c81-b910-08da80653527
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1177
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

Amit Cohen writes:

Commit 798661c73672 ("Merge branch 'mlxsw-unified-bridge-conversion-part-6'")
converted mlxsw driver to use unified bridge model. In the legacy model,
when a RIF was created / destroyed, it was firmware's responsibility to
update it in the relevant FID classification records. In the unified bridge
model, this responsibility moved to software.

This set adds tests to check the order of configuration for the following
classifications:
1. {Port, VID} -> FID
2. VID -> FID
3. VNI -> FID (after decapsulation)

In addition, in the legacy model, software is responsible to update a
table which is used to determine the packet's egress VID. Add a test to
check that the order of configuration does not impact switch behavior.

See more details in the commit messages.

Note that the tests supposed to pass also using the legacy model, they
are added now as with the new model they test the driver and not the
firmware.

Patch set overview:
Patch #1 adds test for {Port, VID} -> FID
Patch #2 adds test for VID -> FID
Patch #3 adds test for VNI -> FID
Patch #4 adds test for egress VID classification

Amit Cohen (4):
  selftests: mlxsw: Add ingress RIF configuration test for 802.1D bridge
  selftests: mlxsw: Add ingress RIF configuration test for 802.1Q bridge
  selftests: mlxsw: Add ingress RIF configuration test for VXLAN
  selftests: mlxsw: Add egress VID classification test

 .../net/mlxsw/egress_vid_classification.sh    | 273 +++++++++++++++
 .../drivers/net/mlxsw/ingress_rif_conf_1d.sh  | 264 +++++++++++++++
 .../drivers/net/mlxsw/ingress_rif_conf_1q.sh  | 264 +++++++++++++++
 .../net/mlxsw/ingress_rif_conf_vxlan.sh       | 311 ++++++++++++++++++
 4 files changed, 1112 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/egress_vid_classification.sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/ingress_rif_conf_1d.sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/ingress_rif_conf_1q.sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/ingress_rif_conf_vxlan.sh

-- 
2.35.3


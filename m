Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7E8548EFA
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 18:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358883AbiFMNMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 09:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359276AbiFMNJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 09:09:45 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2089.outbound.protection.outlook.com [40.107.236.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 395EA222AE
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 04:19:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gltVqxLkCurfYLkHXyBUtKq7vKhx42xIaU8IvA4b7x63CptAWX2ysGDzMEecLyMUYSz0V0cInMST8CR9mG+nys+Ed6H7E+FouHF+EH8k03ntMCq1ZBuBwpFDdU/tVNIhfXjFMeQCKTjW2nIdd1Auwt1ZMTmhx6m7Ml+96APMycdwlTxEcyQE/xX2+zboKTnICpmYUIziUn1Ozv0m1+fw8CS9rMhowweT6AZXnD1cexY3URrYXZmIPJCTh7zE/Uv2jTfx6O1odoRUfV00cU5teZDM4j8JU0dcGLFr3UwWVSEYYGasHJy6T4pCtqburIGrNy2x+xNpc7dToUtrNfrk1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BNt7dFe4Xki9bh2o/ZjGu8DdyMoDt2H5LQvBmG1eMfw=;
 b=BXO81v8adjHaIhbvkl4RwsACuGyJegV1JK0BxsWJXOO+0A8dyzZPc4UhVcV0AAXg5ihLgSjcw+3gX+fi568Khmgqg5Ngi8OhW5htqIhGQIKrCVXNjI7gYcEUzysUNJnTcl6iD20ppy7D4KVJ2P+C8g8ir3wUAP9Bq+ANlW3/J5RHNaVyyzjbYc222Oxr11tmpsayZ+DgDnn1ORa/isfuZ13C9IIl6m48q/V+Tjq5BoSLyc2I0EFFuSSZIqjOLYfAQRDNqJuZQugKBUUXefnJ2Wbg5BAAXhKb6J94umcrZ9RSMJi7p+eA5q9UKiBOf7sReCDAdKHzqwR3pVHFAE+6Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BNt7dFe4Xki9bh2o/ZjGu8DdyMoDt2H5LQvBmG1eMfw=;
 b=uIjEbkIZ+uugh8pytMJeeX6D3RVyZJTxaG/6UMuk1QRHMky7U6KxlTyyaykM31zwQ2CinXiWdS6TbSBbsvRZRhUPQlIUDkDwQ47ji+3eNccIUhP7yk+yXcDBD8ayPcGTeAPjXVqj1XRvB5i3Nixeo/ygzOUw3/7pIiFnvNJJjXO/x47Ao9twVvBOKLyrseUj551efKC5pJw4ugpMp2RlwflrR3O85BxsWT4FNpOILvqzmF0Xt6YdJcx9wWZc4qRuk9dZ0mAJxLw6QJsTaAkOCA16SHNEgLhnCVDMHy1i+sKZGkq7D1SVScKITGXShejFniUwVYCIML/v3yaka5x+Fw==
Received: from BN9PR03CA0756.namprd03.prod.outlook.com (2603:10b6:408:13a::11)
 by DM5PR1201MB0202.namprd12.prod.outlook.com (2603:10b6:4:4d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.15; Mon, 13 Jun
 2022 11:19:48 +0000
Received: from BN8NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13a:cafe::f7) by BN9PR03CA0756.outlook.office365.com
 (2603:10b6:408:13a::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.19 via Frontend
 Transport; Mon, 13 Jun 2022 11:19:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT017.mail.protection.outlook.com (10.13.177.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5332.12 via Frontend Transport; Mon, 13 Jun 2022 11:19:47 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 13 Jun
 2022 11:19:47 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 13 Jun
 2022 04:19:46 -0700
Received: from nps-server-31.mtl.labs.mlnx (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Mon, 13 Jun 2022 04:19:44 -0700
From:   Lior Nahmanson <liorna@nvidia.com>
To:     <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Lior Nahmanson <liorna@nvidia.com>
Subject: [PATCH net-next v3 00/3] Introduce MACsec offload SKB extension
Date:   Mon, 13 Jun 2022 14:19:39 +0300
Message-ID: <20220613111942.12726-1-liorna@nvidia.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 86e6b60b-7e05-4807-b4a2-08da4d2ea04a
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0202:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1201MB02020FAEFE817C18D073A88BBFAB9@DM5PR1201MB0202.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PKfEtgaU3hpX1ue58oDdyA1D6JQraI243bvwMwwhzOeh+5v2r35HTo27DtvtwkQHtwVMNIDJi3S/ZhPY4UBi3D7S9rPioMtw7uHdI/3SI3LuaKizwklxh9/5wG/7bH5tgIGBGHT7/7kpk/VvBMBHrrD8ABv1lesn40Es7v86vfD8du7rgmhUldRceUsEbJtys9p5bXwN8Vv/m2keaUAbp28ZONGf0QeWkJiDbTgYCvlzZFL33Z2OZXVJDszAZVs0Y1szUgUzGIWZtZ1KnRiztYghNXszDCXn1hW61YjmZkebGgjJBDna/apwPJYJBCWV6XGu0CBJnIHS9gxkf6fLfOyFY+J2aBRkEJVVSIU6EvHX4JBmR+3XUtURjb04K692CxNY/vGa/CJEKeHCnHC65JFsV61cfRfnlg/x78Be3WOkPk8EFxWZHc6bJFK5YRZgOmqccDZOncEOPZBYZi9+7iESyUI590JKe2N152qlnDj/Iy3g+gAiD6mjwwvsHPGb7hig1mS8W6UzTMTIlVbKX1DqLrBl4Tcvhn+xmiC6pgJ/X/fEMLxrlObb2MSHukIGZmAIk3HaqtT9NPNAafxPR6t1Pxfd2cMSnAOpNVycWalqxakq38oxJzNwFlQw43pKy4fX4EC/Wv/734qlNPW/4iZlSkIaNzFpTc86NgTi/Gur7ivfhLQlwT1xRgENufW1FSHVsUeKTlHUTaGQ2255sg==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(36840700001)(40470700004)(46966006)(82310400005)(81166007)(86362001)(508600001)(5660300002)(70586007)(70206006)(8936002)(2906002)(26005)(40460700003)(6666004)(36756003)(8676002)(47076005)(356005)(110136005)(54906003)(316002)(83380400001)(186003)(1076003)(426003)(336012)(36860700001)(107886003)(4326008)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2022 11:19:47.7556
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 86e6b60b-7e05-4807-b4a2-08da4d2ea04a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0202
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset introduces MACsec SKB extension to lay the ground
for MACsec HW offload.

MACsec is an IEEE standard (IEEE 802.1AE) for MAC security.
It defines a way to establish a protocol independent connection
between two hosts with data confidentiality, authenticity and/or
integrity, using GCM-AES. MACsec operates on the Ethernet layer and
as such is a layer 2 protocol, which means it’s designed to secure
traffic within a layer 2 network, including DHCP or ARP requests.

Linux has a software implementation of the MACsec standard and
HW offloading support.
The offloading is re-using the logic, netlink API and data
structures of the existing MACsec software implementation.

For Tx:
In the current MACsec offload implementation, MACsec interfaces are
sharing the same MAC address of their parent interface by default.
Therefore, HW can't distinguish if a packet was sent from MACsec
interface and need to be offloaded or not.
Also, it can't distinguish from which MACsec interface it was sent in
case there are multiple MACsec interface with the same MAC address.

Used SKB extension, so SW can mark if a packet is needed to be offloaded
and use the SCI, which is unique value for each MACsec interface,
to notify the HW from which MACsec interface the packet is sent.

For Rx:
Like in the Tx changes, packet that don't have SecTAG
header aren't necessary been offloaded by the HW.
Therefore, the MACsec driver needs to distinguish if the packet
was offloaded or not and handle accordingly.
Moreover, if there are more than one MACsec device with the same MAC
address as in the packet's destination MAC, the packet will forward only
to this device and only to the desired one.

Used SKB extension and marking it by the HW if the packet was offloaded
and to which MACsec offload device it belongs according to the packet's
SCI.

1) patch 0001-0002, Add support to SKB extension in MACsec code:
net/macsec: Add MACsec skb extension Tx Data path support
net/macsec: Add MACsec skb extension Rx Data path support

2) patch 0003, Move some MACsec driver code for sharing with various
drivers that implements offload:
net/macsec: Move some code for sharing with various drivers that
implements offload

Follow-up patchset for Nvidia MACsec HW offload will be submitted
later on.

 drivers/net/Kconfig    |  1 +
 drivers/net/macsec.c   | 45 ++++++++++++++++--------------------------
 include/linux/skbuff.h |  3 +++
 include/net/macsec.h   | 27 +++++++++++++++++++++++++
 net/core/gro.c         | 16 +++++++++++++++
 net/core/skbuff.c      |  7 +++++++
 6 files changed, 71 insertions(+), 28 deletions(-)

-- 
2.25.4


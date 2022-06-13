Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80F80548A06
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 18:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345759AbiFMMlE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 08:41:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358872AbiFMMkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 08:40:36 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2060.outbound.protection.outlook.com [40.107.220.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A45D5F8D0
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 04:10:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h/iggnLrfFONxE3oW1FdhJAv5rwtZ6uYSyJxQljUYTvVHMcl9w084Wkz632IfSZ6HHgUOFNbH8R9Sd0W84BGdnEZANUzbIFe+RBZF4X4Gkx39RZQCdikWIZ2bazgDEQmx+YUqu17jLojc7McTKZaSkMEeWAxilxd3MPI0Acud8z4i0VUsJ+fJBHBr/uFBLMsf7lR4musBOGENf++9u1hL63yJkMwjy5zqzw5OfNuqVSjvA4LKe1JIlNnsopIKEG+1IdBU6JQKI7WyjLBYpWCuggGPbkNt1CUArHkgbttwP6l0+/LldQi2n7iUhZAIeH20HztW74MGBfAJ21kP9aYWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BNt7dFe4Xki9bh2o/ZjGu8DdyMoDt2H5LQvBmG1eMfw=;
 b=EMFJD0dsTiUVee0SuhYCUqWDLuOHyB5uPYMNRXkWh6FT/yaBBss4TbN+JRN9k8LGDYl4QaGRHUvhyprB4jRnv6ynMWH7ed4NwfQa+6ctKN1QL7FWVrPAfYDXKMMjTcTYJiOQXK8jcOWR6vuPTpsP16TT9UarDB0i41Lb4wEoNjZ/aWxibPGMkLScKRg6rvc7UPwOa7aMm//UNOrPjdF01EVW5MfPppWctMyZrtI2feLCq7cenQ7nfaq8cz3Sjn+8wFkGVnvAJWEsDfTqxyN+TldeWTAnjHIO/mGqSsqalJ4yR3IMyvIpiHfn6WrQdvrnU4krWoB74K0Xor/FHN2Erw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BNt7dFe4Xki9bh2o/ZjGu8DdyMoDt2H5LQvBmG1eMfw=;
 b=PXs1UDzMAUkwNrSkv4BBXikb+A8NLxFBWC+QoOopddGaM3Fa25HycQCcUdrX0Gs/0id0CM47FA99KXy6miJ9P0XFAKeAwfkCq/+nv704Hu0yZNgbijZbD/9Pa7+vj04Q0oUPvtxD8Ang6dlywNmZZtb0mUpHX31w6D/dbVbg/X7Epz4unRl3efWP4NFFBL2xY45nrKztOMUqIY2xxzujWNQ03IQkD+gcwYR72ngN3NlWCJXRgoW8v0wjMmTtG9+7O3wEq915cS8MrFoYddeGsYves7o3l4/rsgUi+p1yeARJbDtQKlKqm79kZ0V74sb73xvLEMm6wKplOlRFb++5kg==
Received: from DM5PR21CA0065.namprd21.prod.outlook.com (2603:10b6:3:129::27)
 by MN2PR12MB3789.namprd12.prod.outlook.com (2603:10b6:208:16a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.15; Mon, 13 Jun
 2022 11:10:22 +0000
Received: from DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:129:cafe::4b) by DM5PR21CA0065.outlook.office365.com
 (2603:10b6:3:129::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.6 via Frontend
 Transport; Mon, 13 Jun 2022 11:10:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT025.mail.protection.outlook.com (10.13.172.197) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5332.12 via Frontend Transport; Mon, 13 Jun 2022 11:10:22 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 13 Jun
 2022 11:09:51 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 13 Jun
 2022 04:09:50 -0700
Received: from nps-server-31.mtl.labs.mlnx (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Mon, 13 Jun 2022 04:09:48 -0700
From:   Lior Nahmanson <liorna@nvidia.com>
To:     <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Lior Nahmanson <liorna@nvidia.com>
Subject: [PATCH net-next v2 00/3] Introduce MACsec offload SKB extension
Date:   Mon, 13 Jun 2022 14:09:42 +0300
Message-ID: <20220613110945.7598-1-liorna@nvidia.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4627a9b3-fafc-4951-49d5-08da4d2d4f1a
X-MS-TrafficTypeDiagnostic: MN2PR12MB3789:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3789FDA7FDD21B5F17D98715BFAB9@MN2PR12MB3789.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U2oCzWW27KCjt5vLLMApcIah0SW35Wo1op9WXw5dAdu4A4pEte4OngZObR+TNIHEAjgy3/YxX1DV8XmW8ilWvBCR/KfoIsH7Jb6ewSfz5cZgefAYvQ/8+gcl5fdH1PMtBcio1byetktuyFxzzF+jh9xtULPLOoeHrZejJ38L7YOu2Pp1axxpmDHfDBmGhuAVMR2PWBDeasd3169+skJ7FhKefLvgPRH38ggNQ823TYq9uFp0i56g7XoulqcmnvMT7Hn9MHKpIlmjXKYSoIQTum55G6v17neZ+7RY1T9V2g7PqXWMkiH8bnfxuLA8XCP3dEA5r1buy8SKpRLOC8XJfJjngdZwlPoQiWwU0/dE0gTZ57gku0kIM3Mm3t8tDipTaUg8iJikGZYkNnWICBPhHk691GGeAx3j8YzZPPUzhEd9oit0//w30UwR8ceRK7c8QKDkSeGwTM5jxe5r+4q9v4wNY28WQuU8w4z2m3+Tn4+m80kcmq/gTyTrRSUtqYChUvm+FVxrhyur9/eScniEEmWo35BxQn2o/to4JHrhtu4FOb7qKnjRk8Jak+p1UIpi0cjD8vFiTk8R953/BgAgnLI7CsR0KxNI61WRL9MA9BQn0KVGaxC/9wbZ90Dcdi7OlytEjUxuVZtrshm7Fb0A+3xr2eL5Bp4Z/fnDkU24YByCCGYhCt6f4zhw9LgR+A4iOF0sloOAqP57RbWqvPhR2w==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(36840700001)(46966006)(40470700004)(81166007)(70586007)(356005)(86362001)(8676002)(8936002)(70206006)(110136005)(54906003)(508600001)(4326008)(186003)(2616005)(1076003)(26005)(36860700001)(107886003)(47076005)(6666004)(336012)(316002)(40460700003)(426003)(5660300002)(82310400005)(83380400001)(36756003)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2022 11:10:22.1086
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4627a9b3-fafc-4951-49d5-08da4d2d4f1a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3789
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


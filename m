Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB18E4BEFB2
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 03:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239337AbiBVCxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 21:53:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239327AbiBVCxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 21:53:16 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2061.outbound.protection.outlook.com [40.107.223.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5905025C70
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 18:52:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UJgJzyhNQtLRTaTlE6QwZ5Y/QzqkYesnCYdMw7uVLUgGHiyuTIJwGEaOTL+j0EKUkFtsiEIEkKNPjbrB+UOV/iy3oexakEncXtk4HkDSOR4Zb1vd9B74IrkI4nuQeHdTAD05qZw72v6jSw7KN9r9/Wh5Wpb3l7uTC+wZrvyq6BlLx5sg0C0dJp8yDpFcO3KrGm8TK/QFbT//8oIqJ70EQZoudcZvopARC1kJuH0T4pveM2yZhHp4Ki2pGKhwDj0plaitZv63ZnaFc/Mtq5Av3XXCqOfVqIZDSzeWd2eiCvaF4vpt39jSlrCTYyBIunzR6SrTtmK9qzFII+unsiB6zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h3LZU2GzwEcwk+BBQ0BgNkXocbtLfkxu8V26nhdxni8=;
 b=RZC68q1K4QBXG7vdyVV+vzlYtL3r36PcJBAakePJK20Jd+Vqc/OVw5v1sVUXobatKXF12KRRxDi21wjYRJ4NloIcrwY/lElMmS/Z/TqzVkp4/KiuR07tPRWeQAXo2bUXmRp6r4wvBhl+LQ87sjygmv3xuGkZ6hj24y4x5hISg/8Y7S9FCt6raOaPMcvGYiZfDF2tqaRfSU3N361q/FcYRW1vsrM4zuObM69G4Jo5hlOAIKBfDGqRCfwD/JkGtB2seTmkcW/iXt5cIXpmk/tJ6/gsfybJQn43VQG8wVSs5S4PF252OWFqbPZJs0+Mdmps+Ew5/YOcQ5/K35Fi1JoyVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h3LZU2GzwEcwk+BBQ0BgNkXocbtLfkxu8V26nhdxni8=;
 b=k6AOfqhB1/rpsuuDbu2XpPn1GmSEIz9Jqm/qKvvH8HBhbaff5GAL8uCg8GQF/sBDK2Wmic4qUkJjXHRcxWpyK40rEwlbrPGtSHNX+yPEO08Vjv93kyb4q1SV7TA9Gy8n8gtIJ4VKZPYDKlyAWIP0d8o9rLa5eUka/uGIsL5VYSPc0OyiNrSv9iDG3ZOfbH+n3G276VYM5lvutjHTA1SFzLYAr1aJnFBYgsX5UN5o4blZpn/Q8G52Uc6KkERWQwlHVySbx3KIoIEbCR90ghPyRRi4ROdysTjNp5w/3M1oC8zhfQ7SxhYiYZmIRGV9B/hlUtFvQe35WKfgwDqxpP96vA==
Received: from BN9PR03CA0886.namprd03.prod.outlook.com (2603:10b6:408:13c::21)
 by SA1PR12MB5657.namprd12.prod.outlook.com (2603:10b6:806:234::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Tue, 22 Feb
 2022 02:52:50 +0000
Received: from BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13c:cafe::51) by BN9PR03CA0886.outlook.office365.com
 (2603:10b6:408:13c::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.17 via Frontend
 Transport; Tue, 22 Feb 2022 02:52:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT023.mail.protection.outlook.com (10.13.177.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Tue, 22 Feb 2022 02:52:49 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 22 Feb
 2022 02:52:48 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 21 Feb 2022
 18:52:48 -0800
Received: from localhost.localdomain (10.127.8.13) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Mon, 21 Feb 2022 18:52:47 -0800
From:   Roopa Prabhu <roopa@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <nikolay@cumulusnetworks.com>, <idosch@nvidia.com>,
        <dsahern@gmail.com>, <bpoirier@nvidia.com>
Subject: [PATCH net-next v2 00/12] vxlan metadata device vnifiltering support
Date:   Tue, 22 Feb 2022 02:52:18 +0000
Message-ID: <20220222025230.2119189-1-roopa@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0e4c499a-d470-4d32-e0f7-08d9f5ae69cc
X-MS-TrafficTypeDiagnostic: SA1PR12MB5657:EE_
X-Microsoft-Antispam-PRVS: <SA1PR12MB5657D4295EB08D34B92409C4CB3B9@SA1PR12MB5657.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +MVodm3EBfIcYv7IIL95vQa7FpTPZGVR2rQezfu9oH36Ue6IgON+SNW/DGiXeR2Kr6R2bXDFP4X2N8gjA2aujC/JiTgwsjt4xLi7+uqO5fJAZIkX90WEM8sZCq6UG/iubLAYTkPR2yv22/NJDO4PBXsml2es9T654euGmx6PNcqWFl/WpXF362v8sSYLsRS3GhTxIyFp8oMcIbAurdGRr1SG2WKDHxlzPRr6VhMjjyaopfMnRZ3Y2yv2N9YNsko70KQx/jixK8aUWbG+HtoygQtMJxJsIhsigLRf7N2prIDYYrlATb5HpI8kcfWyHrZpbBDwdU9eZnsxtiAnzWyycLabX4d+a7YKy7WZmRZe0F1cv3zHVUMOvLw0zp4U8yGN9tohnJ9rQGazt1mw+I56xndx+r4sYCE9wWgBVAmdz5989uxomgD1ZXS6Bkmp+cXchd4mE630ub18srQ0bBJelfvJvD6hBJccPzwjUJv9045NzdpJ+45ugd0aP9sI+ufcKioa6VQ0S+lmPXYt1Jv0N6aSdII/IiGuBtM69H7KEZ2mqJF5yDHaCktBRPNBUmphRHMo9GrHZiqJVgaKi6Y0p+0dvuTXHhEtrpK7ygciA/lkWKy8RdOI94bbGjXQTyY0lUuzY5EpTyg+fFSV4zX+PB0wvs7gkKaXTpK4G4ngFkzt2nYY0f3CAD+5HrMsa3UvlInCjIcgS/qRVRcF6StGtg==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(336012)(186003)(26005)(1076003)(4326008)(70206006)(8676002)(426003)(82310400004)(86362001)(5660300002)(356005)(81166007)(2906002)(83380400001)(36860700001)(508600001)(40460700003)(8936002)(47076005)(316002)(54906003)(6666004)(110136005)(70586007)(107886003)(36756003)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 02:52:49.5910
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e4c499a-d470-4d32-e0f7-08d9f5ae69cc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5657
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds vnifiltering support to vxlan collect metadata device.

Motivation:
You can only use a single vxlan collect metadata device for a given
vxlan udp port in the system today. The vxlan collect metadata device
terminates all received vxlan packets. As shown in the below diagram,
there are use-cases where you need to support multiple such vxlan devices in
independent bridge domains. Each vxlan device must terminate the vni's
it is configured for.
Example usecase: In a service provider network a service provider
typically supports multiple bridge domains with overlapping vlans.
One bridge domain per customer. Vlans in each bridge domain are
mapped to globally unique vxlan ranges assigned to each customer. 

This series adds vnifiltering support to collect metadata devices to
terminate only configured vnis. This is similar to vlan filtering in
bridge driver. The vni filtering capability is provided by a new flag on
collect metadata device. 

In the below pic:
	- customer1 is mapped to br1 bridge domain
	- customer2 is mapped to br2 bridge domain
	- customer1 vlan 10-11 is mapped to vni 1001-1002
	- customer2 vlan 10-11 is mapped to vni 2001-2002
	- br1 and br2 are vlan filtering bridges
	- vxlan1 and vxlan2 are collect metadata devices with
	  vnifiltering enabled

┌──────────────────────────────────────────────────────────────────┐
│  switch                                                          │
│                                                                  │
│         ┌───────────┐                 ┌───────────┐              │
│         │           │                 │           │              │
│         │   br1     │                 │   br2     │              │
│         └┬─────────┬┘                 └──┬───────┬┘              │
│     vlans│         │               vlans │       │               │
│     10,11│         │                10,11│       │               │
│          │     vlanvnimap:               │    vlanvnimap:        │
│          │       10-1001,11-1002         │      10-2001,11-2002  │
│          │         │                     │       │               │
│   ┌──────┴┐     ┌──┴─────────┐       ┌───┴────┐  │               │
│   │ swp1  │     │vxlan1      │       │ swp2   │ ┌┴─────────────┐ │
│   │       │     │  vnifilter:│       │        │ │vxlan2        │ │
│   └───┬───┘     │   1001,1002│       └───┬────┘ │ vnifilter:   │ │
│       │         └────────────┘           │      │  2001,2002   │ │
│       │                                  │      └──────────────┘ │
│       │                                  │                       │
└───────┼──────────────────────────────────┼───────────────────────┘
        │                                  │
        │                                  │
  ┌─────┴───────┐                          │
  │  customer1  │                    ┌─────┴──────┐
  │ host/VM     │                    │customer2   │
  └─────────────┘                    │ host/VM    │
                                     └────────────┘

v2:
  - remove stale xstats declarations pointed out by Nikolay Aleksandrov
  - squash selinux patch with the tunnel api patch as pointed out by
    benjamin poirier
  - Fix various build issues:
	Reported-by: kernel test robot <lkp@intel.com>



Nikolay Aleksandrov (2):
  drivers: vxlan: vnifilter: per vni stats
  drivers: vxlan: vnifilter: add support for stats dumping

Roopa Prabhu (10):
  vxlan: move to its own directory
  vxlan_core: wrap label in ipv6 enabled checks in vxlan_xmit_one
  vxlan_core: move common declarations to private header file
  vxlan_core: move some fdb helpers to non-static
  vxlan_core: make multicast helper take rip and ifindex explicitly
  vxlan_core: add helper vxlan_vni_in_use
  rtnetlink: add new rtm tunnel api for tunnel id filtering
  vxlan_multicast: Move multicast helpers to a separate file
  vxlan: vni filtering support on collect metadata device
  selftests: add new tests for vxlan vnifiltering

 drivers/net/Makefile                          |   2 +-
 drivers/net/vxlan/Makefile                    |   7 +
 drivers/net/{vxlan.c => vxlan/vxlan_core.c}   | 414 +++-----
 drivers/net/vxlan/vxlan_multicast.c           | 272 +++++
 drivers/net/vxlan/vxlan_private.h             | 178 ++++
 drivers/net/vxlan/vxlan_vnifilter.c           | 962 ++++++++++++++++++
 include/net/vxlan.h                           |  54 +-
 include/uapi/linux/if_link.h                  |  47 +
 include/uapi/linux/rtnetlink.h                |   9 +
 security/selinux/nlmsgtab.c                   |   5 +-
 .../selftests/net/test_vxlan_vnifiltering.sh  | 581 +++++++++++
 11 files changed, 2271 insertions(+), 260 deletions(-)
 create mode 100644 drivers/net/vxlan/Makefile
 rename drivers/net/{vxlan.c => vxlan/vxlan_core.c} (94%)
 create mode 100644 drivers/net/vxlan/vxlan_multicast.c
 create mode 100644 drivers/net/vxlan/vxlan_private.h
 create mode 100644 drivers/net/vxlan/vxlan_vnifilter.c
 create mode 100755 tools/testing/selftests/net/test_vxlan_vnifiltering.sh

-- 
2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90DD04C82D1
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 06:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232445AbiCAFGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 00:06:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232494AbiCAFGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 00:06:14 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2080.outbound.protection.outlook.com [40.107.236.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB6975202
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 21:04:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hBYgM59+z1V4paC0yuuG9Zn8yAVfxNvZQcCyQcA7WHnPOwxbGu0EepYcAtjkFDqjwYgRjNhvvkMino0YDANv48vuTdAL45psDxclbTj1N5KYEdoT7FjM7tTAR1h995Bvy+pUntAcDZKoBc22+jwQd0yX/c9HXH1cQciQJo/+RHbOqcFZNFD46wByB1cjLZlqouCKFGFbg7Y1ncySnVg4gz07dxNlaJ+lyp/+6VRkwoXZqhLfKL5eO1m9zmke2x23nyTKIzmtvUj/butQFVIF+q5gNgdbEb0DaylwD/pf6nS2abJMwfHr+DbOl8NhbAycFCGAqlILag2UDUu8g2nQSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K3dTnveBZvlLzIZrbRexYRvXDbUJjmT8eXl7EZkgwwk=;
 b=BxhSiz7k96JDaI3DJR/b1uCxJfVbhFwSzrXnzi5jqYPXTEvneL11j7rd8O+a6gngm6IptBejYAAowdsAPC67Z17gL+lM1CZbaSLVi4Hr7D3cn4KPDxw6xjhHoQ73PmKtPzN7E+Iv46KHO8uur3sYQMLyDb2sY/mdyMScj9qW9x2gFSBIxxWpEfV/3sydYrGriNj5DIU4zCfGwNVgqHs/RafQOvVuqW7T8+Y93HaX6S/LeF/phiAmTIfh89jrBnM7kj6pwgTLgZS7nlfOO3a/YDsgRQsfQLEHjtAJxdpgEQFd+vUZLxykVDGpLUoCG5pe/3y42SrfceICtSOtYaQfsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K3dTnveBZvlLzIZrbRexYRvXDbUJjmT8eXl7EZkgwwk=;
 b=nRI7AmHmOHsr1qzvxSSm8nzPprWwtjcSY3vgtZMfLHKWAz7jNlylKYr009KqkwyRsCH7xiBgPpxJK8S+0j73245EVQ3l0/Eg3NP1u5v1xYy5869Kxav3wgRjyggmYnfM1Hxs3+CZwLqvkE4zopTfvx7JjT3U8o01D/lhUBHKsQydmbYYnsuwZ+9XaqvOkdjKLRQdBnc4Cb9QApCYnT37yof6xXStzOUcPMjpoh2JKOHwaNxiVVf6x5mVlWjopCoS6uw8PyeLw2HKYJgNyucjopY0FC6QTwHOuD0DfCex/qgVasSzdDeWVtJtgEW8gb7y/BquLP2eWDyp8WlrZXoqog==
Received: from MWHPR04CA0031.namprd04.prod.outlook.com (2603:10b6:300:ee::17)
 by SN6PR12MB4717.namprd12.prod.outlook.com (2603:10b6:805:e2::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25; Tue, 1 Mar
 2022 05:04:41 +0000
Received: from CO1NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:ee:cafe::80) by MWHPR04CA0031.outlook.office365.com
 (2603:10b6:300:ee::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.23 via Frontend
 Transport; Tue, 1 Mar 2022 05:04:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT004.mail.protection.outlook.com (10.13.175.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Tue, 1 Mar 2022 05:04:41 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 1 Mar
 2022 05:04:40 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 28 Feb 2022
 21:04:40 -0800
Received: from localhost.localdomain (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Mon, 28 Feb 2022 21:04:39 -0800
From:   Roopa Prabhu <roopa@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <nikolay@cumulusnetworks.com>, <idosch@nvidia.com>,
        <dsahern@gmail.com>, <bpoirier@nvidia.com>
Subject: [PATCH net-next v3 00/12] vxlan metadata device vnifiltering support
Date:   Tue, 1 Mar 2022 05:04:27 +0000
Message-ID: <20220301050439.31785-1-roopa@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: caa62159-5c60-4387-6bde-08d9fb40fe4a
X-MS-TrafficTypeDiagnostic: SN6PR12MB4717:EE_
X-Microsoft-Antispam-PRVS: <SN6PR12MB47175A762AEF622948A37C3ACB029@SN6PR12MB4717.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +ZeZpdQ8OPzuyUBXE/xu7iKWhSTyWja18b4jOIJGNxpXJXbKUoEOehqaFuXncFx4kelny/blZFlzI6+tlTEBguKP0KDrtm45yyH39OnadS2prg/fH3G1EGQWWQ23E1ZtloBiAJcBdD4Ausk59Fp+1PdCr2IXrCvuJaS0Dwiv2CmXWa43HZtEscww3xG0NCno10PRnfInJmReRxYqpILjigYWxaHm5qI7narmN346MUdQp9r3A0XLjWppE637YDaVEipQMoPbYJz+FbIlriiV9sSuvN0tvVTlCMMv92OLKUaHfuL6kWXz9xCHHtmkw+LfpKUVO0v+CfR8wuSQYO0cUf7NHV1YwgF4bvOpui9VJU0oyn03z1A/asBQxS4osMYheuycpgyzERg6/xOKcnQxG5V4iaw7gDlAhPgF1MTglsFI/b12YStGJ/5xFCUbmiBy/sBNDFc5A5FRZ/qoV4Y50Iu63/pVP+gZ+YqmBKOcM19f1NqE02DlfR71svcAVdt4UiCfaU9st7BU8TREZuaeVIW/gjJpM5Nsr6dI+43bOoxiHaYuevj4RhR+f72OnWo0TUIrTe2QdTHkGatXNKmx17ngpll0I+ROiP9iUgeYvATXSR/+PjUTrAM8gUeo4J17hlYbXxziSwgiSqAfE8spgddN1vsek/g5WZ4KGWIHt9qsVS1b1mzbw7L9E1Hc4KSyjRMB4bTFDgIDfWWQb/5ZHg==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(81166007)(1076003)(107886003)(2616005)(6666004)(82310400004)(2906002)(86362001)(83380400001)(4326008)(316002)(36860700001)(8676002)(70206006)(70586007)(40460700003)(54906003)(5660300002)(110136005)(186003)(26005)(356005)(8936002)(47076005)(508600001)(336012)(426003)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 05:04:41.1310
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: caa62159-5c60-4387-6bde-08d9fb40fe4a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4717
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

v3:
  - incorporate review feedback from Jakub
	- move rhashtable declarations to c file
	- define and use netlink policy for top level vxlan filter api
	- fix unused stats function warning
	- pass vninode from vnifilter lookup into stats count function
		to avoid another lookup (only applicable to vxlan_rcv)
	- fix missing vxlan vni delete notifications in vnifilter uninit
	  function
	- misc cleanups
  - remote dev check for multicast groups added via vnifiltering api
	
Nikolay Aleksandrov (2):
  drivers: vxlan: vnifilter: per vni stats
  drivers: vxlan: vnifilter: add support for stats dumping

Roopa Prabhu (10):
  vxlan: move to its own directory
  vxlan_core: fix build warnings in vxlan_xmit_one
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
 drivers/net/{vxlan.c => vxlan/vxlan_core.c}   | 434 +++-----
 drivers/net/vxlan/vxlan_multicast.c           | 272 +++++
 drivers/net/vxlan/vxlan_private.h             | 162 +++
 drivers/net/vxlan/vxlan_vnifilter.c           | 999 ++++++++++++++++++
 include/net/vxlan.h                           |  54 +-
 include/uapi/linux/if_link.h                  |  49 +
 include/uapi/linux/rtnetlink.h                |   9 +
 security/selinux/nlmsgtab.c                   |   5 +-
 .../selftests/net/test_vxlan_vnifiltering.sh  | 581 ++++++++++
 11 files changed, 2309 insertions(+), 265 deletions(-)
 create mode 100644 drivers/net/vxlan/Makefile
 rename drivers/net/{vxlan.c => vxlan/vxlan_core.c} (94%)
 create mode 100644 drivers/net/vxlan/vxlan_multicast.c
 create mode 100644 drivers/net/vxlan/vxlan_private.h
 create mode 100644 drivers/net/vxlan/vxlan_vnifilter.c
 create mode 100755 tools/testing/selftests/net/test_vxlan_vnifiltering.sh

-- 
2.25.1


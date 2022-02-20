Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5FF54BCF06
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 15:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243779AbiBTOFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 09:05:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235018AbiBTOFx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 09:05:53 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2048.outbound.protection.outlook.com [40.107.243.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8822035855
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 06:05:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QcA5dEG1q+wKrqXqotFDBiPuOqUGYvSGRG8wSXTI0ghXH6aqO3ayB04wMowXKts8VaRzulYIqxYxKH3EWrYqy/WVP16q0qo8ZtW+MMQDwhEHixqQcwIAl2u5W12vQyGBDIXWV7D8blQ/wH7b9ZKvfppc4w/j7syGRIbfq6JeN8T3MB1LZ48Ni1E4LJDKtqxLI2UzcGSLcXAEAm/H5THxcN73BAQ0RZb5tgRFFfIpYGcSNOKEROKr+zrx4oOLbeiz2zrmyjFWX63Ch5YScRJ/o8OPtco3DcWmolZycvdZAJRpq/qzI5D8xjIRt8ukgY1hX0fhtPVjQ6SeU14oBE6vzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k/Vch0WfVuNkk0hxtz7qQGsQm1A4V2aP2M2sFnmpruw=;
 b=OI3zBqW+H/F+4U2CHq294qNhdryKItEfotpNiK82xC7CdlhfT4Gk332dfyVdNQoL6SGTi5UrTbaXCgrJ0rREemQSFccfN6BYU7n7B5IGLZYiHP6lONrrzq45beLxz/417nvHmyR49CTaX9btMJVdslhuFlVg2yIGYSpIecgsjXxCPRIZQDPmjzUgU3dvY4OJMdsTETshpgiW1cUuQorF/mTjys87XNCnZm0gwE/WL+/PYT6lLKlSaPdBYU+B31VVOP1ITjlfDVMyVHID2P3U95akVLSpQW5xVJ0o3gT6HFuB174KSz9AScovzrLDtErlz8T1n6TcWniWbJSJYnJ0/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k/Vch0WfVuNkk0hxtz7qQGsQm1A4V2aP2M2sFnmpruw=;
 b=GgHMS/MGJ+Rct9AcybSpn1LravKAvOpab5DNvJwg8vl/PjnMNZRdQIphaix+rkbvJsay39szkWrGt6a2YFQ3+/Td5gzTYXY6c1rjOx0Gw61Gcfc6nwcl46R1xhgZTLFsawgQQCJVo+fU3bpx+MBJnjnHMBJqUTS4zYlmdlSzhq+v4K5YwxWEa5Q7KXBGeuGvalZnhPUgMUpKMNHoVEH7e0MQcQ1OgKopvBcuBOnqM02SZR0mnZgJRn0jTznGoHWr8gWzxfgHE0FDYbPSdZ4NCnLHSr78HTKedLxW1QMRMgUFYNsIVQ7qPc9LrwHQHkZzHqKReFRKe89UGdJ9LpfwxA==
Received: from BN7PR02CA0026.namprd02.prod.outlook.com (2603:10b6:408:20::39)
 by DS7PR12MB5910.namprd12.prod.outlook.com (2603:10b6:8:7b::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4995.22; Sun, 20 Feb 2022 14:05:29 +0000
Received: from BN8NAM11FT033.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:20:cafe::dd) by BN7PR02CA0026.outlook.office365.com
 (2603:10b6:408:20::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.19 via Frontend
 Transport; Sun, 20 Feb 2022 14:05:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT033.mail.protection.outlook.com (10.13.177.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Sun, 20 Feb 2022 14:05:29 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 20 Feb
 2022 14:05:27 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Sun, 20 Feb 2022
 06:05:26 -0800
Received: from localhost.localdomain (10.127.8.13) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Sun, 20 Feb 2022 06:05:25 -0800
From:   Roopa Prabhu <roopa@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <nikolay@cumulusnetworks.com>, <idosch@nvidia.com>,
        <dsahern@gmail.com>
Subject: [PATCH net-next 00/12] vxlan metadata device vnifiltering support
Date:   Sun, 20 Feb 2022 14:03:53 +0000
Message-ID: <20220220140405.1646839-1-roopa@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 516f1612-fe94-44d3-6f28-08d9f47a0d1f
X-MS-TrafficTypeDiagnostic: DS7PR12MB5910:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB591084A69AA7605F38F188B0CB399@DS7PR12MB5910.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /s+JF5JeB8n66XgN9G17Kp4+o0CpzWuwUjx3bvfUkNxjcXIwvk+LrYqadlWESICe2M8cdzkTfBHCO/d/bvg/Haf6yeKA7ykEME+yik6PuxJWKe+z8jcfba+mTPnrelWmhJ9Z6UhS5C5Wzelw6dOWjkCmLVmmGElEqjo65Lo8+Egx7oBDGUVh0G2MvCgsEmWVsFnDSSUBVGMt0qA9cKFReu13du0BPT58zJkAek9EbMth42S2cDB27Mpq7viKxDtV1jMoKYIA435jbflXfuk8r0qzEjTh4s0swhz95/5yIlgGQi/QEGlfkpftPvC8od+SJWPY5TBfr5F1nm86+JSgYJ2ErVWZ4bBR1l0xVlEyzdZbvjc1YAfHWNY74aB5WVAKqKyLDcY/wfxFFLmKtHcOFg+vSXxy68gLQT6ADun231HIbWkpTlACcMtVLlxt1vZCQu/HhrK1IVxEyuQueivQZf4NNjbDL964O6jwtehcl1E8SX/5eb2/qiCfN70SBS1l9GiE1UPis/riSIC5HtruBo9kMBVO++aSB0D+MdOVpxUA6VL2x+2HZlvhycdCAEiC01wftbraSmcGJmx+1BfMWY9OifQao2E/CLyo9/Xvfa9JDRfh60I/c75V16wSxubyLUZuh98y6R5bSizwjxhWGkIqEzvlukveqcxFcajWttg2shfX4K7qy42NiAYVzVHSKaNLM5VNEn8KbyORaahtgw==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(83380400001)(86362001)(36860700001)(36756003)(508600001)(2906002)(8936002)(26005)(6666004)(336012)(426003)(1076003)(2616005)(186003)(40460700003)(316002)(356005)(81166007)(70206006)(70586007)(47076005)(5660300002)(54906003)(110136005)(8676002)(4326008)(82310400004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2022 14:05:29.0643
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 516f1612-fe94-44d3-6f28-08d9f47a0d1f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT033.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5910
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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


Benjamin Poirier (1):
  selinux: add support for RTM_NEWTUNNEL, RTM_DELTUNNEL, and
    RTM_GETTUNNEL

Nikolay Aleksandrov (2):
  drivers: vxlan: vnifilter: per vni stats
  drivers: vxlan: vnifilter: add support for stats dumping

Roopa Prabhu (9):
  vxlan: move to its own directory
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
 drivers/net/{vxlan.c => vxlan/vxlan_core.c}   | 420 +++-----
 drivers/net/vxlan/vxlan_multicast.c           | 274 +++++
 drivers/net/vxlan/vxlan_private.h             | 178 ++++
 drivers/net/vxlan/vxlan_vnifilter.c           | 958 ++++++++++++++++++
 include/net/vxlan.h                           |  54 +-
 include/uapi/linux/if_link.h                  |  54 +
 include/uapi/linux/rtnetlink.h                |   9 +
 security/selinux/nlmsgtab.c                   |   5 +-
 .../selftests/net/test_vxlan_vnifiltering.sh  | 581 +++++++++++
 11 files changed, 2275 insertions(+), 267 deletions(-)
 create mode 100644 drivers/net/vxlan/Makefile
 rename drivers/net/{vxlan.c => vxlan/vxlan_core.c} (94%)
 create mode 100644 drivers/net/vxlan/vxlan_multicast.c
 create mode 100644 drivers/net/vxlan/vxlan_private.h
 create mode 100644 drivers/net/vxlan/vxlan_vnifilter.c
 create mode 100755 tools/testing/selftests/net/test_vxlan_vnifiltering.sh

-- 
2.25.1


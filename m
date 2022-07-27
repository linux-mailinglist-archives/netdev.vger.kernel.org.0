Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 408AE583257
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 20:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237618AbiG0SuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 14:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238056AbiG0Stz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 14:49:55 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on20612.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::612])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 211C98C3FF
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 10:46:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F05voT5cxOy0YN+boxejbcYDN45DIB6O7YCrqeZb5BYhoSJfw3CS+rYc03vrNuXFSmUQdkfLy6cCjObjfyxAkw3wU7DTGd5jsm8Cf7yTQZ/zy9KYNURKxzzlkVbaNkW6b/lssjtMFa16xDc6y0BMsBtmUbTn5i26Ckn+IPsYZH6SBJjIfJOdE0XLc3Tc0saA3W5dYF8FIrYtWTCy2q5SQZH4w1KC1EJ2WRu0MNmYIKle3KO43Nzg8Qytb9mvmKh6VjfvCt+ae2aRtyGcDokDepumN2tJQbHPv685HL+SljJHlmKXan/KfOkNMrPfAeYmlQ9g0y+/CSyG9prpxJaz+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F7CV1/eEjGLa9VAmnoigIk68hXawZFEQ0/Iazqd30x8=;
 b=iGwk0hIwvXbpOfm2BL9TkDiBYW5tQgeMtC37h/Sl6HUW0bG3MGQTz8YP6RoOxs3dKsBteHMbpWhrf2GEFtiBVcChmNsE0MytgtyaUGGawHpUklXBfBTxn8HVn9s+SmAX5gvJgvLHFTvEzxdr5x3CgVwJzutE6NPJG+1CzCEs5w/3qVS9hvaAVOywQFSDxhhsoNCYB19rSrJGmqu/jUcA6jQofHTWmYCNhqf/4GsufT2EeGaw6M7UvnSxzTE+Z/zIvfTUZ/XM1NtMasvgbCQ3WtCIPZHe8vPxCnRlyVt0T7wy7Wcj662TObgZ6ktkglij+OyiIc+/QKGebp0WGAxAng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F7CV1/eEjGLa9VAmnoigIk68hXawZFEQ0/Iazqd30x8=;
 b=v9nt2NG4lQsXdaapjQ/9MTupSOpW0rWUzsgyluy6+wdAdauTlR2+lF8U6WG95QPyFeSi/ra922Pb/3XfNvrse5j3MSOKucsldFGwxIhhPRh1JGeAYWFmna/pAK/1d5+/0dcZbp7CdUQNzeAFTr80riStDdWMWiDrhrV7i+JKviCJpcX1qWI4Kc2O52CIkW6+Vw43ON1rvlvqW5+yOPuF2V680QnZfTQiu3YodwgVwWhnOqyNy51N0Cr4Oh50k/AJRcPzjfl/bRbWgWbCvJSVYA5heIt6hzmQkv4vsftrnm2npaTdyYx4NWKDzxAk28ybEgQ8lW8T7+5VHCFlYMuLsg==
Received: from MW3PR05CA0012.namprd05.prod.outlook.com (2603:10b6:303:2b::17)
 by DM6PR12MB4282.namprd12.prod.outlook.com (2603:10b6:5:223::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Wed, 27 Jul
 2022 17:46:27 +0000
Received: from CO1NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2b:cafe::c7) by MW3PR05CA0012.outlook.office365.com
 (2603:10b6:303:2b::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.1 via Frontend
 Transport; Wed, 27 Jul 2022 17:46:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT015.mail.protection.outlook.com (10.13.175.130) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5482.10 via Frontend Transport; Wed, 27 Jul 2022 17:46:26 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 27 Jul
 2022 12:46:19 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 27 Jul
 2022 10:46:19 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Wed, 27 Jul 2022 12:46:18 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next v2 00/14] sfc: VF representors for EF100 - RX side
Date:   Wed, 27 Jul 2022 18:45:50 +0100
Message-ID: <cover.1658943677.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f1e5b8ba-6fec-4bab-6fcc-08da6ff7edd1
X-MS-TrafficTypeDiagnostic: DM6PR12MB4282:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zXtPexQe7HKkBGjq23GadBtcmoUp2pdaCZG6pL285jo4xAZsmmsSNCXlXf8kLwdOKjfurkD/aOwxMt5hzb5kgP02ppnwnIS88nxi1kv3s6ukevAY+idVyCqnhQOW+P/E7pNnfT0J1f6voI/zSKT7IDZEhloaAMsO1s1TKg6x3/Jhf117u64c8L6FvrhgjRmo9qa3BkeKiGtP85chAB3LQWnLZhv1xaaQQXruh9KJfhyOjeiDkOs2tkch22OooShP9MnrZ0tG5g8UkVF50SM91t6wDBVXiYXKexut1BjMQ4D8CLqwfc5bgs3qMHKCZFoL3Au0AeIhO6b3OeQohhaEQeByfJasK38va95O5W9v34wX0whdcQwC/XyD8VrkGFyN/m2725nlCqK6G0GHO4jDFUWV1V5roxj7nwEQFNePuS3oiFLG8GnJl8yIB1eLhwcOH5R1fDZh2kIx6uzo7/9Unbj+ZYgZskgYDd4xk1DV0gALzvjhAEO6qcZ6jmycl9TCNw6qfHZDe4rqaxGVPSXud4Sun5uO2rGB0LqDG2z2g785iuCXfAzN/x5lDg2kAjg+tX9m+UyrNn3xY+rM0POAHMSoE3JWiTAWaD9eDwkWpBT7TQuXYLE0UUdJz6B0AFrKr04DSsLBgeAKiNMX9jioKv6ZB4B1vIgg8CZau6keou1ZCP2jSZktanZpxW+V1y9XzSAOH8RQ8O1v16cfxNduqxoOia6Yxq9AkpqolCrXGrS+EAvBbDz3jsoCbiBwR0gYs//Kw4+X+cI355t+/LuVTySg9rcmEv6Y9bvAA7UTq5WrNn0xN2bAoTNJNv8mCFJ/YGrUg1eB1yY2teOTq9ZJjg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(396003)(346002)(136003)(40470700004)(36840700001)(46966006)(336012)(42882007)(83380400001)(36860700001)(478600001)(110136005)(26005)(83170400001)(186003)(54906003)(316002)(2876002)(9686003)(40480700001)(70586007)(70206006)(8936002)(8676002)(82740400003)(4326008)(5660300002)(41300700001)(47076005)(81166007)(36756003)(40460700003)(6666004)(82310400005)(356005)(2906002)(55446002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 17:46:26.2002
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f1e5b8ba-6fec-4bab-6fcc-08da6ff7edd1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4282
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

This series adds the receive path for EF100 VF representors, plus other
 minor features such as statistics and MAC address setting.

Changes in v2: fixed build failure on CONFIG_SFC_SRIOV=n (kernel test robot).

Edward Cree (14):
  sfc: plumb ef100 representor stats
  sfc: ef100 representor RX NAPI poll
  sfc: ef100 representor RX top half
  sfc: determine wire m-port at EF100 PF probe time
  sfc: check ef100 RX packets are from the wire
  sfc: receive packets from EF100 VFs into representors
  sfc: insert default MAE rules to connect VFs to representors
  sfc: move table locking into filter_table_{probe,remove} methods
  sfc: use a dynamic m-port for representor RX and set it promisc
  sfc: look up VF's client ID when creating representor
  sfc: fetch existing assigned MAC address from FW when creating VF rep
  sfc: set EF100 VF MAC address through representor
  sfc: get provisioned MAC address on EF100 VF probe
  sfc: implement ethtool get/set RX ring size for EF100 reps

 drivers/net/ethernet/sfc/Makefile         |   3 +-
 drivers/net/ethernet/sfc/ef10.c           |  26 +-
 drivers/net/ethernet/sfc/ef100.c          |   3 +
 drivers/net/ethernet/sfc/ef100_netdev.c   |  14 +
 drivers/net/ethernet/sfc/ef100_nic.c      | 151 +++++++++--
 drivers/net/ethernet/sfc/ef100_nic.h      |   5 +
 drivers/net/ethernet/sfc/ef100_rep.c      | 250 +++++++++++++++++-
 drivers/net/ethernet/sfc/ef100_rep.h      |  22 ++
 drivers/net/ethernet/sfc/ef100_rx.c       |  46 +++-
 drivers/net/ethernet/sfc/ef10_sriov.c     |  16 +-
 drivers/net/ethernet/sfc/ethtool_common.c |   1 +
 drivers/net/ethernet/sfc/filter.h         |  18 ++
 drivers/net/ethernet/sfc/mae.c            | 304 +++++++++++++++++++++-
 drivers/net/ethernet/sfc/mae.h            |  20 ++
 drivers/net/ethernet/sfc/mcdi.h           |   4 +
 drivers/net/ethernet/sfc/mcdi_filters.c   |   6 +-
 drivers/net/ethernet/sfc/mcdi_filters.h   |   1 +
 drivers/net/ethernet/sfc/mcdi_pcol_mae.h  |  24 ++
 drivers/net/ethernet/sfc/net_driver.h     |   5 +
 drivers/net/ethernet/sfc/rx_common.c      |   4 -
 drivers/net/ethernet/sfc/tc.c             | 252 ++++++++++++++++++
 drivers/net/ethernet/sfc/tc.h             |  85 ++++++
 22 files changed, 1194 insertions(+), 66 deletions(-)
 create mode 100644 drivers/net/ethernet/sfc/mcdi_pcol_mae.h
 create mode 100644 drivers/net/ethernet/sfc/tc.c
 create mode 100644 drivers/net/ethernet/sfc/tc.h


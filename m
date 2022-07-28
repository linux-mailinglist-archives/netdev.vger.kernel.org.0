Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 148E4584639
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 21:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbiG1S6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 14:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbiG1S6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 14:58:21 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2068.outbound.protection.outlook.com [40.107.92.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A982A71E
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 11:58:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SeQxmCDeTh/kbEjc8OM2NFeUHC6juxqCt8Op6joe3GMtdCHvoaS+IA874yVDJ3jos0Op4oil4cc38Btlad4nsI4WwP3spkG35ySKxwkGPVSoETAE0gbrZ9ggU57QRtCqDwaHHuyxr1HmsTFb7g5tSOhlxkbgBvK92f5ChvyB6gTz5RiZiD4DGQIfslNjKcpKAuZ1yBkgDAX9FgPPS+RY+51ZFBLaC7c3dC7d6KdUA820rC98mSQ/qraxZGB9i6NnIMhwbyM9+N6osPIn8RmwdO4ZUVTY4q+EyhMwLzpttjSS8CjG+OmrNYdnlSVF1JldgRrhvljdmwIc09sFldLfeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oj6lQ4/mwaI8WznlJ95iioGU2EEA5kSzzRc7r8oAxvU=;
 b=lFBaM1b/H1XV4AHQU8wJVIrxEbq5oOJ1gPp2pEPYlJFKMF9ZMmCT6WPt0cyXvJUqc7+y9W8GmkxoCh387AYu7MuDVOea62IARKaq41KlhNyQl4pKoKT/a6nNqDnoByEp7aO1JgWQh8rf3H/3Hiiy+YK04Nty4tPZQd6sdRzT4y8U+vqU/WCUQnpZYAqCGg85WmE5fW4sQ1qLr8KyKZ+n6pxLqCSeU1lZn2koeXXw8ledXjekjyj5gVJluCTRIzXXaC9SDffkUXDWQrWzax8G77njGo7hdTwasfh0V7g/vSF2gnMyPal6/30QvHAE6McGKe7crYzeDXC5k1i9nk2Oug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oj6lQ4/mwaI8WznlJ95iioGU2EEA5kSzzRc7r8oAxvU=;
 b=pkB+R/dUHwp3Wtq/w161a/57W/On/oV9MRzJgynFz5jcq6buTdqQAk852BY1SNr9xgovMMJ+UyRqRa99npEV9WxaxTdgA+yfJo3rNewr+l6b3664sUwLUB7rDEYzaJoQoq7gLEC1upfCn3qMqEprBkgA+V7qJ3iR7YIo8SH38/FIntf+mSXhmDvvkI3MBo8Mc/BcIe/Mh1o/GSD7VRbqBOe0qcSKoDGSc26zwKrNIIcQlzoraJm5nVo7J12UI77bKEgMbi57ZzhtJxtSeU/NjbUK53hSFzoNUKbWX/qeop4HM6u7oczadoUpEFqsBn0nj1u5VXblWSG22UwaaARTpg==
Received: from BN9PR03CA0982.namprd03.prod.outlook.com (2603:10b6:408:109::27)
 by BN8PR12MB3412.namprd12.prod.outlook.com (2603:10b6:408:65::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 28 Jul
 2022 18:58:17 +0000
Received: from BN8NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:109:cafe::6f) by BN9PR03CA0982.outlook.office365.com
 (2603:10b6:408:109::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.21 via Frontend
 Transport; Thu, 28 Jul 2022 18:58:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT061.mail.protection.outlook.com (10.13.177.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5482.10 via Frontend Transport; Thu, 28 Jul 2022 18:58:16 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 28 Jul
 2022 13:58:16 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 28 Jul
 2022 13:58:15 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Thu, 28 Jul 2022 13:58:14 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next v3 00/10] sfc: VF representors for EF100 - RX side
Date:   Thu, 28 Jul 2022 19:57:42 +0100
Message-ID: <cover.1659034549.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aef86c24-588f-4a10-047c-08da70cb2195
X-MS-TrafficTypeDiagnostic: BN8PR12MB3412:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RqupRla0T4/La2Gw1ZqNM+YiO01CljDZF+UpeprB5DgnCz7M/I0/8pP0yLK2oTzhpdbfhi0ZyLAX/URo4NqUYL9Knu4XGYE4QKQoYInnr038W4KFAdRkOnaFEQtA/W2uT4zUTedmhH2cx8Oei+YBh4vnv7zeBFAcmeasBEt4LH3C+MwN0eUdJMns03HVllX+rfFKXGKeTkRs5AcJaPEuPI8zGHiAgMkQbKJIdfv5uyEvBy2b4BK7ze2Axj6xg9ak8B7muQoJFuQd9rX0a/QxHG2gStsb/gOzIVsiUdmSyfU8trQy6XhYZVrcfCtqz7/aVGczz/eepD7AuN9DMShA+pLbXgF4nmtiIXTSK4TdxrC+zRNOcvWSUqnpRUHrkkEZBsdw4CLl9WwDV0xiCSdHLqG3ENk66lsLMiLXaH6QiP6DgvL/lpCC+zBvTPc7P8ArM0F1AbTBqth1ScMj7QXHCXTsPl4NeLBGYaRtkDxUXWtBbEWB3lXxS91EuNYLLr2lYCl+1RPSEPdJ679w8HgjDH8dAEIlLAKVyapwAQXspQ0WjcyRl9asqUoog/e4WxCPHXASMhOzrm6Jzk2frj8gmL9vOnbfDykabRIqm68LGK5vjuYqiI3s0oIsAz6nkm2jVrMFavvHy3moXa/u0UHtv+KCc/5YuGiZIRR8RuuEnEcRSi3a9SudiinIAZIf4TtM9NiI48oKtuY9zScTKKH5OxtVPrRr5YH05NWO9P1NG0RSB/MK/BFUeld2qlfDmUKK453vhhlNzA0SwipfhtcqqPCmxcLTt0D8OJpqlig0k2SK7bChVYUf46VmldJGa3pRmvOnLRpjgUBqlweZxmKC3g==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(346002)(376002)(136003)(36840700001)(46966006)(40470700004)(356005)(9686003)(54906003)(186003)(36756003)(42882007)(40480700001)(47076005)(336012)(83380400001)(70206006)(70586007)(4326008)(110136005)(8676002)(2876002)(6666004)(2906002)(26005)(41300700001)(55446002)(83170400001)(36860700001)(82310400005)(5660300002)(316002)(478600001)(8936002)(82740400003)(40460700003)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 18:58:16.9807
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aef86c24-588f-4a10-047c-08da70cb2195
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3412
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

This series adds the receive path for EF100 VF representors, plus other
 minor features such as statistics.

Changes in v3: dropped MAC address setting as it was semantically incorrect.
Changes in v2: fixed build failure on CONFIG_SFC_SRIOV=n (kernel test robot).

Edward Cree (10):
  sfc: plumb ef100 representor stats
  sfc: ef100 representor RX NAPI poll
  sfc: ef100 representor RX top half
  sfc: determine wire m-port at EF100 PF probe time
  sfc: check ef100 RX packets are from the wire
  sfc: receive packets from EF100 VFs into representors
  sfc: insert default MAE rules to connect VFs to representors
  sfc: move table locking into filter_table_{probe,remove} methods
  sfc: use a dynamic m-port for representor RX and set it promisc
  sfc: implement ethtool get/set RX ring size for EF100 reps

 drivers/net/ethernet/sfc/Makefile         |   3 +-
 drivers/net/ethernet/sfc/ef10.c           |  26 +-
 drivers/net/ethernet/sfc/ef100.c          |   3 +
 drivers/net/ethernet/sfc/ef100_netdev.c   |   4 +
 drivers/net/ethernet/sfc/ef100_nic.c      |  91 ++++++-
 drivers/net/ethernet/sfc/ef100_nic.h      |   2 +
 drivers/net/ethernet/sfc/ef100_rep.c      | 199 +++++++++++++-
 drivers/net/ethernet/sfc/ef100_rep.h      |  20 ++
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
 22 files changed, 1085 insertions(+), 49 deletions(-)
 create mode 100644 drivers/net/ethernet/sfc/mcdi_pcol_mae.h
 create mode 100644 drivers/net/ethernet/sfc/tc.c
 create mode 100644 drivers/net/ethernet/sfc/tc.h


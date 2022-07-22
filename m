Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 553FB57E40E
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 18:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234251AbiGVQFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 12:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbiGVQFT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 12:05:19 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2040.outbound.protection.outlook.com [40.107.93.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40B4864ED
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 09:05:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nrz/4bCAvDDUFcVFJY0W1TzuD5/9PwsR89HkBg5i6dwrTKiPdvbxmUwjKuRoe2kMFQwMg9hxp+oD9Pz376fr0fkF0MCrkpKpu7pC7GsEJPKreTCL9ZJLU5UkpOd7eVIrMNajPM39hYU02GT2F1M/qwyQAUsejyUJy+untanWji1aKh6S9DId2fw5gTzbWet7F8LIOLegH5ynTqoVkQnc8F3ytAjnTNWalqV4SZ7+boEv5KGuITkY4AKVSQYEOzeXvL8EU9xAh4/eDCiXdwni7iuw0+utoybNGGV8odJFCstLOANWGiIROljvvdgqi6FMWERWp9DEqtDOlJXQYvcJiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MVl5M2VGerIk+xxC4rzL1C+blfu+CuFpQocpsldQ8Oo=;
 b=DI0zoMACIvzsyI4z8Q5Ysa71RqVExXhoR6rqeFxZ2WNM7BLLdXP/PXtd3HdXX+2/eNVqSNxjGAilcHcpLtJxlx5bAgUT/EgZ49+p6yLg0pMEyxG3dHVtV4LFqoCFG3rxcyOSLDY7JayKfJYZ/747rbYRx8vBo1CIOSXVAL9P8inHE3Toix5nfT/4jl2Y1F+jDarYdCcCxMV6a/Db3ZhulfbhJlDjwZZXahNRrBkdvxpH5vih32xaqFdveAisRYuHF4sTEljchA7ZpP0oCRClLjsH5FRq8hAjQe5ff4bWS+prRTpblUYFUJuytMk6KPbVYxGAVDdkYF8BnUbcJkxbWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MVl5M2VGerIk+xxC4rzL1C+blfu+CuFpQocpsldQ8Oo=;
 b=bbMxwZuVX4PrWgifd/m8+ga8XveV/KZNuhftpYaE74ELIvQykaWm4AH5gcyHXudQlVz+mtQf+hUkH2+Cq5Y8lME2a/ajQkGRG78IpYI/95W18rUq+UwHYirhn1TpLUVrK6MborGBK3WcPbzK1amZFBJV+ii4MWumGmQvg63IA9MX/OUG6LumB/VGdPEjtcq/nqho7V9+sJhpJnirm1yTiTMZlIw/RXUaT7xpd1wHCGikmBLqVj3ltkmsnx7I+ohpJ82LASqRwofGPDHHNCEZseXcr1sSg4Cb62tHJknPMyKtjK6MxlZh2LGArB//mOwA9EQSYRAjgoBt4LsgwYzRJQ==
Received: from MW4PR03CA0149.namprd03.prod.outlook.com (2603:10b6:303:8c::34)
 by BYAPR12MB3301.namprd12.prod.outlook.com (2603:10b6:a03:130::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Fri, 22 Jul
 2022 16:05:14 +0000
Received: from CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8c:cafe::b) by MW4PR03CA0149.outlook.office365.com
 (2603:10b6:303:8c::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19 via Frontend
 Transport; Fri, 22 Jul 2022 16:05:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT035.mail.protection.outlook.com (10.13.175.36) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5458.17 via Frontend Transport; Fri, 22 Jul 2022 16:05:14 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 22 Jul
 2022 11:05:03 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 22 Jul
 2022 11:05:02 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Fri, 22 Jul 2022 11:05:01 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next 00/14] sfc: VF representors for EF100 - RX side
Date:   Fri, 22 Jul 2022 17:04:09 +0100
Message-ID: <cover.1658497661.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cdb7b844-ea5d-4d87-6498-08da6bfbf676
X-MS-TrafficTypeDiagnostic: BYAPR12MB3301:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: muV0ThnFdf6y1HlJoyeaB2mndqVO6cIUytPAAgjIuusVgFQe4iSOsyOTWrrIfPMDyQsQgDE0Tv5qmx2x16SwUHo4yH1jLrsfXpgFenQYTS5yQnWOKYlUw5oGpAvHuNYceND/eH+T+eFXLELe8Vc4qqykcGC/jkRbhcqFVJsvXIrzOX322fDQS0T2hn1msqRrAZMnj1qvAShWW8KlWOwTs8sioPeVVQV0LxfXmTWqcN95TKJMOxslIRT4urT8ieLOWOPJaNtMeKX331HB2ndeNsrjYuDvDMt1rrQpdDGo4INSOgAnj4sB+YyFOxZARvZo+Mz/ijBXYCN1q22Mmjh1xakB64Rc9hjzpqz7ETDvUtyd+jhSku4abR6wNhGjgKCP/f3Rrw7yA76gFgTxlXRVqik3ICao/uElgXeLcGQQ5GAL4TWkDg64BFN1OEWsOcs3VHGqAYayVu7StKyttHIfODhzErhyTEvGiSQOK8vh5z4C/7X8IIYes0GI8QK2T2X113gQ/lsjb6M97BUi950cWh3KhUi5CWZERe46g+fsSa51LbsqrMlm8a7l73v9l52OYruInsJFbf+Nm6XiRtAfTOxORLPWHg7IQDjPRy6bHhnrtiJSW5QOSesshPK6EI052zX1BHsQmiiJijEiPxEe1upBsz0IIfuemVu2BZWvPzNI9Ny1BPyuVFwrx85+pYP98bs4AyGy+ZC4S20dyoDkiqafxB4bGlFEXKgi12EucdlTbZ46Zt+CkPkyY66/6SQOk2Kt5oMBVNCBN5/2YE08Bfu7FPcvWP+4/UJEfmzIQ+YxTwUthfrHUjtyC57KMgA/xhkjRju1DIeV0Sd7vJ4vow==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(39860400002)(376002)(396003)(36840700001)(40470700004)(46966006)(2906002)(8936002)(5660300002)(40460700003)(42882007)(70206006)(36860700001)(2876002)(82740400003)(82310400005)(40480700001)(47076005)(83170400001)(9686003)(110136005)(336012)(36756003)(54906003)(356005)(478600001)(81166007)(83380400001)(316002)(8676002)(70586007)(4326008)(186003)(26005)(55446002)(41300700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2022 16:05:14.0545
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cdb7b844-ea5d-4d87-6498-08da6bfbf676
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3301
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
 minor features such as statistics and MAC address setting.

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
 drivers/net/ethernet/sfc/ef100.c          |   1 +
 drivers/net/ethernet/sfc/ef100_netdev.c   |  12 +
 drivers/net/ethernet/sfc/ef100_nic.c      | 142 ++++++++--
 drivers/net/ethernet/sfc/ef100_nic.h      |   5 +
 drivers/net/ethernet/sfc/ef100_rep.c      | 250 +++++++++++++++++-
 drivers/net/ethernet/sfc/ef100_rep.h      |  22 ++
 drivers/net/ethernet/sfc/ef100_rx.c       |  45 +++-
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
 22 files changed, 1180 insertions(+), 66 deletions(-)
 create mode 100644 drivers/net/ethernet/sfc/mcdi_pcol_mae.h
 create mode 100644 drivers/net/ethernet/sfc/tc.c
 create mode 100644 drivers/net/ethernet/sfc/tc.h


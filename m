Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3055761C3
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 14:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234471AbiGOMee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 08:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234250AbiGOMec (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 08:34:32 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2061.outbound.protection.outlook.com [40.107.244.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4199038A4
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 05:34:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=drVZincSW8jhRgKrrOZPjMguq3TywRNRQznLOjWLrnHJOkXUBy67ndFFz0f6meEIB/oaJliQCfYK3E9rMii+xDZEyesm05AFkqrCktXIGRH9DrSGSCZUrmv7jYUd1n+YhozD+y4BNeUV5ZlG65PbxJJXzy8wTR0j6nEvdNsgCLGyNi62T2M4xfByrs/A06Vv340o846+bqpKImLqi5kd+1952i5gzsvQjbb8+KmSCHxqbwqt6QofTccor6wEHpwaBQKLsTzSSPlhaPrXzQvTXXSSCf3PSZaDUs0uQ2HrSgqPVz/U3FkX4bSWwLUUcOUekI7cwmzSdqr0ZT6kPGEU/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TGvFLy2nAs3vSwxbj75/m9ejuDg6DFsf3Rdej5IT4Sk=;
 b=CYlH9fW/aqTKes7jJekPpAWPC7/UB+mZ1VgXU0aogqS0k/b6wRAtr8ezt3Aj+dz5cgi6XWCSD3daK6NKJSZta6C8PEoT6fZiYfMZGnRNFwYvBCPo/Kp/1P1TrHl2IbL5kUw9ASxduTUyGEhUFPmNvD2YCk+VpLnqhd+qF3cMF9dumqnk4zvr/FSKi0Q1MlBvEUoM+Dnpw/qKfHW8c7K0U/lYSkyDxxh8l9gqrkkJffZbqEwSqYI+3mlckJ43QuSBKQtVzghbGKTlkJB3/kdtWG/zR1CjLS9miy6aaEoEWS2Ilso2WawaWhY3+mu1avL/3MWgvFmenYh+qOlBCbhzvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TGvFLy2nAs3vSwxbj75/m9ejuDg6DFsf3Rdej5IT4Sk=;
 b=L2nfnEueNlNfC42HuW7Sh0eBEp9WcjintA3lw23UP2brBnbtMAqSMyvBEvL4oSZPUKy/65m/MlvfSRGOyhyoJnQVLG/jmnHfedy3OhLXKsvIgozzJfk3w9a2Gwq8N4I697DirV8OKiL2OdB34094IbBEf7TM8xE698TVSw412leb3R74z5YnnNzcCoRUaztPAo7h3NB5XbDbBveHLwIBle691sP23tq5SYnvfl5Kk5atAC5V3z3ZgTlrUvcSrCzxcCLIc9u8ll+5uDjlPENIOPJlCBzECGSzVym4dKXb/gvHkbzx1Xvz+KLMIUSZdOUY4mHHrrkbv01lDsLidpaYaA==
Received: from DS7PR03CA0099.namprd03.prod.outlook.com (2603:10b6:5:3b7::14)
 by DS7PR12MB6118.namprd12.prod.outlook.com (2603:10b6:8:9a::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5438.19; Fri, 15 Jul 2022 12:34:28 +0000
Received: from DM6NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b7:cafe::f2) by DS7PR03CA0099.outlook.office365.com
 (2603:10b6:5:3b7::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14 via Frontend
 Transport; Fri, 15 Jul 2022 12:34:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT019.mail.protection.outlook.com (10.13.172.172) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5438.12 via Frontend Transport; Fri, 15 Jul 2022 12:34:28 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 15 Jul
 2022 07:34:27 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 15 Jul
 2022 07:34:27 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Fri, 15 Jul 2022 07:34:26 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next 00/10] sfc: VF representors for EF100
Date:   Fri, 15 Jul 2022 13:33:22 +0100
Message-ID: <cover.1657878101.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f836f542-f29e-4d25-5e5b-08da665e5c1e
X-MS-TrafficTypeDiagnostic: DS7PR12MB6118:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0huWTMuIt54pYtWj/BmNdzXFazD373CYmCQG15p0CXFw3QCmBgYFuqglz0KoPtDpdD7eY04V6Ir75ifgzw+ImCADSddkzXgwTQURPX+5BrlI6d9ZK2FQAGypbTOllJu9DwpA67qJLHaNxklSKsHqZG+ajPf6U7MwlAOh+mEItAjOhl3Tm0yTjitTViBZ/kazy/CBD79Kh+DiPsa6CrBNeWymqlFSY60VRigdonjQoYK2rOMxA2hwm37L8p7FL87J4uA+fbfTRJQttBwCZRTy734fHOpgzd4w0Kq4G8ZLZPqqPlvGPPMW829m+o/fs0UY6UfSJExq8eJFZxxkeM8l2JHsrBO7VDBVtkUGhGyQbWXMTqYYfZWnSYAjgdshXf+M6xOCSTGztAo13I3MGEGIrpRraQw61H+jnojYpDLDOR0hE4xWGNF3cc4zmDoGZ/iW+Um1ioLVSiMjy1vYk96LmnlP97dthByZW3mnk3AUvEiowDCHFuUA6l7oBAiolQJyR1Br0ImvuS94a2IjHvwWWcUSHz+AB3ieUfFOVDNnB23kjYaZT+WOrTcci5/6UAKIcmLC7oNGweDAW64lixdPxWmTPYPPh/WL4VuFgf/tkaYzK1rqei2QRHnuDjpwrJiGPYcmgxvArA4S1p8rRioKShUNJ4TdXH+f01FTgymtUl+naTgBokylf6oe+X3zmq6d5YPcnKZ8WaSTOJOGUXQj6IbcBzwGhv6pfwBp/gEhLjiyYptVCW0kP+o6NIWBfM3J72Xh4Sgs1FZeD4K7XygyEOot3FuRkPwxkPqbj58BtYZLX5v2+l7jMVdgzt5thjlppU/K4LHKDudzrXdi5XAKTdYamngfvBBmfETr9Kpvdbk=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(376002)(39860400002)(396003)(46966006)(40470700004)(36840700001)(5660300002)(2876002)(2906002)(8936002)(4326008)(316002)(82310400005)(40480700001)(36756003)(8676002)(40460700003)(70206006)(110136005)(70586007)(54906003)(41300700001)(42882007)(6666004)(9686003)(186003)(478600001)(26005)(55446002)(47076005)(83380400001)(336012)(36860700001)(81166007)(83170400001)(356005)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 12:34:28.3705
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f836f542-f29e-4d25-5e5b-08da665e5c1e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6118
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

This series adds representor netdevices for EF100 VFs, as a step towards
 supporting TC offload and vDPA usecases in future patches.
In this first series is basic netdevice creation and packet TX; the
 following series will add the RX path.

Edward Cree (10):
  sfc: update MCDI protocol headers
  sfc: update EF100 register descriptions
  sfc: detect ef100 MAE admin privilege/capability at probe time
  sfc: add skeleton ef100 VF representors
  sfc: add basic ethtool ops to ef100 reps
  sfc: phys port/switch identification for ef100 reps
  sfc: determine representee m-port for EF100 representors
  sfc: support passing a representor to the EF100 TX path
  sfc: hook up ef100 representor TX
  sfc: attach/detach EF100 representors along with their owning PF

 drivers/net/ethernet/sfc/Makefile       |    2 +-
 drivers/net/ethernet/sfc/ef100_netdev.c |   16 +-
 drivers/net/ethernet/sfc/ef100_netdev.h |    5 +
 drivers/net/ethernet/sfc/ef100_nic.c    |    7 +
 drivers/net/ethernet/sfc/ef100_nic.h    |    1 +
 drivers/net/ethernet/sfc/ef100_regs.h   |   83 +-
 drivers/net/ethernet/sfc/ef100_rep.c    |  244 +
 drivers/net/ethernet/sfc/ef100_rep.h    |   39 +
 drivers/net/ethernet/sfc/ef100_sriov.c  |   32 +-
 drivers/net/ethernet/sfc/ef100_sriov.h  |    2 +-
 drivers/net/ethernet/sfc/ef100_tx.c     |   84 +-
 drivers/net/ethernet/sfc/ef100_tx.h     |    3 +
 drivers/net/ethernet/sfc/efx.h          |    9 +-
 drivers/net/ethernet/sfc/efx_common.c   |   38 +
 drivers/net/ethernet/sfc/efx_common.h   |    3 +
 drivers/net/ethernet/sfc/mae.c          |   44 +
 drivers/net/ethernet/sfc/mae.h          |   22 +
 drivers/net/ethernet/sfc/mcdi.c         |   46 +
 drivers/net/ethernet/sfc/mcdi.h         |    1 +
 drivers/net/ethernet/sfc/mcdi_pcol.h    | 8182 ++++++++++++++++++++++-
 drivers/net/ethernet/sfc/net_driver.h   |    3 +
 drivers/net/ethernet/sfc/tx.c           |    6 +-
 drivers/net/ethernet/sfc/tx_common.c    |   35 +-
 drivers/net/ethernet/sfc/tx_common.h    |    3 +-
 24 files changed, 8635 insertions(+), 275 deletions(-)
 create mode 100644 drivers/net/ethernet/sfc/ef100_rep.c
 create mode 100644 drivers/net/ethernet/sfc/ef100_rep.h
 create mode 100644 drivers/net/ethernet/sfc/mae.c
 create mode 100644 drivers/net/ethernet/sfc/mae.h


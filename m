Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4086A5F78E6
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 15:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbiJGN0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 09:26:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiJGN0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 09:26:00 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2080.outbound.protection.outlook.com [40.107.212.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A6BC5018E
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 06:25:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wg2HUjBK9a4DROJtXqsCcoWjqIW6i8AaHqapbsOBRvBV8UkeogqH/55UKABuGggLUkNnqLq2xNZ5bctvuAfNjT+CHhPaOZ0odXYjvDeHsplTP6CAjJDtgaLqFB+aZ9SxrD4GAoiTl1HsGFEQ7vGazN3sTROC6Tpc+iy0uUeQfQghRfEmB49aVrs/scNaNngVsccCjCGiRXcN5a4JDzPF/KUZBNQ8L5kjk1QAkOPc1v3mh4kvmlPedNJjBE4q35CuixDc1Jxw63LX1Qzmh8rOcGa8Kr8Svy8b1cUgIadvPIGuj4OdOtMsM4R9r4N3uUEzghXZHEIkNmtyc0DTseOVxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+bbLQQSsIx2xPIiTVsIJJPVvhQ08mKVTXihjXv0Few0=;
 b=hxtNqly3Tcpxsux4tfamlO+zO77xYQoOGLtKRsiLydVKfcJ/hEYwNhfum9NKDZ16zUKhF4FE3aprO3Rhm/wB3XwdgE3Gp4smEIZ30J82mKqmVHUm9CTiT+D8nqaNa7DecJyYMt2D1yNlGpOh6Nibr05E7FnRNgb5GBUQ5MMrotwkRUDxz5C4UEKOBVFlvMnwgYSpr0ZIADI5faAUIuoxqvtgZ8DQhHG9tUA9Gvm1kzwhef/Grct7G9hdXIrud/g/TNucg25iWpo2vQ1BvBhb0IqMAy2xFAx7t+5nRoFx6hBDSJDrwtSLR8SUd74+mPFktZI28bH8axsU8b2q22JoWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+bbLQQSsIx2xPIiTVsIJJPVvhQ08mKVTXihjXv0Few0=;
 b=uoVhKXmmkkFJnB3fXFzxzOHdB9lw/Bd2iRwKKuTxBliLmy4GuyjZOf23VZ02hUcw+jnRvCjJq9RmZBeR9a7V1aKw054tjAr4bc2k879NOKJ7TABRcJckxU6BIL2EwrTmiuS2+FLMI4RiyWI9oxMjKkPmdnBu26bUes5yZuvDY2bVEqxBXAd96JeVnofSrZS/4VXc6dUfh6EzJ5kQSqRKeg5g/vV1xwjAb62CvOIB6NeHaLacRm9AeyAfOfnA+AuX5vlXZoZySLGYufygueqeV0yz0eUZH7pXAnjkhUF112THdB/3GvEwrJPAtHuWP4nLWmo8NocgBNqRbaro+6gj8g==
Received: from DM6PR02CA0060.namprd02.prod.outlook.com (2603:10b6:5:177::37)
 by DM6PR12MB4233.namprd12.prod.outlook.com (2603:10b6:5:210::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Fri, 7 Oct
 2022 13:25:54 +0000
Received: from DM6NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:177:cafe::f4) by DM6PR02CA0060.outlook.office365.com
 (2603:10b6:5:177::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.26 via Frontend
 Transport; Fri, 7 Oct 2022 13:25:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT015.mail.protection.outlook.com (10.13.172.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5709.10 via Frontend Transport; Fri, 7 Oct 2022 13:25:54 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 7 Oct
 2022 08:25:53 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 7 Oct
 2022 08:25:53 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Fri, 7 Oct 2022 08:25:51 -0500
From:   <ecree@xilinx.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <johannes@sipsolutions.net>, <marcelo.leitner@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [RFC PATCH net-next 0/3] netlink: formatted extacks
Date:   Fri, 7 Oct 2022 14:25:11 +0100
Message-ID: <cover.1665147129.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT015:EE_|DM6PR12MB4233:EE_
X-MS-Office365-Filtering-Correlation-Id: ed530246-d984-4067-d2e4-08daa867763d
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UG29QuaoNUOBBVLlXmh8IfSXQGABEe2ha4Up0ViMV7OBqV/4L2mWTNKWwQ1PPk7wOg2kDqm6k4kPbR+L5vvR/foCWQ51y97WVavQRE8bJWXgb4V00lRfetOYO53jXtzx+mowuYJNegv4SCHMPRcxdb38ChkKitkJ7EJJait89Ka4uGVqKiZ1f4XzuyyPJoIkNJViyyQrTuV3T/rcTTpErG9jBwrW+qIKVdxb7rjUpXIdaAwxNf3Vjgc9zZfK0BJsEsM4M9BQmz8P2QMzBA/y/mr9T5JGGwBHiDc5so2pDIgGvHz7TOM4KT+08LWVWsTcBjfZH4aI/T92tA6BiQkmdsoAuF7zvuU40A/NJZIHY95OR8B9AuERZEiNXy8IXZfSQT3bVFc+K/lDpl05L6XF6ZgxNtSX732AjT9ilArQffmCbCa4SrfDcr8tglAKB7+nT3Stp+qW9y+xzKGLCpwytFtsl1PjUir3a5K0ycQE2Cict2dGp8bV1EV9HE6HyV3ToZnoS3GfdV6d6VTe3OTXkGHcqlT/Ylg5Bx622lQ8dTz4GMnEcBB3HmFLyG4HmiTcouIjgc6duOlJz+fe9FRd3LxPadu8BI6hWUHQnk+1v6v5L7Mo4ZvVPm3VP1eCNlv3Ch3yx8NQzivMoB46taRMGZ4y8bGEGx9xCYgqUVJBdY/2Az3ZWFwss3FzIg7BAIYK++p6VpOaFTTnvdxSfRtl1E9j/jplWgEycge6421DB02UMEavRLf0RFWTlsdqv7FBj9gSDYVM/KcqNjc9MOAhEthfdXekP6cyzqYHdm77EAY=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(346002)(136003)(451199015)(36840700001)(46966006)(40470700004)(9686003)(26005)(81166007)(110136005)(36860700001)(356005)(47076005)(83170400001)(8936002)(82740400003)(5660300002)(40460700003)(70586007)(70206006)(4326008)(8676002)(54906003)(316002)(478600001)(2906002)(41300700001)(82310400005)(2876002)(186003)(83380400001)(336012)(42882007)(55446002)(6666004)(36756003)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2022 13:25:54.4270
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ed530246-d984-4067-d2e4-08daa867763d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4233
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

Currently, netlink extacks can only carry fixed string messages, which
 is limiting when reporting failures in complex systems.  This series
 adds the ability to return printf-formatted messages, and uses it in
 the sfc driver's TC offload code.
Formatted extack messages are limited in length to a fixed buffer size,
 currently 80 characters.
There is no change to the netlink uAPI; only internal kernel changes
 are needed.

Edward Cree (3):
  netlink: add support for formatted extack messages
  sfc: use formatted extacks instead of efx_tc_err()
  sfc: remove 'log-tc-errors' ethtool private flag

 drivers/net/ethernet/sfc/ef100_ethtool.c  |  2 -
 drivers/net/ethernet/sfc/ethtool_common.c | 37 ------------------
 drivers/net/ethernet/sfc/ethtool_common.h |  2 -
 drivers/net/ethernet/sfc/mae.c            |  5 +--
 drivers/net/ethernet/sfc/net_driver.h     |  2 -
 drivers/net/ethernet/sfc/tc.c             | 47 ++++++++++-------------
 drivers/net/ethernet/sfc/tc.h             | 18 ---------
 include/linux/netlink.h                   | 21 +++++++++-
 8 files changed, 42 insertions(+), 92 deletions(-)


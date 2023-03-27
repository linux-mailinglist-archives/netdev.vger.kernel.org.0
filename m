Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD006CA187
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 12:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233441AbjC0Kgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 06:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232739AbjC0Kgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 06:36:52 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C0122727
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 03:36:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YfHbFfP2sG2W1A726h4qkgimmLZCTycI9HiGV22QtFHd4EU4YCVWoDVgQ4w4/bFy9EDY8x3uKlGqBXrdLpJljesblZYWcpr2bxuHxw5okKdi6QjQRFXOwoPrW9TuSJ5P2D762mqAI4UlvAdFT2hhT+Q/oEiyChPBpuxq7Wdnuujqwtz7NWDLLieRlxAlDXAOiTEzri9sLn/5vt34MIQ3UZOZkeY2IV9Akjf5Seg1mgjapCl16vFy0Ht1kZDFvV3ZW1HkmlYf/UagrycCzj6xdW8J7Yx9lRopdrbiYYwxagTskqDFeB9e6rGcqE4R1ooS6F7716zj9foOtKBOGmr1yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zvcntA0j6ivc4kpaBJ5MVl1WjpZCHqmD+epVz79BQsQ=;
 b=QVyONoqH6BdhSTUvEh4Y7RDC8T7HPprKE9f/v4ehAR2NqRshXRyYtDJgIzPhZTYxmfd64KdKFbB26tKm6iYKkuTL25H+n3e6i3BGypl2O5+RZfU74K2T8Rc5Af/MIzTUkl8HCYSkAPDirzrOK3qrXPr4g6ecabB1CitX67DhO6yb/3eRREu+9PX9P7L+Qj7nFsBS0gy46yrxp+IPjntitiaVz+RDXjjJgB0wYBKXBfavNV21ISrBmn2yFXnZsjN4p8XuX+ut8pC4i9DQ6zdV//S8JSwcn5aGY4wBC5aXKPd61rPb9SU4FNFjjCuXduZVUQN6mSgX0QR0LtXd1Kci7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zvcntA0j6ivc4kpaBJ5MVl1WjpZCHqmD+epVz79BQsQ=;
 b=nNpEEqqQfM2mN+9QFc9FImSJSEqCGQZDTH2B7H1DVZJs0gOeLOMwzfUCmPuasCEkicR2mg0stsj9Lf1qEI5pyyif7GICbzdJa9z8ZpHPkuKt3hNRuqJhGfnAZsoCRkEDFmTi1GhzWTC47hDLg95n0/RW3gIUP5aE7cCg9QcIa1c=
Received: from BN9PR03CA0636.namprd03.prod.outlook.com (2603:10b6:408:13b::11)
 by BL1PR12MB5803.namprd12.prod.outlook.com (2603:10b6:208:393::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Mon, 27 Mar
 2023 10:36:48 +0000
Received: from BN8NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13b:cafe::9c) by BN9PR03CA0636.outlook.office365.com
 (2603:10b6:408:13b::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41 via Frontend
 Transport; Mon, 27 Mar 2023 10:36:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT045.mail.protection.outlook.com (10.13.177.47) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.22 via Frontend Transport; Mon, 27 Mar 2023 10:36:47 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 27 Mar
 2023 05:36:47 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Mon, 27 Mar 2023 05:36:45 -0500
From:   <edward.cree@amd.com>
To:     <linux-net-drivers@amd.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>
CC:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <habetsm.xilinx@gmail.com>, <michal.swiatkowski@linux.intel.com>,
        <simon.horman@corigine.com>
Subject: [PATCH net-next v3 0/6] sfc: support TC decap rules
Date:   Mon, 27 Mar 2023 11:36:02 +0100
Message-ID: <cover.1679912088.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT045:EE_|BL1PR12MB5803:EE_
X-MS-Office365-Filtering-Correlation-Id: 845997f4-6944-4db3-5655-08db2eaf2b14
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bya0agaHsnpG9rQTo68GNCZ7zCaAupiai5GP2172SbnB6mx7ML6bLvn8L5Z3s1ndI7QDaj54rKj8+/433wn1o3qYblqjfMqLL6V4wKdutpgPZXG4kQuSYDgcGRTzETeQZVisjL6C08ks8ziOGLNjULcd+RgQupR+syWHJD23UIzwTb3si5fuwkctvXRfHyw/SWTZshpyPUMrIAbRCVxWpjuCfJy4TbWhQOiKLu6deKDMREejsigJOrPGJwvw9MB1wVR3vwF1FizUJY+TtN5S2B5XG8b9uFKLZ3L1NUDkx0R92C9qpFkGgV5AL8UzVzxaj0LBxNnayD/br1LAKf5MnsS3ufkpAWy/HgGNulhT4PqKAG+hbhth7OtuSO6+DWvmohWOHZ2IsnCDm0G8w/t17Kr1oZj/+46E0PpRLab0S+KFXPzackePmbMTL10BRdJsRX/jqE+VVAezsORyJHLmCT+3K3Y+sWEwlZlEPjIfomyHnFk/YnL3JN/tacstYI7yKtXpkepzB3hEcz1S+ji/8kkiPlMJ9IruzwsotCLvNJVD0X7BpKTGloVga48sAAGMDImsbDXu3HjovJ+Kx/q/27csLEfy2/HvKFW6/JY0OaKdSCFDyscACTMvbi+R4ombQPKHmjWU0mOVFR1PhhiUflDnAK88iFToQYredz/CFreYLP8KfgcNMJcaq7sIzycDOVHBvbMZ6JQ45wAlGPDjOj/YTfFa+pVZG51gkK6VyqQ=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(346002)(136003)(39860400002)(451199021)(36840700001)(46966006)(40470700004)(9686003)(26005)(186003)(316002)(8676002)(4326008)(70586007)(70206006)(54906003)(110136005)(6666004)(478600001)(41300700001)(8936002)(336012)(5660300002)(2906002)(83380400001)(47076005)(426003)(40460700003)(36860700001)(2876002)(82740400003)(36756003)(86362001)(40480700001)(81166007)(82310400005)(55446002)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2023 10:36:47.9496
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 845997f4-6944-4db3-5655-08db2eaf2b14
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5803
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

This series adds support for offloading tunnel decapsulation TC rules to
 ef100 NICs, allowing matching encapsulated packets to be decapsulated in
 hardware and redirected to VFs.
For now an encap match must be on precisely the following fields:
 ethertype (IPv4 or IPv6), source IP, destination IP, ipproto UDP,
 UDP destination port.  This simplifies checking for overlaps in the
 driver; the hardware supports a wider range of match fields which
 future driver work may expose.

Edward Cree (6):
  sfc: document TC-to-EF100-MAE action translation concepts
  sfc: add notion of match on enc keys to MAE machinery
  sfc: handle enc keys in efx_tc_flower_parse_match()
  sfc: add functions to insert encap matches into the MAE
  sfc: add code to register and unregister encap matches
  sfc: add offloading of 'foreign' TC (decap) rules

 drivers/net/ethernet/sfc/mae.c | 227 ++++++++++++-
 drivers/net/ethernet/sfc/mae.h |  11 +
 drivers/net/ethernet/sfc/tc.c  | 600 ++++++++++++++++++++++++++++++++-
 drivers/net/ethernet/sfc/tc.h  |  37 ++
 4 files changed, 857 insertions(+), 18 deletions(-)
---
I'm never quite sure when review tags should carry over to the next version,
so I've retained Simon's only on those patches which are entirely unchanged.
Hope that's right.

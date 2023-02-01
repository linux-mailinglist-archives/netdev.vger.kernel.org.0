Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF2B8685F43
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 06:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbjBAFvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 00:51:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231567AbjBAFvN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 00:51:13 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2062.outbound.protection.outlook.com [40.107.102.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDAE53E636
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 21:50:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ixbVhRNtIkmbqQ/WzaOFURPwmdBVCh1oAEJgJAO5rByuJkBiwVU0/Ena/Ipo9oU+edfh0Hrr7sweeqSif7qvGbbEHTofaw0Hpcnv6Q5BQ2uGTddM5Mf3lR9EdB7QHwitsbSNqLd6fKFElAjqiOFD3UJhVKo6dMBqNT9UB4Nk5itg62sdzF05m5lplgOojytCKUwQ9cHp9Yztepm5h4za2DaadDKsUYFXFYmiWztseYM9DWbWwYBG55PsLpQk9CHpWHdaHfFSq/y8W6kBioDjggZu0e2uja0T5+r/OgI6Z7C6hW6H4rbjKmPYSuov6Zs+pzCLzalldfk+z/7Tk5eetg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J37lkwsUfce63dMoBbVipY6HI41sQprHuIZBdgvO6Ck=;
 b=DnBNT16zlsWFrRWnKzIIqW6Ld8gG8GSEs4euAXjegDWjWw5n+8+7PbNmX3QIoPhYoyvtF+/3v1lBtB6VvVotuSkPWEHd20l6+KsTgqcFfPZPLc/UCqXEN/HYpGPMvbEx5u0/1K7iToUFJrKKqRmmbr3xgf9etdFmrd+UpqnhzZ+hJwRxyjMSEPtS+zUQoV5Iaco/m1CVu9lL52Piw6n8i3mN6b2LD56ECJwBPakhIEc6Szud8ymVSgndYkEBUsVOuET/R29jCTNPDaX4lt7acQPv25cO/aAmKD29QBEWQu3JN0ha2hn4iUUqxzNk9JCs5h4HcALFXfPoVHW5sTwTuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J37lkwsUfce63dMoBbVipY6HI41sQprHuIZBdgvO6Ck=;
 b=axPIncN7eSjmSQXAJL9BgrQ23C627LnNObzIeHZLFHEEDDfR56nn+VUPA11n6o0BbPysEDqyTY1pPCRvb8/304BT9eaFNOvQVtrb6t9zTI+EYGReDa/stodycdwXCNP5sl40uxmwVsYAf6tEv49h5mmijGYBC31+oGn2uTtd+54=
Received: from BN9PR03CA0147.namprd03.prod.outlook.com (2603:10b6:408:fe::32)
 by DS0PR12MB7605.namprd12.prod.outlook.com (2603:10b6:8:13d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Wed, 1 Feb
 2023 05:50:08 +0000
Received: from BN8NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fe:cafe::4) by BN9PR03CA0147.outlook.office365.com
 (2603:10b6:408:fe::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38 via Frontend
 Transport; Wed, 1 Feb 2023 05:50:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT030.mail.protection.outlook.com (10.13.177.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6064.24 via Frontend Transport; Wed, 1 Feb 2023 05:50:08 +0000
Received: from jatayu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 31 Jan
 2023 23:50:03 -0600
From:   Raju Rangoju <Raju.Rangoju@amd.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <Shyam-sundar.S-k@amd.com>,
        Raju Rangoju <Raju.Rangoju@amd.com>
Subject: [PATCH net-next v2 0/2] amd-xgbe: add support for 2.5GbE and rx-adaptation
Date:   Wed, 1 Feb 2023 11:19:30 +0530
Message-ID: <20230201054932.212700-1-Raju.Rangoju@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT030:EE_|DS0PR12MB7605:EE_
X-MS-Office365-Filtering-Correlation-Id: aafb0c40-b7af-47bd-f89d-08db04182d46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ea+Wc1pPxY6gz5ZunLo5DJt9SXVRNvgOhPYrAe0axJfXpvy45tby11Rroc1bDvvL06d6SDoGD9KWRoQ9njYSyfeE6CjsnS40gBpsqeb9OAmBhQqC0gpTKVft68pWDmTu2qxx1ooL5B7zB772JAR2z+XOcYGOZ1kzMaAbJelmL/1RtxbAT9xng1W1l/ZmcankHFtRT56/z1LKwRRNpthyT+utpAGbOdhYRmIdOLVz06BvA8NZ5OVxQOp6Z0keTAJbkkTUl0rBnHlfD+oagDpMXfwy/iA/MS2+wJVeJ96PCHR13ZNJQAR9mIj37mgJYZJson0b4d00V4/o2cWZqT6UxPStc+j+h73qPTpmLsIS9KZmU0nluY8mVPlJWx44dWYs6Upfv9xrOZF+isCHSLtYNcpuFJeKQYyUIG7abBCHlBFoXS2DBoIHPhCGlZWgM9zBcr1rNq/wTohi/3qix6j5W7RuPbDCWOvgsH2bTuKzU9aFgIuZwotcPYGTpcaqG8TYc6hTV6dnHTOAijbCjo+nW7jMS7bRNGei2B6jcYnMrtLbfksptRJEvaZuTngfofqIeB2NMAmtMjakj+Gvjb8wQ02eKJv/cSy66zWn3tk+DMYFGK5s1m5BRbmXMNZS66fiWzM8fe5Ei7Y8WtADAMDoTrKbIE4mF2w7st8cVP/I6QUrhYbfjdWgOK8exSJyoBQjwRHmfC2mRALFlln0pVlnMA6YoUfT0hQv68SmWUjiHjwNNlz6Nribud9uiIUhoxFKph0lvqFj1XWJV2J423leuQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(39860400002)(136003)(396003)(451199018)(40470700004)(36840700001)(46966006)(336012)(36756003)(478600001)(8676002)(6916009)(4326008)(70206006)(70586007)(82740400003)(83380400001)(81166007)(54906003)(36860700001)(316002)(26005)(6666004)(1076003)(7696005)(16526019)(2616005)(47076005)(966005)(40460700003)(5660300002)(186003)(41300700001)(356005)(82310400005)(86362001)(40480700001)(426003)(8936002)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 05:50:08.7315
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aafb0c40-b7af-47bd-f89d-08db04182d46
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7605
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds support for 2.GbE in 10GBaseT mode and
rx-adaptation support for Yellow Carp devices.

1) Support for 2.5GbE:
   Add the necessary changes to the driver to fully recognize and enable
   2.5GbE speed in 10GBaseT mode.

2) Support for rx-adaptation:
   In order to support the 10G backplane mode without Auto-negotiation
   and to support the longer-length DAC cables, it requires PHY to
   perform RX Adaptation sequence as mentioned in the Synopsys databook.
   Add the necessary changes to Yellow Carp devices to ensure seamless
   RX Adaptation for 10G-SFI (LONG DAC), and 10G-KR modes without
   Auto-Negotiation (CL72 not present)

Changes since v1:
 - remove the unneeded inline usage
 - re-ordered the code to quash forward declarations; however there are
   couple of them since there is a circular dependency. Below is link
   for the same:
   https://lore.kernel.org/netdev/20230131111155.5cb607a6@kernel.org/

Raju Rangoju (2):
  amd-xgbe: add 2.5GbE support to 10G BaseT mode
  amd-xgbe: add support for rx-adaptation

 drivers/net/ethernet/amd/xgbe/xgbe-common.h |  38 ++++
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 187 +++++++++++++++++++-
 drivers/net/ethernet/amd/xgbe/xgbe.h        |   5 +
 3 files changed, 224 insertions(+), 6 deletions(-)

-- 
2.25.1


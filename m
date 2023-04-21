Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1892B6EACB4
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232367AbjDUOVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231521AbjDUOVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:21:08 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2068.outbound.protection.outlook.com [40.107.237.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 256C213C32
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 07:20:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WuAg6On1lsElLXlFdQ0wrO0dqvpX3gUpKyDCxU2smZ+5tRHPXhuInA9/hS4MhmoOYTmjHa5MBAvtzR19wR2ASsvgADfc8dfWJhcmzxWDSNaYUQXABmNJ6jPEdMcRh3wzz3aru/jBp+d/WTSnOXJAY5LNTpoD2ZNIR2iET3HhVXznB24wtLI7keWqo+9ykoXRRb0jZ0y+2nUyRIc2N/HBa4D8S7YYcIuh/BWX63ZNnkx/3XI1bgtqQzdf+VHzkl2TAfTsbTOa+/FLgLAN3DQu8JlBnNnpoygS7JlxvpgyDaBOQhAHv3G9hwAjUqsg+mLPJyHjnArgx4WBIPr1f24zPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OmiI7FYFUGubmN1RljPDk2VO4d4DB8O13DSBdpNYUxY=;
 b=BrOVIpvITdWAmasBgGuvZJI2yAei7lFTwr3M7yEPfZneCL0IVWk3kVLNLI/9MjpuHuhJ/A26dRXHfCGZOZFGkipg5y/w51539KqdXgAFA1WFhhqk8GNQ37jSkcLq8YARp/H/xSIKOgcz3PeNfkiye5MKJLKwB54ourqPBzprtdC5diVpcjx0t5WFXZdp9d4fMAhjQS6LWbrJnhuZs1n6kG71m9guQ/zGnTvp1/6OXIf7XkKr+BeUSvGDc0n8mPbq00qMoMsrNDGQmEmAfMtRKazM8doUwXdNMxR39k8JiTOSo2Hrqw7wZMuLxPhxIbadIcsK3v2cWH+eiXXSYvAvjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OmiI7FYFUGubmN1RljPDk2VO4d4DB8O13DSBdpNYUxY=;
 b=mqAB8yn40Vijzw5zJpq6VOVUrLQJLqxtUM5qoNkJfTt78oqcfyShilb/cQfjJCm3OM5l5b3/KBR33uLYr/nu2JIy2evmGXEO5B2ZhmRw6d0evc/Ea0VHNyGp+sP5Hj5W9ptPHwPLXZwMtIec7jZAqQPVVamCLuVRESOBMXwU33Q=
Received: from BN8PR04CA0063.namprd04.prod.outlook.com (2603:10b6:408:d4::37)
 by PH8PR12MB6820.namprd12.prod.outlook.com (2603:10b6:510:1cb::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 14:20:52 +0000
Received: from BN8NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:d4:cafe::5c) by BN8PR04CA0063.outlook.office365.com
 (2603:10b6:408:d4::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.27 via Frontend
 Transport; Fri, 21 Apr 2023 14:20:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT036.mail.protection.outlook.com (10.13.177.168) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6319.27 via Frontend Transport; Fri, 21 Apr 2023 14:20:51 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 21 Apr
 2023 09:20:47 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 21 Apr
 2023 07:20:47 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Fri, 21 Apr 2023 09:20:46 -0500
From:   <edward.cree@amd.com>
To:     <linux-net-drivers@amd.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>
CC:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <habetsm.xilinx@gmail.com>
Subject: [PATCH net-next 0/4] sfc: more flexible encap matches on TC decap rules
Date:   Fri, 21 Apr 2023 15:19:50 +0100
Message-ID: <cover.1682086533.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT036:EE_|PH8PR12MB6820:EE_
X-MS-Office365-Filtering-Correlation-Id: add6248e-32f5-4d1e-0a12-08db42739c63
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gG9TYSYwSpZELRuCcy4O3U8SDWgpIwtRDU4uGtN5PqUF0/8yqaagbEnOzW9RkE3162p7T160KUVCeblo8vWNDbnltzzqHHrNzvsv3jQ7XuLR8g2+YKEnH2QRL3lxLhL1kCDzE7i8nQoetTlXDl9P+P+nckNJbvFUmNJ8TZFoHTGWYgTTdim4unmqbuI1+ZH3w3RG15lyGT9o7GnP45dtR1NaBk8W0UK1HAPZzjKqOaDMSFUzs3RavJ1ZGL3HhWGpa9Ni5uxnDYUC3Aqm4ujSf1oWtqKcEGJsRse0wFIJxyFeRkim+s9CTY57/vSSKL4nZFrz6WHbFpwuQIWsLNIK2K7T4lXbh2s3ANg1NzZrLKQ8iztWyla1tJc//zcFwAoBmkZpeippgy/RyjftX8spDWx/nBOMltmXy8/NzVxqmgEtjUtZp27tzBhuUMLNDVcKo0WG420eiFkQ0Vkxda67OChOV3GWE5AssoLu881hdcjzeyNG56ELkYVq816tcEeyEVcBMdlsJTEui0d3EARW0tkzygt+/FvW3TBcJOBEOvXqk+1S9+84F6kMcmGKC5qAqCThTIOYOWmQvrc9T93yWowXlIuSWFgnwjCjWeAE55YrjBE6ZIAfUJuiNY3BANsyAxiLr3p+3+rzojd7387bv90zYGNdCI31Ks2EfmStktibaSnaW3nMHTs13kT1sCXwQguHxzXEMFfzO68wpCJxCxFUrbaOF80l3tTD0OxdITs=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(376002)(346002)(136003)(451199021)(46966006)(36840700001)(40470700004)(8676002)(8936002)(81166007)(4326008)(70206006)(41300700001)(356005)(70586007)(40480700001)(316002)(82740400003)(40460700003)(2906002)(2876002)(5660300002)(186003)(86362001)(9686003)(26005)(36756003)(426003)(336012)(82310400005)(47076005)(83380400001)(110136005)(36860700001)(54906003)(55446002)(6666004)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 14:20:51.4997
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: add6248e-32f5-4d1e-0a12-08db42739c63
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6820
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

This series extends the TC offload support on EF100 to support optionally
 matching on the IP ToS and UDP source port of the outer header in rules
 performing tunnel decapsulation.  Both of these fields allow masked
 matches if the underlying hardware supports it (current EF100 hardware
 supports masking on ToS, but only exact-match on source port).
Given that the source port is typically populated from a hash of inner
 header entropy, it's not clear whether filtering on it is useful, but
 since we can support it we may as well expose the capability.

Edward Cree (4):
  sfc: release encap match in efx_tc_flow_free()
  sfc: populate enc_ip_tos matches in MAE outer rules
  sfc: support TC decap rules matching on enc_ip_tos
  sfc: support TC decap rules matching on enc_src_port

 drivers/net/ethernet/sfc/mae.c |  28 ++++-
 drivers/net/ethernet/sfc/mae.h |   1 +
 drivers/net/ethernet/sfc/tc.c  | 205 +++++++++++++++++++++++----------
 drivers/net/ethernet/sfc/tc.h  |  27 +++++
 4 files changed, 197 insertions(+), 64 deletions(-)


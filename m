Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BAD95BDCBB
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 07:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbiITF5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 01:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiITF5P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 01:57:15 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2065.outbound.protection.outlook.com [40.107.94.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F63ECCE;
        Mon, 19 Sep 2022 22:57:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X/9ppMKoTJJA87yHIpdTs/WRy7icD+NInH5312+E2KlVHKAnYlb9T0f0alhzkmY3AHb/eUkF32BbDRmymJ7DQW9Yc5nqHuw/AdKCMVa+fR1mCcr8RXi5hZkvWiA0iL0iFX+Z7Ftx1RYaERNVD8y9fZABEZolFp3epck4PI9O3F4vKQHIKZsmBiuv57+FAKJ7He9O1yUKzrxwpAchRxCUnX2tMWQ6InDKIJjcFBTwtGwCig4pqTwC5eeNY0y0cAl52jUCnL7Eu5U8qkwSs2aDohbNBMUdoRQa7smJocHufwlFCVRyp/IX7L0NbT8FAylcjnuWySS/kPPhybncLVotDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N9cDEIxFcPEF4yCbmSf/9iPBv0F6hd2Ix0Vce2IUWWU=;
 b=iGd5hErGB5teZY1buIEvIz/tIhDjQmfdc1xtVjGV9Oa/k7BukVziQMavL5sTbfklagjgC3bsNWJWLwltaPqve9NgrBMJlwaBiVyFYdWs9woqv6lF9kZvYoFbSPPxZvR+4CBadHkDQgIOu9zS0yD9ashDe19NjbdvM+HEdexI9ODYLKaVLeqvQhKyWrzU2bD0Y89W2sHifWmfpDMEyOFycjCX7YZcUhxdQhAuQnx9zHJFyeaeKOGuXAHvFIgoBS6rh3KqL1KrysK4dEe8hctozFQJtJslVBymuZb0o+ZoJmY4Ni1JBrwFCOJ7LkoVuGMQ6lPBLBRd1d5eN88SxQNCtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N9cDEIxFcPEF4yCbmSf/9iPBv0F6hd2Ix0Vce2IUWWU=;
 b=15jSxrSxeHcoT+vB8Q8L7PWeiBpkec4k2PEVqOy1nswpElM+l7a4UI/oPoAYlD9JBJikAryxr2QxODBvYMFzEUAoHjD034iS9A9c5m77zL32neYuG0lgjZsyB/BGxzghkt3p5Eqlvg6Z2IcJ2u8nBcq26GES2CZ2yw67XsjTp+0=
Received: from BN9PR03CA0528.namprd03.prod.outlook.com (2603:10b6:408:131::23)
 by DM4PR12MB6351.namprd12.prod.outlook.com (2603:10b6:8:a2::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.21; Tue, 20 Sep 2022 05:57:12 +0000
Received: from BN8NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:131:cafe::ac) by BN9PR03CA0528.outlook.office365.com
 (2603:10b6:408:131::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21 via Frontend
 Transport; Tue, 20 Sep 2022 05:57:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT022.mail.protection.outlook.com (10.13.176.112) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5632.12 via Frontend Transport; Tue, 20 Sep 2022 05:57:11 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Tue, 20 Sep
 2022 00:57:10 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 19 Sep
 2022 22:57:10 -0700
Received: from xhdswatia40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.28 via Frontend
 Transport; Tue, 20 Sep 2022 00:57:04 -0500
From:   Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <linux@armlinux.org.uk>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <michal.simek@amd.com>,
        <radhey.shyam.pandey@amd.com>, <anirudha.sarangi@amd.com>,
        <harini.katakam@amd.com>, <sarath.babu.naidu.gaddam@amd.com>,
        <git@xilinx.com>, <git@amd.com>
Subject: [RFC V2 PATCH 0/3] net: axienet: Introduce dmaengine
Date:   Tue, 20 Sep 2022 11:27:00 +0530
Message-ID: <20220920055703.13246-1-sarath.babu.naidu.gaddam@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT022:EE_|DM4PR12MB6351:EE_
X-MS-Office365-Filtering-Correlation-Id: 6dbe50ae-aa7e-4568-e3a6-08da9accf5cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tebY2D7kN/eROth/3kwxMouEdfm1vwMDy14jIxstuTytZmCiCn6I2waJ08WGMPucoDWZpV5CsqAaG+2hYc1K4dwYFxzgkjFkC1ot7W65njM7jaOgGlscRr6jcXLzvyGrHNSjVkB0VpRDPAZwWArfQFo4NIHe2BBTvehZvtXfBeV+u6fyJGO7QdKkJ177VCfRysOMsfMYSvynZTEtJAkAaeZfwVPimCnm2y2wPAK2CpkJM2hDoCO98r3kVCtrGMBbws9eJC1MliDZT4l3vTw9rsDNPtPEucUg8yWAM8r3slyeC75C2CilJCct1ZxiFQVZRHMmLGx1kWA0Dlhcm+eCCTJ81s2TWH+uw2rDsDQzj0Kz0KLoKJf5Pg3fI9Aa606jeSAJaojfqkesGNJ3rQ6mk8c/i7o2ccp3SsQMz/lH4SgOZcpwMXwMGquEJrEmF/wxggl0HK4wEEmsMz50vXxshhhFS10EbwHXBrNYBdsHpBQgA+v4r0NY5Q4eyV2k8Z0RpFGmYbYafEr3hfZZOol1p5smzv1EF1F8NUiLmsBk1/MCgnOo1zaFio3sUFThwgLUec8cOadGzn8VxtubvfWI32vY6tIw/q+3qtnnz6+hPxu4z3LjpcQhFx3jo9oOjGGrJdKU92uiQg0ksh4TCxWXeMmi15wduWw3cmaoUyK8n/P7pSPW40RCyhNOL6pBb6pbLUfDpZpK40N2fIDkXSMeyVUi5x9E+BazWWFQ1kVvOgxpWnbw4b6F4r7Yt1EgDugV048pOjzoGlSxr/g1AetGEA9aY16fUuXn7nvKrDW4XdA=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(346002)(396003)(136003)(451199015)(36840700001)(46966006)(40470700004)(40480700001)(356005)(2906002)(2616005)(186003)(426003)(47076005)(336012)(82740400003)(26005)(1076003)(81166007)(40460700003)(86362001)(316002)(54906003)(8676002)(4326008)(41300700001)(103116003)(70586007)(70206006)(478600001)(36756003)(6666004)(7416002)(110136005)(8936002)(5660300002)(36860700001)(83380400001)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 05:57:11.3482
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dbe50ae-aa7e-4568-e3a6-08da9accf5cd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6351
X-Spam-Status: No, score=0.9 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The axiethernet driver now uses the dmaengine framework to communicate
with the xilinx DMAengine driver(AXIDMA, MCDMA). The inspiration behind
this dmaengine adoption is to reuse the in-kernel xilinx dma engine
driver[1] and remove redundant dma programming sequence[2] from the 
ethernet driver. This simplifies the ethernet driver and also makes 
it generic to be hooked to any complaint dma IP i.e AXIDMA, MCDMA 
without any modification.

This initial version is a proof of concept and validated with a ping test
on an AXI ethernet subsystem 1G + xilinx AXI DMA design. There is an 
anticipated performance impact due to the adoption of the dmaengine 
framework. The plan is to revisit it once all required functional 
features are implemented.

The dmaengine framework was extended for metadata API support during 
the axidma RFC[3] discussion. However, it still needs further enhancements
to make it well suited for ethernet usecases.

Comments, suggestions, thoughts to implement remaining functional features
are very welcome!

Changes in V2:
1) Add ethtool get/set coalesce and DMA reset using DMAengine framework.
2) Add performance numbers.
3) Remove .txt and change the name of file to xlnx,axiethernet.yaml.
4) Fix DT check warning(Fix DT check warning('device_type' does not match
   any of the regexes:'pinctrl-[0-9]+' From schema: Documentation/
   devicetree/bindings/net/xilinx_axienet.yaml).

Radhey Shyam Pandey (3):
  dt-bindings: net: xilinx_axienet:convert bindings document to yaml
  dt-bindings: net: xilinx_axienet: Introduce dmaengine binding support
  net: axienet: Introduce dmaengine support

 .../devicetree/bindings/net/xilinx_axienet.txt     |   99 --
 .../devicetree/bindings/net/xlnx,axiethernet.yaml  |  159 +++
 MAINTAINERS                                        |    1 +
 drivers/net/ethernet/xilinx/xilinx_axienet.h       |  169 +---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  | 1165 ++++----------------
 5 files changed, 398 insertions(+), 1195 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/xilinx_axienet.txt
 create mode 100644 Documentation/devicetree/bindings/net/xlnx,axiethernet.yaml


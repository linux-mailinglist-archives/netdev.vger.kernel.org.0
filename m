Return-Path: <netdev+bounces-6314-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0519F715AB0
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 11:52:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E2BA1C20B79
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 09:52:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A550516418;
	Tue, 30 May 2023 09:52:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F5E1640C
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 09:52:14 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2054.outbound.protection.outlook.com [40.107.94.54])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ADDE107;
	Tue, 30 May 2023 02:51:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=it5UYb8CgKI0343VfANaot8oIIYMmMNnJGRHUZqPur/SNBZficiAa0afQPmCklQH6e5fv6PPTXsmVGwxMG36MyWXcPV7MRiIAbsVap6p5dCUCxI6F7RqsGIRUWknatlJ+DdGpRl+pLwhSxFd8a2RvCJ4uYUxkD5rKFZERwmuUahbYXJ9gfduQ0PSpMk1shydTBnxr7BuAAsAm3SucQnlCWr5xhs5JXaEpooFZG51kdUWLVbfZp+I9y/GTPHo+eBQbfJUB97GsEgqtCFQqgsYSJ9NLz0ZrSFpXNwMsdAxOVcb1sVprIXIOZLDIu/sUZTBVhVG4kG+4cwWi4t5pbhiKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IrajCeCb7cgAEhN9x0cg11BgXO9HKr5qwYp2/jdafaw=;
 b=fRROuP4EthBwAOs+2vLmWtCBBpyrvfa/Y6hFd6ygtQ91mxZMqVy287hVebRktPcJzWp9gghjDw3SBiodq3W5NHJkUPqpF/e84Df5sm2fss6WzVRGopxPG0nZ6SsVYBrbUpqt7RdwR6pYnH/IwiFdhGyK2qXd0cyAutdS9W9itS+adl3uSCOk0b5lG3nQ7axKXg7cvgHWUFhVVKCfMdeTE/smRJ+4MJDML7+FyyeCpc/LwpNfa7CXZ9sCaWiTrwadWbHfZXU3wkPO8T1rNooZZzAiYHmykVvqPTfN1+Ml9sigq6gIA/zqHZBHVepldsnRDX6op97aF3arwAmCSo2AdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IrajCeCb7cgAEhN9x0cg11BgXO9HKr5qwYp2/jdafaw=;
 b=po27/zVBOI6pvKWb/n6O21MgjAsx3pxWxIzfsT6FdBJUfrs7H4xVRBWDp/JlLdguxEHdcCuyoJfVfvX0UwatR51W0NDnOjJmWM+R9mmiooG3OWsYQo9/p9g+KONLqgXhB10GbDEf3gLtEqOUrfdLuLVP3zZHw/4SZJ71ndW+2EQ=
Received: from BYAPR02CA0003.namprd02.prod.outlook.com (2603:10b6:a02:ee::16)
 by PH7PR12MB6693.namprd12.prod.outlook.com (2603:10b6:510:1b0::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 09:51:45 +0000
Received: from CO1NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:a02:ee:cafe::b0) by BYAPR02CA0003.outlook.office365.com
 (2603:10b6:a02:ee::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23 via Frontend
 Transport; Tue, 30 May 2023 09:51:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT041.mail.protection.outlook.com (10.13.174.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6455.21 via Frontend Transport; Tue, 30 May 2023 09:51:44 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 30 May
 2023 04:51:44 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 30 May
 2023 02:51:43 -0700
Received: from xhdpranavis40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Tue, 30 May 2023 04:51:39 -0500
From: Pranavi Somisetty <pranavi.somisetty@amd.com>
To: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <robh+dt@kernel.org>,
	<krzysztof.kozlowski+dt@linaro.org>, <nicolas.ferre@microchip.com>,
	<claudiu.beznea@microchip.com>
CC: <git@amd.com>, <michal.simek@amd.com>, <harini.katakam@amd.com>,
	<radhey.shyam.pandey@amd.com>, <pranavi.somisetty@amd.com>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<devicetree@vger.kernel.org>
Subject: [PATCH net-next v3 0/2] Add support for partial store and forward
Date: Tue, 30 May 2023 03:51:36 -0600
Message-ID: <20230530095138.1302-1-pranavi.somisetty@amd.com>
X-Mailer: git-send-email 2.36.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT041:EE_|PH7PR12MB6693:EE_
X-MS-Office365-Filtering-Correlation-Id: aa2f718a-4ba2-4715-1408-08db60f37a4b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	FR7DwKRZx43V3hjkYateTV0t5LuOO8scWa7c/jLTxdp/FqRZ5WX1U8y+eB1p8OHBA/qe3cgJFyV2BdzPO8xcLCHMdTSKfUnLHCJVGH0PRzBOY3Y0rNZ0sw6x3FM2YG1wPmU4GXG7qjHoSb2oN0rpnwHmjK6CpzRxQqWq3Xwh6JASy/rI1ybu2Zlc6ZxU3JVCEEEuVziv0hy8aGjRBWLx/6YJXhBudZNnEzeNd+nTWClRIKqtiSJeFgJaBWg7FxS4NN75nYC/SeNVQsWZjhW6rJnezj9fTI3qPMLNE/lYy1+apbJ9sDTZlrdpOXSB1ERWqYgjsyPjyF10Jq1jv5rOiWSQ46OpfklfPFPP3dW+2z0PH69F5HbOe9WPTktTCS1YCE9BgjWgfZB+926XxG5bWEVXlnJK3tavjUs+UfmDzt33xDb6ZZQw5MgwLWA9keV7bFXmtzGn1RCEKeJSc057VQPC9J+zakX5GvuKwKZrOTGYZY/IlI12HoRQxw2NySpouVSgQjtsbPFZfND/BSpF/QZHppB02Eo2p/WW1jE6cvmcsGw2J3S7ukLYBwZF/4b68jh6WfS805669gQaiwlX6h+Twby5HDjQtxBmA2y4/dhXKwo4RT4k/uzBmB4UyPTeVA7nZ/wQKX7etjPB2OLBmJLj7zKgcBpmiHEaUGMTeHzTSj/53bCLtVF8aaSv0Bwqrm7PXtSlYCu8hROQ369563WPnRUn2LAilPAemwFUNFCx1uRRTHZ1vQagli7jUOJUcjWQlbKZs3TzetJTk+lv897KzzGru21EUoMJtHWU+Ps=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(376002)(396003)(346002)(451199021)(36840700001)(40470700004)(46966006)(1076003)(26005)(186003)(316002)(6666004)(2906002)(40460700003)(5660300002)(41300700001)(36756003)(44832011)(7416002)(8676002)(966005)(8936002)(478600001)(82740400003)(81166007)(36860700001)(356005)(40480700001)(54906003)(336012)(426003)(82310400005)(4326008)(110136005)(2616005)(47076005)(70586007)(70206006)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 09:51:44.6711
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aa2f718a-4ba2-4715-1408-08db60f37a4b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6693
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add support for partial store and forward mode in Cadence MACB.

Link for v1:
https://lore.kernel.org/all/20221213121245.13981-1-pranavi.somisetty@amd.com/

Changes v2:
1. Removed all the changes related to validating FCS when Rx checksum
offload is disabled.
2. Instead of using a platform dependent number (0xFFF) for the reset
value of rx watermark, derive it from designcfg_debug2 register.
3. Added a check to see if partial s/f is supported, by reading the
designcfg_debug6 register.
4. Added devicetree bindings for "rx-watermark" property.
Link for v2:
https://lore.kernel.org/all/20230511071214.18611-1-pranavi.somisetty@amd.com/

Changes v3:
1. Fixed DT schema error: "scalar properties shouldn't have array keywords"
2. Modified description of rx-watermark in to include units of the watermark value
3. Modified the DT property name corresponding to rx_watermark in pbuf_rxcutthru to
"cdns,rx-watermark".
4. Followed reverse christmas tree pattern in declaring variables.
5. Return -EINVAL when an invalid watermark value is set.
6. Removed netdev_info when partial store and forward is not enabled.
7. Validating the rx-watermark value in probe itself and only write to the register
in init.
8. Writing a reset value to the pbuf_cuthru register before disabing partial store
and forward is redundant. So removing it.
9. Removed the platform caps flag.
10. Instead of reading rx-watermark from DT in macb_configure_caps,
reading it in probe.
11. Changed Signed-Off-By and author names on the macb driver patch.

Maulik Jodhani (1):
  net: macb: Add support for partial store and forward

Pranavi Somisetty (1):
  dt-bindings: net: cdns,macb: Add rx-watermark property

 .../devicetree/bindings/net/cdns,macb.yaml    |  9 ++++++
 drivers/net/ethernet/cadence/macb.h           | 14 +++++++++
 drivers/net/ethernet/cadence/macb_main.c      | 29 +++++++++++++++++++
 3 files changed, 52 insertions(+)

-- 
2.36.1



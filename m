Return-Path: <netdev+bounces-10289-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 750E972D969
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 07:43:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 26E05280FEE
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 05:43:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 114921FDF;
	Tue, 13 Jun 2023 05:43:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE40C361
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 05:43:53 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2072.outbound.protection.outlook.com [40.107.223.72])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FC949C;
	Mon, 12 Jun 2023 22:43:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P2dWphUEqwbfTDpwObWYF7GmCyb5J/SftWjjG+jH7KGBNh5ulvxtM9t+jCjnkVa62ckAaL5nTGsus2Yc9oxRGWI7L7yHriDY5aIPXOSa0SI2N6Ob4RecRw5D4WKn1Ebx7A4gnHXIcfE4O1M9gFr9malBqMGPRLg0mIAz5t5hHWTwJXMJxI2PX0dA4jiR7VKKb1flWEtXoqw/nMQH8z0OVm17d5jVZJkTIxpE6qZiL4ZTxK1uiR/zvlJm5EbWdmJ2bcd7BvVuCKCnIAfgu1laTlF1JlImYD9/slPTSN3SXZ6OoHJ0iWBbK8zIV4mcKAv/EcUjgWTwZSWpPG0JHQ7Hew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XAQVmwxlSt/DNWrc5lo61379VYHxohRPpxrDzLpGRHc=;
 b=Us4zSL/U9Qdz2uu9ILfNjX4I7HT4GgXlCFM0DWu/p1g9X8rRfWrn3DFlo+7UWtUb0s3FQzn+jSt6e75hXN8NX8Sw9CtcUO4qUAfp81y6EdM70e+S4GPa1RvZbz5fYuOP22Fo8AJ/DEoZnGaEzsB5TwqFt+B75I4ELQnA8sMbLs2YqnglgR01GbbA9CKfF7QGw3RwzmDhIiSkbypqS9SGZU2w4eqdlWNKtmrAMMoT0Zdvcen1v/BJ4fXO2L8NVEi05Gi5h5H8cf/SNiTMtqpNSum7nDORfd580RBBOlKebBBZd51z2JJGQyVOWPrVzeXANOui3HYDyCGfHvxUOQ9R0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XAQVmwxlSt/DNWrc5lo61379VYHxohRPpxrDzLpGRHc=;
 b=FqXSRKpBoBb93sRN3dFJobP4IlurmqlYMr2IwA838SF8NGp9pCTM57o9UzKnjX0m7W9KVRTPWFDjhB13MuFYZaXkmK/ZJxd3mqEYlq1P3e/W/WihlcGJ5o/L0VG70J0l58tXlLUO+biaBM6e29ot5R0OCla07jzqkWJYGX/V37k=
Received: from DS7PR06CA0039.namprd06.prod.outlook.com (2603:10b6:8:54::7) by
 SJ0PR12MB7458.namprd12.prod.outlook.com (2603:10b6:a03:48d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.46; Tue, 13 Jun
 2023 05:43:47 +0000
Received: from CY4PEPF0000E9DB.namprd05.prod.outlook.com
 (2603:10b6:8:54:cafe::2d) by DS7PR06CA0039.outlook.office365.com
 (2603:10b6:8:54::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.35 via Frontend
 Transport; Tue, 13 Jun 2023 05:43:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9DB.mail.protection.outlook.com (10.167.241.81) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.22 via Frontend Transport; Tue, 13 Jun 2023 05:43:46 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Tue, 13 Jun
 2023 00:43:45 -0500
Received: from xhdpranavis40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.23 via Frontend
 Transport; Tue, 13 Jun 2023 00:43:41 -0500
From: Pranavi Somisetty <pranavi.somisetty@amd.com>
To: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <robh+dt@kernel.org>,
	<krzysztof.kozlowski+dt@linaro.org>, <nicolas.ferre@microchip.com>,
	<claudiu.beznea@microchip.com>
CC: <git@amd.com>, <michal.simek@amd.com>, <harini.katakam@amd.com>,
	<radhey.shyam.pandey@amd.com>, <pranavi.somisetty@amd.com>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<devicetree@vger.kernel.org>
Subject: [PATCH next-next v4 0/2] Add support for partial store and forward
Date: Mon, 12 Jun 2023 23:43:38 -0600
Message-ID: <20230613054340.12837-1-pranavi.somisetty@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9DB:EE_|SJ0PR12MB7458:EE_
X-MS-Office365-Filtering-Correlation-Id: 2fbf7943-5f4c-400b-b382-08db6bd127f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	/n+QIW5LuoF3CJ7WucBGwtAm2FV3WYbrAN24rTSxqZwNk0wFC0dky1Zta6odmg81/c4+lBiQaRm+DboSDJUJwsDoQOREszBxE+NqN0dhEO+VzKricvB0hJBTD4QsmXn3WtzJSgYzU6+2VyTY7HiOTFo7GCnbm/jbMf9HIe15oYD7Hm/WbaXpIgOAI9kdJeziu821b5k5ZigVIEpwwYKUr62TThEE7zyD1X/8gEUdshy7ckU7gsSiEx32Qkz1CmaQdxCG+QkehIrtNNvLqWFZGd1FP+8ujf8MFdNTReMmpMtf8sXG3mL9nOrXBbUL3YVACj+ssvQI0NOHlIsXMRtdnKhbf213QXOqUY5oeZEwt+HrgDXs7IPwQ0LD0CHYSAeOjOEykTmLHvz6RAscIryunwYSCpdl1DJUG5AEDKRpRi5w+QAdqTap+JUg5FWrnWdBY7gfQpzq19iOoPGmxGjb5lZsyfBqFAs3uChWHOUHMhO0hCSPAA5R7Fnt5sgYV2aoPoNyOO1EaDwfZsGrNUqMPfoDzHf4D21fIeM9v0TUIHKcaEP+HlLakrM/XVpwAIN5DYTeuViMShsBsXRWfIAttu3LttMFBf/oPuBaMbE2l087sPZC0kcHD83f1YvgM9TYhFU51KMEDy3/Q7C1c/YkRPlGpUyY+/ZbB66WUsJ7r1VNLNig1GJIve1TFlRDnh78kbzGRXN8RlMvtgt5jCgw36sK4CIXRZxK+7enIygh3+7jUmrHKFhmoIsx23CwJ+i1r812pQXqrCAnMYAo6aj51UgJtNs/PrfJrJlY7ACnMGQ=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(346002)(376002)(396003)(451199021)(46966006)(40470700004)(36840700001)(82310400005)(36860700001)(40480700001)(47076005)(83380400001)(336012)(426003)(82740400003)(81166007)(356005)(4326008)(36756003)(316002)(41300700001)(6666004)(966005)(1076003)(26005)(70206006)(70586007)(478600001)(2906002)(7416002)(40460700003)(5660300002)(44832011)(8936002)(8676002)(110136005)(54906003)(186003)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2023 05:43:46.5132
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fbf7943-5f4c-400b-b382-08db6bd127f9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9DB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7458
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
Link for v3:
https://lore.kernel.org/all/20230530095138.1302-1-pranavi.somisetty@amd.com/

Changes v4:
1. Modified description for "rx-watermark" property in the DT bindings.
2. Changed the width of the rx-watermark property to uint32.
3. Removed redundant code and unused variables.
4. When the rx-watermark value is invalid, instead of returning EINVAL,
do not enable partial store and forward. 

Maulik Jodhani (1):
  net: macb: Add support for partial store and forward

Pranavi Somisetty (1):
  dt-bindings: net: cdns,macb: Add rx-watermark property

 .../devicetree/bindings/net/cdns,macb.yaml    | 11 ++++++++
 drivers/net/ethernet/cadence/macb.h           | 12 +++++++++
 drivers/net/ethernet/cadence/macb_main.c      | 27 +++++++++++++++++++
 3 files changed, 50 insertions(+)

-- 
2.36.1



Return-Path: <netdev+bounces-1756-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A0786FF115
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 14:08:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 301E81C20E9C
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 12:08:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2B5219BD8;
	Thu, 11 May 2023 12:08:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEBCB65B
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 12:08:23 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2053.outbound.protection.outlook.com [40.107.92.53])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3BBD30CD;
	Thu, 11 May 2023 05:08:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nWKqbb/vAlRsGm+vEuB7Gsc8h74htJR2irZMEgaCsxeqGcbqBZT+pVuPyilr7ZEW+fbW4iq58Jl3W/0Xt5KHQKQc9ZIX69Itmlb1dW3fGG2cqnN9xfp+CBh8UjssvvBkynF6m8DBAWVg7EjzE/5cH7MGoIhC47adh2AXXf0s8Xun0tHwz5wJyyNEDG3BER+etSX4agOPyXOTaP/XCr7j8MNaGupB/MVfUZ6nP/V5THEIt8n+d11Sf8mnbzxo33Dr/hgjW4nr4JE/CWPuCDPnkU3Rh+UBXsHEtH4zrRtEVqbSpx35ukQMTQe4COJl9ajPVk8ndkXtsEnwMFWy/zW+wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gqFbsTINfbFhaqd4iTOFYv2v2qVNnRaM9LHQwvboaPA=;
 b=CT4TBY6kgBxVfn1qQWg4jGheOoRDnpxTpjnoIPJ4xCYirG0RJV5iq7ysTMjmR9kdVr9A89MITaBlc1qaVVeYiAQjI6804sJWFSm+HIMsbgPTr64CLqjA/Y6H+WnXmHCE4SD6lox/8LEkOKuiIrprM1ziVX4DM3U/a05UNXOVR9SmwFfGRdv90wd5ow/jD3ZIv5DmPOCaPEMl3U4ATFyeuiUwcOzQR42Z4l3iaVCiHgLpY2AZc3DB2wpe/TyPc5DzYNNVPIrxNfLCb7kD/TRnnnSTnD/YC4DrZeZZ6XP5PTnL3CXgWqYD3MUvqm9Fj/S2bEgC0WuKXu3CIIclzq3n5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lunn.ch smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gqFbsTINfbFhaqd4iTOFYv2v2qVNnRaM9LHQwvboaPA=;
 b=FU6zOyrw1qgBmwehJssFu2cuEAf1h1mhW8YP38TFPx63CpMHaOqOtlFBhf6EEVODkp5HNEZWuKu0h4cAeF+YhaeYtoV8kRS2q7B6tQZkflMF+VQFqxmeQjoWTs5CyXEVA+f7Q6lKR62d5UxR/aritVBzF3dIHgpAVQ9FgE+Kyv4=
Received: from MW4PR03CA0035.namprd03.prod.outlook.com (2603:10b6:303:8e::10)
 by CH0PR12MB5251.namprd12.prod.outlook.com (2603:10b6:610:d2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.22; Thu, 11 May
 2023 12:08:19 +0000
Received: from CO1NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8e:cafe::43) by MW4PR03CA0035.outlook.office365.com
 (2603:10b6:303:8e::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.22 via Frontend
 Transport; Thu, 11 May 2023 12:08:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT016.mail.protection.outlook.com (10.13.175.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6387.22 via Frontend Transport; Thu, 11 May 2023 12:08:19 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 11 May
 2023 07:08:18 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 11 May
 2023 05:08:18 -0700
Received: from xhdharinik40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Thu, 11 May 2023 07:08:14 -0500
From: Harini Katakam <harini.katakam@amd.com>
To: <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
	<davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
	<pabeni@redhat.com>, <vladimir.oltean@nxp.com>,
	<wsa+renesas@sang-engineering.com>, <simon.horman@corigine.com>,
	<mkl@pengutronix.de>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<harinikatakamlinux@gmail.com>, <michal.simek@amd.com>,
	<harini.katakam@amd.com>, <radhey.shyam.pandey@amd.com>
Subject: [PATCH net-next v3 0/3] Add support for VSC8531_02 PHY and DT RGMII tuning
Date: Thu, 11 May 2023 17:38:05 +0530
Message-ID: <20230511120808.28646-1-harini.katakam@amd.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT016:EE_|CH0PR12MB5251:EE_
X-MS-Office365-Filtering-Correlation-Id: 59146002-824f-49a8-000d-08db521868e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Dg5zZC6YEi2bRc68FyM8j/wYPNuctwpS/HDzeEVJS24k2r7zUVLC8fVxZA6u+X2O0WMTpd1KaPBvCfXxDXCX8LwACYHO2wC7gXHNVVrjEzR9JHJlCuoen8j3herRVK8xw3mpa2ycrr6NkmF5iqD/SYgPbF05ZdytAEzyjYC27C7fqIrNswAWeMDHoRB9SnazepmBFDZiR7+POyhBYdUMn5+YE53LhZOiJcf+IQSB/cDRbKZTl3bgKmRi67ZzGTKTtYVb9huNJOKI6btqKkOq/d2hOiLiYF0faoq1KzAhiyly7/skyzd3NuhVjLYBmf7oJHX83cmIHtsH6DXsZa6p2Vz+oWhtTtrOvgZzxK7GvRopvpNCyt7YOYBbQohhFTrrL3mATP5uYFtgbB3JQP6LsdfAA+qyYrWcdhdLpa7oiUy2Q9HuH1dJPTFD0mTpo+A369h4BxPJkZFRgXpojWllB6P2w5pjEGd4QXUycYpcZ57AvOZ06/0uo+HLfA2AdXTuvIVGjwr7ojtqfogFzwatniq6TocozCQzN0YngZD64cXQ6VRSpqgXuTM2hOAxFcBGvNvqVZgCFLy4rpKfw/cZBmri4t4Y/jTWrkq1liIaE73freQ+k7gSG16Ucq5rCFAIKwvbwWSFNtEasxxT/3DVDytdqvb7luNvvtqxZrKKcwawAAJbFKozf49vmS9c9sU47Twpayn4w7H3C1ipg90IwEi5EWOPLL1L9O/N3V1dZDDaQtW1+JKEiIZdlvLtBHQE4eVppFOjNHrpT0iA10TtzdhV/9KclKPrjm0lehTHE3s=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(396003)(376002)(136003)(451199021)(46966006)(40470700004)(36840700001)(41300700001)(6666004)(70586007)(70206006)(40480700001)(4326008)(1076003)(26005)(110136005)(54906003)(316002)(478600001)(8676002)(8936002)(44832011)(36756003)(5660300002)(40460700003)(7416002)(82310400005)(86362001)(2616005)(36860700001)(2906002)(336012)(426003)(47076005)(83380400001)(81166007)(82740400003)(186003)(356005)(921005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 12:08:19.3985
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 59146002-824f-49a8-000d-08db521868e2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5251
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add support for VSC8531_02 PHY ID.
Also provide an option to change RGMII delay value via devicetree.

v3 changes:
- Remove patch 2/3 from v2 as custom mscc properties dont need to be
defined. rx-internal-delay-ps and tx-internal-delay-ps can be used.
- Change RGMII delay precedence as advised by Vladimir:
 phy-mode                       rgmii                          rgmii-rxid/rgmii-id
 --------------------------------------------------------------------------------------------
 rx-internal-delay-ps absent    0.2 ns                         2 ns
 rx-internal-delay-ps present   follow rx-internal-delay-ps    follow rx-internal-delay-ps
- Split VSC8531-02 and RGMII delay config into separate patches.
- Correct vendor ID
- Update commit description and subject everywhere to say RGMII delays
instead of RGMII tuning.

v2 changes:
- Added patch to use a common vendor phy id match
- Removed dt include header patch because delays should be specied in
ps, not register values
- Updated DT binding description and commit for optional delay tuning to
be clearer on the precedence
- Updated dt property name to include vendor instead of phy device name
- Switch both VSC8531 and VSC8531-02 to use exact phy id match as they
share the same model number
- Ensure RCT
- Improve optional property read


Harini Katakam (3):
  phy: mscc: Use PHY_ID_MATCH_VENDOR to minimize PHY ID table
  phy: mscc: Add support for RGMII delay configuration
  phy: mscc: Add support for VSC8531_02

 drivers/net/phy/mscc/mscc.h      |  4 ++
 drivers/net/phy/mscc/mscc_main.c | 75 ++++++++++++++++++++++----------
 2 files changed, 57 insertions(+), 22 deletions(-)

-- 
2.17.1



Return-Path: <netdev+bounces-6059-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9143571494E
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 14:20:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BFDCF1C2090C
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 12:20:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21EF26FCE;
	Mon, 29 May 2023 12:20:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100E96FA1
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 12:20:32 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2060.outbound.protection.outlook.com [40.107.93.60])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A22B9B1;
	Mon, 29 May 2023 05:20:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EEGlJTKph5d4h5OuuYxPAjk3UUVyLjNZtWCD9zjw0QYmOBxbQ846JaQFzf4KqEuZwm6yCkb0eGxODISK9UMCstc201cJKOMEUCgZTfxJw/XjsJM5OJbw08mvrfLwVs3fy4/5WzgY8RNRfIsLRKlfxhlV36UmpWWwhGMAcj7zH5Yd/Umh9lXu47tMMuH9ikKiBZSM5ZqYgn/P0WBzvLLiJ2vDRRfk7kJoq6F1mWSDkRfUE4cSzxinC9qW4NRQc1TLhOAr5GE8ywNeCX7rxC+XpNN7tHDKsuSRFV/n0HPCGXMMoCQF/WtRyynaKoYcdRlFdl/5XfB3jqp5RqzqN7HzQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B4MUWjP3SxbFI+na7qC14eh2vyk1E4yiBL6G5mU0Qfc=;
 b=EqiTiBQpqDj2qBVeX9Y7lE3Nf9Bmwpu6Aqs3CGT/yEvlpCwwPKAW4Gjaz1JgzXJqTgP3OrlAE6yLmopyMmVjwEHvPs5ZDnTrSgmsOyBOJDqE0mINJSTuM9I7ShCSOOrhO1W9FW9Rg8pQY7KNIC8+6o39IwMJbXUvR/KVkrrPyrovwXz/BpgOeyrvrn2kM3MhygJFIz2rfBpgG4+yzY3SCTAXW1SEmng/qiT/0qcxQ5etcrNE8ho2AiMd+Oh7GBKbOxTJbhB8N0J1TqETB2B3CMU/14EVCkwNiYfsuNvgBPXS7t9XJ0tkJI+5w99Ihl9zuyFaLBohZVv+rCOEit0DKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lunn.ch smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B4MUWjP3SxbFI+na7qC14eh2vyk1E4yiBL6G5mU0Qfc=;
 b=lghiwa9gL7S+FYfRSCAM2BiAfyySCKc9P0dCXzOaoAB2i0+nzVXC1F1N0A89WHt6b1Ij+b9QLL2mHJs8Cbsme/qeUhNwiW94WvfbjMFERRWiSMIb4GGZ23Jjp88WfZ3Vgobq/ATUjCDqDSAxgB4Jh9aTzIPi3YcEFYHD4WOXEiM=
Received: from MN2PR19CA0052.namprd19.prod.outlook.com (2603:10b6:208:19b::29)
 by BL1PR12MB5127.namprd12.prod.outlook.com (2603:10b6:208:31b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Mon, 29 May
 2023 12:20:29 +0000
Received: from BL02EPF000145B9.namprd05.prod.outlook.com
 (2603:10b6:208:19b:cafe::b7) by MN2PR19CA0052.outlook.office365.com
 (2603:10b6:208:19b::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23 via Frontend
 Transport; Mon, 29 May 2023 12:20:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BL02EPF000145B9.mail.protection.outlook.com (10.167.241.209) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6455.18 via Frontend Transport; Mon, 29 May 2023 12:20:28 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 29 May
 2023 07:20:27 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 29 May
 2023 07:20:27 -0500
Received: from xhdharinik40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Mon, 29 May 2023 07:20:23 -0500
From: Harini Katakam <harini.katakam@amd.com>
To: <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
	<davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
	<pabeni@redhat.com>, <vladimir.oltean@nxp.com>,
	<wsa+renesas@sang-engineering.com>, <simon.horman@corigine.com>,
	<david.epping@missinglinkelectronics.com>, <mk+kernel@armlinux.org.uk>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<harinikatakamlinux@gmail.com>, <michal.simek@amd.com>,
	<harini.katakam@amd.com>, <radhey.shyam.pandey@amd.com>
Subject: [PATCH net-next v5 0/2] Add support for VSC85xx DT RGMII delays
Date: Mon, 29 May 2023 17:50:15 +0530
Message-ID: <20230529122017.10620-1-harini.katakam@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF000145B9:EE_|BL1PR12MB5127:EE_
X-MS-Office365-Filtering-Correlation-Id: f5b1113a-d6ae-44fb-ef1e-08db603f171e
X-LD-Processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	HR4KikGNPj2wrTb+ddBIlIDnja8gwIam5cDJPnj0eOXpkEIKh/FiMT+46R67JBTBWIwTYaa5+3R2oV3LQgSMFLcPUzszX2rFMv9KIxBfx8JJC1l85PTe/w9BgGHRw7YjvvlDkBM/YNsIuEAfFCxREA79g7/lp+A3gwgvrYYqRDV+8O5NfU5b+ZXiU63cdzIf9wRCEe1Fey0XNZysck66VZmrbzI83lKAd+T281LaIHhgi/zAqRwyboeoEQrHDHWWxR6AD2Ttf3Lpv6SKKm+l4MbNXOFhDNowqp5Jy+Lh4sioRJfxwqtI8JUvZmQ7+qVVqHw98aNXsTHEVuAwfSGXPphl0BGEIwSJf9A/9KpS9hxLCHb4Sfk9ppCsYqhr0tUCcvRLc+hCXXfHhoKoulDGHmZyuZqx1DQEp8V0YHI1kQE7qq8HlsXn2eN2x6SMbPXXHtiIlFUam0EOV7tAS5N5/5kCn7vhiee1/5syRlA+CJrzdwdLsZqCnNSqdfWlawijFaNcYT0fv2jy1qRofobMqLcnqDFo88ZvhDMCC7yluspZfBHSwnyRMHzwe7GxnRsVGxp2KnDobTOVKUDkxkVQ/9VeiUku+8S/W4LCOzWF6fPvfAxbhlwDx9qfNUwTQWKy6m7tt2MZKXgatMoqe2qLYEA2XLWjliQ1VdVzLeCTNKW0L+CalZ45zgv6DgisJ2S+6Uw6cMceEgjbhGwjjoxaYpEwblhcfdVblDjNNPQV5c+7Nm0/7wDM23nNlRd6z7S+THnLEjYQULvylcKrJ4tKgQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(396003)(136003)(376002)(451199021)(46966006)(40470700004)(36840700001)(41300700001)(316002)(82740400003)(6666004)(921005)(356005)(81166007)(4326008)(86362001)(8936002)(2906002)(82310400005)(8676002)(2616005)(7416002)(70586007)(70206006)(110136005)(36756003)(54906003)(44832011)(1076003)(26005)(83380400001)(966005)(478600001)(336012)(426003)(47076005)(40480700001)(5660300002)(186003)(40460700003)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2023 12:20:28.9697
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f5b1113a-d6ae-44fb-ef1e-08db603f171e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF000145B9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5127
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Provide an option to change RGMII delay value via devicetree.

v5:
- Rebase after VSC8501 series is merged, to avoid conflicts
- Rename _internal_delay to use vsc86xx, move declaration and
simplify format of pointer to above
- Acquire DT delay values in vsc85xx_update_rgmii_cntl instead of
vsc85xx_config_init to accommodate all VSC phy versions

v4:
- Remove VSC8531_02 support. Existing code will identify VSC8531_01/02
and there is no unique functionality to be added for either version.
- Correct type of rx/tx_delay to accept correct return value.
- Added Andrew's tag to patch 1

Lore link for v3: 
https://lore.kernel.org/netdev/20230511120808.28646-1-harini.katakam@amd.com/

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

Harini Katakam (2):
  phy: mscc: Use PHY_ID_MATCH_VENDOR to minimize PHY ID table
  phy: mscc: Add support for RGMII delay configuration

 drivers/net/phy/mscc/mscc.h      |  1 +
 drivers/net/phy/mscc/mscc_main.c | 51 +++++++++++++++++++-------------
 2 files changed, 31 insertions(+), 21 deletions(-)

-- 
2.17.1



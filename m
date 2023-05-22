Return-Path: <netdev+bounces-4284-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A57570BE4E
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:29:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1AB8A1C20A5F
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 12:29:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F03212B70;
	Mon, 22 May 2023 12:29:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2B04408
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 12:29:35 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2081.outbound.protection.outlook.com [40.107.244.81])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD3A930EE;
	Mon, 22 May 2023 05:29:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bzQl9U4GphCeHbf8q9qVhEVS4Nwu2WdwZ97bGr4l0/QcIrWSiqSCsVcGk5nQ76JDpfSvzd4D021WXx18atpt3n4QNNRwnW1xGOoSWjuhyTudRMn+mXkBOIrTUHjUi6JYuHzlMRp8tiJTRbgf/ArYAUyAwi1hiNVOLbbajuYr//DxBMvTC6LictnWSMHngbOBbK9UG16tl5UVqD3YddRy7KIXZFNmdaDk5hnyYJUwDmI0pYFxlAeX4CSSwt2e1+olOCcgQM749RWz7UNkOSsoPWA5HqS/kzWgkK0cp9qz2faHFiDNaWLFXx2S9Q4Tzz+cBBX+OaY63IkM6pk8N/WX0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hHOze/NeEo2d9G+qhCyCYmZsru1FpbjfI2R7gG937HA=;
 b=WK/4+7xDlxCzKy31zHORb4Ux6Vpbjo+8wHq8ynfIO7Ro6kTSo/9WmVSkEHxWtkHo2ZssI7BNHoBLvs20BEfW1SYFNqapVabUHRf7K8w9N21SccSYI9tTVNvQScsmt2oYI8zG9FXcK0e1fxISo4ZEeRmC2FmY74Im7xwChsYmWRdA1Vj2Vr7LQP+bn3Y3IEIBgZi2qZcex/XveFB4Bis4P/e0bQmHLegkJVZZ2tBvtYMmQE66MK+5X4BCPwnV5d5kQu0Q53d2GobbrcGl9uhP+UowAly3Q4cBG8g/Y0HSHnTqHn5NwJpyL8F6EEhJQ2RtalTXJZgm1t+fnjSgDt8vsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lunn.ch smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hHOze/NeEo2d9G+qhCyCYmZsru1FpbjfI2R7gG937HA=;
 b=aITafFDGkbInmRErWaLtjHwGqGcoMw4mek2oQy2i1Puvvqeip8NSmhq7WykWc+R/MDINlphhJBWZvV9+1eJ36/3ex0ZPc0wOMANgWEJ40AG21KMcojtVRs+AarzFeVvdzTVdzgx0XDug+ce93URmn/Q8rCWeuanjxStHuPJepn4=
Received: from SJ0PR05CA0015.namprd05.prod.outlook.com (2603:10b6:a03:33b::20)
 by SA3PR12MB8000.namprd12.prod.outlook.com (2603:10b6:806:31f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Mon, 22 May
 2023 12:28:35 +0000
Received: from DM6NAM11FT093.eop-nam11.prod.protection.outlook.com
 (2603:10b6:a03:33b:cafe::ee) by SJ0PR05CA0015.outlook.office365.com
 (2603:10b6:a03:33b::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.7 via Frontend
 Transport; Mon, 22 May 2023 12:28:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT093.mail.protection.outlook.com (10.13.172.235) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6411.28 via Frontend Transport; Mon, 22 May 2023 12:28:34 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 22 May
 2023 07:28:34 -0500
Received: from xhdharinik40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Mon, 22 May 2023 07:28:30 -0500
From: Harini Katakam <harini.katakam@amd.com>
To: <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
	<davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
	<pabeni@redhat.com>, <vladimir.oltean@nxp.com>,
	<wsa+renesas@sang-engineering.com>, <simon.horman@corigine.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<harinikatakamlinux@gmail.com>, <michal.simek@amd.com>,
	<harini.katakam@amd.com>, <radhey.shyam.pandey@amd.com>
Subject: [PATCH net-next v4 0/2] Add support for VSC85xx DT RGMII delays
Date: Mon, 22 May 2023 17:58:27 +0530
Message-ID: <20230522122829.24945-1-harini.katakam@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT093:EE_|SA3PR12MB8000:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a32d80d-6547-4d45-d138-08db5ac00fdc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ZVvF9hxt7EkZEHHPX0aS55VMSHhj9t0dZrNuIpPmMwK0TIdwb6fgkmiqx3Q687xAW5CosYu0VSGXmiMRyVLsU8Ac8AZ1blen91+8Jtmx9M5YGO4xVKTjr20RygKEiexzvKqbkwmCrrNAR3PqZBjq0HvVDb9lsRlM/XRUvG68IDmoPASn4kt8OGCTpaI6vUAdZW0NhHRq+lu2hmWBGyJKuAKkTlq8ambqnL1kFo8DUaKo/CwBvOG6I/fJjG4GGSgQ4PpTfQDeiW7/lYjQdOEHs5av4VrRIY7Yiv1pYTEmUG7QnBephIA1Uf2tpZbeEBECvvcjy+/vasfbPwaCXM9UEU1RcL2RVaOkhoROMPJFo1lbI203ahF19TLz25mYHyNbUMszm1HWtn3NE/i+NbEFzac/Kyg+853s6bYYmKfGZZe4X/9NRejX8a316uIlsPvBe+es7ENkznu0AdDsr+Um+UCHWySErkC6noE+aDPfYjjAzcI4yjT4HlZdjwoKDPclgiWytKitrWAfFLQWX+ThWBl3/6yxdKDi4OXz2eiePsp9PxLGn5AWa1XlA/DsRF9GIbemvElVOyeP+dkBzX6u2QTtv/d0wg+lWdlmapkpsxNeYJ8Y3Oan4GqKTG+pOLZ1sU6zV4hPPto0sNvVw3I5XuiSP0/JvvNfzqtMTRjkt3bVT76/rrrk7qFd+RJcLYaT2TmVcoD5rWlcdKFRMpqhc4x0B3K7lZ7nbnYQlD26ORZJi9E/CHH7tnHdGVljZGjFDK1bp6W/RSySp9W+LLo2kQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(376002)(396003)(39860400002)(451199021)(46966006)(36840700001)(40470700004)(82740400003)(81166007)(921005)(356005)(40480700001)(82310400005)(36756003)(86362001)(40460700003)(8676002)(8936002)(7416002)(966005)(44832011)(26005)(5660300002)(1076003)(2906002)(47076005)(2616005)(336012)(426003)(186003)(83380400001)(41300700001)(316002)(6666004)(70586007)(70206006)(110136005)(54906003)(478600001)(36860700001)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2023 12:28:34.8626
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a32d80d-6547-4d45-d138-08db5ac00fdc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT093.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8000
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Provide an option to change RGMII delay value via devicetree.

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

 drivers/net/phy/mscc/mscc.h      |  3 ++
 drivers/net/phy/mscc/mscc_main.c | 49 +++++++++++++++++++-------------
 2 files changed, 32 insertions(+), 20 deletions(-)

-- 
2.17.1



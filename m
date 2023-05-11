Return-Path: <netdev+bounces-1676-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D5026FEC6D
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 09:12:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BB3871C20EFE
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 07:12:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 967F82772C;
	Thu, 11 May 2023 07:12:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ECE81773B
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 07:12:27 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2085.outbound.protection.outlook.com [40.107.244.85])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 463A45FF2;
	Thu, 11 May 2023 00:12:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kejsKJle3o+eTQDD2utzi9aGsPELzCrBlQeeFZBWOKpjZzvIX7u7Ia+otUvDxcQOgBg5tHo5xBgMdcZbnGCO86IOwhvVKgapOC30q5w8yv9AD4dLdBVpBOmu1APzWvx6yqqMgT0S0caG6XBmT8aDdXd6J5tV35Ib6nBg+zO8uOh2myBgPkjMluEdOO8iHy5wPCIyPLi+IdptHZm+qaCBaRhEaSkbqV0QMC0+pPSQ42ajDjdgz4CT9zVXPYjpvO32Mj6Fx0vD2c6pN6MYzhHvIDyYIqMnoPoDST3TjYGXNCtRNImdLqWNiyow1/8XPTbLUsXG2E4aMC+9X21+/Mlx+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cR1eSAPeKE9sDzFU4q6fTGobelKu9Txb0xgvuezt8cE=;
 b=besUacLHiB8uD1Z/OUg3ADvltMYiCuopDud5VNBik90hs7pYxBk6Xi7a4QQoU23Wot2CDwZMg0S1vCqwiAA5Z69K+6WyW1kj4T7lDr+LLw+7yQFn8GSrT/f9lj5HNc4Flnc1h6gzJD8GxxBWDPwrmvaWij6oMnTK14heTjMkGrKChcFNqJWOE7Rwzlg4/YyYMDJYhVs5QAdkfaYYX4b93pp1K43Tqr3OyVitdQhdmvaZcgcHaCcV3cxKbsN0kDQf1RYXuWM/+TqE8g1utC5PSjA5lHdlnUKNQgsId4UYVDLupslV+MxxfSBeC9h1C1U49qjNvrv4dBUty1vmvrRKKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=microchip.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cR1eSAPeKE9sDzFU4q6fTGobelKu9Txb0xgvuezt8cE=;
 b=CwiiOiaxQ332e9U6bOmyFlIW0gAiwdHeDgBS6yot/jNxJtoz/hSvqd8GjbMaU/aF/DbTOg9+BoDy+bIHmZPYCOBJDf331Vhye/ThDxujV+wBjOHsgPKcxO/AaWQYCcKCuGo1cjDn8f/6iROssn6mcv9rLUZMRPD0ZpsByWXR+QE=
Received: from DM6PR14CA0042.namprd14.prod.outlook.com (2603:10b6:5:18f::19)
 by CY8PR12MB7244.namprd12.prod.outlook.com (2603:10b6:930:57::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Thu, 11 May
 2023 07:12:21 +0000
Received: from DM6NAM11FT090.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:18f:cafe::83) by DM6PR14CA0042.outlook.office365.com
 (2603:10b6:5:18f::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.21 via Frontend
 Transport; Thu, 11 May 2023 07:12:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT090.mail.protection.outlook.com (10.13.172.184) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6387.20 via Frontend Transport; Thu, 11 May 2023 07:12:21 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 11 May
 2023 02:12:20 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 11 May
 2023 00:12:19 -0700
Received: from xhdpranavis40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Thu, 11 May 2023 02:12:15 -0500
From: Pranavi Somisetty <pranavi.somisetty@amd.com>
To: <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <richardcochran@gmail.com>, <linux@armlinux.org.uk>,
	<palmer@dabbelt.com>
CC: <git@amd.com>, <michal.simek@amd.com>, <harini.katakam@amd.com>,
	<radhey.shyam.pandey@amd.com>, <pranavi.somisetty@amd.com>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-riscv@lists.infradead.org>
Subject: [PATCH net-next v2 0/2] Add support for partial store and forward
Date: Thu, 11 May 2023 01:12:12 -0600
Message-ID: <20230511071214.18611-1-pranavi.somisetty@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT090:EE_|CY8PR12MB7244:EE_
X-MS-Office365-Filtering-Correlation-Id: b8ae1346-a3de-4fd6-9f9b-08db51ef1054
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	gAbfezGnug/vPDrU2lTLNehzivrb6EkLUOJhpCjljT7tjRM0u8sUnGhjTuEcRGCPJG+At3MYgj60INdKx4djr4WDOyyzkgqz2Mrco4/3w9uKK6FJjRdlZDmcJC3TIJr9hsQEj9J3PmU2Dl9hZKPdEnEtGQtWm8EdxJNn4sDXHJxjTBI/1GUSAgJMHK7VvYGfeoOEWldBymfWBoaUbPiPLV3xPlPfXBgeiFdbwCTVA3wIS81YKl0GV+1LBQUQZ6+5VhPUQUclzDCv49lLAZIKFh6mnkpP9ZkKFUgPGm4zhL1bpaz9T3xw4yYfklIGCV0gsyY8HAmXZvyHvXh/IEwGwqGPh/stv8ZW7hlrJfJWshn16ba0rj9Xil6Elur22Kau2BJ4kmJNre/C6foaIllGZrGU9pfuNj3vqOcTxNGXnd2zz7JeNS/7/vslM34lDtY3R1B+kt+7o5YQD7+8884eFGEPOf/S+TA/kMTi15bFqK8mLjRNMhD985xlNWZc8xe1kJnjYZZQxp1cjJgz4THfLn+g236+lReBCzru0VLKZ0ozCvXMGp3ZyvaFp6rfqJWhQdEbQAshPWoiDz5ppRLI1VLdsCMMSaagccIJ/kDCIeJ66FxqIfPPcXKZSpLvyOgfH5hGmAJT+nkOaCiuBq/1420CAgCjA/PFU0v0U3qha3rBzXj+1UukOrVC941u+Rk7UtCDqmxvxuWRPWsGc5Smk9IIH+U+FRU4bpNLX/hBg5o=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(396003)(376002)(39860400002)(451199021)(40470700004)(46966006)(36840700001)(2906002)(2616005)(83380400001)(4744005)(186003)(4326008)(36756003)(70206006)(70586007)(1076003)(426003)(336012)(36860700001)(47076005)(26005)(41300700001)(7416002)(5660300002)(966005)(40460700003)(82310400005)(44832011)(6666004)(54906003)(81166007)(110136005)(82740400003)(40480700001)(316002)(356005)(8936002)(8676002)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 07:12:21.5290
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b8ae1346-a3de-4fd6-9f9b-08db51ef1054
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT090.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7244
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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

Pranavi Somisetty (2):
  dt-bindings: net: cdns,macb: Add rx-watermark property
  net: macb: Add support for partial store and forward

 .../devicetree/bindings/net/cdns,macb.yaml    |  8 +++
 drivers/net/ethernet/cadence/macb.h           | 14 ++++++
 drivers/net/ethernet/cadence/macb_main.c      | 49 ++++++++++++++++++-
 3 files changed, 69 insertions(+), 2 deletions(-)

-- 
2.36.1



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 107C86EF266
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 12:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240511AbjDZKnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 06:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240505AbjDZKn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 06:43:27 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A93D46B0;
        Wed, 26 Apr 2023 03:43:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZeBamfcYDRumuIfoNEOa3Te5UIWMNycWlKMZhiYE/Hpwk+MlmwRvu6BG6xJh9cc5gmTCf6DnLbd7aLSCzBywuaT0PgEnaFSoxwxSaxYOAIGTIg0IzgeMwasuU52isikfvAn/OJsokGDBwBp9nyDcK3WpEYjyrmWB+enmnh47fLB0ybThy1Y02A5zY++yLB0pjI7eGPGlkjgX7JHfmQMuaMcwAo7/3H3SDKjHCRw44UbCTc+n3PBwF3YSH9Sgzkil8XlqxMSNxSH/vPhLIKG28vlQJISxI4U6ehVy1YFrkngGJ948ZETkDW5bGyAoqIBnju5Cxvmh2mKLDHQgw+7vEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ByTvEJDJotuFtMm6dMGhfHsXAr3pTFCdIxACb2MfSKU=;
 b=mc+fAzj1knenaSebrwRoTz4fxFd+ujpbTpXVZmte/CwiLnhk2VxiSJpR6Nx4STpzinDKWfF3IG1MLC68vjf8XziDxysbvdqSgw+OjrtojiHkvuLrSv6Ssj/iEioHu01YcXrgSZdMXYJSycYUKEfy+HuDKulN02UDGseTaQI5Kz5eVnLtS2XMPUvXZbJ1lLcxXxieD5N9TsVQ1soxPUTEdFFW6ZgChAchFkEcbmokRojnkP780Eh0Y8j8WHPMOzntSx7L6IMDxDpqFZZcyPR5nh05FfTwnZmz6goAZeegB4nVHUdelxHDT88E1WJ6dvCqTL2lk6okHyYASgmekApGaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ByTvEJDJotuFtMm6dMGhfHsXAr3pTFCdIxACb2MfSKU=;
 b=2GhFbXS5SZxztxSxgb569KyLgrFmgBZDeCEsD40nZBgRsLZKKW1BJRrJQVtSybH/A8CBfQvnp2l0qpXwRtwk/B0mR4Oir3WVVXjB1DnNE8yXJYpRx7ucI4gClPwco5D05R8mO1gBzGltDssWwPfKotFI+RRSus5jQap9boYxHqI=
Received: from MW4PR04CA0205.namprd04.prod.outlook.com (2603:10b6:303:86::30)
 by DM6PR12MB4385.namprd12.prod.outlook.com (2603:10b6:5:2a6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.20; Wed, 26 Apr
 2023 10:43:20 +0000
Received: from CO1NAM11FT088.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:86:cafe::21) by MW4PR04CA0205.outlook.office365.com
 (2603:10b6:303:86::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21 via Frontend
 Transport; Wed, 26 Apr 2023 10:43:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT088.mail.protection.outlook.com (10.13.175.131) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6340.21 via Frontend Transport; Wed, 26 Apr 2023 10:43:19 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 26 Apr
 2023 05:43:18 -0500
Received: from xhdharinik40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Wed, 26 Apr 2023 05:43:14 -0500
From:   Harini Katakam <harini.katakam@amd.com>
To:     <robh+dt@kernel.org>, <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <vladimir.oltean@nxp.com>, <wsa+renesas@sang-engineering.com>,
        <krzysztof.kozlowski+dt@linaro.org>, <simon.horman@corigine.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <harinikatakamlinux@gmail.com>,
        <michal.simek@amd.com>, <harini.katakam@amd.com>,
        <radhey.shyam.pandey@amd.com>
Subject: [PATCH net-next v2 0/3] Add support for VSC8531_02 PHY and DT RGMII tuning
Date:   Wed, 26 Apr 2023 16:13:10 +0530
Message-ID: <20230426104313.28950-1-harini.katakam@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT088:EE_|DM6PR12MB4385:EE_
X-MS-Office365-Filtering-Correlation-Id: 794d96e7-1c76-4c91-a210-08db46430d11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7V5qKhrCdyMIWeXAVemwEowFo6GW+rhCKOVsJR9FeVOXBxt5mfsemvd2GFUHRnzNi+03XzrFAo6dQ4VO83Ml3ev6d3mXYnOQ9SXOFTCpm6C6yEAPxojK9Nl0eDdH75C8mYfz1f4pArPkOXOfzIo0I1dSO/RGo6UYHQMMYeBGgunsDVp9ErIineFLDR0EvoighlQSc1+eSvwPY/D0t3wOH9DIxmfVgYUkRo+MB1yvw9PM003tObARGTjAiwBPmFsbK/tXKEeYdnCbq6EdGOZqQ/0dMbXOteDlRq+HPON+H0vd53zpdS3INMX5g8Ot+EnL0C/WbZretTWvt68ww7+chkQfKlQW+/1U/fYuRvgSbsRQIBju+BLGWRJentV80ufBCuD4rl2bjyGgiCZQB6NgoUPe1GRm2tnS/Dm6e6ksW5l8NNmpDO+nq4J/kOfPzQkfvAg+8RxFL4Pt8zwUzwRb4Z68wlN2m3A/239LT2XP8m45qvHVV6O09m4QON5QPW5+lpuP7eHjOBCj7M3GS+uFzDr/Lw5o0i7rm33ribSN9IbR9/6ApMX2oO0HpQAw1j8w37w7xiMiZVWAAQuJpOtffZhOilcZYdSF6TND+r6lVh6YiE40cNJGtHMm0iEBchlLlkZSzUSH+XieaorrduE9ds3EHoe2rB152mzRgOZj4KeiOU80B3Umgeavg34nyJogW/4WZjWiuDWO78gHdY7qzmU+54cus+lGXJ8MuGF3ivMWZR2yB+tItZbSxvyT7k50
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(376002)(136003)(396003)(451199021)(36840700001)(40470700004)(46966006)(2616005)(110136005)(26005)(1076003)(186003)(70206006)(40480700001)(54906003)(36860700001)(47076005)(4326008)(316002)(6666004)(83380400001)(966005)(336012)(86362001)(478600001)(426003)(82310400005)(70586007)(356005)(7416002)(82740400003)(41300700001)(44832011)(5660300002)(40460700003)(2906002)(8676002)(8936002)(81166007)(921005)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2023 10:43:19.7507
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 794d96e7-1c76-4c91-a210-08db46430d11
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT088.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4385
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

Add support for VSC8531_02 PHY ID.
Also provide an option to tune RGMII delay value via devicetree.
The default delays are retained in the driver.

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

RFC link: https://lore.kernel.org/all/20210629094038.18610-1-harini.katakam@xilinx.com/

Harini Katakam (3):
  phy: mscc: Use PHY_ID_MATCH_VENDOR to minimize PHY ID table
  dt-bindings: mscc: Add RGMII RX and TX delay tuning
  phy: mscc: Add support for VSC8531_02 with RGMII tuning

 .../bindings/net/mscc-phy-vsc8531.txt         |  2 +
 drivers/net/phy/mscc/mscc.h                   |  3 ++
 drivers/net/phy/mscc/mscc_main.c              | 54 +++++++++++++------
 3 files changed, 42 insertions(+), 17 deletions(-)

-- 
2.17.1


Return-Path: <netdev+bounces-9971-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A44D772B7EC
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 08:08:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5EA97280F59
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 06:08:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4EA823AA;
	Mon, 12 Jun 2023 06:08:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8AD220F1
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 06:08:17 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 377D893
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 23:08:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jDwakVqfOfY/Tyu+Dlk5vLzaF18BeL+p5T+UMJyNFM47ISuG9TepYZiah7/EPvgiS1S5Cfj2SykBOMdUbw7oq/9C6iR3FNW5qEiQGC6gnKepyx7EZhZCBBR1E7dFQb+yPVfJAgO1I1dz6+RWe0j5pPPL9ur6Nz5E3D4SDF4sE/cAUlDxGgjcaj+R5XXn/hsAz81AhyrLv47pbhL59nMZ0KU8mgljYoS8ebsOytUcdi9cMdPWb8KDL3T9vjNgtMR+ggSOYyd8c1YwholUqfzsmFEX7seNu0nYoKUAZbVcrICCZC8Sp+WMDc/uapAX9fj+QnsIfzqGrBvI6F9ar7ZRgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dfzR/7tNJZS6V5NTXmX4Xc5dzDbllkljN/qbbGIK1lU=;
 b=A8KMJAsLsBXu2ngSr25A+abnld7yGECm/1UYzAfX0I6gssgegT9nffMB+STwfdEkpREiLJaWxwwfY9rXdqMcGvjtz/6AHyQbX8UAcux/MQEEHFr0zmPlekDDB0E8ev/VcfI10RZtvhF6zWatH3VqPFAa8K597XrhB00bguIVhO/SplIqKjW2SCWaL+JlcYHYp38f6d52CRa/5ACIzHW7i0yavrr3ukgIf159UN9XkAfQ433rdcLMvelRHQ7vaiBXo6VPqALClxZrmEaMfldtWkwVxXjs3ZRz1PEpH7uvifIVtNCI9RIR2VReN0AV8AxLOE9/Z5XYXX1F2QXpwIwEag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dfzR/7tNJZS6V5NTXmX4Xc5dzDbllkljN/qbbGIK1lU=;
 b=1/VXTcv+jBTYSP2CIY3k3287fcOTZSIIt0oFb1nY68pUYRcaHfNdyuazY82kQtMcHmTJwwWnyUJehy6pdzRwHFVyw3tomVz6O4otEZ9QCyZo1nhYqcDMf8juqdNh9QQY3Fz2fMspf9b0WDW7TxU2Ukr8roXwF5wSOdGY0o+RceQ=
Received: from MW4PR04CA0057.namprd04.prod.outlook.com (2603:10b6:303:6a::32)
 by BY5PR12MB4243.namprd12.prod.outlook.com (2603:10b6:a03:20f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.46; Mon, 12 Jun
 2023 06:08:08 +0000
Received: from CO1NAM11FT100.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6a:cafe::eb) by MW4PR04CA0057.outlook.office365.com
 (2603:10b6:303:6a::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.34 via Frontend
 Transport; Mon, 12 Jun 2023 06:08:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT100.mail.protection.outlook.com (10.13.175.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.21 via Frontend Transport; Mon, 12 Jun 2023 06:08:08 +0000
Received: from jatayu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Mon, 12 Jun
 2023 01:08:03 -0500
From: Raju Rangoju <Raju.Rangoju@amd.com>
To: <netdev@vger.kernel.org>
CC: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <Shyam-sundar.S-k@amd.com>, Raju Rangoju
	<Raju.Rangoju@amd.com>, Sridhar Samudrala <sridhar.samudrala@intel.com>
Subject: [PATCH net-next v2] amd-xgbe: extend 10Mbps support to MAC version 21H
Date: Mon, 12 Jun 2023 11:37:24 +0530
Message-ID: <20230612060724.1414349-1-Raju.Rangoju@amd.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT100:EE_|BY5PR12MB4243:EE_
X-MS-Office365-Filtering-Correlation-Id: 38567f5f-c895-4b29-1eb4-08db6b0b64c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	tJURS+iJS0vKthY3oweTgZL5/q5fIONuzCffYrKTDiiAUt5lH0q4XZ+TJTDPIYVzKIZQ1yV74a4EiWZ0dC5B/nQFYJFZjkSSOOojMqiUPWw/NigB0SV9zEDBuubujMxOXGxLcIKo04ow19lDfEdp9Ys83IOBWp5J29Qfttv4lDo+skzXfsbgYCzEi932gd62iusf0+ZPUGRLLowpEIedNH1cL3WRA8+Urbxc4kJ25OUDLSl6Cmuwxg9e3rN+kgTWyCxzxW3m6i07piC+ty8aokZZNg4g7tClz6cPSy+m+mpaE9PEz9nWApsEoqjCpn/q2t4AzXDSmG6zhX1K2+EcHru8kCPu/uBtvOFYoKLjuX+ttmjn+ecRoVbMas6rzExRRAwPkRnU7pK88/dBmfuLIgqRhtqI3ci5+xHNvdcdw9RjdGXz0SpSjPqm5xHz71IoYZtODtQ5E1utfm8z3OkTyEQpNUOKUSw+tMpLQ8RIEFCZVyCpaQb4HRy+trVUxEY/hOZBNKt8rFyTQ0Jez68gwmgAF4zRcJvPeKsLh9RNo4kECxCthGAoaxVF6cYaOQG2goVpRDy2CGInSly0gwN19KK6EUq6sgHx2/RcwodApZKhrbH9ZHMqh0iGxS2Gy7uwfouXjihST9iCG26NO6GEh3/V1ZtkodBl34c3FBiJaHwEXGWMKya5fFVeZWj1BeydC31LxFUUQYWmjydIKQ1q1pDK2+w9NwWqUKnJZWtqli6tUeC4rulmP4iksplV1bW5326k+eLAosVh0STFtl9bWw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(136003)(346002)(39850400004)(451199021)(36840700001)(46966006)(40470700004)(82310400005)(316002)(6916009)(70206006)(2616005)(82740400003)(356005)(81166007)(40480700001)(26005)(478600001)(7696005)(6666004)(36756003)(1076003)(86362001)(54906003)(4326008)(70586007)(40460700003)(186003)(16526019)(47076005)(8936002)(2906002)(5660300002)(36860700001)(83380400001)(336012)(426003)(8676002)(41300700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 06:08:08.0906
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 38567f5f-c895-4b29-1eb4-08db6b0b64c2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1NAM11FT100.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4243
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

MAC version 21H supports the 10Mbps speed. So, extend support to
platforms that support it.

Acked-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
---
Changes since v1:
- Added missing tree name
- Fixed the line length warning
- Added Reviewed-by tag received for previous version

 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index 16e7fb2c0dae..6a716337f48b 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -2782,9 +2782,9 @@ static bool xgbe_phy_valid_speed_baset_mode(struct xgbe_prv_data *pdata,
 
 	switch (speed) {
 	case SPEED_10:
-		/* Supported in ver >= 30H */
+		/* Supported in ver 21H and ver >= 30H */
 		ver = XGMAC_GET_BITS(pdata->hw_feat.version, MAC_VR, SNPSVER);
-		return (ver >= 0x30) ? true : false;
+		return (ver == 0x21 || ver >= 0x30);
 	case SPEED_100:
 	case SPEED_1000:
 		return true;
@@ -2806,9 +2806,10 @@ static bool xgbe_phy_valid_speed_sfp_mode(struct xgbe_prv_data *pdata,
 
 	switch (speed) {
 	case SPEED_10:
-		/* Supported in ver >= 30H */
+		/* Supported in ver 21H and ver >= 30H */
 		ver = XGMAC_GET_BITS(pdata->hw_feat.version, MAC_VR, SNPSVER);
-		return (ver >= 0x30) && (phy_data->sfp_speed == XGBE_SFP_SPEED_100_1000);
+		return ((ver == 0x21 || ver >= 0x30) &&
+			(phy_data->sfp_speed == XGBE_SFP_SPEED_100_1000));
 	case SPEED_100:
 		return (phy_data->sfp_speed == XGBE_SFP_SPEED_100_1000);
 	case SPEED_1000:
@@ -3158,9 +3159,9 @@ static bool xgbe_phy_port_mode_mismatch(struct xgbe_prv_data *pdata)
 	struct xgbe_phy_data *phy_data = pdata->phy_data;
 	unsigned int ver;
 
-	/* 10 Mbps speed is not supported in ver < 30H */
+	/* 10 Mbps speed is supported in ver 21H and ver >= 30H */
 	ver = XGMAC_GET_BITS(pdata->hw_feat.version, MAC_VR, SNPSVER);
-	if (ver < 0x30 && (phy_data->port_speeds & XGBE_PHY_PORT_SPEED_10))
+	if ((ver < 0x30 && ver != 0x21) && (phy_data->port_speeds & XGBE_PHY_PORT_SPEED_10))
 		return true;
 
 	switch (phy_data->port_mode) {
-- 
2.25.1



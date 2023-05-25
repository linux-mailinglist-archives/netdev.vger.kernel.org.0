Return-Path: <netdev+bounces-5426-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24F1E7113A6
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 20:26:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D46132815E7
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 18:26:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 217C022609;
	Thu, 25 May 2023 18:26:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE9E101DA
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 18:26:48 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2047.outbound.protection.outlook.com [40.107.93.47])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC52BB
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 11:26:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FwnGI78Qzqq19ilYVywV4r9mVazSr3fQmBn09qfc37/YXcktIxrixCTIyuz01QpzRNQLYznvnD8y7vLmhu76Iy4AraBDwyZZfzQXhnq7TpG3DsBDwFLrwMaCOv7sRyaDKGzQMlHx+uxN4bcdUdCumigIN50fZ46nwhvvzfFSpNc7Z5NW/24lrBOTGrcr9XXNFUv+pO7EayGtzMiK1N0cDtXcFfnIuacXC6W09oRIkH6oKDum+OnA/zHelo/EXZHmQ8MpJzMjLDhZDAtMehC7PYWomgcFC976C6O4NTKS54bEM8Sug+P+4zSIY7raYwU1HjTpgDMwRGcvqfd821ssgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Mn0GnGwqmMqFzAL4pPEfRoCLHvSBOu3AftJRAspC3Y=;
 b=I/C+DotOYn47wtzVHAEKYg8Uq6sKDaoaFtC2aNB9oMzoEG2DBpBUKEn6gG+lfsebs2oTsk7P22xKp7cgUDWvYyAasgOrykS8wD6f7YwpfPvF3sx9WVdhdbUNGyRbs7MXFquS/lb5HGDGNJYX2mOnTEmp/D1ReJJSkHftTAVpyDU0ujUZDgoMYfv4UTfMQGgriXggAhWD2qzx1TySTZHPKZj804jvzkKhzXyvxKLFn7VC7rVnCHacO7YuG8aUnEZT0ighuCG34rwHG+R8yIeba5GKm/6qZf8EKZqDwTFXMLj4zJXXzG5edzG72xaED0xU5rVPh6aJXRwezUpFaaZnvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Mn0GnGwqmMqFzAL4pPEfRoCLHvSBOu3AftJRAspC3Y=;
 b=e4c9MQIuZrRwcR4AtBiuI6K+F4YT1hwsFZ/cp2+SZyCcu3bLAxz7kbfeBRyFbc2facaYqgJw3rUtwVJhnBB8glohPE2kJBSMWb5mKb3IgyoAGlFfpuzrnmmM/eFGSITkT5T9nWUtbh1DIOTp4yeXORuyQ9r38ZTC3TPu3qwL1KE=
Received: from MW4PR04CA0179.namprd04.prod.outlook.com (2603:10b6:303:85::34)
 by SJ0PR12MB6759.namprd12.prod.outlook.com (2603:10b6:a03:44b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.15; Thu, 25 May
 2023 18:26:44 +0000
Received: from CO1NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:85:cafe::c6) by MW4PR04CA0179.outlook.office365.com
 (2603:10b6:303:85::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.16 via Frontend
 Transport; Thu, 25 May 2023 18:26:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT030.mail.protection.outlook.com (10.13.174.125) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6433.16 via Frontend Transport; Thu, 25 May 2023 18:26:43 +0000
Received: from jatayu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 25 May
 2023 13:26:40 -0500
From: Raju Rangoju <Raju.Rangoju@amd.com>
To: <netdev@vger.kernel.org>
CC: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <Thomas.Lendacky@amd.com>, <Shyam-sundar.S-k@amd.com>,
	Raju Rangoju <Raju.Rangoju@amd.com>, Sudheesh Mavila
	<sudheesh.mavila@amd.com>, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v3 net] amd-xgbe: fix the false linkup in xgbe_phy_status
Date: Thu, 25 May 2023 23:56:12 +0530
Message-ID: <20230525182612.868540-1-Raju.Rangoju@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT030:EE_|SJ0PR12MB6759:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c631bb9-66fd-41a8-05ca-08db5d4d9791
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	YpnpIUsb8tK6RZFNcooJ6IN7lExmzkTNSoIN9KN7rZ/fitwYyNf5P39v3jYhfyhhZOFdE/AQCWgbEPNB7nMP68bj7h+bWxMkdWhiWxC4eU4qD5hM23v/dfZ8MRvVV6Cwy3Zp70oPf5eAJQCjLiYnaoLo7MOzSPs0IB8ToTVjlUedqgzjtgaY+Rh4d3zTB//yI0BDh4IX5ssqHIkL5bj6XWYZk28zRlk+5ecLFZeBXoKHq8SoTZqPNygUVXK9a6MemvAlTITkaW15Mu+pU4n9kfEqm4y7XajzSjzy4x7LurQLPZYIYBA96DojSlbq8F1MO+xbo3NF9EbZOv4FFRDB9Q4MrizC7HIvplzAkDevREbLOTnrtaUlqReokIwSPwaMKlq1ivpp2diWPG+QER/pJfii/8DWiakAq8tgL30IEuwH3mK/RAVcHnyEhNdt4ecH1JRbIMFaFAz9FkgzxkHD6HxtSf98iRpw0LGvyYuil3oZJl/7HqhqVUewAGKitXWmmOdoGqwZL4VG54F56Z/I68BU+Cg/ibq84Z9MpE+eBtcD5eIUH2JFcASvhe3aaBT+ESmMHLVavwy87aZkEv54bXn9pYdAKYCjTP1mOolKpbGbFMiaqu6/5Ee+4Y55yAhJJLQcCm74fUSuGaVM+qJX0MZrG0COPGwW6I3Vpa3czspQ0ZsqpUYdxf2ErSNLkTBZWuiiWcG6iMjNuNrnkieaP2ERPFTC3VKOQ99D4ejlEY8VgYg3jrh+kWcOvnLbPjZSQffoCaVJIQLWgP89o+sLxg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(39860400002)(136003)(346002)(451199021)(46966006)(40470700004)(36840700001)(8676002)(6666004)(478600001)(40460700003)(47076005)(83380400001)(2616005)(426003)(40480700001)(36860700001)(86362001)(82740400003)(356005)(1076003)(36756003)(26005)(16526019)(186003)(336012)(7696005)(41300700001)(81166007)(8936002)(316002)(82310400005)(5660300002)(2906002)(54906003)(6916009)(4326008)(70206006)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2023 18:26:43.8379
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c631bb9-66fd-41a8-05ca-08db5d4d9791
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6759
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In the event of a change in XGBE mode, the current auto-negotiation
needs to be reset and the AN cycle needs to be re-triggerred. However,
the current code ignores the return value of xgbe_set_mode(), leading to
false information as the link is declared without checking the status
register.

Fix this by propagating the mode switch status information to
xgbe_phy_status().

Fixes: e57f7a3feaef ("amd-xgbe: Prepare for working with more than one type of phy")
Co-developed-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
Signed-off-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Acked-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
---
Changes since v2:
- Clean up the code for better readability - Suggested by Tom

Changes since v1:
- Fixed the warning "1 blamed authors not CCed"
- Fixed spelling mistake

 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
index 33a9574e9e04..32d2c6fac652 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
@@ -1329,7 +1329,7 @@ static enum xgbe_mode xgbe_phy_status_aneg(struct xgbe_prv_data *pdata)
 	return pdata->phy_if.phy_impl.an_outcome(pdata);
 }
 
-static void xgbe_phy_status_result(struct xgbe_prv_data *pdata)
+static bool xgbe_phy_status_result(struct xgbe_prv_data *pdata)
 {
 	struct ethtool_link_ksettings *lks = &pdata->phy.lks;
 	enum xgbe_mode mode;
@@ -1367,8 +1367,13 @@ static void xgbe_phy_status_result(struct xgbe_prv_data *pdata)
 
 	pdata->phy.duplex = DUPLEX_FULL;
 
-	if (xgbe_set_mode(pdata, mode) && pdata->an_again)
+	if (!xgbe_set_mode(pdata, mode))
+		return false;
+
+	if (pdata->an_again)
 		xgbe_phy_reconfig_aneg(pdata);
+
+	return true;
 }
 
 static void xgbe_phy_status(struct xgbe_prv_data *pdata)
@@ -1398,7 +1403,8 @@ static void xgbe_phy_status(struct xgbe_prv_data *pdata)
 			return;
 		}
 
-		xgbe_phy_status_result(pdata);
+		if (xgbe_phy_status_result(pdata))
+			return;
 
 		if (test_bit(XGBE_LINK_INIT, &pdata->dev_state))
 			clear_bit(XGBE_LINK_INIT, &pdata->dev_state);
-- 
2.25.1



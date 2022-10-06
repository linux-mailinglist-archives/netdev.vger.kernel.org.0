Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 808C55F689B
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 15:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbiJFN4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 09:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230496AbiJFNz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 09:55:58 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2041.outbound.protection.outlook.com [40.107.237.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC5388C00D
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 06:55:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jddrIGnPkDLKB50adU4ySoXG+gFjVGiqyK53cp/FCALtpW1jWVrPGo7LCEPk89bV5noBlOdRQamgPpAFavHgzY/3cwxR68N7UZyhDxNXhpd6oGnnBX/5e5JwDNudFbbgdGAmXpkZeoOJIXsJdAK8/yFUkODBL2eIwaccDfG2SfPvzk3UrG1qLrtrAovI2KDiIGQe1YLCTXw2g4QFbGA2KKJAgTpNZKrpGe7WiVe4CO8msev180lbpdP/4h76VKmKxyJkKICrjiGo1MrlV5GgaQZNe5Nk2khKqdhBnkDnnq4HGFdEX8Vl50/XdpC3hvjW9qm0drW1twcl/0rF2n4Q9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=khym6tocJO+MqHFAbIUCEuWpev7GPgSF8S0SJUpjlME=;
 b=htG6BmPZm4Bsb/3Y8RlFHL3606TDHj64kZ+FNj24YwNdJscY4HeAvunt68LB6PV0qfV92wNhMjD0A9baKIbE1IU9P35r88pNTSY0pe6JapkWJ1n7C8nWr8J4cbZkfD8+X7qxDH6zd5BJow3xlvwhlgCpFZAkcX6xnf54LyiACiMYwViVbRNFxlGZLH0TrcOoEo/SAY/JBgKVriZ/d3Sd9qJyx0URlIfG/1ZJ+NkW1qvcYelzG/oQgmIAbnq6gpq4+T9nIA6XNi7NIATK7C2oJLuhouCJquigwmDOLaYRbU3EG81IwddyG7XvroXkn7ZdCdUWh7In9dfubSGqERGxxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=khym6tocJO+MqHFAbIUCEuWpev7GPgSF8S0SJUpjlME=;
 b=qc+CYIIFqVGQTIwAL+EAFlxYHX3WRSOfhNUts6Z9JIhMYQY+ys+rAOdPOBSJRcBCZjCsZBjxWpQr8QpHyT40ojZqdCJ06mH/bu1TC4N0zXvuQQNh64Gbk4XQwjJSW1Njm9iPjQHUpVSfB8KYLipr5uakOZs3kE+o4O3nOV3OOSU=
Received: from BN8PR03CA0012.namprd03.prod.outlook.com (2603:10b6:408:94::25)
 by BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.31; Thu, 6 Oct
 2022 13:55:53 +0000
Received: from BL02EPF0000C402.namprd05.prod.outlook.com
 (2603:10b6:408:94:cafe::c3) by BN8PR03CA0012.outlook.office365.com
 (2603:10b6:408:94::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.26 via Frontend
 Transport; Thu, 6 Oct 2022 13:55:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0000C402.mail.protection.outlook.com (10.167.241.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5676.12 via Frontend Transport; Thu, 6 Oct 2022 13:55:53 +0000
Received: from jatayu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 6 Oct
 2022 08:55:50 -0500
From:   Raju Rangoju <Raju.Rangoju@amd.com>
To:     <thomas.lendacky@amd.com>, <Shyam-sundar.S-k@amd.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <rrangoju@amd.com>,
        Raju Rangoju <Raju.Rangoju@amd.com>
Subject: [PATCH net 1/3] amd-xgbe: Yellow carp devices do not need rrc
Date:   Thu, 6 Oct 2022 19:24:38 +0530
Message-ID: <20221006135440.3680563-2-Raju.Rangoju@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221006135440.3680563-1-Raju.Rangoju@amd.com>
References: <20221006135440.3680563-1-Raju.Rangoju@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0000C402:EE_|BL1PR12MB5995:EE_
X-MS-Office365-Filtering-Correlation-Id: 63afb30b-7e11-4972-803e-08daa7a27c43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cdgFy1Nj482eoFs7etoPKoiNW40yrN39VKvxiHFcdDQFc3M4bORN8aOuG4DwzUX/mPap7f7ryGwKqAbYC8ST8uu0ksCVhhT/Iu7Y5/antMb2MUJ8wpwgRV63hoKFTb8DJAOm5bHSxLRuUzwLkXpdRkUJFwuHHdA3NyqQEf1fJA3sQxc6kpArhg06R5qy46qt+cfgHhaT2bH+fq4p1UsG0UfFhQ94HUZUIxpbTc3adCeeHjqESyeULD6MsYpwFWu7xR7wAbWOTcuM/M7s4k1Fwq4uJh6y6VoaRmFCddn3MeVxlIbntXcQTWJ2Lugh17qDBM72paif6j+1cn05PFS2yUPH6h1vVsixso0DczG8k8adADjBPysSDikIEfPNjyJ/uyTX8F09LwlGtSPCEasl62mECd5yLwD6zOFQziqKasvGbJScHt53uMKlOIbj+eSoA666kDJgKRiunyskpbwNG7Jgjk3UPZE7v9zsMXNVe8gOfj1fzABsmTm9lzFigkwcDQBO0cEZRYkrNhnPxf2za3sjd/TQlO1hOCPW6/wrTcvYxPcoMkWBXjZUq0/nqG+ISpNVr/bXgY20PHOC+12yMI0cYFB0dCMndGAYcHszaA7orDG1imxD0WQi475EQOiWbvCieGalgobkiuF82qWHuTAmEcD6JFmdGBR0ge3RpkRGM9n7/3hTCgw98Htf2K4uMDad7KJJgxkHbO8BT19zfB+Mbuo+8sb5amNpNagDDWYPbp5UYO2vdaWCdQ6NQEX8f8GoVSlUFocE1Z+PnvnsHNtcMFa9CxbAW6EGPHJ119DxRGqT/i2XFI7WDMgOUAPX
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(136003)(396003)(346002)(451199015)(40470700004)(36840700001)(46966006)(7696005)(81166007)(4326008)(54906003)(40460700003)(8676002)(478600001)(70206006)(70586007)(6666004)(41300700001)(110136005)(36860700001)(426003)(47076005)(82740400003)(83380400001)(8936002)(5660300002)(86362001)(336012)(26005)(1076003)(2616005)(2906002)(186003)(36756003)(316002)(82310400005)(16526019)(40480700001)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2022 13:55:53.6591
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 63afb30b-7e11-4972-803e-08daa7a27c43
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF0000C402.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5995
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yellow carp devices disables the CDR workaround path,
receiver reset cycle is not needed in such cases.
Hence, avoid issuing rrc on Yellow carp platforms.

Fixes: 47f164deab22 ("amd-xgbe: Add PCI device support")
Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
---
 drivers/net/ethernet/amd/xgbe/xgbe-pci.c    | 5 +++++
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 2 +-
 drivers/net/ethernet/amd/xgbe/xgbe.h        | 1 +
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-pci.c b/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
index 2af3da4b2d05..f409d7bd1f1e 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
@@ -285,6 +285,9 @@ static int xgbe_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 		/* Yellow Carp devices do not need cdr workaround */
 		pdata->vdata->an_cdr_workaround = 0;
+
+		/* Yellow Carp devices do not need rrc */
+		pdata->vdata->enable_rrc = 0;
 	} else {
 		pdata->xpcs_window_def_reg = PCS_V2_WINDOW_DEF;
 		pdata->xpcs_window_sel_reg = PCS_V2_WINDOW_SELECT;
@@ -483,6 +486,7 @@ static struct xgbe_version_data xgbe_v2a = {
 	.tx_desc_prefetch		= 5,
 	.rx_desc_prefetch		= 5,
 	.an_cdr_workaround		= 1,
+	.enable_rrc			= 1,
 };
 
 static struct xgbe_version_data xgbe_v2b = {
@@ -498,6 +502,7 @@ static struct xgbe_version_data xgbe_v2b = {
 	.tx_desc_prefetch		= 5,
 	.rx_desc_prefetch		= 5,
 	.an_cdr_workaround		= 1,
+	.enable_rrc			= 1,
 };
 
 static const struct pci_device_id xgbe_pci_table[] = {
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index 2156600641b6..19b943eba560 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -2640,7 +2640,7 @@ static int xgbe_phy_link_status(struct xgbe_prv_data *pdata, int *an_restart)
 	}
 
 	/* No link, attempt a receiver reset cycle */
-	if (phy_data->rrc_count++ > XGBE_RRC_FREQUENCY) {
+	if (pdata->vdata->enable_rrc && phy_data->rrc_count++ > XGBE_RRC_FREQUENCY) {
 		phy_data->rrc_count = 0;
 		xgbe_phy_rrc(pdata);
 	}
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe.h b/drivers/net/ethernet/amd/xgbe/xgbe.h
index b875c430222e..49d23abce73d 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe.h
+++ b/drivers/net/ethernet/amd/xgbe/xgbe.h
@@ -1013,6 +1013,7 @@ struct xgbe_version_data {
 	unsigned int tx_desc_prefetch;
 	unsigned int rx_desc_prefetch;
 	unsigned int an_cdr_workaround;
+	unsigned int enable_rrc;
 };
 
 struct xgbe_prv_data {
-- 
2.25.1


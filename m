Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D272116F85A
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 08:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbgBZHL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 02:11:29 -0500
Received: from mail-bn8nam11on2083.outbound.protection.outlook.com ([40.107.236.83]:56800
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726903AbgBZHL3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 02:11:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RsAep52swxy9u4cxoIUhKy2qq/jivDVJT9gc9dURSTHPDPpwT4HZ5CMQvWuy5g1/9g/l2jovc+h0Me3Eyh9kjfoGIHpQcwU0HLhRVcNApq66gZ5CKkM5WjwzurYVSCGMIoyIPQyn0QC+ckavESbh5qIW3kU3NZ50a8+CgwR/aqe5l0ZhixS7MFjOyLE9CCEQ6oKPCFC61dvStlHHjzd+ypvLF/17eyXO0vKin2O/pFYqGjehcIjTS+NyZ+TLBjBXNAW0BRxu1bhEFMM8EAHNqaMDzQRm18QJx7NjLhf/UinzzK6OFk+dX/H+5e0jBx0PaqoYVCBQx1JyIWkY+wxF8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zvzDEMfVq2WyhMExIcQtMMsESFH1bLcNkkk/9M5HqX0=;
 b=EwdkXizME3DjxZzVR2Vhe2vTjESpSmMt+//FVb4eFftfcEcIxnG5QrgEQYPRY8wB07Vy4Yd+yOqO6SlGXbb6izXLqbmnOz3CesfTUMzVBQ/mXA+AjpZrlCiiwSFfp7reCIIHAbyzC1/earPnfR9ELCTaip3OM2sUmRR4ELHBUIFokHsP2wmfyNVwGnO037l2yJEntvmzIIHOeR2qR4fgeHvzDpWMwbS6s5PcbMKatjj8QQkqIRl83v65U8MqEoCrlj7//gbLvdoaGX5iFORwQS+Tv50ii15R3Fvv4dkKIAFwbTJIvMYu+uXGVQsyZa9fMhllAsATwMwp/ZRMHZ5tYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zvzDEMfVq2WyhMExIcQtMMsESFH1bLcNkkk/9M5HqX0=;
 b=RdYMGyphQMfQiquIZMK9POI1TppItiqbUxqrs7jj+0VvPiOumNz4JHG6lu8qt2e7AP0aacoWY2Js7kpvK8ZNkECdDjQW+MPhtzLdFSTVL1nJxqKr8VdyaAFN2WVu9Xk9foNc1AHP/6GCXDWnPUqPN8e/Iq4Yev2pECxj8ggvlxM=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Sudheesh.Mavila@amd.com; 
Received: from MN2PR12MB2974.namprd12.prod.outlook.com (2603:10b6:208:c1::11)
 by MN2PR12MB3727.namprd12.prod.outlook.com (2603:10b6:208:15a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.17; Wed, 26 Feb
 2020 07:11:26 +0000
Received: from MN2PR12MB2974.namprd12.prod.outlook.com
 ([fe80::a142:9294:5865:65c]) by MN2PR12MB2974.namprd12.prod.outlook.com
 ([fe80::a142:9294:5865:65c%5]) with mapi id 15.20.2750.021; Wed, 26 Feb 2020
 07:11:26 +0000
From:   Sudheesh Mavila <sudheesh.mavila@amd.com>
To:     sudheesh.mavila@amd.com, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: =?UTF-8?q?=5BPATCH=20v2=C2=A0=5D=20net=3A=20phy=3A=20corrected=20the=20return=20value=20for=20genphy=5Fcheck=5Fand=5Frestart=5Faneg=20=09and=20=20genphy=5Fc45=5Fcheck=5Fand=5Frestart=5Faneg?=
Date:   Wed, 26 Feb 2020 12:40:45 +0530
Message-Id: <20200226071045.79090-1-sudheesh.mavila@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA1PR01CA0124.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:35::18) To MN2PR12MB2974.namprd12.prod.outlook.com
 (2603:10b6:208:c1::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yocto-build.amd.com (165.204.156.251) by MA1PR01CA0124.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:35::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Wed, 26 Feb 2020 07:11:22 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.156.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3b55511d-b6f2-45ea-1248-08d7ba8b1767
X-MS-TrafficTypeDiagnostic: MN2PR12MB3727:|MN2PR12MB3727:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR12MB3727775E14984B696361115AFCEA0@MN2PR12MB3727.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 0325F6C77B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(366004)(136003)(346002)(376002)(189003)(199004)(36756003)(1076003)(66556008)(7696005)(66476007)(66946007)(956004)(26005)(2616005)(6666004)(5660300002)(44832011)(478600001)(6486002)(316002)(8936002)(2906002)(81156014)(81166006)(186003)(16526019)(86362001)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR12MB3727;H:MN2PR12MB2974.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VR2aLFHOa/YLPr34+QIz6ZvuJA9qiDihX3KJ+YSAYv191ao/YWY6xAQbcPHqkWeUIhA+sRf8T/aQ0StYHGmhzffl2aV+IHK0nXJO8MK33fcovSgm0u624FHvISlRV5P+lkNxyTyE+TMmmhj0yrNlIbKzy2wiZUZ0RtLbKYrZ/AkMZV5BPGXN3+5V6jtLbFGNMdOLBAt//rozcx7/t+zfZMWL2aeVmpXpOq/xwZc2gYfRfpty+XyPwzJb4Kis1Sz2MGBn6byviseRW0P8ukxBBG/XGtCAeS5Lf2XDs23o8kA6/EYRJrLVFsFfuawoc+GCQFcJsPz0AdkVEq2/mw7c6Ccp/tyd4lIHso8oYPEppr49aSmim6kWO8CjOvnlXWfn5QcWf1TVxIhb5CL5rr9eod4l+ujLJxPW6p3yK/+PH5Q8EP6ZhGqWSx57diUhcYNI
X-MS-Exchange-AntiSpam-MessageData: 3GGc34Gssbfmmvsa3klW6wllq7Tb5AlJohZfErryuhMjc3kXGQoa//TihM/vEa5X7CNHoP6iVPbSqAP/6sH+k1MwNy3EOk5oEjJtC63Bx56+jnv2CHD8NcPk1iDByhlEi7Fcf9lOuUG2AK8geYXeWg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b55511d-b6f2-45ea-1248-08d7ba8b1767
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2020 07:11:26.5488
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k1rOVPYNFJoJnnuALooGVYeNBAKKy3848A9ng1z4E3C9SGFvroA4aB2qQ5Mpi2i5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3727
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When auto-negotiation is not required, return value should be zero.

Changes v1->v2:
- improved comments and code as Andrew Lunn and Heiner Kallweit suggestion
- fixed issue in genphy_c45_check_and_restart_aneg as Russell King
  suggestion.

Fixes: 2a10ab043ac5 ("net: phy: add genphy_check_and_restart_aneg()")
Fixes: 1af9f16840e9 ("net: phy: add genphy_c45_check_and_restart_aneg()")
Signed-off-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
---
 drivers/net/phy/phy-c45.c    | 6 +++---
 drivers/net/phy/phy_device.c | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
index a1caeee12236..dd2e23fb67c0 100644
--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -167,7 +167,7 @@ EXPORT_SYMBOL_GPL(genphy_c45_restart_aneg);
  */
 int genphy_c45_check_and_restart_aneg(struct phy_device *phydev, bool restart)
 {
-	int ret = 0;
+	int ret;
 
 	if (!restart) {
 		/* Configure and restart aneg if it wasn't set before */
@@ -180,9 +180,9 @@ int genphy_c45_check_and_restart_aneg(struct phy_device *phydev, bool restart)
 	}
 
 	if (restart)
-		ret = genphy_c45_restart_aneg(phydev);
+		return genphy_c45_restart_aneg(phydev);
 
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(genphy_c45_check_and_restart_aneg);
 
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 6a5056e0ae77..8b16775b9324 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1792,7 +1792,7 @@ EXPORT_SYMBOL(genphy_restart_aneg);
  */
 int genphy_check_and_restart_aneg(struct phy_device *phydev, bool restart)
 {
-	int ret = 0;
+	int ret;
 
 	if (!restart) {
 		/* Advertisement hasn't changed, but maybe aneg was never on to
@@ -1807,9 +1807,9 @@ int genphy_check_and_restart_aneg(struct phy_device *phydev, bool restart)
 	}
 
 	if (restart)
-		ret = genphy_restart_aneg(phydev);
+		return genphy_restart_aneg(phydev);
 
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL(genphy_check_and_restart_aneg);
 
-- 
2.17.1


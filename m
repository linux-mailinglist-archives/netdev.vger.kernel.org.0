Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5310B21753F
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 19:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728421AbgGGReK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 13:34:10 -0400
Received: from mail-bn7nam10on2084.outbound.protection.outlook.com ([40.107.92.84]:44863
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727834AbgGGReK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 13:34:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nzIh6KJOhK0qm2Qq6dPtHRCxzwE4Lhnfcj3V/IfCzcEyl0eHHkgzmMgA79NI/R/2DyX/4oHcuKafTaAiwqrkIK18H1tNg18B+xUO8YlWtolgqi6eI4hbbMY2P1kq8/8Xt/VoZXq6/VBAckOUFAaHIAz2D2SF9DU8SMSAfV4IoXCBBVF5VrI4iod/BpZlppvEc7uZY82SRWEvd2PFxG+3suGRuFOGZf/UUBj1do59EWsJ1+nprNxamNb1bBo2yzqLX9blfe+/zgThjIUbKHtUfBabNJ0PRtim2VZ29LmS8UEW+mQqAGyzjVrQI7q7DA27UypQACP74yO2ClZdS2aESQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rtCMaoC4hFWkykET+IGT4XVLghmBb7Pr7RAoqVv6djY=;
 b=C+nLADX2XRVkAuWJI1Vdej/TyA6lBDjB8pSsIlDYzE3/sIZanPOHii5NKtXqz7A9I1+jK+yIkZgA4Ly8FHvBDofDUso3jvjDJ5sN5CU6THAyhUw+MZ3vtzWwCUG+9jj5bfBET7Cs5ghA5cBOxIFtCP05qwBAx4TsicxOZZXYmAR2P5Jk20gPW+7WRwR3n8CBrVJNG5GiI99sD8zrvLmwHl8Sj6FN+FiSZTNXlwzRO++BjnXcocl2d+e1+0qpFkLNbxa3VbRATI6tUfSS00S+YsqetSmTI9AvoAXdBP1JczwkghB/vmfapm4BkFJoIwJ/ByNzgichn6Xp1dlM/22RFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rtCMaoC4hFWkykET+IGT4XVLghmBb7Pr7RAoqVv6djY=;
 b=HAFbxi34NM4i6SuKGdpAXXTGAgak5HDWgxTqJ37pm3S9Kr++LrzptTwQECWnKZi2RT5QUxVWveTBg5s7MmR0uIYbn5cosUfIUVd1tb2zauILxsBmYs0F9Q2XCNeW/y5FBVXj2uK3cf0BOKr2+l+zZazRd46Zr7Fo1RDm6hboB68=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from BN6PR1201MB0258.namprd12.prod.outlook.com
 (2603:10b6:405:57::13) by BN6PR12MB1443.namprd12.prod.outlook.com
 (2603:10b6:405:e::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.28; Tue, 7 Jul
 2020 17:34:07 +0000
Received: from BN6PR1201MB0258.namprd12.prod.outlook.com
 ([fe80::ac9a:b1f:fa1a:403b]) by BN6PR1201MB0258.namprd12.prod.outlook.com
 ([fe80::ac9a:b1f:fa1a:403b%3]) with mapi id 15.20.3153.020; Tue, 7 Jul 2020
 17:34:07 +0000
From:   Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Subject: [PATCH] amd-xgbe: print the right c45 id
Date:   Tue,  7 Jul 2020 17:33:47 +0000
Message-Id: <20200707173347.1564682-1-Shyam-sundar.S-k@amd.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR0101CA0030.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:22::16) To BN6PR1201MB0258.namprd12.prod.outlook.com
 (2603:10b6:405:57::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from jatayu.amd.com (165.204.156.251) by MA1PR0101CA0030.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:22::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.22 via Frontend Transport; Tue, 7 Jul 2020 17:34:05 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [165.204.156.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2b1415c9-cc55-4c2a-7b11-08d8229bf37b
X-MS-TrafficTypeDiagnostic: BN6PR12MB1443:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN6PR12MB1443139F95D70D06CFA962DE9A660@BN6PR12MB1443.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0457F11EAF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GzFT7DqlSSrcq4/+AZ4FdD/GtOkGOUa1+FHv39ChXsWCQONkaIxkIt8QiFaAQMhwrQ+LIz6jNpvcFH+LvjAoCKvdMJk57rjcKYnWgeS6SB3XB6O5+3p0FjuBAiokJNR8VkfAhoQk7d+2sH1QBEKTqusRI3VmRQks8RHhNo6c3jpY7pwYl1Ii4N0fy4nDum7B/ekEaFX37aowv0/aSCnVcNLWAM4hA4lJ3oN2vgOLUcZSMp6ybVe23tdgWfopsnRDK2klEEhWR5NCt2MvzrLDdihXWkzmTb5YLckCcEQ4IncFxFUTWk0Rx9fQiLfp/VRjxYnZYtH+HVsg5QvsUtxhFQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1201MB0258.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(396003)(39860400002)(366004)(136003)(110136005)(1076003)(316002)(8676002)(6486002)(36756003)(6666004)(83380400001)(5660300002)(2906002)(16526019)(52116002)(7696005)(66476007)(66946007)(66556008)(26005)(4326008)(8936002)(478600001)(186003)(2616005)(956004)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: juMAYuUeThZ2RqQhxMeYeghUo49XRjJse9SoUj5NNf8CMl524Lg8J/VMVqrDOuW+GPi98Gdf/qqy1eSSF/37EVml+5ZRjZy5EJK+Wz5elMTMUTnRcdH68NHLQThVnxLVylVS3EL896qTAfZ1Vc/fNqd743gHbZR46v37YlxUiyQtm3ksTMLdRfURG4AZIu53mRt5sN+fskpE25pS+yO6a5tMPN/b0eQSvGNLXRvM5M9A0NnZ07WeMX+6htzw3RuXt3ZAjYEKLiUsSqgTfErFALfsOtUpHC6VxhEHJl3gxW0+LFNSiZUhZ4NQ7TJIHaKo0vVm4XVgWExrMkgPDWkkKO8TGEFlUCVNo67RM803XztoWsaYPqMrjGjDlLdc3xqxG4rrYleVgIN8CnqfscvQZAhhurshiu+Q0K9ExUzg9wDCfRYpEo01k4z0EzA9bYNR2EmgYI4QhTNixSvA4l845sbRhE6W29vu+DPoUJzW9jQUQejfJ4bD6dcBInqjWP3j
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b1415c9-cc55-4c2a-7b11-08d8229bf37b
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1201MB0258.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2020 17:34:07.7594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: epp+RCDfJ6y4XseY1DxHnZPMPJBRYGNJyRG5ZdB5DADR67AjdMzAmT/95U/NUeBWxniTiKEHQgq7CA3vC3ziiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1443
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If an external PHY uses the CL45 protocol, then phydev->phy_id will be
zero. Update the debug message that prints the PHY ID to check the PHY
mode and print the PMAPMD MMD PHY ID value for a CL45 PHY.

Also, removing the TODO note, as the CL45 support has been updated to
do this.

Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
---
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index 46c3c1ca38d6..5b14fc758c2f 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -1024,9 +1024,9 @@ static int xgbe_phy_find_phy_device(struct xgbe_prv_data *pdata)
 		return -ENODEV;
 	}
 	netif_dbg(pdata, drv, pdata->netdev, "external PHY id is %#010x\n",
-		  phydev->phy_id);
-
-	/*TODO: If c45, add request_module based on one of the MMD ids? */
+		(phy_data->phydev_mode == XGBE_MDIO_MODE_CL45)
+		? phydev->c45_ids.device_ids[MDIO_MMD_PMAPMD]
+		: phydev->phy_id);
 
 	ret = phy_device_register(phydev);
 	if (ret) {
-- 
2.25.1


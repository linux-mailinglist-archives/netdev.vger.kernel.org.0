Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6791216C0B2
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 13:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729729AbgBYMYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 07:24:03 -0500
Received: from mail-dm6nam11on2064.outbound.protection.outlook.com ([40.107.223.64]:42817
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729048AbgBYMYC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 07:24:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E1eCxmOoVIF1JLRRu0cCWavvzUqyQeecLVDGWkPshfgnOb3HqQE164AyEluJwc/sPbJQYBWZ2/aw8YddUrRZvRLky/1e6ZJQnQS64K8RlIeO8c79AEvgoh/cU8G9DaxHdY/fA55o9lAcYPPZa3JatHa6PL8FXbGsvC6WTzDhs00vt5nxvp0YZt1Fj0Um/8jbOLaMGi0OHAFxgtLExA8OKjckwb4Z9eBnxmTislOTl09QfAzkiZSy8WrrANhes13U+Z4sHCtL4uns1sVpN0bKPQteyPS27cg+VFJb99jpdAm696wAekMPYVhBn2f9/DdYxfec89VWqDK5j8EIPefYiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zOQYIhAlhsOMcgLdDsJOa46/769a/JFRgnSHKkt9lxs=;
 b=Xs9mA9Db2wa3lvNqTyMIVZzfW0JZME6byZoHSBU8MYsXJP71tGJp+4zmwHaOtmIkpn7ofrFb7XgiwvacsGZPDwiam2zqcc+MKhhlU9RQlu8YtcN4sckzKmC4rc2lWySdFv2G8kZ9KEDurhggtVYcemkh81gSxrXCyImR3yxaY+G/vASNId0PfurIqedgzxKWUJxHNxrlF4he+QsCBzEU7VtHAIhstnFken6z5FvLgSKpAYkn28GdG7sy4uPvM5O/ybHUuBUaD2lKkftnUEzUCRF5q154JaARdZ2T6Q8Xc2dAzzlk+7jOaNxY0isVdQnu5xwAbSwtblIARy6FADhA5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zOQYIhAlhsOMcgLdDsJOa46/769a/JFRgnSHKkt9lxs=;
 b=MSwHJDmqFOAZwm/3lwUyCnKkmTi4QW1Ft6uOSuoW3dBFRhi9NDuLE02su5uyLsSi/cFEkMqSImVovkcZCGXC3D4jUq4unoBOJdY/flH5j5nGfdNvAYHvU3Wnw5RdKqblsTf1XGmZxEonEsbxAMXq1SchOopX1RmatPUMoLFRHbs=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Sudheesh.Mavila@amd.com; 
Received: from MN2PR12MB2974.namprd12.prod.outlook.com (2603:10b6:208:c1::11)
 by MN2PR12MB3264.namprd12.prod.outlook.com (2603:10b6:208:104::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.22; Tue, 25 Feb
 2020 12:23:57 +0000
Received: from MN2PR12MB2974.namprd12.prod.outlook.com
 ([fe80::a142:9294:5865:65c]) by MN2PR12MB2974.namprd12.prod.outlook.com
 ([fe80::a142:9294:5865:65c%5]) with mapi id 15.20.2750.021; Tue, 25 Feb 2020
 12:23:57 +0000
From:   Sudheesh Mavila <sudheesh.mavila@amd.com>
To:     sudheesh.mavila@amd.com, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: phy: corrected the return value for genphy_check_and_restart_aneg
Date:   Tue, 25 Feb 2020 17:52:08 +0530
Message-Id: <20200225122208.6881-1-sudheesh.mavila@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0133.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:35::27) To MN2PR12MB2974.namprd12.prod.outlook.com
 (2603:10b6:208:c1::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yocto-build.amd.com (165.204.156.251) by MA1PR01CA0133.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:35::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Tue, 25 Feb 2020 12:23:54 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.156.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 22d1ec1e-1f6a-4310-51dc-08d7b9ed95f8
X-MS-TrafficTypeDiagnostic: MN2PR12MB3264:|MN2PR12MB3264:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR12MB32646877CBAF64646084E366FCED0@MN2PR12MB3264.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:595;
X-Forefront-PRVS: 0324C2C0E2
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(136003)(366004)(346002)(376002)(189003)(199004)(36756003)(8676002)(44832011)(316002)(5660300002)(2906002)(7696005)(4744005)(26005)(2616005)(1076003)(66946007)(16526019)(66476007)(81166006)(8936002)(6666004)(186003)(6486002)(66556008)(52116002)(81156014)(956004)(478600001)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR12MB3264;H:MN2PR12MB2974.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k3gpn4kbb4t+IlTZza0I7fLJDUO74Q+gvApI9fyfwJuDplLS2Tdp38VCuyQHyo12zhETxk1ZdLOWXo7ZcucqXBdffVyOqV8LRwTchX+5v+a6K47s3ctLfHhSpZJUvnwcsm043q3o0gCaPzVpSvECP8UwuZyNtR9M4QCFQzZizrpgKi8v/49TH1PC7+Zf/MEcvU+3WwgDOxZ1CNPIUC0mDjPZiEnvQnoGQGqnrMeUn3tI0EeT5C06qMvsXP4MjKZVrfSBrSZ9w5fqTspL5xbmsi9yPQP6extUDBglpzsjpebIUIaa1e5tv1Ae/s7iThibfirN4kTCXLMVT/OSlaqk/oZMWy7evs2/uBmeINjK5FPvdDcdhKCprbIkBViPRD7xTrnMqZuuA1J9eZIn/tL/c0XUX9hu7lu3ZFb+xnaN6QsHP2SJsGu9MqH0ya9Dhprd
X-MS-Exchange-AntiSpam-MessageData: TJxlMYmTgJubDMiPvy/zidSiHq8NdM5XWTS9sDqmB0kdkp4oPJ+l9nWpAtjwTJFdYV14VOJrA+R+ra42QOOg85wALpr8hGnM+BawT4yDFOjc52FJN0MneTxoPFH+GzXdSn8aHXra0v/T3in422tUhA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22d1ec1e-1f6a-4310-51dc-08d7b9ed95f8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2020 12:23:57.4309
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8bbHyeyTJlMb4O+0j4P96dj9QWhdGhZFmfLOzOhHE++6O6NFw7UGNvJQji4+Ta/3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3264
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When auto-negotiation is not required, return value should be zero.

Signed-off-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
---
 drivers/net/phy/phy_device.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 6a5056e0ae77..36cde3dac4c3 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1806,10 +1806,13 @@ int genphy_check_and_restart_aneg(struct phy_device *phydev, bool restart)
 			restart = true;
 	}
 
-	if (restart)
-		ret = genphy_restart_aneg(phydev);
+	/* Only restart aneg if we are advertising something different
+	 * than we were before.
+	 */
+	if (restart > 0)
+		return genphy_restart_aneg(phydev);
 
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL(genphy_check_and_restart_aneg);
 
-- 
2.17.1


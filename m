Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90AB331D1C8
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 21:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbhBPUyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 15:54:53 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:13448 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229699AbhBPUyt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 15:54:49 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11GKl9Y5020440;
        Tue, 16 Feb 2021 15:53:52 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2052.outbound.protection.outlook.com [104.47.60.52])
        by mx0c-0054df01.pphosted.com with ESMTP id 36pcj9gycy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Feb 2021 15:53:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f1kYsa5wxoTIXR1lDS3DnUcSEGlYsEg6Y6+lidVveSPc9J3B7Q6Rfgyc0Ua9wCFaE/q4+aSuEUn3CnwICN0KzxTmmfI25HqnLBSrroSSsll2MOS7k1B8uBUbZdPIlNRmxbGOtqwGeR4N6mZ+M7o5P81eDLs+p6t28CRaT0OYl4XP7idB6I52Lx65okiyncsBF0cZ4YYZjeQKDkGI0MavG3MocC0I7RO9ZXAamlZ5h48qG9uq9l1uv8Uv8FtNmPo/64F3tIKcnSOf5JgVNXd5EDE+u9toLYYflGT3CO9PYItMWNSN89GaZkGmmpg+nO6cjI14IgXQyF9GPht3DZKzUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9BZv0wW1PlXrtAoG9v1sbTv/a5AZkGw98yAukYU/SIk=;
 b=OZLzIm4YJJNaKYr+4eBY/ScOm+Z0jsqHgRL+JusjdLoXhEE6ot3BHk3Wk4vSNiT+L8n5oDFdaRSrrCTIW3lRrmlzbY5cMpnklDeOJy7sGYcQ5vsjh1jEssQJI4QikFPnQ2DJA5HLZg1joyQvMA+6r4volNBOeduHjHV2G5nsi3Z468lVxB4/2xQFfhYgtvjRRv2cYLtqQYkxXgHHmJwt3or4XNrh8mUVQ5ivj5SIg8qR/sx9uDqHmKd/e3gj+/gseSchgGUL0RZaA1oN42f+hJrVM2Jl/B1c/qR14urBHb4rwmq+drjMqBEKcz7bB3LQmJ/HWo7Rmb3U0JPayOfp9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9BZv0wW1PlXrtAoG9v1sbTv/a5AZkGw98yAukYU/SIk=;
 b=O0suhrvEA0mwZ2OWm1bB1DeC5HNE0WhxNK7S+2+3XM1Bt5HKRuF+u/Yx8lZdQuM7p+D4l3rJvLmyja0/reSL2TS7Q5rCpWIdioodpVjWhPkJIxKTp7VjcGcgujsyvdlGnM5pwrUKkHvKAU12LmZ546y/G31DvSY53Eoa63zP9HE=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=calian.com;
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YTBPR01MB3118.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:1a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.39; Tue, 16 Feb
 2021 20:53:51 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3172:da27:cec8:e96]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3172:da27:cec8:e96%7]) with mapi id 15.20.3846.038; Tue, 16 Feb 2021
 20:53:51 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux@armlinux.org.uk, netdev@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v2] net: phy: marvell: Ensure SGMII auto-negotiation is enabled for 88E1111
Date:   Tue, 16 Feb 2021 14:53:30 -0600
Message-Id: <20210216205330.2803064-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.27.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: YT1PR01CA0045.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2e::14) To YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:f::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (204.83.154.189) by YT1PR01CA0045.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:2e::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.38 via Frontend Transport; Tue, 16 Feb 2021 20:53:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 40c151e5-8cfc-4906-aee5-08d8d2bcf6ee
X-MS-TrafficTypeDiagnostic: YTBPR01MB3118:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YTBPR01MB31180F5CAA67527975E408CFEC879@YTBPR01MB3118.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yb+3e5vhYkYclZ1xV3bdlqXRrJ0RrINYA9AC5ZFwMb4RDVXEGnAyGvz5oXkzoc2TP4tqksc8VeqGQI2UuZlz0g1VgNbby8RjLHY5ZoVy6I0ezKkIxba0GTn2StSSL0F7qOJrIH+++ZDP396CiUxoLiKnrC0XM5OX3U/J+muFUrUEbthNVZTrZCo+/IiHTe5TdiFp4PXTt3DpjJYQf+Icixd0JxmE8far5UywcT3VwkHXFRcpLx7kBQswEh+HkZfWYYFjRDXZo8l1PoXe2kfC7iwceXvp/1I/tDgY+TRea1hFBFK7KGhUnz+OWCzqXEZbrIS1cXdueZij7gbkRR/8kLCN9TblMUvK9iG1oosINDWdM43zuBzYKc3MoxHYBJfou/Gq9J4z6sBirSnuAOa5JMeIwrEpFxs2pL2OQP/yHYUPxjVWrPZLHV4Zv8vamJHyqNKc2HoGWMd4VohNgXP6qDdlmTBzRNstPPiNrhiXnkvhp7V8qmm7IkB27D3MQE6FmySWWbeTExt42+KRgjHkWHpZ5/hZrPkDSXjyVmE0pdz1a/iWUSL4v7YC3a/G7G+s65S62wts3Clqy4Ly4ojbNw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(366004)(376002)(39850400004)(396003)(6486002)(186003)(52116002)(44832011)(6506007)(8676002)(26005)(5660300002)(478600001)(2906002)(8936002)(16526019)(4326008)(66476007)(107886003)(66946007)(1076003)(86362001)(66556008)(69590400012)(316002)(6666004)(6512007)(956004)(36756003)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Ze3/MABufqR5nIHCViOQWrMS51mEZOm+oJfKWv18HWLnEiIoMyWfmFWNUwds?=
 =?us-ascii?Q?wkIy501C7H5WgBrG+Ag0irmwdONGzqnPw8WuqZUUlTvx2E1V4pvlZ8PWTPSM?=
 =?us-ascii?Q?rWSyVLNnj8+hbfJSuqTbeER4UugoZaORlMGqvD6EEoaaCxMd5+kbLwHhcdeJ?=
 =?us-ascii?Q?8OqJJG4cEbLq6wuT0xdJGPNiOx85yV8qEUPNPkcHZn+fsoEbabq8eXkqZ6hz?=
 =?us-ascii?Q?xhKdnday0usa8+ewbaMeoIbe9gvTyQLWXreZWdjzS/8H6cZ1L/2/MKtIWsHq?=
 =?us-ascii?Q?Za7rpY+B8uxR96WPUyFIkHmX64SN82kBu9qCBz88/GjsYdnpbh0Vgum7qeMk?=
 =?us-ascii?Q?+hwfZxTXVu7NseGZkrSt4cKZxmYK6bqy3aGljko+B7ELTx2S2/FBTia1z8sN?=
 =?us-ascii?Q?EOaArGH9ibmrU9DOILRcIOsGvGeuw+xzE+RrlQlz588ixwcbr67IC2rdH5tt?=
 =?us-ascii?Q?5lLrD0HIrQkhcA68m6uJuka1ibXKAhtdCiW8DHslRRVHpt/YTj+7rXXH7oF5?=
 =?us-ascii?Q?l9wLKcrMYtHkgXoJ+easp5k57xuWV0q20EAeQJoxspiFN/myxbeJ5nn6M/38?=
 =?us-ascii?Q?21ht7GcryF5n5kiFSLIiN73Gkbp4V+UEnlEJWHbXVY+7BMYqHIigVoext00Y?=
 =?us-ascii?Q?u/Rj7hW68AIDRFF6CMb9uhxlB9IOXEDsf7rvI00HxUq4FcXOEW8DKQiDgv7T?=
 =?us-ascii?Q?olEd8l/eRR8lIMh1F2LUjrowBSlYbByBmY1FlWGU8bn0aR2p50X6OWuFolnm?=
 =?us-ascii?Q?0zo6lypa83/DeXOVDO0j4vMwO3S5nXlxAEGEY4u08LmcYbGyP75cZ2TUwnem?=
 =?us-ascii?Q?MwDobCZGx3jFP5ifRDgOHdDj4vZCviyKjdnCthc+1KCsb6kr+pvbH05Sr80E?=
 =?us-ascii?Q?SdZdcGfTG0ULWu1ZUvBvQryRGz4jmgDQXlMXpsAJr3t2zVCDUPIoqBeFv/AY?=
 =?us-ascii?Q?DxhUbLirink5dKuwYlPMl2pjrFqY+fqjQ8zqJAv0opftGhIu16eWRpJJ4qPB?=
 =?us-ascii?Q?9CUmbQKiT6b7W+EaLsGgdsJo9bDsuxdIbIomlluhbR5T7T6S9qLJE7ouHXb9?=
 =?us-ascii?Q?0T9dsiabrdG54GmpOsbevhN9K26atg/dCWjua8EjEtPWA/gkzZzGDK/zMEGL?=
 =?us-ascii?Q?fV9CA65wnwprzXApaLknaxKd8n/JQPGx+hzgLR8NJU5MOQEJccDB7vw89ER+?=
 =?us-ascii?Q?TbzRAtoqOjrLx75zljI+zY2C8NPJIQGMRiua7Uh0F7SlvsnBelRexwAMcNY7?=
 =?us-ascii?Q?5ViClq9gFfSx7YDJXqdEuEui1uj89yD8Eoi4EDkTnm7HAzTl/K8NIJY5iHLb?=
 =?us-ascii?Q?ZJmqE6fny2ADgnvL7A4W9FMe?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40c151e5-8cfc-4906-aee5-08d8d2bcf6ee
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2021 20:53:51.2806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QChAd6mUuoagl30DTWakEdrVfu38EwX2gBZTSTTQaRO+Dn6DVY4e1rcTl9n/RkhwmTb8TApRWrWe6JhtRFU0VC+4KEvoPgJtv7RTEalZ7Bo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTBPR01MB3118
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-16_09:2021-02-16,2021-02-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 mlxlogscore=999 spamscore=0 suspectscore=0 bulkscore=0
 impostorscore=0 clxscore=1015 phishscore=0 mlxscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102160169
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When 88E1111 is operating in SGMII mode, auto-negotiation should be enabled
on the SGMII side so that the link will come up properly with PCSes which
normally have auto-negotiation enabled. This is normally the case when the
PHY defaults to SGMII mode at power-up, however if we switched it from some
other mode like 1000Base-X, as may happen in some SFP module situations,
it may not be, particularly for modules which have 1000Base-X
auto-negotiation defaulting to disabled.

Call genphy_check_and_restart_aneg on the fiber page to ensure that auto-
negotiation is properly enabled on the SGMII interface.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---

Changed since v1: Fixed typo and added more explanation in commit message

 drivers/net/phy/marvell.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 3238d0fbf437..e26a5d663f8a 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -684,16 +684,19 @@ static int m88e1111_config_aneg(struct phy_device *phydev)
 	if (err < 0)
 		goto error;
 
-	/* Do not touch the fiber page if we're in copper->sgmii mode */
-	if (phydev->interface == PHY_INTERFACE_MODE_SGMII)
-		return 0;
-
 	/* Then the fiber link */
 	err = marvell_set_page(phydev, MII_MARVELL_FIBER_PAGE);
 	if (err < 0)
 		goto error;
 
-	err = marvell_config_aneg_fiber(phydev);
+	if (phydev->interface == PHY_INTERFACE_MODE_SGMII)
+		/* Do not touch the fiber advertisement if we're in copper->sgmii mode.
+		 * Just ensure that SGMII-side autonegotiation is enabled.
+		 * If we switched from some other mode to SGMII it may not be.
+		 */
+		err = genphy_check_and_restart_aneg(phydev, false);
+	else
+		err = marvell_config_aneg_fiber(phydev);
 	if (err < 0)
 		goto error;
 
-- 
2.27.0


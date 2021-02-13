Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7549A31A92E
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 02:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbhBMBAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 20:00:42 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:2720 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229796AbhBMBAj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 20:00:39 -0500
X-Greylist: delayed 1805 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Feb 2021 19:55:15 EST
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11D0Qnpb013520;
        Fri, 12 Feb 2021 19:26:49 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2057.outbound.protection.outlook.com [104.47.61.57])
        by mx0c-0054df01.pphosted.com with ESMTP id 36hrw92s6s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Feb 2021 19:26:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gyRbtkelRZK2hxZOHg5+kdsd2OoAELRa9s4qDJJeukM/Jf4OcJ53tzweUPJO7Owby2ho8eiIc4IRi4+UF3caKxyU6M1WFwjQtyS1gYH43T7QJMpoTbM4Lz+/5VSBZZOZBijB/cpCA/PROuEPY1F01BsBFqnTBLPQN2uNoqpE6mHEBpCh3Z//ErKQYsszCfLNYF34hJdzxlCbLaT3NW7/g29N9VVysTXFUgRYqcQnpEGyycEYPOFApMZ70P8HgEgwqaSKNaMjwx0Kxb+60XRGeB3S+FI1HhAblF7Q+YuGyoJ49GPyMudfe9l4Y+yjYBKD22OT7YwqU1HklS7IWiOamw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dAAAdggV9Aa2JZV1htDE00RwuVIOKNG0KYtnjoz7qMI=;
 b=ibaEYXrLaBHc8k6BWTmKkD0TQEVovUZ0VAlOfIDVw3IYENyusWQcEnsMc7wRFTQaIJsmxCHpivV3EE04o7Y/m3tj5wUVF75NY3iVvAfiypNpEQTdOhLXBDLpA0F0WNqHZyIr+kBbG9uJ1fySjtpU8SrB8HLzmySwzrU0DPL63wxkgFgmrZpnfs8TLjUDyeQKYZwNeP84yq0AWjpJWzI0UfIVTKjMUfXUb6UxrY5cYqB8cGo67v4r1DSGlPnYiIbdkRlS+n/hauscudN0BHOKI8EJpDD4maLVDJDlo3Nffj8vtXQU2HtX8fs0wd9+4AswewwJxOEPS8Lv6/HVEIN+NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dAAAdggV9Aa2JZV1htDE00RwuVIOKNG0KYtnjoz7qMI=;
 b=2SyxXLO7mY6W1Q63PrjVimoAyImB9eHa/3o3ujqLWZ5CKAAPQVQK/o5DFA569ygGkZGsigpGmgSaclZLN5giOnHrA5eVZ+NDNqR1WFrjfcAnXf7LlLKjaNce3d2rVbVciLs92zRIcV65vsMNDosrrK00GGfSiqI6E3tMxkQUbSs=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=calian.com;
Received: from YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:1d::17)
 by YT1PR01MB3564.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.30; Sat, 13 Feb
 2021 00:26:48 +0000
Received: from YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3451:fadd:bf82:128]) by YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3451:fadd:bf82:128%6]) with mapi id 15.20.3825.034; Sat, 13 Feb 2021
 00:26:48 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux@armlinux.org.uk, netdev@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next] net: phy: marvell: Ensure SGMII auto-negotiation is enabled for 88E1111
Date:   Fri, 12 Feb 2021 18:26:29 -0600
Message-Id: <20210213002629.2557315-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.27.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: DM5PR13CA0014.namprd13.prod.outlook.com
 (2603:10b6:3:23::24) To YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (204.83.154.189) by DM5PR13CA0014.namprd13.prod.outlook.com (2603:10b6:3:23::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.11 via Frontend Transport; Sat, 13 Feb 2021 00:26:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: deae0868-74a2-49cb-5fa2-08d8cfb60ce0
X-MS-TrafficTypeDiagnostic: YT1PR01MB3564:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YT1PR01MB3564F3ECDB108DF47F270738EC8A9@YT1PR01MB3564.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U3RbH5qAeMbuVplMVd4/hy2dA4vt9wQm2y6NuZ29hRGUi48XPsUsHlij9PLfLPpQKFPPSw11eBl+uEl91+6VixOGdavYkSTZnfbVHkk9CJieKREfAq5frZr4r2xhIc5SgN9pJQbTueyDj/mWlqeQctA9DHA7omJbjykaCToiWV4K0sAtzZ6a4mexuVrIYU4bDrwk4DDv9SNwy5TmGB8F2Ct1VUfn4kVNYmNU6UKh67BVgpLxtHTioo7AnQVsIu9hEBRLgKv4R/uOHcGXuEpxto2hH8H/i4RcXV279gCOls1dPJiZuEMbF7lR8h6jR2KV1vNwkUsLyoM/1rvM2NnMti39kVBIgXQwIU8MbvLHNFjzjFswmTT2WLhYcD/s/2tLgF5c2SByD1OciO72uhDgJgStP/TqSy/5LHdgTdzLJzhwi6++D4aFm89wju3sBWozOLhHvFhDCnsLfQHgjAAJnl5LS2YtjHZEb2QCYUGUjwgz4SGMSdvGHP08sqwq2w6T5nXd4e1y5C2S8CoZqjPanOUGkeVdegDUxJ8iVTOxutBBSuYJvM8BVxr3UgrfrrWzBM1fUj4JKiuhuw2B39fUXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(396003)(39850400004)(136003)(366004)(346002)(376002)(1076003)(6512007)(52116002)(4326008)(478600001)(66556008)(66476007)(66946007)(2906002)(8676002)(44832011)(2616005)(107886003)(6486002)(5660300002)(69590400012)(316002)(956004)(83380400001)(16526019)(8936002)(6666004)(6506007)(26005)(36756003)(86362001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?9p2KANY88UJn4kI4lni/Rq8Zs3zh+krt1fW8BEGB9hyipH5WNFb6Hv1wJXib?=
 =?us-ascii?Q?oOEdIO93j1JdzcW1gOVpJ5jipsOs6lAj9fPu7VDnG0oaqPTv2XOEUCY8OsU+?=
 =?us-ascii?Q?19Ixq/qpfd0fTG0XxlsRphl9yNO04qjPL7K4wQvkDEm2eXNA4FRTUF/tEzVJ?=
 =?us-ascii?Q?ZqZ1hD87j1adH4K+n2mtD22Ucz0UDlI/KC4o/58I6BAvdZLyvzWuZFtmwoXC?=
 =?us-ascii?Q?DL1Y8/+FlDscDg5eKZC1bFkJu+EOzLyO3cK2+8ojTQh/0L5npA6809akAPOw?=
 =?us-ascii?Q?G4kncbIZnx4ddmzTgzQRbOl8ihhG3NfVMBEXQVsYQoUpUzkFwQdO07ZUGPZE?=
 =?us-ascii?Q?6Rf243Kdq7y9dn1wwhpvo7y8adrVJ1IEBC0CinAkAma83mZoSTsrRFH7OWcb?=
 =?us-ascii?Q?zXBrCKJgtm/rrHH3WoXthVhd2ogVzO7Bwi8VTkQYH92Uv0jAWZFhLCP1yk9C?=
 =?us-ascii?Q?0QardoQV3XA0dJQCYpTPbgDK5UxD5s+k/cS4ZszGjcJrgHCJt78KpJz1gE97?=
 =?us-ascii?Q?jMheKj4ai5b73b1+JZ4kKNor6WLfh2F2FKUo0/50CmHd64cwi+jL6izLjG6m?=
 =?us-ascii?Q?hjBtL5Ek6mAn49a3jtP2Jeeg1uGcdms2UuBU1YZAyH3phnVcc2EbkpMUO9hT?=
 =?us-ascii?Q?jgXpGCou3N7Qe+gfEccZRbuSgmusWXT7gGZCYJUEa/HBArzR0LCz28fgY1Sw?=
 =?us-ascii?Q?WRz9g46bF6tmSEpiqZQiUP1pSdhMGzTG3ATtovi8xedj1UAhd49q9yP/V6hL?=
 =?us-ascii?Q?IDWTffLq1k7G38Q6gMGnEpxNtQ4Icm3L00bCso9iDwJStwZmYXaAQ1Vd7Sh4?=
 =?us-ascii?Q?kHsdQEJHHKuLtJv7nJm1qQhXbfTe7t/FHQr2Kn5tnH+klLV7qD/290+bMi4T?=
 =?us-ascii?Q?b0aqqR1kaMyCbMyI5Ijld4whlwp6oCeDU1wYCARm87NeicEZDr7jB/aIqLqi?=
 =?us-ascii?Q?aZSLP3LKov2ma+z6vTOSXkIV7v6FcS+4iLyQixmMgJzPQdj0eGt/chzvzmeg?=
 =?us-ascii?Q?F1snG+70+XWq7PLEYQOnMACMkD+sqhZtK+dbbQfWvY0GvySSWvGBRgNoA+KI?=
 =?us-ascii?Q?KoCPQi3SNGjeIqwFvTWr4d049+eKWSX+Rka7rGb6akWAxRGn+quelByVqOnm?=
 =?us-ascii?Q?kC+nK/uwK+JFfRrXXXl5HIIgUDeSUWmNYtmmMCMVP5MEmwCUY9CXhmCpXRvk?=
 =?us-ascii?Q?d2KY4wpTdJw1mhLXZ1YsC7He/L9P0n7EthgZuigfyyfUzz6QZ2GZ+8qkmL1f?=
 =?us-ascii?Q?c9cBlGxkCr48utTAO9yPCyPv98BXR17HTXNfzuBtJP5HDSv+EsSLfGh3Iiy9?=
 =?us-ascii?Q?f2MQ3U66F6GyIOYrJyuQURLT?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: deae0868-74a2-49cb-5fa2-08d8cfb60ce0
X-MS-Exchange-CrossTenant-AuthSource: YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2021 00:26:48.1253
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8PT6It3Kxml9EA9iF8t9NF0BP9CshffuajKg26G8vkhX7d3fLca7v0UufmRxVUobWnV5Vu5Wfpct7PyKakqI73YH021R8TtPiobK4V2jLnU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT1PR01MB3564
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-12_10:2021-02-12,2021-02-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 phishscore=0 lowpriorityscore=0 spamscore=0 clxscore=1011
 priorityscore=1501 impostorscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=901 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2102130002
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When 88E111 is operating in SGMII mode, auto-negotiation should be enabled
on the SGMII side so that the link will come up properly with PCSes which
normally have auto-negotiation enabled. This is normally the case when the
PHY defaults to SGMII mode at power-up, however if we switched it from some
other mode like 1000BaseX, as may happen in some SFP module situations,
it may not be.

Call genphy_check_and_restart_aneg on the fiber page to ensure that auto-
negotiation is properly enabled on the SGMII interface.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
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


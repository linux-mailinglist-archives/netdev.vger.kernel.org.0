Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5CD5122FF
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 21:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235327AbiD0Tq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 15:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234764AbiD0TqT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 15:46:19 -0400
Received: from mx0c-0054df01.pphosted.com (mx0c-0054df01.pphosted.com [67.231.159.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A465E17A93
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 12:40:34 -0700 (PDT)
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23RI5Owk016748;
        Wed, 27 Apr 2022 15:40:03 -0400
Received: from can01-yt3-obe.outbound.protection.outlook.com (mail-yt3can01lp2174.outbound.protection.outlook.com [104.47.75.174])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3fprsj8ut4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Apr 2022 15:40:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IX2wfkYVXsE98g2DLMwYE+6jsw4UunHyJktM8jTlRtWwpnCxcYLmWhCzfG7CgjE7Vk7ikjzIcpuaWowGc9cEN1iAK5kHir6PFNSz04YSjbyk6ic2MUyb7YR8I4BQD89kXSEP8ksfdGMzKxL5lRzisIQH+IlGaWi0RC80xtf7fZihzEAUOB2RLAojMW6doeUYD7f0rs0tayy4tJRfhE29DNFQTDLvI7k3dO2AR6RHEwGU8WH/71+oAxHchdH3aBqvE+X8bAXSQuOcCQq50ZfPca3EtP4jxudPc19/bBZGGgdX97e2VG5ur0c/J32YhjPtqSfwUMMyKtvSESVJcp5/Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EPFz55+16+qPw6bfCj3nIrZz1Zf2on+A2ZPuBygwrvI=;
 b=eocL/YB85i9z15g1ed5DYFzK0MiaKqcJhpPeiU5FMjO1K+auxNc9xsZrq3RXBXm52CWs731F9WsTmnsJqSVRkBqBMWp2DrHLXiWlTcEWU4A8AIqvRW1szp6pUMz9Gsf0xYMnUxQyxqzCGVnFB134y4uSbaBMqmjn4b+kcFgEorTf8itxKg0sInrbMPJkjxOiM4XtkRq1HlHbi3xyRkBoI0XpkSKevenz6t+k+z/ARcr4ADvME74aQbLMOwMzZrUYiLfertW9ycJ4aCUu1vGlPlq9od6Prrip9n8m0h/KcCpn0rr74kqt5bg7bGYEbX+1Sz4x74c5fFG4t6+EJU7JbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EPFz55+16+qPw6bfCj3nIrZz1Zf2on+A2ZPuBygwrvI=;
 b=NPWEeaWII5HkWXPg4RxdGiHQt2d4IRPWuQkJinx6PPSQHL/OCo2WUVndc9XLC3Io65fg80uVnzGbt/dIen32Ezi+AS05P5eITPI0gYoYbvShL0dVwl2Jgse8HX+N0x39XtMORq+7SbqPyivtk2drhDSxBN4p+Yde7R8fZ9xFYkA=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:66::9)
 by YT1PR01MB4616.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:43::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Wed, 27 Apr
 2022 19:39:59 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::4dea:7f7d:cc9a:1c83]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::4dea:7f7d:cc9a:1c83%2]) with mapi id 15.20.5186.021; Wed, 27 Apr 2022
 19:39:59 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next] net: phy: marvell: update abilities and advertising when switching to SGMII
Date:   Wed, 27 Apr 2022 13:39:28 -0600
Message-Id: <20220427193928.2155805-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0080.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:84::23) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:66::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5744f800-bf6d-4bfd-0794-08da2885b74a
X-MS-TrafficTypeDiagnostic: YT1PR01MB4616:EE_
X-Microsoft-Antispam-PRVS: <YT1PR01MB461614635BA903AAC99A8AAAECFA9@YT1PR01MB4616.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W0B+qwr4HcMeb912AzfwPqBrfsLfMspALPtOQ21RqRUF+CyZ9j38RuH7POpc8mY7ERKPVlrT5CYH3EGIZC4qNQJubboz3YD4dZ5xKNqXC/a4ilPmY/xUWiSuuE8YE23m+IsXcr4uRU4qiOdgd/CZ9uFOXnx/7bP41fc+7ioRmP+GfM1aq3l8gEVuL1cjpWzO3UiUGYDaDrdU6EF3VMQFkZp4fJwb3lK3Fnnv45STLobkee/3Zur9tWNVOEc0In9bEPWE9WjchkiDKNO7ruak2KLb0g8AMV6o4g50ebb+mNrWICoptDlJY3frMd2h1tHPt/0Y6PX+1lNsDlBolqLtZCl40PYYyxpsnKAXiycovcdRf7EYexOkkUUJ56o9R75r0VCwNCC/wrELPPexi6vwaaO8oFKVUJEG1wj/UEOW6bYEs4Qf47j0PCJ5VY58qoNTbAQpIxIZ8jWrGQ+pEBkZkrSEOUOnvGnTmiF18IdseFVzUMRLuFPg5SUq25zttIERp2zg0wLtNLH4C3iq0lulN01M3ueRsfSHWkGf7I1Xe2P2XsiK/gu5TrV72/gQFPxS1NxjW6ZYCRm63fACPLli0u1JPMRO8EvyjhbZZlOQ3aGDn71JpAZ0VxK/EE5063je6MjrUM9v+XPdJB+ZW/fDc3adHt0iLvwLGab8e86CLdePdzN44tYly+5CWBzFX+aGAfV1e+HLvA9XHpwkLjRGUw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(66476007)(66946007)(66556008)(2906002)(6506007)(8676002)(4326008)(6916009)(52116002)(15650500001)(44832011)(2616005)(6666004)(5660300002)(6512007)(316002)(107886003)(8936002)(86362001)(26005)(83380400001)(186003)(36756003)(6486002)(38350700002)(508600001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mmyYnLEH5MrC9v08yxs396xmCSIzNoCr40jelZ+gvg1phi4j7UF2s1J2+hCm?=
 =?us-ascii?Q?CFP2OYxWzclfS3/uAzi5ghYHx9dUe25g0FFyf7dX5cdowTisB84s6BFlEj5i?=
 =?us-ascii?Q?Hi6B3XM9XlxIxgnt80xXSlIGj6+0piNYkUGIAnfWqChOuhTlS6+tkUAAlGhf?=
 =?us-ascii?Q?W2p6EfIZtVM7366aBpnIoB6UmieN0V6CH0J9FVhZJ2g2yHYFUN8LauvIkD2z?=
 =?us-ascii?Q?Gceqalvid3wQfTPaGtreyokEUMFHB7UErVjYa/TaxIqXk2x9Te4+9bEixwVZ?=
 =?us-ascii?Q?kfNADUu+g9xJ8WuLYvpy3T0xaCQhupugqQmKs4wdLPTgFwfnd3Zz9SLg2DWd?=
 =?us-ascii?Q?3pPz3xVOQkZeQ9Bp9+ywXiFZZAA/fVTvJZUt2Kh87fkqJHXG8A0+YNAlA4pg?=
 =?us-ascii?Q?x0wgu5kVQzcekqVkUkfWb8WXt9dbUky8cYSRKANGbURs/Petsl6+Ubdi8nbZ?=
 =?us-ascii?Q?ylTK+/k2lsTkFB+nQY5NkwjhCmjXCaNdLE/AUgcrsO+9FTKRzpSa3oWTvhku?=
 =?us-ascii?Q?wv7cREdBvMRxM8qBH/C7hhewAqJv+xP23VIbEAzN9yfFC9JwzdAF/6hV3KC3?=
 =?us-ascii?Q?jKQvS7NJeC6j6dO1YETCm+ai4iU4vB6RsLXa0MiPiOoilFZvMG0AMowYQWx/?=
 =?us-ascii?Q?9f2dtP9nGQSb6LD/yWZzRaKSVHuJA3NBeojjTuKM+tEm4S5SsLbKAVc1vQv/?=
 =?us-ascii?Q?XFq6XnFGlP8q0+Vjt7xlIMasY90RX5O+6C5Bxo/rNLBvxyQfeWfh6BnwJcyO?=
 =?us-ascii?Q?skQe+eiRy1n0eIM24BtsGMhdItPIkpTKoWBFdFnsaeHAm6zbINUZiilr/75e?=
 =?us-ascii?Q?QQE605+ozOtncdGUxw2x+bkJOYI7cwt2YuWKrhnn1v4nENUs0DxWbzVCKcdf?=
 =?us-ascii?Q?LD1+6D8LjPssOITptRNuhz2BPFc3OpUZXFQLMpSC0cvAzrAIS2V4eWOUBV+Z?=
 =?us-ascii?Q?tl2EtKQnG4vB/wspqduqwgLvM5Q1lmoaGZsEY6C4Xn4oMetfdtVtnYkvLkdD?=
 =?us-ascii?Q?Y8FTMZkz9pHJh45NDybozFjYs1F13KbRhZanvsJAfwTYKhHpswxlDeBTndON?=
 =?us-ascii?Q?fE9n0n9UPNsXwL8pkOMxmpLwMDCKpBvUEy75vtMJrwbgwXJ8O8tNjjNwY2g9?=
 =?us-ascii?Q?RxhqbLcdiflk6eJ5EmzhKIAUWDL0nRbE1RX19TZAy9TPnKZXTq9c2it4eSWF?=
 =?us-ascii?Q?2PD078zOYFDOQ43WQf95n/k1qv8CM9+ivHr6TotHa3aJ90wNZQi6vZecjkb5?=
 =?us-ascii?Q?zU4nFgpehAW/1Ul0lDR7P3avGvZDi+xz/n+todAln5ATb/8Wf8L54pUsV+Xn?=
 =?us-ascii?Q?4l+CMQs9/4rrKImS9bGKOZpi7RUC8QFHcY0IAeg7Fe21/4OvMeJbi6s4dom6?=
 =?us-ascii?Q?OToJPuWeZ3vzhIjFzB4evDBsFe3EpsGj2MxypWgff4vRWqN9uPpWLFUcCdQM?=
 =?us-ascii?Q?MLY4kA16K8rWegMyaumiunft0nX3HquQG+0v6TD2CBR/6Tenh1992u6ljO4/?=
 =?us-ascii?Q?z+OXRpXcwfQaXH+mGe7Iz83T9awVUFY++LG8Tj5ghTuoobcB9bajlUarBU4r?=
 =?us-ascii?Q?CALnOhFr31GFzN9X0gIqkVLbs6RUQPPzvaGQfMjhzGCONmILqflvehrCF36x?=
 =?us-ascii?Q?7v1UZ0PBBoY7m/wPlmSuunj2xsW/HaTECVL3AGSuL4LQi13+pvU7mBwELHw9?=
 =?us-ascii?Q?UKwpcf1iAxpPZRQIU9ZMuFXR5lcP4/dHlaXDmU9OIzkChfmbNo77rWro9d4E?=
 =?us-ascii?Q?kXlefE9kj/jBYDQAXC9X5SwnmTvMQ0U=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5744f800-bf6d-4bfd-0794-08da2885b74a
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2022 19:39:59.8113
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sID1mqFI0i+L/Z3bpBdXHxDtOZIlK3o+DI2mVul8tv13Seoud9UjOEcGV+Vgs4wun4+nknp2rtaoKTH6qOYqsNU/MS21drXNTZ2lcRsmLqo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT1PR01MB4616
X-Proofpoint-GUID: e9AEJ3gt4NF0Oo4TuSm1PZF5d92AE6HA
X-Proofpoint-ORIG-GUID: e9AEJ3gt4NF0Oo4TuSm1PZF5d92AE6HA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-27_04,2022-04-27_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 suspectscore=0
 mlxlogscore=927 mlxscore=0 clxscore=1011 spamscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204270121
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With some SFP modules, such as Finisar FCLF8522P2BTL, the PHY hardware
strapping defaults to 1000BaseX mode, but the kernel prefers to set them
for SGMII mode. When this happens and the PHY is soft reset, the BMSR
status register is updated, but this happens after the kernel has already
read the PHY abilities during probing. This results in support not being
detected for, and the PHY not advertising support for, 10 and 100 Mbps
modes, preventing the link from working with a non-gigabit link partner.

When the PHY is being configured for SGMII mode, call genphy_read_abilities
again in order to re-read the capabilities, and update the advertising
field accordingly.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/phy/marvell.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 2702faf7b0f6..47e83c1e9051 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -961,7 +961,21 @@ static int m88e1111_config_init(struct phy_device *phydev)
 	if (err < 0)
 		return err;
 
-	return genphy_soft_reset(phydev);
+	err = genphy_soft_reset(phydev);
+	if (err < 0)
+		return err;
+
+	if (phydev->interface == PHY_INTERFACE_MODE_SGMII) {
+		/* If the HWCFG_MODE was changed from another mode (such as
+		 * 1000BaseX) to SGMII, the state of the support bits may have
+		 * also changed now that the PHY has been reset.
+		 * Update the PHY abilities accordingly.
+		 */
+		err = genphy_read_abilities(phydev);
+		linkmode_or(phydev->advertising, phydev->advertising,
+			    phydev->supported);
+	}
+	return err;
 }
 
 static int m88e1111_get_downshift(struct phy_device *phydev, u8 *data)
-- 
2.31.1


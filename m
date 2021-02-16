Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E2131D2DC
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 23:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbhBPW4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 17:56:09 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:35511 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231208AbhBPW4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 17:56:08 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11GMqjWp028214;
        Tue, 16 Feb 2021 17:55:14 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2055.outbound.protection.outlook.com [104.47.60.55])
        by mx0c-0054df01.pphosted.com with ESMTP id 36pcj9h0yg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Feb 2021 17:55:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jjzAtAil90kNGDornxkg3yiEDAaIf45BleSwDc8seYaMUV/yyFqNfb4oPV5rqzj2Q+7nT1CIAb9V6S9AIZrP+Gb4c5jbsCj43t4+oyk8hUVVj0adoojbqCiwfRo59v+FbTTr/N25xc+cNGjmFjyU3HrO+UaW3gMLLUtuN1yRNXGz79alm0MRZmGHneywXFlciU9zDEUcOOFjipyjZLzrwg4lcjy0qulqyBg02oikrzRlHNSXSvz4OdWHEOpIxx9zU6kLA+R3wbNU+8M8nC6OG3KhmdPg+exNIx2vjePtxhkacT/K0T2JVFMT82AJUoBd2klEbETRbWCFvnQDbP7vqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ynFk4vFoDyFGdZbysS1fU/TYDNbg1Y9Au8XaIU/7pNs=;
 b=TDtUsmsZ550Js7SfCgVFqdpN3s/HCEQakINtRw9YFxnBL5+0+Dm6a+stfCVqoVp3rjf24HSYdZrzQHluuQAgvzvRUrOHYOoMC9J1+ssr3GQ4MvcwNZh/kjaCtlgFKX4en0vHsrQa1e8GIKp3W8e2VDbHENWipMfX01gS6Q7Af+y7ikj6Hm60qi3gLc534LuPDvX1DSEEYLuw35VKmI9FncvwX+D0XzJ5t+4SbS9DhcJGgPDQgJ1gfGci36KvgKq84Vjy06s+XWXt4Yj5/pOZm8mNfDTau7Q5W2ulk6026NRxRo4BDN8CiAkrMIcebuYBUnv1lgEcGYp9Zth/4+UrfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ynFk4vFoDyFGdZbysS1fU/TYDNbg1Y9Au8XaIU/7pNs=;
 b=HEqAsfkrL24F8nMOduQSfjMKTcOcpXnN6FQEmJGjs/ee5IU7dMMGvJGFzUklWXBZNhSwdT3TLDsaCU48m3yeVL9aQ6gOls2ZS4tbZaR3xO5JyXoVH+YcnW/Jl5miCO48TE2dx2qeqMDDk4RSSwoLYROJKYSUzsf6N3PhMGBoc08=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=calian.com;
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YTBPR01MB3119.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:1d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.38; Tue, 16 Feb
 2021 22:55:12 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3172:da27:cec8:e96]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3172:da27:cec8:e96%7]) with mapi id 15.20.3846.038; Tue, 16 Feb 2021
 22:55:12 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     f.fainelli@gmail.com, linux@armlinux.org.uk,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v4 0/3] Broadcom PHY driver updates
Date:   Tue, 16 Feb 2021 16:54:51 -0600
Message-Id: <20210216225454.2944373-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.27.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: YT1PR01CA0034.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01::47)
 To YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (204.83.154.189) by YT1PR01CA0034.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.38 via Frontend Transport; Tue, 16 Feb 2021 22:55:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 93ad9b7a-5b42-4c57-1b5e-08d8d2cdeb03
X-MS-TrafficTypeDiagnostic: YTBPR01MB3119:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YTBPR01MB3119D4AAD61207C7B40393AAEC879@YTBPR01MB3119.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vjHSD8s4UnNw6GSNUUgXeJkIsTIR6TJ7BaV00VzEPS+VquOFC+jL3C1BrZANimnvy9XBrPI6u1z557z+ES5fr9WS/hamvn+x/UBLCxcWzHfjFqqcyKPvIjPfgbXLE/2kcBPymcVrNE3HUt1fMbY3DGCJ4snU/Xl/hMTZ+nektk/yFIc3Y48KQBSSjqQzmQytuUKUZJ/1P6nrWYu3N7P9rxvyv97HP5vVpDgUe8cIbGwOcFf/OogQsvex3W1igOVuSWHdkot5NXQdyQnE7/g+IC4yYgj9gz7WEvNfibCowCvm0RM/mWlQU0RnU15JEodnfIJA8D1Iorqp+Zn5x7l1BlbcxbAsT1m/3n6nisMetD8okZgra69e9FqwklcllAq7jaGqYOY+Yw83wWe7hBP2kTgIBp/Bw4h4pYBnlfhO5xvSK6nAn5YHjMT9x01u3/0jleOtlwZS7GK0WirtIewFNGtAyFA8De++QK191PA0SRhw1PJanC3qUsleyUkDd/o6QrOkH4YrVKUy+xVSbZJbJtQHnfp+JMKvwPajlBOfTF09Sms7IXzrdLM1PWhZ25gEJiWLLf63ES9yRcL1C3kQdw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(366004)(376002)(136003)(346002)(396003)(4326008)(8936002)(5660300002)(36756003)(66556008)(1076003)(66946007)(16526019)(2616005)(956004)(69590400012)(4744005)(66476007)(6486002)(478600001)(107886003)(26005)(6506007)(86362001)(44832011)(6512007)(15650500001)(2906002)(52116002)(316002)(83380400001)(6666004)(8676002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?IxYemf8c0GnRrKjEJzGJxPLuUlRVtseCJL11LZaXefG8gpv1iDxJD+yLKyEl?=
 =?us-ascii?Q?OnvoFXh1oGbjcpyS2R4MeRxCy0OvxMPvYnDjf92NJjBzhvvQQMoX1AARF8pS?=
 =?us-ascii?Q?mgh/147esZ4T+3COvLTCCOaMHW0IdEoc+stF5W4tPDkw6lEojRWlvZLc0YeV?=
 =?us-ascii?Q?+jfZGur8j/sawY9zrOEFCECmp4ANJfGWlxtq9a0UWnhBY+i4/T6+3zf2fOsm?=
 =?us-ascii?Q?0YxyU3pz6RpPA/IEUAuPp6LylE714z0Vc3llrnEUkup+dCtZWutHKGQZ3fRZ?=
 =?us-ascii?Q?/ZF+zScCOfVtDjjM5s2gqhW/bNOWxC2uUFqM+nOtXK9qexo3azUB2gD3DlSp?=
 =?us-ascii?Q?+N1w6WCnzry1wnekeQ7QihMZnfeh9eGhJ5ok79SwNINbsbXU4ArDaashvcPg?=
 =?us-ascii?Q?5MjSihIos6g41PNxHhbXXOGD6pg8ewHw5EEjRKpES3Ps4Fi+dD42/Y4O3Nv+?=
 =?us-ascii?Q?sV1K1flJRN41P/TYhLy1gHycF5xmotxrsf1nvOI2HizMnFs8zp78eCj2HsI+?=
 =?us-ascii?Q?mizIbi6eXF/y9sEq3l65eZZY8/U9f61k7xc85GbgHf9+elp/IOPBMX42JJ9q?=
 =?us-ascii?Q?1CvQHIbUsNRvQwhCHDsMucafkTs0lTlstkBvqsmDy4b/BH0rQ8HOSO9ZRf2I?=
 =?us-ascii?Q?ocYJPST/DjwjSeNpytslU0nBDr/FeyOneZ0LLF4XUa8aQyCHXIUBXbuqRb32?=
 =?us-ascii?Q?RKa4lwnTwCF0FPqDj1AyD3azM0gV+BdnPPxZWjczoyT19jzKyRa/UK26PO5E?=
 =?us-ascii?Q?avK83guG3tjp0bCV7H1orb8yf6NopMadBI8NRFVi4ifL5ikjZjFu8lI9OUM2?=
 =?us-ascii?Q?/DgxjpRdkNH5uCXKgK2I7ixw8EuNrV7RAqSbuJ06lIJLB0KaXxzBCu0OnXqS?=
 =?us-ascii?Q?Upxdg7Ml6jxQtFMQz0FM9NqGh9p2rOuFHusxUej1MdrLzkky1hWMqbI1V9NO?=
 =?us-ascii?Q?ORzfQ5aQMe+AVVOCXZBWn2qc/vkNVUy3Uv/6SeM4UxtnI3EnPqRsRupAO/IR?=
 =?us-ascii?Q?7R2vn0fv6HQJ1vxvc0fSP9tRVYC3qlXmCMfZPuCQ6zDkSiF9gKtwUmS5wQH6?=
 =?us-ascii?Q?zziHqA9IFkEXHUPLjaTz1D7sr9hwv9OYHw1US3e8pTLC1Emtd58SAdMsfwmb?=
 =?us-ascii?Q?8fDKur7Jv2lMl0MHKZwuWFZwq+/H32I5NHD3nL6iYRC1eJ1L9c7hKN81iu6H?=
 =?us-ascii?Q?3sCe+efN5xloTXymMsCPXZTb7+I7mUT8o54JkHNZqnM2xeKntxkgGbC+6SNe?=
 =?us-ascii?Q?yKE+e1TprtK5o2z7sUVu3/3LS3+S8hvMSrp9TOoTfwL+FT9BpXxr/vXhqpQv?=
 =?us-ascii?Q?R/R4KGQIiPdUr5z/DdvPj8dM?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93ad9b7a-5b42-4c57-1b5e-08d8d2cdeb03
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2021 22:55:12.7252
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A009CGzFDaAD/TU0lr95ri5aTy0EW9iqoPa0T1bzFkUyNjk2ooZsVv4JR4goPNIKebAOhLnBBT66A5JhuHQ2rdDq5XE6u5UUhM69phuUN1c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTBPR01MB3119
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-16_14:2021-02-16,2021-02-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 mlxlogscore=790 spamscore=0 suspectscore=0 bulkscore=0
 impostorscore=0 clxscore=1015 phishscore=0 mlxscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102160183
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Updates to the Broadcom PHY driver related to use with copper SFP modules.

Changed since v3:
-fixed kerneldoc error

Changed since v2:
-Create flag for PHY on SFP module and use that rather than accessing
 attached_dev directly in PHY driver

Changed since v1:
-Reversed conditional to reduce indentation
-Added missing setting of MII_BCM54XX_AUXCTL_MISC_WREN in
 MII_BCM54XX_AUXCTL_SHDWSEL_MISC register

Robert Hancock (3):
  net: phy: broadcom: Set proper 1000BaseX/SGMII interface mode for
    BCM54616S
  net: phy: Add is_on_sfp_module flag and phy_on_sfp helper
  net: phy: broadcom: Do not modify LED configuration for SFP module
    PHYs

 drivers/net/phy/broadcom.c   | 108 ++++++++++++++++++++++++++++-------
 drivers/net/phy/phy_device.c |   2 +
 include/linux/brcmphy.h      |   4 ++
 include/linux/phy.h          |  11 ++++
 4 files changed, 104 insertions(+), 21 deletions(-)

-- 
2.27.0


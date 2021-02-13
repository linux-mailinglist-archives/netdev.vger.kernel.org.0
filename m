Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C32131A9A1
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 03:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbhBMCT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 21:19:56 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:60141 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229650AbhBMCTy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 21:19:54 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11D2I1XC001480;
        Fri, 12 Feb 2021 21:19:04 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2050.outbound.protection.outlook.com [104.47.61.50])
        by mx0c-0054df01.pphosted.com with ESMTP id 36hrw92sw9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Feb 2021 21:19:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TmAJjDogwGBtdNVolfFJVv9Oq4oMJtUIbm6iv2F7osHxzD36t2Ctz9CQkN7FyOniNO729mDNqL5DkHeMrKk4k3e3oJGC/pJfXpFBCVG+/lxDc0QIi1up/zk0j4gbTxCRAP1JKdOl3amQPheUPyiJPEboKxkyniohI7YUbJgvcgJAH1ikEQiyKQn7GfOLDfJ6jCCN/1cSZk6X/MI2AegrzTLfmqo22J7rmPzyldAb6JeYWDVIiNvT1Kc0gmmwZHT6cPqpsDUVc87hAslJemh/vBIaS8dmkIaRp2WivcPNJuE4QW9xRKxvoO2GcX4gx5kwOBycYwyH6EDSwaVEbv3qaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NJ33gQf7V9QtlIplKsTjb+3BLZmE3jFjycMuyZtq5fo=;
 b=AN8AAGYEJ7u9OskZ4wQfYSgMFEYS1It7+a1PHHkAO7ibb5+mfa+S33FUCjusWwoR+kC4gfNwhn2+AzmU/bnPAN/Hn+zEvWUrzA1pGaxUZFMMsrgwgPQk18C6AXKifMzr6K9TkoeD6SmTwJyaHgVE1DB3LvqML6RfAaVe5xlNUs4c1ds1d4kuMmLgUPnm/0Frs9pfh3/UsE2A7ExHBG0y/mJ/0QA862RXLoIeokOPVrC/0aYA4Cpn8MYwZj81Fq1U+uyq7WvscTDgc/Zc37ufHAglDnlbQFqUbxOVed134xyqtSO+fzxx/ELoPUCACU+eqOv7cSDO/MH+ve8JLfFqzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NJ33gQf7V9QtlIplKsTjb+3BLZmE3jFjycMuyZtq5fo=;
 b=e6G7apjP8REyTjJFwEK2AMt7etF5QnhVFZnQCk5XvR3YEmgIopG9QI22jCh2i3vMujLOOgcRrPGwKrVmUOiYl8mxIUn20+C+2TyCsnFIOett6akBy0wiYDJqtxLmjY5119e4jIiT2MGRhLRY8nZASbp0anrTleR1svFGdjvcAqU=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=calian.com;
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YTBPR01MB2606.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:1f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Sat, 13 Feb
 2021 02:19:02 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3172:da27:cec8:e96]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3172:da27:cec8:e96%7]) with mapi id 15.20.3846.037; Sat, 13 Feb 2021
 02:19:02 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     f.fainelli@gmail.com, linux@armlinux.org.uk,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v2 0/2] Broadcom PHY driver updates
Date:   Fri, 12 Feb 2021 20:18:38 -0600
Message-Id: <20210213021840.2646187-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.27.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: YT1PR01CA0096.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2d::35) To YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:f::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (204.83.154.189) by YT1PR01CA0096.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:2d::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Sat, 13 Feb 2021 02:19:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc913396-4eb8-49cd-5e45-08d8cfc5bab5
X-MS-TrafficTypeDiagnostic: YTBPR01MB2606:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YTBPR01MB26060C9EAB2694E74C05A159EC8A9@YTBPR01MB2606.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5fT58+OQuHI2SWuRuboz4OVtDo/gQQ9/bSk1RsEcEOIp2P/TILjO8X+bEKBPqs5/fz0rakPccpVg4y+EqnO5d48PsTT5uu5ge8QJZvlPCV8GzE3mWVqrKfE7wcQ9hg6U9CGgDEeP8ut3RTMCHGauWa/YNyzA2NXTQQpRFJBCHo+UzFYMk8n9jpEqsYZTV7xhHKOgzRm4lERhFYQPO13Xx/8lB+2qG62IaCPFoRl5VKtLm5ct931Q7TEy6lOoz9EGfSBa1sL+NC5mVGOlmOx6HiqjuM8hSTtyaMgUt+Y2lkUsjUZVlkP6GebHlObDzLP9+bo4su18Y+DuYFamjsipwwFMP5cA3lEwzzH+WzcJM41quaaDpOLFv3m7JB7l77bq/3Mjpcy9Uf7c/dyAGFDZQuCe5c4dJFbC7qXB6s7aJiS9qLM1ddW6aCaQq7W9X/NqOaSWliREN/CCOJ9N/g0oQifgini1aJNJ02KdkhYYwjBNjt0nS0c5RWpU1wB7yXfSpKVvO0Q6/ShU5FRK+P6fhLuXL1uVgFMDrIyr99D0BMHmvBTVnZYZe0Me6U44woeBnm8RgTI5noWKRaN2vBv8pw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(39850400004)(346002)(366004)(376002)(6512007)(107886003)(6486002)(4326008)(36756003)(5660300002)(15650500001)(52116002)(956004)(2906002)(478600001)(69590400012)(2616005)(44832011)(16526019)(186003)(26005)(1076003)(8676002)(316002)(6506007)(4744005)(8936002)(86362001)(66476007)(66556008)(66946007)(6666004)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?lA8WmijAxRtwgqek33hfyZcmAGwzg83VWyREpK+5LCGy6LbLd14/QQlwjk8g?=
 =?us-ascii?Q?StlpwVRcD4OmSlVd4slLlXveD0XWot8gtqFtZl2X8FukMsc07l9HA6SwEOrV?=
 =?us-ascii?Q?CSIWagzMLqAMNqD1VG+KQRL4BsH9LSwdgnyUrwB0bTxXZli9BOfQLUAKOaJF?=
 =?us-ascii?Q?IIH8lwCMXNiOlaOTAftWJQq1w44TW/N/dca8C65kp4vCWjgOn0e8wEtR22qB?=
 =?us-ascii?Q?7PVwLoXFYZCZXPvQ2kDA+L7ZsCkacYOH29aqVLlvrcurge8kqVmGweM4Zum8?=
 =?us-ascii?Q?+pKwy4hCJ8xEA6t1HS1q2JS6FpR9MT+0XK9pUgaQIi92pyCOrP/ZSoWiZ6AG?=
 =?us-ascii?Q?3jJanHNjc5fbDIU1IKgUlnZVmUfSoerJlL17WPT/91uFvK9NtUBMJJojWAga?=
 =?us-ascii?Q?avuj4hrh/adAOFDEDCXaSQBcWGpQ5NwMXstE3KjGCbCVEC4vxhFKHdRevygK?=
 =?us-ascii?Q?YJjMHMzRChkwXaBLLdq8oMDdX7zHpHOUh8oODPAAAeCCei1iMTpaqh+yFVXi?=
 =?us-ascii?Q?acQv8B1VPsIL634m9ogejlV4xdA1X4cB9MTxFLZs8v/ZWOFZxuIhQCMrIGgu?=
 =?us-ascii?Q?ElaRM2Tpg+eIjE/br/d4uF/rzWam72+eUOktVchaY5OwwnMRl5Gek4a8KfPy?=
 =?us-ascii?Q?R/uIhwHq0APfGg5iWTYmuaRrzLMeevze+OqPyysVBEbyxE0IWdl3WFnYmt21?=
 =?us-ascii?Q?6tXnm0NoxO5xmPHC31FfOEzGdG/hi25J8TROGON4+tF82LzQnon/sqHa1MuK?=
 =?us-ascii?Q?H1i7LqGVgSFAGYOaRHyGEhS0Z+wq1QiUezyRE4YDvJUDsOC68QxV3lx+Svwr?=
 =?us-ascii?Q?ZRwgk59kjZr82RcPAsvTlJUmxioYGN/l90WvJEnqDQ/1QeSqdsSCmS6ZIcD/?=
 =?us-ascii?Q?gxgzZBjGDIH2soXH7EwPNPmX241tJyiufYZxycmaQUiDCnIZKZyBSBOlHUfw?=
 =?us-ascii?Q?kEE+o+b2O8YKBQoMfCTW1watRhVqFAAkiYPkRggpeBIic3PqBQG/84vy0s+8?=
 =?us-ascii?Q?fs+Xuh9AivB7KX4hdvN/tIprxNIHZrVS21Oq7S1oVveRzmh5EIwfN4JGOU0R?=
 =?us-ascii?Q?PUUIu8wEGqu6/A9SpkPigTzuXJBX60yde2X9W1fkzhBd3XwncQAhgO3pENvv?=
 =?us-ascii?Q?ZFluuDxB4pyKpsVmdhAYQD00RY9nmRRk5hFJDMhehllVHH8vtBg1cE3qFRET?=
 =?us-ascii?Q?VQmTp/07y/RbzGYZe39lRFbp0yTe5XgjKxukwgaLa1RENnhJdqFWxG6C0Xg7?=
 =?us-ascii?Q?MdxlHADA49nl/hqS5/DWIboLIHTjMOWXSGFghlTHITNXm9iMJ6X+vpNiX8dV?=
 =?us-ascii?Q?wtCiiIsW7GGL8iHwd3oOL04c?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc913396-4eb8-49cd-5e45-08d8cfc5bab5
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2021 02:19:02.3438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pis2VLThy/RikWTSl4GgAsSXhGvq3sMCEeNUejN4IlejA/vHS3eUf87KY+Dq77ehm67F+JuNbXGcdqajyMMzPFvANos0ffWbrYz42GQ95p8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTBPR01MB2606
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-12_10:2021-02-12,2021-02-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 phishscore=0 lowpriorityscore=0 spamscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=776 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2102130019
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Updates to the Broadcom PHY driver related to use with copper SFP modules.

Changed since v1:
-Reversed conditional to reduce indentation
-Added missing setting of MII_BCM54XX_AUXCTL_MISC_WREN in
 MII_BCM54XX_AUXCTL_SHDWSEL_MISC register

Robert Hancock (2):
  net: phy: broadcom: Set proper 1000BaseX/SGMII interface mode for
    BCM54616S
  net: phy: broadcom: Do not modify LED configuration for SFP module
    PHYs

 drivers/net/phy/broadcom.c | 110 ++++++++++++++++++++++++++++++-------
 include/linux/brcmphy.h    |   4 ++
 2 files changed, 93 insertions(+), 21 deletions(-)

-- 
2.27.0


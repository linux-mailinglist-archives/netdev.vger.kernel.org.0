Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02B57452ABB
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 07:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbhKPG3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 01:29:21 -0500
Received: from mail-dm6nam10on2120.outbound.protection.outlook.com ([40.107.93.120]:37728
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230330AbhKPG06 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 01:26:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YX9niCzC1JQ8pAqbs1X+rZm7onPcTUojQJyRNG0hoqF95rzv1E6QgCpY12f+LUVhkF3ZeKEh+C8czE5aPOhz16TBHYHHn3MqqGb0igM0dqBdW95b+hXy1pTqnHVGkogU3Ncg0RQOTHJbRhCKglmKy2Z/dPOqhnUir0HJTEyImtxKpCNe4d4OJQH2w2vWSQU/SKeWqHGBKQuzKqu46UGJagwOPwFX71fX0OZv4a2srgg66WQXqwh1qhN2eL4g5PZmubxOjexeeCkWND/agPZ+wMd1BmM00k0BPmaj6xTYUEa2M1VGO/AqouqXoh4MnxHIJSYL1DhMokd5Z35CAzha4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x6up6gsz+c72GQk2W1hkBjqvedIEfYO5cUKW7oUzrF0=;
 b=UB0IyQocQ+wRAwq1zwJ9qZdBU6XQx/xYbMF/xWK3mZsBBi0umTor0v94tQog+XAKug810sgn7JdllDU+7GD6MLBynFH+YmFicrcaeE5tH1Ic1S0YdVnlE7ebYmh4teUWnwr2PnMPWKMf9NJh1pDmRcHN5v3y1lhhLxX+oOfTPP7egCScOBlQcXAN0ynr7f5YM4nYEvEAJyiCvvxYMCT7rUlVrgSAFx9FSvOG6Lw0FcdKLTVrHWyNOvVy28LGfXpU2H7kO39YnwXokOONCaL7HCV+8iGNUlIZ2QqE665io6D5gihyXYbYAFFPVYR1f3qs4gXnv2py4dwSjmi8KOdozA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x6up6gsz+c72GQk2W1hkBjqvedIEfYO5cUKW7oUzrF0=;
 b=zKmLcrhd3G58MJTfJmVQBdo9TZb4X9qFDRsE9McIuhutCejNd7gXbRKvHDNgo9So+lMbY6sau19V+IfUQY+B0c8w3d9P/rnS7zwBQwIMzQw7zZr5FtXOXr8rZHduareaPvHp4A8wqCMmYScTE6D1t43e0+YRerCTFueLSGmYI18=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO1PR10MB4722.namprd10.prod.outlook.com
 (2603:10b6:303:9e::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Tue, 16 Nov
 2021 06:23:50 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4690.026; Tue, 16 Nov 2021
 06:23:50 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [RFC PATCH v4 net-next 10/23] pinctrl: ocelot: combine get resource and ioremap into single call
Date:   Mon, 15 Nov 2021 22:23:15 -0800
Message-Id: <20211116062328.1949151-11-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211116062328.1949151-1-colin.foster@in-advantage.com>
References: <20211116062328.1949151-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR11CA0028.namprd11.prod.outlook.com
 (2603:10b6:300:115::14) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MWHPR11CA0028.namprd11.prod.outlook.com (2603:10b6:300:115::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Tue, 16 Nov 2021 06:23:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1b5be51a-1999-4e19-5564-08d9a8c9a752
X-MS-TrafficTypeDiagnostic: CO1PR10MB4722:
X-Microsoft-Antispam-PRVS: <CO1PR10MB4722972ABB9A76826456CC86A4999@CO1PR10MB4722.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:935;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: saDpDmpTVahbLKNHh9uJUcL9u8t0rpKSEkVZQ1T/gAcbb6ih58xnslt/tE6AD01R3Nj318+UTBNWiV1lx6w9lPQZect57M+H6jyJv879Hk8rwIlu7+une7ZraQp6RiaqUWz3yfVVqpsPPGV2rqNo2mes1vM9hLHce07FacTCJ2p8cHAeBE10X95/1vxfkgs5GqhVyr8hqFSgTwZ/nDqG4S4lDEObBJWbcaxhbzJt/y4HcmCtbqH8+d+sPZ9osoJbNouYhwaVk6Fklvg0TB7x8BOlMyTlK8iiio44D0MqwyYlyx+cvFDTnoliNzE2zVcV/85/050J37M5vL52g8jiDxIqe/lFyq/vDHRZFAZx+qPab51TSYej3nAGD4jVl3rmptny7pohd9ChH1a3v2ul6nQfFbcHoxagR/erqdwG7hWK9iOmmLZFevsZ1QYBoiHjyb2tPw4WicFYls+AdBgKBdQhcGTzbKAdV7q5A0qfH6UGObhle/Ds6AFDlni+T5MLhWhgzXBZhuxpsCj7dQ9mbN3nFU3prKN1XC74wbVr9Yz2JeuWfeb8Gx5bgDT1ABShHQfLP0QhQWlAcgvQmJzo/e1Mm5OxnCaRI8yxTCrURLU3ZT/3i/x7DmyYdvR1wmkiGoFD7QD0WB1k0lLf2gJX42Pd1WjPyISMTbOZKfUCKcDhGnnR1d0xxVNpPrkErKtv9byv7pCQ91udotaFq65fAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(366004)(396003)(39830400003)(346002)(83380400001)(6666004)(54906003)(5660300002)(2906002)(7416002)(6486002)(44832011)(956004)(86362001)(2616005)(4326008)(316002)(508600001)(8676002)(186003)(6512007)(38100700002)(38350700002)(1076003)(8936002)(52116002)(4744005)(26005)(6506007)(36756003)(66556008)(66476007)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tXFEqgle1CoNMSYB4f825jQGWE4gQeTdOw24SivTFNvyWz6N7HEIaE3dAZBM?=
 =?us-ascii?Q?IbZnVMINFH7jX+q8Eqy9K2Xt7swXcO7r3qIBQ5W4c+Q2IQLROtZ9XTsdrIwh?=
 =?us-ascii?Q?Hag6FD3Vv+eVh4u3Nsz+xcfKOKbx5rZsFSeNwdBApic1tst9cYxluw6RakAB?=
 =?us-ascii?Q?K5ScQ1kHH0cifeGNkmKtQTUvdd3XS+tQIh3CR3Q1lip2CO68n5yu/znCrRvT?=
 =?us-ascii?Q?kpQ+rJ2YudFzIuFCeKPZpd9XmhzNcmAzZRdf5VpQyqJG5jN+ldjabATfw9ZY?=
 =?us-ascii?Q?grHB3Bs09q3aU/BzARcgu1xhq+yve/Jxbxi2EVd1SM7KEi8Gr2qht9luCQ2n?=
 =?us-ascii?Q?1Y/esowf8pRdtNrKEXwMIp08riT+O6P2hKdNDriEk81/VEoIKVSErDPZz04H?=
 =?us-ascii?Q?UEK//UlX6ro7D6klRhieTXUrLOlIZzL/RnPeysZnAHEQUlXSaXHuzDkUi+8/?=
 =?us-ascii?Q?F39WXHlzsRer/YQjiKsvpd9R8nf9jCiXrMPQWFLFEhuQ3pfsPuFYGXtTUsyQ?=
 =?us-ascii?Q?E9bHX1JxEweyhG8lC7w8H9nGI3/qdwCm5I4bZxjJnJpXkDx/ZdrAarewFrkE?=
 =?us-ascii?Q?k2Aaey8c9Cmff1hp2sczuXH3Ox8+yx5otcw6H887K52TwCR3Mc2gs7IUe4JG?=
 =?us-ascii?Q?kitiTSEbeVQ6dlY09A0h9NbEac2LjYPsYdFXo5oUQzXbhkp8nSGxHvh94mnC?=
 =?us-ascii?Q?6l6Nz7eaIC0JacZnR2BdR5WH16MhDwpgVO8quSoI0YV/ZNiGK0+LFq8QQIQl?=
 =?us-ascii?Q?W63XN7exm1LGHcU0ZZE8QOc9teswlK2gG6g4HP9sO9fJPQ/RU6V98BKgDfP9?=
 =?us-ascii?Q?bWQSYsi/70NcDnMamWoz0mMVrtyv5B0BLppKhVO66Dt8M1PoaUskqjOXQzZx?=
 =?us-ascii?Q?bm+drK0Hl7836ZhjAcucXO60tygLjLaIpPl58N/h5GPUJQ4Fdi+/e3kFCo9c?=
 =?us-ascii?Q?6xUQJqQ5hIr2TUTSaOSmzEiNbiojCIag7fKUqcGDboYJnHtmyGCKbH9PJFTh?=
 =?us-ascii?Q?TI9W8HWjTtIyhiSz9KIQXuq8SKN/MhsctQaubN8OoGz1HIJC+5Rk6raxjWi1?=
 =?us-ascii?Q?ikScSZVfeQo0TD5EBgp2XzKLpGLXt0CqMaPlaHKcjD4kqeg0NKtdkuq8y8PW?=
 =?us-ascii?Q?8vnyboTOq0Ns+3bIUdBlEhkGXUfShEVpBOnf2ojH3rjIWPc5xv313tMvnXA5?=
 =?us-ascii?Q?NX05xMT26DobZow4BBhrR6gRcBkEA0+U+5z+ze4VMBHZ3AJbFlbqspkJCYw2?=
 =?us-ascii?Q?x+FDGVJMPSsXLq34zS/Lxn9C3UYK4zSGj+XZXhirq1toIiQZ5H7+pRg0CAPp?=
 =?us-ascii?Q?b3fa5XUKpB/MAAgDbw60O6Djc4UIyPhYEnf5/a/asTDmj5JLAD+HMIoE3fdZ?=
 =?us-ascii?Q?dYNS6QxN5EiYzvtounTxvjL0JDiZrv6MhJYZxnRbOL1zT+I/hIwXJPBu3OfQ?=
 =?us-ascii?Q?YmzssWTtMIow+PTF3zu5Oszm55Rbh63ZmFAiO+5KBpioqj+5UHhsor6YphXD?=
 =?us-ascii?Q?ktEKBR7Le+61fJo2UuufsiMeXpHpUResCKALN3wKFz5QcB4iyneGbjHzfjb7?=
 =?us-ascii?Q?CtGtZ3UrXGtEYgN6cQ8TmLzjA7Bqz6v8JDsBrRvaBbOcrOLbH8WhFtpdokLI?=
 =?us-ascii?Q?mCganmk8YRL7lGHdtbchCt6bMxj2EIJy3QfvqoNdf79Kl1FK7Rx7Gn/Fc0ZA?=
 =?us-ascii?Q?CNCA/wAGvU8Oq40bn4La8x0wIWQ=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b5be51a-1999-4e19-5564-08d9a8c9a752
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 06:23:50.0338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wLz2iV+2Aj5oDOebUjtsNb6nVD8Ks+ygbDkuq0RzWHsis2HIyME9rzWgFAI4nHI1b41h+U//WWfKG/R9hu4pcu6FWqQoGn/oLRfVHEscb10=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4722
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simple cleanup to make two function calls only one.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/pinctrl/pinctrl-ocelot.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
index 0a36ec8775a3..cc7fb0556169 100644
--- a/drivers/pinctrl/pinctrl-ocelot.c
+++ b/drivers/pinctrl/pinctrl-ocelot.c
@@ -1378,8 +1378,7 @@ static int ocelot_pinctrl_probe(struct platform_device *pdev)
 
 	/* Pinconf registers */
 	if (info->desc->confops) {
-		res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-		base = devm_ioremap_resource(dev, res);
+		base = devm_platform_ioremap_resource(pdev, 0);
 		if (IS_ERR(base))
 			dev_dbg(dev, "Failed to ioremap config registers (no extended pinconf)\n");
 		else
-- 
2.25.1


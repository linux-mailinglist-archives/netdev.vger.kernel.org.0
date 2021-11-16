Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68F54452ACF
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 07:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232237AbhKPGaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 01:30:02 -0500
Received: from mail-bn8nam12on2129.outbound.protection.outlook.com ([40.107.237.129]:48640
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231274AbhKPG17 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 01:27:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MLoPhFABwMDVezcn+dd286h53Ktidyl71uPVGu+QolOiAnt9gh1CQ4QOUxvWcOaq2QLYPvjGM8MAeshGOHPg34GXEKhf+gBMFQX7TgNeQ/QKRb8KDfjfZWWs2JeJsV7eVL928TBPv42lZIhu4yKOTt/Ha//aSafo+G0vXLszyJ3kAbWMX5OpzjmCCT+HqYEF52CjvfYWTTusNEG7KHF6TcvTmRktIUjxIURRgtBCUe7GVN1LvG4yZWKXXqPcCe6lxWnlhyAxSZAEINx3jziQtNAi0bCWLPV6KcFAfwOGo1wlhsrXmGoApE7tk4xqut+TjAgZr+oFJ6sPyKv/2JCkug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1l73FUOfTXGsUNS5WNZu7qMSfIq/CYlA9/HtYXWFjUE=;
 b=nND+KV6i7r3IuC3QP6CE1wVBgFLAFsvA51ENmEaSZ+ytkTL+Lp/SKxCgXsIgPJQBT4Plxaq50skNVn2SgRBYXiIYRzFldzFJOqLzv1qz1NZvQqoq8L0H4f6jgZEvlea7cHervK1B0ct6b+fK2CTnUseZfrvsA1ZsgpX6GztkkkNOgRThgxgfIB/pBWd5iixC3Nb6mFAgT5kJPuZrz159qQ4/0ZAOm2jSTCrZtWZxEMd/526m7Chw8rgX3WRBqYlfs8QtIZ6Y4jGL7+GKjZ+EPgMYDJNKAK388RkUm0RR4iZTdoSyW+hY8sXNlH+S4Zt5dWc9tWYU1HZJ1nj9mYMy3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1l73FUOfTXGsUNS5WNZu7qMSfIq/CYlA9/HtYXWFjUE=;
 b=e35FYV6Yvy9MDTlo/C5DiEjJ0Klib3YAEUekP1iREWoacq6iUuzq6LsDxNAcXyMCg1R2KUpyjLAfEVlweMShBuinvAb3EdiqMI7cG/7msixQH3IoQTRFZSD+uF+KY621N2lL6uXzwIFL6vBqAin28FvdZINGSDWxaB60xcmmz34=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR1001MB2383.namprd10.prod.outlook.com
 (2603:10b6:301:31::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16; Tue, 16 Nov
 2021 06:23:46 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4690.026; Tue, 16 Nov 2021
 06:23:46 +0000
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
Subject: [RFC PATCH v4 net-next 05/23] net: dsa: ocelot: felix: Remove requirement for PCS in felix devices
Date:   Mon, 15 Nov 2021 22:23:10 -0800
Message-Id: <20211116062328.1949151-6-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211116062328.1949151-1-colin.foster@in-advantage.com>
References: <20211116062328.1949151-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR11CA0028.namprd11.prod.outlook.com
 (2603:10b6:300:115::14) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MWHPR11CA0028.namprd11.prod.outlook.com (2603:10b6:300:115::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Tue, 16 Nov 2021 06:23:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8b16ef4-2d3e-40c8-aef9-08d9a8c9a4fc
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2383:
X-Microsoft-Antispam-PRVS: <MWHPR1001MB238355E60A294E9C775575F3A4999@MWHPR1001MB2383.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o+TXQZuuVQsISk1/K8kYdq3If2tq3Ygx5wue3nIFJHsXDJOPfPUTMlzO6ZqRUQKKrsSCQU/5UNTugJcdOTOB/c6VkioWG1VQvfUvbLIm9TbIjgdpcWQNoue6JBEe4WYPF0KgkiRvp6Vt2lzD8XL7IDMPcLLMMM9eqAaDRoSyJRAsGUFmx9CU1gu9qFxgew+dWDyqg/pRapsIEvN2BB+yt7pEoS9+THMPZV4oMvfSL/vo3jDXdiCvISSU9nHbz+/IpgFGve9z2OOjnX1+duAjEE11spETcBCX5xzzn8UuABhrmbR9Dwp1JSNxdGadd3JLLe2nIcksGHANf4Jn9nqcZF7Thiff6ch/z7ggj4Q39geTPYGeEOLn235J4Ikm5m6lZj0rP2fd6NxR4s25q0QDQz4QYQQsRzRMN9w7QsSGDuIvZSzQm0Yt0ljDrwdLewg5ZNjea+NwUMJbt018rlCYwOSZ6NqKHY+VVylB/Vi+4rZr8r57a8ohDD68Kk/ewXQD7MIGyp+eary5g10JCBZZQR93BxOafQZ1psjHpwIBhZXAlUh+Y7eprqQY5RcAnia7nWOn9ouQV2O+8n4WT67qg0L7qsIdUDSZlNkRt3OYU8OYJtFrnPaeDCOrc46KN3op9EuinXmjFdryY1oD4VEE6KyVdBh63CZ9cJgwCIzV2visyrul4j+zczbfqssfKu6kvgPUrHuuAwa0UXAhXGv9sw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39840400004)(136003)(366004)(346002)(396003)(6512007)(54906003)(316002)(4326008)(83380400001)(8676002)(86362001)(44832011)(1076003)(2906002)(66946007)(38100700002)(38350700002)(508600001)(956004)(26005)(66476007)(66556008)(6666004)(4744005)(6486002)(6506007)(52116002)(5660300002)(36756003)(7416002)(8936002)(186003)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q4HE21y+flLrmutA2vHKeSWMBqCAHu/BQVxWMBpWq+FfwDKQmfJW3VdwTVYn?=
 =?us-ascii?Q?QuA8HsNSlO42s/gNDdP+3AK52/qIOnuoUAcx80NzYrfXdiX3ZnewN1jiX31P?=
 =?us-ascii?Q?zQHqSBx14ZTaV56CbvjJS168V++g9Jva45jmoPRyoPJJbNkoBXYsyGZg9ubw?=
 =?us-ascii?Q?VUQo8E4JblJkzwoOKAHzH4hSupWufieQe1FqIX+Ltj3n+o5DyL5nh68Ul6yR?=
 =?us-ascii?Q?UegX5hUHFRsON4SZ9OXbvCITytQ3KPnMPrk2VyN0KSGcjbZjsoh4gYLNF6vR?=
 =?us-ascii?Q?mt9UogsrtKbtPWPSQOnBexmt1m25p8vKLgx3ZwG9SHDjDiwLKX7xCYU3B5zo?=
 =?us-ascii?Q?wKdQxmRmLefu5XmHQlAj+Xje+kzcgtfBeHpZwSeIcT7IJxnpyHD7lcxoL4DU?=
 =?us-ascii?Q?L2c27yHppAaeXfE23DFobfKjtzHHT/KUESbPsM5O6gpNQdiE2m1XyP3xH6Bm?=
 =?us-ascii?Q?s1BLQuiow8TXLYTFmplZkNVFV5RsRNmtXHkXUasAYWew9v6PqNl3n4jGQ4gj?=
 =?us-ascii?Q?vqLbcaAir7d8Al31VCnufG86tVfBjRwyBuXJdE1C8Jbxd2yoGFVmcWtIHk38?=
 =?us-ascii?Q?bhIHEeyW/tXOfAfcrQXBeDAH2ZMmSt0P8qro5iQUloVpArv/gsn6aUVo+IZk?=
 =?us-ascii?Q?/rQll9RMisuhNpHh0R1craW2GU9CSQiucL3axfbUibVGsDT6paTJSgdOIuGM?=
 =?us-ascii?Q?9/x4r7ZZug4Zug2YguUI2RVA3N9mdpmGbAlRGjAeFI8rJsNFdhyQ9dDdQ4tm?=
 =?us-ascii?Q?JgGdHSCLI8zAskl4VjYob5N/IGexDT/gsj3v2PPHwCYQCLMn0lW3ilAmLKIF?=
 =?us-ascii?Q?bGbhEnoSl/d291UvdvKYC2iMFwEVBA5LWPnr7nxonRxjfKBAfh8/ylFgRy/4?=
 =?us-ascii?Q?FTmBbBlUFVOduHlJTUyBr47ifdM0m0muv1LlHeHnnkltmRC/5zD5F8MLOF0H?=
 =?us-ascii?Q?IFGW51p3GBYIiCuvG1NZPE0e8o77MC5rCVgBHdD/9Nipc/n2ZFfoIWZlVmJ6?=
 =?us-ascii?Q?tXX/hFqHqNL4CVpSJNcx0MU05gGb4Z9VT4kvLA9vihFHhqARctBlwqoeV4nd?=
 =?us-ascii?Q?ank+fCZVl71b1mXlYbotFCH5A18pYNBPbJZ/Q0XJIv6L+da6LJ3JKl4SV3ij?=
 =?us-ascii?Q?EsRZ2aj+OTuFYr5ZrOEAV7aEYaEnSiBIpPa5l6Ue/9MQQ69vBNvv93mUClk2?=
 =?us-ascii?Q?QM+NEx0/EQHlMj9kJ/n+xUlJ83iLJ7ajjdUVLfxk6bsF9Xh11C1bOuk2kzGK?=
 =?us-ascii?Q?oD7z4bPKVQX/I23rqaJZBLsBdUeNW2w6lXE+ml9mkUovNp1pBGMmzC0JnYpI?=
 =?us-ascii?Q?AOaUduFFXM1L7CuG75eYl1Ym1p4tih1FQrrBrUHB7mV9bCXZCsuWUFcYKkVB?=
 =?us-ascii?Q?oAHbGjqhgE9yIsgKz/loRuQuFVFZK6MBCLS+eeNqxyUTJ3EZLIoaNFWEppOC?=
 =?us-ascii?Q?5qGeXTJYJ6taqW/vzTjGiBtRtZvzso8BZuFsfwglDa6MgpwF5btNkKNscH4v?=
 =?us-ascii?Q?Tb3GH85hiXl4ONJnIarSj6ej9iYDXjn74uB1pgKu+/PH3ZE7PTFVBE4caTp8?=
 =?us-ascii?Q?LGjBS0u7g+pTAbTNFlrG/d0cJpSXoMvFnJ2wFRsyc9RFS0J70QG2yK7U0BFH?=
 =?us-ascii?Q?HBpHJTOTEqqtOInIsl4jSs/2XsDMMxxScZ2NjUUR67if8qKQauZklq5qrXiY?=
 =?us-ascii?Q?zOLZUkOpBm0TavwTh5tKymywgIo=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8b16ef4-2d3e-40c8-aef9-08d9a8c9a4fc
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 06:23:46.1300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jIMUoFIvcDTew9fHwKdmaYZiof0uAolbpj3EyaBmnhDSWFvmMsuIqDep2SBoddOI7NkB9lMtOvzQ40FifKB1ecv96Gbgz+hCP+xght3NLUQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2383
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Existing felix devices all have an initialized pcs array. Future devices
might not, so running a NULL check on the array before dereferencing it
will allow those future drivers to not crash at this point

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/dsa/ocelot/felix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 327cc4654806..94702042246c 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -820,7 +820,7 @@ static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
 	struct felix *felix = ocelot_to_felix(ocelot);
 	struct dsa_port *dp = dsa_to_port(ds, port);
 
-	if (felix->pcs[port])
+	if (felix->pcs && felix->pcs[port])
 		phylink_set_pcs(dp->pl, &felix->pcs[port]->pcs);
 }
 
-- 
2.25.1


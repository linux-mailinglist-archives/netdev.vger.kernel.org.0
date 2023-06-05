Return-Path: <netdev+bounces-8108-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 507A4722B83
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 17:42:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ABB151C20B9D
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 15:42:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D850721089;
	Mon,  5 Jun 2023 15:40:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52AE1F93A
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 15:40:49 +0000 (UTC)
Received: from mx0d-0054df01.pphosted.com (mx0d-0054df01.pphosted.com [67.231.150.19])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 066D7E40;
	Mon,  5 Jun 2023 08:40:33 -0700 (PDT)
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
	by mx0c-0054df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3559p71O019626;
	Mon, 5 Jun 2023 11:40:05 -0400
Received: from can01-yt3-obe.outbound.protection.outlook.com (mail-yt3can01lp2172.outbound.protection.outlook.com [104.47.75.172])
	by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3r02e3gqhv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Jun 2023 11:40:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PQ7TnvACKgrKvMdutffge5cEKR2JthcLtLHtzHDt63yYDSvWjBTIAtOVA8riVHQhcJhxajedwtGko7uYgl8P5Uz5kal4QEZkByN53s4XR6/tX+GK+NpY03rpQYTnp/bwm+QXvHYeREGrwFAJRZxsZNQWimAUObYQIo3KtnlT1LjIiIul6nunjEal1LmNxGZd5vIo1bvqgOSz4MSDTwO76LsbI9kejsq0rwUDn395tOZ/2kz9WSmR/8jpdpsqYpFtwZxrVcZmN3Ws3VUi3UUKQU8l5D/ug8kEHxSkbUfPUfEgNGzpt1GcrMOM6hqgKl1njc3X8TRPtieCYsmLjQKJQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ElBkSjCN2dBPlBZj1RzGMov8o3nsJgmBF5DvkvhsJHM=;
 b=fiXob6SSaiB+LhWwR9MHU89Q5FPFV6i6eCj6bVj8Xh90h7CSftILc4jLNVU2qWoHqV+dyx5xyBFJJnA7leJj3mKsbFFsXjYKmpLyVFuXurBTcEXFVNMwHHP5CCy6IRnauruspGKiE/+QMRxro8Dfn0tFwDa6fN+wVxub2Gv64GJuz9mdqm/P5syD/YfDkJiUicVP7j55yXQTgjffImUU7BtvhZOtzYllc1TYsD/TQ2sV/lklqSvI0J3w4XHg0M+/qWZ48hbHXQ4Yb8fPLQzST23iDEVDKnxCM6DL+3WUXpk7mD3n7sDfS5kM5X2QbK2T2LqntpUSvPN7z1lConSNRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ElBkSjCN2dBPlBZj1RzGMov8o3nsJgmBF5DvkvhsJHM=;
 b=CHoceHxwLibZy7g3k6I6I7jU89dECFTq7xO/OOUOJGtp9qJzK39pQ6UnVndBhfNlOLKFVagMDB//fPYqpDK7sXrX2NUPuVcmh/NahDr4iDFhQgSle74Ho8BSXBmzemSgNCUwixZXGdqtHDtYzjXKGG2FnMPUJXA9FiDwb2mAgHc=
Received: from YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:b9::6)
 by YT3PR01MB10571.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Mon, 5 Jun
 2023 15:40:03 +0000
Received: from YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::c059:dcd5:ca20:4a0]) by YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::c059:dcd5:ca20:4a0%6]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 15:40:03 +0000
From: Robert Hancock <robert.hancock@calian.com>
To: Woojung Huh <woojung.huh@microchip.com>, UNGLinuxDriver@microchip.com,
        Andrew Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v2 1/2] net: phy: micrel: Move KSZ9477 errata fixes to PHY driver
Date: Mon,  5 Jun 2023 09:39:42 -0600
Message-Id: <20230605153943.1060444-2-robert.hancock@calian.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230605153943.1060444-1-robert.hancock@calian.com>
References: <20230605153943.1060444-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CYXPR02CA0063.namprd02.prod.outlook.com
 (2603:10b6:930:cd::8) To YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:b9::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB8838:EE_|YT3PR01MB10571:EE_
X-MS-Office365-Filtering-Correlation-Id: a9b9c4b0-ba42-45ec-4046-08db65db212b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	N4JfactCoqgU65PBIzDas4zsxELFxbwRnk/wbxlvt4hRnCZSBQvrT77njp3LpCxCeD7ui8/W5GuLWBAIDCHtSJOMEFXBDKuZD2AJ6/8ch0uRlzyv5pO3pO0yvhLrkX55LCFY1MU8MeQhMeXs+bbvyu+N92fNz9lC5QiTvLSlvu5MYxVvJcQyI9RStZemOdN7fSyOfMkpLf/qjwjIIHM99mclJEM0Q1corkdd9nX0+Gr5XLRC1Pz4FMkQmvtTqt+iCSo2eqqogwrwsl+Vk7lCcuh8U2T7qM1RdVxGXpUJ9jcNMA2nVM4rD9ZpHkntOdpcZ0VLJaZgL0WNpvmnB+yg+Z/zvqY30KDKu7bEwlgGn8IJyEwDq3eC2X0ubkl104/veuje1neN/c1TLZFsudJ51XemXzP0MXY1oib5F2tMz3fG2m13s5yNbOD7H/+K4w9okheO6Eg+FvyFsGQmq4C4blauJRcv1GHjy8hH+MoUKJltvFq6R/KhGjTKA1SJ+evCR78TH0rw8tr+OV0ZF4zpsWHxtralK0yPTF/3WqaSi3FkC5p6VHJfXjcyD4IyZNVYBHvhI0sQKZb4dbMAsg9JtrIUmtvH+CpQV34hZuzIeOqFWquwNNT6RxB9RPYQyJ7xYGzRiPhODFTytebFXv7BOw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(376002)(366004)(346002)(39850400004)(451199021)(36756003)(2906002)(86362001)(44832011)(7416002)(5660300002)(83380400001)(6666004)(6486002)(52116002)(186003)(6512007)(1076003)(26005)(6506007)(107886003)(921005)(478600001)(110136005)(66556008)(316002)(38100700002)(66476007)(4326008)(38350700002)(2616005)(41300700001)(66946007)(8936002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?AsVpNf3m9F9S1voMmt0k6kz5K9U+lw16Td5FgCjgT8fXX9yjU+XofQLvXtq8?=
 =?us-ascii?Q?lkCqr6vVWYO1S2zZuLQvxcLfg1tQyIEMBsg8ri4oMsk/DKghMiEYu/t2QtLk?=
 =?us-ascii?Q?mLzFGz65cdJ6BzrGRE7iDFHLTHMXBhQPANmI0L+yMo5hXAylbrxSjbKOCDBR?=
 =?us-ascii?Q?0Rx+GXVkX8Y+WSoSn533sIODj5X+m1+XMPzW6sa64CNqkiOEOTjSw4PV4HXq?=
 =?us-ascii?Q?EyV3D+pFdNjoeR3OK3SubOujM4yThoQoBPKAdOAZm9P+3uNH7L0phCscvCiV?=
 =?us-ascii?Q?HJ510jPsNs0BEg/GaSZNlasUPG3OZ3jP8H7sHCGzUYunnlUtAtCN6qCPjC/L?=
 =?us-ascii?Q?gepMEikLTpatzxSz6lo5iQIWA01USa3JLYdofT3BUzGhyLxIL8bI3no8oRrU?=
 =?us-ascii?Q?4AKoJY7baSEPvgv/mbHmYyAeKZyv6Pz1XDAZyVvy2kaOMUrHHkolgxGz2UEQ?=
 =?us-ascii?Q?JaGGJE74nsIQJ2VbDsr2gXSMz75hqGFW1Q0iPKxCBZeC864YkCuyBgITV1e9?=
 =?us-ascii?Q?Surret3evV9vBy4qsz9RRREObCTn2H82P0MwkZYVShsDbLT5LGo/S7qI1Ls7?=
 =?us-ascii?Q?XPomQfqyjqXLqO3Xzo7Vy9aLbHvDb2SOZVg8wQZSXRd6RFwo4xKNffXSFhJh?=
 =?us-ascii?Q?ZprWdm7eO6B0s+AYWWS8BpfhyJJ5OyZPJHlJJGn/scKjPsq8YgZI+EZGqjFu?=
 =?us-ascii?Q?NOd31wo302x4G8m0Z1wnG7lOaJIAhSW5beoiWppe8w3eD1T8nxDNssdFciH+?=
 =?us-ascii?Q?e4OlnYbHVC/rdG1tBvxbvn6sNejwxv1YAcfY5UI1vGiQ9+g6USPn1tOSCPpJ?=
 =?us-ascii?Q?rSYdyve3ERheOhWyQQTHvqYExOljqiZA8rvLydGUbfkYHYzdgzesZ71pvucg?=
 =?us-ascii?Q?T4oi+gcRyuLeTgcgsKQvDJgyO5T98AuNQnvP2EFoYuMb6EQRlCObcgfPcyN9?=
 =?us-ascii?Q?SGMonMxOFTZf+FA70UvlXvMc2EsaOhJUq7XK4EuZ1vK2TazsTYtQ3gRPiNrP?=
 =?us-ascii?Q?nGNveFIOXQBVxjEvhK1JhRyARA4aRxHbgBaMGuANiLXoS3cAkeeZxdiG7737?=
 =?us-ascii?Q?e5XJ1B3mKmRlioTTPNS6z71SlQ16SOSCfhXFmZLUTbG2o2M5pdAdHAyXdvAk?=
 =?us-ascii?Q?8+hFatw9+vawy2fCZAXoE0E+CXkv1smmcbFqS1qbprRpj1WO4EtGGvBiqWaL?=
 =?us-ascii?Q?luOMac2pGL/i+eZuq1XzMXKA/hUTDjfBBNjzLVfZROOxc0ota5bfkmAThdJG?=
 =?us-ascii?Q?aNARRwv5MG7ZCYgUrKKkA7gqayfOIu0D0W5BPm+RBePwMViJHvgWjcCo7CSX?=
 =?us-ascii?Q?LqMef32jBSjpF/yzBMF2axyj3yTK4DWMezXOrXfv20LE20zQ6cJm4A/Wg/9o?=
 =?us-ascii?Q?D4DzPDSMoff11y+j7xO6d3JIbncoZki3cSU1fHpBgbrWVNAgP8KdLdzo9cKv?=
 =?us-ascii?Q?/ZezYJtao7aWqYPteB2UYuiqfwDNJtJFGOm110L8Vx+l/pvMdY33uoydjZcu?=
 =?us-ascii?Q?8YYtGOGr2bzJOOqW9vON/yl9TSg/OPIjDBYNkKE65IzFuiB/E2alSNVrohRx?=
 =?us-ascii?Q?p7jLtUg4DMgLRYhI2jGMyrEcf0FBJxzj2gz/wIhF8sZiGuYWA0mGO70ko7M1?=
 =?us-ascii?Q?9w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?us-ascii?Q?Y1sQxj5N0wv2eJS4BldeP1Pc8RKSicCfhWfUl1dN6KJYrnMdNyHHTctL3SOw?=
 =?us-ascii?Q?/l/Eb/PrbZg30bg1xNC1f6QPWNjLe1S+qMZqYtnlDYpMCcfejJawKBFt3pwn?=
 =?us-ascii?Q?UTRkSu/odU0cGDSsw2864SIC6zeTUQXRPwJKtgpouy5oCw8mOp4hYFy/RmmD?=
 =?us-ascii?Q?R0y2VAN+azmJSywVCiWD9R/BrIeXl/n79Kl/dN6WtFCQKvHY3QwkE3HteCG5?=
 =?us-ascii?Q?JRnm+AVw735p3Lb5NKtmZPQ+qihbaSUIeZ739QFDZ/wBSrDZH8HLtXIeAw8C?=
 =?us-ascii?Q?eSDffVyhIV6oJUxEW0ktSAWCMg8ipOdlvvHnPpFxSJpxAlVwoGMoAH8HAGyn?=
 =?us-ascii?Q?a5eHLs0FMn0ED3UoTUCpy1SWsLglRb4m8Nnd8I/aXVazDllkWcU1WeT7Un3E?=
 =?us-ascii?Q?btki0Ow3+JfTb1l3baj85dlB05WPNhdFH6DDVzUfPngd51W4qYp6NiT+Lxei?=
 =?us-ascii?Q?UwnQ17970QMCY/IEAMAOETfOE2kbDZWSD10KAnIxGVKG4WexYsoXegzYu6MJ?=
 =?us-ascii?Q?x7uQ1Vb8iS04sQQKdGh/LcRnOy8QSUzbOlHt5PqPf4g0YBE+QkZhZ3ASHe8e?=
 =?us-ascii?Q?G5lFdk+ZTXZYiy4KPbby9VaQPUtcr4TjCs1nSN2gvY9k9PdJ3rEThVojGqz9?=
 =?us-ascii?Q?mZXXmyzg/cIFIAPtda10daAoLHseHQHQNyft6VCf4ok7V3l3kW98suvzqDf3?=
 =?us-ascii?Q?NBdV1SUKbRZWEwUmlr3eIA6XNkObSl3hVmeMcdR3o2XozhvtHSAnjSPo/Xn9?=
 =?us-ascii?Q?My/uGcjqB+vqyTU1wCEIv6ommoIrpW/4BDMg5OV6F7yjrCa7z8x+kz74wi4G?=
 =?us-ascii?Q?2QCNdG4tutZFdxT40KqdiMDg8JA9oFtj6vbtFXH9nkRpgwFt0e2O48zp2iIr?=
 =?us-ascii?Q?Ix6nnFvR6I3wmATB7cjOQHYnYpMLHoUMTP7ky84388tON0qsBZs77aUcgn3y?=
 =?us-ascii?Q?6mHj8zPNw/ZyNAWKL/4o9eDSKDL8JmWuavSV/zljgxopRemF78tyj/b0swiI?=
 =?us-ascii?Q?EvMyZPIk9w7fjjY+b4sEcGJ7/w=3D=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9b9c4b0-ba42-45ec-4046-08db65db212b
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 15:40:03.3382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QLhzyQcfpsF3CB79hgDlOWHGh3w2H+Q0qCkkXyF0ELrinRjIQvCCSuOZ12i29l/NLXDDt9EFQKGbwsU+zuM+mEbQWAO9GN1uFL+VmAdMraU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB10571
X-Proofpoint-GUID: HqJnBsRfDUSnDziJM-Hu7kohp0UM_oQN
X-Proofpoint-ORIG-GUID: HqJnBsRfDUSnDziJM-Hu7kohp0UM_oQN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-05_31,2023-06-02_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 clxscore=1015 bulkscore=0 mlxscore=0 suspectscore=0
 lowpriorityscore=0 priorityscore=1501 mlxlogscore=999 phishscore=0
 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306050135
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The ksz9477 DSA switch driver is currently updating some MMD registers
on the internal port PHYs to address some chip errata. However, these
errata are really a property of the PHY itself, not the switch they are
part of, so this is kind of a layering violation. It makes more sense for
these writes to be done inside the driver which binds to the PHY and not
the driver for the containing device.

This also addresses some issues where the ordering of when these writes
are done may have been incorrect, causing the link to erratically fail to
come up at the proper speed or at all. Doing this in the PHY driver
during config_init ensures that they happen before anything else tries to
change the state of the PHY on the port.

The new code also ensures that autonegotiation is disabled during the
register writes and re-enabled afterwards, as indicated by the latest
version of the errata documentation from Microchip.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/micrel.c | 75 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 74 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 2094d49025a7..6d18ea19e442 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1774,6 +1774,79 @@ static int ksz886x_read_status(struct phy_device *phydev)
 	return genphy_read_status(phydev);
 }
 
+struct ksz9477_errata_write {
+	u8 dev_addr;
+	u8 reg_addr;
+	u16 val;
+};
+
+static const struct ksz9477_errata_write ksz9477_errata_writes[] = {
+	 /* Register settings are needed to improve PHY receive performance */
+	{0x01, 0x6f, 0xdd0b},
+	{0x01, 0x8f, 0x6032},
+	{0x01, 0x9d, 0x248c},
+	{0x01, 0x75, 0x0060},
+	{0x01, 0xd3, 0x7777},
+	{0x1c, 0x06, 0x3008},
+	{0x1c, 0x08, 0x2000},
+
+	/* Transmit waveform amplitude can be improved (1000BASE-T, 100BASE-TX, 10BASE-Te) */
+	{0x1c, 0x04, 0x00d0},
+
+	/* Energy Efficient Ethernet (EEE) feature select must be manually disabled */
+	{0x07, 0x3c, 0x0000},
+
+	/* Register settings are required to meet data sheet supply current specifications */
+	{0x1c, 0x13, 0x6eff},
+	{0x1c, 0x14, 0xe6ff},
+	{0x1c, 0x15, 0x6eff},
+	{0x1c, 0x16, 0xe6ff},
+	{0x1c, 0x17, 0x00ff},
+	{0x1c, 0x18, 0x43ff},
+	{0x1c, 0x19, 0xc3ff},
+	{0x1c, 0x1a, 0x6fff},
+	{0x1c, 0x1b, 0x07ff},
+	{0x1c, 0x1c, 0x0fff},
+	{0x1c, 0x1d, 0xe7ff},
+	{0x1c, 0x1e, 0xefff},
+	{0x1c, 0x20, 0xeeee},
+};
+
+static int ksz9477_config_init(struct phy_device *phydev)
+{
+	int err;
+	int i;
+
+	/* Apply PHY settings to address errata listed in
+	 * KSZ9477, KSZ9897, KSZ9896, KSZ9567, KSZ8565
+	 * Silicon Errata and Data Sheet Clarification documents.
+	 *
+	 * Document notes: Before configuring the PHY MMD registers, it is
+	 * necessary to set the PHY to 100 Mbps speed with auto-negotiation
+	 * disabled by writing to register 0xN100-0xN101. After writing the
+	 * MMD registers, and after all errata workarounds that involve PHY
+	 * register settings, write register 0xN100-0xN101 again to enable
+	 * and restart auto-negotiation.
+	 */
+	err = phy_write(phydev, MII_BMCR, BMCR_SPEED100 | BMCR_FULLDPLX);
+	if (err)
+		return err;
+
+	for (i = 0; i < ARRAY_SIZE(ksz9477_errata_writes); ++i) {
+		const struct ksz9477_errata_write *errata = &ksz9477_errata_writes[i];
+
+		err = phy_write_mmd(phydev, errata->dev_addr, errata->reg_addr, errata->val);
+		if (err)
+			return err;
+	}
+
+	err = genphy_restart_aneg(phydev);
+	if (err)
+		return err;
+
+	return kszphy_config_init(phydev);
+}
+
 static int kszphy_get_sset_count(struct phy_device *phydev)
 {
 	return ARRAY_SIZE(kszphy_hw_stats);
@@ -4735,7 +4808,7 @@ static struct phy_driver ksphy_driver[] = {
 	.phy_id_mask	= MICREL_PHY_ID_MASK,
 	.name		= "Microchip KSZ9477",
 	/* PHY_GBIT_FEATURES */
-	.config_init	= kszphy_config_init,
+	.config_init	= ksz9477_config_init,
 	.config_intr	= kszphy_config_intr,
 	.handle_interrupt = kszphy_handle_interrupt,
 	.suspend	= genphy_suspend,
-- 
2.40.1



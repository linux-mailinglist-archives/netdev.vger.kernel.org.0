Return-Path: <netdev+bounces-7601-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C5867720CA7
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 02:40:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 79ABA281B49
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 00:40:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81F9D816;
	Sat,  3 Jun 2023 00:39:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689A6195
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 00:39:58 +0000 (UTC)
Received: from mx0d-0054df01.pphosted.com (mx0d-0054df01.pphosted.com [67.231.150.19])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84FBBE40
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 17:39:56 -0700 (PDT)
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
	by mx0c-0054df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 352NHxtr019830;
	Fri, 2 Jun 2023 19:41:46 -0400
Received: from can01-yt3-obe.outbound.protection.outlook.com (mail-yt3can01lp2169.outbound.protection.outlook.com [104.47.75.169])
	by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3ques3pcph-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 Jun 2023 19:41:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C05gMwMHdv/H2zQ/touj77d6s2JbuyKccOMY5MZkivlz/IAUN1gl8wf/lcsFbCo/KHV7R87rKU/mfLzTMgXFHUlZqHF8aOP6PKWvNUgBOtVvE4ctoJ/euLJ8N0SnLPZxUhex2Qheacg/UQvLN6/sFb4V0BO1S4JtFU2D52SAPL5JLiR0jvdFnjiSMRDdS3rS8s+BFeJ0StgII2j2US+oKVA8/EERy6H8/1fo3Dh+SzUiI9sdXeWwUSQwRpNQ+TaRRU94NrWV9OKMtoTndahSfiatiS1dHM6IQe9mUAFSm+VO003qX/r5uzdD/cBk+WIUYtHXnIlflKiCL2PUQWWsPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UPadptKD9Z2koX+L3eERKyBGmXqLU0A8id7eDjJyGp8=;
 b=EKW3YNZLcDZwMzsFeE9zIaKXRHtyB3ZXeZ9KNIscb8A631D5xLEG2DmQYX9lqL+PvfyjCvxvszGJFJYZJu94wRwqM6kwnYC+KL7APbVFQfWNqu9XJu3rptdGRGcadMq/iGH6KTG5h4ldYsrnl5XMQztwn80inpKXtlDGnWGAj/5DSL0xk8VPKBndaCe7QvR2Euc2ujavKEinDP8LiwynEQSy5dyw2XwaInQLb5oWYaLZcEnBrkN4q31iZPa951lQHUvYNf/S4hNJgTEsflzBM04pNFnbtGIS66a8jmzDzG7YTQ9WPATDXm3IUhthuVRx2QsVZDThBxXIpn/cT8id1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UPadptKD9Z2koX+L3eERKyBGmXqLU0A8id7eDjJyGp8=;
 b=xGPs9HCJdvOFfAUKcwih3rorRWb9WeiR1DECFviMGxC0WMp8ANH8ZrdCWshUP8cj55UVehrq/FsjChyUPUuHkEOz9XR7TGR587VeDj2KiBV8VP9Op5dzTgxs2bl9waWlY7LGzSJewoUpAs5MBN91dCza/SsO43Mt58pUbD/bYo8=
Received: from YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:b9::6)
 by YT1PR01MB8763.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:ca::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.27; Fri, 2 Jun
 2023 23:41:44 +0000
Received: from YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::c059:dcd5:ca20:4a0]) by YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::c059:dcd5:ca20:4a0%6]) with mapi id 15.20.6455.028; Fri, 2 Jun 2023
 23:41:44 +0000
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
Subject: [PATCH net-next 1/2] net: phy: micrel: Move KSZ9477 errata fixes to PHY driver
Date: Fri,  2 Jun 2023 17:40:18 -0600
Message-Id: <20230602234019.436513-2-robert.hancock@calian.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230602234019.436513-1-robert.hancock@calian.com>
References: <20230602234019.436513-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0362.namprd04.prod.outlook.com
 (2603:10b6:303:81::7) To YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:b9::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB8838:EE_|YT1PR01MB8763:EE_
X-MS-Office365-Filtering-Correlation-Id: 180f30e2-7f1d-4543-5b37-08db63c2ec61
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	6Av9A9vnEafTWWr2pBToz06AIxMsHXPXR2uvfC4semXhKt7sGxPOUQkOsx7U91W9B0pyFy0IYsAtC3/KBt1807L8dKXkdfM2AburHYQf78PREc4tmFMQa/DgHCdMkvrGu4DG1l1EXYnF0Krif/5lhahhhn+HVncwUFVmviUHIQj1msoL1L3XqyV8110zOS+Aa4fMIghZ4GpiKILLKwBtz+6mxzg9T4mAjBh0CQ72ClXNNYB+9/Nxzw0gj+RXTludgVg58QbcVNtyfpjUaVrCrBs8auqFhgWZ6LZzSkW6TU4aRUbIHD2/Hu/CRSkZ2uSerKk08v0ljs9pBiv17uNd6RWLWnX3uVgosbmEbAHqX1YGGSQb1gH8ziaZaVFx10n6OdzpGxtfB4jJDFW9ZgzpxTsRkK5nu6AHy6RTxblPBO4deqO1dUMUJsmiVp2d5biUVHL6d37PYbpNZ+6GGUhA5tGYTcJU9tHJWYwsRSRck7O2UU9sIm2Gw3K/a/UuguTWaO3aQ/m5k/owBBlStXeAaqcwB9hYJLCe+RL6huN3dDb2DO2KqFL3GBrKPDXUjmWz2KI16aEKBCmQCQ3EfhQt0jovTDMA+HM6t4em3P+jgDwRj8g2LsCsavsL4B1jAuEY6KMbPuVNshIQ57/RkBPqBw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(346002)(366004)(396003)(39860400002)(451199021)(8676002)(8936002)(6666004)(110136005)(478600001)(921005)(52116002)(316002)(41300700001)(5660300002)(6486002)(186003)(26005)(1076003)(7416002)(107886003)(44832011)(66946007)(66476007)(66556008)(4326008)(6506007)(6512007)(83380400001)(2906002)(86362001)(36756003)(2616005)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?YoeH5FZLRvzPlMEUZM+hDrgW7CveDprPi8SnKsQE2lW9fDTmj+bMwZSH5+3K?=
 =?us-ascii?Q?QTs6e85yf3OiUapwfJIJ2Z1zbPBknawQ6G1KT5QHHEhyUm9pi2H+f/XFcquL?=
 =?us-ascii?Q?GS6IA5K0gT81Eqp/XrFkMDWjhWguvpERywNuCBBJpbCTIV/nbXeFofzMwM0j?=
 =?us-ascii?Q?Jy92vruiFwOtFzI65cPnLT4CgWIEkvvecph9+/VacqSr1/MNA9+Arsf5qQi5?=
 =?us-ascii?Q?rbNS1E3WGZeCl4DmLOcX7X1m1u0vHPQ96BC5F/ofwT0HOYUkJq8dRADIvLQb?=
 =?us-ascii?Q?vZaE128WSyyhRcb+0tWtpJBPf4otZJZcWVwdHPan05iW0wgiKBUe0LBLTJ0G?=
 =?us-ascii?Q?93m/U1ZV/5poDdXPv85sGVYr/zWVNxiVwUWYF6UAEAK63nlwXHlUM9JY1T+W?=
 =?us-ascii?Q?8/JyCN+uRoeeBVrhfD3gSPMLYsiW8PVqkiehzlfyMl+rK86BpgUz+yeq7lSW?=
 =?us-ascii?Q?fTIF5E6395jnSuTOjs/qaArXnJdMmQgJ7c0RX0nStpMQ3Hgl6gmnHPHMtoGh?=
 =?us-ascii?Q?y/Rh4RAXQZvHOYlEtJHrz0+7zMcVTXZD2Nuehz3QCkaQluwVyIXrOHe+w6YO?=
 =?us-ascii?Q?dA4sLgqze+xqQ4yGNJbIOERLttv5tUrnngWmM9BcK1797o0rBTJU+mnidgIr?=
 =?us-ascii?Q?0VfC/bIxEz8BsCqK7mgJg8pFMhoCG8QoNgHAc/KvAsOX+KuB3Cey/b/VJV9G?=
 =?us-ascii?Q?YxfS/UdOgTpSEUViBfAWHym4Kvlf0g6zqz9n7jqc14TEw8+dVTuU6uwpIKS4?=
 =?us-ascii?Q?dAqx6Q3K14EK82lIuq+mBZfuTtsdBKE35alCufaQbCW6h/P1c/jpmKp8xCRv?=
 =?us-ascii?Q?miDWIfOF30Tks3U8r2y7MuH0hUpvnQghW1ttSyG02LDVrusSSgGSA/n/yNbs?=
 =?us-ascii?Q?xJVBDjKTbTOalE4rQK47Xjg1kJf7948IsjU1TApb5swCes7xVNsmrlRtLqdv?=
 =?us-ascii?Q?qOiANkF4i2CH0ku27MTyo1HnJrFJiNlElL25mJ+MBmyAgHpRK8lzfeUmX2/w?=
 =?us-ascii?Q?LxLUxQVp/i1AUUNO9OcAKNLwkuzTksZknSz6HffIb4VLmSUORcN4WKefgh7U?=
 =?us-ascii?Q?tQTHqYf8xxOy7QvNNdtyAiyx2qxyXlZZCDSGPRzawYWJF34hvlieyV9QJDO2?=
 =?us-ascii?Q?R3Cuv/VFb541v6Uh1pVavpTWMQUMIpHllZhBibZUIBfQmKDMjS4BXjAlIOgA?=
 =?us-ascii?Q?+8SEQ3mOUd4mdxpOTfQDoaSH71T5kukHdJQbGvc8NjnQs1sXdDlHSQqX3i+m?=
 =?us-ascii?Q?S5pK0kUMGDPsYsmmT+rfgPMuTDv3mOfqJeVkE1ggamOE9GFL+RdkZqT6c1El?=
 =?us-ascii?Q?Z1ORMWzPiHzyFpNfUTYC3LL2zxJSSBXykXuPH2AZyPI2+9qzzxR3AS74a/KS?=
 =?us-ascii?Q?Ytt1qYei5AeMFxqdaWGF6ClxCE+7e8UEI5i8yMRtOfjwSfyh3N9zCVHT56IY?=
 =?us-ascii?Q?7C2rv+Zv9EIqZa0sCsUuZyIpFa0z1Wy/voS1RDwSkOZ12Idz6CTtBC9YE6hg?=
 =?us-ascii?Q?4Mw5ZEFkJ5kai/c05VXNPa46KtmuZQ2iM2CHK8cxkaCJWeFVbz0JU1yW44am?=
 =?us-ascii?Q?0TnO1lpjv3YjAG4j1mgPVR2kFHhn2jKJL+RgJrMFOA5OmhS5r1VkZjj5OvVO?=
 =?us-ascii?Q?SA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?us-ascii?Q?e2GTkRv9RLIskQu+mbGgYnBAKWteOGNfVnVZy2w1bI2NfhypTVwFirtMrham?=
 =?us-ascii?Q?hIP4E8C/mGbbulHoqfoZk39eR37aEIuOhjUUUCsab2uuL/W4UVyu7k6lW9mN?=
 =?us-ascii?Q?yt5YjgQgZPDwH0Tg0Cjkw64TgMZ84Pys7DD0EW+EsrrCiKfpoUKs73XM3j4f?=
 =?us-ascii?Q?SY75Cy0gbibx3UjvVGLaV0Td+9sZp2AOnxmLFiPb6wsyu75jS93WSGbUKLpk?=
 =?us-ascii?Q?1YSLWXXBl9QWXdTSwZb7b4j/1nNJeNpGGJprKm6Y1cUVRoR368FZqRIB5vNx?=
 =?us-ascii?Q?lSP14BLB82ywYhi+EHhh96ww16Q2ClxJmbvM16gNPrnjfmtIYM4rj4BbnaNi?=
 =?us-ascii?Q?QophoiYtX5hxWoFpU41jTsQ8K92RT4/N0uZXipMlzipyEhcpHoXPUY9ky0qk?=
 =?us-ascii?Q?Q+IZRtPXjInaR16QWbabfZ3EG70hyAroBr9VDziUayvMQ7rNJVQybrbru0HW?=
 =?us-ascii?Q?Vm8tPxf7zIyc9alqUZFIVY/Neee3DF8NbhOn2m7q4iDHsAVs4EUdRQK+5Hod?=
 =?us-ascii?Q?1itM0HJ+bXT6BLS7R4HDRSGWthS+450taS+be1ock4/h3ib/CpCmZ1WU7thL?=
 =?us-ascii?Q?+QgoBMbLndQXnGu77uWuvGXMKs5WBF8L5Z3Xxcg3AnHDqK0UpgUiuKu9UODO?=
 =?us-ascii?Q?GMYZ8Hi+Yw2JefOZo6+kjoU+YLTRFtuPoZpldoHJkuLr76UkGd7A1Azy1GhY?=
 =?us-ascii?Q?FdQZV8MeqjpmdYcPr+P1DQBNTWR7CX/zPOGK1nkQIto6BCxkCWRaUSLWIfUs?=
 =?us-ascii?Q?uSIUrOM+8mNELEllp83hcKaHFJtbVVFyCVP5dGpbAukve1G4l61KFwVyXGgj?=
 =?us-ascii?Q?qo+/QoMk9KeC8m4srz6C8dHuKqcFaLhsAL+i1pAA6dfmNgN6pZXxSIWXyTFt?=
 =?us-ascii?Q?P4bhXgWOOxfYwQHPTLp4Kacl5k+hDCVN8uBtvudmCXHQUGHO5/oznOCCm64x?=
 =?us-ascii?Q?rVPsVWeHkEEYL9k35cyyd19NVVxmWgQHQCb4MTEWUCeMIHjxlT3qfj5anwyM?=
 =?us-ascii?Q?FneiuWg5ZibSk6HAttx8qF3oJA=3D=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 180f30e2-7f1d-4543-5b37-08db63c2ec61
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 23:41:44.5164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9URFNbSgUZfVOYo33mizF2NqALfqj73uKMVLWwbj5f1bo/AGogwPlLuctqi+SsRZysws4corTBA49w+gT7HkQCibK2rQq6rRP4vu7c2fzXc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT1PR01MB8763
X-Proofpoint-GUID: hMijEivPDS08xOHs6SHSa1XPbhny8IZ9
X-Proofpoint-ORIG-GUID: hMijEivPDS08xOHs6SHSa1XPbhny8IZ9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-02_17,2023-06-02_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 mlxscore=0 priorityscore=1501 bulkscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306020187
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.6
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
---
 drivers/net/phy/micrel.c | 75 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 74 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 26ce0c5defcd..6d9f38b5ea17 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1733,6 +1733,79 @@ static int ksz886x_read_status(struct phy_device *phydev)
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
@@ -3425,7 +3498,7 @@ static struct phy_driver ksphy_driver[] = {
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



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6731648B9B8
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 22:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245373AbiAKVfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 16:35:11 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:3485 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245360AbiAKVfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 16:35:06 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20BBWJUl022122;
        Tue, 11 Jan 2022 16:14:31 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2053.outbound.protection.outlook.com [104.47.61.53])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dgjrs97yg-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 16:14:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Au3PoaguC34UBgdwzFqySm20JxIKOkzvKJNE09JljLKR8lB9alJ4p1t3jFMVZGobOBEf+myjTXN2OnwZ1S7c4fRkgI4pK3wkctdQovJtee5s1yobjDv2SjZFCRuto1Bun2fw5wwUjhMxiRQSosdCVrtTAwd1rz1A7StUaRZ3wUkWW57cRInPrvAS20jxjKNKuJCeGJPMvz2cwWB/l+2bxWOCItzrGCnH0piNXpAnObaSMyMYzvR+L0haM5hJSUOFZKbZ8Ji2v+3EdKIdzZsK6YIxDWEtekW0Ncv7rMRZpwYtfqJY7nLi11c45zXHK9d8czkzZf17tiL9I3i0kVNoyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iSV1LcXhDE3eLySVJixtB5wpsPh+VDaIOsTT+RVzZ6Q=;
 b=P+Cfit9k3EzjEP9tXDu44sAmgjZXLhYr/QMhUHpqyX0QUeS+Zn5cR2OT/EalvfTlI/k40VzAJ4o+GmaRHgTnD09SQh7ajA1ZKysB0Z6MtZP6AcLO3MCCcebbqtUrSDZKvh5veyf0YXeWpN1lKEwei7wS3zSGQbN6CqCGrdW66WMf8z+ns/YSJzIzfMygp8DbNk/ALGPn7Y/4PeSJEmu3JKLDptIF95+SMZLdn4usRULukZ+naiJ8sup11KoN+fCJlmQdGFnBjJin4stHrT4GsLjZqsT0hROLZ+zYPSsP+DfGXV7r+1EHk5Cf31zurMsn4k46UVFEfgFQyfl0UlZCBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iSV1LcXhDE3eLySVJixtB5wpsPh+VDaIOsTT+RVzZ6Q=;
 b=kNSWBdDQNXolSvtGKsY1xaZhvs1sh4zM+rTEwKBAqFg/PjZ9X/Sga2E5gwTVIoQ1f/nfEImfCL1ANkaHA9FOJLucujZ0ztXnyRTnz7CwPL5EFPy9hIE9rG4L5KuA+gCOpEWZ4BJQIz3zV6L5/G1NBjZb0A5fVc6HMvprxI8mOQE=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT3PR01MB9218.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:a0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.10; Tue, 11 Jan
 2022 21:14:29 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::d1f6:d9e4:7cc7:af76]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::d1f6:d9e4:7cc7:af76%5]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 21:14:29 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net 3/7] net: axienet: limit minimum TX ring size
Date:   Tue, 11 Jan 2022 15:13:54 -0600
Message-Id: <20220111211358.2699350-4-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220111211358.2699350-1-robert.hancock@calian.com>
References: <20220111211358.2699350-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR07CA0049.namprd07.prod.outlook.com
 (2603:10b6:610:5b::23) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 28014dde-4842-41e6-1be8-08d9d5475ab6
X-MS-TrafficTypeDiagnostic: YT3PR01MB9218:EE_
X-Microsoft-Antispam-PRVS: <YT3PR01MB9218599DD88A0DAAC227E429EC519@YT3PR01MB9218.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YhAY3NP3mYyianmZHhOkYsUW2w5r9SHAlwmQBxb+P4mRTjVKiw8aVhq5B5mGhd21JHcLXH+OnIS8kBFZiLuscbJcWzfWj7iNJrHFi92lsLvhNQvlwQW9X6YS66jc6CRkLc71DY9Vi/1FAsOCUy09kZrYPOtYIoWzASKdia6Rcj6hVwkC/W1sbYPsaqLscuCj0sr5CAO0QkRa3ej/qZ75eZM3O5fEvJLP5Fee/Sm7lY/UQisQQjUowxTwOQj+CsWixQNmU9ZdqXKTjdFN5wbSzpqECN7CzJGKb/Ge8wkY6Bmmqz3o2KVVWLkkxCw7TTPHXI+NJTaLUbHIlX/QdoD0zSR6F/At0u4QjRJf0FBqdjJ6+S3o9ScHAKnPWiLq5QPIJV3ezDNkLyzn9hzgmVG6tJ/Q4D0xao1htJq5y0F2f7czgDoJ9CPPvJ9DO1HleaZti4ngVRQmf11/zg25Z7DnAnWJbywtKba1Iv288GY8Tck9Z/nZjBkkimxC33If9XMCevw/nW4BAJV13JG9GO5aIYkHE60hV+w1RzRtDcU1IaSvcU4y6j4TJchut+gO6v3/DpqyP1lyssv0aSYDLIqM/LGHeF6Rx4HqVp3abJk7LE7rxwflqk/pDt7UvRU3Q69xTO2QNiIsbHwCtK1hDNutscg1fmWXpMhe73CvlcRzUJHI4Czb9Irc2hFWGE+yzCG1jsNHMffxNQTYDMpd4sERWg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(66476007)(66946007)(52116002)(6506007)(86362001)(38100700002)(26005)(186003)(44832011)(2616005)(8676002)(2906002)(1076003)(6512007)(38350700002)(36756003)(316002)(8936002)(6666004)(4326008)(508600001)(5660300002)(6916009)(107886003)(6486002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YPox/3IM24KviQS9HT1ipZHxMBIw0vdipqF2lvOxeNHuoSIuLQyxMGStYIvz?=
 =?us-ascii?Q?IGk/ce7DMAjdXO6R0Zuu1TySmk4HRklQnJviHIhxb1eq8gphfjLJRFpBWUW5?=
 =?us-ascii?Q?nr7BusGlvyKNvh4AQtW3ILixKthrni50w9jxbSl5fHMXanhcdrJ8b6P+tykH?=
 =?us-ascii?Q?LNq9A+dLEdPMKrGOTZf5AazWNFps0KhJRZKLzHO9hWfGZ9aF6j0zu8iff6vK?=
 =?us-ascii?Q?GBL92Kec3LaC41vaWbGj85SPXjBgy7bhz083/lhGzPwKOzBZqPxdC9CPo6xH?=
 =?us-ascii?Q?F21f4Nc3QPq9nTCiyqj29h51UBjaQDZvVd9YJy312lT89YhbNlKmx1az2vDU?=
 =?us-ascii?Q?ylIHTZ69JCPismQZUa1n/PRBjcfAauTKhS72SbUbRHMcKsLpoOz0t/aSIJpn?=
 =?us-ascii?Q?PuYIFO2VOQWBgZa6c49DZdeS2IWpkY3wtDVKjWQKJF0aHpoJi9GJEpII2oZF?=
 =?us-ascii?Q?I/2J4LTXCkbn9qNrfiFtwV2mbuNQBD3IoyuZ/3wj10pCppHZl5BEQYtah6vV?=
 =?us-ascii?Q?OrrFhXqX4ZXmVb5cCi20OXcTjHW2hdh4l/lAPKYUDqUjyw95MRB4UmzWhqqP?=
 =?us-ascii?Q?4tyo+M7Ho9dEtkjjP3sGcktoe/iN3B23Hm2qLjciZlKcuo+y0Aweom8Sh7pl?=
 =?us-ascii?Q?14kZy1UZYtnlIqNlpTPVQHC+SSLqiMyaEKLV0ESiqCLFnFU9rNU66yGV2cvi?=
 =?us-ascii?Q?pV+MPTdO8UKlMXlJjqMg+kfW+bkM1wOTsKnZRoofa06WujLQJiK2oONWr3PA?=
 =?us-ascii?Q?IrijmNHMeRlUPd2EG+qb4j9nUmZw6Qjpxrca4YU/o5Gz7qgWWOLTiEKX8SEu?=
 =?us-ascii?Q?cZTuVymF6s0vf05S0O+sLaYklIqf2a+R5EjYm1qhrdPbj+bu0PhZ41FUedWe?=
 =?us-ascii?Q?/3YbMRM/WnxDGdxEpVDRo2P5lStcSWKp6MU4t73Mb+z7JHhPGkz4yl1dTOG2?=
 =?us-ascii?Q?oKYTl+QGeYFOHu8kmBTE92S5an3mUf0rICIYcLCBDpCtCDhDhAZx2lcnbhvn?=
 =?us-ascii?Q?joM/+OhYfJRhiA9W56UposG8gPQKBjY7vPhuCDt9pJomzcgNTxU4LILM7Irh?=
 =?us-ascii?Q?ndsuQFitpztIse28dR3uWRRABgqCIkDN29HOyDQkZgf8NRJr7KENcyfGkmM+?=
 =?us-ascii?Q?Lp+rNjwF8flG1O6j9oFK9X34/Hbo/r8FxwmClF4QeqTW5HOlW2H6ZlNahxYB?=
 =?us-ascii?Q?ox84IQzcuF4hWceDZSHsCNSQO5Vwkc9EsxcLxX5sK9z8G9ZeYN2MSJj5YZKX?=
 =?us-ascii?Q?3SCQuCVe2OOG30H44d0WcHORxU6DNvuGtrYudynGahkq4FaR/Dl2VT1LSQIE?=
 =?us-ascii?Q?OGFeRTRcybt9Pbsio3EIbbFl5Uw61d7RY6j0mAEVycNqujVznRwLmomBksdK?=
 =?us-ascii?Q?LQfNwboPYaIa7UDgbbxCZyc2jzKI8pwIGuLIJzEe4ixZGvZbarEi9sNeNuxl?=
 =?us-ascii?Q?wZcCKa3OhgS+kP/NEHv8gIdsx8IY1UVXgZxTUJRfC2Uu6iGGrUeEb5geQ/an?=
 =?us-ascii?Q?8K0OCOY3OdWW2EQnVIzJbIiihdX0RtPXGsp+d0Z1d4rBDY02H5BM/V6wziz0?=
 =?us-ascii?Q?xJql3evtpRmkJ/iCgeO/DmigAk5SQ3lNtvekuWFMWOHonjul3TsNMX6E85St?=
 =?us-ascii?Q?b9fPp06Eoop4LRCzQm+zsxedV8BjXdAMnEM1tg0aIHw+xLFNDyY9iZ63r41h?=
 =?us-ascii?Q?ZcLvAQ=3D=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28014dde-4842-41e6-1be8-08d9d5475ab6
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 21:14:29.2645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p7pE3xRqrb4fC917/Pk+9jEDS0HN5aEvTJd/962ONX/7klI1gYqGeM/l8sgDj56YC12ltIpF+9oIRWaBP69frMGYV8U+IWoQn9IhHZrmsiE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB9218
X-Proofpoint-ORIG-GUID: fFEjHdhzVybUOKIa6UjrBntsVOTilgEp
X-Proofpoint-GUID: fFEjHdhzVybUOKIa6UjrBntsVOTilgEp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-11_04,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 suspectscore=0 adultscore=0 clxscore=1015 phishscore=0
 mlxlogscore=682 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201110110
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver will not work properly if the TX ring size is set to below
MAX_SKB_FRAGS + 1 since it needs to hold at least one full maximally
fragmented packet in the TX ring. Limit setting the ring size to below
this value.

Fixes: 8b09ca823ffb4 ("net: axienet: Make RX/TX ring sizes configurable")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index de8f85175a6c..8a60219d3bfb 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -43,6 +43,7 @@
 /* Descriptors defines for Tx and Rx DMA */
 #define TX_BD_NUM_DEFAULT		64
 #define RX_BD_NUM_DEFAULT		1024
+#define TX_BD_NUM_MIN			(MAX_SKB_FRAGS + 1)
 #define TX_BD_NUM_MAX			4096
 #define RX_BD_NUM_MAX			4096
 
@@ -1389,7 +1390,8 @@ axienet_ethtools_set_ringparam(struct net_device *ndev,
 	if (ering->rx_pending > RX_BD_NUM_MAX ||
 	    ering->rx_mini_pending ||
 	    ering->rx_jumbo_pending ||
-	    ering->rx_pending > TX_BD_NUM_MAX)
+	    ering->tx_pending < TX_BD_NUM_MIN ||
+	    ering->tx_pending > TX_BD_NUM_MAX)
 		return -EINVAL;
 
 	if (netif_running(ndev))
-- 
2.31.1


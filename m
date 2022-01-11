Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E43548B9BA
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 22:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245385AbiAKVfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 16:35:16 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:3485 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245370AbiAKVfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 16:35:11 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20BCxNPn017415;
        Tue, 11 Jan 2022 16:14:32 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2055.outbound.protection.outlook.com [104.47.61.55])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dgjrs97yj-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 16:14:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GCZ3PWsmrHAUR3gJNnwcw6DFtR5qpiN0D5r5N1w5Ig38KBCRZ/6xHkoQyOjGbxTbaursrvO8Iq79v5OeyUK8teyjl1iXmWRmjPPEt26R+lO2tJjiCcBRXF25NHupBZbEb5pIM+qxuxHfRrTBniee/Hv9jJS4a845m7QuOryvKWug8jQaeqUZJxI6p2QD5otbM6HgfZBJ8/BP2uDSj34bznk1nG6S0oeGFlNUw16XV4O0swS7hYkFlmOO8+CUPb8ocyEkYBEIMfWjiWl5RD50aOWSAMJ1vaHRrD52usJh5xow+7MeFDyNx7NP+ExXFPSwUivqvI2GQDkX5ww+HKp5LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3maKHlNnvSWV4s8RF71FZUrR7rUC6v0MJp7HOwqTX7U=;
 b=XhXtzBSatS6Ls/xeHLoqfXRgrgERJ6AelXh979WjAODTGyggOrMDoNBnSqsUPhXQHWfKM5F9O8e21Ge2BWWkAMFhuKxAWPVysQLr8txneo4jTAaRNEtaTqAJnkCnjU8L1gOxa1LnBSAsVIjWdW5uopfV0WazUL1JpQL2O17onszQoZAKwQ8u9LPIuvXfWXnyl3vz5V/HfJLUJ/x8mWD12uULIXmAtU7EYvMyjZ9KH4q0Hm7uGvRU/P5aFWgPBEs3OcLR6+NrFR09SXrXb1aaJ5wCUQUbZFIgbWw8BaUVnYlOR6eaIOsh/GqnkYTmK5YBSuCy3+dVqcocr31gWrzmlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3maKHlNnvSWV4s8RF71FZUrR7rUC6v0MJp7HOwqTX7U=;
 b=xsDC7pIEwtw7wEDL2imU89UU6cXJElrU+Xle0YQfXMXwTdPos3rA9IX4euHGToo0QGmUIX+Wa0KP/NnJg8F/nXA615nXOtALsGkBkTWWxzZk07iIPwfyQsj+u8sVyJwIQms0IQTYBDKZu6L9rDMSOjT9dD5xIT1MFL4jU3maI30=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT3PR01MB9218.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:a0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.10; Tue, 11 Jan
 2022 21:14:30 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::d1f6:d9e4:7cc7:af76]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::d1f6:d9e4:7cc7:af76%5]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 21:14:30 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net 5/7] net: axienet: fix number of TX ring slots for available check
Date:   Tue, 11 Jan 2022 15:13:56 -0600
Message-Id: <20220111211358.2699350-6-robert.hancock@calian.com>
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
X-MS-Office365-Filtering-Correlation-Id: 66ae3126-4971-45b6-5d38-08d9d5475b94
X-MS-TrafficTypeDiagnostic: YT3PR01MB9218:EE_
X-Microsoft-Antispam-PRVS: <YT3PR01MB9218C822C639DD09468CFC58EC519@YT3PR01MB9218.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: npC3UfPe/yIdazx2DSYoPU0GUzSNQ211ql1GE2d5RoqASfGG+vZehdX0u4GjB/gPKjPoTWxAxSztFsNYNDZKDY11TgV958Pfvl4B+ghzhyjCXL2akujQZ2D0dYQib/5K/5g7YVbcu7RMoPDwoVcYn5wTc1zQjDdepItr8gEXTK1gltBpyVfx//4BP47n/uAyfbnBRsfRWajjEAGThl2mfwkvIAW2l9iEYINXj3EsvIuUXp0EQQtyEjj+SJNOhU/fzmmEXDPkvSdUk4n6b+CxoxKfNaDC6qhLT3rVeeC0CkuRbsiaGcPEqlJjgJzCeZLucTcVlh+wECxUgqEwRhJVC5pQcm6Hg7wf3lnEabnnr/hn1GaHwJomRwg1cUdxZm5Cu7xDZz2aFg/voyi1xZHxIZdLzOGiRXVazGFW9OSDPLlAXHw1NwHr1ZreExfp8P9xauktkdcEtPSQC7LwRZGMz4pUQjy63Ch+4r5TtVJhh1GxEwjp7tW5f96vfFapA0vNMz7udVPCwuomxkoPiUtUfPZeSbrUkkkdcN7hbXiPRVKHxbl9frBPQV5AHDZzg47U3s/jjC/sdkGZyoOtj9LJ3u6WIH3wGSo+gs4ZE9F3sl/SmavQQd4b8G/zNgFheiIOz207TuH9AUb9tmiL5Y1bcFleqcXF6Urh+vlhsaFig3f3FievpM/cg48sGirC+qkmbrDUQznhKtnDeXQTWW7pmg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(66476007)(66946007)(52116002)(6506007)(86362001)(38100700002)(26005)(186003)(44832011)(2616005)(8676002)(2906002)(1076003)(6512007)(38350700002)(36756003)(316002)(8936002)(6666004)(4326008)(508600001)(5660300002)(6916009)(107886003)(6486002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DWupSwNlRNdRoZqShiVbjFWuwmIcE51Z3ZWkRSMi/MgoJEw1qFZEMAI+QX1W?=
 =?us-ascii?Q?gXTR5gBzFRDSXC2Fvm150GEsjVCUKTFzOLxqaomKaogm/gEovfV4jsc9sdY6?=
 =?us-ascii?Q?YPiZNMCzZ04uaLYFPtpD7W3WPbe+gpCEreoRlLNf+j3VPfWjz3cXntUHIXgC?=
 =?us-ascii?Q?dePbk1Q4pFAcRNb8lD5Aa+f755zFOcSto6luWkIU5ziNVa2IPvqjQ0MzuEwu?=
 =?us-ascii?Q?vMSrlQYZkoXBgS4wywT+bTlnPVfH3nEQttL6UuvJ83AHGY83Wyg0Et94WZbY?=
 =?us-ascii?Q?smWDLikC3aB8ejHaQFbJDuXtZwPhF8SHhprv4LATtiq9c9yhJ7QSR1F+9PYF?=
 =?us-ascii?Q?TSZkZJAGnNrQ5UEb9+geYQefrcioncuQk5JohffQniFxXLvW25gPyfDdjsRx?=
 =?us-ascii?Q?25TYo5aHTuz6cy7MrbgLNcEyDkzl2Mwh6p8zVSTtH77X+YWWDRmdJkFDCcsX?=
 =?us-ascii?Q?7ibCOtN1DJt5eoAZdqvlccyxMUgPrbgv9oY/GQSVVaS/UH3vbBewnCRreCF3?=
 =?us-ascii?Q?vEB0zItNgkaTD4gMKaBQUwkLIIAaj2JC3InTPwh4a2pMcjWuEXGgIt8ylZZB?=
 =?us-ascii?Q?u8KO0KVH4aIz5x3zq4XH5X2yiePkgM6VVMbiryiPb2GqafWsE4YdqRKpmBsS?=
 =?us-ascii?Q?eR8+svwHSOWEbnCYCZPITtZCPlehdPrMemhxg/cvDxfkuJ1ihyO3HR+/YoqQ?=
 =?us-ascii?Q?wOuXY4E1UEP/+/wkPZnYs7o0L8o7QWYK91ZB8otPaoNwnWVmmZyH3VQJmpfh?=
 =?us-ascii?Q?dxmSbsV/Vipe02huwbjrs5P4u0GeoWNThj3QA1GW3k5fg+ZfHTh6V3SjAOri?=
 =?us-ascii?Q?8kSD0TyFm0A/CCfAK9DVgWAn2wCkCeeQ5nrv/l28TCsOFEIePzgJ0BUA96E/?=
 =?us-ascii?Q?KdYG3tqVPlb1+aeSaNWz2alfQFeKAglxlNSS9zOYmJiGJD+sj+0XpXRxEkvB?=
 =?us-ascii?Q?nzIBotqmhZe+1kMN7DpJXE0GdFkn/xeAtDeYSmfltXjuS175EVA9q8jUEO+i?=
 =?us-ascii?Q?FCPYU19QXg0qHkt+q6g3GxPxQfZzrDCWjUqcAZ/4W88CsfZAmxX87uugLZDg?=
 =?us-ascii?Q?8mrfGjB+3YgfDbBs+Uvu711nUWYlL+bHU612AIKTMNyxpXVhMOaoVlb1K5qz?=
 =?us-ascii?Q?N+v2Ygy6W2RWXbJzemzeZWmIxzE2ID2TwUlN/vx9BiLVCxGx/4EfFpDJ4jbH?=
 =?us-ascii?Q?kp9LjqQjo5ePyQibzY9RNhFTt9wbrvkg0VvBbPW9OcGSYXij/7cZP10k+hKB?=
 =?us-ascii?Q?kgBFsXuWuHmR9S/JnXcDSieNbu0So53TvdzwWsP3zIXYVoSpZMcVPRnnT4oZ?=
 =?us-ascii?Q?NSxkS2eO/unFNdQhRhYEWgURxBknIY9r5MLYerT90IpWeaHpy6hCModt0C1e?=
 =?us-ascii?Q?PZqjOYD1e24WhCBHOuFSNkrZR/6ahUHLBtWjvLWKkL0DRJl9YNEgxY7ZSmEO?=
 =?us-ascii?Q?90oZ3E6N4YNmDCRNgAh0nzWa47FW0oTfaQM2R3802W5tlNyxXK7YQS1MB01R?=
 =?us-ascii?Q?i4Yq0peHjQ1rqdpb6RPBhhDyTnHhSgAuLB/dBPgaQ3i/Gi8IlFTNKHqUg6+8?=
 =?us-ascii?Q?EX+cnQ7l9TJwYoF9qU2xZRQ1lxwUhtz1tmn0Vh/hi7LjsQ5D0wC8jAgiP/As?=
 =?us-ascii?Q?aajV7UGhTJ41FfG6UUN9MlhCkjkiOa5uzAKBiSqi4/8S9MCJcboVax2k3SI+?=
 =?us-ascii?Q?77j0Pg=3D=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66ae3126-4971-45b6-5d38-08d9d5475b94
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 21:14:30.6885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CEsbKtfTUGu38Es7y+I02+TiPFBqjoELjtk6zHUmK4wuMzWaRJHj7KI60dSWehtQ/VmrPsdyqQZeP79qh5ENHmUmoIgfFjDrXqGgO/x/ROk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB9218
X-Proofpoint-ORIG-GUID: uAmRV42trP7I_xqj2aoKvOwfLBw_uwz3
X-Proofpoint-GUID: uAmRV42trP7I_xqj2aoKvOwfLBw_uwz3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-11_04,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 suspectscore=0 adultscore=0 clxscore=1015 phishscore=0
 mlxlogscore=888 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201110110
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The check for the number of available TX ring slots was off by 1 since a
slot is required for the skb header as well as each fragment. This could
result in overwriting a TX ring slot that was still in use.

Fixes: 8a3b7a252dca9 ("drivers/net/ethernet/xilinx: added Xilinx AXI Ethernet driver")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index ee8d656200b8..c5d214abd4d5 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -747,7 +747,7 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	num_frag = skb_shinfo(skb)->nr_frags;
 	cur_p = &lp->tx_bd_v[lp->tx_bd_tail];
 
-	if (axienet_check_tx_bd_space(lp, num_frag)) {
+	if (axienet_check_tx_bd_space(lp, num_frag + 1)) {
 		if (netif_queue_stopped(ndev))
 			return NETDEV_TX_BUSY;
 
@@ -757,7 +757,7 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 		smp_mb();
 
 		/* Space might have just been freed - check again */
-		if (axienet_check_tx_bd_space(lp, num_frag))
+		if (axienet_check_tx_bd_space(lp, num_frag + 1))
 			return NETDEV_TX_BUSY;
 
 		netif_wake_queue(ndev);
-- 
2.31.1


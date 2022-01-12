Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34ABA48C9EE
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 18:39:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244240AbiALRiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 12:38:46 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:26337 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241185AbiALRi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 12:38:26 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20CE6nAw020453;
        Wed, 12 Jan 2022 12:38:04 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2051.outbound.protection.outlook.com [104.47.60.51])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dj0fcg53p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jan 2022 12:38:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y4IZBq8jJQ0IWxB0LrO3ppilBCS51wt2fzT6WYh5+yV5cASd7O1fIC9V0RZ4f24dL0hWMJ/dOW0wO4RlLtYK8zIQAALAyeOZ91pptNmos6lGKCZ7NF5IZ0XsFnFmMq5106UB/gI920kEvS+1P5cSb7U9byh3T0G0RlIuIg1XoFpUciSR7mh7r9A989z2DrVUUNGpLpQ5c/SRhCnadZyst9UZ+wcAGtNzyJF7NW0Q0uxjIu4kwfVVm2TVldlXBnccIUW29AEzVzlaI/pCAh0A5oVwjb9LTPFAgRXvSdLDqbE/fRjImw6kxhbGGYdlygugmkBkOks1b4xtM8+mEQluPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3maKHlNnvSWV4s8RF71FZUrR7rUC6v0MJp7HOwqTX7U=;
 b=YxAHFXTKSfYNugrnOYdQeBMDGR1gscQvvv1E9zOvRnZs9e+N7b+i8/XP/fEtZKzX7yHFpel0QPMZatBPRyZL2kT9eOvTdpPyDlPLcDIQJWSTM0gbpWl2U3fa4fusT/mBj570vnxa8AGpToNEiCT4jRf9VAimpF7JBidYtGbLLTHdc12dLpDu0V3dYlbB0T2wD3NfenJmgjh1NRu1WeP3WkrjMKscijaHKNYPgy7LP5jSphaw2ZIs+FOE2KWpFXGTcVuMTjyphNEh9tw8weGvzs9+3D7DltIT/tkNkxkVRqprB/KM3XswMpi+EY3M9jjtY8tUmreRilnuUHufqUXtgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3maKHlNnvSWV4s8RF71FZUrR7rUC6v0MJp7HOwqTX7U=;
 b=VLhWmA9JbPy+B3OJnc4tkJFQ2DYWZnkb5VzMmxZHuNb2N+43zca3j+gq3OM35RDBJPzUukANurbQNe2XMvuNcC4O9w9hVEzhOjvY0Q7SiWGf3nxD86SwMSOwZA52B9R2yn4d+rejVhGPYsKxXEyfx8Bas4btH54lQd3KczdD8ak=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YTBPR01MB3424.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:1a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Wed, 12 Jan
 2022 17:38:02 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.010; Wed, 12 Jan 2022
 17:38:02 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, linux-arm-kernel@lists.infradead.org,
        michal.simek@xilinx.com, ariane.keller@tik.ee.ethz.ch,
        daniel@iogearbox.net, Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net v2 7/9] net: axienet: fix number of TX ring slots for available check
Date:   Wed, 12 Jan 2022 11:36:58 -0600
Message-Id: <20220112173700.873002-8-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220112173700.873002-1-robert.hancock@calian.com>
References: <20220112173700.873002-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CO2PR05CA0061.namprd05.prod.outlook.com
 (2603:10b6:102:2::29) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc849574-ff67-4b35-6094-08d9d5f24885
X-MS-TrafficTypeDiagnostic: YTBPR01MB3424:EE_
X-Microsoft-Antispam-PRVS: <YTBPR01MB34249497D8E080A6EC0AC651EC529@YTBPR01MB3424.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZtiSoB3YgPBzr8e6l5UmsP5dyRc69Fuetu3nib7YaWo5wQCoqCa1zflmmNysUvPapF6qmkkDCOtwDlMuoTIw7uDtBnv/xHpa5XDzxLv2K6b0UBo4dzDYwarksHt3OixM4XBDTULN3pQqLgeMftW4T7vFlogFBSWvRigg43iZ3yvtQOj8F+GbIRm9H4sehdN8aZnp89OoJs3s3N+Y56rplHxHvinb8312MQ4xz4INMBc7n7OGhi71MurXA4O3Aw/e4Ct2D4+GO2x1AoNQhBy1Aj45XKTXr1/nNhZucMGAvWwA92GUE8OLWY9ow7f0byJTzBx363Glc08NkA6cW9esnoi2fTqLHRvewxIMxPW4qATicb9PZ+a9zmksX1PsZehmDPKZzcErJRQD80CCzOAvGIcswNUso6fG7yJvZnw7S9i/ky2dUzWoO6EX/thA5seA3c1gk3LWjJ5e5FMRu7ZBQjHjjVZ8NNU1aQ5yIGZv6MEZovC8mo9Pb4q2+dmIffFzoYri2rHRz8InP+klC5qA7WLnF42mv/d6xikegWGeB8Y1ZvWc/peOgplHLU7BhAePdCi4P+UpMjitRTCe3dZST1MFM0QFfwyhFGFGeZ+Inyi/MHahSQ9G17LfIUPincXe/hWYSkf1lk+1v4DFtakDZb9u3OS79Z1I9yfMTXn3WUub9kvjLd+yj37wCRn4z7qsFTJqRZW/tbRxXMlbymA4TA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(6486002)(6666004)(107886003)(186003)(66476007)(44832011)(38100700002)(26005)(52116002)(6506007)(6916009)(8676002)(508600001)(66556008)(83380400001)(8936002)(6512007)(86362001)(38350700002)(2906002)(4326008)(1076003)(316002)(5660300002)(66946007)(2616005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6TRcLu2fisTvPqeQWRpRbYkmuy6NJZ5ScUU5+6FQmKkSNfFb/zq1PK7z+87D?=
 =?us-ascii?Q?OJzoHSY804LiZEG/6KPFww7rtsAPU2VX6BORyfLxwhFkl+B5MIoC2APXzTfM?=
 =?us-ascii?Q?GPhuITuf1kVYW72ZbomGkhboSc/6I1HafUKPFxWkAKmrnqOU9HDL1L0VlYit?=
 =?us-ascii?Q?AOnTS9qBBa8CJACUkK1oYrrNvH46M180rPXxwoApyQkk5MgjbAsD13C5JAQr?=
 =?us-ascii?Q?DDYbtCB9kaXMkAfhE7wL1wzCm8wAmUoa+h4cNwxEHho9lviHTegSws/xSABa?=
 =?us-ascii?Q?Bjtf6L5BNffJKwrYX4RhU165kVXwGLEQmJDdlU2dIJCyvcrOwMOYAYCquMaH?=
 =?us-ascii?Q?tv8S19wepyOYRiL5+QhJDOr/QIXSYfj3CtAuKT89Wdvd8AC2ziBE0iKzQFa1?=
 =?us-ascii?Q?pOXPozQoZnw7wyW9iJMvaq3UxANasOCRvB4Fk1Mp/DRWjSIlwFGhfRNAZuJK?=
 =?us-ascii?Q?kMpiE1mCP5K9YWMDl2lj1Cm9r1wCjqIKgQ2X5iKsOGfblPdFuj1HWBX/DZTa?=
 =?us-ascii?Q?I0LuDWn0TPgEStm7vvtjMrXykrrYzxBHm4Ft/moww7va5f7m7BY0n5jSQVcl?=
 =?us-ascii?Q?WGy3Fs1jR53ILIEozCNKtvgM66eJ0wg7XNUTIHvV7POjevKSezXW2AXDal5i?=
 =?us-ascii?Q?wBqTSqtOfVo0UVrNt3LBc92WsmMsJH/27/gdlbUU/0URwqynVIHeupulHRl/?=
 =?us-ascii?Q?8Bfi+zAkqNmGaDKeHKchJhiAIn0JErYuEP4BlIW3mKXtS1HKiLMQ1fI04baE?=
 =?us-ascii?Q?fqeCP0R6mjPsSSwRdZ7H5yNr2M2VIVn+0etOhm22NZMJPtq7GKG+t+fesv1A?=
 =?us-ascii?Q?vaXshneVnI+qXBPfPwE9NWfVfbgvu8MjbPMoi4et27pryBU0OL3liv/W1DbX?=
 =?us-ascii?Q?e1TdKSUIrba9OiyHTuJASj6UFY1HQ1ugjDhYn4WljT5TFIZsH0TYS917OM7Q?=
 =?us-ascii?Q?vgcwtrdatgQ5+xDwYmLNJpXikX5HPxoSOkRuUc4PqVsmBd5+wC3WiKyP/sHm?=
 =?us-ascii?Q?mW6H1jJ+DK3IybMW3scYsgVXWaNoN1UDUHnpPDyROZwW2A93vnVo5YtMMS1J?=
 =?us-ascii?Q?Uek2s8fbX48BIRnbmObaC8tG+jTFFGonsbWDlFs9PiGvinvwAC04dVfazoPp?=
 =?us-ascii?Q?wNJzTS0ubHP78xNHkrqd9y4KpOg+RIJnfcrU3CCb5IWr/GrrVfsDm9b/f+K+?=
 =?us-ascii?Q?fB6T/oUwme9obCJC+eobd2Yf8fOEXhBH84kX3nHHBRlyZeHafD/ewBqehtQ7?=
 =?us-ascii?Q?AamqCr9y4n+8K3eJxIprIMKfgSJOBG3HGPmzMVLvz6M8feSy6jGsubuUYqup?=
 =?us-ascii?Q?Su2NK8X9H8HDHsnIavlhYvV3pGuoVO1JCsEFmumhmrnIM5r4Owu/qOl0PxYi?=
 =?us-ascii?Q?B1inOKrK3nMF2i0und196lE79mGOWJ1kcBgDSBnAth4DeezuEMlQtvVtQs9H?=
 =?us-ascii?Q?+jkNp51IYjz4rA0hYw0rri1k5/P860LFnHpGYyZ53hJHIchsu+cJoj4/z6nX?=
 =?us-ascii?Q?t67X567fUMWnFS3N2j7izpdK2g5yndxNXTMRpqfIyqbnKmcYiQcBjq1RCHN0?=
 =?us-ascii?Q?WScxs3TURrA65k9fLUJOEbcmsfyME3RsnS20KytbJi1kLFQmmvc5i7bqp1Gl?=
 =?us-ascii?Q?871yGDFUzxJ4IWafhpprNcfPIuQH17MB2RvGpfu5EtVyIB9v51mCKVrt8NK2?=
 =?us-ascii?Q?gEp3LkL0Da4WZAoXShbqfD6Ovzo=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc849574-ff67-4b35-6094-08d9d5f24885
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2022 17:38:02.6075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6xxmd+Lt49NS6hBtAvjcglyX+SpS11pqdZricmKTEU29+WdbxEzMK6wCm1b4W0VZ8qvau95rr1Gep1d1iNpfo7SgtCVzU5EXBYS4hJgLI4E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTBPR01MB3424
X-Proofpoint-GUID: r_HUvlY7L_r2W2u3QmALDzzyrJW_TA-Q
X-Proofpoint-ORIG-GUID: r_HUvlY7L_r2W2u3QmALDzzyrJW_TA-Q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-12_05,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=915 spamscore=0
 mlxscore=0 adultscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0
 suspectscore=0 impostorscore=0 priorityscore=1501 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201120107
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


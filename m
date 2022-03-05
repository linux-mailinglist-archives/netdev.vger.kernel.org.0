Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B06B4CE175
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 01:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbiCEAZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 19:25:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbiCEAZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 19:25:01 -0500
Received: from mx0d-0054df01.pphosted.com (mx0d-0054df01.pphosted.com [67.231.150.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F23CF7EA04
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 16:24:12 -0800 (PST)
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 224NrapK009166;
        Fri, 4 Mar 2022 19:23:49 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2050.outbound.protection.outlook.com [104.47.61.50])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3ek4hy8phe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 19:23:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DMb8m+ij5mW3dujYX7qzcCJji8G8YYxar19GqlDPpJvR/si7yr4bh4ReiR0vpJiiM+hrCaDXyjce6YEc1XSUbPHsntHk/Mr/BXkejyegQDbv2luLJ6UtRR93LkkcdXWEikHanzyrGcvpfV+KscadOT8PzTDktr72/Y3WUr/Cpub482RCKR/Z7ak7Y+aTexnVH7YtJYuBy8x6oQyPp8OY70xyoEb+gvWI5vY2nyI0Zx4aPBkoEl3d2o1dpNa5QqyHeydEByIhT1x2B6asTHTuz/xTuh7SVwLeTkGXqLklZRS8Mdnu2BImd0KOEAMR5jaOmPiLChcNs4EZT3i/jz6N/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yUCq2UikCIWxBI73BK0upvu2ClQMceTulwcjfUe1u8o=;
 b=NTOD8kQ71hqgy8sbsqiSElIml6OJR09XR+uhG2mPuDzc+O9yAPxdNmfr5D+fDz4QGtIgSs/71LlRjcYl2+c4p+N7xuM+eToV7jX00FzUSwZWI9zaAx4KLcT6dJ/B+37MA/aKgvUBId7/QUbUsKwJufYGXaC3Gaoi5JUpv7Z9zbkShmpg45n3lHuEWmfKB53u0eO9RtoaXmS4NHu09fwKeYebSygdxYxqeusczqUBJ8gu/YjkB2FU8a9IkrPfGjL4+x1AvioCzlnlxBS94d0Cyke0NkZ4A39fwWQxIiez9VZgr7NQ3Ems1+QZ5S3zPpRF+e0DVLH/tm1WD0Of+HlZjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yUCq2UikCIWxBI73BK0upvu2ClQMceTulwcjfUe1u8o=;
 b=ar02D1vZfntbBVXTbsbQYvNmsZWqqAYTXH6yTl4K/zXOo9s1MtcXkbAjU+x+R9Ff3T2W+Au/rneyqx2h+DOU8wCC9Ym+BY14IAHYFDARYXHsIqALqdBKR03SerBFWCym7hqd5ASZXAzmkIrizxyVOnkBLPtR/Jht2emjj5Ls49o=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YQXPR01MB3701.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c00:4f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Sat, 5 Mar
 2022 00:23:48 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230%7]) with mapi id 15.20.5038.017; Sat, 5 Mar 2022
 00:23:48 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, michal.simek@xilinx.com, linux@armlinux.org.uk,
        daniel@iogearbox.net, linux-arm-kernel@lists.infradead.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v2 6/7] net: axienet: reduce default RX interrupt threshold to 1
Date:   Fri,  4 Mar 2022 18:23:04 -0600
Message-Id: <20220305002305.1710462-7-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220305002305.1710462-1-robert.hancock@calian.com>
References: <20220305002305.1710462-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR1401CA0011.namprd14.prod.outlook.com
 (2603:10b6:301:4b::21) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 02724da5-8119-40c4-b332-08d9fe3e6a80
X-MS-TrafficTypeDiagnostic: YQXPR01MB3701:EE_
X-Microsoft-Antispam-PRVS: <YQXPR01MB37017905A3B1641D0FC08C7CEC069@YQXPR01MB3701.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ktUvj4vvU2eQQPElOY6sNei7iy1+RZeKIPT0ZHnCtOQvJnlyxMPPHaazDDLlW1Ev/2VhUs+HTjw41VKfyXJVgPLtYkpepUeYaMaa7qjSuUficRicPXy+woQ9mZH1MjqZ6s/K1M4oj7G7Vxzz0Lc/iykw2DmtkJRCaOaeg9OWBCDDxOM7NazJuvC2LDyinIMB0YEzcyFszggTPgBQ5vb48N2XY1C1CzxVkuRddeGOZDXLVeqFv23o4GHyDWY2XtHdGPfFp3ZT4xIo/ScGipo2JrHpfIgR6soJH5s2RkuDp7oCE7UwDQVZ/cLfpHXikcQNAp8y7z3+fWJTSTKOq9rqiQiaUjKyqhpfhdnnfl37r4rlyd02XFqwUezX/C9axUSNtCxlHpaJ2KTLgW12RRLnrqPbMJ2DU2FnDatv9xRAUmwQjblBzifUgunkTOGIUfsMp2gKD0PCX2n+ZpyVNXQR/zIQ76KM1rdU8lv+ZeIQZhmlcD3IIg6g9+F3rCPUf1cygssbyOoQ/waOzNkQBHenZb72JM8EAYd2PCT3v1Xtw7Cbd4XsNNxFQLOnuRFvi3htUiF3lfRheCv1OJUpNoOQN9GyYL7rvA4SWC38nfX+qoM0Q56SidGHboDMb+qaw2t6h4LICgeanozeMWuFeGG8wWJrfYGCgARiXQZlUny55leWJhJPVhwBfRKjN/1YqESw+bv7Ujnu2j41ZDan5T+2qg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(2616005)(6512007)(5660300002)(52116002)(44832011)(6506007)(6916009)(2906002)(83380400001)(186003)(26005)(107886003)(8936002)(36756003)(1076003)(316002)(6666004)(38350700002)(38100700002)(66946007)(66556008)(508600001)(8676002)(66476007)(4326008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XgGvkSxdR3iVSt5qzPwB1VY6HOOY/cBc1g250BJlTNs4XXXHgI351CH0VOfD?=
 =?us-ascii?Q?xW9irWsyuyFz0emX18RTBh5h2Ii6uENgBSqXcZucbCZwwDAtgNalCM33TSoW?=
 =?us-ascii?Q?eCMSsAyNKj77yj9DzurZ2Rc+8Vd12YzP/uutYg21MVu/ohDaAc+KeD456tkX?=
 =?us-ascii?Q?6hDKKDpzzhHk5VKeZflxpsZXbmKKmY6RP6l8DeGf2Lsm56cixAQdmnLlQ405?=
 =?us-ascii?Q?0GFGUkX75ihTqMdSv0L9PTB40FyzezbcU8lEYzvslq5xl6SHTRUuLpQfQgbh?=
 =?us-ascii?Q?rkY67ycu10rDEAdtR5mR1G9c9IYII6yku6xiUpOB3e8TCUXD48x3YOuKi/rN?=
 =?us-ascii?Q?1fLbgdayFOqFOI+fxiS6cCBzFRupzvEjmAiD++0g5E5U8fphs92Z+9CjBrzW?=
 =?us-ascii?Q?gfOMFwDXG5JNI2kNBqRc8ZtIXHqmIX/zb4+4kk2aXJJuVeIXrX11c34gV9cd?=
 =?us-ascii?Q?BUeH/7VOc5+g/eeFBx2DB2blFp3wGTZ/tm5nKbCA6gwHZ5exb4y8d7EkPmPG?=
 =?us-ascii?Q?Tp7TQGNX01J8q++U58GyfEamogDSFD4hMN0kBw8MyuG/7Sx+RtUWA6DFTpBz?=
 =?us-ascii?Q?yjvz+ULiYXe0Lr16W2g90W43UxvaBWBY9NKvXuVNxYnSU+pR5E6If52gYzfI?=
 =?us-ascii?Q?08p3aIY6I7t2106VswkOlIl91BSjvBA/Y4nmHuitGjVd34bERSjVuSTYs8i4?=
 =?us-ascii?Q?xFCMGs5sT+UruT5oS0q3nXFgdwzlSfLbIcIFLMMZV3PrPcDN2aFhWCiWCcAw?=
 =?us-ascii?Q?6SFpv6bNTVMr6QRA/JIQt8JsKLDXJEtEAB46qvnhCWamthU51PSZiI6/vEOy?=
 =?us-ascii?Q?Go5wSRFYQrIqF/Wake9T2gCkrEN+j9St5vPg1GMrWd1UN4n/NwNrOVTZgYAd?=
 =?us-ascii?Q?7CTKclddlafIOBykxp7DGypN+vNR1wmVZNYnGizEhkELNET1VxmpJCP//4aq?=
 =?us-ascii?Q?innbkNBGtgfxxCwpjCTWeZtEqqfzXlxD6BX/d189GSQB5+LgKoPbdSSO4h+7?=
 =?us-ascii?Q?Yo9c9mzqTeSFzkOHuLYCqSTT9XfnJc4ESUwp1D89yQLO3O+32jM4sdXzrwGQ?=
 =?us-ascii?Q?kdsCfpvlXahzQs5c/faUTK2oPVvfyzCBgnXxkZEPIJZFFHObfL7Hsm79yxC0?=
 =?us-ascii?Q?edeB4LMI5j09bw+eKBeIfbQ5DszgwuVXMT6XuWV2pMnR1hMj+lqReMovJjJV?=
 =?us-ascii?Q?EsTqX/3UZZKFb9095R39Gnt2k20apgYX4gUaMR50hQ5dP2xLsQ6/xTJzQTve?=
 =?us-ascii?Q?86KY4VJAfCIQY2wjvoRnH6OayDnan44wurKOhZKVP1r1cXiHvasafZdWhNdM?=
 =?us-ascii?Q?5Hiba5idL0nzMnITU3WuwQQpXjVIW5nxC4sVVpLt5hcZuVkKJuH4rv8bBizy?=
 =?us-ascii?Q?dUSLORiJqoy6dqVxJ9stSzhdo2l3KQUJuZ1+b/pn4eibQkC4Hmg1T8p81we2?=
 =?us-ascii?Q?ZGTrJQ7ZHM7d8sftMvaM7XjrQchZfKNPvUyPN5LB8FEDuGZJeKMfghGmTb7O?=
 =?us-ascii?Q?z5nzlbOqeHkJimBgRMfbFMeZ1Kh/aQx+sRPAv0Q0qsnfrUCRWq14bHFK1wrD?=
 =?us-ascii?Q?fE7n179fzIiN8pUv7cZhZHlUOORYql3lJam00EGPv8PKCZXLgUSlDeHTF6U+?=
 =?us-ascii?Q?c3NnTxue9hogGVwlafFAiYaW7tUvHC6yRMnZmrwYSRzsO23ihUzunIYKJeSq?=
 =?us-ascii?Q?WGiCy7mu2FT0yvJDdHmRwDHA/ZM=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02724da5-8119-40c4-b332-08d9fe3e6a80
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2022 00:23:48.1019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b8O4QC0N+y2EelJUMWP4uTv04sjG9jxiAT1L5cfFrQxOXcc4yH6UnEhRizn+xR0xYZIaNGVu17TykejHJskMECnv8EakKIEEuU4PuCXI5do=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQXPR01MB3701
X-Proofpoint-ORIG-GUID: HgoZzkMB6sU-6VLqlEyRDrmWXU22_CZw
X-Proofpoint-GUID: HgoZzkMB6sU-6VLqlEyRDrmWXU22_CZw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-04_09,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=6 lowpriorityscore=0
 bulkscore=0 mlxscore=6 malwarescore=0 impostorscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 mlxlogscore=123 phishscore=0
 suspectscore=0 spamscore=6 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203040121
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that NAPI has been implemented, the hardware interrupt mitigation
mechanism is not needed to avoid excessive interrupt load in most cases.
Reduce the default RX interrupt threshold to 1 to reduce introduced
latency. This can be increased with ethtool if desired if some applications
still want to reduce interrupts.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index c771827587b3..6f0f13b4fb1a 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -122,7 +122,7 @@
 /* Default TX/RX Threshold and waitbound values for SGDMA mode */
 #define XAXIDMA_DFT_TX_THRESHOLD	24
 #define XAXIDMA_DFT_TX_WAITBOUND	254
-#define XAXIDMA_DFT_RX_THRESHOLD	24
+#define XAXIDMA_DFT_RX_THRESHOLD	1
 #define XAXIDMA_DFT_RX_WAITBOUND	254
 
 #define XAXIDMA_BD_CTRL_TXSOF_MASK	0x08000000 /* First tx packet */
-- 
2.31.1


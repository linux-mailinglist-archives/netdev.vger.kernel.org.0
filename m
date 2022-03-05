Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3BB84CE176
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 01:24:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbiCEAZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 19:25:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiCEAZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 19:25:01 -0500
Received: from mx0c-0054df01.pphosted.com (mx0c-0054df01.pphosted.com [67.231.159.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01B387EA1A
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 16:24:12 -0800 (PST)
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 224M4Hd1004102;
        Fri, 4 Mar 2022 19:23:46 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2056.outbound.protection.outlook.com [104.47.61.56])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3ek4hw0xyy-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 19:23:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LhDmTRSkz1Rz2mXOO/LtV5zsDjiSr/paStVFHReM6BGE8b+bsJQyGmHWugvVP6iwzyjjl9HhklqzXpVisDv1AQ4tagCRPgXOhtabuznre9AAhjTdv9RD7lVPzksVmB0DY75MWpdtRqMT8RgsZ9cC6p+G6obGj4IqT8t9fcp2lcYuU7soS5y+KlwZUp2imY+d0jvIAQWLbmhciPFYMp7nP/bkz6cWEgtreMWDKKQV+D1+C50m/v2nLZrdhRYvrVi97HBrbtRWZ1F0Fs6jto1gxYObcM1Y3bPHtgNuoFcQEYPd51VNKxZOt2zXXUMdAOyJ0Q0TgDVF0kKn87Zbhx3/jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LmGF+PECeuzxRb/Bym8EaMgnscDUXKqiVlYkBMd5pHc=;
 b=kdsZtoFURMDyE4oAyM2fcHGdGWT+KLv1w70LRYgO+RYYVOETuh65kqfW3QqtTlCLygC9MNjnYTd1LGdU9lJ55XIghgHGrnj86pFEczMbA6cgztHm+jnqcwz/dPdD4lPdoI/1R1Hov613hGbJfgRpvrbzQbCdRLr5UXLNxZg6hva3z/HzXZpNHmKokDXI+auU7hG7rKizPunHwr6Z9vhffy2X6gCGGoC+nJDOU2WPCAlc4AbRlp99xAAQp7OjxlKo4IkOj+aNh+27zqGRcjic2wdBUb5KrQKgO50RKYYOzy5Wu2V9CtM8Bs9Ovzw3LXC1cU0xDozEjvIC5QNR/eIFmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LmGF+PECeuzxRb/Bym8EaMgnscDUXKqiVlYkBMd5pHc=;
 b=t79iGvKljn+RqQeJgtnE5Xli2tjVCkCIQ6CVUIwjKx3PqAWbw2QBgHW9nMWOq7aHA0NDcUJpHHDZ6Ot0JTPweC/pzcBicD9r9dQUAlGU3xt1QjBjIkbtYVDL+Ntc0oHNZULlCfxgiFxs1OGLJiz8VKhXFSEVnzQzAwWD6rF9ecg=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YQXPR01MB3701.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c00:4f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Sat, 5 Mar
 2022 00:23:44 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230%7]) with mapi id 15.20.5038.017; Sat, 5 Mar 2022
 00:23:44 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, michal.simek@xilinx.com, linux@armlinux.org.uk,
        daniel@iogearbox.net, linux-arm-kernel@lists.infradead.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v2 4/7] net: axienet: don't set IRQ timer when IRQ delay not used
Date:   Fri,  4 Mar 2022 18:23:02 -0600
Message-Id: <20220305002305.1710462-5-robert.hancock@calian.com>
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
X-MS-Office365-Filtering-Correlation-Id: aff40564-7087-413a-9ff8-08d9fe3e6852
X-MS-TrafficTypeDiagnostic: YQXPR01MB3701:EE_
X-Microsoft-Antispam-PRVS: <YQXPR01MB37014D3F2FD53E68D1DBDB14EC069@YQXPR01MB3701.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4fNr1N4EZs9Qe49ogXL0KlwzZK54BdnQUvQ6V2u1T0kwTNbnJkW1Xq3+r/QOy8rlK/V1nUUYeCe5ZXwWrUrT8AD1VQy9DhbSV0z8ydifP+CQ7z0wklPuqsXHytfWMncGwEiEmKbL/9GDbC+3yFAYTt0XKQF5aKmIP35+lBb4wcmjpS4Qu7bnwoABIHX7zhjDu8EghjGYpa8hzG09WRdoG0nfYckXJu94ckcn1yH7saNvB0dvckSLuQRPte1tfRnudsA6u/qNfHEfRm5kO9oyowJTgiJTcEMAwrVrAxfb/zZ5fX34QOO8KOQ2QoJpGfXYLI37lJ0yjxUBYZU857HqmTirCeTK838ashMghy/J5lF6Q866vEDwk3JLonFOCZQk41a1Yte2OUpWHzl82Wop97bCMTbhciHcOyIeDKZCnbxuW5ev4gXmG9ufzWSgCkcKGzFsAu6GrAcYUmI3g+r3CTU+natXZPRi3UqTD1uojDakEEFI/dLEBwL3rwZF3YIvVaBMfulM76ar96N/hv03PV00wn2WTQKD0mYY1q7KEpQHSfFV81NCczoYkWPr3ox5PnRK3jC14eS059GdSxTDpxQvLnhq6i0sZw+aO9R2CzkZJurVMhSpPUQ4kTwY43XI/iVgErFEnSQ9xIPboVwrVDezbngbQlTrPkPEQpp5/yeVBYz7Qe0XU6wmJmHbvQh4LfBierYHVFe/PAvEyIhACA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(2616005)(6512007)(5660300002)(52116002)(44832011)(6506007)(6916009)(2906002)(83380400001)(186003)(26005)(107886003)(8936002)(36756003)(1076003)(316002)(6666004)(38350700002)(38100700002)(66946007)(66556008)(508600001)(8676002)(66476007)(4326008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ldmACn6VFzgx+53+Zs+wpe+FOpj1wapKOkSWhmYJJkIOnR5aY9a3mfoIEoZr?=
 =?us-ascii?Q?n0wsx1WhirfyJcCCBnU/R83/Yr7WfILuCYmVGq4fQq/Hn+XAryrWbIaE91YG?=
 =?us-ascii?Q?UDV0fsZiqCmUZoggAlX1DE1TigrUGSENK6hAx8zBDa8FtBj4zRCzb0rwpb4Q?=
 =?us-ascii?Q?caj7cAomdK6xgWLDCWnQyI6/KW7JyK4MkzE5u8ZcJBxWrHA6d7El7Ka18F7g?=
 =?us-ascii?Q?E+XaN/8OvETQnsJFV2603uyrf8S87jTBivtppQA1dEHMmYTNEdC6OGvHWUwm?=
 =?us-ascii?Q?NzRajpfT0y7Mq3eg89LiFYyypWhXoQDeiIpxOt3XlENOSS9kt6rdb2+uTbhW?=
 =?us-ascii?Q?i7g2udLcv1DWaLUrtXoL3pJ59B1Wp1eh1OgNJinR8BeSWR7bVMJ3WcVaVc0R?=
 =?us-ascii?Q?YTB+ryiL3O9KaMgDrfwVoN7dBvI99QmucVXuyBwQV4aj1EuBL64Yqw0jizS8?=
 =?us-ascii?Q?MPMoTF2nsSgIOJEcjqiYudVEIKuTCBZ+4TaVvTfhMgTwWzEj19zU7XZAfKqx?=
 =?us-ascii?Q?wJ85V27rsiGWNLCkuOQp7rzRjosQfi5hTdTTc+nXXsaJ/GaPeAtTGwWvXjde?=
 =?us-ascii?Q?Rf2e7vArYlojDCF+gkpacb8Ieflc4pyxH4dR+XMwp2MR8nkMff3h/fWy/xOb?=
 =?us-ascii?Q?oIOwssci3eVs1FvrlOXSGJaxVOVSLNcWPnGQfZBaIKJ3j8PglFI+O9PcYViC?=
 =?us-ascii?Q?HSEDM6BznLxU/OCBzETddApcu+jR5pZD4kTUKXSlshwszs84QQeFO5HCN0KT?=
 =?us-ascii?Q?uGiJZgoR6irpONJ1fMymGR4wskOV7nAEGdB2Z1aY58ZoUmbrZR1ztJUYdAo5?=
 =?us-ascii?Q?vgYFe/Wyi/L/EPYzSt4ALxkCVY1n0aiZHodq4t19vlrgzxeAgwpgL66YKbrf?=
 =?us-ascii?Q?7nX/rZFTEuwW9T5cISFS+L/vEvnAP8VvHQ7b4Je2GSQ6ANFn5S3ORmbH1MN0?=
 =?us-ascii?Q?aUV31F1FDbqsLpSpn+ub0ZwHmrmadimsNCCWhX4HdK5m9F3B1Oeuee63FcMr?=
 =?us-ascii?Q?Pj/W09Lm3x4iKc4DFF9+8kgjQbzZs/Z5R5w9oXaNMJ7Av+h6E3+1dHBVhmKM?=
 =?us-ascii?Q?ditY7UDitXkBvA58GpK9ov/YuVNxgiymnvXY18CtJKfFHYKByFc5jfFDnuSZ?=
 =?us-ascii?Q?dNO9VvXSboFvWnmducBdBSw26dBD1OKFRuA+HLHO3+RjzSXq3zfuzESg/s6I?=
 =?us-ascii?Q?0cd07zI6rLKNmYuIuzzVzCRBPbl+upat+IVg2bPnkiY6w+B+pFoj4rZ1wtPb?=
 =?us-ascii?Q?qTfFaufBKmHE+nvCEdfbR7/FZcWmg/njfUFqOhjrZ8fXS4lddLS3Ts4HQ/CW?=
 =?us-ascii?Q?KzOKUylC83iTu7YLG52w9QApvPNT5ufkL+fclsNgoO54fVj+DAEEcZoH6MHf?=
 =?us-ascii?Q?sSUNMxo9YEKPspCT5ECFEnz6QtQi5SmzlyrN2mdDQgi05FWPXSldqCja5t2r?=
 =?us-ascii?Q?ymGZkahJBEFQcdkyCXWTmHDjqmPtODF85z7nsRfpoxLiKW0hoARuY09A4vAo?=
 =?us-ascii?Q?xwq/owEdQZ4bQL76mnrm8rGZvPwZSjcaC9f9TJQccza2SS/crTCSkWhHxxKa?=
 =?us-ascii?Q?cPlKNRDK7S1QH83WB7tncZMBS/0Sv31QYITsDM/mbewY+1D0JMPEK/aJhBtC?=
 =?us-ascii?Q?oeNhaVAEeOkY+s6233v+CMG5RokcNBPG2jkIYzD529UFnylvzwlemDQb6zdC?=
 =?us-ascii?Q?6JC//Onm+rkxNg3G4hQsJKnIR/Y=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aff40564-7087-413a-9ff8-08d9fe3e6852
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2022 00:23:44.2402
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aMaNaRvZdQWovR9NHUalgn7Fh/3DB4y+n3zOS2Vnmu8WuftLZcWVuAC20OWlOEpFngGxBAhiqGp+8H6SPDi5OhB9iQG936LcDU+2atJsxRY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQXPR01MB3701
X-Proofpoint-GUID: ZyvsXpPTXZqIWsb0zIQDTsuZbY1sPbMC
X-Proofpoint-ORIG-GUID: ZyvsXpPTXZqIWsb0zIQDTsuZbY1sPbMC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-04_09,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 bulkscore=0 phishscore=0 mlxlogscore=836 lowpriorityscore=0 mlxscore=0
 impostorscore=0 spamscore=0 malwarescore=0 priorityscore=1501 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203040121
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the RX or TX coalesce count is set to 1, there's no point in
setting the delay timer value since an interrupt will already be raised
on every packet, and the delay interrupt just causes extra pointless
interrupts.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 .../net/ethernet/xilinx/xilinx_axienet_main.c  | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index d705b62c3958..b374800279e7 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -236,14 +236,24 @@ static void axienet_dma_start(struct axienet_local *lp)
 
 	/* Start updating the Rx channel control register */
 	rx_cr = (lp->coalesce_count_rx << XAXIDMA_COALESCE_SHIFT) |
-		(XAXIDMA_DFT_RX_WAITBOUND << XAXIDMA_DELAY_SHIFT) |
-		XAXIDMA_IRQ_ALL_MASK;
+		XAXIDMA_IRQ_IOC_MASK | XAXIDMA_IRQ_ERROR_MASK;
+	/* Only set interrupt delay timer if not generating an interrupt on
+	 * the first RX packet. Otherwise leave at 0 to disable delay interrupt.
+	 */
+	if (lp->coalesce_count_rx > 1)
+		rx_cr |= (XAXIDMA_DFT_RX_WAITBOUND << XAXIDMA_DELAY_SHIFT) |
+			 XAXIDMA_IRQ_DELAY_MASK;
 	axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, rx_cr);
 
 	/* Start updating the Tx channel control register */
 	tx_cr = (lp->coalesce_count_tx << XAXIDMA_COALESCE_SHIFT) |
-		(XAXIDMA_DFT_TX_WAITBOUND << XAXIDMA_DELAY_SHIFT) |
-		XAXIDMA_IRQ_ALL_MASK;
+		XAXIDMA_IRQ_IOC_MASK | XAXIDMA_IRQ_ERROR_MASK;
+	/* Only set interrupt delay timer if not generating an interrupt on
+	 * the first TX packet. Otherwise leave at 0 to disable delay interrupt.
+	 */
+	if (lp->coalesce_count_tx > 1)
+		tx_cr |= (XAXIDMA_DFT_TX_WAITBOUND << XAXIDMA_DELAY_SHIFT) |
+			 XAXIDMA_IRQ_DELAY_MASK;
 	axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, tx_cr);
 
 	/* Populate the tail pointer and bring the Rx Axi DMA engine out of
-- 
2.31.1


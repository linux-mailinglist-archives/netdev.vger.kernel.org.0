Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBDC64CE17C
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 01:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbiCEAZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 19:25:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbiCEAZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 19:25:05 -0500
Received: from mx0d-0054df01.pphosted.com (mx0d-0054df01.pphosted.com [67.231.150.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB38972E4
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 16:24:15 -0800 (PST)
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 224NrapJ009166;
        Fri, 4 Mar 2022 19:23:39 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2051.outbound.protection.outlook.com [104.47.61.51])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3ek4hy8phc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 19:23:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HIuJr3QGU7FFBppEVm0ozL7OsmgJRrSfCHUAamrZVEnay7A41APiaXaXlnMdhuYBpnHwAaMGzctScg1c18106shhl0/XTF8fMzz2NZWFG1mx3ysIcvdVdqEO/NuOodXiXegXvrePEvBBVq+rZlTEtx7G7z1fO9c2CPquBNcE/g4IKk4hSSG2eVARTfdhQTWA9n+3zOY6mnFXZrhtsgZlFfezvMTj5ssgKiqVaVLtaziG9es8rEx8GL/pgt2fWU2Y6GI5M8tJzMkuZIUwPmwELA1YdIZ7F3pOCcXT2Q79vvTeLIet6oTRHvWiJfr6B6QQCuoNoaFDunTEM8BY/uei6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EYP01KOTY28L26vzif+UYTz3fme+tlvPM0xXN9yQBv8=;
 b=LydrLgmtfo+3LTmisopLrPuXKilnsRdZ/dvY1ylrc/LxjJ9k462e5BDDQVSvfLetKeiHry7krZXMsMK/4R/k5A06/AnCFWLHlwkOl1BZkGHlInPBR+VpYyZ6RJKoRfZtFlwlA9D1deZSV1j7KkjHsoOCVYdeU6lHfP66gYjSKzHBdUe0PuHng5Nnc6DMFXMhZ6VMMSYNvjksjOCtX/K5LDYADsSdztuKCXMBQMdQ3Pdu6/gdQaH0k5I0cmbY/ZlgCKeVG29yNQIKmh0w2d8mwJyEssn5SKU/Cdi5IsayKMR4SJW4lJK1T8GFzOIrm/m2jR9uc2BieSvnXGj04sJIug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EYP01KOTY28L26vzif+UYTz3fme+tlvPM0xXN9yQBv8=;
 b=QUoyVHmL8eTb1TJZQJP9GcCy5gKPYflANu6gVbJHpU8QkNo2f3QA64ptrR5rVxkgeQlIXk+UUAE5szjAfmKQ5hO03NIxKzyeN3wWaV9ClpFIMFVkDim9JUCAqvSsxP+ETS8rrduRE8MOU9G3Jq+GG9Zl9a8ID1bDBNnaTCyXkss=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YQXPR01MB2758.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c00:45::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.17; Sat, 5 Mar
 2022 00:23:37 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230%7]) with mapi id 15.20.5038.017; Sat, 5 Mar 2022
 00:23:37 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, michal.simek@xilinx.com, linux@armlinux.org.uk,
        daniel@iogearbox.net, linux-arm-kernel@lists.infradead.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v2 0/7] NAPI/GRO support for axienet driver
Date:   Fri,  4 Mar 2022 18:22:58 -0600
Message-Id: <20220305002305.1710462-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR1401CA0011.namprd14.prod.outlook.com
 (2603:10b6:301:4b::21) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b71639d4-17a6-44a5-5c0b-08d9fe3e642d
X-MS-TrafficTypeDiagnostic: YQXPR01MB2758:EE_
X-Microsoft-Antispam-PRVS: <YQXPR01MB27580D96A29AF7C1D6F81752EC069@YQXPR01MB2758.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +OyMzjRRKQGG+5ts0XINxxXFpzLjWY+Utirqqk/8PzbtJww8S63BbivYvNBq2qHuVVTOQ9cgunerVVIdashqTiv5fJ8zuCM6r/r3duF/V4K4lvuUy8i16lvRQh/SL5XNz0F88/XVuBpBqhQryBoM3PcwdcenAvu8pLT9upYv9U3SjR5reTLWt1RLd8sfaX+RQteA4EOXpBj6auqDBvvJFqfsaqf6A/L+3/Kzha8ZlQyWQtNLCfnSafzSLSrE8vWzdLsjutFI8R6Xy151cG0x1eTpBUxRB5ZAGe3Y3sr+VJB/ZMW4Fd1hPeXka+BtjgRxDqHOSjZbFBNHdWQPd/dTcyTc0lh7WK6XtRkxqLXbj2SnPbZyvpQV+ZVXn3a9CLDB5JnHRPk3tGjuhU2NG6cbe/F6bfeZeE4tvegHDISr5PadZP/2DGz2HStAUpYbqOJsmWOfx+bm9zcuzS1RA00bbObX/jwbj0E+5oMC0+f52ueksO5FPqmK5uXnLG6vqoZK6O4+UTKfXNC7q+XvxAGNWDfllJrYhS6lcB99uecvjkpqBkQIIuDK+wkeNDIkdPREMlaETcSfHVVoAvlJpMZT1svzmQb0Ejth88uPAMRoVOo9KO+zG5AzYCBacSH67X2Mu5Lw2O4S/LN7kSLEu3hst5sljZpK8sxdNHO7ZkA31YPitVXDTmw2OePw7hfqNWX1Ik/dp8nzAdp9u0PEp0WrJw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(26005)(6486002)(107886003)(4744005)(6666004)(1076003)(8936002)(86362001)(8676002)(4326008)(508600001)(66946007)(66556008)(66476007)(38100700002)(38350700002)(83380400001)(6916009)(2616005)(6506007)(52116002)(2906002)(6512007)(316002)(44832011)(5660300002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GR5UhmyozEj0nFYonh+5vv0O9erYIDtz9KkLO8Gt2ZnAQZ3/4IzNLfVoV6M6?=
 =?us-ascii?Q?QbVaU1lcm0qs9xTdxua3y+EVx9i791H3N8sJpFmsFPb9yzGYqzti32RABRRq?=
 =?us-ascii?Q?mlqV0hfMvHLaYP2dFpolfmNreYdEwm1umz+fV1BGBiNVGzjHuxgAhtafcbye?=
 =?us-ascii?Q?XnUjycUmtgj/IeD8YdbjEepYGr9pPYFA8yHf17JBCYKJDHd+n6i+inZsAEew?=
 =?us-ascii?Q?SjU0CZvHOm4/fKY1ub/EchS6ZHoaG+Fq38VG0mQR0zDePNIKQTP+/KDxjTNo?=
 =?us-ascii?Q?11qPnSlPQpssXLzr1bpbqhqxV1HMjZfCbMnVFEu+qZcgmebv3W6PIi//5huL?=
 =?us-ascii?Q?4F4b9XNr38wl7CB7DjNvYCvlmNZ+9KlyDyQVrHUIWLniiJBXZeSOeKExdC9T?=
 =?us-ascii?Q?uOGW1Ih+J6/zm+A4G0I3O+bGiDmgFJrPVuwxE1kHDbyUZzkakbWv7tihak9i?=
 =?us-ascii?Q?dtMOROiRIQ6Ywag0AGzv1ZDdOof+Bn5dPsPtQyQJER5uBtCZhSqpkvq/EorW?=
 =?us-ascii?Q?SWFWNuFzTs1HmS5MEjFXkguNtASB55ps7G7O9zlweAvbtLh/mNs8ujpyZyEx?=
 =?us-ascii?Q?rQOuAVJrxBF3xSzRdF6OQ6pxkEEtdwdlZzqZhjQwf+zzgKwRUEyGIZKl39rJ?=
 =?us-ascii?Q?A4nkKSzSPFJXzwVJ0EFWe73hLkHVjqn/e3SXfBgLB+GGbM5ek3Lv0cFwNhMA?=
 =?us-ascii?Q?QMc6Hen3h+RyJwXVxnqZ8p3+PIRy92UK5z+1UUCIsG7ORsFn9+NIJfRpZLcB?=
 =?us-ascii?Q?PVJOQNzz9gRO/3GYWfXW0O3dzWpanDS+aqXZ+PJ27ZueSohcL+PshwTci530?=
 =?us-ascii?Q?forGosYFngbuWD+c3n4JBilsZmQU/VsWINa5mRqpCBJOjE0+bJJHjn5nQ6Zs?=
 =?us-ascii?Q?KwZMkauIN2H2oY9T6C03WeeQUwqCuopFZVkK7BFiVzCEECMpj48wLKLuGCgD?=
 =?us-ascii?Q?/QLFVEsjiTtu6WSZID4IAABKF/y/1+p7RbiybuYVry94wd4mAil0ujAWDY/I?=
 =?us-ascii?Q?w9xCz9J8AqFpHNdFmHXl8eOUFJfCcS0UArUPsKVntBjKCwGB6+wlQTr6pCvg?=
 =?us-ascii?Q?sq753DvF/Sg/wtdk/ozC3ns7whWhva+edyQg3UGj7Sa87OzoBFxUzOAFD/xH?=
 =?us-ascii?Q?7Rph5jCC2tsecD7oquWZPhPyB8qbGlEIxEMB/vvFkwtgoEhqjPqDdNDkrvJd?=
 =?us-ascii?Q?RPFbCdflInGgw9FMBw0PAiCKpXmyKoVFunCvS1loifeS3Oh+DC9q4ODxvq4A?=
 =?us-ascii?Q?WfRFdAe6b9SxgrCzBdPFuqkyIZDbtlt/mLTObJlDWpUIgq/7EYzdn0TgPYQM?=
 =?us-ascii?Q?o1Jqdkk58EyHifOmIpNVb0p+9oGDMeDRU44keiRkHpHXH3BqXJ9ojv5TwDH+?=
 =?us-ascii?Q?J0exxWKfN1CDbERudfsf/WfNjh7DsUP5u2z4NMbSnXheOIqYZRStTbHTnHvs?=
 =?us-ascii?Q?sJ+TOgHqmvy9QBpEvv1z67yr/570bI/Lurh66lKmTiZLgzYK8V+MCEeJg7xc?=
 =?us-ascii?Q?ZfELBojGLcqcyrMhPkyb5St7yVQ7MsnieoGquz9y6lGs1mV1Zyq/PlVLf1bP?=
 =?us-ascii?Q?npnf5d+zzdxqp2dO9CKBM8cAXcSLQ6N2bZenVz4XtLwtvLzcfetG3FpaiLj2?=
 =?us-ascii?Q?Ox10wTnmVa4DGw+HiCIhAUwQxR71eprJQTSrOHxKqLi8a9JPO3rP0Dpl7n8v?=
 =?us-ascii?Q?YWLB/EGGdxQvsPOXTRoIPQ/CJ2Q=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b71639d4-17a6-44a5-5c0b-08d9fe3e642d
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2022 00:23:37.7216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VG8Vz1FBQEOLi9pSgROpI3gInHj4/ZnPZkivsTK1zYm9YGSa7X65cPXyx4PLlpLHkFJoGgeI3fMiu2MfE1RwuHObjZbo/EdwFkkQIdyDwac=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQXPR01MB2758
X-Proofpoint-ORIG-GUID: WzDoPb59lLhUS7cQ9KtgHmpX98EM8BYS
X-Proofpoint-GUID: WzDoPb59lLhUS7cQ9KtgHmpX98EM8BYS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-04_09,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 impostorscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 mlxlogscore=640 phishscore=0
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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

Add support for NAPI and GRO receive in the Xilinx AXI Ethernet driver,
and some other related cleanups.

Changes since v1:
-fix 32-bit ARM compile error
-fix undocumented function parameter

Robert Hancock (7):
  net: axienet: fix RX ring refill allocation failure handling
  net: axienet: Clean up device used for DMA calls
  net: axienet: Clean up DMA start/stop and error handling
  net: axienet: don't set IRQ timer when IRQ delay not used
  net: axienet: implement NAPI and GRO receive
  net: axienet: reduce default RX interrupt threshold to 1
  net: axienet: add coalesce timer ethtool configuration

 drivers/net/ethernet/xilinx/xilinx_axienet.h  |  16 +-
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 498 +++++++++---------
 2 files changed, 264 insertions(+), 250 deletions(-)

-- 
2.31.1


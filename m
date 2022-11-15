Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDA4A629E3F
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 16:58:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbiKOP6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 10:58:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231563AbiKOP6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 10:58:11 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2078.outbound.protection.outlook.com [40.107.21.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE5DF2DAB6;
        Tue, 15 Nov 2022 07:58:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CPHxd4rXMA0YjF9Fd74VEJKgdA+a1GhOqaz7Cq0LFgUqNj/HS9SnxpVtBD6V6g3/0BMoU5zFSeiNnv+WPDO4Y3X7aTPL8DMPxn1t6ufqHhqH4h5f+faCdCsrVZJhCkUDoH0i9hwuQtT1vKlXQF7++L4FaMI8j8VKCNYYXS1esfwTtEZaTJPxlBeLdgJ5g/Nz+n4/dXVQhbt4/vwRez1loSbY7wGUX+75/0Yz9AvJ5GB8+GP3Cew54Squ/DBtcPnmkgQCA+UB+Feym94CvOluIPkj7Ccldz9ilmNzKHL2I8vuQ5ENkH7pjScRlNAXGv08K00lEsgO+2269QMdullItQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AXhaqDQ5GbEk+DVxZulYaDGIvLMKvknZPzRSEZZEVNc=;
 b=lJN3H3nzaJ56PGA3Tlp9yfNNjzfM51EGq8vIPTwyY6rlXmBqWkUEk61r1O7TRyGr84xGAomCKe77LNT4oDECZ8oyuzetl7QftZVvv/fpr3qlJItrsQL5eTDqxkaIMXKJ5fGYNZmatPmRfiAkt7oc/zqUX6PE8Fu0hD8xbJ2gXcz7AXWum4vtKD+Thdbf1XtNlEm7ibYetEqHy7sZ99NkzIFIRFwRDYk7Jx48Phn/y4Niobog814q4yeo85pEFYtdRNWn9YJ/uMlrKEWpUxAF/DbuGCDGLHIPq6uk7ZpLg0BalaYG4y8euO5yZtIjcM9AduAT2r2O6A0p78VP1m23yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AXhaqDQ5GbEk+DVxZulYaDGIvLMKvknZPzRSEZZEVNc=;
 b=LMWkqD42yMHayRDNsfDs9o3Pf5nTzgkd1bZv2b24/YSuG3WrO1pKD+OnuKY5P/b+zZk37QN5vMnUqyiWAJ7farzYTyqrgv47Qipoxaugl9H4uBDZQsMp4LqykkbQJ7Yi7ajSw72OMDYrtKgBPnUFkccSIk2VNmvuS2XsDnsivfk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by DBBPR04MB7690.eurprd04.prod.outlook.com (2603:10a6:10:200::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Tue, 15 Nov
 2022 15:58:07 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::6b44:4677:ad1d:b33a]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::6b44:4677:ad1d:b33a%6]) with mapi id 15.20.5813.018; Tue, 15 Nov 2022
 15:58:07 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        imx@lists.linux.dev, Shenwei Wang <shenwei.wang@nxp.com>
Subject: [PATCH v4 0/2] net: fec: add xdp and page pool statistics
Date:   Tue, 15 Nov 2022 09:57:42 -0600
Message-Id: <20221115155744.193789-1-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR20CA0031.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::44) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|DBBPR04MB7690:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e28899a-dfe9-416b-782e-08dac7222e68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UxteR5dxA2HcDlZsjRr6Uj1MEgKOLzS3rprZqi/iVDtawHLQo9xTcDpm56S+/hwWKzWWMsyz0k+FfWoPoyNGJrHkzA0PBsAJn0AM56MDVMhNVqVwKFqmOpFAiYfXszK9DnLAf+jykujM791dixRYqSm9QTVQZA4DyEN4OhdLk6uF3j7rs9aLK8IJ+ogjLQJ8iqHyRmhfS7fDAGtBdKQydaqLEiq0XYs9juyMwec9TxVSNjo0WGHTB34cqOXsOT2g+y7dSKe5XKH7tfUZBUeXu2rOb6A5fOb5OMXKJ+atXwKUdwoQxe2nmsB4MyyROdGqFS00Ucc15KaUVRFrwEYzCkXOuJYT9ap1NJYvREZDajgjxdPP+sKs/42FJ+YPZbx+B6MFHPcTjdPODyxJkZ4YufeFIcVHkUOwbR+9Dg9p23MzySUPE3NxynxYT6txu0+bKXidnxHxRcgTaejoec4dZicMSVyW7aba6w9WMnPkGilmmIE3dolCaB+MUckOyUkBiST6Wsr6gMlMnuQgdTjqaUpcQDYn7GiWwg7ACIJCPmMHohjWb7Ve5fGBlnOB7weyqjGZYX38LffPcfEPi+xnAL2Pqw8/+aPBbwxQZlmYDvRw6cAkz9TQDB1pmZTyCSwIsvgo0Ln05tX4xVEs84voLYDiNg2vbPmE0alosySSRdi3LerxBHp0ncMpZhYY1VK+9pYvhYiZr97S0SqrmShIolK8E2lMYV/5SwZZJ62wHYLWwoP/mX+VyTVQDvhzxH68
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(451199015)(36756003)(6512007)(186003)(83380400001)(26005)(86362001)(2616005)(38350700002)(5660300002)(38100700002)(7416002)(2906002)(44832011)(41300700001)(8936002)(4744005)(478600001)(52116002)(55236004)(6486002)(316002)(1076003)(54906003)(110136005)(66476007)(66946007)(6666004)(6506007)(4326008)(66556008)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FLWju5svqVLoARA8myvqhcldem415RGnl84qs65B7dmBVnrtDRf2TP+ApUMv?=
 =?us-ascii?Q?SvRNsDgI7RXmdOUq7MR+NJ9HXns5uvep5e9yK/OyOrj5GqrxA36wvN2REUI5?=
 =?us-ascii?Q?ZJgC3Hzrh8y1t6w9Uw7tzC/AMTHXIQ1SOPDEJFLzCrw5fZG0sz1Y/lVL+tte?=
 =?us-ascii?Q?KaX6fe8bsLVmPJpBxIeKCiSMXvaSm33sbqGP2P1DDFwfp1+Jiinmd391FjZX?=
 =?us-ascii?Q?UdF785K43uLfSUV+zaCEC9tIjohpJJk0nXVhP0cyWxitWHy35/sTtp4CE2Rb?=
 =?us-ascii?Q?cX1QXpCL/xFQ3ilEffmZ6Cj+fIyTupxjHv+ONf5b2sT7ouKxof+gtA+w0oJv?=
 =?us-ascii?Q?GdO+M5dShCiLVNryiuBJZWwBFZZdxLAYr23U9GfYmR5LpSga7scRMzb39K+G?=
 =?us-ascii?Q?3Q8lFXyiCJ5hAiV4uNIUeGZJwcAgJjpoU6du5TCOc72nGTpF0RjO2WHRWZBd?=
 =?us-ascii?Q?r+tUzTKh1OzojnxPY+6GlipTE1OV1MIxRL4igoEvYncd2LIfghHsyAqHCfjn?=
 =?us-ascii?Q?U1u3kMTh6zD7Eyz6p4jn3GOqhwTK+BkjcKM+kLoTMfBSjnQaTj83b2IXLEJR?=
 =?us-ascii?Q?lFBuikjn4ctIjxRffZZc3bpQznLGvbNRmtQ/zY/EZ/L4XlxBueOHRabd/8nf?=
 =?us-ascii?Q?5RD+++cOFhm0rmTUv5OwnTFobaYuxT/39UhqqK9jtYtv67F8gIgZ7xMivEzv?=
 =?us-ascii?Q?pKnL7sRc4diDIucPAzISBW7VRm4bJe7b2+Dpn7cXipSdAHdo48d2Mb32X1si?=
 =?us-ascii?Q?9zLJRwFi528u8flZqDfPDOoFxG+tAmY0VCMdpuazSolJuYeb+YBnEqeAfRcb?=
 =?us-ascii?Q?sda8ebsuPdiq+LhpMECdUAWbwfAY2Do/aGDpESkQ6oCDm/Qu5YXKycpIrZUd?=
 =?us-ascii?Q?gQ7BtKeI7ID/ajcqdDIuXTlK5SyIofp+71LBSvWamzfknnjM4gmAdSQm9x5A?=
 =?us-ascii?Q?t9VKu5IHTqIwl91Lfn3iNfvR1p2JbyrqLvlIAmtiJ+1I5uVim+fRj4/dmBN/?=
 =?us-ascii?Q?GQmJ/UQGSfsktT5CtY4bJMpcbDb4b6ZLvF5Wfrz3sSzf5ibLXpVHRvyvQ4oG?=
 =?us-ascii?Q?HcQZbppbIB0UWdnT46qO+Gci7GtzBj/RNTjGfPyP9DcJxR+fGAxjiytRMIvl?=
 =?us-ascii?Q?rNHMzBfhoRGvxcCqIJFf57g4C+X1VePyEH2bxfnEPvJr2TMmc370PDz90TWA?=
 =?us-ascii?Q?H4F5mYU4Z746eQMAcEzk7VjdU6bk3LmOVLPrm3VCS5CulPECDxRM3KrG1Ivq?=
 =?us-ascii?Q?4siQCPApF7++Eh0GE83ZppSFcLnvOHU0Vvzt5x63FFPK9dm+HSEbshcgD9Fw?=
 =?us-ascii?Q?XIgU1/36/yYmrXoDCgD7xoNloT0ndi+IskLgovBz4efTtOU/S2O547IrhsQI?=
 =?us-ascii?Q?JC9d2FV+vBScvsBXvGLbnQ3CfFli9sYlK0WRHyta3KB3lzHocjbwq8c7h+iX?=
 =?us-ascii?Q?ZUKKJKfOuI/4NG2HushcwB+eBvREtK8wQ3Dy2Yk0njmfsYXNVBcsYQcXxtRi?=
 =?us-ascii?Q?R3XyIw3a8aFTTSjR9UWV5vysjaHVlvOJ+fag1VNJRwlSBl8j6rTXiMptRU0Z?=
 =?us-ascii?Q?vbTICK3TE39iGfWaIys3Fseyj+5XjxV8EiYw0mCZ?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e28899a-dfe9-416b-782e-08dac7222e68
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 15:58:07.1989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1bxP+n3gt2J9IMZVcjSkOR0/VnebFLJSFax1IfTWOO+nRo5mDlI0HHQNgxlJE1xzPUS+hzFj9o6XDY9HnDudXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7690
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 Changes in V4:
 - Using u64 to record the XDP statistics
 - Changing strncpy to strscpy
 - Remove the "PAGE_POOL_STATS" select per Alexander's feedback
 - Export the page_pool_stats definition in the page_pool.h

 Changes in v3:
 - change memcpy to strncpy to fix the warning reported by Paolo Abeni
 - fix the compile errors on powerpc

 Changes in v2:
 - clean up and restructure the codes per Andrew Lunn's review comments
 - clear the statistics when the adaptor is down

Shenwei Wang (2):
  net: page_pool: export page_pool_stats definition
  net: fec: add xdp and page pool statistics

 drivers/net/ethernet/freescale/fec.h      |  15 ++++
 drivers/net/ethernet/freescale/fec_main.c | 100 ++++++++++++++++++++--
 include/net/page_pool.h                   |   2 +-
 3 files changed, 110 insertions(+), 7 deletions(-)

--
2.34.1


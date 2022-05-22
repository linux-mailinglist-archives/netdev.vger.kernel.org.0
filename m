Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAFAF53032B
	for <lists+netdev@lfdr.de>; Sun, 22 May 2022 14:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345258AbiEVMxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 08:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238468AbiEVMxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 08:53:16 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60072.outbound.protection.outlook.com [40.107.6.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83DBF245B2
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 05:53:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LcicPDCHAe6nzWwLlU5QzwGFSjjPv0DsGREhkiP9nDrHDkeOLai2IPMdBn/ywqtMC3OiIg6uSlpJLeNcKd1p71XZw1OixOIEonr5jNSEuy15HYHhwKWIx/0i0ELyi0iNJ7KLmJnL23SAzqThml+RBpfaqxFFC+qKmIBtpDqZdWX7hBWQ/zqPNbvivKbrqtNkqcFSmFLb56MZI3srej+lonlBeIEYCysHhl0KofYmnNzYfNwf0H4wYfAMneJ5fXeI3lf7JiLrrENtcaTGo53umpZn9HEnn1jvFWlWz5PMa4vz5AQaj7quZxHi5nh3XimcDqpXqXIOB4QlXdd803H8xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U0tUehWCwKV+CLKMUCvIsKbe2o1lbcnQrkeukc6nKRs=;
 b=PELZV3RUy3AJoUO4mtHLkOiyR7MTnLhChnopRIz8nKfCNDQhwfXhFLEtmA7CeiUyR661DrYGjwDxVZCFN8UphJVqIgikpgEk+XhDmnRejw2SdT718bq5Hj8/Dki0N2vZRX34QXwcqKXz5eOHpRrcXMAjpTfA7MkwAotqrL+TMJnq0pHfQHu5KJVmW7O5nlwoyf1hrSIqH8yNz288DjUCfVPwF32bonxdUyyGk1YZxm+sYt4qc7R+tSb9BOSYEM3Sb21NKzOjr2X31ANvl3ynNC6wKdqu5mz/0VlekrRzuCNH/g1gOGMFDZaTulaRpkfdbc91ffvLnwSe2KiKnOQGOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U0tUehWCwKV+CLKMUCvIsKbe2o1lbcnQrkeukc6nKRs=;
 b=JbKoYP485KsKrsbPCdbgEoypwOsJ9KBZOTV2Tw68J1vUJMGvqZ5juYiFyFE6LeuDzBmIcT/9sgPyjKq8sr3z2lhnwsHuaH8fexxqEha+C+10iNh/OAEzYG8BBEScMdSnTZhOYy/LApa9HLeFIGOtKQL3LjQIdw4jzD9zmJG3tRE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by AM0PR04MB4385.eurprd04.prod.outlook.com (2603:10a6:208:74::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.16; Sun, 22 May
 2022 12:53:12 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::482e:89a:5ef4:21fd]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::482e:89a:5ef4:21fd%5]) with mapi id 15.20.5186.021; Sun, 22 May 2022
 12:53:12 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net 0/3] dpaa2-eth: software TSO fixes
Date:   Sun, 22 May 2022 15:52:48 +0300
Message-Id: <20220522125251.444477-1-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR08CA0008.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::21) To GV1PR04MB9055.eurprd04.prod.outlook.com
 (2603:10a6:150:1e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: efa797d6-f672-4683-0e3b-08da3bf20736
X-MS-TrafficTypeDiagnostic: AM0PR04MB4385:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB43857F71AE0707F47E837D88E0D59@AM0PR04MB4385.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3mjHmXfcR/RNEBb+GmPvfL/cwQtxLAidj8t7MuI6I/5442rYkjGWViRKiTxiNwn9aCaxRRQFvoU+6IMCYb+MO9DwsKM806DY3pO8wM9jbUbx9FwNb31xMQ7BqbQzt9A3+UfdkXS3dk5VlelCFJDJtG8PZYQRkGSe5eu1rN/dvaMUjmviJwjHHwI6Qc/QAkSAT5TCXnr3ggYNE1Qpkz9Wqwd0AqDKPFW4DbugA5JLuyfbkso8y3Sd9KQ4RN/5W9qtmoezylUJYa1+wvMAhywC7vkdpnrp79RBMeAjD5c9F8aCM6nbcn1l986dscfzPMo3Gn4IynHdX/bt+ZalLk5PcHKul9cXrwhzrFp9Yl2h6dGRaJ5IGaLDVgUmFTujOU+dCIRGmEJin4t34PJ5w5gjFfFhjZ+OobaYjgv7t9u/L2E5xrfXOSyl8GviEsPqKfGMyqvq3H8BRPYjuQTK6gFz3v7xdYA1W2YyTW+EWAh+AkAChptVmcLRVGZvlvutBWRdU3ATHYi32uJlJPYjATLzZ9kDdEU8kKL488uYw5V/No3EOhhc3+dFHEzhOOsOC3dpx/mbVLlQ4cPRHWmLat3D590aG5l+AJjOcuuDUtHITXf83ESaOI3tAFlb2iLH9MtjCc0lM8l8oQeIAWHc64qfv1jmcCtBY1Y58oey54MHe6Cof92BlVFduGMJ5wPEBCW7Ep7hBLNpfpyhbDb+EtYlqcwN9fYqawr4qmcemk8uLSXl/tyb1MKKPwqe1GNhDKxKL6MWzcrl0qK0aI9HPySazIgjOXnznvTSmCeW4wS3HQ0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(44832011)(186003)(5660300002)(4326008)(2616005)(1076003)(38350700002)(38100700002)(83380400001)(2906002)(6506007)(6512007)(26005)(52116002)(36756003)(4744005)(6666004)(6486002)(8936002)(966005)(316002)(8676002)(508600001)(66556008)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xppJLWiwDK8oWK+mCvD5OMvWL/V6ODrbYkBrbEYh/xf2eMECLP7RECsGR/NB?=
 =?us-ascii?Q?9KwSemQZ0enM8wgOC86Zo2m0xsjR+Ue4fhuKZDpDL2la7JOaHzpp+/uYi0rN?=
 =?us-ascii?Q?hNdR6bEoDS9Y7TisXzZFRzXMwpM7QSTn1FW1Ldc4DLJGKoukE0CIsKOxrIcF?=
 =?us-ascii?Q?P6EyGc/YDf+iY5InUP1iCzIMpgBb2cJJtYoF3WSg5Y8ObDjyFn5TEP/t/il3?=
 =?us-ascii?Q?KSfGtfUdx00CZOKHFCtY8cvdO3h3WbdNwY70R9WyAoeqqNqYIKHHlefZKeKa?=
 =?us-ascii?Q?qoW6UQf87Z3KQIhSXEwtOZ8vBpz/As2zxv5IVzI4ZhuVywoDoX38PD3HMU5x?=
 =?us-ascii?Q?gMqDo420CmeHKMUFl85MlkQq+DjI1d/N1q0F7PjsZBlsCk2Oztd2Rqbu1A6V?=
 =?us-ascii?Q?JtJNQuXm30TGLg7GjBHgK8IasPHfbWZTBBr8kGmiUP9qbW2qdvexjsxIsx03?=
 =?us-ascii?Q?jdLyGU7Iz7jpqmeOobxdjb3yvyiw/x2fwfMhJXx4n+rVKBqBb/u6knjtIyw9?=
 =?us-ascii?Q?gGpD2XETX7mqGT7tmft7T6jhHThbvAjwd0yZm4IO/sTynQt+r9vDf252XN/K?=
 =?us-ascii?Q?53RQsxwL95ZJiFSQylF0d32Ag40y/ILWWJkiZgFHVQl+YQoejJS48P8PW35i?=
 =?us-ascii?Q?kV3WoPpZKXn3sxFKmo+pcxsPcKtVkgoKXx8pSEn7pGaplP78hUpwtjzyEKel?=
 =?us-ascii?Q?DVtfi/eDJ1xhqB2xOKC61ApupSvnVtVvahm/leUAOnpClWDiRlMqG3lXsi3K?=
 =?us-ascii?Q?NO5npxlgvUQvoZGWvkkKRt65+H1U9OHJOF4dBBtJbgbImBy+pkuv/DsNU8Es?=
 =?us-ascii?Q?1AqSFbFVmwfr9EFoDSGDBaalNoC7gjqIP6z9ywG7CFtu9W7hzfBm4l2tUHSC?=
 =?us-ascii?Q?BTCHMySs6mGcvc7FUJuSjnhBFiAHVJvkNBAtIa3xAf1/qSOLSNrCa9pgNBhb?=
 =?us-ascii?Q?6DbjL4ekRShrN6te4bxV4begp2Z8nNDDLjO3Kq653KHTNxTut21qWXBRMdWd?=
 =?us-ascii?Q?Iu3+fjLxUsl1JmqMYUUbRgP3aLMFinV1+x12l00DpSIEnfb8J/s31Y2TxHdi?=
 =?us-ascii?Q?FqmIoHkVSSfQJi+O9iTWst/Xa80dCnBI9Gozg4VZNznvCJj9JRromRejA0Ha?=
 =?us-ascii?Q?LIPAmkRs5SwqLXH6eU8Vy+FaqqequMO/oWugzjVbp4N4pvsNyfq/2qzfsh6F?=
 =?us-ascii?Q?lYw1rmPI2EECANDyV+Kb65JJlyZxNKB7HZy4EfmE/PkKGPuDL3uj+fu4uEtz?=
 =?us-ascii?Q?ltFswWZNhS52iIKqVlu7KLtZQ1cR9f8zfwQl9AtxS+/q3KkuWXHkoZ0LcetV?=
 =?us-ascii?Q?uryANjNRppj2CQwZNWZ1lECEdnC+FeM8MbRf/8eMsgnH34tQkmE27c4cn1Az?=
 =?us-ascii?Q?KZHddFnF0Bwv5XRfD0rYf9OW4jjlp7bBqevn7jzxnQg70ioYZcow5zk0Ufrs?=
 =?us-ascii?Q?hNL5cRJrZP0BVNbeNhDvqMv3DCwNn+l8i2ylb7zXyNXrBrIDInEbBvfYX047?=
 =?us-ascii?Q?qnTWKwXp9ojm0tNHM358v8VZQEZ8YWVaWdf1O8fxEOjYyrYnOnKaPCI+o+pe?=
 =?us-ascii?Q?W4W6K/VUFKHehaIAFY0LavQfR9O0Fm2ywLGOQjx/yI0reUEyUDfc+W6qz/LL?=
 =?us-ascii?Q?6hXlASiZ9azGSmTqDAsVcf7MSnnYbPnirKtqCPjcRrULQeAs7XVU2UPfPZCu?=
 =?us-ascii?Q?fwZaUnlRNz30jvaTqxNW2ITW6S4F2T1dt/knol+HDw73S80G6Ws5mrSGZkXW?=
 =?us-ascii?Q?Lnu0ayGpE/pm9RKxCIaJabOQ2iE12o4=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efa797d6-f672-4683-0e3b-08da3bf20736
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2022 12:53:11.9671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /vAvwQpSIFoKtOcoHv5p81u5kfBRjzJMLjSC2WW5NxW7wPOaqjHZTWgYqwoi4esdGUtJ9CkQFVB7zi6l7WOqiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4385
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes the software TSO feature in dpaa2-eth.

There are multiple errors that I made in the initial submission of the
code, which I didn't caught since I was always running with passthough
IOMMU.

The bug report came in bugzilla:
https://bugzilla.kernel.org/show_bug.cgi?id=215886

The bugs are in the Tx confirmation path, where I was trying to retrieve
a virtual address after DMA unmapping the area. Besides that, another
dma_unmap call was made with the wrong size.

Ioana Ciornei (3):
  dpaa2-eth: retrieve the virtual address before dma_unmap
  dpaa2-eth: use the correct software annotation field
  dpaa2-eth: unmap the SGT buffer before accessing its contents

 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

-- 
2.33.1


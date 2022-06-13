Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D27F654815F
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 10:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238323AbiFMIEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 04:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239517AbiFMIDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 04:03:13 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2042.outbound.protection.outlook.com [40.107.236.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51575BF73
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 01:03:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AdQJYFPFBhWnEa40XqnLlyn5gCrFUXcO63FYA75QTHR2TdNr14g2oJiNqIGdrEVIDIQDagJfQ7/1wHT0lNUbf6telE4EWurxCorOFQ6dQOsnEd3nsw0xUmGyPc2AjZL/xIAmgmD/g10tLL/X7wH8juGWC7xu79RX1QnNHfjo9rXxu9anjTmMiN/Me4gBDig0OBZFHTQRcgFPk0s2kDgK9EXVceJDZ3WwuQMpHjaXFp5LZ/cmtJsms7I26M4qUdqk+KrqkGhzKScERCOLbnFxL9woyykRyFOjk9+MSoPipdM/TqjzaZinFAXIUAT8DCJ+9TNIvE9YJnJFxjUinhdjBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PIbVz9mxoC0ISHmBqvO5Q1d8HYVhINFWfLN9spul9IU=;
 b=Sra+hHWTrfQMVh7CnYnf/FfgczXFlFy25c+jRWE//UszPbayW1go2d364QpiZ6o/Ec55iD1Qq+p/A30vnC03tIqmVEZHIb++DDGHaXPHfRViaDhSYmVcP0NxLlPB+S04IAqN8HQjqA9iV+/qqm4vc3waR2enbnHETb/Fs8lR5F5KDpugqDRL9p8V8psAgymmd0v+rkKNk1vdc8aFPh+SLEF47/M/IRzFymwidOICRJUL5Frn6xwlDAIVDaj9VavF3s/NrbVWVV2IydL8DITt0oCbjYvN5LWsv44gGzirwrsm1/XtO6CJv/9tB5RG+aGwI6CrbKiOdc+QoUWblsMD4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PIbVz9mxoC0ISHmBqvO5Q1d8HYVhINFWfLN9spul9IU=;
 b=NS3ZzJcdzbctyMVeH2TNYvsyYB5fhdKQ4FfWRUeKC45pdlZIbQqS6DFIzXEia5tOF9WbiBfqjSqnAHg5q+JkoEQC7pRTv/VOXN2WGTGd3oiS7qGuHFamTi8V95dcKIqz2p7yBNiKnbrO6gtMDmL5YpPOmrRpvJy1Iuy+EDekDCI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=synaptics.com;
Received: from SJ0PR03MB6533.namprd03.prod.outlook.com (2603:10b6:a03:386::12)
 by PH0PR03MB5765.namprd03.prod.outlook.com (2603:10b6:510:40::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Mon, 13 Jun
 2022 08:03:11 +0000
Received: from SJ0PR03MB6533.namprd03.prod.outlook.com
 ([fe80::d52:5cb7:8c3b:f666]) by SJ0PR03MB6533.namprd03.prod.outlook.com
 ([fe80::d52:5cb7:8c3b:f666%5]) with mapi id 15.20.5332.013; Mon, 13 Jun 2022
 08:03:11 +0000
From:   =?UTF-8?q?=C5=81ukasz=20Spintzyk?= <lukasz.spintzyk@synaptics.com>
To:     netdev@vger.kernel.org
Cc:     oliver@neukum.org, ppd-posix@synaptics.com
Subject: [PATCH 2/2] net/cdc_ncm: Add ntb_max_rx,ntb_max_tx cdc_ncm module parameters
Date:   Mon, 13 Jun 2022 10:02:35 +0200
Message-Id: <20220613080235.15724-3-lukasz.spintzyk@synaptics.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613080235.15724-1-lukasz.spintzyk@synaptics.com>
References: <20220613080235.15724-1-lukasz.spintzyk@synaptics.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BEXP281CA0005.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::15)
 To SJ0PR03MB6533.namprd03.prod.outlook.com (2603:10b6:a03:386::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7932cd29-2d10-4d86-0c13-08da4d132882
X-MS-TrafficTypeDiagnostic: PH0PR03MB5765:EE_
X-Microsoft-Antispam-PRVS: <PH0PR03MB576596A1B4713580AE3432A0E1AB9@PH0PR03MB5765.namprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v42jWF+kKnR7mtS7pfXHcz5X/pgbSwxGIIyshrx94FPSVp/5qmhgm4vTjWz0Z58sjj5TkqlMgdUQLsSmMOivdZdrbR/JfnXQ1kJ0XDbM97iVPzlFkLvUU+nKAQ769ysCNOPHjBZNfYhsAbQCMdd1zVe7fqqJw7f9S8JA4QaRGvJfTLy7BbPBnMa+f33aWxMDzVY5AnqH7ylxdS/gpJtHpt1OU3KgegMyGiYfJ4PiSuJOIOLA4JJTprwxx+wiOZbglE1R022mooyxY6PNkOQLqkfZ3NycdbUpIlLrly5+xfsnLpFtJS9NtnHjVzFnFvS03H9bkfr8XwyUOivX0xqoEylZuEGsNC7nPBBtY//tWJAgfBpmk3oaUzwMlxLaWOBCP2cUq56qBBRT0so8fZniTQKWlMkCskg5QeXN1py1RNODtMKFQu8mFHZGjZ0fhEXX9qUOtLb9qC4SN/BXg3XRD7T5KFUmFK9SVuJK2QtqkyLnaFG8tAEsVgkwjD5SkDQDVUUZ30as5qP8vWwrkBadKX6Vv6feChiXiNZpg+prcqn4Id+4slVvrdrhiQ4fFtYujqnlx4FANrYkUY3Dpq1Y6DZyKWoFFCzfWMTEvk5Ic/pPxx0D92IZsjAKmOBDiXbWKWXS4VuhtBLIEydDLCSNbaYovWjKx+aCsU7HMMUYC6/nfpXXbOqXq1m7w0bhY0qZY4NsNYPlC8gAZwJfCHdqHQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR03MB6533.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(36756003)(316002)(83380400001)(186003)(2616005)(107886003)(1076003)(5660300002)(6916009)(6486002)(4326008)(66946007)(8676002)(66556008)(66476007)(2906002)(6666004)(8936002)(52116002)(38350700002)(508600001)(6506007)(38100700002)(26005)(6512007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a0hTbFNNL002Umd2UEFQbnpIT1NKejl1bjIwY0orblN3aVQwUG8rNERwWFZ3?=
 =?utf-8?B?Y1pRaVdxazlyY1lNNEozR3E5OXc4Skh0NTA4dENSOFY0dWtlSXI3ckhhMStM?=
 =?utf-8?B?VWs0T05lZ2hpaHdEb3MzUGdYMEQ0YmlaMmNDcnZEWkU2VzhieDhwVTVlYUs2?=
 =?utf-8?B?NlJrejBLMFhta1hRdHZZSmlnenUrWG90aEJscC9BMXdEcmkrVmFKd2pLZGVT?=
 =?utf-8?B?c3c4QXJxVE9JOVRNTlBFYURGN3ZYejR0UjVVWHU2N1o2VHFzQjcvRGJMOVo1?=
 =?utf-8?B?RnhQYXBNaWJ2OTVWazhzYThTSC9KUmttazB2bVJGdGttRlVqUXlrTzQrNEZH?=
 =?utf-8?B?R0ZrWHNoT3JkWDB6Q0ZGZkE5bU85Ynp2RWNHMG5yQzV4ajZqd1BzZElwbnVo?=
 =?utf-8?B?eWFicmI0dGR4T3dGMnJMZlplaDdQNXVEYzY2WEZnYSt6S2pTUkV5amVYVWtF?=
 =?utf-8?B?TEZReHBFZXdXV2U0SEVyOHQ5NGhkNEpQN1Q2bW5jUGJ2SHBGZVZLN09uUXNt?=
 =?utf-8?B?QnBzS0hMS0E2OVU0THJhb2FqWGVxZUZUdGwvbDhIV3pnNzhaNXd0WlR1bndM?=
 =?utf-8?B?eFVSYmdrdkpuOHVLaWhHWmtHenM4RmRPYmZaTHEwOUVRTHIzbENwcmxQZDlL?=
 =?utf-8?B?K2g2d3ZMQnBOWm04QzJkRjFtcnFxb0RPam5SbGN3QW5NbEpNUTEwcmlLc085?=
 =?utf-8?B?alArWHJ3UFB6ZjFXd3hYTHYrdTYvV3BMVmFscWUxbFNUNThhckZtQWVDN0N3?=
 =?utf-8?B?S094VDd0T1RpSWpHMUNtRjMvekljbytMR2tkVE9QNnFYdkc0QjBzZW5oUjRD?=
 =?utf-8?B?UlVyWC9IaUVudkNwc2NqTWg1ZUxqK1FsRHJYclNLakxpK2RucWpjNFVBTGxq?=
 =?utf-8?B?bmlqRWN4Rno4Z1Y2YzB0QUNwanJYTkQ5emVJampaSHJPWFduQWN2cWp2VVRT?=
 =?utf-8?B?MVRwNm5rWUdybXVGVnpnQ0RBMXpoQWJhcFAwMWVUcE5QR1dKSVJ1aDVRQ0V4?=
 =?utf-8?B?SEVMaDhCa1VoaDA2aDlUYXQ5TVBXZk92RStFdEpKU0VEKzFwdy9pTFNod0NG?=
 =?utf-8?B?dEVHR0k3R0kySERweFJnTWdPZkkzWWFBcTJMRzl3djZZQnlIZVRjQkt0d1pM?=
 =?utf-8?B?aUhKcVB3Ym94Wkhkb0tHWGpjaVlRUDIyRytjcGVDT1l3ckFwdDFCTzAzK01L?=
 =?utf-8?B?Sm9BdWNPa1FFWUpleVhvbm50YmtwejV2V3ZsT1lHbG15NUNqeEJiK2MyMFo5?=
 =?utf-8?B?anQ1b0lMM1VzdDBJQ21RRkNXSG4wNGFmWjI0ZmxMb1NsUXh5SHl4ZTh2TENX?=
 =?utf-8?B?WjlpOTM5V29SV0l5eno0cXFYeWl4TWFXVnJ6THZhWXBQcE1pa3hjc1ljaDdy?=
 =?utf-8?B?YXh1Uk9pY0pkQ0QrclM4SmMwMjkxQTczMnpIbHMwWVVxWnJNd1N5RkdmRjd3?=
 =?utf-8?B?U2pWMTY1b2xBZ0FpRThPdUkrUlJIbkExR1JQbDRjOWoxKzE2Z2Fsb1c3ZGpC?=
 =?utf-8?B?NWsrTWQ0YlV2aHFnSDd2czFkamFtZ3JGT0dxNERMSk1qOXRVZU1EeTRtalFU?=
 =?utf-8?B?YUhBZ2h0aTYyQmVpVVVwYnRmRUZsTjJZYzlzaHNNNlJtR0lHMHR4OTJXWmxH?=
 =?utf-8?B?MEo2aWM4OWRoQld3MWU1dVJHVzZCNHJXNENnUWZSd0gxWC9SMzNLR0tGdllv?=
 =?utf-8?B?NTRsSkFTK0lKdFRjU2NqZm1LSWxKRHZrcGYvU245bk5mb3BBcU1KQ2lPdG5W?=
 =?utf-8?B?eGIwQW9HVERPNytlSEVVKzgxRGtveGxtY0U3VDVlL2hDM01sTTBKZktYZmVa?=
 =?utf-8?B?V3UvSitrMEp5bmRGRTZKVzBqM0M0WExMcjVmdmJSQ053ZlNONXhkUkcxY1gz?=
 =?utf-8?B?ZTIwc3BZU3RTUmZHdTEyU1FZN1lrcTFyVlIxcG1vdTBGQ3NITjVlbzVLeFlU?=
 =?utf-8?B?YUNZMjJiLzlNOHVZQ2RGVEVxZGVtTWh0d2pXbmpRMHFnb3MwMVROc2thNEx2?=
 =?utf-8?B?UjVKNldUcG8wTlFTSi84L29ONEtJVFVLUEs1Z2taSXI5QWlGcURxRjVEK2Ey?=
 =?utf-8?B?cEh0dmpRUzRNYno3UklSelNOY0RPTklNSlJwZmZFNG8zOS9qMVNWRUNzMDB6?=
 =?utf-8?B?bEsyeitkWHpSbVJsS1kxMFM5WGtkWXFWUHZpOXNBUnZIbzZPTi9HWEV1b0dS?=
 =?utf-8?B?NmVOSzVnM2llNzZPZTJKZkZZOFdSUkJzMTdOTlhvU1I3U0VrSkVRQ0xkc1BD?=
 =?utf-8?B?YURpOVVjR250dVBqRnFvSGpzaXJCeDFQNnplYjdiQ3M2dUpuU3NUZEdqYWRq?=
 =?utf-8?B?L0RtTytrTmRINUxwQ1lZc1B0THg5SXR2MnByVXhJQ1p2cDdWaU9GZz09?=
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7932cd29-2d10-4d86-0c13-08da4d132882
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR03MB6533.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2022 08:03:11.2549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nO7xIsJWIsMOy2Hhi3wMje48/Zu9azibcBoa04qydxgHgscQs7/OXH/69BghbndopG3LVmME/6Xg62WiHTR7hQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR03MB5765
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change allows to optionally adjust maximum RX and TX NTB size
to better match specific device capabilities, leading to
higher achievable Ethernet bandwidth.

Signed-off-by: Łukasz Spintzyk <lukasz.spintzyk@synaptics.com>
---
 drivers/net/usb/cdc_ncm.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index 4594bf2982ee..1ea1949c6014 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -61,6 +61,12 @@ static bool prefer_mbim;
 #endif
 module_param(prefer_mbim, bool, 0644);
 MODULE_PARM_DESC(prefer_mbim, "Prefer MBIM setting on dual NCM/MBIM functions");
+static unsigned int ntb_max_tx = CDC_NCM_NTB_MAX_SIZE_TX;
+static unsigned int ntb_max_rx = CDC_NCM_NTB_MAX_SIZE_RX;
+module_param(ntb_max_tx, uint, 0644);
+MODULE_PARM_DESC(ntb_max_rx, "Maximum allowed NTB RX size");
+module_param(ntb_max_rx, uint, 0644);
+MODULE_PARM_DESC(ntb_max_tx, "Maximum allowed NTB TX size");
 
 static void cdc_ncm_txpath_bh(struct tasklet_struct *t);
 static void cdc_ncm_tx_timeout_start(struct cdc_ncm_ctx *ctx);
@@ -154,7 +160,7 @@ static u32 cdc_ncm_check_rx_max(struct usbnet *dev, u32 new_rx)
 
 	/* clamp new_rx to sane values */
 	min = USB_CDC_NCM_NTB_MIN_IN_SIZE;
-	max = min_t(u32, CDC_NCM_NTB_MAX_SIZE_RX, le32_to_cpu(ctx->ncm_parm.dwNtbInMaxSize));
+	max = min_t(u32, ntb_max_rx, le32_to_cpu(ctx->ncm_parm.dwNtbInMaxSize));
 
 	/* dwNtbInMaxSize spec violation? Use MIN size for both limits */
 	if (max < min) {
@@ -181,7 +187,7 @@ static u32 cdc_ncm_check_tx_max(struct usbnet *dev, u32 new_tx)
 	else
 		min = ctx->max_datagram_size + ctx->max_ndp_size + sizeof(struct usb_cdc_ncm_nth32);
 
-	max = min_t(u32, CDC_NCM_NTB_MAX_SIZE_TX, le32_to_cpu(ctx->ncm_parm.dwNtbOutMaxSize));
+	max = min_t(u32, ntb_max_tx, le32_to_cpu(ctx->ncm_parm.dwNtbOutMaxSize));
 	if (max == 0)
 		max = CDC_NCM_NTB_MAX_SIZE_TX; /* dwNtbOutMaxSize not set */
 
-- 
2.36.1


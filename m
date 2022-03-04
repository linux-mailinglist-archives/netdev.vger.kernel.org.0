Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E031B4CE057
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 23:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbiCDWo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 17:44:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiCDWoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 17:44:25 -0500
Received: from mx0d-0054df01.pphosted.com (mx0d-0054df01.pphosted.com [67.231.150.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A81E21E01
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 14:43:36 -0800 (PST)
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 224LSl4V027177;
        Fri, 4 Mar 2022 17:43:06 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2058.outbound.protection.outlook.com [104.47.61.58])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3ek4hy8n9r-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 17:43:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G0UWhv1dIhv1PJ0QpKMwR3w5KlBNVuU5qJEMQNITlt67y6pkyAqaY7jir0eObceLSzXQoqOgETfrSPiJoz9wnma9h5cDFBld0dKXawVKsiCEnpJdWN+t0Oln7cSb8T7pB4nYPnFWsI+lQ4MsPtpHczbTNEG4iI5cqJSdbfOgwJ92jA1DY6NdOuzRbBxi3/ZVwiUL0HZBvam715WJnMPkUj7CpxtRCuY3sAjxPEdl80+uQqZPokv3Ck3S/hxYcQ+XlH6q06F1BOFQdiDE2WLzVmK+bjsn2cS95qG2ObjzDwv6WPGKjy72fMnhuCTI6bEt0toW6B2Hq2RZL/hdcrt0GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yUCq2UikCIWxBI73BK0upvu2ClQMceTulwcjfUe1u8o=;
 b=PQ+/b/k0kCCBhHjxOoCleTYXlKZe39jAHva4L0u/HCNxiZi6uInZuYgbVDfVY8rPeawP8igOR4oQT78SPa4NqYYlPwRiutjYhwcrvRy7N4jhPSfezCJPd0N8+4yJEQkZCsOoct/NLCON3NNV0Zn3HqKt5hItekR3xUUrDQriBFchrRDo1XPN7Ozyup7KPbULGm28jW0GrNog9Z3UEj0/2ZFZnDlEQEEp6Oy3YgkK4MVgUkufC6l2TbDWfqcGzY8V/D/FF5eRzAsFDaXsVAY+1d15wCrEzfVbWe9VRV4JMi5oqq6phAoijny1GhRvyDZfYCJw55hHM6qRmEp6BzX5HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yUCq2UikCIWxBI73BK0upvu2ClQMceTulwcjfUe1u8o=;
 b=M6FMtIza8Wwf2JENl1MIFnqFvWpNyfJYqfFd4661o7t9M7CsToHn41WESuof0pOlBkSxVmFGUykgnaWmxQif1IFvtLN4WE8yu6w94gJumtnEAbZBpg9zaq+vEtBfyLx/pB06y+LrYtnJ9g7i1jg09D2u07O8V5jiHv0I0KjMmfI=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YQBPR0101MB6540.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:4b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Fri, 4 Mar
 2022 22:43:05 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230%7]) with mapi id 15.20.5038.017; Fri, 4 Mar 2022
 22:43:05 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, michal.simek@xilinx.com, linux@armlinux.org.uk,
        ariane.keller@tik.ee.ethz.ch, daniel@iogearbox.net,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next 6/7] net: axienet: reduce default RX interrupt threshold to 1
Date:   Fri,  4 Mar 2022 16:42:04 -0600
Message-Id: <20220304224205.3198029-7-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220304224205.3198029-1-robert.hancock@calian.com>
References: <20220304224205.3198029-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR13CA0005.namprd13.prod.outlook.com
 (2603:10b6:610:b1::10) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 02948f60-3f55-4e40-b505-08d9fe3058f5
X-MS-TrafficTypeDiagnostic: YQBPR0101MB6540:EE_
X-Microsoft-Antispam-PRVS: <YQBPR0101MB6540D4377217E6D0672092BBEC059@YQBPR0101MB6540.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jNArLeva2siiSuNMnt8rUlAJR19wFjDlPr6vi7cUVU/8okp0yDSgCNnHwXJtdU0TwwZqG3hNejFP/vfeHoTNLqpEozEI2NmgUqDo2stvSju0LEFA+y3HYy+NiGwX+5bpcdebt6Zp9A/uq7PxhanhQokizsTz9jc2jE4RNCegXJ2grxlr6aercqBPqr9s/ld6zi6QRZQe+4rGnXl7tF+14wx5rKQCzdrQUkRZgzyf4SCFT7JGXh1KpyAdhzfnZ/0qQEDhmQviwtnJxZkIGm4GwzMG5pASZKcac3ESJ3bd3p+5iV7qExMUou6AlB0hPqupD6+Q+sPElH6BinH0083LxFu9zMeco/59KD9MYm8FtaDBBrIv/TqSZKqOlFQzcwX7t4+3p50x0jITJ2KzM7hjiJBlYNqcdVDVPtqV2aoYIz9zVwXvrXrIfcTxMltrSEianK/ciWh4HZeHJhy7H/yEV15ku8FSrOcbRQaVrN8zmy4nBCkahwUKPIp1eOUoB8URhGy+lganv9L29JpbmyluuevBGvjHzK8AIyFOVSRvyTqF27+CYkFY4ijGnGAb8z4jUVig2RxcVM2Rav7HIsVh2ApLzQZzEV9ahSSkrjhOziAHIMMMaRflUcDAk0RMbLmbG5hjJKEF52/6ogtdM02jYCeSq5pKUR7JEdU/z8vMBNSUUEzyKAzFqzXafKzukKceOunDyBd+aimXGYBvjqNOwA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(186003)(316002)(2616005)(44832011)(36756003)(1076003)(6512007)(8936002)(107886003)(8676002)(66556008)(6506007)(66946007)(2906002)(5660300002)(66476007)(52116002)(4326008)(86362001)(38100700002)(508600001)(6916009)(83380400001)(6486002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7ovw3TKADqxkRmWn5VjfrMtdrQLalMi6qjuB9Y3zZa8EpLvBpXutqtTOZwCg?=
 =?us-ascii?Q?Mbzeh1lH5Ysx08lWpXuGDZp/VdvuHQVr9BUt6H3glinQtwtb0QPvYmgSSBrC?=
 =?us-ascii?Q?2EUF5v4jk6cQVOJww5LBaKUn8dy84I5V0qFtNHw/Ev0oqGPHP5I3p8oGu5DW?=
 =?us-ascii?Q?c0xGx4xdbVQfYGybIgGz/o2KZLQpH4ZXiq0tyA1PDz19H4Ivu/nAtTMbZA0e?=
 =?us-ascii?Q?v2oDXZ6mIKgY7fIe0YOTewz+icv1M94q90iI8nLi1JOutW/WII5TusKmnPkL?=
 =?us-ascii?Q?/et7OP7Jlvtp4bzSyRPy0hp2/a92G+LdGGfLg1OEjM569IgpUv4QPqBB2QFM?=
 =?us-ascii?Q?exB8aDs7q+OqFQ/sggbaom7FiED+Dn8LjrEQpo1cmBxUmQb3NaZPqzS0ESyW?=
 =?us-ascii?Q?Lqq4DDlkSMrf1GEK8QFn1rSRUAWdIFHfzRzqgaFMOj4fT/Q5tPIzDysSM0hU?=
 =?us-ascii?Q?imXgb0cPdMOMIvAbFmkkIAbr27ndKrUP5v/d9psi6YJRIvrX2faHnYGH7pE/?=
 =?us-ascii?Q?vg+nnZQw5HRIikoq+e2RMCvB36HNgjuP4W8hAzRtTkNgFFjCpZOmoSxSBkeU?=
 =?us-ascii?Q?Jg5SXmqLZLOHIojQgs3TA4J633jNsPyh/KtGerhPu+jsTFf6VDY+O97zTF6G?=
 =?us-ascii?Q?/Oo7Olf+m7+v42AloVEO582PaLsA1yxr65inJm7msVjyElyicRML3yWNhrCa?=
 =?us-ascii?Q?Femd013qB1MAL2B/YbFBLuBZ2eaaBXVBhFVJby4WJstkbK9+VouHZyTI1ZzR?=
 =?us-ascii?Q?q8i/m7yCR3+ggSBWHRmtJ4gwBQ2O7NoOCsvqUYKbnVX1p3qCsVuocD7pCHxM?=
 =?us-ascii?Q?zHcK7krUQuVS3Wf2Gh/kWIx6owOdtFbaYdSuWNX4OqSMvEppOOg0DgPfdjly?=
 =?us-ascii?Q?Idfr+G8duQ4lUwHyoY9wFWffEHmmyLTBguph2zlGgUeq3asuoHif+O+CDWwM?=
 =?us-ascii?Q?dGB2+r7ZP0t5jQYMbE50MMccgS14jbSKFdMa7dR9wsuTdGvIimGan9rmSJE8?=
 =?us-ascii?Q?Afp5KvOLq++KKBZz/O8FRMp1uDYQ8eiFAofQ+jkrCEdxAqqpeYnaI8/MD0vM?=
 =?us-ascii?Q?CWJRP6g5tuBcsMH6Hr3omYMaJ3Fvf4E51+xxIuBVSYGNYUquN7vfja9ZzHOw?=
 =?us-ascii?Q?pOju6KZMoM2GzUiD+IsR6dquFrDujJ6ExgkUv1G+MMR4G2yNNETbgmk/RCwS?=
 =?us-ascii?Q?SsZ9PzbYU4HTACgwhJu0QM3ZImkQwunZkUwYm8gPJ2SznvN4Q724DLjsnXM7?=
 =?us-ascii?Q?MoZV1rVghjydxFW9L60erw0foXjBDt493pYMf3EK2M4Op6rJzJ2bmCmu9VJY?=
 =?us-ascii?Q?JnuE3GlJJgFw8H6dc3w8XT2RXmW2yo0tZzITf0wQdDiGvzS8zjtEbJSt3dse?=
 =?us-ascii?Q?FuEhz2aL/pLR5jZm1wu7cDisu3Calx32avZIF/eWXmwHkPxk/Wzyu1DNZeEE?=
 =?us-ascii?Q?O4l6fmhIYSOTM076zbm7YCwalCSCEgM7pVKdbD5yaARd9SxwL2T+n3+03e95?=
 =?us-ascii?Q?VFYuDGm6yRx/gV0chGzPRRXw7iv9MyyP4zQvxbkKd2dJoa94Sg5lXcyR9Egl?=
 =?us-ascii?Q?/V1dILR9jF7UdB9G1Mg7Op7xlIF1H9sAiP00WEHEKf4OZkr6CIFBjEe6FeEv?=
 =?us-ascii?Q?FE2Q4VUlQXsurkHC06xsWwFUNuZIEBkG6VJ4QsvjjS4IgnVqDzyiwJeEmmrI?=
 =?us-ascii?Q?CgmTsW1DY9ml9na9XS+BEAknyzc=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02948f60-3f55-4e40-b505-08d9fe3058f5
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2022 22:43:05.5581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gNxK27OJqKgqpYvLo7LTVvHvve4aJjlFKtf7UTWh2hcojZ9+q4WjzQd5tFDN/ynZ2KmkZkD8+lv5AJAr1EJekC56qjLTIUB9EoI6QUesLqs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQBPR0101MB6540
X-Proofpoint-ORIG-GUID: SJS811xqcRik8rDsSCLk7vx0Ws_FXFVn
X-Proofpoint-GUID: SJS811xqcRik8rDsSCLk7vx0Ws_FXFVn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-04_09,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=6 lowpriorityscore=0
 bulkscore=0 mlxscore=6 malwarescore=0 impostorscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 mlxlogscore=123 phishscore=0
 suspectscore=0 spamscore=6 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203040112
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


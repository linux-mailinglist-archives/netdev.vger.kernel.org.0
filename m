Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA8A84D8663
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 15:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242094AbiCNOFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 10:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242092AbiCNOFF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 10:05:05 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C39336413;
        Mon, 14 Mar 2022 07:03:52 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22ECkrjE018640;
        Mon, 14 Mar 2022 14:03:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=UoyzzNxvu2a9iyq+pwhTOkGKv2YRzrl0Fur85aDiaIg=;
 b=bYcUGFcNmyspzGM59AeS+BfHKfLQiDNYC7PWViSpl0pNXry2gRLM88TPBhatNl8OmrZb
 yUeoFixM/VIoMuLhUANUwGBG5O7MfmX4CtJOckzn2n+3WeLpAz98IsOg5UiM3LvJR+Eb
 UahCqTv9K8aPssO8oPrG4niqVQUo6bwN0H5MmOOyaRw89q055brmQva4h+R6/sgK+Ctc
 dJ2KCE/eUKij159AKxQnjUCm4ynjrzC5Too2Aoh6cWy27JbVbbYG6NxQ8b8y2MLhoyUX
 wZQ1g3rpnBeAKwKMoqskkB92UTMWc4w44b7C1XJ8QYllbsPQkntPulyPqkQNmiYeUjpR Uw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3et60rg8uu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Mar 2022 14:03:41 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22EE1ToO132314;
        Mon, 14 Mar 2022 14:03:40 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by aserp3020.oracle.com with ESMTP id 3et64j948t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Mar 2022 14:03:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=duqzYJxsbHDuRisadcPOxfbY7kjNxHRjRoAXmrH4Ew5OAk9/PwJqttqtsuCSKZ0RnWsC0/3mmXRFNe0JZCdmYhXswnMI9x6FCfl/j2wBRgeyzP1RCUEF9BDMRsGIVvPM8PqJeYpZNleM1xu7cny4PS4BdYEObNhGb3ex7cJgxanH1tS1Zl6L/cQFqZYomSQA6jTqrlck4jNIaXlyXqOm9KdLp+VbMNI8Cg4VAqQiKEuUnwkBUzmZQZBhzGhoxLIlvobO+c0BlieAYJbKKP18YktBPV9VuUgTC7uHo46CswWztA7Q9wJkZVgWPsGCpj9JIAVvXt0SJC1oKZLumF6lpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UoyzzNxvu2a9iyq+pwhTOkGKv2YRzrl0Fur85aDiaIg=;
 b=Kes0dClqtFM61ECzhwUOHk1I77KLZzOYuN+CSI/6Ke5xXAk+Ryqy5Etz/+s8G3TlT1B4V1Ful+Hf0AQwS0v4S6XdJtPib2Zfe+r5u8jtjdElBgyzk47um9tvhv2oURromyD3Jeymu14urpP8WLLCkMp+cKVG7N/vqyYAB0r0mz0GXVnRL8Z7wU15QONA5U+uGdmtCiFeS9pMygP5BF4AMfumd8yg2yNhYfADhfZzNfUhjV07+dCHcpD5XhfjqtsEJ+wcCVSdtvtiQebAqjTFiaCTgyndBCHWUDVEnWPZyRabKe1yiWJeeewGR7r5+k9xQSXQ3Cia6f3X5KT6Y5JVMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UoyzzNxvu2a9iyq+pwhTOkGKv2YRzrl0Fur85aDiaIg=;
 b=tKTNpK9VsF2zKOLHTLM7YPTnXpHcc2QHqeNETXVJxLzQDwEF9o39ZPTSrlBvVLZr6nH/KUISlRyzPIYlrI9HfigU6mOO/vVqQTHpqD3InoBEb2aKXXP5dTf+OfwMoA5cDfP1bkF3biqxS73MMcon1pKrDyWmTURGaIWnyyXtM1A=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CH2PR10MB4151.namprd10.prod.outlook.com
 (2603:10b6:610:aa::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.24; Mon, 14 Mar
 2022 14:03:38 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5%4]) with mapi id 15.20.5061.022; Mon, 14 Mar 2022
 14:03:38 +0000
Date:   Mon, 14 Mar 2022 17:03:27 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] net: sparx5: fix a couple warning messages
Message-ID: <20220314140327.GB30883@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0050.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::19) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9684409c-3449-4f27-6832-08da05c36fbc
X-MS-TrafficTypeDiagnostic: CH2PR10MB4151:EE_
X-Microsoft-Antispam-PRVS: <CH2PR10MB41516EFAC8BE36C1458F43688E0F9@CH2PR10MB4151.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DyeXZd1HeuMgkWIVc/Volhy/QqDC1nhrReWpakX2JcQGi3HgHQHDQYKCAiacYs8IukdgDpCzf28c4UGlBRRrqMK3kAUhzC/Rp3p2iB7T69zm7g9JQg21FMLgC4En5ga7lbPTHEx/z74KyHggG9SsXt9VTX7Rz5Kcpehl84ORdVMsWgibeCOaivAxkJbDTa9XtyhFm2S4D5Z16p3IeBbndJ5iFKaxtJtizYK7/42FKiS2akZ1+TxTVZIOPNRH/wr8t3HgHb02x0XXD2YNI1izoKOxMyw/1z35+zy7t4dSmos8rcxEE79yWIo1ZzL/4aQmQreIuuI9uEbpCQfW+sKTW4herNCvE+8TH4m26S01q26vfu3tVehWw9pN5unT3hesP7JjzxjpYfejcN09oNEYBKWikC1xR4SU3HnOcg7+rSL6av1K8GKdM1IngmRSfonRdjTcTXh16z1/8Tn8hhR47wnF4cRrhCefJnxPu6ySbqiQyy6hjASEKEYa2h0HC+IbP1wEXCwDMhv6yRSvA7hMj6yYLmA1KbB2Mhf96zW/Po+ZKjcbQK7sG+ijUwlzJbQNxs4cI0/Wa3qpSZIXj/fwM6p90fjrzhj1n8wmFSiNFE7lKv1XZhlA44Z3hDmGi0pFnePONmmiQybGzbNNxefB7PN/rmnXsdgzIEQIHxVe1O/WXEJzJkcGCtd88fbsayeofIYmh5zXfrc4t5n+FvqQAQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(33716001)(6506007)(52116002)(9686003)(6666004)(38100700002)(15650500001)(44832011)(508600001)(6512007)(2906002)(33656002)(83380400001)(38350700002)(6486002)(8936002)(4744005)(110136005)(54906003)(5660300002)(1076003)(186003)(316002)(8676002)(26005)(66946007)(4326008)(86362001)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YfPVRN2UyN1H/hLgYYPeXr5UtgV0O7mxbjQ55wSH9WLIYQCoLA6VEQSDh/i7?=
 =?us-ascii?Q?LwUcBMVT4ZF2iUTCwBgKZejVZA98nDBOleO6xXmwwEVLuCDxsjSb36TUsngr?=
 =?us-ascii?Q?XuB5jZaG0Njyf9TlUCJv/AcmSt4iTHZwHG35W9DVg6tdh9ZHnwoKR3BagiLr?=
 =?us-ascii?Q?mItxtag/tQYf++zJbe3iVePEBOw/ypHPpW5UckdUUSxyfVOqijsZrCejkC1I?=
 =?us-ascii?Q?l0WsAOpVEBywAvkS3RGDAzsqy0at+wDd9DSmQHSXfDKcOuAUvwrdLCHq9vXM?=
 =?us-ascii?Q?YitsM4o5v8K6VK28aAl+rgN6ZSNbSIIhdUyBkBaf6hfb1JT4Tx4Wq4sTg64b?=
 =?us-ascii?Q?+qcmM4bQXEPfniUwIvucUxCEWF5AsixQJiL2mgNGVmd9VVUIOlUoAEPSCjH/?=
 =?us-ascii?Q?SLXUkL7UZzIwB22fnDpsyEQ+Kd58C052jeM8c9CpUNObrmVtvANdLndW2Ox/?=
 =?us-ascii?Q?RkDuu7ldXVluuRAcDzHzg9KCeAQA29BnjFxgDIzCD9AY9MCpwhm8Sdf4vklF?=
 =?us-ascii?Q?XnTzXhZCQXw8b71MglvlDjHzA3MW9Er/MfQ2j/6sBbnBPAlca5gEjwp9uS0E?=
 =?us-ascii?Q?ArEnFlZE+o1ZWsXGBDqn+5kngEboRF3PR+rhUILgbpNiJmIQGtMX5MSRoV/7?=
 =?us-ascii?Q?CDpoQ/TQjCP2VUSXCApqQl87ZYNtGRRW00ibCBxjsy0rVp4p5wi4HHHKdMMM?=
 =?us-ascii?Q?tBheXSQSWReJWTK6rgDbIi1tdo6tazODXavP+HDWUsp5Gl6GKu6ybR7twtC4?=
 =?us-ascii?Q?DhimvwaUAX/FWAJBEPHkH/JlobaJRculwc/hMDCYmiUBg11+rLflutEBUzbR?=
 =?us-ascii?Q?NpVD+dGzya6RRteycd/fbJd4S+PWKwqiM76PWXmQcS05IiY4bG+AUHPlmlxo?=
 =?us-ascii?Q?EIzpOfjjPtgmHaDFuKIe/lOJnMyYntThmXJXd0PzRV16tBvHx+whAhiYdKMg?=
 =?us-ascii?Q?J+BNskL/wJSvhFntr/9sN9V1lelyxFZm7OyjzzepgASSta/nNXFk42eYMJ0v?=
 =?us-ascii?Q?ayVYWKqQggXYdF3YLsyk1cI3heh6Bz8DyX1Pi8UHEVH8eeSTeu0EeuBUoJsO?=
 =?us-ascii?Q?eKXdglBuPUl7KcRIMrgFr2uY+0d4aiOhuXYiWkzQycP3y+bOR0VvvVpZEopi?=
 =?us-ascii?Q?mu5SIrg9WhjvbaH+xDsuIsz+EdAF2Br+5Vdzh+dfzBBaGtyUuEkNYGs0sLVY?=
 =?us-ascii?Q?G15IPTWE3RR6SKcFDTnqegdyBtc+8yqNHCSLLNSjQYiapoRyLTMyrFuzVsr7?=
 =?us-ascii?Q?VEpdZ2mI5bAm8gWD6MTyglPuIUk5SD5M2p3d+btaBpQoXEMaoV6jNi05+3to?=
 =?us-ascii?Q?008Srbu8Hg38leXpj6Q8Ycx9z07cFBGDM9ZWm99nGoz2m1T6/reUmPN/GHZ2?=
 =?us-ascii?Q?9Te4G00DDZasdShDhV6Nje+DXuH+avf4Kdhca++zvOUCvZlF7HimamoFYszn?=
 =?us-ascii?Q?9HA2szfuK1Ns6wF6b1Uasg3ODjbC3QwekEAflJMIbxsrJcOj6Fm+mw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9684409c-3449-4f27-6832-08da05c36fbc
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2022 14:03:38.0695
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UvueaSHUijfMl1WX4IlTpRqpeFpOq+kN4l9jtULeoujc9u4Ccfts4z0jfgCTMFPCJToLIo2pOii2DXAjMtHEyb4uuX21RdaWNVBhCDL+JkI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4151
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10285 signatures=693139
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203140089
X-Proofpoint-ORIG-GUID: OqQqAl2mniiitdwJQZ44RMpuhbvlXNm7
X-Proofpoint-GUID: OqQqAl2mniiitdwJQZ44RMpuhbvlXNm7
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The WARN_ON() macro takes a condition, not a warning message.

Fixes: 0933bd04047c ("net: sparx5: Add support for ptp clocks")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c b/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
index cd110c31e5a4..0ed1ea7727c5 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
@@ -45,7 +45,7 @@ static u64 sparx5_ptp_get_1ppm(struct sparx5 *sparx5)
 		res =  920535763834;
 		break;
 	default:
-		WARN_ON("Invalid core clock");
+		WARN(1, "Invalid core clock");
 		break;
 	}
 
@@ -67,7 +67,7 @@ static u64 sparx5_ptp_get_nominal_value(struct sparx5 *sparx5)
 		res = 0x0CC6666666666666;
 		break;
 	default:
-		WARN_ON("Invalid core clock");
+		WARN(1, "Invalid core clock");
 		break;
 	}
 
-- 
2.20.1


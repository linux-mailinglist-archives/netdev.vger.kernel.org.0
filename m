Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A51764CE23C
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 03:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbiCEC0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 21:26:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230349AbiCEC0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 21:26:10 -0500
Received: from mx0d-0054df01.pphosted.com (mx0d-0054df01.pphosted.com [67.231.150.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 840A722C89C
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 18:25:21 -0800 (PST)
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22526BSB005431;
        Fri, 4 Mar 2022 21:25:04 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2052.outbound.protection.outlook.com [104.47.60.52])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3ek4hy8qh5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 21:25:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CeOJoBMSR5uV01RQSOrmvY9Cq7q+ZiNrz18n0MqvMgZhstOUlDwVXJwZZxVSrLmGa5jvYSYDCjyg5ABNIihhniwue17Sb3yyxJ3rcbYr5bQFjTW7HeEoQFBiINUo5Hd6m6+WBGMrLlY43U1i6+eApfrQKeuQDVRTGfoK4i/71Q83nRTBP/kYnHU7zWOwqVCg8q6qkjHT2iRiNWSjqz6Dtos7ItHr/aRnl61pwM2GCLGdVZ9NxyYhOuB0htRkri+tMTrcRuPxD+pn/euvbcH9v7fCrISxiot5leAZO6Vd3Iq/H+yiHcxAPLsUX8aiAkIOyn1i1rphwKOd8Wi0NfjmZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yUCq2UikCIWxBI73BK0upvu2ClQMceTulwcjfUe1u8o=;
 b=eNB7Ryt+Jt2e0j684IDfKW9bq0JD9wux6d3ZENTNV6CzngloyTAlpMpfb5iVZP/ZbGAweCLOq3zrLydczF9Y1zfVhPM0wvgbGr4msUywLo7gbXn9N3pDNuCsWsTSxiwstjgrDgdGJGPqOMGmHEPgoUtyFPTqtk2EUK6+PKB/IszRsEOz1G+2ZnweWsK5p0Bzl3L9jcyzel4rfCDqbDBHQZUnHTNdKACUgmVaX84xWBdUk5X+9f2ugZNpRYx2MUqASLBmSPl7E1W+O04g/61loUpc9ZsWcREBJ3YLSM31akN4MVwxTDNHV25B80c1GiYJNDAD0t1ouEoN0B9R7qpteg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yUCq2UikCIWxBI73BK0upvu2ClQMceTulwcjfUe1u8o=;
 b=l9P56fJEZVZL1lEj/LVhgyPXpJg/gHJPGtJpuWcBhe2kHzLGx6/ErvQVWvA7LHF8kE9hOQF9OAOoDmFO6v6JRmxMwDYwMP8KNTN2GVR+YjezBG3l2aMEYeCInY6VtyA2ueOcWqZtyuhnnLOD3qD+bRDk4KAoFzE5GVGWWFnOqoQ=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (10.167.1.243) by
 YTBPR01MB3184.CANPRD01.PROD.OUTLOOK.COM (10.255.47.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.14; Sat, 5 Mar 2022 02:25:02 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230%7]) with mapi id 15.20.5038.017; Sat, 5 Mar 2022
 02:25:02 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, michal.simek@xilinx.com, linux@armlinux.org.uk,
        daniel@iogearbox.net, linux-arm-kernel@lists.infradead.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v3 6/7] net: axienet: reduce default RX interrupt threshold to 1
Date:   Fri,  4 Mar 2022 20:24:42 -0600
Message-Id: <20220305022443.2708763-7-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220305022443.2708763-1-robert.hancock@calian.com>
References: <20220305022443.2708763-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0304.namprd03.prod.outlook.com
 (2603:10b6:303:dd::9) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a0074cad-fa35-48d3-6fa9-08d9fe4f5a9c
X-MS-TrafficTypeDiagnostic: YTBPR01MB3184:EE_
X-Microsoft-Antispam-PRVS: <YTBPR01MB3184F09D48E441E1A8011F90EC069@YTBPR01MB3184.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QtcUsrKpqv8yeVO96ZLHcJZK1F5pzZCQ0o2FzbOOJMZQGZQt1kvIwYavhTA1kgRrxUPGcnlu5YhOFIJwJPPgQeos7AiKDKO/0Umq1CbGkdaxROXuAXC7FiGv64AC5eTYT2j7+nBoqtQ/+E47FwHyT1jGu83AFb9weQjmEXf1WPr9lZJ3pe3IQCn8ykFJiemppZ7vhLKnXf2aWHtMkj9FaVdGUmMehuBINtMzty33/MyBW22jVW4biC9KYZvuqFkPrIMORMqjYxG+wr3YY5f/wKI9OtYGTjicZpjqDTi6yfYcKfd1rVrZo4a1jSSP7j1tzbFe/d6bH8CkiRECos0RhZbYn6TeqYY/hpop9ARpj7Huhv5us2t/vWTsLOOItqx0LAJ4XVdTjtj8ld+Mp5f3VRS0Fsi/9aVo2/pl2hUfIpcn02IPN6uu1U/zYnlUwKFTL4bb32wFb3Ms9nCCVFzLrkuU7hYiREeyti4vq4z9P2+UEneMZ5bkwTN1sAerfr6pXA9Ke6/tZXcweXu3L0k+Th+5smyZuCyT/h4N/xU8MTkFbcC0LLnCirBUlTvvgQlyJ4SOcxFWNMmIfMCPobK5BAYRTMoJ8Jn/maZxVIj9Dbec4wbiO/vjlV58h50iRVUo8kuw5rJZjFw2tKZS6cMRXItVcPFOUyU95kxjLgn5H7dF7jJxMaGK5ZIovk+xY0MnvJJw+H9jNW/3IAyyfBOQng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(2906002)(107886003)(5660300002)(26005)(186003)(83380400001)(6916009)(4326008)(2616005)(1076003)(8936002)(44832011)(6486002)(38350700002)(38100700002)(508600001)(86362001)(316002)(6666004)(52116002)(8676002)(66556008)(66476007)(66946007)(6506007)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QI+WwfJh4JqbufL4KrnQLgHOVjLjqQ/0YDS5sF2ds0IaQYRVeEWR1l6JiHKz?=
 =?us-ascii?Q?p/iQfU2TWX8neoOL70sY/IVS7PXIHTA2WnR8wEnHWUakpAwhRKy6+rG3rSgn?=
 =?us-ascii?Q?kwNteqcHMRjTOOqfd/VPS3063HPC4cjrTVMPlKLk05mxXuRevYxaMT1cPcGU?=
 =?us-ascii?Q?jQ0s66E9ZnfqgsAmcwyXNqTcEdCkMPvUYItCg1m7CUqJ61pxxilaOayKx2LQ?=
 =?us-ascii?Q?+eYh4kbBrkMBGxIAi5aQuu0vDOhTHtgd7xzD4m/+r0Rv276Fr2feEJMyIS3y?=
 =?us-ascii?Q?ithm5dJ1g5hR1J8ZsSTJb/tnqtug2vBg9EMLSW+4CM4w/B6rPUtBl4kFvaab?=
 =?us-ascii?Q?ij0X7Zxon82PrD5g8u5Kj/qCnRzkpZA+OVABJmAY1bl0vMlcCYe908FooL1r?=
 =?us-ascii?Q?t74ZieyeAu/gwT98HcOBRFrkHYli2tdVjwzT9mM2+5TCRWaCWc/p2bwBrKpO?=
 =?us-ascii?Q?JI3AF56c9uwAjNVikPxG7s2qwQebSFLlWQcBwERfJcYmRHwKelv1MyKlTJcQ?=
 =?us-ascii?Q?O1TDE0Lry6fqkl17KLnxn+uVIB33LABzGraTbAKuHTPUgo3PeMtFB9+bcBpd?=
 =?us-ascii?Q?o0S5wW+6s+41Cp/fciHRSuHJDY656NpGk1Q7/iz5RmeTALeKJSTqdFohV0Yh?=
 =?us-ascii?Q?UREIqbJ51njeRhnCGjHH8eN2+YNZUl9byAUomih8cR03bJwxrWWEWVWk+L2E?=
 =?us-ascii?Q?iRd+XiA+gDaebZjTDROdhF5ZXlcWLT0Wg1ZeKP/GCBkBAlvc+zvhqrwu44hY?=
 =?us-ascii?Q?sYiHkGIkivkAo64Q7ijlc6dR83NoEUlXrXFHATAIiPCvggHs1MQ970iJfj3+?=
 =?us-ascii?Q?6VV1dswEabU/0ag6ceUtlfguHb0ssMzIJuE22NGL8Q6W72/vFbn5szbTfp8E?=
 =?us-ascii?Q?AKvigAy7ro4CH3NaUcVHNt1+w1uRhNTDGO8Hs2MLX1Fw3zBiIBGjcknxeAN8?=
 =?us-ascii?Q?x179oWXxYKhINmN5q88eulvC63t3YhZVwl9S6jBZfLNf3Qu+9doFbGFPJYAN?=
 =?us-ascii?Q?fnV7nlW+ViNLTddqTz0HzqjETCyp2yzvQVajCdI5AQmWbivZtaw+7u3cT/v7?=
 =?us-ascii?Q?RZCVcBNGqwLwgCdtwoDSqAc5gkUz9C6+ixJWwb+Rvg0dpqGBNi8AFfB5sScT?=
 =?us-ascii?Q?25udxEThoXzFW+fq7fMGGqWCao3UkTnmfKV0ST2xwS1YDBChVGfcGSrl4Cdo?=
 =?us-ascii?Q?IfMsOI56Ru3xuUSzFvrfEkw6uZIWzewakLIEqF/lVO/6DcMPefIprgQX0Cd0?=
 =?us-ascii?Q?4RGV6mFd/HZwe9VYvizQyH1vuEh6Wn2wtG4nj2YBUQFX2Xo+eRO9fEihqXqN?=
 =?us-ascii?Q?pacZOOPWM7TKogEpsZ17eJ8spqDuwPTgbTjPiMpN/Ox3Yo61tQNR056coc4d?=
 =?us-ascii?Q?VmyWbtF/tDSilV4ggra8cXbzXB1bVqhQPFtEvrBD4Yrt5rFVW46Lru4ZsnV+?=
 =?us-ascii?Q?35VTy4o7J+fsrrT3Zgt/yr/xNTIZEXq+nXe9DZ+2dGkbWajlWdg5FosNb90K?=
 =?us-ascii?Q?GGbRQjvUk/xXMMuXkRZHATmAjfOd2Y+SL5OjRpwX9v99FdwsDDfde4HhdjFj?=
 =?us-ascii?Q?jvUftpYF12rfl7+K/0Krkaah3N09NAi2pxvjpzFWIWkWEbHY5HscVJHKmgPw?=
 =?us-ascii?Q?zqRjH+SEgUVyI1BBiVXgwqhyBPiSdvniImsXZFexnkqKyt1Lj9i0oJZHljS5?=
 =?us-ascii?Q?j7CZUftvVZbguX4H0acKyAeGTYA=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0074cad-fa35-48d3-6fa9-08d9fe4f5a9c
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2022 02:25:02.7417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Lgda7qE1nixrZ2LAobt2kgDh009cNWRlvWTOQLyR335VsbI6pEyndbemjiIAEzCMxDHYM5QpQNGPaI1VUjXUFgLkmEmx+ZCsmlgsRAwj14=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTBPR01MB3184
X-Proofpoint-ORIG-GUID: WYbwRX_PFtlcwGcJ3fqn0rU3sYgDe3rG
X-Proofpoint-GUID: WYbwRX_PFtlcwGcJ3fqn0rU3sYgDe3rG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-04_09,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=4 lowpriorityscore=0
 bulkscore=0 mlxscore=4 malwarescore=0 impostorscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 mlxlogscore=141 phishscore=0
 suspectscore=0 spamscore=4 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203050007
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


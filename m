Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBF3B5680AA
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 10:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbiGFIAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 04:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbiGFIAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 04:00:30 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 421C022BE1;
        Wed,  6 Jul 2022 01:00:29 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26663xSq017792;
        Wed, 6 Jul 2022 08:00:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=YPqwHbET0roymnIDDSm+mS8s3QPcL0/BNaoBK1TTQIQ=;
 b=k7js0FOImpHuEVyjMcWv4pUQu1FlDGhfqnRO7ZpuAPQBZMSlP5sxVlqtnYRrozRcrp1l
 4KxttLomoEaBuha/4gjpKRjWTQhvl6YoGBhHygpbcRIQnF/CfcYBJmjsZujTH0MrmS/2
 JOTveePls6qPPF6ZMl+X+4hGP4SeCUtvYTZrZQvkbdYCoFT6YcxGIrzOZ+uz5otXrNAz
 55GN9EQ0FJZGnLh4DHto55/14c5/4XUli39hj5uj6ldvY/yec4SLRFniG/lKqMGhwTl+
 Z5j5sUMxUYt02h4K5u3vAWp+QI8tKlMZGENReDtS9cqEbTweafGKaOVvpmw+zWoK/937 XQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h4ubyh73m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Jul 2022 08:00:05 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2667tR9w015231;
        Wed, 6 Jul 2022 08:00:02 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h4ud7um9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Jul 2022 08:00:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TFKWyttzXjvj1O4UCpgi3poubiXFgQ5OTBtrlkX/3M7SGQK6XJTrhsxKw7gz0iCVT4ReYM8CSDQTvsN7M0QbYeo4NhVLyFXwjUfHeKIsKW58rcqMQzvbPuFim/HTMaszRx7OAvuYd90JMrxU3XSztEsbCUmV7aFGUHvFUjz5sRGzpnUJdOx8PGelOrhUPk27Dbolw8HWeD991qpyXZk1nVWAGUi2DRH0mega2zkozK5jWNm7uCghjftLVghTXR8swdtOWMAaJbKAEh0q26RjtVO3Qe513n0NChRl67I+AXbz9Kr0xIks3E7IfaNCg6cBfnP0JtSHXWur3ArgTcKVJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YPqwHbET0roymnIDDSm+mS8s3QPcL0/BNaoBK1TTQIQ=;
 b=Rxsh47za+tEZFjySwykQXVzNa3JTcvFLe3V3czoOIip/wYoF6u3g2c800eBY9e2qmZBiaQGf0CVFmNFDnKmZvQpXNIxZrK9ze8ufdMwjvlzU3dV24xc7JuJ8dDtLZD2jG8KjOAmpebVFaNW/IpuAY7S7fuCHqqC5d973L03AmMoNPiOArYy9KNDgAva0YJqQFEjQFJlpS+XCsfQw7Mihf+hyAQiCE5zrxlSe3cHJErmvE30w79me0CFi0y3nehbczes7Up00JgWxyAyEhyDFApXXSVfGk9G6vUzkD0bGUfWM1yuB+shGsEJDd9d130cDZZ6veY1EHLzPTIce6Szhhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YPqwHbET0roymnIDDSm+mS8s3QPcL0/BNaoBK1TTQIQ=;
 b=loSn3uKssALwQGbrQAc4KUNTcbX79L/CCPchOdUxiNvWqPTb0wiczmuGKGJeSaYSfKRwEaKBVzcXu2eXV4HK/aWViU7Ik/nMmW4Was9cbuiFG2O9Tx2embRW5iywOObId2n7/7IyOleoNepYTUSGWRm5hN6riD82MwzNBYMVjyQ=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BN8PR10MB3187.namprd10.prod.outlook.com
 (2603:10b6:408:c6::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.15; Wed, 6 Jul
 2022 08:00:00 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b%6]) with mapi id 15.20.5395.021; Wed, 6 Jul 2022
 08:00:00 +0000
Date:   Wed, 6 Jul 2022 10:59:48 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Wolfgang Grandegger <wg@grandegger.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] can: slcan: use scnprintf() as a hardening measure
Message-ID: <YsVA9KoY/ZSvNGYk@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: ZR0P278CA0139.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:40::18) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 68b4af58-d771-4a54-de4f-08da5f258697
X-MS-TrafficTypeDiagnostic: BN8PR10MB3187:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xarm9ymMtaEtE7KDGk7Ub9QsFaydIAWD+AVOw/cQSrbfOAUz84mJMYqsNQ/1Bvzzl4yoTqgfCb2SzEY4ruSWNH7dMRqVnrvSiAf4Fsc6nxPLQyP/3DM48XQB9HEoQNPLe5tuunH9EWVHvKHiNdNIQGR9jMDLPp/GIcYUjSxc08ws+atDpe0hstN5cXLkIA9HIoghGOjBzz4HYbi/Is4z5DevpA7R9hQO1akCHzUhVICLBsyXnqVc/XgZFJpIk10JY+Q5u21nO1mFSVVboY2MoPOEVG3KPnbbt8E+X33ISDx4+jJPZhxL/IHYJ6O/nNN/kx0qnWqIp0p6jbHjdYC6RyUCISV4xy7ClkakUS8MCOEew71X0yhzVXevuyxhH/L/y94xHbRIyY/moS5NHNbp/oWuz/imszQ8NdANOzhp4frgqZPULmlglFK6W0S9bGMlmJzDQ2fpnkdq5aXOXDSgMphdTz8DTMqdnLiV5BH8l+Tmbk04+SHcFfhJy1R98J6XUelszT1NvsdR4eRUq/c7jBfdBzMprHLkw0yGn+EwaMjBQu4F/vXRcBTZwr9IgXBBA4FIPo1kJEjJz/JxZflvwopd02zCCuTd+s1PrgRdE6zT3NpbyEs5M4fnbwKEzHziSZzThXV+6OZFlUShGIoWTK2Vmc8p6jVNkQ3NzAAHNCPp9Nto4fC9DuAwuu4ieeSwgch0N8ou5EjpfSz5HOZKjL8xbW2/Wkp4cKWTHsR0RBue6RDlHzCYws3VS2SakkpPgqIO5Iyh3MNDtzYqSD3/cu1+1MYAX/HVTQzqTcU8oeYezwgJfSKHX9/PbsbAuO/g
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(396003)(366004)(376002)(39860400002)(136003)(346002)(41300700001)(33716001)(6666004)(316002)(6512007)(9686003)(26005)(186003)(54906003)(6916009)(52116002)(6506007)(83380400001)(86362001)(38100700002)(38350700002)(5660300002)(7416002)(2906002)(6486002)(8936002)(44832011)(478600001)(8676002)(4326008)(66556008)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aaZFK2hSeH5JFsRcLISFWRFSWkAY7IA5wJctZIF8Osp4+r7M0T2F//j0MZy4?=
 =?us-ascii?Q?p6vENMUkALskwaOApcmAxujaa9bGW64QyiRSpXEIfCwuXbFZezuNKDOl3q5w?=
 =?us-ascii?Q?HvYcgIwdRSSpos856NI5I975tMvdEVpz3qlUBNT9bHBM7mhz+jWBbcu2cWgF?=
 =?us-ascii?Q?gp+n6fBKMy3xGimBWEfpPQJOM1VEUDLSVrXNwGkGJTCZ4kijByOceBLBLv5u?=
 =?us-ascii?Q?28q+IUdQieD+rqNC1SX5LpknnKSVSSDYY7a5WoLI20wCdMsySiZlpKdAJfnF?=
 =?us-ascii?Q?nNEpp8fPz++ZHxxI8kpEip1jh3tQbY4JB/HetPi6MpEbka/osK736YSKsLqy?=
 =?us-ascii?Q?LORCA3KoVn6V2yWwj350kJEtfqysL/5GQTWSRbV62zP/ata3mZ8Tyr7l7Dtl?=
 =?us-ascii?Q?H9K8TRqkRlOYAyc5PkjlWeIA2FctGh5LA1cpcdXvUJVFERAGJUtahJxMkbRZ?=
 =?us-ascii?Q?eo3RxgrKmbxUhKjs+DBh13sSrspIG9IamWyczwLaUyMKdMMGRJNpGtblCE7+?=
 =?us-ascii?Q?J4n7C9f22owN40/MUBrR9a22Q/GIlAFcUkeddFIOVTS/zc7Qi1/wn7ATbUdL?=
 =?us-ascii?Q?v/hKHIJxgAqzNLkhqw1RXqxIUFsm+UQpzZmor9PjjFn6vx7UKw+goafulGL7?=
 =?us-ascii?Q?bI1Q8vOT8MLLoZWamnoswo9Gwgk7cR+bf2OHGWrL/0cMWR+t367nWhtp9VtP?=
 =?us-ascii?Q?FChTZbLkPpuXb0fIMf4j51DIrRlofJuIAwjdS40QlvacILQoRvGqz28TA3iQ?=
 =?us-ascii?Q?zbT8Sq2pbgCC4tIqxIDYJIYLTROS0M6Z91/Y60EFzRsvdR9/MLSqA7zzLkxf?=
 =?us-ascii?Q?2YJOEhYEnx5apDTcYGe++oRRRAQoUtDqZSJCJuRfLF79jHdYgVw82pSbNulb?=
 =?us-ascii?Q?n/cclyESA4xaEgsV831WQn3XuAiZl5eJBJa1NOnpS7SCKzCPCPq3i7TKIRsg?=
 =?us-ascii?Q?+fZldzg7rW/BuIelTu9/W7l0RYsuhUNKLv18LnHyYA9QJI4h+UX/XKmp1zmO?=
 =?us-ascii?Q?S2GblO0aCoM54higHwApxyqsfmUz4K9vcKyiyO3AL/ZGn9MdScaftw93Ivp2?=
 =?us-ascii?Q?GbfeigbMaG6G0VJNlHBk0DLhecKuTVwwySFIgN0ZDQRmpRumPS6Ws6y9H++L?=
 =?us-ascii?Q?qDlFOZWiQVfoJO2eVTSG07/A28d7/qIlXW5qaAyEJe7wMkexh3Njsg9HZpEs?=
 =?us-ascii?Q?wr18X88DcIN2YR8yKQLKQ6sFUU4vqLYzAu4eK5XYwH2Xpw3SjK4u+6O4WOK9?=
 =?us-ascii?Q?5XgxmQ6txaaglECL98qNXsX5b9FQl//1a8vx8UUfJRq/dvElwCfwUn4bbrz8?=
 =?us-ascii?Q?HyGZGsP1yVo539qFUT8Szdy3bz23vzqRxPtFAbOV2clxlP2inLqrOlZ0gLjk?=
 =?us-ascii?Q?rgMh9iUhsQmNdQ9w/COCzMOCjGLk/yGDTJObqr/PNoFpZ0ORqFAB/bPVAzZ5?=
 =?us-ascii?Q?WT2k9c/2BP5tP81ytJfbuXQuia22TlIkg0Yg77JKWaV5EDq4T9EjsZQ7OXyI?=
 =?us-ascii?Q?V17xl6zZI3Ck0iQMkg27VpSm4X4036ZoXyMI9VMYowbWn7VS4h6R6dZhqw3L?=
 =?us-ascii?Q?mmmIB7LUW0/Si1t80Zkt2xexmToBySLy2rwolK89D2WBsPvyeVdLOC8DgNqr?=
 =?us-ascii?Q?YQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68b4af58-d771-4a54-de4f-08da5f258697
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2022 08:00:00.4437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9BA2fKfPPP2O4ShQv/QItepz8MuWOCgIImwEuwpITlgNs9ivpKW1424akQgp3mGN37G0sWtCAw/wS+vbhrtlxOBdDMOisIyt8ym+mVW8q04=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3187
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-06_04:2022-06-28,2022-07-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 spamscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207060029
X-Proofpoint-GUID: AwDglgPXCBkFcJRcgCDSeVFzRbnbR3lp
X-Proofpoint-ORIG-GUID: AwDglgPXCBkFcJRcgCDSeVFzRbnbR3lp
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The snprintf() function returns the number of bytes which *would* have
been copied if there were no space.  So, since this code does not check
the return value, there if the buffer was not large enough then there
would be a buffer overflow two lines later when it does:

	actual = sl->tty->ops->write(sl->tty, sl->xbuff, n);

Use scnprintf() instead because that returns the number of bytes which
were actually copied.

Fixes: 52f9ac85b876 ("can: slcan: allow to send commands to the adapter")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/can/slcan/slcan-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/slcan/slcan-core.c b/drivers/net/can/slcan/slcan-core.c
index 54d29a410ad5..92bdd49996d1 100644
--- a/drivers/net/can/slcan/slcan-core.c
+++ b/drivers/net/can/slcan/slcan-core.c
@@ -647,7 +647,7 @@ static int slcan_transmit_cmd(struct slcan *sl, const unsigned char *cmd)
 		return -ENODEV;
 	}
 
-	n = snprintf(sl->xbuff, sizeof(sl->xbuff), "%s", cmd);
+	n = scnprintf(sl->xbuff, sizeof(sl->xbuff), "%s", cmd);
 	set_bit(TTY_DO_WRITE_WAKEUP, &sl->tty->flags);
 	actual = sl->tty->ops->write(sl->tty, sl->xbuff, n);
 	sl->xleft = n - actual;
-- 
2.35.1


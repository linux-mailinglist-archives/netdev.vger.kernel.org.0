Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2C344DC094
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 09:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiCQIBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 04:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiCQIBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 04:01:30 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C71EBB92;
        Thu, 17 Mar 2022 01:00:14 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22H3RgoD030868;
        Thu, 17 Mar 2022 08:00:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=CDuPXYGkizaanLOoWdY9sUPTemZMseUd3AA2ud+wRS0=;
 b=EYeLZbDU13o4572bM67Kdo1b9dKe5iNaJU2dFOpC9sbZbcR9PwhVivqv5pU1fpQha9xE
 alV9F4Pf0nhOmG6j2EmrcD2s/ckaEdfOTZnzdYeo91FxCZ7j/kKcSpkd4FihIVEniMlM
 hm9rnTPypNLcc7/HCyjkbnts3DUhVVWZyR7jBldn0hDC+ZRpdc/VCTlqp6ngm64Faepw
 bUx/027+XJPZSIlY7pa2HhFEC1iy97KVt6d93/0zvAcWjNzPEYgbnwU9aUSsNhaQAVAo
 Rfku5QMRw/CBknrnVJ81pAKC0FZM/DSd8xG1leST5EB2dwoi89AZMMZpCrqm/AIp6NKV Kg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80] (may be forged))
        by mx0b-00069f02.pphosted.com with ESMTP id 3et5s6rgtc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Mar 2022 08:00:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22H7vAav030569;
        Thu, 17 Mar 2022 08:00:10 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by userp3030.oracle.com with ESMTP id 3et65q1x4j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Mar 2022 08:00:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TuLJ7j2LNc7GGHd9+wZYblj/TPvNxSiWR/4RSWGoG/hv96ny8wOuRcpLaYGcyb1e2WAbVdHW/Ohz5D7ZeBIOZY0GiJLR7e3+2NVWyBecTkrS4XAos9esZpdsgPjszcu2dbNM5hbF5E9pBBJfmYWbE0sHqzluthqub6LMcIObwmh1D1U3b+N4FlgOnch35euIuV88ljjJjrbkQFexYg6zp7M+sAAW8Z8wYg7WvjjhspjfBjMa9v5ZO/izceTFP65owYopk+mcR3C4prLwelN3Hfv/qKvZR/BoDubliQVwi3dkk9w3sjJi6UV4JIM6CcWuu9piibbRHuSRxsMFVy1ttw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CDuPXYGkizaanLOoWdY9sUPTemZMseUd3AA2ud+wRS0=;
 b=fGgrWv1uCJ/XubnLSSJDIuYxWnjTV810tMlNW+TUPs4dVGVLt/Yz/kiAdGADZ35QUonGOfegWi9ubEI3kPxpPRP06hmQM3kBagY878f1kxxIZBV66ayF08AuwxSILnsq7GVT0TSpYD2nI5x7M8oGoNOOeumQPB3te1REbHYKBqxI32uTa8TAZK6tKlb2VeWlPUpIweCUhSJ7gFrTphMptArZa2DfMFsyLRG4xRrqMWsleSMlFiNHFl3fhulxE42EeyouI+fMz68CSKreIjG3ULaw6AtqNSij0zPiN4Oxqau+F/Nhsrea6z+WqXJKI9LOGuUPTlwstkoK+ReblDJV3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CDuPXYGkizaanLOoWdY9sUPTemZMseUd3AA2ud+wRS0=;
 b=DZdtORgksTWnO2Yd9+j557RWkqPtDtbebfvvvsHXC8MHLAiuK7oiV0d7Icg97Hj3hHxug7JJnJjhrLKyOj7djBRHXN7ilP/hRakQnIlQvgxrKyhA/tJo8OM0ibr+6HBR5ghbc1WUPg0OkHqSZteOBKJWVxsALf2AdtdWuIOG0DE=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by DS7PR10MB5390.namprd10.prod.outlook.com
 (2603:10b6:5:3a1::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.15; Thu, 17 Mar
 2022 08:00:08 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5%4]) with mapi id 15.20.5081.017; Thu, 17 Mar 2022
 08:00:08 +0000
Date:   Thu, 17 Mar 2022 10:59:57 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Richard Cochran <richardcochran@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] ptp: ocp: fix sprintf overflow in ptp_ocp_verify()
Message-ID: <20220317075957.GF25237@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0178.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:45::22) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 44677798-4928-4feb-d66a-08da07ec2798
X-MS-TrafficTypeDiagnostic: DS7PR10MB5390:EE_
X-Microsoft-Antispam-PRVS: <DS7PR10MB53902A7D4181EC92DDAA4FF78E129@DS7PR10MB5390.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ifpe7aityIK2y4oMECNPhM2XCmabFn3X3ymNP3YRPSqJy0WY5A1EKEj1eM1mo5bNhqarvbMh54WyA/q9pTUyHGUx1E6W/iPXJxdE/6PYE0tfB3qVoJaRvr6spEmD9wFLiKwOtBUc++z34g2NFLcCKo8J0OO/uhuzJSnW7DvJgMPBY/Ufi5A+iD3tU6RGs+78V9D6SFktc3NUalPWJioWq7NIig7hnJxh3Ds5ZIPuPYS9Vu/82ZsAUspwKft8rxv7ZK9Z/1MPqy+wa9nei463vgNzPQz39nMzPvxW8FOsjlAywuhwtg0+6YcvN8Y1dysTW1cvT9TAe5Iggir5+5WsT5hiEqOYOICPhlaQmJKlhIipoYyMtga4L+jQj635fbvfVfFTdmoamoX4sTLrg+sv09xTGCmHFow1s5AUajZbLDOgmyQRzEsSn1bAAWWu8T1zBt2/wIetSXy4Wm9qlwL6h1Uf2y4CAPWaRI1jyXjU8OE2P8td6Xzdx36vj3bWbBwZ5rdao+074UL2Nm+Vcc16CGZ7siZ8kGIWfxFlkJZ7djvO4Gxh2gD3Cu6MtmpxMJr+dkW88AIA6mGeOrVWlut+d9cPoQ0QRdEuFGZQisKGAQtwBUpUHcVRcJb1MxYOuNh40TItent4tjeS8Ak0pkFFgXqao5P8v2Z1NcJ8+ip58tYysgRqrlsUcwqGq28t8JanhhZErMG5vr9Bbx4zFkM8Wg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(5660300002)(83380400001)(33716001)(44832011)(2906002)(110136005)(316002)(54906003)(4326008)(8676002)(66476007)(66556008)(508600001)(66946007)(9686003)(186003)(6512007)(86362001)(6486002)(6666004)(38100700002)(38350700002)(6506007)(52116002)(33656002)(1076003)(26005)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kHUSyg1kK9dALWTYnmK3wmhJ9PnBWXRX1aWlVzBYGD7ZajYJBmT+qtpuAr3u?=
 =?us-ascii?Q?Jc4/aATmZTBh0IPO9/LWmBXXQ7sfzA7LHy4MUiqDu55cZTVEIELe67CGB120?=
 =?us-ascii?Q?HZ9VTZECH4E9jgh/vZtBX3qNx3m8fdNadYiKomu6C57Wjp/atxbFvfracb1w?=
 =?us-ascii?Q?vMdBrWRI4/67YVxqGeXTtoYvobkFKzcdEWlsus8OUIB2TM4BnhGe4qKP3KBx?=
 =?us-ascii?Q?PSlfTa3T94RZAcmJJ4qaQ1iOieyERaDEjJ+uvkQqDnnO6oVvGFZ1636cT75y?=
 =?us-ascii?Q?UHE8xTg2m6370TyflyWSuRKfOD5qT339A/BP391BYVV/01X5IqCNQ7FvQ02a?=
 =?us-ascii?Q?/ZXYIVRryPhh7jFC39RVYMpxwAylk2SrvOqE92/GXz/hYS8cQKOm+WcRkqz+?=
 =?us-ascii?Q?mQSpEbIv2wYUrxHP2nvzhGopwufacqSgPwKjPF9vpdF90+TlfxSxpGKyiJBx?=
 =?us-ascii?Q?Qcz5bN/Hud20skjtMMYIrhWqDJ6qffcY1UhcGf36OdFpX1VJYyPIVBtfiPk+?=
 =?us-ascii?Q?J4wab+7mGcvf1vMi9jwyYwJ/vlyR0c/EvFZhaOsCwwFrLVGUg6Wbu/kWooLD?=
 =?us-ascii?Q?C/RnnGvO+XUpr1giOHcSfcxcWERJ8uwNr1g1Z74ZbYLUHwhKuml/cDuG1xsy?=
 =?us-ascii?Q?Hn888vI1JvrH5bkmY+FCfUVJ3/ZhOoiG8SDIl94X4XZGcNw+EXV5uUf8sPU7?=
 =?us-ascii?Q?j/mHqRPn82Po7eOaFkN6IGJ8SOy0lUeSAjrKZyFc5GzafvpUdP0K4Z4bqHqE?=
 =?us-ascii?Q?mVCmv3Nv7aYoxylEfwKJhYMdInqRVxZZfQp6gPzotkGUuI2rDiZ2qiWSCiXR?=
 =?us-ascii?Q?iJ815ZOjhknjWa9QNWnMvyy3bmwA1ngAev8aa/ulY093X89/OhCN8wGEljZl?=
 =?us-ascii?Q?UvqzPfpMkc+FtQ/tV/7C2IrGkYKVrn1QILQuy2A7EIApzalsAGQsfXPK4ofR?=
 =?us-ascii?Q?lzrZ5e0FX+ler8T4C3/9dPx+6ZyyiHBqKQ2bxnlFh6a+obc0jnslyXu7i9U1?=
 =?us-ascii?Q?q2bLIW/X5/NKabYFO+eZlHxt5QiRVkm/6j5aN/9ZgqGYFnmJqPwoRHmXW+8Y?=
 =?us-ascii?Q?dNnfJgS+i6ztzvjXF55aF/MT3n6k0MkhzC8JWULgOBq+MDNhSa5d7sz0fcRN?=
 =?us-ascii?Q?ZREJkr3kr95IUqWAzbkkvsJIrD9LvOcvaQTO5j2aPZdytip91LKfcemR8ok0?=
 =?us-ascii?Q?WLzShvzueLdQmixcFpAmYEcsOd0KMLIpSkWXjbJ9QVY7o79IqCImdKPiNd44?=
 =?us-ascii?Q?jB+/xfzKMXfI5F9KVTD6DQCCmLOYhDxDgFisTBxiECTTn+HndWEEULQ7njWe?=
 =?us-ascii?Q?pS3eTGuyZq9s60NBgdDeF+72dV4bTcTuDIsl8/yKwablqLplbDea0pu6OgM0?=
 =?us-ascii?Q?nRrLZ9hAc3ZLQp0eNIjf5V2mZOZlWolNflPW3zVWta6B/HvO+686krxKhT4C?=
 =?us-ascii?Q?M4O0d9hTn5FfTbxLA5Ll0YW+9qG7qgjbdkjCrJO6RWzs0YaOTwfkqg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44677798-4928-4feb-d66a-08da07ec2798
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2022 08:00:08.5600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ge2jP4eaPXVmO4yGDzVt1J0qkCMiFo5xmpxm760GgSFux0BEDlsbCT7UroEMPSq7gTv8ZU3+OrdpXwL7Rsn7e7GYloe+e4p1wWmq0fYuJkI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5390
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10288 signatures=693715
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 adultscore=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203170046
X-Proofpoint-GUID: 8pI77byOrykA2MnMBVE0zxkvY2stNiED
X-Proofpoint-ORIG-GUID: 8pI77byOrykA2MnMBVE0zxkvY2stNiED
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "chan" value comes from the user via sysfs.  A large like UINT_MAX
could overflow the buffer by three bytes.  Make the buffer larger and
use snprintf() instead of sprintf().

Fixes: 1aa66a3a135a ("ptp: ocp: Program the signal generators via PTP_CLK_REQ_PEROUT")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/ptp/ptp_ocp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 56b04a7bba3a..f0565c4a85df 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -968,15 +968,15 @@ ptp_ocp_verify(struct ptp_clock_info *ptp_info, unsigned pin,
 	       enum ptp_pin_function func, unsigned chan)
 {
 	struct ptp_ocp *bp = container_of(ptp_info, struct ptp_ocp, ptp_info);
-	char buf[16];
+	char buf[20];
 
 	if (func != PTP_PF_PEROUT)
 		return -EOPNOTSUPP;
 
 	if (chan)
-		sprintf(buf, "OUT: GEN%d", chan);
+		snprintf(buf, sizeof(buf), "OUT: GEN%d", chan);
 	else
-		sprintf(buf, "OUT: PHC");
+		snprintf(buf, sizeof(buf), "OUT: PHC");
 
 	return ptp_ocp_sma_store(bp, buf, pin + 1);
 }
-- 
2.20.1


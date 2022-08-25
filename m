Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 113F95A1200
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 15:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242584AbiHYNZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 09:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241883AbiHYNZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 09:25:33 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C35EA74CF;
        Thu, 25 Aug 2022 06:25:32 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27PD9Ona004543;
        Thu, 25 Aug 2022 13:25:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2022-7-12;
 bh=N36PlZhb0sIiCR+NgHhl7U5aDRrZRyY2VpcZKjphUx0=;
 b=opmUGjs8Uyz1uo+QJaoT/ETPLPnR5HYfLS89YdCArLVZ1DnB/7XEnuDkopgzyaPgBFxe
 heOz3VL8GAz1WVYTwUFOyfpSTPjvgSiPlv2I9dMmyh4Tog4eMrk+203I+LLCNtwSWGmN
 p3olj1feVPteObnSHPxMvTJsd66MOPrYXegXnq7liDGUmkabMRjprfInZAIqlYHtLhvc
 00vFEK6hldqGEgFPORAu4XGXPeDAulBW8Qo/lhdb49eXO/M2w20lWljIoi2ixxc+5xYm
 SJM5KvhZ8FuXK+eVnzhYvapRgesmkQ867/DE6ElI3F7vWyzlvCpRF4WgjEgIf3OShXfP 2Q== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j55nycu3c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Aug 2022 13:25:24 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27PB1iXn021799;
        Thu, 25 Aug 2022 13:25:24 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2042.outbound.protection.outlook.com [104.47.74.42])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3j5n5paghn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Aug 2022 13:25:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L7qIkbJBmWlhgwVswecnwx4GeJAxMQzBWNDG6WJ3x89WMIfLte5IzHjdk5snmcHRmB2GQYix1reqdtE5F51HWAMAnRfBokv7yGMt/Ai2FbeGgsznP1M+jin7uoxfu0SQ1ZhwDLw43YiT2Rkb1L8H4arpAafbFxyEOd2P+gWoU58LBnt+raK7/vQgn5SNyXUoWChaWUN9lfsTlcSWz2I84rBrrTgN4cpVXZslQuUHtFd3BtbtXb8phn2Gj9ZZYjZWBONU1ehkXVD/n54z2tDM0ObndosO8pU8crsPmtocou4b1xqyjq49ZxK0mqvB5//lQEEARQLYD1SyowCHcBnqWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N36PlZhb0sIiCR+NgHhl7U5aDRrZRyY2VpcZKjphUx0=;
 b=I8JRFKXrWajMyluwAblEjm2WO9Vq3ZBfIrV31CRA4Wddy88DyyTBMBEUhzEvooXYX7wfv7kVRFPdaFe3REyJFY63nUx2RVi0m4J+cnPH4NQuxE2F7ulkJ8wytYTCNBtdaxcexPsr7yG0XMhlw0JlFFaDDMamMFjP8j7DgfEawucYk2Bse0Qcn3zdv4ZtGjtR2z7MuVytxmh9bkL89kuvjzU/0FM5BwvYvMylbBUSV0zmYb9HO/Yx+nHtzKm5HmigDVuxHgKhtuGBuzHOZzLn/ZzQoyeWLX2ys8VCKzhVM4wkO/2AkHjM5JEfro5b0HpOeUbw7gJS+OyGos37sGf7Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N36PlZhb0sIiCR+NgHhl7U5aDRrZRyY2VpcZKjphUx0=;
 b=oLAZbgf+Uh9/Vwzo1pv6zU6WmNavh/mtSVkn8quHYnAFVO3er5RQ2cfqJAIo6NnHYB4v9BFUsiC3S7mmR9GrwEPHEnnzcXNn+mu4o8Z5FXfVt+NnHIkqnz5h1lPyRvhSlVEJn8DrXjaKIpC0i9SFnMef5rZY5IASQ6RGA4pQPQ8=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by DM6PR10MB3945.namprd10.prod.outlook.com
 (2603:10b6:5:1fc::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.21; Thu, 25 Aug
 2022 13:25:21 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::209e:de4d:68ea:c026]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::209e:de4d:68ea:c026%3]) with mapi id 15.20.5546.024; Thu, 25 Aug 2022
 13:25:21 +0000
Date:   Thu, 25 Aug 2022 16:25:08 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] net_sched: remove impossible conditions
Message-ID: <Ywd4NIoS4aiilnMv@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: ZR0P278CA0192.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:44::16) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e92d75fe-64ec-455e-7da9-08da869d427d
X-MS-TrafficTypeDiagnostic: DM6PR10MB3945:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9jyHM0cstZABgJs2u3MhEM2MvFEmeXTQVgiUvilz1ZevGW+hnpKZZxV6AX7YcvtWBlLVWA8rRVNwvDEGZDz8S+qGscX+ovpRUfftcOuwEZmbdwneN8TJkf/M9Gv2U/b4p3yc5ZrBeHUaEe6wWGwz0wjFrOBMCOnxMuop3jJ/L3O5wLptBTzJ2Kic4ux8iGlVJOfNIcCsQEWtvDUow6NWFfsT7Y1OHJcwMocp7HMeTuWfoQoTaze2joW07KZs6GjnPnT5BjI6252gq1NyFDsu+wscy1dKwIXAJZVA1g8SgxJI3m9u8tpQZVGIHIktGg9fAeETqN7JkSgTPvOs4D2E/8puPJMSJboCapQzEXGsew6Fapo5YPt365zcRgOM0ZT+WpulworhZq+V4+buyEv/Kx3Nab7s30nbbeBmsDRMAbKiIaIHBVUM531N844q45kTX1jKYyHAFWFr4yxkbu6NXue5nDRfAMz8REd0bVdXAVoZbSobjLOLWw/rfob19WJBeg+l1LyVIQCsdrJmwXaCYrh72WipUVrG+6iytmHbmObS9iekckgOfrJx9Qb5zaOcWML/WC0IyKZSS4agUPiKlIt0vm2ZRGTOr/0L1q4CrSa11RreYBZn9V+ZbKb0OBVHV60wQ4nfSExwBH7F6QrZvohx59/dc45cOjmU+mVD3I1DwmVnUCFjrUFAWkAS7sCuS3hnHng9xpyLgpvm0bw1IP9XwpS8FziCZKZj3UkM47Jp36kPwSqSLOBgzqcvbGQg+FO3Z5TMngSo+AJBhkrGMA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(366004)(396003)(346002)(136003)(39860400002)(376002)(41300700001)(478600001)(9686003)(6666004)(6512007)(6506007)(38350700002)(38100700002)(52116002)(186003)(26005)(6486002)(6916009)(66556008)(66946007)(33716001)(4326008)(8676002)(44832011)(54906003)(66476007)(5660300002)(4744005)(2906002)(316002)(83380400001)(8936002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z7n4iEXd7i0Slt3E16mLBBZcyCQlOqU3I/LJFxRfoTwBZkmgSevUpUf1x6La?=
 =?us-ascii?Q?mp81U6KNIbZAXyD45GCRISvhdfMdemh+nOUA/5OvC26df1xZp6E1h35ClW6J?=
 =?us-ascii?Q?g5UFnycgCf7AYe+XOjp/qLpJ6vAtTJHcaWQv7H2oQ7Nkd4h9+JYmlqmMoJj8?=
 =?us-ascii?Q?+gDo5dYlctnGls1b/Sslzy/JUlMkF3b6hnXP6ChIei2t/UiXj9zPLA8HkMzc?=
 =?us-ascii?Q?5LwXVi5ybHu9MC6AQfur4cQllC/7BGTLtfZvoEzv2Lc0p8uMs+0e+molKT1J?=
 =?us-ascii?Q?I6v7dwramTSEDypWVwwQgJ21/fYJ7H/VTOn/8i50RwfB4ao3kfpZnwxZbcgU?=
 =?us-ascii?Q?pb+/E2SM6p1z2Rrcba/1gfQYNdBzr+YxeY7A0QghfX4NX7IFyxAbklN8I35e?=
 =?us-ascii?Q?xCJap5BCIVmoUgKt3Qpy/pcfmHdvS/Kz2N7JPnoavareD55ysVz9aogIqlK5?=
 =?us-ascii?Q?RJdGvxrT9LxjBabxOemNb7GQUQewEUMN5QsXG+e7fKlLygsMu/pq/1Asgy9u?=
 =?us-ascii?Q?FXRTvd933SoLanz/GCeyJZ6HmEB/aOUSYSWAgw4qL0xlqmxU8Fz3mTMH2jEO?=
 =?us-ascii?Q?ZxioSC3hQpv59XW6W4BX1NgXitv0C9L3zLbzFG1eik0uATJXAvRdM+k4faaK?=
 =?us-ascii?Q?RlYKZOOeWxCGx7AhgiOgnJRuHRRZT08izQPf+GrSLreiE802RUhBJPhuOEFU?=
 =?us-ascii?Q?bXcyfI6r5XkytGVWyggazYtNQu482pcwjj9i6ZkYxImRW9JB5AHxtUu8PSdO?=
 =?us-ascii?Q?bWbslJXoOHWgf1FQXqJ6fy0C1LtuXFxP4s2U2C5zfO9H+wmu+zM3BFiV43bg?=
 =?us-ascii?Q?0CVmjy6o9gcJDHV7pbPcOko7xkdAUzvC7G/5a6cOUnZdKD/BliZqKKMusCMt?=
 =?us-ascii?Q?b1tgBexGZDa9wrOet/Yn4T/CEp3C/nVJ0hlKcWYOEruRsjBQfmIozQt4Dsem?=
 =?us-ascii?Q?5rU6G8irB8dF1RK0eR8yUix0hBSJQmN5Nc05B7Z6G3uEq1G5zIRUqXX2hghT?=
 =?us-ascii?Q?qtWnbJAfMp/KacaNAhjYj2oUIdcIVY39vhRXlMFFqhifLqsixJcvK+3+GZUV?=
 =?us-ascii?Q?pv0+sAww0I/f9LoN1k0uPScA8NGTk7+ZuWZrbEX6bZPNvZTAkm1CxHOtomSk?=
 =?us-ascii?Q?CEFNsaWDrWWbDWzEAACAxcZmaSuJqb7aIoAoSpdfWy3GYSM4bDkNlQDYbHvW?=
 =?us-ascii?Q?Ez7zGWMPnIRThMtGiQn7dQcTQPpBoYEjQmIW+uQ/HccnGb2OkzsCl9KBSTf2?=
 =?us-ascii?Q?g9SIJ6flitL5b/5wApRkFr4Jvi/w71AlSmoUIRr/pey7ygRBHL8Ekqmec514?=
 =?us-ascii?Q?lxt/QvjA7dp3xM9PIX2EK/38Yz7f00cFFAZ/G1tZBSB9eTmy9EBfpMl26K05?=
 =?us-ascii?Q?tjedeUCIAzpjferFY191xbNO+8I2If/BXgogrA/KD7YdHOOVpx5FzxDf16Gw?=
 =?us-ascii?Q?6dSEWvVIeps+VmSjtefRWd+qv9uSOtxchYzVUwr9BBA8TCpFZf7McN0tLlKg?=
 =?us-ascii?Q?9q5qLVLbKJ4q9r2M55UuQhlZDtYo22pEAhLYVJN/QQGTd/bkx2bFAQu3VxP9?=
 =?us-ascii?Q?GLvT2MMJNVSLTcjEBeCIS70qhKvXnFJRQDeUhqUgEP2UcKy7H/AQ7GtpRcET?=
 =?us-ascii?Q?RQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e92d75fe-64ec-455e-7da9-08da869d427d
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 13:25:21.2979
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ferolULFckbwTw4a61vFfUOM7B21ErGeOMCwMgBozuEjUOuS9qhf03jHylBFHAQQJH68V11C4wJ5uyfesFCYae/44hbIiolsgWoe+TxAshQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3945
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-25_05,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 mlxscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208250051
X-Proofpoint-ORIG-GUID: kJZjATuIQHjzac4LaIcx_8MAVd6N5TdQ
X-Proofpoint-GUID: kJZjATuIQHjzac4LaIcx_8MAVd6N5TdQ
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We no longer allow "handle" to be zero, so there is no need to check
for that.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
This obviously is low priority so it could go to net-next instead.

 net/sched/cls_route.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sched/cls_route.c b/net/sched/cls_route.c
index 48712bc51bda..29adac7812fe 100644
--- a/net/sched/cls_route.c
+++ b/net/sched/cls_route.c
@@ -488,7 +488,7 @@ static int route4_change(struct net *net, struct sk_buff *in_skb,
 	}
 
 	if (opt == NULL)
-		return handle ? -EINVAL : 0;
+		return -EINVAL;
 
 	err = nla_parse_nested_deprecated(tb, TCA_ROUTE4_MAX, opt,
 					  route4_policy, NULL);
@@ -496,7 +496,7 @@ static int route4_change(struct net *net, struct sk_buff *in_skb,
 		return err;
 
 	fold = *arg;
-	if (fold && handle && fold->handle != handle)
+	if (fold && fold->handle != handle)
 			return -EINVAL;
 
 	err = -ENOBUFS;
-- 
2.35.1


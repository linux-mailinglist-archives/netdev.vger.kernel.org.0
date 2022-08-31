Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD0A5A8096
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 16:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbiHaOsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 10:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231256AbiHaOsp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 10:48:45 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2770CE33C;
        Wed, 31 Aug 2022 07:48:42 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27VEENtn022377;
        Wed, 31 Aug 2022 14:48:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2022-7-12;
 bh=eE2761GV3fQVc0q6VzlLeOxYd1+I/9WfKEwwysqZEvQ=;
 b=rWi4Ps3xbx3HPxH/cKoA2LVrxlHaXRduihfzmyOu+Ta59BlkqnTk5HDbGCQPgI5KV0wH
 pM3tcH8R6C4+v+MakU67zOJKQEVmhHoI5uU5rcq5zquuLyCQJdBiBLTYLTfoDfTv0l9o
 OY0juJReddFgVEeC/3PPmZoQmPXfm63GsU7l75tpStyfh7LKd9M92DftXE5qf+/ur4l4
 C4CBavvFRsehLlz1/a4yBdJcKLcoemNVaK57AAAhcqLH/FxJU34YwFrB/8+E8PEmLxy5
 y7T4hZPPNs6Nl6rKuARkLW9cIl/ghlAqkLe1AztG0I9t61X7D3oALWTq6+SKoePr42qI /A== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j7avshecv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 Aug 2022 14:48:10 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27VEN5tV033656;
        Wed, 31 Aug 2022 14:48:09 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ja6gqdw65-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 Aug 2022 14:48:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gSwBQY/0jxpO7HchBhahw/leb0eRsaszwav1UFvDP/MHXd/G4ZXV203sKqU8xWsOgtEq8tcDcuM++vi2K8aVjqHH4VY0ZJ8rBXmUkfCZn4ZyeBGPmUACwyIzm8nzx98U+/IgH9mNzutJMK4yTrmMk/Aze6duEofmdkWhL5XmAmNg+8Bcpym5eIkmAMeqNm1JnwFXcmwLx7hAOXb3usze4MLFhgRLfuEmUppHrZdUPtm6PVuKy9Yg5yKNfvIdUj8aoOOihkeVxk6ycFuCzGuk3iJt1w6salH8l0zzbJ4Kf9ILz6s23p6N0I/z0lA2X5VsaVBS8n3f0JvwjJfBXsvrZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eE2761GV3fQVc0q6VzlLeOxYd1+I/9WfKEwwysqZEvQ=;
 b=CCpccO2iIV8Fiq+Ez7wIfMAlGSbZxuk7t3G2zFj8cWrlAHWvokeEKijdzsmlklTwllTt7tOH4UOgJqlk5pqCNiRRixzoyNogmgEV3u6F5lzcZPkMyRamAkvXJx4hEzI0AcGUb+99uhq2fHuVopSBii8hdlqjgi1FRVEsZQZNzY/BWQMfPDazYEHAX/VxYXjYMmIq3aGL3oZ7ljNGL2FSoTg3YLUJ/Chl/OyRtwDuc+lfGxKa7dRWa/Z95klkV+zgu8CeIUUJ/6dGJSd5mOQUN6ExlVgkiQp3QkOfkXC4zM8Lbz+VsrR9cAU+v0UvUR5fMUcMswHEwoyGhOAsJYWTDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eE2761GV3fQVc0q6VzlLeOxYd1+I/9WfKEwwysqZEvQ=;
 b=ILfktvmKxUXd3hWp4w4MYvkyYP/B3unVbNwdCd76ViuhykzeheKfhkTmTUK1UQBvJemmSL9btwi9Mf4yD3K16VyVdvASi1qZDwSH69xXMUNo1YHd2ZC2oa5Ip3W/B/HHAOcQU+m76NORHz7zG92iEDaBMnHi5xRX6bcsPARgHUM=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO1PR10MB4722.namprd10.prod.outlook.com
 (2603:10b6:303:9e::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Wed, 31 Aug
 2022 14:48:07 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::209e:de4d:68ea:c026]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::209e:de4d:68ea:c026%3]) with mapi id 15.20.5566.021; Wed, 31 Aug 2022
 14:48:07 +0000
Date:   Wed, 31 Aug 2022 17:47:56 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jon Maloy <jmaloy@redhat.com>
Cc:     Ying Xue <ying.xue@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] tipc: fix shift wrapping bug in map_get()
Message-ID: <Yw90nHF82AyG35Mk@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: ZRAP278CA0004.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::14) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 94018e8b-9a1b-4154-9735-08da8b5fd0e5
X-MS-TrafficTypeDiagnostic: CO1PR10MB4722:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UCL5mM7TzZ06yorKVtXoVq5P9W5n4oCK0M7zvHEaAOkeCcnOE8D7bs7Je8rbxE/clXyre0hzo9e1OAz3K1pR4jqqhVsupKuvpYHfg3nVxzY22E2dna/YUUEpDvAPRdNpybTv0SUqFfqI4nI36lOtgaoMy6F+ZCf+I5Yu0FJeI3kAD68KWlsN+RL5rzdtXVZ/H6wSsm+NMxfS6K7F3hJnZMhRTuz9XG5q/77/GzqqMFFOkX29EXF/tsuZjVj9usVBIQeQude99QsXBVWlNAnZaZTa89Ft+WFbIZdgaFoLasC8EjhKiAIhVDUVS5HzT24Xl25LDk+71sdnW5JrgOnGoLd20hHZoUuGruBIjG5ojUU4LvnTJoFc/j+RbOWLip0OUfsrq24lZJiW+CgHfzg0IOLG40HUZdz/Ad3ShRbpTEgieQyHs35lxZnpH0lSNiTY2e3BCVAyhzG6vK1YzY+EmdL1dgByAMsz9zGlOfDuqsuaHBR7WTvglrcVad3UbOGZvL9ru0l2EKSu2qejXa8FLhyqwt/J6NKIHaXeNt53+lb/t3W7CL3kN9JemUGOaLu1Kd0ZXcGzRu6i5s7z+tQQMS+W5dfvFkJ3DAc89fC0D75ICLzm71cBRiGJpZvI82DD4JBcMscdADlM9rFhzMqkBSWIsXJfehqv3dLcS6QVWyOE2zDTy624mImlOcAz5Wxkm77ZlDyvWhoaP4d5FfIr4AXQaYVYrZVslxu4jilmEACYyaZpTVmBqDd27pqJWU69SUqoqI9O/APjBr8YoI9fGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(396003)(366004)(376002)(346002)(39860400002)(136003)(66476007)(66556008)(66946007)(2906002)(6486002)(86362001)(316002)(83380400001)(6916009)(54906003)(6512007)(26005)(9686003)(8676002)(4326008)(44832011)(4744005)(6666004)(41300700001)(5660300002)(8936002)(38350700002)(38100700002)(52116002)(478600001)(33716001)(6506007)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?j8ci97+vPBsijoCxVvPHdtCsq9EKlBbSS5zCx8dCmKR+7O6BSn0fFwO42Wec?=
 =?us-ascii?Q?qYQo71gZZCiennj2AIVO/md6GeO604p+lNZ0nyeh2qg7wsuGqG4YTHIkIWCM?=
 =?us-ascii?Q?CZvlXEGsWEs8ZHlNEs5yGZMLxVIibaSl8zfc9GMSc/Q3Tyz6NibqndwvT37I?=
 =?us-ascii?Q?M8+QuTNcjLrSlTJJZGs6rMpg+cdgsyCaRbwYhaMb1L9e9OAeP/vYRXxoZjm+?=
 =?us-ascii?Q?zReTRUf30DRWNf3wZerghmX4a4UJl10OeDAvn/jquF3OHc7NfB65VwjojOYH?=
 =?us-ascii?Q?2aMdKQA3De2M7oms0KC45tQ7Dz73d2fL91U0KQ4JMcmcmZe3uMBRLgx1ojmR?=
 =?us-ascii?Q?dyUmEFHykOY0qR9GC5ZM8mp1999Sp/SZM5SVcKhXljwzWoDr662TMB8a08Sb?=
 =?us-ascii?Q?+MQ+RU1Uny2zEeo0LIvkGspB1uFpDQlWNPxxNN53toC8MeMEZLVlZJAPhZhL?=
 =?us-ascii?Q?lfko1xerp5EAQSPdJVRFb+Sp6t/dGNPsWm8OVavSNkiT5igK19ZIOWib52/b?=
 =?us-ascii?Q?D5NvxCKvOUnCdNWwmc2sYEs8bTEv/bfWZ0x6mykZNw1g0IpofyrV9RN89JNh?=
 =?us-ascii?Q?APaXza5O6nljV0sk68+dpM4Ct3/oMqYapuTC7SQjTvHaO3tnekvBevPdqVM0?=
 =?us-ascii?Q?0PQZSAR7iSyDmMdyYY0qwHm1yoAkTg5Zdhue7DEEG2odzq0Npc2AGY/QaNMq?=
 =?us-ascii?Q?Stq8KKFhcU2XVnlyQ6eWFJ3MVyj9wQ3jvWNlEkIMxANbb940dueYA3lGSWI2?=
 =?us-ascii?Q?ak3ooGsCIBti5O/AvNHceTD9q4i6+frBqLuCiqG2tuzxzzDRNTjNho8nwdWo?=
 =?us-ascii?Q?n38KpG5ceBpfEwNSJf556igqL6J54lf3EwrUcflDVFlGthj5EWeUqJ18uUzo?=
 =?us-ascii?Q?Tfo0S/F37jITG6+xCiBfQNxSLWN/ubO80jKyYYXkLydop+c9IeXXCMt7NL2O?=
 =?us-ascii?Q?9OlkHHXvpwZ/POJz2NVORKwCrKhGw6TBhjCiUlA0dxwB6iraqXJiIwcKOju4?=
 =?us-ascii?Q?RktxO6RX8zm1fws+03TGezrtGAPyS+HxuFfrl+I0nZRWHGMuyWOekdnyyYx/?=
 =?us-ascii?Q?CIsP1GqYbGOwuGfcY4V/dEWo/3d1fYHieoOVkYd6XZHKRX/qSC+/zN1I88Vz?=
 =?us-ascii?Q?4iBLFfMIqx9rSJMoL7P6jUzGGUuGhyqp+xV3JOAB5CgoEXbqrTEUo2Qwsde3?=
 =?us-ascii?Q?fCi9mbqbip97pMQJnsS8eAlG1rzj87oog2RM14gSrPk7vidHEacQ5c27ywwm?=
 =?us-ascii?Q?sRTw6xzm5nAzL8MAoQl/XbCT0RRfuLIH0xlA1TifEmy2ICax+ZRyN8FJhiR3?=
 =?us-ascii?Q?L5V3ewfYiN7/Yp2E2M2TjqQFJSCBQ6fWm8xWUHO7/SKwOT4mg2Q/uQ1ID4I4?=
 =?us-ascii?Q?JC32KUN1uhNWP6IOBB7dcM+O39OLiowKLdzdqK3NcVqJ3xQVL0E2erH53NYe?=
 =?us-ascii?Q?mmZx9TdlVboKzcQ7Of05gMzHP0JYk5Oibk+xasWR5xFTV9KicLwzVGrYsMb9?=
 =?us-ascii?Q?xBKOEHROPW2wuS2RsokQ3j1DI9o6VFT9b34NTAtIDzeoJcMH5ZGX9qeL2PO4?=
 =?us-ascii?Q?1CuoYYOAdNGSGdeA1YLAqxycsSgg0t+Vp+jOSYyq/iSPdUKl11eV0A8WuDP2?=
 =?us-ascii?Q?xg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94018e8b-9a1b-4154-9735-08da8b5fd0e5
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 14:48:07.4988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eBeUoyacephSxEfXhlOhlQhTymrck+taXreExy2ynWBrnjd9jLujUWZ8DV9bLbR2uo4CE1j+kMvwVAxddVbK0sVzzT0BBsYCBFgWV8xmMzs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4722
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-31_09,2022-08-31_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxscore=0 spamscore=0 phishscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208310074
X-Proofpoint-GUID: La3W_x45yv2QVmkK0qxOEBbf-R7554UW
X-Proofpoint-ORIG-GUID: La3W_x45yv2QVmkK0qxOEBbf-R7554UW
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a shift wrapping bug in this code so anything thing above
31 will return false.

Fixes: 35c55c9877f8 ("tipc: add neighbor monitoring framework")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
I have no idea why I didn't fix this back in 2016 when I fixed map_set().

 net/tipc/monitor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/monitor.c b/net/tipc/monitor.c
index 2f4d23238a7e..9618e4429f0f 100644
--- a/net/tipc/monitor.c
+++ b/net/tipc/monitor.c
@@ -160,7 +160,7 @@ static void map_set(u64 *up_map, int i, unsigned int v)
 
 static int map_get(u64 up_map, int i)
 {
-	return (up_map & (1 << i)) >> i;
+	return (up_map & (1ULL << i)) >> i;
 }
 
 static struct tipc_peer *peer_prev(struct tipc_peer *peer)
-- 
2.35.1


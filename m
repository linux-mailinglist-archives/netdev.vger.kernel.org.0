Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62EE857510E
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 16:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239418AbiGNOqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 10:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238585AbiGNOqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 10:46:46 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7DC54A82D
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 07:46:44 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26EDcpqw016433;
        Thu, 14 Jul 2022 14:46:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=YTtg20UDCeWEtJJn5arVg2tpxnQE+7rKFcdnp+iw9As=;
 b=V3q3F6wmwM2v92yHRaMxlZg1tcgYncrUWcf9laqhBAYw5FPuLc3glLr1O1xMCLSq/ZpY
 iAzN3ze9rqIY9e6BT0OldYfJtKO4uJg5RMIRBC0nXIj0TTQyUx2C5N979kpHPlA+yi8W
 +dWJAriem74g4KgFoJFqMFD6fLn0I55CL34jXrGnBkXupGKqGUvWRdxe5FVMcJsS5dfZ
 XUUCdaKzp/fRMFMJ/+0cv+p5iiqIhuLvx57xYTSCc+d1m7MQQlaY11CS3Zu76XCm7vu9
 H4umRC8Phc8TxyBSawScUObOjQeDvenwY5aPsLmCk1CpP1nvUbsPUkT1mmz90x26Ms0f gg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h727sntte-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 14:46:35 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 26EEYre7036604;
        Thu, 14 Jul 2022 14:46:34 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h7045vm59-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 14:46:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gNgAs7t3EkJ4XJMv4Xmvaznf+8/WayyNWxWgKXIgudiGYZv2ESQutMDYaoEi62S4Q96oI55xOi1JO5fXa7pKZmGrrqrpKrfIInC4XgT3tG5j/wPIUoRdjmhYAsgx/w1XXE73DhZBBZGaNgnzz1mv6e6ifP6pMFLROFDG9BSrkAJn/RHV88TKMMFV/YupLhPaAza72AKUh7sBP9niwWOx6c2mVb7AeRLj2X1OOKG7SgQ2zlHxsTs/S1LYSUfIklyDeqxrft5pKNRKIpJu2PYqswlb/GpnaltyLnaYEYhatKi/Jeg1S1yPuyDyFucmtABZ5WnJneLqr1WWEzIeWfqF7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YTtg20UDCeWEtJJn5arVg2tpxnQE+7rKFcdnp+iw9As=;
 b=GBDByiDE6byIKBykxSCpVUoBTM5n5nVQgNIzxUQKdPeJqqsrTMDgZisN+0F+nLCRl2egP0HOh7dfCQ9aVOtR5mSHrjkSUp2JMIU1V1mA3nkj9h2Otdp3aJvE9wGQJxVQjs2qFTGjxIx7WaOcBmnJWtG7IjkWfs1r9ITBZY/toOkR9ssFeC1sqCihLbOPsiTNnN7e6YrB0LcFbtaUfnjQOFwKAS75XTW/Tykll/6ptKNb6GJSGclx/dJmFMZgGcyvlu6cLnnA/ntXQc7NpsuzGJQbl4F88f3zQHRZVxIu/0wgOeXUGxoDh1Qe2t+oPgA64ApqDXm1VAp5pHlFtDUAxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YTtg20UDCeWEtJJn5arVg2tpxnQE+7rKFcdnp+iw9As=;
 b=xkfh3ad5m+W0Zkv6ySMWXHiemMhQwk5qHKaimWnTlaYUq/rAuAFGwr3CpvszWn4M1sw1RrJjckgPdcuSpCVfMwLlbAueCqeND0LflBqf7KXrvP34T/z3Zo+MIkxuPN+c7ORVOwqn3R1JiDlVUKel+ZdGrPloDmpfI6ZSqr9ShCI=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by PH0PR10MB4422.namprd10.prod.outlook.com
 (2603:10b6:510:38::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Thu, 14 Jul
 2022 14:46:31 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b%6]) with mapi id 15.20.5438.014; Thu, 14 Jul 2022
 14:46:31 +0000
Date:   Thu, 14 Jul 2022 17:46:18 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, syzbot <syzkaller@googlegroups.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH] ipv6: fix lockdep splat in in6_dump_addrs()
Message-ID: <YtAsOlBliPwJG/Q3@kili>
References: <20220628121248.858695-1-edumazet@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628121248.858695-1-edumazet@google.com>
X-ClientProxiedBy: ZR0P278CA0095.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:23::10) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e1acb9a-23af-44f9-39a5-08da65a7a421
X-MS-TrafficTypeDiagnostic: PH0PR10MB4422:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ALkvN0H7aWYn7oUsfVOkqqN0vJTJ2Ek93S81Ei7FdUDGM+wx7RF3xuFvQv5X1T+ebrPdKGU2ie+VtehHNsYYke25OLAaGFg8+LiDua4+wjGZWbKGfpqsV1TOvbOdEIPGEZTGxiq2LAbLyMbu3H/VEAB/khmh+JRmnfQn9xRRAdXi3w3soRsd2DDf7MsE7it13i31x1lHBLqKaGg4KVxB4H+cy1OU4XlSeP/kBwYvHLIm4rnWa5UY+exYoqLGyItesafgyfwAOiXgMHqsYNC3jUPib54NOM7wwTQTlUxBcy3MmsF/eCzBbZeoWoJytb1LmfvaKNm4QcXh8M2QMQb3XuY6vC2NOV9JpQzqWdzNvcG1gZkE2cS31X6tBz/B77PFxdGwZX6ajvpc2HezlgQyFMF6HOWnVH3WME/7gBCQyburTa0izpfA+FCjo6KZGJNzLZBDdvpchPhO1YVmEmFEVMi3eKGT31Q5nOyCd/RClYX0lJA+4Cl4ej5QO0r70HGBZOhf4iW+INRcbB2Vmw5NCVKPjHXs6dFl7Fwrnwkb2j3Ws4vogpQyrZpM3OgkdOrn4jSQCjl6It/JBdW3lovxJN84QKE6Q8ZBesLnFq9fBBvTGyvNMtb1zPc0uJf7+8IAdLZOwlOikEsO1PqH4IU/WK/uBHP4ifQcXF/mX7e+mmRKyCHuhZikaCCh6SxjpOYQsbJ+ep0SuuCPe6hjum4l5yZnau7lHqy8OA4Q8w/IdlQHI2sNsaBocLeum10wkRckzD8zjyVI9NxaqhSP9ESNoLSSQznHe7FsZDgFUuN3ekHjP/S7YDBNT/8Wq7L/XTIO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(39860400002)(346002)(376002)(136003)(366004)(396003)(66946007)(66476007)(66556008)(83380400001)(8936002)(4744005)(8676002)(4326008)(44832011)(5660300002)(2906002)(54906003)(33716001)(6916009)(316002)(41300700001)(6506007)(6666004)(186003)(52116002)(26005)(86362001)(107886003)(6512007)(9686003)(38350700002)(478600001)(6486002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WwqkgcWRuGQP5hfwc4uJYp0hi3a0O560pKv23O/r2m+76js0aJb8jJk8QEJL?=
 =?us-ascii?Q?S0M9jP/i0k+HR2aJFViDDdnRWFXVBlZSHXUaRRxVf8dKyGofbo2OPJULMY7b?=
 =?us-ascii?Q?Ao7VfW168cDrigSuuGcShMTxmSObB2bQV+uf7Twhk0b4mRK4zUjYH5Oimc7V?=
 =?us-ascii?Q?d7wDdjvym+AxRpiEYyn9S8Kx98NlUilnDhhYGAjecp5sRnrvKlj+eTmJvK71?=
 =?us-ascii?Q?NZqZ0iLyNnLnlSYcGhdCVwpaojENo8Awadfk+NXJO4X8iAs74kEFLMLKaFzs?=
 =?us-ascii?Q?M31tyf9Dy+uIBEYP4y2bY9t39FfX6lP759Tw/8SCK/MKG2jOHnBCC0bd11Qh?=
 =?us-ascii?Q?JsVVMYYh9CNPZqRVjmrzuoyKW6xaro/zWrWNpYtRNgT7GNaSCIvYEzHi0v67?=
 =?us-ascii?Q?CfjR7NLvB+WTn/mEW4UjEIexdTjyPj//Fx+1Z07kFtS3af/lGahLdLjgYWzm?=
 =?us-ascii?Q?eI9Eu0Arsa0GMbuQXWlLLHMRqpY4G88d1vrBZZNbn6pDc9LdYVA/XF41tVEH?=
 =?us-ascii?Q?EXLCYQM8Wa2+zau59YVJXyi7TOO8DlphVs0SHGcofODgTW2Ze/eXb++Becak?=
 =?us-ascii?Q?E4NSEtBi4wmEbUaTHYTmOgjKMSO+akzo4v8uRmSuXoAaOThcn+V/szMAG7au?=
 =?us-ascii?Q?SipJx1f0BRjxdAILK8kLpTg6TkDJleYA5fflKzjpkYgGz21WiOLMuZs0yVSa?=
 =?us-ascii?Q?NYofbTqmEmYIlaMr13AdYO35as37Zwbd84Sy5Rn+Mly0hhGgjByW360/cnQB?=
 =?us-ascii?Q?gq9XdtHX5lwMwMRiwn7gqe8zLxdsZY7ww4zFTPt2B60UCgnImrxe9wJd9txP?=
 =?us-ascii?Q?FNTn83afS9zW4tuMfrSJx//ATehE0VtLLcuz7rKO/2pTfPOQepmVRBrKQU6A?=
 =?us-ascii?Q?a++TC89Qeeaa+47I1byBHNkLj50p6BfbWk1HrM0PtV0AqUGH1BZeTeDjT6+m?=
 =?us-ascii?Q?9DBlasj0o++UDbIzM13ml/ffthjQ9mDeYeJLzAQb1w6crQA6/PWva7y7NsVo?=
 =?us-ascii?Q?a5SwBch1jEmZsg6z7aB3xrf1XhnctK+kLwpbeyM9oPDml9KGdSTqueyrv0IP?=
 =?us-ascii?Q?HXDKJOZOKTANpgqpwIsQ9gR1zRl8V4zsi3Tf+zDT52g8m4a84/D6ToDOSpaE?=
 =?us-ascii?Q?vJNSyV22dvHStVabsy1VPE8aC9QLfdCyuzlqDJtrv1u/oWCO1z9Bq+dIQlqO?=
 =?us-ascii?Q?Buj8GU1JHXSTNcNk0tSwWjSu24+DXmeXjA4CLbOC4lFtF+e+rjiO8V/wdT33?=
 =?us-ascii?Q?ExTirRA29pQD9mUNcYKf8S4tWDXojbD2LFbXn9wMQ5IMOiv475hoAlvySoeC?=
 =?us-ascii?Q?b9IR7lETJRwJrQXHgsxPqewjBGyu/mXOYXYdxtpYRCyX+x+lDqdEyQ2wcaU3?=
 =?us-ascii?Q?SNk31EytZVJ1Hx3rG7HZrwegc9qc33tMiU7OVyC+H3HIynDt5QH9fyJvLIEM?=
 =?us-ascii?Q?V9dn352Y10HVOPUY8i0h3p3tLBbjtLL2tCvo6WfNMKw5xDl3U5Qfz9DpHtyW?=
 =?us-ascii?Q?Cms19nYTkl2yPYXb8uON1C48HI5pGggOOVmAKpQ+LtG1ZvkS3SKxBZ0J2yGR?=
 =?us-ascii?Q?FgyYO4xsqgREyuzZ0MlN20dRUWEzkzhMPsodgY/15IPQmwkwoR53T3BvU5O7?=
 =?us-ascii?Q?qQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e1acb9a-23af-44f9-39a5-08da65a7a421
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2022 14:46:31.6430
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iHBIj8xjjh9nEulE1fWfBG5PE5v1aneTDv7vBdSTlfiAdiGpjPx719pGzyae83c0LQA3I/c24rY6OqqlY6ALpEOsXsQIwW9/cj500wvh66A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4422
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-14_10:2022-07-14,2022-07-14 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=682 mlxscore=0
 suspectscore=0 phishscore=0 spamscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207140062
X-Proofpoint-ORIG-GUID: O4qqMdW-wkT03hyIYz_qW8If5vE-x2Sn
X-Proofpoint-GUID: O4qqMdW-wkT03hyIYz_qW8If5vE-x2Sn
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 12:12:48PM +0000, Eric Dumazet wrote:
> As reported by syzbot, we should not use rcu_dereference()
> when rcu_read_lock() is not held.
> 

Is the comment at the top of the function out of date?

  5141  /* called with rcu_read_lock() */
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^

  5142  static int in6_dump_addrs(struct inet6_dev *idev, struct sk_buff *skb,
  5143                            struct netlink_callback *cb, int s_ip_idx,
  5144                            struct inet6_fill_args *fillargs)
  5145  {

regards,
dan carpenter


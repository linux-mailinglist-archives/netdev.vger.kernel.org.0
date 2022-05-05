Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBD6251BF39
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 14:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356184AbiEEM2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 08:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240218AbiEEM2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 08:28:05 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2EDD5520E;
        Thu,  5 May 2022 05:24:25 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2459PHxb026114;
        Thu, 5 May 2022 12:24:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=ive9T8ylhM5efw6wk9mb8syKOCNQlY5dPhxgsVb/B8c=;
 b=It66y1eA0RYwNLQWRRKNPDerQZ8L0MG5VpNnxrCcjbqfgRAu88NcmHqzKHCJG+cbQZNC
 Ye/os7qxqnXC4RFzyV9PI+UqV+pM/3xLDL9k8+q5cUoGFA/wCANyLw7kVFgppITmeRCG
 AH9joLjFQMz81V8B698gKsMZ9VRNiLkL36HX3WN4PweBL8iezkXRDbp77RZh+aOCgK1I
 7ZWwa8dS4ybHkG1uiHhr6gdUsHOeo3rI+bFb5D+5AfbyCxGvulaYoHEHeakfQuIpNUfM
 e8U64pq7EF2LEXfCfGaoKGZo37pMp9T9wUAutVEiyO3MxnKUH+ChYySQ/cZdJwHdpv6h 5A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fruhcayrr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 May 2022 12:24:08 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 245CKwV7039781;
        Thu, 5 May 2022 12:24:05 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3frujamq83-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 May 2022 12:24:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a37Y8nm5NT07Ns1q6bzF3LXSk3MVROhOKitzjlT8DAo3pwWE1p4Ofk5j5cQeXqTLBvqJwmF4SjJwEXY4nsp3PxSvTeyDPEYENsH7l73TjtQpf3Od9yUUG6BQVvqbLye2hzHKE00oDzjmLIJ6hkwpK/dkiQqwVcYCrda5pZb6gwu2Yc9c/ePo50NdLnP9KFVFi7IPoMO+rg3+3HVuo+LT3ub/XXvcShR3tDqgx07hLYrePj94TT5LYlrzoY5kwVmFKR30eiBDC5A0l1St+ACxz+mhPWDPER41RAqxnz112r0oLJMXVJ1pP4CVBs9x3TkeIljfo1zyIHgQXizF8faURg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ive9T8ylhM5efw6wk9mb8syKOCNQlY5dPhxgsVb/B8c=;
 b=Rz/PGtoFfBvDb6jaKUM2YoeFXvrPOJ+2yl7t+7meMxwsVl+ddA8+cUrAuhptO746xYAqQQugZHaY2HepUh2+SjxfwrhyJOen9iPF1UCK41KmqWhz1myAhQMe51ktnTP6wMQm0Sqlq1mqNUKSYuquKPJdXlF9JYPRLs6a+++8TDeGBqiqcfIkePTb/eLNwSsZAjp/pq7ibYgEITEOtnxlH3pFspee6rYTyG5rc24ehuRRbI9IvGeG3tAQUgmVyvPA+AlwYTYUVmAYFqLmXkUCBJV+JfAKLQGknE0W/nHJUu4PYPbumXdQBAL855Q1NlEYwWDrathif0zYuo19cvm8gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ive9T8ylhM5efw6wk9mb8syKOCNQlY5dPhxgsVb/B8c=;
 b=LU3H99m95auSKzWYx2urg+6ZpIom4D0YQU7/8hO/DSoqxIYsio+vYLMfXOIzBXXEHHuY8psIS+v25vjLiGk/HhLGL9pY0SjgHVwQ9nBlzzMdwN4h22OUKR1ACoCNNkpimikwjcuXOue5tncA2Usggd+FencgoDP/XhnhyU5R9zY=
Received: from CY4PR1001MB2358.namprd10.prod.outlook.com
 (2603:10b6:910:4a::32) by SJ0PR10MB4447.namprd10.prod.outlook.com
 (2603:10b6:a03:2dc::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Thu, 5 May
 2022 12:24:04 +0000
Received: from CY4PR1001MB2358.namprd10.prod.outlook.com
 ([fe80::e929:b74c:f47c:4b6e]) by CY4PR1001MB2358.namprd10.prod.outlook.com
 ([fe80::e929:b74c:f47c:4b6e%4]) with mapi id 15.20.5206.024; Thu, 5 May 2022
 12:24:04 +0000
Date:   Thu, 5 May 2022 15:23:52 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Geliang Tang <geliang.tang@suse.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        mptcp@lists.linux.dev, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] mptcp: fix deadlock in mptcp_close()
Message-ID: <20220505122352.GT4031@kadam>
References: <YnOu5xlGgE2Ln7lj@kili>
 <0606e0fede42a16c93231498d23c9afd5c05e26e.camel@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0606e0fede42a16c93231498d23c9afd5c05e26e.camel@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MR1P264CA0022.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:2f::9) To CY4PR1001MB2358.namprd10.prod.outlook.com
 (2603:10b6:910:4a::32)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee61e558-54e0-4e69-8b4d-08da2e92248f
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4447:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4447FA0C32F35271A706A3B38EC29@SJ0PR10MB4447.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /kmSmS/BKSXsJivhsXZ2ZV99KvIqkdthsJrT5tawJHYQHTPMdi1ROPSu3OOP/+gdxLD67WY+y2HYsoHL9Iub/jB4D/LlhUgniN53RoqyFBpuRtqyw9ZrJcOau1lSauuTgYsbK7YVdaXoWGMj9tAzt0qS+fqh2TOQqA8uowwybFjA6eYDeVFFZ90pnpbU0owArnfwUjPEHbbYdOEPCyON3yawBQB/boCyR6vaqGpZN3P33TzvHDtvuZGLbOIf+QlYDlK0FJMTyu2/x7wkwE1EqQhmFttjcLg3N2E42/P5UO5V6wuF2PFr28xTX7frZeSQEeRUkZDAtACNsLVF/sU9Ui2NLBukBQwP6kMRBr0WfC+hn+bV4lbhOnMLkD2m7d4G1jq6+lXoqscQaNbENXV2q8CmQXO2uHPCBg+UGfoj2cQjjvUEyoKHAS2x0TVOaoj+6cM4BrDB2aXzoNK0FsGpvY5l1Mzz40EuR7qbjO+6InfPtvx5Xa98JY4fTxDIvGH3UCCRqjiKc3Cnmk0S4TyseGM8zFtBBIn/NZ6nQ8LIIM0Ky3E2/+/OseaBNax/m4Z52uj9SYz3G3oyCT9YRl7xaXO1gj0FVsbY4XnEfngfdeBDEryLN1pFLglK1aHGzciq9284blFGbL6t9lJ+ZXQf3y+Rv+dsoFuDKTZlhen89710SF7S0ITAnfXO0P/7XrTbQFssGEbOrwH9CSR75EK06Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1001MB2358.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(54906003)(6916009)(316002)(186003)(6486002)(1076003)(66946007)(6506007)(38350700002)(38100700002)(33716001)(52116002)(4326008)(508600001)(6666004)(9686003)(26005)(6512007)(33656002)(7416002)(4744005)(8936002)(2906002)(83380400001)(44832011)(86362001)(5660300002)(8676002)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Jt0UxXs0GE5PVimvE+6851M8dLOb9wUtuY5cmldl3KKdAV1De2nrF4M+T8Gs?=
 =?us-ascii?Q?cahakY86ZQXGNqXGRRIsaK7K5EQVEAGy6z+14XjuVEYNuefghtzx/FR/7DSb?=
 =?us-ascii?Q?K65MdE28B6lVVzLf4dmLovHxg2/MRFuWXiZ24rxzS1ppjJs8WxZfh6wppx8D?=
 =?us-ascii?Q?UXnoLyXYoAriqECL/W9ofmshbwu3USx6/HCA259aUflkBXK+IDkT7ZVvoSWL?=
 =?us-ascii?Q?DbJUuiyZk9CebckieKXq5wi0e2aGPW2tnc013bMBEw6wYcSOe82CPprEkRdC?=
 =?us-ascii?Q?BUV0zN4YwrSL1SO6svkfBGNRDxkLOoRX0O+3JH64rtvg65TVdbk+GYgqsKKu?=
 =?us-ascii?Q?fsqjH8HEBekT3VdutFp3cHF4bJVtKXIPUGba6C2ieSkEdhf96iSfqTIwy+2F?=
 =?us-ascii?Q?+1ZSzMXlH9qptcbvMjXMeO3GoFZTm9zsGwVrWgWNMrXLmqCq//suJt0p1BEh?=
 =?us-ascii?Q?rnj0sInjeeuPG9gbLwlZn/QxC0ILPWlHUR0h421Jgr3OvrjpQ03SWMIbyywZ?=
 =?us-ascii?Q?0GFdTDLafuZKoXkasjULgi9w5JPA+NUUkgr+ZFNkgfyqMBpK75OA5A4YG2PS?=
 =?us-ascii?Q?m0T+9HNzXciRJqnlMq56Luc4qGQ6dV2hW5yqxk9An5BLOyWh0YYduMryWA38?=
 =?us-ascii?Q?0p0S+qX8HHgSB/FIW7TXLvXPa43VjJLzOgUsoK6nV1S+s5ZGG1TgYG22w6O7?=
 =?us-ascii?Q?j4BbukWjxiUFoncghLZNd08pXATZrcQVmz6C1WIwWr5rL8zqRqF3OfE9I3pO?=
 =?us-ascii?Q?l9cy2KUr4UFeb2mcv9CBoTteLHlKHPXICA19CHlPEdmZNfd+wNOMbUqdpSkO?=
 =?us-ascii?Q?xxyr9AzNYZCn/5HOSo1d1ImdGEPMDFCRSFTWEDReFN6mrUr+LQEEAvtfuJjL?=
 =?us-ascii?Q?ShEKHFltTHu9SoxMo8WaNkbXYLZG5LIOYtFC/o1LrTyvFux4VM1zhfcUs+JE?=
 =?us-ascii?Q?5Ajhp8kIILpoEX6UTE0i9ykwVs21p2xZdPkKz3S9IgIDSF/1dEHWw0pm3Cd3?=
 =?us-ascii?Q?+InB1+OjA/X45hLpknw1hiV+20zXWZNp+1NCd9F+PmCJ+PqYfAqXY9BWgYhY?=
 =?us-ascii?Q?RmtYpBovqGRxwa/3B8c6NOLq6HTvPBLkkRJpxQg61wxDnq0PsA7WdsdWpD/6?=
 =?us-ascii?Q?r+Lndi7Z0h6oM5PwiNhYlJ8nqUd4HM7V4THsS2hnE37jGkX7QFLQFLP29IsU?=
 =?us-ascii?Q?iKP075y7GNIoyLd0NoRUs0m06Cjxi/nFA0csBGyNf2ihtLB9/atPsR0UvwL8?=
 =?us-ascii?Q?6zjMOUhMQOl2net0W7/RB2Cx9tz6yZXfxn/AILRvcGRH4f/oU0x/Ufw3zMC/?=
 =?us-ascii?Q?3TMKMksQecI0wpZHOVheDksnxJzJvPHqcEjMYBxOo8LKVSZyktwju6l+BOHB?=
 =?us-ascii?Q?1X0kZNflZq6ccdtIn+XvBf5JveKYYpPXfkIg9ZdNLPIHMapcxSfVRaJrF7sR?=
 =?us-ascii?Q?NRxxwPbLYQy3RbMh25kcqsixku0dt1mCX5Q/WdWcCtS+GEFiKWF9NshUtPML?=
 =?us-ascii?Q?aaGb4fOoGOCbPneOXKSnVHXkvmMMnGsI4p5PQl5jKxzdmPiDAcDHOboDIzLo?=
 =?us-ascii?Q?O5sOWy7z7L2cE+Ll8x4iJuCFRRnar2MDeq87aZiLhBs3V8qxBnIzQPR6sIL9?=
 =?us-ascii?Q?QWLcLm1XX+pn+wM4B2rFuM6vKndZJKJykKKGqxqdZ4XaoC4b2irXQLC+zrTQ?=
 =?us-ascii?Q?naHbmPyvkEto4CXY5/Ia9GfAAX5kltjoC54zYSnbrwJaKfLrxXTWtPcdsp6I?=
 =?us-ascii?Q?RPfLJmMs0eryXdg9e6iPHahDM/hJCxk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee61e558-54e0-4e69-8b4d-08da2e92248f
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1001MB2358.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 12:24:04.2023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YFIz10r1jgCnlnxe/IErga69I0I/aXTIZGbFS1tZLJazKSnlja4/7QgSsHEQGbjdl6Zx4kIA4Mj2mZj0AxA25FVSTiqU1B2ElOfnf19Qtso=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4447
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-05_05:2022-05-05,2022-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 bulkscore=0 suspectscore=0 mlxlogscore=935 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205050089
X-Proofpoint-GUID: C3XA7dMZT4H4ks6iPLOADhSO32oK63RP
X-Proofpoint-ORIG-GUID: C3XA7dMZT4H4ks6iPLOADhSO32oK63RP
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 05, 2022 at 01:50:01PM +0200, Paolo Abeni wrote:
> On Thu, 2022-05-05 at 14:03 +0300, Dan Carpenter wrote:
> > The mptcp_data_lock/unlock(sk) functions are taking the same spin lock
> > as the lock_sock()/release_sock() functions.  So we're already holding
> > the lock at this point and taking it again will lead to a deadlock.
> 
> Note that lock_sock() (and release_sock()) releases the relevant
> spinlock before completion. AFAICs the above deadlock is not possible.
> 

Oh.  Yeah.  You're right.  I had hard coded into my local copy of Smatch
that it took that lock.

	{"lock_sock_nested", LOCK,   spin_lock, 0, "&$->sk_lock.slock"},
	{"release_sock",     UNLOCK, spin_lock, 0, "&$->sk_lock.slock"},

But that's wrong...  It drops the lock as you say.

regards,
dan carpenter


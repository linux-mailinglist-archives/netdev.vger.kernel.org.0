Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 476F5415E46
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 14:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240871AbhIWMYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 08:24:42 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:6028 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240911AbhIWMYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 08:24:40 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18NBbrjQ007037;
        Thu, 23 Sep 2021 12:22:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=FBiVIbn3bWVzr3uRWwKninzRbfl+A9gQ/OeCHdKibf4=;
 b=p7hxSD5h4GSgu+Z9fFbALoLORQcSniNkzIR2geph994yj/M+n9CKkP4rlI+66rAp+hYa
 haXPVeS1Gnc+5ATDaPgGDLTaKSDv1i7AGBpXlp669XKVy1ELzGiXUbrRxXY3HNmSsfRm
 SSEDLIuGIYlmDJNBvls5BOWqNYXBT7i/jh07te4Y/rq5yLFclkX1ElPMReK+9RRUm6ug
 SMpsPL6pcQTGlKd8vbl8rp4lbcGqLfsEIOyZxiIokcqAb/sHkqx3MqRwqUxtj1zmlYaT
 sDoItssT3UPNjXV2g5vUWiucpY1NAkX4ZCtrnWZqIt7LCyv+N0JHNLo+XYeBA9dlRiSq sg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b8neb1jh6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Sep 2021 12:22:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18NCA7rG163358;
        Thu, 23 Sep 2021 12:22:41 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by userp3020.oracle.com with ESMTP id 3b7q5xr3xn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Sep 2021 12:22:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oNGLoYzTDirzAcT5Sjphpth2MC4E6REvubm4W+eJjNHICvYjct0jbZsa7Z2WaI0Bkxl0JtrkxAFVejq29T7bFRMlRb7hOSKOc87dFff8uxWnH05tWPZrIl9HLw3cM81G8QO6UHvEAojCbCJNQ7wyhHhNOUUl69qYSoyhFJiRzjvS31FR1vkawVFI0bts1/OSylcr3EA0Ke/fspdtdXLIrPFGO4rqz+M3JDPU5YE4nJ/IKEMzgWC1LZ1PdKsp/5H1PsepnOtMRm8qYSHbwuVL0D84vzNsLNbxxanQQYyPq8KIjG6nS7H7ubDVtanubyqPPG2Qr3Vh2F+5LiibMLQmaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=FBiVIbn3bWVzr3uRWwKninzRbfl+A9gQ/OeCHdKibf4=;
 b=O4bXKigRTKXkqF3TGBauwf+VdrVYceRaxmxtbAAEzVGYM6LvOOOV/1oOND2VEi6ywWFxeqlQ/xvVDbCwQJZgbb878GgioHBpmNzy5OTpdiy4/pvx6157ath6TMrcdVpWs/SaorLapluHa3b0cxKpamCCRV+Ys9YrA+WfSvtlMOQjhjkZO/AIE2e+eHgn5w7ir9tG039Zt2qwpzjrQM/YH2T1I2ajmrhffp1FhALjoRVHqEdYiibbnmUjbFp7ZajC2PUM4v6Cq2mJOzbl6ZoV/hs/+criqDElnwywY0u/okN2d9KGW774Nt1xi60Z6Y0uu08SAgT6kEIn/N6CgBHETw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FBiVIbn3bWVzr3uRWwKninzRbfl+A9gQ/OeCHdKibf4=;
 b=b/G8CfTq3qD94IqRqJlESwdoxDqgvXfSLVpNgvKuqE/DLb0S3iw1aXHhN7p73H9z4tEklZHmStpUQ6iSYiNNVysCLw6gsP1wAbwguOBps8V1TgNlYANiWW9V+2jjyqTHI9pAhSgPyiYZJGvo86z3GnGbwPxp4GG+Toek/oE4D9A=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO1PR10MB4706.namprd10.prod.outlook.com
 (2603:10b6:303:9d::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Thu, 23 Sep
 2021 12:22:39 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4544.015; Thu, 23 Sep 2021
 12:22:39 +0000
Date:   Thu, 23 Sep 2021 15:22:21 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Samuel Ortiz <sameo@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] nfc: avoid potential race condition
Message-ID: <20210923122220.GB2083@kadam>
References: <20210923065051.GA25122@kili>
 <3760c70c-299c-89bf-5a4a-22e8d564ef92@canonical.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3760c70c-299c-89bf-5a4a-22e8d564ef92@canonical.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0048.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::36)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (62.8.83.99) by JNXP275CA0048.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Thu, 23 Sep 2021 12:22:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eee6f06e-c73a-4295-11bd-08d97e8cd59a
X-MS-TrafficTypeDiagnostic: CO1PR10MB4706:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR10MB470644370DB88F6FAE0EBE308EA39@CO1PR10MB4706.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JULEAElUNOrQRNPvvF5k7W0rfpVm875cU/YA5SKLgfMfgMmJQQLkoKDw8pqtgsaTae5l2JTPqbpC0gU2FoSN71PZMel5ss6p7swhvQwsJidgZ+xXsatJNs468GBZhlKa3CymbCwtY5vSvAR3HaH+0vNpW7Jm4mZpsjQ8wgdAdI+UCbZ3OIF0KAo4azSmV6ZikQ6aVbcFOTSbxCQUcH/LR1nV+GTedOLsXjZJf88O5Bs+up+IAnFuGjSggwHmzK0816kuN1WK8cqPXXQ2YYrr8hCORnI+xz0REOSy3PeaIVOx7X16eifeF6BBz7wpd46tFBvChYJVqRhi7bpiZJeiQkO9/EGW19BlkjtqJDI+8EF/JTGQ3SgmM0hGhPefy+kRZz0BIzZC9mC0CYQjlx3qZbniDtNhaCfDWXi1cDR93159Y4VvLs8IiCAbLhrvijCWV9zUV7KLPhy8/2hSMzPwIHKsJrZflBOhcsafOhfV5rfqKGdO1qmv+PqvDZJv/qTYNJbFtGFXZ62Hn/J39y1XFIglyO+nanKGnHnVlIcXQs0TWdCci3MBmETFStwOZl232D3by7nXSR7ylRqgs3ZNr5caJuJPJ6RV5CndfnAxzhsDLHv83YXY+G9pn1IyIO464FGjTcTfsawBhG/BV0Y8JCdUmvkeifqQja9HFTz2djvSHcFHQE3YDyS28iVJtq9cO+IuzTkQBoBJUnGkUYJzvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(1076003)(52116002)(38350700002)(38100700002)(55016002)(33656002)(6496006)(508600001)(66556008)(66476007)(9576002)(66946007)(956004)(5660300002)(8936002)(86362001)(54906003)(316002)(53546011)(4326008)(6666004)(9686003)(2906002)(44832011)(26005)(33716001)(186003)(8676002)(83380400001)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LSEWIhoF8scortx/Dq+5LZHV/zrrg8Cr0ZDJjHVWg029Ms3H5gNRnLlQkVNN?=
 =?us-ascii?Q?u1fnG5M6Nz621VFHYXSpMXjL7ruu1BppeRIoG5AH3x0cV5Bmf9GCOM4xPQxW?=
 =?us-ascii?Q?D9fU/U4GEwLBLzgE9I5AoNHBRgw7MBfZTr7FyDInaz5Y+pZluOlve07UBStJ?=
 =?us-ascii?Q?a6cQRA3jzRis7TU1SCFkVrTjGfqmJBzxsbLWvevzJZZWafjucNQwiy1w/QSr?=
 =?us-ascii?Q?YwzLdQMgpTSouIV3zpBmGMx5A1lPjTuahclp0wrV8GjLz7hZwhyCq+uZbsGN?=
 =?us-ascii?Q?Fu/O/AAysK9v+qblz6Hw3Bndj9EWzW6BPJrURKcc1QUvfgoiseLUIQLP/kYI?=
 =?us-ascii?Q?3/Y1uRJxSwtVV4VY7uZun1EagV3ahQv0XZZYWXXqC5IYu0DZv8hoTunFxlgb?=
 =?us-ascii?Q?GiDCGO/g7rWsCXFHZB+v4AwVIwEi0/DhsX7IR2OgWk3j413V6L2LzHoIwRlY?=
 =?us-ascii?Q?9d6cT/X+Fai/7N1ePeLIFnBK5ZEiFQ+hs3TAiDs9gHz7e+bhGDXxPGccb0eN?=
 =?us-ascii?Q?TGaYgyCzku3byh4k1XnQVioBfsPQTPyK6TePhwsnvQ1u6+ifLdjeqWtlDwC2?=
 =?us-ascii?Q?aTeEazL8zM77RQh3IkYQO73Nq31C9Rmp1EiF7O6DfEA6V8RJQpE8jC8a3w9X?=
 =?us-ascii?Q?bg4zVqCUbyr32R9oudaHxNzo7bYf0LKUmUGZ+Z4HqznlJIFi2dz9Kb8ela4g?=
 =?us-ascii?Q?505GpjIvSB3Tp48fXqkY1LSGCE/v/qHKVYJ5Lpn1zGHzKwzN+O7QoCvRCbZe?=
 =?us-ascii?Q?OBxTpwn4EZCg0WOZ8yfTO/DI//PzZQsS9rYSC1kFPfqXKX85kPvuSwLZikrh?=
 =?us-ascii?Q?AgMrb6TGEEcqYOOCZjnIS2sPh+3/EMI7CZm0NBNcK5FMeIDcw95iL7NbD1X+?=
 =?us-ascii?Q?unTMjDbgsRH8AKle1uTt1hG0PJ3phsqLd/qx8oI3MdD7PxyyPjpxO2epyPwv?=
 =?us-ascii?Q?ApwX43EZQD4nO4a94R2JOwksaYjG0kS+1pHPm6olvJDTpJSX2jl5+AFH+Kx4?=
 =?us-ascii?Q?fek2y4HXN8aq1tDSkb71kEFo4rezWup/pwHy1Ln2oHhI/jveegi6n6xjkFo8?=
 =?us-ascii?Q?XwRqwzbd0UIjVMFA6n/C4PrCvGlWQ5c8qzQcv4FhW4hFJ88LdPc09SE75qGO?=
 =?us-ascii?Q?Q98GnzNSxN1dHvNM0z0gYjpQfTZedZ+PPrl1Ywz6hPhbTq1DpZ99t4zGHg+V?=
 =?us-ascii?Q?DwKnQ0vNsrnpy2SUqXvE1ru1Tg/HHZNxdlPIHJHLA4R+w0Q3u9qPuIHbIOZb?=
 =?us-ascii?Q?ejXc1XOlWyrxIozrgxz3yh44ow7jvZIYgT6EdjCKNAfdZgfDz/w1l0HhtiSX?=
 =?us-ascii?Q?R1S2ESXBZLDbIYFZFIhmknSq?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eee6f06e-c73a-4295-11bd-08d97e8cd59a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2021 12:22:39.6819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0s2KI9ddGarafTpdQ+QDJ+ylqYiNqJEWwQ/S4gGXZP1dlYc0Cw/uLEU6KVzL5oQnfjNGhfwPFmiuV4w7BE8p5R/cN8DLeXAC9efDzSHstXo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4706
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10115 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=815 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109200000
 definitions=main-2109230077
X-Proofpoint-GUID: naTmqxQMSyRrh-03wRqx-YZxpyKp3vE4
X-Proofpoint-ORIG-GUID: naTmqxQMSyRrh-03wRqx-YZxpyKp3vE4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 23, 2021 at 09:26:51AM +0200, Krzysztof Kozlowski wrote:
> On 23/09/2021 08:50, Dan Carpenter wrote:
> > This from static analysis inspired by CVE-2021-26708 where there was a
> > race condition because it didn't lock_sock(sk) before saving
> > "vsk->transport".  Here it is saving "llcp_sock->local" but the concept
> > is the same that it needs to take the lock first.
> 
> I think the difference between this llcp_sock code and above transport,
> is lack of writer to llcp_sock->local with whom you could race.
> 
> Commits c0cfa2d8a788fcf4 and 6a2c0962105ae8ce causing the
> multi-transport race show nicely assigns to vsk->transport when module
> is unloaded.
> 
> Here however there is no writer to llcp_sock->local, except bind and
> connect and their error paths. The readers which you modify here, have
> to happen after bind/connect. You cannot have getsockopt() or release()
> before bind/connect, can you? Unless you mean here the bind error path,
> where someone calls getsockopt() in the middle of bind()? Is it even
> possible?
> 

I don't know if this is a real issue either.

Racing with bind would be harmless.  The local pointer would be NULL and
it would return harmlessly.  You would have to race with release and
have a third trying to release local devices.  (Again that might be
wild imagination.  It may not be possible).

regards,
dan carpenter


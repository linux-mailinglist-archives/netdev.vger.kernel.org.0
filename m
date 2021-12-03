Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F26446748E
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 11:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379791AbhLCKOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 05:14:41 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:9300 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1379789AbhLCKOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 05:14:40 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B38iSpN025636;
        Fri, 3 Dec 2021 10:10:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=UEQu428iX/0vzh3yBl9DcyuxBuj9LHFZjJ/ynRPxs4g=;
 b=ZQlhl9ZFGGehOFaRvCq9s3kZVNZCX9ezbEMO4lHyscdgfjp/W4W8iPi4bVT8kYqfDcpH
 o6tGJwsw0YDTROBOBlaGM67/OKOYQulhu4xbmd+Yqt3kzWnhNJY3AwddV1OsqBdUj/8M
 darJnMYIDKyYLOJ8b4kXAKdtpbDOG97I4JKfTAU7gs4rb/OM7IXTTj8jQwLeJv7A4K20
 Atflo6GSdnv408aX1bfPqOSgIail6g7PxkMYSse+KwPneQHMvSuQ+UExeEZnM/VnaYd0
 IkSrEMl9UaEHlZ5PlVyUS+wI8XZLBRpHmuTs4MWnC5/dlU+76uFMEVkqehBHpUxZ6mnm yw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cpasyw86e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Dec 2021 10:10:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B39trtO081875;
        Fri, 3 Dec 2021 10:10:54 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by aserp3020.oracle.com with ESMTP id 3cnhvj7v9c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Dec 2021 10:10:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e+MKQyV2YcXpSdsNJuxbfKqDaMFBmV4HcQ5fos0ubeAKuvaQu8Wr/opwvbmIB90+xvonlUPqvb/Ul/qvDWIuWcNOC4hgN/I2L9eEVwdJB23+dq15rZ+j6JMfFJR/t6JGeP/6MQx2bvE7Yn+wDw38b1ZwyddBtwi1s7cz4pVMeieHXA88P8XeYBDay59TNxu/QZ+s+trT5VUaajubOyPcrX7aTcE2ShHxm5GALELorxoKPQOGtMWqwqB8h5TLMwYCjxKNXlPMmHc4hWQ9U0HZDIGd7UcMvVUQsl+HAfwLDhxSsW0t7O0n9tTpJ/lmnsQErFY+jCcRLsM8U8WCuVeUew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UEQu428iX/0vzh3yBl9DcyuxBuj9LHFZjJ/ynRPxs4g=;
 b=OBemLu7GJutNKOrJ+Xj07OxrO/CnQNc6BM5OnM1dH0HiwSr3ZnX0f6t0UheGjg6KbbmBKNpThjL9fCIJ5X+4/FAE4te6ooNDl0bVwvII5LJVvtmkpiEGvOSbvhAaQpGb251mShjMyz2hRp3baTdBeEhLLGA9a47JRpmViYm29zNtq5+itM/rwjvn8+hdWMqLAT2UQ7658dRBDi3kXgf2Fp489ySVuuOxLY7mVEMzR5d5peEh7Kkd3c/niETtjagX2QSqjZGZtkWWhrXnE1dFLxiMZYMgGSwFq1IwwkawOdvp8WJ1EVaeeAyLkB4Druh2w52LRiQhxh0CGIn3qpCNLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UEQu428iX/0vzh3yBl9DcyuxBuj9LHFZjJ/ynRPxs4g=;
 b=R76f3nrVusPMraGrxgoBICMS0/eM8jWnLqFSWBKpkLswJGWewcPljXE09Ug7l/6vxpBQeY0NAK+DgrCAnwEDiW5SHpjFa6VEiq50W1AP8aZJwprtmdfBIZjBM07zXQeKa9wnJ4az2dxsZkUyCSzUwGg9tGwRKaDJpBfpLrRQ0Y4=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO6PR10MB5460.namprd10.prod.outlook.com
 (2603:10b6:5:35e::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Fri, 3 Dec
 2021 10:10:53 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0%6]) with mapi id 15.20.4734.027; Fri, 3 Dec 2021
 10:10:53 +0000
Date:   Fri, 3 Dec 2021 13:10:25 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     GR-Linux-NIC-Dev@marvell.com, Ron Mercer <ron.mercer@qlogic.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeff Garzik <jeff@garzik.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net/qla3xxx: fix an error code in
 ql_adapter_up()
Message-ID: <20211203101024.GI18178@kadam>
References: <20211203100300.GF2480@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211203100300.GF2480@kili>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JN2P275CA0048.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:2::36)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (102.222.70.114) by JN2P275CA0048.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:2::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16 via Frontend Transport; Fri, 3 Dec 2021 10:10:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db9404d3-532c-4a39-b322-08d9b6453044
X-MS-TrafficTypeDiagnostic: CO6PR10MB5460:
X-Microsoft-Antispam-PRVS: <CO6PR10MB5460DA19F3AC669399C0BEE28E6A9@CO6PR10MB5460.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7Ct6zD23/NKDH47+C2HK9cVg4k4WxlsQLPgn7iYb441WhEgYlfZtral9sAwI7cC1NobBZYZ+5uzfKHjSQXu9O+SRfm4HPbgw5tl8vpelfKiMCV9VLc9ofxxW63AqsMh+8kzh1IQLbzpsj2kyWeAZluRXYkjOdiC5fj10qEqIiwSgJM4/WRzHZZ4lm0HQLrho1AmdZf+gr4NUB6VAJ9lpw9bSEA1lZIQsT9agx/8gJ78dmVWXCSbNrbnLUenikLSa3BQ7v/ysffKpw+j53B6iYQfZbnRsDFp91q3A5eb6MHaHCBPiB6ZCWuSqrVzOGMIXDhhooFIuSL+3RltU1iq9oZf5K8MnU6mtZlMEK3ARd+xu5HVIcxJB5hmfR+rdi2kDuCW1K6M7OY2N9lj0zWvRMzhpKVG9l+3Fxq/j3l/fVulqwRvBsSumHE8D1g75slMUEWSx1ma+AmKxoAuHTqeLQU1yAzd91nJLP5pkTXcS0/uzna8Be1HgFp/lm+TMmNJlxxK304GxQJv6d5UzOEkngG/IUGc98RaGZl6jhM5D3f4W4IDaB0ZcLs3ImTfqgNI5v1Ws6j1WZcCaABbVF/mvDcNOXKnpfTFpl0cheW90uBbshpD+vTtZd4ia4YgRc0FS84KhIvM6slwGgLkgpxp5Xv0R0RyETSrUsvzqfEuSRH1m+Qez0GEA/mqip5nX9oC79RWvy7F9Uo8ByEgAe8N9FA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2906002)(1076003)(38350700002)(558084003)(956004)(316002)(86362001)(54906003)(38100700002)(6916009)(508600001)(8676002)(8936002)(26005)(4326008)(6666004)(6496006)(66556008)(9576002)(186003)(33716001)(55016003)(9686003)(33656002)(66946007)(52116002)(5660300002)(44832011)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RQRgfcKrK3X03B+VjCtIUEc7CqmE/YJBrETFoMnWkv4q2cNgLB+Hx2IJ9c0Z?=
 =?us-ascii?Q?3MPp2OvAUhLpi0hkSrUvmiT+Ls4KYizyZXW7b8W4W65lWRvGRmz6G34E+1eE?=
 =?us-ascii?Q?mPyHBAh2EtjeIlx2dG4Fgo7ZfwT7cA6VISs9Z/LCcsKw1pQJ2trxYSVzcq7Z?=
 =?us-ascii?Q?pbRmQCiojC4nK78pJUW9jbOJk/osKBTKZ1sGd5b68V+6rXzpPWQWTSHoVEIE?=
 =?us-ascii?Q?SfCQhu/akpe+1am/pyVumBTksew+QW1iP0OOSdedp37PMZfAQtPzgcGUFP76?=
 =?us-ascii?Q?YgH17S85lDOz7ZmorD29Kz4ULTBZWzTE87I/np6v0k3cboankSuvvNzW1Cdu?=
 =?us-ascii?Q?BSh+fWIxNXjSRxQ+OA0hS9sQYffcPnLFAyUa85QoGarhapJDR4rEE0hOGvFS?=
 =?us-ascii?Q?yfgpJWZHbs3uaaMVkXSxQgAINDK3dD/6B7BQC1pf2A1HrIeAwhWQoSqCGPg4?=
 =?us-ascii?Q?1S/s5ToWKVi1r23/akL/vtI0ynhK6Mgf8JGd8n4bsFoF4K4tsP6Q/ApW+0/s?=
 =?us-ascii?Q?ohsnMrC+05pRHDK/GFaRGfToVHPiUfu50/kXuAcrCWKGeN6+w6Bm8K/vGSzi?=
 =?us-ascii?Q?8tzLxlXM5JCPpEjT0joDTXv133QvHTNdIuXhDbyiTbeZP5Z7TtVOUmVedTjm?=
 =?us-ascii?Q?MvCgbLsXTlpSv9dgeUuAnEf4Vx0DPV9uKqfk7HTmaEmtCDCqchUvWFiz+gd/?=
 =?us-ascii?Q?qvS2cgdzDgiekvHs22YU+48bwRoMX1LaLfTW4BCYRHfJTooG53usDoACrJDZ?=
 =?us-ascii?Q?hpuL6VKIo2E2CVZZjrnRpP5KWu4dKn8tnQB3Fw5cxV1ELcM1rDIMcglJZ0S/?=
 =?us-ascii?Q?xdc+znxxDx2FibjELw+2+HTRkXruWxdgYwujnLmDaYmQA9x8SS+mWEItuIir?=
 =?us-ascii?Q?F3d6cU0l5RiNwAWqqkxtHY0tZaEf/cEw4BZCxPfyUJyn+YK9omn4sJCq2aqs?=
 =?us-ascii?Q?v8rl8hlBhAKi/SLfgUcZAm7vdsLovt8S92EspdwSlCVCLhjOnQdgFD93NAiW?=
 =?us-ascii?Q?G0i7r641nyPa0Pdhdg14yyrdPoM/7owMoaFdko8lyEZeSP5SqnmMLKqlI+m1?=
 =?us-ascii?Q?TB/wWH7yabZq4gEQQh+n/J8lQumGC329OtobgMeOUxXgz193kAWc/vaRUrn7?=
 =?us-ascii?Q?dtP8oYW8j9FDVMSWNcrPMgS9iRgWYjqIx4xOqAdKvVaGbs12L9o+1OUYW5Js?=
 =?us-ascii?Q?bF26q6FnACvjfAsAH9FuIFqGERDno/ou7lAdUd0e76AUP0Ew7unFeFt3NCoR?=
 =?us-ascii?Q?GLBb/6//9l0BjlurEQTm2KwJ8SKFz5Gsbxp+ZK836pJlAUvDR43EbH5E9/1o?=
 =?us-ascii?Q?reIwN1mCAQpWJvd1G0WCz4M3RxUlUPoBV+TFLWUl5L7pP4B6RP56naRjK8xD?=
 =?us-ascii?Q?nnUYGOsTMVjBV01bQP8y5DNq/YFIAmYpRRTJkgSUsuj93Ew9R9m3DLxP/519?=
 =?us-ascii?Q?hR+u547yu23OsVInMPMmt3IsdHmo3cCCydGMkEPgfJTHqZOWp2LSOeqjkZji?=
 =?us-ascii?Q?QXAd1tnmWuR+S09wF0H4kdNRR8NB+noiQoR5TOPZWpcwAFguWsy3sxwxhJL/?=
 =?us-ascii?Q?HgctKUue22mzgphhEEDicXktiJcSyupEpv9ybinrncQnhkdHa0W+cJE2m340?=
 =?us-ascii?Q?JynoZZUHRhnnTV1T0LD+XzCzwNVo6ccojYoz9b4wgE1IKIsUOgYUmyZ+C82u?=
 =?us-ascii?Q?kMU6R9YiCy2toZrH2GmoQgDY6qc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db9404d3-532c-4a39-b322-08d9b6453044
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2021 10:10:52.9732
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YUdJqkQO6201WYEcD0WRk96udXoDp311W2uu6Tj7qi7moi9004EDdfRUIRnSBF8FfKAhLJsUCk6ylQU+sj5csLXM2PudOPWA8wzv/MZnE+8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5460
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10186 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=644 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112030062
X-Proofpoint-GUID: qAT84VfHhc6VkseBorOjm4Wh_-m6Oum3
X-Proofpoint-ORIG-GUID: qAT84VfHhc6VkseBorOjm4Wh_-m6Oum3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I had intended to put [PATCH net] in the subject.  Although it's not a
high priority bug so net-next is fine too.

regards,
dan carpenter


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4563D6C6A
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 05:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234718AbhG0CeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 22:34:20 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:32724 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234513AbhG0CeT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 22:34:19 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R3BxeS024480;
        Tue, 27 Jul 2021 03:14:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=mNiGAHQkZzBjO3jLZnijGZb3Sc2ORDgyjyRUFuvLZW4=;
 b=fRAQ+WvNgibB0mfPy+pLgT3ECdGpKrvPZTNCZ7XEQGMqtjSz1sXAzN0tAWb52PqF1vMo
 uS0UyZJia1ErLD/7NM9UdTiLCxHTiUyFGbfKw8YM1NJcFQXGF4sm2fK0do8NdZmMrV3z
 ScTKB47Y7qi6GbZGAr5jK7kIecsHuV8bMJdLrtKh/XT18ckm4nP41QXvYYDsG6M4Fpl/
 h+BlgD/lOIewos+tlXok8FvSliBLz6CBYKd7RkoypeXREa/K09Bxw7Gf0RzgpV3HZ7M/
 R6Ou9ft5vPqeyad1Ovip2f3dIOkovENLSuY6S5apo6b0UxtWqrDSu5DVZRmiTbmw0an9 2w== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=mNiGAHQkZzBjO3jLZnijGZb3Sc2ORDgyjyRUFuvLZW4=;
 b=lztbmLyXyfXIokojh4lzfW+IlFELJEwwq8235ctr0LCMGTAsCZXZyGUz3kMpkEejzoBw
 xVU9nr55fNAMiblijgI+W+oZCk681N9dIYz4UPJbjl4KHlR5rABn+LqI/lQ7DhgL69+M
 Wkoy2q5VE1cA1+m3++1RAvz1suUH2+OP3+cNTTDAU/uUMU7zenuAc6OYwoyQ6eABGb2M
 LbVf0ywOkPuBMLCSSN/KowHzYY9Xp4xq87wjqRUXE7/aNjlfNmgcWKPs+k4H2tOU7AwE
 bOe7agNnYOPlgthKASqEWok4MKnIQg1ThGY0HkOgYzge7iTDLl28wN7KJljOm+Wn0ssp GA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a23538m7g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Jul 2021 03:14:38 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R3ApUs050480;
        Tue, 27 Jul 2021 03:14:37 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by userp3030.oracle.com with ESMTP id 3a23524b93-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Jul 2021 03:14:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mtd6H7dVtHWhGtV3DqkbJh1gLCYkUoZWEF6r5rGOd/Z3F6PJyio10mOh9GOOVUj803lgQ1AedjYjdjhhZztl3hsZKZn0zOTL33tn2DuUYBgJ/DBMHO6XDBKZbKszFutE7d3qrfhet2+Lio9s5FYgqNkucaqiMEgYW6I7RwiDbpJgHaSxrE5ZA1Ddyzy2p44MvTqGpaDvRK1RQp0HEIh4MboUzwb+DO6nDrZRXTD9dcZRkmkwIktiTMo8sX1b0RfsdodRhv0albtxlGokjB4++f06hEw17/ojqrIlQ2vvo+BIZ9H3/J9kJdIE4pVKNvZ9/WrqUpk+93KDNa/ptG1G9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mNiGAHQkZzBjO3jLZnijGZb3Sc2ORDgyjyRUFuvLZW4=;
 b=A83wIHgGtJkMBe0Z8vPMVX0s2c1DOW6XLBGNJD5li24KAyL4+VkxbdCDYcg+WhZJATitbrHtbzZG8xnJTBxSmPwBoulzatD3WKUhJ4e8OGo3MNBwT63CoKd4CeSHOBOqtX/Ue+tO9uJRn6r3E370XQMBxS7ySHYHHeZWLLa6w+4yXGTNTFGxm7P7RwIyf2jQQ9f6GTUU2WbA+I/s2DVdckH83ypdXdyJHkPP2FzYvTAAHgz1b2L9qMje0g0pZ3dqWtv7GyUONI5iHnu22RheHeKwM8Mu0hqXOVxbzT0WbfDLaUBOfazAr2JE62erldj8jKK1QJNh+Jt68GOY0eeQrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mNiGAHQkZzBjO3jLZnijGZb3Sc2ORDgyjyRUFuvLZW4=;
 b=Wwre2nDNDji9qpCMkCivThiMSOv5LrVnoDjd5lKi26jjQWZD7S8ADcU8Tqi9lTDe2RiseSuwxNHjYiQzhtPxR0eDHzV9G0ImuQbz5dkdPIQUr8IXXn16LfGBgHOWNfpLkVGAW7w/arN708wmSKCd1Nk15UzxzK/0Mzl8VV9thbE=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4501.namprd10.prod.outlook.com (2603:10b6:510:43::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.28; Tue, 27 Jul
 2021 03:14:35 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 03:14:35 +0000
To:     Bill Wendling <morbo@google.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2@marvell.com,
        "David S . Miller" <davem@davemloft.net>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 3/3] scsi: qla2xxx: remove unused variable 'status'
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1v94wqwhd.fsf@ca-mkp.ca.oracle.com>
References: <20210714091747.2814370-1-morbo@google.com>
        <20210726201924.3202278-1-morbo@google.com>
        <20210726201924.3202278-4-morbo@google.com>
Date:   Mon, 26 Jul 2021 23:14:31 -0400
In-Reply-To: <20210726201924.3202278-4-morbo@google.com> (Bill Wendling's
        message of "Mon, 26 Jul 2021 13:19:24 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0801CA0009.namprd08.prod.outlook.com
 (2603:10b6:803:29::19) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN4PR0801CA0009.namprd08.prod.outlook.com (2603:10b6:803:29::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend Transport; Tue, 27 Jul 2021 03:14:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a15782a-41be-4018-f373-08d950aca8e9
X-MS-TrafficTypeDiagnostic: PH0PR10MB4501:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4501FA0966BB2A452C25C7708EE99@PH0PR10MB4501.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OC80ZKuKnDfpIqaxcCAWe/mmeMZVlBIKq0quVF64RW2IoPI3OPVmO76rPjYJ5rXZj5v+rdDsiSEc3JvC3udqZ0TgqSOKn899AqApX9WiBi3E9MmoBtyXyVgO3sEFiq/mt55l4DUs9OHxhP+zyPjk6DR6xhuNToMxLFDUB6VDbRAUoLD2cWVmHsaxDAnJ3FLtsTOdT8MtMN9EMW9ommI8bkv0PMQ1ZlZhBgolDuZH6fCNQ+ku6NklliWJrNPK9oLXOHAoHAYs1XkDEaJ1gwi9jYZW4NjLFbsxu+EsVCsorYKvg/D8Oa5ldeWOshYjRWS6a+dIJNrAm0tP6X8tpP942UEOQW2hWSe6mXKPUbmpWC/3AOSymqEbFskUuRCismHfDjQls9W+QKFoAHbbdMAsF+yljTd40atgbuXk1ukruv7P4OL45SfSCgpu84H7KlYk5pL7NHm1UvruMwWEvTyM4IEuxaDwab9A5z3zoyBzqG7LewOl50YuwF7VjR6b8FeQxDxyUC0raTaPk8ebziwE2+VeVCkC7GDIB5MYaC+RWobwENQ8BhAUukF0IS4vxRd0CVtOqwAriJ7UNxx/K8PsYcfIg2UlkCmXruXHxF75lbirCX4eOF4txP95pcqEpLklrGw+sxsYg0X/pBMzMnXw94NoxRpMN0AmCnViD/z/F51SKCduXJ+5rFvTCq84KMXWtvP/DXShGwyBOMVYcGHvTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(396003)(39860400002)(136003)(66946007)(36916002)(7416002)(478600001)(6666004)(66476007)(7696005)(86362001)(52116002)(186003)(54906003)(83380400001)(2906002)(558084003)(55016002)(26005)(316002)(66556008)(956004)(38100700002)(107886003)(8676002)(38350700002)(5660300002)(6916009)(8936002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?w0d0mYnBkWVdAPXHo4/lCl6ebTyvW5iCkNIo9j625FgvPsN/VzxDzzrLrwcT?=
 =?us-ascii?Q?ancxEhp5JfSbNht7XbQbZgoqGyVRKr/Ta5+SK9rLhn/JrhCgfhaMEY6E31FG?=
 =?us-ascii?Q?pO7n154cb+/nHrwl7K1LbgnPEFNoWW9HgfG3QQwlj/6/27Ph22TNzUu5WTxd?=
 =?us-ascii?Q?AB6s76QRB+bh0aPu5FtbrVlhDCjmSo4mL3fp0f6Ab98bxrJfF4WCUJJLW5gG?=
 =?us-ascii?Q?5uMeFUBrepq+ChoBjqORqjgIsJLtanTATPeN4i4clM6pSIl2x6FKVGVeUBM0?=
 =?us-ascii?Q?JHI3X0KUOK1nvYyHTm7oMTfwsuPZqGslx4BnLwA0xFxNdDg22StxRC8HxuIk?=
 =?us-ascii?Q?r7pJVf5Ll2qWnifwQRbzQlu5+3yitDaceOAJTJaxK1TXcyGqsKEp++3YMABH?=
 =?us-ascii?Q?qyYIB/p2vUzeKmE36kSzPV7JkYsK2g/fPEbwQFJiZ86Pd/O57M+QBezkvcB9?=
 =?us-ascii?Q?J4admkxeK6U+9nyYJua02NTRmVQEWJhOqJUy2tMV8t4UEDz+IdQnL+PYpXkT?=
 =?us-ascii?Q?ttJrUr2ASHFDiY18+FYvMXkIDrhV4GtCuOx7iGCacv8p/QFO3YFcqjwdT/Do?=
 =?us-ascii?Q?81OQwjqS9phk0wdL9s14sQuBk2tj5r8uLK9NGg30drgWtvzZmSnr6adoA3/v?=
 =?us-ascii?Q?4YHEJIY+7/UzJ7TDd8A+EGFzoXV99hK4WJdKErKJ2gn4iuoR61uFbOafB22j?=
 =?us-ascii?Q?eIeuDAHVYcFSJjmMzucPMOvs1DD5S8NraRhS94dMvIQZvH78x2p1CK61+Xqh?=
 =?us-ascii?Q?bXh4bkgGlwkKuDbHLAmMgeghzohpqs+LPPbYBYWGE/Rjm6vgoQFrs+jmhgee?=
 =?us-ascii?Q?GEubg79fNBwNYFrU/vW8KROlFWpkr9vbPuE0x8D5pSwTFZzgdrR9DGWzTbzL?=
 =?us-ascii?Q?arbOlrH/rRSFdd+9awasfcv93xVJAvZj6IejZfFhYuMWkldTtx5MJEIZX/YW?=
 =?us-ascii?Q?6x5HOlmlMXq8h0p4Djk0CIqb2EI3H045mK0q2WIWJ4DdudOXSZe8l18Q+611?=
 =?us-ascii?Q?9FVdnHrYV+etnmfC4eO0zKArJSxbvOabJyvX4MCNoyFD164STaI//djw0Wj/?=
 =?us-ascii?Q?5K/58iRYECnFilAe5H6b/wrpoa3vqdTM8AgSUNugKplrxnFpRE0TmR9rjHfl?=
 =?us-ascii?Q?CZdDVXXZe8mKl2XRdi6a42XvB12Op5yPhNHGpX92d/0NC1kJg0g07NtZsT6D?=
 =?us-ascii?Q?PDXUb7RvzXXL8lddaxJR35U5GTlSDHlKCeZQyfRlTC9baBTkiUGLTYS0nFPM?=
 =?us-ascii?Q?DH0vkVVa09A34o/TtqUg6eE1d9E73oX+aa+34u8eHLYtfH5IlCThUBQaqXoA?=
 =?us-ascii?Q?9YB0xFAWPxeRQcJg3/MHMtB4?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a15782a-41be-4018-f373-08d950aca8e9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 03:14:34.9332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nqYyQYTu7qXx6u/W7PY30yaiDgYq5x/uH90cWqB8V6qfNKeF+lq1Pr/kUfmkpVrnjmQBTzJAceRBkeWxXuX2mgQu6T/w+HiuSmm5R23kS6Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4501
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 suspectscore=0 phishscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270017
X-Proofpoint-GUID: _cNJv6OGRklL1EXwHpkV_eZFtHs-tJvc
X-Proofpoint-ORIG-GUID: _cNJv6OGRklL1EXwHpkV_eZFtHs-tJvc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Bill,

> Fix the clang build warning:
>
>   drivers/scsi/qla2xxx/qla_nx.c:2209:6: error: variable 'status' set but not used [-Werror,-Wunused-but-set-variable]
>         int status = 0;

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering

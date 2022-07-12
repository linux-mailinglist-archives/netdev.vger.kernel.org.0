Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEBC6571BA7
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 15:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232819AbiGLNqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 09:46:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbiGLNqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 09:46:33 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D5412AE32;
        Tue, 12 Jul 2022 06:46:32 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26CCtali016693;
        Tue, 12 Jul 2022 13:46:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=rei8MsmC99mqd+V+IxA1yNkDZQEaRng3A8rMNlnmijI=;
 b=g9JDLIRsnWD4tiej+wKdGgBi88Vj8pMCvHQtTcLqyPJDEUXq2hz6P8azNORoCQoOqyH7
 M5oArrf0UiqLhXHeX6MJ16Cd/nnoZzz7jdL4hD1fockF8KZG5cP3SCn1XGyrGTPfgVHd
 OD1n2tRGltyP4N3+rdZrSCDWh373RlFvh8s44Jk6FczzlUjpnGIJFZYIy+xCipDmRcWr
 sGb31m9DHlpwCTM21I7+zRiWucX93jbcO+u9m60o80VnIFc/GcVPwbGV8ZTBjA6gQOGe
 qNv5DONXeMe3w0904ZPQSdD5vkOFaIlGf0mPxedhogH1PRNmqZnjGAlUmTrDtulIRlUD Bg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h71sgpggb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jul 2022 13:46:24 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 26CDeLt0000740;
        Tue, 12 Jul 2022 13:46:23 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3h7043pg10-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jul 2022 13:46:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VmisbCRrZWsnNX/0jGwO7lh+Skh2WZChKDB9ocrmd3TMBIuZWlLeOFAb2146W6uZm2XoqerNKaSzFToFbWQm0sFdiVg4KDQ+YJkZkGLk52Obqq9ymTUReEVWDkUZYPJG89t4zyr/QDHA2d87RToRlgxBk8K13bP6r4fZgEfft60zPHzKSKzqCmjq9Np3583j4+MBrUMYshUxnlG0Bh1hOkrhJ6UoEYaXBGEYxoSxnH/1GUvxQUfBOz74f24MfK4uE3/MNweRw1GppRcGVL4h1zCJzEMDQoGiQMpqHYRrMdIIQiARZg8aXPxgs4J19ejjgk+KAbbHCK/YI745L7XkkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rei8MsmC99mqd+V+IxA1yNkDZQEaRng3A8rMNlnmijI=;
 b=SzMQM9MiU0FJ2/JciTmU8DTzEqpz9+ywV5JQklfb+Iz5mlYE7gV5/Dt3XKBgo55/yDpxvp/GMeMw8LyXcLQB8Z99unPNPtL5KURfucISc1oJXPGf/mc4zObhDH4/5Bj7R7+FBhvDus+BKWKx/AoC7s3m57Kfv9mnQmsA2qxsj5T16rAESqDLD7G2FjqK6il0dnhHFYVULAl0K7WGC+WhUWsdb23RySsoaQFnm0h21bTj62hMYsS/tpzjN0jWg5mhkM7mj7hmKQfFkL22EDh2sVBFlwHYTYBau6U/EXtugfsyZbgbP7w1L4BovTRnzvAcxEotGBoTvlkgHYlveXqwGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rei8MsmC99mqd+V+IxA1yNkDZQEaRng3A8rMNlnmijI=;
 b=sypKoQrMd8XV/QwUHXm8QBqwZU6fDut8dLQWR/8DcZ9+GUWYkxo2byIax2mIx+dIzs9cUhrfNDFdUYqPz6druYoQ10Th4E/gDKp15i0H5CDg5zllh6AAI+I97Td4ClJNLjpQo6SCfzrG88MgcwD3+OGIlFKKvw7nzR/1tNrMtgc=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BN0PR10MB4904.namprd10.prod.outlook.com
 (2603:10b6:408:125::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Tue, 12 Jul
 2022 13:46:21 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b%6]) with mapi id 15.20.5417.026; Tue, 12 Jul 2022
 13:46:21 +0000
Date:   Tue, 12 Jul 2022 16:46:10 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Binyi Han <dantengknight@gmail.com>
Cc:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Coiby Xu <coiby.xu@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>, netdev@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] staging: qlge: Fix indentation issue under long for
 loop
Message-ID: <20220712134610.GO2338@kadam>
References: <20220710210418.GA148412@cloud-MacBookPro>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220710210418.GA148412@cloud-MacBookPro>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MR2P264CA0190.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501::29)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce8ad774-7dab-4fb1-ce48-08da640ce754
X-MS-TrafficTypeDiagnostic: BN0PR10MB4904:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zALHbLuPPoaOmTomOAEne/lLmGo6u6Z4CeSsflvEVdDbkuJ/jTHcUbt9iFPtXMQg0UQ1BPNFS6GXRQi3pjoCthiEGCkyuoxkUUmyRzO3lEtBYbHvy85xbBiMt0gMwWwjnY6RvkXPDRW4Nh2kI7ubNRgJmmEbKqCQJnFIVVAkx1Z+SsikOoDFaCBymyBtYW2yDmBJqh2HUTtspRT3CMi3hkVWpImOYJ8Hm8s8ZSoQoKl44qAJT737Oy0syzYWt5efGoZnupl0NX2wN1WWw/3WBC7NpELOFD0bLP2TmmlNAh1ABKT4N8xDvQ6oNNHNOs66RFAcT2pL0HNXlxev9LCkkD63c6DII4QAdAjABzc3AS5tSS8nDxMwaD+cVoL9bGNw/fNYFUJMPHdgh0Nm7E+qR2TKDv6t9sOJhvoirklkwCE4oPdMwHRfEiRe3vqc2w3gsqfNROexY2QSO1I1y8YZI4Z2l+v3AGnZdJ9kL/H1atFQH9bZGOIau8xa07VqcKfQZ2bPRoox7GJgz1Ddb4FnyA73I42amqKkxsjfF9UP2EZJ+9bQbND5nw+nzivdy4z8Kc8lD0VI12CkjbYLWJuJEv7jymVtueUGnlZ8teOZG2zE03BU4LA0ME+nRBMLzudpopS15C+eKHgB9I9z85s2ujCcnFSJhdYNwjGIi0VQeu9gmh/ODx9udsGT68L8hVxYIRb8L/vOsRdGR5BLK2O2cB9/XHoKAeSZ2mPEfCn1BM+WAu2XKyOCOPvQJR+nGIOey0VziuhgRe65EIZlWgh6e4FGGGs9EfGPKCJlORjxsbaD79Qv5nCGhaEBKLm5k10p
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(346002)(366004)(376002)(136003)(396003)(39860400002)(6916009)(54906003)(4326008)(1076003)(66476007)(86362001)(66946007)(6506007)(316002)(5660300002)(6666004)(186003)(41300700001)(38350700002)(66556008)(52116002)(26005)(8936002)(8676002)(6512007)(38100700002)(9686003)(83380400001)(2906002)(478600001)(33656002)(6486002)(33716001)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pmbmpgkebH8fQ+4WMiuWZY5Ci+bUVrk1fimjLOOJtftNV9dHwvxiuTSCMC40?=
 =?us-ascii?Q?vLCj0Si4+7i4ynXIKx1ut2CheLFY9PihD1pxOp1vo78Qinb6lYECkuYoaRRr?=
 =?us-ascii?Q?C14+fnMTQ/a8iISTJIuObD3PL6NLZuD0f4Ui3sp+IvTFZIwBE6qdTuBH2/H0?=
 =?us-ascii?Q?NvuftBPOzHtOVbwX5JnHrRLwAWozwhUwjT3MfVlk4b+D/JNjopGi/PwkXlPA?=
 =?us-ascii?Q?xRI1ButqtJ9SC7287yv5KsXrEdnhY1qKr3XdzZotOpzVnkBbZ6supcSQiLFc?=
 =?us-ascii?Q?BW4f+r5BoMgRO36U0350iBRqkgGFpRtWfSTyLDQVXsyNrvETmAL1KHL41isP?=
 =?us-ascii?Q?zWSHtCBmBiV3j1SQgsKx2y3KaGiB9v+p4BTCR4jUXG2yQhRK8KwMRO2eF8LO?=
 =?us-ascii?Q?8XZD+5eRqJzZ1ua/KG6Wa7Ucl747NJtuMrdrbmKs0atynaAZy4bSSJ9Mmzih?=
 =?us-ascii?Q?Qiru7pRnuPP9bHBlo8tVVUPXaVh2JSsRHbTX0/I/fl1CIQ8K/RGjeX77IoK4?=
 =?us-ascii?Q?mllD8H5AlfdHTMu9G2dTNih2mwnmRnxAfqF2/YqYqtLMIWrCnAeF3Ag91dEA?=
 =?us-ascii?Q?2pBa6+YbMAO7DmP6Pk2fjVYqHX9ukFI+sNHbuI9+S9qcIdPlW0t/JqORUseI?=
 =?us-ascii?Q?jJGxzPfy47laRo7BMb55f2B8H65fJ06VCvP7NcjvZQbtu4PU5dvMJ7F9pNOx?=
 =?us-ascii?Q?aQSvTwebS+tsqKCFFRepFsBJlVwHguynrDBbiiGmZoZ3W+50vPPlOawHo23U?=
 =?us-ascii?Q?ViKnAo5RIGhjqAwsY6He45eQ3Z/bLIw2fbfYEXKttnA/ifKPWKX5eXA/wlz7?=
 =?us-ascii?Q?Ya82vz0y0S7sGgVzSfuAcaO369+D33D4Vw28Rek/STqqa3In2OLhafBc9WNv?=
 =?us-ascii?Q?7AZE3UAxBauKDyoj4a/lzkUi0W9cwdFpwiKD9iBAEQ4Hlb+AUcrT/F4vMIIP?=
 =?us-ascii?Q?MxbA8/6sMQxe+RXYX0mi31+y+siZOXfOoHG+amRaL/IhVdJtruva9l4Rw9ac?=
 =?us-ascii?Q?ZcJugKdcEA9CRQO5MG/LP4F3Zg9+yG50etvUJUrIrmiK04kjBi9hlNSX/ciu?=
 =?us-ascii?Q?ZJlvRZ02FJty+boV5dOWTm5xhPutjXw45fd2N57/sH9lNx88BIz3Z3v/9cQb?=
 =?us-ascii?Q?0JbFZYu3ztxA6Kizow8QamIEyBuJwuX4UZxZqfrfqSfBJy1qA/L0X3TqzAkb?=
 =?us-ascii?Q?8rMXjYSV5gMJE5qV00L5hkvcIPJfzajX2pEJOgCko72q90wDutlCLtWWctFY?=
 =?us-ascii?Q?4kbjxVYBUUVAOemxaWp9tYdz5BZpiZft5uPeyMbyLE/kB2nrjk6UPGgxOIyn?=
 =?us-ascii?Q?rJIf7ARYbHKvga1WWBbzgiWAhSSBs+PfEjtBWFAMl55BgRc76p6H/LAT4HP5?=
 =?us-ascii?Q?T6ubuKFmJ+qE6oP/IWyufyB7Jfhl5L5rSWRyA0J43QwOmhHXfQ6MHsVZdWTr?=
 =?us-ascii?Q?wPI+0YFYBgdcSNkhiVT6wnwWxQ3Hn1gWYoMY8hZvInCxiU6EtVO6wY1ZzNJB?=
 =?us-ascii?Q?c+K2GTcGoXhA9tnsSvbtrCJEqAtocfhIy3zbRWlDEpz9JCdGHGFGBvviGQZr?=
 =?us-ascii?Q?lmcjxjjPDZx1e8EWBNPEECkSguyuI21mP2xiQIAF+UMY9q6lQApnC2NxXmYJ?=
 =?us-ascii?Q?NQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce8ad774-7dab-4fb1-ce48-08da640ce754
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2022 13:46:21.3576
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2+bnl5O6HTcn/vCYnLoK2PgtaZL2u1QAQLW/b4u+iCpRiFKpEy1oqR3how5eIliarfdNi1MdjNIRt/r/Rq/c2aOmz/ftJYquRJnUeoF61S8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4904
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-12_08:2022-07-12,2022-07-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=0 mlxscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207120053
X-Proofpoint-GUID: eSPe78UtmY7xQCdRWTDdQLjM8YZneZaV
X-Proofpoint-ORIG-GUID: eSPe78UtmY7xQCdRWTDdQLjM8YZneZaV
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 10, 2022 at 02:04:18PM -0700, Binyi Han wrote:
> Fix indentation issue to adhere to Linux kernel coding style,
> Issue found by checkpatch. Change the long for loop into 3 lines. And
> optimize by avoiding the multiplication.

There is no possible way this optimization helps benchmarks.  Better to
focus on readability.

> 
> Signed-off-by: Binyi Han <dantengknight@gmail.com>
> ---
> v2:
> 	- Change the long for loop into 3 lines.
> v3:
> 	- Align page_entries in the for loop to open parenthesis.
> 	- Optimize by avoiding the multiplication.
> 
>  drivers/staging/qlge/qlge_main.c | 20 ++++++++++++--------
>  1 file changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
> index 1a378330d775..4b166c66cfc5 100644
> --- a/drivers/staging/qlge/qlge_main.c
> +++ b/drivers/staging/qlge/qlge_main.c
> @@ -3007,10 +3007,12 @@ static int qlge_start_rx_ring(struct qlge_adapter *qdev, struct rx_ring *rx_ring
>  		tmp = (u64)rx_ring->lbq.base_dma;
>  		base_indirect_ptr = rx_ring->lbq.base_indirect;
>  
> -		for (page_entries = 0; page_entries <
> -			MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN); page_entries++)
> -				base_indirect_ptr[page_entries] =
> -					cpu_to_le64(tmp + (page_entries * DB_PAGE_SIZE));
> +		for (page_entries = 0;
> +		     page_entries < MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN);
> +		     page_entries++) {
> +			base_indirect_ptr[page_entries] = cpu_to_le64(tmp);
> +			tmp += DB_PAGE_SIZE;

I've previously said that using "int i;" is clearer here.  You would
kind of expect "page_entries" to be the number of entries, so it's kind
of misleading.  In other words, it's not just harmless wordiness and
needless exposition, it's actively bad.

I would probably just put it on one line:

		for (i = 0; i MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN); i++)
			base_indirect_ptr[i] = cpu_to_le64(tmp + (i * DB_PAGE_SIZE));

But if you want to break it up you could do:

		for (i = 0; i MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN); i++)
			base_indirect_ptr[i] = cpu_to_le64(tmp +
							   (i * DB_PAGE_SIZE));

"tmp" is kind of a bad name.  Also "base_indirect_ptr" would be better
as "base_indirect".

regards,
dan carpenter


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4656C474125
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 12:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233411AbhLNLJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 06:09:57 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:25412 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229502AbhLNLJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 06:09:56 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BEAU250004563;
        Tue, 14 Dec 2021 11:09:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=+TzRgKpHH87DVJthjmXcebv4dgrD0vgcXhWS6+J3P1g=;
 b=zRBhirJzay/IMh5ym+5bL9hvTDddcf6aOudbl84yVh1wzwRYF6h7JHSyfi89SZAlWjKC
 PLbs6tdm4UFM2YEnS7hKjzIZZ5JBZ+1S07yI6Ot5GXNg3stegCZJJY3SZM1t3bIPGR7Q
 TnWTaHg4TGB3W9h9Hm1ZZLW145Qabiq8WglmXx90jGD/KBdxHL43oZwCeh7kwJ66uAF7
 qmvl2O3qZq5fy1iaZhDKlb7pawRtWzJ9mkyth00CRiohDneWyfRGdv14xZ8yTcPkXgld
 CgGc1zTn2yZEmgbFJtXPwdIt8PtT+swK8t1rucnAyd5UekXHUQSNGoHIqx8NDS4Et1sQ PA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx3mruhtu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 11:09:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BEB5o65148662;
        Tue, 14 Dec 2021 11:09:51 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by aserp3030.oracle.com with ESMTP id 3cvj1dqn58-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 11:09:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PNlKRAcP5LHiKRgjKb15s4A+bHNmC9gzoyES1YTbnzSXvPbNG8nfD/aEkEz/Dz7q0MlV9Nzf7QGDbmBG3uGG9xy101mDSYFWigDA+KfjDL5vg753z1dVcRi9MYf/4vzalUhlf3YWyGWuPSn3A8sosDv2wk3/7kwadJ88Pq29mU9PoaRXptU58AKfRXhSQP7o40pm1c0x+aS6OqTbwk2bEmW2z64MJN2Mnt8dG3dyk5MsP86VZeN7wueabBLBb6DDXEc5TZ2Gr1B6DTkP7hWgG8WVCRO0qc+/ZeqJdzjHhPjCzvFBVxCNK+IPFcIIHkyRi8ITBbfi/drTyPD7WzDNLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+TzRgKpHH87DVJthjmXcebv4dgrD0vgcXhWS6+J3P1g=;
 b=WuXK0CHOscPIDUZkFeOAtw71SYbyQbMgNkKEkk/DNa2Rpik4IXZRCbL2x5dKfXrRYoxYLMifhKqKuMiBQ3ml4Q6X90DqqM810trP+Nj6lW6dWkFUObuvpL+hnuSOV6gg+mAOF/FHw1jh4kMY978HSQvI6nqHRbd1z1d59tgq11q4JjPp+KYc+rfeOLGF5d5X674PKq1VfNpJMAkIwQ1PxT3s9/7uWy6NNhx7oIV9HvyGur63PMgXwzlKlL8ONezKEy6mnnOXtYV3zuzu15xbRio+eWjFEFEYwewQKK9nEerF5gocgoPVs3BDrcGmKPBohArby2Zqo3NBQ5iN5fRCuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+TzRgKpHH87DVJthjmXcebv4dgrD0vgcXhWS6+J3P1g=;
 b=rWwTbYWjq+G6fLPDLtBJ7AZc9sgw7FiqF4IG/rsodbDt60OrmyX3TjwPyrAecl7xY+nUFXyl2JeOHtp79T52J/u+OnmClZhdMKPjTKwJGU+gc3qGViYNZlMt7GZmgUXl7NLmSAoTFKi81lEJcsrwz6/SU6AkYg3YY9e5g5q0WQg=
Received: from DM5PR1001MB2409.namprd10.prod.outlook.com (2603:10b6:4:33::35)
 by DM5PR1001MB2057.namprd10.prod.outlook.com (2603:10b6:4:32::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Tue, 14 Dec
 2021 11:09:48 +0000
Received: from DM5PR1001MB2409.namprd10.prod.outlook.com
 ([fe80::d505:458f:8b5c:14db]) by DM5PR1001MB2409.namprd10.prod.outlook.com
 ([fe80::d505:458f:8b5c:14db%4]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 11:09:48 +0000
Message-ID: <fef9d1be-54d5-ba1b-f7ae-fe5a063afb8f@oracle.com>
Date:   Tue, 14 Dec 2021 03:09:34 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH net] rds: memory leak in __rds_conn_create()
Content-Language: en-US
To:     Hangyu Hua <hbh25y@gmail.com>, santosh.shilimkar@oracle.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
References: <20211214104659.51765-1-hbh25y@gmail.com>
From:   Sharath Srinivasan <sharath.srinivasan@oracle.com>
In-Reply-To: <20211214104659.51765-1-hbh25y@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0137.apcprd02.prod.outlook.com
 (2603:1096:4:188::17) To DM5PR1001MB2409.namprd10.prod.outlook.com
 (2603:10b6:4:33::35)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6d17ffb1-21b6-49ef-f08b-08d9bef23dda
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2057:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB2057234B7C5E1153526D12FDFC759@DM5PR1001MB2057.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1247;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D0rkuVB/ohp7L5BGMC0rgyg5lZCKOGuocw1A1R3OBJZfhoS2hDnbZgW9Or6rYh2zuJLjRjqhFMvddZQuVsbqMqOL1z61srB1RcAelWxXdNOMkFgpFibU8f8SsQCSLMmnZnHwe+KvX/R6wl9sQwpa//f7b3tGZqhq1l8Z+pP4kDu17qvCNNxCLe9kSf/j1o7QpKcQ1tWWhTI/O1rkRx7fpC/ru7M7MeUgn9YDo52Dbmn8dvABR7n4C9NSRR85mIgXSepKIYvs29pyFytUeE7TP2KECdFRDneEhvBgFL0yp+G4aGskjASDf0nZrH53uUf5nbGLniNMYUUShYoHwWF9p46AqtddZ5jgvVCqrqpyn3oSJVE7uURvyt2FISlU1fQTWLP+OOWk0Qhg2kYEarrhCOGhJ1coFTwAbuXsX1vDqQs/p9xvYh6A9r26hQ874xJNNshTeGVNtVSj90dTYht1OwwhvNXBc7cTCJVvdCmMDN8FDkcQcouDsCajSIv64zfjaCzTuAiOPJMddKhzEqiwhZlxZcubD+U5NXdYnSZFfFubc/MGr6PI21flcXTVnr5viGjulks6iZXFqzh9w5pe3tQj/jh0edlW4JAD7ePZ3y2ScmFI7NKeo7abLwWBZhxbOgO7OQXI9mItH+0DBg1TUNWAAUx+M9l+7fSzmYf3yxBQUDEXsulkIPQWjI6cn07EWDIcUoSH3qq1DLQooPoO4XYdJueDUJOugKahg1v0jvQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1001MB2409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6512007)(66946007)(38100700002)(31696002)(44832011)(6666004)(6506007)(66556008)(66476007)(2906002)(4326008)(316002)(8676002)(52116002)(53546011)(6486002)(2616005)(8936002)(4744005)(31686004)(186003)(36756003)(5660300002)(86362001)(508600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TW5ZVk5pWHV1b0NsRC9sRmdjSzRsc3haVWRMTlJBNjFaSjZzWXR5SkdqaUlE?=
 =?utf-8?B?cjNDbVhVS25WTlhTVjZZUUZwZGtYWG54R0NEbk8xdmZ3eTB0eTVPRG9YcEpS?=
 =?utf-8?B?SEtnVVB0TkJPZVFZK3ExR0piaEpkeVVWNTllNzY5K0lacmYranhQU3Y4Qnpx?=
 =?utf-8?B?NnN6NitIS3JoeXBvc3ZpVlM1NVRSS2I5eFI3cGRyVk9QM1F2QUx3L2Yzb3U5?=
 =?utf-8?B?QmV3ellYck1ZYkJVN0pldG1nVVFhV2dPSWlFVEw5eEdXc1lKV21wZUp2aW4w?=
 =?utf-8?B?N2h2TDlIWm54UCtxb0orUzd6UXhTMTVaUXRrRjBITWtQSFFPZlM4S052cE1K?=
 =?utf-8?B?Z250WXNwLzNQSlNJOEx2UzlCdmV6U2Jxc0IwS25QNVpzamUvMXdEYzlNWlha?=
 =?utf-8?B?bHZweUxBWFRBOThoY3Zjd2l5Uk9aQ1FweHpSdXE5NEdQa1J0bi8relIvYUdu?=
 =?utf-8?B?bURwdTl4ODJVYjBIU3ZROG5IUUtJbmQ4L2t5M0kzaG9kMDVxNHUrYmlWalNx?=
 =?utf-8?B?SWpiV29TWlU5OXBXNDJZRWwwYjM5MWRxYmpmWVhHY3h5ZnlYUjVNanhHRWoy?=
 =?utf-8?B?bTlQdWZNak42T041VUEwMlhtUW4yUEJWUHR4eUFGeVNKb1FWMlkvS2RmZU5y?=
 =?utf-8?B?aDROdC9jUWd0am5GTXZDUGE4SHFiWHVXVHk1MkdXRU9yeFdRQWZuUWY1VHZo?=
 =?utf-8?B?YmVNSCtpTTg0QSt5ZnZSeHBXTCtScDJtRFJhc0N6UTdZSEg0cGJMMUREQUpa?=
 =?utf-8?B?SndNbWtsQm5qanBrczViMGhDeHU1enNEc3NWMlhubWYzTDk1YmdOYjl0UTFK?=
 =?utf-8?B?VWFHZXZMYTRxYy9yQ0pqaHJ6T3ZmTmF6ckFVTmx2d1hJTW1Dc0NCeEFneXYz?=
 =?utf-8?B?V3BrSVZGTlVJRnhMazM2K0w1dXhOV1JzZ1VlU3NoL2FqVXlPQ09WQTZmL0hJ?=
 =?utf-8?B?Q28wblhZWVB3OW1wT3ZSK2h5TkpQQXZlUzc5TUhjZGpOTVN0TWdweGVrL1h0?=
 =?utf-8?B?cm9VQmFVUG5rV0QyK29xQWUwcnRtdHVBVkF4ZjJidzNLVHM3a0lnSnNIMzlX?=
 =?utf-8?B?WTNKTjV5a1JSaVJabktDd0NONzcrMHlBd3dKQ0UvYWVnNm1vNkRCby9BOElm?=
 =?utf-8?B?eENXcXFib1o3VGJoaGI2enJhdzFiR3E4bS8rZVJyc2tWdHR6bWl2Q0dQcDJw?=
 =?utf-8?B?b2J0VTNiOWFMVVRjb1F2NGNyV25PWlpXampaSzZGeCtRV0xSa2xLblRDSk13?=
 =?utf-8?B?d1Nacjl1WGpBQkhBY1ZwcGliQi9hL2sreVc2ek9uRGRpMVU4WGpBb0hvS1J0?=
 =?utf-8?B?N1hhNWlJWjJqYzUzY2g2TytUcVJCR2lXWXBFYitRUmQyaDhvSWFyTzIzOStj?=
 =?utf-8?B?TXExL2gyL3pGd0UwRFZWZ2o5TmdEK1ZFanNud2hDZTgyVWVTeis2dWtRSTlo?=
 =?utf-8?B?L25qUVRpWmZZV2lTR09aa2FnSkFlR1lVQ1ZHZHZuMDBnTnNsNXZPS2hpNzZX?=
 =?utf-8?B?WFNYVWUvaUVuNmZnU2hrNVM5S0xPdDlocDBnT0diL05XQnpsM3duL2RTbXd6?=
 =?utf-8?B?amZHdW12WEJ4bkd2eUJHL2hERlc3VEZwbXZFWWxZRFFUNDBmNjBSaldjd3dq?=
 =?utf-8?B?ZFNOVmlVQ2ZzcElmakJFZllGaGZkWVdEME1EeTQ3YTNiQm5HbStYN2Q1Mjlx?=
 =?utf-8?B?eUQ2Z0J6YnVWQXhlRzJqTGNmeEhSWFh4ckpnZU9ySzRTZ1BZNnBxREJ2NFlR?=
 =?utf-8?B?Y3FzZk9HTm1BTGpYUm9hUFdpYmlTQk5jUDB3ZmJFeTBFS1dnWFZsUnRTaWtF?=
 =?utf-8?B?N1E0dW1vTnQrNXFnaEZkQ243T2M0Y0UwNUxwdzZYc2dYZHBTZXFNVlRDVEhl?=
 =?utf-8?B?Uzh5cllIejI0TnZITUczVHpPRGIrb2FXN3gzV1kyU3BXc1BGTmZJeU5YMkdX?=
 =?utf-8?B?N1g4bFg1LytsMkZUbjZjQ1NKaHpXd2FLeWdVWXBWNkpGa2wxVXBZWW8zNlln?=
 =?utf-8?B?L0hkdkxQZnB0c0F4bm9EVFMrZW5IK1ExcGZXQmFHNDNvZ0dBQ3A0OHNjdFU2?=
 =?utf-8?B?TU9BTG5vSTYrSzJGWUVVbGtLakdzOGo0VDl4TjVMTVZuMXF0aU1CNW9kbTRx?=
 =?utf-8?B?eGtpYnFDSklqLzF1ZW5SNGhvTlQveVU4TVppL01OS2owemt2aFRIVlRobWkv?=
 =?utf-8?B?YkpudytuRnM4MUNITnpXUGVwUnIyVkJEOS9jbU1oSVlkbGR0NHlBVWRWR2Uw?=
 =?utf-8?B?UHc4TDVyRTdld2haelAvdDYzckhCVHdCTFZneDdBamQ4VktyOHBGVElsZkxF?=
 =?utf-8?Q?FQdyxg6u/OoTxSDNzZ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d17ffb1-21b6-49ef-f08b-08d9bef23dda
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1001MB2409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 11:09:48.2915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BOCknkv+MTU0OZBFkiBhKR/EirCf6zIskPwIQFFfMkQNY3qF++pmnCDSbty+sGMDM2RJgGNLgSQ73Wa8sGCvESR+4P7l6TdTXgvBeVDCtHk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2057
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10197 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112140064
X-Proofpoint-ORIG-GUID: 3gebZ5GmyO1vFlWuuA5bpXijJ14XbUZ4
X-Proofpoint-GUID: 3gebZ5GmyO1vFlWuuA5bpXijJ14XbUZ4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/14/21 02:46, Hangyu Hua wrote:

> __rds_conn_create() did not release conn->c_path when loop_trans != 0 and
> trans->t_prefer_loopback != 0 and is_outgoing == 0.

Probably a good idea to include:

Fixes: aced3ce57cd3 ("RDS tcp loopback connection can hang")

> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
With that,

Reviewed-by: Sharath Srinivasan <sharath.srinivasan@oracle.com>

Thanks,
Sharath

> ---
>   net/rds/connection.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/net/rds/connection.c b/net/rds/connection.c
> index a3bc4b54d491..b4cc699c5fad 100644
> --- a/net/rds/connection.c
> +++ b/net/rds/connection.c
> @@ -253,6 +253,7 @@ static struct rds_connection *__rds_conn_create(struct net *net,
>   				 * should end up here, but if it
>   				 * does, reset/destroy the connection.
>   				 */
> +				kfree(conn->c_path);
>   				kmem_cache_free(rds_conn_slab, conn);
>   				conn = ERR_PTR(-EOPNOTSUPP);
>   				goto out;

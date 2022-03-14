Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 280464D8B78
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 19:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239596AbiCNSMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 14:12:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243667AbiCNSMO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 14:12:14 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9843FD88
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 11:11:01 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22EI4A2u015175;
        Mon, 14 Mar 2022 18:10:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=m6decs+omM4X3GXCQdDVqbEIUcGKvM1sAkLU5MN2lBw=;
 b=LuTQzoAr/lpsCFn0Thfd9yHZCdHh1rIl94gyWu1Q7vch2rwniC+6g/YYAY67AgqAGQpO
 AgHj1SQCT05GNx+xzf3yYspLbFMxIlZMGBVUPcFyK+pEdHNY6YmiWyasJj6f7jtr/xWc
 7gPmPm5r105Ca5WHCYzRX39/3GQGHjnlFsSd3mbye3Xu7spjDB7EIHBlvIjSWHWfKT5S
 YAtfH+8M2mFCXqZavGg121G0+4rEYRCjC1bV12Mu+OEmVwAgis3cUR4G9G8ImEbeNirI
 fxj2VucxpLeKLinkQtwdvJXaYyu+lcbXOEMWXdXgegb/N1Chz+D7SB/FAXHoTDJE1++j 4A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3et60r902v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Mar 2022 18:10:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22EI4qtl170770;
        Mon, 14 Mar 2022 18:10:51 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by userp3030.oracle.com with ESMTP id 3et65nxm55-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Mar 2022 18:10:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fjRYGyq+qlQRg2zh+SpwLd5faraSJXS7jxjxAtUjE5CYwMZWiDCI50i0ms35y9NNl6br/0l1s2iDxFijWoH/2YJ/oIylSdn0JOSESrxTAibbMU/aiw2cCL7s7IUzS3rcraaTMWNiQcUMyHeJKLP6RlcuT8uHi/zqdFtYzab7uGzkG75Mwdm9bcYg26mA5arQZmkBRBEDdrlCb9HtF1KNIVrdPTuTRF1XohIB3bv8leSkGiIhX/kK3IdUHLUJSefgKgkyn+Np1zooxZLBmijRpTO4d2eOuOQLgRub0j8IrO6YSZcF2vJVxx3vNhW7StImWRT/NyecFKSEu/hwSuZguA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m6decs+omM4X3GXCQdDVqbEIUcGKvM1sAkLU5MN2lBw=;
 b=Lhr5kwHRKFcbfMPZDhoX1UFlysHOKy6WjlWBfROIvsHNwGDgIZriRxVTVSlymKChnXNN2Ir8MPxySgHV1JO35BhikKV8pAaMekRR4f0fxBlco4b1NB9O3EK9MUe7M1usPyEmpyMfX8+HQt81SoGiav6XwgOm23X5Q9QU3592Kan9QjCxdcYBGE9XvXWd93MmNQeF651vfJ6+mobBxN/NEdzSLT3LZPLE6tsc62eYwhanoqA0e/S4deBoAJCBR/0vgYP4qa+sCKY5ui7Tq7jpWNvfnWP/CydW5bpXfq35o+vX919u0hlop65dbX1U7Uyy7xQg8vZxNbeyn8+kuIZu0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m6decs+omM4X3GXCQdDVqbEIUcGKvM1sAkLU5MN2lBw=;
 b=isPVxu47trjP8KPKTtKMoiZDBAhEI87oXxvlKfQQqFdY99uZXXxkZowYV74nlnJi/NxaAlCM5Y+2i8lxMYLZR6+eUoFmcztDbL1R6mSL7l7q01EaTdHbuIWgd41X9wCrAR4sHLmQqUZeobjapyZD7VoTEYp0xzDEQBpR5OHg9PY=
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com (2603:10b6:a03:2d4::12)
 by DS7PR10MB5215.namprd10.prod.outlook.com (2603:10b6:5:3a3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22; Mon, 14 Mar
 2022 18:10:49 +0000
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::48af:b606:c293:9cc2]) by SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::48af:b606:c293:9cc2%7]) with mapi id 15.20.5061.028; Mon, 14 Mar 2022
 18:10:47 +0000
Message-ID: <141499fc-fb51-74be-32fd-a4e9008d7abf@oracle.com>
Date:   Mon, 14 Mar 2022 11:10:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net] af_unix: Support POLLPRI for OOB.
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org
References: <20220314052110.53634-1-kuniyu@amazon.co.jp>
 <bb446581-6eaf-3b61-1e5d-07d629c77831@gmail.com>
From:   Shoaib Rao <rao.shoaib@oracle.com>
In-Reply-To: <bb446581-6eaf-3b61-1e5d-07d629c77831@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0P220CA0016.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::23) To SJ0PR10MB4494.namprd10.prod.outlook.com
 (2603:10b6:a03:2d4::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 19236d5e-74a3-4ab8-4d21-08da05e5f6cb
X-MS-TrafficTypeDiagnostic: DS7PR10MB5215:EE_
X-Microsoft-Antispam-PRVS: <DS7PR10MB5215DD0739493FA68603F649EF0F9@DS7PR10MB5215.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: INRLNOK64B+6ybZDmEwh3W54QY4ss5pjMp1+5u+zRXb9Lo4XCYBmQqqls4Q24A6vRXkmynGDjmUiHX59Uf6d05jSrowrQPjiW5Gt3j8a/YsozXZ1ZCMHLI0sOtiiblcOmvDSt0IsWZQNrIdNyJ1EQyfkc+NTtjlmtXmgyzcrCZGV5EvyjxvEbq7TaRlNeYTdH+QczOeMxnJGywvveb90ZUxjP52ikCD5uO9UzG3upEERtS1hS5HYKGna0A5oFYCLhgT6DzQeQbSDO1Y9giXV/9fcF8iltCgQO3Vh25qjb/5NSJcxlvZ5UkchkAYxJinHJEz+pqB8e3K2mksSSKFbXpHD5kMaT4zR1c++MLaFj7oWutT1riBPFUqF10BrspEdZpWDR4jFRnWRdF7ummzvXsrDKXK3rsG53FlL+kr701r6Z75R5NtlBjMkJnzHKWFVHKdy0xRALoQFZyH7AIUBAHkfnvnuhJxRUBRjmILX6HEW7zMJYxFq0z5udOTvLZ2REX8WDcjF+UOOlRVIBy1WwvVa5QXLwrrVNImz0YBiTDY8xTxAz2qM9ZObE/jtPZpFZtt4ZXYgY3nBJR5xJ1Zal4VZ+3yNaZXKai0q9KzwAsePsyQzy78DcU0bJu7Rbrej346L3hmRDtRrsynspYWBr5rRbO5694JNIJp77qqKbVBdNjquQoNAMD36P5Pi6xQuYhK0SR8RbceGEBf927c7IHeLmLaHtfJdOWY13f9uuIc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4494.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(316002)(38100700002)(31696002)(6486002)(110136005)(5660300002)(2906002)(8936002)(4326008)(8676002)(66476007)(66946007)(66556008)(83380400001)(36756003)(2616005)(508600001)(6506007)(6512007)(53546011)(186003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K1JPYklVaUVScHpWQU9NY3ZjdEJsK0pGd3NJMHBGWURQVEhmcjFQV000RUx4?=
 =?utf-8?B?VmZIdkhHanhNWk54cEpRN0hTeWtaQ3Q1eGNaL0t6SkNUTEtqTCtzbjRGUWFD?=
 =?utf-8?B?ak44NnpEUFRyZXFKa0ZtTFVNNWFLa0lUYkJjVzBZNzBKaEJJS1k4bVc1aGlE?=
 =?utf-8?B?SWZjUDd0U3dXUEJtaC94T1JSckpYMVFDak9MT21oVjdKTUpyTDhCOEdta3dI?=
 =?utf-8?B?QmtXL29XZmlOT2JMUVI5VTkzOHdqOGhSMnd5UTBucmpYV1RsTlpyWFV0TVBM?=
 =?utf-8?B?LzFpSkIxQ0xPQzNkS1dIb2c3VW12ZmJYcEtkemZDblhQVk8rdk9rUXpSUG5P?=
 =?utf-8?B?L0RJTER1VnYyR3FvTlV1MUJmTHB0cVd0VHRrWGRQMkczWTZUVTNFVGJMWWVV?=
 =?utf-8?B?OEdkc2JtS002Yk5pSzF4NGViV2FGK0tuNUJxT3FFdzRsblh0WFQ3ZHZpUzdW?=
 =?utf-8?B?WjhPM1FOakVaSFM4YTRmVUp1VDB0SzZjUGsvYlhjWVVCU0F4akw0UkRaekJQ?=
 =?utf-8?B?M2hOV2FndE1XaVF2UVJxMnFlV1JzbURHUlJ1OGZheXdhaHJXdHRpNUkvZW1k?=
 =?utf-8?B?L2p1UXpNRCtqNkNLY3pmSnBDZGwxSS91ZGFCZVFLL0g2Tm1WZmRXYmg2eEV3?=
 =?utf-8?B?MEszZUFYZXZsNXlIZjkwZ1hYWWpvZFUzeTRYTGFXL0F1dHp6WXRONndpSGUr?=
 =?utf-8?B?L205d2xwdzlPNlVuRGtGZnFxR0phcDZWN0pHWk43bEZjNDh1WkxnMWlRY29a?=
 =?utf-8?B?ZnE5bXUyWnpkVFJmSTFpUXNBa0dxbFh0V1ZYNkZta0pvL0NEbWdWMjFBZVo2?=
 =?utf-8?B?SGRsUU5oajBySDZHbkl1WWhFREpUMXlIZlNiaGNDanc1OFdIZ0x5VkowWk81?=
 =?utf-8?B?N0U4N3pubTdtT3NoZnJScXNMcUVGR2FLTG41d2VvWTRJdVN4bU5XNlhSanl5?=
 =?utf-8?B?aEloQ1FMRXNKQjQvUW5yelBxcStkQm1Ga1FYYmE3b2p5dHJNOHNUemUzT09a?=
 =?utf-8?B?dTlSdmZKY1lPL1loN2UrQTRtU0lYZ2s1NDRqd0ZPb3FqLzc0R2ljeUgxNmtW?=
 =?utf-8?B?VXdCTGNJdTNrenJJNXRKdXdFNzZ4cWxXeFBEMVEwSU9KV1FJVFgvZktKUm5S?=
 =?utf-8?B?VE1aaFJBaXV2NWl2TFNWN0E1RE1meldGOFBLclZBaFZWVW1MZVlBbjJMYzNL?=
 =?utf-8?B?blpZWGFSWlR4VGdsUFpndFQwOVJpMUd0d2NvdXF1bDdPRWNSNnlsTm1xdFVR?=
 =?utf-8?B?dVIzR0l5Mmx0dDhub3YrNFZIZERaSFBYNTI3TEJINUxFQjJ3VXNyTnJ3dXlL?=
 =?utf-8?B?VTVUcHZ6SEQ2OTNuNHRHb2toaWd3UHdxSWp3OXlGN1RzUW1PNTdOdUVXT0Rj?=
 =?utf-8?B?S3J2SDNROUhZb3R6RHFhT2MxTTdqcFpHaXlQb1dmSGhRTUlTUVNkazJaL2ZJ?=
 =?utf-8?B?RFZhMmptY0QvQ1JDcXczc0d6Ym5GL3k1Z1VJQ2xNWkZPUW5ic1QvSm1hbGI5?=
 =?utf-8?B?MTdHS3hySk9FbUFXSDRUa2g2REp3dDRWYVNJTGtqMlV0azY0UHBBRXhQVVYv?=
 =?utf-8?B?WTd1ZE1mcXNnamNsSkpZdnZITFZqVit4azhFZ1VGa3VXVkJKbElKZXRXazhz?=
 =?utf-8?B?V0J4dmU4WjRrVGxhMzlDdWxpUnFjNnJQYy9KSnlKZVorVzlBbXR0bHMzOUxR?=
 =?utf-8?B?WFBtVjNRZkNVQVF1di9VL2dQQnhlZkcyMk9lYTB1RDJCL2IrOWVOY2E2dWIy?=
 =?utf-8?B?RUhJdDBaU1JEL0MzOW0vMHYxdXZqZWFRN1lEV0FVVjFLZVR3UFJBQzUwMmxL?=
 =?utf-8?B?T09MUUVQM1VTS0tLSEtLcGJJcCtmTFBoQjk0RWgrOVgzTzRZay9yM1RyMEZF?=
 =?utf-8?B?RFIvamozQUhFejdxOG1aUWJETThSQ3Z1K05xd3BSWFZ4S0ZJNWg5bU5JYTNh?=
 =?utf-8?B?WXFMcCtua1lWaFMwNGVDbzVodFZFdDBqci9QcTVhNkpsdHdoaDBqR2xzaUZ6?=
 =?utf-8?Q?ecHrp+N/ICZSvisv+T7CTyzwJm3t1A=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19236d5e-74a3-4ab8-4d21-08da05e5f6cb
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4494.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2022 18:10:47.3608
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q1oWF4aR1JmuL/Dsp+QfJ/hKiyeiEUvN8Yn3kBp7DanMqMrsZBZ7zEVsZUnQvu4ou5ad8BO8Xip6r5EAXkTOoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5215
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10286 signatures=693139
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 adultscore=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203140109
X-Proofpoint-GUID: isGnduVLmEvTzu88YnJWOdaHlx9gxb82
X-Proofpoint-ORIG-GUID: isGnduVLmEvTzu88YnJWOdaHlx9gxb82
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/14/22 10:42, Eric Dumazet wrote:
>
> On 3/13/22 22:21, Kuniyuki Iwashima wrote:
>> The commit 314001f0bf92 ("af_unix: Add OOB support") introduced OOB for
>> AF_UNIX, but it lacks some changes for POLLPRI.  Let's add the missing
>> piece.
>>
>> In the selftest, normal datagrams are sent followed by OOB data, so this
>> commit replaces `POLLIN | POLLPRI` with just `POLLPRI` in the first test
>> case.
>>
>> Fixes: 314001f0bf92 ("af_unix: Add OOB support")
>> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
>> ---
>>   net/unix/af_unix.c                                  | 2 ++
>>   tools/testing/selftests/net/af_unix/test_unix_oob.c | 6 +++---
>>   2 files changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
>> index c19569819866..711d21b1c3e1 100644
>> --- a/net/unix/af_unix.c
>> +++ b/net/unix/af_unix.c
>> @@ -3139,6 +3139,8 @@ static __poll_t unix_poll(struct file *file, 
>> struct socket *sock, poll_table *wa
>>           mask |= EPOLLIN | EPOLLRDNORM;
>>       if (sk_is_readable(sk))
>>           mask |= EPOLLIN | EPOLLRDNORM;
>> +    if (unix_sk(sk)->oob_skb)
>> +        mask |= EPOLLPRI;
>
>
> This adds another data-race, maybe add something to avoid another 
> syzbot report ?

It's not obvious to me how there would be a race as it is just a check.

Also this change should be under #if IS_ENABLED(CONFIG_AF_UNIX_OOB)

Thanks,

Shoaib

>
>
>>         /* Connection-based need to check for termination and startup */
>>       if ((sk->sk_type == SOCK_STREAM || sk->sk_type == 
>> SOCK_SEQPACKET) &&
>> diff --git a/tools/testing/selftests/net/af_unix/test_unix_oob.c 
>> b/tools/testing/selftests/net/af_unix/test_unix_oob.c
>> index 3dece8b29253..b57e91e1c3f2 100644
>> --- a/tools/testing/selftests/net/af_unix/test_unix_oob.c
>> +++ b/tools/testing/selftests/net/af_unix/test_unix_oob.c
>> @@ -218,10 +218,10 @@ main(int argc, char **argv)
>>         /* Test 1:
>>        * veriyf that SIGURG is
>> -     * delivered and 63 bytes are
>> -     * read and oob is '@'
>> +     * delivered, 63 bytes are
>> +     * read, oob is '@', and POLLPRI works.
>>        */
>> -    wait_for_data(pfd, POLLIN | POLLPRI);
>> +    wait_for_data(pfd, POLLPRI);
>>       read_oob(pfd, &oob);
>>       len = read_data(pfd, buf, 1024);
>>       if (!signal_recvd || len != 63 || oob != '@') {

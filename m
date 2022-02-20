Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B733E4BCCBF
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 06:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233452AbiBTFmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 00:42:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232925AbiBTFmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 00:42:45 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 257F46422;
        Sat, 19 Feb 2022 21:42:25 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21JNRjMo022629;
        Sun, 20 Feb 2022 05:39:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=5Fp8FC7aA9H0iLqSkNRhaldqpWanujAyShFF+lixfvI=;
 b=erAnW1d0HF9wdYmEDsA063CI20ptYacIzjlEgkFXEIznlvYBy4f+PZKPcsHJpDy+SBtj
 MOuoscTrDnNEidzNs2LYxI8iBAbR6R9o++l5sauaW7opIQvG4dBfi1oHmRr7TengDwy/
 6+YGuB2ahYOTmf+ZImhoW5TivzKy6d0Z1RaY3gXGUpy/3xfIhRVJ9yxRbfBnn4eM0jX5
 vcih5pS3geWXDQc3uVlMPhNBWpAuGptXIHkWrRygNjQVJFBnRtqgjnE8LrqMOV96McgL
 AkJEJEvxT+vzyZ07NlhDqlgqdO7qxHXGaUpO4yLwVRzLKKu4o8cvEbHAa+YnCcyyl8zB CA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ear5t1ety-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 20 Feb 2022 05:39:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21K5UKEM138279;
        Sun, 20 Feb 2022 05:39:56 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2046.outbound.protection.outlook.com [104.47.51.46])
        by aserp3020.oracle.com with ESMTP id 3eb47xak00-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 20 Feb 2022 05:39:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CRa0LNT8qkyK8/EMLEqYkjVX1yNo828WH1ObQkA9I4W/fc7UFytnF8EJzji0G47ASNYrAzJ0PD9cueHEb6o8mk88f5qaHczZeLoHmz8M9neGl6pHx/WCPCtSUkUOSFBFoNd6AgiU26GwWz6cB2Uz9hOHbBenXf9HtHWEFK5lcwd7GyyM/ubQTWvbtNJaMn6qaUuPY4ZFHuWqVe0oa//QO07rIVFBahIEkUKtFye9LCjk5K6aCD8M/iPxIRmBj32e00y6L1BX7p+ilBMLAWtVPYKpvJTANpMqUVf0v8ssIyMo6wUdjTNd5nPdLg+iOvT2FFZ5Lz4pncWXVAJwWZvMlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5Fp8FC7aA9H0iLqSkNRhaldqpWanujAyShFF+lixfvI=;
 b=Qat9zA2IJkwf2KPEDBYb8f3mL02Zixk4NX803NBFUDgYnkDtSGSBa6ok0zboCVYsr1ispvGRv41yzSUYi7tS8qJEWjnnIzmEpKQ03TwQtHXFNL5Tv5vp3kWpCslh4EzRViQNhbIF85KNSPU0kTz1ydpoTMrbcFIWnD48OimBQ+S/EiDQlzgjeHrA8Y1V8WEpfD1j4DpP48j1r7TTHUhAayqgr8Eb6UJ+75Ux0wGwuuDDg21HGghD71KX8xSJXwYztfoMKwAbasPj6fjRYv93fBqQCu2mBKjjINOUrbUD7E4+ESYvqalUdn+vdmA6dTMX0mELFnMvshG+cDId6iIekA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Fp8FC7aA9H0iLqSkNRhaldqpWanujAyShFF+lixfvI=;
 b=sYURPe4KQ0MCFKD20kTHh3CYtr1kuIO+IwW7xW5i+lbOnFauAerJCI3u/K7xlEWHUA9JmrQk4d2aoGJiTncKn9v/pJsDczUyRohcETHSDcwHyqxgHP70oFuFRuT/XYQkODWCL+ZmdU+XmKlB7xSG1AIABX/Vs6E2lhejJBvwAbQ=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by CH2PR10MB4136.namprd10.prod.outlook.com (2603:10b6:610:7f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.17; Sun, 20 Feb
 2022 05:39:54 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47%4]) with mapi id 15.20.4995.026; Sun, 20 Feb 2022
 05:39:54 +0000
Subject: Re: [PATCH v2 1/3] net: tap: track dropped skb via kfree_skb_reason()
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, edumazet@google.com
References: <20220219191246.4749-1-dongli.zhang@oracle.com>
 <20220219191246.4749-2-dongli.zhang@oracle.com>
 <a76d0c63-f747-d33c-d782-0b2f696e7de9@gmail.com>
From:   Dongli Zhang <dongli.zhang@oracle.com>
Message-ID: <172e9385-6c24-6473-7670-57bc33960979@oracle.com>
Date:   Sat, 19 Feb 2022 21:39:52 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <a76d0c63-f747-d33c-d782-0b2f696e7de9@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0123.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::8) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a6bb6d0-17f0-42e7-4986-08d9f4336baa
X-MS-TrafficTypeDiagnostic: CH2PR10MB4136:EE_
X-Microsoft-Antispam-PRVS: <CH2PR10MB4136CADD7E4A45CF196DE128F0399@CH2PR10MB4136.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EzpDLjYUvGTcm4r/KZjnMR6c3GHa05kE3ytGOoFTIbaIItqrdVSK9GL29Xvr5fKwh/gbkS8zU+puR/trTY1PKkaO20OEXpbYMo30mJB5QE8av3y9qa4Ngcyhhd4zcBVUddsRfXyCDjxYxVfFXUzWe3nl46AgJJ4Dj0HDbRQczwRJPJJboTYSMhDOFGpSAHtj+c9rEegMjqkCQC5BwBcEdzDaA6b867XOzywi09TLdznrUPRgDbFJ4XoWgKJDJNhH9Gjz+dhYC2U3i11RpY7S2dPa8WJaWx3faI+pMTZdA09G6rC66cgJMB3v3EdXQRbChafgXwfXs1bw8JGq9VAyTrd4aJtP7BixJvA2TI/gg1kpz1cSjO57mwrkI9c3MZjDYUNQQdztC46naTB+QwkMxjEpmc5xz2Y3mVF+NGJBPUlWFR7MF2TqWJe3gDpnj2jkoCfQzL3vjyq7ctuiqwMNVAvKekFvPKL17B+sGLXAQptAYPn9GJwFmN2MbqOKJiCWraWFJzckTksknQbfL+VWNVIDVhGYHoMy/49gjFwo/hP1mzXj6ARX/Ymm1vgCw95Y7HaB3knwl/SRorsvi5kj2TYyaQgzSmvRVyGvwSYd7vFZL9WB4bHBl39ucLSOceCyRUKxi3LaENlnMLiTFCWrbD2+QXUwU/9d3P02nWEqoh6VSDnp3BBuK4XQ3w8IKh/xfiWrmGnr6tYff8xPu9GgpDC1UptyYuZb0YtCwI+y+bk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(31696002)(38100700002)(86362001)(4326008)(8676002)(66946007)(66556008)(66476007)(316002)(8936002)(5660300002)(44832011)(7416002)(2906002)(186003)(83380400001)(2616005)(508600001)(6486002)(6512007)(6506007)(53546011)(31686004)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NVVTcTRHcU9RUThsbEg3Qm9vdm1pbWlkRFR2RUZFM3lXeVIrcFBJNFNQZjdo?=
 =?utf-8?B?NStoalpGTUhKQVdyME4wMnNWc0RmMUdXMXpWSUJOeXVCUmdlK0ZPSFF5NTFk?=
 =?utf-8?B?VWM2Tm1hMGlQNnFJSXF0MXV3MjBvczEzLzE5KzNQVjRxODZURTNTTVBOeU0y?=
 =?utf-8?B?Q0ZITDhEZkxxN3ZuTXFTOTZ4U3NZeTZDVG5BeXBQRjRSbjNzYTZjQkpxRzZL?=
 =?utf-8?B?YmxsQkREU0R1WmNoaFBOK3J2Y1ZNV3ltRDN1U0hRWFBWUDdmR1JuWitoVUMv?=
 =?utf-8?B?RHQ1UmJjSlBxSlhoVXRMMkY3Nmc4eEZFSDA1WTltbkFLRDFjczNkZlJMWDBL?=
 =?utf-8?B?U0JZWk5NRFVUcEhTckNCc3p3eDJVVFc4alpwOVRLVUpDTWNzZ203a1lFTVVW?=
 =?utf-8?B?bGJSeDhhZzNoQzIyNjQrNGxoZzZVY3MxYTFZeEZmOTFEUDg2RlpmSWlQQ1Nl?=
 =?utf-8?B?ZzM0eHY1RCt1bFhVTzNULzA2OUZvMnB3RDVuYi93YmRYa0s2MjdwWDJYVWl2?=
 =?utf-8?B?MTVlWlBraEpQMzlpRmtGbGdaTVhzKzI2MENLRUo4RXpybnFFMDkxVDNhQjJk?=
 =?utf-8?B?dTQ4dVNIUWlBRHZVQ2NIUk1INGs2dHBwRTJieEdBRWVsZzhKSGNzeXlpRzMy?=
 =?utf-8?B?QUxYOUdIb3NodDM5MENmY2pFU2NWWS82K2hwWjYxd3N2VUJpTjg3cEx0YS9s?=
 =?utf-8?B?K1QyYUJDYVVMbUt4SzY0OEJiam1TeEwzVVoycWdWNVR3ZEYreGZ2WGNUeFhL?=
 =?utf-8?B?eU80ajJ5a09qZVZydGlkRU82VFZhRUlzNnZkQW5JdGJ3dFFMODRRMG5nd3NP?=
 =?utf-8?B?K2ZyNTB2ZFZUdUpGRVlwMmNLajM4RUV0MHUrT3pTQXFPWm9aL0ZrRVNHNXBR?=
 =?utf-8?B?M2xTeWR4KzlocTRQenVib1ZTWFFRaEdGM2VKWDdmdWVnSE9udUgrME91NjJn?=
 =?utf-8?B?QU5oQldXMTVBbTNscHBqcDkrSUJmaWVUa3RzcU5Ndk9zOWp2OUFtWjNrZ3FH?=
 =?utf-8?B?Skc4YW5wK21XSUwwZWhlZ2hScUxCd002cXVXaVhOOSt1WXQyM2ZzU3VIbFRS?=
 =?utf-8?B?dENvN0g1aENZYUJmWjdvYitwQUNuK0JnS3VqQUx5QllrWVI5TlAvMVNPQm9G?=
 =?utf-8?B?S3hoODdFbWlIR0dudTUyc05rNjlCcVJhTTRtSzB4RXNqQ3RVdkRHc3N6THpk?=
 =?utf-8?B?T3ByY0RNaGJnMXY4M1R4Mm1LcWVjT1YvZ0puMVVzN1ErcnVCZ1VZNWZNSkdW?=
 =?utf-8?B?YVc1Q1hSNkswRFV3L05DUUhzNm5hVzV4YzJaajBlSERBZ2RNaU1acXduSFky?=
 =?utf-8?B?ZnA2cUFwVEgzZEZ6UGRKU0xweE9pZlo0eEVGTXB3bEl6d0xidVRkS3lvOUlL?=
 =?utf-8?B?cDNpSXRIZjZhbzRDZDFhVlZPRFZhd3p5Wm9pTjVUWHRFc3pmU1lwVXZYY0M3?=
 =?utf-8?B?ZXZWWXE1SW5VUVQvMlJaTnRGT29wRUhRUTZmMldUSndxcFN2R29OQXBMeEZ0?=
 =?utf-8?B?WFMyTElOMEJ2Q0dCdUVGRENLdGdzN1MyOStRbGFxei84ZEFEWUlyZnhnTHlt?=
 =?utf-8?B?N1E5TUk5M0ZlT3N0SXJocUtjVXdvSWtUVjZVTXNtaVg2dEVtZ04wbGdKYUli?=
 =?utf-8?B?akEvWHVVL0RkSzhTSlNGV1VkblN0dkFTN3hodTJEVDBXQjdXSWFKRExWd1B1?=
 =?utf-8?B?c3lQNkx6cVFQNndXMEhwRi8yOGNRTTFPeDROZEx6OE1USWdLVlE4bGZ4TW9n?=
 =?utf-8?B?U1VadnE4c2FmcHRpWG11YzROU0lpMjFpOUl0Mk9ycEgrV2taSTZYUTk4R2tn?=
 =?utf-8?B?a25EZEJkNUJqVEhVZWc1WGhKOFgvcmxyd3VvM3lWM3d0WktNaU9LY0xZYmRO?=
 =?utf-8?B?MFE1V3JrelNoZjQ3TUxmYzA2RSs5aTZRbFJmZ1hPdGlxeXlhUVU1STVlVUY2?=
 =?utf-8?B?dVVWTmdDSytCWkhXd2JQWmlUT3FyQVdJdUVlcGZUQVhNVFNRSUxNRk1sbVpD?=
 =?utf-8?B?T2FHSGxicFhvTytHMkk4WUNOc0JWYmZwTWZLWW9kdkNyNkVxdmE5bHI5YjAx?=
 =?utf-8?B?MWRYcnlHSm03cVAvc2dycERLVy82VTBZSGNUWDNBOXhQbktheDZMR01WalV2?=
 =?utf-8?B?QkNtRnRFVzNrZG5rN01GOUcrMnIwZnZtV3oyZStETWJVclBFczRiUDlFZGFa?=
 =?utf-8?Q?dOVoH7p2RizgKujWH8Q9+4YzudbHIDvJAACPe9AJj4v2?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a6bb6d0-17f0-42e7-4986-08d9f4336baa
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2022 05:39:53.9904
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QT3NPCYWjQKcssjjObDiYGUSeNr5B9PBKir2Fs/IHyAYbzr0w2YVewm8uEOIS0aVK5kLJjBxaWYo+ozF0NTuzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4136
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10263 signatures=677614
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202200036
X-Proofpoint-GUID: Qdy7NbVqYeJkvyM4rbGgTChXZ_JzHe4v
X-Proofpoint-ORIG-GUID: Qdy7NbVqYeJkvyM4rbGgTChXZ_JzHe4v
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On 2/19/22 2:46 PM, David Ahern wrote:
> On 2/19/22 12:12 PM, Dongli Zhang wrote:
>> The TAP can be used as vhost-net backend. E.g., the tap_handle_frame() is
>> the interface to forward the skb from TAP to vhost-net/virtio-net.
>>
>> However, there are many "goto drop" in the TAP driver. Therefore, the
>> kfree_skb_reason() is involved at each "goto drop" to help userspace
>> ftrace/ebpf to track the reason for the loss of packets.
>>
>> The below reasons are introduced:
>>
>> - SKB_DROP_REASON_SKB_CSUM
>> - SKB_DROP_REASON_SKB_COPY_DATA
>> - SKB_DROP_REASON_SKB_GSO_SEG
>> - SKB_DROP_REASON_DEV_HDR
>> - SKB_DROP_REASON_FULL_RING
>>
>> Cc: Joao Martins <joao.m.martins@oracle.com>
>> Cc: Joe Jin <joe.jin@oracle.com>
>> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
>> ---
>>  drivers/net/tap.c          | 30 ++++++++++++++++++++++--------
>>  include/linux/skbuff.h     |  9 +++++++++
>>  include/trace/events/skb.h |  5 +++++
>>  3 files changed, 36 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/net/tap.c b/drivers/net/tap.c
>> index 8e3a28ba6b28..ab3592506ef8 100644
>> --- a/drivers/net/tap.c
>> +++ b/drivers/net/tap.c
>> @@ -322,6 +322,7 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
>>  	struct tap_dev *tap;
>>  	struct tap_queue *q;
>>  	netdev_features_t features = TAP_FEATURES;
>> +	int drop_reason;
> 
> enum skb_drop_reason drop_reason;

According to cscope, so far all 'drop_reason' are declared in type 'int' (e.g.,
ip_rcv_finish_core()).

I will change above to enum.

> 
>>  
>>  	tap = tap_dev_get_rcu(dev);
>>  	if (!tap)
>> @@ -343,12 +344,16 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
>>  		struct sk_buff *segs = __skb_gso_segment(skb, features, false);
>>  		struct sk_buff *next;
>>  
>> -		if (IS_ERR(segs))
>> +		if (IS_ERR(segs)) {
>> +			drop_reason = SKB_DROP_REASON_SKB_GSO_SEG;
>>  			goto drop;
>> +		}
>>  
>>  		if (!segs) {
>> -			if (ptr_ring_produce(&q->ring, skb))
>> +			if (ptr_ring_produce(&q->ring, skb)) {
>> +				drop_reason = SKB_DROP_REASON_FULL_RING;
>>  				goto drop;
>> +			}
>>  			goto wake_up;
>>  		}
> 
> you missed the walk of segs and calling ptr_ring_produce.

This call site of kfree_skb() and kfree_skb_list() is unique and there is not
any "goto drop" involved. From developers' view, we will be able to tell if the
'drop' is at here according to the instruction pointers in callstack.

 360                 consume_skb(skb);
 361                 skb_list_walk_safe(segs, skb, next) {
 362                         skb_mark_not_on_list(skb);
 363                         if (ptr_ring_produce(&q->ring, skb)) {
 364                                 kfree_skb(skb);
 365                                 kfree_skb_list(next);
 366                                 break;
 367                         }
 368                 }

I will add the reason to "walk of segs" case as well. About kfree_skb_list(), I
will introduce a kfree_skb_list_reason().

Thank you very much!

Dongli Zhang

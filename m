Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E40143F428A
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 02:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234377AbhHWAXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 20:23:14 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:61500 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233168AbhHWAXN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 20:23:13 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17N0AesS032077;
        Sun, 22 Aug 2021 17:21:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Xt5n1t3Ome3CipmLk8Kmav26I2lFmq/hQ1Yt/oACIEQ=;
 b=qFcQuE5wupUQqRF7FtudQgHSat8pmMDxSNt33G5+8hyYLriZip93uFBgZEfgevxjXH3J
 hH2HxxLnq8o9uFYrIoF7BpbFrX/WLG4bZp3tMGvdBZ+H3jZpXfsvKZ8PDCrJF9CKCkq3
 UlGBTPxYzm3emp8xLsNLUeQLZab+Mis/Erc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3ajyave5n4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 22 Aug 2021 17:21:56 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sun, 22 Aug 2021 17:21:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iQJu+FEIl73sfrquD60COzqfFf7hlSDaviELI0AkJY525GucoNDYUbaP9qst9gLDW6H5YR0X7eGksODJV+urfrYpyhoSjzYNzwf+8ZcHX7Vju4N29civAO+5VmuV1aH4JG6/ul+cpws7YpJBm8Grg5SIZAFihnLSs42xqpvcNfaeeSBlh+xthPG6D155ot1Q8LOu82cqHtOc5VQlVAJAUBm4crTGw25IrP80F1ecP3SJ6vYf7EOwLISifBzFP2M0k7y7wQErnK8TZzOkBWvVUlPwezUs/AGChFQEff39LWVUcsvvOy6dqvLFtR+T1zjbkFFwqJdrUUXuqJCy+9rqcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xt5n1t3Ome3CipmLk8Kmav26I2lFmq/hQ1Yt/oACIEQ=;
 b=btbWViT6u5/QdcRXvHmAi0pCVKlBhCaykzn9PLHgMjVz1sVdvJPgIt8sVih7RZEVZ1ZfIug7jsu0cY4ffLeJiQAAcRw7gdE4Vl94wMwZt2jWh/hQT7wrjqfj5IEgxHVcUb2V6+tRkTTefaGsPJQiv73W5VL/bZg+QdXfxxnLzQYC3xdDnIP0u2aJWHPLelAxQcCda/3zlFS6BujiOPlfYtl1xQZ3i0rJrtJWOvXw4nPYjuksq6Ex3SEbHk36J9GqGLE4ycEAQJtGVWaz7LX8vUPcfkQwrxbqwoHx+9l7mUS/LLevV+q/lDkCEBaVuZPjl5hEHcRXGMl63D0NdN4B/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4917.namprd15.prod.outlook.com (2603:10b6:806:1d0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Mon, 23 Aug
 2021 00:21:54 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb%7]) with mapi id 15.20.4436.024; Mon, 23 Aug 2021
 00:21:54 +0000
Subject: Re: [PATCH] net/mlx4: tcp_drop replace of tcp_drop_new
To:     jony-one <yan2228598786@gmail.com>, <kuba@kernel.org>
CC:     <edumazet@google.com>, <rostedt@goodmis.org>, <mingo@redhat.com>,
        <davem@davemloft.net>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <hengqi.chen@gmail.com>
References: <20210821155327.251284-1-yan2228598786@gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <6fb1850f-227e-a600-c23e-f7db9e68a470@fb.com>
Date:   Sun, 22 Aug 2021 17:21:51 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
In-Reply-To: <20210821155327.251284-1-yan2228598786@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
X-ClientProxiedBy: BYAPR08CA0068.namprd08.prod.outlook.com
 (2603:10b6:a03:117::45) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::1137] (2620:10d:c090:400::5:b9c4) by BYAPR08CA0068.namprd08.prod.outlook.com (2603:10b6:a03:117::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Mon, 23 Aug 2021 00:21:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b815b13e-c1fe-4707-1fd6-08d965cc026a
X-MS-TrafficTypeDiagnostic: SA1PR15MB4917:
X-Microsoft-Antispam-PRVS: <SA1PR15MB4917A9BF70B0424FB3101B2FD3C49@SA1PR15MB4917.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ax4RuAbNqQmv5uG7BqxGCMLxkILATXgEEWNK+OnUX9SjVEnkYIZLIvFecayvdT3Q654TEQX4xbLoZgcdl7sR1jaD9AinhN5LVhSkKoUwis1PHjXWT/547Y8aHWvSTF3Y0e2oXkSKjy4tgLcQg0ISOYYuUZFFV8dMt6/sD60h37C9tdT5QjDbLa7YEsGO+sP1pwtzc7ndAeF8EAs/6txbrU0rU9pjbBEkc0nHO69qRUpJBXAi8Az4+UzmIUXuZ8iQRTYM8qbAiXjwYFHhFrQeJ5qCZHl3zjm5tIG8iM4HUZjouMQezr3YSP41c2E2CzLGXwKgfl7ojMnXvFagTRT3TV0dRCGKAH3g10RVhtByNiQv2F8SK7322DT+xWGmQbprX1MX8wffpLw6t7YSYChLenUcbsgq0hIJY9CeS6Mx36pQr8hRPXGqin1WT9DF59hWizbNrSNmfrKo9nMnoAXF0KRvuCgYBuzoLBVwBv5j8FDEnuOxHwGN/O06vUkgf0z2MkaWCiaSmIqC1tu3NiRWkmnQfq0I/eZqJQOvwJeB+k7DqyHdD2lNaiT/icsKHYxv5AHtfngsRZQQIy2+UQhSdNhoUOulNu1VFfNdjuqNSOlFeouRY4HcTn/K28k4ID+aNiS4uaJhJaTW6PjLR7qwtSz/1vRs1iMPD+IZ321kOt3XHWC1ImDygQ265Uii//UDKL10HDHvf+sf3OcPKLtnCgHoeAZc0CKVWsuV0G1SjA0CyhjCjVjy8tCYecGlPqeJZ6Y9EmsE8r11Pomh+Cvj9SjuuRpY6pgFNiIDes8UbbdhYAXPOqCFFvgzjClvNpJA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(366004)(39860400002)(36756003)(478600001)(316002)(8676002)(966005)(8936002)(4326008)(31696002)(186003)(38100700002)(2616005)(31686004)(5660300002)(66946007)(53546011)(2906002)(83380400001)(86362001)(6486002)(66476007)(66556008)(52116002)(7416002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RkFHOUVHUUpLaHo4N2ZIQ2hVMnp2dmdYeW1OUXZyRTBvV0pWZ3h4NGZKQVgy?=
 =?utf-8?B?S25STlhNUVlmRDlLcWZmRG5BakZWMmxUT05wclNyVkxxVTZ3QXk4ZU1CTEdV?=
 =?utf-8?B?QzE1NC9tWWJuVVpaMmF4NW1Ibnd0djRoUU9YbGxzOVpMRGhyNi8zcHVMaXZN?=
 =?utf-8?B?UHRxS0oxYjlieEhSK3dicm1weG5MQ05pTmV0UGpHSmVOM0ZPTWxZQ09vUEFK?=
 =?utf-8?B?VnZXYzNQYWxsdGh4emVLdHN1R0FMenlIRHVHQ2N0UE1scytXaW5xR0dXdjBR?=
 =?utf-8?B?VUZveWNFUklFUjdSN2RuV29RMERJRnRMVU9sZmtwUFA1a2R1TFQ3RnZ1dWlG?=
 =?utf-8?B?azk1Unc0YmNab1VITDVaTWw4NHh4U2I5NjRnejdNZFF2RTJob0RCdjV6WWVS?=
 =?utf-8?B?NFZkVEFycjBqUUFJL3oxR2RCUmNQWnBhUUZ3MzMzeThiM1FCQWRuNFNsc04v?=
 =?utf-8?B?UjJrYWVPU1VXejduc0hCMGFIUDZTODFIbFo1d2lLdmZ2VGFlZlBYbWQyL3pT?=
 =?utf-8?B?MFNIQlpIZWdTVTdraTQyZ3RsRWZFTjUrWTlPN2plT0tXTVlzV0xrU2ZpNndt?=
 =?utf-8?B?T1hyaUl2WE54eUFnbG9WeXNXcGF2UUV1aGwxb3NNV3RMd2RHbTFvZXl0Rnd3?=
 =?utf-8?B?NmFhSzZDVkQrbE5UZklNNkNiQVFCM1hlWDNkb0trQmZLd0g2ZitZZXllcnUr?=
 =?utf-8?B?enlaaGVucGNzRzQyZHIvSS9VUDZhZSs4KzBmUFBYcXRtQjl3UEMwL0psbGdi?=
 =?utf-8?B?d0dBR1RKZmhlWVR3VWR0T1k0NURLYURkNUVRN3dCVGdkby9jQWdpRE9CdUk1?=
 =?utf-8?B?Z3FjUjRXUXE3YndjNnA0ZkpacVhFZWxtQUxnNE83SlNkUHAvV2xLbmNHWEFD?=
 =?utf-8?B?TDZCVEJtSXBIZk01WWpCU2kzbWorQUIrZHowT1kxRndmWk4xdHV3ejRyL2lN?=
 =?utf-8?B?VWNyNndzMlN2REtUMWRtaTZWV0J4OU9kNFJqUzdtd2Q2NkwzdGk5Qk9ZRUw1?=
 =?utf-8?B?WmVuWFByL3VMMDFlZUwwM2pYQ1YxQU9ZVGIvVW0yVlRpdzFGSFZUVW1MQTF4?=
 =?utf-8?B?YUdlU1g1N1lZSjJ4cjB6OGFWR0FGV0ZLVTZmUWhUTXBxUmduRlptOEt3dU1R?=
 =?utf-8?B?dkdMazIwTnJkdnN2ZFhLcVZhRUppQ01tZE9HcGRFdDB3eU9ZNU50K3pERW04?=
 =?utf-8?B?U1MwZkpnWWNMR0x2ZXNyWmJlZU5DSno4MlZCKy94M1d5OVUybXhLbndCUk1J?=
 =?utf-8?B?MjBIQWg3ZlVsK3Z5eG10UlNOb2VhK1ZLZmJFK1psNFdjS1NIYmRYOGNMTVVY?=
 =?utf-8?B?S2dhZ2ptdHRWUWI5UUhZbWR1bHZob3hRVFAvcFJlWjYydC9PSmI5VTNWWVZp?=
 =?utf-8?B?VHhUY3oySzJGUUp4TFdjQmQ5VWNNMndpbWVOSG1oSmYwYVFmN3dIVFROazhN?=
 =?utf-8?B?QlNWakR4elY0UndqNXFaeWhrd2wyWFA1RFhPL1h6VWlSd2lYcVhmQWhodmx0?=
 =?utf-8?B?L0xsdXFyY0NnUkhSQ05QUWI0RVo0SHB2MGZWWEhxVkMwSGVDUG40VEtFallW?=
 =?utf-8?B?YVBhdWJpS3RLcXZOTWpzSStHWktKS2lGQnZCb3ZKYVI2TE9oTlVEcXNLR3c0?=
 =?utf-8?B?L3ZmSlY1SEFvQmNwYnNjVi9Kckd3d3FqR1B5b1B6RWJCdnR2RnZGUSt2bzd6?=
 =?utf-8?B?RU92MFdjSjdYa2V4bms0TG1obERpZ0dnaThMMjZPMGc4eHFuYzdnMmdKdFFw?=
 =?utf-8?B?MC83dlVCbW1peXl6U2ZjTHFPdCtnNS84TlZyeXN5VzhKNEJ3NnNUenFqL3B3?=
 =?utf-8?B?OUVsenRaVHNzUzBESU5zZz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b815b13e-c1fe-4707-1fd6-08d965cc026a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2021 00:21:53.9378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iyPKYJZGWa8Z8XSC4mnwcA2E9KGtpwGeeg8akS7MJziy553oa56HA2ckzJSRQcZF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4917
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 728VKI4rQEFJWL48Hmi8OKeWfOUzs8-P
X-Proofpoint-ORIG-GUID: 728VKI4rQEFJWL48Hmi8OKeWfOUzs8-P
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-22_06:2021-08-20,2021-08-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 priorityscore=1501 clxscore=1011 phishscore=0 impostorscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108220164
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/21/21 8:53 AM, jony-one wrote:
> We never know why we are deleting a tcp packet when we delete it,
> and the tcp_drop_new() function can effectively solve this problem.
> The tcp_drop_new() will learn from the specified status code why the
> packet was deleted, and the caller from whom the packet was deleted.
> The kernel should be a little more open to data that is about to be
> destroyed and useless, and users should be able to keep track of it.

For the subject, prefix "net/mlx4" is not accurate. This patch has
nothing to do with mlx4. Just use "net". The subject is not accurate
too, maybe "introduce tracepoint tcp_drop". Tracepoint name "tcp_drop"
seems more accurate compared to "tcp_drop_new".

It is worthwhile to mention the context/why we want to this
tracepoint with bcc issue https://github.com/iovisor/bcc/issues/3533.
Mainly two reasons: (1). tcp_drop is a tiny function which
may easily get inlined, a tracepoint is more stable, and (2).
tcp_drop does not provide enough information on why it is dropped.

> 
> Signed-off-by: jony-one <yan2228598786@gmail.com>

Please use your proper name. "jony-one" is not a good one.

> ---
>   include/trace/events/tcp.h | 51 ++++++++++++++++++++++++++++++++++++++
>   net/ipv4/tcp_input.c       | 29 ++++++++++++++--------
>   2 files changed, 69 insertions(+), 11 deletions(-)
> 
> diff --git a/include/trace/events/tcp.h b/include/trace/events/tcp.h
> index 521059d8d..5a0478440 100644
> --- a/include/trace/events/tcp.h
> +++ b/include/trace/events/tcp.h
> @@ -371,6 +371,57 @@ DEFINE_EVENT(tcp_event_skb, tcp_bad_csum,
>   	TP_ARGS(skb)
>   );
>   
> +/*
> + * tcp event whit argument sk, skb, reason
> + */
> +TRACE_EVENT(tcp_drop_new,

tcp_drop instead of tcp_deop_new?

> +
> +		TP_PROTO(struct sock *sk, struct sk_buff *skb, const char *reason),
> +
> +		TP_ARGS(sk, skb, reason),
> +
> +		TP_STRUCT__entry(
> +			__field(const void *, skbaddr)
> +			__field(const void *, skaddr)
> +			__string(reason, reason)

I understand we may want to print out the reason with more
elaborate reason, but for kernel internal implementation
an enum should be enough. See tracepoint sched/sched_switch.

> +			__field(int, state)
> +			__field(__u16, sport)
> +			__field(__u16, dport)
> +			__array(__u8, saddr, 4)
> +			__array(__u8, daddr, 4)
> +			__array(__u8, saddr_v6, 16)
> +			__array(__u8, daddr_v6, 16)
> +		),
> +
> +		TP_fast_assign(
> +			struct inet_sock *inet = inet_sk(sk);
> +			__be32 *p32;
> +
> +			__assign_str(reason, reason);
> +
> +			__entry->skbaddr = skb;
> +			__entry->skaddr = sk;
> +			__entry->state = sk->sk_state;
> +
> +			__entry->sport = ntohs(inet->inet_sport);
> +			__entry->dport = ntohs(inet->inet_dport);
> +
> +			p32 = (__be32 *) __entry->saddr;
> +			*p32 = inet->inet_saddr;
> +
> +			p32 = (__be32 *) __entry->daddr;
> +			*p32 =  inet->inet_daddr;
> +
> +			TP_STORE_ADDRS(__entry, inet->inet_saddr, inet->inet_daddr,
> +				sk->sk_v6_rcv_saddr, sk->sk_v6_daddr);
> +		),
> +
> +		TP_printk("sport=%hu dport=%hu saddr=%pI4 daddr=%pI4 saddrv6=%pI6c daddrv6=%pI6c state=%s reason=%s",
> +				__entry->sport, __entry->dport, __entry->saddr, __entry->daddr,
> +				__entry->saddr_v6, __entry->daddr_v6,
> +				show_tcp_state_name(__entry->state), __get_str(reason))
> +);
> +
>   #endif /* _TRACE_TCP_H */
>   
>   /* This part must be outside protection */
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 149ceb5c9..988989e25 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -4649,6 +4649,13 @@ static void tcp_drop(struct sock *sk, struct sk_buff *skb)
>   	__kfree_skb(skb);
>   }
>   
> +static void tcp_drop_new(struct sock *sk, struct sk_buff *skb, const char *reason)

You can rename funciton name to __tcp_drop(). tcp_drop_new() is not a 
good name.

> +{
> +	trace_tcp_drop_new(sk, skb, reason);
> +	sk_drops_add(sk, skb);
> +	__kfree_skb(skb);
> +}
> +
>   /* This one checks to see if we can put data from the
>    * out_of_order queue into the receive_queue.
>    */
> @@ -4676,7 +4683,7 @@ static void tcp_ofo_queue(struct sock *sk)
>   		rb_erase(&skb->rbnode, &tp->out_of_order_queue);
>   
>   		if (unlikely(!after(TCP_SKB_CB(skb)->end_seq, tp->rcv_nxt))) {
> -			tcp_drop(sk, skb);
> +			tcp_drop_new(sk, skb, __func__);

use enumeration?

>   			continue;
>   		}
>   
> @@ -4732,7 +4739,7 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
>   	if (unlikely(tcp_try_rmem_schedule(sk, skb, skb->truesize))) {
>   		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPOFODROP);
>   		sk->sk_data_ready(sk);
> -		tcp_drop(sk, skb);
> +		tcp_drop_new(sk, skb, __func__);
>   		return;
>   	}
>   
> @@ -4795,7 +4802,7 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
>   				/* All the bits are present. Drop. */
>   				NET_INC_STATS(sock_net(sk),
>   					      LINUX_MIB_TCPOFOMERGE);
> -				tcp_drop(sk, skb);
> +				tcp_drop_new(sk, skb, __func__);
>   				skb = NULL;
>   				tcp_dsack_set(sk, seq, end_seq);
>   				goto add_sack;
> @@ -4814,7 +4821,7 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
>   						 TCP_SKB_CB(skb1)->end_seq);
>   				NET_INC_STATS(sock_net(sk),
>   					      LINUX_MIB_TCPOFOMERGE);
> -				tcp_drop(sk, skb1);
> +				tcp_drop_new(sk, skb1, __func__);

This one and the above one are in the same function so they will have
the same reason. It would be good if we can differentiate them.

>   				goto merge_right;
>   			}
>   		} else if (tcp_ooo_try_coalesce(sk, skb1,
> @@ -4842,7 +4849,7 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
>   		tcp_dsack_extend(sk, TCP_SKB_CB(skb1)->seq,
>   				 TCP_SKB_CB(skb1)->end_seq);
>   		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPOFOMERGE);
> -		tcp_drop(sk, skb1);
> +		tcp_drop_new(sk, skb1, __func__);
>   	}
>   	/* If there is no skb after us, we are the last_skb ! */
>   	if (!skb1)
> @@ -5019,7 +5026,7 @@ static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
>   		tcp_enter_quickack_mode(sk, TCP_MAX_QUICKACKS);
>   		inet_csk_schedule_ack(sk);
>   drop:
> -		tcp_drop(sk, skb);
> +		tcp_drop_new(sk, skb, __func__);
>   		return;
>   	}
>   
> @@ -5276,7 +5283,7 @@ static bool tcp_prune_ofo_queue(struct sock *sk)
>   		prev = rb_prev(node);
>   		rb_erase(node, &tp->out_of_order_queue);
>   		goal -= rb_to_skb(node)->truesize;
> -		tcp_drop(sk, rb_to_skb(node));
> +		tcp_drop_new(sk, rb_to_skb(node), __func__);
>   		if (!prev || goal <= 0) {
>   			sk_mem_reclaim(sk);
>   			if (atomic_read(&sk->sk_rmem_alloc) <= sk->sk_rcvbuf &&
> @@ -5701,7 +5708,7 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
>   	return true;
>   
>   discard:
> -	tcp_drop(sk, skb);
> +	tcp_drop_new(sk, skb, __func__);
>   	return false;
>   }
>   
> @@ -5905,7 +5912,7 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
>   	TCP_INC_STATS(sock_net(sk), TCP_MIB_INERRS);
>   
>   discard:
> -	tcp_drop(sk, skb);
> +	tcp_drop_new(sk, skb, __func__);
>   }
>   EXPORT_SYMBOL(tcp_rcv_established);
>   
> @@ -6196,7 +6203,7 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
>   						  TCP_DELACK_MAX, TCP_RTO_MAX);
>   
>   discard:
> -			tcp_drop(sk, skb);
> +			tcp_drop_new(sk, skb, __func__);
>   			return 0;
>   		} else {
>   			tcp_send_ack(sk);
> @@ -6568,7 +6575,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
>   
>   	if (!queued) {
>   discard:
> -		tcp_drop(sk, skb);
> +		tcp_drop_new(sk, skb, __func__);
>   	}
>   	return 0;
>   }
> 

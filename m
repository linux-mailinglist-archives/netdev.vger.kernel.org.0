Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E64943B7836
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 21:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235408AbhF2THP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 15:07:15 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:19212 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235344AbhF2THN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 15:07:13 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15TJ2Y2R008574;
        Tue, 29 Jun 2021 12:04:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=P7GhYbx7xCm1rnmOgeDmD8Uo+HWZPpbQ5qQbzkVi/gc=;
 b=dBzxj0kYiwN3KwNndAmpneSzl845kQmRy13aBRPxegb0/cSp5kmQUd9H8f0xjG1/SsNa
 HdInnmxjOVaUqknxGfwGsCRoYHhxPID88OfJ7h67HeVSPAS083iriRqBqFIH25RWa9Z9
 7VaHz/3oQ8CPgeM1x/Dd/gTE0yQg4H95HjE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 39fyvfuwx3-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 29 Jun 2021 12:04:31 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 29 Jun 2021 12:04:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YrRo7R4l8bmOt5fqfgJYx/beXRoXTtELzmSKgVwVgEQIt+QjoMFO6xA55/dtfb6SwzeBzLvGtstZpwWg6uHh6wqrR8lB48I35zrr1b3dMKoBB9ozhp2yNX65CnxuUMs1/o+Ej1pqnIJj10qAP3cXS7dl4UunhWzdFylHgm4MCYdFkhw6uczUbPcqHhcauaqEBaUMaLur3O3iICGJhqo6VSy9gehlioBOLNqIS8gbRygujlzJT8s6aTyYVJZ9d+X8olDUzV/Uek53z+uz7owWIS4nWl06oB6tHQi3EgTi8T4VEmgoYop0tZ2lYMqc6NLF3aXJg7I0lPeFRqejVyMvgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P7GhYbx7xCm1rnmOgeDmD8Uo+HWZPpbQ5qQbzkVi/gc=;
 b=nfS+jSGRjAOaTIe/cK0yzRb4+/k4bybr4Fv3ulRSG3pb24xIi6ZaWC8/lCY+Q+bEnqcxZBCnV+rJZNTkudLlHBc0ELXIn27Bu+IgQV687AfsowEvrBZI6A3yxGwnS3m08TP/kQodm+UJ+Rj65pJGQsMBHGftZQYsZMPiQWHCDAOjXRDV10JO1jBO/eG5ImZRgh2iUP8lozwdkuf6bI5ND1kbVP+MCtBKEfWlxNGqbntLj8upAQ/8W7SMZKri21iqxD+0hx27dDf0cFbI5dJ28BVrJgGlAQMAu5/1dHUCTBOpJ44rvhNaA89boojIkeMQSE54AXHkd5CAUl+IyAKGxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4919.namprd15.prod.outlook.com (2603:10b6:806:1d2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Tue, 29 Jun
 2021 19:04:24 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906%5]) with mapi id 15.20.4264.026; Tue, 29 Jun 2021
 19:04:24 +0000
Subject: Re: [PATCH bpf-next 0/8] bpf: Allow bpf tcp iter to do bpf_setsockopt
To:     Martin KaFai Lau <kafai@fb.com>, <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>, <kernel-team@fb.com>,
        Neal Cardwell <ncardwell@google.com>, <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
References: <20210625200446.723230-1-kafai@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <255586ce-81c3-bcf2-663c-f89fa18c0ac0@fb.com>
Date:   Tue, 29 Jun 2021 12:04:21 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <20210625200446.723230-1-kafai@fb.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:6625]
X-ClientProxiedBy: BYAPR08CA0012.namprd08.prod.outlook.com
 (2603:10b6:a03:100::25) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21d6::1a57] (2620:10d:c090:400::5:6625) by BYAPR08CA0012.namprd08.prod.outlook.com (2603:10b6:a03:100::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend Transport; Tue, 29 Jun 2021 19:04:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc95d3f5-f276-4c40-841c-08d93b30b594
X-MS-TrafficTypeDiagnostic: SA1PR15MB4919:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB49194D1AE806B6CCF4C041BBD3029@SA1PR15MB4919.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 06Iq7OQ4Ia15Joj+s0btXYArLiqZEwUds2ciZnT1WtefF4C9k/1sUOz1h1mD1/2KjVENOcsdGlEl6bXk4PJRymWXytkB95Y9X481D/JV/XofXh1SmtNyMNonIgUTd8zWknqUSFT/KsZXfZpxvX4vMLg1pp7YLw7I8etbWEsbY6cfVJRWC5fJ+uJIqoOuvHFGIiLbxP/L+DA2tvzoOjHY8oroUKhHZw01+SGJPkPiXvhVnCwmP/gaNVKOnCTjA1ol7cPkBsu0wRDdozKmxrcJKlqG3qTp/OZ/6Ck7XYqb9gyMgRwpcMv4S+nbV0P2XnMhwnT8lVM7awSikPLBUtnGCu6QPc9d/hebDmjxuZlRhViQqMWCQEaz3dvVYo3NIHHovITP4dZ6XKjfLU1M8dT/E2g+L+Gzw1XX5vzYXpsb+7AcVeeRO8Asa5nQUK58JfBHmM/zOGJokUfZHLMcxVegEpldIuofJlbA/EpCyW6ZPKO2GZwf94oM4sgiSnCRgpky+VboL5L2V13uk2rwFDdviyhzzu2t4uISRz/gTuCyBEB23Uod8FqWvFtID6f5HUr+y5mqDRSZ3mmIyhBvOe8nNE4BmgVNFJdIuRKuTd/87ySrcazj+Zij2lk09WP1KY77muVvUKkHjAi9MzBIoI1sfWciNAzkzql5TxKo20QC1IJGrc6jFd6MaXT7nhpBZPZYXnDsYUB+CordD+xfthePirGlBEzRqDo9zQCntsOw72ly//C1ZQigoo2kH7iQavHt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(396003)(136003)(366004)(54906003)(16526019)(31696002)(478600001)(4326008)(52116002)(186003)(36756003)(86362001)(53546011)(83380400001)(316002)(5660300002)(8936002)(8676002)(66556008)(66476007)(66946007)(2906002)(6486002)(31686004)(2616005)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UlBqY0swdDYvdWJoQmdlME9JMzJkL0lKc2pOdUl3UkxGYXc1M3VMSlZad3No?=
 =?utf-8?B?WmFDdldaQnMxV3d5NzRXUjk0OGYwV3U5cmh5SUZKWGdsWHNmWm1jazhiSXVm?=
 =?utf-8?B?aWhYNFBRcEp5cGhkRi83SjhmV3o4VU9jdUNiZGRTVHZXVXRLeXJkUUo5Zi9M?=
 =?utf-8?B?S0ZCK0k1ZVhlYVRmT1p5RUV4RTJlclR0b2o3b1hhNHZBQlE0dWp5cnAraE12?=
 =?utf-8?B?aWJBa1I1TFlwL1ZtckxYYlBPaWwwUVFzbVc5T09PeTRKWVp4RTlhSVI3bWVo?=
 =?utf-8?B?NEVYR0F6QlZ6SHlRNXhNY1FCbkpWK1pkWHBNNjNKVXlBU1phMVR4Yi9NWnJQ?=
 =?utf-8?B?bXJyTkdKSmRmNFZveHRCbFhtL0VGc1h4MnNjSVFaT3YxOHg2REYvd29HZ3hh?=
 =?utf-8?B?NmRnV1lOVDc4blJMQ0p0cklnR3gwaFVGMzFUMHpDUnhGR2xnWElQMlB4NHh3?=
 =?utf-8?B?aW40cHE2a1JmRHhtZnQvSW1zbW5pWGVNclFMN0U4eU4zRkdwbElSVzZyRGh1?=
 =?utf-8?B?c3NkNDgvMWZLRG96dlNXa0VLS2pxbDAvYnpIMTJtSEIvMyt3VWFOOXJMSlg1?=
 =?utf-8?B?WDVsaE1hTlZKajgxOFVrdi8xb1dqUGt0NVlWQmZvNDNYME1leHp3ekNjNGlz?=
 =?utf-8?B?OVdrU0FscEdMRjRDeEc1a1FRNjRYVGFyMFBpSXBQOTRrdEpCd1VzN1hQRkEx?=
 =?utf-8?B?TWRnN2ZyZGpiUVd3TzVRWWVacEZBc1lyVlJmSE8vYUszVTJlcXI5YnhVZDlt?=
 =?utf-8?B?SjZKNjl0dkdDdkE3emFuZGQvaG4wZ3RMVUIrWGxKR2RVc1FrTXVvMi9Hem5i?=
 =?utf-8?B?UmZjWDJ3NFVnT3FVQUV6ZjVCSnFzRDVDcTRMQ1p2Y0dIUm5jWkJ1ajN5SUpq?=
 =?utf-8?B?alhyWlhSaU1Ud1ozcTlXeFdOclE2MmQrTWxhQ0JEUFlPczArOUpOa3VhR2RK?=
 =?utf-8?B?ZmhzMEhxa0ZRRE00bVRRcWQzMEYybkdZYVJkNS8wUnNlN3ZKZDhQT0NycE9t?=
 =?utf-8?B?cXpzNWRvbkl6U1ZMZVBMTVlaVGh6L1dVZDR0cjJBc1YwQUNZcjZsUlRXUUVI?=
 =?utf-8?B?d2RlUWx0Nk95aHl0UmpSK3lqZDY3YzE2REZlblFlV3hQL2ppUkZHVGdSLzZr?=
 =?utf-8?B?T09BTWFScTRwQjlDbnc1SzZUZkFSNFVqN2RPSlRlZnBjZDBCSnNYdko5MWxs?=
 =?utf-8?B?LzA1QWRZYzZSWUxPSUlUY1lkZjVsQ1RaRmdaS1J2S0VqUGRtd2pVa056QWdG?=
 =?utf-8?B?WVRncDBTeStnU0FHWnlOZllUN0xRVzdsVWdQN2JHbEVIbFR6azRvWUxZQTV1?=
 =?utf-8?B?ZVNwLy9pT1c3SE1DdWFZYVpteUR2eGI5ZFp6VFJGc3FOOHVwMDhqREVEN2dn?=
 =?utf-8?B?anJnWWVUcFRFMjZYdno0M0d5Sm9RekcrdTkzUndIYS95UzB0RU4ySUhGNzBs?=
 =?utf-8?B?NmFzMkF3ZGNSWDNrYXZLR0UwelE1N3hJcy9lVE5GMEFvSHcycHMzMGRmcEZi?=
 =?utf-8?B?eFU1TnlFVDhaZkdIaTF2bnNHSmxtQ1owcWxSRlFZYnN5eHlncU1NL2VnY3lJ?=
 =?utf-8?B?ZHVDendSY0JPV2hPWVNqYWg4cW9adlRuRElJdG1xbWFLY2FoQXFpa1h0RjJm?=
 =?utf-8?B?ZmxJbzNGNUNvYVEzZ1k0OG9nQnl5bmFjSzROdnd3U2R2TU9mME40eDBhYncx?=
 =?utf-8?B?aHJRK1ZnejRZaGFYbGVPR1R5V2k5bXJwc3dTc2ZlVDZJWE5ZNUoyKzhrcFlU?=
 =?utf-8?B?ajZxekRnL2Mvb1lDdXV5UDJvcjYwZ0RieWtUK1Nua0xWOWhnK0x6aDhPVWs5?=
 =?utf-8?Q?iiOm5V+Z3/D1/ss5sYbA+G2OZL0zrcroC5M/o=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bc95d3f5-f276-4c40-841c-08d93b30b594
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2021 19:04:24.2802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oBDY6wR6BbMZj10vhU8sx2GNUh+rx1m30z8CbY5XuIr9laf9kbctNxYZygcUkgvB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4919
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: AJlH5D8iE1O2hthp1eoYPTZP55SSX-GR
X-Proofpoint-ORIG-GUID: AJlH5D8iE1O2hthp1eoYPTZP55SSX-GR
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-29_11:2021-06-29,2021-06-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 clxscore=1015 suspectscore=0 phishscore=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 spamscore=0 adultscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106290120
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/25/21 1:04 PM, Martin KaFai Lau wrote:
> This set is to allow bpf tcp iter to call bpf_setsockopt.
> 
> With bpf-tcp-cc, new algo rollout happens more often.  Instead of
> restarting the applications to pick up the new tcp-cc, this set
> allows the bpf tcp iter with the netadmin cap to call
> bpf_setsockopt(TCP_CONGESTION).  It is not limited to TCP_CONGESTION
> and the bpf tcp iter can call bpf_setsockopt() with other options.
> The bpf tcp iter can read into all the fields of a tcp_sock, so
> there is a lot of flexibility to select the desired sk to do
> setsockopt(), e.g. it can test for TCP_LISTEN only and leave
> the established connections untouched, or check the addr/port,
> or check the current tcp-cc name, ...etc.
> 
> Patch 1-4 are some cleanup and prep work in the tcp and bpf seq_file.
> 
> Patch 5 is to have the tcp seq_file iterate on the
> port+addr lhash2 instead of the port only listening_hash.
> 
> Patch 6 is to have the bpf tcp iter doing batching which
> then allows lock_sock.  lock_sock is needed for setsockopt.
> 
> Patch 7 allows the bpf tcp iter to call bpf_setsockopt.
> 
> Martin KaFai Lau (8):
>    tcp: seq_file: Avoid skipping sk during tcp_seek_last_pos
>    tcp: seq_file: Refactor net and family matching
>    bpf: tcp: seq_file: Remove bpf_seq_afinfo from tcp_iter_state
>    tcp: seq_file: Add listening_get_first()
>    tcp: seq_file: Replace listening_hash with lhash2
>    bpf: tcp: bpf iter batching and lock_sock
>    bpf: tcp: Support bpf_setsockopt in bpf tcp iter
>    bpf: selftest: Test batching and bpf_setsockopt in bpf tcp iter
> 
>   include/linux/bpf.h                           |   7 +
>   include/net/inet_hashtables.h                 |   6 +
>   include/net/tcp.h                             |   1 -
>   kernel/bpf/bpf_iter.c                         |  22 +
>   kernel/trace/bpf_trace.c                      |   7 +-
>   net/core/filter.c                             |  17 +
>   net/ipv4/tcp_ipv4.c                           | 409 ++++++++++++++----
>   tools/testing/selftests/bpf/network_helpers.c |  85 +++-
>   tools/testing/selftests/bpf/network_helpers.h |   4 +
>   .../bpf/prog_tests/bpf_iter_setsockopt.c      | 226 ++++++++++
>   .../selftests/bpf/progs/bpf_iter_setsockopt.c |  76 ++++
>   .../selftests/bpf/progs/bpf_tracing_net.h     |   4 +
>   12 files changed, 767 insertions(+), 97 deletions(-)
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_iter_setsockopt.c
>   create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_setsockopt.c

I have a few minor comments (replying to individual commits). But 
overall LGTM.

Acked-by: Yonghong Song <yhs@fb.com>

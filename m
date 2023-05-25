Return-Path: <netdev+bounces-5229-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C5475710549
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 07:26:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 334531C20E8C
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 05:26:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CB0C847A;
	Thu, 25 May 2023 05:26:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D72B199;
	Thu, 25 May 2023 05:26:48 +0000 (UTC)
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B1997;
	Wed, 24 May 2023 22:26:46 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34ONabua002556;
	Wed, 24 May 2023 22:26:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=SZI2zY855EC3k4KM8ft0/FSmCJ/ACu6163H81bk5lLk=;
 b=W38qm2Dg1GX7L42adYd2WQtLHogvViCcirsLYMCqXa8Jd3h/jVC7i30lI8gK7ZM8TGhB
 5Zt+wlt8PSboNCG0A0fnms88QYMADUZZvD2zw8vK8LoeEiotesW9j7jPAJaIZJvFYX6f
 8h6UPAhn9zQKKTtVV77eGdq7odYlx+4K/cyevBYs7x+/Meh3yqq+h1T6KX7tUoCB0nkh
 kdk6P2sUwiCxUOAmV7VGJ2qdjh+v3uFtZNJFeIjTMahKBjYqhIFeJUeKl9A4dU1g/0WI
 5Q25GGjtw6RFOuMBEthE6vlNemM0uf5km3Zw9NJL/gMcy68F72kYGYLU/W6Ub6JJmPaR Pg== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3qscws01u9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 May 2023 22:26:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DBnZGm92O7B7OPVHHzRzZ9qrFFfhxC1z8y0VQkAacaE3254EvHlDs5WS45ecKCdNNgSy3kvvYJQzTo+jyhmb2xj9Nj7AQHZbRV2rSW3FyOQnkhVwmfoGiaUqlGQH70ZdIxiQu1Gl4z2e2u5/9zO/4//ntutmP+1e1V98Ym8U0D8aFBoGEc2NvXBWqcb4ZnohjW2tHkPOTxJg44FlFS1tfDhekG7iSs9brbaErN9Yn8OMu5hBXi/YIpUHA9jGBXESHh+iQYG6McQXhBTciQlTbm1UGNXulOpEC1/sH/tvPGJDxRoQlNCLxr2qVrWwdCVzVhn3ohMTPZHUB6iNt/xV/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SZI2zY855EC3k4KM8ft0/FSmCJ/ACu6163H81bk5lLk=;
 b=H+Dnvkg5gtlsZo1JOc2cWVoL8puXQ/+ToQcYR1TNzxRsCwaieJWAkm4ZenRrCqJDHJ47qUPhT+BW9vM8KxsP2Vp/MisTwa3vtCFJrQONYBjSqMRrq4uCidYIMwijyidTlS9y0l6MtsgUIu0xZo6ewNxyt8ZUmQUM7BTCwDPy4O9EfsRJ1BfKDC2GnWZt4j8oZ5RcDdxtvScYnCfUnCLOAV0dNC2OJbd0Z9D9RsFPnp2M3ak1NnEZek/YqE1JMmnRK6Hxd3yx0ZC0QfKkwLpNYZM/f1Nabk+Kgy9+3PeyeLyIZrkiIzh1EWpb9s0N8haZEyygNstHmqwL/5eRnvgGUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA0PR15MB4030.namprd15.prod.outlook.com (2603:10b6:806:88::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Thu, 25 May
 2023 05:26:35 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::bf7d:a453:b8d9:cf0]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::bf7d:a453:b8d9:cf0%5]) with mapi id 15.20.6433.016; Thu, 25 May 2023
 05:26:35 +0000
Message-ID: <26c90595-f45e-a813-d538-0892c3ef2424@meta.com>
Date: Wed, 24 May 2023 22:26:32 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
Subject: Re: [PATCH bpf-next] bpf: Export rx queue info for reuseport ebpf
 prog
Content-Language: en-US
To: Joe Damato <jdamato@fastly.com>, bpf@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, ast@kernel.org,
        edumazet@google.com, martin.lau@linux.dev, song@kernel.org,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        jolsa@kernel.org, haoluo@google.com
References: <20230525033757.47483-1-jdamato@fastly.com>
From: Yonghong Song <yhs@meta.com>
In-Reply-To: <20230525033757.47483-1-jdamato@fastly.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0071.prod.exchangelabs.com (2603:10b6:a03:94::48)
 To SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|SA0PR15MB4030:EE_
X-MS-Office365-Filtering-Correlation-Id: 339db506-e3c5-4c16-ef29-08db5ce09b60
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	0o9GY5XJRjRvHOseQgynJMcX4H0nhyzNdba/reiN8r4adSFZjqUuENexXpCbbh8repRQc075irDG1bV8QMYhgaBX7z2FG3kCFq/3TCEl+y/RORFDJT2ng1Wue+92udCmUMdpyXC9LN0igkSC0PJ2p+hToEDLXF7bBR/VPF4oP+k9c67/dvUf1dk59E+oT9mQhS1uEYDpNzmcJ6avQDlafSj3r6vl89ROogKhwXGFf2D9c7f8HP1Xu5qW5zvVYqaysN+f+yxCqwd80U4OB4y/Vrx7nRwl72Z+2GimOp4/eDcXLzKNLjfsSlyfZt6qfnV6c9qAaLVN0B3Q9s2tUxoElXSv82pc+R1TKMpJiguoOgbQ7DW4D6bUvCl3VKDLHHsEfPKXH0d565g83kowRsvJdPaazZCzTcT7oYekjzYEF2k4ePLWJDN3kLm8glyRcOlhWu2pffeZ5rEUPpBglHNshW8K9mecLcOlD5EZDryZUs3w7tzw13HzMMg7zrtSt9xHZssKCYJlGlPghMd9Eu3DKKu8zIGZE3srY+5ZaqmIeKJX4gUnE2aZ+YUhCsz00fAcv+7gC2buUGHvxHseqT9CHfKzm+2NFfqNViuZbP5vTGtaIxsghRTuAAwgezUlSY/XYlu1e7gdQt65jdUObT67mQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(366004)(376002)(396003)(39860400002)(451199021)(2906002)(2616005)(83380400001)(186003)(36756003)(31696002)(86362001)(38100700002)(6666004)(316002)(6486002)(41300700001)(8936002)(7416002)(8676002)(5660300002)(478600001)(31686004)(66556008)(66476007)(66946007)(4326008)(6512007)(53546011)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?dkNVSm9sWFdwcHBaYkRTdmVKRENvbnNBcW1URDRmU2hwNXFDRTFwVEdxU1Y3?=
 =?utf-8?B?Z3VRdDA1cWR4VXp2M3pDcC9PdVlPdlg4Z0NHN1U4TGpiMGh6NE1EdkwwSEpp?=
 =?utf-8?B?VWxvTy9PS2gzOC91S0ZFOG9oaDhlbmY4Nmp6cTI5cUdkYkMycGRTVWFIb3Jo?=
 =?utf-8?B?d2FKMUJNZFRNYm9uekcyUTRmS2NVRmpWb0hETWpBQm9HK3ZPVDRSRWN0WDFr?=
 =?utf-8?B?QlVHbzNjVjRBUlQ3SnNpcXpEK29JWUliQ1NFbDJpb2E5eGtscDlTWXl4Ni9I?=
 =?utf-8?B?TnlvQkxRK3Bna2RjdDdRb1FqVVFmOURMVUszYkphazYvNXdTcjZSN2dlVk1p?=
 =?utf-8?B?eUtwNDZhcVZYa2h3aGVUODhUa1BoZGsvOG5JV1drYjNHQitSdzZaSFRnVWtI?=
 =?utf-8?B?M2twYVVKWDYwMWo5OVYzbkdTem80U1h5TjJSZmVYaysvR0doYUFpeTdYRE9H?=
 =?utf-8?B?aDVrMi9xckJlQUxzSEU2aXV5SExMOXJHbTVEeWVXSmRPeUpDei9RcmwwQnhn?=
 =?utf-8?B?eDdTTTN5ZHRLd0svNVRYcFJmeHJBbUl5bElNOXBDOGVDNzhFbDlvaUFINXdi?=
 =?utf-8?B?ZjJzc0QxbzhvOGdQNm1nb0w3dWFKOFJZZXJabHNCNGRBdDJpUHNYc1lJZDA5?=
 =?utf-8?B?SzFacW9ONTlWb1FWdmE2V2xSRjdIWi9XK21nMEtDRHV4dlVsR0tSK1BBcHI4?=
 =?utf-8?B?bUdiaG9JejhOM3cvWVUyRXRIYmhZVjBiTVlwUzRMQ3dlOVV5NnhuM0RkbHM4?=
 =?utf-8?B?NEt2OGlpWGtQLzQ1V3d5S2hKK2RhTGtGTXVoN1FQZVRkdHE1T1YzQVd0UHZT?=
 =?utf-8?B?VXljRnZkT1hXb3F6bWgxTkhUVUYzbEpCNjRjL1JXUkE3RDI5ZnpyUUtpUzBI?=
 =?utf-8?B?blEzTjNPTGpwNmVENXM1bXB0NXR2K3lKWG82VzQ2S1Rmb3NsWWwvQ1NUSjJC?=
 =?utf-8?B?ZHVZc2pWU0dhTjdMblRzMmtWU1pMUnpoNkN6aWZoYjJQcjV4blRkZVQ4aVdF?=
 =?utf-8?B?TlFQb01ONUhlUllEZHNPdlE3NHJFTldYZHBDQkI4eGxraGpUTWp5QzduN3Ni?=
 =?utf-8?B?bk4rMmFwZnZYcGZ1N2hUTWtIeHEwTjBDSnVqUFJVanREYmhKMHFtYTArdy9p?=
 =?utf-8?B?Tkhiam0wKzlDYnBUM2VCcFBLL3hXSFhuS2p6UjlETCtSczdla1Z4ZnpuQjN4?=
 =?utf-8?B?Qkd5TSsxai96ckxzL3krOGc0Z3hOS1Vza0ZpRi9XcWhkRVZPT0c4SjNxeFhG?=
 =?utf-8?B?ZTVLVVRzUTV5K2JydGZTWERFL0hFUW55MnNxUGVmQmszVDh6NmxaL1h6aDkr?=
 =?utf-8?B?a2RnZzFjdVJ3dkxrSzdWL3ZJV0Zxc2ZBbXFWR2sxc2dIWmovVXNvRlVFamNh?=
 =?utf-8?B?cU1KOWtaSUtlRHJtTXJZSkVwQm5SSGtoMXBXNVV2dFJjQ29tUDRXUjNtUWhS?=
 =?utf-8?B?Q2FGamlTdVVXV3h4cnp4NjVQUVVkTzJweUMyN1FQU3ppWm1Pb2dYZG1UNFE0?=
 =?utf-8?B?MEJwNEw0YTF5UW4vVDBjaDFWeWxzL0VDaUdTRUxadldRY2dYOTZDZ1luQzB2?=
 =?utf-8?B?ZDFhRVR4Y0FNV0I0clNHSzd5NXBCMHBzdGFoa2NpcDVKUlI5dmVVQXFBSEIz?=
 =?utf-8?B?QXdJU2cwVWRueGYwMThQeFRoV0l4TmVPUFViSFF5V25GZmRHN1NCNjZtZWUy?=
 =?utf-8?B?OXJQVytLQWt2Q3JlQjJPVkFaL2lUQkhuU1RScVgvRVRtVWtYNXVnTEF2VEpR?=
 =?utf-8?B?Q0RRQ3Y2Y2kwRi81QVJrNlRiNnNWUmJubU9DV2Uvbnp6TVU1bUVhMFpPRlRs?=
 =?utf-8?B?bUkwNk0vWGZ0T3Z3ckd6dUVoOVozaWpPbjdkOU81aGdxMGFCenplVzVuKzhW?=
 =?utf-8?B?NE5oT2xiYkh6RjhMVnQyanV1Q25KeHdvcEYrajNabE1TcE5OTmR2WE5BT0FD?=
 =?utf-8?B?VzF2dkdwcFdrc2dkY0JlUlZyZnpCMmFFaGlScHhqYitoWGdjcEtHQnRkZUJR?=
 =?utf-8?B?R3NrbjM0MXB4MDVBNXlmb21vVzl6MnFYZ3ZheG11QXlURlBzVGhpSWVEYy9h?=
 =?utf-8?B?ZkhBUWR3ZTBBRzNEL0VRMVArbWhFSnErQTg4NUVkVkhEMjJiY1pxRGxHVkRs?=
 =?utf-8?B?eTRZQTlBSFRiNEpGZHRBZVBBRnpOMHRPY3ZhcWhoV21RQUNCNWF5cmJXMi94?=
 =?utf-8?B?R0E9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 339db506-e3c5-4c16-ef29-08db5ce09b60
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2023 05:26:35.3893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 20ixFqtgCwynoN4a2VbznZc4nzrijoM0yaBNQ8xM29x29vW5bQ+BmwiUk6hWKetF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB4030
X-Proofpoint-GUID: 75UubAPUV-fP-WX3uUPGDXUQ8s6jC3s5
X-Proofpoint-ORIG-GUID: 75UubAPUV-fP-WX3uUPGDXUQ8s6jC3s5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-25_02,2023-05-24_01,2023-05-22_02
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/24/23 8:37 PM, Joe Damato wrote:
> BPF_PROG_TYPE_SK_REUSEPORT / sk_reuseport ebpf programs do not have
> access to the queue_mapping or napi_id of the incoming skb. Having
> this information can help ebpf progs determine which listen socket to
> select.
> 
> This patch exposes both queue_mapping and napi_id so that
> sk_reuseport ebpf programs can use this information to direct incoming
> connections to the correct listen socket in the SOCKMAP.
> 
> For example:
> 
> A multi-threaded userland program with several threads accepting client
> connections via a reuseport listen socket group might want to direct
> incoming connections from specific receive queues (or NAPI IDs) to specific
> listen sockets to maximize locality or for use with epoll busy-poll.
> 
> Signed-off-by: Joe Damato <jdamato@fastly.com>
> ---
>   include/uapi/linux/bpf.h |  2 ++
>   net/core/filter.c        | 10 ++++++++++
>   2 files changed, 12 insertions(+)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 9273c654743c..31560b506535 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -6286,6 +6286,8 @@ struct sk_reuseport_md {
>   	 */
>   	__u32 eth_protocol;
>   	__u32 ip_protocol;	/* IP protocol. e.g. IPPROTO_TCP, IPPROTO_UDP */
> +	__u32 rx_queue_mapping; /* Rx queue associated with the skb */
> +	__u32 napi_id;          /* napi id associated with the skb */
>   	__u32 bind_inany;	/* Is sock bound to an INANY address? */
>   	__u32 hash;		/* A hash of the packet 4 tuples */

This won't work. You will need to append to the end of data structure
to keep it backward compatibility.

Also, recent kernel has a kfunc bpf_cast_to_kern_ctx() which converts
a ctx to a kernel ctx and you can then use tracing-coding-style to
access those fields. In this particular case, you can do

    struct sk_reuseport_kern *kctx = bpf_cast_to_kern_ctx(ctx);

We have

struct sk_reuseport_kern {
         struct sk_buff *skb;
         struct sock *sk;
         struct sock *selected_sk;
         struct sock *migrating_sk;
         void *data_end;
         u32 hash;
         u32 reuseport_id;
         bool bind_inany;
};

through sk and skb pointer, you should be access the fields presented in
this patch. You can access more fields too.

So using bpf_cast_to_kern_ctx(), there is no need for more uapi changes.
Please give a try.

>   	/* When reuse->migrating_sk is NULL, it is selecting a sk for the
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 968139f4a1ac..71826e1ef7dc 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -11134,6 +11134,8 @@ sk_reuseport_is_valid_access(int off, int size,
>   	case bpf_ctx_range(struct sk_reuseport_md, ip_protocol):
>   	case bpf_ctx_range(struct sk_reuseport_md, bind_inany):
>   	case bpf_ctx_range(struct sk_reuseport_md, len):
> +	case bpf_ctx_range(struct sk_reuseport_md, rx_queue_mapping):
> +	case bpf_ctx_range(struct sk_reuseport_md, napi_id):
>   		bpf_ctx_record_field_size(info, size_default);
>   		return bpf_ctx_narrow_access_ok(off, size, size_default);
>   
> @@ -11183,6 +11185,14 @@ static u32 sk_reuseport_convert_ctx_access(enum bpf_access_type type,
>   		SK_REUSEPORT_LOAD_SKB_FIELD(protocol);
>   		break;
>   
> +	case offsetof(struct sk_reuseport_md, rx_queue_mapping):
> +		SK_REUSEPORT_LOAD_SKB_FIELD(queue_mapping);
> +		break;
> +
> +	case offsetof(struct sk_reuseport_md, napi_id):
> +		SK_REUSEPORT_LOAD_SKB_FIELD(napi_id);
> +		break;
> +
>   	case offsetof(struct sk_reuseport_md, ip_protocol):
>   		SK_REUSEPORT_LOAD_SK_FIELD(sk_protocol);
>   		break;


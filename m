Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 060C3445949
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 19:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234040AbhKDSJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 14:09:21 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:60474 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231402AbhKDSJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 14:09:20 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A4ENhRU001616;
        Thu, 4 Nov 2021 11:06:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=9n8QvHPoVIfdcvpxFqDOA7CJ1aElxKDQ5iH9vSLOBJo=;
 b=mBVrsHEFP6lz1CL7SzcdMVgIvGXEpsZRfNe+tMj653C7cg7LshJUaGYTXLmm0M5LtEzd
 gkPH4CnDNv/wKMmbx0x9bbr1QrH/mq63OEAkBiubCImZsrziBh2rLiJ2QVSTqDrmsEz2
 /urDey5p4SZyouyP5OxxmAdFjoCs2cdOKEI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3c485a5syq-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 04 Nov 2021 11:06:27 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 4 Nov 2021 11:06:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GMp2EsUhsJpsTip0mzZphZB0uY9zM91oF3trHjzwOxza3ZQ23XpW+HtNci6KAqmR78P2bgbDKXCiRt2XOk5rSNiryVF6U2goYL9BFa5KgbGIVyc3na3I6bpMJi8MA9dNnXbQIE5oB0DeswvEtT+q6H5m/uXWeAKqSw/M8zxZ9f0iEhORIF2eiTeK9qEO1ZqJAA5I0pUWLMXKOT84VYShvVTx6cDndLq92KWJNI8aDKYCMs7zrIIakUNGm880eFHJ4++G4c8didgp8VvdMxb+Y9c/1UKFV16v9EXpLNJ3JYXpPmyxDYUFl5T7gJfu9YC+jpBf4rGQ4dDctxtrLAfYSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9n8QvHPoVIfdcvpxFqDOA7CJ1aElxKDQ5iH9vSLOBJo=;
 b=ioZrCF43dE1EcR6vBnoZ4zGvKBuSdruae2sr4lL5DHVONtxGsLEcWCrGS0WbYWcgqS2vpx0/wWQZqbXpDdhxJaxzcNl7F0Ra4MqhWvFlwyMMW1flRBzIs0DuhALQYDoW+6m5ffoKL2FPaLrcs79rmG2HcxaRdMshyPoOpGBHimpzy52K8jAF7ny6pBEGJMgNFvz1QbziwLpi7qU4um4CSnoJLZfNwSTIGWhF+1KHc5Dhtambrt08TsmBQ/QcanBUATCq36LptqoQtNY232Do7C4IKLtzbhIadv0cypFcjq0PDG0c5QjY5GHff1YhLuAJDm3mIAWAXUOncYnAQeL46A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: cloudflare.com; dkim=none (message not signed)
 header.d=none;cloudflare.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4903.namprd15.prod.outlook.com (2603:10b6:806:1d2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Thu, 4 Nov
 2021 18:06:25 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75%6]) with mapi id 15.20.4669.011; Thu, 4 Nov 2021
 18:06:24 +0000
Message-ID: <32332bb4-1848-0280-9482-5189ab912b02@fb.com>
Date:   Thu, 4 Nov 2021 11:06:21 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH bpf-next v2 1/2] bpf: Add ifindex to bpf_sk_lookup
Content-Language: en-US
To:     Mark Pashmfouroush <markpash@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
CC:     <kernel-team@cloudflare.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20211104122304.962104-1-markpash@cloudflare.com>
 <20211104122304.962104-2-markpash@cloudflare.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20211104122304.962104-2-markpash@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0262.namprd03.prod.outlook.com
 (2603:10b6:303:b4::27) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
Received: from [IPV6:2620:10d:c085:21e8::1253] (2620:10d:c090:400::5:e407) by MW4PR03CA0262.namprd03.prod.outlook.com (2603:10b6:303:b4::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Thu, 4 Nov 2021 18:06:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9f2415f8-7786-4bd5-b7b6-08d99fbdd0a1
X-MS-TrafficTypeDiagnostic: SA1PR15MB4903:
X-Microsoft-Antispam-PRVS: <SA1PR15MB49034B972D49337DC4B26F98D38D9@SA1PR15MB4903.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1201;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2wQezTW6nzo0TLpof16uIAJQ6Wufp9X9QUP/QAccxa1WlbLJQIrwaEqBPKjDAub7jQtXzkzAhPioLEA7oXtgixIrBmfqx0xRYo1OmGzlLjYS9lAEOE0oggm6gvpDMDSSKQXw5RgRzKFJmioDXheAuVIw+t1FZhIv+9uD0/8frLLiXFa0OC5asU46bBRYpCMwAkP+MthcUsKEUbpSXVwVUEZAIzx/8GWSeSL/UxxA82JfW++rLc5lcqfcHy/F/qFBP3FjLln8QhpMgp4f4xfFwlMljZw4SUsFsohlyYO07ubJXIjkSCEl5/IzIohbJtUuW1y0o7Ppv4BmGKvZwXxe1yNuNMU5xJ5kDYCcNcogtqSwW0GvbuV4BmtknQbAWQjKuXzSj+LHVpTxX4n1h5jxKV69HijV448xm3aDrQy5ve9jji+yDpHOIAxpSG/GGV34pYCwcUE4XzJiAsw3aXLxa2bvR0wvAwdN8RIB+EvqAjmHmNhnkKeaymlyiG+reyJPcPT2B0H194g9erYFFVZO4VXVDLw7qD3SQH5uYWkU6KCp3x5FD0XtC21iciM9uVfGmzmvM/7FqPaFANf1WMu+ILAdBt8F6OKhnTRc106Qj7Z5Di2iRz6DwVeyUXld9bfkr3W2yYwJ8sZcJumn830RRemvzl3XpvsfOSEyxxpeV8PDidrJz5P+HU/4sWYFTfNVAGkrYzWNFpMcQRrnehEYrpR9Q3WZcPd7sN2QBX920SebqRK/npuL49AjsI/i8Nry
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6486002)(110136005)(66946007)(316002)(66556008)(66476007)(53546011)(52116002)(31696002)(86362001)(7416002)(2616005)(38100700002)(186003)(36756003)(31686004)(83380400001)(2906002)(508600001)(8936002)(8676002)(4326008)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SGF3L3FVY3c3OGZXbWgyaklsNC9zUGowSlFUZkpjOTBtNm9KbUNXVmRueTMz?=
 =?utf-8?B?ZUVXeTFvRFRtdVlsWGpqNHNYUUtJN2RzRUFxZnZhakg1N1dQeStBRWxkTTFH?=
 =?utf-8?B?NHZTL0NYYzNhNlNMYkVhUld3WWkrQkdRcTRidnNHcGl0SWt2V25WeDZ5Y1lR?=
 =?utf-8?B?V0U4NzJHeHc4QmhuUDRjNTJkZlFhUit5TndCTnVid0h6QVJGd2dhQWx5UURO?=
 =?utf-8?B?VkdWTFRCc1VWVkNOSXIySUgyb01QNkk5cFRSdWh3L1hySkE4azdQZkhFZkJO?=
 =?utf-8?B?c1NvUGZRV2FYOW41UUNFQXlYb2dHc01haFYwOWwrdWlZUXhkV2ljSmJIL0Vv?=
 =?utf-8?B?UGY5OGdNcmRzRDRyTjE2ZitZTXFUb1ZtcGxoVzlHQWtEREQ3cXZ4bHZ4ODdW?=
 =?utf-8?B?ZngzTTZBY2Z3UlBxeTRTTFNxRk1sRFRXYmVGSG1jUTZIMm5ENlVUVzZlSDRD?=
 =?utf-8?B?ZVpTcDFvTUZIbzd2OXVwcndqVS9hR0t0YXZ2Q21NUXQ2VFk1YmorUXV2REFP?=
 =?utf-8?B?Rm95YmhrNVF4L1BOcGdhRzlIRmtIVVdNV25OclA3eHZoNUxoYlJEaUpQaXNG?=
 =?utf-8?B?WmsrWGc0Zzl2c2tqK2psZWNUOFhJRFViMFlLSzJNRXdnRngrVFE1UzlPbG5t?=
 =?utf-8?B?akIvR0dVMWkwY1dWa2hqUDVuSFNJZERTbXpiL1cyRDhVNk1aSW1QbytBVWdO?=
 =?utf-8?B?a1lscUpWQ3JVS2FoU1VVbDhUbWVEdHIrZHhpNEltZ3R4MTFYSmY4Y0haa0dK?=
 =?utf-8?B?WjFXNW9CVHBxV0dMcG5vb2lvZTNLalFuaVRkY1NhRlhKelI0dTNiQkVoUmxI?=
 =?utf-8?B?eFV0NzN5cVlVL2JPdm1KL2htL2lLdGFqOXprb0lEbGJKOEozaGI4RHFwdk5I?=
 =?utf-8?B?cUpZOTdOT2JETVRsM3Jselowd0h5QWovVWdSVmdyWEFvN2hvZ29jb2pKZ3lu?=
 =?utf-8?B?Mm9YZXNJT2kwTkt5eXRSMlYxTG1VMCsrcjZsUHNsSDR6TU9Fbk0ySG85bExo?=
 =?utf-8?B?Z2krbkE2RFdwbExES0pQSVJhbWJRajZ6OE1RZXFwNnA1R0JsTkIyek43WEVz?=
 =?utf-8?B?OUxnaXo0RHRXYmxjR2kzc1ZudE1mOGY5SVgzdEJKN0srdGY1bWVHTmVkWTl0?=
 =?utf-8?B?OGRTdDlCeFkxU3VMWUxxclh6Nzd6dVVRdG1GVXJTR1Z2cjhrRFdBTkhFMXBy?=
 =?utf-8?B?QTdNMTBqcDlqUHlKM1lpenZPMmlXTmFCenlBalZPMUUxa3lpUEdyZDI0UjlW?=
 =?utf-8?B?Rk9FZ0w2YzN6eXBCY2lvMVhkdWh0V3M1TG5BRDM1bjg4dVBqckVVbmo4OC9U?=
 =?utf-8?B?SEZ3LzR6RlNvazh1Ylc2VHMwbWNMTE5HZ0FvWjZZUlVlQnBmQzRlWVpCY1hh?=
 =?utf-8?B?WGFxTWR2UEVxNXkrcHRqK3pHU3BXUWN0MlIrUXB0aWZYYzdwWi8rVHVVbXpO?=
 =?utf-8?B?bHVuT2dxSDY1c0VLNWlrUjVQbEdhVmxqU3NRc1pHQnc0UXJrODIrK2JMVTUv?=
 =?utf-8?B?d3Uxb0MxVXYzUmlVTDdpOGxBMXg3RHJCTFE3azY0SHpwR0hBbDhocjJRY3ps?=
 =?utf-8?B?Yi9zUjIwdzdWM1lrTTNYVi9pZUZvSGZ5QzJBK1BqMUt4aVBjamhnV1l6enpr?=
 =?utf-8?B?bWsyRDljOFlDL05vS3Q0K05DTmZUWU9MNlZOMFFLbGJ2VVdQT3QwaitZdHNM?=
 =?utf-8?B?ZW1zUkxZZmtPNmhpeG96aDVOTkkrK2podzFLRDRGRUxUeGE4M21kUXE0L0w4?=
 =?utf-8?B?aExnbUwzcUFGQnova0tSblAzaEtCb25OV3Eva2tlVXlaUDVmL0lhZTFvWkQz?=
 =?utf-8?B?Q3ZHZ0U4czgzK1d3OExveG9rcDZyeVZCYzBlQkhZekp4bDltaW52ZHJyeExG?=
 =?utf-8?B?ZlQ4UUxCYjJUeVlpVlZUWndMTVBvLytpa0xpY2p0K3RON1RtZ2hrRXY4dUIy?=
 =?utf-8?B?U1Q2aURDSWJuU1ZlMGVzTFRjRGVRMTBoM1ZXM0d0dGRCenkrRlcrM2h4MWlm?=
 =?utf-8?B?ano4ZHFQQ3VKc0FKYmVDNGtBeGlIUnltM0lhUkpicldMV3NOSkdJV2JNRVhz?=
 =?utf-8?B?RVFFMitGMk5aNUlybDBjUHFCRXFieGxmTE80WGJ5Q1AvZE1QK20xb0thVWE1?=
 =?utf-8?B?bWxwRWE5WGlsUmhxQkZzYllpdTJUcllKNkRaVjFMcnV0ZnN1SDErM1NPVCtx?=
 =?utf-8?B?OUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f2415f8-7786-4bd5-b7b6-08d99fbdd0a1
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 18:06:24.8619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nNQ7uGe9haHDScPOujNF9wUAc5OMUyQwMsL5iI8BOVWgHrauz7134eDnHApJ0Ycr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4903
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: RtJYm5smMX2vylpXnOq1byxmxH5kFIoC
X-Proofpoint-GUID: RtJYm5smMX2vylpXnOq1byxmxH5kFIoC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-04_06,2021-11-03_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 adultscore=0 mlxlogscore=999 clxscore=1011 mlxscore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111040070
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/4/21 5:23 AM, Mark Pashmfouroush wrote:
> It may be helpful to have access to the ifindex during bpf socket
> lookup. An example may be to scope certain socket lookup logic to
> specific interfaces, i.e. an interface may be made exempt from custom
> lookup code.
> 
> Add the ifindex of the arriving connection to the bpf_sk_lookup API.
> 
> Signed-off-by: Mark Pashmfouroush <markpash@cloudflare.com>
> 
> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index 24b7ed2677af..0012a5176a32 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -1374,6 +1374,7 @@ struct bpf_sk_lookup_kern {
>   		const struct in6_addr *daddr;
>   	} v6;
>   	struct sock	*selected_sk;
> +	u32		ifindex;

In struct __sk_buff, we have two ifindex related fields:

         __u32 ingress_ifindex;
         __u32 ifindex;

Does newly-added ifindex corresponds to skb->ingress_ifindex or
skb->ifindex? From comments:
   > +	__u32 ifindex;		/* The arriving interface. Determined by inet_iif. */

looks like it corresponds to ingress? Should be use the name
ingress_ifindex to be consistent with __sk_buff?

>   	bool		no_reuseport;
>   };
>   
> @@ -1436,7 +1437,7 @@ extern struct static_key_false bpf_sk_lookup_enabled;
>   static inline bool bpf_sk_lookup_run_v4(struct net *net, int protocol,
>   					const __be32 saddr, const __be16 sport,
>   					const __be32 daddr, const u16 dport,
> -					struct sock **psk)
> +					const int ifindex, struct sock **psk)
>   {
>   	struct bpf_prog_array *run_array;
>   	struct sock *selected_sk = NULL;
> @@ -1452,6 +1453,7 @@ static inline bool bpf_sk_lookup_run_v4(struct net *net, int protocol,
>   			.v4.daddr	= daddr,
>   			.sport		= sport,
>   			.dport		= dport,
> +			.ifindex	= ifindex,
>   		};
>   		u32 act;
>   
> @@ -1474,7 +1476,7 @@ static inline bool bpf_sk_lookup_run_v6(struct net *net, int protocol,
>   					const __be16 sport,
>   					const struct in6_addr *daddr,
>   					const u16 dport,
> -					struct sock **psk)
> +					const int ifindex, struct sock **psk)
>   {
>   	struct bpf_prog_array *run_array;
>   	struct sock *selected_sk = NULL;
> @@ -1490,6 +1492,7 @@ static inline bool bpf_sk_lookup_run_v6(struct net *net, int protocol,
>   			.v6.daddr	= daddr,
>   			.sport		= sport,
>   			.dport		= dport,
> +			.ifindex	= ifindex,
>   		};
>   		u32 act;
>   
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index ba5af15e25f5..5b8618a4d485 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -6296,6 +6296,7 @@ struct bpf_sk_lookup {
>   	__u32 local_ip4;	/* Network byte order */
>   	__u32 local_ip6[4];	/* Network byte order */
>   	__u32 local_port;	/* Host byte order */
> +	__u32 ifindex;		/* The arriving interface. Determined by inet_iif. */
>   };
[...]

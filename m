Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9439F47CBC2
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 04:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242164AbhLVDoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 22:44:04 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:3738 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229997AbhLVDoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 22:44:03 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BM1GjQ7020758;
        Tue, 21 Dec 2021 19:44:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=gW93vG+Zvl34lfkcIWlBxsQRDrfTv4eokObqJ0QzzOI=;
 b=e7z6hG/r8eVnR4j54+5HHAWmb6EJ2Vfw1telgk4yRk9E4HFVslsMU5xfbvxsRfsX60La
 Y5GQraTUJ7GldW/+Lt6qVD/3iE2gY6oGhhgnp6adeWUG9wYQJ2EyAl8KUS+ld+Pb4exa
 UAVMi9OgbOg+8a0OcH8UpCBZZTTWjr6rIoE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3d3t7bgn69-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 21 Dec 2021 19:44:00 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 21 Dec 2021 19:43:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gHymihJ84xOMmMkyO/0xDkT5dAs1XK6uN3ajKGLmjswsUdwp2NDzTnu1eq7SyFu35jI5XL8SEIu9al+wD+aTfI7QTxWkIhxvquZJvQzD+HUqg5DWnQHLYtzqC/WParsu46xoDAxu52g+dqGRU89fZUanyZ6ICv9JXlekg5hRF2AiUEOw5tam140Ugi8sNuePVg5uOvyAhs2eBqkwhy2Xs5mbQoZK+CKFRUo4hCSGL3dWf7HBQhiC1ihfSnXZwgfzCAo/NJhGSf4xS4CBq7uo4/gM8i6lLVI48ypWb2+M7VXhdUxv2v2W+lFn352ke4EFdMXPRZRhV8EeBYrAOR84AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gW93vG+Zvl34lfkcIWlBxsQRDrfTv4eokObqJ0QzzOI=;
 b=jwgeVHvt6UjkOr9ZjBx0Zx2OlNSx8xVa8QfYM0q7PJCeKU37QaPxQLTdR111WWecP1Cv5JNUrrbecUqJEH/M3KKP44T78UL2Kj14dZbaAc3qqfsAT1AYnv5jFgEjAsPmgxggk+golz39LiCkFD9j3G8sONahDmmjhcNoWJx4znrmj0OU4SO+rLytvdc/APpsAqdpd/02sFcCJpkCXGiDzY09/sM8T8joK9Md0i8LuYTFH5j1ypFTLyALQwYUP3/EiXLk2ySkovXdI+UTTysOAA/w9IpPxKiSqmQcmMaIY96aoJZ0jrc49/S89xQazcLaQaAgXgpRyGV49Nh5zRm0YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4740.namprd15.prod.outlook.com (2603:10b6:806:19f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Wed, 22 Dec
 2021 03:43:53 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::b4ef:3f1:c561:fc26]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::b4ef:3f1:c561:fc26%5]) with mapi id 15.20.4801.020; Wed, 22 Dec 2021
 03:43:53 +0000
Message-ID: <1bb2ac91-d47c-82c2-41bd-cad0cc96e505@fb.com>
Date:   Tue, 21 Dec 2021 19:43:50 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH] Add skb_store_bytes() for BPF_PROG_TYPE_CGROUP_SKB
Content-Language: en-US
To:     Tyler Wear <quic_twear@quicinc.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <kafai@fb.com>, <maze@google.com>
References: <20211222022737.7369-1-quic_twear@quicinc.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20211222022737.7369-1-quic_twear@quicinc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR02CA0016.namprd02.prod.outlook.com
 (2603:10b6:300:4b::26) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 665d9bd7-cbd3-4582-73ec-08d9c4fd4625
X-MS-TrafficTypeDiagnostic: SA1PR15MB4740:EE_
X-Microsoft-Antispam-PRVS: <SA1PR15MB474085E3CC8B3578CA56000BD37D9@SA1PR15MB4740.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1751;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kjy8c8jUqfSTRbPv3/fErfOx0L6SF9W2+KWVhFmGME4foqDabon9Q7lqGQOnFVkWmd8j87/AXH6SAQ/OJh2q/ATJwmgUgDFo7R8/YL9lLllIac8QlvXD4JBU/esHqAkeUAPe8mG+dKkN+tFi+y9yomDZFY8TSrPLlDMXb+HcKy4tCZuEtqbbmb+MfV/XgnwQtGX6yFu2MK79Ko0gqU86RJQMi+LAtihNWXW5M9WtoJlu3g6LBNZ7h/AMRd1tEcchiK6S7rwp5heo01wvxbbziWTrCsrNZ5vkO7jhzEgKBbsf4W78S0Xjh7qXKrIPj5x6+0gUHJlImyyFlnuEhVdDBGJMeZDCUPvBb36krd/vFkZ42hr2z9p6FQcFY6b2XzIpC/FnRvfmYh/uMPcn6uPvFbM7vIHWaGnQV2ekut4tes0oyTvo0l4ULfADcMEHA0CpVA/u0kShKITJnXCjfyo/1FJPAk+aaMJxT8TklJeuImDtAxKSXKzye1RJM1AEvjfksuguxH3leWHO6v5hUXAGc41+oxA8LI+qfwOetFMr2FVC7II5iOoQXC/oBwFPmCx1DHQbKQEE/ASMkRd8VJWLF7s+GLLwK2PWZwfnd8cBhZ4rAzrmy4CHbM9J2+iCLqOsErowwNA0h5Q87vw0msNZN6Zu9IG3elvWL6VlUAsHlrKF5VHn79r2wSomTZXB5xQ2YPcJ/c4Q+3AAMP3lyKuQOTpL6rNIKvEtOANo9v+blHI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(31686004)(52116002)(508600001)(66476007)(316002)(36756003)(4326008)(31696002)(6512007)(53546011)(186003)(6506007)(6486002)(2616005)(8936002)(86362001)(5660300002)(2906002)(83380400001)(8676002)(66946007)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YnRFaG5QQ1I2dU9kQ2g4Q25BaHppdXJuemdoZzl5S2lERW1hSGpBM05QMGR0?=
 =?utf-8?B?TllaL0czdW5LYVJpS0FLZEVLUEVGSDhyTXNoaUNPTUhXZmFVNUcwK1hjdlAv?=
 =?utf-8?B?eEVLUnV3SkVpV3NxUzRVY09wUEhndFZJUENiUFJCdXZrd08yb3Q5SllDdEJj?=
 =?utf-8?B?UGJhRk1yejN5UW91ajhQK25yVG8yNTF3SVhMb2JlNjM2T1JselNQSUtXTjRR?=
 =?utf-8?B?YThrQ2Zmb2ZEVGphN1I3anZ2cXlHMjZZZ1V4RFc5K2R2elVKRGR6Sng4NWE5?=
 =?utf-8?B?WFlLMTFkNXlRYkVmMEpnclNaRmdJWkRhYXRJUlBnRjlvbi9hN2dnWGQ0di9z?=
 =?utf-8?B?VVFTelN2V25EWXlmT2t5eGQ3dG5rMEF0MzZJcUxoK21PbzAvNThleTEvSmlo?=
 =?utf-8?B?MzVSdnM5OVhpdGV3dTNLc1M2dTBwVG8vcEJXZUxjWWhNZjNUMUlPMzlmLzFQ?=
 =?utf-8?B?SWtpTjVjeGo5UkxUV0VyU2hPOHM1T3pKajhCYVhwUlY3S2dqTXBKSDNQTzA4?=
 =?utf-8?B?c3hac20wTGE1TksrSXpEUHEyNTNVamJrQ2ZIWFRFV0IxYjZhVTd4dXc4NitO?=
 =?utf-8?B?YVhiQnNaVTREY2dLaXBZVExJYzJYc2g2bTFHTC9IM1czSjk5R25YdUhGNWxR?=
 =?utf-8?B?YVdjUGJVdGdVMUVVQmhhdEF2bGMzRVVySGJ5ZDdUUm50MlZTNTVqZmZIeS85?=
 =?utf-8?B?TC9JdXlmRUZ6MVJERDdoaENoYkxTRkYyRlU1TDdIR2NObGVLM1M5c214RDJF?=
 =?utf-8?B?dk5pRE9Ea0dHVDNLdG8vMzR5RDY2THNKenlvQTJ3NEF6Sk9MWDd2RnBvUlBU?=
 =?utf-8?B?S2pEMEE3djdTVy84cDJnUXpNSmdiMmFibXFPMzFSUmxmUy9zUUlldzNXejFW?=
 =?utf-8?B?L0RLZW01ZUFGdWpBWHZ3dWJmTXF1eVJMWXQwTVVNS25id3YyKy9pYlJxZnpZ?=
 =?utf-8?B?eU5udzY3KzFrMTFTUU1mS28xSVBINE5vdzdPMjN0RTdIUVhMNzVrMlkvSCtT?=
 =?utf-8?B?RVRrajdUVG5BMUpkWGhWbkpuc1ZLMEQ4TUpaYXhWTnJJWVA5YnpNdHh1YUNK?=
 =?utf-8?B?UXpGR0pnZVJ1cGNrMDVPMlJWMmRtT2dSNjhYbitPOU5TTjdVb0djZ0QvMjdv?=
 =?utf-8?B?MVE4dWVDQkpUNjlsZDNIZmpVUHZXcVJDZVREV3NsK1BESXBkVzBDdEhmVFEz?=
 =?utf-8?B?bTAyNTJWdTVFN0hWKzN0QWUzbHdxVVFkWnYxa1BnN2JIbVJwcnVoWU84THFw?=
 =?utf-8?B?aXZSR3RCWDgyeGw3RU9SNWxuUXBOSjVpWDhpWmxDbEhPYW8yMy9aQUxNM2tz?=
 =?utf-8?B?dkp1ZmMzSjFDKzhtSEZrTndhTGFLV2doMmlGTkVRdkg4OXpCYUJZcGhkOUQz?=
 =?utf-8?B?TkNIMTE0ZHBwbDZQQ3NWYVBLemRqL0F6YS9VejVFa202WGFRd0thQ1hDcTlY?=
 =?utf-8?B?c0tvMHpMQUsvTWZMdStCL1ppMTMvamNtOFRaTENScFZiTUZoaWxueGZVc0JZ?=
 =?utf-8?B?Ujc1aXRDS0k1K0JHekpTZldpV01mS3JjYlRxUndUbFNCd01uQkJ4SHlGUWZp?=
 =?utf-8?B?eVRYQzFXVkl4cXp3UXo1eEQ0TXNpNnIrampXU1M5UHZ1Q09aOHRJVU5ycjBH?=
 =?utf-8?B?R1ZETk1LaWZYbURWUXJnMW9oVGRjWDl3SUpiVGRKbU1Nb2kzcDBROVN1eTdn?=
 =?utf-8?B?cVR3YVlSa0l4REFOWGtkRi9LNzVuYmJhUGRWdHlpdEZwdDk4cmVnYnFrdnBC?=
 =?utf-8?B?R2FiTEJFb1haN1JLRTNCSU5pMHlDQmE0M2xuZnNsMFBWQStJTjgxM3V3WTF5?=
 =?utf-8?B?Wk9NZWRkWXp1aGlKa2hHSUlzNDdiUGV5SzFyUktkVDdlTHpxb2dqRmVuMm5T?=
 =?utf-8?B?eEc4OVpraG01b0sxYlZBVExnOTdkRFFCN0c1NWU4MFlZWWxsRk83SE9abWJ0?=
 =?utf-8?B?OXZkMUpzSFpPRjBaQVA0ZGJuNmI5M0hlT01rMzJmcWI1T01GOHhPd0hxQmsr?=
 =?utf-8?B?b3FFZGJUNUp4U2w5Z1dkK0Z3K2lOdGl3SEdidXcwVDViZlUwWENvTzZwTzE2?=
 =?utf-8?B?eWF2eHJHRXBUZkloVURSRW9FekY3SkdCUjhoTlV2NElyOTJjSGhTNEZMeW1a?=
 =?utf-8?Q?rtMgrsva2BcSbi5XH+Ia8GwcB?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 665d9bd7-cbd3-4582-73ec-08d9c4fd4625
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2021 03:43:53.3984
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a24L8OjjrGeXkOefUlD3LIXHw63JIyqu01TZS+b4kFss5ZhWYiuPqvsmGTUNrsIc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4740
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: _rCuwKKcA7o_3K04HHon158sqTRmp9hQ
X-Proofpoint-ORIG-GUID: _rCuwKKcA7o_3K04HHon158sqTRmp9hQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-22_01,2021-12-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 lowpriorityscore=0
 phishscore=0 adultscore=0 impostorscore=0 mlxlogscore=999 spamscore=0
 malwarescore=0 priorityscore=1501 bulkscore=0 mlxscore=0 suspectscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112220023
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/21/21 6:27 PM, Tyler Wear wrote:
> Need to modify the ds field to support upcoming
> Wifi QoS Alliance spec. Instead of adding generic
> function for just modifying the ds field, add
> skb_store_bytes for BPF_PROG_TYPE_CGROUP_SKB. This
> allows other fields in the network and transport header
> to be modified in the future.

Could change tag from "[PATCH]" to "[PATCH bpf-next]"?
Please also indicate the version of the patch, so in
this case, it should be "[PATCH bpf-next v2]".

I think you can add more contents in the commit
message about why existing bpf_setsockopt() won't work
and why CGROUP_UDP[4|6]_SENDMSG is not preferred.
These have been discussed in v1 of this patch and they
are valuable for people to understand full context
and reasoning.

> 
> Signed-off-by: Tyler Wear <quic_twear@quicinc.com>
> ---
>   net/core/filter.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 6102f093d59a..0c25aa2212a2 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -7289,6 +7289,8 @@ static const struct bpf_func_proto *
>   cg_skb_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>   {
>   	switch (func_id) {
> +	case BPF_FUNC_skb_store_bytes:
> +		return &bpf_skb_store_bytes_proto;

Typically different 'case's are added in chronological order to people
can guess what is added earlier and what is added later. Maybe add
the new helper after BPF_FUNC_perf_event_output?

>   	case BPF_FUNC_get_local_storage:
>   		return &bpf_get_local_storage_proto;
>   	case BPF_FUNC_sk_fullsock:

Please add a test case to exercise the new usage of 
bpf_skb_store_bytes() helper. You may piggy back on
some existing cg_skb progs if it is easier to do.

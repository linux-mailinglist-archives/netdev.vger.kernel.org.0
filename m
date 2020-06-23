Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1682D204737
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 04:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731359AbgFWCWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 22:22:32 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:32618 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730882AbgFWCWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 22:22:32 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 05N2MGJN006770;
        Mon, 22 Jun 2020 19:22:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=LMtxSJRAyc1bvhMeQcdbxV8C0n9UYhriEstRBISJ72o=;
 b=ND46dZOUM9OXYLDKpef31G03C77EyDlZ/XtPgUJfZf4sxpziKEYddM3Xya7ySQZ/ANec
 FiXV28GkBV7tnQXV+Z6E+rr1pqt348fIO626WIPsHxQHlIa7vLpi2ulJBfCONdjmkxtK
 phtn4LfiqjgtwUgusdmSapiLsklHkJsdJtM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 31se4nkqud-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 22 Jun 2020 19:22:17 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 22 Jun 2020 19:22:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VHejn0l0Rz8nH6SMnwT/T5/ToENCRmSsgbaZFBRR+LhuVEZ2jiWvrzo/quURdNPt0TRS3AeJyQ/2fctZn9D+gm01KuSuR+FgTgRsF201G95L5hWld37TMcfeErQG3fbASizMNoSkRPb/bKeEeV4/Yv27vazTD1bI9zthMAJqX2tEqeoA1WaasTvS5o9KU31I+ErWCwAjiVkEQ89M7hC3jX0r2xuo7OkqLk5ftpK7eMc6OInePzGNVHBj/zu4FVaqNX6M4Ws6VNS/e3MmstnGeu0pDYZdy/o5LHbMrUthFJrWS7yi1FolEGlgyAYyxNq6plnLNYkDSfiSdKEOhDhg2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LMtxSJRAyc1bvhMeQcdbxV8C0n9UYhriEstRBISJ72o=;
 b=aeyUaQrKceqHUz4V7S+MBqQL1JvUtDv8GhhJKWgMlsVCpQ4w4qW9rL7l62RTF9f1i/DonBORHyIyXQmEcaWHpxAshQOshA3Uj+Sk3dzyJ19SOgd7DXcK2Y97dxwLmWFZVlkz+vwQh+tPndP0Vi1KdUUOcQ67VDekbisF8v0SaB33miqsY6B1vE149m02Hql3rV01dbUZZZgY3DoYZIXFIDPNddFYR07rnNN2LaXmMwYq1kG7ivLtZAQhJnfTu3JR/Xyq2Cdz62ruwR2y+sC8TxS3vM8N4WHKpYwOp0F6fw459xrgTfIt7G/87kQvXFGe7y6tG17WAUoyIPYb4VeJUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LMtxSJRAyc1bvhMeQcdbxV8C0n9UYhriEstRBISJ72o=;
 b=LhSgY96sN/M3IY0ykXroxDQ6T8tOZhxMJKI+eMhxx3RrsdLuHEgSPOYFewqtzuAxANewdKkDBkpBWhuVSYcSUD6Vb6nLoF5sAD8C8K7EzAghBiBGuYVOUoiG0C9joTYVcxOC7/KFkmwLEblvQUcOXkpLRFCoG3m4qTybgqTxMDg=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3191.namprd15.prod.outlook.com (2603:10b6:a03:107::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Tue, 23 Jun
 2020 02:22:06 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 02:22:06 +0000
Subject: Re: [PATCH bpf-next v3 09/15] bpf: add bpf_skc_to_udp6_sock() helper
To:     Eric Dumazet <eric.dumazet@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
References: <20200623003626.3072825-1-yhs@fb.com>
 <20200623003636.3074473-1-yhs@fb.com>
 <d0a594f6-bd83-bb48-01ce-bb960fdf8eb3@gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <a721817d-7382-f3d1-9cd0-7e6564b70f8b@fb.com>
Date:   Mon, 22 Jun 2020 19:22:03 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
In-Reply-To: <d0a594f6-bd83-bb48-01ce-bb960fdf8eb3@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0081.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::22) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::1595] (2620:10d:c090:400::5:3cd7) by BYAPR07CA0081.namprd07.prod.outlook.com (2603:10b6:a03:12b::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21 via Frontend Transport; Tue, 23 Jun 2020 02:22:05 +0000
X-Originating-IP: [2620:10d:c090:400::5:3cd7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1cfc0ba0-3345-4666-c751-08d8171c392b
X-MS-TrafficTypeDiagnostic: BYAPR15MB3191:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3191C25F0FBC7DE8D321BF8FD3940@BYAPR15MB3191.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 04433051BF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 50oZXgPgLutOaAXQF3kuVQrQAGCMTk3oAmWtPbhyVRZcuNos3RU/uDI23jclNahrNsF6CuoezqKxTi1dQwfHNM9uoTwOAR9BWKrWsr9JTgk06Vp6Xh4oWvHYVp4MTX1zW7lMGL88od+W+MYL/Q2Wmq21QIYi/e5hN30oCrnXHRa9DbV1pnd2+BTiCZZoN0y0ZAd6JT/I+qozmk5zlhV3MNGm981StclBqkugU8Erw+ZES88DkPobWxcyh9nPUrrJtiXLWgWfAinxLSxmS8IuOUJL7tDqWY8StbGZvXM0s65/nw2s6zaxm5ng3Y8Yewx8j+EgDESu0JkVaNtfjP7/xOVwzlPsm4bVlyuCkk5cl3fbiyZv6SPe/UX8UtIlOYbe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(396003)(366004)(376002)(136003)(39860400002)(2616005)(31686004)(86362001)(16526019)(478600001)(186003)(316002)(53546011)(52116002)(31696002)(6486002)(8936002)(54906003)(5660300002)(66476007)(83380400001)(66946007)(66556008)(8676002)(36756003)(2906002)(4326008)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: JYMnMVESwFoMbvoKW3v2ZLSvkoeJEU9YBy8edKdvlMOZKP4j9IQT4xdhKoJNYTEyokfVHLs0R0uHIYZ2n0C0gkdAcl0StokdHoafzlADLYI2AgK6UhvR2cbhLmCmuhK7ur/c/dImj4sZR949otNC127vueDOYiQqDK49jHyUGLNuI3zwxrkpQp3+bnHQWwGe4WajEZxxaDLLeGop8ZJYYOinl7LzHGhC5Dq159AB1HGciORTGP+tQA5hMcWrVRcZlBzSNgrmpbLZ36lSVb5gcK42r63x+kdzOuDkFhFX16tnOBCgmmzUgl20CDM0NkQfzEhj7uxQrTqkOUA5JA/asZjOrwytaep/t9zn0kwM7JPxthnTo+r+rmWLdfrnOx8gVZJOryQh/K8O52GhrLjlkVRRgW97xYk6jnTSMzKiR/oaxdtaRwHEx3T8r8VJmokQYw7++oSaaGswwoIh5bV3ZBJ22I5T+1l0UxDH1e8aipC0rz5bj/Q9A3Qv/H1TCf/+n4Komr5A+wZVyZd9TbIkOA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cfc0ba0-3345-4666-c751-08d8171c392b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2020 02:22:06.4995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Amkcc8ndHX3QJYazHhZXMazefBR6Bommdq/2EN8UcWfLxv6AzXOcrRP3NOLv4h40
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3191
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-22_16:2020-06-22,2020-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 impostorscore=0 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0
 clxscore=1011 mlxscore=0 lowpriorityscore=0 priorityscore=1501
 cotscore=-2147483648 adultscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006230016
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/22/20 6:47 PM, Eric Dumazet wrote:
> 
> 
> On 6/22/20 5:36 PM, Yonghong Song wrote:
>> The helper is used in tracing programs to cast a socket
>> pointer to a udp6_sock pointer.
>> The return value could be NULL if the casting is illegal.
>>
>> Acked-by: Martin KaFai Lau <kafai@fb.com>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
>>   include/linux/bpf.h            |  1 +
>>   include/uapi/linux/bpf.h       |  9 ++++++++-
>>   kernel/trace/bpf_trace.c       |  2 ++
>>   net/core/filter.c              | 22 ++++++++++++++++++++++
>>   scripts/bpf_helpers_doc.py     |  2 ++
>>   tools/include/uapi/linux/bpf.h |  9 ++++++++-
>>   6 files changed, 43 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
>> index cc3f89827b89..3f5c6bb5e3a7 100644
>> --- a/include/linux/bpf.h
>> +++ b/include/linux/bpf.h
>> @@ -1649,6 +1649,7 @@ extern const struct bpf_func_proto bpf_skc_to_tcp6_sock_proto;
>>   extern const struct bpf_func_proto bpf_skc_to_tcp_sock_proto;
>>   extern const struct bpf_func_proto bpf_skc_to_tcp_timewait_sock_proto;
>>   extern const struct bpf_func_proto bpf_skc_to_tcp_request_sock_proto;
>> +extern const struct bpf_func_proto bpf_skc_to_udp6_sock_proto;
>>   
>>   const struct bpf_func_proto *bpf_tracing_func_proto(
>>   	enum bpf_func_id func_id, const struct bpf_prog *prog);
>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> index e256417d94c2..3f4b12c5c563 100644
>> --- a/include/uapi/linux/bpf.h
>> +++ b/include/uapi/linux/bpf.h
>> @@ -3276,6 +3276,12 @@ union bpf_attr {
>>    *		Dynamically cast a *sk* pointer to a *tcp_request_sock* pointer.
>>    *	Return
>>    *		*sk* if casting is valid, or NULL otherwise.
>> + *
>> + * struct udp6_sock *bpf_skc_to_udp6_sock(void *sk)
>> + * 	Description
>> + *		Dynamically cast a *sk* pointer to a *udp6_sock* pointer.
>> + *	Return
>> + *		*sk* if casting is valid, or NULL otherwise.
>>    */
>>   #define __BPF_FUNC_MAPPER(FN)		\
>>   	FN(unspec),			\
>> @@ -3417,7 +3423,8 @@ union bpf_attr {
>>   	FN(skc_to_tcp6_sock),		\
>>   	FN(skc_to_tcp_sock),		\
>>   	FN(skc_to_tcp_timewait_sock),	\
>> -	FN(skc_to_tcp_request_sock),
>> +	FN(skc_to_tcp_request_sock),	\
>> +	FN(skc_to_udp6_sock),
>>   
>>   /* integer value in 'imm' field of BPF_CALL instruction selects which helper
>>    * function eBPF program intends to call
>> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
>> index de5fbe66e1ca..d10ab16c4a2f 100644
>> --- a/kernel/trace/bpf_trace.c
>> +++ b/kernel/trace/bpf_trace.c
>> @@ -1523,6 +1523,8 @@ tracing_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>>   		return &bpf_skc_to_tcp_timewait_sock_proto;
>>   	case BPF_FUNC_skc_to_tcp_request_sock:
>>   		return &bpf_skc_to_tcp_request_sock_proto;
>> +	case BPF_FUNC_skc_to_udp6_sock:
>> +		return &bpf_skc_to_udp6_sock_proto;
>>   #endif
>>   	case BPF_FUNC_seq_printf:
>>   		return prog->expected_attach_type == BPF_TRACE_ITER ?
>> diff --git a/net/core/filter.c b/net/core/filter.c
>> index 140fc0fdf3e1..9a98f3616273 100644
>> --- a/net/core/filter.c
>> +++ b/net/core/filter.c
>> @@ -9325,3 +9325,25 @@ const struct bpf_func_proto bpf_skc_to_tcp_request_sock_proto = {
>>   	.check_btf_id		= check_arg_btf_id,
>>   	.ret_btf_id		= &btf_sock_ids[BTF_SOCK_TYPE_TCP_REQ],
>>   };
>> +
>> +BPF_CALL_1(bpf_skc_to_udp6_sock, struct sock *, sk)
>> +{
>> +	/* udp6_sock type is not generated in dwarf and hence btf,
>> +	 * trigger an explicit type generation here.
>> +	 */
>> +	BTF_TYPE_EMIT(struct udp6_sock);
>> +	if (sk_fullsock(sk) && sk->sk_protocol == IPPROTO_UDP &&
> 
> Why is the sk_fullsock(sk) needed ?

The parameter 'sk' could be a sock_common. That is why the
helper name bpf_skc_to_udp6_sock implies. The sock_common cannot
access sk_protocol, hence we requires sk_fullsock(sk) here.
Did I miss anything?

> 
>> +	    sk->sk_family == AF_INET6)
>> +		return (unsigned long)sk;
>> +
>> +	return (unsigned long)NULL;
>> +}
>> +
>> +const struct bpf_func_proto bpf_skc_to_udp6_sock_proto = {
>> +	.func			= bpf_skc_to_udp6_sock,
>> +	.gpl_only		= false,
>> +	.ret_type		= RET_PTR_TO_BTF_ID_OR_NULL,
>> +	.arg1_type		= ARG_PTR_TO_BTF_ID,
>> +	.check_btf_id		= check_arg_btf_id,
>> +	.ret_btf_id		= &btf_sock_ids[BTF_SOCK_TYPE_UDP6],
>> +};
[...]

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0085D1BD1BA
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 03:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgD2B1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 21:27:51 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58432 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726181AbgD2B1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 21:27:51 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03T1Pqom026279;
        Tue, 28 Apr 2020 18:27:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=00kthKCbCN1fMi/pMj0DPXhjKYDAHAKc5sriJyHfTkI=;
 b=TDCedR0VYEWPpmku2jTI0B7QRvPsxLK/p9LGy1EqaTczfYYv4E+4XTgORUbhhLPbN/PT
 Cq6+oCeDfIbr/vf450PXAiYkAVnTI+ibB+7h/UpsOYadRt1qW2dRlqyuyKFp9b5IDJuh
 UCfaK8mlOgz3w7Q0hTXUKmXzKLZpMxAfHy8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30n5bxb90g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 28 Apr 2020 18:27:38 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 28 Apr 2020 18:27:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eWeNjrvB4bvXITrgY4V1RAoZzTn8YbqICmse9Equ/yrC6byOZxffr7+O2MEMEQWOZZSKZuUash+zKuT2eIAlPVUwbXegJf7F/rrPSYQR4IeguLYLBNYPIQeJNK/pGd9qqgrnzJCVEtHSM7gmgxflLz1aF9uYyAasyjXwarXoz1Vlqd0fW/cGeBESi6v/ij7fKh46IK1PUTnTbhFoM+0Ypui5CpMsi4IKg1cjGZOXctIY2ErGo8Kk1QYXXX/gwOJYlvapJTIy/bwNrk16fpRo0DD8/DBXdmKeIS1zXCG2aHPm95ggVEJVUjv6/o0lweupaPhI8X9Blhjb9FGTc/UxcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=00kthKCbCN1fMi/pMj0DPXhjKYDAHAKc5sriJyHfTkI=;
 b=jj0nwZ4i6gMuTcWGeEebcuivE9pzhrrh0MpXlN1wCgqhlrYmkJIz2psKDnpJeq7JOy2gi+ZR5oDZTEnXwmIzuOS8FkGwclugi6Rmy5RVc2mREFbmcPdbkVw+HmSH7bXfF1hQDnB9BIql9G0q0QlbMfbHgmh6OpvPTwg4XCg8iRebYTzJfd81TZQB27kvf2iFk9Zc3GaTxQZkMwwmKmGVAvmos1Url2M+wh43ZZ6/YngiuZXilQ7jfylnervaVpNK4tSbeAxw8t2Sg9p6j1YjDbxDcpGp1E/5ue3SS+t3NlAX1rYdkh9SMPWhQdC06g9gb1CVJE9mHTHVlyeFPYo1ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=00kthKCbCN1fMi/pMj0DPXhjKYDAHAKc5sriJyHfTkI=;
 b=G+l0ZF9iM16tqj2BTgXCnQiBiV4xenhbXUabUl9OUqG1wR2GlVsTCQOTAiiQWP9SOamZZuLjb8wDgw3uW0rKXt95lXgyC2GiMnZ3gyigwvfNl18oM1ElZTRmp5GkoDMQlu/d3LhlN1TwWbJVMgMSKSzruicwyq/cvzLZD9q5oZU=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2821.namprd15.prod.outlook.com (2603:10b6:a03:15d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Wed, 29 Apr
 2020 01:27:36 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2937.023; Wed, 29 Apr 2020
 01:27:36 +0000
Subject: Re: [PATCH bpf-next v1 04/19] bpf: allow loading of a bpf_iter
 program
To:     Martin KaFai Lau <kafai@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
References: <20200427201235.2994549-1-yhs@fb.com>
 <20200427201239.2994896-1-yhs@fb.com>
 <20200429005415.x2ocuctowbagpkaw@kafai-mbp>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <fc39b19f-8540-c567-11be-651dfcf7895f@fb.com>
Date:   Tue, 28 Apr 2020 18:27:32 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <20200429005415.x2ocuctowbagpkaw@kafai-mbp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR16CA0059.namprd16.prod.outlook.com
 (2603:10b6:907:1::36) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:2258) by MW2PR16CA0059.namprd16.prod.outlook.com (2603:10b6:907:1::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Wed, 29 Apr 2020 01:27:35 +0000
X-Originating-IP: [2620:10d:c090:400::5:2258]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 64828fe4-d2ef-4859-4f24-08d7ebdc7f7e
X-MS-TrafficTypeDiagnostic: BYAPR15MB2821:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB282181A912AFDDEFB6DFD2EED3AD0@BYAPR15MB2821.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 03883BD916
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(376002)(136003)(366004)(396003)(39860400002)(4326008)(16526019)(66946007)(66476007)(478600001)(5660300002)(6486002)(37006003)(8936002)(53546011)(8676002)(186003)(66556008)(52116002)(2616005)(6506007)(6862004)(6512007)(36756003)(31696002)(2906002)(316002)(6666004)(6636002)(31686004)(86362001)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ef1gxUaKODtNx3RxDBtlQK2doEiWst8sUvYDY8UVUAAhUJaT5zNQ2p4Nw1Igu3nRoL2Zyg87iTo1cj0VHVHDqwolVko5OttewIX4nzK4GPbrOPEnxwY/7iWgfEBfXNVp6RyKRdQvyXcf+KI//BQPr5xzemXE9beVlP9Nq0aOf1jh7wHNYS+0Qenqs1ctecIt10/dwG0oUyBTJ55Mc4Z5TWqxj98919QDz6uyRJ81/8iKxyu0ShqoYGqheVAJ8FwJobHO5GX3vk9DPWZKAfz8XobqkQMG3GBfAkNMFPX8pzdiLuNfYBXL3s/v8ruAOX/YYy7HPsD2lKvnzL/oMtMk5biClNZUKhH8mUmQOaX4FwZ+XciBIN/aoaL9TrLtCRZ7jYc1Ev9Qu7R6fpdmrVx4LjE5eic2Iv2IuRdxUgGSNrXJTNAwEP5XoZ1YnXr1UMd+
X-MS-Exchange-AntiSpam-MessageData: cC9hyEQyfNxgEVAWKsKUj2Y/G7r859A8/1t9r4m7uwAQPyxtAKwgOrE/iBHsrmPukmELmeNR9z1Z8jL106DXc7ZI1WMaGfIEu3ylJZCv4hMeJlc6eTnRu6/Yw4XKlzC4rVPAiewp1ObObDeJSYoKg2XhI6dbgPVK9rl/T6vZ25UR7YJW9wQJZWKJRvl4vd+Cgq7jZxGnV2YpB/ffWTXD0cZK+hprVK5HUQXGR/Ed8n1W2qpRXnnixHlMid8XxvlcwgbDzIu4keL+KdB5Gxx8G6T88KJbwp4AZrOQe/k3QNjTOiw8Cdm9nlOJdC7Otq+NJubRX8NiLZWbUv0XY/SG/404tItk4WXelF17RJms+w/XUqZDTs/5P66fIdGtIzYq96Srdfu3Ns7MSyYvyQ8hq4MddGxuUVCW5+/4+MKghEcTy8m7usjMimu0jtaB7ZpKi6wBalggBmxGABgH98Njrp5PI8QO1BSJkxvWSFenCFGnbFrjYQJH+5qOvZ6Nut4YvE6eqfIZGqaGYPjVcLGQCi20ysYLKrO9JxjtxupZII1ru3CX+y2lATvbkQ/oT5tbaSTv1Gr6VmTTws2SDQKfV/WiKSicBic2bwWeF04ss9w3z8IlHSrB+mSAvfhmhBVkpejmnoIqfwVoecpQxJFfwqrp+2VqNrpCQo2ibbBZcX99gI6TukcOXVj8ZZRB5M2O1yB+3m8GcZss/Rr2wYGX+wLzRpphQhm5HVQ/i6HOtOciowNbTQ6uKp5r+w0sBBvffFA/mCXqDAYkn9sNHxfzwZRUypBBSVqnpxp3OTrnFG+ecki/qo8YVmWA8ZIBpw5X9ZF73dtrKAcwAQOwSwaCPg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 64828fe4-d2ef-4859-4f24-08d7ebdc7f7e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2020 01:27:36.2690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X5yTHikGJ+rWqM0fFSJFp8LQikIqmtz5Y1Pt+0/3gHS6TVUHJmuQFG7m1QlSQcY/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2821
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-28_15:2020-04-28,2020-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 adultscore=0 priorityscore=1501 spamscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004290009
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/28/20 5:54 PM, Martin KaFai Lau wrote:
> On Mon, Apr 27, 2020 at 01:12:39PM -0700, Yonghong Song wrote:
>> A bpf_iter program is a tracing program with attach type
>> BPF_TRACE_ITER. The load attribute
>>    attach_btf_id
>> is used by the verifier against a particular kernel function,
>> e.g., __bpf_iter__bpf_map in our previous bpf_map iterator.
>>
>> The program return value must be 0 for now. In the
>> future, other return values may be used for filtering or
>> teminating the iterator.
>>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
>>   include/uapi/linux/bpf.h       |  1 +
>>   kernel/bpf/verifier.c          | 20 ++++++++++++++++++++
>>   tools/include/uapi/linux/bpf.h |  1 +
>>   3 files changed, 22 insertions(+)
>>
>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> index 4a6c47f3febe..f39b9fec37ab 100644
>> --- a/include/uapi/linux/bpf.h
>> +++ b/include/uapi/linux/bpf.h
>> @@ -215,6 +215,7 @@ enum bpf_attach_type {
>>   	BPF_TRACE_FEXIT,
>>   	BPF_MODIFY_RETURN,
>>   	BPF_LSM_MAC,
>> +	BPF_TRACE_ITER,
>>   	__MAX_BPF_ATTACH_TYPE
>>   };
>>   
>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>> index 91728e0f27eb..fd36c22685d9 100644
>> --- a/kernel/bpf/verifier.c
>> +++ b/kernel/bpf/verifier.c
>> @@ -7074,6 +7074,11 @@ static int check_return_code(struct bpf_verifier_env *env)
>>   			return 0;
>>   		range = tnum_const(0);
>>   		break;
>> +	case BPF_PROG_TYPE_TRACING:
>> +		if (env->prog->expected_attach_type != BPF_TRACE_ITER)
>> +			return 0;
>> +		range = tnum_const(0);
>> +		break;
>>   	default:
>>   		return 0;
>>   	}
>> @@ -10454,6 +10459,7 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
>>   	struct bpf_prog *tgt_prog = prog->aux->linked_prog;
>>   	u32 btf_id = prog->aux->attach_btf_id;
>>   	const char prefix[] = "btf_trace_";
>> +	struct btf_func_model fmodel;
>>   	int ret = 0, subprog = -1, i;
>>   	struct bpf_trampoline *tr;
>>   	const struct btf_type *t;
>> @@ -10595,6 +10601,20 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
>>   		prog->aux->attach_func_proto = t;
>>   		prog->aux->attach_btf_trace = true;
>>   		return 0;
>> +	case BPF_TRACE_ITER:
>> +		if (!btf_type_is_func(t)) {
>> +			verbose(env, "attach_btf_id %u is not a function\n",
>> +				btf_id);
>> +			return -EINVAL;
>> +		}
>> +		t = btf_type_by_id(btf, t->type);
>> +		if (!btf_type_is_func_proto(t))
> Other than the type tests,
> to ensure the attach_btf_id is a supported bpf_iter target,
> should the prog be checked against the target list
> ("struct list_head targets") here also during the prog load time?

This is a good question. In my RFC v2, I did this, checking against
registered targets (essentially, program loading + attaching to the target).

In this version, program loading and attaching are separated.
   - program loading: against btf_id
   - attaching: linking bpf program to target
     current linking parameter only bpf_program, but later on
     there may be additional parameters like map_id, pid, cgroup_id
     etc. for tailoring the iterator behavior.

This seems having a better separation. Agreed that checking
at load time may return error earlier instead at link_create
time. Let me think about this.


> 
>> +			return -EINVAL;
>> +		prog->aux->attach_func_name = tname;
>> +		prog->aux->attach_func_proto = t;
>> +		ret = btf_distill_func_proto(&env->log, btf, t,
>> +					     tname, &fmodel);
>> +		return ret;
>>   	default:
>>   		if (!prog_extension)
>>   			return -EINVAL;

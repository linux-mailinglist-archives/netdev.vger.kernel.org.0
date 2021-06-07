Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B675039E7B5
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 21:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbhFGTpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 15:45:33 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47550 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230311AbhFGTpc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 15:45:32 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 157JfO9R008493;
        Mon, 7 Jun 2021 12:42:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=QywCyMzE8Jdoo07Y6HDcCxy/K5PjGxFCoOb61mMHARc=;
 b=fzdMn5dZMFKZz62qtd9Y4AGuQKRKCDqZleT1Ll3LbHroB+oiyPG8S3OMUn+lvjjhQmt7
 AWZBZzvc90A/AlP/DT1N2fPdEETj2I5XAFs9L5QSsfWW78iKM/KFFbJC9bXnXw56gf48
 6RJHg8DiOaEcywYzKSPkEf++PyaROUjhk2k= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 390s3xysk6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 07 Jun 2021 12:42:56 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 7 Jun 2021 12:42:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AaST97PBMMASQ4lAy+PAdWeYywPGjj55JBvswbetMHL+3nuJ9h1PSLeOkYH7vDUCkmfEG8QJyHYMx4A6YP1UOl0dK4AsSl9ILc/3Jy12yatIdfsxQ13npz0Vhsi1TsESZ+IttkCTdJbQf6rhWCjObHrF7xTa7XamEgiUyUivnVORyLJXPR3FIgtzH3teqkQDk3EKIld18Fwxqj6xknuhWiGoHs33ZsifLCK286BLq2SuGGPY4CpIepU/aQnatUfcYtwoGXNctrVsAV831wsS9NQHzl1OQ1xi5QyMkDKqdBjSDsNwIG5DxFQwecGVphDC27/7XepqaEbgTw6ySFGJWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QywCyMzE8Jdoo07Y6HDcCxy/K5PjGxFCoOb61mMHARc=;
 b=fINalRV/XYPmoEWcAPPNGF/UMH6w8tiS2w8dEMNZ+L65v3Lvy2Z/PoKPoBETGFPDCqVIJtt5UBIa4GOsioplix9rd+smPvgZrHme/gVYcmUe/1zzHwc3uC0w0yj9HmmNh2JhxLWb+Han5/weB/HX5ehHxL3UDHVbcdUbnAWGjXUNgJRNJVEKmcFWSzdIKgCtRWdU+sa1wyGsWpECl68R9MpXXEzKwspG5wiFNhkqVlySR4bUOz9dtQ+Q0cQSJZmFYZ8ftx8vK7ozhcGw4ndd6nF2WDkHJ6CS5dM8gJ0gCBIFoPq7Foe7v78Cx7eqEj9ARBeajmUdd7agLcP7Qvy4yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4871.namprd15.prod.outlook.com (2603:10b6:806:1d2::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Mon, 7 Jun
 2021 19:42:54 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906%5]) with mapi id 15.20.4195.030; Mon, 7 Jun 2021
 19:42:54 +0000
Subject: Re: [PATCH 15/19] libbpf: Add support to link multi func tracing
 program
To:     Jiri Olsa <jolsa@redhat.com>
CC:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
References: <20210605111034.1810858-1-jolsa@kernel.org>
 <20210605111034.1810858-16-jolsa@kernel.org>
 <50f92d1e-1138-656c-4318-8fecf61f2025@fb.com> <YL5lYPJdx5mmd06F@krava>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <a96ca297-ecc3-2bb7-6f76-97d541cd90e5@fb.com>
Date:   Mon, 7 Jun 2021 12:42:51 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <YL5lYPJdx5mmd06F@krava>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:db22]
X-ClientProxiedBy: BYAPR04CA0025.namprd04.prod.outlook.com
 (2603:10b6:a03:40::38) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::1097] (2620:10d:c090:400::5:db22) by BYAPR04CA0025.namprd04.prod.outlook.com (2603:10b6:a03:40::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Mon, 7 Jun 2021 19:42:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e958471-8413-4595-7d66-08d929ec714e
X-MS-TrafficTypeDiagnostic: SA1PR15MB4871:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB48716FAD3E006D26459765D0D3389@SA1PR15MB4871.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e5SQnCHfumrul9N3aoeNtXgCkfhZtY5vPtp4v/FRJ6JUNv5mwW2HUepMDs84Kb+/fgXCMEtFdyBCPKsriG9+GyQ62Qj9nngSX9ohQJ+dt1zpXd3TGMEZxgdEQbpMBgxn39ft3O9G4IauA3wk9GCq8Kk9kaYf7bFw6hviK5G5BRFlQ+qCU1aoHyigVLkdFIkXPrHu0KzusPK8OC5LitQokFi2rIv2L1phI27QHCVWliWGyzF9JNfnTI0fFrhL+OdCnmL2vKWDZzPMRDrmCLsi5FVkuauqq99mlLaIGW61DY1KB7Si6vtSA9vr83PSxPX4hk+d0LE0JFQQIXCA0bQuO+cTsgAEBTfSI7Svpmq+ROGl4Zp7jojHEKGkGVSI4gKpccV5ku7Zk0SnXYIqzOS7Z3t4Vge1ZBmYWuT2U0Z85ZCBEtSN+wdUykxAft3srpiA7pkn0TqW868ILYULNGGv98X3x0OWoFlzpAptudL0orfPNxdz/MAqv3/nbKW/sAqEFiuKE4yO6w0tJ9kUFRS2HMq3zszfG+g0GsgioqDKWkZkVqZFd+UapBQZwm9UEmH81Irml7E1o/Eho+diqB0ni+6rfNJE+nZ4Jys0XdZam71JdZwoGVCiMWd9ddbJt7S0bRyVUwm5smwWwRqy7OLkOY0qeqgG2y38qSAz/rxLyPFMKDOSbm5H6VJFGeyBv+wP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(346002)(376002)(366004)(31686004)(316002)(2616005)(7416002)(16526019)(186003)(52116002)(8676002)(54906003)(53546011)(8936002)(4326008)(38100700002)(2906002)(5660300002)(31696002)(83380400001)(36756003)(66946007)(478600001)(66556008)(66476007)(6916009)(86362001)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MVdhTlQ4Z2o4N2IycFFaSEVSRGFOZW1NRU84KzMwaXo3OWtLSlRaaGNCcEZj?=
 =?utf-8?B?Umtlb0crai96d3Ruc3k2c3N1ek1BeEFhZUFIUE9sZTN1L2t0UEt6NW9MaHov?=
 =?utf-8?B?QXlhYTlQWnd6ZlZnYWNKSGh6d2lSNXlXYitaRTVraUpPRG4xSnVtSWdROUts?=
 =?utf-8?B?dUVJTElPSzFndFc5aGUzLzRuOWJlNm41c3ZjOHBUdUdNRzlEYUUzd1lVaXJW?=
 =?utf-8?B?aUtCejFIbG1FdnkvQ3NicS91TnIxbHAzaGw1SmRnMjd5VXZNQlY4M0NqWjlM?=
 =?utf-8?B?Smo0Yk9kdHBzanJaSmxKa0pMYnYrNlFaRDFEKzdtdHU0UHFDUlRzTit2QVJy?=
 =?utf-8?B?UWtsUGRHOWxDbUdiTXZzOHZnTVZmaENGVkJMTnV5c090dWxOTk1Sems2TUk0?=
 =?utf-8?B?NWRVdktOdjZQVWQvRS9GL1AxUnF3ckYrMmZEZ1JLeDQ3UGFOYnZMNGRZK3g1?=
 =?utf-8?B?akFHczN4ekhzTXVHK0czTDdyZ040dWp0ajBEbWlDR2l2aUVSYWNQa0dRWEhz?=
 =?utf-8?B?eThFNWhzVFRrT2krbHVQb0VEcXkzWlVXdmtuazh5MnNKOGVPekZDNWJ1bS9J?=
 =?utf-8?B?eGpnaE5vVjMrYzdNY24yRm1JZnpwNzJpVW8vNHBWTXJRbTg3SHg2eE9NNVV1?=
 =?utf-8?B?VENYNE95UVlHQ2E1ZlFJdnZBOEs4aEVGSHdvS3lFSFZsR3ZQbE15MlVEeTlq?=
 =?utf-8?B?QWtVVEtXeGt0OHVxV1hDdnNyS3lsTDlDNjMvZW81Z2t5SVQxY1cxU0xLTSs0?=
 =?utf-8?B?YlZEMlhpRDBjNzBkOWZ4N1A3ZjVvOHRRUEp6M0hYUzR3a2wxUE9HUUF4dU5i?=
 =?utf-8?B?T0psTUJUbGE2bDJ3RktvbWVNRnJsQ3pSUG5admpnWHJYaVV2VjBaeXZ6cDk5?=
 =?utf-8?B?d1k0WTh1Z0xCMVhlcnEzVlZmMzIyWFh3aFJDQmVXd01jdGppQlhzQTlEWWpP?=
 =?utf-8?B?OEs0cGxTQit5eWpkdHZocWZjejd1TVcvTDlKbE9TbmRmcllXRmZpc2FONGZp?=
 =?utf-8?B?bHNEa1M3QWFVVzVnbXhscHphc2dEeEVEb1JTRVlFd3U1V2s1ckI4d1M2Vnlh?=
 =?utf-8?B?M0phYXRTVXVnWnZVa0lMQkRGVVdqTVhPU2hNbExLa08vYURpNW00MUZCZzc4?=
 =?utf-8?B?bE5nQ2lhQ0ViSVQzOEJtTmlXQ3BvakVDL01ja2xJeXFkYkxYQ1JRVmlRTjFa?=
 =?utf-8?B?bW1mVkx5R2JJUW5jaEdZdWZLYnIvUFdzRWVjVGRMbitXQ0Q3cCszTlJhdTc0?=
 =?utf-8?B?ZXNRV3ZHSHlmSWl6cDNSQWlJL0pMS1REOU05eUVLSDVXRUVML21iNnFwZGg5?=
 =?utf-8?B?N0ExV3A5bzFhbkxScHNuT05nVkVaeU40aFpoaUJ2UlVSNG1JU2ZxQmJWMEw4?=
 =?utf-8?B?NWl3cjU0dlp1MnhyNVV4cDltbGtWVzhpUnhCSlBNeElvWUpwM1F6OTFMWUlo?=
 =?utf-8?B?SWdWQ2pQaWEwU2Q3U3ZDZFFZa0dzL3Y2YUdkMmJ5bytnUVRGRDZWVTkzSy9N?=
 =?utf-8?B?K05HaHBwNUhTZXdNUVpKaDRpMldwUU15NytaSTc4c0t3ZEp6MDdKVE1kcVpE?=
 =?utf-8?B?RGdCcWlVc29Db3drU2tqTHRXbkV2V0RDYThPeHpON29mNG1haHRGeG1iTE5Q?=
 =?utf-8?B?bjR1OVJVdC9jOWg2aWpPQ0tCK3JGN04rUGp2Y0RQSjcrU1FQV1FxaVBpc0ZH?=
 =?utf-8?B?QUxYSERhcTBsRXJtdnZiUm13TFpCNGk5cS9iRURnMW5zNXZnVE9CTmlhSlFl?=
 =?utf-8?B?cG5iUGI3OVo3WUExK0U5K1Z5Y2hBTXVVUzVYZ0YzZWttRis5ZVlBSkdxcTRR?=
 =?utf-8?Q?xXtDFJ4v2x4teUFGs4cl60NUnC0qcoz8JQ+jA=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e958471-8413-4595-7d66-08d929ec714e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2021 19:42:54.0685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tEvJHHBqbv6p3Duy+1gklllK6CoeR7WrmvhY/3j9evtQheaWU2FLO0xGr7h4Vu5Q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4871
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 9UCHFt_xQVxqFyfBPqh2tnNivN0_u-MO
X-Proofpoint-ORIG-GUID: 9UCHFt_xQVxqFyfBPqh2tnNivN0_u-MO
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-07_14:2021-06-04,2021-06-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 bulkscore=0 clxscore=1015 spamscore=0 impostorscore=0 lowpriorityscore=0
 mlxlogscore=999 adultscore=0 mlxscore=0 phishscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106070133
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/7/21 11:28 AM, Jiri Olsa wrote:
> On Sun, Jun 06, 2021 at 10:49:16PM -0700, Yonghong Song wrote:
>>
>>
>> On 6/5/21 4:10 AM, Jiri Olsa wrote:
>>> Adding support to link multi func tracing program
>>> through link_create interface.
>>>
>>> Adding special types for multi func programs:
>>>
>>>     fentry.multi
>>>     fexit.multi
>>>
>>> so you can define multi func programs like:
>>>
>>>     SEC("fentry.multi/bpf_fentry_test*")
>>>     int BPF_PROG(test1, unsigned long ip, __u64 a, __u64 b, __u64 c, __u64 d, __u64 e, __u64 f)
>>>
>>> that defines test1 to be attached to bpf_fentry_test* functions,
>>> and able to attach ip and 6 arguments.
>>>
>>> If functions are not specified the program needs to be attached
>>> manually.
>>>
>>> Adding new btf id related fields to bpf_link_create_opts and
>>> bpf_link_create to use them.
>>>
>>> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
>>> ---
>>>    tools/lib/bpf/bpf.c    | 11 ++++++-
>>>    tools/lib/bpf/bpf.h    |  4 ++-
>>>    tools/lib/bpf/libbpf.c | 72 ++++++++++++++++++++++++++++++++++++++++++
>>>    3 files changed, 85 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
>>> index 86dcac44f32f..da892737b522 100644
>>> --- a/tools/lib/bpf/bpf.c
>>> +++ b/tools/lib/bpf/bpf.c
>>> @@ -674,7 +674,8 @@ int bpf_link_create(int prog_fd, int target_fd,
>>>    		    enum bpf_attach_type attach_type,
>>>    		    const struct bpf_link_create_opts *opts)
>>>    {
>>> -	__u32 target_btf_id, iter_info_len;
>>> +	__u32 target_btf_id, iter_info_len, multi_btf_ids_cnt;
>>> +	__s32 *multi_btf_ids;
>>>    	union bpf_attr attr;
>>>    	int fd;
>> [...]
>>> @@ -9584,6 +9597,9 @@ static int libbpf_find_attach_btf_id(struct bpf_program *prog, int *btf_obj_fd,
>>>    	if (!name)
>>>    		return -EINVAL;
>>> +	if (prog->prog_flags & BPF_F_MULTI_FUNC)
>>> +		return 0;
>>> +
>>>    	for (i = 0; i < ARRAY_SIZE(section_defs); i++) {
>>>    		if (!section_defs[i].is_attach_btf)
>>>    			continue;
>>> @@ -10537,6 +10553,62 @@ static struct bpf_link *bpf_program__attach_btf_id(struct bpf_program *prog)
>>>    	return (struct bpf_link *)link;
>>>    }
>>> +static struct bpf_link *bpf_program__attach_multi(struct bpf_program *prog)
>>> +{
>>> +	char *pattern = prog->sec_name + prog->sec_def->len;
>>> +	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts);
>>> +	enum bpf_attach_type attach_type;
>>> +	int prog_fd, link_fd, cnt, err;
>>> +	struct bpf_link *link = NULL;
>>> +	__s32 *ids = NULL;
>>> +
>>> +	prog_fd = bpf_program__fd(prog);
>>> +	if (prog_fd < 0) {
>>> +		pr_warn("prog '%s': can't attach before loaded\n", prog->name);
>>> +		return ERR_PTR(-EINVAL);
>>> +	}
>>> +
>>> +	err = bpf_object__load_vmlinux_btf(prog->obj, true);
>>> +	if (err)
>>> +		return ERR_PTR(err);
>>> +
>>> +	cnt = btf__find_by_pattern_kind(prog->obj->btf_vmlinux, pattern,
>>> +					BTF_KIND_FUNC, &ids);
>>> +	if (cnt <= 0)
>>> +		return ERR_PTR(-EINVAL);
>>
>> In kernel, looks like we support cnt = 0, here we error out.
>> Should we also error out in the kernel if cnt == 0?
> 
> hum, I'm not what you mean.. what kernel code are you referring to?

I am referring to the following kernel code:

+static int bpf_tracing_multi_attach(struct bpf_prog *prog,
+				    const union bpf_attr *attr)
+{
+	void __user *ubtf_ids = u64_to_user_ptr(attr->link_create.multi_btf_ids);
+	u32 size, i, cnt = attr->link_create.multi_btf_ids_cnt;
+	struct bpf_tracing_multi_link *link = NULL;
+	struct bpf_link_primer link_primer;
+	struct bpf_trampoline *tr = NULL;
+	int err = -EINVAL;
+	u8 nr_args = 0;
+	u32 *btf_ids;
+
+	if (check_multi_prog_type(prog))
+		return -EINVAL;
+
+	size = cnt * sizeof(*btf_ids);
+	btf_ids = kmalloc(size, GFP_USER | __GFP_NOWARN);
+	if (!btf_ids)
+		return -ENOMEM;
+
+	err = -EFAULT;
+	if (ubtf_ids && copy_from_user(btf_ids, ubtf_ids, size))
+		goto out_free;
+
+	link = kzalloc(sizeof(*link), GFP_USER);
+	if (!link)
+		goto out_free;
+
+	for (i = 0; i < cnt; i++) {
+		struct bpf_attach_target_info tgt_info = {};
+
+		err = bpf_check_attach_target(NULL, prog, NULL, btf_ids[i],
+					      &tgt_info);
+		if (err)
+			goto out_free;
+
+		if (ftrace_set_filter_ip(&link->ops, tgt_info.tgt_addr, 0, 0))
+			goto out_free;
+
+		if (nr_args < tgt_info.fmodel.nr_args)
+			nr_args = tgt_info.fmodel.nr_args;
+	}
+
+	tr = bpf_trampoline_multi_alloc();
+	if (!tr)
+		goto out_free;
+
+	bpf_func_model_nargs(&tr->func.model, nr_args);
+
+	err = bpf_trampoline_link_prog(prog, tr);
+	if (err)
+		goto out_free;
+
+	err = register_ftrace_direct_multi(&link->ops, (unsigned long) 
tr->cur_image->image);
+	if (err)
+		goto out_free;
+
+	bpf_link_init(&link->link, BPF_LINK_TYPE_TRACING_MULTI,
+		      &bpf_tracing_multi_link_lops, prog);
+	link->attach_type = prog->expected_attach_type;
+
+	err = bpf_link_prime(&link->link, &link_primer);
+	if (err)
+		goto out_unlink;
+
+	link->tr = tr;
+	/* Take extra ref so we are even with progs added by link_update. */
+	bpf_prog_inc(prog);
+	return bpf_link_settle(&link_primer);
+
+out_unlink:
+	unregister_ftrace_direct_multi(&link->ops);
+out_free:
+	kfree(tr);
+	kfree(btf_ids);
+	kfree(link);
+	return err;
+}
+

Looks like cnt = 0 is okay in bpf_tracing_multi_attach().

> 
> thanks,
> jirka
> 

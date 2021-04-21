Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99394366D96
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 16:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239497AbhDUOGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 10:06:19 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:53518 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243259AbhDUOGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 10:06:16 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13LE2sIQ025031;
        Wed, 21 Apr 2021 07:05:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=CWrz4TrRdWMxYOSb61G4kW/Xj2OKWywNtMSQWmlJKrU=;
 b=RozDeTCyImbIH4RPr4hMUfDa6HSTqlyczRJPS6QJxXjsL8e5l1QBz98fR32M8Y0qoF7c
 43PkefTvkYqMDAl+ncdx5ae79fIcDHGsrSzt+j+150wUwEJxsgU+ttIbHjXobAuEYg3O
 TjxB9NUrtNqgeNX/648xOX+dLdRh7HJ/GdQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 382ksd8k2q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 21 Apr 2021 07:05:28 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 21 Apr 2021 07:05:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PvTonizhm9ZkV7/YVz34lBVY0Y/lShnCBLcHCc+tZn4TToa8VjvsTmQeRqNdKK+BaOZRiw0Q/O/Y6xbRDfOD2XcgM+xU9ccqhZloNVxWnZ5jQHyYv2mwCdAz6g6jVjhgt6gwQG7cTyEvQUufq/DEFvPCpFvlsA41zN14mMdRYOfTH9WDhOunyFp/V4aflwGe6EHbQDZOYwWssRUamgQQEVeggX8g+Ud/GbcSsvIB8up+jejDRznSa1sTv5FnaCkQUg2vl9QaBHbBJq+opsZbJONGKJdJ7CSd1uxR1BbtHM7hCqs7Fic0YZK8owhgIponmRiNizQ70ehGuHHc/R+xoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CWrz4TrRdWMxYOSb61G4kW/Xj2OKWywNtMSQWmlJKrU=;
 b=lFyMYLG1CAZGPkmBAqm0pWIYTvvh5hYlMAUUzffODsrrZTnITuEVF3f4GN/mdwmO8UWEfLFuf4SiNGTHHLfGs2PAfC8qMEGK/tpOTMiobbAhA6xtq4ncu7wuWrUm4IdLMdPyQpHiOzNttQ9VD2xzQRoJEN5jHTTYAH6uxECfDt7uCSU69xANbtvUeP/7RavrXzsdJw5Y07dJSPuxB5MaWXFnOF+4g3gc1QpO2FPCHMpWDbg27nytqBNVdeCPdY8xgmdOWXp/a4eawqLAkslGLFr3gHCENZjY+P1Bjz/vUQu/walsQ3/CuIaFMGUznz3EqrX9z16ltUouO7mJ3nSnbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4340.namprd15.prod.outlook.com (2603:10b6:806:1af::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Wed, 21 Apr
 2021 14:05:25 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4065.021; Wed, 21 Apr 2021
 14:05:25 +0000
Subject: Re: [PATCH bpf-next 13/15] libbpf: Generate loader program out of BPF
 ELF file.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     <davem@davemloft.net>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
References: <20210417033224.8063-1-alexei.starovoitov@gmail.com>
 <20210417033224.8063-14-alexei.starovoitov@gmail.com>
 <a63a54c3-e04a-e557-3fe1-dacfece1e359@fb.com>
 <20210421044643.mqb4lnbqtgxmkcl4@ast-mbp.dhcp.thefacebook.com>
 <2ff1a3d4-0aba-e678-d04c-621ab18b7dd0@fb.com>
 <20210421060608.ktllw2v3bhgd5pvm@ast-mbp.dhcp.thefacebook.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <01c72879-0f2e-fe3b-cb4b-5f0a899e4d5c@fb.com>
Date:   Wed, 21 Apr 2021 07:05:23 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210421060608.ktllw2v3bhgd5pvm@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:f2b4]
X-ClientProxiedBy: MWHPR15CA0048.namprd15.prod.outlook.com
 (2603:10b6:300:ad::34) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::137a] (2620:10d:c090:400::5:f2b4) by MWHPR15CA0048.namprd15.prod.outlook.com (2603:10b6:300:ad::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Wed, 21 Apr 2021 14:05:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 63202b9a-e66d-4d70-d358-08d904ce82dd
X-MS-TrafficTypeDiagnostic: SA1PR15MB4340:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB434030941357AEE677EC9A73D3479@SA1PR15MB4340.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xTS+9+qsRuS1nMZowdMy5XXQ6f923QO8mwYyP//dOcy0EQ8g5euJnpznbIX9N0I+OyxFz4Ml4r23nvmFln3Rh4Uvkfvuhwx2n62lIy2T/WNXY0FL0vWl7fNWflBaJmybNx63uyzgr9FLmM09KVZBb9LI9CB2jyoY82SNnWU0WHyHEI3oFSud5kliiIDkauql4NlgI5fAHpoEDnSqxq+L6PX7Xq0W9tzlF8Ka2HmfPAALFk+zC8wyLfUin8ZWfW46k5XyWLUjchTt34gosv3h/D7Ck8iHXerQ0/E6BLt8vK6vrtOWRCdkzHyDZwD1ZwxlC4nHuHswnEKX39s6wl4TClEGIVAw6Ex4f/TI3rUYPwkzn6+wZ0jGOX0KneeH1xDrA8bwIWIEUDHugFxA9trdv3A7/igRLIpd6Px0uj95Y7E/8AjUGWw7e+VnOpkpsF7FnHghcRN44mJfAVOlMU8d5jUzncbhwq7O9QL9l7Tj3nzJNc+wgDj3IndICp6wap8EL8xpAUGCdOc7TrmI4etcSDd1j51APkhlebacfFWxDr638go7eU3PPCfBuaCPJnh7wHVRTsgwyCZ63xFrrH8Ko9m74WTnmwbxzhsFCwodRSGmoOiLez6n1HfPUJJQoIc1a2AXiOYYMwLaaQfIC62DHZVtfJNC/xBfUIUyjQj7WfzPH2ACy/1CoCtaR91vidla
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(366004)(396003)(39860400002)(31696002)(52116002)(86362001)(2616005)(31686004)(66946007)(6486002)(478600001)(8936002)(6916009)(38100700002)(316002)(36756003)(16526019)(83380400001)(4326008)(186003)(66476007)(8676002)(2906002)(5660300002)(66556008)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UndqNHV0REdaY1J4U05lY3FQbWdjcC9QY0ZCQU9sc0xKWjdCZ29lUWRnVFhH?=
 =?utf-8?B?TTQ1V0UyVlgxWmxqdjlNdFl2UzlEMmE4bXNVTkZZQkFpOVZzWHgwajR1Rmlj?=
 =?utf-8?B?NHBDWVBkcGR0M2QzUXY5Y3NVVUM0SzVKclhIVUxYMWhnMGJXVXFQUXpZU3NL?=
 =?utf-8?B?UldORjF6SEJpZW82RW4yL0x4OGNvRUQzQ3Y2dHhvSXVaV1ozRnA3dk55a1Ez?=
 =?utf-8?B?d2dHNHg3YkZnc3RGVDQzdUdXbW0ralFnclM2OU8rQ3NIWU9aWng5Wm55OVBy?=
 =?utf-8?B?SUtvOVZSNXc2UWJOTjBILzdoMmxYN0N6cHVZSGtHdCttRXNtWHU2NnZaVjQx?=
 =?utf-8?B?VEZDLzh3NWkxSytwYXYxQlRqZ2hkeGZwUUk0V3dCVyt2czlGbG0ycFY0S2tN?=
 =?utf-8?B?R0tUdVEvZlJkbmgycW54ZFFuM3ZFbXVxMno1UnlmYlhYZlFNTk5MN2VmS056?=
 =?utf-8?B?aVUwS1lYREpYQ2hhd21IajR3Q0RGSkYwMWp4bjhGd05jYVRKQStPbmMwY0JK?=
 =?utf-8?B?RW9YSklSTnJaakk0TXhmQU12REFpZmVhMnRjQkZ4VEhKSlk1R1dKMllza2dS?=
 =?utf-8?B?MWxIcFliSzl6YVJmUDZvS2l5WmZlZnF2TzBGaDZ4aUYzWEFlT0dxOUpqSlVT?=
 =?utf-8?B?QUx0OHdhL3N3REkzSmZIOEVzVmpCUmdpd1RxdkUvK2IrWGx3SWdrMUc5cTFH?=
 =?utf-8?B?TXJWaVM2QTJsWlM4bmNld2JlQWhNQzdJdENyV09VczlIUEg4QjVJeXhFSGR6?=
 =?utf-8?B?SXM4NVFWMzFKWEN4VWgzZWYzM1ExTHdjSkVaTHFnUnRzUXQ0enV6ODJYeWxW?=
 =?utf-8?B?OGNTVTRnRkdBd0NXcjlickNGR2ZSZGVoMVZXU0k1YVVtc0ZCNUY4U0JYNXBz?=
 =?utf-8?B?S245cDBqa1hYNVNIbjRGbm84TXRQeFJxR00xbVJ0R1BnTTZwWG9OWDRaK2dT?=
 =?utf-8?B?T2ZSRUlpQnpqdGJFWHdhbExJbi9LVHo4d0Ivbk9nTExkQnJZSVJZYUpYb0tL?=
 =?utf-8?B?SzFsd3RHcEtnYWlIK0hmLzU2cG5WUEx1TVlQUktPdmdJakJPSnNJQTc4TUJk?=
 =?utf-8?B?ZXp6Y3hxajlJMFY2cThyRzdmS2t0cE5zaFpqeTdJKy9vZXdJUDRJNXpONU13?=
 =?utf-8?B?MEY5T09QNFY1SDVBazVWTXZVMnFIY0huNmVTMGkydDJOeUR2RXhBamg3cS84?=
 =?utf-8?B?MkdHNGlpODVteVU1akRiTDlaTGVyb2lSTHdycHlVaGZkdGl4UXkyQWRRYlJl?=
 =?utf-8?B?bXpWNUI3WFlXaEdrR2JhbGZZRCtVWEJleHVxRjlPVmxZNytkaVZFa1dzbGxU?=
 =?utf-8?B?K3MrTS94THRuT1B2WWQ5R25TUHpFUy9RRHZmWUp0RE8zRExXd1RvamgwVG1T?=
 =?utf-8?B?dlN4L3VSZ1JraWc1WHJFZkk2VHd1MVljT0d3Z1FreVE4L3Qwc1VTVmc1dmVE?=
 =?utf-8?B?Wnh4QkZQNGh4azBYZHhNU29UeW5FbTB1SmJqQTByTUVnREtJdExkNENGNmRh?=
 =?utf-8?B?dnZVV1psZVgrQTVzUTRCUUo1bDY5UU5idXJPK0ZEY2JobjVaMWMyVVd0VHB5?=
 =?utf-8?B?cGMrS21hOWNzQ1kzOGR6bzRhTFQ5bjNhNXpKVnczQ2NSM2ZDTTg1RC9BVG1T?=
 =?utf-8?B?S2VWbTdzL2tycUF3YlVUamF1ZlBDTU12R2tNMklpWmo4cTB6QWlRMEw0a2RZ?=
 =?utf-8?B?NGorTm9lQmtWMHROcmJmSWJZSEE0OEl1bEtWYjJITUlEb3oxNFdoNTVIaHYz?=
 =?utf-8?B?S0ozKzN3ZUE4QkVma2poZXFidEZxdE5SRUhQcEwveHZXWWpBcjZBRGVhbmJY?=
 =?utf-8?B?cDhnS3Nrdng4Y284Y0hPZz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 63202b9a-e66d-4d70-d358-08d904ce82dd
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2021 14:05:25.7074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fKWH+ZhY6Jscyq3q7a7KclFbCOQlwbiLJht+UBOP7R6ZkqWD9IVrXxhdSHjD/txA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4340
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 5syLHnDFl-hkmPBNCa82n-Twzn0AW6up
X-Proofpoint-ORIG-GUID: 5syLHnDFl-hkmPBNCa82n-Twzn0AW6up
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-21_04:2021-04-21,2021-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 phishscore=0
 mlxlogscore=999 lowpriorityscore=0 suspectscore=0 malwarescore=0
 bulkscore=0 priorityscore=1501 clxscore=1015 mlxscore=0 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104210110
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/20/21 11:06 PM, Alexei Starovoitov wrote:
> On Tue, Apr 20, 2021 at 10:30:21PM -0700, Yonghong Song wrote:
>>>>> +
>>>>> +static int bpf_gen__realloc_data_buf(struct bpf_gen *gen, __u32 size)
>>>>
>>>> Maybe change the return type to size_t? Esp. in the below
>>>> we have off + size > UINT32_MAX.
>>>
>>> return type? it's 0 or error. you mean argument type?
>>> I think u32 is better. The prog size and all other ways
>>> the bpf_gen__add_data is called with 32-bit values.
>>
>> Sorry, I mean
>>
>> +static int bpf_gen__add_data(struct bpf_gen *gen, const void *data, __u32
>> size)
>>
>> Since we allow off + size could be close to UINT32_MAX,
>> maybe bpf_gen__add_data should return __u32 instead of int.
> 
> ahh. that makes sense.
> 
>>> This helper is only used as mark_feat_supported(FEAT_FD_IDX)
>>> to tell libbpf that it shouldn't probe anything.
>>> Otherwise probing via prog_load screw up gen_trace completely.
>>> May be it will be mark_all_feat_supported(void), but that seems less flexible.
>>
>> Maybe add some comments here to explain why marking explicit supported
>> instead if probing?
> 
> will do.
> 
>>>
>>>>> @@ -9383,7 +9512,13 @@ static int libbpf_find_attach_btf_id(struct bpf_program *prog, int *btf_obj_fd,
>>>>>     	}
>>>>>     	/* kernel/module BTF ID */
>>>>> -	err = find_kernel_btf_id(prog->obj, attach_name, attach_type, btf_obj_fd, btf_type_id);
>>>>> +	if (prog->obj->gen_trace) {
>>>>> +		bpf_gen__record_find_name(prog->obj->gen_trace, attach_name, attach_type);
>>>>> +		*btf_obj_fd = 0;
>>>>> +		*btf_type_id = 1;
>>>>
>>>> We have quite some codes like this and may add more to support more
>>>> features. I am wondering whether we could have some kind of callbacks
>>>> to make the code more streamlined. But I am not sure how easy it is.
>>>
>>> you mean find_kernel_btf_id() in general?
>>> This 'find' operation is translated differently for
>>> prog name as seen in this hunk via bpf_gen__record_find_name()
>>> and via bpf_gen__record_extern() in another place.
>>> For libbpf it's all find_kernel_btf_id(), but semantically they are different,
>>> so they cannot map as-is to gen trace bpf_gen__find_kernel_btf_id (if there was
>>> such thing).
>>> Because such 'generic' callback wouldn't convey the meaning of what to do
>>> with the result of the find.
>>
>> I mean like calling
>>      err = obj->ops->find_kernel_btf_id(...)
>> where gen_trace and normal libbpf all registers their own callback functions
>> for find_kernel_btf_id(). Similar ideas can be applied to
>> other places or not. Not 100% sure this is the best approach or not,
>> just want to bring it up for discussion.
> 
> What args that 'ops->find_kernel_btf_id' will have?
> If it's done as-is with btf_obj_fd, btf_type_id pointers to store the results
> how libbpf will invoke it?
> Where this destination pointers point to?
> In one case the desitination is btf_id inside bpf_attr to load a prog.
> In other case the destination is a btf_id inside bpf_insn ld_imm64.
> In other case it could be different bpf_insn.
> That's what I meant that semantical context matters
> and cannot be expressed a single callback.
> bpf_gen__record_find_name vs bpf_gen__record_extern have this semantical
> difference builtin into their names. They will be called by libbpf differently.
> 
> If you mean to allow to specify all such callbacks via ops and indirect
> pointers instead of specific bpf_gen__foo/bar callbacks then it's certainly
> doable I just don't see a use case for it. No one bothered to do this
> kind of 'strace of libbpf'. It's also not exactly an strace. It's
> recording the sequence of events that libbpf is doing.
> Consider patch 12. It changes the order of
> bpf_object__relocate_data and text. It doesn't call any new bpf_gen__ methods.
> But the data these methods will see later is different. In this case they will
> see relo->insn_idx that is correct for the whole 'main' program after
> subprogs were appended to the end instead of relo->insn_idx that points
> within a given subprog.
> So this gen_trace logic is very tightly built around libbpf loading
> internals and will change in the future as more features will be supported
> by this loader prog (like CO-RE).
> Hence I don't think 'callback' idea fits here, since callback assumes
> generic infra that will likely stay. Whereas here bpf_gen__ methods
> are more like tracepoints inside libbpf that will be added and removed.
> Nothing stable about them.
> If this loader prog logic was built from scratch it probably would be different.
> It would just parse elf and relocate text and data.
> It would certainly not have hacks like "*btf_obj_fd = 0; *btf_type_id = 1;"
> They're only there to avoid changing every check inside libbpf that
> assumes that if a helper succeeded these values are valid.
> Like if map_create is a success the resulting fd != -1.
> The alternative is to do 'if (obj->gen_trace)' in a lot more places
> which looks less appealing. I hope to reduce the number of such hacks, of course.

Thanks for explanation. Agree that gen_trace and non-gen_trace are two
totally actions as you said. Trying to reduce the number of hacks
will make codes better too.

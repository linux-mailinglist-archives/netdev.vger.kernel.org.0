Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA0123664DB
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 07:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235162AbhDUFbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 01:31:18 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52000 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230516AbhDUFbQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 01:31:16 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13L5USG5009496;
        Tue, 20 Apr 2021 22:30:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=jH6s/rWSaku/eb+1IAVgyrMpJ74n4XWJFBqO0Od7Dsk=;
 b=bXgaD9sLd67Um2Hzcn5iW3FW/2d7kZh+ibkGG3kDqrzwp4iXeu9D/2ou847/3t4yYMYE
 QN+/d9P8q1pVz2ZxhKs+aZ/Stv+27pxGMv4IN8pcCEGxEa3/N9TcFW3szEF+SVAChX18
 ca+4GIHJlQ4BqtaWMuE7Ze4rWFr82F1BCBg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 382dq9r1kf-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 20 Apr 2021 22:30:28 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 20 Apr 2021 22:30:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dj1agg4Ef/6uU7QxHKY7rIwSttQGvmL451K77ip2P+i4cNlhKoWh+RAr5qHBke/m5n0AEYhBPl4qTbWeRuTAAs6rkDiTO5z18t4g0TAlAM9RvRGhoskhucQk6bgxrXQl7ENgrFqt0mR7HW8flsuUf8Uhc1R6vbkmV90/sAdStWJnMbN74NoqvQ6heYc8/Ky+6d0zc1vK6/nUuEhmGiqElJPKYHBu/PSmboATOO9CrP//q/wnYm9jpdGFdbM5dThy3BchMl7ppYYyx7wXeUD07Y+ZJKCHdeIr99dl0V3M1qM9GPVDxfmNpnHg+kghk1O9BtMalW4KcLYt/fWskvequA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jH6s/rWSaku/eb+1IAVgyrMpJ74n4XWJFBqO0Od7Dsk=;
 b=ax0GXJ3BL8G0Xv/WVAWjT7CJbTJwKCGNmuq5fzFgkpA7zN/Q1+F44lJQynxdqE8cCQgAqz8Ti4QeqBjGWyQjUloFLctpL/PmPXSiDsVwy7gVOghYElSupHGLAkI61uFEbhUNS6qBxsnipbt7p1rkGrt69yitEwYBAXYDWUOBqD8Og07VNXK5zhXFLn4ERV3XSy6iavTuJq8bXx25DViBU4SRckxccKKPBgZSAz88oaTikIfGVYj/l0EGnAtpqDVrV1yeDBu2CBH2MHwnnOANPHmI5LQA8FV5Su6uqHxJ12js9wQnzzIgNqRBZVdkz+SSpVK1O1MVxm62gP3nQK+2nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA0PR15MB4046.namprd15.prod.outlook.com (2603:10b6:806:8d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Wed, 21 Apr
 2021 05:30:24 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4042.024; Wed, 21 Apr 2021
 05:30:24 +0000
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
From:   Yonghong Song <yhs@fb.com>
Message-ID: <2ff1a3d4-0aba-e678-d04c-621ab18b7dd0@fb.com>
Date:   Tue, 20 Apr 2021 22:30:21 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210421044643.mqb4lnbqtgxmkcl4@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:d87c]
X-ClientProxiedBy: MWHPR14CA0054.namprd14.prod.outlook.com
 (2603:10b6:300:81::16) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::137a] (2620:10d:c090:400::5:d87c) by MWHPR14CA0054.namprd14.prod.outlook.com (2603:10b6:300:81::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Wed, 21 Apr 2021 05:30:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dd5e007d-11db-4925-e7e9-08d904869041
X-MS-TrafficTypeDiagnostic: SA0PR15MB4046:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR15MB404624AD16F97A0089F246B6D3479@SA0PR15MB4046.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b0uv/Hb578lNn3LLgXKh4dzKRz/thYnlQFGX22kw0+Faq/Aa1lkcry5k18I0z4/MXhHS/xBco1qVMqpzvAXWnLysDG7do6YTD4QJW3phSNqwCLGrtTHsmLV8bj84INTPfWaX2X8OZcwZEbFU1/LdVsIVKSI0C+bvk/WLWiu8WyoW0/Fj+Z2vxXOK3ppBGPMRZD7i97lNg32WqeGlMLT/9HZm7mMZuUYE4j7KQRlvKwfqth3Jhf5zg8tnyVBq2uPh6XuRDFkxyr02aHCcRp9yPzfZSex8BjzjL9EjnluEjpPmp221D/Fr09lZ431vE15rW1febFmIB6ETQ4ZfF+jA8vEYaBLJsY95DcOcUt9CwBDg8HJqO9TPXFkWOOMTVamqDYlpb+lokRgsk7kSNx5Wb3jFBSL1gyg4BaaIQf7hdbsGBIJYG1QEXhRHvWDRsVuleU6KrHmN4OTHGxDpJqG22w4XNeyYZD5OHYjEtR49EM9tzfvSpVyJUdHfbo3D5YnRwapUGNpQ/A/KEBNyETW8MM6H9yqoG0zOLwOjM9b4sCIIqDFCt1y0HZfiAHdTtgR5nSPU4YViLHONHS9uqrsmERe1KZdzfZjGe9MArjSmsRIiBLT5vnks4vHfAoGsiMg19Fs3i4dKtQa/Rl3UtD0b9XoXtgu2gvqooIZnfSUVxHYmI3OEf3s7/KUyL3a3NYnK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2906002)(5660300002)(498600001)(6486002)(38100700002)(66946007)(31686004)(186003)(6916009)(86362001)(16526019)(8676002)(4326008)(53546011)(52116002)(31696002)(83380400001)(30864003)(2616005)(36756003)(66556008)(66476007)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eHMwME9TWkZ0MnJscFNaY01vR29XWnowa05kNVlQbXR6OE8veDBhVVZqcFl2?=
 =?utf-8?B?bFBKWkNrcTcyZU00VDVvaUFacGVUclFyV09JYjVDR29Ca3krcXBhNzlkbWkr?=
 =?utf-8?B?UTNwRDMyWnBaakI4SitnemZmNzUzZmVoNEo4NmlWeTQ3S3BSdGZ6eUdidlV2?=
 =?utf-8?B?OXBhdDh1cGdYR2lYS0U5U3RJbEpvQTFkM3c3MVZBZ3Vqdmk1OEEyWDdneWhl?=
 =?utf-8?B?N1huVmlqWFFyMm50eS85blMwYnN1RXN0N0ticmNOKzRBcjNXelg5NnBmN1hP?=
 =?utf-8?B?L3NkVHo4WFl0NE44bEFCSlkvdDRudjhRMjJFdVRtbXYvaE5uTkZHVVA0akxr?=
 =?utf-8?B?SDVINGswSmdhMmwvWmtxQllUK1gzcHRaT2FUME53ZHhMcHJnemdCaFMzcHk4?=
 =?utf-8?B?WTN5OUxWTUphM0lQTjEvcGxoM1ZRQUVsOHY1WjdjUkFpbmpCZGtvSmFxME9D?=
 =?utf-8?B?K1hBNFRseWhzN0NKMDhHT3k2NUt6eVUzN0lFdHdHalQwSThzYTlUdUpRQUF5?=
 =?utf-8?B?UFhZbDF6K0MrNGRtNUJmVDcvSXZjN2hsUUpzaTNzWCtSSTExMk1lTjVQYmZI?=
 =?utf-8?B?V0JiRSt6WGMvMmdocndDRk9TNWU3d3IrVXZlelE1TGhCMGYxdnUxcys5bk5T?=
 =?utf-8?B?MmwzTUtZd2NBb3hkZVBkcXNFaHpna1A0Vm9uYlhLcmhmMm5UVlQ3RUZSd2M3?=
 =?utf-8?B?SjRGQnZWL1VUb1E3djRMcFZ2bk9Uekl2dC9XcDlXS1R0Tm82ZnhNWktKWW9V?=
 =?utf-8?B?Qy94NlhGckZhUkhnTzd1OGcvRHVNZkdMKzBYT3ZZOWlwYzI4ZWR5eEc0eUVx?=
 =?utf-8?B?alZqTFVoVjNVbCtxNlhRcnlhazF2ZEo3SkZhNEtMNFlzczFSdmhwaWdqZ1Zj?=
 =?utf-8?B?dzJkUlY1U0FUWEw1VGd2KzNRQ0JRQnA4dDJHZGkwYldDWDlLSVhlNC9OSEFx?=
 =?utf-8?B?NUZNSjVsQUU1MkJ5bkZCcEpCVUtKWk5keDRzR0JqYzR5cDl3YUhtZld6cmhm?=
 =?utf-8?B?Z2F1WmJ4b3JjVWlmNHB1NTg0UXpPL29uYytBaldMZWlnY2NqU2FjbEJBZWo5?=
 =?utf-8?B?RU90bms5Rkl1a080MjJURlhadDZwYXJPMEhhbm5wSStyOUR1V2VPVXNLbUN3?=
 =?utf-8?B?WXJSNklKYzRBZWUvd3dHM3gzQ2Q3MHJzeFMrTTN6ckt4UzJ4eWZQYVdvd1Nz?=
 =?utf-8?B?ZlZVbTJZajRTNkl2dlRVWE9KQWJNOGNDclZjbk1pWDcwZk12Z0s5OGF4MERK?=
 =?utf-8?B?aFJTbXNlVGdXSGxkL0EvVWFCeGhFWk9YdENXK3dxUTJ0Mm1hNjBSZC9QQTkw?=
 =?utf-8?B?clplTll1Mkx5WDdsVjlNTFFnVHNPeFNoY0RXamdRQksvSER5UWw1Q2p2a3BP?=
 =?utf-8?B?bloxQlhyNG93OEp0RGdQZGJ6dmlDalp1SkRyS1BzWDZpZSs5ZmNwM25HMWNq?=
 =?utf-8?B?QmZUOUJOZGwrWGF1dXBzRkRBdVlzd0U3TXhzNERjZldHYStNN3FTM0tsNDMw?=
 =?utf-8?B?QzI1S2g4a3EwTXp4UjVHSUpGb0tzWHRPeWR2NS9FRFc0STVxZktWbkRWY0Jv?=
 =?utf-8?B?dFNxQ1B0SGl3RjRhQ0FFN01aekg2S2JSUGVLTmxPNXcyREsvTjM0Y1FUdFEv?=
 =?utf-8?B?Vk84NWUrY2x3YXkxd0FQWjhyZ1JjNlFOenRyeTBuRTI1ZlMybWk2ME5YaE9S?=
 =?utf-8?B?ZS94UHVVekpNOHBlcHNPNGtKaWdENXRoQUI4R1NjKzFHdW1rd2N1VU5yZHhi?=
 =?utf-8?B?OTlnd0JsTHpVK1JrSE9Za1pLOGVTbmhzTnREM3B4cVRsSmd6Zk5XU3FQMU1p?=
 =?utf-8?B?REVIbXNRcnBTSVBJb080dz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dd5e007d-11db-4925-e7e9-08d904869041
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2021 05:30:24.3412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5vsNCCqLFzeyB18cJQT5RSrazBD/rNClJOy6IxYSNKQYO/9xZzMwrWUP1YKDUXER
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB4046
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 3RxpSZr_5FEvjKCBKHkCDHpf4bly545m
X-Proofpoint-ORIG-GUID: 3RxpSZr_5FEvjKCBKHkCDHpf4bly545m
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-20_11:2021-04-20,2021-04-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 malwarescore=0 mlxlogscore=999 impostorscore=0
 adultscore=0 suspectscore=0 spamscore=0 clxscore=1015 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104210045
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/20/21 9:46 PM, Alexei Starovoitov wrote:
> On Tue, Apr 20, 2021 at 06:34:11PM -0700, Yonghong Song wrote:
>>>
>>> kconfig, typeless ksym, struct_ops and CO-RE are not supported yet.
>>
>> Beyond this, currently libbpf has a lot of flexibility between prog open
>> and load, change program type, key/value size, pin maps, max_entries, reuse
>> map, etc. it is worthwhile to mention this in the cover letter.
>> It is possible that these changes may defeat the purpose of signing the
>> program though.
> 
> Right. We'd need to decide which ones are ok to change after signature
> verification. I think max_entries gotta be allowed, since tools
> actively change it. The other fields selftest change too, but I'm not sure
> it's a good thing to allow for signed progs. TBD.
> 
>>> +	if (gen->error)
>>> +		return -ENOMEM;
>>
>> return gen->error?
> 
> right
> 
>>> +	if (off + size > UINT32_MAX) {
>>> +		gen->error = -ERANGE;
>>> +		return -ERANGE;
>>> +	}
>>> +	gen->insn_start = realloc(gen->insn_start, off + size);
>>> +	if (!gen->insn_start) {
>>> +		gen->error = -ENOMEM;
>>> +		return -ENOMEM;
>>> +	}
>>> +	gen->insn_cur = gen->insn_start + off;
>>> +	return 0;
>>> +}
>>> +
>>> +static int bpf_gen__realloc_data_buf(struct bpf_gen *gen, __u32 size)
>>
>> Maybe change the return type to size_t? Esp. in the below
>> we have off + size > UINT32_MAX.
> 
> return type? it's 0 or error. you mean argument type?
> I think u32 is better. The prog size and all other ways
> the bpf_gen__add_data is called with 32-bit values.

Sorry, I mean

+static int bpf_gen__add_data(struct bpf_gen *gen, const void *data, 
__u32 size)

Since we allow off + size could be close to UINT32_MAX,
maybe bpf_gen__add_data should return __u32 instead of int.

> 
>>> +{
>>> +	size_t off = gen->data_cur - gen->data_start;
>>> +
>>> +	if (gen->error)
>>> +		return -ENOMEM;
>>
>> return gen->error?
> 
> right
> 
>>> +	if (off + size > UINT32_MAX) {
>>> +		gen->error = -ERANGE;
>>> +		return -ERANGE;
>>> +	}
>>> +	gen->data_start = realloc(gen->data_start, off + size);
>>> +	if (!gen->data_start) {
>>> +		gen->error = -ENOMEM;
>>> +		return -ENOMEM;
>>> +	}
>>> +	gen->data_cur = gen->data_start + off;
>>> +	return 0;
>>> +}
>>> +
>>> +static void bpf_gen__emit(struct bpf_gen *gen, struct bpf_insn insn)
>>> +{
>>> +	if (bpf_gen__realloc_insn_buf(gen, sizeof(insn)))
>>> +		return;
>>> +	memcpy(gen->insn_cur, &insn, sizeof(insn));
>>> +	gen->insn_cur += sizeof(insn);
>>> +}
>>> +
>>> +static void bpf_gen__emit2(struct bpf_gen *gen, struct bpf_insn insn1, struct bpf_insn insn2)
>>> +{
>>> +	bpf_gen__emit(gen, insn1);
>>> +	bpf_gen__emit(gen, insn2);
>>> +}
>>> +
>>> +void bpf_gen__init(struct bpf_gen *gen, int log_level)
>>> +{
>>> +	gen->log_level = log_level;
>>> +	bpf_gen__emit(gen, BPF_MOV64_REG(BPF_REG_6, BPF_REG_1));
>>> +	bpf_gen__emit(gen, BPF_ST_MEM(BPF_W, BPF_REG_10, stack_off(last_attach_btf_obj_fd), 0));
>>
>> Here we initialize last_attach_btf_obj_fd, do we need to initialize
>> last_btf_id?
> 
> Not sure why I inited it. Probably left over. I'll remove it.
> 
>>> +}
>>> +
>>> +static int bpf_gen__add_data(struct bpf_gen *gen, const void *data, __u32 size)
>>> +{
>>> +	void *prev;
>>> +
>>> +	if (bpf_gen__realloc_data_buf(gen, size))
>>> +		return 0;
>>> +	prev = gen->data_cur;
>>> +	memcpy(gen->data_cur, data, size);
>>> +	gen->data_cur += size;
>>> +	return prev - gen->data_start;
>>> +}
>>> +
>>> +static int insn_bytes_to_bpf_size(__u32 sz)
>>> +{
>>> +	switch (sz) {
>>> +	case 8: return BPF_DW;
>>> +	case 4: return BPF_W;
>>> +	case 2: return BPF_H;
>>> +	case 1: return BPF_B;
>>> +	default: return -1;
>>> +	}
>>> +}
>>> +
>> [...]
>>> +
>>> +static void __bpf_gen__debug(struct bpf_gen *gen, int reg1, int reg2, const char *fmt, va_list args)
>>> +{
>>> +	char buf[1024];
>>> +	int addr, len, ret;
>>> +
>>> +	if (!gen->log_level)
>>> +		return;
>>> +	ret = vsnprintf(buf, sizeof(buf), fmt, args);
>>> +	if (ret < 1024 - 7 && reg1 >= 0 && reg2 < 0)
>>> +		strcat(buf, " r=%d");
>>
>> Why only for reg1 >= 0 && reg2 < 0?
> 
> To avoid specifying BPF_REG_7 and adding " r=%%d" to printks explicitly.
> Just to make bpf_gen__debug_ret() short and less verbose.
> 
>>> +	len = strlen(buf) + 1;
>>> +	addr = bpf_gen__add_data(gen, buf, len);
>>> +
>>> +	bpf_gen__emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_1, BPF_PSEUDO_MAP_IDX_VALUE, 0, 0, 0, addr));
>>> +	bpf_gen__emit(gen, BPF_MOV64_IMM(BPF_REG_2, len));
>>> +	if (reg1 >= 0)
>>> +		bpf_gen__emit(gen, BPF_MOV64_REG(BPF_REG_3, reg1));
>>> +	if (reg2 >= 0)
>>> +		bpf_gen__emit(gen, BPF_MOV64_REG(BPF_REG_4, reg2));
>>> +	bpf_gen__emit(gen, BPF_EMIT_CALL(BPF_FUNC_trace_printk));
>>> +}
>>> +
>>> +static void bpf_gen__debug_regs(struct bpf_gen *gen, int reg1, int reg2, const char *fmt, ...)
>>> +{
>>> +	va_list args;
>>> +
>>> +	va_start(args, fmt);
>>> +	__bpf_gen__debug(gen, reg1, reg2, fmt, args);
>>> +	va_end(args);
>>> +}
>>> +
>>> +static void bpf_gen__debug_ret(struct bpf_gen *gen, const char *fmt, ...)
>>> +{
>>> +	va_list args;
>>> +
>>> +	va_start(args, fmt);
>>> +	__bpf_gen__debug(gen, BPF_REG_7, -1, fmt, args);
>>> +	va_end(args);
>>> +}
>>> +
>>> +static void bpf_gen__emit_sys_close(struct bpf_gen *gen, int stack_off)
>>> +{
>>> +	bpf_gen__emit(gen, BPF_LDX_MEM(BPF_W, BPF_REG_1, BPF_REG_10, stack_off));
>>> +	bpf_gen__emit(gen, BPF_JMP_IMM(BPF_JSLE, BPF_REG_1, 0, 2 + (gen->log_level ? 6 : 0)));
>>
>> The number "6" is magic. This refers the number of insns generated below
>> with
>>     bpf_gen__debug_regs(gen, BPF_REG_9, BPF_REG_0, "close(%%d) = %%d");
>> At least some comment will be better.
> 
> good point. will add a comment.
> 
>>
>>> +	bpf_gen__emit(gen, BPF_MOV64_REG(BPF_REG_9, BPF_REG_1));
>>> +	bpf_gen__emit(gen, BPF_EMIT_CALL(BPF_FUNC_sys_close));
>>> +	bpf_gen__debug_regs(gen, BPF_REG_9, BPF_REG_0, "close(%%d) = %%d");
>>> +}
>>> +
>>> +int bpf_gen__finish(struct bpf_gen *gen)
>>> +{
>>> +	int i;
>>> +
>>> +	bpf_gen__emit_sys_close(gen, stack_off(btf_fd));
>>> +	for (i = 0; i < gen->nr_progs; i++)
>>> +		bpf_gen__move_stack2ctx(gen, offsetof(struct bpf_loader_ctx,
>>> +						      u[gen->nr_maps + i].map_fd), 4,
>>
>> Maybe u[gen->nr_maps + i].prog_fd?
>> u[..] is a union, but prog_fd better reflects what it is.
> 
> ohh. right.
> 
>>> +					stack_off(prog_fd[i]));
>>> +	for (i = 0; i < gen->nr_maps; i++)
>>> +		bpf_gen__move_stack2ctx(gen, offsetof(struct bpf_loader_ctx,
>>> +						      u[i].prog_fd), 4,
>>
>> u[i].map_fd?
> 
> right.
> 
>>> +	/* remember map_fd in the stack, if successful */
>>> +	if (map_idx < 0) {
>>> +		bpf_gen__emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_10, BPF_REG_7, stack_off(inner_map_fd)));
>>
>> Some comments here to indicate map_idx < 0 is for inner map creation will
>> help understand the code.
> 
> will do.
> 
>>> +	/* store btf_id into insn[insn_idx].imm */
>>> +	insn = (int)(long)&((struct bpf_insn *)(long)insns)[relo->insn_idx].imm;
>>
>> This is really fancy. Maybe something like
>> 	insn = insns + sizeof(struct bpf_insn) * relo->insn_idx + offsetof(struct
>> bpf_insn, imm).
>> Does this sound better?
> 
> yeah. much better.
> 
>>> +static void mark_feat_supported(enum kern_feature_id last_feat)
>>> +{
>>> +	struct kern_feature_desc *feat;
>>> +	int i;
>>> +
>>> +	for (i = 0; i <= last_feat; i++) {
>>> +		feat = &feature_probes[i];
>>> +		WRITE_ONCE(feat->res, FEAT_SUPPORTED);
>>> +	}
>>
>> This assumes all earlier features than FD_IDX are supported. I think this is
>> probably fine although it may not work for some weird backport.
>> Did you see any issues if we don't explicitly set previous features
>> supported?
> 
> This helper is only used as mark_feat_supported(FEAT_FD_IDX)
> to tell libbpf that it shouldn't probe anything.
> Otherwise probing via prog_load screw up gen_trace completely.
> May be it will be mark_all_feat_supported(void), but that seems less flexible.

Maybe add some comments here to explain why marking explicit supported
instead if probing?

> 
>>> @@ -9383,7 +9512,13 @@ static int libbpf_find_attach_btf_id(struct bpf_program *prog, int *btf_obj_fd,
>>>    	}
>>>    	/* kernel/module BTF ID */
>>> -	err = find_kernel_btf_id(prog->obj, attach_name, attach_type, btf_obj_fd, btf_type_id);
>>> +	if (prog->obj->gen_trace) {
>>> +		bpf_gen__record_find_name(prog->obj->gen_trace, attach_name, attach_type);
>>> +		*btf_obj_fd = 0;
>>> +		*btf_type_id = 1;
>>
>> We have quite some codes like this and may add more to support more
>> features. I am wondering whether we could have some kind of callbacks
>> to make the code more streamlined. But I am not sure how easy it is.
> 
> you mean find_kernel_btf_id() in general?
> This 'find' operation is translated differently for
> prog name as seen in this hunk via bpf_gen__record_find_name()
> and via bpf_gen__record_extern() in another place.
> For libbpf it's all find_kernel_btf_id(), but semantically they are different,
> so they cannot map as-is to gen trace bpf_gen__find_kernel_btf_id (if there was
> such thing).
> Because such 'generic' callback wouldn't convey the meaning of what to do
> with the result of the find.

I mean like calling
     err = obj->ops->find_kernel_btf_id(...)
where gen_trace and normal libbpf all registers their own callback 
functions for find_kernel_btf_id(). Similar ideas can be applied to
other places or not. Not 100% sure this is the best approach or not,
just want to bring it up for discussion.

> 
>>> +	} else {
>>> +		err = find_kernel_btf_id(prog->obj, attach_name, attach_type, btf_obj_fd, btf_type_id);
>>> +	}
>>>    	if (err) {
>>>    		pr_warn("failed to find kernel BTF type ID of '%s': %d\n", attach_name, err);
>>>    		return err;
>>> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
>>> index b9b29baf1df8..a5dffc0a3369 100644
>>> --- a/tools/lib/bpf/libbpf.map
>>> +++ b/tools/lib/bpf/libbpf.map
>>> @@ -361,4 +361,5 @@ LIBBPF_0.4.0 {
>>>    		bpf_linker__new;
>>>    		bpf_map__inner_map;
>>>    		bpf_object__set_kversion;
>>> +		bpf_load;
>>
>> Based on alphabet ordering, this should move a few places earlier.
>>
>> I will need to go through the patch again for better understanding ...
> 
> Thanks a lot for the review.
> 
> I'll address these comments and those that I got offline and will post v2.
> This gen stuff will look quite different.
> I hope bpf_load will not be a part of uapi anymore.
> And 'struct bpf_gen' will not be exposed to bpftool directly.

Sounds good.

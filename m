Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60D31222A12
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 19:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729320AbgGPRic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 13:38:32 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:18080 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728402AbgGPRic (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 13:38:32 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06GHaJ2r025373;
        Thu, 16 Jul 2020 10:38:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=35vpkgtt1KASufmf3Ftun6IASX/ZDYpRc0xIpND29EM=;
 b=Sn4GXaq0t7rHExjJZM2wEFp0xeCI9vS1qsKMQ0stpsVHh4P1jV/3afh0XPcKL3vMjp37
 E9zPfOJTSUHr8HDgf38SnN8p5dL0ibC7bYMd913PTcCC3xzIN3spO+J6tnm+ao0wM6j2
 rLT9/tUmoM6WyL7PZHaAN1bG+z1j7uXFXp8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32a7df59je-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 16 Jul 2020 10:38:17 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 16 Jul 2020 10:38:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iw/hwZmMCmRKbCadvR9ZYTjR7ehl1jbzKoEdaZYAoWn/FTosd54RMFgB7ITMB7LweYH3HqlQJ68BuN8lCwGEZ2TZEG0Wn6qhus1fTDR0hVpZSW5DTX9Wb5xfWLcmi1wvYMfUYMoRDRFZfYtCg/kb1EE9gFuER5CAL7zAEHcFsyuM1p3sxxZVmByy2/3Zq4PD6TtfIQRBt2v8mWoG+3cWGsOMcFT59Vjcfrc6ryolzKuqCZPDE9lP8PQYoZBhRY7uE8TLI5NIfsR9o4VGAuFE1qxS4enPxIjp7aEb+4NDvu36qNtv2DKcLJhcIE7qEHzEUASj1PL/eKz+4zOSGExbSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=35vpkgtt1KASufmf3Ftun6IASX/ZDYpRc0xIpND29EM=;
 b=eNKuGDx9555yQlcdILHoU3LmQMAFx+KmYbJzS4aUEZGeJY0uLKqF41DJz8aIHzUKkW2HY6j4bkBR2PKjbf8jbUbVMIss8DH3GAqOqXhAIwTRUuWZR0VXv9AHke1hS8stTbk9mNo8nlLBT8GD+KYyAWoT+j+xjiplRWIkfzbXEHm9pvC2SkLsiIopO65oHZjZNwMTcalxXTSoNtAhJDn5vjznIdW6g3DDyat1yeTbyTyvQ2v0snR/uMO4EzHLWheNKfj7fLZRnHY/J5a021IYBOJef42AABOQpB475MLW3ZK/+/mqGQQD8ClZ9JLklXniaxd7Hzbw+mz9ZZ1Kw+tyqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=35vpkgtt1KASufmf3Ftun6IASX/ZDYpRc0xIpND29EM=;
 b=fqrOoud6OcYAlOSF6M9yyLscVKebFeori1+g3sTHcIi9B1jLfu1cX8hLQ62QJN7XD7CzMCvKAizob6dAXpWkPs9KwCS1RMgTY7iLJgGClRzDjs4RAi0ffrjH9bieBbENy/oP0uU0HUvugNtmallDSlFYEQyZdeBnWauyipipLnI=
Authentication-Results: iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BY5PR15MB3665.namprd15.prod.outlook.com (2603:10b6:a03:1f7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Thu, 16 Jul
 2020 17:38:14 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3174.026; Thu, 16 Jul 2020
 17:38:14 +0000
Subject: Re: [PATCH bpf] bpf: Shift and mask loads narrower than context field
 size
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-team@cloudflare.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
References: <20200710173123.427983-1-jakub@cloudflare.com>
 <c98aaa5e-9347-c23f-cfa6-e267f2485c5b@fb.com> <87a700y3yb.fsf@cloudflare.com>
 <7c27726c-9bba-8d7c-55b4-69d7af287382@fb.com> <878sfjy93a.fsf@cloudflare.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <0cd71ea3-c529-7007-1f93-4442484834df@fb.com>
Date:   Thu, 16 Jul 2020 10:38:13 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
In-Reply-To: <878sfjy93a.fsf@cloudflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0033.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::46) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::1176] (2620:10d:c090:400::5:4e0d) by BYAPR06CA0033.namprd06.prod.outlook.com (2603:10b6:a03:d4::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.18 via Frontend Transport; Thu, 16 Jul 2020 17:38:14 +0000
X-Originating-IP: [2620:10d:c090:400::5:4e0d]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca995dcb-65f4-4081-55f4-08d829af04a8
X-MS-TrafficTypeDiagnostic: BY5PR15MB3665:
X-Microsoft-Antispam-PRVS: <BY5PR15MB3665F49B8964BC2312A9D0F3D37F0@BY5PR15MB3665.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d8K/TXJSJ3fY891QUxgTQXgTthJXEnqjroCcuAhoPAmjPSTJfDZfKZtqKQD5YMWBK4BQ3KEhIM9YegMdl1yuUx7h25jYaM2tvPbiPlZBqyqEwuz7BZt+xMx8aS7rgvOma7eZzlRGENmHubhxkuZV4eABeLzcmFq+OyO2cxd5fHN+zSpo9HnF/DYiNobT28na/DeiRATL5zF5osu2RO8fU4tX4v4wsstfwUs467fHQl1hbZd2i+nurZsUjW0U7rF5x477Y121VO8OuuPVZK6m7++LA6ZJZ8wXwO/tJuQXeMkIQcOfmeVPNbRyJDDo+8oUalaeprRfruLJcNVHdrqYTZ2lxJVz0ETaGLbKKxitlpM87eLZveX7EQqnDMeLHbf/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(346002)(376002)(366004)(136003)(39860400002)(6916009)(53546011)(52116002)(54906003)(8676002)(31696002)(66556008)(6486002)(86362001)(66946007)(316002)(8936002)(83380400001)(66476007)(5660300002)(186003)(2906002)(2616005)(478600001)(31686004)(4326008)(36756003)(16526019)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: NYRtikRl7T3EYUBwNXBWEn0acAGHaz51YnaH6KvunY9RT3GXMbMrphUtfr/agspxqAhPhqS/SeOcrtcsYphVxoF77ABVETcZBiMr8OAR7dxRTJwbNNkGkowRU+6OhGF0m+rb+oo23b63cxwWKU2nMeM3UlpVEma9dn50xF6iDgqGcMEQp+lFlwrYniv73MxKMgZVUEcW4fYtd24UhM2frVeqjX8bWj8t/YMwAHAsdD6TvKmobflVTcKIXv7Tcq2krIqcacOfjttVbeKis0suuD3EdO4pl/wCj5bZ9WPhVNS29f2WYQ8gRbvGUB2DDonrDqIY3ukeXZPD5odJFr+RSeo4NxX4Yac9OYzDnt6+Z5rarXQCMWZy3q/xNvwrtJ9kTW/Wbw/8P77yHRz7SyCWOEeuQa7JpyuKf1NF7dpiGjMx0V8zRl9K7BVXNzGMtHTeVZ9IOpCIPpWM/fg2SYvXlRlWvuk/MSCcUpYpF8eeE4l9E5Y83gnwtwxHTEjPrjdIypRcvzke6vmUvhGyZlAhaA==
X-MS-Exchange-CrossTenant-Network-Message-Id: ca995dcb-65f4-4081-55f4-08d829af04a8
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2020 17:38:14.9330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8Q1eBSNPd1acWVkG1l63IgexGQ3mDETXzvUbMtJhNUYmUvZws0HUbk7OS0oYTHHL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3665
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-16_07:2020-07-16,2020-07-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 phishscore=0 spamscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 lowpriorityscore=0 suspectscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007160127
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/16/20 4:48 AM, Jakub Sitnicki wrote:
> On Wed, Jul 15, 2020 at 10:59 PM CEST, Yonghong Song wrote:
>> On 7/15/20 12:26 PM, Jakub Sitnicki wrote:
>>> On Wed, Jul 15, 2020 at 08:44 AM CEST, Yonghong Song wrote:
>>>> On 7/10/20 10:31 AM, Jakub Sitnicki wrote:
> 
> [...]
> 
>>>>> The "size < target_size" check is left in place to cover the case when a
>>>>> context field is narrower than its target field, even if we might not have
>>>>> such case now. (It would have to be a u32 context field backed by a u64
>>>>> target field, with context fields all being 4-bytes or wider.)
>>>>>
>>>>> Going back to the example, with the fix in place, the upper half load from
>>>>> ctx->ip_protocol yields zero:
>>>>>
>>>>>      int reuseport_narrow_half(struct sk_reuseport_md * ctx):
>>>>>      ; int reuseport_narrow_half(struct sk_reuseport_md *ctx)
>>>>>         0: (b4) w0 = 0
>>>>>      ; if (half[0] == 0xaaaa)
>>>>>         1: (79) r2 = *(u64 *)(r1 +8)
>>>>>         2: (69) r2 = *(u16 *)(r2 +924)
>>>>>         3: (54) w2 &= 65535
>>>>>      ; if (half[0] == 0xaaaa)
>>>>>         4: (16) if w2 == 0xaaaa goto pc+7
>>>>>      ; if (half[1] == 0xbbbb)
>>>>>         5: (79) r1 = *(u64 *)(r1 +8)
>>>>>         6: (69) r1 = *(u16 *)(r1 +924)
>>>>
>>>> The load is still from offset 0, 2 bytes with upper 48 bits as 0.
>>>
>>> Yes, this is how narrow loads currently work, right? It is not specific
>>> to the case I'm fixing.
>>>
>>> To give an example - if you do a 1-byte load at offset 1, it will load
>>> the value from offset 0, and shift it right by 1 byte. So it is expected
>>> that the load is always from offset 0 with current implementation.
>>
>> Yes, the load is always from offset 0. The confusion part is
>> it load offset 0 with 2 bytes and then right shifting 2 bytes
>> to get 0...
> 
> Right, I see how silly is the generated instruction sequence. I guess
> I've accepted how <prog_type>_convert_ctx_access functions emit loads
> and didn't stop and question this part before.
> 
>>> SEC("sk_reuseport/narrow_byte")
>>> int reuseport_narrow_byte(struct sk_reuseport_md *ctx)
>>> {
>>> 	__u8 *byte;
>>>
>>> 	byte = (__u8 *)&ctx->ip_protocol;
>>> 	if (byte[0] == 0xaa)
>>> 		return SK_DROP;
>>> 	if (byte[1] == 0xbb)
>>> 		return SK_DROP;
>>> 	if (byte[2] == 0xcc)
>>> 		return SK_DROP;
>>> 	if (byte[3] == 0xdd)
>>> 		return SK_DROP;
>>> 	return SK_PASS;
>>> }
>>>
>>> int reuseport_narrow_byte(struct sk_reuseport_md * ctx):
>>> ; int reuseport_narrow_byte(struct sk_reuseport_md *ctx)
>>>      0: (b4) w0 = 0
>>> ; if (byte[0] == 0xaa)
>>>      1: (79) r2 = *(u64 *)(r1 +8)
>>>      2: (69) r2 = *(u16 *)(r2 +924)
>>>      3: (54) w2 &= 255
>>> ; if (byte[0] == 0xaa)
>>>      4: (16) if w2 == 0xaa goto pc+17
>>> ; if (byte[1] == 0xbb)
>>>      5: (79) r2 = *(u64 *)(r1 +8)
>>>      6: (69) r2 = *(u16 *)(r2 +924)
>>>      7: (74) w2 >>= 8
>>>      8: (54) w2 &= 255
>>> ; if (byte[1] == 0xbb)
>>>      9: (16) if w2 == 0xbb goto pc+12
>>> ; if (byte[2] == 0xcc)
>>>     10: (79) r2 = *(u64 *)(r1 +8)
>>>     11: (69) r2 = *(u16 *)(r2 +924)
>>>     12: (74) w2 >>= 16
>>>     13: (54) w2 &= 255
>>> ; if (byte[2] == 0xcc)
>>>     14: (16) if w2 == 0xcc goto pc+7
>>> ; if (byte[3] == 0xdd)
>>>     15: (79) r1 = *(u64 *)(r1 +8)
>>>     16: (69) r1 = *(u16 *)(r1 +924)
>>>     17: (74) w1 >>= 24
>>>     18: (54) w1 &= 255
>>>     19: (b4) w0 = 1
>>> ; if (byte[3] == 0xdd)
>>>     20: (56) if w1 != 0xdd goto pc+1
>>>     21: (b4) w0 = 0
>>> ; }
>>>     22: (95) exit
>>>
>>>>
>>>>>         7: (74) w1 >>= 16
>>>>
>>>> w1 will be 0 now. so this will work.
>>>>
>>>>>         8: (54) w1 &= 65535
>>>>
>>>> For the above insns 5-8, verifier, based on target information can
>>>> directly generate w1 = 0 since:
>>>>     . target kernel field size is 2, ctx field size is 4.
>>>>     . user tries to access offset 2 size 2.
>>>>
>>>> Here, we need to decide whether we permits user to do partial read beyond of
>>>> kernel narrow field or not (e.g., this example)? I would
>>>> say yes, but Daniel or Alexei can provide additional comments.
>>>>
>>>> If we allow such accesses, I would like verifier to generate better
>>>> code as I illustrated in the above. This can be implemented in
>>>> verifier itself with target passing additional kernel field size
>>>> to the verifier. The target already passed the ctx field size back
>>>> to the verifier.
>>>
>>> Keep in mind that the BPF user is writing their code under the
>>> assumption that the context field has 4 bytes. IMHO it's reasonable to
>>> expect that I can load 2 bytes at offset of 2 from a 4 byte field.
>>>
>>> Restricting it now to loads below the target field size, which is
>>> unknown to the user, would mean rejecting programs that are working
>>> today. Even if they are getting funny values.
>>>
>>> I think implementing what you suggest is doable without major
>>> changes. We have load size, target field size, and context field size at
>>> hand in convert_ctx_accesses(), so it seems like a matter of adding an
>>> 'if' branch to handle better the case when we know the end result must
>>> be 0. I'll give it a try.
>>
>> Sounds good. The target_size is returned in convert_ctx_access(), which
>> is too late as the verifier already generated load instructions. You need to get
>> it earlier in is_valid_access().
> 
> I have a feeling that I'm not following what you have in mind.
> 
> True, target_size is only known after convert_ctx_access generated
> instructions. At this point, if we want to optimize the narrow loads
> that must return 0, we can pop however many instructions
> convert_ctx_access appended to insn_buf and emit BPF_MOV32/64_IMM.
> 
> However, it sounds a bit more complex than what I hoped for initially,
> so I'm starting to doubt the value. Considering that narrow loads at an
> offset that matches or exceeds target field size must be a corner case,
> if the current "broken" behavior went unnoticed so far.
> 
> I'll need to play with the code and see how it turns out. But for the
> moment please consider acking/nacking this one, as a simple way to fix
> the issue targeted at 'bpf' branch and stable kernels.

Ack the current patch as it does fix the problem. See below comments
with a slight change to avoid penalize existing common case like
    __u16 proto = ctx->ip_protocol;

> 
>>
>>>
>>> But I do want to empahsize that I still think the fix in current form is
>>> correct, or at least not worse than what we have already in place narrow
>>> loads.
>>
>> I did agree that the fix in this patch is correct. It is just that we
>> could do better to fix this problem.
> 
> I agree with your sentiment. Sorry if I got too defensive there.
> 
>>
>>>
>>>>
>>>>>         9: (b4) w0 = 1
>>>>>      ; if (half[1] == 0xbbbb)
>>>>>        10: (56) if w1 != 0xbbbb goto pc+1
>>>>>        11: (b4) w0 = 0
>>>>>      ; }
>>>>>        12: (95) exit
>>>>>
>>>>> Fixes: f96da09473b5 ("bpf: simplify narrower ctx access")
>>>>> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>>>>> ---
>>>>>     kernel/bpf/verifier.c | 2 +-
>>>>>     1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>>>>> index 94cead5a43e5..1c4d0e24a5a2 100644
>>>>> --- a/kernel/bpf/verifier.c
>>>>> +++ b/kernel/bpf/verifier.c
>>>>> @@ -9760,7 +9760,7 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
>>>>>     			return -EINVAL;
>>>>>     		}
>>>>>     -		if (is_narrower_load && size < target_size) {
>>>>> +		if (is_narrower_load || size < target_size) {

Maybe
                 if (is_narrower_load &&
                     (size < target_size || (off & (size_default - 1)) 
!= 0)) {

The original patch is any narrow load will do shift/mask, which is not 
good. For narrow load, we only need to shift/mask if
   - size < target_size or
   - the off is not in the field boundary.

I still prefer better xlated codes. But if it is too complex, the above
change is also acceptable. I just do not like generated xlated byte 
codes, it is very easy for people to get confused.


>>>>>     			u8 shift = bpf_ctx_narrow_access_offset(
>>>>>     				off, size, size_default) * 8;
>>>>>     			if (ctx_field_size <= 4) {
>>>>>

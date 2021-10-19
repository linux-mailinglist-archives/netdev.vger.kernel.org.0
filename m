Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 263D5433B8D
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 18:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231842AbhJSQFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 12:05:13 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:16376 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231559AbhJSQFM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 12:05:12 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19J7qcBQ005248;
        Tue, 19 Oct 2021 09:02:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=tGTocOVslKuZk+hr7SEzhXiy/HYwjxJV3xnJDaeLnoU=;
 b=D+l085ey4xtCyqHL1poh99coUOxa1bgzUx9qXM/oiXHKjQG7grqz7EFtJsNB51EmdwAG
 Dpp0DDUuDAF1272JwYvGBG0Dli9Odi4LRCB0eB6PxNHswwY7t7oudBJCXS9Ew8+pKvmQ
 YtDaiEaNTlQ/tmiOmEmDpmhn0495UAZH7no= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3bst0tu99v-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 19 Oct 2021 09:02:44 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Tue, 19 Oct 2021 09:02:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AtcSLOr7s0D7tWw4+bsgLWYfWcBIbhwMaJF4Dp3nUKCVhRJgM1B7Y09VqoD5wdXimOegbrBa/dluqXK8QRmbFxIz6oVJiLxNXKlh1bW5u/H3atfr+QWL6Yr+/OSRGt9RzN2WZSHLjH6ncP79YyEo9FgFMgjVmAH2fcexgLjfhntmO2b7C81FKguAcUdCSVuhw1hrMuhsHYVscq70VfL52+vzZsqlhPTSMXaQ5jR5y+lIku4g3wI1iFqURcUayu9TxPZk1r6wezY6pOvfXLBgmvyydJGFq7FJFEN/TAFJsj3E17um/HrGhJlT55O9IOaq5kzoyFkkqZRhP/TSupUOTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tGTocOVslKuZk+hr7SEzhXiy/HYwjxJV3xnJDaeLnoU=;
 b=hSS2rM+R2enVtxzzZTHyxLg255EffVjUper0lIPK2cb5owfRR8F+MYv/50bZurC8X8N5q4lzm3uDPAtHSYM/WFMUnjX4zLaAN7InEN91oATW2nNsPuTVWyfJG7bnt184cmDHani1jreHY0M0Ej1n6oQOY3li+QABuiyZ1IaM9bPO/PIOwrZdBlnFY5S/YEH//D7b7LHKJR3cy/RUaeC1g1d6unshqmMox+unOZw667yPJNzsLCTJ9+sDTXSGIjhyOxG4GcwAyf5+J3mwtyVXzcSHYxwsstGsFMjxkM+bpv6N8l3IgP1XwO90D9FxJy9faGLMfCs/QRgekr/wD587+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA0PR15MB3886.namprd15.prod.outlook.com (2603:10b6:806:8f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Tue, 19 Oct
 2021 16:02:37 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75%6]) with mapi id 15.20.4608.018; Tue, 19 Oct 2021
 16:02:37 +0000
Subject: Re: [PATCH bpf-next v2 0/3] Add XDP support for bpf_load_hdr_opt
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
CC:     Martin KaFai Lau <kafai@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Joanne Koong <joannekoong@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <Kernel-team@fb.com>
References: <20211006230543.3928580-1-joannekoong@fb.com>
 <87h7dsnbh5.fsf@toke.dk> <9f8c195c-9c03-b398-2803-386c7af99748@fb.com>
 <43bfb0fe-5476-c62c-51f2-a83da9fef659@iogearbox.net>
 <20211007235203.uksujks57djohg3p@kafai-mbp> <87lf33jh04.fsf@toke.dk>
 <20211019000058.ghklvg4saybzqk3o@ast-mbp>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <a9314ae9-eab8-5761-a547-5bfb5022dac3@fb.com>
Date:   Tue, 19 Oct 2021 09:02:33 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
In-Reply-To: <20211019000058.ghklvg4saybzqk3o@ast-mbp>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
X-ClientProxiedBy: MWHPR18CA0067.namprd18.prod.outlook.com
 (2603:10b6:300:39::29) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
Received: from [IPv6:2620:10d:c085:21e1::11bf] (2620:10d:c090:400::5:d93) by MWHPR18CA0067.namprd18.prod.outlook.com (2603:10b6:300:39::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15 via Frontend Transport; Tue, 19 Oct 2021 16:02:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5488b8ad-d107-4d55-972c-08d99319deec
X-MS-TrafficTypeDiagnostic: SA0PR15MB3886:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR15MB3886F97811BD0E3EB8A66B04D3BD9@SA0PR15MB3886.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LeIiYE56nVYNteaMZX8w6mk+iz5h5i+iwiJGgygI2Xi8bjK9iyum5VctlOKtRmD2EW2USDVVT6uJGATsNmPpzHJJojDgfoj5kOJaJ98CC/Qk265U6iIIxF4owNNHzCgh3JX8eVRW66ywQu2S7EbNJlGbOB6nLiUim0xkBZZ3rf+i+88cNPrIwh6m77FzwdSH/It5hYI3nlmlK7k279g/oo/6H0N1xbIsI9nCEcXcJtEyUxbDbvEQ/XrmZFszMX8YsXN8LxiwG1214FfEZVgXtwgkg1tsab0O3x+8Fedwf6ec68nM6PXajhi08UBdV5Huf0j7NA0+VXXa35Yc28CoQSF5myJA6DGEQelYYIBreRXTPwN37fPhJQxXcXgcYl7QFxhcWLHBMBEmDOMbTc3tdAAKA3BK/4vBG2nwjpggRWjv2nn+nPVhX+UnODm0ffydM+0Frg1e3gL3n2qE60Q/YnIGkDBgEhRea5bk7xeyVTn0NYe18NddRPYuxHPgCZBi9xClc9hw7kSfvQJ6xd+A2N9wH8fgzd8W/6SAtTo6H61O/H62OLyJh8asjQjqaDNSdehxzngZcE7fIDiDrzj7py23kTyzIdFZrpumGFB2qeEHeIaxm6PQTTLOwSho+C4akSaxCObEoqlVUcVm0Z5w64KdDuJ2cfSDutkR9rK4AgtzW4J4JLKetKurjaOTXu9Fi4VK91E5bVGXx0Eum5NgcClB4WuIpuDm6cwW/V5LlvFeOeCMYHn1AwOnRCPHHqJ6xuzsoqC3osxnR9xPVYMTI14MYDLpnjgDCFkmyL0M+RxyuprVifksJoLf/kBui5yz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(54906003)(110136005)(316002)(5660300002)(52116002)(66574015)(6486002)(31696002)(508600001)(86362001)(36756003)(2906002)(66476007)(66556008)(8676002)(66946007)(966005)(83380400001)(53546011)(31686004)(4326008)(38100700002)(186003)(2616005)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N3pnNzdDZllzdHBYZ2NkV25neVBIOHpsdG83d2l6c0U5N01jMjJaTWc2Y1VO?=
 =?utf-8?B?eDFEcnNuRlN5b3ZiUW9nYkNlYmZXak03V0k5Q0hRYmVieS92QmowN3hnQ3dr?=
 =?utf-8?B?b0dlbWRZV3NwSlhLSFhtaG5TNjNrRmIra1RBbEJNOTk3anYwRnJzMFhmcW1S?=
 =?utf-8?B?eWpOS0JjWWU1ckE4dm1tV3RXcUhoMkk5Ulp3NDdSdzJxc1FtcUZoeXNzN3FH?=
 =?utf-8?B?ZDI0R0gvV1NVTk85cGluWlVqNzVPcnJUMWg3a2FlTmFuYVdjK2xTTzkvSGVu?=
 =?utf-8?B?aE1Nck1vcUI3Q2dlTHFmczJTS0xoK2ZDbCtmUFJoelltUmw4QVhyMHJnMTlx?=
 =?utf-8?B?WHlIVmVpREpmd3kvZGJ5ZnJmMG5rZSthM0NVZmVsTFQ1NmhQcURkM3p2aGNN?=
 =?utf-8?B?MXpOZUliVUl0UGI4bXFQRFVOOG91d2ZUVVdsY2xDR2c0NW5GMkErZjJFQlVz?=
 =?utf-8?B?NlRielRVbHFLRVZ1OW5tTzBBUE1YNHFHSWcvWjJFK1dhSVdzaGdjcDhNMWZ5?=
 =?utf-8?B?NGZaVzRZVmRhU05Ub0tIRmk4VkJoS3RIcS9HVVFMMDU4U2w0ZkttTU1MRU1U?=
 =?utf-8?B?QkNLSWhoMXVOdXJrUDhGZ0xhd0RmcVkyRkEvRVFLRU1CNWt6eWZWRXhsQVJP?=
 =?utf-8?B?Q0lyc0hJSWFmeHJYaDcwT3NuNnFUOVdsRGt2WFR0SVFLNExhdFp5SUpwQ2VP?=
 =?utf-8?B?MVN5WWhHVFdPYzFTUndHTytXVkh0UDVWVGtweERkRU1jTGVkQTNJVFBHRk11?=
 =?utf-8?B?S3NKeTdFcEc2bE5lVG5IM1g1UTg0ZVNDeThkNUZDdnowbWhFaUsvTXRDajNX?=
 =?utf-8?B?ZmJvSitaYjRlVklGTkNKc1JoQlhNdmNNTmdWZHpzbTNSN3h3VXRHMGN0cVhL?=
 =?utf-8?B?S25GR3ZsaE9FWnhUUWJBUGhYUlpLclNKcEd3MTdNYkQrZnBMMThKZ1hkeGZM?=
 =?utf-8?B?Q0xOaHRoUEJFbW1CYnNDNjJkU0dUM0g2NnRscFNsN29ncFB3NGFBbC9WN0RR?=
 =?utf-8?B?YjJleHBhQzhFS3M1aVQvUFd3bkh2d1RNSXdLZ3B4bXRrZWRLYWxoQjkwdGFX?=
 =?utf-8?B?VFY3Vy83ekpwSkpSQVB4cG9sNVB6K1h6NHVoY0hCekk3WmMrQXhRazRwaC9P?=
 =?utf-8?B?V1pBR1RmdWFKb244dGFDSFJmb2F0cncvV2RWNTRYcmszVkpZVVVVQW5JTXVH?=
 =?utf-8?B?MWxuMmRwU2hYTm5XWGpmbyttSEVGZWJXdUhKclZGNFkxL3gvS2ZJWmJPelFI?=
 =?utf-8?B?NTRGWjMwSlRoVHhlYTU0d3BkZkdkYnJvR3U5SzJYRzNVaSt1TDdCenUrcXBF?=
 =?utf-8?B?MHd5NjQrMk41Q20rRFRmV0RLWWxSbHlKNGlVWTJpSjA4ZVdKbWdYYmtXbDRI?=
 =?utf-8?B?RDd5NWNhenhjekFySm5GSldYZC84Vkg1eExSQm8rKzFtamZPZWx2UWNVNC9V?=
 =?utf-8?B?eWJSenkydkNBS2RCOGo2ZVBWQ0kxelJUQXNDekxaV2NSdmdDOWREckpaQ1VG?=
 =?utf-8?B?aUpPSWVlUElzM2RCbWppNmlqMVhWL05hL0hIUUltWk1iSG41NDRnZERUV3Jw?=
 =?utf-8?B?L2N2UE9CRGFnRWJzVCtzZWc2Ty85UVphZGxJK0xSZWVtdmFEYmJIMFFUaUFu?=
 =?utf-8?B?NmUzVDIyVmxDSHFreFMyTFo3V0hrWGZ2U0ErTUp6dCtsMGh1S010b2dIME9r?=
 =?utf-8?B?eVVnRlJmbWx3OG0wS0FYL1hLRmJYZWVZSEF1dGJqVDF1MjVIU1BsZnpmeGFz?=
 =?utf-8?B?Ly9oVE1XV2FXbUkvZCtsSVdxMjF1OUJsdHlaanNOQkxRQUt4bmNUclZXWldT?=
 =?utf-8?B?dThHVXJ0RGdjUEV1VWhyQT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5488b8ad-d107-4d55-972c-08d99319deec
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 16:02:37.4840
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CUqS52cTJe90sojhR/t5C+EhkVSmANLtJ2euaWfNwYhmUzYgPTxSXUn12Y43EZCo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3886
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: XhbPL-myKqw8e9F3yHCBUkLIwNtEACa1
X-Proofpoint-GUID: XhbPL-myKqw8e9F3yHCBUkLIwNtEACa1
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-19_02,2021-10-19_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 priorityscore=1501 mlxscore=0 clxscore=1011 adultscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=879 impostorscore=0 spamscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110190094
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/18/21 5:00 PM, Alexei Starovoitov wrote:
> On Sat, Oct 09, 2021 at 12:20:27AM +0200, Toke Høiland-Jørgensen wrote:
>>
>> So if we can't fix the verifier, maybe we could come up with a more
>> general helper for packet parsing? Something like:
>>
>> bpf_for_each_pkt_chunk(ctx, offset, callback_fn, callback_arg)
>> {
>>    ptr = ctx->data + offset;
>>    while (ptr < ctx->data_end) {
>>      offset = callback_fn(ptr, ctx->data_end, callback_arg);
>>      if (offset == 0)
>>        return 0;
>>      ptr += offset;
>>    }
>>    
>>    // out of bounds before callback was done
>>    return -EINVAL;
>> }
> 
> We're starting to work on this since it will be useful not only for
> packet parsing, TLV parsing, but potentially any kind of 'for' loop iteration.
> 
>> This would work for parsing any kind of packet header or TLV-style data
>> without having to teach the kernel about each header type. It'll have
>> quite a bit of overhead if all the callbacks happen via indirect calls,
>> but maybe the verifier can inline the calls (or at least turn them into
>> direct CALL instructions)?
> 
> Right. That's the main downside.
> If the bpf_for_each*() helper is simple enough the verifier can inline it
> similar to map_gen_lookup. In such case the indirect call will be a direct call,
> so the overhead won't be that bad, but it's still a function call and
> static function will have full prologue+epilogue.
> Converting static function into direct jump would be really challenging
> for the verifier and won't provide much benefit, since r6-r9 save/restore
> would need to happen anyway even for such 'inlined' static func, since
> llvm will be freely using r6-r9 for insns inside function body
> assuming that it's a normal function.
> 
> May be there is a way to avoid call overhead with with clang extensions.
> If we want to do:
> int mem_eq(char *p1, char *p2, int size)
> {
>    int i;
>    for (i = 0; i < size; i++)
>      if (p1[i] != p2[i])
>        return 0;
>    return 1;
> }
> 
> With clang extension we might write it as:
> int bpf_mem_eq(char *p1, char *p2, int size)
> {
>    int i = 0;
>    int iter;
> 
>    iter = __builtin_for_until(i, size, ({
>        if (p1[i] != p2[i])
>          goto out;
>    }));
>    out:
>    if (iter != size)
>      return 0;
>    return 1;
> }
> 
> The llvm will generate pseudo insns for this __builtin_for.
> The verifier will analyze the loop body for the range [0, size)
> and replace pseudo insns with normal branches after the verification.
> We might even keep the normal C syntax for loops and use
> llvm HardwareLoops pass to add pseudo insns.
> It's more or less the same ideas for loops we discussed before
> bounded loops were introduced.
> The main problem with bounded loops is that the loop body will
> typically be verified the number of times equal to the number of iterations.
> So for any non-trivial loop such iteration count is not much more
> than 100. The verifier can do scalar evolution analysis, but
> it's likely won't work for many cases and user experience
> will suffer. With __builtin_for the scalar evolution is not necessary,
> since induction variable is one and explicit and its range is explicit too.
> That enables single pass over loop body.
> One might argue that for (i = 0; i < 10000; i += 10) loops are
> necessary too, but instead of complicating the verifier with sparse
> ranges it's better to put that on users that can do:
>    iter = __builtin_for_until(i, 10000 / 10, ({
>        j = i * 10;
>        use j;
>    }));
> Single explicit induction variable makes the verification practical.
> The loop body won't be as heavily optimized as normal loop,
> but it's a good thing.

We have discussed how to verify *well-formed* loops back in 2018.
(BPF control flow, supporting loops and other patterns:
  https://www.linuxplumbersconf.org/event/2/contributions/116/)
Now probably the time to revisit it again!

I think Alexei's proposal is the right direction to have
compiler preserving the loop structure with some pseudo instructions
and verifier is able to range-based verification
instead of iterating all loop iterations.

LLVM already has some IR loop intrinsics like below:
   def int_set_loop_iterations :
   def int_start_loop_iterations :
   def int_test_set_loop_iterations :
   def int_test_start_loop_iterations :
   def int_loop_decrement :
   def int_loop_decrement_reg :
to facilitate hardware loop. BPF target can define its own
intrinsics to help define a well structured loop.

I will look into this.

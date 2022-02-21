Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7E54BE727
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 19:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377780AbiBUO1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 09:27:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377752AbiBUO1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 09:27:14 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2071.outbound.protection.outlook.com [40.107.94.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44BF92196;
        Mon, 21 Feb 2022 06:26:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bnmOiXkU3VISR3Ht2LHotNwpMQpB3iflS04Gf9q2LKf+CSv0npTB0hAzz2Sswjg08HT18iI0fyplzrLzM9ZzhMgE9gx7Ujb8Vj+Sr2hvUCGQWOU2DLzrm+ZXJGcvgS9mgrSTLkEXblt0h0lgOmGIfwRRPgz/7HnoZP3uBEvW6/B5Lho/SAaULHNFZhFAMhkmvbnkp5SuGuv9LXZ9asdkECQwracezwqmNS+qi6BQoXDLQ5Lu+NRi05yhvSZRQnQL//99I1H7ZvrFJtUz3sqk2yqEmPI1UGIGwC/UVwg0CxM87KXG0bm65dfX03fSbUIjKfUXnjKHrolQ9VIIRocrqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fqNaH6Faq4wLAa14PAy27G6P0ASTh5Y/MPeE29MwyFQ=;
 b=Minal1B3HOyZN+Gy6jtvdCtn+ygtsqlumwFmbzRkU+5+xGAv50jQ+d+149XFxDtl40ITGeGAkbpoNaPoh7Gc3BGNyaTvNV6PyvqB6cK3K44ztiaEJHv4KgNvX8nz2ObjTF4Lj8PwVtN3jlobNrLlmLdoZdyStKCMYDseBkCea3ibjqnH/cawgwkrqvtIi+d2Vb+P22Oyj8PwCXhOC55fJFWV2aX6dOhFvGK8CFz3I/yHKSQrG3Z3iCu+q4ZcHYSHBfoHlFVdyvPNb0wGUhYKbQYcHz7lQgxYuFa+8QcrDHJtCCozt0u2EYGRSpSyFxwokSBSg7/cIVekthXW1D6PBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=fb.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fqNaH6Faq4wLAa14PAy27G6P0ASTh5Y/MPeE29MwyFQ=;
 b=ZRZagf/0G5l88Qb+2e12Y2k09qCRL9K/0748K1tgmgrRvbBoPaPEyybQGGEXeU1mLpCCoZdnT/kSCY5yPntq3JgKTfYl9WZSnshjYMGDHgB2AW2RgQjJNUfk4OSJHb8YXwHYmVOulM6ja7GW+cNJ2ltUkwS8LjaLR0/1VIKK7s7HTKJZhXYjM12A9fbWKSZYIZbOZUV0BbVxey/2rIbmANnIdy7s3CUA/YDmj0pYxNsxD9+BFEZs3mLKcYGXOqm5+EmtmMGMxMBvaPlMkdsWHNu34+OhrMsRuwEB820lNjQR0l7coXi/fROukDuNiSphTpmHxo47WvogEmBNB62efQ==
Received: from DM5PR12CA0058.namprd12.prod.outlook.com (2603:10b6:3:103::20)
 by PH0PR12MB5402.namprd12.prod.outlook.com (2603:10b6:510:ef::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Mon, 21 Feb
 2022 14:26:48 +0000
Received: from DM6NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:103:cafe::2e) by DM5PR12CA0058.outlook.office365.com
 (2603:10b6:3:103::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14 via Frontend
 Transport; Mon, 21 Feb 2022 14:26:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT003.mail.protection.outlook.com (10.13.173.162) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Mon, 21 Feb 2022 14:26:48 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 21 Feb
 2022 14:26:43 +0000
Received: from [172.27.12.242] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 21 Feb 2022
 06:26:32 -0800
Message-ID: <6b6ce8a2-e409-0297-cb29-fe9493c9d637@nvidia.com>
Date:   Mon, 21 Feb 2022 16:26:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH bpf-next v2 2/3] bpf: Add helpers to issue and check SYN
 cookies in XDP
Content-Language: en-US
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        "John Fastabend" <john.fastabend@gmail.com>
CC:     <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "Nathan Chancellor" <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Joe Stringer <joe@cilium.io>,
        Florent Revest <revest@chromium.org>,
        <linux-kselftest@vger.kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Florian Westphal <fw@strlen.de>
References: <20220124151340.376807-1-maximmi@nvidia.com>
 <20220124151340.376807-3-maximmi@nvidia.com>
 <61efacc6980f4_274ca2083e@john.notmuch>
 <8f5fecac-ce6e-adc8-305b-a2ee76328bce@nvidia.com>
 <61f850bdf1b23_8597208f8@john.notmuch> <61f852711e15a_92e0208ac@john.notmuch>
 <9cef58de-1f84-5988-92f8-fcdd3c61f689@nvidia.com>
 <61fc9483dfbe7_1d27c208e7@john.notmuch> <87a6f6bu6n.fsf@toke.dk>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
In-Reply-To: <87a6f6bu6n.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cfea9828-2f1f-4fee-1c99-08d9f54631c6
X-MS-TrafficTypeDiagnostic: PH0PR12MB5402:EE_
X-Microsoft-Antispam-PRVS: <PH0PR12MB54029F381C643803826850D2DC3A9@PH0PR12MB5402.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lwnGhxUjERhaFitbGavktIM+kcM9XDwvguFz17Oq2sqtFCgWJ2MOk1BjACEMaFdStpwp6/0/raYQacmgd4bKPC/xHLArJIJLMPllOVYMuaVW/Fwb+ZyuNGfirz12RXcwJmGCAtZ7qP2TrxD98EEc+HTTVQLz4kYgXs7pS9gdbSduzvWeBzSyExpICq2vtWFzMjXqtLjtsx8xTPs9yYSVF+vuDLyX1tZ3p+66qxVnuWsNbAmKIPW1cyy9jySPMkhuxHv/OpYo0ymQUk/z4Vlrh5WrhqSHRmSmY+fwTMEEiCaG0rtdlmSoXT40mehGKGaGb8c5V9OPKSiqUIuD6gV5HYPhKeS4nRydW1IUmUDxEkpF6c9mY4q+bIHRSohKH1jizfatSdfC8BZH58GfIpchRFKwbX/ZmC/Kpy0NQezDcspkC32GQGODMYBhLQtN/VmkkIiZyPHPMptvHVORWUIR2eSg+rAGbLHaXYkDndmzc00X0HnWIKP9OUQ2TJISwSSCUpTPW17wndQL9SE/e7GbkT4OpM7AdSzCT0ztFQ8q6YPQa4GB0tyhQkflmbAG6WhIeb6wUAbnXeM4clD6x1kwzUP28VvIU+I3b16GNpqdCGEIaWl9GjheZFAtA+forr/qyqgGjpl5uupVKHdlDhL9P43noEO0VLF9EQMWhYfaMnZMxVxHkulR6dMJjN7aOOJpKz4PUCy+tIuIzMghH8S/VcHFZ29wP1GdQc+AZ05bEac/xjBztjT58DNoKoTmdkhv
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(26005)(186003)(31696002)(2906002)(40460700003)(356005)(6666004)(47076005)(110136005)(31686004)(83380400001)(81166007)(86362001)(8936002)(36756003)(54906003)(16526019)(508600001)(82310400004)(316002)(16576012)(36860700001)(7416002)(2616005)(5660300002)(53546011)(426003)(8676002)(4326008)(70206006)(70586007)(336012)(66574015)(43740500002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 14:26:48.0125
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cfea9828-2f1f-4fee-1c99-08d9f54631c6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5402
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-02-04 16:08, Toke Høiland-Jørgensen wrote:
> John Fastabend <john.fastabend@gmail.com> writes:
> 
>> Maxim Mikityanskiy wrote:
>>> On 2022-01-31 23:19, John Fastabend wrote:
>>>> John Fastabend wrote:
>>>>> Maxim Mikityanskiy wrote:
>>>>>> On 2022-01-25 09:54, John Fastabend wrote:
>>>>>>> Maxim Mikityanskiy wrote:
>>>>>>>> The new helpers bpf_tcp_raw_{gen,check}_syncookie allow an XDP program
>>>>>>>> to generate SYN cookies in response to TCP SYN packets and to check
>>>>>>>> those cookies upon receiving the first ACK packet (the final packet of
>>>>>>>> the TCP handshake).
>>>>>>>>
>>>>>>>> Unlike bpf_tcp_{gen,check}_syncookie these new helpers don't need a
>>>>>>>> listening socket on the local machine, which allows to use them together
>>>>>>>> with synproxy to accelerate SYN cookie generation.
>>>>>>>>
>>>>>>>> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
>>>>>>>> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
>>>>>>>> ---
>>>>>>>
>>>>>>> [...]
>>>>>>>
>>>>>>>> +
>>>>>>>> +BPF_CALL_4(bpf_tcp_raw_check_syncookie, void *, iph, u32, iph_len,
>>>>>>>> +	   struct tcphdr *, th, u32, th_len)
>>>>>>>> +{
>>>>>>>> +#ifdef CONFIG_SYN_COOKIES
>>>>>>>> +	u32 cookie;
>>>>>>>> +	int ret;
>>>>>>>> +
>>>>>>>> +	if (unlikely(th_len < sizeof(*th)))
>>>>>>>> +		return -EINVAL;
>>>>>>>> +
>>>>>>>> +	if (!th->ack || th->rst || th->syn)
>>>>>>>> +		return -EINVAL;
>>>>>>>> +
>>>>>>>> +	if (unlikely(iph_len < sizeof(struct iphdr)))
>>>>>>>> +		return -EINVAL;
>>>>>>>> +
>>>>>>>> +	cookie = ntohl(th->ack_seq) - 1;
>>>>>>>> +
>>>>>>>> +	/* Both struct iphdr and struct ipv6hdr have the version field at the
>>>>>>>> +	 * same offset so we can cast to the shorter header (struct iphdr).
>>>>>>>> +	 */
>>>>>>>> +	switch (((struct iphdr *)iph)->version) {
>>>>>>>> +	case 4:
>>>>>>>
>>>>>>> Did you consider just exposing __cookie_v4_check() and __cookie_v6_check()?
>>>>>>
>>>>>> No, I didn't, I just implemented it consistently with
>>>>>> bpf_tcp_check_syncookie, but let's consider it.
>>>>>>
>>>>>> I can't just pass a pointer from BPF without passing the size, so I
>>>>>> would need some wrappers around __cookie_v{4,6}_check anyway. The checks
>>>>>> for th_len and iph_len would have to stay in the helpers. The check for
>>>>>> TCP flags (ACK, !RST, !SYN) could be either in the helper or in BPF. The
>>>>>> switch would obviously be gone.
>>>>>
>>>>> I'm not sure you would need the len checks in helper, they provide
>>>>> some guarantees I guess, but the void * is just memory I don't see
>>>>> any checks on its size. It could be the last byte of a value for
>>>>> example?
>>>
>>> The verifier makes sure that the packet pointer and the size come
>>> together in function parameters (see check_arg_pair_ok). It also makes
>>> sure that the memory region defined by these two parameters is valid,
>>> i.e. in our case it belongs to packet data.
>>>
>>> Now that the helper got a valid memory region, its length is still
>>> arbitrary. The helper has to check it's big enough to contain a TCP
>>> header, before trying to access its fields. Hence the checks in the helper.
>>>
>>>> I suspect we need to add verifier checks here anyways to ensure we don't
>>>> walk off the end of a value unless something else is ensuring the iph
>>>> is inside a valid memory block.
>>>
>>> The verifier ensures that the [iph; iph+iph_len) is valid memory, but
>>> the helper still has to check that struct iphdr fits into this region.
>>> Otherwise iph_len could be too small, and the helper would access memory
>>> outside of the valid region.
>>
>> Thanks for the details this all makes sense. See response to
>> other mail about adding new types. Replied to the wrong email
>> but I think the context is not lost.
> 
> Keeping my reply here in an attempt to de-fork :)
> 
>>>>>>
>>>>>> The bottom line is that it would be the same code, but without the
>>>>>> switch, and repeated twice. What benefit do you see in this approach?
>>>>>
>>>>> The only benefit would be to shave some instructions off the program.
>>>>> XDP is about performance so I figure we shouldn't be adding arbitrary
>>>>> stuff here. OTOH you're already jumping into a helper so it might
>>>>> not matter at all.
>>>>>
>>>>>>    From my side, I only see the ability to drop one branch at the expense
>>>>>> of duplicating the code above the switch (th_len and iph_len checks).
>>>>>
>>>>> Just not sure you need the checks either, can you just assume the user
>>>>> gives good data?
>>>
>>> No, since the BPF program would be able to trick the kernel into reading
>>> from an invalid location (see the explanation above).
>>>
>>>>>>
>>>>>>> My code at least has already run the code above before it would ever call
>>>>>>> this helper so all the other bits are duplicate.
>>>>>>
>>>>>> Sorry, I didn't quite understand this part. What "your code" are you
>>>>>> referring to?
>>>>>
>>>>> Just that the XDP code I maintain has a if ipv4 {...} else ipv6{...}
>>>>> structure
>>>
>>> Same for my code (see the last patch in the series).
>>>
>>> Splitting into two helpers would allow to drop the extra switch in the
>>> helper, however:
>>>
>>> 1. The code will be duplicated for the checks.
>>
>> See response wrt PTR_TO_IP, PTR_TO_TCP types.
> 
> So about that (quoting some context from your other email):
> 
>> We could have some new mem types, PTR_TO_IPV4, PTR_TO_IPv6, and PTR_TO_TCP.
>> Then we simplify the helper signatures to just,
>>
>>    bpf_tcp_raw_check_syncookie_v4(iph, tcph);
>>    bpf_tcp_raw_check_syncookie_v6(iph, tcph);
>>
>> And the verifier "knows" what a v4/v6 header is and does the mem
>> check at verification time instead of run time.
> 
> I think this could probably be achieved with PTR_TO_BTF arguments to the
> helper (if we define appropriate struct types that the program can use
> for each header type)?

I get the following error when I try to pass the headers from packet 
data to a helper that accepts ARG_PTR_TO_BTF_ID:

; value = bpf_tcp_raw_gen_syncookie_ipv4(hdr->ipv4, hdr->tcp,
297: (79) r1 = *(u64 *)(r10 -80)      ; R1_w=pkt(id=0,off=14,r=74,imm=0) 
R10=fp0
298: (79) r2 = *(u64 *)(r10 -72)      ; 
R2_w=pkt(id=5,off=14,r=74,umax_value=60,var_off=(0x0; 0x3c)) R10=fp0
299: (bc) w3 = w9                     ; 
R3_w=invP(id=0,umin_value=20,umax_value=60,var_off=(0x0; 0x3c)) 
R9=invP(id=0,umin_value=20,umax_value=60,var_off=(0x0; 0x3c))
300: (85) call bpf_tcp_raw_gen_syncookie_ipv4#192
R1 type=pkt expected=ptr_
processed 317 insns (limit 1000000) max_states_per_insn 0 total_states 
23 peak_states 23 mark_read 12
-- END PROG LOAD LOG --

It looks like the verifier doesn't currently support such type 
conversion. Could you give any clue what is needed to add this support? 
Is it enough to extend compatible_reg_types, or should more checks be 
added anywhere?

Alternatively, I can revert to ARG_PTR_TO_MEM and do size checks in 
runtime in the helper.

> It doesn't really guard against pointing into the wrong bit of the
> packet (or somewhere else entirely), so the header can still contain
> garbage, but at least the len check should be handled automatically with
> PTR_TO_BTF, and we avoid the need to define a whole bunch of new
> PTR_TO_* types...
> 
>>> 2. It won't be consistent with bpf_tcp_check_syncookie (and all other
>>> existing helpers - as far as I see, there is no split for IPv4/IPv6).
>>
>> This does seem useful to me.
> 
> If it's consistency we're after we could split the others as well? I
> guess the main drawback here is code bloat (can't inline the functions
> as they need to be available for BPF_CALL, so we either get duplicates
> or an additional function call overhead for the old helper if it just
> calls the new ones).
> 
>>> 3. It's easier to misuse, e.g., pass an IPv6 header to the IPv4 helper.
>>> This point is controversial, since it shouldn't pose any additional
>>> security threat, but in my opinion, it's better to be foolproof. That
>>> means, I'd add the IP version check even to the separate helpers, which
>>> defeats the purpose of separating them.
>>
>> Not really convinced that we need to guard against misuse. This is
>> down in XDP space its not a place we should be adding extra insns
>> to stop developers from hurting themselves, just as a general
>> rule.
> 
> Yeah, I think in general for XDP, if you pass garbage data to the
> helpers to get to keep the pieces when it breaks. We need to make sure
> the *kernel* doesn't misbehave (i.e., no crashing, and no invalid state
> being created inside the kernel), but it's up to the XDP program author
> to use the API correctly...
> 
>>> Given these points, I'd prefer to keep it a single helper. However, if
>>> you have strong objections, I can split it.
>>
>> I think (2) is the strongest argument combined with the call is
>> heavy operation and saving some cycles maybe isn't terribly
>> important, but its XDP land again and insns matter IMO. I'm on
>> the fence maybe others have opinions?
> 
> It's not a very strong opinion, but I think in general, optimising for
> performance in XDP is the right thing to do. That's kinda what it's for :)
> 
> -Toke


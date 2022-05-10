Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D73565224A4
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 21:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiEJTVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 15:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235496AbiEJTVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 15:21:32 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2087.outbound.protection.outlook.com [40.107.236.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9796324E033;
        Tue, 10 May 2022 12:21:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NBlLXIcDqqeLTYLSI537QwrPaKxs7sGjBhkorcoULiq6Z4pVL3t/mvxF2IzZhoGQen81h5yanw/uqkHFimtlpU+SKmh2Mhrjwgu8w0/Fcq41UWYrR1Az9+nGgT92ev2QumFODymzx9AN2gbeO9m8uruzPeKC6dw2IXocxeNbtLJKp9NFFbpqtEHRwU+2VgwWPTSG0cPmVxZbc1tbAayW4UxVDT+rSX4r1gqydoJcsB0YOEZy+6skS94KflLEetNoxvZGhRyk0NrKmMFTJLKAqCBjAODhLxGSRes59NDB1Xuj8Zyt/EGyr5R4GvfMcuKWHhC/8j3TJDDqJhYoCsGK9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GwNAX0PZ3LGD4b4/j/ulYmQZvWNXyK46kMIrfITwvwQ=;
 b=dD+Qlr9Dn70BodY1AYvQyvxMIwqX0INx2JcKnv1G1C8/PciXIirSd0vbndzx4iPFkGicDA8+qVgWiisH7b4r9GY8MEvtDBgoSdDJ1wILUu3T5Rk05nTy7exPpLVAi8SldX6R31nVr2+olCGOHyhZVlcHyDAoGCjRZTQ0e2NsVc3fG+XVQVXXzMDXRfp0DnQo/Lw0iWxqEl07Gj5m0d2k0J63l/8TrtzWq0zMFrJpiO86BMw9aKZm9en5iRRqDc7QC7ZymgQGw4YqPVZGT9fGLNvQkpWQjDcqSRZoB2PJk/kMloaqknEGhmFhGR7EezOENVDUwHGog0EM0nuZfP9Apg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GwNAX0PZ3LGD4b4/j/ulYmQZvWNXyK46kMIrfITwvwQ=;
 b=G/OxXhQtzqNZ5m0N82/e8/g0FWCheNnaaCtWLl81PWafETlu7/UwYJYDDCAafOWEeWukg7/hpudnIXNTGHTkEkFbz3SVTOaEyOKvf90tY4sKGflB4tEIadzHiA1tKq0Hm5B9Deh0Zwe/hdQML3aTFvoVLKPCx08so17uYsw9WExKQR6JXSovnFQh6Wh6sSNLfwRRHBy1VD6FbJeakvm0iw1Xmn7FVhTQm+nMDeQdGHZAjxeVEuOk4ETnAHvGTB9U7ZNVvX49lIHtj/qMaHi5HAaenDM1ur4t81Y+XbS62iN1ytU5X0QgtUs+/awWiPCHM8h1ybU4iKp2Z4zOhhfW2w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5150.namprd12.prod.outlook.com (2603:10b6:5:391::23)
 by BYAPR12MB2855.namprd12.prod.outlook.com (2603:10b6:a03:12c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Tue, 10 May
 2022 19:21:25 +0000
Received: from DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::a186:70f2:4280:14df]) by DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::a186:70f2:4280:14df%7]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 19:21:25 +0000
Message-ID: <a330e7d6-e064-5734-4430-9d7a3d141c04@nvidia.com>
Date:   Tue, 10 May 2022 22:21:11 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH bpf-next v9 0/5] New BPF helpers to accelerate synproxy
Content-Language: en-US
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Joe Stringer <joe@cilium.io>,
        Florent Revest <revest@chromium.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Florian Westphal <fw@strlen.de>, pabeni@redhat.com
References: <20220503171437.666326-1-maximmi@nvidia.com>
 <CAEf4BzbSO8oLK3_4Ecrx-c-o+Z6S8HMm3c_XQhZUQgpU8hfHoQ@mail.gmail.com>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
In-Reply-To: <CAEf4BzbSO8oLK3_4Ecrx-c-o+Z6S8HMm3c_XQhZUQgpU8hfHoQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0289.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a5::13) To DM4PR12MB5150.namprd12.prod.outlook.com
 (2603:10b6:5:391::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d5bc8f8a-0a3d-4236-d4d3-08da32ba467c
X-MS-TrafficTypeDiagnostic: BYAPR12MB2855:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB285582649E5BF95726B5E2F8DCC99@BYAPR12MB2855.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sesT4gIlTYGZjCoI/uUotkd6udFpt23JDYvzZ3eMB4X7NNGfWcbfuyWkXwPfcD3HRmG2rdKAz1W2v1tP3CYpezw3metKGSEW43sPwgcuBMxqjr8Cx6aj7zb5GgBrWzSYceEyBMVEV6GgN9Em9kTbibuA3TvhCtwyMZ0B5vgnoq56V3A6HNRSZ7Zu4C0imhsL1aPrtBy0G70JT11603HdrRahx+1n3sYxJNHBkJrOifWVwgCVK5QjcoiLZII9trkKsBYpwlOFl8uOw6tKbO+1CibYg9zSlwS1vS9h3Jb8ba92toFdttZeI+UVAk0/MY6qzIsVScXRGEhQBHPps20d+gAhH8eVH9jzU+NDvTbncINz6c+YN5wtzOFlfZXOND1YNWbQx9z/WabKAAJ2uGyGAMLUalu7OZSz+nOxwvPihvqpFkR3mCqEdFBZSG8e5DNzT0fbAg0r52DPqJSmY0wSUryJ8B99JZTYwKK4AJFarpyN3XBGRLQ3v/yFL692578vCEm/tVLVb0k+IEEuimuYoz9QhN3Zhc1PidUltnOqHC0FLfrUh+vpenPqpJAtST8YrSFL8Xd5a8I5WCZ9kZ6xIMcDwk+Bn1P03QjNCFxTvT/Vwfr8hOv1Zeau8M9y8bi9yvJ5e8J0/vQHFvk9eD1mbJv4PWiaiTcjWwR/vRxCZ3ECZKoOQZQd9OH4Js7Nxa1qIvEtVA9JpwFtnkvcw27Rx57u8nB13go7I6cVo2p/E/WjBscH1tW27jQovc6AMwUMkp0cUwU73rSHaD4dQKNZngXvjsduF+DsZyubIzUOg1i8tTlJB+BicMec99uaDMB0WGQHSEPDC6x7SN00Lu1CtOSWmSEFfHaf3VWrezfKDTk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(53546011)(86362001)(38100700002)(83380400001)(6512007)(26005)(31696002)(2616005)(186003)(66476007)(31686004)(66556008)(8676002)(316002)(8936002)(4326008)(66946007)(36756003)(5660300002)(7416002)(2906002)(508600001)(6486002)(966005)(6506007)(6916009)(54906003)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d2w2cmtYVm1KTHZuOHMxV2ZKOERRVGRwZS85VFQvRnZBM2hmKzhmM2RlNnF1?=
 =?utf-8?B?OUV0QTN5dHF4MElWSC9JWDh3dTVKZUpzL0d4MEU5ZkM3UjJvVnhaZ1V5WFYz?=
 =?utf-8?B?Ykl4L1hUem1FdUFpK0tmS2ZSU1BiRDdJZjE3TlRNYmwrQk93akd2QjhuMnM3?=
 =?utf-8?B?eTNzczBjVlZsNmh4SWUwQmhvSFhMOU1vZUpKK0UzSFdjQnZhbjBzandYTGN2?=
 =?utf-8?B?KzNJK1RESXVEVURaZUFaenJoODFDSlZLeTQyWjBOQmNRZzhYN0RWVEJEZEFR?=
 =?utf-8?B?U2M1eFo1S3dicU1hYUdqaVFQVFJMbTkvK29SK0Uwang0d2hOQ2VsUEVUbUNi?=
 =?utf-8?B?UHlJa2RUcU1LaFVocFBhaThoNWVMSGFXa1ZEbTViY1FOOGpIeG4yb3djbytv?=
 =?utf-8?B?NmtnQ3M4aFBwQ0RqQmk1cmlmeFF4ZnZGOGpGaG5FSk44Y0o2NmJ0ZzhLemsz?=
 =?utf-8?B?bWhybUtCc242VC80YzhiMUQ5clgvWk13L21xeE1aUVN3WTBYbEdNZTBCMC9o?=
 =?utf-8?B?aWd0MUl6ZldxVVFnWHhYdXRkOWtvclZkRlo2R2x4NVhTTXJNc0U0dGZZWlFY?=
 =?utf-8?B?bVF1ZjExcXY3K200WU5KTXJaMnFNQnVvelhwTVRNMW9icWRrT2lzQ2wrZmds?=
 =?utf-8?B?d3ZGNEZ0OTN1bWlxRDNpMmZ4dmxrTitiOUViNEdqMElCekpjQSsvaTBVZUxU?=
 =?utf-8?B?UjZRZ1R4aU5zb21icU42bnhKckVIcmVoWnJSTkpZUk80VjdLMExhZzEzSlJw?=
 =?utf-8?B?Z0xJS0FjelBxNjlVKzVXYkIzNEcxZnl4NklkTHI1VmFQRmd0N3FjTG9rU2FM?=
 =?utf-8?B?TlM2MjA1WUxrUWdhaGtYMS9uZnp3SlRhOUkvQjJabWlLRlAzNjl2dmJoNE9W?=
 =?utf-8?B?QTE3U05lckZaK2JFY09RanpRaTJBWC9oWG9KeDZ2akZIQkVJYVZycDYzcUZt?=
 =?utf-8?B?M1B2Z0REOXR1SWZ3Mm9SZUc3RWUyZiszd05teUJDZWhYRzFqc0JaaENxUElC?=
 =?utf-8?B?bXpQd29VL053a3R2NjYyTHlWUGI4NENVeXZKWUxWM3o4NTFyQnVJNW1mUEI3?=
 =?utf-8?B?Z1VPRWplUUJEdHhGdlhNL3JoRUhRS3g4aVp4Y3ltYkt6b0RiVlF4ZTE4V2k3?=
 =?utf-8?B?KzMzVk5LUC9CYjA0T1dRZmhnYTZkQlRMdklvZ3VHQW00RnhiWElNaHVEem0v?=
 =?utf-8?B?ZU1STnN6cURhUUpmb1dOcmdkSm1Yc2M1MUJqMzNVQjB4ZDNtU01NcFZsTmkv?=
 =?utf-8?B?NWdUWlhKem9uOFVza2JBYWxSRGVGKzZ6TGRxOEtkZWZWWitnVlpmTHgvU3VE?=
 =?utf-8?B?RXdqd2h3dG52QlBhZnpYS2JEeTg0V1p2Sk5wV2dTRWY1VmlxRld4LzdTSEV1?=
 =?utf-8?B?MGF6M2YveUR4VU1yeCt6RmNLbXBTNmp5c0E3V1RJSURReG1VNzd0VFRLZUgv?=
 =?utf-8?B?Y0cxc3V0K1YzL1NYangxK1pKa0NQR3NvdW15bkVRdFlVbG4wSXpnMDZScFBt?=
 =?utf-8?B?Ulp5Q21kS3QzMFI3Z2lWbmFXVEtrWUVDNW5ESjhlT0szcXhZaFJmc3RvaExz?=
 =?utf-8?B?YXJmeWtxRmJFTDhabXRXQTV3YUlvbU9INHdwWEZhOEpRa0k5ZFFEcDBKOEd5?=
 =?utf-8?B?ZUtYNDN6dk5LNGQrL2VYeWVTampTOWVXQWpZS0lobG1FYnAwUGc3U1lIanIv?=
 =?utf-8?B?UmRsalhyOUFqcHEyaXZScTZxTk1acjBhN1FLZmVvNDFUcWpiRmgxMm13ek0y?=
 =?utf-8?B?YW1rNkc3UzIxalQ1TVdkMHBSRHN5SG51ZSs0ejdMS1UxaXhlWFgxS0doRkJL?=
 =?utf-8?B?ZFZ3TVR2NTJHcnZrRDEvU24ybU9ydjErRjRIZU1uQUZFNHBabW8zVkhUWFYz?=
 =?utf-8?B?Wk1PRi95eVpOTU1IV054S2hNdWpDVGRMOCtpbWpId2paMURaZlV5Q21QU2Nu?=
 =?utf-8?B?M1YyQjBjb2dUSkpMNXF6Y2M4RlRYbnJYWFlsSmJLL203Tm9YckJmV0U4TC8w?=
 =?utf-8?B?VTRTT2FqVXdLOEpwZExENDg1ZVNFSCszV2p6b1EyditZdEZBUzdsb1d1Smhw?=
 =?utf-8?B?SGhFeXpFY29jcndPbFUvZnIyeHZzY0N4U2pXSUROUnpBanJvWkhnbW42N2tT?=
 =?utf-8?B?ckh1VkJqQ1ZPaEprdnlwM1RqMmM4N3pEM01pbUFYZE9tSGhsMmlSa2hUMkpr?=
 =?utf-8?B?Wm0wc3pxV1g4UUZocW1zQ3lQK0ZLMy9NQkxQcEF0dTVWNGlaOUczZGlvUnp0?=
 =?utf-8?B?akRsbkNZekFIM0swN1RlMkFwOGw1WFdicnZ1aDhmL0hNWUVxS0wvM0I3ZGVP?=
 =?utf-8?B?TkVqSjdScEN0b000ZUgrV0FQUTUvN1hJT1Z0NkdMVU0zTnlKaVVaZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5bc8f8a-0a3d-4236-d4d3-08da32ba467c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 19:21:25.5801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4QpIkQJcKSKAo+2gNp73R1zBXGLaThGcURSFEXI+ATarcFAp4JnADjdmMAvc8kYCIDeY5BSP6adZ2FMugSOw0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2855
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-05-07 00:51, Andrii Nakryiko wrote:
> On Tue, May 3, 2022 at 10:14 AM Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
>>
>> The first patch of this series is a documentation fix.
>>
>> The second patch allows BPF helpers to accept memory regions of fixed
>> size without doing runtime size checks.
>>
>> The two next patches add new functionality that allows XDP to
>> accelerate iptables synproxy.
>>
>> v1 of this series [1] used to include a patch that exposed conntrack
>> lookup to BPF using stable helpers. It was superseded by series [2] by
>> Kumar Kartikeya Dwivedi, which implements this functionality using
>> unstable helpers.
>>
>> The third patch adds new helpers to issue and check SYN cookies without
>> binding to a socket, which is useful in the synproxy scenario.
>>
>> The fourth patch adds a selftest, which includes an XDP program and a
>> userspace control application. The XDP program uses socketless SYN
>> cookie helpers and queries conntrack status instead of socket status.
>> The userspace control application allows to tune parameters of the XDP
>> program. This program also serves as a minimal example of usage of the
>> new functionality.
>>
>> The last patch exposes the new helpers to TC BPF.
>>
>> The draft of the new functionality was presented on Netdev 0x15 [3].
>>
>> v2 changes:
>>
>> Split into two series, submitted bugfixes to bpf, dropped the conntrack
>> patches, implemented the timestamp cookie in BPF using bpf_loop, dropped
>> the timestamp cookie patch.
>>
>> v3 changes:
>>
>> Moved some patches from bpf to bpf-next, dropped the patch that changed
>> error codes, split the new helpers into IPv4/IPv6, added verifier
>> functionality to accept memory regions of fixed size.
>>
>> v4 changes:
>>
>> Converted the selftest to the test_progs runner. Replaced some
>> deprecated functions in xdp_synproxy userspace helper.
>>
>> v5 changes:
>>
>> Fixed a bug in the selftest. Added questionable functionality to support
>> new helpers in TC BPF, added selftests for it.
>>
>> v6 changes:
>>
>> Wrap the new helpers themselves into #ifdef CONFIG_SYN_COOKIES, replaced
>> fclose with pclose and fixed the MSS for IPv6 in the selftest.
>>
>> v7 changes:
>>
>> Fixed the off-by-one error in indices, changed the section name to
>> "xdp", added missing kernel config options to vmtest in CI.
>>
>> v8 changes:
>>
>> Properly rebased, dropped the first patch (the same change was applied
>> by someone else), updated the cover letter.
>>
>> v9 changes:
>>
>> Fixed selftests for no_alu32.
>>
>> [1]: https://lore.kernel.org/bpf/20211020095815.GJ28644@breakpoint.cc/t/
>> [2]: https://lore.kernel.org/bpf/20220114163953.1455836-1-memxor@gmail.com/
>> [3]: https://netdevconf.info/0x15/session.html?Accelerating-synproxy-with-XDP
>>
>> Maxim Mikityanskiy (5):
>>    bpf: Fix documentation of th_len in bpf_tcp_{gen,check}_syncookie
>>    bpf: Allow helpers to accept pointers with a fixed size
>>    bpf: Add helpers to issue and check SYN cookies in XDP
>>    bpf: Add selftests for raw syncookie helpers
>>    bpf: Allow the new syncookie helpers to work with SKBs
>>
> 
> Is it expected that your selftests will fail on s390x? Please check [0]

I see it fails with:

test_synproxy:FAIL:ethtool -K tmp0 tx off unexpected error: 32512 (errno 2)

errno 2 is ENOENT, probably the ethtool binary is missing from the s390x 
image? When reviewing v6, you said you added ethtool to the CI image. 
Maybe it was added to x86_64 only? Could you add it to s390x?

[1]: 
https://patchwork.kernel.org/project/netdevbpf/patch/20220422172422.4037988-6-maximmi@nvidia.com/

>    [0] https://github.com/kernel-patches/bpf/runs/6277764463?check_suite_focus=true#step:6:6130
> 
>>   include/linux/bpf.h                           |  10 +
>>   include/net/tcp.h                             |   1 +
>>   include/uapi/linux/bpf.h                      |  88 +-
>>   kernel/bpf/verifier.c                         |  26 +-
>>   net/core/filter.c                             | 128 +++
>>   net/ipv4/tcp_input.c                          |   3 +-
>>   scripts/bpf_doc.py                            |   4 +
>>   tools/include/uapi/linux/bpf.h                |  88 +-
>>   tools/testing/selftests/bpf/.gitignore        |   1 +
>>   tools/testing/selftests/bpf/Makefile          |   5 +-
>>   .../selftests/bpf/prog_tests/xdp_synproxy.c   | 144 +++
>>   .../selftests/bpf/progs/xdp_synproxy_kern.c   | 819 ++++++++++++++++++
>>   tools/testing/selftests/bpf/xdp_synproxy.c    | 466 ++++++++++
>>   13 files changed, 1761 insertions(+), 22 deletions(-)
>>   create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_synproxy.c
>>   create mode 100644 tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c
>>   create mode 100644 tools/testing/selftests/bpf/xdp_synproxy.c
>>
>> --
>> 2.30.2
>>


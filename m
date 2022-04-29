Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73F0951455D
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 11:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356553AbiD2J0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 05:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356539AbiD2J0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 05:26:40 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2065.outbound.protection.outlook.com [40.107.95.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75CFFC614D;
        Fri, 29 Apr 2022 02:23:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gEJaJdR7cRjuuQGNBKY2TJpUMPujOG/eEzytXobqS3nmJK4OuqBQn2bqCkHxbCKftWY6PqxKkjKXBMPLkUGrGI3svked4RAL9PGZn6vCDGO1Hr+X7wyD4jBG7pI82Irh8Hi+KqnubsVpK0MN4dNN/QxQh75K3bhgQIw6tX9PVqdDKOPfdu9pz2risDa4P9DlD9lYmWXt5k9JVrLN4y5KiZ6q0z67mC3icJ9A60Yc+3maijwzN/7AaDWlx+4O3YQFY1RqKcWTXstf+xJysi7H0E9q0VvamobD63qS3s4ZHwBNN5AI2J9iUGl+0+CglL8NWo0YKI5rapHyVfatlLj8Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TyiXUIW+5OOQ/0mVb4pPcZi0CmUxiKWVSRtDBjvI1uQ=;
 b=dzn+2fON5ut48BKKUFMhbcShfnsENcH0yNDZv6JDJEONFOTlzQwuQrgvjOk6wVYz/tZknKXnZsN5HTp2b5TX7KPIy/okhn0MI5CazXpugHE32uy1/7pLGyFX+5xGCU4UxaxLWklTuCwzbLja3bqELd8iS3Q5KPNxqn1+vavqM6eeEOM802n5AFWiKMYs1bJ99MNSpjHiS+jM51Y8Yq6LOugR1ynNZs41ucKOFhkVFKywEKZLOjlIFRJ4U9Mdvibv1vzCGexN/gNAY/SmmrkaRJASCCg08zGdFwXC27Ns8GUl7vkSlFa1e9IYi8NlXxXzy2FdLIHOD2D0QG1fVE/HaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TyiXUIW+5OOQ/0mVb4pPcZi0CmUxiKWVSRtDBjvI1uQ=;
 b=pHz7ZMoTQbkuEpIx4qnR0vIMyPJWo8CE8zS0Lj8JGkafQwMdLd2uJ+DRmrL7wk4itGMMiaPZNRz23REM9m1JivOphYXwQ5+k9gABRK0vkMFbaJ1hzPpm+Zx+BxSZKS5bj2prGXeg67NLMUA/m7Dl/SFDAR3riAyhcPVE4mTMPZTo/KHUhLZB8w0GruaoeWcFPZguRASG3kWSbhplLd923hOFeYL2J159d8N7xcGdfWByhXPmcnc9SBtIPARYKjBBv3vnP6qctEfuax4N9WKMsLSXWDDXeMi1gTNW2Stxh1UoQx21pU/STwfI53xDNKHUNq1XmhUq9w4GS41G6VBsig==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5150.namprd12.prod.outlook.com (2603:10b6:5:391::23)
 by DM5PR12MB1322.namprd12.prod.outlook.com (2603:10b6:3:70::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Fri, 29 Apr
 2022 09:23:21 +0000
Received: from DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::a186:70f2:4280:14df]) by DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::a186:70f2:4280:14df%7]) with mapi id 15.20.5186.023; Fri, 29 Apr 2022
 09:23:20 +0000
Message-ID: <0d496e79-afc5-39d6-59be-be4152b9b60b@nvidia.com>
Date:   Fri, 29 Apr 2022 12:23:11 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH bpf-next v7 1/6] bpf: Use ipv6_only_sock in
 bpf_tcp_gen_syncookie
Content-Language: en-US
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
References: <20220428153833.278064-1-maximmi@nvidia.com>
 <20220428153833.278064-2-maximmi@nvidia.com>
 <CAADnVQLw4yz_N3xR59XbSGdCH3ckU-pPWZ93JugomGejfo5hTA@mail.gmail.com>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
In-Reply-To: <CAADnVQLw4yz_N3xR59XbSGdCH3ckU-pPWZ93JugomGejfo5hTA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0005.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ad::17) To DM4PR12MB5150.namprd12.prod.outlook.com
 (2603:10b6:5:391::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a539f6f4-dd65-4476-1edd-08da29c1e6ef
X-MS-TrafficTypeDiagnostic: DM5PR12MB1322:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1322314B40DE3CC4480DD57FDCFC9@DM5PR12MB1322.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UvdXcnBB/AhE7Ae+8QUmhfvOP98EPnCZ2DQWKLp6g0JoNQRhl9wNI5VlMO1cu4oTNVFF1eyo9KV7JY/OMFHZV9v9dfTP1k+hM6y47YU8hTDqROGLiRJkSZ3Wz6PoHYhu+lDRUlo41Ou/Eo40iUgQyOajYI5/sQicgOCR7ZfN9dAIv3CaqVYheJUZXtPbiIASPCVXg0L0/4DID5QWy1GtNkVXsEaDLok9JRQVEYSzef1Jl1AiXFlPpAxwZrUHCx4TqeHskV7jyIiTaPdQMvxdAk7FoDYUgkf86HSODeEULDwSyswfsM5v+tI++lZpV0u4IKt1UjJ6mcMs3KapscUQ3ZYeaGbiwHTkDowjIzKxY0oFEKOqA7Pe3RJ/7hfum0FgL3g5t7RzAjQr/+GdaM+wvtd9NwFrBdubuRDw/2VCoKQbv/wTCjWFZDUD14B753K1OUTRD5OdTW8gsjzQWHXASbGxHvqQ0FeUZAq0xB+gztRB8w2QlMNjmrCvDLapxipq8Yx31x4DC8fLbeV6cQU/jQ/t7KvYxnBhQOgNGkI+MwOTix6UyGu93xMd1ougtHFiHinhsrMrRnMDGLwIt/ZQK85EYUwDbtOXG5/C4Nxu8witwqORwr2gnmCmY27vNdi1sGXledkTou9C+c0v2kj9ZQ+AUYET1NqGs6lC7heaU1vDWEaHcQP7BcVKUSXZeua/29Y1GXS0Qze6DsZTXcbaUfDC9vxyjTYPDZ9K9dOftck=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(508600001)(86362001)(31696002)(2616005)(53546011)(26005)(6506007)(6512007)(38100700002)(6666004)(2906002)(66946007)(66476007)(316002)(66556008)(186003)(36756003)(5660300002)(8936002)(31686004)(54906003)(4326008)(6916009)(83380400001)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RFhaNXRtQW5sSW12WWtoUExLeXYvRW0rZHZ0Q1RrV2hhOTZEN1l2dUxNTFh4?=
 =?utf-8?B?dStRelZQM0RtUDZHRE9zZ3gxU1lrTGMxNTFiMVdpN1c4NzVUMEZUeXFTc0sr?=
 =?utf-8?B?eUlSTUcvcGtPU0FuNUVYR1o3TnlWN2ZTQlBqUUttN25BMmZnRFhqMjQ5cGdU?=
 =?utf-8?B?YThXTTdxaE40WnlBMHBxRVJLTnVTYXphUmdTd1pYNnlUQndGTC95bkUyTkFq?=
 =?utf-8?B?MlNaaWhZdkF1OC9HMmhLalAxdEJlUExTZVlYRmRIWGlWRUZxMjZncXJ0TDF3?=
 =?utf-8?B?QmpsdmhYL1lOWUZVM1ZVQVA2QkVTR0dDY0pLNWNKeXVMcEx4a2hhMFk1dkNC?=
 =?utf-8?B?ZTVOMGxuV0JOUm94bWhBRHRGaTRpczNsS0hzKzBUT0o4d0R1akdZNTg0WWhP?=
 =?utf-8?B?VVQyWlhjTHVhcW5oTUk1SDVkMHRDU25jL0xHZG1FTGY1S1RpdlFqZ2tEN1M2?=
 =?utf-8?B?TGYyOHhPTCs1LzlpME5VT0JmUXdnaDcrU1FVaVFjaUplSU1oL3d6M3ZVUDJN?=
 =?utf-8?B?M3p1b3hpb0U4MWIxQnE2UElyeDhtNGdaVUFQRDJac0FEemUzYlkrV1NWclBU?=
 =?utf-8?B?L0phaEVWZ0llK2dhY3E2WFdLQ1NHV1dqdWJSZlNmelZmd1FSdkZyK0U1SnB0?=
 =?utf-8?B?V2p4b2RTcExraGcrQ3QyVHlvZ1poN3h6Rk14aDZrckJNc3dobnRHWnh6ZjFp?=
 =?utf-8?B?RlNTTEJyOUhLMkF0cU9ucjZkSEthdm9hTkZkWmdLci9IUWZUV2wyK1NMTWhJ?=
 =?utf-8?B?SVozZ20yTlpyWDZ0K2RHZ0xhL01vMDNQakkxZnRkVDBOTkQzdElyekVBZ3Ru?=
 =?utf-8?B?WFdpNkQxazRjOHZFeWlDTE5hSmxlQ3N0UEtpUDZ3QmdkQ3UzOXJORS9ITFJ2?=
 =?utf-8?B?Zzd5YkxGVkoyUk9kWjFTbXJuZDJ6VGdOcUs1d2tuY2lzNmMzZDRTOVhWWTFH?=
 =?utf-8?B?Y2JZSy9Eb1hWaGs2cXBVS251VlJQenhQcE81RWNlMlJ1M2lXQk1ScWtTYWZy?=
 =?utf-8?B?alUrLzFWM3lMd21lS3JqTXYvemZjdGFBaWs0bVl4NjB5RXlhem9TVU9HbkhL?=
 =?utf-8?B?b0hjUU9xN0d1RTZZaG1PaDFTOEovcGdLK1hUYWloc3d1c2tkV3R1UURGQnhQ?=
 =?utf-8?B?aXcwTnZsSDlHSmRXSG1BYUhsSm1BRkFYcGM4bGxiWGpISm50K0NPV3EwK2pI?=
 =?utf-8?B?N2w2bSsvZU5FUlM5UWZreVVRWmo1d1liZHdUL0FHd2hNb0JHU3RYYlZhSU8z?=
 =?utf-8?B?dWxseWZRaWV6MEdnZDJ5WkFEeHhhVlZSeDNMZ2xLelZrTDhMOTFZSHkrQ3g5?=
 =?utf-8?B?bEk0akZDUVRYbWpmL3NkSUNIQzlTb0RSTjJReWU2MzJicXNRb1V5b01mMFlU?=
 =?utf-8?B?eTNXbzJwMUtUOTdYTkhwOXBCT1g5K1RFdW5ZL0xZK3VPL0t3dE9GWWFaejE1?=
 =?utf-8?B?eXBoNWg4NXRLZzhadWcrQTN3SGR5SWZqRC9vUG9EWG1SWktVaUt6WTVza3hu?=
 =?utf-8?B?eWdaUFRyVk1lZHRua0ZqQjk0bHJHaVQwWkdqL1lDT0NCd29zZUJMamlqOFZt?=
 =?utf-8?B?UGtqSFFJQ0txR3ZvMEdaZWlHcFhNbTI5MXBhYkd0dmlBemp5ays3dmNYakdZ?=
 =?utf-8?B?aS9jeWgwVnFYa3VKR2dPZk9JVUQvZDVPL1JCSUNnV0VVaUxZTFhqbFFqTFdm?=
 =?utf-8?B?Z1dQMlR4YkduTitkWXlPZjNIdlAwVTVMWU9jL1J5b1AycmkwK1FoU1ZTVXIx?=
 =?utf-8?B?WmZrTkRhNmMxam1RcGNxZVh6enROWHcxUFduSHdzU1dxNGp0OVBRbk9HM3Zl?=
 =?utf-8?B?VVJwclJ6NXZHQVlxVG4rZkRxVTdOMEZ6aHYvcnZjeklzbzhzMVdVQlgzS1g5?=
 =?utf-8?B?WjdrdzdDQktWT2haQ3NRN0hMZDJ4T0ZIdE13dnlkdUVlTmJISjJqakN6Zy9o?=
 =?utf-8?B?UkdKSFlsREQvVHVGUlhmQnpuUkV2SkZObVVGODZUQytaZGtBOG9HNDdxa1p2?=
 =?utf-8?B?cUF3OEZSckM4dGVzb0hQc0xFUDlaODR5aWFBSjRDV3hIQ2NFSHl2TXRnUWpu?=
 =?utf-8?B?NmlBNDh3TzBJenFxUm9NRHNOS1NkdVJiNDk0L1NoZ3Z0aVlUQmdQWm1CZnhK?=
 =?utf-8?B?UG9FR2FRVmNwM0ZoamJ2RC9qV1hsMnptdTVTbVlnNm4ySm94QUhFZ3pjYm40?=
 =?utf-8?B?L0IvR25nemRZYXBJdlZ6aUxNMEdCWVo3Yzd0am9mcTdCbjduKzQrVHI5RjZp?=
 =?utf-8?B?ZldDRmcrdTZTR3RuekRXSmRiSnVnaXdzSG8zM09zSUhqVklDK29PN1ZzTG1h?=
 =?utf-8?B?Smhoc2VWa284R3JLVHZ1ckxkUUlUcnBLcnIyUzFFamtTM0VjWklzQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a539f6f4-dd65-4476-1edd-08da29c1e6ef
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 09:23:20.8546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dZTIvT4Rfjb10U33csbUKLjzdjJfmYoXw9rQocYfQZdK4j2TGrFUf3cuMxGdpkvkTZ/rrJZq/++QnmhGrXCoHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1322
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-04-29 06:15, Alexei Starovoitov wrote:
> On Thu, Apr 28, 2022 at 8:38 AM Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
>>
>> Instead of querying the sk_ipv6only field directly, use the dedicated
>> ipv6_only_sock helper.
>>
>> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
>> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
>> Acked-by: John Fastabend <john.fastabend@gmail.com>
>> Acked-by: Lorenz Bauer <lmb@cloudflare.com>
>> Acked-by: Petar Penkov <ppenkov@google.com>
>> ---
>>   net/core/filter.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/core/filter.c b/net/core/filter.c
>> index 8847316ee20e..207a13db5c80 100644
>> --- a/net/core/filter.c
>> +++ b/net/core/filter.c
>> @@ -7099,7 +7099,7 @@ BPF_CALL_5(bpf_tcp_gen_syncookie, struct sock *, sk, void *, iph, u32, iph_len,
>>           */
>>          switch (((struct iphdr *)iph)->version) {
>>          case 4:
>> -               if (sk->sk_family == AF_INET6 && sk->sk_ipv6only)
>> +               if (sk->sk_family == AF_INET6 && ipv6_only_sock(sk))
>>                          return -EINVAL;
> 
> Please rebase patches before resending.

I'm sorry - it's totally my fault! I didn't fetch before rebasing =/

> Applying: bpf: Use ipv6_only_sock in bpf_tcp_gen_syncookie
> Using index info to reconstruct a base tree...
> M    net/core/filter.c
> Falling back to patching base and 3-way merge...
> Auto-merging net/core/filter.c
> No changes -- Patch already applied.

Someone else has made the same change as my first patch, so I'll drop it.

> Applying: bpf: Fix documentation of th_len in bpf_tcp_{gen,check}_syncookie
> Applying: bpf: Allow helpers to accept pointers with a fixed size
> Applying: bpf: Add helpers to issue and check SYN cookies in XDP
> error: sha1 information is lacking or useless (include/uapi/linux/bpf.h).
> error: could not build fake ancestor
> Patch failed at 0004 bpf: Add helpers to issue and check SYN cookies in XDP
> 
> 
> Also trim your cc. You keep sending to addresses that are bouncing
> (Lorenz's and Petar's).
> 
> Remove their Ack-s too or fix them with correct emails.

As we don't need patch 1 anymore, I will drop it, and we won't have 
these acks anymore. I'll also exclude these people from CC (I only kept 
them because of their acks they gave when their emails still worked).

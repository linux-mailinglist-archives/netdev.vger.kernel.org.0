Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF8A163E6FB
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 02:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiLABQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 20:16:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiLABQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 20:16:41 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65CB3975F6;
        Wed, 30 Nov 2022 17:16:36 -0800 (PST)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AUJW1hE008932;
        Wed, 30 Nov 2022 17:16:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=Ib0S2vpiIoAOO5E3YN/Vuoh6pp3hSVd2NTahFO+l7A4=;
 b=ZbowZ4LkZGq4z534JpN7Is67+ydfyJTb4YPX2pvaLB6ANHhZy4STqhNenTd2skdU3xB0
 XuYr6ss6kXFmsELd3jmQw1gtE40LGkrSyFCwhQMTmRYbv3MXlQ5z2EHkkTxI5mUHDOnI
 C2LUZ2KVCHcUnfJ2Izo8tNnLnNSzsAuenhoqbohPK9mw5hfa2X1YgowiNFm03T4OVfOM
 fxcSqzDnz7F/RpgqKUC+VLFcapOCekXc602L9bTIZsiY7CKMRQG2y5gDrxAQG3thu6eL
 7yuFdIKST/vj1WKQRGn+LBhd0n39XTzNzouatd0eVBRd2P+1G6qF992YjU01h7/0nnmM rw== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3m5w6akgg4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Nov 2022 17:16:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GrTksy9ufskcVxrw/e2JHINs6Jyu2r2WESeaBXXGuvZhrduiGnApQ/w+28P7acJkPB3iUK61OSR8TT43FzbBYmtfpPNBjrwSXN24A08Ukr2OyXXwH6iQ9Le2ORuqOWfqGgAvesSEkEeQYTmxquQPivkAUHHX6SYFexDbs1CF/79IXt8ML+29liar2+RaRRdEzdftst2wxm4ALtj4tq0ZOB0g65Y3Ht0XhXOiW/pOgZc66t1xl/ju4JxiR69JWB3aQdtl2Nz6JB84F5tMcHUj4A8SCV4S4MyUn85Rbtu2076AasAGCnM6kZWKJQnXG59fnSLzsJag82X4VNhQIZ03Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ib0S2vpiIoAOO5E3YN/Vuoh6pp3hSVd2NTahFO+l7A4=;
 b=LKLWBOfeMP2bclq6DIzgZ1FJzGTemfGo++xCtQ2oBj2Er4HQuwt7DClOzWJMHijdErIu1SDcISSn45mOfK4Y8icpbr7GzMS5zDI6m2LdcVNq5IcpLX5eF965+0kfkwGMcsT4ee6fvJuiVKzlI719loQhEPoHCGF4ZJExIO1NruyQJwOiJzfGGKtoEkGy+hLEQVv+47qnj8igh4t32wvkeEAyJVSE0zzFkQ9OgEyieirAFmD3+qxatQrMytUhvuVlbhxwpVV5WDQRHDOIZFxNUyLh2xql4ArsbuMDl2j63Q9n249xuf/9Tx0jn+JfzNk5FMrdZA8R9KMs/ax23b1cow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BL0PR1501MB2178.namprd15.prod.outlook.com (2603:10b6:207:35::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 01:16:09 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d665:7e05:61d1:aebf]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d665:7e05:61d1:aebf%7]) with mapi id 15.20.5857.023; Thu, 1 Dec 2022
 01:16:09 +0000
Message-ID: <b075ae0a-2829-310d-ec34-f5706520c435@meta.com>
Date:   Wed, 30 Nov 2022 17:16:06 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
Subject: Re: [PATCH bpf 1/2] bpf: Add dummy type reference to nf_conn___init
 to fix type deduplication
Content-Language: en-US
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Jiri Benc <jbenc@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
References: <20221130144240.603803-1-toke@redhat.com>
From:   Yonghong Song <yhs@meta.com>
In-Reply-To: <20221130144240.603803-1-toke@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: BY5PR20CA0023.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::36) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|BL0PR1501MB2178:EE_
X-MS-Office365-Filtering-Correlation-Id: f32b1409-418d-46d1-13f1-08dad339a0eb
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mc0JZPUxSQ4zXhm441tmMYSVCbdlblSR6Jj6w01MoPQKsSJtdQZ8qNgin+elr7SPJ2gMlJB/jMSUQ8HhnE/Scw8BGrESJcxLrNL6BUasGQ0Za8baIwSL4LSYDHFLi4lriaqG+Eg4yOROrbLQzXrbH+Ooz8b2jzAnXWXCUrIxdprme/ZoRZjC/Ip7stRyVSh7x5NTH4BMNqgRUkFzw7V66u6OvYHotEj2wFA1LAJfEIcVn4lLHkVF0tf2+J4gaKZdvquWlfho+Ym9I4dInPP54AJIPpH0bDRdcLO/E6Eeoa3JdLayCJM3VMos/EVRNEI1jpTHoIBc/no6nROpW/XCiJbQtkO14nUNRYZXSLZuu5oOficnAvzKdQCUEwmykf4fOY+E57GBMxoz8tbatslcuRl85rH67uP15EuokPH/rMBbBQnAkOWBu4zYcn/a9OgEerkAD9PEglsXTQCuVxTR0HHTpwNOmdqemD23z3Js0XggaikgMNLhEx6ADY1cHNUJ3hjdGHB2lNXt1N5OieDplAe77lE7W3RH2j0VN2NnBaFEepZcNRhN9NwucahKqZCMgdf2BVkZTWl3vOZRuJijEoPlS00Ab5bbwfKF2h8Qht16NACjVGeqv6uOjhOtYo8gKuxYCizO5gl6D63nP5gENYbce0uqwrPheNjDv98FcbAc69VMQwVE9HlPdY/HcLMhBieS1+PDM9N9901+OEcZU0+kjzlX6miKNxKv8O/zwYJXMO2Mp+bPWVOmracTUfa2x4v/EANIlYQVOPZNlUwfIi3M/VlrCfhZHhKH8o5V+Ew=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(376002)(346002)(39860400002)(366004)(451199015)(2906002)(31686004)(2616005)(41300700001)(66946007)(186003)(36756003)(921005)(86362001)(31696002)(38100700002)(6512007)(110136005)(54906003)(8936002)(5660300002)(7416002)(478600001)(4326008)(8676002)(66556008)(66476007)(53546011)(6486002)(966005)(316002)(6506007)(6666004)(101420200003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?akJMTzJ0TThsb0dhbjRpaFp4SThtUVdtRlphSEp5ZDNwZ3kzY0pNaXFJbnBR?=
 =?utf-8?B?SXM0ZDJ2SFNwenp3cDFuOHB6TU56elg5UFE1L0VTMnA5ZjRCc2xRMXFCUmRv?=
 =?utf-8?B?SDY2SmZlU1kwbkwwT0pYZTU1cW8vaExVbnhsa1Y2dE9jcjhXWUhsV3VFNzBQ?=
 =?utf-8?B?QjZjdmlaTUhkL25zanRvejBHNWxpVEJQdGlvRk55dnlKZXZJaEFwRVRIT0Jn?=
 =?utf-8?B?V0RsY0lQeWM0VEszeXRmNDVKMS9HYmVqcGlXQ1grVXZxcXcyWnBid1RRMWFo?=
 =?utf-8?B?RGZ6UndObXl5QUtEaWpTdjlLc2VBN2d2SG1pZEhBeGNJSE1VRzl2ODZaalll?=
 =?utf-8?B?Mll6RWo1YkZFcTMrQ3M1RHA2SVlqZHVzVi8vTU5nUE9NcWozMjJYNEZiRmJ3?=
 =?utf-8?B?UUw4cEJTclFFdUkwOUFZbzZlRXpPVmN2WWdRbk1hQUUzcTl1aXBOR25lZktm?=
 =?utf-8?B?ZHYxV3o2cW1zRk1PQVFBWDJ4cTQxclNDOHlLNTZrWEtQWXkxOGkvaStoUjBo?=
 =?utf-8?B?b3dOeE10YVVwM3hjNGRxWXdYZExjQ2xDMStidVBYYmVHMGdSeDRrSCtYc1Jr?=
 =?utf-8?B?S2VDV3VUMS8zbzZPdXJoMStpeDNQKzl1eFh3VUpKenNzaEk0U0V5TkxxZXVp?=
 =?utf-8?B?UzMzS21HNlJrdmpFTTdhSlJGR3BVK1owRWc2TmQ1MFZpZ1pOeTdRVTRXWThF?=
 =?utf-8?B?ZTdZRkxRN005a1JwcHlyUElzNDQrenV2cEVGRm1Va0ttYlhTbm5oaGh6aERL?=
 =?utf-8?B?VFdmZXBYRnBtcjNBQlZLNTNLZkxLZ1JHeHBRTFhSV0tvUTBvRHo5aGlIbVpX?=
 =?utf-8?B?V0prMUs0TVJkd3dLNUx3clhNMHpVblR0bDROWjlKdmllT1BXRlBra0xjQThm?=
 =?utf-8?B?REJxL3cvK0JodGtoOGVram13Nm1QTHJDWm40dno4aExPY1g0UjVDbFRYYmt4?=
 =?utf-8?B?K1hDMDc2K3hCMGVSUkVFdnplVCtKeHltajRjOXV0RmFNMnFJUEJoaGR0TmdQ?=
 =?utf-8?B?aWxFcmdCaFliazdKR2JmaWJ1Y1RSRjBZWDNPaytYc09Vdm9OSVJoZGduUi9z?=
 =?utf-8?B?Z3FmVFQ1NkMzVjIwS0RQc1crbjlaYVc2YTA2clVyY29oK2UwT3hlai9KM3BH?=
 =?utf-8?B?VlFLRzFyVitNYkdaVkloOHdlTFdOdFcxZDMvOUk2SnB1MnlOaFpiaDh1bEh1?=
 =?utf-8?B?cis1R1ZkSWpGL0RDUjVTV0gyS1UybmF5VzJVeVM3TmZYZE5ZRjRCMFNWdHkv?=
 =?utf-8?B?cnJncithMDkxSGRxaTRmNUlBQk42MkRWNXltdWxtYXJmaHh2T2VpbW5uODNP?=
 =?utf-8?B?U2ZjRUtIQ0ZWd3VGUVdkRkdRNzJhbENKdkZYZlMrSzFwM1lET283bTZCcmpQ?=
 =?utf-8?B?OXJ6d2xXd1Z6Nk82MEtiUUd6L01XR01jTjZvaUkvckxTaVB0YWIzNko3bDY0?=
 =?utf-8?B?QXZtWlpoMEFaYURnRytQaXJWMFY0aGV1MWVLTU5IOGpYNFFaV1RKYW03QzRI?=
 =?utf-8?B?cjVKSzgzN0lnOXZ5Yk8vV3BxWU1SL05kek0vdUJWWmpaOUhvdnNiYkl6QzFB?=
 =?utf-8?B?ZkcvTlV0cWdJUS9TZ09QWmxwMllCaDhkd1NMV2hXSTdMVDR5VGhhR1hwSVQ4?=
 =?utf-8?B?dDA1TlZVMjZVN3J5c1lhQ3M0N2FRbTlEZVpIbjVVc1JZcXZkeHRuazcrLzd0?=
 =?utf-8?B?UWZ0NXJwVkE5UGw5S1VPUERkcEc5RHVoNWo5OWRLMXBOYWRKZDNRaVFVNFVP?=
 =?utf-8?B?RVFFQ0djMGFFQ3BTSGJlcXU0TkgwaThna0FJNlRic2tvVUM5QkdvRk15ZjdI?=
 =?utf-8?B?a2xDbC9HRjJzYmJ0RHBzSWFHdVhlQmhxNU81NldFdS92a2YrczVrNmduVWZB?=
 =?utf-8?B?ZkNFbSt3dXVveU9TNzl4aGYzOHhJdDYxQTRMQzVtRVBvbDFMaUYvWFk3dzhv?=
 =?utf-8?B?YTdQNjREbHYyWjFKbnJXNjNpa1hvYUtuMkFFalZnTTh3c3EwYUNSS0pJaGJk?=
 =?utf-8?B?OEo2bzBycGlQUVRpcHEwQUFzWTRBb1pZWlRmbHpnVDJ3R0Vmd0VTUkl0L1dN?=
 =?utf-8?B?VWlTR0xoVVdPQlNkQWV6Mnd4UGNYTlQ3RG5wRkl0Y1hsMFMyWXJZNG1vb3Bp?=
 =?utf-8?B?ZnFXZ2tVeHl3WWtwQitXN2ptRm1PVEpxWWg4cnltQ1BoV05qT2dhZVF1dTRy?=
 =?utf-8?B?cUE9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f32b1409-418d-46d1-13f1-08dad339a0eb
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 01:16:09.4422
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i8ng13BmZPHTFdsuPH6ouNHL9M0PfGUfINMFKP9rUL1UimQ8NEaeb3SuBYIX3yjr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR1501MB2178
X-Proofpoint-ORIG-GUID: Qy5LfPVVUskCU2lYfTht26xjCRBGk-LA
X-Proofpoint-GUID: Qy5LfPVVUskCU2lYfTht26xjCRBGk-LA
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-30_04,2022-11-30_02,2022-06-22_01
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/30/22 6:42 AM, Toke Høiland-Jørgensen wrote:
> The bpf_ct_set_nat_info() kfunc is defined in the nf_nat.ko module, and
> takes as a parameter the nf_conn___init struct, which is allocated through
> the bpf_xdp_ct_alloc() helper defined in the nf_conntrack.ko module.
> However, because kernel modules can't deduplicate BTF types between each
> other, and the nf_conn___init struct is not referenced anywhere in vmlinux
> BTF, this leads to two distinct BTF IDs for the same type (one in each
> module). This confuses the verifier, as described here:
> 
> https://lore.kernel.org/all/87leoh372s.fsf@toke.dk/

We might have similar issues later for other types.
Not sure whether the root cause is in libbpf or verifier. But we know
the kfunc from (module, btf_id), so for arguments, we could first
search the corresponding module and then vmlinux for btf_id matching?
This way we might fix potential other cases?

> 
> As a workaround, add a dummy pointer to the type in net/filter.c, so the
> type definition gets included in vmlinux BTF. This way, both modules can
> refer to the same type ID (as they both build on top of vmlinux BTF), and
> the verifier is no longer confused.
> 
> Fixes: 820dc0523e05 ("net: netfilter: move bpf_ct_set_nat_info kfunc in nf_nat_bpf.c")
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
>   net/core/filter.c | 15 +++++++++++++++
>   1 file changed, 15 insertions(+)
> 
> diff --git a/net/core/filter.c b/net/core/filter.c
> index bb0136e7a8e4..1bdf9efe8593 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -80,6 +80,7 @@
>   #include <net/tls.h>
>   #include <net/xdp.h>
>   #include <net/mptcp.h>
> +#include <net/netfilter/nf_conntrack_bpf.h>
>   
>   static const struct bpf_func_proto *
>   bpf_sk_base_func_proto(enum bpf_func_id func_id);
> @@ -11531,3 +11532,17 @@ bpf_sk_base_func_proto(enum bpf_func_id func_id)
>   
>   	return func;
>   }
> +
> +#if IS_MODULE(CONFIG_NF_CONNTRACK) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES)
> +/* The nf_conn___init type is used in the NF_CONNTRACK kfuncs. The kfuncs are
> + * defined in two different modules, and we want to be able to use them
> + * interchangably with the same BTF type ID. Because modules can't de-duplicate
> + * BTF IDs between each other, we need the type to be referenced in the vmlinux
> + * BTF or the verifier will get confused about the different types. So we add
> + * this dummy pointer to serve as a type reference which will be included in
> + * vmlinux BTF, allowing both modules to refer to the same type ID.
> + *
> + * We use a pointer as that is smaller than an instance of the struct.
> + */
> +const struct nf_conn___init *ctinit;
> +#endif

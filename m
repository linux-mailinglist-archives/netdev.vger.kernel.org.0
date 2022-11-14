Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97CA562860B
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 17:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236750AbiKNQwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 11:52:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238083AbiKNQwF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 11:52:05 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7651D2D7;
        Mon, 14 Nov 2022 08:52:04 -0800 (PST)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.5) with ESMTP id 2AEFCBHG025390;
        Mon, 14 Nov 2022 08:51:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=lIfhKFOYQpHavIzoOCFw5XpFOyV0iZONr8ly6K0lLIc=;
 b=VC+g/w3vtTv0sXeD3/9gCHVUYD+IgqriMOXJf7H87e5PM9ilYmuoNxjsDaJBaUUKcXkw
 +TqVz3Sbv+JZ8ykx1cK87/1M8QFtKGsDYlRN8lCp9pAc5CYYFbvwEeTQr8PSfWYgBwqs
 EzN3U52n9RJWzE7Ti0kN36hUB3YQaBWFj8tXC+A7dviGhDZr3NBGX4oGNTITELXzThXE
 y6eQKBalVxsq/3+G6Hw1beXFpXhFgbE9THspk07rahULeg2bTGZVC8AS5Gymgyknwav4
 tUwNa6x6+TkHsZLBClDgo3n1egRF7lqARD2y2oW46ximtM1OBE+oVsBWzN6SbZT/IIfs zQ== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kur3m0x47-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Nov 2022 08:51:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MNLSwTJzs4FtZZWK5qsQpJLGx1Li/c/9+Rwv/5lQ3BvMbldeUqY3YBD/QZVyaNiamB10bbS9T0zqDnMDtBOxsxEwZ9s5ymh8FrjJ1sLQOBcz1lO7n4W8pPaU80UUHk4Bx5qSE9pi46hIAgV8mH+G/PZyuMcXr0hwZY1oG5RwPOHmVxHasZdY1L3kZO8lzwbpPl1kkJkdMOZ9x5iKvfefV9yau0rMpE+X0isJ1g5rHrV8d8JCBpXhtu5juq5ziQRszrzgA/VMWFEsYOiurR/qg8RvmwdH+qvWfiti8LWe0Ln6k6jF6Mo0ulQxxG2yZf2gfh4bikw14xZAvmkDKZoTkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lIfhKFOYQpHavIzoOCFw5XpFOyV0iZONr8ly6K0lLIc=;
 b=nBhEX6M9Hxui/GLhstquEho0e0pACFWr8Npo+Wy8vR1D+1IEdFwQVLtcF8/cfd5BsFYXXZU7I2E9hcfCGHWN9cqz6rcpepGLyRitp4WyWKmtFduzhWS8ewsSAUX9r1X/zv8DS3YWZHR2cKBt3UoCuYwhcXK61rSCKwQ/C0GofM1oHi1yMmQwSVWI7l50B4NhcUFKHvyssE9ennCx54Wl0SAq2qon60m21ueOwq2POuR370lLy7zq9EKWDQb9m96eJy8MSgn+/HIB3HqPMfppExpn6pqSCLzdbl+jMdsEo6YCY0jV0KjGyGmMYWUDpxcGHB/F41GuqGe/x67zoyGmuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by MW4PR15MB4700.namprd15.prod.outlook.com (2603:10b6:303:10d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.16; Mon, 14 Nov
 2022 16:51:43 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::ac66:fb37:a598:8519]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::ac66:fb37:a598:8519%7]) with mapi id 15.20.5813.013; Mon, 14 Nov 2022
 16:51:43 +0000
Message-ID: <10b5eb96-5200-0ffe-a1ba-6d8a16ac4ebe@meta.com>
Date:   Mon, 14 Nov 2022 08:51:41 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Subject: Re: [1/2 bpf-next] bpf: expose net_device from xdp for metadata
Content-Language: en-US
To:     John Fastabend <john.fastabend@gmail.com>, hawk@kernel.org,
        daniel@iogearbox.net, kuba@kernel.org, davem@davemloft.net,
        ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, sdf@google.com
References: <20221109215242.1279993-1-john.fastabend@gmail.com>
 <20221109215242.1279993-2-john.fastabend@gmail.com>
 <0697cf41-eaa0-0181-b5c0-7691cb316733@meta.com>
 <636c5f21d82c1_13fe5e208e9@john.notmuch>
 <aeb8688f-7848-84d2-9502-fad400b1dcdc@meta.com>
 <636d82206e7c_154599208b0@john.notmuch>
 <636d853a8d59_15505d20826@john.notmuch>
 <86af974c-a970-863f-53f5-c57ebba9754e@meta.com>
 <637136faa95e5_2c136208dc@john.notmuch>
From:   Yonghong Song <yhs@meta.com>
In-Reply-To: <637136faa95e5_2c136208dc@john.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: BYAPR07CA0059.namprd07.prod.outlook.com
 (2603:10b6:a03:60::36) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|MW4PR15MB4700:EE_
X-MS-Office365-Filtering-Correlation-Id: 03a70658-0a8d-4e4b-7fb4-08dac660827f
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZLkx+zGSFGdusy7WyEG4DBr75YSEcW7hn+pgupMm6QCji05FAPDQkMNNdBApNqE6zF1rW9vBFaQ3EPtnds23sHGC/9NbUHE/3UnVs73opKl/Fe4uKSe21LpHDL6RSomHf+SBqT5vLfYISPTCa/K+UyHFBhtv8ZSl+7SqSsCf3FFUGJ6epa0QlGsP8d5fxXNHdU+QiPtlLOMw21Z2fhmjHhrrOPIOwWY/2aTW0krlGVnf7/6ZBV7wNgHuLJ/tFN6NsEqZE1IsyyLMr2QI8BoicIf05ZYlUoe4fU8um3XFEhoLmwbvPE6DqblBCq/GCsO/TFh+LGFs2LPCds/13FoTK075PxW6UzPzyiMacllLgmyFjlbk1jpC9XkEgN+wMUhIyWejr5j4qmdXqQCYVy2sBUWreMh15lBbMCid1JwbSRQimpsVkf1yyysLn4toj677RZZNti2eNEu6P2xAFpyWCkXObfoR55e5qzqskUL589RyKDRFts68GzCmzEGxuv6EChHaTCYvwvm5nAPmFqQ0UgpGQBu6OTY42kj3FdYfF2PC4psWEhmhpHnfe3SnmQWSk8A6uZsdsklc4qxtugnsYUDm4nq99n/pN2NyY2ECzgKmpmrlu/sm6z5m6xY6Ao5wmC+qpliWckxCSUjvH4s4p+gLcp+OU+zUYwNWQA8+6v97SV+YgF+BOuT3j4cQrT6k8JyPbcwIryKHvHnVQXl5SIWk+8wghzEYmg7JApNsxHx8dvLTHZGsJmP8YJgLf91airPDDjVxURFZq7NE0WBVVoL14CnNlctc4em5S1E4KJ7nbydFIM8upEXbkHoryAvxulsvS3tbf6gi5xptRCa+CKdNrxqFl7TH7X1lQmZbxEQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(396003)(376002)(136003)(366004)(451199015)(966005)(6486002)(478600001)(53546011)(316002)(186003)(2616005)(6506007)(6512007)(31686004)(5660300002)(41300700001)(8936002)(83380400001)(4326008)(66476007)(8676002)(2906002)(66946007)(66556008)(38100700002)(36756003)(86362001)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y0U0a3UzRUhTWThSdVJDZm9ML1J4WG9Kb1R5akVBeklOdUVSNm55MUFoWWFn?=
 =?utf-8?B?Y3hXalgwUEsvTEhSVFdHN1c1YXZhbmxybC82eW50MVBrb1ZwN2xBa3VsSHpr?=
 =?utf-8?B?ZnlhVkJJa0QzS2JVQXFacFlyN1hXOTdDYVVRN0c4N3prdWxSbkxBMGtNelhF?=
 =?utf-8?B?by96L1hFOWdFWEcyRGdLclFOTnZHa2czUW9KY3NRN1E1YWlLZ0JyZ2t6S3Bx?=
 =?utf-8?B?TVJMTlhjam4xanhySWt4Zm1KeDR6NytWTUFpa2lZN3BoL2ErWHFqMjZWQlFw?=
 =?utf-8?B?QnRJeExWVE1RNi84Z3RPOXZFY0h5bDJobkREQTMzQ3VYMzdobDdiZHVTekgw?=
 =?utf-8?B?aWRZMnhRc3ErS3kvaGhYV0NxMDFtSmthOXBzREdaZ29rTFVlbnIwQXBWdWho?=
 =?utf-8?B?UGdZWUQ0ZVZlVVhyQ01vY0RzNis0OWVYMTVqQ0dDTnJ2dnkvcWhEVWhoUm5B?=
 =?utf-8?B?b1QxMlBtb0JGMDBUN1dzdHcreHZYNmZ3U0U5Y1dWMkRwYVdLWDR4ZXlFVzZK?=
 =?utf-8?B?SnAzMENVOVBkcnFWZGhjdk5JMmM2NnhWNHE3cmRTYWRPdlFmL2tZYUQzcG5F?=
 =?utf-8?B?alFnaTV1c0M2TGlJVEYzQnBKdHRXcEtPMTE3ak45eGdibVJBTGg3aWdaWlp3?=
 =?utf-8?B?bnpKL1dvMll4M1BxYzdQYnNqUVJtMytyZHd3bzBjUVExdnNrVTZCbnRwR0RK?=
 =?utf-8?B?ZFM0Um9Rak5rRFFDWTltUjB4SXdQSWJpN0NpR1pwb0E3bXV0MVFINEd4TlNH?=
 =?utf-8?B?VHYwVGNScERVRmZLUXNIRXV4TnA2M0w1cWhEck05MXQzUXJ1bDVGa25GdEdh?=
 =?utf-8?B?SUhlMXcxRkpYcU4vQzU2UHV0eUwvMmdKUjQzT1NvUmhGekhyN2VxbXFZZE5D?=
 =?utf-8?B?MWgvUkhVSDR1cnlKbWtYT3A5QlNNUWtkc3Rzb3pBSDJpVGNNTmhnQjVxR0pS?=
 =?utf-8?B?SDZvbklmeEJScGk3cEFFN3JPVWRtUVJDaGo5cjVpRXRPS2h2TktYNVBPaldw?=
 =?utf-8?B?NGNmR0d6ZXZxd0pPZFNTUTBlMVhiLzRmM0RneE81V3JlV3dGSDBUeXEwQnp5?=
 =?utf-8?B?ZTJJVjRodVltZnBIOEtEUGpCS3NvVjhndmJGelFveUN1VmcwbjhOSFNOK1V0?=
 =?utf-8?B?V1dtcXdwWHFHQ3FnRitxTWpTODl2SW5QNEtmeERDY1hndGw0aFhTYWZsSEtQ?=
 =?utf-8?B?VFI1dHEzMU8vUjU1NHBEZ21BQTlkaW4zbEJGWG50L0hFSUJBNVFLUE55TWdz?=
 =?utf-8?B?RzJlY1hLaEpQSStEZ0JjSnI5SUQ2cXRsNjEyT3NRZDZiWVJPWHQxNFJrWWpv?=
 =?utf-8?B?VlR4TkhQOXZ2ekloOG1TUHNyM0EwWW9Ma1Vtazd5dklyWm12S0xjRE5mazJ6?=
 =?utf-8?B?QlEvQWp4cEFQR3ZTNmVsMEtYd3lielY0cEVXN0dPOCtwMHRtLzhHVk9yR29p?=
 =?utf-8?B?RnBVeEF5ZXZNaWIzNjJSbUEvcnNEWStwaGpuaGl5Zkg4MGRpZjV3U2pHaWE3?=
 =?utf-8?B?bUR6RHluU051Q1ZVTEpsWk04V2tWRTJFayswdElzeVpZYXQwYS9USk83cjVC?=
 =?utf-8?B?NzFBV1N2ZXI2dlhOTGkzL2pzSHp6M2NUU245d1BXTkhOR3ZKdmhnVW5pcUxZ?=
 =?utf-8?B?NXRjemozRWdBVlk3RjVrYTRRN2RpOExpdWNEMGJXc2RGWHBzNkJNOUZoZFVH?=
 =?utf-8?B?YVVqQUppSEtvSE85em14VVZmb0Z2M1RzQXQxaVZJVEVLT29kSDQxbWhFdlkv?=
 =?utf-8?B?bnkvNWd1TThZV2tGeTJoZlMweDJkV0V4eGhqaWFHRWZzdUlIK3c2QmFQNzBv?=
 =?utf-8?B?clRmMnp2bDIrR01TWDZVajNMVlBIVE1iZkZhS3I4cDUvZWE4d2Z2T0wydXJw?=
 =?utf-8?B?L0VKN2lNSWNIVWF5N3hpNktobWlwZFdIV0lRZStKejBhZ1pGNVpWVm9nN1ZE?=
 =?utf-8?B?WHpxbHJZUmNCemF0ZW5WRTBVRWVFeUpJM3VIeDhQMlNlNHdXbFVHTndlMWkw?=
 =?utf-8?B?SzJxby9Na1Bub0Y3MlNCYVh0ZTlabUVqZ3oxUkMwUFM1Sy9GeTlZdk1PejVY?=
 =?utf-8?B?SmxzMFVHUnRvdkhGS1F4clFCMENDU2cyQUNJQ0VsZTNxR0pGSWFjNHlGUHE2?=
 =?utf-8?B?cEtnYU9lMUZSSGY1S2NvRmZQaHFCcGNCTmRzbTkzY0dicUJacm10LzJ3cDVM?=
 =?utf-8?B?YkE9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03a70658-0a8d-4e4b-7fb4-08dac660827f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2022 16:51:43.7087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N88AQnCYmZoXtXnUpLjhI1ggb6xxlZ2CR2OQHT013RczPoJDMNgEP6sbJ1o65cQy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR15MB4700
X-Proofpoint-GUID: v9F1UCuBylZSDhF2IEAqnqJheprzRxnB
X-Proofpoint-ORIG-GUID: v9F1UCuBylZSDhF2IEAqnqJheprzRxnB
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-14_13,2022-11-11_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/13/22 10:27 AM, John Fastabend wrote:
> Yonghong Song wrote:
>>
>>
>> On 11/10/22 3:11 PM, John Fastabend wrote:
>>> John Fastabend wrote:
>>>> Yonghong Song wrote:
>>>>>
>>>>>
>>>>> On 11/9/22 6:17 PM, John Fastabend wrote:
>>>>>> Yonghong Song wrote:
>>>>>>>
>>>>>>>
>>>>>>> On 11/9/22 1:52 PM, John Fastabend wrote:
>>>>>>>> Allow xdp progs to read the net_device structure. Its useful to extract
>>>>>>>> info from the dev itself. Currently, our tracing tooling uses kprobes
>>>>>>>> to capture statistics and information about running net devices. We use
>>>>>>>> kprobes instead of other hooks tc/xdp because we need to collect
>>>>>>>> information about the interface not exposed through the xdp_md structures.
>>>>>>>> This has some down sides that we want to avoid by moving these into the
>>>>>>>> XDP hook itself. First, placing the kprobes in a generic function in
>>>>>>>> the kernel is after XDP so we miss redirects and such done by the
>>>>>>>> XDP networking program. And its needless overhead because we are
>>>>>>>> already paying the cost for calling the XDP program, calling yet
>>>>>>>> another prog is a waste. Better to do everything in one hook from
>>>>>>>> performance side.
>>>>>>>>
>>>>>>>> Of course we could one-off each one of these fields, but that would
>>>>>>>> explode the xdp_md struct and then require writing convert_ctx_access
>>>>>>>> writers for each field. By using BTF we avoid writing field specific
>>>>>>>> convertion logic, BTF just knows how to read the fields, we don't
>>>>>>>> have to add many fields to xdp_md, and I don't have to get every
>>>>>>>> field we will use in the future correct.
>>>>>>>>
>>>>>>>> For reference current examples in our code base use the ifindex,
>>>>>>>> ifname, qdisc stats, net_ns fields, among others. With this
>>>>>>>> patch we can now do the following,
>>>>>>>>
>>>>>>>>             dev = ctx->rx_dev;
>>>>>>>>             net = dev->nd_net.net;
>>>>>>>>
>>>>>>>> 	uid.ifindex = dev->ifindex;
>>>>>>>> 	memcpy(uid.ifname, dev->ifname, NAME);
>>>>>>>>             if (net)
>>>>>>>> 		uid.inum = net->ns.inum;
>>>>>>>>
>>>>>>>> to report the name, index and ns.inum which identifies an
>>>>>>>> interface in our system.
>>>>>>>
> 
> [...]
> 
>>>> Yep.
>>>>
>>>> I'm fine doing it with bpf_get_kern_ctx() did you want me to code it
>>>> the rest of the way up and test it?
>>>>
>>>> .John
>>>
>>> Related I think. We also want to get kernel variable net_namespace_list,
>>> this points to the network namespace lists. Based on above should
>>> we do something like,
>>>
>>>     void *bpf_get_kern_var(enum var_id);
>>>
>>> then,
>>>
>>>     net_ns_list = bpf_get_kern_var(__btf_net_namesapce_list);
>>>
>>> would get us a ptr to the list? The other thought was to put it in the
>>> xdp_md but from above seems better idea to get it through helper.
>>
>> Sounds great. I guess my new proposed bpf_get_kern_btf_id() kfunc could
>> cover such a use case as well.
> 
> Yes I think this should be good. The only catch is that we need to
> get the kernel global var pointer net_namespace_list.

Currently, the kernel supports percpu variable, but
not other global var like net_namespace_list. Currently, there is
an effort to add global var to BTF:
 
https://lore.kernel.org/bpf/20221104231103.752040-1-stephen.s.brennan@oracle.com/

> 
> Then we can write iterators on network namespaces and net_devices
> without having to do anything else. The usecase is to iterate
> the network namespace and collect some subset of netdevices. Populate
> a map with these and then keep it in sync from XDP with stats. We
> already hook create/destroy paths so have built up maps that track
> this and have some XDP stats but not everything we would want.

the net_namespace_list is defined as:
   struct list_head net_namespace_list;
So it is still difficult to iterate with bpf program. But we
could have a bpf_iter (similar to task, task_file, etc.)
for net namespaces and it can provide enough context
for the bpf program for each namespace to satisfy your
above need.

You can also with a bounded loop to traverse net_namespace_list
in the bpf program, but it may incur complicated codes...

> 
> The other piece I would like to get out of the xdp ctx is the
> rx descriptor of the device. I want to use this to pull out info
> about the received buffer for debug mostly, but could also grab
> some fields that are useful for us to track. That we can likely
> do this,
> 
>    ctx->rxdesc

I think it is possible. Adding rxdesc to xdp_buff as
     unsigned char *rxdesc;
or
     void *rxdesc;

and using bpf_get_kern_btf_id(kctx->rxdesc, expected_btf_id)
to get a btf id for rxdesc. Here we assume there is
a struct available for rxdesc in vmlinux.h.
Then you can trace through rxdesc with direct memory
access.

I have a RFC patch
   https://lore.kernel.org/bpf/20221114162328.622665-1-yhs@fb.com/
please help take a look.

> 
> Recently had to debug an ugly hardware/driver bug where this would
> have been very useful.
> 
> .John

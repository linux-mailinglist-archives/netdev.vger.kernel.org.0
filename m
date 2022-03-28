Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 210F54EA355
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 00:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbiC1Wzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 18:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbiC1Wzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 18:55:48 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 319A130F47;
        Mon, 28 Mar 2022 15:54:06 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22SLKexH025147;
        Mon, 28 Mar 2022 15:53:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=DtoFFcUo4N+J+8GLUfOvqOh3zJOAq9hQFU5NgEztHOI=;
 b=HnPYlgZMk99NJsxxYdl7T/0WCaOpS2xIIGpVHQ+yelauZC1HdOR6PVW/xhqy/3dH4yE0
 CkzivokbH67mqPPb1sNCYhFTMXDMpzMw6fdF2A6EtTZnPlguTd3ILtk4+LTdkUEZjk9K
 MOhLLLT2o1VPncvCtVxiahAs+LwyPVv2VK0= 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3f1yxtpa99-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Mar 2022 15:53:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jvSrCk7fFg8DdeSwQnmYVGgv1fZQg4Hbf498bqDVmGXxR15QWIbDxHlHSaxtcIJFEBXRFVX4Oer8Om4RxvCAKRlGEEyBbiHP8KJrgoUyV2I7NS5ppiXptYJoBTtAoJuBMQV5QM+VW1I69VYdxu4mBpUmkWkFa4lzpDBhTYAIcdLZ7dor1dgdTHncfZzshySi+XPL3dJxHINDzXHX5bC4jjqKt3MY2jHXJ/kaUHjNQZoBpqXllOW+IPlFy8smi3R1k7fTcZ7E79tAOP5a5nB/bPBGReOzeYwhyh3YX95F3Ac/tPEE6Cht4jsj++k5hOhEsfJbj/E80DSuM/VoosM8/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DtoFFcUo4N+J+8GLUfOvqOh3zJOAq9hQFU5NgEztHOI=;
 b=bvkqPfh5IzTm9IJ5xGgN27TtKKzasutcJyvm9SBaLoi5yNNASmHmmBZIP2mfT/9M8BDrHs7mJwGs8rNcqyqNaDFaTOyOqtI1I0VasqW3Csn4R3YgVWCw2nakpZEzxZVJA5iNYNd7YGpWBbm+cXaO05M0LUItTPko5VCtPk/Tomm6p8f6o6AuArRyt2oMhqP9Z43ysw3b/tFSi+VP+7NvTKEzdvBySltP3BHs5FGf1zm3qZ7S5s1Tre5F313MIGxoPylBoPoILGENGIZ9EjAUHoiTI83Z/s/DcWVzdmix5uXzisZKEl1pmcYkBX0Ubl3P6m/EqWKARl4HluJPO51i1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by MN2PR15MB3232.namprd15.prod.outlook.com (2603:10b6:208:a0::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.23; Mon, 28 Mar
 2022 22:53:42 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::4da5:c3b4:371e:28c2]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::4da5:c3b4:371e:28c2%7]) with mapi id 15.20.5102.023; Mon, 28 Mar 2022
 22:53:42 +0000
Message-ID: <596ed6c0-7e2b-334e-27df-93d734352dcf@fb.com>
Date:   Mon, 28 Mar 2022 15:53:38 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH] bpftool: Fix generated code in codegen_asserts
Content-Language: en-US
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <olsajiri@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Delyan Kratunov <delyank@fb.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
References: <20220328083703.2880079-1-jolsa@kernel.org>
 <9a040393-e478-d14d-8cfd-14dd08e09be0@fb.com> <YkIDfzcUqKed7rCq@krava>
 <CAEf4BzaCnG7A+Ns1dw8KYbmzU_q_T96-Niu=1j6o=+KRxYT1bQ@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <CAEf4BzaCnG7A+Ns1dw8KYbmzU_q_T96-Niu=1j6o=+KRxYT1bQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4P221CA0018.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::23) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 54634291-9373-4d2e-5839-08da110dce7a
X-MS-TrafficTypeDiagnostic: MN2PR15MB3232:EE_
X-Microsoft-Antispam-PRVS: <MN2PR15MB32326057A9CBB2AF9DD6EF88D31D9@MN2PR15MB3232.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1ODtxYf9njLBRVYLGFSZEHjV9Q9pFHrm8JBhPX4z0ncroP/Uf03/XkVot/Czf1j7bjOWNDuaDwRZuwYgfUNwVAC8Gp2r9ngwhdRtKlOS7lW/RwTFwfBsrhfowCOAmwvHJ9cBg54XyR8iTbMIckTynSihYYzfGTmGGFd79xVJcgWKyfq3NhODS0tRgRSzrHTfmFcwsiyAzkHs0ZwgEph4cOl4kWkWMghf9DFTO2IIYQ0Tg4yUXA2cQf2i3Po7XmrnlPg0ntTRdIn/tCzk1MunHp6VoeHqYfgTTtM7WWsCTDkYQBl1N2fKHGSY47MOw+lz14jtkW5QZ1p72UQwQuFgTyQGsKw+mw0G4k2uH+LHW+zjb1jvSnqhoRfj/AyVNSKqb0ksxhNKaB43WOYAVixNZGAxZ6EajGcB83+JGhfZO/HG4YTqhNB+ONE8sm529x0YbDOSrrYweZ33DDwiF6vzc2B2CGejDwjOlcKbuovM/IFSnsPzRbjKo4dgZeOIKX2AXrwebZHznhDRD27BbybXEl7N9MMJx+knVx8X30KooHW7EWTOg4NS8Uc89r9TuwrZPDZj0039BmOUld9sk5mDoMPeGR5EgfICNOW6iwTjh79BjTcb1Lts7G5KbaSKpaS18D5tCr0IUsrpwEZ1qmsB4l4TDlG1F82aK+vRnmzOT2EcpB0xQQ4NR7hEx/IVbAC44YgbZqvl/IyQkiusNCrphSnvaBCYxSyvh7bBNkRiZyE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(316002)(508600001)(38100700002)(7416002)(2906002)(83380400001)(2616005)(6506007)(31686004)(52116002)(53546011)(8936002)(5660300002)(66476007)(54906003)(110136005)(4326008)(66946007)(8676002)(6666004)(6486002)(6512007)(31696002)(186003)(86362001)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R3QwSnlMclEwcm50Zk9mb1E3ckVTUlJmcnl4bWdvZmwxbWJtT1JaT0pELzZK?=
 =?utf-8?B?R3VmWFIrNG44djlUR3FNYy9COGgzdE5UVnFNb0oxbkVtQlZJWWhSUkpLNzRK?=
 =?utf-8?B?LzNuT2FpMk03MUVBYnFucGIyeW5sNWFVYUhIMUZRaThlWEdFWSt2TlBuYVlk?=
 =?utf-8?B?S0s4bHk4dVVVMWtGZC9pNWVDbHpZOGhCZjJoSGhsODIrVGRBdXFYU1V5cFhk?=
 =?utf-8?B?WTkzak1ib1JabTdhTW9HdEthWTNqNTVtMzBMVEhZbHhYUnJuYU1Ha1cwUStj?=
 =?utf-8?B?VGJON1MwVDlNOTlYWTBXaGs3TzZYZlVpZ1NGcTREeVBqY0dMRmxuUG5oY21a?=
 =?utf-8?B?TW5KWXdZb2duQnRDVkxlTmZiekloUG1mKytFbVFDckYySG1TMndoaTM5M3RG?=
 =?utf-8?B?NGh0WTJxV21NT3V0RnhmbWp1VUFvaGdVakh6WkdmU0Q4WXVDUXhmc2hYdXJa?=
 =?utf-8?B?N05YRDRWNE9DYis5UVlpWU1pNmZGUGlSWnBPeHdwY0JSUDlzLzJpQ2JMZ1lS?=
 =?utf-8?B?SzFVdzVHUjY3NDVKZExlcEpPazdQRXduemtXdjBSU2dPd214QnRSSGtpUUND?=
 =?utf-8?B?TzhyNTcyMk1NcW1iNWpUcWE1SEZieFdYeFBRY3NyVlJXam1VeEQrUEx2V0JI?=
 =?utf-8?B?TjMvc3I0c09wRVJBZ0p3R0dXRXpEWEgyL0NlWnMwZkMxSkYvUVEyTU1NSXJM?=
 =?utf-8?B?WStlNmo4N0VOS2RibXdiYVNSajJ4QmxORVRMelI3cjEveURkY1dtcnNndEgx?=
 =?utf-8?B?eG5oMHVUeEhDcFJ0N2hoVVdiV1o3TTNiYzIySFNZSVIxRkhDMzh0LzFnZG9w?=
 =?utf-8?B?Z1Bmdk5tZThoVWoyWXpQT3dKMjEwSnJMOHRvRW9mcngvemFYVXFKSlQ1ZWhO?=
 =?utf-8?B?SlpSTmRDTEpJNWhGZGhGZFhZcTZNSkpwYWx0QW42bm1LNDh2WmZ4V29NZldQ?=
 =?utf-8?B?YmVGejdMdWovMHRIbTUyQStlai9RdDJoTXhLU2pzSUJEL3RId1ozaEdaTTBV?=
 =?utf-8?B?OGtWNkU5U2Y5K2tkSERTMlBmdi9uVU4zTEtNbGdrQkkwaGRzZEhIZk9Kbmxi?=
 =?utf-8?B?UUZWb0FTZW55cG5LTEQ0THlabmVCZy9jV2cxbk5RY0FBQjMzZlJSbXR6OTVK?=
 =?utf-8?B?QnNqZktmTEU3djRLaDcyUFR0RUtPaVRRMUJNK0dSdTJmV0FVYzZDakY3anYy?=
 =?utf-8?B?dlhndXBnblg1ek5KZG45czZyRm5RWURuSDh1VGREZlZ4VnRZTDhuRVp6Qjcy?=
 =?utf-8?B?WmM1RC9td1V0bjFaNlJUdVptbmhBRUd5bVJMa3JmMEpyTzM1T25YcjhqNmxR?=
 =?utf-8?B?MzJXdyt4MUEweXpDV2c3WXVLcjZsY3lwN0xSUmd4WE9Na2JFS0VScHpkQjIx?=
 =?utf-8?B?NGJ6WEVvZk00VVlWc1dDU1JZYm1abVJnUEtvemVrMXlMb29rNnhQWkNlSFNE?=
 =?utf-8?B?N05oZFEyZWk0cVhvSlhyR2hzMkVvUHhuall6Nkl5N0NwYWpmSW5CTUNhYVpC?=
 =?utf-8?B?eVpaQTBxd3hub0VrV2VINUJ3OUdRcVN2YXRuODdoSVhKdUtkYkJmeWVuV3hw?=
 =?utf-8?B?b3RHTGY3RExQT1E5M1RhTUZwL3hGMWpscU5PbWxETVRsQ2xYMmUxVmNhbXYx?=
 =?utf-8?B?djJhMVFRUEJhT1VVNERBdXprZWE0dXc2MTVpMUhGMytVVVNjcENnaXhCTm9B?=
 =?utf-8?B?dTlPUjJKVW9HeXBYUk5zUHoyYUZZc0d6bEZaM1hvbW5hQ1hldlZBVXd0clNa?=
 =?utf-8?B?aVdWK1VYNTdKRU1mRVNwbmUzR3NFcktnU0NxaWh4MG9rU3BnRVAxdGtqdUV5?=
 =?utf-8?B?TWVNWlc5Wmdwczg1Mm14ZXZjNGNOTS90RVlPM1R4UjV0eTdhZEwyVjhucm1j?=
 =?utf-8?B?Zzk3S0lpK1c4aUVLYWxoSlVMYVQ4YXBnQmtvMlNUblphd1VlWko0MEp0TDg2?=
 =?utf-8?B?amR4a2xvNkZGd0swcWV6ai9RZng2YlFQblNiMlI0OGdPVjdpWmtvbWtkUnk0?=
 =?utf-8?B?dUYzVUhPU2c2ODF6L29KaFdOOUYySjh6a3ZPaDJZUXVObVoxY3hERnlDd3Ra?=
 =?utf-8?B?R1VUWEFWd2FHRTVPQ3lSZHNtdDhmTTRjckIzaGN3cU11RGQzS1ExY0dEZ0tS?=
 =?utf-8?B?aEJCUDNCUlNYbHhWOUZHbEZIY1l2UkNqa3UyOER6UFE5VjVFejFWS1Rpdisr?=
 =?utf-8?B?M2ZVNEp2ZzVRR0pTTnhiR1ZjVS9aVzZJRTVhTWNUQVlUWDZadGdmdWgyWUNN?=
 =?utf-8?B?cVFhNU11VlVYZ0h4eCt4WVNUbFBEcTh1a0E0YW9oL3lMMlN4ZXlvcjlWV1cz?=
 =?utf-8?B?NFhvcUhraDJ4R21wTzdUMmU1NDZMMTFnZ0l5Q2ZzWEhncFNmQ3J2Zz09?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54634291-9373-4d2e-5839-08da110dce7a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2022 22:53:42.4592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KIhu+O4v0Z/YZsfRViAqwMG+3wfL+VRs2nGGPoqdvLApk+pp+AP3wwymPjP1XHZw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3232
X-Proofpoint-GUID: TjqbBiT0ks5xpmXWAoNgWRTnbdhncdux
X-Proofpoint-ORIG-GUID: TjqbBiT0ks5xpmXWAoNgWRTnbdhncdux
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-28_11,2022-03-28_01,2022-02-23_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/28/22 2:31 PM, Andrii Nakryiko wrote:
> On Mon, Mar 28, 2022 at 11:50 AM Jiri Olsa <olsajiri@gmail.com> wrote:
>>
>> On Mon, Mar 28, 2022 at 08:41:18AM -0700, Yonghong Song wrote:
>>>
>>>
>>> On 3/28/22 1:37 AM, Jiri Olsa wrote:
>>>> Arnaldo reported perf compilation fail with:
>>>>
>>>>     $ make -k BUILD_BPF_SKEL=1 CORESIGHT=1 PYTHON=python3
>>>>     ...
>>>>     In file included from util/bpf_counter.c:28:
>>>>     /tmp/build/perf//util/bpf_skel/bperf_leader.skel.h: In function ‘bperf_leader_bpf__assert’:
>>>>     /tmp/build/perf//util/bpf_skel/bperf_leader.skel.h:351:51: error: unused parameter ‘s’ [-Werror=unused-parameter]
>>>>       351 | bperf_leader_bpf__assert(struct bperf_leader_bpf *s)
>>>>           |                          ~~~~~~~~~~~~~~~~~~~~~~~~~^
>>>>     cc1: all warnings being treated as errors
>>>>
>>>> If there's nothing to generate in the new assert function,
>>>> we will get unused 's' warn/error, adding 'unused' attribute to it.
>>>
>>> If there is nothing to generate, should we avoid generating
>>> the assert function itself?
>>
>> good point, will check
> 
> we can use this function for some more assertions in the future, so
> instead of trying to be smart about generating or not of this
> function, I think unused attribute is a more robust solution.

Okay, if there are possibly more assertions down the road,
I am fine to keep the function even if it is empty to avoid
more and more conditions to decide whether the functions
should be generated at all.

> 
>>
>> jirka
>>
>>>
>>>>
>>>> Cc: Delyan Kratunov <delyank@fb.com>
>>>> Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
>>>> Fixes: 08d4dba6ae77 ("bpftool: Bpf skeletons assert type sizes")
>>>> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
>>>> ---
>>>>    tools/bpf/bpftool/gen.c | 2 +-
>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
>>>> index 7ba7ff55d2ea..91af2850b505 100644
>>>> --- a/tools/bpf/bpftool/gen.c
>>>> +++ b/tools/bpf/bpftool/gen.c
>>>> @@ -477,7 +477,7 @@ static void codegen_asserts(struct bpf_object *obj, const char *obj_name)
>>>>      codegen("\
>>>>              \n\
>>>>              __attribute__((unused)) static void                         \n\
>>>> -           %1$s__assert(struct %1$s *s)                                \n\
>>>> +           %1$s__assert(struct %1$s *s __attribute__((unused)))        \n\
>>>>              {                                                           \n\
>>>>              #ifdef __cplusplus                                          \n\
>>>>              #define _Static_assert static_assert                        \n\

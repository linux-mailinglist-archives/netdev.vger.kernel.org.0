Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2AF56D493
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 08:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbiGKGT6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 02:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbiGKGTz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 02:19:55 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE240167D7;
        Sun, 10 Jul 2022 23:19:54 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26B2hGEQ027447;
        Sun, 10 Jul 2022 23:19:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=/2CzFFGY+NVtPqliEGTSNXCW5y36LnhPjwBxsSWxrjA=;
 b=BlC5jA+GHY3LTQSzcxuzOAK8mwcADtfS1lKgMXj6mDNsFLvSnNYQIy6grPysGGzxf4AU
 x3ou+vQOy2SuOtNF2I3fAxzWB9ixLe45jfX2yetGVeIJo/ep7l21EGeLcT5NFRCaqP1/
 35Y2Ux0zd81Lwfebjas8nbfgseWjSfAHe6M= 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h75qmydg3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 10 Jul 2022 23:19:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V/Ug7p2T3p33x1Bn4f2JTRTFQDPbERD3+mlyoK4DVo5R3DtibxksIfnhZKFT2N+C0LIJn0n3HLJ7ErU0j+4Qi4xlPlx9soOXICxSoHvuRMRuhCbfnmQwfX5KJq2/Yb+Ob0aLqLaV3YceQJs+lzuJ1OGWBSzd+lS0MJ0hVX5eQwssPgh/Ni7h0tpfRPEmYW9JZR2KFmfmkZWmBZhr97u2ZpGCNRDv/ZP3dI0eG7Uz8GDkOGzj3uPsmNNl/DkqKwCJqxrsfbY8mHvSx5zBAOvycQPs/AJZvVIQ8imdTCgIKXJbSpV2r+1MW33GcT/BfWblhJNSVP/FasiVUDDxYftjbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/2CzFFGY+NVtPqliEGTSNXCW5y36LnhPjwBxsSWxrjA=;
 b=nP0RArJ4YbYS9i+YuGfiMlez6x2U0vA+fSsido0gxcoHXZ7utgn755SWw8wjJr3CZklwz3JmW0SEJ0+MoFmsZ6B8rgrAPBrbUUMMaONXoCqo+9wqV8vA2OnSFbVosYTptHqoym68OmG0bd1SNwro4OXZ3oue25D62eei/IFnreNjEBbm0y6ITLSzYSjS0vH61KLMsF2Z0hUaNH6mjOK2vXLOmL8H2rWKCVWAwzaH8QySWV83WDVaEBuUai86Hz0+Ff1Dmx28J0nbxPn/BxKxo7PIHyPi7fCa7CCRabzpLqcU24Bjvc8GA+7NbANo+cgADlgqlGMpsqGJVQbkyYRNBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BL3PR15MB5436.namprd15.prod.outlook.com (2603:10b6:208:3b7::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20; Mon, 11 Jul
 2022 06:19:19 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23%6]) with mapi id 15.20.5417.026; Mon, 11 Jul 2022
 06:19:18 +0000
Message-ID: <e2f8fcd8-9219-1119-86ca-69714789d494@fb.com>
Date:   Sun, 10 Jul 2022 23:19:15 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH bpf-next v3 8/8] bpf: add a selftest for cgroup
 hierarchical stats collection
Content-Language: en-US
To:     Hao Luo <haoluo@google.com>
Cc:     Yosry Ahmed <yosryahmed@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Tejun Heo <tj@kernel.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        KP Singh <kpsingh@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org
References: <20220709000439.243271-1-yosryahmed@google.com>
 <20220709000439.243271-9-yosryahmed@google.com>
 <b4936952-2fe7-656c-2d0d-69044265392a@fb.com>
 <9c6a0ba3-2730-eb56-0f96-e5d236e46660@fb.com>
 <CA+khW7gu73pRFi73BR20OCJhzrs8-kHfTYYR38+MJUpt6wqXoA@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <CA+khW7gu73pRFi73BR20OCJhzrs8-kHfTYYR38+MJUpt6wqXoA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: BYAPR05CA0011.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::24) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eab9bd59-6ece-43f4-eec0-08da6305496b
X-MS-TrafficTypeDiagnostic: BL3PR15MB5436:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5gvKIUPCSWya0pbHEW7A3nejrE9HWCbEHI8y041jIEtpPlHyyhATwI0v4CVWXk4lE3GKOT15sOPg4igDkylrbUNJGqs7rDVqZT/XUK6up5ew/xCaDX9r3Ln2fUtVG0tWL1nJZI4/UwZkrAZey6dBB20KYq5XrzcAsONA4Ej+DNwp60Ymw07SPs9hu3yeDSzyqKGNohLhBKZa82Z06kpwCfMdkgoXTCeBTHeVctb85JZqd2XrGpp7sQWDA3ev/snza14LNddtappmY+m3Lv3wqL3hb+G5GGidxbyJQAY460Xz5cofSpqZBYluPI7xNDfn3gkBo+PZGuuMGfeEY6OrD4xVwZ0IQ2p7W5wDRiCfS+ONhqEk6Trx3jAdfzADJxPG3rgjPsEbJzptEmUazs/bqCKS7y4j2OvR5HJ0Rvlf5Ker2scFJceqmT4dYOlyReflG2grdQ/rHLF0X1JGYZFZXvHardqe0w46spinMYThQgeEX/rPky6WFe7yKGZjrKSZSXANs9Q2Ty+v38hOqtSkvWlLLAiUioKeYYXahv+W+dBeOKAnfFkPexjt6KkXs4kd2IxN2bvPAwurKAoBpcxXZKQa8xxP12BRqbI40kOjiRaBim6H9L1G0PMbNgpP+O5Ty76FBOHiCdxptXzv0l5EG2chPQyCmbwXc+wVBUa6OrZx8C6K52Z7D94DuFhjiEo/2pQsrvuS11MMldcpZpZ7whA9JkXwb+NgewwVg4DSURG9Ts7oPSoYz/9Xs26RFbwres+NlAItK1+pNJOcNvUqrHdKv/zAnpXqFEMm4qN+KIdCuvpJBr8ogIejJSBkZOF8qa1blC5lF6a3Bq5czJP4AzAbIm0lhzdMM8q/jp59VbwTmqYQEKz7hcVcEy52tQcl4w0U0r73fhxjyBi1TQ1bfY8/dWF6Q7uaPqC3XFgmtXE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(346002)(396003)(39860400002)(366004)(66556008)(66476007)(36756003)(478600001)(31696002)(86362001)(31686004)(8676002)(38100700002)(6486002)(966005)(6916009)(6666004)(6512007)(6506007)(53546011)(41300700001)(2616005)(4326008)(2906002)(5660300002)(186003)(83380400001)(66946007)(316002)(8936002)(7416002)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UEN5ZlFia1EvN0tuNUtvM1JudGZZUmttTFA3NGgzZGgzVERyWFE2VzFCeUR4?=
 =?utf-8?B?eC9YaGsrV1RzeTNML1dpT2NIRHQydzdRaHVQS0lNaHRHYjhtYzZEeHlRejVz?=
 =?utf-8?B?L056Wmk3U1ZkWiswMXY5aitPaTE4NlFuM25ZaTdGTThwWlRIbjdLVml3bHlB?=
 =?utf-8?B?aTRHNkRiTDN5NW9sdDBMT1ZmMW9KODNETVUrREdCcmdUQnhVSFNmaWxFQTA3?=
 =?utf-8?B?Y1pTd1c5dDI2QlpqOUR1ME1KNytBc3FobUx5N1RFb3JBaVFWRllDTEpud3RH?=
 =?utf-8?B?N1ZOL1hMKzl5TU5ieGhXRHdnTUtDYkY4aTZiSDY1V2tVYk8xOFk2R3gvVGFo?=
 =?utf-8?B?WExXM1U1c3lkL1k1dEtjY3JRQjJTbjRySHRtakZLMC9jemlQRTBYZjFIWWQv?=
 =?utf-8?B?S0svL1l2UkZOQ3lIaDdsMUM4WXlBaDlVMTVTRFNTeHQyYjJ2MW03a0tIZ3NT?=
 =?utf-8?B?TmE0ZlZMb05YYmozRm5KbkVoSTcvRzBlakVNYUFmUUhraEI4NkhZdW5yNEVM?=
 =?utf-8?B?TUtRSGpKdDkwNmozM05DSWVCNGNLR3hBOWpsNWtlQ2w4TUQ1cE9DcHJpUEda?=
 =?utf-8?B?ZWdRT3ExK21GRVcvSnNHbHpWSVFWU2NVaHR3ZHNtdml5U3NLUjA4YlFaQWxC?=
 =?utf-8?B?VzhBTHJnLzNmUGg4ZzZiNHVoaDhxaFpqN1FrZTV1WmJVbkFLTlZxbEdGNGpC?=
 =?utf-8?B?SW5qOTY0WlB2a0RmTnE3Qkwwb2VqdXRqZG1veGMySFZOb29NZ0R1dXpoaHFk?=
 =?utf-8?B?cGlpeDB0OGd4NWhKUkdkcE1TeGt2RWlmWE44Y3pab0JPNDFMWVRMYmpObFZU?=
 =?utf-8?B?QlgzYnFTSFdKbm1RbjhyZFFiL3d1VFlRM0RITW4vL3B2VmQzS3hhK2k3NWlq?=
 =?utf-8?B?QmRucmVpdUF6OGh0eDR6NmMzMmlzSDUwN1djMEhYVmQxdnVCelo4NnFMaFpV?=
 =?utf-8?B?UkdNeWczNkE1U1J3ZzBCbmx5ZlJ2aEdrcDdiMEV1Z0s1VXJHRmlHKzBlbzhK?=
 =?utf-8?B?UmpuZ1FZVnJxRnlXNDdzN0NvQllidWNXQVZub2l4L211MGR0cklsL3FqOXky?=
 =?utf-8?B?amJsQkN1K1cwSkJSRWJvdGhYbURINzB6Qm9kSWM0NDBCTG81ZU5PbmhEcklW?=
 =?utf-8?B?bFFXTWFDa2dIUDN6TktBSWROUzlvK0NzcDkxQ1pHWXMxTkRqcThJSHZZQzRZ?=
 =?utf-8?B?b0UrcEQycENJZjlueTB5VjhsMjlGcU9LSTBlbkNQZ1liODVMcm43czc5NmpY?=
 =?utf-8?B?ZmloR2xHVVByNGdFdGt2bXZRcXg0amVJT3JyS2FQMlF0Q2dxNFpEb0liZjVm?=
 =?utf-8?B?cjdnTktCNFJSb0FlbE96TUZ3bGpWVzcxekFmS0lUSS8zNVcyWmEwa2dzQ3Ez?=
 =?utf-8?B?THZ0S0JmckNPSWdRcjJxS29uUTZ0QkVQOWRLNlVOZjFDblJEdVhLVnRyNmg1?=
 =?utf-8?B?UWVpUW9DZm5mY1hGVmxkMG40a21za3RRWUk4dEtENXEvTHBvcWR4czRrUXFr?=
 =?utf-8?B?RFA5SlE1MGJXMHRxdEQ1Yy8zVXVxUmt0OHMxWWlkcjVSNTF0bEZ3UEYzc0hY?=
 =?utf-8?B?cXNUdGs4UkJ6VlljYmdhSXFrTzY0Y2w1Nm1PVEU5dHdMVnAySVhXSmh0eXJN?=
 =?utf-8?B?SXllOVF5ZTBFR2dVNng5RXpiQ0hReVdLdE5jc2VjaHh0VGtsaE11a2hTVkhB?=
 =?utf-8?B?Q2tZL1dqOUREencvckpqY3EzWFAxOWlWTW5wQ1R4anBFeGdmY3hkMitkNkww?=
 =?utf-8?B?elA2YzVrMXpyY2x6Vkt4MCt1WHRhSU9kS0R2TWpJNkZiTXZEclI4azVjdHFp?=
 =?utf-8?B?ZktPb1RmclJ5M3h5dEhLM1J0aTQvbllYemZTMU1Dbk9OWnJlSTlGK0h6ZUNX?=
 =?utf-8?B?QlV4Rlp2K1pjS0FPNWlkSjhWSytKWkttQzVocVhENXZrTkJuK216Zlh2MEJP?=
 =?utf-8?B?NHVxWlpZUmJYekl4VDJVZGNaWEtEcEJFS0NXZHZadmU1U0o5RmVJK2Jnd2o3?=
 =?utf-8?B?L0h2Nlo5Z1UxWWFUYmwrWFpMUDlRUU1mdURLVkZGc1puNzZmR2pZdDJwNGtk?=
 =?utf-8?B?RFZXdytKQ3I5RWZuQ0RseURyaDBoT2FjamdhaDlHOS9NRlZoQmg3ejVxUDdz?=
 =?utf-8?Q?+6GTRS36MA+yRoMVprvEX5aTJ?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eab9bd59-6ece-43f4-eec0-08da6305496b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 06:19:18.6174
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sipM5NpE9Bc/DxA1ysgDVZhLCeKFdTirGXaZ50vh8xsAPzeuHt39K8VoyKZxHKPE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR15MB5436
X-Proofpoint-GUID: MLNGfXzSlm5RT0cSsQpgWf0oIPMDFY5N
X-Proofpoint-ORIG-GUID: MLNGfXzSlm5RT0cSsQpgWf0oIPMDFY5N
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-10_18,2022-07-08_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/10/22 11:01 PM, Hao Luo wrote:
> On Sun, Jul 10, 2022 at 5:51 PM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 7/10/22 5:26 PM, Yonghong Song wrote:
> [...]
>>
>> BTW, CI also reported the test failure.
>> https://github.com/kernel-patches/bpf/pull/3284
>>
>> For example, with gcc built kernel,
>> https://github.com/kernel-patches/bpf/runs/7272407890?check_suite_focus=true
>>
>> The error:
>>
>>     get_cgroup_vmscan_delay:PASS:cgroup_id 0 nsec
>>     get_cgroup_vmscan_delay:PASS:vmscan_reading 0 nsec
>>     check_vmscan_stats:FAIL:child1_vmscan unexpected child1_vmscan:
>> actual 28390910 != expected 28390909
>>     check_vmscan_stats:FAIL:child2_vmscan unexpected child2_vmscan:
>> actual 0 != expected -2
>>     check_vmscan_stats:PASS:test_vmscan 0 nsec
>>     check_vmscan_stats:PASS:root_vmscan 0 nsec
>>
> 
> Yonghong,
> 
> I noticed that the test only failed on test_progs-no_alu32, not
> test_progs. test_progs passed. I believe Yosry and I have only tested

In my case, both test_progs and test_progs-no_alu32 failed the test.
I think the reason for the failure is the same.

> on test_progs. I tried building and running the no_alu32 version, but
> so far, not able to run test_progs-no_alu32. Whenever I ran
> test_progs-no_alu32, it exits without any message. Do you have any
> clue what could be wrong?

It works fine in my environment. test_progs should be very similar to
test_progs-no_alu32. The only difference is bpf programs with different
insn set. Some tests may not run with test_progs-no_alu32, e.g., newer
atomic insn tests.

I have no idea why test_progs-no_alu32 won't work for you, I guess you 
may need to debug it a little bit.

> 
>>>
> [...]

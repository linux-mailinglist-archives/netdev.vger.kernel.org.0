Return-Path: <netdev+bounces-5165-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E578870FE92
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 21:35:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C1E3281379
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 19:35:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E10EC200B0;
	Wed, 24 May 2023 19:35:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE15C13F;
	Wed, 24 May 2023 19:35:01 +0000 (UTC)
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6275A12F;
	Wed, 24 May 2023 12:34:59 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 34OHZQSa013199;
	Wed, 24 May 2023 12:34:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=NUbjI9MblHHjXelwd2qnUO01v3T/AoeWVodmyQDpBag=;
 b=lXwn6zaXY5Rw15LA5ILTb2tc56j8KScMuBQbJ/INJxMX0hEDAIBwcm4/LPcA2CmhumCs
 T8FRDVDikDwNnkZ1iABOWRHl9F+zVnhrMmaw4yJdYc2w+hs+tIJxo31U8tTfm/Q8txp3
 Pr45eIVXYyCp7MjjaJ1mrgny91BDyCvs8wjNtcRGxRnhDArp88JwAtst/jiMG4KkiZ5P
 DwvpfTio8XYzR7ArmUSFq6Sm9/A2YmUNBJH+Dsq/f0lSW50BDnr19cVRqFy1xA9o501F
 Zr6R9bZgLZ2+mZ861E60aEoc3VMrK0e/UdI2zpf1FPiZOI/trFBbchw52nk6suh3daSH +g== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
	by m0001303.ppops.net (PPS) with ESMTPS id 3qs8emxgt2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 May 2023 12:34:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HLUvemTl36xcKawMFhYSJs4j1ChzR09j29/ddIePRrZNnD+qfs4YVoQWyWXiRvdkn+iSqa72Drdp3WBu9gGAQZRfSMZgRBKmQmuRN+Qe/wmW60x+e+NZVW1DAaabLY7891wYHUqy6YGvZOeyrbh3nnZknt5/FEkF8CDI+yEQph5G0EdxWwbKQn75N+74wkX83LxDfw3P2HVu+YQ5ggX/4yvxZa9RzSpsjR+HN6Rw5A6ecf/nPIuEpLLfRzCOxWjnNbrPbVls64BdNvTVjfFn4gmi8B/Xb6dgj8CFu+e4jYAqEJWmunqzMVGjjrpMCFDNKrSDtRbsZfZtE/ZYvIcLNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NUbjI9MblHHjXelwd2qnUO01v3T/AoeWVodmyQDpBag=;
 b=dtLkX6Xzfn/KaMP7qYziVHw6Zu3H8DJdhndcImmM73PhI3epeNyUjpQGL2FRDY41CV+OnW9EG1OQsP9YYuxIPboZN47Otsf06aKgUN4wn40M/DlRWraFv+Lo/Uz2e1MW4lr1v7V8QybIyYZfPfOWnAOLhLwwvo+uT3B0/NDuqghnT9EDQ93JZFZjLSkkjvwjUk1paJR75k5ntV5nFk9zuDSHAJgz7JEAOn4ZV9ggRQLArKkU1sTqRPlDlr4VulOZQPI6v7vMkzSz9zIs91fnTNdL1LI/kJFt9fFMM6UeUP5E7R5uNwf4/6jM7kEUaKkZ7Ga8xldi8bqE9WQGOuHObA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by DM4PR15MB5504.namprd15.prod.outlook.com (2603:10b6:8:88::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6433.16; Wed, 24 May 2023 19:34:35 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::589f:9230:518:7f53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::589f:9230:518:7f53%7]) with mapi id 15.20.6411.028; Wed, 24 May 2023
 19:34:35 +0000
Message-ID: <113dc8c1-0840-9ee3-2840-28246731604c@meta.com>
Date: Wed, 24 May 2023 12:34:31 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
Subject: Re: [bug] kernel: bpf: syscall: a possible sleep-in-atomic bug in
 __bpf_prog_put()
Content-Language: en-US
To: Teng Qi <starmiku1207184332@gmail.com>
Cc: ast@kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20230516111823.2103536-1-starmiku1207184332@gmail.com>
 <e37c0a65-a3f6-e2e6-c2ad-367db20253a0@meta.com>
 <CALyQVax8X63qekZVhvRTmZFFs+ucPKRkBB7UnRZk6Hu3ggi7Og@mail.gmail.com>
 <57dc6a0e-6ba9-e77c-80ac-6bb0a6e2650a@meta.com>
 <CALyQVazb=D1ejapiFdTnan6JbjFJA2q9ifhSsmF4OC9MDz3oAw@mail.gmail.com>
 <d027cb6b-e32c-36ad-3aba-9a7b1177f89f@meta.com>
 <CALyQVayW7e4FPbaMNNuOmYGYt5pcd47zsx2xVkrekEDaVm7H2g@mail.gmail.com>
From: Yonghong Song <yhs@meta.com>
In-Reply-To: <CALyQVayW7e4FPbaMNNuOmYGYt5pcd47zsx2xVkrekEDaVm7H2g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: BYAPR11CA0044.namprd11.prod.outlook.com
 (2603:10b6:a03:80::21) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|DM4PR15MB5504:EE_
X-MS-Office365-Filtering-Correlation-Id: a4f58cf6-aabb-4c78-209d-08db5c8de7bb
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	gCp3b3oBs+Ut5586tqSbr+lnuFqORjpi+aPx96PQV3yb6Hb+iUJjD2beEJejejA/iSsZqdZhcgD/taS1mMVRZ3kbDalIryXCwLlE8YudjpJEn8RvrhiGXY0a8YqSIiM+iWy6xI5aOc+gVjpSapqGd/nlFsrKNZvkTPeU2x8Vss8T9KC4SmGoVn5XjuEnIvqKOyBjrWEcAni82JBjSlKc5QxyqXGCJz2KTE6UxAlctlM2YKscbktssHREfy1a1UNIwl4sbclMfNsE6I/4wMAgRoGRiTDBzAlQJPQfKLCGLOBoe8S96vkb6RYSuBGmQnS3GURoQZzcfJ7CSmd0LwfIZEcGyhuxgcwckqDwwmJrCP/eJjY+VYZp4xecKkTWALJMBzDqma244X43dIqidStmOHjpoSY2jwyRpNJDEMk1MP+gieA040SsH9b3x11/RzLRArr8S2K1cdyvLeIt92UTsiFSdNHdJXWXvMsJvf0/iqKAADy8sd70t0XvCcJxSQxafuXNfZ1vO+KCTx6NAmua+iYCV4e4RMpoSxJDkkx7YMWkmFybz4jj/6/BsTgNUG44ibuUzjrTaFV2flSrVoI/cCUzy/i9bzH7JaJ6KtRuunDbp6KxklaFtQvl7Dj+W9QfcpP0d4sWpdT7vSqQSaZc9Q==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(396003)(376002)(136003)(366004)(451199021)(6916009)(7416002)(36756003)(8676002)(8936002)(5660300002)(478600001)(4326008)(31686004)(66556008)(66946007)(66476007)(316002)(6666004)(6486002)(41300700001)(38100700002)(2906002)(6512007)(6506007)(30864003)(186003)(83380400001)(2616005)(31696002)(86362001)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?N0tRc1dDcjZVY01yTXhSTUZEem1rRVFadlNSQTZndjBIM1NmVEZEQkg0QjF4?=
 =?utf-8?B?L2hLRTcydHVrL29xakFmeStsVDF0QmgxZVZ2MkVDbHNSems4eTFTNUVVN2lU?=
 =?utf-8?B?SXFWSEZ1a2RLQTljREZCTElndnZYOUFiNTZpenF3Sy9vR0VxWkRoMXRvZVl4?=
 =?utf-8?B?RlRQNjYvZG5WMGd1WjhTZXpWNjlIVTRqakZXdnp6RmgyREprd1JIRG5NNjha?=
 =?utf-8?B?eGZScUNjeXF0QlVITDk0WEd3ZDJzSnp5YlkzNm5zaUluVy9vYU12M1JmRjda?=
 =?utf-8?B?eGo0d1Fud3RUdlVTeDNJLzAwazk0VjN5Ulk2OVFlRXRpa01FTHcraVdraXE1?=
 =?utf-8?B?eVRJTGZDK2FqKzBHZ2NLZGZQK3lYVi9QSTRYYTdHbHNKTUNPcnVxN21vWCtn?=
 =?utf-8?B?Y1BaeGVta205NWNuUkJ2dTZuaWZoSlp4R2Z3eWF1R0M5MDU0ODZaSWpQVkZu?=
 =?utf-8?B?anlaNTg0QUV5cWgvZUp5OE14UGIra1ZybHVPVkowQk5LOWhPVDhGbThjakY4?=
 =?utf-8?B?QURjT0FQRU01SUgvd3NadlRCb3lwa2xVbWU1U2FlUmFZNTgwcVp6bDBlSVFz?=
 =?utf-8?B?aFhpMllpSFM4U2RFL3ozWjFmRTRzdXlwVUFBMzhobTYrc25UQjMvZDd0eEtM?=
 =?utf-8?B?dVdmUGhVQW5pUTNEK3VzVk5OL2owNGlLL0dDMDNyb3BLNEVmYTdjWVNRK2JT?=
 =?utf-8?B?elE2MC9EZG9tQnpobjlHZElKdFJuMDc4US9UM240dzJodk5Eb1dvUkJURWdh?=
 =?utf-8?B?NWx5MjQweWN6T3BLSkNpUlJIVEZNN0RsR2FwSTJSRGsrcnlKVEVSTGo1ZnA0?=
 =?utf-8?B?bGNYQ0dMYVVEL0w0Yk80dG9qV212VFJVMnkzMXhva3dtYTc1QWtOTUlJZUxV?=
 =?utf-8?B?M0llT1JTVDBUZ2ZkM29VRlJ2ck9yVXk2S1orRVRFZm1mVmdtdUV6VHVGN1NJ?=
 =?utf-8?B?ay8rcTNZU3VHeUJaQitmekwyNDU1MVFvOEhKWFk3ckluYUkwODYxWHpHK21C?=
 =?utf-8?B?Vm1Ra2dBb28rOVJONkhSaitzem1jOXFtUjU5b2RlVzdZN0NVTHphWU1xUEhr?=
 =?utf-8?B?QTRDdWpaQzBsSTJmYytIdjVpUWdSNzQyODRzOFNEaUVXL3Y2RnBST0E2UVNN?=
 =?utf-8?B?UFNnUnI4eC9LSCs0bmdVQzgzcVNOY2ozQWJDL0Nhd1FtRzJlL0JzYmsxZzhq?=
 =?utf-8?B?VWRNYmhFeTNDaHg0RTVpYStKZVdXNXcydUwrNHBScVdJR0xoSWRleUltdGZF?=
 =?utf-8?B?d01vbWcybEFQSEEvUU1wdzhQeCtBMFVaSzVNSU5aZ0dHSGprcUk5ZTlYTE5D?=
 =?utf-8?B?dFVpemdMRkJhSlNoT3Q4ejhqOWgyZEtNcDVEVWFVbklrOTFsamE2V3gzTTNt?=
 =?utf-8?B?ck1yeWZLajd6bjVnQVcva2hUdDZybEpnUDRjemp2OWNpTXgwTUliUFQyemNV?=
 =?utf-8?B?eGFob3ZxRUlSdlJuazFyaTljL3ZGMERGc0txMWdoYzJ1WFRITW5HMlFkV1BN?=
 =?utf-8?B?bC9laHUwMVhIcU5ZRHU1c1pWeGdYSWE3K1cyaEIwUE02QUsrOXNVd3VqOVNH?=
 =?utf-8?B?a0QwRnF2NHVON21RdFdyK2pvbE9EaUJoL2krNER4aWVMcjJKZitEc29ySDZa?=
 =?utf-8?B?dTgyNXJBZ0dOajdXSVhxZklNU0x4NHhIVGlrQXc2ejdzSmIybnFBaFJ0MFIv?=
 =?utf-8?B?WUlaMDVFRkVnd2p5NUVOUVJVMmI0REEwRkV5aFhnRFZod3NTQmJsSFZvaThk?=
 =?utf-8?B?ZzVDdGhyQWdqb2tXL0lGQ2d0SE5SWWJISWFuNEx6blZTSUhEenFaMDdJRVgv?=
 =?utf-8?B?SFFESi93V0VZZW9vYzF0Y084K3FqRGhDTjJkeG1Kd09SWS9wSWI0M2Q2Ulp0?=
 =?utf-8?B?MDRaKzZubDhoOUZkcTNnamRYMEdOK0wyVWNkY0NNVTdCSytHUVdiZ05ieFAv?=
 =?utf-8?B?QllFVTR1UlV6bW5nUmN6YzB3ZnpoWStuSHFiZWt6NGU1Qzd0T0NiNnU2UXpS?=
 =?utf-8?B?b01kRDhiRjFReldsNWFJVUZBYW1tcFhBeGxmUU4wNmdlZWhzdXhlbm9pTS9F?=
 =?utf-8?B?VSt5OWNRWjhub2g3UC95bEVVYWtLUTRzMkdmMXNyci84WXNLY0Rja3Rnek9n?=
 =?utf-8?B?d1lEZThucTNQblNaM2tWeW9RYVdZUVBkYW9HWDdiUk55Wmw3ekJ6WGN2czVC?=
 =?utf-8?B?d3c9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4f58cf6-aabb-4c78-209d-08db5c8de7bb
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 19:34:35.2696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WpV5UqqAjDQTyZG+zdpkDsu4zIJx8jzu8NqUJz9Aeeub5wHOimwQUSpC+3aOmsmy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR15MB5504
X-Proofpoint-ORIG-GUID: oQfOaX5fGVUzra92MjMlIkI5XhqGWcIY
X-Proofpoint-GUID: oQfOaX5fGVUzra92MjMlIkI5XhqGWcIY
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-24_14,2023-05-24_01,2023-05-22_02
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/24/23 5:42 AM, Teng Qi wrote:
> Thank you.
> 
>> We cannot use rcu_read_lock_held() in the 'if' statement. The return
>> value rcu_read_lock_held() could be 1 for some configurations regardless
>> whether rcu_read_lock() is really held or not. In most cases,
>> rcu_read_lock_held() is used in issuing potential warnings.
>> Maybe there are other ways to record whether rcu_read_lock() is held or not?
> 
> Sorry. I was not aware of the dependency of configurations of
> rcu_read_lock_held().
> 
>> If we cannot resolve rcu_read_lock() presence issue, maybe the condition
>> can be !in_interrupt(), so any process-context will go to a workqueue.
> 
> I agree that using !in_interrupt() as a condition is an acceptable solution.

This should work although it could be conservative.

> 
>> Alternatively, we could have another solution. We could add another
>> function e.g., bpf_prog_put_rcu(), which indicates that bpf_prog_put()
>> will be done in rcu context.
> 
> Implementing a new function like bpf_prog_put_rcu() is a solution that involves
> more significant changes.

Maybe we can change signature of bpf_prog_put instead? Like
    void bpf_prog_put(struct bpf_prog *prog, bool in_rcu)
and inside bpf_prog_put we can add
    WARN_ON_ONCE(in_rcu && !bpf_rcu_lock_held());

> 
>> So if in_interrupt(), do kvfree, otherwise,
>> put into a workqueue.
> 
> Shall we proceed with submitting a patch following this approach?

You could choose either of the above although I think with newer 
bpf_prog_put() is better.

BTW, please do create a test case, e.g, sockmap test case which
can show the problem with existing code base.

> 
> I would like to mention something unrelated to the possible bug. At this
> moment, things seem to be more puzzling. vfree() is safe under in_interrupt()
> but not safe under other atomic contexts.
> This disorder challenges our conventional belief, a monotonic incrementation
> of limitations of the hierarchical atomic contexts, that programer needs
> to be more and more careful to write code under rcu read lock, spin lock,
> bh disable, interrupt...
> This disorder can lead to unexpected consequences, such as code being safe
> under interrupts but not safe under spin locks.
> The disorder makes kernel programming more complex and may result in more bugs.
> Even though we find a way to resolve the possible bug about the bpf_prog_put(),
> I feel sad for undermining of kernel`s maintainability and disorder of
> hierarchy of atomic contexts.
> 
> -- Teng Qi
> 
> On Tue, May 23, 2023 at 12:33 PM Yonghong Song <yhs@meta.com> wrote:
>>
>>
>>
>> On 5/21/23 6:39 AM, Teng Qi wrote:
>>> Thank you.
>>>
>>>   > Your above analysis makes sense if indeed that kvfree cannot appear
>>>   > inside a spin lock region or RCU read lock region. But is it true?
>>>   > I checked a few code paths in kvfree/kfree. It is either guarded
>>>   > with local_irq_save/restore or by
>>>   > spin_lock_irqsave/spin_unlock_
>>>   > irqrestore, etc. Did I miss
>>>   > anything? Are you talking about RT kernel here?
>>>
>>> To see the sleepable possibility of kvfree, it is important to analyze the
>>> following calling stack:
>>> mm/util.c: 645 kvfree()
>>> mm/vmalloc.c: 2763 vfree()
>>>
>>> In kvfree(), to call vfree, if the pointer addr points to memory
>>> allocated by
>>> vmalloc(), it calls vfree().
>>> void kvfree(const void *addr)
>>> {
>>>           if (is_vmalloc_addr(addr))
>>>                   vfree(addr);
>>>           else
>>>                   kfree(addr);
>>> }
>>>
>>> In vfree(), in_interrupt() and might_sleep() need to be considered.
>>> void vfree(const void *addr)
>>> {
>>>           // ...
>>>           if (unlikely(in_interrupt()))
>>>           {
>>>                   vfree_atomic(addr);
>>>                   return;
>>>           }
>>>           // ...
>>>           might_sleep();
>>>           // ...
>>> }
>>
>> Sorry. I didn't check vfree path. So it does look like that
>> we need to pay special attention to non interrupt part.
>>
>>>
>>> The vfree() may sleep if in_interrupt() == false. The RCU read lock region
>>> could have in_interrupt() == false and spin lock region which only disables
>>> preemption also has in_interrupt() == false. So the kvfree() cannot appear
>>> inside a spin lock region or RCU read lock region if the pointer addr points
>>> to memory allocated by vmalloc().
>>>
>>>   > > Therefore, we propose modifying the condition to include
>>>   > > in_atomic(). Could we
>>>   > > update the condition as follows: "in_irq() || irqs_disabled() ||
>>>   > > in_atomic()"?
>>>   > Thank you! We look forward to your feedback.
>>>
>>> We now think that ‘irqs_disabled() || in_atomic() ||
>>> rcu_read_lock_held()’ is
>>> more proper. irqs_disabled() is for irq flag reg, in_atomic() is for
>>> preempt count and rcu_read_lock_held() is for RCU read lock region.
>>
>> We cannot use rcu_read_lock_held() in the 'if' statement. The return
>> value rcu_read_lock_held() could be 1 for some configuraitons regardless
>> whether rcu_read_lock() is really held or not. In most cases,
>> rcu_read_lock_held() is used in issuing potential warnings.
>> Maybe there are other ways to record whether rcu_read_lock() is held or not?
>>
>> I agree with your that 'irqs_disabled() || in_atomic()' makes sense
>> since it covers process context local_irq_save() and spin_lock() cases.
>>
>> If we cannot resolve rcu_read_lock() presence issue, maybe the condition
>> can be !in_interrupt(), so any process-context will go to a workqueue.
>>
>> Alternatively, we could have another solution. We could add another
>> function e.g., bpf_prog_put_rcu(), which indicates that bpf_prog_put()
>> will be done in rcu context. So if in_interrupt(), do kvfree, otherwise,
>> put into a workqueue.
>>
>>
>>>
>>> -- Teng Qi
>>>
>>> On Sun, May 21, 2023 at 11:45 AM Yonghong Song <yhs@meta.com
>>> <mailto:yhs@meta.com>> wrote:
>>>
>>>
>>>
>>>      On 5/19/23 7:18 AM, Teng Qi wrote:
>>>       > Thank you for your response.
>>>       >  > Looks like you only have suspicion here. Could you find a real
>>>      violation
>>>       >  > here where __bpf_prog_put() is called with !in_irq() &&
>>>       >  > !irqs_disabled(), but inside spin_lock or rcu read lock? I
>>>      have not seen
>>>       >  > things like that.
>>>       >
>>>       > For the complex conditions to call bpf_prog_put() with 1 refcnt,
>>>      we have
>>>       > been
>>>       > unable to really trigger this atomic violation after trying to
>>>      construct
>>>       > test cases manually. But we found that it is possible to show
>>>      cases with
>>>       > !in_irq() && !irqs_disabled(), but inside spin_lock or rcu read lock.
>>>       > For example, even a failed case, one of selftest cases of bpf,
>>>      netns_cookie,
>>>       > calls bpf_sock_map_update() and may indirectly call bpf_prog_put()
>>>       > only inside rcu read lock: The possible call stack is:
>>>       > net/core/sock_map.c: 615 bpf_sock_map_update()
>>>       > net/core/sock_map.c: 468 sock_map_update_common()
>>>       > net/core/sock_map.c:  217 sock_map_link()
>>>       > kernel/bpf/syscall.c: 2111 bpf_prog_put()
>>>       >
>>>       > The files about netns_cookie include
>>>       > tools/testing/selftests/bpf/progs/netns_cookie_prog.c and
>>>       > tools/testing/selftests/bpf/prog_tests/netns_cookie.c. We
>>>      inserted the
>>>       > following code in
>>>       > ‘net/core/sock_map.c: 468 sock_map_update_common()’:
>>>       > static int sock_map_update_common(..)
>>>       > {
>>>       >          int inIrq = in_irq();
>>>       >          int irqsDisabled = irqs_disabled();
>>>       >          int preemptBits = preempt_count();
>>>       >          int inAtomic = in_atomic();
>>>       >          int rcuHeld = rcu_read_lock_held();
>>>       >          printk("in_irq() %d, irqs_disabled() %d, preempt_count() %d,
>>>       >            in_atomic() %d, rcu_read_lock_held() %d", inIrq,
>>>      irqsDisabled,
>>>       >            preemptBits, inAtomic, rcuHeld);
>>>       > }
>>>       >
>>>       > The output message is as follows:
>>>       > root@(none):/root/bpf# ./test_progs -t netns_cookie
>>>       > [  137.639188] in_irq() 0, irqs_disabled() 0, preempt_count() 0,
>>>       > in_atomic() 0,
>>>       >          rcu_read_lock_held() 1
>>>       > #113     netns_cookie:OK
>>>       > Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED
>>>       >
>>>       > We notice that there are numerous callers in kernel/, net/ and
>>>      drivers/,
>>>       > so we
>>>       > highly suggest modifying __bpf_prog_put() to address this gap.
>>>      The gap
>>>       > exists
>>>       > because __bpf_prog_put() is only safe under in_irq() ||
>>>      irqs_disabled()
>>>       > but not in_atomic() || rcu_read_lock_held(). The following code
>>>      snippet may
>>>       > mislead developers into thinking that bpf_prog_put() is safe in all
>>>       > contexts.
>>>       > if (in_irq() || irqs_disabled()) {
>>>       >          INIT_WORK(&aux->work, bpf_prog_put_deferred);
>>>       >          schedule_work(&aux->work);
>>>       > } else {
>>>       >          bpf_prog_put_deferred(&aux->work);
>>>       > }
>>>       >
>>>       > Implicit dependency may lead to issues.
>>>       >
>>>       >  > Any problem here?
>>>       > We mentioned it to demonstrate the possibility of kvfree() being
>>>       > called by __bpf_prog_put_noref().
>>>       >
>>>       > Thanks.
>>>       > -- Teng Qi
>>>       >
>>>       > On Wed, May 17, 2023 at 1:08 AM Yonghong Song <yhs@meta.com
>>>      <mailto:yhs@meta.com>
>>>       > <mailto:yhs@meta.com <mailto:yhs@meta.com>>> wrote:
>>>       >
>>>       >
>>>       >
>>>       >     On 5/16/23 4:18 AM, starmiku1207184332@gmail.com
>>>      <mailto:starmiku1207184332@gmail.com>
>>>       >     <mailto:starmiku1207184332@gmail.com
>>>      <mailto:starmiku1207184332@gmail.com>> wrote:
>>>       >      > From: Teng Qi <starmiku1207184332@gmail.com
>>>      <mailto:starmiku1207184332@gmail.com>
>>>       >     <mailto:starmiku1207184332@gmail.com
>>>      <mailto:starmiku1207184332@gmail.com>>>
>>>       >      >
>>>       >      > Hi, bpf developers,
>>>       >      >
>>>       >      > We are developing a static tool to check the matching between
>>>       >     helpers and the
>>>       >      > context of hooks. During our analysis, we have discovered some
>>>       >     important
>>>       >      > findings that we would like to report.
>>>       >      >
>>>       >      > ‘kernel/bpf/syscall.c: 2097 __bpf_prog_put()’ shows that
>>>      function
>>>       >      > bpf_prog_put_deferred() won`t be called in the condition of
>>>       >      > ‘in_irq() || irqs_disabled()’.
>>>       >      > if (in_irq() || irqs_disabled()) {
>>>       >      >      INIT_WORK(&aux->work, bpf_prog_put_deferred);
>>>       >      >      schedule_work(&aux->work);
>>>       >      > } else {
>>>       >      >
>>>       >      >      bpf_prog_put_deferred(&aux->work);
>>>       >      > }
>>>       >      >
>>>       >      > We suspect this condition exists because there might be
>>>      sleepable
>>>       >     operations
>>>       >      > in the callees of the bpf_prog_put_deferred() function:
>>>       >      > kernel/bpf/syscall.c: 2097 __bpf_prog_put()
>>>       >      > kernel/bpf/syscall.c: 2084 bpf_prog_put_deferred()
>>>       >      > kernel/bpf/syscall.c: 2063 __bpf_prog_put_noref()
>>>       >      > kvfree(prog->aux->jited_linfo);
>>>       >      > kvfree(prog->aux->linfo);
>>>       >
>>>       >     Looks like you only have suspicion here. Could you find a real
>>>       >     violation
>>>       >     here where __bpf_prog_put() is called with !in_irq() &&
>>>       >     !irqs_disabled(), but inside spin_lock or rcu read lock? I
>>>      have not seen
>>>       >     things like that.
>>>       >
>>>       >      >
>>>       >      > Additionally, we found that array prog->aux->jited_linfo is
>>>       >     initialized in
>>>       >      > ‘kernel/bpf/core.c: 157 bpf_prog_alloc_jited_linfo()’:
>>>       >      > prog->aux->jited_linfo = kvcalloc(prog->aux->nr_linfo,
>>>       >      >    sizeof(*prog->aux->jited_linfo),
>>>      bpf_memcg_flags(GFP_KERNEL |
>>>       >     __GFP_NOWARN));
>>>       >
>>>       >     Any problem here?
>>>       >
>>>       >      >
>>>       >      > Our question is whether the condition 'in_irq() ||
>>>       >     irqs_disabled() == false' is
>>>       >      > sufficient for calling 'kvfree'. We are aware that calling
>>>       >     'kvfree' within the
>>>       >      > context of a spin lock or an RCU lock is unsafe.
>>>
>>>      Your above analysis makes sense if indeed that kvfree cannot appear
>>>      inside a spin lock region or RCU read lock region. But is it true?
>>>      I checked a few code paths in kvfree/kfree. It is either guarded
>>>      with local_irq_save/restore or by
>>>      spin_lock_irqsave/spin_unlock_irqrestore, etc. Did I miss
>>>      anything? Are you talking about RT kernel here?
>>>
>>>
>>>       >      >
>>>       >      > Therefore, we propose modifying the condition to include
>>>       >     in_atomic(). Could we
>>>       >      > update the condition as follows: "in_irq() ||
>>>      irqs_disabled() ||
>>>       >     in_atomic()"?
>>>       >      >
>>>       >      > Thank you! We look forward to your feedback.
>>>       >      >
>>>       >      > Signed-off-by: Teng Qi <starmiku1207184332@gmail.com
>>>      <mailto:starmiku1207184332@gmail.com>
>>>       >     <mailto:starmiku1207184332@gmail.com
>>>      <mailto:starmiku1207184332@gmail.com>>>
>>>       >
>>>


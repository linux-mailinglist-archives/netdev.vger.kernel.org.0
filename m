Return-Path: <netdev+bounces-8323-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A8CC1723ADC
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 10:01:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 75B46281514
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 08:01:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 950A427713;
	Tue,  6 Jun 2023 08:01:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83624611C
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 08:01:27 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2087.outbound.protection.outlook.com [40.107.101.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 818CB1BE2
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 01:01:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bOOfC250FZi57ZaFZdt5A6Hz8wlnF5gQRsErvWEmwe+E1ZoylLJ89Y8hrd3oMPj0sX2PFcjnLcLw7UPVsOL8O712lAuhrl7KqF7Dcp/4LBYzynJ7W2ajb03nOOEigJDky48qgYyy8qimS/o5FF09XFjJkulabjGhjO8qc6RITKYKKFo5eVrBlZXk5dCEx41Yl8GkwWaXa/KI4TED1AT5O5fMsxi19AH6uaudLr1CgykGG1eOeERGgZV0TOuSLOCtwqEwDJIN4RGPOwb5DrSwn/nMW+9Fa6rp50tNo8N2M4TMETXEJYzZBj6Xtc5cJzg588ywkD7tj5YsMsSLR6RQsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YB5DfYZbGnRZqKs/btv2ZpwDv7GXW8psNoEjPBEOCGU=;
 b=AI6mrxwLTnb3LqvElYmcLknBlqlQ8GfAF8ui1DvYN1xbR2IAN4wMYdxPDQSVrcv9vOcLJ1AkMXaawwQw0XP10z+P5jemWlwH+5Bv7bpWrRzYeuXZot1S5Q53l2kAh15SN8dmIbuJeetVfVYbOo1UspUyS13tU0XabWUKNhLsAHOrBunDWtJ2pJZz4S8X/PQ7j14CZuvNF0o6bd9FozmItGnIKUe/5SXY74uD87w2MFytDuTQy6EnKbMe6geM40WfS2Hs0h11XNqZIc9pNRCLdnxENm65JstUF9maoZXmkPd89XzSTzhH7sS080PhvxIR2kbDYJcLTHmYVRyi9DyWLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YB5DfYZbGnRZqKs/btv2ZpwDv7GXW8psNoEjPBEOCGU=;
 b=SfhCue+xfjI/fR/mm7DdySL0gk6z/yFa/CBN9YSfbJSC01FRQMC8qDla2cow5Vcth9G6VSfZ9A2n/f+ZtM8iDs1Aj5fCIV1zG43tdiAZ8KpYfOqa9C7ysOuRUc2hcer81LHZhVcKC7LN0ZluETUAAeXtNbZ8cggVov5fk805TUPx+v3NsQKiJNn9ftHHfAUo+PyL2elKIkoIhCWB3JLQD1DPCWh/t7nclAa1a0d34w568gP243L3wvubgGF9l2Sp0d5JFyNfUPZWFiVDE+Ub9FruAbmylyCPu0vfaH55or83RSR63Z8tuVQoR8Lz92xx5P743zgicg4BP3hZbGfjIA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 DM4PR12MB5247.namprd12.prod.outlook.com (2603:10b6:5:39b::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.32; Tue, 6 Jun 2023 08:01:21 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::12e5:730c:ea20:b402]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::12e5:730c:ea20:b402%4]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 08:01:20 +0000
Message-ID: <0c04665f-545a-7552-a4c2-c7b9b2ee4e6b@nvidia.com>
Date: Tue, 6 Jun 2023 11:01:14 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 1/4] netlink: truncate overlength attribute list
 in nla_nest_end()
To: Edwin Peer <espeer@gmail.com>, Jakub Kicinski <kuba@kernel.org>
Cc: David Ahern <dsahern@gmail.com>, netdev <netdev@vger.kernel.org>,
 Andrew Gospodarek <andrew.gospodarek@broadcom.com>,
 Michael Chan <michael.chan@broadcom.com>,
 Stephen Hemminger <stephen@networkplumber.org>,
 Michal Kubecek <mkubecek@suse.cz>
References: <20210123045321.2797360-1-edwin.peer@broadcom.com>
 <20210123045321.2797360-2-edwin.peer@broadcom.com>
 <1dc163b0-d4b0-8f6c-d047-7eae6dc918c4@gmail.com>
 <CAKOOJTwKK5AgTf+g5LS4MMwR_HwbdFS6U7SFH0jZe8FuJMgNgA@mail.gmail.com>
 <CAKOOJTzwdSdwBF=H-h5qJzXaFDiMoX=vjrMi_vKfZoLrkt4=Lg@mail.gmail.com>
 <62a12b2c-c94e-8d89-0e75-f01dc6abbe92@gmail.com>
 <CAKOOJTwBcRJah=tngJH3EaHCCXb6T_ptAV+GMvqX_sZONeKe9w@mail.gmail.com>
 <cdbd5105-973a-2fa0-279b-0d81a1a637b9@nvidia.com>
 <20230605115849.0368b8a7@kernel.org>
 <CAOpCrH4-KgqcmfXdMjpp2PrDtSA4v3q+TCe3C9E5D3Lu-9YQKg@mail.gmail.com>
Content-Language: en-US
From: Gal Pressman <gal@nvidia.com>
In-Reply-To: <CAOpCrH4-KgqcmfXdMjpp2PrDtSA4v3q+TCe3C9E5D3Lu-9YQKg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0165.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:99::7) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6288:EE_|DM4PR12MB5247:EE_
X-MS-Office365-Filtering-Correlation-Id: 26aeb291-8e6b-4079-f481-08db666436d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	v2wfad/ucnFQs93uGZpbhT3uRLvtBicEXGwO+cmzI05rf4j9fUBy3hZmBfbC303PIfnNuhkS8Y6bvseosW57jb0vw8eQGs8kI28igB2CnGOwaek4YQIm+BrrS+TJmcqhkZks9EzHEMyvw1lo+ZjRIOGFSMwiypdlKCoZbbszP7hF8mQbLHl7+tCsg0FsBhxioy/b8ftVZ3NbDWilgmTj4xphs1npWkytDhTsNKy/7xC9CB4sJFg+VMXtRjhuwFsatRwtiNGu5EjSOWhmDBZgHKGEuCi2rjLNptDAWbzCnqaUHE+HrXb6edEoQuBVC7wQTVblg3FSyC7gMNklYKt9ZdTkzch8ZOk7KYrwsLaLODbHyqF54HVWnoLyf7LXIY1wikgf6mDMMCISBrBBYrt8+VG1q6yRJ/zH9wFi6CFEyCC70D0BjW5SKnp4SgrOXt4FAueM+X8hp+eowSXjsHbUJoiwJIwGrANRuCJZi48umz3m+Te8OkvpzzCr+r7wZDXvywv+adXD03OEGkiKBIG8cMiYUkbHjyyiqf63M6Lv3oV8opyC0bYBu1einWnzn3WMP067TKxKjQr6HRTY855azFkQ6MFJmkT23iIsT0avmnX32sgq83rQoye+XX7NvpbbX06L4c3xwU5LvpQ4AM81zG8uDI9Qh7UmZian2YbTwRqitMsjtDL1Su1PYZvhpLUI
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(396003)(39860400002)(136003)(346002)(451199021)(53546011)(6512007)(6506007)(38100700002)(2616005)(41300700001)(6486002)(31686004)(6666004)(26005)(186003)(83380400001)(966005)(478600001)(110136005)(54906003)(66556008)(66476007)(66946007)(316002)(4326008)(5660300002)(8676002)(8936002)(31696002)(2906002)(86362001)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S2pXSURJdlRtdjBpaEVTM0J2Nlg3eUFRMWdYWGp4ODhHeHdqdzZDNm1kWnBQ?=
 =?utf-8?B?NXpnZFRKd2cvVE9GYVkvTTczNEFGQlhPYVNBbG1hTVBzSnhrT3FyaGNhdlBS?=
 =?utf-8?B?TC91T2I5TjBPOHV6UDVPQXQzNWNDWTk5cEpsYklTNEhMaUpRUFBVa0RsYnRQ?=
 =?utf-8?B?QTBpYUlITlJpZmZKZU5DSGpMWjZOMmRYaS9TenNjK0dzaHpuUjFIVGttQ3VU?=
 =?utf-8?B?NVl6OFVGcGJsdlZSYnNtMXhwUlhXcWI0M04wb2VEeXRFTXN3ZGc0WjVYT3k5?=
 =?utf-8?B?djc0c0E4QlNoYkRGRGE2emVQSyswdVdQekRQNG5sU3RyMVVpeDRjdWJkQTJ4?=
 =?utf-8?B?WXFzWit5VHgvMVVkdGY3L3dpVDZCVnByVVNWT0ttVjJzUG95OUdmbUdsWmdt?=
 =?utf-8?B?cUxvYitUY2gwRTZESjdVUkh6d0lySlFCY0ZHUDB4VkxFbHpOZjJyNGJhZFhp?=
 =?utf-8?B?NUpDT2RITnpTaTREYmVuUGJTU1Y5Tkx2WkRMdmhyV21SSTJBZ3pIR1JXMHpQ?=
 =?utf-8?B?M1N5b3RLaW1Ua08rU3B2NENTMWRxVVR0VDdBYUFKRmZOMU10a05wS2Rzd1dT?=
 =?utf-8?B?Umg3WEN0R0Y1UXp6eWFQY1MxR29zS1pYM0JMQTdXbkhYZFJkR2hZS1NyL04y?=
 =?utf-8?B?R1E1bGZ3UXpDWmVuUSt6OGRZLytOQUkvL0trY3dVdEtPbUR6RC9pUnJPMm1V?=
 =?utf-8?B?MVN3bDhUMmU2TFY1cjNyK1BHVXZBRGhDUnBNZ09VTU8zZlVPV1lGcTZyc0Fq?=
 =?utf-8?B?THE4NjR5MmszSTlQYkhidEw2Z1FkVWliQitkMS80ckh3UW01T1EvVHg5NVV0?=
 =?utf-8?B?SHoxNGNOQWsrSnlnZlJUblhvb1AyTlZBQTR5ODFjNEovVnVmS3k4clB5SUFL?=
 =?utf-8?B?TE5KendOUW5ZaWNWYmFEaDE4R08wOGJyeHUwNTVQcm8rT3J2TjNpNDBJYk9S?=
 =?utf-8?B?L1NyeVhtK2hyMnZ3Nzl1TTZweER6ODhkcElrZlk4L1Q5a05UcEY4cytrVGFr?=
 =?utf-8?B?eUpUNFdZcCtpYzBEYXJvbnI5OVo1UTA5OWlWQlVpYVpSWHdXRnh1TWc3SS8r?=
 =?utf-8?B?MnRhd1l0UGNrd0RhUFAzelZ6c3psSVgvRXpvY2tVUGZhdlgzNmZhQ2NGOVhT?=
 =?utf-8?B?RVBpSVFYWEg3Umc1N210Y0NyUG56R1ZENzJtZ3grZkVkMk45T0UyVituWm55?=
 =?utf-8?B?K1E4MTJqUWY5VnRRWkFUNW12c2RhdVRjYW9Zc0RYaFBXSGZQSWltQi8xdEtR?=
 =?utf-8?B?bzZydW9GM1pralJHSE1CTGRYVXRtRk1iaERoT3dnTjVVVkVQQURxUHoyNEVn?=
 =?utf-8?B?NFhGS2Y3aWZvTWZSK2xrMWlseGZmU3dGL2QwaHdYWHE4QnJRUXllelNJMlFG?=
 =?utf-8?B?bWRpc1ZjNjFNWUV4cEJjTFBxMGMvaVprNzFDQXdnNGptei9JdU1MN0JJWFRw?=
 =?utf-8?B?cjQwRWVWQ3ArS04yWDhKdTZmKzlBQjByOUMwT2pYNFQvOWhmbEhsUEpBWG1S?=
 =?utf-8?B?RHVXWVVqUjNvSDVmdnFua0hNZ2lLWTNkMjNmNGFUK3JObU41YjFpckNxS1Fr?=
 =?utf-8?B?c1B1QzljcmVEWWtEL2pYc1U1YnpLd2JEdXBlUFE4UmF3TEN0R1JrczQ5Sk1j?=
 =?utf-8?B?Z1p4bzA2NmFpM1NpcjYvRU9tM1dZdzZvVVBnN0xKR0dST2N0dXVVOE1yTnc4?=
 =?utf-8?B?K0wwL3V3dnB2STlsK1ByWWZCaDV0cHN1bmIvd21BRFI3bUtPbEdtdUc5QUFL?=
 =?utf-8?B?cHd3aXp3Q3d5Sy9tbDJGRDhMWW9KclRaTXdjQjhsNzUwMkhqM3FVZllibGlz?=
 =?utf-8?B?dWVScm5CNjYwUXgzZUlkRWNqaER4M0Jkc3hSbWxQQS9nM0NlZjBwSzRYeURp?=
 =?utf-8?B?MnpTUCtRbFB2ekFFa2NJemlGeEwyZDNSQkdoc3lPY3BxVUh0TDZUZ0x6KzdL?=
 =?utf-8?B?ZnlucjljdWlLbDd6RU1uL2ZLWlhFaCt2ampTRk5INlZvblBTSWF3M1o2cE05?=
 =?utf-8?B?S24yVG93ODZnK3YzbkVTRFJramxlelgvaGFIY0gyM21IeDAwRXg5K0Rya3lv?=
 =?utf-8?B?RnVGeXZidWJmOFlDNEhxN1BoaHZPRWFQNkdOQ0NrRjdaMW9TK2M5U2pBQlZB?=
 =?utf-8?Q?DqvlmGxwTeflISRTUCyYhJcZV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26aeb291-8e6b-4079-f481-08db666436d6
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 08:01:20.8275
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q3YPOo9IkYrDqXwXOvgUoYXE9nfeQ2Uw31tnxmAsV4ydzcsSv3n+X5Hw7/Z8Z9vX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5247
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 05/06/2023 22:27, Edwin Peer wrote:
> On Mon, Jun 5, 2023 at 11:58 AM Jakub Kicinski <kuba@kernel.org> wrote:
>>
>> [Updating Edwin's email.]
>>
>> On Mon, 5 Jun 2023 10:28:06 +0300 Gal Pressman wrote:
>>> On 26/01/2021 19:51, Edwin Peer wrote:
>>>> On Mon, Jan 25, 2021 at 8:56 PM David Ahern <dsahern@gmail.com> wrote:
>>>>
>>>>> I'm not a fan of the skb trim idea. I think it would be better to figure
>>>>> out how to stop adding to the skb when an attr length is going to exceed
>>>>> 64kB. Not failing hard with an error (ip link sh needs to succeed), but
>>>>> truncating the specific attribute of a message with a flag so userspace
>>>>> knows it is short.
>>>>
>>>> Absent the ability to do something useful in terms of actually
>>>> avoiding the overflow [1], I'm abandoning this approach entirely. I
>>>> have a different idea that I will propose in due course.
>>>>
>>>> [1] https://marc.info/?l=linux-netdev&m=161163943811663
>>>>
>>>> Regards,
>>>> Edwin Peer
>>>
>>> Hello Edwin,
>>>
>>> I'm also interested in getting this issue resolved, have you had any
>>> progress since this series? Are you still working on it?
> 
> Hi Kuba,
> 
> Thanks for the CC, I left Broadcom quite some time ago and am no
> longer subscribed to netdev as a result (been living in firmware land
> doing work in Rust).
> 
> I have no immediate plans to pick this up, at least not in the short
> to medium term. My work in progress was on the laptop I returned and I
> cannot immediately recall what solution I had in mind here.
> 
> Regards,
> Edwin Peer

Jakub, sorry if this has been discussed already in the past, but can you
please clarify what is an accepted (or more importantly, not accepted)
solution for this issue? I'm not familiar with the history and don't
want to repeat previous mistakes.

So far I've seen discussions about increasing the recv buffer size, and
this patchset which changes the GETLINK ABI, both of which were nacked.

Having 'ip link show' broken is very unfortunate :\, how should one
approach this issue in 2023?


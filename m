Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26F09417AF6
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 20:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346429AbhIXS03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 14:26:29 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31964 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346421AbhIXS02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 14:26:28 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18OGaKOo006601;
        Fri, 24 Sep 2021 11:24:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=lESdepIYWNVmTSTKQpGSWo+2rc6gnyA1m0F5B4ovcfw=;
 b=S4Q27KYgcfBcvxeCJckItVrUBc7McYmV4AnP7Ix0OS0KQEGIA67TXMiBi24hnDXApr0D
 b75YMavPpmfZs4CUX5MNK9EuwHpNLY4cUKr7fdboLHMAMmJ4JmubAqnZxPd7n9NefJCf
 8jZetx44CAWb/kcFHNwGChR2mgQB8XLiUaE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3b93f9nw44-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 24 Sep 2021 11:24:41 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Fri, 24 Sep 2021 11:24:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BVyuVaZLHkFQ9K/cM/BnnmBqns8Y2z/DBecFnVmaaZTOhmKU1vObtmxzlIqt2MdPp92qOHsgtjQ4KB6Vle9zr1iSlxbFZ5O34asbLNtGDgtV8C1DVDshs2DAMtEgOQtF1+d59XAYjmFkvYt5PwVuEZPgwqiC8X7GsKSxRz+Y9e5fmM8Db97vAEiu8ErHWYSMsx5XtWOhw3RwzCmNnsTARdnhEmYZY8N+xx5JGMzbFsIbd73XZTecOutqkjeK6rXerTOTzR1pQJyB20sqf+0S0LE6ngLGg9uL5Cb1k9RJW0WRb4ycMRiH8LNhgV4vVMGpxgT3xLZnzs1DpkhV45joSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=lESdepIYWNVmTSTKQpGSWo+2rc6gnyA1m0F5B4ovcfw=;
 b=EEvQF9UaBywfNeoJA4Um73CwN//AtiEKVADmbYW+gHnfrLu+fYkDjUaUWOP+7Izj7D37nywYinVXNWLUShxb7v9nDp7O1PbWK7/FZiTEsMqeLPG89j0SSEJfXLFKNjrnPS7/ftH3qzw1zYzenWu2uS/BaKD0SuYQjSrOmmajpsHcZthYxGu+6QTND6jhU+u+WQIDiqu+IKzbMKPkFOPvnj/hjih05x8l5udmxAYaK949gjCM6TatKOgeLRVMRg3XeZWi4FWQmQL+PxQG88TBSbnMA+JhG0upNt0bgaPm4O04dV6OJnwJijsZrAwB86KB7BYsK6qA4optogkTbSa3JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from DM6PR15MB4039.namprd15.prod.outlook.com (2603:10b6:5:2b2::20)
 by DM6PR15MB3196.namprd15.prod.outlook.com (2603:10b6:5:172::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Fri, 24 Sep
 2021 18:24:39 +0000
Received: from DM6PR15MB4039.namprd15.prod.outlook.com
 ([fe80::94f2:70b2:4b15:cbd6]) by DM6PR15MB4039.namprd15.prod.outlook.com
 ([fe80::94f2:70b2:4b15:cbd6%9]) with mapi id 15.20.4544.018; Fri, 24 Sep 2021
 18:24:39 +0000
Message-ID: <761a02db-ff47-fc2f-b557-eff2b02ec941@fb.com>
Date:   Fri, 24 Sep 2021 14:24:37 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.1.1
Subject: Re: [RFC PATCH bpf-next 0/2] bpf: keep track of prog verification
 stats
Content-Language: en-US
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Yonghong Song <yhs@fb.com>
References: <20210920151112.3770991-1-davemarchevsky@fb.com>
 <20210923205105.zufadghli5772uma@ast-mbp>
 <35e837fb-ac22-3ea1-4624-2a890f6d0db0@fb.com>
 <CAEf4Bzb+r5Fpu1YzGX01YY6BQb1xnZiMRW3hUF+uft4BsJCPoA@mail.gmail.com>
From:   Dave Marchevsky <davemarchevsky@fb.com>
In-Reply-To: <CAEf4Bzb+r5Fpu1YzGX01YY6BQb1xnZiMRW3hUF+uft4BsJCPoA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR02CA0128.namprd02.prod.outlook.com
 (2603:10b6:208:35::33) To DM6PR15MB4039.namprd15.prod.outlook.com
 (2603:10b6:5:2b2::20)
MIME-Version: 1.0
Received: from [IPV6:2620:10d:c0a8:11c9::100f] (2620:10d:c091:480::1:a2d0) by BL0PR02CA0128.namprd02.prod.outlook.com (2603:10b6:208:35::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15 via Frontend Transport; Fri, 24 Sep 2021 18:24:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 26f36ba6-9f85-4052-4703-08d97f889201
X-MS-TrafficTypeDiagnostic: DM6PR15MB3196:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR15MB3196BD3BB01AEA6F21887387A0A49@DM6PR15MB3196.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dZNBLjDBiYODBnwYgqOMxpgAswqSyGkymyPuKOd+hqJn0TFJUufFm4s2x+MZphH+xlBkZJbBGIi8472Sz57O1yqixIOoIo0CLVl2mqEwjIGBWMIUNG0qNDGIK6zVUkG0yHH1ZNstWA1Osy10ovocdX7MGf+5H7jTQcfaYYvQlpJtdDu2Rq43+y0YLfBz4IhA0ptj10bTrOriEANDdOKRSVD6ks+aYvXjZa9qw8qVNAlfGEXVsedoCd4kwH6aPeUjllpDjf51huj2cI+v41lW19Xrm9LupeI7wbVE65NS41Te8MqODpAkz1wjDELkI6s1Uwij65lqSNSlQBn1Ub8O3Fc42LdPNtrFHw73RdhZ+ColGFX6wFEIGzuhQvo90QefgmPlNs7T7R7Br/Qx0QxeOL6zg0qNdE41xcO9rPQm0e1I2537eBqSdNxme4WUOp14CJtBITstgjKbJt3916FnKyJDdQYBKLjEgesO0UbMsctvT5YB4lf7jX/N/WDsODAEFhBXoVu29T/DSFCL9+LAlz+MTg7PeLgCfTh48+PfIqnF6+uaYfQ19NuJ0Gc6yzDEmZU5yJPS7qzAhmXsMWs0Xa1KK7yEpSJe5+cd9BJC9ysGQnoZk8yFI7bS3TF/IM8NZEFy4vNqMay5/YV/IlCHxrjpWYjTiB13HU9TzdoeeDHtQoHhWVPrRsDqREhX8j8FkjRdDeHj1BxFSF109+7d6l0Kd+fXw9vSleZSiX1oQJ0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB4039.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31686004)(31696002)(36756003)(5660300002)(8936002)(2616005)(38100700002)(186003)(8676002)(6916009)(508600001)(53546011)(86362001)(66476007)(6486002)(2906002)(15650500001)(66556008)(54906003)(316002)(83380400001)(4326008)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OEVEaHpEeEdSZWlmdWFLUWhXT3E3djR0aUZ5QjJXYVlLQkdYelJoa2RIS3VK?=
 =?utf-8?B?NXVLdFpJa0F2dXJvY0ErY2cwb3JUckw1SDJBMzlpUlhIVUdIdllJU0IzVEt0?=
 =?utf-8?B?bTg5UUtpZ3MxeFBhcHZTYTJrd2s2Um54WmczeHlnVXUwTkpMWTMzWnZITS91?=
 =?utf-8?B?NG9OSlpjU1RtaHNPMzkvRytPT1FUSjlDNXdBUE1DOThKNDZVb2U0YzAzcmdk?=
 =?utf-8?B?UkNoVllqWWVCdUVLdzQySVdOWVdPbWFlY0cySm5rcjhMM2JqK0ZpS0p5bWhZ?=
 =?utf-8?B?MVhrRDhFMEdNRG5OdEZxajJIQ05PZHFZYTNWVWFzRU1JVURmaUJqdC9uNTha?=
 =?utf-8?B?LzFoNC95SS9zK2p6aUlpUUVGSnFLUGd6YTcwM1NPNWpHanhjNlhDQit4ZDFz?=
 =?utf-8?B?UkJSS3pvZTFObHdaRk43S2VCNFZVK1MrNENnT2ErZGs5UElaQ2hWVGFGN1dV?=
 =?utf-8?B?MW5kNXhmbG5iZmxGaWdYWUxwT1RZR1BkMmpEbldLUzhJVm1VL1NJUUE3NG82?=
 =?utf-8?B?K29PeWJLMVN0blFKUVpuaEl1WW15QzZ2ZnBUckVoODA1OE1CNGhJbm5sb3JO?=
 =?utf-8?B?VHNKL2Jrc0xodFc2aW1TQ1lJUUFzU2M0bWJNSUNveGNCK1FxZUx4QjFKbm1z?=
 =?utf-8?B?ZEVYamw4M0lBWXFxd1F4YmVRUThqRzBqNXk5TExlNVdDYm5YVExZQWRqZXdY?=
 =?utf-8?B?OGxWRWk2eVJlVFI5ck9NSkpyK3FsVnl6Y0EyQy9FaTk2N0ZNR2xkSmk0RUE3?=
 =?utf-8?B?dTBmbUZYb0QybXJhV1Q5Sk12K2pMY3lNVlJtaG5qTzhkVWhvTkNtYVM3N1po?=
 =?utf-8?B?cUlTZjZXYnAwQkV3NDhmbHo3ajY2T29QTmJCNTVubHJ4OWhsUHFVc0cvSzBU?=
 =?utf-8?B?NnNINVRmemZHc0d0NEt5azdkSmxkYkpHK0NHY1pSakNOMm0zd3cwQzViUGRJ?=
 =?utf-8?B?ejcyWEtXWlgwY3o0d09mOXVna3JlNWh4cXVQMXVMTy9LeHdZdkJHSGlDMW1K?=
 =?utf-8?B?d0dNajFyUjU1ZXBPalZOdmk1ZmNSY1hBd0R1ekdzTDdvb29xQ2IzeXljbGNB?=
 =?utf-8?B?dWJZTysxYjhGNFdvaXUrM1ppbm8vdnBZRHdqWHRwNUptMENiVUJLT0xyaVhO?=
 =?utf-8?B?djhlS1pyeXlBOGpWd2xVYjYwS1lkQjloaVJ4RFpKODI2ZGh6R2RjTjVIZnRm?=
 =?utf-8?B?MGFzVHFVN2d2MERWdm9tZm1sRnRxaStHN25SSldxQ1JnRUZkQ1Y3YnZocVdL?=
 =?utf-8?B?VTlBQ0svdmR1Y3NCM3BYOWh0Z0N1WW9MUEMxa0xIOHVwemxyS0g1NEhBbnZx?=
 =?utf-8?B?ejZNTDZWT3VxeGdTZkphWGRGWEhCNEsrUllSeXhSdGtqSnBpTWhObDVrMHVU?=
 =?utf-8?B?bUc3ODBPM1hYQkF5dTRMRVdxTHJYVTB2QnllNXBZcWhieWtnTlUrTytaOUc2?=
 =?utf-8?B?a1FOYUtBazIvMTdFWjNFNk54N1J6cXFjaXFQL0Y3aTNRV0ErTVNOQ1c2dk9M?=
 =?utf-8?B?YnFSZHhMWXpIQkE0U3pxNnVKdDN3YnA3Rmpka0xPZCt3ei9rK1kxbEl1ekpt?=
 =?utf-8?B?UFNoUWNHS1RWS0h2VzhPdnRtOVlTOUJTbnMwcVkvYXNkdHVwaGtOcUZ1VGps?=
 =?utf-8?B?T3I4SWIyWVZXUkRVaCtDU0Z1aWNFT1dUb253U2w2RjdtSGcyYWhrTFZzSWF1?=
 =?utf-8?B?UzNYWVVDa25BNSs1MXBrWGNvS1hNU041MVJwTjlxWVlqTHdnM0ZVUmVQbEZp?=
 =?utf-8?B?N05BQSsyN3pQK1M4ck9BUHpqTm9MU2pJTzUvUlloR3k5a1NHUlhEK25kWDlE?=
 =?utf-8?B?WGVTOGp3dHE3YVlGNVEyQT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 26f36ba6-9f85-4052-4703-08d97f889201
X-MS-Exchange-CrossTenant-AuthSource: DM6PR15MB4039.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2021 18:24:39.3036
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6fVzl8bUL2i1R+06n8PddIGEo0jLUGOiH4fa8puAls9NuaUA+QWfaZh2QMyasguU+EbSkyZvQmQ9f0yCp9/UMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3196
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: UtnS_GNKn8lJRo7-j0R_RkAWaoMMvA9o
X-Proofpoint-ORIG-GUID: UtnS_GNKn8lJRo7-j0R_RkAWaoMMvA9o
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-24_05,2021-09-24_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 mlxlogscore=999 spamscore=0 priorityscore=1501 bulkscore=0 adultscore=0
 clxscore=1015 lowpriorityscore=0 malwarescore=0 impostorscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109240114
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/23/21 10:02 PM, Andrii Nakryiko wrote:   
> On Thu, Sep 23, 2021 at 6:27 PM Dave Marchevsky <davemarchevsky@fb.com> wrote:
>>
>> On 9/23/21 4:51 PM, Alexei Starovoitov wrote:
>>> On Mon, Sep 20, 2021 at 08:11:10AM -0700, Dave Marchevsky wrote:
>>>> The verifier currently logs some useful statistics in
>>>> print_verification_stats. Although the text log is an effective feedback
>>>> tool for an engineer iterating on a single application, it would also be
>>>> useful to enable tracking these stats in a more structured form for
>>>> fleetwide or historical analysis, which this patchset attempts to do.
>>>>
>>>> A concrete motivating usecase which came up in recent weeks:
>>>>
>>>> A team owns a complex BPF program, with various folks extending its
>>>> functionality over the years. An engineer tries to make a relatively
>>>> simple addition but encounters "BPF program is too large. Processed
>>>> 1000001 insn".
>>>>
>>>> Their changes bumped the processed insns from 700k to over the limit and
>>>> there's no obvious way to simplify. They must now consider a large
>>>> refactor in order to incorporate the new feature. What if there was some
>>>> previous change which bumped processed insns from 200k->700k which
>>>> _could_ be modified to stress verifier less? Tracking historical
>>>> verifier stats for each version of the program over the years would
>>>> reduce manual work necessary to find such a change.
>>>>
>>>>
>>>> Although parsing the text log could work for this scenario, a solution
>>>> that's resilient to log format and other verifier changes would be
>>>> preferable.
>>>>
>>>> This patchset adds a bpf_prog_verif_stats struct - containing the same
>>>> data logged by print_verification_stats - which can be retrieved as part
>>>> of bpf_prog_info. Looking for general feedback on approach and a few
>>>> specific areas before fleshing it out further:
>>>>
>>>> * None of my usecases require storing verif_stats for the lifetime of a
>>>>   loaded prog, but adding to bpf_prog_aux felt more correct than trying
>>>>   to pass verif_stats back as part of BPF_PROG_LOAD
>>>> * The verif_stats are probably not generally useful enough to warrant
>>>>   inclusion in fdinfo, but hoping to get confirmation before removing
>>>>   that change in patch 1
>>>> * processed_insn, verification_time, and total_states are immediately
>>>>   useful for me, rest were added for parity with
>>>>      print_verification_stats. Can remove.
>>>> * Perhaps a version field would be useful in verif_stats in case future
>>>>   verifier changes make some current stats meaningless
>>>> * Note: stack_depth stat was intentionally skipped to keep patch 1
>>>>   simple. Will add if approach looks good.
>>>
>>> Sorry for the delay. LPC consumes a lot of mental energy :)
>>>
>>> I see the value of exposing some of the verification stats as prog_info.
>>> Let's look at the list:
>>> struct bpf_prog_verif_stats {
>>>        __u64 verification_time;
>>>        __u32 insn_processed;
>>>        __u32 max_states_per_insn;
>>>        __u32 total_states;
>>>        __u32 peak_states;
>>>        __u32 longest_mark_read_walk;
>>> };
>>> verification_time is non deterministic. It varies with frequency
>>> and run-to-run. I don't see how alerting tools can use it.
>>
>> Makes sense to me, will get rid of it.
>>
>>> insn_processed is indeed the main verification metric.
>>> By now it's well known and understood.
>>>
>>> max_states_per_insn, total_states, etc were the metrics I've studied
>>> carefully with pruning, back tracking and pretty much every significant
>>> change I did or reiviewed in the verifier. They're useful to humans
>>> and developers, but I don't see how alerting tools will use them.
>>>
>>> So it feels to me that insn_processed alone will be enough to address the
>>> monitoring goal.
>>
>> For the concrete usecase in my original message insn_processed would be
>> enough. For the others - I thought there might be value in gathering
>> those "fleetwide" to inform verifier development, e.g.:
>>
>> "Hmm, this team's libbpf program has been regressing total_states over
>> past few {kernel, llvm} rollouts, but they haven't been modifying it.
>> Let's try to get a minimal repro, send to bpf@vger, and contribute to
>> selftests if it is indeed hitting a weird verifier edge case"
>>
>> So for those I'm not expecting them to be useful to alert on or be a
>> number that the average BPF program writer needs to care about.
>>
>> Of course this is hypothetical as I haven't tried to gather such data
>> and look for interesting patterns. But these metrics being useful to
>> you when looking at significant verifier changes is a good sign.
> 
> One reason to not add all those fields is to not end up with
> meaningless stats (in the future) in UAPI. One way to work around that
> is to make it "unstable" by providing it through raw_tracepoint as
> internal kernel struct.
> 
> Basically, the proposal would be: add new tracepoint for when BPF
> program is verified, either successfully or not. As one of the
> parameters provide stats struct which is internal to BPF verifier and
> is not exposed through UAPI.
> 
> Such tracepoint actually would be useful more generally as well, e.g.,
> to monitor which programs are verified in the fleet, what's the rate
> of success/failure (to detect verifier regression), what are the stats
> (verification time actually would be good to have there, again for
> stats and detecting regression), etc, etc.
> 
> WDYT?
> 

Seems reasonable to me - and attaching a BPF program to the tracepoint to
grab data is delightfully meta :)

I'll do a pass on alternate implementation with _just_ tracepoint, no 
prog_info or fdinfo, can add minimal or full stats to those later if
necessary.

>>
>>> It can be exposed to fd_info and printed by bpftool.
>>> If/when it changes with some future verifier algorithm we should be able
>>> to approximate it.
>>>
>>


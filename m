Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF61841696B
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 03:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243761AbhIXB26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 21:28:58 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45670 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243758AbhIXB25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 21:28:57 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18NNef24010094;
        Thu, 23 Sep 2021 18:27:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=MMX3xtnAGauakINGVfk2+ZoI51WK8LDVmtwdgdsR8LQ=;
 b=M63iPQ4iPnU2DVx7mRr9g/0dxHTSkuH5Ox3sWf7pOtPgbA/09ouPOqNbEyjKDVIpfYVg
 ggcPu1yO+ypS08CMiiMy0Yt18oQq6rHi4jw29s0ABgYd2bdfmvffcQFgGqyNDoxHGCT9
 ScdSLHMLO06sA8cs30c+KmVlFLrG/auko4Y= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3b93f9gewr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 23 Sep 2021 18:27:11 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 23 Sep 2021 18:27:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KDt9T9D/OFjGCDdH/KZAkwN6EjgE8sSD0OOntiWVI8cnObpxRQZ2RRVIWib2OAv3+jGAKsMEWqW3nbXhoix8VNR8KXiflk73a8OECOzbhiy1FU+sY70ukBPR9YxQ8aCnJjdGpDKYw+KDqLcFhyYWInwi5zDwXoQ8+ZI0woOo5uru/j3Avqvv7HRI7I28jcRLvhuLJ2PBQXUntp5NxNMYUKNv+Y/3TVPvMo00IzCZaF587TUkvnF78JtBUQOp24a8gJoZPXagXTIRfwW71n2/AN77SP/6hkkyC76C6AiuFlhjgUBLkBmSkY0yAL/WLrwjEjaWHGPhMliGYElHBGNr7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=MMX3xtnAGauakINGVfk2+ZoI51WK8LDVmtwdgdsR8LQ=;
 b=Rna3Bi1SgJlM2mTxxFL/4l/Bp7Sxh1b9/Xguj13Nz7J+cuONAmSYiJBv9skX9ODdlvkljYxN2HlNp+tbd+KOzFh0z/noAqIEw1cJegLs8AbwmsN06QFaT5rb7ERfh7+LCOsl0hMFlUnDPw0conFjNUVGMhraXPWdudyLeSdLWV/ky2l4SXr+ap3DZveDHxk1CSPlNBk3uLFrOTRXeDKF9/ibUqqH2USUuPzbz414xSmd0ihVqw4rQNadZMkYAsmMB1Hg1BFDooQjpqYp7PZAVN36SK1dNaNpVAHTNqqcZTu+6gtzPA7P6m9XmPC7Tzw/l3HVO+bA8wASyJV8TZk1rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from DM6PR15MB4039.namprd15.prod.outlook.com (2603:10b6:5:2b2::20)
 by DM6PR15MB2603.namprd15.prod.outlook.com (2603:10b6:5:1b0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.18; Fri, 24 Sep
 2021 01:27:07 +0000
Received: from DM6PR15MB4039.namprd15.prod.outlook.com
 ([fe80::94f2:70b2:4b15:cbd6]) by DM6PR15MB4039.namprd15.prod.outlook.com
 ([fe80::94f2:70b2:4b15:cbd6%9]) with mapi id 15.20.4544.015; Fri, 24 Sep 2021
 01:27:07 +0000
Message-ID: <35e837fb-ac22-3ea1-4624-2a890f6d0db0@fb.com>
Date:   Thu, 23 Sep 2021 21:27:06 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.1.1
Subject: Re: [RFC PATCH bpf-next 0/2] bpf: keep track of prog verification
 stats
Content-Language: en-US
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Yonghong Song <yhs@fb.com>
References: <20210920151112.3770991-1-davemarchevsky@fb.com>
 <20210923205105.zufadghli5772uma@ast-mbp>
From:   Dave Marchevsky <davemarchevsky@fb.com>
In-Reply-To: <20210923205105.zufadghli5772uma@ast-mbp>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR02CA0058.namprd02.prod.outlook.com
 (2603:10b6:207:3d::35) To DM6PR15MB4039.namprd15.prod.outlook.com
 (2603:10b6:5:2b2::20)
MIME-Version: 1.0
Received: from [IPV6:2620:10d:c0a8:11c9::100f] (2620:10d:c091:480::1:92ea) by BL0PR02CA0058.namprd02.prod.outlook.com (2603:10b6:207:3d::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Fri, 24 Sep 2021 01:27:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f961eebe-be1b-4f64-dbc8-08d97efa6c64
X-MS-TrafficTypeDiagnostic: DM6PR15MB2603:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR15MB2603DA2E39B67100571178FAA0A49@DM6PR15MB2603.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sA6qPs/5SqKKm+I5t4K63h8wOILospsfuOcuze3MK90aZkhOLmDuLLletr/kEBLwB6sEN7vbLqTtgcRuewjqdJAFBKiV5PZbDtZAcDO1U/PYDpzq/04xYzjUo6v3Boxn6MdF4aW8RBlTjdUivs5otl2K/k9AJbl+531XLOXaZTU50FRkaIOVIqTaYKbcWUrIamvX4m98EhPbkS4pmDHGEQBO3B8x3f5DvrmCFrQigPGEfWHNM5NyjHjhfgzpYWHPeabRrdlcUGmyjDy0s4Sxjics0uns885uURGZO3RH6GYiY6xz//H+bzoDp9qUd5fI7ZqOCYCELNVUjeGst/i7CGbRaQTPNtojv0IuuDdwrYiRUQV4LRnYyVXAZsQAJF3ISuhWL/aP1tV8ak15GMm3xY4fyLlYhICOZBStL6YPBkqZKZawcru9nsgmoj5j75uGubgfbmC3QJqBP2If9uRXj+r9P6TAjrwmKg3ZNYfk7gP0DZ+FjW9c0uSkeG0ikcyeZcpucDxijq5m93oL21eGYgLAUQUys+PLySBIUZmills55r6auBJEmAfNlNE+IVYa3hIvCedMJ+pJjQzJhDUKFqFt7ciVExma/pMFwKBE/ZIrcMXK2jDAmACuIjYNj5erpwnp3fzz2Kej489K7OOcm7cnOYPFxuveCbQmpe9hgpGL3d5Wj/alWf4JN+WhGW9sqNbEWqIg+c/jOyazpzcqmgFRWR5DgiFdxjFCCOJxQtU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB4039.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31696002)(31686004)(4326008)(36756003)(508600001)(186003)(66476007)(66556008)(2616005)(66946007)(8936002)(15650500001)(83380400001)(5660300002)(8676002)(6486002)(6916009)(38100700002)(54906003)(86362001)(2906002)(316002)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c0M2WVBXWmJGbTM3ZDhScEdNbksvK3dDa1JLQmlEWFd6cVVpQXNOOXRxdXhv?=
 =?utf-8?B?UEtZTDMwRHJpVEloWk9XalVxWlBmKzZCWGprTW4zb2tvc29tVzR3YTA4OGJm?=
 =?utf-8?B?dHdKcUUzY0thbEVCdXhMenZodnh2b2ZiRSsxWFhwYk9mMWZXbC9iZ1FFS3Z5?=
 =?utf-8?B?OEE1V3BwRG5Dd2pNVHREYVBXTEJmVit5d1JrSHpsc1FpR3dlc0wrYUY5U2ty?=
 =?utf-8?B?aXhRL2xjYStJbzhIeU14NDRDUEJ0Yi9rRmZSMlZMS0UxUEpNWDlFaDdVVjlW?=
 =?utf-8?B?dGk2V3NyZmtpV0J1K1pJNVc5c1lqRXhCU3R1eTkwRWxHVEtFVUw2VmFGUmVx?=
 =?utf-8?B?bEhBejhDd3dXbnB1akVxSzR2UnFyMWZBcTBDY2laWCtMSnZFZ2xKSzZKYVds?=
 =?utf-8?B?RmJ0aHZycmFjNW9jR2pvWTdsdnA0Y0FDa1pHZFozRVhBU29pNnJ0a3lJejY2?=
 =?utf-8?B?Vkt0YlBRcmxSMFlESzZPbGFZcFBudG5kbzRuOTV4UlZxbTVnVmJyNnRydTJ0?=
 =?utf-8?B?d0VhdXBKWDBRWTdYVTA5amxBRklFcGwxeUdjRTlFempvUUNLcEgxd2s3SmlG?=
 =?utf-8?B?YmV6NFRmSU4yOTlXZS9CaitwL1l2R1ZYSWx1WUNkOGJFY2xYNk9WTTNGU0t6?=
 =?utf-8?B?Rmw4VWhJNWRIUkV1V2NGR2VJaXNqS2NXZzREeTkzWVVzUkUxWFRESmJNYkVn?=
 =?utf-8?B?R3FiYlBRTXp0SkozV1ljZ2Y2RWFCL1hKc2RGVnhiWXkrbWdyZ2ZYR3ptWFpQ?=
 =?utf-8?B?UDdpNDJQclZwMGtPeWNRSDBLeXVGKy9PWEQxRTQxQUoxU2hqbS8wNHd4UzZo?=
 =?utf-8?B?OU8zYXdSa3B4YUg1QWZwN3V3cjNwTHNwUEpzeldiWVhQYms5Zk5DWWdkaTJ1?=
 =?utf-8?B?QWdQNHpzZnI1VmV4Vkw1UldrWWVGUU41SHViTUdLR1FML1RHaHQ1SDFNVndJ?=
 =?utf-8?B?d1RqS3NOWU02KzlqV0RtVmNDb3pScWlGOW1DSjJCcjgwVXMyRGhReWhJR0hQ?=
 =?utf-8?B?VlorbklRT00vMkNDZXVRUHk3RUw5c3dPWUloVGEvWFd1VWtXUW1abEFmT2Q3?=
 =?utf-8?B?YklZaVlOSHRHYzBna0F0aFYrZUc3QW1xekhKWXFqa29ZUVpjcGdXL2hlZkpx?=
 =?utf-8?B?SU1ZTDI1enNBTXdkQkZ1Mm0zblpXajVMQXNWTUx1SlJmSlZXTzVTLzd0ZEZx?=
 =?utf-8?B?MElWWnRRRTZ4WWlXc25UREN3elhvcFM3WFBwcU9mTGJYNXFqL21YRlB1Qkc1?=
 =?utf-8?B?TVdCSTdVQnlDSmtleUQ1UXRSNW5lTTM5eWlsTm9kdE5BenhSNlQzMDdxd0ZI?=
 =?utf-8?B?ZjMxOWlETVMxVE1PMmhYaStEVXQvUjV5ZmhoR2gySjNQSEFDeGsrWit5QkpY?=
 =?utf-8?B?ZDNQbTVKL2RiQ3M4UU5XQW9DQ3FDb0FrRk9DRy9aRUtpVEU5WENacVpkcEZl?=
 =?utf-8?B?T0VJNTZCWHJZTXZXUGlHWStUWlNLbFVRY0RqODVuUzBhMXEwYlE4NUlNQ2RQ?=
 =?utf-8?B?RHhpcmtGWG9HcXczYS9XdFpoTnVhTytSeFBmbGpHZUc2Vmltb240QzNGek9V?=
 =?utf-8?B?c2tXNXRPZy9UdmZhRWhJRFBpV0pwYVRabEsxZVdzUDFXa3oyeW1FVkcrVktH?=
 =?utf-8?B?clpXOTZjM1hYaWJxcHdnelRmYmNVTHFtL1ZyRXQ4eFdFdStZbExDaEdvWFo4?=
 =?utf-8?B?ZlhwRXcxb0F5akNOUVVvRzRYWG10UWJBY3ZDaUt4UDdyWFNvYzJmcXB0UVFp?=
 =?utf-8?B?L2toZlhPVDhsQ2U1aXFBcVpsSDlvYUt0dEZnVHg0aVcvdXVYZDlYamNPU003?=
 =?utf-8?B?YTgrNHRCb2E3ZG1kNUNqZz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f961eebe-be1b-4f64-dbc8-08d97efa6c64
X-MS-Exchange-CrossTenant-AuthSource: DM6PR15MB4039.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2021 01:27:07.6762
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WoTCtH7ZpgYRui47k2tdT5wMMmPaC/AMcOTOnmLgILl9IqD2TPx/Ei+OY6qRmqQPx9pYYl5o/SowftEBDQiGaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2603
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: dkGl-EWhON_J3fvNWr6NGcyN6Pbh2Siu
X-Proofpoint-ORIG-GUID: dkGl-EWhON_J3fvNWr6NGcyN6Pbh2Siu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-23_07,2021-09-23_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 mlxlogscore=999 spamscore=0 priorityscore=1501 bulkscore=0 adultscore=0
 clxscore=1011 lowpriorityscore=0 malwarescore=0 impostorscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109240004
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/23/21 4:51 PM, Alexei Starovoitov wrote:   
> On Mon, Sep 20, 2021 at 08:11:10AM -0700, Dave Marchevsky wrote:
>> The verifier currently logs some useful statistics in
>> print_verification_stats. Although the text log is an effective feedback
>> tool for an engineer iterating on a single application, it would also be
>> useful to enable tracking these stats in a more structured form for
>> fleetwide or historical analysis, which this patchset attempts to do.
>>
>> A concrete motivating usecase which came up in recent weeks:
>>
>> A team owns a complex BPF program, with various folks extending its
>> functionality over the years. An engineer tries to make a relatively
>> simple addition but encounters "BPF program is too large. Processed
>> 1000001 insn". 
>>
>> Their changes bumped the processed insns from 700k to over the limit and
>> there's no obvious way to simplify. They must now consider a large
>> refactor in order to incorporate the new feature. What if there was some
>> previous change which bumped processed insns from 200k->700k which
>> _could_ be modified to stress verifier less? Tracking historical
>> verifier stats for each version of the program over the years would
>> reduce manual work necessary to find such a change.
>>
>>
>> Although parsing the text log could work for this scenario, a solution
>> that's resilient to log format and other verifier changes would be
>> preferable.
>>
>> This patchset adds a bpf_prog_verif_stats struct - containing the same
>> data logged by print_verification_stats - which can be retrieved as part
>> of bpf_prog_info. Looking for general feedback on approach and a few
>> specific areas before fleshing it out further:
>>
>> * None of my usecases require storing verif_stats for the lifetime of a
>>   loaded prog, but adding to bpf_prog_aux felt more correct than trying
>>   to pass verif_stats back as part of BPF_PROG_LOAD
>> * The verif_stats are probably not generally useful enough to warrant
>>   inclusion in fdinfo, but hoping to get confirmation before removing
>>   that change in patch 1
>> * processed_insn, verification_time, and total_states are immediately
>>   useful for me, rest were added for parity with
>> 	print_verification_stats. Can remove.
>> * Perhaps a version field would be useful in verif_stats in case future
>>   verifier changes make some current stats meaningless
>> * Note: stack_depth stat was intentionally skipped to keep patch 1
>>   simple. Will add if approach looks good.
> 
> Sorry for the delay. LPC consumes a lot of mental energy :)
> 
> I see the value of exposing some of the verification stats as prog_info.
> Let's look at the list:
> struct bpf_prog_verif_stats {
>        __u64 verification_time;
>        __u32 insn_processed;
>        __u32 max_states_per_insn;
>        __u32 total_states;
>        __u32 peak_states;
>        __u32 longest_mark_read_walk;
> };
> verification_time is non deterministic. It varies with frequency
> and run-to-run. I don't see how alerting tools can use it.

Makes sense to me, will get rid of it.

> insn_processed is indeed the main verification metric.
> By now it's well known and understood.
> 
> max_states_per_insn, total_states, etc were the metrics I've studied
> carefully with pruning, back tracking and pretty much every significant
> change I did or reiviewed in the verifier. They're useful to humans
> and developers, but I don't see how alerting tools will use them.
> 
> So it feels to me that insn_processed alone will be enough to address the
> monitoring goal.

For the concrete usecase in my original message insn_processed would be 
enough. For the others - I thought there might be value in gathering
those "fleetwide" to inform verifier development, e.g.:

"Hmm, this team's libbpf program has been regressing total_states over
past few {kernel, llvm} rollouts, but they haven't been modifying it. 
Let's try to get a minimal repro, send to bpf@vger, and contribute to 
selftests if it is indeed hitting a weird verifier edge case"

So for those I'm not expecting them to be useful to alert on or be a
number that the average BPF program writer needs to care about.

Of course this is hypothetical as I haven't tried to gather such data
and look for interesting patterns. But these metrics being useful to
you when looking at significant verifier changes is a good sign. 

> It can be exposed to fd_info and printed by bpftool.
> If/when it changes with some future verifier algorithm we should be able
> to approximate it.
> 


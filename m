Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C98E232F532
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 22:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbhCEVLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 16:11:09 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:18522 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229592AbhCEVK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 16:10:58 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 125L9Zc4023558;
        Fri, 5 Mar 2021 13:10:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Tz92ErT/HxpZoz4TlAGAj1/aQOcUFmoh3zFwKg6WXwo=;
 b=Fl/frw/GwcgCol+PsnRUIKo1+sPDVfqscXEgRWlN/CinI1QBUZWtzqR+DaNr4UyABJV5
 dLa6GZX+qt2B6GAnLtua5JrzDSXqXSBMHTYETQocHcHqwxaiDEnbDjDgEkA96R7KAeKH
 9IPXUMNLedf7DbUMzX/HOkJ7FIl3R1m5iJM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 373ha4uqug-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 05 Mar 2021 13:10:42 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 5 Mar 2021 13:10:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lz5/bdUQl1iwbN9xKLDlId44CBiEt1NRB3IB9NetEoYXhDndvGR0Z/Lbuj+AaniOAo2YVmnrvrE+cB6u+QtU0EACwPTC1h/yvyaI6S/WUrfZi+iTi1awS8UbXmxr/DkC1f1xYJHggIQbOOidIWUKFjWome0EgsGwuZlxjl5lxQdNrFjTNRf3TyLonTxeh5eHUAzmuoFn6HeXwTpjBoVM1/vG6qh0MZyXp9aJUsbXJrEFablLXjVu/jH5las9frDldoPw6JQybbv9IDNKbbyaZmbuh4yBAYZgSz/qNmWNVT3WFx7AlZZTgA781xG1wdkNXacOMuCEle5JVGVO7JdwGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tz92ErT/HxpZoz4TlAGAj1/aQOcUFmoh3zFwKg6WXwo=;
 b=OhtHn18ms2I5FAxHJ/jYKVJifQA80UjmV08IXZq14GLaaCu0e7N5axZPN8P4nybVxJ2pJE5h8QeBG1xwA0KReeoWZlUKQPLd7Tncp51wYI9ITAE5srjR1MZzewfYSebh36ffCA/0W9+BGXQ0oXNSjqqtM4/tsugdagQHYjMSWBEuzHfFQsRogQDUWGEwcCH9Wq1jIW3pIGUbskO2/gqPyJYW+kvxIKjLDqyBxP1QU+VFxRtCSVao5T+Jszx5WfbBa8i0Zufl8zEqzk2IQXUGuZtEngg4D49BQ5yQhzENThzOxPgChDv+YJAidC1EAphnJSy3sqDwXcMliEYKpOQfaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA0PR15MB4046.namprd15.prod.outlook.com (2603:10b6:806:8d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Fri, 5 Mar
 2021 21:10:38 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.3890.034; Fri, 5 Mar 2021
 21:10:38 +0000
Subject: Re: [BUG] hitting bug when running spinlock test
To:     Roman Gushchin <guro@fb.com>, Jiri Olsa <jolsa@redhat.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        YiFei Zhu <zhuyifei@google.com>,
        Andrii Nakryiko <andriin@fb.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Yauheni Kaliuta <ykaliuta@redhat.com>,
        Jiri Benc <jbenc@redhat.com>, Hangbin Liu <haliu@redhat.com>,
        Stanislav Fomichev <sdf@google.com>
References: <YEEvBUiJl2pJkxTd@krava>
 <YEKWyLG20OgpBMnt@carbon.DHCP.thefacebook.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <14570a91-a793-3f56-047f-5c203cc44345@fb.com>
Date:   Fri, 5 Mar 2021 13:10:33 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
In-Reply-To: <YEKWyLG20OgpBMnt@carbon.DHCP.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:81bc]
X-ClientProxiedBy: MWHPR21CA0042.namprd21.prod.outlook.com
 (2603:10b6:300:129::28) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::1105] (2620:10d:c090:400::5:81bc) by MWHPR21CA0042.namprd21.prod.outlook.com (2603:10b6:300:129::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.7 via Frontend Transport; Fri, 5 Mar 2021 21:10:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb28ffdf-b48b-40d4-635e-08d8e01b205d
X-MS-TrafficTypeDiagnostic: SA0PR15MB4046:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR15MB404619A6C19259C0D6BBBA36D3969@SA0PR15MB4046.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fynyg36dLVLMKVA2t/B2HgppFZeX0zWBkymp6VvTKBUVUobWX4s/VfJlHRyzBR5jzbUcrzqfpUtidEM2kTCAv8vV0oAbTYUuJZ5eUu/Hm0meaEcwemhMZwVZyAlkJ33VtDllNcJJgANHHr4rx/cY1R+L2q7HH7SsYQ+EkYOvPq1K2T6Rg+s/tDRrpGDizxGp8dL2LU/U7izfjo+eKN6i1Xun/zrV89zTFcWNFETQHQmi7Vj50rJ9CHZxGPpQOCT+akSWBRAXnlvxAcBt8tEVWOxoJf9yfZV8LkIOpeT3+iDt4wkwDOPo9wCVk9B42BszTn/tbH0A/XvEe1gbzzNQIg+TzscS6CGgX3RUjlGTN9B16+bY769eF5nh5ZQ598zWWVXwTPiI7aBkf5oH+V1LIlaZf/6Wqoz77to2lIThOVHgLAdFfUuwfNI7Pw8UEno8WGQl9RahANduLuHvjO0AY/y4FkvsI66YC8VAJse5GiXfFiK6D8u5z7o7mzPvCTzetpR02RXOaKpAYjUqOb4Ix6OHRl2PamkDFizPrpNMr3zSf2NTOk+IrQLgmWjFOlUXsEJnPKG0TTrAFhtGkeaHKZ6SAOStHH63Xrmg+g9ATu0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(376002)(39860400002)(396003)(346002)(66476007)(186003)(6486002)(31686004)(2906002)(8936002)(66556008)(478600001)(110136005)(66946007)(5660300002)(52116002)(6666004)(54906003)(36756003)(16526019)(8676002)(7416002)(4326008)(83380400001)(53546011)(316002)(31696002)(86362001)(45080400002)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QTNudU9maGR5eHhndnArT2Zmbm1WU3U2Sm1kbDZIaXFhVnIxMEZMR3dkOEpi?=
 =?utf-8?B?bThqd2xDdXp2VlVwc3RZSWRON3ZMbXJtbTJxV3BGOGRJSWFNbytmbkVaK3Fv?=
 =?utf-8?B?aGpMRWpDMGR4OERJQVJDdFZ2QytlTWx3TmZwWHVjdVNVM2FsV3pMdFk1dTR5?=
 =?utf-8?B?b1gwVThub25md2lZdm5oU0hVRk52NnptNllXc0pjSFVteDFkeDh0cXoreTEw?=
 =?utf-8?B?dkJBUTU2RzJmZUZORmJJa3NIc1JxdGhGWmVSR1R2UUt1ckRPeGZKNFJyRDVO?=
 =?utf-8?B?UU9TM2toV2lTdkxleGhpRUt5Ukc5MXJPS2xkUnA4alJvN2FVdU0xRmdublh2?=
 =?utf-8?B?WXZkSmlVbGZPZExiM05nS01qd1RyVk5wcUxVekhma0xFTHc1b0ljK08ySzA0?=
 =?utf-8?B?LzI3WWprdWdDRzVsay9OSmNoZndyTmNKby9DREhQT3NwNisvTUZNeEhnaVpm?=
 =?utf-8?B?QUlnOVY4L2xxd0M3TkVrTzRwWnVPbG1nQkt3a1J0a1l1bGs0ajJHbXpOcGd4?=
 =?utf-8?B?ME1yc3hWV1Vza1dLZ0hKQ0FKbHRWU0dPbHh2cDltQmNuK3R1OEpHVy9zOW52?=
 =?utf-8?B?R0h0Z0Q4dWRnSmV0OC9acXhmWit4TUtTT1NzcDZteXNPQlF6R1pHSXF6TVU1?=
 =?utf-8?B?KzRyMWpRUzFmck1DR3hIT2lqc0hNUW5vbG9TeGFJd0ppaHVOVFEyZmkxMWRv?=
 =?utf-8?B?Z3pnaGJVWlp1OWcxdDM1NkZwT2kwS0FITnZNTk85UXdOTVVzS21BcnREQ3lh?=
 =?utf-8?B?UlRvNUhtRmdwZlpKQmtZZHBnbGlYK0daVlVrNE9JcWs5VUxTRWJ5QWswTGd4?=
 =?utf-8?B?MTd5U2EzQzJjQTMwYTVUL0pJZXhYUjFGNTdvTlUxTVcrWm40dXcyTXM2ZEV1?=
 =?utf-8?B?Y2ZrR1NTcnJCTHZYa3ovZ05yTTRNMnUyNUhTeVhMN3BaSXJsdExKYkFBSjRq?=
 =?utf-8?B?THNmUVhTTEhRK1ZuakV1Y0doRkRoUTVVd1F2T05Fdk16S254MGlEU2w4cExm?=
 =?utf-8?B?NEo4NEtSbHlPWE1ETkgxa21kUmtoOUNua0dkWUZMTm83cEFpTEpWSmdWdG0v?=
 =?utf-8?B?QU5rUU1GUEtQUmhQVkJYc2l4aFAwOXRmeGFvVTZpUkpZU0NHTGtuZzVJaGVn?=
 =?utf-8?B?eTl1VVgxcDMwWWFuN1NrQnkrSitqbUlWNVhMM0UxczR4WkxNSjJHclV1QXp0?=
 =?utf-8?B?WGFGVVF2TjRRMWRtMUUweEhvNFlsOHFjcDNWaG5lU1lKOTFpNmgrUjI5dkpF?=
 =?utf-8?B?dFE3ajgwemEvZW9YcmNmMk5Qb3dVZGxiejNYdmV6aHM2NmErN0g0UUp5Tzda?=
 =?utf-8?B?NVpyaU1XaFNRRjN3ai84djlVL1pWdDZjWkhCM0R0NzJJTjgvTDAyeFM5N1BG?=
 =?utf-8?B?c3BxWmlES0pmTFFzeEJoVVc4L1RaQWFPRUVDMFF3SmdhYnlpNXFsdkNsSU5Q?=
 =?utf-8?B?VWlwNmtOT3ZabWJzbjVUUUdWeVcxTWhJSmxBRHJNaGZlVEtuWlF2K2xCZ2kr?=
 =?utf-8?B?VXYxaHRraHc3OU1jS3B2cUpLOTB5ZXFrSXdJY2NvUHNoTTVGMzhsZ2JLTVdM?=
 =?utf-8?B?RmZGRTZZWE9XWXFsQjZGN0dqMWVrdGlOTTlaTWJZQ2JjZDllZURBQmRPc3BJ?=
 =?utf-8?B?Yi9vMVFzcHU0SzhGV3R3dG5wNFM2M3NPeHZJQmwyUGZ5RzVNQUZKOWV0bzlZ?=
 =?utf-8?B?VVBlOWozOG9oMlp6SmdXdXNwZThuU0ZabkFadVNLNThJWjB0N3pJWmVkSis3?=
 =?utf-8?B?aU9mWXRnQnJ4MkUxVVVpaEJyT0txWDNnNXZZRGFUcGdXZ2I5UXNrRk9USmda?=
 =?utf-8?B?STR2UG90d3hoY2hZdGZ3Zz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bb28ffdf-b48b-40d4-635e-08d8e01b205d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2021 21:10:38.6504
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PnnrhzTjy3Mv+jynf0Gp2uM2cpO7Ees1dDmglDWn0Py4mpX+6Av60GXGqC/hMPol
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB4046
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-05_14:2021-03-03,2021-03-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 adultscore=0 spamscore=0 mlxscore=0 mlxlogscore=557 clxscore=1015
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 phishscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2103050106
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/5/21 12:38 PM, Roman Gushchin wrote:
> On Thu, Mar 04, 2021 at 08:03:33PM +0100, Jiri Olsa wrote:
>> hi,
>> I'm getting attached BUG/crash when running in parralel selftests, like:
>>
>>    while :; do ./test_progs -t spinlock; done
>>    while :; do ./test_progs ; done
>>
>> it's the latest bpf-next/master, I can send the .config if needed,
>> but I don't think there's anything special about it, because I saw
>> the bug on other servers with different generic configs
>>
>> it looks like it's related to cgroup local storage, for some reason
>> the storage deref returns NULL
>>
>> I'm bit lost in this code, so any help would be great ;-)
> 
> Hi!
> 
> I think the patch to blame is df1a2cb7c74b ("bpf/test_run: fix unkillable BPF_PROG_TEST_RUN").

Thanks, Roman, I did some experiments and found the reason of NULL 
storage deref is because a tracing program (mostly like a kprobe) is run 
after bpf_cgroup_storage_set() is called but before bpf program calls 
bpf_get_local_storage(). Note that trace_call_bpf() macro
BPF_PROG_RUN_ARRAY_CHECK does call bpf_cgroup_storage_set().

> Prior to it, we were running the test program in the preempt_disable() && rcu_read_lock()
> section:
> 
> preempt_disable();
> rcu_read_lock();
> bpf_cgroup_storage_set(storage);
> ret = BPF_PROG_RUN(prog, ctx);
> rcu_read_unlock();
> preempt_enable();
> 
> So, a percpu variable with a cgroup local storage pointer couldn't go away.

I think even with using preempt_disable(), if the bpf program calls map 
lookup and there is a kprobe bpf on function htab_map_lookup_elem(), we
will have the issue as BPF_PROG_RUN_ARRAY_CHECK will call 
bpf_cgroup_storage_set() too. I need to write a test case to confirm 
this though.

> 
> After df1a2cb7c74b we can temporarily enable the preemption, so nothing prevents
> another program to call into bpf_cgroup_storage_set() on the same cpu.
> I guess it's exactly what happens here.

It is. I confirmed.

> 
> One option to fix it is to make bpf_cgroup_storage_set() to return the old value,
> save it on a local variable and restore after the execution of the program.

In this particular case, we are doing bpf_test_run, we explicitly 
allocate storage and call bpf_cgroup_storage_set() right before
each BPF_PROG_RUN.

> But I didn't follow closely the development of sleepable bpf programs, so I could
> easily miss something.

Yes, sleepable bpf program is another complication. I think we need a 
variable similar to bpf_prog_active, which should not nested bpf program
execution for those bpf programs having local_storage map.
Will try to craft some patch to facilitate the discussion.

> 
> Thanks!
> 
> Roman
> 
>>
>> thanks,
>> jirka
>>
>>
>> ---
>> ...
>> [  382.324440] bpf_testmod: loading out-of-tree module taints kernel.
>> [  382.330670] bpf_testmod: module verification failed: signature and/or required key missing - tainting kernel
>> [  480.391667] perf: interrupt took too long (2540 > 2500), lowering kernel.perf_event_max_sample_rate to 78000
>> [  480.401730] perf: interrupt took too long (6860 > 6751), lowering kernel.perf_event_max_sample_rate to 29000
>> [  480.416172] perf: interrupt took too long (8602 > 8575), lowering kernel.perf_event_max_sample_rate to 23000
>> [  480.433053] BUG: kernel NULL pointer dereference, address: 0000000000000000
>> [  480.440014] #PF: supervisor read access in kernel mode
>> [  480.445153] #PF: error_code(0x0000) - not-present page
>> [  480.450294] PGD 8000000133a18067 P4D 8000000133a18067 PUD 10c019067 PMD 0
>> [  480.457164] Oops: 0000 [#1] PREEMPT SMP PTI
>> [  480.461350] CPU: 6 PID: 16689 Comm: test_progs Tainted: G          IOE     5.11.0+ #11
>> [  480.469263] Hardware name: Dell Inc. PowerEdge R440/08CYF7, BIOS 1.7.0 12/14/2018
>> [  480.476742] RIP: 0010:bpf_get_local_storage+0x13/0x50
>> [  480.481797] Code: e8 92 c5 8e 00 5d 89 c0 c3 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 0f 1f 44 00 00 83 7f 18 15 74 10 65 48 8b 05 6d c6 e2 7e <48> 8b 00 48 83 c0 10 c3 55 48 89 e5 53 65 48 8b 05 60 c6 e2 7e8
>> [  480.500540] RSP: 0018:ffffc90001bd3ce0 EFLAGS: 00010293
>> [  480.505766] RAX: 0000000000000000 RBX: 982a259500000000 RCX: 0000000000000018
>> [  480.512901] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff888149ccf000
>> [  480.520034] RBP: ffffc90001bd3d20 R08: ffffc90001bd3d04 R09: ffff888105121600
>> [  480.527164] R10: d3b9342000000000 R11: 000000000000025c R12: 0000000000000734
>> [  480.534299] R13: ffff888149ccc710 R14: 0000000000000000 R15: ffffc90000379048
>> [  480.541430] FS:  00007f8f2357b640(0000) GS:ffff8897e0980000(0000) knlGS:0000000000000000
>> [  480.549515] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [  480.555262] CR2: 0000000000000000 CR3: 000000014e826006 CR4: 00000000007706e0
>> [  480.562395] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> [  480.569527] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> [  480.576660] PKRU: 55555554
>> [  480.579372] Call Trace:
>> [  480.581829]  ? bpf_prog_c48154a736e5c014_bpf_sping_lock_test+0x2ba/0x860
>> [  480.588526]  bpf_test_run+0x127/0x2b0
>> [  480.592192]  ? __build_skb_around+0xb0/0xc0
>> [  480.596378]  bpf_prog_test_run_skb+0x32f/0x6b0
>> [  480.600824]  __do_sys_bpf+0xa94/0x2240
>> [  480.604577]  ? debug_smp_processor_id+0x17/0x20
>> [  480.609107]  ? __perf_event_task_sched_in+0x32/0x340
>> [  480.614077]  __x64_sys_bpf+0x1a/0x20
>> [  480.617653]  do_syscall_64+0x38/0x50
>> [  480.621233]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>> [  480.626286] RIP: 0033:0x7f8f2467f55d
>> [  480.629865] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d eb 78 0c 00 f7 d8 64 89 018
>> [  480.648611] RSP: 002b:00007f8f2357ad58 EFLAGS: 00000206 ORIG_RAX: 0000000000000141
>> [  480.656175] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f8f2467f55d
>> [  480.663308] RDX: 0000000000000078 RSI: 00007f8f2357ad60 RDI: 000000000000000a
>> [  480.670442] RBP: 00007f8f2357ae28 R08: 0000000000000000 R09: 0000000000000008
>> [  480.677574] R10: 0000000000000000 R11: 0000000000000206 R12: 00007f8f2357ae2c
>> [  480.684707] R13: 00000000022df420 R14: 0000000000000000 R15: 00007f8f2357b640
>> [  480.691842] Modules linked in: bpf_testmod(OE) intel_rapl_msr intel_rapl_common x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm ipmi_ssif irqbypass rapl intel_cstate dell_smbios intel_uncore mei_]
>> [  480.739134] CR2: 0000000000000000
>> [  480.742452] ---[ end trace 807177cbb5e3b3da ]---
>> [  480.752174] RIP: 0010:bpf_get_local_storage+0x13/0x50
>> [  480.757230] Code: e8 92 c5 8e 00 5d 89 c0 c3 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 0f 1f 44 00 00 83 7f 18 15 74 10 65 48 8b 05 6d c6 e2 7e <48> 8b 00 48 83 c0 10 c3 55 48 89 e5 53 65 48 8b 05 60 c6 e2 7e8
>> [  480.775976] RSP: 0018:ffffc90001bd3ce0 EFLAGS: 00010293
>> [  480.781202] RAX: 0000000000000000 RBX: 982a259500000000 RCX: 0000000000000018
>> [  480.788335] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff888149ccf000
>> [  480.795466] RBP: ffffc90001bd3d20 R08: ffffc90001bd3d04 R09: ffff888105121600
>> [  480.802598] R10: d3b9342000000000 R11: 000000000000025c R12: 0000000000000734
>> [  480.809730] R13: ffff888149ccc710 R14: 0000000000000000 R15: ffffc90000379048
>> [  480.816865] FS:  00007f8f2357b640(0000) GS:ffff8897e0980000(0000) knlGS:0000000000000000
>> [  480.824951] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [  480.830695] CR2: 0000000000000000 CR3: 000000014e826006 CR4: 00000000007706e0
>> [  480.837829] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> [  480.844961] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> [  480.852093] PKRU: 55555554
>>

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 222A9332E5E
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 19:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbhCISge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 13:36:34 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50616 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230425AbhCISga (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 13:36:30 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 129IU3nJ011589;
        Tue, 9 Mar 2021 10:36:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=lz7aK4bZoiaA5IKhu6U/by40Y2Xxk2aCfbSUrsyByXs=;
 b=P35qaYBgS/wvyybneNURSv9aJ/AWV4nbZ5Fh5i4f48Aaw2A2myN2kbD1iujZTkfLnqzQ
 1gncmWoC3eNBHN1v/cOJG6fPwm7anEBkCnBl7nN9fa9z7ajohmFxRvxaqAXYA4LdwmDl
 PHrNLfnQ0lHVIKSgIflAyIQvwtYmqub3dJ0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 374tc14h0n-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 09 Mar 2021 10:36:14 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 9 Mar 2021 10:36:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l7WIV/QMO67s/NXEP01iKwAXqGg/3wX7f38Pwxlr+KgHyOPbH3Yme6ko/hnAzMBVuisaOraY0O1Y/62NUaJh7/aEJxfjK9gkFjEkv0byP6hfRDcL+BGfZyFTZDXziYk1968F5t3qD28PM02NtVffpgpWEObRushJt+NpJ02fjkzalvVJ3v/Zj5gKRbtXoTA8TvpZOUftM2rEieetMou0cG92QL+xXbXpApdu5p9Gog+MyL2/11m9iAOqw6fiPXZN7H7lWoPyEN6cMTGIV9CSfMPHxjq7Nf9c42fC++WQLFvJSrWC70BTFy3+rU/5Bj76Z6UoxIYk1LsguDRhZmnNFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lz7aK4bZoiaA5IKhu6U/by40Y2Xxk2aCfbSUrsyByXs=;
 b=WZnHm9gs5VeeKXj1qMxGQauisH3hwot2JTbLCwo09BppvxxWBV8Yp5nbOwPkzWXjh4F2xTOJaCR+akzWGhGd1prrrsS83KE5NNeVJg0GHsuSORncTSkKGrCRrhJVMh/Ko3FagrN84Q8fvQiniSj/wEmYrMGQpiDt6X6UnDY9DFdRuMyhHo9sVDVq+IsNfWPf2loU+xJxfWHsEPxA7/jBPCbFmffHCEAUaQknzJFDkJBzm8OuSl15Kaj93lBvxK3MSaXGRWjcb2CtvEZe9WkurPYt26Zh7ISES2xT1T3/hJuZDrMtBPCTSHP3SSCOjfhvyW6Q+hWLIOoB8En1E53Mgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4738.namprd15.prod.outlook.com (2603:10b6:806:19d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.21; Tue, 9 Mar
 2021 18:36:11 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.3890.039; Tue, 9 Mar 2021
 18:36:11 +0000
Subject: Re: [BUG] hitting bug when running spinlock test
To:     Roman Gushchin <guro@fb.com>
CC:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
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
 <14570a91-a793-3f56-047f-5c203cc44345@fb.com>
 <0c4e7013-b144-f40f-ebbe-3dff765baeff@fb.com>
 <YEe8mt+iJqDXD6CW@carbon.dhcp.thefacebook.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <45df5090-870a-ac49-3442-24ed67266d0e@fb.com>
Date:   Tue, 9 Mar 2021 10:36:06 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
In-Reply-To: <YEe8mt+iJqDXD6CW@carbon.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
X-Originating-IP: [2620:10d:c090:400::5:8cd6]
X-ClientProxiedBy: MW4PR03CA0056.namprd03.prod.outlook.com
 (2603:10b6:303:8e::31) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::1105] (2620:10d:c090:400::5:8cd6) by MW4PR03CA0056.namprd03.prod.outlook.com (2603:10b6:303:8e::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Tue, 9 Mar 2021 18:36:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b82fbeec-8966-43d6-c47c-08d8e32a365c
X-MS-TrafficTypeDiagnostic: SA1PR15MB4738:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB4738419E9E0389D17752ED60D3929@SA1PR15MB4738.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VjNFpd8l4pD0GCOk49+tv2Jo+Su7Dda1Sygyq/43+424xx7snq8xnVJc0z5JtcaWfnEHHI4c9ilnVDha2PC44pt/wmi5sY97I9gaelZMTdmDsxWiExEMhzhbJ3aEctQxf3HcraRWc9n9sD+O3mr60pZqUqKOjn6OOlbg2ElHah2cRvugIcWRsfdbPSYnRJijiHW2e4wzMK/gYJaQ95uqdf+JtGlvkNpmKI+YdynYBhvoxK2kZstzidwT8NV+OQ+7oPmUsO+2d9w+QE41FReA/W1sfPKyflF8zQ4Nnyty84KPpfLkOuL7TgEbJZiVHnoxiZT5ZBZQhb7No50QhMNvq1joC2H7Q+jlyZP5XjSrxYlz3rrd1fRL5htR2g2JkCKXwOTC81EevcKu0/XHtuDFVR1Xeh2ih7H5NzdhRI5b7Zky8MMHFOwWizbyyB0C6zceuKlv2OF5uf5A1BqzhVcp2IuxtY+uw9t2jj9Wq0KoSD6lG5I7FEivKAL4pH/DjFBf37NrnAnRmxU2Ym4RWqj9F7xSObNr20ANb0kcY3c3JWl9thFDMOBArJ8r1NyxUDIUJ1NKHE2FKg/l0M3j67pccj3fgYKVaK85D0GVlt2GLV6LqV8/tXCUsgvQDdSr71awLjCTUSS8iYFpjH7LXDwcpM2cVuQfgDIEb1Cqwnu9q03N0fWY4hfvRQhqBtmW+Y2v
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(136003)(376002)(366004)(396003)(66946007)(966005)(53546011)(8936002)(37006003)(478600001)(6486002)(8676002)(16526019)(6636002)(66476007)(66556008)(86362001)(7416002)(2616005)(83380400001)(54906003)(36756003)(5660300002)(6666004)(52116002)(4326008)(31686004)(2906002)(186003)(316002)(6862004)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?d3YwNFpTRW5tZ2F2a3MxQzdYSUREWjV4NytrZlQ0b243dVdTVzkzeS9yRGRu?=
 =?utf-8?B?bWVrSVptYnhlMGhQZGpFTzRCb2FZRm5Lc0l2WTAzTFVvT2hXdUFLMlBXU2Yv?=
 =?utf-8?B?WjBPODZVYXp1b1RVNlNDTDB5dlNDV0RBWTBEanZEU052SDY4VlkyaUFOZWRp?=
 =?utf-8?B?Vm5PSFFnK0lMc3IvN0lDZmZzUzlXcUFqT3pzNkVQWVlvRU1EK3dibk9xL2Nr?=
 =?utf-8?B?VGNqM3ZNdHdKVUVZeUtWbzVOeXVkaGkvRzFYU0pJOG5kOWZBbTJCREpPWUJW?=
 =?utf-8?B?SEZYbEFWOUdzQWxsRzFjTjJaS1A4ZzZ3ZWlabFoxei9VbXlaOHJEODc0Q3o2?=
 =?utf-8?B?S0s2YUE5S0RmN3FLejJabUtJVVh5MmNLYWdZZW1XUTU4TEpPSlpzdlhqS2c4?=
 =?utf-8?B?RlFRSmVDVGtzV2x0TVo4RU1jdXB1aVNvWWFtaXJqMGwrajcraEVZbkY2VXpa?=
 =?utf-8?B?MVdnYXdFa0dnRFFyY2JsQnBXN2FIb283N2FsZnk4L0toS1MwQk5OQ01vSHdm?=
 =?utf-8?B?cDVPMld5VlY2blNleTJ4VGYxd0kzSXZlYVlaRVNIeFI5ZUxJVkozcmFVaERw?=
 =?utf-8?B?enRYcUo5b0dHeUFvVUJQREpZY1ZETWIwelJwRGczTGJML3pBWnB3eUxrVkpv?=
 =?utf-8?B?L1FjOEI1eUo5bDJ3SUdiNDJ4ajYzRXFwdWRMVExZanBJVTJhZmxRc1lxcTg2?=
 =?utf-8?B?VEJHZUZnZng4VTgyUEJBam9wTjUrUzY5cG1KRk1lWTFWanNVYjdWaVp1T3U4?=
 =?utf-8?B?elZsT29PRXgxUlg1WnhETXE4RnVPQm1TdnBXWVV0VFZXTk5CaUJ6a25qOWZx?=
 =?utf-8?B?VjRnTTk1QmxYbTRwTFBIVW5JMDhIUSs0TEFnQ0NCSEZtM0hCQXp5ZmNXRFRt?=
 =?utf-8?B?VCtVNXZuN2cwVTdQZDhNUWJnRlRhVkRONnZSZFFaY0FuZXJEOHR1Vm1yRVhz?=
 =?utf-8?B?ZmtMK1dMR21ReERQOGkwdE9RbTQ1c2FrWUlUSllrOG1oUnFVenpEblYwd2cy?=
 =?utf-8?B?S1VURkEzYWd6SG42ZnUzSncwcjRaeXFVR3lFbzMzUkVWTnlCMzFrR2twNmxl?=
 =?utf-8?B?YlhHRG82aFBDbks1V0ZIcVNQNnFtaUQ2SkJDYUV1NTFCT2tHMzNCeTFGVkVP?=
 =?utf-8?B?VXJDa21TMHJtdjQyWDlmMCtpaUpTYmQ0OFdIellKNHZnd204b00rdEkxanRz?=
 =?utf-8?B?SWxieWNnYkpkNEVrYTNHQXUwMElIWTBYMU9EUVdlT0x6b3Zhb1MrSFBNNmRT?=
 =?utf-8?B?eUsxNGtqWHEza05MaHRrNDZwcTI0aHNSTnllU1hYU0xPcWpaQTk2T1lpOFB3?=
 =?utf-8?B?YW4wNTZGb0dmVlVwZWM1aC9KZzNGdDZ2RUd6dTZDZElFOVdybTQ0YUs3TE9p?=
 =?utf-8?B?bzIyaTc0TlpBN3RDQ0dQN0FTYUhQa0dhRU9XNnpLeHoxOWt0cW5ETTAyUjFt?=
 =?utf-8?B?US9iZHdaRitNeGRHVTZjdjNKL3BLMVZodTJTdGZYbzBVdVhySWt5akoyWVZw?=
 =?utf-8?B?VHhhV1N6K29GejMxb2JURDhoaWtDd2FmM01Rc29hdDZOVnRoNXlzbzRmdHly?=
 =?utf-8?B?QWh3clJ0bEs2VVkyRml2TmwvOXUrSWJ3QlhKR3Z3R0dlZWlBRnhUOWNZR0FQ?=
 =?utf-8?B?ajlkd00xNE1WOHN3VmZZdWFtUEtMbURqR2FZVG9uZm5zb3oxS1hCYzNOU3R4?=
 =?utf-8?B?ZmNIR0Z0bTRad3d6VHRtZ3RoeHpMaUczbVZhb1BWS0lZN1VxeWZYRGFuak9u?=
 =?utf-8?B?RG4vemJEd1prR0xFeWxmenRCWkdXZm9Qd2xRMC9uajIrMUVyNTZIZlNLYytK?=
 =?utf-8?B?MG80Qk1ObnlIbFJNU2RQZz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b82fbeec-8966-43d6-c47c-08d8e32a365c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 18:36:11.7073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xIZfJsW9EgRI4yUX88cag3EcJku0M3Yn/xOhqM9TjW3v0NE+hB7405weyKRmGhXj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4738
X-OriginatorOrg: fb.com
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-09_14:2021-03-09,2021-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 adultscore=0 bulkscore=0 phishscore=0 priorityscore=1501 spamscore=0
 impostorscore=0 mlxscore=0 malwarescore=0 mlxlogscore=673 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103090088
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/9/21 10:21 AM, Roman Gushchin wrote:
> On Mon, Mar 08, 2021 at 09:44:08PM -0800, Yonghong Song wrote:
>>
>>
>> On 3/5/21 1:10 PM, Yonghong Song wrote:
>>>
>>>
>>> On 3/5/21 12:38 PM, Roman Gushchin wrote:
>>>> On Thu, Mar 04, 2021 at 08:03:33PM +0100, Jiri Olsa wrote:
>>>>> hi,
>>>>> I'm getting attached BUG/crash when running in parralel selftests, like:
>>>>>
>>>>>     while :; do ./test_progs -t spinlock; done
>>>>>     while :; do ./test_progs ; done
>>>>>
>>>>> it's the latest bpf-next/master, I can send the .config if needed,
>>>>> but I don't think there's anything special about it, because I saw
>>>>> the bug on other servers with different generic configs
>>>>>
>>>>> it looks like it's related to cgroup local storage, for some reason
>>>>> the storage deref returns NULL
>>>>>
>>>>> I'm bit lost in this code, so any help would be great ;-)
>>>>
>>>> Hi!
>>>>
>>>> I think the patch to blame is df1a2cb7c74b ("bpf/test_run: fix
>>>> unkillable BPF_PROG_TEST_RUN").
>>>
>>> Thanks, Roman, I did some experiments and found the reason of NULL
>>> storage deref is because a tracing program (mostly like a kprobe) is run
>>> after bpf_cgroup_storage_set() is called but before bpf program calls
>>> bpf_get_local_storage(). Note that trace_call_bpf() macro
>>> BPF_PROG_RUN_ARRAY_CHECK does call bpf_cgroup_storage_set().
>>>
>>>> Prior to it, we were running the test program in the
>>>> preempt_disable() && rcu_read_lock()
>>>> section:
>>>>
>>>> preempt_disable();
>>>> rcu_read_lock();
>>>> bpf_cgroup_storage_set(storage);
>>>> ret = BPF_PROG_RUN(prog, ctx);
>>>> rcu_read_unlock();
>>>> preempt_enable();
>>>>
>>>> So, a percpu variable with a cgroup local storage pointer couldn't
>>>> go away.
>>>
>>> I think even with using preempt_disable(), if the bpf program calls map
>>> lookup and there is a kprobe bpf on function htab_map_lookup_elem(), we
>>> will have the issue as BPF_PROG_RUN_ARRAY_CHECK will call
>>> bpf_cgroup_storage_set() too. I need to write a test case to confirm
>>> this though.
>>>
>>>>
>>>> After df1a2cb7c74b we can temporarily enable the preemption, so
>>>> nothing prevents
>>>> another program to call into bpf_cgroup_storage_set() on the same cpu.
>>>> I guess it's exactly what happens here.
>>>
>>> It is. I confirmed.
>>
>> Actually, the failure is not due to breaking up preempt_disable(). Even with
>> adding cond_resched(), bpf_cgroup_storage_set() still happens
>> inside the preempt region. So it is okay. What I confirmed is that
>> changing migration_{disable/enable} to preempt_{disable/enable} fixed
>> the issue.
> 
> Hm, how so? If preemption is enabled, another task/bpf program can start
> executing on the same cpu and set their cgroup storage. I guess it's harder
> to reproduce or it will result in the (bpf map) memory corruption instead
> of a panic, but I don't think it's safe.

The code has been refactored recently. The following is the code right 
before refactoring to make it easy to understand:

         rcu_read_lock();
         migrate_disable();
         time_start = ktime_get_ns();
         for (i = 0; i < repeat; i++) {
                 bpf_cgroup_storage_set(storage);

                 if (xdp)
                         *retval = bpf_prog_run_xdp(prog, ctx);
                 else
                         *retval = BPF_PROG_RUN(prog, ctx);

                 if (signal_pending(current)) {
                         ret = -EINTR;
                         break;
                 }

                 if (need_resched()) {
                         time_spent += ktime_get_ns() - time_start;
                         migrate_enable();
                         rcu_read_unlock();

                         cond_resched();

                         rcu_read_lock();
                         migrate_disable();
                         time_start = ktime_get_ns();
                 }
         }
         time_spent += ktime_get_ns() - time_start;
         migrate_enable();
         rcu_read_unlock();

bpf_cgroup_storage_set() is called inside migration_disable/enable().
Previously it is called inside preempt_disable/enable(), so it should be 
fine.

> 
>>
>> So migration_{disable/enable} is the issue since any other process (and its
>> bpf program) and preempted the current process/bpf program and run.
> 
> Oh, I didn't know about the preempt_{disable/enable}/migration_{disable/enable}
> change. It's definitely not safe from a cgroup local storage perspective.
> 
>> Currently for each program, we will set the local storage before the
>> program run and each program may access to multiple local storage
>> maps. So we might need something similar sk_local_storage.
>> Considering possibility of deep nested migration_{disable/enable},
>> the cgroup local storage has to be preserved in prog/map data
>> structure and not as a percpu variable as it will be very hard
>> to save and restore percpu virable content as migration can
>> happen anywhere. I don't have concrete design yet. Just throw some
>> idea here.
> 
> Initially I thought about saving this pointer on stack, but then we need
> some sort of gcc/assembly magic to get this pointer from the stack outside
> of the current scope. At that time we didn't have sleepable programs,
> so the percpu approach looked simpler and more reliable. Maybe it's time
> to review it.

Indeed this is the time.

> 
>>
>> BTW, I send a patch to prevent tracing programs to mess up
>> with cgroup local storage:
>>     https://lore.kernel.org/bpf/20210309052638.400562-1-yhs@fb.com/T/#u
>> we now all programs access cgroup local storage should be in
>> process context and we don't need to worry about kprobe-induced
>> percpu local storage access.
> 
> Thank you! My only issue is that the commit log looks like an optimization
> (like we're calling for set_cgroup_storage() for no good reason), where if
> I understand it correctly, it prevents some class of problems.

Yes, it prevents real problems as well. The reason I did not say it is 
because the patch does not really fix fundamental issue. But it does
prevent some issues. Let me reword the commit message.

> 
> Thanks!
> 
>>
>>>
>>>>
>>>> One option to fix it is to make bpf_cgroup_storage_set() to return
>>>> the old value,
>>>> save it on a local variable and restore after the execution of the
>>>> program.
>>>
>>> In this particular case, we are doing bpf_test_run, we explicitly
>>> allocate storage and call bpf_cgroup_storage_set() right before
>>> each BPF_PROG_RUN.
>>>
>>>> But I didn't follow closely the development of sleepable bpf
>>>> programs, so I could
>>>> easily miss something.
>>>
>>> Yes, sleepable bpf program is another complication. I think we need a
>>> variable similar to bpf_prog_active, which should not nested bpf program
>>> execution for those bpf programs having local_storage map.
>>> Will try to craft some patch to facilitate the discussion.
>>>
>> [...]

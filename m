Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5073331EC1
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 06:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbhCIFo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 00:44:59 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48746 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229495AbhCIFod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 00:44:33 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1295hu88026746;
        Mon, 8 Mar 2021 21:44:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : from : to : cc
 : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=kvvEq8MH1w+j2vJrkDaPqZXnqR48nMsBzAfsE9+B41k=;
 b=kGEizfDUK2l6qkTZhPmXDyHjjQlQd0GDiJZNlDbqefLiI2FOFa4Vxo32TIRDnuOkEd8R
 mnVtn8fEK9radpgvBMoGcGMGLezfEUMI0++RBXTnp5ix6hgtZkmg59ujaS8HlLoZY2aB
 n8xdp3ZYOJDPbarq5dd0m0hUTnGoT1Zfads= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 374tc1114d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 08 Mar 2021 21:44:17 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 8 Mar 2021 21:44:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EW3MyN54+fr+tipxEOrfcaPVAegQxklFNBW+V52MikQiNApMKKVDAgpemUXVwjN9t9/6dR1TpS4i7iswOvRtkeddW/YtD7o0XAQ66h8MC+ARm7XMzugaIpoM/Oq204n9tGAVMfl7Ym41DX3LTmS9fAe9YYgwI9Lvb9P36gsK5zsEL7Wwkf/a2QSimPmNwHLtOfBj8Dv6ga3Cc8HL7kCLipMfG2uj/syytzHPTKGWq3zKGMDx8RtCu3rLSM5LvXs8afbbUSVO7ttaC/fkxnb+bhadHygKCdXlmJlFaFT3qm9OC+/GDkhaWO5b9h2yXZF7IpLipY6jdk08Jk2Kzrb5+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kvvEq8MH1w+j2vJrkDaPqZXnqR48nMsBzAfsE9+B41k=;
 b=U+2zpuUsZ6vFw37zGU1emwW6eREnePBvnIEuBDh2320NI22yEcoJz60rt4LRcgVRPweg3CDjyYJ3dVRijHm+eN/BK3is1amqiYaI2xr7smZREZ8l8jVvRZrkcL01KgbELK9BmQO4LzSr+kNROl74x4ceNAS2IToqAgkGQPwGhGZoTQyvioVTa98L5wLbFigJwQYaOkIjUcOXwf/CN8r8N2e/F4HxIYjP3U7x3e6K6Zre9NxXN7HTGwLsvDqXJ7nzJ5BlrzE25FEpYAqekeEPdMDo2hmeYa4ND0d1pU1Xu/QfokwW+1+5ejyaFJXF0csoJ6zxMoHWRS51toDXF8wadw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4450.namprd15.prod.outlook.com (2603:10b6:806:195::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.27; Tue, 9 Mar
 2021 05:44:13 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.3890.039; Tue, 9 Mar 2021
 05:44:13 +0000
Subject: Re: [BUG] hitting bug when running spinlock test
From:   Yonghong Song <yhs@fb.com>
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
 <14570a91-a793-3f56-047f-5c203cc44345@fb.com>
Message-ID: <0c4e7013-b144-f40f-ebbe-3dff765baeff@fb.com>
Date:   Mon, 8 Mar 2021 21:44:08 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
In-Reply-To: <14570a91-a793-3f56-047f-5c203cc44345@fb.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
X-Originating-IP: [2620:10d:c090:400::5:e530]
X-ClientProxiedBy: MW4PR03CA0337.namprd03.prod.outlook.com
 (2603:10b6:303:dc::12) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::1105] (2620:10d:c090:400::5:e530) by MW4PR03CA0337.namprd03.prod.outlook.com (2603:10b6:303:dc::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Tue, 9 Mar 2021 05:44:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1c0810eb-2963-4d9b-c495-08d8e2be5e56
X-MS-TrafficTypeDiagnostic: SA1PR15MB4450:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB4450F7FBE5742D823B518073D3929@SA1PR15MB4450.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vQhrm23yZDw2kd8LydAdr9he//K2ePErSbf5mERKFcHimOWyIVvf98uWgN0CbyjVNnUYiMGxPTHOBluHw8jrG5qcthNu/BrFgvkbDgvDK1COSkiDUMQzowvB8f0NmHQdeNP0USa310xoROrvzYV9A6YaBnmNg72di1ZCcjCSU/pgwPnTXy93Fd2vMJElW/ofQgZSTVCAkrNiBqDPNNN44FY0Rm346ZUkI4kkSK2gbd+lvmhdO2A8meHRxcP2wXd1QvwG1t88CGQaq4MVc0wIgPnJjpAaW3UXWoArrpsDcPVCcG8HKlBFmdywO82X/v8Ru6U74j91PJIOMg67WzvstgICDlzRDAV6Ay3Ny60w3C6ntVJhtxQ5t7t4rlaE3PBTlwtYGGSo+Vqu8bPBN+2D7LXMEHHeOq++vRCZoMyAfYsrFviMXVxk78P9hFg4fmF6vWGcEvxYYVtWwwP/kL4jLgeuFRU6CyqmwTrOgxddeWvNk1JAQCkVAKTVUgt48wJNAlj1W0pOzXCcNAy4mITTBCEBUqYxxub1wZG/l9Sdq/o9RSJBKusdTBehDKPVcMYhEJeStwJCwaHbnSddeATM/dTDMCqG/FKGVkAl+HMJ0nE6ZjGpnOCWXmZLhA0ZuvrwHKdHe9bRVc+v8TxCNlRWAZkqy8ZDBGTH6E+0RCjZ+5vRjNoyAC1LmqynTcZqL6W6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(39860400002)(396003)(376002)(366004)(53546011)(36756003)(2906002)(31686004)(54906003)(52116002)(5660300002)(110136005)(316002)(7416002)(2616005)(6666004)(66556008)(186003)(66946007)(16526019)(6486002)(66476007)(8676002)(86362001)(31696002)(966005)(8936002)(478600001)(83380400001)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VmpVWXpLWElNY0hlenBnZmVsdGR4VUIwWHF4S0hTb1JjeXVBblBlNVRJZ3Ns?=
 =?utf-8?B?UzBpOHVBL2pDdlg4cHcwYi8zNE5hMHR0N0xURkh2UEFJdmxnUy90TzdvZENN?=
 =?utf-8?B?ME9TTXVCZlNzSWNwMTVmZDg1ZnlkMmpuTFZSeXJjV3JaTjJmNUQwamZmYWlQ?=
 =?utf-8?B?V1E5S21qVHZPQ1BvaGNEM00vK09URjNUWitkMHZhOXpKQmdWTkRVREFsRERa?=
 =?utf-8?B?SU92RE0yRXBaUzI2d2F0b1UycFYyQjNqMGRHbWhkK0lVK0hYYnhXMXZ3V0ZV?=
 =?utf-8?B?Qm9SVkJ4SkJXanBZRE9mc3NyRlpRTGhjNWxkay9sSWViTU1wR3dQeithc0lV?=
 =?utf-8?B?R3dFOTdJdUlDQ3pRVWFTTm1rc3RBcERKaUdZQ3BsRVY5ZWtzckVHOXVEWWRE?=
 =?utf-8?B?NVZWaUhZd0F5dmRCa00wYVFGT3lCTzBNZkNNRWtVaEhpcFgxd1l4UEVFKzBj?=
 =?utf-8?B?UDJackZlelZNK3pSWldYckthYUEraXBKVk5pL09ZREpnWmNzSVFhR1hLREkv?=
 =?utf-8?B?Uzd4SkNDelREWlMrQ2haYU5FRzRDdVBhaXAvUEJNZzJwbk5YYkFJcEtGZ3RE?=
 =?utf-8?B?NHB2SFNDR1pzNFF0OExSaTFHZ1B0UEIzTkVERzRnbG9NcC94OE51VVIzZnQv?=
 =?utf-8?B?QWlIN3JMdFl3Wm9idjBaOERwS3drbnhvcUtWRHc0MDU3VGtJQ1cwSXdrb1hv?=
 =?utf-8?B?MWdOWEhGWml3L1p2WS9kWnB4bnExbDBGYVhUd21KYTVUMjdmTlYzYTF2V0FC?=
 =?utf-8?B?Rkh2Yk1zYzZieENQY29najFFcjdqRzVVVm9NZWg3dFk1QzZWWGlWNHpmM0RN?=
 =?utf-8?B?MDNRMTkwRkNSRWlkUzlBOHpDYWo5SDFVZzRPbkZvbHNaZnhGcVZreTdhUU56?=
 =?utf-8?B?V09rMkJpRVRRTngybVh0NE1oZEY1WHEvWHlScEFIM1BjRnFncFpzdlR2L3Ro?=
 =?utf-8?B?R2hUYWlSbEl2MGxmK0NhekhwZG50SDM4U254WlRSRTdVY1pWZnFVWUpCQ1kx?=
 =?utf-8?B?U2o1dVNTYVlKYzVaQXc1RHplR0xCeCtxNnlKLzRPZDJNMVNXK3N5L1JCUVUz?=
 =?utf-8?B?V29rR3RKV3NRRnBJUlN1QW1UWjJTVm5PZklBeDRtTzJkZm56U2QvenJORkcv?=
 =?utf-8?B?a3FvYjRWc3I4ak8zSmh1ZXRWNitwSFFpOUhSaWFkNFVJV3NDWTZ5b282a1JT?=
 =?utf-8?B?dzMxazBtbkpDbUhzRTRPbUhpSTBVQjhPdTNUS1E1eVZlNzlxdFRwNnZocGFD?=
 =?utf-8?B?cWFEckdsZzVwcFJmdmJMME9rTkIxMmM2WmhtSExxa2toWWdkV1ArbkNoemNm?=
 =?utf-8?B?U0ZzNkxuTzhhQ3NiUEhna0J6M0kvUEJVbmJKVnV2OVFNQk5hd0ZudnhsYk43?=
 =?utf-8?B?M3MyMCtiRlZERC92bkZINFlOSU4wTEZaclM4SUlmZkFScnNpdEpjSUFaWEpa?=
 =?utf-8?B?QXhPK0hCRnZXZ3F1MWpPeVRMTWcxWVBiNGlwY0Q1dHVxUkxObHF5di8xNHRa?=
 =?utf-8?B?d3RBN3NmYzB0RVJ0SlBweVhhalRkVTBaZllJL1cvam1lbFpqb2c5TjUyRXE0?=
 =?utf-8?B?VTh6WUl0U25nYktoOEFwUS96QkJUSWJ6YlZIcFVydVlJREF3d0dpeHNGYjUv?=
 =?utf-8?B?NksyOHpyQ003WWlxMzY5ZThuTkZCbG8rS0UybDczbEk0eFQybDFjT2VKRHRP?=
 =?utf-8?B?V3dLTGJ1cHhwT0hXa2JWVHFaRzVVVVp6ZnhoUWdQR1JQQUozbmNwTHMyaXJy?=
 =?utf-8?B?WTk1b3U2dW5VM1FCQ1Z2SUw2RXRXZ25HZnpSaEV6b1J2QmlOaDFGcXl4QmhO?=
 =?utf-8?Q?EExFKUqi3ZvdmuUMkLjM2HKSKPGJ9LulTWptk=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c0810eb-2963-4d9b-c495-08d8e2be5e56
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 05:44:12.8682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GncSDL6kZ0iilJdyhh5gOMjQj2K+lPeG7MUAa2I6l6pwhhscwe7wqLJZe4//Z/+1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4450
X-OriginatorOrg: fb.com
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-09_03:2021-03-08,2021-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 adultscore=0 bulkscore=0 phishscore=0 priorityscore=1501 spamscore=0
 impostorscore=0 mlxscore=0 malwarescore=0 mlxlogscore=430 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103090028
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/5/21 1:10 PM, Yonghong Song wrote:
> 
> 
> On 3/5/21 12:38 PM, Roman Gushchin wrote:
>> On Thu, Mar 04, 2021 at 08:03:33PM +0100, Jiri Olsa wrote:
>>> hi,
>>> I'm getting attached BUG/crash when running in parralel selftests, like:
>>>
>>>    while :; do ./test_progs -t spinlock; done
>>>    while :; do ./test_progs ; done
>>>
>>> it's the latest bpf-next/master, I can send the .config if needed,
>>> but I don't think there's anything special about it, because I saw
>>> the bug on other servers with different generic configs
>>>
>>> it looks like it's related to cgroup local storage, for some reason
>>> the storage deref returns NULL
>>>
>>> I'm bit lost in this code, so any help would be great ;-)
>>
>> Hi!
>>
>> I think the patch to blame is df1a2cb7c74b ("bpf/test_run: fix 
>> unkillable BPF_PROG_TEST_RUN").
> 
> Thanks, Roman, I did some experiments and found the reason of NULL 
> storage deref is because a tracing program (mostly like a kprobe) is run 
> after bpf_cgroup_storage_set() is called but before bpf program calls 
> bpf_get_local_storage(). Note that trace_call_bpf() macro
> BPF_PROG_RUN_ARRAY_CHECK does call bpf_cgroup_storage_set().
> 
>> Prior to it, we were running the test program in the preempt_disable() 
>> && rcu_read_lock()
>> section:
>>
>> preempt_disable();
>> rcu_read_lock();
>> bpf_cgroup_storage_set(storage);
>> ret = BPF_PROG_RUN(prog, ctx);
>> rcu_read_unlock();
>> preempt_enable();
>>
>> So, a percpu variable with a cgroup local storage pointer couldn't go 
>> away.
> 
> I think even with using preempt_disable(), if the bpf program calls map 
> lookup and there is a kprobe bpf on function htab_map_lookup_elem(), we
> will have the issue as BPF_PROG_RUN_ARRAY_CHECK will call 
> bpf_cgroup_storage_set() too. I need to write a test case to confirm 
> this though.
> 
>>
>> After df1a2cb7c74b we can temporarily enable the preemption, so 
>> nothing prevents
>> another program to call into bpf_cgroup_storage_set() on the same cpu.
>> I guess it's exactly what happens here.
> 
> It is. I confirmed.

Actually, the failure is not due to breaking up preempt_disable(). Even 
with adding cond_resched(), bpf_cgroup_storage_set() still happens
inside the preempt region. So it is okay. What I confirmed is that
changing migration_{disable/enable} to preempt_{disable/enable} fixed
the issue.

So migration_{disable/enable} is the issue since any other process (and 
its bpf program) and preempted the current process/bpf program and run.
Currently for each program, we will set the local storage before the
program run and each program may access to multiple local storage
maps. So we might need something similar sk_local_storage.
Considering possibility of deep nested migration_{disable/enable},
the cgroup local storage has to be preserved in prog/map data
structure and not as a percpu variable as it will be very hard
to save and restore percpu virable content as migration can
happen anywhere. I don't have concrete design yet. Just throw some
idea here.

BTW, I send a patch to prevent tracing programs to mess up
with cgroup local storage:
    https://lore.kernel.org/bpf/20210309052638.400562-1-yhs@fb.com/T/#u
we now all programs access cgroup local storage should be in
process context and we don't need to worry about kprobe-induced
percpu local storage access.

> 
>>
>> One option to fix it is to make bpf_cgroup_storage_set() to return the 
>> old value,
>> save it on a local variable and restore after the execution of the 
>> program.
> 
> In this particular case, we are doing bpf_test_run, we explicitly 
> allocate storage and call bpf_cgroup_storage_set() right before
> each BPF_PROG_RUN.
> 
>> But I didn't follow closely the development of sleepable bpf programs, 
>> so I could
>> easily miss something.
> 
> Yes, sleepable bpf program is another complication. I think we need a 
> variable similar to bpf_prog_active, which should not nested bpf program
> execution for those bpf programs having local_storage map.
> Will try to craft some patch to facilitate the discussion.
> 
[...]

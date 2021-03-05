Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 963B732E062
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 05:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbhCEEIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 23:08:47 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:40580 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229463AbhCEEIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 23:08:46 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12544vuq010551;
        Thu, 4 Mar 2021 20:08:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=/M8MC+owjrZQMN3MSL+kGlc1LShJms5orIVUgjYKEd0=;
 b=efw3JrUcFgDv5p90TlDOXf/+ix0yNuBDLk6WDcsSUg8Td4HiMQec0qR6rkD0lI4iCjt/
 iv/AEIDmUZDn3liqg1Lxx9mtjPxYstEfCkxAgpXczpM/zF85oLSRfLGfocANeq2jCIWI
 1Pdg5eLHbhaEeGDFLxqEfmRwmbfEiEbTRQI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3734q5arsv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 04 Mar 2021 20:08:25 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 4 Mar 2021 20:08:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TgQuPSCDWXDti7SwFiGUF18lfR4nvnnm28PUt8bW1YeA0PnSHUyhKZmiuSRQP1b8JEbMYJzyvY7dr/9q3/Ma6fx5zPDeyINpUXJRSnf4VVnrr4egeW1EgH62dfUulFFbH+V1Nm2Uwf05b39denZXANlHZ4MluAb8dSQwUkr09mvT/hGExK2x+WK3aa6h7eMdWYWGM4hFjvfOdLK/VePWzqkcYE1234T12u5tf765k5eE1N9o9U/Tr44Zp6DYATOD+lldDzVRsFiBrepJmZCm78iyHFEe6GCzCe/44uk3oFSujJoPHCfV/4Y+KkbA12kvd6pgDU+ws7Re1zw5i+Oprw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/M8MC+owjrZQMN3MSL+kGlc1LShJms5orIVUgjYKEd0=;
 b=DGhysHJMQEXWtueJDuFDC9xnZC3ZY+RNDBEYsCekDz8eP1EbnPb49uI3iOAb0VPGaoc2lz6WjD2d8oeIDkBKuJjnVvBVTSwjthq5/qk+GhsqbMd20wHa5yOKpgj1/Tvfk/pjuKfLjWx57yI9JAwFvpxP+640FXGpQi3biLdbg6RtmT8psHPEjqMC3G2XSRkHZeNGda998onUX3U+4PwAbw3ETvazEehXwLFyRGgNl7lTlgYI9p2GSCr//UYSCpnKU4vXXkGlpw4zthKoKZegn9vZLgqxtK0nbGeFCfZaWLXKUFSuOl1PNCjGqxXyPkOqsU6ECHSXmUhvy6kMfaOQNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR15MB2367.namprd15.prod.outlook.com (2603:10b6:805:1a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Fri, 5 Mar
 2021 04:08:22 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.3890.034; Fri, 5 Mar 2021
 04:08:22 +0000
Subject: Re: [BUG] hitting bug when running spinlock test
To:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Roman Gushchin <guro@fb.com>, YiFei Zhu <zhuyifei@google.com>
CC:     Andrii Nakryiko <andriin@fb.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Yauheni Kaliuta <ykaliuta@redhat.com>,
        Jiri Benc <jbenc@redhat.com>, Hangbin Liu <haliu@redhat.com>
References: <YEEvBUiJl2pJkxTd@krava>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <ea84958b-52e5-0e34-fbd2-d75c7562d88d@fb.com>
Date:   Thu, 4 Mar 2021 20:08:19 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
In-Reply-To: <YEEvBUiJl2pJkxTd@krava>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:d5cc]
X-ClientProxiedBy: SJ0PR13CA0083.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::28) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::1105] (2620:10d:c090:400::5:d5cc) by SJ0PR13CA0083.namprd13.prod.outlook.com (2603:10b6:a03:2c4::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.14 via Frontend Transport; Fri, 5 Mar 2021 04:08:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f485b16b-4489-492d-3a5f-08d8df8c5129
X-MS-TrafficTypeDiagnostic: SN6PR15MB2367:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR15MB2367931EFAF35E66497858DAD3969@SN6PR15MB2367.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jQ/efWIyTGB0/kfE4Q8CGujd1LWiLCfJGJcMS048NZpWuq/Tm6gepW2d5Ct7J+YBM2DtjqoZOQLr5yFk2DUIEaQ3S6AaaLxXZIn0P7NpcWdkDK2O95MaU2+aM3Odx1czIioRRhj851w5qJW+yY4B9RPRlCm/mE8EfOlAT82bIzcU+7nXMDL9ZogpONYzm4tXETvBXgRAEC85gkDMFUr15P2tVoXy7BEC4OkKbi+4xoXSW0Dh3XR8qNhD76bxEeZ1KqET7oOW/HMkuDCQ6HNuW2+xWOUbGs6ojmAw4SMl3YQ9DgrxTVQiP1mxlFjHMXUCYoLB2D4r+fRI7UstPwWkS27KIBDxw1w7yYKMWRQC0z77hwloPqp83RHe+NmPQvv3de86FsEdf7ifvauUA+TGBhsyQouGs45nDkKu6KkV0zpJEeF2qpriWx8NyW/kb0EyVOTVWtuvFOUReN8OMN+rbyvZL4+bwY2l6r3Aq4kTPtCqhFNUMm3GR0Yj2SKN0ds2J6q3sAmXshkXjUERJWhw0MWleWmVkdEH9c4ZNYOkTDlpynvPQoGxcLo99wAhK4sYQBcoML2GT7r6x6EmT1F+2oyDRocWZmCiYbB6g3rE2vA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(366004)(346002)(376002)(136003)(2906002)(31686004)(83380400001)(7416002)(31696002)(16526019)(45080400002)(316002)(478600001)(86362001)(4326008)(110136005)(54906003)(52116002)(6486002)(66476007)(66946007)(66556008)(8936002)(36756003)(5660300002)(186003)(53546011)(2616005)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NjRlZWRtd2RhdlhNK3p3Q015cThabWsrQmJJbVMzNm5qbDdQbDc2TXBPV1N1?=
 =?utf-8?B?dGptZ3hXMS84bWVUdkw4QWJFYWxtOVZ5cm5TeTI3Ty8vSnkwdk82UkpObHNo?=
 =?utf-8?B?eWZtcEN4OHhXTmEwTXQyNWh6ZHI3TzM1azdhUHBNYmU0enpSeTUzQWFWSTUz?=
 =?utf-8?B?ZDJVTlJJRFcxd3dKQkNDUnRobGhGRXc5UnpJcEJZTWxRV1RKNHRHbm1zYVRW?=
 =?utf-8?B?Q1pNNUZMam1Ud3QyZlVrbmZvQmNwczFpczRpekMwaHdkQld6VTdiR21DaWw2?=
 =?utf-8?B?anhmeEdtTGN6TGFxbFIwTXhHWUwwVStVOEN0V3FLQUo4ZHdUNDNkUk9tdUM1?=
 =?utf-8?B?bzVDL1ZraGNaU2dZUTA0RlZuU0dXZFZTUytLbGljdVdaTFRGQ0lIdHgrV1Zw?=
 =?utf-8?B?WjNlaDhLdzF2djJjWWw5d2YzbXZpdVcxN2lsVVZyZjdMRERCdnNqcWxMZy9M?=
 =?utf-8?B?eUZRQ2RqUTIyT3pBUDl0V01hRXFZR1BSbzlVbnRjRUlKdjRYZXR4UFM2a0ZG?=
 =?utf-8?B?dld1TU8ydUx5OGJYRUNDVHdwUlhnOGVmdUJwOXd5cFRVWURNSnppMmJFRG9v?=
 =?utf-8?B?SWtIMHQ1TmxJajZ2VkhjWG5sU2hWblRKZnZMWTNKc3piWFE5ZkRONnRWWnJL?=
 =?utf-8?B?ZnlGR2d1clVIRERWS2NKc0p3bTFCdlNoTDBPQnFkNTRTeVRtcVBDTGNxeStQ?=
 =?utf-8?B?UnFONmNpVklKc1Q1U2ZZV1JDRnpNRDNVZFVSdVdiK2VHT3hFeUdlVUZVTkE4?=
 =?utf-8?B?NzY3ZGd4VWtRamFCdUlWbEYzRXkyYVRSWXY5dHpYQWZPVEU1MzkyZi82UjFJ?=
 =?utf-8?B?TjNqemdvQTFaZVhUbFpNa3gxL1VYdjUzS212cFlTQ1dSMnNlV01oWE1aNVJH?=
 =?utf-8?B?dmlFUzVmRXlwaVRXNmQ4SjhFNDNwdStoazJJOUV3bzBybDNRQzZGWnJaSkJY?=
 =?utf-8?B?Wm5abHZialdNUTVJeGl6SkNZeldBUVdFekpBSFZDcGFzL1JnSWhmT2YrRnhz?=
 =?utf-8?B?dVMrM0J1eHdGTWJ3UE9MWEplbzdjdEJiRFA1VFVBbUR5ZDZDT0NHUmhUVmh2?=
 =?utf-8?B?TEg1Z0xmQXh0b0EyMGlmdHZTUkJDNkl3Rmw5TkZDTThPZER4Z0NXeHNtQ0tu?=
 =?utf-8?B?N1lITlFOS0FSaXlaUndOcWtZaWxWaUkxNitLa2hJS1dFU0M1b1BhQ2JMbFRj?=
 =?utf-8?B?eTRSQ21MRG9IRDVZSDlpVk94U3RSOWFadTRESG0wZUVXTC9oanZkdTM3TWNa?=
 =?utf-8?B?Zm5zSWo1YUttTG9SRmRYRnFYZVJRWS8xZHcwVEI0bUlLQU9UcWNUNm1ud0pF?=
 =?utf-8?B?NnkvZXZSL0xIUFRuV2N1TUpjRVE1ZFNhUnR3WW45Y1lDOUpRZTh6czg4U2E2?=
 =?utf-8?B?SnBYRjJLSFB3QlQ4ZWk1M2RWMTBXMWtKWmVDVFgrd0VVeldEREtiQkNXekJX?=
 =?utf-8?B?VGlPTlpacnBTNEN0TS81bndkNUg5YXBJZDZTRnF5WUowekozS3NUbXJtWmNM?=
 =?utf-8?B?NDQzaVl4NkZVeVJHQVFKQTRYZjZsSDlGOXN5c3NJOEZGeVVqRit3Z2hmUmZO?=
 =?utf-8?B?K3RlU0hYOVBscnpYeVNHZVRsNXpnS2NvVUJRdndvVHNDYlJ0bjFqMm1PQklU?=
 =?utf-8?B?TkNqNUVhcC9HY0pkZEhWQk1CNTN6anpEOFJ1ampkMXFmWjcrVGhyTnZ6Nk1l?=
 =?utf-8?B?U25DdTRCeEZ0dmhzckwva3Jwd3hWWDJuQjJVVi9xR3ltOXF1Uk5KME41bDI0?=
 =?utf-8?B?ZjJqaXc2dkR5N2NpWVVpYjlGRy9aaStKa1FMY2F6ZTNDY2RVWDdmN1I3L2JY?=
 =?utf-8?B?VFN6T01IbnFhbWJZcjgzdz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f485b16b-4489-492d-3a5f-08d8df8c5129
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2021 04:08:22.4586
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y5kdQ5fQOYZpxJNd9kTspXFhaH9xLIIgm+VQZsTj1RNHBYcH17DqiA4uXepMfUb1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2367
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-05_03:2021-03-03,2021-03-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 priorityscore=1501
 impostorscore=0 clxscore=1011 mlxlogscore=870 malwarescore=0 adultscore=0
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103050018
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/4/21 11:03 AM, Jiri Olsa wrote:
> hi,
> I'm getting attached BUG/crash when running in parralel selftests, like:
> 
>    while :; do ./test_progs -t spinlock; done
>    while :; do ./test_progs ; done
> 
> it's the latest bpf-next/master, I can send the .config if needed,
> but I don't think there's anything special about it, because I saw
> the bug on other servers with different generic configs
> 
> it looks like it's related to cgroup local storage, for some reason
> the storage deref returns NULL

I checked assembly, I think you are right. percpu 
bpf_cgroup_storage[stype] seems null.

This array is set by bpf_cgroup_storage_set() which is called inside
BPF_PROG_RUN_ARRAY_FLAGS and __BPF_PROG_RUN_ARRAY_FLAGS. You could
check their parameter *array* input to see why the NULL value is set.

I tried your above two commands with latest net-next
and can reproduce the failure. I will take a further look. Thanks!

> 
> I'm bit lost in this code, so any help would be great ;-)
> 
> thanks,
> jirka
> 
> 
> ---
> ...
> [  382.324440] bpf_testmod: loading out-of-tree module taints kernel.
> [  382.330670] bpf_testmod: module verification failed: signature and/or required key missing - tainting kernel
> [  480.391667] perf: interrupt took too long (2540 > 2500), lowering kernel.perf_event_max_sample_rate to 78000
> [  480.401730] perf: interrupt took too long (6860 > 6751), lowering kernel.perf_event_max_sample_rate to 29000
> [  480.416172] perf: interrupt took too long (8602 > 8575), lowering kernel.perf_event_max_sample_rate to 23000
> [  480.433053] BUG: kernel NULL pointer dereference, address: 0000000000000000
> [  480.440014] #PF: supervisor read access in kernel mode
> [  480.445153] #PF: error_code(0x0000) - not-present page
> [  480.450294] PGD 8000000133a18067 P4D 8000000133a18067 PUD 10c019067 PMD 0
> [  480.457164] Oops: 0000 [#1] PREEMPT SMP PTI
> [  480.461350] CPU: 6 PID: 16689 Comm: test_progs Tainted: G          IOE     5.11.0+ #11
> [  480.469263] Hardware name: Dell Inc. PowerEdge R440/08CYF7, BIOS 1.7.0 12/14/2018
> [  480.476742] RIP: 0010:bpf_get_local_storage+0x13/0x50
> [  480.481797] Code: e8 92 c5 8e 00 5d 89 c0 c3 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 0f 1f 44 00 00 83 7f 18 15 74 10 65 48 8b 05 6d c6 e2 7e <48> 8b 00 48 83 c0 10 c3 55 48 89 e5 53 65 48 8b 05 60 c6 e2 7e8
> [  480.500540] RSP: 0018:ffffc90001bd3ce0 EFLAGS: 00010293
> [  480.505766] RAX: 0000000000000000 RBX: 982a259500000000 RCX: 0000000000000018
> [  480.512901] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff888149ccf000
> [  480.520034] RBP: ffffc90001bd3d20 R08: ffffc90001bd3d04 R09: ffff888105121600
> [  480.527164] R10: d3b9342000000000 R11: 000000000000025c R12: 0000000000000734
> [  480.534299] R13: ffff888149ccc710 R14: 0000000000000000 R15: ffffc90000379048
> [  480.541430] FS:  00007f8f2357b640(0000) GS:ffff8897e0980000(0000) knlGS:0000000000000000
> [  480.549515] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  480.555262] CR2: 0000000000000000 CR3: 000000014e826006 CR4: 00000000007706e0
> [  480.562395] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  480.569527] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  480.576660] PKRU: 55555554
> [  480.579372] Call Trace:
> [  480.581829]  ? bpf_prog_c48154a736e5c014_bpf_sping_lock_test+0x2ba/0x860
> [  480.588526]  bpf_test_run+0x127/0x2b0
> [  480.592192]  ? __build_skb_around+0xb0/0xc0
> [  480.596378]  bpf_prog_test_run_skb+0x32f/0x6b0
> [  480.600824]  __do_sys_bpf+0xa94/0x2240
> [  480.604577]  ? debug_smp_processor_id+0x17/0x20
> [  480.609107]  ? __perf_event_task_sched_in+0x32/0x340
> [  480.614077]  __x64_sys_bpf+0x1a/0x20
> [  480.617653]  do_syscall_64+0x38/0x50
> [  480.621233]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [  480.626286] RIP: 0033:0x7f8f2467f55d
> [  480.629865] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d eb 78 0c 00 f7 d8 64 89 018
> [  480.648611] RSP: 002b:00007f8f2357ad58 EFLAGS: 00000206 ORIG_RAX: 0000000000000141
> [  480.656175] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f8f2467f55d
> [  480.663308] RDX: 0000000000000078 RSI: 00007f8f2357ad60 RDI: 000000000000000a
> [  480.670442] RBP: 00007f8f2357ae28 R08: 0000000000000000 R09: 0000000000000008
> [  480.677574] R10: 0000000000000000 R11: 0000000000000206 R12: 00007f8f2357ae2c
> [  480.684707] R13: 00000000022df420 R14: 0000000000000000 R15: 00007f8f2357b640
> [  480.691842] Modules linked in: bpf_testmod(OE) intel_rapl_msr intel_rapl_common x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm ipmi_ssif irqbypass rapl intel_cstate dell_smbios intel_uncore mei_]
> [  480.739134] CR2: 0000000000000000
> [  480.742452] ---[ end trace 807177cbb5e3b3da ]---
> [  480.752174] RIP: 0010:bpf_get_local_storage+0x13/0x50
> [  480.757230] Code: e8 92 c5 8e 00 5d 89 c0 c3 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 0f 1f 44 00 00 83 7f 18 15 74 10 65 48 8b 05 6d c6 e2 7e <48> 8b 00 48 83 c0 10 c3 55 48 89 e5 53 65 48 8b 05 60 c6 e2 7e8
> [  480.775976] RSP: 0018:ffffc90001bd3ce0 EFLAGS: 00010293
> [  480.781202] RAX: 0000000000000000 RBX: 982a259500000000 RCX: 0000000000000018
> [  480.788335] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff888149ccf000
> [  480.795466] RBP: ffffc90001bd3d20 R08: ffffc90001bd3d04 R09: ffff888105121600
> [  480.802598] R10: d3b9342000000000 R11: 000000000000025c R12: 0000000000000734
> [  480.809730] R13: ffff888149ccc710 R14: 0000000000000000 R15: ffffc90000379048
> [  480.816865] FS:  00007f8f2357b640(0000) GS:ffff8897e0980000(0000) knlGS:0000000000000000
> [  480.824951] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  480.830695] CR2: 0000000000000000 CR3: 000000014e826006 CR4: 00000000007706e0
> [  480.837829] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  480.844961] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  480.852093] PKRU: 55555554
> 

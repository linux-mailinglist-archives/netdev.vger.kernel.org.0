Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 560C232F4A8
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 21:40:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbhCEUjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 15:39:22 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:31326 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229493AbhCEUjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 15:39:01 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 125KT6PG013769;
        Fri, 5 Mar 2021 12:38:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=cjxMjNHCBTAD9XRyeea7gVmmIEhPTxeQ6Mwzqkw9YJ0=;
 b=hnhj9a+xtRJKDq2szW1F5d2/kpCBlBnGDccaQQdThGK55VtyMUccZ6ldfh+Vd8zjwm1o
 C9JuAF4u8kWN0QuHtZZD+DrR+FZDicNjbNFkPd8DeV6Rge771Cne7gxkF8YsgixxDDLQ
 A0N/YyPkjIlSgz62j80hWpj2vajOqR6tyyA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 372nyhupg7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 05 Mar 2021 12:38:41 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 5 Mar 2021 12:38:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nl5xg/ZpjHjObed3So8ONfLTsArQ7HpRbZxDuuZvYs2ylWB0Q9L5SWOEGVd3QkOTzOJWlr0PPWmPi560uYFpxmjN4dUc7DBp3Z72VQIMJVkHpHJZESUm4iRFI1UupILMVdg2/icT6tJmEKvKJeUJOD0+I1wrJ4FbfsKDZ4856VWIY2VpB+lX5LGAInROiZ9gb6pWR7oUqx0ytWE9gUR8iBCvb2jdGu9E7BaX+mmgATvdRZVXi245VDXZmdYzuIkBNNYPa/Icw3Lc2uDUoBQaNDdzt7VqGyGqwjQ6nWYJxrNAdZ2cGJPpdTk8U3GcO8jAkZDBg5sGVGbOEa43Vt26Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cjxMjNHCBTAD9XRyeea7gVmmIEhPTxeQ6Mwzqkw9YJ0=;
 b=PDgNw24hs6vSV8xDI7zlsbQYDMK0Gu1667F3GRKNnZ/uDh943wxaGN7niNKbujOIhtSWcxsMBZ9NnNwxCTTpDjtmYXBgJa5v0jaLl+1Fb9gDM+9hcvRBYS1NOVWAQ0heOt+Y20WJE0PSallpILIZnO7JjsJekR4iTV3cwcdUxpfvHfR9JO8Tko1848UcMZPEWe4T6nC4Nf/Wa+QY8LBNt5UQkT+UN/6mqtaBO+S2qi4moJ5y/rBwDAmZcucRr5nVSFrK5rVzWqqLFp6miMRypoSoosq8jCoB9Od0HpPMLclry9f5lzYwojl21MQN40/u7bjRZpaHnr6s/fxrgjgPvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB3158.namprd15.prod.outlook.com (2603:10b6:a03:104::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.19; Fri, 5 Mar
 2021 20:38:37 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::53a:b2c3:8b03:12d1]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::53a:b2c3:8b03:12d1%7]) with mapi id 15.20.3912.022; Fri, 5 Mar 2021
 20:38:37 +0000
Date:   Fri, 5 Mar 2021 12:38:32 -0800
From:   Roman Gushchin <guro@fb.com>
To:     Jiri Olsa <jolsa@redhat.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        YiFei Zhu <zhuyifei@google.com>,
        Andrii Nakryiko <andriin@fb.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Yauheni Kaliuta <ykaliuta@redhat.com>,
        Jiri Benc <jbenc@redhat.com>, Hangbin Liu <haliu@redhat.com>,
        Stanislav Fomichev <sdf@google.com>
Subject: Re: [BUG] hitting bug when running spinlock test
Message-ID: <YEKWyLG20OgpBMnt@carbon.DHCP.thefacebook.com>
References: <YEEvBUiJl2pJkxTd@krava>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <YEEvBUiJl2pJkxTd@krava>
X-Originating-IP: [2620:10d:c090:400::5:6f6c]
X-ClientProxiedBy: CO2PR04CA0137.namprd04.prod.outlook.com (2603:10b6:104::15)
 To BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.DHCP.thefacebook.com (2620:10d:c090:400::5:6f6c) by CO2PR04CA0137.namprd04.prod.outlook.com (2603:10b6:104::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Fri, 5 Mar 2021 20:38:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 19b793ba-08e3-4f59-04ea-08d8e016a714
X-MS-TrafficTypeDiagnostic: BYAPR15MB3158:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB315880CFB879048BCF56E4AFBE969@BYAPR15MB3158.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pS7T3CK1YvvfxeS57gIfggN7v+fNuSuGxVV7grQ1Qzt3J+Mv/RjU8sWn6IV2/plplLM7OU9NoJrMdJjmhq5M6c2uk1VcKw7hdWITcjkSIL2G3L0HVn7eEcx3lk6KG7DSHb2HTSOA4IuHwLx9JuNiGrB3qDMAiLQzhnLciMCZXxba3qKnDZGSZyDTQGhhsFt+JAx+9vx4G+z19RdJ/eS1UKiuGahLuVC8hTXPBfJ9Z0yQg+nVYWRCFWhq9K7dEyXTTYltjTHrEmEnrKeJ8NI7Nm68bzxl5wzRiNcSqt64LZ3aNj/bYM8lXgDxKhzgmhiDcr0eAbPhjmINJwJFUXyE83ixMX+Vi+ORBChSwv2oKZcyTP+AGF35njAl4GToOlff8i3KWQVWJcuPR7cBDi9jkOoj+vYl5Q3PY+aGtA4J6VEzpRMUJobOJM6nW1aIQqGGyW5QruO3tkIROBQoTjl5k3ORXhYF43GxB3MIo3cxyb8cYBwrJvAr8ReC+0YpEM6X5whfBWczS12Pf09aWfKsWg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(376002)(396003)(366004)(9686003)(83380400001)(55016002)(6506007)(52116002)(186003)(7696005)(2906002)(16526019)(7416002)(6916009)(66556008)(6666004)(66476007)(66946007)(478600001)(316002)(8676002)(5660300002)(86362001)(45080400002)(8936002)(54906003)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?9q+bYuEBKbzJGVdrM2i/sYLj5Oco/x0GStm8repsCoDRmHztTtXetJt52tgO?=
 =?us-ascii?Q?za8xxhnhAiOqK+5AAXrbietBhD2bDNyntlmsHe9yBluwRL25wKOUqGQWp8TW?=
 =?us-ascii?Q?Br9No/BqDqlEx9PFYYOe3TUDkMwLE8bpHiFqBLm1efeaiuf/a39QsQFD8bwc?=
 =?us-ascii?Q?i4ccsZT9D6Ozff7o9eK4R62JtsDzPoZF+CroARSmRfDzy3vjPkI4tB009BGS?=
 =?us-ascii?Q?erkV3e/DNdcIRkHqDRd5w33/J+wIaFd89vzZkzmbA/IhJ/1LtX1W93zyI6Fk?=
 =?us-ascii?Q?yFZRoo82LmgzE37460TQK4fRFk+lXGcOu/HE8AggqpwzZ/2H/GwqO594rVk8?=
 =?us-ascii?Q?Qccwz1oaJ1IvME5S54e1pIRisR5c8/tPmBwP9JU8Z/PjmP1kUjWXf4v2g85m?=
 =?us-ascii?Q?tYJENLasg1a+QE28cCa7yWT8jg74z94lyH521S/64Ng1EsOQAX96aHxRRgIa?=
 =?us-ascii?Q?os+EY7WqYchAu0uCd1jJvgkh1VeiNeOiizecAGXkWT9MrS0B0NBt+2d6Xrt8?=
 =?us-ascii?Q?4mZSFvtOS6Qk6RGOX8RGlvIWKDi4Ym3ofm7eNJyL0YmF86zCrs+Lf45WMwlR?=
 =?us-ascii?Q?+IQKHsJPxfz5aJKrYpKavkQvA2Vx95CG1GVuboA6vVjFth54mrq80IcI+cJZ?=
 =?us-ascii?Q?3IH6WenYlUHxx75MwiZXvNVJMjMeMExYyQs8K3RW9NAy+ZFfd5nwwVgy6B89?=
 =?us-ascii?Q?jUOkwmGkG/J8LkNDhUZOxitU9ooIC8kFnWUJYlhiAYZUIKtWbBLIsPB2kxJE?=
 =?us-ascii?Q?CFQLcFVpRBrgSaYSuzBtMhP+Nm+1YoqFHAEntSTg+jf/hYziUuaxDOEMFfUu?=
 =?us-ascii?Q?CPG7+nydt8F4GtmMMPphpr0gId9NUN68WfGze0aSS6y1u52gwzqo6SLuFPuV?=
 =?us-ascii?Q?sAfMqMOHlMHLN6XZph3yi2noaVLQv1cB3b4GDXB0eiMG4KysRoy/PO8x8lpH?=
 =?us-ascii?Q?o40wwoiHc6JiezQFyZsP5Ctj1SaFbSL/rtG6+aCGWSQj2P1dWkwk1FxEbG5B?=
 =?us-ascii?Q?/GfemZc/CMGrn35gIcb2pRDj5XVxzjMU4vqmZrIsG7YVKzXD9So5XuM0q8YD?=
 =?us-ascii?Q?ugdp1ODjUnK/UJEn0XPL84sAt4i5eZr4JZII4CrCNLGo/LVRld/E9PrXiPoU?=
 =?us-ascii?Q?6XE/7VA63NZR8vMsdBGbUDC6MLkTkK/ikHaOvgThyW6VLeygIAZLSapHkxFg?=
 =?us-ascii?Q?ztuJc3+nUIzgzHJpJ4GC9kjmzYJ7OFOcoDOUqNHUJXePQnpg7qRRDgIQ46Vk?=
 =?us-ascii?Q?EshNiNPy+RA3za35DPBJrAC23DY1p/lcQR6wZY2QCUPcU8G8xBRuN361Qfg2?=
 =?us-ascii?Q?AOBbUHEQJq2jOnFUnm0JgzGDrts4jR407gxZRqiD1WpTwg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 19b793ba-08e3-4f59-04ea-08d8e016a714
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2021 20:38:37.1923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VvaUyvj37WpVSOgnNB4ildCLDYEBwcEMISuArjrwyokaCNAmO+pTpST/Wy71BmbJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3158
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-05_14:2021-03-03,2021-03-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 mlxlogscore=516 malwarescore=0 clxscore=1011 lowpriorityscore=0
 suspectscore=0 bulkscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 phishscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2103050103
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 04, 2021 at 08:03:33PM +0100, Jiri Olsa wrote:
> hi,
> I'm getting attached BUG/crash when running in parralel selftests, like:
> 
>   while :; do ./test_progs -t spinlock; done
>   while :; do ./test_progs ; done
> 
> it's the latest bpf-next/master, I can send the .config if needed,
> but I don't think there's anything special about it, because I saw
> the bug on other servers with different generic configs
> 
> it looks like it's related to cgroup local storage, for some reason
> the storage deref returns NULL
> 
> I'm bit lost in this code, so any help would be great ;-)

Hi!

I think the patch to blame is df1a2cb7c74b ("bpf/test_run: fix unkillable BPF_PROG_TEST_RUN").
Prior to it, we were running the test program in the preempt_disable() && rcu_read_lock()
section:

preempt_disable();
rcu_read_lock();
bpf_cgroup_storage_set(storage);
ret = BPF_PROG_RUN(prog, ctx);
rcu_read_unlock();
preempt_enable();

So, a percpu variable with a cgroup local storage pointer couldn't go away.

After df1a2cb7c74b we can temporarily enable the preemption, so nothing prevents
another program to call into bpf_cgroup_storage_set() on the same cpu.
I guess it's exactly what happens here.

One option to fix it is to make bpf_cgroup_storage_set() to return the old value,
save it on a local variable and restore after the execution of the program.
But I didn't follow closely the development of sleepable bpf programs, so I could
easily miss something.

Thanks!

Roman

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

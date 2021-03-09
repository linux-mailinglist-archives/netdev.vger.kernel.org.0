Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5F3332E24
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 19:22:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbhCISVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 13:21:51 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:30070 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229553AbhCISVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 13:21:43 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 129I9nGA011323;
        Tue, 9 Mar 2021 10:21:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 content-transfer-encoding : mime-version; s=facebook;
 bh=pLKf0o7kofvhR3qL2GZzszmxk4vNJLmnXFZmY5nPicM=;
 b=PX8UwvjlR9Ok8kc+ZVW+fPD8YDNYPCa+3tc9rzYQucc6t3GlViUVPXUK5AjUsYmH410g
 /2giHm0ZeHPYWQepkd9AmQnVjc7bmtBsEWT9WNgs4PoBv3CCle+DhUhb7itGW/eEzJdw
 v/82maNO5pvwE1uaw5jxkt6XE8nHTpIPOqY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 376av89d33-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 09 Mar 2021 10:21:23 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 9 Mar 2021 10:21:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gAWQAyyWSENRALavClTRNVIEFsnU8nGU5TX3PjS8EnOPwOQSoPPR6wkf6aa7IOs6Ltq0KYni1Avj0GriF0T+ZlLdvz/MvrVJBMyNeuhfzAqSahQwpKsgX/lLI1CyaJdQJ1OHUlkdOqmJe5/krrh0ng/4UE9cklh2IGsa8D3uem7I+V4ChMD56Oo34yyvpiZrJ6ztFBVHIzxGLFhLwWlxiNxvFm36ANl7oKhToZ6zuRbkb7bqPRn+Ueybuljf4pDEDpzOvPFf4K6oC5/1yn+YddrDcrfBzOx+hTZ1BjjTp3HtEpLJzktImpdvTk741UOxzzvO95JxhWNlIEuAC0Q1tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i5devpixuiTQplX+EHUNjBoMKS5xUAsW2pntl39HuWc=;
 b=VyUjlqNwt9mx7kTP2GN7ayx5QWtqpGR5wcif25zxoA6GO+UbEkKPPTlUCooScWX4MbORqe+iql8tR42QfSZPawtQLJCLqke8c1DohmG5LQJRcx79ZgY5NZ73eZYaXcbN7A7STbkjBDkBm3IHCFZpbBBC0tn/v4Xhz06ajQv0jgnHln1kPkNnl9THjD1iZ5N1qyo6eK7ofg3z0kv0XdVuiFRfa3wvQuP2UdVZugU1UmKWWue9OBAIuWABWgLRzmDWspFNIhlewT5Ob8pjk/eTajKZ8iuLMmf7ghoNP8BxsetMxb82y8qFyyrNBXeq06wDgXKOFa9Bazg8CiCW2hl/Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB2440.namprd15.prod.outlook.com (2603:10b6:a02:91::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.33; Tue, 9 Mar
 2021 18:21:19 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::53a:b2c3:8b03:12d1]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::53a:b2c3:8b03:12d1%7]) with mapi id 15.20.3912.027; Tue, 9 Mar 2021
 18:21:19 +0000
Date:   Tue, 9 Mar 2021 10:21:14 -0800
From:   Roman Gushchin <guro@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        YiFei Zhu <zhuyifei@google.com>,
        Andrii Nakryiko <andriin@fb.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Yauheni Kaliuta <ykaliuta@redhat.com>,
        Jiri Benc <jbenc@redhat.com>, Hangbin Liu <haliu@redhat.com>,
        Stanislav Fomichev <sdf@google.com>
Subject: Re: [BUG] hitting bug when running spinlock test
Message-ID: <YEe8mt+iJqDXD6CW@carbon.dhcp.thefacebook.com>
References: <YEEvBUiJl2pJkxTd@krava>
 <YEKWyLG20OgpBMnt@carbon.DHCP.thefacebook.com>
 <14570a91-a793-3f56-047f-5c203cc44345@fb.com>
 <0c4e7013-b144-f40f-ebbe-3dff765baeff@fb.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <0c4e7013-b144-f40f-ebbe-3dff765baeff@fb.com>
X-Originating-IP: [2620:10d:c090:400::5:a938]
X-ClientProxiedBy: MWHPR21CA0031.namprd21.prod.outlook.com
 (2603:10b6:300:129::17) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.dhcp.thefacebook.com (2620:10d:c090:400::5:a938) by MWHPR21CA0031.namprd21.prod.outlook.com (2603:10b6:300:129::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.3 via Frontend Transport; Tue, 9 Mar 2021 18:21:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7087b87f-a316-49cb-d952-08d8e32822ae
X-MS-TrafficTypeDiagnostic: BYAPR15MB2440:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2440E6F5E8966B37C75D7F7CBE929@BYAPR15MB2440.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NNuTgB37tmM5xphNbhdb55JARpbtZieqi6leY+KCCkqicVaZoYM3p77nsnvHvARB9TnsOyvkXkdBBCh69gETnNc/O2hX9KqwkqtDt8m60BRluc4743qOjM8qKUR2zjCqt2lZFB6BkdDKBfZiN9/gfaRcCCr8MwWotlkwj27O50eyiVOlxDwIOOPDjhibiQrrA9dDYWOWiJPciWfMfi+ZRLBYs7WNBlDP6i2CC5BSyNv1qJ2/1uQ7uXg9zLTGDTNXnXYS3Gpmro1DJtfO/kyhWnAgEJQgfrojHaiwRMB4cC0rduShQVTHE9lzdPze1QrxB/rvRAJ0iEYPPdYQWeZVwf6s7y/ZqauBZyl4BOrvyWpoMJL3e1vGOCjZ4nXDFpH+KXO1+3PkkZwiFin5qUsLo6nVzQoBKtjd3SDe++IGB2PK++teaf7rzvXRqDXfwi32lV3vpg73sFWr+mWkGPOo/v2kiUJTA8y0/lfuGoDlxfpVhhCffrYLN2JMIsBt6EpaGXQy3VTwjgC+iD0dTLPkioc5liFraphhAR1OUvnMLCQ4jcttQcixCmm26SKnjbImRISyHsImLz/oFdWvUhzTf6et/exKtl81HFx+OC15l5hX2FqPghjwlC5YEPj3NJlk1gq8n2YNKnr//7RswyoGXA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(346002)(376002)(136003)(366004)(316002)(9686003)(6636002)(186003)(5660300002)(4326008)(7416002)(966005)(478600001)(8936002)(66946007)(8676002)(86362001)(83380400001)(66476007)(16526019)(2906002)(52116002)(66556008)(54906003)(55016002)(6666004)(7696005)(53546011)(6506007)(6862004)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?iso-8859-1?Q?v0BE3LgV8USEVeUjL/bJf9a4gKyt88HE3v8oVejMTbowSDhfjRCcUmjWIF?=
 =?iso-8859-1?Q?HkMmhPxZhZIoRtQrVJH4NlPF1aAgSZBn8vAbL72QEVb4wKSINB8jar3P5J?=
 =?iso-8859-1?Q?pDEULpVgat/r2msG5q8fz/45NflVwq0k3fix0G4KH2ZHLr+k7SVZw9dI/v?=
 =?iso-8859-1?Q?0JppZ4U51JG3o0hCXwCIQ/6YPptNgVb03mzRzR0RYE91UIwld/SCjDcRi6?=
 =?iso-8859-1?Q?CQLiAQ1Kh3b1jCfYstz4OWhlwn29uZ+q/e7/ETPoJPVV6SQOSyarzm00w9?=
 =?iso-8859-1?Q?4yQBd7qj2Ia6DcotM9wqbK7E6pFAytXlOBm4bUuyV53lmx5zQvEHlgGssB?=
 =?iso-8859-1?Q?kJFKgj+SGOaoVB1SHXWJDAuJo/hYwcQTjyuDRFJlx4BwJsVR96Lz8wdl40?=
 =?iso-8859-1?Q?8vmqGm8vUSCBNVsEuBRj5UI8MXf+UcObnb2Wsg1x+tBNXCMZQYrW7IJmip?=
 =?iso-8859-1?Q?b934/fK2CjULskE98x8nOnuWvG9cI7gzzX2oGJ/hEgie7qE6+t/CJgT1m0?=
 =?iso-8859-1?Q?1lTQLupg7BSMU14mhi0dvaoG5ajnvMMoXAr3sZOeXwDObci+oQZegP3DNo?=
 =?iso-8859-1?Q?1YQlH5zBcfdXe+AcNe6JGFYc+aXKngEOzHIgDXEqL4Qto6kTBLhsIDsLd1?=
 =?iso-8859-1?Q?RRoTQSzu15WAFxK+h6ZoqY6lb9sIbGYp5z5z698pc/VgnrWo2Mk7teIEqi?=
 =?iso-8859-1?Q?mK8iZwGMhSI/J6qktU2GQ6fKlwupVM5fM73YRfAwoTY/xsSWd2g4nV35ol?=
 =?iso-8859-1?Q?geDDd0Vu81Hg2LwbDtFxp/AyRMRnCuUE0vrWC5MUmzvs3FkphixqUFBgCA?=
 =?iso-8859-1?Q?z2yXAdKpL4osZNRc6pYXbv48m9xCorTfqf9Le/n9JxFDq8S2EDsj//L7oB?=
 =?iso-8859-1?Q?7oscdg7mqHKfypHPkouecYiuVcblkG9V79ZEUwjEBX5bX3tm0oJFVQ+xLz?=
 =?iso-8859-1?Q?jlfnC48Ji4ZK1iUjuFB4RhwN8DD/dp1qkBvA4hUWjTdwZ3SZcIjoy/uurf?=
 =?iso-8859-1?Q?NNhLAuC7ddJ/qZCGmg5AGn6g+0rZ8Bp7a/Uz5PgKU3vlcUX9tOhHAC7Qlr?=
 =?iso-8859-1?Q?XG/QUvhzzrqhCO8MzTZjbH1o3qier8932fc+mnzTn3G6iCQl7nOWMw75Cd?=
 =?iso-8859-1?Q?QJ4BvpzNYupSp7PrDRxtJpEoJetDstF2StYT60yZaJsuJV1nLp7xjoMRHK?=
 =?iso-8859-1?Q?2ReuwIp5QQqAWMnZUIRnWBtPytfmeTQ65p68yfGw7FdjK2J6w7x5PXQ5jv?=
 =?iso-8859-1?Q?C5qHUR+0JwIDAjG33PJBXcKJMFCrwAHxHCkqUkYuDIbZBVS8cwu5erhzLI?=
 =?iso-8859-1?Q?xkP7Ss01Z6p2VQKrP0B0DxAmR/q+rK9CaZX3vo/CbPDsswHILxn/lE1Cwn?=
 =?iso-8859-1?Q?59o5ZrkWc0l4gd5JT6gHx9ZeB4lczx2A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7087b87f-a316-49cb-d952-08d8e32822ae
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 18:21:19.6004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lo6ZV5hssuktw1phyoygtpy/nDJcpIfcGGnp4Q1BiBNsQa96mw9Ofqmtj1lg2mV1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2440
X-OriginatorOrg: fb.com
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-09_14:2021-03-09,2021-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 clxscore=1015 mlxlogscore=893 suspectscore=0
 phishscore=0 malwarescore=0 spamscore=0 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103090087
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 08, 2021 at 09:44:08PM -0800, Yonghong Song wrote:
> 
> 
> On 3/5/21 1:10 PM, Yonghong Song wrote:
> > 
> > 
> > On 3/5/21 12:38 PM, Roman Gushchin wrote:
> > > On Thu, Mar 04, 2021 at 08:03:33PM +0100, Jiri Olsa wrote:
> > > > hi,
> > > > I'm getting attached BUG/crash when running in parralel selftests, like:
> > > > 
> > > >    while :; do ./test_progs -t spinlock; done
> > > >    while :; do ./test_progs ; done
> > > > 
> > > > it's the latest bpf-next/master, I can send the .config if needed,
> > > > but I don't think there's anything special about it, because I saw
> > > > the bug on other servers with different generic configs
> > > > 
> > > > it looks like it's related to cgroup local storage, for some reason
> > > > the storage deref returns NULL
> > > > 
> > > > I'm bit lost in this code, so any help would be great ;-)
> > > 
> > > Hi!
> > > 
> > > I think the patch to blame is df1a2cb7c74b ("bpf/test_run: fix
> > > unkillable BPF_PROG_TEST_RUN").
> > 
> > Thanks, Roman, I did some experiments and found the reason of NULL
> > storage deref is because a tracing program (mostly like a kprobe) is run
> > after bpf_cgroup_storage_set() is called but before bpf program calls
> > bpf_get_local_storage(). Note that trace_call_bpf() macro
> > BPF_PROG_RUN_ARRAY_CHECK does call bpf_cgroup_storage_set().
> > 
> > > Prior to it, we were running the test program in the
> > > preempt_disable() && rcu_read_lock()
> > > section:
> > > 
> > > preempt_disable();
> > > rcu_read_lock();
> > > bpf_cgroup_storage_set(storage);
> > > ret = BPF_PROG_RUN(prog, ctx);
> > > rcu_read_unlock();
> > > preempt_enable();
> > > 
> > > So, a percpu variable with a cgroup local storage pointer couldn't
> > > go away.
> > 
> > I think even with using preempt_disable(), if the bpf program calls map
> > lookup and there is a kprobe bpf on function htab_map_lookup_elem(), we
> > will have the issue as BPF_PROG_RUN_ARRAY_CHECK will call
> > bpf_cgroup_storage_set() too. I need to write a test case to confirm
> > this though.
> > 
> > > 
> > > After df1a2cb7c74b we can temporarily enable the preemption, so
> > > nothing prevents
> > > another program to call into bpf_cgroup_storage_set() on the same cpu.
> > > I guess it's exactly what happens here.
> > 
> > It is. I confirmed.
> 
> Actually, the failure is not due to breaking up preempt_disable(). Even with
> adding cond_resched(), bpf_cgroup_storage_set() still happens
> inside the preempt region. So it is okay. What I confirmed is that
> changing migration_{disable/enable} to preempt_{disable/enable} fixed
> the issue.

Hm, how so? If preemption is enabled, another task/bpf program can start
executing on the same cpu and set their cgroup storage. I guess it's harder
to reproduce or it will result in the (bpf map) memory corruption instead
of a panic, but I don't think it's safe.

> 
> So migration_{disable/enable} is the issue since any other process (and its
> bpf program) and preempted the current process/bpf program and run.

Oh, I didn't know about the preempt_{disable/enable}/migration_{disable/enable}
change. It's definitely not safe from a cgroup local storage perspective.

> Currently for each program, we will set the local storage before the
> program run and each program may access to multiple local storage
> maps. So we might need something similar sk_local_storage.
> Considering possibility of deep nested migration_{disable/enable},
> the cgroup local storage has to be preserved in prog/map data
> structure and not as a percpu variable as it will be very hard
> to save and restore percpu virable content as migration can
> happen anywhere. I don't have concrete design yet. Just throw some
> idea here.

Initially I thought about saving this pointer on stack, but then we need
some sort of gcc/assembly magic to get this pointer from the stack outside
of the current scope. At that time we didn't have sleepable programs,
so the percpu approach looked simpler and more reliable. Maybe it's time
to review it.

> 
> BTW, I send a patch to prevent tracing programs to mess up
> with cgroup local storage:
>    https://lore.kernel.org/bpf/20210309052638.400562-1-yhs@fb.com/T/#u
> we now all programs access cgroup local storage should be in
> process context and we don't need to worry about kprobe-induced
> percpu local storage access.

Thank you! My only issue is that the commit log looks like an optimization
(like we're calling for set_cgroup_storage() for no good reason), where if
I understand it correctly, it prevents some class of problems.

Thanks!

> 
> > 
> > > 
> > > One option to fix it is to make bpf_cgroup_storage_set() to return
> > > the old value,
> > > save it on a local variable and restore after the execution of the
> > > program.
> > 
> > In this particular case, we are doing bpf_test_run, we explicitly
> > allocate storage and call bpf_cgroup_storage_set() right before
> > each BPF_PROG_RUN.
> > 
> > > But I didn't follow closely the development of sleepable bpf
> > > programs, so I could
> > > easily miss something.
> > 
> > Yes, sleepable bpf program is another complication. I think we need a
> > variable similar to bpf_prog_active, which should not nested bpf program
> > execution for those bpf programs having local_storage map.
> > Will try to craft some patch to facilitate the discussion.
> > 
> [...]

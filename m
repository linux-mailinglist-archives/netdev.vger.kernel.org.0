Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66B9D332EF8
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 20:26:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbhCITZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 14:25:51 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:28402 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230425AbhCITZn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 14:25:43 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 129JI5CG015913;
        Tue, 9 Mar 2021 11:25:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 content-transfer-encoding : mime-version; s=facebook;
 bh=vmgsYgmjCo7JH6DX7RoUFGrPr886nUT4ARX+gTPPu3Q=;
 b=huzCoFuSNsiZNgA0jXBWYgZhAZz9JYIzMDqBvuaeJEeXbvw6UYykNB09BG/7rAd+xoz9
 IYK3alOPDgBuyu0w3RX8AYE/5i9WtnlGhIW1oM9oc1Ofp465O/h9A0WSLMaSZ/4ct99+
 91wYFbY+UKevs12Giist1bsGPykVpTJ56zM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 376dq2gk9w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 09 Mar 2021 11:25:26 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 9 Mar 2021 11:25:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DOTVcYT+c2AMoDFr7xHuUfaWkCFSFHRmjYYEQVfO/7PTeIGjl3CAa+UXEtTNJC2eVAZfrHxLOaUvCt7VV5vGqBLTWNrSsc0fy7MKCeGTnZZcDrYvAJ4P4zHP3ZkI/wyo+JH2e54EOloLdf+OF5EzxxM8vi2N4a+mMh6nB1sQbWMnnCBzh2rVU3C28LVcvGGBQ8HfzKXWF5RPh/nfHwWhXZtrVgB/2jJBMrkYthK7fuITitrz/R9hRGV5avQlpb3JBitL5ZLhNlOEAQ5jTCgS+XYgrYjw8pwIpnnrYjhCOLgicDcKIVsdS/qLrTQhX/4A3/L4w5EvRmug6XL3oJtI2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nG1Mdreq6DllmlAn1Xhwo+gSAPv1mJeIfKQ9QmTUfzY=;
 b=FSyV/QzSMJvSwTNY9kAReMB6nESS6d7jscST/O/n67b7gNqM/mYtRE37zOO9iKny8i915Yirq2Dm0f1jr3qkcc47RfqtGxlfs4R5kfmMdy/z48+7/KIKi0RM0ZbLjuMFMmgQFRe5OAL1FNkkV8t9JESa/KKRE/yvd1H5Nu/Fudos+kwtAvmKrDSijSjR3rq0v4RVgpDoe5Gt/byBKs2RWv+1q7VbC5Q0+XIHPYZ7Hsepi+sZKVkmgIk2aouhjxXoKgP15Djb1ijiIG3WgBZpZUysArnnCPtOl9kHdRM9FPrLnQlLIgGyRxzoM3Am9EbEYBPOBVjyKwR/4MHz4a8elQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB2807.namprd15.prod.outlook.com (2603:10b6:a03:15a::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Tue, 9 Mar
 2021 19:25:23 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::53a:b2c3:8b03:12d1]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::53a:b2c3:8b03:12d1%7]) with mapi id 15.20.3912.027; Tue, 9 Mar 2021
 19:25:23 +0000
Date:   Tue, 9 Mar 2021 11:25:18 -0800
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
Message-ID: <YEfLnk3ipJ7z7bMw@carbon.dhcp.thefacebook.com>
References: <YEEvBUiJl2pJkxTd@krava>
 <YEKWyLG20OgpBMnt@carbon.DHCP.thefacebook.com>
 <14570a91-a793-3f56-047f-5c203cc44345@fb.com>
 <0c4e7013-b144-f40f-ebbe-3dff765baeff@fb.com>
 <YEe8mt+iJqDXD6CW@carbon.dhcp.thefacebook.com>
 <45df5090-870a-ac49-3442-24ed67266d0e@fb.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <45df5090-870a-ac49-3442-24ed67266d0e@fb.com>
X-Originating-IP: [2620:10d:c090:400::5:a938]
X-ClientProxiedBy: CO2PR04CA0118.namprd04.prod.outlook.com
 (2603:10b6:104:7::20) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.dhcp.thefacebook.com (2620:10d:c090:400::5:a938) by CO2PR04CA0118.namprd04.prod.outlook.com (2603:10b6:104:7::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Tue, 9 Mar 2021 19:25:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 243df7f1-dbe4-4d0f-c126-08d8e33115ec
X-MS-TrafficTypeDiagnostic: BYAPR15MB2807:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2807A138EAA0BCFFD1A1B807BE929@BYAPR15MB2807.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7kkxmui4qUMcDGwQlwHSeuav1SZY47BMA13Y/GUTOI1Kuk54p/m+tIHM0M6Wc3YE7FgoF5TJaqUq05rk4Xv/sTrlERAKUt0MHFgbgHD/uY/yyu4VPdUBKwSOQUepOviwr+sc4qlXfWd3Lqx2l4h8dTAhiblzKpHw9ajkxBukHOQfPHpQHaEchtHmp3RKjiWzjd4TpFp4x+kgQNdd3kcR0IAl3kb7ipVqjERF1Ee9O0y8plUE3I+AqRFpADB6z8pw7OMXcHaAH04AxxtcRd9vU6s9LJae8c99TAd9IY2U6qx0QnWKhU6tm7pzNHqduPO6w7/1OnOaVq1Aqg1bkqbhSY64Uln7ASFcP8vVmXhT0QBocGlG84BybU+aZJClPIXjU/FMKwWHuAS3e0XMHOYvYOWyF9LWXIxmnV0W2JAaQApq3/nEc/BeHPsrfJvY9asQ3JFU2iY6K5UDlI5BB7A6knTNgVRfU83BrY8QfBxEDXJt3hho6PHUxMBQJLtBKhm3T2mrFY3XzsR6K63jngMxa85ZEbaX2DpMptaSgi5qyOBh5YqNvq83vH45XnD9jwwW0BS797bj+YbXxIQ1R5yRqzwgcxOr52bJ2NY4arRYhzY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(39860400002)(136003)(366004)(55016002)(53546011)(86362001)(66946007)(6862004)(8676002)(966005)(66476007)(316002)(6506007)(2906002)(8936002)(7416002)(9686003)(7696005)(4326008)(5660300002)(52116002)(83380400001)(186003)(478600001)(66556008)(6666004)(16526019)(6636002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?iso-8859-1?Q?EfzRilidZY1nqIIM6qGm/vjUt76KfCRhGp2MKR4OZR3iJfAm1+jgkko9zf?=
 =?iso-8859-1?Q?9TrCH4/DBFtW3f73bO+iny4AoPbFGoKo0+exVxIGainKK1vbtGxBGOOkug?=
 =?iso-8859-1?Q?q1OKy99OzR9r08LQltjgtvUAzhgXMaG6wIQDwJV4Xvhdx5hH9jUSJBWXnK?=
 =?iso-8859-1?Q?kZFLcomdYABX8wGtZN/hWcHE+DSHVD/lbif81IB9GKlt/AwKUqkO3XMTpa?=
 =?iso-8859-1?Q?BzusTcfpctsUUnSuUfwB9mGlHzgq3xhPcJoCKFo5ZrfSWbR0KPJup0Z1VQ?=
 =?iso-8859-1?Q?8Py0+LADLMV9X5NT4q6uivOiZacSYWWXQ4BCRex7L9b41xt0T2p9gyWTv0?=
 =?iso-8859-1?Q?HQG0ACWPsuaNlJ9jYaE3Lajo8Ewq9zYqKNL+98OZvK2oODwZaEWILqMgDH?=
 =?iso-8859-1?Q?YUQxwxE+jga4LQXzrfUYvsVHpYmoWSYap7ABhMB6O6ctXFbPSkgp+Szt3L?=
 =?iso-8859-1?Q?rBaNdq4YxID5kzw8o8avz1PzQ2begnGnrYlLSqgOd1h0Ht0AIm6eLPNz1b?=
 =?iso-8859-1?Q?c8TPq/VoF485adp0VOkKTUSp1LBkbzYLGurCUEahhR0Y0fDHtf88FhYSqW?=
 =?iso-8859-1?Q?K43JtBndrHGsUWFrLYP96ApxtcMtO4/qunjnuoQ0TaQs6wttweEf8rHB1+?=
 =?iso-8859-1?Q?FZNlW6nNWIBqiSLt9PveMET7B3DT36CT0jEjRT7tZR1UNExFZ+9pb5IGtk?=
 =?iso-8859-1?Q?/quNqj0otMSQCtfzgRbpTYEjDw0478Fl1jDOh8kv766kToYAPJvXkFCoJ5?=
 =?iso-8859-1?Q?gHhojCltNRFxSnpe/g1x5WDDkdCfrlq0SP34QR4iYcQX8nAIcOSIG0sc2f?=
 =?iso-8859-1?Q?c1ldwzool6ZvbHENHaYpKUudBS1IN0VLUULJ/hV+r3WwH4/FbaoHcA68In?=
 =?iso-8859-1?Q?PAbmyQ3bFi1eEWGx6cS4xDx0OQzl4iSxTHurrjq9JW+c6tIm6sVJsPcEk1?=
 =?iso-8859-1?Q?qFhXtei6lw/9nUkrWTFJKwDoiJeb73uleRyQpI8LxHs7kNxeD8k5HosffB?=
 =?iso-8859-1?Q?ZOWS6GgpuOGyznFLKQkV7FovWRa2wZQH5YQtFqxQSOGpGeLEnBYUzOomfy?=
 =?iso-8859-1?Q?/bukrTnuqK7zeQ4CIuWkLVTBIol0CdBK1ZkmcJIv+l0g2KKRmwkTfzSgld?=
 =?iso-8859-1?Q?twsLcdlfR4Q0oo9qK6fDEUXLyUKco+r8ETL2PQSmTxw07ZFKBwpPnuvdb2?=
 =?iso-8859-1?Q?PQiX7eHawjuDYzzxHysSrxAq07wrmKDUnTro/gAlkhtd1yIKu2wqlbCrNV?=
 =?iso-8859-1?Q?1jDuTeU3U3zCuWnLsEPuUmlsxkipKrfErKll9AE8yOtEZiAbgM5cgOEzd1?=
 =?iso-8859-1?Q?xSI0eS1t/bwFwq45WCF/ltS1P4jsgoXkiYL8JlFyReBsbfSh+gumBJKpE6?=
 =?iso-8859-1?Q?v1a/2FifVUYuQzbzkFUtFfxJePL57REQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 243df7f1-dbe4-4d0f-c126-08d8e33115ec
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 19:25:23.6503
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3eJaXsntXi+AQ6B3Rx/Ls6ZhDtx23Wwjc9aoE0MyRcjtkhh8J1Sl2rKfM1l0ubrY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2807
X-OriginatorOrg: fb.com
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-09_15:2021-03-09,2021-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 mlxscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=490 adultscore=0 phishscore=0
 suspectscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2103090092
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 09, 2021 at 10:36:06AM -0800, Yonghong Song wrote:
> 
> 
> On 3/9/21 10:21 AM, Roman Gushchin wrote:
> > On Mon, Mar 08, 2021 at 09:44:08PM -0800, Yonghong Song wrote:
> > > 
> > > 
> > > On 3/5/21 1:10 PM, Yonghong Song wrote:
> > > > 
> > > > 
> > > > On 3/5/21 12:38 PM, Roman Gushchin wrote:
> > > > > On Thu, Mar 04, 2021 at 08:03:33PM +0100, Jiri Olsa wrote:
> > > > > > hi,
> > > > > > I'm getting attached BUG/crash when running in parralel selftests, like:
> > > > > > 
> > > > > >     while :; do ./test_progs -t spinlock; done
> > > > > >     while :; do ./test_progs ; done
> > > > > > 
> > > > > > it's the latest bpf-next/master, I can send the .config if needed,
> > > > > > but I don't think there's anything special about it, because I saw
> > > > > > the bug on other servers with different generic configs
> > > > > > 
> > > > > > it looks like it's related to cgroup local storage, for some reason
> > > > > > the storage deref returns NULL
> > > > > > 
> > > > > > I'm bit lost in this code, so any help would be great ;-)
> > > > > 
> > > > > Hi!
> > > > > 
> > > > > I think the patch to blame is df1a2cb7c74b ("bpf/test_run: fix
> > > > > unkillable BPF_PROG_TEST_RUN").
> > > > 
> > > > Thanks, Roman, I did some experiments and found the reason of NULL
> > > > storage deref is because a tracing program (mostly like a kprobe) is run
> > > > after bpf_cgroup_storage_set() is called but before bpf program calls
> > > > bpf_get_local_storage(). Note that trace_call_bpf() macro
> > > > BPF_PROG_RUN_ARRAY_CHECK does call bpf_cgroup_storage_set().
> > > > 
> > > > > Prior to it, we were running the test program in the
> > > > > preempt_disable() && rcu_read_lock()
> > > > > section:
> > > > > 
> > > > > preempt_disable();
> > > > > rcu_read_lock();
> > > > > bpf_cgroup_storage_set(storage);
> > > > > ret = BPF_PROG_RUN(prog, ctx);
> > > > > rcu_read_unlock();
> > > > > preempt_enable();
> > > > > 
> > > > > So, a percpu variable with a cgroup local storage pointer couldn't
> > > > > go away.
> > > > 
> > > > I think even with using preempt_disable(), if the bpf program calls map
> > > > lookup and there is a kprobe bpf on function htab_map_lookup_elem(), we
> > > > will have the issue as BPF_PROG_RUN_ARRAY_CHECK will call
> > > > bpf_cgroup_storage_set() too. I need to write a test case to confirm
> > > > this though.
> > > > 
> > > > > 
> > > > > After df1a2cb7c74b we can temporarily enable the preemption, so
> > > > > nothing prevents
> > > > > another program to call into bpf_cgroup_storage_set() on the same cpu.
> > > > > I guess it's exactly what happens here.
> > > > 
> > > > It is. I confirmed.
> > > 
> > > Actually, the failure is not due to breaking up preempt_disable(). Even with
> > > adding cond_resched(), bpf_cgroup_storage_set() still happens
> > > inside the preempt region. So it is okay. What I confirmed is that
> > > changing migration_{disable/enable} to preempt_{disable/enable} fixed
> > > the issue.
> > 
> > Hm, how so? If preemption is enabled, another task/bpf program can start
> > executing on the same cpu and set their cgroup storage. I guess it's harder
> > to reproduce or it will result in the (bpf map) memory corruption instead
> > of a panic, but I don't think it's safe.
> 
> The code has been refactored recently. The following is the code right
> before refactoring to make it easy to understand:
> 
>         rcu_read_lock();
>         migrate_disable();
>         time_start = ktime_get_ns();
>         for (i = 0; i < repeat; i++) {
>                 bpf_cgroup_storage_set(storage);
> 
>                 if (xdp)
>                         *retval = bpf_prog_run_xdp(prog, ctx);
>                 else
>                         *retval = BPF_PROG_RUN(prog, ctx);
> 
>                 if (signal_pending(current)) {
>                         ret = -EINTR;
>                         break;
>                 }
> 
>                 if (need_resched()) {
>                         time_spent += ktime_get_ns() - time_start;
>                         migrate_enable();
>                         rcu_read_unlock();
> 
>                         cond_resched();
> 
>                         rcu_read_lock();
>                         migrate_disable();
>                         time_start = ktime_get_ns();
>                 }
>         }
>         time_spent += ktime_get_ns() - time_start;
>         migrate_enable();
>         rcu_read_unlock();
> 
> bpf_cgroup_storage_set() is called inside migration_disable/enable().
> Previously it is called inside preempt_disable/enable(), so it should be
> fine.

Ah, gotcha, thank you for the explanation!

> 
> > 
> > > 
> > > So migration_{disable/enable} is the issue since any other process (and its
> > > bpf program) and preempted the current process/bpf program and run.
> > 
> > Oh, I didn't know about the preempt_{disable/enable}/migration_{disable/enable}
> > change. It's definitely not safe from a cgroup local storage perspective.
> > 
> > > Currently for each program, we will set the local storage before the
> > > program run and each program may access to multiple local storage
> > > maps. So we might need something similar sk_local_storage.
> > > Considering possibility of deep nested migration_{disable/enable},
> > > the cgroup local storage has to be preserved in prog/map data
> > > structure and not as a percpu variable as it will be very hard
> > > to save and restore percpu virable content as migration can
> > > happen anywhere. I don't have concrete design yet. Just throw some
> > > idea here.
> > 
> > Initially I thought about saving this pointer on stack, but then we need
> > some sort of gcc/assembly magic to get this pointer from the stack outside
> > of the current scope. At that time we didn't have sleepable programs,
> > so the percpu approach looked simpler and more reliable. Maybe it's time
> > to review it.
> 
> Indeed this is the time.
> 
> > 
> > > 
> > > BTW, I send a patch to prevent tracing programs to mess up
> > > with cgroup local storage:
> > >     https://lore.kernel.org/bpf/20210309052638.400562-1-yhs@fb.com/T/#u
> > > we now all programs access cgroup local storage should be in
> > > process context and we don't need to worry about kprobe-induced
> > > percpu local storage access.
> > 
> > Thank you! My only issue is that the commit log looks like an optimization
> > (like we're calling for set_cgroup_storage() for no good reason), where if
> > I understand it correctly, it prevents some class of problems.
> 
> Yes, it prevents real problems as well. The reason I did not say it is
> because the patch does not really fix fundamental issue. But it does
> prevent some issues. Let me reword the commit message.

Thank you!

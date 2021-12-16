Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56295477B59
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 19:15:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240585AbhLPSPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 13:15:14 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:42842 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231582AbhLPSPN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 13:15:13 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BGA5QUh006061;
        Thu, 16 Dec 2021 10:14:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=b63EOuX8g0B+9KcMjuhLwZxhFXZXReqwoX8ZIg9Z5K4=;
 b=AbCSVdYSFzC9Pv2hr4XnZ4oXzWkMKFuTyTjimX4218VKNK5kD7ICvCmwrcxZeKXO1DdF
 tsT7+qpe1FnxLa7CADRk77JOtYLTfpNE/FoO/v+eh6LdCvjR8qL0PIrTNhxDhfJt/v2Z
 5kkkPR84QXv3IFti/gpPB8Hdl4u9O8cvo0Q= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3d03d5uhv0-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 16 Dec 2021 10:14:57 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 16 Dec 2021 10:14:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l5v7fo8dF/Ox1WAUDywLvXhFUJUnzJq4WLQssvG5iCtVwisXWK9EQLSboRGNfDi22aXhvSCK7mkSbeP0MvFdjTTUZrkldv5AW/iMI6+ZOaY2UkVdA7cpXJYDlNJBd+WoBY0fogmprh18RiAwBjp+WA4XNqf3b/WkwlP5xh512dZLJICPZ6R5fRGAyn+INmkW0es+1gfvQ40VFuw9fTmwPcPHcvvg7iWRaWjoilcRNdDV41TMHquZ6WDCDkER5mMrTDbtbs0e/o07FX/cypkTsI74OeSPhbuH1qHT36iZH6ifnZOlpBX/OeGs8yzYF4dVmJCW1Mq3bEopBLG6AGk81A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b63EOuX8g0B+9KcMjuhLwZxhFXZXReqwoX8ZIg9Z5K4=;
 b=SztMx1Kv/BGooV8EiE7I+DdkF794AFPxt4Yv12YkthpfGRJGGWqHjIIgIFlspHtqzdnqnXn917TE3rIY1csa+jUofu64pPAzhumNroi+S0246bY44EQlDlA4h8SJqgG0VCrbe8p5XOxdTewYLADSZQ7WrmpT1l941cPYGMgToqbUM+HY+3so3vA2PoksxZ2nQVqv+eIUp31hEjseoD+qRRpZbRkfgNQyVfITkfyufQfiOup/+38SDVFyt6JWr0c/yTb5OqNQtrbw9peGh7xBu/ABJ1aoK28GjelMRzDA7fvjbq/zv3Wl+opcYwZTPetrSwC05uMVgCHlj0NW/KGfkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA1PR15MB4323.namprd15.prod.outlook.com (2603:10b6:806:1ae::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Thu, 16 Dec
 2021 18:14:52 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010%8]) with mapi id 15.20.4801.015; Thu, 16 Dec 2021
 18:14:52 +0000
Date:   Thu, 16 Dec 2021 10:14:49 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] cgroup/bpf: fast path skb BPF filtering
Message-ID: <20211216181449.p2izqxgzmfpknbsw@kafai-mbp.dhcp.thefacebook.com>
References: <Yboc/G18R1Vi1eQV@google.com>
 <b2af633d-aaae-d0c5-72f9-0688b76b4505@gmail.com>
 <Ybom69OyOjsR7kmZ@google.com>
 <634c2c87-84c9-0254-3f12-7d993037495c@gmail.com>
 <Yboy2WwaREgo95dy@google.com>
 <e729a63a-cded-da9c-3860-a90013b87e2d@gmail.com>
 <CAKH8qBv+GsPz3JTTmLZ+Q2iMSC3PS+bE1xOLbxZyjfno7hqpSA@mail.gmail.com>
 <92f69969-42dc-204a-4138-16fdaaebb78d@gmail.com>
 <CAKH8qBuZxBen871AWDK1eDcxJenK7UkSQCZQsHCPhk6nk9e=Ng@mail.gmail.com>
 <7ca623df-73ed-9191-bec7-a4728f2f95e6@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <7ca623df-73ed-9191-bec7-a4728f2f95e6@gmail.com>
X-ClientProxiedBy: MWHPR08CA0047.namprd08.prod.outlook.com
 (2603:10b6:300:c0::21) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cfff7632-91d9-434f-9d5a-08d9c0bff4bd
X-MS-TrafficTypeDiagnostic: SA1PR15MB4323:EE_
X-Microsoft-Antispam-PRVS: <SA1PR15MB43233D6446CC6B895A45AB8ED5779@SA1PR15MB4323.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3HeJO6GFCXuTBA4RId+Wnn0AA4lR50OZGM0+TjtKEPTXgUNiuOIHevLoPSp4Wj5Blk90gszdf7ZN9Md0IpeeAulSgwGg4fzFMN4MV+6KWhZdUz6YgAOICtIqVEp3V7unclfQhWuBZ1ADsKtiSlGqjFQBlwwH3nKKOW991t1fIU2ppqXFTXbaVzWXpZ1tVfpgPleECx9/15+mHSmu+jzYlfQA7lwjb0cLTo053sznYXEQm2Wx2u5MpFEeaJlh5rjFAgFgmqAQPm42+EBDAudYFFBJp1BHf1fwMLEFiiP7EYB1aRzFMthwkqx/VZjzdqFN7WawE2PFiILOIxR9WtZKZVv7JKlh/3MH4FJ/mKQU72VmH4d0eVgVV8QLg1J39SMKACmVRGp+3jntlbp1rRiee68Q+0F9G6keWOsyqVoy2dGfyQgLSR4M3AW7SKoqxDZuiVh3GPp/ykYwQw/3BatGl6iyw93rmncyl5vqmMyRBL/Zs7vvWyGE49ZSbXGbxlvNq/fW0bZVEM8TBqaoJv1QKOEH5qVKDZTRjgGfb37bTCjuCNWThHY7BQAn08iq/Od6iQUq5OB/i/t8laji2PJ60utrGpDTWCYrjPfjZWP0Tvn6kTQyHdGqvpoYP+Q6aOp8z6NWP+eZzPp3R8oJhdDWjQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(6486002)(53546011)(6506007)(8676002)(6666004)(86362001)(83380400001)(508600001)(186003)(5660300002)(38100700002)(316002)(54906003)(110136005)(4326008)(66946007)(66476007)(66556008)(8936002)(1076003)(6512007)(2906002)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?li57LIqPN+XDB7e3z8CEHboLPVpRz7edGpXoffnoO9L+r8ILkicLDPQKv1tA?=
 =?us-ascii?Q?vNDf299x1L3pY8pOySHXMEC5hQFoizkWzgTByGNVFHt6iuB2kTsZKGFkFRhR?=
 =?us-ascii?Q?PT33KQaLvglowpxeUwi1MvUecciGlvh8S8m6trkk5I8zkVWmQIhXpJXuzEy6?=
 =?us-ascii?Q?WmIv2K96EKXS6DzEQAdD4E8zfc3OIwBNibRMbbjws7n/ytr4ypn6DPgVABxS?=
 =?us-ascii?Q?xSCne6s1L/EV7O9umuzZWGRGPDFTdXDbNQc58bXYzeplbJy7YqwIxO3Bfgml?=
 =?us-ascii?Q?An4vZpXF0Qrj4FUyAai8BJEVlJI36SMFVF4QNy+vUKr7qrqwmD3B/KLERokx?=
 =?us-ascii?Q?uIbiOUlasbhW+abD9kiSYoywab8cdFEA1rJSdrChc1Xuu+4i2DgJR0sQShts?=
 =?us-ascii?Q?JMFuVJ+2+MRuZcJ9LT6qLpjAtIMGbCZX2buNq6Zgwzbky1PtY+xHf0928w4Y?=
 =?us-ascii?Q?mNeViKDInURDFNHgnVLaKA1OePeSxlNYzqZvLKHLY+Pir7zAPw9Junq6hai0?=
 =?us-ascii?Q?Qk+/7jzZ4RhOIzuKbc6QhAV64IxvGf2A5Jep4oci0oO0kroIHGsoxKDJEzwr?=
 =?us-ascii?Q?JMDx81F275Z/jJDC40ZxIVTTUpnYuDjJmpKBjU4ndyiz4j6jCmBHQn46anRV?=
 =?us-ascii?Q?5CIL07CeGRv+V5iHS04+DjnLqqAhtr7QAU8daq8e4lsv/e5FH7Fv3jXyWRNm?=
 =?us-ascii?Q?KZ2cNvLSVcS47QstmGjEiWmOUe81Gzbf/+alMTmc+pklO6IACeRjSEEZ41gv?=
 =?us-ascii?Q?IK5jB/6I8aXR24nM9nyPtmltoKdYox4jA300ollqMLygAllYRxYC1nm55tis?=
 =?us-ascii?Q?Vmh9OyC5HvLppVHjj3zhMnK9IC+BAoowoPX+CV4NvndrwpNL70nzqpswOeY2?=
 =?us-ascii?Q?uLHzbKTvXXwDOxNsrllnjry7TS3+fAt5cWQeh4486tE88d8dUo3Ffv2f6sFw?=
 =?us-ascii?Q?5phnXSU09NJ1UMju5O3NfQl3o5vbsAgf32DdITVBemgVm94qN3UFl/lE+/Av?=
 =?us-ascii?Q?vvOCStVtM3lzHCgxmalDRgY9xKXCRdt1YlwYVEUWyYGsQBcYZwe+fM751KEF?=
 =?us-ascii?Q?2seqknJ4kNcwl+I9aAYOQKywOShM0NTdWxffTkkAiSjSBp4G4BKzzYMf/rxN?=
 =?us-ascii?Q?bj4zE2YFUWnZMEDl4pk3gu0IwXEWc5LpZdmcAw+i69xTc/bLboev3jNOsnen?=
 =?us-ascii?Q?Pgsl6f4koWIEHMHFXcSK320/aMHtWSV7hzs56xB9GpBmA2uzJsgYIAHdJ+xH?=
 =?us-ascii?Q?dUFsTZai0u+JaQgTKMS1ZoiqqQx1HHsJpvWWM5sRxwjCZLPZHNQ+F7D2UQQe?=
 =?us-ascii?Q?dUt71Od98XJoccTEwmTEvVegmH7TODeu6uopkkj2x19rl2yjOXCfrrhHbN9Z?=
 =?us-ascii?Q?P1NoqyH1wGKMjSrzdJ5K2gTTF/ZcQrvyD7X/AAjfNUPitnRJWhSSw5mIOec9?=
 =?us-ascii?Q?rXQxcAGbvtQduLosX1jcvn3pdHYMJ/X6+SeUJk3bYL6J43H5S6JExUmXhXmn?=
 =?us-ascii?Q?Us/qz1sCaGUAAd+EwyZzt0Pax0IC8qo3yu2zFH44emNxZ9rZi95Vwbz+PwbT?=
 =?us-ascii?Q?JPENVFwqO+y0Q2L9HKy/TW4X3T0ti9IVzYmI0Z/8?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cfff7632-91d9-434f-9d5a-08d9c0bff4bd
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2021 18:14:52.8512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8DZjnMFQ70HER0BKXK9wS/EMppw8iUtVnVwckYL08omj05H2GjT0x5NErx4CgRvx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4323
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: LjsPYhw3c-OmxjAKEfK_on3fCw_nmKOL
X-Proofpoint-GUID: LjsPYhw3c-OmxjAKEfK_on3fCw_nmKOL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-16_06,2021-12-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 suspectscore=0
 mlxscore=0 priorityscore=1501 adultscore=0 clxscore=1011
 lowpriorityscore=0 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 impostorscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2112160103
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 16, 2021 at 01:21:26PM +0000, Pavel Begunkov wrote:
> On 12/15/21 22:07, Stanislav Fomichev wrote:
> > On Wed, Dec 15, 2021 at 11:55 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
> > > 
> > > On 12/15/21 19:15, Stanislav Fomichev wrote:
> > > > On Wed, Dec 15, 2021 at 10:54 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
> > > > > 
> > > > > On 12/15/21 18:24, sdf@google.com wrote:
> [...]
> > > > > > I can probably do more experiments on my side once your patch is
> > > > > > accepted. I'm mostly concerned with getsockopt(TCP_ZEROCOPY_RECEIVE).
> > > > > > If you claim there is visible overhead for a direct call then there
> > > > > > should be visible benefit to using CGROUP_BPF_TYPE_ENABLED there as
> > > > > > well.
> > > > > 
> > > > > Interesting, sounds getsockopt might be performance sensitive to
> > > > > someone.
> > > > > 
> > > > > FWIW, I forgot to mention that for testing tx I'm using io_uring
> > > > > (for both zc and not) with good submission batching.
> > > > 
> > > > Yeah, last time I saw 2-3% as well, but it was due to kmalloc, see
> > > > more details in 9cacf81f8161, it was pretty visible under perf.
> > > > That's why I'm a bit skeptical of your claims of direct calls being
> > > > somehow visible in these 2-3% (even skb pulls/pushes are not 2-3%?).
> > > 
> > > migrate_disable/enable together were taking somewhat in-between
> > > 1% and 1.5% in profiling, don't remember the exact number. The rest
> > > should be from rcu_read_lock/unlock() in BPF_PROG_RUN_ARRAY_CG_FLAGS()
> > > and other extra bits on the way.
> > 
> > You probably have a preemptiple kernel and preemptible rcu which most
> > likely explains why you see the overhead and I won't (non-preemptible
> > kernel in our env, rcu_read_lock is essentially a nop, just a compiler
> > barrier).
> 
> Right. For reference tried out non-preemptible, perf shows the function
> taking 0.8% with a NIC and 1.2% with a dummy netdev.
> 
> 
> > > I'm skeptical I'll be able to measure inlining one function,
> > > variability between boots/runs is usually greater and would hide it.
> > 
> > Right, that's why I suggested to mirror what we do in set/getsockopt
> > instead of the new extra CGROUP_BPF_TYPE_ENABLED. But I'll leave it up
> > to you, Martin and the rest.
I also suggested to try to stay with one way for fullsock context in v2
but it is for code readability reason.

How about calling CGROUP_BPF_TYPE_ENABLED() just next to cgroup_bpf_enabled()
in BPF_CGROUP_RUN_PROG_*SOCKOPT_*() instead ?
It is because both cgroup_bpf_enabled() and CGROUP_BPF_TYPE_ENABLED()
want to check if there is bpf to run before proceeding everything else
and then I don't need to jump to the non-inline function itself to see
if there is other prog array empty check.

Stan, do you have concern on an extra inlined sock_cgroup_ptr()
when there is bpf prog to run for set/getsockopt()?  I think
it should be mostly noise from looking at
__cgroup_bpf_run_filter_*sockopt()?

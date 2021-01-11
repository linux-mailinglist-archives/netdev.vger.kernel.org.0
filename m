Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1D8E2F2256
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 22:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389224AbhAKV7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 16:59:46 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:14956 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389004AbhAKV7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 16:59:45 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10BLw8Mp026857;
        Mon, 11 Jan 2021 13:58:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=sZJGw6FZ4/qpScpWwcjPpR9vLR8898SluPYXOehPdvg=;
 b=bHiHfBn0RU3xWxK3LfL13xnQ2E+rE6YrWrpen4JuLEm2janGNe5Dx+BScBqJ5a8ZNBgs
 Z1CAIsFK2hOUbcseU2bYvLS0zcO8HCMGqu4ilUZy+KYLWAG5ruREC2l7F6ajlKXmmiX2
 RJes513pW8CQUvvdOlG6R3Jeag9BvKFeF6E= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35yweb793m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 11 Jan 2021 13:58:42 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 11 Jan 2021 13:58:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gACOd5AcTvAH1RuQY8+Z5b+BIswxJxhznuc11gjHAnqVO9X0KZmaFXt28CiYbjZNk5u7WgwsAVnLwo51B8gOwrcLjTmQbjrLZFCmlKLNicsN9FA++R+QrJZT7coJ7T9IQn0hVZKMNhjzZCXam6D6nefCGUG1VtMPJ8HXQ4XDsnAzVmVFPGWPB5nvc+eWm3D/AE9ILFE4jcejc+BDpPlCBx/m/SYikS9ze8TFqfp6bItctCpnS68mSCO6vGwduTHxHngwJcKngukYsS6p3T3IZXWPajO9xPjVqA6WgFYUgZj0Vo35dp2+ERsbB67Ut+TXF8tpPuOPVDqVzOnfZXz2oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sZJGw6FZ4/qpScpWwcjPpR9vLR8898SluPYXOehPdvg=;
 b=GCxEmwULS+J/dFXPHq/tnMc2PoxKF3m3udeWokBmAZjXBgVlZ+FCRd7l1T/3fqv/gJp/XhG6C2CsOr+QWTqIEoR/HvCcUtpZpa0bPxr0W6dY5bBuJg09BCPaEAtmJR6vTdSVjkWLiHMFptNk4CJ3ZTBxie2uIzGaSshIktHzD1y8vKFb8WOA7ni76r3rSVIXonlmnlsVJFIRp5nXdaC6E4fn8NXmw7yuxrsBB6lztJWbDtcPlZkfJo4sEQXen78oBhdk/RDe8xIlf8jAf+MbXxsDzM4/4c/yhqJZiZjdWwZTUA1xQCfCb3k+g1x5rZezIjF/EwUUl2FYaPVeXV4MgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sZJGw6FZ4/qpScpWwcjPpR9vLR8898SluPYXOehPdvg=;
 b=hr7c4QOl890dcY6MhOHo5BuYnu3ILYiaORDAwkRoM5xFo+31A38urDG7FoDX6CgRVlqzVkxVCLqcCbBPy9lFfSIC5q9j5nP13Fi3ftI9N2XLWVZkQ5ktusMsfauYLPSFttJ0PzJcqAVGslBvoSEKR5dyHsgSbQ9cuwCbjzYJgBo=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2453.namprd15.prod.outlook.com (2603:10b6:a02:8d::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Mon, 11 Jan
 2021 21:58:34 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d13b:962a:2ba7:9e66]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d13b:962a:2ba7:9e66%3]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 21:58:34 +0000
Date:   Mon, 11 Jan 2021 13:58:26 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     KP Singh <kpsingh@kernel.org>
CC:     Song Liu <songliubraving@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Kernel Team <kernel-team@fb.com>, Hao Luo <haoluo@google.com>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH bpf-next 1/4] bpf: enable task local storage for tracing
 programs
Message-ID: <20210111215820.t4z4g4cv66j7piio@kafai-mbp.dhcp.thefacebook.com>
References: <20210108231950.3844417-1-songliubraving@fb.com>
 <20210108231950.3844417-2-songliubraving@fb.com>
 <20210111185650.hsvfpoqmqc2mj7ci@kafai-mbp.dhcp.thefacebook.com>
 <CACYkzJ4mQrx1=owwrgBtu1Nvy9t0W4qP4=dthEutKpWPHxHrBw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACYkzJ4mQrx1=owwrgBtu1Nvy9t0W4qP4=dthEutKpWPHxHrBw@mail.gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:e2df]
X-ClientProxiedBy: MW4PR04CA0243.namprd04.prod.outlook.com
 (2603:10b6:303:88::8) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:e2df) by MW4PR04CA0243.namprd04.prod.outlook.com (2603:10b6:303:88::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Mon, 11 Jan 2021 21:58:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 812e7c4d-dbca-4d89-3c83-08d8b67c0a9f
X-MS-TrafficTypeDiagnostic: BYAPR15MB2453:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2453D9FD2DA587E50B48F7A2D5AB0@BYAPR15MB2453.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cif/rj4rgWzz9e6H06Ph52dXhrIIpp1xPu/WWetDXBZhHmCoC6oyymwrDKlqR2FullO948w0jFPOBNJoBe1RqBT/ZFUvQHm9BHg9pIHIhyaPpums7kltEJfX1yuW906zZWcdLbA5eJ6RpL4gQiUF4Vg7eW/7RCnlF0KZi+FWv0N/tdvnZ2OmiMhmHouwgVS7IBP5c9T45Zib4ip4hSjYEmPqpiQeqpFYtQoROL5tKW4UhoqJGVVOvYpTNUS1kYey/kxjrLGUjo5SskShK+gnPrgsCIQ081PqwtyzBW5EYyv/ImSNXRnWeVxb4i8eOtR8OZDg7/W1PS+z2HBgjLdaw3U0BJUyZ857YqmkhatHMyAptQoS90/uOpoaC6HjhxHriURQtYKOrt+MbOtE4fzHbA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39860400002)(346002)(136003)(396003)(478600001)(8676002)(7696005)(6506007)(186003)(53546011)(52116002)(6666004)(2906002)(54906003)(16526019)(4326008)(316002)(8936002)(66556008)(9686003)(66946007)(7416002)(83380400001)(66476007)(86362001)(1076003)(5660300002)(55016002)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?541obB3Sc2Xm5HkRBJf4AtU0PXVMvP26J10H3bIvOUmK6o7VKUh7ZI98wX7x?=
 =?us-ascii?Q?49YhUSxg1iJ19gZDF3vpF4faETHDkYugUGcAmts3/Sp9876NL1dIpCB0IfK1?=
 =?us-ascii?Q?bhObr2P6AyA3vhSXVorWkNe4WzvvCFgBdHR6Hg3NwhW+ECwl9KdBLcOal9jb?=
 =?us-ascii?Q?uTpjw9yfe705arkeSmoZRGcg3KYr2yhygy6poQAskG4lwzbyE3XCMpdV46rm?=
 =?us-ascii?Q?Wgh929dSvfxGCSlQ0NP+LKxT4ysWu/Y7rcIEwpfg/Jkbrbwb3VSRZV9XMk7/?=
 =?us-ascii?Q?KyiOLbaHlbjH266NoSNZ7Vr6RTveN4Im2IlffrKQwCKaeU9qNX8Qd12luNno?=
 =?us-ascii?Q?LJFG0jEdQnGdxNP6NdbDrbZlSSEvVlqJUvsTp645KOJ+aNKlqK61D6gazLl1?=
 =?us-ascii?Q?+hzGixe7qoR5F8GLsb6KZWXlo+aVRdNCMQE7tCCk2l4s7uDiRS1OKMx1KV1j?=
 =?us-ascii?Q?QyiD+Oe1g51lDAbnFCRk5S9qv1F7WpJjGHGv+SyADt2AT5NBBTnFVq98R/8k?=
 =?us-ascii?Q?7R/DiYqP6SsKTS8E2AqQVuMjQvZf33V7ORXJsYiTKG36D2ps3ORZjckhEbAr?=
 =?us-ascii?Q?rCrBJ7ZeEYaf/RHoj3tX3p5GXWcI0+8+vcKdS/v7+3tNwTr5kB+LtWbL2oPv?=
 =?us-ascii?Q?ix2gtN/AMHWGH0vQ7MmqNyTTJbKvFA8uKi+nOJBL3U5mbXRp6ledfQWedJcf?=
 =?us-ascii?Q?/u+1/GA5sJOSmyP13hy20TORiQDAAjQmDamIC+n+Ls14xdZJ9TbnsGTfZHQx?=
 =?us-ascii?Q?0+zK0RfyytjUoVH29h7m8JPN4LBd9tfAtTJjohhfLq4kQBXVxfrKyAYSgcbY?=
 =?us-ascii?Q?NlnES0p+sPdwPpGe0Ie+78rKLrYTE+r9JvyL7qxhykzi3y85Hj3l8UyGe9Zq?=
 =?us-ascii?Q?5e/CkNPyniUAW2XhIpvchNqRe+LS1p5Je8DIBR02QJBFmUdDmI/GCAj87s7m?=
 =?us-ascii?Q?+hBztaOkCdvdGgLvg1Yui63BNdsvHUIWxuuVvAYGjFBqS+ePxyW2cf5MsCJT?=
 =?us-ascii?Q?V61nC1r9eHm9HPmXSjst8ibaTw=3D=3D?=
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2021 21:58:34.2193
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 812e7c4d-dbca-4d89-3c83-08d8b67c0a9f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nJJrhzGN4PqFvhFoWpbUPq+rkD1Nc+R0F21ZSa1Uf2fO6Rxn0R9NpDaO07hVUfMP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2453
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_32:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0 impostorscore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1015 mlxscore=0
 adultscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101110122
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 10:35:43PM +0100, KP Singh wrote:
> On Mon, Jan 11, 2021 at 7:57 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Fri, Jan 08, 2021 at 03:19:47PM -0800, Song Liu wrote:
> >
> > [ ... ]
> >
> > > diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_storage.c
> > > index dd5aedee99e73..9bd47ad2b26f1 100644
> > > --- a/kernel/bpf/bpf_local_storage.c
> > > +++ b/kernel/bpf/bpf_local_storage.c
> > > @@ -140,17 +140,18 @@ static void __bpf_selem_unlink_storage(struct bpf_local_storage_elem *selem)
> > >  {
> > >       struct bpf_local_storage *local_storage;
> > >       bool free_local_storage = false;
> > > +     unsigned long flags;
> > >
> > >       if (unlikely(!selem_linked_to_storage(selem)))
> > >               /* selem has already been unlinked from sk */
> > >               return;
> > >
> > >       local_storage = rcu_dereference(selem->local_storage);
> > > -     raw_spin_lock_bh(&local_storage->lock);
> > > +     raw_spin_lock_irqsave(&local_storage->lock, flags);
> > It will be useful to have a few words in commit message on this change
> > for future reference purpose.
> >
> > Please also remove the in_irq() check from bpf_sk_storage.c
> > to avoid confusion in the future.  It probably should
> > be in a separate patch.
> >
> > [ ... ]
> >
> > > diff --git a/kernel/bpf/bpf_task_storage.c b/kernel/bpf/bpf_task_storage.c
> > > index 4ef1959a78f27..f654b56907b69 100644
> > > diff --git a/kernel/fork.c b/kernel/fork.c
> > > index 7425b3224891d..3d65c8ebfd594 100644
> > [ ... ]
> >
> > > --- a/kernel/fork.c
> > > +++ b/kernel/fork.c
> > > @@ -96,6 +96,7 @@
> > >  #include <linux/kasan.h>
> > >  #include <linux/scs.h>
> > >  #include <linux/io_uring.h>
> > > +#include <linux/bpf.h>
> > >
> > >  #include <asm/pgalloc.h>
> > >  #include <linux/uaccess.h>
> > > @@ -734,6 +735,7 @@ void __put_task_struct(struct task_struct *tsk)
> > >       cgroup_free(tsk);
> > >       task_numa_free(tsk, true);
> > >       security_task_free(tsk);
> > > +     bpf_task_storage_free(tsk);
> > >       exit_creds(tsk);
> > If exit_creds() is traced by a bpf and this bpf is doing
> > bpf_task_storage_get(..., BPF_LOCAL_STORAGE_GET_F_CREATE),
> > new task storage will be created after bpf_task_storage_free().
> >
> > I recalled there was an earlier discussion with KP and KP mentioned
> > BPF_LSM will not be called with a task that is going away.
> > It seems enabling bpf task storage in bpf tracing will break
> > this assumption and needs to be addressed?
> 
> For tracing programs, I think we will need an allow list where
> task local storage can be used.
Instead of whitelist, can refcount_inc_not_zero(&tsk->usage) be used?

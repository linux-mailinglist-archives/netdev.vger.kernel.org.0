Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B978950EAB5
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 22:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245599AbiDYUl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 16:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235623AbiDYUl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 16:41:28 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 036843A5F8;
        Mon, 25 Apr 2022 13:38:22 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23PHP6uE006771;
        Mon, 25 Apr 2022 13:38:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=QRZ0HMHd8n+rWZk1l8wV10PYpjApGdAut1NGzSOVBrE=;
 b=ap2k/S9OydWQX3JacD+jtINIxZyymI2/Oa7kdN5a1tN1NxyxjZn5boHL1hZeyjUJEzf1
 EwhU/0BLZ1zPmsrwU3BSitRzz9eXIarlzs3C+5AK2nhKcRfYZDceeWwEQXqblsHJZt8P
 Lcmoi2GW1L+Qv06sdx/0sp69lgMs7LuVrII= 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fmdgfwdvy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Apr 2022 13:38:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jcHlnAoiefrB/Cfx9cmzoz3c7oz8qOTrBn2oHVPwNppV1zF3gizHLqps07VpBVWE329F4WV6/qo0uztsJh1GrD78wJUatbarsGY76WtBmFXLAIWPv8sTeY4mLfpC78t+Gv98PNmJRQnindUQVeDNbCm6N8QZ07RIIH8qCEnN4y8xDvZq1OcWzGHknSgWzw4FuGBxSzlLsEw4gtSQiq7Oz4fLVlIHtE4M69Nrhr0+EH7bntusZ5HaPaxZWEksRuHr0PhEoi1ZvvM+S+S5Ov+eujYK5eb9avhz9RYjz2EcVvhH9lQ8yrVxSWRrDyvOV3lc5tTSQXItXBpNy2y3xfAn9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QRZ0HMHd8n+rWZk1l8wV10PYpjApGdAut1NGzSOVBrE=;
 b=QwSCdCyKjswo3ArW+70UcaqlN6lOx9+I2m2w4JStFuHx1bCMtakHkT3P7RSAFLMai2BwkOwGUVmLG3zKjyBXjGijOLJUAmImTYBSCSULCbtErJVX7FvBqtE2vNkkaH9qUfp7LhIvdr83uKtwndK1kTSRoSkBYnUJtA4RWVJM8exqe0BuNzw9kUzKvvtHuAX80S7iFznMfiACqXcQpoPPYSpVTBq4ot8UFOwCqJ/519s6Mw+pm+QENtTIGHYJX68SuWajP0abTLX7e7WIsZGT2ClZGP3aoyvHmLmQfCb9qmzjcAqd0wid32WBR1On6FvOfLFbfjs9paSVFcvl1kJmPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by MWHPR15MB1551.namprd15.prod.outlook.com (2603:10b6:300:b1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.21; Mon, 25 Apr
 2022 20:38:02 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::100b:5604:7f1e:e983]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::100b:5604:7f1e:e983%5]) with mapi id 15.20.5186.021; Mon, 25 Apr 2022
 20:38:02 +0000
Date:   Mon, 25 Apr 2022 13:37:59 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: Re: [PATCH bpf-next] bpf: use bpf_prog_run_array_cg_flags everywhere
Message-ID: <20220425203759.yxyyvdarx4woegfg@kafai-mbp.dhcp.thefacebook.com>
References: <20220419222259.287515-1-sdf@google.com>
 <CAEf4BzYoA4xvqv7SaM2TvcbKef=m4n6TSGVNA34T2we05fRwpw@mail.gmail.com>
 <CAKH8qBsTiQA5knxoBSqxCYav89QdSN0j6t1EWX1MEVbAqLj6kg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKH8qBsTiQA5knxoBSqxCYav89QdSN0j6t1EWX1MEVbAqLj6kg@mail.gmail.com>
X-ClientProxiedBy: MW4PR03CA0266.namprd03.prod.outlook.com
 (2603:10b6:303:b4::31) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b26e039-c108-4e81-2b2c-08da26fb7e1d
X-MS-TrafficTypeDiagnostic: MWHPR15MB1551:EE_
X-Microsoft-Antispam-PRVS: <MWHPR15MB15512CDFE6891E1FDFDECAFFD5F89@MWHPR15MB1551.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UmRt6lWZbe9h+Epg4HEZEcSZfSJIx+kmFsKtOVDqMNdSiGRe/hEjgu2bFWvfjM6OdZdjONApABP2diVIkYxuCKuicZVQXBHBIxHYz6V52FcO3JaVXGpUjUC5txXdPj+qjDXOIPAibXqHqzJib2MTBc+2Xe8It2rLMHyBGetTy5aMufzRj1ZwVjS9NhHOON4Xt10eCubM+C45/nvvrpNU+p7+2l7Ky94KktDHlATFsqplQxEHa59vnSF59SxU/DjnZagMT0rcOIHzcrUMb4hcSK80HSL4c02alVQXITAZrZGMvnMKMCcpRo5dnAE9VR967sSRbXEdVKHV7MAvcjxdG3SHXlHvA0j9i51a7keWVew/C/QNdYX1jhP4seaC9VJvDhNUpB2s/Zgp70kqIYtcYk1fe8Ci5/qfZViOdtZC7Cs4TlQZbJmuQ2G4F95ve9Bnii4y36E+qCvM/Yf18MgfZ4YFD0TR+3c4L0Vs1pAT3BJPYzAhgPKyvKP/AXvuZiHTBM+UI29Vqs/jgK6iJbKnKCb5bMDrdkf1Ctp4PO8Jm6DT/2TiSfSwvYYngJA9aBFj6PSOXkvxgh8iDIzHBKDsFZJ/NvTD4+bWxiPUp6MxYrfkkIRw5WTqkUPT1H6rFPypwGukRIFlj0rZOIORU5mppg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(38100700002)(6486002)(2906002)(8676002)(4326008)(66946007)(66556008)(66476007)(316002)(5660300002)(86362001)(8936002)(83380400001)(6512007)(9686003)(6506007)(53546011)(186003)(1076003)(52116002)(6666004)(54906003)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cRRaD4EYf7ugH7ju3/mPuNgl48/ICZmHPe13/80aelRSFjCR3cfl3z5yPreV?=
 =?us-ascii?Q?DiaySFR4rflyER/x8nSSaPfb9jUUeIGCQgp+ydB2UxE9iz1luR3hf/Tr4pvH?=
 =?us-ascii?Q?OsCyipGTDm4/uZqNx8oX75JhEUWqNpEvggAd0+v8Jkv8BzXXyd7q3fwK6zTU?=
 =?us-ascii?Q?o/+pINTO7GDEJ/lFGuxn0fMuheu1Ea6N5hIXP4AX6wXHl1UXEUp8IxEj/jeq?=
 =?us-ascii?Q?XRZGGomdsoCW9kEl8Eyk8hKywEi2R0CWSIOHHnmWzSlql6YdjrjmYYAM8Yw9?=
 =?us-ascii?Q?j1tAIoHy0CTkpzyU93L40GM8sIZjfwhClKmheWS+Tls4RliWsdyRkWzjqeOB?=
 =?us-ascii?Q?JeRBdS0eG+d4nYj4NkXwmbeFjy8jRI1JMclR2O3BFmqOwsZ504obgM46UBw8?=
 =?us-ascii?Q?wKP1CtCbD9hGu+88g16FeKnQ+zsQc2k+TIx99dY/bNpboXwLvaeLL63l6xye?=
 =?us-ascii?Q?1Dpx2zk8tVCKCKPcV/CYfeSXseXoKMm3w6us97av/k/O6+tNzNI8YRhO+F97?=
 =?us-ascii?Q?B1LBBif5Dr7XDO0WKRFRN6tso4TytjsYlw3QaxtncSUnONxylwP9LbqNZiQX?=
 =?us-ascii?Q?lwET6iTN5u27x9jBaGpmSSN78KFrA+qcVW6BQCXcqmwrStSJIgESVNaSLV8w?=
 =?us-ascii?Q?HCV3dfzsIq2GAh3t5jNKKEX6Z4LiSFgCvL2N6tF2otZ9Dv18upb6pERB8Aop?=
 =?us-ascii?Q?GVJfooIDX+WngEO/M2NEMHAYW2SC5NtPE5gePSIiturBwSBvKGYJYt02yfaW?=
 =?us-ascii?Q?KG8tMM3QnQpYNaj774nwTttVC+2lSLOO4d9mkunqGx5znz73u0Kke0/lrUcX?=
 =?us-ascii?Q?IqMRU95AJ4ey5I8HaDTVXBpfdqHYd6Z4A0EGAgQyZhLN21bdXytbYCsgKbGl?=
 =?us-ascii?Q?Wgnvvxbz/Z6SdJGtOivpguyEGHluOyYx6YclXonCK9YdSGxjdALdW+NiBpwe?=
 =?us-ascii?Q?dU1th/uk663a2a9M62YO+QKWUqNqZprcJJMyBcHx+7OPKxJa59kSJfN0joZg?=
 =?us-ascii?Q?yHG12+mMFR6V8KaOrK/6O1jeu7b9gXa66ThNXi7oVcvdf+rCkxpg2Vmff2Qb?=
 =?us-ascii?Q?doTI2eklbYXT4+le/GpXQLdl3E1TKjCCO7cs/CA8oPJc5ohWNvFijO1Ie+nE?=
 =?us-ascii?Q?G+0nrWCPD0R07114d9aF/S+ytCe113k3LT+4E6bbz1WnKvK6FGCtWp3xoyif?=
 =?us-ascii?Q?DsEC2Uq+xhe3AafbbD2Ul13zcW504W+DN17Kq0h1wM2cBgw+xmNlY7ccKS/Y?=
 =?us-ascii?Q?fcHLq/ImRNNej4r72Z2wQok0AProDftBHDCnqaBGV+5xU9zqitL0m+EI6cuB?=
 =?us-ascii?Q?sI7hf7i5v5SbVBRyeQm6ewFuP2o2WKud6AfPStWU7B4BXr4sscouZ3bUfyhN?=
 =?us-ascii?Q?GHhCbjvOyEI9L8cfA6SGqNUdFrWaUA73Xera6KfNd47eTOu7iXgK6KUDoaPo?=
 =?us-ascii?Q?YtczWjWPsD1cHqrDoU6bs+nKjhcWTahYErxryVWDrfhp8AzTSEIRBhfmoI2V?=
 =?us-ascii?Q?mBPMB7ufgPnfltV37d7mxmgENpPdyMC7/STaT4cvljSzt4LqMEY8QRWN/8vk?=
 =?us-ascii?Q?sGIJ1DBZmfp/BYo2qSDICDZdPiMMJ1OztUvT4V8PKV87UZj4HVZACRNFxl7c?=
 =?us-ascii?Q?j9+/zdqYYByBe2p1GOECXdqePb5KKMzXfJj4yWZ4sriktQXdZ2jzmajJ1qB6?=
 =?us-ascii?Q?14HhDJ8gmZPYvjOXJJhSBrDWDyKHNH60WbxnV5jgTk6UlJQCExQQBVCDOGyM?=
 =?us-ascii?Q?7DsQKeBllWBrplz04i2dzo34Pq6oIEg=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b26e039-c108-4e81-2b2c-08da26fb7e1d
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2022 20:38:02.3489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HA5ZYpF+MfIf47wePPUCLmVWJEA/mYdEyicO4UY192kjipyfwMUxVoCelQVHPAYs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1551
X-Proofpoint-ORIG-GUID: kg2iLTv05B_B-eP4_tvpOG7kmmO7Z_GO
X-Proofpoint-GUID: kg2iLTv05B_B-eP4_tvpOG7kmmO7Z_GO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-25_10,2022-04-25_03,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 20, 2022 at 03:30:43PM -0700, Stanislav Fomichev wrote:
> On Wed, Apr 20, 2022 at 3:04 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Tue, Apr 19, 2022 at 3:23 PM Stanislav Fomichev <sdf@google.com> wrote:
> > >
> > > Rename bpf_prog_run_array_cg_flags to bpf_prog_run_array_cg and
> > > use it everywhere. check_return_code already enforces sane
> > > return ranges for all cgroup types. (only egress and bind hooks have
> > > uncanonical return ranges, the rest is using [0, 1])
> > >
> > > No functional changes.
> > >
> > > Suggested-by: Alexei Starovoitov <ast@kernel.org>
> > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > ---
> > >  include/linux/bpf-cgroup.h |  8 ++---
> > >  kernel/bpf/cgroup.c        | 70 ++++++++++++--------------------------
> > >  2 files changed, 24 insertions(+), 54 deletions(-)
> > >
> > > diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
> > > index 88a51b242adc..669d96d074ad 100644
> > > --- a/include/linux/bpf-cgroup.h
> > > +++ b/include/linux/bpf-cgroup.h
> > > @@ -225,24 +225,20 @@ static inline bool cgroup_bpf_sock_enabled(struct sock *sk,
> > >
> > >  #define BPF_CGROUP_RUN_SA_PROG(sk, uaddr, atype)                                      \
> > >  ({                                                                            \
> > > -       u32 __unused_flags;                                                    \
> > >         int __ret = 0;                                                         \
> > >         if (cgroup_bpf_enabled(atype))                                         \
> > >                 __ret = __cgroup_bpf_run_filter_sock_addr(sk, uaddr, atype,     \
> > > -                                                         NULL,                \
> > > -                                                         &__unused_flags);    \
> > > +                                                         NULL, NULL);         \
> > >         __ret;                                                                 \
> > >  })
> > >
> > >  #define BPF_CGROUP_RUN_SA_PROG_LOCK(sk, uaddr, atype, t_ctx)                  \
> > >  ({                                                                            \
> > > -       u32 __unused_flags;                                                    \
> > >         int __ret = 0;                                                         \
> > >         if (cgroup_bpf_enabled(atype))  {                                      \
> > >                 lock_sock(sk);                                                 \
> > >                 __ret = __cgroup_bpf_run_filter_sock_addr(sk, uaddr, atype,     \
> > > -                                                         t_ctx,               \
> > > -                                                         &__unused_flags);    \
> > > +                                                         t_ctx, NULL);        \
> > >                 release_sock(sk);                                              \
> > >         }                                                                      \
> > >         __ret;                                                                 \
> > > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> > > index 0cb6211fcb58..f61eca32c747 100644
> > > --- a/kernel/bpf/cgroup.c
> > > +++ b/kernel/bpf/cgroup.c
> > > @@ -25,50 +25,18 @@ EXPORT_SYMBOL(cgroup_bpf_enabled_key);
> > >  /* __always_inline is necessary to prevent indirect call through run_prog
> > >   * function pointer.
> > >   */
> > > -static __always_inline int
> > > -bpf_prog_run_array_cg_flags(const struct cgroup_bpf *cgrp,
> > > -                           enum cgroup_bpf_attach_type atype,
> > > -                           const void *ctx, bpf_prog_run_fn run_prog,
> > > -                           int retval, u32 *ret_flags)
> > > -{
> > > -       const struct bpf_prog_array_item *item;
> > > -       const struct bpf_prog *prog;
> > > -       const struct bpf_prog_array *array;
> > > -       struct bpf_run_ctx *old_run_ctx;
> > > -       struct bpf_cg_run_ctx run_ctx;
> > > -       u32 func_ret;
> > > -
> > > -       run_ctx.retval = retval;
> > > -       migrate_disable();
> > > -       rcu_read_lock();
> > > -       array = rcu_dereference(cgrp->effective[atype]);
> > > -       item = &array->items[0];
> > > -       old_run_ctx = bpf_set_run_ctx(&run_ctx.run_ctx);
> > > -       while ((prog = READ_ONCE(item->prog))) {
> > > -               run_ctx.prog_item = item;
> > > -               func_ret = run_prog(prog, ctx);
> > > -               if (!(func_ret & 1) && !IS_ERR_VALUE((long)run_ctx.retval))
> > > -                       run_ctx.retval = -EPERM;
> > > -               *(ret_flags) |= (func_ret >> 1);
> > > -               item++;
> > > -       }
> > > -       bpf_reset_run_ctx(old_run_ctx);
> > > -       rcu_read_unlock();
> > > -       migrate_enable();
> > > -       return run_ctx.retval;
> > > -}
> > > -
> > >  static __always_inline int
> > >  bpf_prog_run_array_cg(const struct cgroup_bpf *cgrp,
> > >                       enum cgroup_bpf_attach_type atype,
> > >                       const void *ctx, bpf_prog_run_fn run_prog,
> > > -                     int retval)
> > > +                     int retval, u32 *ret_flags)
> > >  {
> > >         const struct bpf_prog_array_item *item;
> > >         const struct bpf_prog *prog;
> > >         const struct bpf_prog_array *array;
> > >         struct bpf_run_ctx *old_run_ctx;
> > >         struct bpf_cg_run_ctx run_ctx;
> > > +       u32 func_ret;
> > >
> > >         run_ctx.retval = retval;
> > >         migrate_disable();
> > > @@ -78,8 +46,11 @@ bpf_prog_run_array_cg(const struct cgroup_bpf *cgrp,
> > >         old_run_ctx = bpf_set_run_ctx(&run_ctx.run_ctx);
> > >         while ((prog = READ_ONCE(item->prog))) {
> > >                 run_ctx.prog_item = item;
> > > -               if (!run_prog(prog, ctx) && !IS_ERR_VALUE((long)run_ctx.retval))
> > > +               func_ret = run_prog(prog, ctx);
> > > +               if (!(func_ret & 1) && !IS_ERR_VALUE((long)run_ctx.retval))
> >
> > to be completely true to previous behavior, shouldn't there be
> >
> > if (ret_flags)
> >     func_ret &= 1;
> > if (!func_ret && !IS_ERR_VALUE(...))
> >
> > here?
> >
> > This might have been discussed previously and I missed it. If that's
> > so, please ignore.
> 
> We are converting the cases where run_prog(prog, ctx) returns 0 or 1,
> so it seems like we don't have to reproduce the existing behavior
> 1-to-1?
> So I'm not sure it matters, or am I missing something?
A nit, how about testing 'if (ret_flags)' first such that
it is obvious which case will use higher bits in the return value.
The compiler may be able to optimize the ret_flags == NULL case also ?

Something like:

	func_ret = run_prog(prog, ctx);
	/* The cg bpf prog uses the higher bits of the return value */
	if (ret_flags) {
		*(ret_flags) |= (func_ret >> 1);
		func_ret &= 1;
	}
	if (!func_ret && !IS_ERR_VALUE((long)run_ctx.retval))
		run_ctx.retval = -EPERM;

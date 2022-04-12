Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 693AC4FE7B7
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 20:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358673AbiDLSQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 14:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358672AbiDLSQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 14:16:34 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AFAE13DE8;
        Tue, 12 Apr 2022 11:14:13 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23CHqPMh030787;
        Tue, 12 Apr 2022 11:13:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=GfD1eX+u667TggRhzxUucn9C4n3QZ2txuPw2LGUvzIg=;
 b=fpuoCTt3WsZZ2Z37BGqXWQOt2srR9ftmQdmvpugjBLk+nEMHnCgSa7xdqEO8+LiZ1KjL
 KmRX8gUOx+P0eWJCqDp29Vb/2jcGrOtI3xPVH/ClnUJlTUmellPszVaQuQCrQ9VmpXvP
 6lpjFD5vYQfRN4TRL040LX5k+TAHSPRm4eI= 
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2042.outbound.protection.outlook.com [104.47.74.42])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fdd410qe8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 11:13:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nFSc0H04uqr6fmsyMOC8M5uJAmXaR+4ruiADgSlN7Mcjdy/WzDCmCP8plnToQgS/Se1ZkNyttbKTxI25zhrHjRYivnyDPQjrzPG29YqL/ZpqzIfkTjyELi4tbO1/g5KrXIL4TLVoAkV520/T4RRgGoeg8zRvctSYJ8E5XYYLUsnRSTtrjdGBu7DqjQLIaQAPqzC7VqC41+TF+HcfU8rChxJIxQml9kGi+9Ltm/j+aNC3IrxlhqwOqfkUo619tEdlT71kuB63zxNLO+d08c4S1+N+K05x4wIRdX49LCfH2d/T8dWFWw/yB/szrwwZteAJEeqbhFjymtqyTK5HnB3hkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GfD1eX+u667TggRhzxUucn9C4n3QZ2txuPw2LGUvzIg=;
 b=WLLVWAOScNDq4s4QorvEU//wW525nZ+aZU42nRYnSlHFsnQeAAT6+bs9aWMe4bwQS1goZWHo5FBMMWg5H0X3mnJI3PF3k8OVM/9ao8pEwjhqj3UvXqdLDrYtn1P12LUFL3aAmJpZ22sXRJreDgCaOYsoKeHCvEWXYyp6J62hj0Tdfvymoh2+BR+kk6o3AqmYtkNlVU1aOiwTxRAxrWE2CcXLX3AIy5gKDSUHHguT6UYgiyFcj4CesjtdeMOL5++rQ63z4CgAkGV9ZwmFQqOuy2cP3zJo2oP0Sej9LoMQzCKHmiaXExkvJVW+8AFG9hXMZQTunmU3680g9TQJauzWJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by MW3PR15MB4058.namprd15.prod.outlook.com (2603:10b6:303:4c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 18:13:55 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::100b:5604:7f1e:e983]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::100b:5604:7f1e:e983%5]) with mapi id 15.20.5144.030; Tue, 12 Apr 2022
 18:13:55 +0000
Date:   Tue, 12 Apr 2022 11:13:53 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v3 3/7] bpf: minimize number of allocated lsm
 slots per program
Message-ID: <20220412181353.zgyl2oy4vl3uyigl@kafai-mbp.dhcp.thefacebook.com>
References: <20220407223112.1204582-1-sdf@google.com>
 <20220407223112.1204582-4-sdf@google.com>
 <20220408225628.oog4a3qteauhqkdn@kafai-mbp.dhcp.thefacebook.com>
 <CAKH8qBuMMuuUJiZJY8Gb+tMQLKoRGpvv58sSM4sZXjyEc0i7dA@mail.gmail.com>
 <20220412013631.tntvx7lw3c7sw6ur@kafai-mbp.dhcp.thefacebook.com>
 <CAKH8qBvCNVwEmoDyWvA5kEuNkCuVZYtf7RVL4AMXAsMr7aQDZA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKH8qBvCNVwEmoDyWvA5kEuNkCuVZYtf7RVL4AMXAsMr7aQDZA@mail.gmail.com>
X-ClientProxiedBy: BYAPR07CA0022.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::35) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d8804922-4c86-462c-8efa-08da1cb034cc
X-MS-TrafficTypeDiagnostic: MW3PR15MB4058:EE_
X-Microsoft-Antispam-PRVS: <MW3PR15MB40588D715A77234264CC0631D5ED9@MW3PR15MB4058.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b6jcnQSprGU2+X0h1GNb6NAvYkcLs0lnf2yzRUUl9rpLIGrw+gtgHXk3vWJZw8krqSK5MVJ0fsyPBF2AQWX8APtm+4HCrw3eTfYe60xi0K4Hzzu60joB1PGJ94MRmsNB96ezNIM5roHSuOQluntFvkUmxuvr9Gvnx0I8lrLCFv8o6BvU7nPiCpsJmDXU/s8eYfsKBXQpvPYhzSeEqf0nJmEStMBqwcBbLR0mWHlqJHhl9JEGf7/K1kXtqv2Tubo9jOPeubpUbMukdrJnqYUYss/68o4N9NUwfaQE1YzNDusuG6MJXhfzuvyZXOYPEMJaO6WXxmVA0f+lXIpgMq3IfciAydNxstZNskCHohmu1cvfmrDlu73u1Np3GRRTb1xs0uO0OM+ymCa++LU6QphKkjv5JN/amWPsJ0HoUHL+x8pAuqlH2n839QPMLHaJExtl7DSxufTO/oqVn8w57j0FRmXkvOFj2cg1flwZYUIH6DkC3M87Y/Lac53UubBBm22cw/w2UzKicRFD1eBQsQ/zYJvQMAJIDLw3igqSerAl1MRqpFuMfVx0rq8N5xVmMuaAtA2TjRECJSMFl4D61g6x8znoIQtSuee3jT2SaOaya6Zc9Nc1/buJZlz6+ik8YSIy2ogkSs2m1duJnfLOVy4ddA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(86362001)(66946007)(66476007)(66556008)(6916009)(83380400001)(508600001)(52116002)(38100700002)(53546011)(9686003)(6512007)(6506007)(1076003)(4326008)(8676002)(6486002)(8936002)(2906002)(5660300002)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oOdRDoEkQ8I1PZf0KRbnzQSUTHsixbi/jyBSyQjtxEIHd4f6m2qE6lFZhzRL?=
 =?us-ascii?Q?TT7XwXVol2+LZjjLv6wX8SUSfxWyOxauAoFt+PQqhkY+kGrbUVjieOAZFZho?=
 =?us-ascii?Q?NRt/jw4gZqDUOr8h/3d4fiI1oka5NCLF2yP7JQ+mF8ehC3DqC0p9nkfHZDeb?=
 =?us-ascii?Q?Gkru70M/DlPUN//p8SxFA2Ctv0IBsu67tvXA+l7U1SFKqlA2WJ6Jbo5dT7RN?=
 =?us-ascii?Q?pUY0oinmKaasMbrdeoml8iyrIFNdqSRmwk56N9z44TxRqzcu6gh92hF69iKh?=
 =?us-ascii?Q?x4O/Gc1a0EXuIr+9LQhvrwF0BKmj1704b5fNtRt2CJZIM63cri14giPeZ+dM?=
 =?us-ascii?Q?I7egPHP1BPDaATTlUuDr9/IXqrayaPUxXW0HiSsoNco7Betz0wziCgKXnQrB?=
 =?us-ascii?Q?vhks56hlrtbXGRocqLMoaXCEy1flyspi6p/Nib+xYcowOCRmg3LIF6TTPboV?=
 =?us-ascii?Q?wamoEILoXbRmjs2vNvgSMC56V8hKLB8NgSVGGqpbl5CZRKV3CDbZ6xz5Hu1S?=
 =?us-ascii?Q?tlM556Z4axxgjBF8cd0enpLd+CeTe2IOB8et/MIEU8x5Ji5nR7iJBN+oBXIf?=
 =?us-ascii?Q?gup/K+iNZSFcHCT5WNcLsHRw2BQoMZb9HTvX9qibIlcXOWfsGPvqJNg9g765?=
 =?us-ascii?Q?Wl5Vv13Nw400JiUOjqgTV/1aC+SiZdWPB4MO+18oVfH+K7NRDkhcpnupemvt?=
 =?us-ascii?Q?HWJH/FNr+JEAqew5EKCepkKFE6i4zDmuwQzugmWNCTIRr6YgyQEs8wu5JL/S?=
 =?us-ascii?Q?tNcJf6/7K2n4le8u2XQvfyrwCkdXM+ljENR5izZyxNvEjoJ8t1H8WykWweoY?=
 =?us-ascii?Q?iw60E/D2vwpHAn81M9UNtjJnZQYa6UP6KS+RgdOOiiNabrm0saoTeh5IDb1f?=
 =?us-ascii?Q?d4kQwj9NaDEDsIiwjafnlPFDkX9N4dcyLl247bpWxHGEszpcD3Y1soxes9Cr?=
 =?us-ascii?Q?dzIyju9PRLrP6+MZlZUPNGY1fz0fe8EEgYVY69r7iyMagdaHJwV8jLoNH47C?=
 =?us-ascii?Q?QuXcEUOxzirXgrGMNTtBs9KJX9NvXQUjUljf59sGv7nof7FmeCQvQ7vcR3vk?=
 =?us-ascii?Q?RRb5haQKpPtCxH4cQ5yYddYECWV6hQogxDmi5+xSEku+wD8Hd4/rOZqIFHz7?=
 =?us-ascii?Q?WfBibmJEprC2QxaK3lYbuj9ljy4L1Q00tT/amR0rsyPY9pxq7NdlCFFELr1M?=
 =?us-ascii?Q?+lkHNQKa6d2BajV7XgXgWY2OqR2sz7ypMriWbm0vkVOHy5ArYpwXweTcacXN?=
 =?us-ascii?Q?7djwx8P8AN0dY+32/5Q5osoTxX5q7fPcAe2J6VvwA9E7vWW9Xgp0FztPOQlN?=
 =?us-ascii?Q?/ZLpFpWIMbeMbhUbOlb5mKo8EX3oo2Mn1UQoYwH5dnmGACP0Oq2lWSsJWZjt?=
 =?us-ascii?Q?8GqvZNTdsuNKIwcr7Ijxs0AIga5JP+/VTfJU6rXTBNgGHcwheZtP4Ibfr29A?=
 =?us-ascii?Q?aLxLJTU70SUl+90qUXQkjhrwzK1pyusnD1UcX3crnpZ7oLJopxyQ5vkVq6+C?=
 =?us-ascii?Q?f45++cxKlqhTFsFn1VYsXmj61lNIy2p9YnYzju0GmNoVwcBouku8vBkHJtS8?=
 =?us-ascii?Q?+A66EJqV57JlqZNIOUcmif8zVV6D1s10sR7QkoftuoHD56k0tlb2hzMNwt5q?=
 =?us-ascii?Q?pHfPcJXwWFYfkPQ6csrTI55t8zd01UlXfUPtiU3cc9sxyczCuyuN8CwyoJgR?=
 =?us-ascii?Q?5sJDgyTIj107iXZ0BXwPTt13igPRnBH2mxBxb8jHfUKopowKAsIKtWBgqA4K?=
 =?us-ascii?Q?TlXOBYFDzI20Q8oRznGWOPXFmgBQWZk=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8804922-4c86-462c-8efa-08da1cb034cc
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 18:13:55.3239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: njyWcUlSPfigdEwK4LIpAcwxKpP96uryqMJTUU/nMOCICsdlMMpMdobPPIZB271a
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB4058
X-Proofpoint-ORIG-GUID: gcN1SGCwnItzbvk4NjJkGVYTpcB4Z_OQ
X-Proofpoint-GUID: gcN1SGCwnItzbvk4NjJkGVYTpcB4Z_OQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-12_06,2022-04-12_02,2022-02-23_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 12, 2022 at 09:42:40AM -0700, Stanislav Fomichev wrote:
> On Mon, Apr 11, 2022 at 6:36 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Mon, Apr 11, 2022 at 11:46:20AM -0700, Stanislav Fomichev wrote:
> > > On Fri, Apr 8, 2022 at 3:57 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > >
> > > > On Thu, Apr 07, 2022 at 03:31:08PM -0700, Stanislav Fomichev wrote:
> > > > > Previous patch adds 1:1 mapping between all 211 LSM hooks
> > > > > and bpf_cgroup program array. Instead of reserving a slot per
> > > > > possible hook, reserve 10 slots per cgroup for lsm programs.
> > > > > Those slots are dynamically allocated on demand and reclaimed.
> > > > > This still adds some bloat to the cgroup and brings us back to
> > > > > roughly pre-cgroup_bpf_attach_type times.
> > > > >
> > > > > It should be possible to eventually extend this idea to all hooks if
> > > > > the memory consumption is unacceptable and shrink overall effective
> > > > > programs array.
> > > > >
> > > > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > > > ---
> > > > >  include/linux/bpf-cgroup-defs.h |  4 +-
> > > > >  include/linux/bpf_lsm.h         |  6 ---
> > > > >  kernel/bpf/bpf_lsm.c            |  9 ++--
> > > > >  kernel/bpf/cgroup.c             | 96 ++++++++++++++++++++++++++++-----
> > > > >  4 files changed, 90 insertions(+), 25 deletions(-)
> > > > >
> > > > > diff --git a/include/linux/bpf-cgroup-defs.h b/include/linux/bpf-cgroup-defs.h
> > > > > index 6c661b4df9fa..d42516e86b3a 100644
> > > > > --- a/include/linux/bpf-cgroup-defs.h
> > > > > +++ b/include/linux/bpf-cgroup-defs.h
> > > > > @@ -10,7 +10,9 @@
> > > > >
> > > > >  struct bpf_prog_array;
> > > > >
> > > > > -#define CGROUP_LSM_NUM 211 /* will be addressed in the next patch */
> > > > > +/* Maximum number of concurrently attachable per-cgroup LSM hooks.
> > > > > + */
> > > > > +#define CGROUP_LSM_NUM 10
> > > > hmm...only 10 different lsm hooks (or 10 different attach_btf_ids) can
> > > > have BPF_LSM_CGROUP programs attached.  This feels quite limited but having
> > > > a static 211 (and potentially growing in the future) is not good either.
> > > > I currently do not have a better idea also. :/
> > > >
> > > > Have you thought about other dynamic schemes or they would be too slow ?
> > > >
> > > > >  enum cgroup_bpf_attach_type {
> > > > >       CGROUP_BPF_ATTACH_TYPE_INVALID = -1,
> > > > > diff --git a/include/linux/bpf_lsm.h b/include/linux/bpf_lsm.h
> > > > > index 7f0e59f5f9be..613de44aa429 100644
> > > > > --- a/include/linux/bpf_lsm.h
> > > > > +++ b/include/linux/bpf_lsm.h
> > > > > @@ -43,7 +43,6 @@ extern const struct bpf_func_proto bpf_inode_storage_delete_proto;
> > > > >  void bpf_inode_storage_free(struct inode *inode);
> > > > >
> > > > >  int bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog, bpf_func_t *bpf_func);
> > > > > -int bpf_lsm_hook_idx(u32 btf_id);
> > > > >
> > > > >  #else /* !CONFIG_BPF_LSM */
> > > > >
> > > > > @@ -74,11 +73,6 @@ static inline int bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog,
> > > > >       return -ENOENT;
> > > > >  }
> > > > >
> > > > > -static inline int bpf_lsm_hook_idx(u32 btf_id)
> > > > > -{
> > > > > -     return -EINVAL;
> > > > > -}
> > > > > -
> > > > >  #endif /* CONFIG_BPF_LSM */
> > > > >
> > > > >  #endif /* _LINUX_BPF_LSM_H */
> > > > > diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
> > > > > index eca258ba71d8..8b948ec9ab73 100644
> > > > > --- a/kernel/bpf/bpf_lsm.c
> > > > > +++ b/kernel/bpf/bpf_lsm.c
> > > > > @@ -57,10 +57,12 @@ static unsigned int __cgroup_bpf_run_lsm_socket(const void *ctx,
> > > > >       if (unlikely(!sk))
> > > > >               return 0;
> > > > >
> > > > > +     rcu_read_lock(); /* See bpf_lsm_attach_type_get(). */
> > > > >       cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
> > > > >       if (likely(cgrp))
> > > > >               ret = BPF_PROG_RUN_ARRAY_CG(cgrp->bpf.effective[prog->aux->cgroup_atype],
> > > > >                                           ctx, bpf_prog_run, 0);
> > > > > +     rcu_read_unlock();
> > > > >       return ret;
> > > > >  }
> > > > >
> > > > > @@ -77,7 +79,7 @@ static unsigned int __cgroup_bpf_run_lsm_current(const void *ctx,
> > > > >       /*prog = container_of(insn, struct bpf_prog, insnsi);*/
> > > > >       prog = (const struct bpf_prog *)((void *)insn - offsetof(struct bpf_prog, insnsi));
> > > > >
> > > > > -     rcu_read_lock();
> > > > > +     rcu_read_lock(); /* See bpf_lsm_attach_type_get(). */
> > > > I think this is also needed for task_dfl_cgroup().  If yes,
> > > > will be a good idea to adjust the comment if it ends up
> > > > using the 'CGROUP_LSM_NUM 10' scheme.
> > > >
> > > > While at rcu_read_lock(), have you thought about what major things are
> > > > needed to make BPF_LSM_CGROUP sleepable ?
> > > >
> > > > The cgroup local storage could be one that require changes but it seems
> > > > the cgroup local storage is not available to BPF_LSM_GROUP in this change set.
> > > > The current use case doesn't need it?
> > >
> > > No, I haven't thought about sleepable at all yet :-( But seems like
> > > having that rcu lock here might be problematic if we want to sleep? In
> > > this case, Jakub's suggestion seems better.
> > The new rcu_read_lock() here seems fine after some thoughts.
> >
> > I was looking at the helpers in cgroup_base_func_proto() to get a sense
> > on sleepable support.  Only the bpf_get_local_storage caught my eyes for
> > now because it uses a call_rcu to free the storage.  That will be the
> > major one to change for sleepable that I can think of for now.
> 
> That rcu_read_lock should be switched over to rcu_read_lock_trace in
> the sleepable case I'm assuming? Are we allowed to sleep while holding
> rcu_read_lock_trace?
Ah. right, suddenly forgot the obvious in between emails :(

In that sense, may as well remove the rcu_read_lock() here and let
the trampoline to decide which one (rcu_read_lock or rcu_read_lock_trace)
to call before calling the shim_prog.  The __bpf_prog_enter(_sleepable) will
call the right rcu_read_lock(_trace) based on the prog is sleepable or not.

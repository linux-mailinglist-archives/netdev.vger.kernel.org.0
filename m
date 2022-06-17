Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFD3154FFF3
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 00:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236241AbiFQWa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 18:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383333AbiFQWaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 18:30:13 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35E8266217;
        Fri, 17 Jun 2022 15:30:02 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 25HLhZou018452;
        Fri, 17 Jun 2022 15:29:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=JkjA+rxk4Ql7EfDSdXGQAY7GYJ5Vqi1p8W7WprrMfc8=;
 b=PuCcW5WbOs4CtzLDMrfh1IkcWWEx9LNFkHvCAP0wfYS4mHk+2dyXXLuPdNiPESFOodjy
 hSxLCcBC1KOrluRtkw4cl5EGzuq4tqgrellnMyzlB95tU2JXBvarvR8VpiBU+7LT0Xa2
 PidEw+RP+ZHQQ3VC3zTW9ZI3RAQhv1/hBR8= 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by m0001303.ppops.net (PPS) with ESMTPS id 3grkew56sa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Jun 2022 15:29:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RGh/m/7iijNjlOjaTJkO3I2o9Sg7vWPv1naO6fCN1vkgx1lbYpeizvPjaY+DlleFASgwEpA0jVXpk8s5g31gYYpL2zUniUuJTUCRRXCgcVB/1zmoDwWh6leN1mkJ4JiMW7k7aa1TVk3YCta+npOGZkidZ4gTTC2F52Zn+2nSoTcI2L9LGAJnfq3VuY5vcKdelOs62pyhEpU25ZWPFDETlXvqdGLvDQxfGp+EM6DXl1kgqbZOGhy7+FGy7tnRyKOBbt+YfL+yU1ncXhUYSOrgUydNc4z49GaKNGugeBGvA9kbAWvAUTgmlwt8J2cR6vXQcdZwVp5CEcYORZ9LphlbhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JkjA+rxk4Ql7EfDSdXGQAY7GYJ5Vqi1p8W7WprrMfc8=;
 b=C0Wim0qid8ZFgH0gNx/pUyXLKWQl0qFUH+ff0kSqKhojSMqew+At1pjm6V1VHE7udBUJIjtaH7+GRFUOchpXLq5W4jEEl1bKalr87HBW9mFpuInlnQRB60g/gxFmzTzs/QRF+m0Qk7J4VFc/ggbgk3Kf4hC/UJ9MtHQx8uAX5E/chekxSxDtq0xhXucMFDt7HkRLtTiYoFjjNtU1iTwdNRo/XRRtmp5CeeCF4LZC98Em4CojLA4cNcf8Ydzr+KdKmApKr9ZlbXbwxyxfqn4qKYoWZkQpKd0Byu9In1kK06eO+YNdqbjJ1pBkUQWUkmOSIbL0ETEUrMYihW2Co6vEjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by CY4PR15MB1224.namprd15.prod.outlook.com (2603:10b6:903:10d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Fri, 17 Jun
 2022 22:29:45 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762%6]) with mapi id 15.20.5353.017; Fri, 17 Jun 2022
 22:29:44 +0000
Date:   Fri, 17 Jun 2022 15:29:43 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v9 05/10] bpf: implement BPF_PROG_QUERY for
 BPF_LSM_CGROUP
Message-ID: <20220617222943.w4nqx4vgzhhliwls@kafai-mbp>
References: <20220610165803.2860154-1-sdf@google.com>
 <20220610165803.2860154-6-sdf@google.com>
 <20220617005829.66pboow5uubbrdcu@kafai-mbp>
 <CAKH8qBvzBHgouvRvXYpi66RoYbjXrmPXQwW9gsC3sk8J=VzBng@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKH8qBvzBHgouvRvXYpi66RoYbjXrmPXQwW9gsC3sk8J=VzBng@mail.gmail.com>
X-ClientProxiedBy: BYAPR05CA0055.namprd05.prod.outlook.com
 (2603:10b6:a03:74::32) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 078d936a-f293-4cfb-0624-08da50b0e11e
X-MS-TrafficTypeDiagnostic: CY4PR15MB1224:EE_
X-Microsoft-Antispam-PRVS: <CY4PR15MB12241B5E51D05D018BAA9604D5AF9@CY4PR15MB1224.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JpMzmgUXbO8hfN/OktLknZ81mIw1SFEbQgWyORUTV3iNmZtf3L4yCuRNWQzagjzQPdgqLmgngGS0xBoP5Gdmg7vyugEMASxvfjfVNxeoFRX8RRtSwsmfIiVvvYIrJNi/xaH5JE+KA7dzfyXrYwZsWLdoD380fRt6PZegIkJtkDIDQJpBALVwLMObt0PtgebMy8SJ/h/80XHCCJ4MOYoTeS0QK2mRm7FNKo8i3mpzpldx4fbhRVHPvpkmOtnbevZUcC1jmyu1J4Dg/yrkBkWasinAG9bMu/pS8vjvhPY7XzgAgh3TABgzYZFA7Ek0h1Rzqn5g9oq0q4XCveIHAxsM0bYChIH+m1PSe6TqN84Na/qCaysHdmO5KHG13O0tTC9L7KF12IQC8mZAem1TRi77dllXl73ktKnxMDzF2QuKww9Ye0dWIQM3+sZpm0AcMwO5xoI43NWsjKDlV7iU1THkmPZRKqjuV24UwC45tfFdwoK0uwR0YJAiPZoq295eZWHoPkpsTfUxtVFcHbY1fwb2CQswVQwm0WfzkA5eChgjS7kBcCOJlycShJmWy8BDi4b2sqHyBZfVuLdQlQAISGLHM3LDFPIBFTdG7Xd7IS3SI8sJC3INdJcMPF9FIfoOz1A5AQY2sW0S2rAkqx8C5axWTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(366004)(316002)(1076003)(83380400001)(66946007)(186003)(86362001)(66556008)(6916009)(66476007)(8676002)(4326008)(8936002)(33716001)(38100700002)(6506007)(2906002)(6512007)(498600001)(52116002)(9686003)(53546011)(5660300002)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?J+trEMwgj4CARHF9tDjzQ4s2z+fpxQkbbwYu0B0cpved3zfiLo7DeeQ5Eclk?=
 =?us-ascii?Q?QYsufIzFzxhBcjaLdYkzos/BuXrOeFHkWFM7jAlOQKAOVAPUYM73Fob28qeP?=
 =?us-ascii?Q?pIh0MmBcMlwnz1eCmmA7f95aEgYH5SRK4z9mp3m43xRAp6ufTDpGOLugugDm?=
 =?us-ascii?Q?IRphloT51d2B642Yvee0XtC6fq3Qy3jal+qMGFaABP172Rb+MjgTRklCf356?=
 =?us-ascii?Q?cHFKcjn0Tj9yUOMKy7gqejKJrktmQBUxtqFXNXzVV7RkdjFIBcrd5Qd4TKw8?=
 =?us-ascii?Q?FZ2dntPEWfTtIqazomI7fAGmeD3zmN9I1E9WjqscI7BZFnXNfGuvPbt1eIAS?=
 =?us-ascii?Q?mzgym8fqQC6GcymOzP1k0LnZbO0DV9Yz2i10JOLyMwClakzC2+mPpdR6GaJV?=
 =?us-ascii?Q?ePBskT5VzxrOh/2Ia/MchqugNfizFfS1oiXeHsDs9gSPFYkkhByKjoRwbUD5?=
 =?us-ascii?Q?Y2E3LS1bx8tr4lqH0l+b+EYqZD+9g1f8KjfgfQFT1FCyJHFCVQ616F5ggS8X?=
 =?us-ascii?Q?JueCrLweNL8DDyB7wTpQsmKfJCD9Y9LNdPjuTyauulaz1qP2fgFE+yYId4/W?=
 =?us-ascii?Q?FSDF/rvUB2+DuCeSm019KQkw09Qh69EeSngzCz04jZLMucwwMxO+s63qmshq?=
 =?us-ascii?Q?+JX7wRcKDZmIM70xabg9IMaa9DlBKJSSlcwTZ5EQfJN/JbQZs2EiTfz17RWq?=
 =?us-ascii?Q?huJgH/boBEJM3jJUdFrD/tK7lBuHaRrMq4y28E1m4+z8Hp6Y+hYy7CCOu8lJ?=
 =?us-ascii?Q?dZbRMskfa33xKR0TAV9+15/ktB1XBrVLzGsG0rp0om1lToBYVDsaktPiD/DI?=
 =?us-ascii?Q?efAano1N6f2gcNqUdyvuNVKVVv4e/6ky7EtUm7rOhBCYIy3iEQzoSsZmr8mG?=
 =?us-ascii?Q?xc0Vlkb8ORB8+6dvFQr78Q6ri4XSsqWhkcMoh2aw8tYOubIL78WeI0RvK6vE?=
 =?us-ascii?Q?ZoVnOAhxTF3PYHno6WWxyBdhR8/Q+64OE0q0juUa1vLUqt/ZKbFl4jiGWKeM?=
 =?us-ascii?Q?NeUnCvZHkK6l1cCpyjvXhNXJNWsM8cS/g1OngFaRJYniY+G3gNqQM3OGyPDL?=
 =?us-ascii?Q?oayI0UfqpqKq/xKO+5mtgpVEcfdEXh4s6ZHxmYRC3p81ViKgB9UHYyC1q3zx?=
 =?us-ascii?Q?FwvTWodnEzs1Zx/nvMRzFx3Elzjr8HqcEoGm1N9fKte9p5tekfYlaI6WhQ/j?=
 =?us-ascii?Q?p+lAplWIBJCnlWwEHMpnzh5I5nppuVrawgukKj1FNuYxJInqh9wnVihoQLSF?=
 =?us-ascii?Q?nMJXCXUDecJkSGg+Ti1eknfDdjBRHXcPYWVDA+pHTlVG+0pcP1NZRKi8abqy?=
 =?us-ascii?Q?RvgNxDXi+3XzfEaKubpx1byF87+uZWWN/S+jQrL6gK6357UBY7hJbZeUuBPI?=
 =?us-ascii?Q?5PozbO5BVqslFpP4/yAbp+YLYWoUDidJJQbbWJnx5YvJ1qBCGhx6y5A6vkO0?=
 =?us-ascii?Q?SHdjb17+8eEQP/bZn2d1vWEPf2qQwZrP5HPAtIo6YyQ6kz1DyQrNYBtZQeaG?=
 =?us-ascii?Q?eGB78Csf/EjBp0ghScN2vvkI9NjMCgzqr3x27UsCHM7GL58mZ4o3d5Hun5X7?=
 =?us-ascii?Q?We6nE+DxTTHcjFMvhyUfSzeuvQQJ/7u0mCwTVcEX3zduDuOTSJMYfgJDpRI5?=
 =?us-ascii?Q?vjSF66UAe0e9VxBfkeoVwFA8flaibh2ZlnWcwrITucYZbuUY3yV5Z+4D7kWs?=
 =?us-ascii?Q?Heb8BNzI+DHkiixVFUlo/xt0Hu8BUwHofnWHSahy6hmArwwLniMJ2oMj8i3b?=
 =?us-ascii?Q?/SiKDn4DkKuVwaO4LkMijhDTViJeFJw=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 078d936a-f293-4cfb-0624-08da50b0e11e
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 22:29:44.9059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h8WcOshORbSqAfP51WrHBDgT+VVK7iJkuhzlAJberbwETWqq0mpNdZAf155zN+sM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1224
X-Proofpoint-ORIG-GUID: Lot-b-_Sr3HbLhQKJZQhhjAtlzdgOJLu
X-Proofpoint-GUID: Lot-b-_Sr3HbLhQKJZQhhjAtlzdgOJLu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-17_14,2022-06-17_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 17, 2022 at 11:28:21AM -0700, Stanislav Fomichev wrote:
> On Thu, Jun 16, 2022 at 5:58 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Fri, Jun 10, 2022 at 09:57:58AM -0700, Stanislav Fomichev wrote:
> > > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> > > index ba402d50e130..c869317479ec 100644
> > > --- a/kernel/bpf/cgroup.c
> > > +++ b/kernel/bpf/cgroup.c
> > > @@ -1029,57 +1029,92 @@ static int cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
> > >  static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
> > >                             union bpf_attr __user *uattr)
> > >  {
> > > +     __u32 __user *prog_attach_flags = u64_to_user_ptr(attr->query.prog_attach_flags);
> > >       __u32 __user *prog_ids = u64_to_user_ptr(attr->query.prog_ids);
> > >       enum bpf_attach_type type = attr->query.attach_type;
> > > +     enum cgroup_bpf_attach_type from_atype, to_atype;
> > >       enum cgroup_bpf_attach_type atype;
> > >       struct bpf_prog_array *effective;
> > >       struct hlist_head *progs;
> > >       struct bpf_prog *prog;
> > >       int cnt, ret = 0, i;
> > > +     int total_cnt = 0;
> > >       u32 flags;
> > >
> > > -     atype = to_cgroup_bpf_attach_type(type);
> > > -     if (atype < 0)
> > > -             return -EINVAL;
> > > +     if (type == BPF_LSM_CGROUP) {
> > > +             if (attr->query.prog_cnt && prog_ids && !prog_attach_flags)
> > > +                     return -EINVAL;
> > >
> > > -     progs = &cgrp->bpf.progs[atype];
> > > -     flags = cgrp->bpf.flags[atype];
> > > +             from_atype = CGROUP_LSM_START;
> > > +             to_atype = CGROUP_LSM_END;
> > > +             flags = 0;
> > > +     } else {
> > > +             from_atype = to_cgroup_bpf_attach_type(type);
> > > +             if (from_atype < 0)
> > > +                     return -EINVAL;
> > > +             to_atype = from_atype;
> > > +             flags = cgrp->bpf.flags[from_atype];
> > > +     }
> > >
> > > -     effective = rcu_dereference_protected(cgrp->bpf.effective[atype],
> > > -                                           lockdep_is_held(&cgroup_mutex));
> > > +     for (atype = from_atype; atype <= to_atype; atype++) {
> > > +             progs = &cgrp->bpf.progs[atype];
> > nit. Move the 'progs = ...' into the 'else {}' case below.
> >
> > >
> > > -     if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE)
> > > -             cnt = bpf_prog_array_length(effective);
> > > -     else
> > > -             cnt = prog_list_length(progs);
> > > +             if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE) {
> > > +                     effective = rcu_dereference_protected(cgrp->bpf.effective[atype],
> > > +                                                           lockdep_is_held(&cgroup_mutex));
> > > +                     total_cnt += bpf_prog_array_length(effective);
> > > +             } else {
> > > +                     total_cnt += prog_list_length(progs);
> > > +             }
> > > +     }
> > >
> > >       if (copy_to_user(&uattr->query.attach_flags, &flags, sizeof(flags)))
> > >               return -EFAULT;
> > > -     if (copy_to_user(&uattr->query.prog_cnt, &cnt, sizeof(cnt)))
> > > +     if (copy_to_user(&uattr->query.prog_cnt, &total_cnt, sizeof(total_cnt)))
> > >               return -EFAULT;
> > > -     if (attr->query.prog_cnt == 0 || !prog_ids || !cnt)
> > > +     if (attr->query.prog_cnt == 0 || !prog_ids || !total_cnt)
> > >               /* return early if user requested only program count + flags */
> > >               return 0;
> > > -     if (attr->query.prog_cnt < cnt) {
> > > -             cnt = attr->query.prog_cnt;
> > > +
> > > +     if (attr->query.prog_cnt < total_cnt) {
> > > +             total_cnt = attr->query.prog_cnt;
> > >               ret = -ENOSPC;
> > >       }
> > >
> > > -     if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE) {
> > > -             return bpf_prog_array_copy_to_user(effective, prog_ids, cnt);
> > > -     } else {
> > > -             struct bpf_prog_list *pl;
> > > -             u32 id;
> > > +     for (atype = from_atype; atype <= to_atype && total_cnt; atype++) {
> > > +             progs = &cgrp->bpf.progs[atype];
> > same here.
> >
> > > +             flags = cgrp->bpf.flags[atype];
> > and the 'flags = ...' can be moved to 'if (prog_attach_flags) {}'
> >
> > Others lgtm.
> >
> > Reviewed-by: Martin KaFai Lau <kafai@fb.com>
> 
> Everything makes sense, will do, thanks!
> 
> Maybe we should also move "struct hlist_head *progs;" closer to the
> places where we use them? Same for "struct bpf_prog *prog;" which
> seems to be used only in one place.
Yep. SG. Thanks!

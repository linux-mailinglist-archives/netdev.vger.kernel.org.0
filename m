Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59E5C542028
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 02:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380411AbiFHASN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 20:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1448962AbiFGXJM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 19:09:12 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A3B7382E6A;
        Tue,  7 Jun 2022 13:45:12 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 257G3tnj007836;
        Tue, 7 Jun 2022 13:44:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=L0OCQGVWCJ2nHt8tzUxJ7J4SHDfBinktbM/KqKKmwMA=;
 b=DdT+xli/H/jdjx0IWdgX99Qdqwy2+SlBiGdIefkH3UQXxcD3uPIKzW5HkyvTaKRUzqiw
 rr8aKyS98U1A1gv9Cwm1WPorcXEZbh072JD70tto18Q+fT8yJtNV6G9tjc3lo6CDOZRL
 jHGSVQMdTqM8Ty9IsZSJvmyvfTQ/hTVmNgA= 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gj9djj8yf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jun 2022 13:44:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MSSWEIqw5JRmlRJWHC13c+MMZfuFX2ICjKPk6dhptdoQaYu744XQmijt8ZAzRM9T7hs7IOToUXcCA9fwm+tEADfxMQf7P9qrHVpurXlPmhvND15JbyWNYw7NyWJ0K3UkV5kV6K3N++D4hbhL+SpITEiJLz4UQOf3XoQGVFIcSfQPdIiGyfXvNFhNEPAo5qqdjbuYo0oG3WPmCiyb6o5ltQkJOOPeG5nG64xkng7hNIQQ8jVt7JvyaLAxnnIzXeAvUnbahfRc8U2i7BwTS3zxBwJ479cSDHLPq5q9eEMdcWWzMYbX5mcIQyuzctaWa3cNAlS/LBFeNw/odizMMld7+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L0OCQGVWCJ2nHt8tzUxJ7J4SHDfBinktbM/KqKKmwMA=;
 b=EVsvGnrAj+Qck6QZFXlYcFMCmYAPpIhIwbCkf85Ug08mqAh9qrYNgyzLc4b510532hGLku1R1KNMYFqnKGjBGuORQvIPjLcwdKuq7jEKwrZvHZTwKes3uRaChanyCMSbXlXAz2R4PwJ8E31hraxsWSreAkXpbiCOpFWzfYE57LsyRP+5qI3yHyBJGvKoLLQYRMVYQcD8CSGqnBU7QgUyXYvJXJANDB64HdJD1Fx1IEnBB9+Rzr1dN0db0tzSMlpA7LHSDovdvV0sVhEIL3kPgd0imtjdjEbhtx8j78Rlt4oeeKaeElWSaYpI5FFnHswWwdzcjizdEFyUGOCKH5ji1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by MN2PR15MB2573.namprd15.prod.outlook.com (2603:10b6:208:124::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.19; Tue, 7 Jun
 2022 20:44:19 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::a09e:da84:3316:6eb0]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::a09e:da84:3316:6eb0%9]) with mapi id 15.20.5314.019; Tue, 7 Jun 2022
 20:44:19 +0000
Date:   Tue, 7 Jun 2022 13:44:16 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v8 05/11] bpf: implement BPF_PROG_QUERY for
 BPF_LSM_CGROUP
Message-ID: <20220607204416.3zjqhwmh3i25u6ev@kafai-mbp>
References: <20220601190218.2494963-1-sdf@google.com>
 <20220601190218.2494963-6-sdf@google.com>
 <20220604065935.lg5vegzhcqpd5laq@kafai-mbp>
 <CAKH8qBvX2OL17pLNusN_W6q8GpoNs7X9=h9YMwsx7-2-QEer1g@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKH8qBvX2OL17pLNusN_W6q8GpoNs7X9=h9YMwsx7-2-QEer1g@mail.gmail.com>
X-ClientProxiedBy: SJ0PR13CA0061.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::6) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 484a76ec-a672-42e5-19cb-08da48c67e66
X-MS-TrafficTypeDiagnostic: MN2PR15MB2573:EE_
X-Microsoft-Antispam-PRVS: <MN2PR15MB25737794AA079608556C4997D5A59@MN2PR15MB2573.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F2Owt9gRvmWHZhbMjOEnI0zS1Ve5MnEhrEfVpUyZHmQq4U97Ikuz0gDYHnMNix4BzMk0k9TJdNZ0BVqeHbG7X9TbWhmCEmgjS6/dPUmoToCz8CBi/Ixkv+Fw6xyp1jYtJNKQkuhKd42inE8xob2+ptHP0rb2Z5Mn7FWT/E19wnjczOfYhMMTW08GOaeJEzacEwcoku4qcB/D0VEJxDXZg7rxmMqaO7WnVmpdnVIpx1bLCZjw+llGvzDOIAbLAku8irJbD6wPf7SKywS+8uPb3sVZTZc6OTpoIHg4sGMGM5tMaHBmMAeNrBjyhzzjAtBb91CqycrcTFa3Fyv3AK+xyllHqvw/i1+YPab+VpKii+hIEZFHdGegVU26b77TneXWkVVZBDbLn6s1m1cKMRGoAUryiTLOFetTk2MIh8mFso6EPgWQvq0pkafJfqMiX/5F8198MWXtI3mEjAqZivxFcRRCEroYFAYFRpYcS6gtduVVtADAkwBlQhgXBjmqbFHNFlHPUNzLXwI834wIHAGquSjNSy8AlakXIvuVOozlv2Cpl7XFP+5KORoJBkPwND2Oauz7SAq+LoaXm4cFD4hz+1Fu+AWdUzg8N9VappvdI/5btY4D0ZI8JbMuXw/y1XKXTgzhWDjWCoHXBOyPaPdL7A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(9686003)(316002)(6486002)(38100700002)(53546011)(86362001)(33716001)(1076003)(186003)(2906002)(6506007)(5660300002)(66476007)(66556008)(8676002)(4326008)(6666004)(8936002)(66946007)(6916009)(508600001)(83380400001)(52116002)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5t3+3mnOolFFbJ2F3nsWYLG4poyjwpbk/9zMa+GtqRTT9ItobAF7mOXwXMCt?=
 =?us-ascii?Q?z8K+FegXB6bBC4WMSxUfl3zLh6vr5b3n3NzlSpDXCnJtg5FavWmxePycLwyq?=
 =?us-ascii?Q?X/65cwbaHTtTVyxAImWiASPTMC1lTCiPyAG+NtHkRTNn5JfdZW6NY3GSBtPw?=
 =?us-ascii?Q?3fLeC2KHoW8eFGUnqlzS41Fqq+j5QJ3mAWtazjlrQ50gaiEw39ytlD4peGDz?=
 =?us-ascii?Q?rehjt8SHMFvJ1DSkUj9OMveAMgGxt5IJ7zIiYAFoJjetfh/3ISp6xNxHCSX6?=
 =?us-ascii?Q?XRo/mdpm/aGRS0E7tQY+Zk5sijXsZ9KLexf1tUuZ0gv3yNjVNBOhl6y/JPUC?=
 =?us-ascii?Q?SsK64uxSu06ay7htastZXlQmYDWja2+IRMGO6PnwYTx6YJqFNLIoOb74oUl9?=
 =?us-ascii?Q?MM5X6gx2ElWH0zXdH5wo9WsZj+l63JF2uLElGrgfwbSF83DlXmLsDi1KTGkK?=
 =?us-ascii?Q?fwx0zNDrB3jPNu6uDsTx3L10l50AZ9oQO1yQ9yOGNxePQ9GNdqvhHxTuZ2yh?=
 =?us-ascii?Q?YHmgahD2eEmqo0Nn76ezVR1OlGE1kkX9Y4jHOmkbvKl7WkHzTJuoce+F5FWj?=
 =?us-ascii?Q?kqpQFNYCaFuo0qjWximPqOxLLWROFBkMuaagQtq//Dd6tWIPjfVCdOQbi3Fq?=
 =?us-ascii?Q?hmVRpXmFO9LEfiJpVcw2r9gPX/Ao72Wk8zfKg8bo9q2cOqJAKQxvOnB7chQ+?=
 =?us-ascii?Q?qKS9smw/dSGfYqh1nf2bFTdvaDX7pZ+GwSg8Q94iIl2GPAGWxfKkYe8G73e+?=
 =?us-ascii?Q?r9T8y3gmYocQ9RhU62vLGSkIr7NkOXy/QPx0JwCUbI6EyTRck2/F0hhUrAST?=
 =?us-ascii?Q?AHJb6PpMZ79a6H38SbytKxBPDx1Q4PnAZs9eP06sYl//iOekXIyD9SU+8doz?=
 =?us-ascii?Q?xWXC+VMz45XewWbv0yKVEyFDOqI6US8eeoYK9XNq0KBCCfe55BVtYi09bWGY?=
 =?us-ascii?Q?qNrnr/IewoOHDbCWV+4ELisFgVKDG5JTifebuFndy9wRFT7D+XdpvxcZMz+K?=
 =?us-ascii?Q?mtHTQ1OTfnYPOHEXsHlK7x60g6PhmJRJLDG6aUlSMmfDo1qxqYs2N/vgy6Q1?=
 =?us-ascii?Q?pnE1FcdSROdKIL2NNo/3deIypH8LMmjyWhYCIm7n3JK9AU2qocFenVH2yVCX?=
 =?us-ascii?Q?A5oFdMVBZ0k2xu0areWeqcTdKe6Hrd1+wdBHvnxmxsWTbZ+Gog7ENAX7uu4d?=
 =?us-ascii?Q?cw5jm4RkxK41e0yNbpYmeDWjCFjfM/8w4w95AY0rJ3MV4vvXgZXfX2MZr+OU?=
 =?us-ascii?Q?2v1nr6Dg1SGD4GlZsoXMBAluD+Z3+gGJO59uwGSJtKVVseyD/AezX1iZTGEP?=
 =?us-ascii?Q?+y5mJkMDIX3UQQIesbwEDOSSz/dn34FkeDAYyAFWwXFWvcPf3MCeFHoovNqj?=
 =?us-ascii?Q?OayJLOmJw8f5siZTRgSFTucnFu4F9LEsbu75DrkLgynxR2XkjFtailOuu9AE?=
 =?us-ascii?Q?bUDgo07K9HKf3KB/aDY9sqcLwawMjWQK5+b3GYImdDTyo69pbEE46B2qc/FI?=
 =?us-ascii?Q?bdiNaTAVqwACX6gD4YDHbjHpzFIe8RaO93XsIO3PiwNV0pk/irGsw/osCkA8?=
 =?us-ascii?Q?I21066l5yrzi4t+w1dq3OMz76EGD4bkf59fR7UytKdlGjhy3sJW+yVxPw9HY?=
 =?us-ascii?Q?iGczBHOfGbinWpAuQqbAN2P1nuzkO7X87LKyaX72Rr7cQEoSB3vVyr7a/fKG?=
 =?us-ascii?Q?RQTiDOz7CDoQaaQLHr0wMEiKUI4RMg8OasZSbSH+xZtxbOiinivV7luZOjD0?=
 =?us-ascii?Q?csup7xKmO/SOZS8M6XjKkQqo92nRTgY=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 484a76ec-a672-42e5-19cb-08da48c67e66
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2022 20:44:19.1142
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kCzwd+Bu+fFH9+rYKnhIMN4UG4gualqaGCMd+V6/H7IH13nk3UzIr6B6eFxokJv3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2573
X-Proofpoint-GUID: vRYxbN-SgeQ-n250BlFDgb0Tdb7bMIsF
X-Proofpoint-ORIG-GUID: vRYxbN-SgeQ-n250BlFDgb0Tdb7bMIsF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-07_09,2022-06-07_02,2022-02-23_01
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 06, 2022 at 03:46:25PM -0700, Stanislav Fomichev wrote:
> On Fri, Jun 3, 2022 at 11:59 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Wed, Jun 01, 2022 at 12:02:12PM -0700, Stanislav Fomichev wrote:
> > > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> > > index a27a6a7bd852..cb3338ef01e0 100644
> > > --- a/kernel/bpf/cgroup.c
> > > +++ b/kernel/bpf/cgroup.c
> > > @@ -1035,6 +1035,7 @@ static int cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
> > >  static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
> > >                             union bpf_attr __user *uattr)
> > >  {
> > > +     __u32 __user *prog_attach_flags = u64_to_user_ptr(attr->query.prog_attach_flags);
> > >       __u32 __user *prog_ids = u64_to_user_ptr(attr->query.prog_ids);
> > >       enum bpf_attach_type type = attr->query.attach_type;
> > >       enum cgroup_bpf_attach_type atype;
> > > @@ -1042,50 +1043,92 @@ static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
> > >       struct hlist_head *progs;
> > >       struct bpf_prog *prog;
> > >       int cnt, ret = 0, i;
> > > +     int total_cnt = 0;
> > >       u32 flags;
> > >
> > > -     atype = to_cgroup_bpf_attach_type(type);
> > > -     if (atype < 0)
> > > -             return -EINVAL;
> > > +     enum cgroup_bpf_attach_type from_atype, to_atype;
> > >
> > > -     progs = &cgrp->bpf.progs[atype];
> > > -     flags = cgrp->bpf.flags[atype];
> > > +     if (type == BPF_LSM_CGROUP) {
> > > +             from_atype = CGROUP_LSM_START;
> > > +             to_atype = CGROUP_LSM_END;
> > Enforce prog_attach_flags for BPF_LSM_CGROUP:
> >
> >                 if (total_cnt && !prog_attach_flags)
> >                         return -EINVAL;
> 
> All the comments make sense, will apply. The only thing that I'll
> probably keep as is is the copy_to_user(flags) part. We can't move it
> above because it hasn't been properly initialized there.
Initialize earlier:

if (type == BPF_LSM_CGROUP)
{
	from_atype = CGROUP_LSM_START;
	to_atype = CGROUP_LSM_END;
	flags = 0;
} else {
	from_atype = to_cgroup_bpf_attach_type(type);
	if (from_atype < 0)
		 return -EINVAL;
	to_atype = from_atype;
	flags = cgrp->bpf.flags[to_atype];
}

if (copy_to_user(&uattr->query.attach_flags, &flags...))
	/* ... */

for (atype = from_atype; atype <= to_atype; atype++) {
	/* Figuring out total_cnt.
	 * No need to get the flags here.
	 /
}

> 
> What I think I'll do is:
> 
> if (atype != to_atype) /* exported via prog_attach_flags */
Check "from_atype != to_atype" and then reset flags back to 0?
Yeah, that will work.  I think in that case checking
BPF_LSM_CGROUP is more straight forward.

Also no strong opinion here.  was just thinking to avoid
multiple BPF_LSM_CGROUP checks because copying the flags
before and after the for-loop is the same.


>   flags = 0;
> copy_to_user(.., flags,..);

> 
> That seems to better describe why we're not doing it?
> 
> 
> > > +     } else {
> > > +             from_atype = to_cgroup_bpf_attach_type(type);
> > > +             if (from_atype < 0)
> > > +                     return -EINVAL;
> > > +             to_atype = from_atype;
> > > +     }
> > >
> > > -     effective = rcu_dereference_protected(cgrp->bpf.effective[atype],
> > > -                                           lockdep_is_held(&cgroup_mutex));
> > > +     for (atype = from_atype; atype <= to_atype; atype++) {
> > > +             progs = &cgrp->bpf.progs[atype];
> > > +             flags = cgrp->bpf.flags[atype];
> > >
> > > -     if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE)
> > > -             cnt = bpf_prog_array_length(effective);
> > > -     else
> > > -             cnt = prog_list_length(progs);
> > > +             effective = rcu_dereference_protected(cgrp->bpf.effective[atype],
> > > +                                                   lockdep_is_held(&cgroup_mutex));
> > nit. This can be done under the BPF_F_QUERY_EFFECTIVE case below.
> >
> > >
> > > -     if (copy_to_user(&uattr->query.attach_flags, &flags, sizeof(flags)))
> > > -             return -EFAULT;
> > > -     if (copy_to_user(&uattr->query.prog_cnt, &cnt, sizeof(cnt)))
> > > +             if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE)
> > > +                     total_cnt += bpf_prog_array_length(effective);
> > > +             else
> > > +                     total_cnt += prog_list_length(progs);
> > > +     }
> > > +
> > > +     if (type != BPF_LSM_CGROUP)
> > > +             if (copy_to_user(&uattr->query.attach_flags, &flags, sizeof(flags)))
> > > +                     return -EFAULT;
> > nit. Move this copy_to_user(&uattr->query.attach_flags,...) to the
> > 'if (type == BPF_LSM_CGROUP) { from_atype = .... } else { ... }' above.
> > That will save a BPF_LSM_CGROUP test.
> >
> > I think the '== BPF_LSM_CGROUP' case needs to copy a 0 to user also.
> >
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
> > > +     for (atype = from_atype; atype <= to_atype; atype++) {
> > > +             if (total_cnt <= 0)
> > nit. total_cnt cannot be -ve ?
> > !total_cnt instead ?
> > and may be do it in the for-loop test.
> >
> > > +                     break;
> > >
> > > -             i = 0;
> > > -             hlist_for_each_entry(pl, progs, node) {
> > > -                     prog = prog_list_prog(pl);
> > > -                     id = prog->aux->id;
> > > -                     if (copy_to_user(prog_ids + i, &id, sizeof(id)))
> > > -                             return -EFAULT;
> > > -                     if (++i == cnt)
> > > -                             break;
> > > +             progs = &cgrp->bpf.progs[atype];
> > > +             flags = cgrp->bpf.flags[atype];
> > > +
> > > +             effective = rcu_dereference_protected(cgrp->bpf.effective[atype],
> > > +                                                   lockdep_is_held(&cgroup_mutex));
> > nit. This can be done under the BPF_F_QUERY_EFFECTIVE case below.
> >
> > > +
> > > +             if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE)
> > > +                     cnt = bpf_prog_array_length(effective);
> > > +             else
> > > +                     cnt = prog_list_length(progs);
> > > +
> > > +             if (cnt >= total_cnt)
> > > +                     cnt = total_cnt;
> > nit. This seems to be the only reason that
> > the "if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE)"
> > need to be broken up into two halves.  One above and one below.
> > It does not save much code.  How about repeating this one line
> > 'cnt = min_t(int, cnt, total_cnt);' instead ?
> >
> > > +
> > > +             if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE) {
> > > +                     ret = bpf_prog_array_copy_to_user(effective, prog_ids, cnt);
> > > +             } else {
> > > +                     struct bpf_prog_list *pl;
> > > +                     u32 id;
> > > +
> > > +                     i = 0;
> > > +                     hlist_for_each_entry(pl, progs, node) {
> > > +                             prog = prog_list_prog(pl);
> > > +                             id = prog->aux->id;
> > > +                             if (copy_to_user(prog_ids + i, &id, sizeof(id)))
> > > +                                     return -EFAULT;
> > > +                             if (++i == cnt)
> > > +                                     break;
> > > +                     }
> > >               }
> > > +
> > > +             if (prog_attach_flags)
> > > +                     for (i = 0; i < cnt; i++)
> > > +                             if (copy_to_user(prog_attach_flags + i, &flags, sizeof(flags)))
> > > +                                     return -EFAULT;
> > > +
> > > +             prog_ids += cnt;
> > > +             total_cnt -= cnt;
> > > +             if (prog_attach_flags)
> > > +                     prog_attach_flags += cnt;
> > nit. Merge this into the above "if (prog_attach_flags)" case.
> >
> > >       }
> > >       return ret;
> > >  }
> > > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > > index a237be4f8bb3..27492d44133f 100644
> > > --- a/kernel/bpf/syscall.c
> > > +++ b/kernel/bpf/syscall.c
> > > @@ -3520,7 +3520,7 @@ static int bpf_prog_detach(const union bpf_attr *attr)
> > >       }
> > >  }
> > >
> > > -#define BPF_PROG_QUERY_LAST_FIELD query.prog_cnt
> > > +#define BPF_PROG_QUERY_LAST_FIELD query.prog_attach_flags
> > >
> > >  static int bpf_prog_query(const union bpf_attr *attr,
> > >                         union bpf_attr __user *uattr)
> > > @@ -3556,6 +3556,7 @@ static int bpf_prog_query(const union bpf_attr *attr,
> > >       case BPF_CGROUP_SYSCTL:
> > >       case BPF_CGROUP_GETSOCKOPT:
> > >       case BPF_CGROUP_SETSOCKOPT:
> > > +     case BPF_LSM_CGROUP:
> > >               return cgroup_bpf_prog_query(attr, uattr);
> > >       case BPF_LIRC_MODE2:
> > >               return lirc_prog_query(attr, uattr);
> > > @@ -4066,6 +4067,9 @@ static int bpf_prog_get_info_by_fd(struct file *file,
> > >
> > >       if (prog->aux->btf)
> > >               info.btf_id = btf_obj_id(prog->aux->btf);
> > > +     info.attach_btf_id = prog->aux->attach_btf_id;
> > > +     if (prog->aux->attach_btf)
> > > +             info.attach_btf_obj_id = btf_obj_id(prog->aux->attach_btf);
> > Need this also:
> >
> >         else if (prog->aux->dst_prog)
> >                 info.attach_btf_obj_id = btf_obj_id(prog->aux->dst_prog->aux->attach_btf);
> >
> > >
> > >       ulen = info.nr_func_info;
> > >       info.nr_func_info = prog->aux->func_info_cnt;
> > > --
> > > 2.36.1.255.ge46751e96f-goog
> > >

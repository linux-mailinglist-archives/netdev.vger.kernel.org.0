Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3B855005C
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 01:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237223AbiFQXIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 19:08:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383431AbiFQXIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 19:08:20 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EB512CDFF;
        Fri, 17 Jun 2022 16:08:19 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25HLhp69022178;
        Fri, 17 Jun 2022 16:08:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=9zBoSpN8Ru/7NbL8yzYSwmuLWFD4qCqXBPTqT5yFlw0=;
 b=ltYs3/eUc4lvwgcUvb2d0xV0q0Ox21LJEso5ovqWls1gBIuc/VLFK0UofJ04gFrhoTgh
 coAHcDAz2CDLCGfhwr1gQNaAkFa3Kdu1Z7KglvXy2a0Ln9M5Y4Q0RRVOZFCkuHQ5fuzC
 YwxYQVYdxTlnYaV/KHqcBxTncjrV0llRYeo= 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gr3trb8y3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Jun 2022 16:08:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XwPAazybu0sHzl2y2R7q58fcxfViCXq3muM36b4/dle/98I2obxnNjX2ZKcRfa51keX8tVXMUARnvC5XI3zSduElTrZF7IYOYI2kkkuNKfEEqfI6GKxuTIG/Y2N85NBlw5TiDV13lu0f/z+oegByLbvSc/DnGW+J0t236UHGWXuAEanJ4ukbZjEzfz5TbCI2wZwf/bTo2lm0GsJG3lnmfvrNpxzlD5cEZYns/rOFSp2tI3VK7BoLsPGtyjVxaA2pEs0PHYaDrNLocDJKZriE5hH5xKun/T1F+FoGm97AKY9wDHbrDNaV7v/SGxT47+/sMhMuRLckzH5Grbva+seiBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9zBoSpN8Ru/7NbL8yzYSwmuLWFD4qCqXBPTqT5yFlw0=;
 b=hz32Y5ldJ4v5l+0T0QPreuPnWCwgmoC2g+c1GLtTWWl1lSne6lMkgfJjuSkHC99diVFUtbglMR+f2tTpIiP+p8ndvpUji0jQd7M1qKjvHDyDu7Jga348EsXpdlKs8hahnwlb0MVdyUfab4qzXJDU1HHdq8TPOTEGIXVUtrq0UQeOsejJRybNn28HqToHA+Rw+pOdy8n7QqhlIpLyznJVdfwZko3NdgD/dBFteT8iZ3uRyQopzyViFDsNRdMwjNrNswZEipa1E5iHoJaGi6zgOsKjDh9BskyZJ5iDtUvdlDx3g60nJRU01+qJdd1S/390Vqic/UFTUvY75xbUe6Avqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by BYAPR15MB2839.namprd15.prod.outlook.com (2603:10b6:a03:fd::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.17; Fri, 17 Jun
 2022 23:07:58 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762%6]) with mapi id 15.20.5353.017; Fri, 17 Jun 2022
 23:07:58 +0000
Date:   Fri, 17 Jun 2022 16:07:56 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH bpf-next v9 06/10] bpf: expose bpf_{g,s}etsockopt to lsm
 cgroup
Message-ID: <20220617230756.tt6wth646ntqwph3@kafai-mbp>
References: <20220610165803.2860154-1-sdf@google.com>
 <20220610165803.2860154-7-sdf@google.com>
 <20220617054249.iedbzuakyzg67o75@kafai-mbp>
 <CAKH8qBsRKNNR+9zvn5G3DtruYqWJ0eF0TZp1ORM5VH2WKiBVng@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKH8qBsRKNNR+9zvn5G3DtruYqWJ0eF0TZp1ORM5VH2WKiBVng@mail.gmail.com>
X-ClientProxiedBy: SJ0PR03CA0251.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::16) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc771039-2571-4b67-ebf0-08da50b63803
X-MS-TrafficTypeDiagnostic: BYAPR15MB2839:EE_
X-Microsoft-Antispam-PRVS: <BYAPR15MB2839885CD6F7DF76B955A21DD5AF9@BYAPR15MB2839.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6vkSXoaKmpLQoKQtqpy6MfzI+D+OGY1oebjnNfmYkNxqa2rfiP64saesJzuamaBfMpZbXTvLVHXqe0KMP02yWF9JRgqpeMKW57vzcQez9CgsikNNZFJ/vo1/U13a0Jw0DcSCM/k/GgqFnAxfPLcBQEKVBg5GwJq8OWBQYnoLZ4atbD1LLPs7bBDMzy06OJDExSoPsWwjIGTRO6X1mlRKtR+nA30xstgfQ4JgSThoJ4Sp4jvC3YZa9K5sqQj/SjRMVg0JmWPAIBOgiHSRrRfgxfKEU3ZwrYJ/gUkhOQ6OaTMdyLuaPVD6JSJ7vK9XHOXEdFDb3PI3SNL+ERZ4xNjO9BusF0UDCbrnRrod6cFWFs4zXywKF6DQDnvlgYnh36N/Cf5gwJNbdjBWRuU/+fOftPoQyIlwlJFhP4cu8IAHx1P6JhjAyZqHv060Ljva7CMvy54Bffa2/r+DolPCQ7BGV5VJEWKy3GDmlpvQWWcTwCG4wVTGh5z5LcJcd1iwhSdOG1v2AujZPzvi7ALoypWvBjAx1Jv7Cc+hsko7GkpH6zgp/BV238+NtFnkbb6ei9ldcagWrtFnIlS+n8nIdIFtlW29IJtW6MQ4sOJxd5wnb/SGFJnoJCHN9VT97lFsocUI4Q+FFe+fN6j4BFspx0HjziJAv0/mKyuOVq1i3BguYAz5/NA82JK+szbvG94xwm5GY+J9tN9QpbIL+VDOhGSf2lx1WEPQ++nWYI6e29n3VY8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(366004)(498600001)(5660300002)(6916009)(2906002)(9686003)(6486002)(966005)(6512007)(316002)(8676002)(6506007)(53546011)(52116002)(83380400001)(33716001)(66946007)(66556008)(66476007)(38100700002)(186003)(8936002)(4326008)(86362001)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VNw4LOF3R5SAyRJCNmaGDmMda07IGfqiZ1UDr9rsiQTcNkpcFNJeDXSGt7Ir?=
 =?us-ascii?Q?YAGDekcG7jhsaqnPqt+uuov6vRUQrbk8aHmEjoIZV4Piammjyr3P5hxKayBU?=
 =?us-ascii?Q?0Wh0qRiIpt1OwcGJziWClLusEsiaS6ckxsCapcQgysEX/YDvJp4WgayaZ7t0?=
 =?us-ascii?Q?43/tebjCVKP8xoMptuCWobmBmL7IlxryqOkPfAiWiZop1QBk4oDa/onxzjhA?=
 =?us-ascii?Q?mo9K2oOqhnkfra0P06Khs3xtS0MOKs37o+BnvigwryR02DEJGqNXC2SCWutX?=
 =?us-ascii?Q?MWodSOHov/4q5hs3CYAhmTEqtGdtlU1yEsgqykeYEB2Dk6g2WnJdG9QSqd/Y?=
 =?us-ascii?Q?YQjTq8d9+04go8AAGsZxpFqHNudM6Dzja8TfERjIRsxBbJU8gqxoeIK1JoUl?=
 =?us-ascii?Q?+QwFe/vcy6f3JyZwVBXsj9CcDU9o2jWHIcXBfpCghOUz1HbcQlh+pcilfNnX?=
 =?us-ascii?Q?uaMw6zpALAZQqVs26YbotzyyUNiANn/s/po20bkovw18dFGhC1GMJXUjDZI1?=
 =?us-ascii?Q?LhuYAwRAk+grMl6zRASUxXVVJE+Vv5w5x3bz/bQsP6ZMnP3sqSm0r6a/aV/r?=
 =?us-ascii?Q?EqKbl8RAyCaF768oyMqnDtXPrPPZbPD8Z038+H2iwomaWwLNGwqZK4eKn7hT?=
 =?us-ascii?Q?aRHQ+qjqmhCnJmoy6Nc5IVWOs5wdja0BE/UOmqvJjG19TLH2PEvR52BGB8EZ?=
 =?us-ascii?Q?yEB37WN5Z3kAFUfYv8s55ZRc1B3zydn4SIt9VTf5KOmdz70BijBH4vFMmQdL?=
 =?us-ascii?Q?PfUNyVI5uvuVOtVj40z0y0MQdzES3UFo1k8EtAJz2ZjkTVfuT2WdEe5kR2Nn?=
 =?us-ascii?Q?YUSiOYYo2lN7aqwCf6tdFYxBvIP+iUryygirk64/XIqU2/zN7nPd803O/Gxf?=
 =?us-ascii?Q?hfzUtrjxhIMa8VrPvATo5ZoMSNU/A8VbKEDpx8BegDgtNfxy9tGMglU3XDg7?=
 =?us-ascii?Q?LlE6UWxW7gZmSjTtVIILdFfUA9RXN/ARbB8m/WyQeWTdrmsZxlFTslhLHlTX?=
 =?us-ascii?Q?YISxJDMGafwzqK0YzaEg0EJQGBnkCD4t4hf18IpT1ICms1TGAoGVcqYd606R?=
 =?us-ascii?Q?iNckHuFPiZtG/nr+n6oy5qSNzaOXAeKszbAJlHy5SqgUn+ME0Zy8yPGIz26z?=
 =?us-ascii?Q?ZLEK7YuMBntRaREckqhBEc8ucxFnO5UQmeCG1OM8w5UofuMMHlcq6ZgcNkRS?=
 =?us-ascii?Q?a2etG0BUEwBYe8c38p6Fu8ZXXYZ8hQ0qIf1zIRpSn6kICVJI5ubYH4y6SF2E?=
 =?us-ascii?Q?8dFU8dp8AFJhSQRkUorUGu2ldMX1qZUIyF43OwMcMdj9rM+6hYXfhyy4KDaX?=
 =?us-ascii?Q?8RcnGAMdkGGFU7YrqHtEr1dGyOmafO0npO+DnFSqk3ff7SIAJS/9niHYkgS7?=
 =?us-ascii?Q?nS8xPKVsXH8dWA8GLRvzTV8cfNoQ10czMl7tilB1wDhElTDkZ+ZEX9mwU8ue?=
 =?us-ascii?Q?k3/Jc7WvqyR65RZeQMFIw9FholZ8JO6ck+ZXLAnqdPeHzJ54lZm7dDek09dJ?=
 =?us-ascii?Q?ZSD1fKE/k6VnJZtvm1qdw4NYuCq5tS2+VwdJ7ieU0/jQcfafcsnh8DsgmRpD?=
 =?us-ascii?Q?kbgJXwds9c5rLAvW7C6nGLKdgz++H7CkkR3p9ompO7Wcv+A2P7SrOIo9V50J?=
 =?us-ascii?Q?fGw3d3sF3cHo4J47/sZZf//d9bAdh6LJlJEUNT1e1kZUsyCWeVZ3Vlk7v40j?=
 =?us-ascii?Q?vUzdLiscf2S5nqur+IvEONGHkbwYX5WCY9UmFgmiaIDA33gCdo0/HRkQWEd4?=
 =?us-ascii?Q?3dFkWVsVUgxquPQ1Z5FNGMp4C+0HVas=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc771039-2571-4b67-ebf0-08da50b63803
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 23:07:58.3065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DuH1VtVjGvYVhmHxVfiMyUox9km6DbVnCXyhhop1nTQNk6BhQoGCXx/4pw+c2k+f
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2839
X-Proofpoint-ORIG-GUID: dkhvK8mtQRMOG9vmVRt-1oU6IEjZCyAq
X-Proofpoint-GUID: dkhvK8mtQRMOG9vmVRt-1oU6IEjZCyAq
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-17_15,2022-06-17_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 17, 2022 at 11:28:24AM -0700, Stanislav Fomichev wrote:
> On Thu, Jun 16, 2022 at 10:42 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Fri, Jun 10, 2022 at 09:57:59AM -0700, Stanislav Fomichev wrote:
> > > I don't see how to make it nice without introducing btf id lists
> > > for the hooks where these helpers are allowed. Some LSM hooks
> > > work on the locked sockets, some are triggering early and
> > > don't grab any locks, so have two lists for now:
> > >
> > > 1. LSM hooks which trigger under socket lock - minority of the hooks,
> > >    but ideal case for us, we can expose existing BTF-based helpers
> > > 2. LSM hooks which trigger without socket lock, but they trigger
> > >    early in the socket creation path where it should be safe to
> > >    do setsockopt without any locks
> > > 3. The rest are prohibited. I'm thinking that this use-case might
> > >    be a good gateway to sleeping lsm cgroup hooks in the future.
> > >    We can either expose lock/unlock operations (and add tracking
> > >    to the verifier) or have another set of bpf_setsockopt
> > >    wrapper that grab the locks and might sleep.
> > Another possibility is to acquire/release the sk lock in
> > __bpf_prog_{enter,exit}_lsm_cgroup().  However, it will unnecessarily
> > acquire it even the prog is not doing any get/setsockopt.
> > It probably can make some checking to avoid the lock...etc. :/
> >
> > sleepable bpf-prog is a cleaner way out.  From a quick look,
> > cgroup_storage is not safe for sleepable bpf-prog.
> 
> Is it because it's using non-trace-flavor of rcu?
Right, and commit 0fe4b381a59e ("bpf: Allow bpf_local_storage to be used by sleepable programs")
is to make it work for both flavors.

> 
> > All other BPF_MAP_TYPE_{SK,INODE,TASK}_STORAGE is already
> > safe once their common infra in bpf_local_storage.c was made
> > sleepable-safe.
> 
> That might be another argument in favor of replacing the internal
> implementation for cgroup_storage with the generic framework we use
> for sk/inode/task.
It could be a new map type to support sk/inode/task style of local storage.

I am seeing use cases that the bpf prog is not a cgroup-bpf prog
and it has a hold of the cgroup pointer.  It ends up creating a bpf hashmap with
the cg_id as the key.  For example,
https://lore.kernel.org/bpf/20220610194435.2268290-9-yosryahmed@google.com/
It will be useful to support this use case for cgroup as sk/inode/task
storage does.  A quick thought is it needs another map_type because
of different helper interface, e.g. the bpf prog can create and
delete a sk/inode/task storage.

> 
> > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > ---
> > >  include/linux/bpf.h  |  2 ++
> > >  kernel/bpf/bpf_lsm.c | 40 +++++++++++++++++++++++++++++
> > >  net/core/filter.c    | 60 ++++++++++++++++++++++++++++++++++++++------
> > >  3 files changed, 95 insertions(+), 7 deletions(-)
> > >
> > > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > > index 503f28fa66d2..c0a269269882 100644
> > > --- a/include/linux/bpf.h
> > > +++ b/include/linux/bpf.h
> > > @@ -2282,6 +2282,8 @@ extern const struct bpf_func_proto bpf_for_each_map_elem_proto;
> > >  extern const struct bpf_func_proto bpf_btf_find_by_name_kind_proto;
> > >  extern const struct bpf_func_proto bpf_sk_setsockopt_proto;
> > >  extern const struct bpf_func_proto bpf_sk_getsockopt_proto;
> > > +extern const struct bpf_func_proto bpf_unlocked_sk_setsockopt_proto;
> > > +extern const struct bpf_func_proto bpf_unlocked_sk_getsockopt_proto;
> > >  extern const struct bpf_func_proto bpf_kallsyms_lookup_name_proto;
> > >  extern const struct bpf_func_proto bpf_find_vma_proto;
> > >  extern const struct bpf_func_proto bpf_loop_proto;
> > > diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
> > > index 83aa431dd52e..52b6e3067986 100644
> > > --- a/kernel/bpf/bpf_lsm.c
> > > +++ b/kernel/bpf/bpf_lsm.c
> > > @@ -45,6 +45,26 @@ BTF_ID(func, bpf_lsm_sk_alloc_security)
> > >  BTF_ID(func, bpf_lsm_sk_free_security)
> > >  BTF_SET_END(bpf_lsm_current_hooks)
> > >
> > > +/* List of LSM hooks that trigger while the socket is properly locked.
> > > + */
> > > +BTF_SET_START(bpf_lsm_locked_sockopt_hooks)
> > > +BTF_ID(func, bpf_lsm_socket_sock_rcv_skb)
> > > +BTF_ID(func, bpf_lsm_sk_clone_security)
> > From looking how security_sk_clone() is used at sock_copy(),
> > it has two sk args, one is listen sk and one is the clone.
> > I think both of them are not locked.
> >
> > The bpf_lsm_inet_csk_clone below should be enough to
> > do setsockopt in the new clone?
> 
> Hm, good point, let me drop this one.
> 
> I wonder if long term, instead of those lists, we can annotate the
> arguments with __locked or __unlocked (the way we do with __user
> pointers)? That might be more scalable and we can let sleepable bpf
> deal with __unlocked cases. Just thinking out loud...
I think the btf_tag may help here. Cc: Yonghong.

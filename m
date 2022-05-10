Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E082520EAD
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 09:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237721AbiEJHhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 03:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240043AbiEJHRv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 03:17:51 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB362992C4;
        Tue, 10 May 2022 00:13:54 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 249MUkZN010972;
        Tue, 10 May 2022 00:13:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=hH/Tvkm13BzAkRzdJmG9x4z2hww141O9OuZNWa6pktE=;
 b=cRH/9JfsMugRDpJOduwfNBeNzcPutyatSnV/VnydioAD2+SoP0jwj0BCCQDACWwn7KnG
 XG+CHyWNYZPm0e4egffoMgTEWhaz7W4W3fsrPBJ8HUuyib2RESMpgURobgvs/LTnrBlb
 U3IARywc0+ZDvhubw6Q2bgE0DePwKgY8Bmo= 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fyay5j8pu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 May 2022 00:13:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EK1j/VkYDMF+cG/zTakb5a6Kvym/FX+euJWPtGxT6rA2jV0xiaeVIhVFixrgh1lKS71NoeNxqSHsiqkjx5/4GlFU6UE1daGD/oJx+jRGEpYukKGSrrTEQ3iaL9agy3kd2XNtLzVf/uBg2vglHV5BSquPKN6Q8HhOz9b7vVpQCnur96DkzsDSleToLX9lwdQ2OqDQaEMsnn+ilsE82ozg3sM6EtdO/qglCySCN7PVNgQ0ESpGruQ2tDKoNUaJYW8taRzXivOuCeDuGKlAIVLT+dr0KGmdnk6VKnv8pqAP60Kc21WHv8UGbVP/HEyFV8H5FvQBFX9EpdEiKxK9kZ9fFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hH/Tvkm13BzAkRzdJmG9x4z2hww141O9OuZNWa6pktE=;
 b=fDp0j/b2K1+qkIrMActBpHupfo0GAmZMJCBE0dtNbkT9quSr7ktSrm3mkQQIfQdWhc5H5tJHtu0vmXqyN+rXgeoZghDesc1FrOfeCRlFiYoVrt1a0Cp14dmxrg/hEr8AFswFw0fg6JmPoF+5c/ok1/8M5tYnallEV/zM4MoHCYVhyGzQeUf4nRNiIKXbfIYMdNrFRLXmUvwnnuw+vLOsaKYJ96xhWdxnnZ8VG2k1ly4sjeeBKXQPpUOVh0wA/lGrNitywhldh0BtmvmdYL1ZngySZuE3ihgDwjJiNJP3hCMJ++j5g+x0PqsOwdX6MF3q/FEh02NRnLGKVm4lQ1SRVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SJ0PR15MB4154.namprd15.prod.outlook.com (2603:10b6:a03:2ca::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Tue, 10 May
 2022 07:13:37 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::fd7d:7e89:37f4:1714]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::fd7d:7e89:37f4:1714%5]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 07:13:36 +0000
Date:   Tue, 10 May 2022 00:13:34 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v6 03/10] bpf: per-cgroup lsm flavor
Message-ID: <20220510071334.duvldvzob777dt47@kafai-mbp.dhcp.thefacebook.com>
References: <20220429211540.715151-1-sdf@google.com>
 <20220429211540.715151-4-sdf@google.com>
 <20220506230244.4t4p5gnbgg6i4tht@kafai-mbp.dhcp.thefacebook.com>
 <CAKH8qBsQnzHPtuAiCs67YvTh9m+CmVR+-9wVKJggKjZnV_oYtg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKH8qBsQnzHPtuAiCs67YvTh9m+CmVR+-9wVKJggKjZnV_oYtg@mail.gmail.com>
X-ClientProxiedBy: SJ0PR03CA0092.namprd03.prod.outlook.com
 (2603:10b6:a03:333::7) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c6a98b8e-83e5-4643-a095-08da325499db
X-MS-TrafficTypeDiagnostic: SJ0PR15MB4154:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR15MB4154F5D7BA3D80C358D53318D5C99@SJ0PR15MB4154.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YYHF6r6zT6uQD2HlGqVAUugBzqInvDMNA7k+d9LZlvdCE24ACXVubuk64L6aZbxr+JXXcVGn3RlYKdSJAdr9/mJeVH94Sg1a/HaRCYjaGZl1ir8bfnHbuRsGpF4STA/9ugDX6cUk/pnDYyKAgGmffyzA8NpubusuWvBYKS2fI4JVp0QOIi1rRWKIoqk6O4a3yazYZLXmg8YWQgE7HUYXu6/EPe5uuchwWNTeUw1Q2E2NmTPJllrMcw10J3IqTca+U+r69b5U3DBHNHcvjKu2N9U9LKNfIcDHJUBx8DbO8oe+E7ajcboWg2NQlD1sCCqVno4b38xPOIwLHPvA0ZX4Klm756d2PTOop3W8//pUhLPlherYXszG+LazksCa1rY2yKQZ3E7ng6BAe15Nlaz5OOL3vHQSOfWP+Oa8Z1hE8YJ1ben58eReGoJ9QftlLpPjwUKYpI9GJ78RQfsW5njsnVLOThYGZ/kMd7H2I+bbnEbEFqD6PFU64t5y/eNQ3psSoy1oqSw+yaH0pWsFqsLfJxRTwX9m3LqWwjnRNYzpRVJPI3u/GVKbEYc+NNzbk5r5eQffyKXcofDu1bLWiimgK1b+jDTZDQpveLO2JW+2mL/LSYXia0rBqL0VH7YhVrTgK0Rpvku8laL1tYMgVDZ/KJ+/Lvvxx9IEFlWxJyJV3Lpw2Qqmlm8FIp45UmVdg/pZ1i9tH/xAjIShGM5w+VD29g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(508600001)(66476007)(66556008)(66946007)(8676002)(86362001)(4326008)(316002)(6512007)(9686003)(5660300002)(38100700002)(6916009)(52116002)(6506007)(186003)(2906002)(83380400001)(1076003)(8936002)(21314003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EOY/Mb1llYQEd9CfGY4prOrZ2u2evOEm6kZ8gn7e+4O3BMlCt1cqtzWwTNso?=
 =?us-ascii?Q?u4yIzuVJ2iPNwU/LgU/RJV9+sd3eWWjWiFo6KPa3KZnDbN5b3oDmd4JqeM01?=
 =?us-ascii?Q?2Ro0UokAwdC3Hy1MGc8IAxCcu36sEuxp6MGOJ/NTUNd3CVMqcSGsLLMtCJmH?=
 =?us-ascii?Q?/Q/e/teW3JD5x0b4g7f0BZA5Cjdrz1z1KAGWk19J+LQ0raiI0JTSC9tJKYKa?=
 =?us-ascii?Q?qhZNPq/wqRyWt0I7sDtaRGNAlP1uEtRJjRsQ8GKPE6Miw2hoecm5aWNIh90P?=
 =?us-ascii?Q?+9V2VvsfHrqqIz5d/uwjlEA1PurXnkHkIstxHuVPHhXw3SoOl+bHa3oz0nM5?=
 =?us-ascii?Q?2zPSzst2wxsbGRhvvqP0lQHUJ6M1JrNPqZEX0Gb/Y7kLds2BQPXRZBcTOX4v?=
 =?us-ascii?Q?GfJkb1Y8Ru2QAMIfVmRDOU2COE9OikflEtpExR+UW2Oo+z5w+PIOjoDciCO6?=
 =?us-ascii?Q?8UfNmBOus3KiQeTkQt7jxup6jKi+cDEWHyKVPZkr0gNwsgm7NIjIqXW3VpEY?=
 =?us-ascii?Q?Cix8jKyRzYvwEg1OwNSbbVUT+2F4BmFJHwsilOfarJaERic0faJ17RhnWOqB?=
 =?us-ascii?Q?/eyq4EKM/39wyFzwdKeY4qRgRjkei2X9J59bCcWKVX6LgTB8AoxUgsgpGXkX?=
 =?us-ascii?Q?aZ9PPe1nuuc2Gxr0Zly+44Gpq/PpkMRwYFrnxcDmJt7g407WFdwQqJzTISIc?=
 =?us-ascii?Q?L/XiK7JCIO6+60xkM2KROAAecMVELTmG90HORMqE4heOdUmZ7e6yswTC5Lxh?=
 =?us-ascii?Q?rsFPxEACyKfEqfmm5/I6pKSwRy9hRZjZonjtfiCt3Dr0rLSSCk4sOpwOcQPE?=
 =?us-ascii?Q?POOj/sml70QLUNTlSf8OJc3bnFPxJrf7ZQfitG/Gk/KB9ULK2zDccgZMt+zS?=
 =?us-ascii?Q?8+zP2ibVLtf1zQLm4MZqVbeutXnbtwaKncioxeDP+x/kjwNRElwGVNKYELjz?=
 =?us-ascii?Q?024njqyv3A7PIFVX98yR2ENh8bK98Nt5MFjLfFTvhdi1GfMVMIoiyjkg56ZV?=
 =?us-ascii?Q?tYftosRRRSJWxbBM5dbrm5BWw7rnKD1vIGCSB9ibYklvVz1K00upETMVYWCK?=
 =?us-ascii?Q?bja64v+cMLnR7j5VihaUrxSeSjTWDqjpRPZkUliWepVQpozEcekz1NO8rsjK?=
 =?us-ascii?Q?71oQNZzTrPUw401Cqo4UYaL7EQU3k0IGMy/HP0Yg7N8loWFlYnYEUndj/8pr?=
 =?us-ascii?Q?1aPlS6VBq5vFPTg0KRlllwq4gRRiAAR5YBMCsTWntW8cXD1rpKAkJjDgJ8Rd?=
 =?us-ascii?Q?NBiRguBaVK2e4K4xHAcsEWUTIVhtZ2YCLNERG9fq/jsSD0yKuuf1sXS1QxpS?=
 =?us-ascii?Q?MKMjTEKQrwDwLfcXMFg7qd5gsPfVQdWGDPtLNsBvqSWHylucGzakakoQ3x9a?=
 =?us-ascii?Q?HT87QaYzVUEt9hGHzbc/1NC98Nntog1ss9DOoovEq27WXrMy8EZo1MyA9D+m?=
 =?us-ascii?Q?jCltdkwV9Z50IgpNddf95+I5cNswvypMRgu/ptQ0Iw4DlHfqS1/AM4yMCIl9?=
 =?us-ascii?Q?waBGCvGfTIsOh5uUVAAmJkbBr+rmpFQj+PSSnJqumTR7aPGblRvqr/BSoHvC?=
 =?us-ascii?Q?D5tLaiOSkerVF2LT7RM2dhoBT+hFOCymz5S9KZQiMzYKZSXlrcUi07T9hOW7?=
 =?us-ascii?Q?TjN4FGo4hi+HipdNfwpVK7pDFOLdS2r+oPy6F3UjoZ+QCI8Cnpxzh32X+qgp?=
 =?us-ascii?Q?3B2gMT7bWQ54fyMPQkKVtDg+fHALQo3jUe0VTPkLjhpD0boNJYl/ObtW+YFE?=
 =?us-ascii?Q?BqvlwnJOs6L7UP54NAuKXzc/x7sc5a4=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6a98b8e-83e5-4643-a095-08da325499db
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 07:13:36.8002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pHqTymgL6uATh5YqOj+BFl3ySCVxaO/GJpvb3IJUEwCc632LpRh2nyiXMRh+ectB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4154
X-Proofpoint-GUID: d2n9RO37QgTMrtOHYWDky49Wez2nl7Rr
X-Proofpoint-ORIG-GUID: d2n9RO37QgTMrtOHYWDky49Wez2nl7Rr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-09_06,2022-05-09_02,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 09, 2022 at 04:38:36PM -0700, Stanislav Fomichev wrote:
> > > +unsigned int __cgroup_bpf_run_lsm_current(const void *ctx,
> > > +                                       const struct bpf_insn *insn)
> > > +{
> > > +     const struct bpf_prog *shim_prog;
> > > +     struct cgroup *cgrp;
> > > +     int ret = 0;
> > From lsm_hook_defs.h, there are some default return values that are not 0.
> > Is it ok to always return 0 in cases like the cgroup array is empty ?
> 
> That's a good point, I haven't thought about it. You're right, it
> seems like attaching to this hook for some LSMs will change the
> default from some error to zero.
> Let's start by prohibiting those hooks for now? I guess in theory,
> when we generate a trampoline, we can put this default value as an
> input arg to these new __cgroup_bpf_run_lsm_xxx helpers (in the
> future)?
After looking at arch_prepare_bpf_trampoline, return 0 here should be fine.
If I read it correctly, when the shim_prog returns 0, the trampoline
will call the original kernel function which is the bpf_lsm_##NAME()
defined in bpf_lsm.c and it will then return the zero/-ve DEFAULT.

> 
> Another thing that seems to be related: there are a bunch of hooks
> that return void, so returning EPERM from the cgroup programs won't
> work as expected.
> I can probably record, at verification time, whether lsm_cgroup
> programs return any "non-success" return codes and prohibit attaching
> these progs to the void hooks?
hmm...yeah, BPF_LSM_CGROUP can be enforced to return either 0 or 1 as
most other cgroup-progs do.

Do you have a use case that needs to return something other than -EPERM ?

> 
> > > +
> > > +     if (unlikely(!current))
> > > +             return 0;
> > > +
> > > +     /*shim_prog = container_of(insn, struct bpf_prog, insnsi);*/
> > > +     shim_prog = (const struct bpf_prog *)((void *)insn - offsetof(struct bpf_prog, insnsi));
> > > +
> > > +     rcu_read_lock();
> > > +     cgrp = task_dfl_cgroup(current);
> > > +     if (likely(cgrp))
> > > +             ret = bpf_prog_run_array_cg(&cgrp->bpf,
> > > +                                         shim_prog->aux->cgroup_atype,
> > > +                                         ctx, bpf_prog_run, 0, NULL);
> > > +     rcu_read_unlock();
> > > +     return ret;
> > > +}

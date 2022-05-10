Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E82F352249B
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 21:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbiEJTTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 15:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbiEJTTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 15:19:07 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D662E261954;
        Tue, 10 May 2022 12:19:05 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24AFLoSA030470;
        Tue, 10 May 2022 12:18:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=jcA5K2pMBMJnmh4j0SCUhRCyJlJp7+/dPkh4AuGVLRo=;
 b=HcopILaoJmySLvEr2t30yXDIZoD34RW8Ey6gsLuCnKR3ByK8ptDnFU0uVGef+GHQMIHn
 U3pII1PojNZL06w+2Q50Bkx/p5D7eJCWKvIdvDn/ekbbIJM2sT9RCJOoev8a8OJsY8ps
 BORfRLoNip2EncouISdCzMeZIaRdukrFwZM= 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fyay5pxd4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 May 2022 12:18:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZfXxUgx8SGuo9cACoppf+RZl8Skq6gs9fiRJPFJflqn/dMm8eertMmV8Ux88+vD8sV3VNQ/68y76zwGnQRzNYPiPoOfAm3fgOq6FqjSFNV1QMSkKIQ7hn08ygiWEOirdYcS+YLUBzOow9ZrdjJ3gFU+AmLXIsPIGwWap3jzsVTp010z8IPqiOoMf/Zog//zxz6lC0WZtnyoIhTD8/fbYoeghApYdvBYCD27O2dXC1zO2fReLVZbZ9kB4ydamckvSYZmrx/8UkCinO6uNhp5eKuc+AE8a3fUI1fjcnl8/ZjiW4IfGBSkZ0220xGUjfW6KQETBwNiYlPU3vaFhmzA4JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jcA5K2pMBMJnmh4j0SCUhRCyJlJp7+/dPkh4AuGVLRo=;
 b=MW3T4xbmOvDXbSXTFBYEzWjjnfEFqpuOE2bJxT98EnHRZNtBy4WqhkSV6xGXNjaOe2DNrVSdene1b8xwlExPOWdAoAfljSiYvwOjIPQIlUMARKNxXi2vhnfFGmHcm8FGKa/IgeXPqHuscq35Zoai4pkJde9lbIC+PlGU3hi2KTfs3CqdjtdYwz3H3BQv7yIjRCL5SD2fh8mmX8lUxNeWbfBC/5MnCyRzubOp2i9uMxsR3L0NP6deO7ByOe2Frw/ZLnx1RHqhst1kGbwZAxcXnOxp/DrvwvM7ajCqnSUXO4QwhSu8dRRkTpKdan2wDzvV+YFhYUB3xuoYrNFkIr+HJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by BN8PR15MB3267.namprd15.prod.outlook.com (2603:10b6:408:74::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Tue, 10 May
 2022 19:18:49 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::fd7d:7e89:37f4:1714]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::fd7d:7e89:37f4:1714%5]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 19:18:49 +0000
Date:   Tue, 10 May 2022 12:18:46 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v6 03/10] bpf: per-cgroup lsm flavor
Message-ID: <20220510191846.exg6gremtqx7wbst@kafai-mbp.dhcp.thefacebook.com>
References: <20220429211540.715151-1-sdf@google.com>
 <20220429211540.715151-4-sdf@google.com>
 <20220506230244.4t4p5gnbgg6i4tht@kafai-mbp.dhcp.thefacebook.com>
 <CAKH8qBsQnzHPtuAiCs67YvTh9m+CmVR+-9wVKJggKjZnV_oYtg@mail.gmail.com>
 <20220510071334.duvldvzob777dt47@kafai-mbp.dhcp.thefacebook.com>
 <CAKH8qBsR_kgQ3ETwm++AL7vZDcq1H-56eykqDdAcrveH5+ejzA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKH8qBsR_kgQ3ETwm++AL7vZDcq1H-56eykqDdAcrveH5+ejzA@mail.gmail.com>
X-ClientProxiedBy: BYAPR08CA0040.namprd08.prod.outlook.com
 (2603:10b6:a03:117::17) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 11dd028e-77dc-40f7-d0be-08da32b9e906
X-MS-TrafficTypeDiagnostic: BN8PR15MB3267:EE_
X-Microsoft-Antispam-PRVS: <BN8PR15MB32678655E3EC8231DF36D35DD5C99@BN8PR15MB3267.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kvHNm+jHRepI+w18Gs54yxWsq9EHsA1pDhaduvicmVTzxYWncm4o2KWMjzmSmDIiUubUTOsFK8nFk+kcWusea2EoLd1YS8zrF8sFLMGedOLXwaNj7cMDZ6FppfN1XE9A43isrlQjoDsRq1O8UBeUpO7TsFCrGbZLLWvMICe/AwHkf73kOD0Nx+iUlihE/0QqDYKsRRcW4faTrpWte8Jfd2Ubvt7VPvMuDCuQfGb3biU/gPj5dj2MsPZJqGb0BmbXFjRKqrOZ+QI98/QM5O2S9OFRyvuIRlpI4928L1cFdy/+UZHe97oAHv6hjN9kLin/LTUkrSBxKNgObtO8iGixxNQpwleAZeNRsq9BC54IGe0m6E6X+Scn+qLf7ryLnTOPaig+fN+rkdfVEmJdFLQlRuWchTAC8HePu7Wd3EUF2j6omXlEKeu2Nsiv0BbVjJZrXviX9FP8hMDaqPRJtbt+b4O4pETW3ZD/x2ZY0C/8zeIFWObnMBrCzjSVC9EZUJtvt7ZlY4Pkc+VxcJExSk+mjmxNlvxGHzX8qBLXJd7FQr3PbaUaiOTvWLsuSQ+q8BRGebFz2ygZEB59S7F5zxSr5ON81eBJ6CGjfpoIHHi/m1Mx+annaDxbbGxhxdlYRJ6fAO0L7pCV/BXAvFDMXimeC8oFoODQTD4sF9BJzRX3ma+jRaztAoOHKoOiZb/9rc8yDb6KJZYt+oPcJBp0BA7/Dg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66556008)(6512007)(6666004)(9686003)(508600001)(6486002)(66476007)(86362001)(66946007)(316002)(186003)(2906002)(52116002)(4326008)(8676002)(6916009)(38100700002)(8936002)(6506007)(83380400001)(1076003)(5660300002)(53546011)(21314003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sjrSuvE8MYxieQRlXy2OKKK2Wif8KFTZAytGfvaVYyIIEPeh/dzP3/sqRr3u?=
 =?us-ascii?Q?Rnfzv1cn1gIvTRCSd6g6nSqyYBL6e6NzdF6qV65xPmpstYeTmjnBhtzVnWlj?=
 =?us-ascii?Q?KtZY2HrC+xwY4m84LaqjKJKX30c7cPuRgOawKvk38yTvRS3O1p637eEGOmC1?=
 =?us-ascii?Q?xhaaHvwtZvoQuhzA96LncCUPc1l9PhFGjioid6ijunXaae4IaKUNbP+UkB8I?=
 =?us-ascii?Q?jL9S9hKnak7hLJXhZv6wut4EXg3+DCRr2ZdHNBzP9sqn5m6rSM8rcklDSJpR?=
 =?us-ascii?Q?ULhZVPYbU06PZkIwYFJmX3yAeFC4bxGO7nQEDQWPboIXswpazODWTXk+Xs5i?=
 =?us-ascii?Q?jXeUFC02go+YF210klY+PTvjJMFdQ/bS9iuZ1U/X1e2+OdOVNxrpmCELFjvk?=
 =?us-ascii?Q?sGvw4bsJ2Fb1JdSbeJ3EwnUcLVLuISJvLqeOJQn1eobbRhMnRNf0uo9DpYyT?=
 =?us-ascii?Q?1SDumIgKQcofCj89jAq9Bd0NN9bcCapkbhouoVP6/uCMvyPzgW2aIj9urvQM?=
 =?us-ascii?Q?KtgjuazLxjMWMU8KyG+keqslr4lniSmkS4frXd2El0tXsLxFzfaiIFmR2JQ8?=
 =?us-ascii?Q?O9ns7t0vbtzLDua/v6lN7tvwdPRG2MHCYqIzFiljwtiKdXrk8H+tsetl+mmx?=
 =?us-ascii?Q?V87WJddqpvT0oHaaJb2YfSYClV4MIVmrRezP+ArGrQ14v9ZlCiJhjvQVdDcM?=
 =?us-ascii?Q?WDbiClCBc9ODka3GiTWZg6P4numVCUF60DgJdp8Fnd+ggXkMolfJqJ518WtM?=
 =?us-ascii?Q?ryP39TjnJQ8mf5Sp2BG9AyP/hQc4sE4q5OCT0M+M8iT2u7xO7lEA7MMawKw3?=
 =?us-ascii?Q?ZyzBObT0/glX4DpcHoQ3bScFxEbjfXvkcdXZ9yZtt23c3KApb2fMFd+TQRc9?=
 =?us-ascii?Q?TO9CI7Wo6CfJvljF24kfE48jGQcnixakLoeVAJe479gNW5l4DHrVokSHH2aE?=
 =?us-ascii?Q?DUI2ZBCRwx3MmvhwEfQkVQYNdxeLVPGBq7qJnX17scwji+2IHepvIM2HYI9D?=
 =?us-ascii?Q?F+j2Prb02QuIL5vdWyi7aqjFydV8W6/HgqUKwrwrm8u+FMa+N8109hTxpV2W?=
 =?us-ascii?Q?QcaZVferSWqTbqwyHtfF1gwP9lrrrJQd1JbQvJ/O6ez+1gSzsg1bcAepzRhk?=
 =?us-ascii?Q?XOBNDDPHCiL/GtvKbBEXUeTWR5jrEkf2lGqSMDv9BYoqlarDXcraflzBoZZ0?=
 =?us-ascii?Q?xy9mpOHx07D/BOMIBQMBsXu9e0nUR38wNT8w/Ac4P+PzEC412jwneSx63TSC?=
 =?us-ascii?Q?L8/v7mVkfyl+kBbod5XlQyMBO6YG2nAxKOb5Zb+V/slbn22ztoqJTHzLA8Fr?=
 =?us-ascii?Q?m9cMQa2f7+5wGnX2p1OjYXWXzNo9EldtsL4O9hU40CJXric+pYHiOqRgSm9j?=
 =?us-ascii?Q?eW9gryBbgLvD/FbB7tK38XnoqjDrkTLyIgZSxuRrxgze9b5NiEqS7Q0VHlnz?=
 =?us-ascii?Q?v+2+WKXbNVKyHrCAEe+zLlzZj11B5DrdhWbt5l8hShtLUDSNGnhAuxTK4FVl?=
 =?us-ascii?Q?6KzGSAQNmCVeUKWaWwq49NMNIDWxWnUHQ13Yr+W9slPNkzvwukMJxw8D+OjU?=
 =?us-ascii?Q?xe8IBhpMzyko+pJ6xlg/xxXFPXm4lliVGWjqaxyAT44GP0GU6I+Lz60gP3qg?=
 =?us-ascii?Q?PRLn9X3qSgx+GBAIxGDxfPnsJe6OXS2APeFK/t/fEClbFdIYtpuG4sNWUHnp?=
 =?us-ascii?Q?/meIc7+spy1yW1bOr2H8d3fN1mhM0IXun583tkEgda0Z/5aUBTP/WuNMv5pN?=
 =?us-ascii?Q?N5asD8m9y5tekwKnxZyzoKk5Pi4Ygv0=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11dd028e-77dc-40f7-d0be-08da32b9e906
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 19:18:48.9816
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t7ggCtMvK/QcIDKMKc6esZMEHRmj5lz9yMpvGe5s9rzUmPyzJOPbpwP09egQ0mpL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB3267
X-Proofpoint-GUID: mYkD7N_VNx-fMQIec8mpuF9KH5RSwDWe
X-Proofpoint-ORIG-GUID: mYkD7N_VNx-fMQIec8mpuF9KH5RSwDWe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-10_06,2022-05-10_01,2022-02-23_01
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

On Tue, May 10, 2022 at 10:30:57AM -0700, Stanislav Fomichev wrote:
> On Tue, May 10, 2022 at 12:13 AM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Mon, May 09, 2022 at 04:38:36PM -0700, Stanislav Fomichev wrote:
> > > > > +unsigned int __cgroup_bpf_run_lsm_current(const void *ctx,
> > > > > +                                       const struct bpf_insn *insn)
> > > > > +{
> > > > > +     const struct bpf_prog *shim_prog;
> > > > > +     struct cgroup *cgrp;
> > > > > +     int ret = 0;
> > > > From lsm_hook_defs.h, there are some default return values that are not 0.
> > > > Is it ok to always return 0 in cases like the cgroup array is empty ?
> > >
> > > That's a good point, I haven't thought about it. You're right, it
> > > seems like attaching to this hook for some LSMs will change the
> > > default from some error to zero.
> > > Let's start by prohibiting those hooks for now? I guess in theory,
> > > when we generate a trampoline, we can put this default value as an
> > > input arg to these new __cgroup_bpf_run_lsm_xxx helpers (in the
> > > future)?
> > After looking at arch_prepare_bpf_trampoline, return 0 here should be fine.
> > If I read it correctly, when the shim_prog returns 0, the trampoline
> > will call the original kernel function which is the bpf_lsm_##NAME()
> > defined in bpf_lsm.c and it will then return the zero/-ve DEFAULT.
> 
> Not sure I read the same :-/ I'm assuming that for those cases we
> actually end up generating fmod_ret trampoline which seems to be
> unconditionally saving r0 into fp-8 ?
invoke_bpf_mod_ret() calls invoke_bpf_prog(..., true) that saves the r0.

Later, the "if (flags & BPF_TRAMP_F_CALL_ORIG)" will still
"/* call the original function */" and then stores the r0 retval
from the original function, no? or I mis-read something ?

> 
> > > Another thing that seems to be related: there are a bunch of hooks
> > > that return void, so returning EPERM from the cgroup programs won't
> > > work as expected.
> > > I can probably record, at verification time, whether lsm_cgroup
> > > programs return any "non-success" return codes and prohibit attaching
> > > these progs to the void hooks?
> > hmm...yeah, BPF_LSM_CGROUP can be enforced to return either 0 or 1 as
> > most other cgroup-progs do.
> >
> > Do you have a use case that needs to return something other than -EPERM ?
> 
> We do already enforce 0/1 for cgroup progs (and we have helpers to
> expose custom errno). What I want to avoid is letting users attach
> programs that try to return the error for the void hooks. And it seems
> like we record that return range for a particular cgroup program and
> verify it at attach time, WDYT?
Make sense.  Do that in check_return_code() at load time instead of
attach time?
To be specific, meaning enforce BPF_LSM_CGROUP to 0/1 for int return type
and always 1 for void return type?

Ah, I forgot there is a bpf_set_retval().  I assume we eventually want
to allow that for BPF_LSM_CGROUP later?  Once it is allowed,
the verifier should also reject bpf_set_retval() when the
attach_btf_id has a void return type?

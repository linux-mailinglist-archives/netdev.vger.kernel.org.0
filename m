Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBD465002D5
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 01:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236030AbiDMX7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 19:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231635AbiDMX7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 19:59:00 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAEBC5548E;
        Wed, 13 Apr 2022 16:56:37 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23DMLHB3021175;
        Wed, 13 Apr 2022 16:56:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=oh4T+t6CU2XFOMRSp4b+GKgcoXIUZXtJ4pHW4JvBIRU=;
 b=mmKaXepI5sg8zQKwnNsRYD4x1z4VXoWcIEECoi2heKpAeIRUfKyeU1RWX1TYRHysaBMl
 oqy5r6T9OBcE+cMLhiYgtuhFsP1X13u9KYmBiFWbR6Yc/Ub0ZGkZ794dtcBbL1T8TT3T
 RBesFueRaAVdKvi2Fsx1zOZp/B5g9EIQdSM= 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fe2myjkdm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Apr 2022 16:56:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mn2238XTNxhV2naUvAMSbNct4Af5OfOThwXKOx2JyZMCSv2JluI8xH5bL97pJZpgetAhwFSyn5ri8uXnucgpoFfz/XHv29HFIGL1NJnoCtOMaH90LMBTZYTXYdpNJSUdaafH6Ewf4AYdfnwUzHUaaAZHV/C2JUI9pMmsbDhwNZvsLnykh4tVIs+OxSH8q1AP+2SRWFBGicK8z4MfIIrXZuxdRTPjm0gLxpzHXcd2jiUJm5GhYSlAJ8ohT41PyV/9fSjULsIkEIlAxGqxZsbd1414avVwqyOIHYT0VV9VYzoZNidbqO9RSqi/p0AkDsADLOYohh2/63G0/TGDvxroHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oh4T+t6CU2XFOMRSp4b+GKgcoXIUZXtJ4pHW4JvBIRU=;
 b=RACxMqeSzaVjKA1mruG4fre6FVKsQQLAWfF4s0ue4LmQNRx2SXAq5MSoEnJTwvv+N6CNF9H5jQBHAmjreplvHiE35u7ukkLD2SnveSYOiOx5CqlyYvyYBmd7/5C8xWMd518sdc0jNVMN1zdm1hPlkLDjlwW9cxiKeNXpkgw/CkeIqaDOCAu4mQbBCwwvd75PTxFZtDec0SFO1H/8UdIN1KHxEdq+f09zTJdFy5gI7+ZfRVViJ7b1MT1xIQ4za8/dXny35eM8YDzY3Zi7mmGslHHbCZaVvXeOqFxz63/bHejDmY28UCntr9H5t8HH+aRGcQIc5iOS/q1MHezmhkK+Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by PH0PR15MB4229.namprd15.prod.outlook.com (2603:10b6:510:1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Wed, 13 Apr
 2022 23:56:15 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::100b:5604:7f1e:e983]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::100b:5604:7f1e:e983%5]) with mapi id 15.20.5164.020; Wed, 13 Apr 2022
 23:56:15 +0000
Date:   Wed, 13 Apr 2022 16:56:12 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     sdf@google.com
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: Re: [PATCH bpf-next] bpf: move rcu lock management out of
 BPF_PROG_RUN routines
Message-ID: <20220413235612.dpwtebrielg7v75p@kafai-mbp.dhcp.thefacebook.com>
References: <20220413183256.1819164-1-sdf@google.com>
 <CAEf4Bzb_-KMy7GBN_NsJCKXHfDnGTtVEZb7i4dmcN-8=cLhO+A@mail.gmail.com>
 <Ylcm/dfeU3AEYqlV@google.com>
 <CAEf4BzYuTd9m4_J9nh5pZ9baoMMQK+m6Cum8UMCq-k6jFTJwEA@mail.gmail.com>
 <20220413223216.7lrdbizxg4g2bv5i@kafai-mbp.dhcp.thefacebook.com>
 <YldUIipJvL/7tK4P@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YldUIipJvL/7tK4P@google.com>
X-ClientProxiedBy: MW4P223CA0001.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::6) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 00c6050a-e11d-4640-91d1-08da1da93205
X-MS-TrafficTypeDiagnostic: PH0PR15MB4229:EE_
X-Microsoft-Antispam-PRVS: <PH0PR15MB4229DFD37D6265C42505A72ED5EC9@PH0PR15MB4229.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N/0RKRMD8OSNKpPFq2IL2pKTAKnQsvmz5annTSdv4n8zcz00NlS3XGkcSFzpJhuPjq4SvrKTY6DKJk8cKsZnGQzAgiMEANpwepHfqdoxjZbLFlYjkfIBU/bOVhwOA+G5akIpxZ+/iQIg0LuHE+9+7wiuWVNBQcuJa8N+ikP9OUHuN1CooJF1/GwchSq4bfkB92lo02ySrS6gZkiBOHnG6hi6GyDj2kJnR8JRDZdAZp5IG8wsus41uTAKSNPhS/KRuWnbEnHcRXE7eRyBwjIeeZB0jVp+qhrz2Sl0Qvirfmu9lYtntXI8EFkIcwcm6qI0siU0TQRcO6O8oKXlxPoWa4zJHypZRXEE3S+JPSu9FJzkaQ3k50vS44sKNHpzoNq/kjhd8qLkBQCw4RVwLNK126g5IPbOdnAj3gClwB4QbHnVAsWJluU1B/HtNoJQIXq9BmPlhrxcRqnxcVG5UcNSiyRUpy2BnZFtsgprlNPECBEvBqra5PacaExLRIzeYZj0Td8i4YCcYdBiSsFPHL5z7IQJptziooHQ/5EGpuuq9IZ4XhH1jytmAjfz06vyGca9JkCdSvvlvIo1Hy85ObLLm1YaLwixbpLEZfvLobDenoyqopZd+ZUqeFcvOApfquZ6yVDy+2JMBKUS7SsjfQfXJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6916009)(186003)(6666004)(66476007)(8676002)(38100700002)(316002)(54906003)(4326008)(83380400001)(66946007)(66556008)(53546011)(52116002)(86362001)(6506007)(2906002)(8936002)(5660300002)(6486002)(508600001)(6512007)(1076003)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?c9yQ4f50NIt6nloeXhppwnTcz517w/vT0IMAk2nTkU9FxSw3FXeIc56MDhzz?=
 =?us-ascii?Q?QOT9GW/aAIUD6Uoyy17uu2XvH3iZkd824zqk9NFhUoNZQmkvl2wErk9GKzSR?=
 =?us-ascii?Q?tk56vWMkTCuIWvvZRErzFwr7qIgdJ+agW89Fr+2Vf9h1xsDKu3ooEERJ0gRF?=
 =?us-ascii?Q?Vsrs7RXzFLH1gJtQHTf6M0vgYdmrZTia3a4X7Pg/+1ZEEsP9tRL+4ZTR+i2X?=
 =?us-ascii?Q?ysz7TYlG1iTnzYT/OUACHOFlhF/9OWYmwdfe6rssJNQBSRgRnRM7EFkFbu1L?=
 =?us-ascii?Q?nEt1UglSPEUfZDqvlM+lDs6l4CmNmZRBron6GwK2wC2j/hRUi04D47HqPxAh?=
 =?us-ascii?Q?Frh8NxJgc0zXhZphWYWO+Ujz+hcPx/G+6efEQn2R0I8y27oI7uDPAfAbahdT?=
 =?us-ascii?Q?D+UJC9oY8ITe50Goelhv0eARXu1rFoSHQIY8BTD5L1wnjolZj8EomsokKWUu?=
 =?us-ascii?Q?lhshmL9eUysshPHM79O3vmqdZr1cb7tC8Yvcv01Og3zuzrfpXQ8VT8dZYJ/w?=
 =?us-ascii?Q?IsRjLylF++Xp0UCOETdIxR/7Yza86HskLd1kCuT8DFYfkkwJW4U5Tgmok5au?=
 =?us-ascii?Q?+FYRWMZS0+0b8oVly8kzalGk+dv1R6fGGc04vfjxE+Gav+/YPTQheWkVfvA7?=
 =?us-ascii?Q?aOOwI0MAgB5nw3r650Ybkhfwitbg2wR9uDC7ktzZJ+Huqhn1BjWnmAD3ltNX?=
 =?us-ascii?Q?WvG699QdbtiE3L0GmS9j1NNNJxuoMZTthOChDSVmyeeU5boKzHzlRv/FXWIB?=
 =?us-ascii?Q?rUfF8UFg+qqv9yhpPdz2PdEFpIMGSLqoaHAOFMRlAk9IIOREGptwOHyWVjIf?=
 =?us-ascii?Q?Z2f8knpDis67ITXrp7gHoyrkoTIpQzA89CbDLIaCYrOWRLuUdJuVRzIf3KG9?=
 =?us-ascii?Q?n7jzp+lf6b4Tu0wg//Nwkngu+TZAIazY8Z+04Sou7LaHp3IXHbuqL4JXibGQ?=
 =?us-ascii?Q?ruJi+cVkxHkMhmZmh6zFdWsWKlqmGsEOFeHq87vPtPlnjeVc+egQfaV1mhxw?=
 =?us-ascii?Q?cQP0zUSSwcBTtUZAg1b/tfiomH3+/omvDuvYH8/v1CHGbNcEv3Le1ysBRbwf?=
 =?us-ascii?Q?AE2xi6f4MYmW9hWB3K/IAOGKTdG+bpYCpfLatkrM4kYdsOETsyclDXjY6GPS?=
 =?us-ascii?Q?I/1+qxmQ7UpaAaLjPQqqGGJn1W+6Lo+3K08KEEb4cqVH97fMNYG6tO4/h72x?=
 =?us-ascii?Q?WFc3imkRxaH93fvJY6bO3OfndRo0ypflO8Ity0/9/ge+If2UE2Ls8/GUJldA?=
 =?us-ascii?Q?AdIY3dxfttpDb5BDXGK5CVaqVMUyI3sD13KTtpwg8UPPumXi1KbchsGtc2hs?=
 =?us-ascii?Q?c9JhhQ7j6cchYXhabrkN1kD3yUoEVbAqzie2MWa4rg2QCwLCGO1aHRPkmEwM?=
 =?us-ascii?Q?2nQEyVTiewHES7ssij3oqEJmNnDrEYa0jnSfmOG9EDXPwm2Ozg3y4uU0syD1?=
 =?us-ascii?Q?s13bpV2vijj2L//s0l+ywLJQl/6ZMRM/3HCqlDIPGAp7iwUzBqDUcDE1QUR4?=
 =?us-ascii?Q?6DHERklYhgrLpgQCFzpNZGksDEql1oN5GDhLEVEcUZREDrJj3Eyj5EuwloDQ?=
 =?us-ascii?Q?U2hhSocmO6J8z0A7MzG6gfZyaFlRflANqu8kmk+EVeVzCdQCKLnH6BUT5pzf?=
 =?us-ascii?Q?/Dmh7ewbNlPQAU+vVtZiUv/I/8LIx9+hYfqqDsNEygqog0K7CIEgzVhNAAwv?=
 =?us-ascii?Q?B+td+Toxu39s5UBl17pYN7Y+DXxdQxnfSroHVGCOmlaj/o5v3oVbhD22CMZv?=
 =?us-ascii?Q?+crSukRz+LtLkKAJj/rb32q1VIqY9l0=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00c6050a-e11d-4640-91d1-08da1da93205
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 23:56:15.5687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T3RZd7cyzqxXt7hlrQHQibOocnWtAvV+d3hcT4DWgRbFMy8dTG9RVw8Sr59RHGLs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4229
X-Proofpoint-GUID: -0G8En44vBs9B1mlqWEcYh11K2h-47fS
X-Proofpoint-ORIG-GUID: -0G8En44vBs9B1mlqWEcYh11K2h-47fS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-13_04,2022-04-13_01,2022-02-23_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 13, 2022 at 03:52:18PM -0700, sdf@google.com wrote:
> On 04/13, Martin KaFai Lau wrote:
> > On Wed, Apr 13, 2022 at 12:52:53PM -0700, Andrii Nakryiko wrote:
> > > On Wed, Apr 13, 2022 at 12:39 PM <sdf@google.com> wrote:
> > > >
> > > > On 04/13, Andrii Nakryiko wrote:
> > > > > On Wed, Apr 13, 2022 at 11:33 AM Stanislav Fomichev <sdf@google.com>
> > > > > wrote:
> > > > > >
> > > > > > Commit 7d08c2c91171 ("bpf: Refactor BPF_PROG_RUN_ARRAY family of
> > macros
> > > > > > into functions") switched a bunch of BPF_PROG_RUN macros to inline
> > > > > > routines. This changed the semantic a bit. Due to arguments
> > expansion
> > > > > > of macros, it used to be:
> > > > > >
> > > > > >         rcu_read_lock();
> > > > > >         array = rcu_dereference(cgrp->bpf.effective[atype]);
> > > > > >         ...
> > > > > >
> > > > > > Now, with with inline routines, we have:
> > > > > >         array_rcu = rcu_dereference(cgrp->bpf.effective[atype]);
> > > > > >         /* array_rcu can be kfree'd here */
> > > > > >         rcu_read_lock();
> > > > > >         array = rcu_dereference(array_rcu);
> > > > > >
> > > >
> > > > > So subtle difference, wow...
> > > >
> > > > > But this open-coding of rcu_read_lock() seems very unfortunate as
> > > > > well. Would making BPF_PROG_RUN_ARRAY back to a macro which only
> > does
> > > > > rcu lock/unlock and grabs effective array and then calls static
> > inline
> > > > > function be a viable solution?
> > > >
> > > > > #define BPF_PROG_RUN_ARRAY_CG_FLAGS(array_rcu, ctx, run_prog,
> > ret_flags) \
> > > > >    ({
> > > > >        int ret;
> > > >
> > > > >        rcu_read_lock();
> > > > >        ret =
> > > > > __BPF_PROG_RUN_ARRAY_CG_FLAGS(rcu_dereference(array_rcu), ....);
> > > > >        rcu_read_unlock();
> > > > >        ret;
> > > > >    })
> > > >
> > > >
> > > > > where __BPF_PROG_RUN_ARRAY_CG_FLAGS is what
> > > > > BPF_PROG_RUN_ARRAY_CG_FLAGS is today but with __rcu annotation
> > dropped
> > > > > (and no internal rcu stuff)?
> > > >
> > > > Yeah, that should work. But why do you think it's better to hide them?
> > > > I find those automatic rcu locks deep in the call stack a bit obscure
> > > > (when reasoning about sleepable vs non-sleepable contexts/bpf).
> > > >
> > > > I, as the caller, know that the effective array is rcu-managed (it
> > > > has __rcu annotation) and it seems natural for me to grab rcu lock
> > > > while work with it; I might grab it for some other things like cgroup
> > > > anyway.
> > >
> > > If you think that having this more explicitly is better, I'm fine with
> > > that as well. I thought a simpler invocation pattern would be good,
> > > given we call bpf_prog_run_array variants in quite a lot of places. So
> > > count me indifferent. I'm curious what others think.
> 
> > Would it work if the bpf_prog_run_array_cg() directly takes the
> > 'struct cgroup *cgrp' argument instead of the array ?
> > bpf_prog_run_array_cg() should know what protection is needed
> > to get member from the cgrp ptr.  The sk call path should be able
> > to provide a cgrp ptr.  For current cgrp, pass NULL as the cgrp
> > pointer and then current will be used in bpf_prog_run_array_cg().
> > A rcu_read_lock() is needed anyway to get the current's cgrp
> > and can be done together in bpf_prog_run_array_cg().
> 
> > That there are only two remaining bpf_prog_run_array() usages
> > from lirc and bpf_trace which are not too bad to have them
> > directly do rcu_read_lock on their own struct ?
> 
> From Andrii's original commit message:
> 
>     I think BPF_PROG_RUN_ARRAY_CG would benefit from further refactoring to
> accept
>     struct cgroup and enum bpf_attach_type instead of bpf_prog_array,
> fetching
>     cgrp->bpf.effective[type] and RCU-dereferencing it internally. But that
>     required including include/linux/cgroup-defs.h, which I wasn't sure is
> ok with
>     everyone.
> 
> I guess including cgroup-defs.h/bpf-cgroup-defs.h into bpf.h might still
> be somewhat problematic?
> 
> But even if we pass the cgroup pointer, I'm assuming that this cgroup
> pointer
> is still rcu-managed, right? So the callers still have to rcu-lock.
> However, in most places we don't care and do "cgrp =
> sock_cgroup_ptr(&sk->sk_cgrp_data);"
> but seems like it depends on the fact that sockets can't (yet?)
> change their cgroup association and it's fine to not rcu-lock that
> cgroup. Seems fragile, but ok.
There is no __rcu tag in struct sock_cgroup_data, so presumably it
won't change or a lock is needed ?  seems to be the former.

> It always stumbles me when I see:
> 
> cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
> bpf_prog_run_array_cg_flags(cgrp.bpf->effective[atype], ...)
> 
> But then, with current, it becomes:
> 
> rcu_read_lock();
> cgrp = task_dfl_cgroup(current);
> bpf_prog_run_array_cg_flags(cgrp.bpf->effective[atype], ...)
> rcu_read_unlock();
> 
> Idk, I might be overthinking it. I'll try to see if including
> bpf-cgroup-defs.h and passing cgroup_bpf is workable.
yeah, passing cgroup_bpf and bpf-cgroup-defs.h is a better option.

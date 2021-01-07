Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1272EC7BE
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 02:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbhAGBat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 20:30:49 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37762 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726367AbhAGBas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 20:30:48 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1071P10X027191;
        Wed, 6 Jan 2021 17:29:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=er5ipm3XGFmXtCw1u19E3GFVw+2eHKJs094JcL5fhg8=;
 b=CKR0dB3Yr5ZGAGjicFA7K5l5gsCfez47+tgsamR1eX2g9e7nLNAMxl6R5kDAu0fsQLyo
 3jqcudRgy4S7aNgnkwn2+jwR5f3seleZ/Y8Zzg9dDU4e4uwVFx7FB2TGXQbK+dHfFU/F
 JnxReDurIo4kqaqrXGQsdpnzXZYsbNYlhtU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35wpuxregd-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 06 Jan 2021 17:29:52 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 6 Jan 2021 17:29:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TDGyzAYZMUY0qWlNKCtJuM9aKGQEjct5lwVsYeiEzMRMwctToHrOJn6iJpnbBG5qgPejsCja3a2+tQkyPsCuBxEuCQBFwQudwmqAvJvH+AwxW431b1HR+Uw6XR0lDhdQXqVpUkuQhF00HXOU9CVVxjH9KrTUp8R+oOirDf1nDGgxfGT7sB2B0pinV9xPQH0/mJi7N8uYIVXYkKNOEete5AfRfmf2gUSM/RhUwEfvHFsVpOJtQPrOlOY2EqhEst6TDOwIS2BwxjINU1mrXYiIOcXGziCP2V9pmsMaeo9EoCSEy8s97s6RXe2V8cqRKBaMa73yNQbgSaorDSsnH8R7xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=er5ipm3XGFmXtCw1u19E3GFVw+2eHKJs094JcL5fhg8=;
 b=OXunwupDxLvsvxjkD9aQF21tNcarV93xnWi1LmPewoCWXmafVgeD/vzki6HvzwSHDMeNe7qMh6o6vVLk4TgzTWl5Cx8Co0kWmMjDls/QJYSgbancOTXI+ACmPi8KJnTMvDZ18EXdoSkdhZZkQVrR1vl+SErpt8Yfm6HeQVFb0yHgii9aNANO/pmO91ZwfkzDXk18cB6/21/wt7RbDTBYmY/X+DBmY+FLmdt27Dr0PQ9zYzTgPAQSY0/epiWcafafiSq/GKQNi04s1Qwkokmb6FYmhooeeT+yRiOY8FnIkiPTxMRGT/tNJNZ7dhvu9EltO9S+jwFNguMnEQ7Ifz3NJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=er5ipm3XGFmXtCw1u19E3GFVw+2eHKJs094JcL5fhg8=;
 b=HsxOkhoYc0lufEb4DLEQ66kjCijP7HDuBt4petbW21H4SLCF4OooNAhOFUOdEaWWGQ+am7a0Xa6b9qJC78aADHZ3is9EiDcv90QCNXKpBXrkCJJnxM9ywRjGS0bBmZFmbfuHryUlAMqGO02k+NXXAKKJuSh5upMok+mv9sK0bNI=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB3461.namprd15.prod.outlook.com (2603:10b6:a03:109::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Thu, 7 Jan
 2021 01:29:50 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::217e:885b:1cef:e1f7]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::217e:885b:1cef:e1f7%7]) with mapi id 15.20.3721.024; Thu, 7 Jan 2021
 01:29:50 +0000
Date:   Wed, 6 Jan 2021 17:29:43 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     <sdf@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, Song Liu <songliubraving@fb.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH bpf-next v3 3/3] bpf: remove extra lock_sock for
 TCP_ZEROCOPY_RECEIVE
Message-ID: <20210107012943.rht4ktth5ecdrz42@kafai-mbp.dhcp.thefacebook.com>
References: <20210105214350.138053-1-sdf@google.com>
 <20210105214350.138053-4-sdf@google.com>
 <20210106194756.vjkulozifc4bfuut@kafai-mbp.dhcp.thefacebook.com>
 <X/Y9pAaiq2FMHoBs@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X/Y9pAaiq2FMHoBs@google.com>
X-Originating-IP: [2620:10d:c090:400::5:5a1c]
X-ClientProxiedBy: MW4PR04CA0304.namprd04.prod.outlook.com
 (2603:10b6:303:82::9) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:5a1c) by MW4PR04CA0304.namprd04.prod.outlook.com (2603:10b6:303:82::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Thu, 7 Jan 2021 01:29:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8881b2db-f966-4504-7f6a-08d8b2abba17
X-MS-TrafficTypeDiagnostic: BYAPR15MB3461:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB346113A60BD8E44446833ECDD5AF0@BYAPR15MB3461.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2rRmZOUHqq8TKzmbHDn7RCauTfFMmutIR1bOaCjR9y+D/go+sXVfz4d6WgxxxhUgPlsjyP9vpObNC2vidmUDTcEUB5cAYaSusPSVuZkLUnN3vW6gRqj+DJHzo3xPQgxTuvbJKHyKiIL3tnfzcazvsxNqlWbIs+2Zz760Uwvtr60UqI2EqnfFzFlR2/XHTbupwXXmPywl1ECs3r3ruyP0oXzDiPlrfhsxrbRDBs3UNIRf9/739+kvq1SAmmDhj55pzkgaVcaYHmzJLCCB4n49GnyYG7fVkA0i62hrZXVGmA42oYp3G/H4VjuvdGb46wldjxFC12QQpSk+4HsYNiskXVW74VPCFqEni+l6qXz7jjbNOXonFLwx1A5FwzB4RgwAGqPwCrmm/ilIm2KTgM2xXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(366004)(39860400002)(346002)(396003)(86362001)(4326008)(8676002)(66476007)(316002)(16526019)(83380400001)(6666004)(186003)(54906003)(6916009)(9686003)(2906002)(8936002)(66556008)(66946007)(52116002)(478600001)(1076003)(6506007)(55016002)(7696005)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?XPlOY4VkDgCbxhhJjZLjigtILhg2YRicJ2GiWGzjU2Ck4QtUkAc7fdHP8pVh?=
 =?us-ascii?Q?zmDur3ym7O5h/k8SDwNQciw2wx1J0YuPvgbKd/4WhZZwNqj6Geo3VSlejlwl?=
 =?us-ascii?Q?gXiTTIPItr7JdBzLkRPy9okzZdkap76A4OU1+YFoGttcU3E+yiTJSaAySGph?=
 =?us-ascii?Q?Gj/+SrXW/PChVbavRKgdxV0u8/0KgkeSmw3FmYNXfEEJNfvztiMbmzVqfJYg?=
 =?us-ascii?Q?eM0Y6fvt+VzKHXl8hKy14SH91LsibnEKUHeoZtFTBqDfxNu69IszJJix+FwV?=
 =?us-ascii?Q?rzIVUuVKBLOXOs1UbmUbjfYXYAt7XGkiZaWoYqFA80/4prt5BFytRVGcDZJ5?=
 =?us-ascii?Q?EnsrkTDwHOYhrgwZ+gUD0l5lqQQ3RhMRwFpi8uScxB6YEgdzGi3GazoVgTL6?=
 =?us-ascii?Q?St/5XyCM0+/429ssXLbVBTXCGDKVKwo8sJb6SqYYWVCT9JwwUF0ANU/Ryw6b?=
 =?us-ascii?Q?GZNsLtsCTJeZbuOCNI7qJU1sQsmijuFMMOayuhJYtm9oPieNbUQP+7jS/v36?=
 =?us-ascii?Q?ZuVoVFf+tPfM+xKKEgttEOJBJuzCmJ530fMbRxck65M9+F7aj7ehxyKlO+WH?=
 =?us-ascii?Q?JU6eLgFmkk3aeS5R1LWRMse9gpkO0areQ52hggQLw2LETY+8G+JD/scHY5nR?=
 =?us-ascii?Q?fPNr+w/Ck3VRUX2LuCvvUw3yDHHn0OSZA3ZglEpA6IKvj66yU3RM0W0XSNQZ?=
 =?us-ascii?Q?oniw8lHdonTK3WuTBnXcTQzJnJlJKvEUCBksEnO9Ig8mpUcGSGGfW7Bxlu7g?=
 =?us-ascii?Q?oXtSoIMM306n+/mVPAF2YVYFWKLT6eumnuk7+0VLBzRhadSjIAkdT4Tu56+t?=
 =?us-ascii?Q?ZXJrvoQOzgX7KJux15MoZWnW05FdJ0+HEKmYoC4MI+dETi+QoaLsJ9EkrhOF?=
 =?us-ascii?Q?aeJJYZ3tjuOZ6tuvPzqCpqJbYwuAHYWGdEYl8/u1suq6XJiGh9dnLbddiIvX?=
 =?us-ascii?Q?Ma5VqnwMuEYs9Q+PM+7R6AkocMu/PrOiNNApGThUXO4dBmURXbZk1SQ7A+u2?=
 =?us-ascii?Q?IFD4CZ7frs8LwH9k49UJ+b8swQ=3D=3D?=
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2021 01:29:50.2480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 8881b2db-f966-4504-7f6a-08d8b2abba17
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uw58fyEapUx/ulo2+spXiJBvgM1a0MikiLEs2zUCvNYKgXNiuNtclOGe3Va7ezrG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3461
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-06_12:2021-01-06,2021-01-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 adultscore=0 suspectscore=0 spamscore=0
 bulkscore=0 mlxscore=0 phishscore=0 malwarescore=0 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101070005
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 06, 2021 at 02:45:56PM -0800, sdf@google.com wrote:
> On 01/06, Martin KaFai Lau wrote:
> > On Tue, Jan 05, 2021 at 01:43:50PM -0800, Stanislav Fomichev wrote:
> > > Add custom implementation of getsockopt hook for TCP_ZEROCOPY_RECEIVE.
> > > We skip generic hooks for TCP_ZEROCOPY_RECEIVE and have a custom
> > > call in do_tcp_getsockopt using the on-stack data. This removes
> > > 3% overhead for locking/unlocking the socket.
> > >
> > > Also:
> > > - Removed BUILD_BUG_ON (zerocopy doesn't depend on the buf size anymore)
> > > - Separated on-stack buffer into bpf_sockopt_buf and downsized to 32
> > bytes
> > >   (let's keep it to help with the other options)
> > >
> > > (I can probably split this patch into two: add new features and rework
> > >  bpf_sockopt_buf; can follow up if the approach in general sounds
> > >  good).
> > >
> > > Without this patch:
> > >      3.29%     0.07%  tcp_mmap  [kernel.kallsyms]  [k]
> > __cgroup_bpf_run_filter_getsockopt
> > >             |
> > >              --3.22%--__cgroup_bpf_run_filter_getsockopt
> > >                        |
> > >                        |--0.66%--lock_sock_nested
> > A general question for sockopt prog, why the BPF_CGROUP_(GET|SET)SOCKOPT
> > prog
> > has to run under lock_sock()?
> I don't think there is a strong reason. We expose sk to the BPF program,
> but mainly for the socket storage map (which, afaik, doesn't require
> socket to be locked). OTOH, it seems that providing a consistent view
> of the sk to the BPF is a good idea.
hmm... most of the bpf prog also does not require a locked sock.  For
example, the __sk_buff->sk.  If a bpf prog needs a locked view of sk,
a more generic solution is desired.  Anyhow, I guess the train has sort
of sailed for sockopt bpf.

> 
> Eric has suggested to try to use fast socket lock. It helps a bit,
> but it doesn't remove the issue completely because
> we do a bunch of copy_{to,from}_user in the generic
> __cgroup_bpf_run_filter_getsockopt as well :-(
> 
> > >                        |
> > >                        |--0.57%--__might_fault
Is it a debug kernel?

> > >                        |
> > >                         --0.56%--release_sock
> > >
> > > With the patch applied:
> > >      0.42%     0.10%  tcp_mmap  [kernel.kallsyms]  [k]
> > __cgroup_bpf_run_filter_getsockopt_kern
> > >      0.02%     0.02%  tcp_mmap  [kernel.kallsyms]  [k]
> > __cgroup_bpf_run_filter_getsockopt
> > >
> > [ ... ]
> 
> > > @@ -1445,15 +1442,29 @@ int __cgroup_bpf_run_filter_getsockopt(struct
> > sock *sk, int level,
> > >  				       int __user *optlen, int max_optlen,
> > >  				       int retval)
> > >  {
> > > -	struct cgroup *cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
> > > -	struct bpf_sockopt_kern ctx = {
> > > -		.sk = sk,
> > > -		.level = level,
> > > -		.optname = optname,
> > > -		.retval = retval,
> > > -	};
> > > +	struct bpf_sockopt_kern ctx;
> > > +	struct bpf_sockopt_buf buf;
> > > +	struct cgroup *cgrp;
> > >  	int ret;
> > >
> > > +#ifdef CONFIG_INET
> > > +	/* TCP do_tcp_getsockopt has optimized getsockopt implementation
> > > +	 * to avoid extra socket lock for TCP_ZEROCOPY_RECEIVE.
> > > +	 */
> > > +	if (sk->sk_prot->getsockopt == tcp_getsockopt &&
> > > +	    level == SOL_TCP && optname == TCP_ZEROCOPY_RECEIVE)
> > > +		return retval;
> > > +#endif
> > That seems too much protocol details and not very scalable.
> > It is not very related to kernel/bpf/cgroup.c which has very little idea
> > whether a specific protocol has optimized things in some ways (e.g. by
> > directly calling cgroup's bpf prog at some strategic places in this
> > patch).
> > Lets see if it can be done better.
> 
> > At least, these protocol checks belong to the net's socket.c
> > more than the bpf's cgroup.c here.  If it also looks like layering
> > breakage in socket.c, may be adding a signal in sk_prot (for example)
> > to tell if the sk_prot->getsockopt has already called the cgroup's bpf
> > prog?  (e.g. tcp_getsockopt() can directly call the cgroup's bpf for all
> > optname instead of only TCP_ZEROCOPY_RECEIVE).
> 
> > For example:
> 
> > int __sys_getsockopt(...)
> > {
> > 	/* ... */
> 
> > 	if (!sk_prot->bpf_getsockopt_handled)
> > 		BPF_CGROUP_RUN_PROG_GETSOCKOPT(...);
> > }
> 
> > Thoughts?
> 
> Sounds good. I didn't go that far because I don't expect there to be
> a lot of special cases like that. But it might be worth supporting
> it in a generic way from the beginning.
> 
> I was thinking about something simpler:
> 
> int __cgroup_bpf_run_filter_getsockopt(sk, ...)
> {
> 	if (sk->sk_prot->bypass_bpf_getsockopt(level, optlen)) {
I think it meant s/optlen/optname/ which is not __user.
Yeah, I think that can provide a more generic solution
and also abstract things away.
Please add a details comment in this function.

> 		return retval;
> 	}
> 
>  	// ...
> }
> 
> Not sure it's worth exposing it to the __sys_getsockopt. WDYT?
or call that in BPF_CGROUP_RUN_PROG_GETSOCKOPT().  then the
changes in __cgroup_bpf_run_filter_getsockopt() in this
patch should go away?


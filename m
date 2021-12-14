Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2629474BAD
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 20:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237284AbhLNTOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 14:14:52 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51526 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234651AbhLNTOw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 14:14:52 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 1BEIc5CG009111;
        Tue, 14 Dec 2021 11:14:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=BUcvFdTq5mcMnUodW9jDJhJTdrebe+dRgpxzOTgCnAI=;
 b=RUHonPts4rDlG0uDC8mqfllh3NmFC/QIjDP86Hfalg/1f3q+Phg0QHHlxiPlH7lCnUxT
 Tti7nt2yCzWonxe1uP5TOQLjWsQxWRVl8uLdxtMxOg01LwBYlSC4mbemulT+PipYTfdk
 lJR31JNXgPDATcl9WKw8QqudT88Cn7NFEL0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net (PPS) with ESMTPS id 3cxs1ec7cq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 14 Dec 2021 11:14:37 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 14 Dec 2021 11:14:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c5+Jq/xkvNupjXNHco1qJ/038DfTEf0785GAqxNu5LD5glztk3gMJ0AGTNLyjWuaVwBdPJzEtRq1um+9i1itXq3EkWZxW3zvpisyHLX8aT+G26IhodMVsW6JMHuV48utGg22F0EOfbbVfYXbRBOGWYwnis3shrflSYC7CzcF0nMRJfpb0ShTBdXku//H7lv2TEZjGX5DNPB4Zc1Wwh4tCW4j3KMn3l6FOiBsy/z5cjjGQh5+qiaJ4rCphE4hasO6zstChnf7R7zkDwOkSzbWiHYfCjbZ7gVJZzTRQb6nMCnqfxcZAKggTMgkZ+e1Kzglh5U5y0c4Z16202s6qyG3og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BUcvFdTq5mcMnUodW9jDJhJTdrebe+dRgpxzOTgCnAI=;
 b=VYNzMr+aSpqFfv4Jl6vFkHTNp7BxdeycbcPs/YcBEDHe9dG2bdb1uAVUSQFNADk0vWqYLRTthh8fiR/M9S9bRTQFtENtWWvE8K5/oePLkEkBGOXYZuqgsNFF43daoT9NCNKEjWKjkcbhkAnmWEc+vBIgUtrbt4H2rGOj30oYvMdJT1jwdHsxOlM2DX6FdmSEW9WICpFNtnZw0dc0eYyurkcFuPP5sYESYcDJ8Xn3zma8S5WdnxedlQIpVn8dp6LN3We+vAtncQ2SHbtU91jU+NEX3zfY8JqmPsSB68HGdP1CdC+wm7mh8FIaPW9UK7GimFpavRjxtMrYM0n+tF5BPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA0PR15MB3821.namprd15.prod.outlook.com (2603:10b6:806:8e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.15; Tue, 14 Dec
 2021 19:14:35 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010%8]) with mapi id 15.20.4778.017; Tue, 14 Dec 2021
 19:14:35 +0000
Date:   Tue, 14 Dec 2021 11:14:30 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] cgroup/bpf: fast path for not loaded skb BPF filtering
Message-ID: <20211214191430.h36grlvnxeicuqea@kafai-mbp.dhcp.thefacebook.com>
References: <d1b6d4756287c28faf9ad9ce824e1a62be9a5e84.1639200253.git.asml.silence@gmail.com>
 <20211214072716.jdemxmsavd6venci@kafai-mbp.dhcp.thefacebook.com>
 <3f89041e-685a-efa5-6405-8ea6a6cf83f3@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3f89041e-685a-efa5-6405-8ea6a6cf83f3@gmail.com>
X-ClientProxiedBy: MW4PR03CA0268.namprd03.prod.outlook.com
 (2603:10b6:303:b4::33) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0efcdcb9-6a43-4cde-1c1c-08d9bf35f6de
X-MS-TrafficTypeDiagnostic: SA0PR15MB3821:EE_
X-Microsoft-Antispam-PRVS: <SA0PR15MB3821B95F70851C504F2805CBD5759@SA0PR15MB3821.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:989;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WfmfiCUE3Yg25MkiOp+Dgul72L4+g44fDeqwKMy+vJYokSQXx0Vn4RApGQJ6dBzrbcxJogrEvNV0Xn5UKCsnEr8IuDtHtblKnVkmvmuNLVvxXpUaXgPH0uItqcJE9buGjJDH/3XorwTRV/Liy97bTBVHPHOjPGm6obMAREZvXl1I38jTjtmZhuyJNfndC39VP1ZC1OUpi8cKWijbhFNjip9Qr0efsU5wgX4uw19uMc4j7fLrOQvS1ze9nUC1W6Iu5KvM2LHYHAqBG3lnWmhzOknmWdhBUnjnl9BH5CovPLdqNP+P+FDO1wg8ZXbx8qAy9G+KyJulgpvSV8Iw+qI96wY3tF/OMDarPcDSPDOA2fYUrhuzMYEQBUpM5ubcsmMq8+TM+DkaQZh0fhjrh1yTZvl2mw4w6VkeVpgTMpEGCr/lTOtVdthUCOmBInAS03gN2Z5rhP6b0gKJUi7wskrRKLmIQto+4VqZMoq8SE3DTGaA3YYleoebtBu2mZwlildd07tiq5WUCMwh6JxBO7lRqRAMPGku6nygLH1XOshZ9LOHnwLTzWYCa8RSuT7iSgXmfsXPyNRiKdeMl7T5pVnZR7t4W9pZVKrSKc60fP8B+U2vriaKxFx5IWiROecC6q/lsAAYoU6ly6s3AgiyHTUYww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(66476007)(38100700002)(54906003)(86362001)(6512007)(6486002)(9686003)(2906002)(52116002)(4326008)(508600001)(83380400001)(316002)(6506007)(66946007)(53546011)(8676002)(186003)(6666004)(1076003)(8936002)(6916009)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0RAI+YVA9FlfeJrfoiPA60wPoC+vnTrft3l1Ruox5oqb5x1hdSrbZtnLRm7X?=
 =?us-ascii?Q?uiqZoa3MUEa+zt2W7FQu7rNeXxPa9K+5mAcoPQZKfR5eEKrLrMQPwhUiZ3OI?=
 =?us-ascii?Q?rT2hhw3tWPGtYXWESdfTHgPgohtre8p4UR92yUS6GW4l+16FjsC7GK4tO5Uw?=
 =?us-ascii?Q?pNiB7V9cmHxGtGNGSVPYw4747QN9kxilPTbKsGYJSqbE8Rqa/y1WvL/BHXHt?=
 =?us-ascii?Q?bT8IYZq7AaCVkwss0Zy7K/EPyzv2hAS/lfL0oGE7sefc0njk7eBkDQAQebP4?=
 =?us-ascii?Q?xqzKwDqZsSFEM7wr3oavZea6CpVcN1Surd5IDhWoexkfQ5c88IZkfTnm1ylL?=
 =?us-ascii?Q?CcZOH/nXjMDbQkUQK/GDUaKBp84Ih3K5ue7z46WZ+gtzKnaDsOKphY57MDJO?=
 =?us-ascii?Q?SOfFklxqKzWhjCgAevDrOhE22o7keTUDG4RzrmTIDJWDRYIvLBwH0NhDwYwq?=
 =?us-ascii?Q?XZcIN1sRrc7nFgHn4NWYQ6fBwLZEufwl23m0t2V1db8tkvVgyIt2WIO9ZJtB?=
 =?us-ascii?Q?zLbSqiKXoacnbqvQczEOMenbpRNTBLJyMf2PsEOoCDrEUrqMKHLWwYBhnEm8?=
 =?us-ascii?Q?DKc/k4zlox7xe1fy6ISOVO/icZbYVNPQ+AACgAKwnclHJZG0nKPcfKUy7oWX?=
 =?us-ascii?Q?b54aqQpxAR7qywyy1zwrGpHQXD0pgFfXz8Cg+0LMaWfW+SjhdPtqoA2XtS6W?=
 =?us-ascii?Q?gacgywzc4tueFjY1QMqTBFsFR63FW0YdqhqwcCBbAZahGqoll2pIIDlim53N?=
 =?us-ascii?Q?7M4+peMC7NdBxU6er+YwvBwgyc91qp1+ODUvoJAxtjQWCrosN5OYD8ZhWtHx?=
 =?us-ascii?Q?RIwOtVDx8De/vKIqidYEZs4/H7bCKfkOCvnFmNB9fZYWRtOdb7qmaBkXiS2p?=
 =?us-ascii?Q?a3GRpNvmqK2/uGubPVF3ZT2CkRWtQxxfJzGQcq55F3l3CFgZxDM3KFzmAhcd?=
 =?us-ascii?Q?cLVgFGJNkqMsY24/l6mMDw06T0R1UEpTG6j/PH4Hs0My9WSRSSuwJa9pYsoJ?=
 =?us-ascii?Q?OHx64/CdgMExHE++Gv4kv8bvdE1WbjZ+3Y3JgWlDSzV5nEIeW9oRDoBfeqea?=
 =?us-ascii?Q?WLRPpoIP9FT/2BDewU7HB1p4PynvLg35j/IIJwO2Yf+18m4WeJ7Xc8Isk3ip?=
 =?us-ascii?Q?yK96TSmNM94oMZj44N/zw8Qq5JTf/6a36QctCctDKQ+ynNmGgOmnJR44QQbm?=
 =?us-ascii?Q?Q27pgkX4ilnZGuLUXAo1TTJfncTgfHycRasn911UxUCU+QScjexhyOOGWY2t?=
 =?us-ascii?Q?t3iKZhcrlRBEGgxjapdNa0SrN7wfvp5X2CiE0iA7xeoO4PDha+cmMUBXsGbT?=
 =?us-ascii?Q?53a97wv9NrwuSMVmyLgyorGo8wDlFA+OG2fuRyQOZaoHGpAGWFbg/h0JkQOd?=
 =?us-ascii?Q?gocZPmhz0H8ARliIxHXjvE1TsCeTpIx1SNINv8rB+RSAoqXmJ9dNlk/fJjis?=
 =?us-ascii?Q?uDo0B8j/p+5hRru8OnWHisSO+Npq+FKuHMKZ8Zn9z1e63qN/YC8VF6kdmaIT?=
 =?us-ascii?Q?Yu9l/IZ79/gNaZsEMHLAJVZwDEsPPoq4Byafp75IOAi8wT0i0u0tFSunXUSw?=
 =?us-ascii?Q?ok5yfzZXNOD2mcoBTu3LXBEuujXVot6t6uRNuxHl?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0efcdcb9-6a43-4cde-1c1c-08d9bf35f6de
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 19:14:35.4798
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c6PZJEk3RMtQZJeI/tY8MnrVt7l7uhXCr3xv2XQM4WM/JanqEbW1RsT6GfsJ0sFy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3821
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: Ey6qYwidGGXVce3LOr_bvOLICldZRkEC
X-Proofpoint-GUID: Ey6qYwidGGXVce3LOr_bvOLICldZRkEC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-14_07,2021-12-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 bulkscore=0
 mlxlogscore=665 lowpriorityscore=0 mlxscore=0 suspectscore=0
 priorityscore=1501 adultscore=0 spamscore=0 impostorscore=0 phishscore=0
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2112140105
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 14, 2021 at 11:40:26AM +0000, Pavel Begunkov wrote:
> On 12/14/21 07:27, Martin KaFai Lau wrote:
> > On Sat, Dec 11, 2021 at 07:17:49PM +0000, Pavel Begunkov wrote:
> > > cgroup_bpf_enabled_key static key guards from overhead in cases where
> > > no cgroup bpf program of a specific type is loaded in any cgroup. Turn
> > > out that's not always good enough, e.g. when there are many cgroups but
> > > ones that we're interesting in are without bpf. It's seen in server
> > > environments, but the problem seems to be even wider as apparently
> > > systemd loads some BPF affecting my laptop.
> > > 
> > > Profiles for small packet or zerocopy transmissions over fast network
> > > show __cgroup_bpf_run_filter_skb() taking 2-3%, 1% of which is from
> > > migrate_disable/enable(), and similarly on the receiving side. Also
> > > got +4-5% of t-put for local testing.
> > What is t-put?  throughput?
> 
> yes
> 
> > Local testing means sending to lo/dummy?
> 
> yes, it was dummy specifically
Thanks for confirming.

Please also put these details in the commit log.
I was slow.  With only '%' as a unit, it took me a min to guess
what t-put may mean ;)

> > [ ... ]
> > 
> > > diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
> > > index 11820a430d6c..793e4f65ccb5 100644
> > > --- a/include/linux/bpf-cgroup.h
> > > +++ b/include/linux/bpf-cgroup.h
> > > @@ -219,11 +219,28 @@ int bpf_percpu_cgroup_storage_copy(struct bpf_map *map, void *key, void *value);
> > >   int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
> > >   				     void *value, u64 flags);
> > > +static inline bool
> > > +__cgroup_bpf_prog_array_is_empty(struct cgroup_bpf *cgrp_bpf,
> > > +				 enum cgroup_bpf_attach_type type)
> > Lets remove this.
> > 
> > > +{
> > > +	struct bpf_prog_array *array = rcu_access_pointer(cgrp_bpf->effective[type]);
> > > +
> > > +	return array == &empty_prog_array.hdr;
> > > +}
> > > +
> > > +#define CGROUP_BPF_TYPE_ENABLED(sk, atype)				       \
> > and change cgroup.c to directly use this instead, so
> > everywhere holding a fullsock sk will use this instead
> > of having two helpers for empty check.
> 
> Why?
As mentioned earlier, prefer to have one way to do the same thing
for checking with a fullsock.

> CGROUP_BPF_TYPE_ENABLED can't be a function atm because of header
> dependency hell, and so it'd kill some of typization, which doesn't add
> clarity.
I didn't mean to change it to a function.  I actually think,
for the sk context, it should eventually be folded with the existing
cgroup_bpf_enabled() macro because those are the tests to ensure
there is bpf prog to run before proceeding.
Need to audit about the non fullsock case. not sure yet.

> And also it imposes some extra overhead to *sockopt using
> the first helper directly.
I think it is unimportant unless it is measurable in normal
use case.

> I think it's better with two of them.
Ok. I won't insist.  There are atype that may not have sk, so
a separate inline function for checking emptiness may eventually
be useful there.

> I could inline the second one, but it wouldn't have been pretty.
Leaving CGROUP_BPF_TYPE_ENABLED as macro is fine.

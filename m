Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E76D4966B1
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 21:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbiAUU5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 15:57:05 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:9450 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230333AbiAUU5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 15:57:04 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 20LFmfZg005209;
        Fri, 21 Jan 2022 12:56:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=vsucrDmMC+6XNQpHTtuhM83Ri5HIl8xjfgnzy1c1QZg=;
 b=K4TQlWNhHV6GIo9VQ5JCxjnTiYP93U/5TyNdzxqKhhFgJ5P5xxXf/KPeo5dLej2p6ZkJ
 c3wLIrGIsZOrvCnMKliF7cRoL/7x8TeVsPcnazKDx5DI/CdGLP2kxjMeoeK9Vm7rFLzS
 mO1kXj0IiVKNez4gC3pZRKdW6eJXMgTmHdw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net (PPS) with ESMTPS id 3dqhy4nwhu-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 21 Jan 2022 12:56:48 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 21 Jan 2022 12:56:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BCO0/AOYprlj11Paon7B2uOsjVXgYF2FfrCsTmTK5vA0wzdXYnqdhWyplUVud1JkseKjAAQqxhUQnXUw058PtIeJcGHHwXw4QKJjyRKM2V9J72cRi+zjIVwtCTvwtMwzDwKxZME7F+NUjWcQwWZWflsrQJe8twCTSoEZNiFTmnIs5gM6X1VMcM/Q0s+8HdrF2V4CaeHxCKeEGhOYmsgFDsuFZgLB3YuA+kOs65dQ8LKm1WAMHUWLBUj/IWQ6ZFaOCQ05Gsty/ID9V86+QCmDOcxZzJ+uk04/GzRA4Z5mJdDrS52rR8VOebn96HwKbifPV21y7/pWQ7KxR7tU/TFDXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vsucrDmMC+6XNQpHTtuhM83Ri5HIl8xjfgnzy1c1QZg=;
 b=GJqgduIVd6wRpYcRviIizCWnA5fIXAEy5wjy6OgWpWUIAYLcotRRWnNlAWr/lvShA+AIsRHAonrP6C8Xi7ftEkh7uFq+Xs47JH+u7gWMiu2U03+QTWe7yuK6WFNsoalCSglEfdbcu8jn+Q+O5O/VOSZSWXXgSHzRLQYcdJDjxQrs1FM2zm9CHrTUYyur2lphSC82AntxZx6qgz4dHwJj+bR0Aps7GMdZysqOdwVdp4eh5lMk/16PI0XTZnuCbLUyC/xNjFnxU2e2OFtHqFx2pS/9FesmlFH2amMh4AhOO7aR4NBhQtKqpE1EgLhc+2hy5E8oo3qaG8kotEQtIyLl1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SN6PR15MB2432.namprd15.prod.outlook.com (2603:10b6:805:24::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.12; Fri, 21 Jan
 2022 20:56:41 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::b0ca:a63e:fb69:6437]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::b0ca:a63e:fb69:6437%6]) with mapi id 15.20.4909.012; Fri, 21 Jan 2022
 20:56:41 +0000
Date:   Fri, 21 Jan 2022 12:56:37 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     <sdf@google.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [RFC PATCH v3 net-next 4/4] bpf: Add
 __sk_buff->mono_delivery_time and handle __sk_buff->tstamp based on
 tc_at_ingress
Message-ID: <20220121205637.ip4eax3mhsaod74k@kafai-mbp.dhcp.thefacebook.com>
References: <20220121073026.4173996-1-kafai@fb.com>
 <20220121073051.4180328-1-kafai@fb.com>
 <YesAbHLRYBJ8FwiK@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <YesAbHLRYBJ8FwiK@google.com>
X-ClientProxiedBy: MWHPR19CA0062.namprd19.prod.outlook.com
 (2603:10b6:300:94::24) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 12a09613-54ca-4860-c8f5-08d9dd20867a
X-MS-TrafficTypeDiagnostic: SN6PR15MB2432:EE_
X-Microsoft-Antispam-PRVS: <SN6PR15MB24322CBA5590567EFB711268D55B9@SN6PR15MB2432.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DRqaJOjWUowDcG1FZaHAG+qd+46gtUyu/MvQyldDxDtlylTi6MF/qtdO+svNZA6S1xMmwRcLIjnO+0WH8IFJQvr57H5w/W1uktOClGueS8meVeF04mHN+PuC7YMrE5Kn1h4L5jAMzi0YxM9Ge4rxiq5cR7T3QW7WgwtVujxx13KMuE5DWNVIWbjytkFGxFTitUfYSBFIbQLppdffFSWKrdmQAcu9gVBAzufyRZ5E3smfQddFT4nhRcxunK5tMiEn1LPs70X+aAoMXkS4eFaRA99+T4ZTpzv+bQNL7r9uSBwbWFUdGBeyyAvZMHNmlpGlDaVeMyJMkfbJyqI36i2d+l7CeWWWSlPM92Sc4An9p204dGVlXYLqjSwDTHLQULIO2fYZ6Lol7WyT1rxR1egDNs4+IQn1hE8X6eTkwCw3iFfkbT9ORxqCwY2DABOcRFHv6EtPsk67Nm3HHPytbhJtISdt0p9c26fEeeLNlfugj0y8Akuc8a6oRqVgrEwHBgLoIHuO4jxkaHo5HN5kLI70MGrmlPKTURlMbzje8nVjavSrKa2vJebtal+Ops3CH8qlfba6i5JtYyY7439s1YQlbIDXHgj8rWaUrSzx7DSUilN4pGE1JpJKBhiCrOFPcT5OUUwpslAPiK8lMXX2EHaovTpKVhHhtPqK4O5PVdE7eANqF42UIfLaxVH82mpdz7HX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(2906002)(9686003)(83380400001)(6512007)(316002)(6506007)(186003)(52116002)(5660300002)(30864003)(8676002)(66946007)(66476007)(508600001)(66556008)(4326008)(6916009)(1076003)(6486002)(7416002)(8936002)(86362001)(54906003)(6666004)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ciOE6070EMps9+RTNp1tmw3b4xFqysHSo908ipk33AI60HUI8gSZAcQWuJz+?=
 =?us-ascii?Q?Gmv8mFvS7XBdY2ImASjIzv16cLbB5HV6wBV92gQ9Z46gdehJbgLlwktvi3ev?=
 =?us-ascii?Q?RiVYcPQQEX5ZhtqGyUbJckBCPQDpv7JKF7CxfzcCqEpGJJ2TPoBY8q6Xt64I?=
 =?us-ascii?Q?6/UQIT3dF1g27NWvFmeJ8uq/8pNKCLW+6EpkHbNFFNSpII26g5jLoh0itwE4?=
 =?us-ascii?Q?vlsEYGDuS/mtoeOC1hxO1tH1jaFhRh2p2YdNsbd3KrDJNT0NOLXPUUeVWZe4?=
 =?us-ascii?Q?pd8E2tuCNLB2kO/F+0PKENxa4FS70qGg5LmtsjTfhhpsQ32mkiMWa0x3j9tD?=
 =?us-ascii?Q?QXvBNAxP5gdwidJ8IVI3WF57UiOaJuIiC5e4fvP0ULHJA053AJIwq/ZARxcJ?=
 =?us-ascii?Q?rjuHwFujRidd3mM1ByXupINw2A4Z47iF5FcTJ8g0MoSuQKhe7a1+j7uHeweI?=
 =?us-ascii?Q?b55g8syS8lQaLNPdWr+4AqZI83mQCEFOhu+fC9H9ZvQ3JAyRbfrPs1zo9oXZ?=
 =?us-ascii?Q?2RGbPkLpa8sKI/Q6p52sOPc+LglstceA3G0yOisH2X356wxLpX5bgsVuXDGg?=
 =?us-ascii?Q?b/USU563nddBR1W4j5fLt+D9+RDnITCjUuyVQWs7w+pcX4VcvnJRwZRP5UPE?=
 =?us-ascii?Q?zSiPQ6TjS/JUirwlEzM5ZLS4zmR0W2qensTAzlwWrINFy0vJOzSttcX8mTvK?=
 =?us-ascii?Q?I0VQFO36LuhqG/ZzcxHwd8Qk9vIlyqY/peYrZTPGQH4Be/rMrCBCssooo0zg?=
 =?us-ascii?Q?XiDKE7Jr1HH6ZupGv8+CQhrHPq6dRQ4KMQKFvJ0UZI4NH90yCmxe5vH8GLLM?=
 =?us-ascii?Q?RaWAjr0bfDPFRKJNtBnH67NsBS32d6j46fBfWjcFqihR9liwG6waLr5kUoOo?=
 =?us-ascii?Q?Tq2m998IugUDcGwLiVw2sYEpQqvm6+vWqrfForM6YQgaP8xAqUsxFmN90BON?=
 =?us-ascii?Q?4pEo9gNrxVf+PPeFQwLZCm9CmvyHUrR1ljXB3WKMf/Yi1mWOPt/l8WuoDnyh?=
 =?us-ascii?Q?5A4dITxJCMRBZOCWSYK3wZ2UIAWForeXfo05/fxtE8+TPUy4Jq/IfiEk0s3V?=
 =?us-ascii?Q?quSdvmRoqVQpzhPqYgivtk2D9bGWFMTqaai+bH3aD1Tx1IuZYrCHbAu7wbqE?=
 =?us-ascii?Q?s00zp29L3996h83mIUkpr/3ZS/skh+sVod130bZWmmFxIiw0xTfSItyO2jUh?=
 =?us-ascii?Q?etD8I494vLDFUY4DFwGNoUtCJGWEUeB/ihOjegdBBxq4pUFYv3rCEVaBiQKe?=
 =?us-ascii?Q?WU8S9PIS6IKhp7DRrBoWscQhIyz6bNHFxhSo+usHiVBUAv9hp5efbWIw1wSl?=
 =?us-ascii?Q?LxPKMftWtyhTkYyMZn8pfYEQR+Aw7jcLmECp3wDGee0FkG/87m0xJxE4i8UZ?=
 =?us-ascii?Q?SA9yBKSS2R/fK8ZmD1lVZNSCvnPy33cOZ/yLUDJ6vUA0I71l2bJTMn7B0fBe?=
 =?us-ascii?Q?zlJuY/DBCR13Io00fmeSh5jakR3njUyz8dl5q+nojYY7cdQ/zQWKc1KPXnan?=
 =?us-ascii?Q?XBxW6CaCfSx46mvO12XLkNJhKqIK94zQfILH1/uJ9fIKo0JDDXdHks3Rs6QS?=
 =?us-ascii?Q?SSxEARRlB5/PpjOErG8MEYrfIwiKvFUKyJo9OF3k?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 12a09613-54ca-4860-c8f5-08d9dd20867a
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2022 20:56:41.7489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4K4npvmye0Kz9kZXL2hq/uM4eO15hPKZezDukkwWu11K7EsqJGUaBsYsRIprAh0u
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2432
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: LJ29S-eZk_evTHGcJG4Xmpdz4ExTL_p2
X-Proofpoint-GUID: LJ29S-eZk_evTHGcJG4Xmpdz4ExTL_p2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-21_10,2022-01-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 impostorscore=0
 spamscore=0 malwarescore=0 adultscore=0 clxscore=1011 mlxlogscore=999
 bulkscore=0 phishscore=0 suspectscore=0 lowpriorityscore=0 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201210133
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 21, 2022 at 10:50:20AM -0800, sdf@google.com wrote:
> On 01/20, Martin KaFai Lau wrote:
> > __sk_buff->mono_delivery_time:
> > This patch adds __sk_buff->mono_delivery_time to
> > read and write the mono delivery_time in skb->tstamp.
> 
> > The bpf rewrite is like:
> > /* BPF_READ: __u64 a = __sk_buff->mono_delivery_time; */
> > if (skb->mono_delivery_time)
> > 	a = skb->tstamp;
> > else
> > 	a = 0;
> 
> > /* BPF_WRITE: __sk_buff->mono_delivery_time = a; */
> > skb->tstamp = a;
> > skb->mono_delivery_time = !!a;
> 
> > __sk_buff->tstamp:
> > The bpf rewrite is like:
> > /* BPF_READ: __u64 a = __sk_buff->tstamp; */
> > if (skb->tc_at_ingress && skb->mono_delivery_time)
> > 	a = 0;
> > else
> > 	a = skb->tstamp;
> 
> > /* BPF_WRITE: __sk_buff->tstamp = a; */
> > skb->tstamp = a;
> > if (skb->tc_at_ingress || !a)
> > 	skb->mono_delivery_time = 0;
> 
> > At egress, reading is the same as before.  All skb->tstamp
> > is the delivery_time.  Writing will not change the (kernel)
> > skb->mono_delivery_time also unless 0 is being written.  This
> > will be the same behavior as before.
> 
> > (#) At ingress, the current bpf prog can only expect the
> > (rcv) timestamp.  Thus, both reading and writing are now treated as
> > operating on the (rcv) timestamp for the existing bpf prog.
> 
> > During bpf load time, the verifier will learn if the
> > bpf prog has accessed the new __sk_buff->mono_delivery_time.
> 
> > When reading at ingress, if the bpf prog does not access the
> > new __sk_buff->mono_delivery_time, it will be treated as the
> > existing behavior as mentioned in (#) above.  If the (kernel) skb->tstamp
> > currently has a delivery_time,  it will temporary be saved first and then
> > set the skb->tstamp to either the ktime_get_real() or zero.  After
> > the bpf prog finished running, if the bpf prog did not change
> > the skb->tstamp,  the saved delivery_time will be restored
> > back to the skb->tstamp.
> 
> > When writing __sk_buff->tstamp at ingress, the
> > skb->mono_delivery_time will be cleared because of
> > the (#) mentioned above.
> 
> > If the bpf prog does access the new __sk_buff->mono_delivery_time
> > at ingress, it indicates that the bpf prog is aware of this new
> > kernel support:
> > the (kernel) skb->tstamp can have the delivery_time or the
> > (rcv) timestamp at ingress.  If the __sk_buff->mono_delivery_time
> > is available, the __sk_buff->tstamp will not be available and
> > it will be zero.
> 
> > The bpf rewrite needs to access the skb's mono_delivery_time
> > and tc_at_ingress bit.  They are moved up in sk_buff so
> > that bpf rewrite can be done at a fixed offset.  tc_skip_classify
> > is moved together with tc_at_ingress.  To get one bit for
> > mono_delivery_time, csum_not_inet is moved down and this bit
> > is currently used by sctp.
> 
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
> >   include/linux/filter.h         |  31 +++++++-
> >   include/linux/skbuff.h         |  20 +++--
> >   include/uapi/linux/bpf.h       |   1 +
> >   net/core/filter.c              | 134 ++++++++++++++++++++++++++++++---
> >   net/sched/act_bpf.c            |   5 +-
> >   net/sched/cls_bpf.c            |   6 +-
> >   tools/include/uapi/linux/bpf.h |   1 +
> >   7 files changed, 171 insertions(+), 27 deletions(-)
> 
> > diff --git a/include/linux/filter.h b/include/linux/filter.h
> > index 71fa57b88bfc..5cef695d6575 100644
> > --- a/include/linux/filter.h
> > +++ b/include/linux/filter.h
> > @@ -572,7 +572,8 @@ struct bpf_prog {
> >   				has_callchain_buf:1, /* callchain buffer allocated? */
> >   				enforce_expected_attach_type:1, /* Enforce expected_attach_type
> > checking at attach time */
> >   				call_get_stack:1, /* Do we call bpf_get_stack() or
> > bpf_get_stackid() */
> > -				call_get_func_ip:1; /* Do we call get_func_ip() */
> > +				call_get_func_ip:1, /* Do we call get_func_ip() */
> > +				delivery_time_access:1; /* Accessed __sk_buff->mono_delivery_time */
> >   	enum bpf_prog_type	type;		/* Type of BPF program */
> >   	enum bpf_attach_type	expected_attach_type; /* For some prog types */
> >   	u32			len;		/* Number of filter blocks */
> > @@ -699,6 +700,34 @@ static inline void bpf_compute_data_pointers(struct
> > sk_buff *skb)
> >   	cb->data_end  = skb->data + skb_headlen(skb);
> >   }
> 
> > +static __always_inline u32 bpf_prog_run_at_ingress(const struct
> > bpf_prog *prog,
> > +						   struct sk_buff *skb)
> > +{
> > +	ktime_t tstamp, delivery_time = 0;
> > +	int filter_res;
> > +
> > +	if (unlikely(skb->mono_delivery_time) && !prog->delivery_time_access) {
> > +		delivery_time = skb->tstamp;
> > +		skb->mono_delivery_time = 0;
> > +		if (static_branch_unlikely(&netstamp_needed_key))
> > +			skb->tstamp = tstamp = ktime_get_real();
> > +		else
> > +			skb->tstamp = tstamp = 0;
> > +	}
> > +
> > +	/* It is safe to push/pull even if skb_shared() */
> > +	__skb_push(skb, skb->mac_len);
> > +	bpf_compute_data_pointers(skb);
> > +	filter_res = bpf_prog_run(prog, skb);
> > +	__skb_pull(skb, skb->mac_len);
> > +
> > +	/* __sk_buff->tstamp was not changed, restore the delivery_time */
> > +	if (unlikely(delivery_time) && skb_tstamp(skb) == tstamp)
> > +		skb_set_delivery_time(skb, delivery_time, true);
> > +
> > +	return filter_res;
> > +}
> > +
> >   /* Similar to bpf_compute_data_pointers(), except that save orginal
> >    * data in cb->data and cb->meta_data for restore.
> >    */
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index 4677bb6c7279..a14b04b86c13 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -866,22 +866,23 @@ struct sk_buff {
> >   	__u8			vlan_present:1;	/* See PKT_VLAN_PRESENT_BIT */
> >   	__u8			csum_complete_sw:1;
> >   	__u8			csum_level:2;
> > -	__u8			csum_not_inet:1;
> >   	__u8			dst_pending_confirm:1;
> > +	__u8			mono_delivery_time:1;
> > +
> > +#ifdef CONFIG_NET_CLS_ACT
> > +	__u8			tc_skip_classify:1;
> > +	__u8			tc_at_ingress:1;
> > +#endif
> >   #ifdef CONFIG_IPV6_NDISC_NODETYPE
> >   	__u8			ndisc_nodetype:2;
> >   #endif
> > -
> > +	__u8			csum_not_inet:1;
> >   	__u8			ipvs_property:1;
> >   	__u8			inner_protocol_type:1;
> >   	__u8			remcsum_offload:1;
> >   #ifdef CONFIG_NET_SWITCHDEV
> >   	__u8			offload_fwd_mark:1;
> >   	__u8			offload_l3_fwd_mark:1;
> > -#endif
> > -#ifdef CONFIG_NET_CLS_ACT
> > -	__u8			tc_skip_classify:1;
> > -	__u8			tc_at_ingress:1;
> >   #endif
> >   	__u8			redirected:1;
> >   #ifdef CONFIG_NET_REDIRECT
> > @@ -894,7 +895,6 @@ struct sk_buff {
> >   	__u8			decrypted:1;
> >   #endif
> >   	__u8			slow_gro:1;
> > -	__u8			mono_delivery_time:1;
> 
> >   #ifdef CONFIG_NET_SCHED
> >   	__u16			tc_index;	/* traffic control index */
> > @@ -972,10 +972,16 @@ struct sk_buff {
> >   /* if you move pkt_vlan_present around you also must adapt these
> > constants */
> >   #ifdef __BIG_ENDIAN_BITFIELD
> >   #define PKT_VLAN_PRESENT_BIT	7
> > +#define TC_AT_INGRESS_SHIFT	0
> > +#define SKB_MONO_DELIVERY_TIME_SHIFT 2
> >   #else
> >   #define PKT_VLAN_PRESENT_BIT	0
> > +#define TC_AT_INGRESS_SHIFT	7
> > +#define SKB_MONO_DELIVERY_TIME_SHIFT 5
> >   #endif
> >   #define PKT_VLAN_PRESENT_OFFSET	offsetof(struct sk_buff,
> > __pkt_vlan_present_offset)
> > +#define TC_AT_INGRESS_OFFSET offsetof(struct sk_buff,
> > __pkt_vlan_present_offset)
> > +#define SKB_MONO_DELIVERY_TIME_OFFSET offsetof(struct sk_buff,
> > __pkt_vlan_present_offset)
> 
> >   #ifdef __KERNEL__
> >   /*
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index b0383d371b9a..83725c891f3c 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -5437,6 +5437,7 @@ struct __sk_buff {
> >   	__u32 gso_size;
> >   	__u32 :32;		/* Padding, future use. */
> >   	__u64 hwtstamp;
> > +	__u64 mono_delivery_time;
> >   };
> 
> >   struct bpf_tunnel_key {
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 4fc53d645a01..db17812f0f8c 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -7832,6 +7832,7 @@ static bool bpf_skb_is_valid_access(int off, int
> > size, enum bpf_access_type type
> >   			return false;
> >   		break;
> >   	case bpf_ctx_range(struct __sk_buff, tstamp):
> > +	case bpf_ctx_range(struct __sk_buff, mono_delivery_time):
> >   		if (size != sizeof(__u64))
> >   			return false;
> >   		break;
> > @@ -7872,6 +7873,7 @@ static bool sk_filter_is_valid_access(int off, int
> > size,
> >   	case bpf_ctx_range(struct __sk_buff, tstamp):
> >   	case bpf_ctx_range(struct __sk_buff, wire_len):
> >   	case bpf_ctx_range(struct __sk_buff, hwtstamp):
> > +	case bpf_ctx_range(struct __sk_buff, mono_delivery_time):
> >   		return false;
> >   	}
> 
> > @@ -7911,6 +7913,7 @@ static bool cg_skb_is_valid_access(int off, int
> > size,
> >   		case bpf_ctx_range_till(struct __sk_buff, cb[0], cb[4]):
> >   			break;
> >   		case bpf_ctx_range(struct __sk_buff, tstamp):
> > +		case bpf_ctx_range(struct __sk_buff, mono_delivery_time):
> >   			if (!bpf_capable())
> >   				return false;
> >   			break;
> > @@ -7943,6 +7946,7 @@ static bool lwt_is_valid_access(int off, int size,
> >   	case bpf_ctx_range(struct __sk_buff, tstamp):
> >   	case bpf_ctx_range(struct __sk_buff, wire_len):
> >   	case bpf_ctx_range(struct __sk_buff, hwtstamp):
> > +	case bpf_ctx_range(struct __sk_buff, mono_delivery_time):
> >   		return false;
> >   	}
> 
> > @@ -8169,6 +8173,7 @@ static bool tc_cls_act_is_valid_access(int off,
> > int size,
> >   		case bpf_ctx_range_till(struct __sk_buff, cb[0], cb[4]):
> >   		case bpf_ctx_range(struct __sk_buff, tstamp):
> >   		case bpf_ctx_range(struct __sk_buff, queue_mapping):
> > +		case bpf_ctx_range(struct __sk_buff, mono_delivery_time):
> >   			break;
> >   		default:
> >   			return false;
> > @@ -8445,6 +8450,7 @@ static bool sk_skb_is_valid_access(int off, int
> > size,
> >   	case bpf_ctx_range(struct __sk_buff, tstamp):
> >   	case bpf_ctx_range(struct __sk_buff, wire_len):
> >   	case bpf_ctx_range(struct __sk_buff, hwtstamp):
> > +	case bpf_ctx_range(struct __sk_buff, mono_delivery_time):
> >   		return false;
> >   	}
> 
> > @@ -8603,6 +8609,114 @@ static struct bpf_insn
> > *bpf_convert_shinfo_access(const struct bpf_insn *si,
> >   	return insn;
> >   }
> 
> 
> [..]
> 
> > +static struct bpf_insn *bpf_convert_tstamp_read(const struct bpf_insn
> > *si,
> > +						struct bpf_insn *insn)
> > +{
> > +	__u8 value_reg = si->dst_reg;
> > +	__u8 skb_reg = si->src_reg;
> > +	__u8 tmp_reg = BPF_REG_AX;
> > +
> > +#ifdef CONFIG_NET_CLS_ACT
> > +	*insn++ = BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg, TC_AT_INGRESS_OFFSET);
> > +	*insn++ = BPF_ALU32_IMM(BPF_AND, tmp_reg, 1 << TC_AT_INGRESS_SHIFT);
> > +	*insn++ = BPF_JMP32_IMM(BPF_JEQ, tmp_reg, 0, 5);
> > +	/* @ingress, read __sk_buff->tstamp as the (rcv) timestamp,
> > +	 * so check the skb->mono_delivery_time.
> > +	 */
> > +	*insn++ = BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg,
> > +			      SKB_MONO_DELIVERY_TIME_OFFSET);
> > +	*insn++ = BPF_ALU32_IMM(BPF_AND, tmp_reg,
> > +				1 << SKB_MONO_DELIVERY_TIME_SHIFT);
> > +	*insn++ = BPF_JMP32_IMM(BPF_JEQ, tmp_reg, 0, 2);
> > +	/* skb->mono_delivery_time is set, read 0 as the (rcv) timestamp. */
> > +	*insn++ = BPF_MOV64_IMM(value_reg, 0);
> > +	*insn++ = BPF_JMP_A(1);
> > +#endif
> > +
> > +	*insn++ = BPF_LDX_MEM(BPF_DW, value_reg, skb_reg,
> > +			      offsetof(struct sk_buff, tstamp));
> > +	return insn;
> > +}
> > +
> > +static struct bpf_insn *bpf_convert_tstamp_write(const struct bpf_insn
> > *si,
> > +						 struct bpf_insn *insn)
> > +{
> > +	__u8 value_reg = si->src_reg;
> > +	__u8 skb_reg = si->dst_reg;
> > +	__u8 tmp_reg = BPF_REG_AX;
> > +
> > +	/* skb->tstamp = tstamp */
> > +	*insn++ = BPF_STX_MEM(BPF_DW, skb_reg, value_reg,
> > +			      offsetof(struct sk_buff, tstamp));
> > +
> > +#ifdef CONFIG_NET_CLS_ACT
> > +	*insn++ = BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg, TC_AT_INGRESS_OFFSET);
> > +	*insn++ = BPF_ALU32_IMM(BPF_AND, tmp_reg, 1 << TC_AT_INGRESS_SHIFT);
> > +	*insn++ = BPF_JMP32_IMM(BPF_JNE, tmp_reg, 0, 1);
> > +#endif
> > +
> > +	/* test tstamp != 0 */
> > +	*insn++ = BPF_JMP_IMM(BPF_JNE, value_reg, 0, 3);
> > +	/* writing __sk_buff->tstamp at ingress or writing 0,
> > +	 * clear the skb->mono_delivery_time.
> > +	 */
> > +	*insn++ = BPF_LDX_MEM(BPF_B, tmp_reg, skb_reg,
> > +			      SKB_MONO_DELIVERY_TIME_OFFSET);
> > +	*insn++ = BPF_ALU32_IMM(BPF_AND, tmp_reg,
> > +				~(1 << SKB_MONO_DELIVERY_TIME_SHIFT));
> > +	*insn++ = BPF_STX_MEM(BPF_B, skb_reg, tmp_reg,
> > +			      SKB_MONO_DELIVERY_TIME_OFFSET);
> > +
> > +	return insn;
> > +}
> 
> I wonder if we'll see the regression from this. We read/write tstamp
> frequently and I'm not sure we care about the forwarding case.
>
> As a future work/follow up, do you think we can support cases like
> bpf_prog_load(prog_type=SCHED_CLS expected_attach_type=TC_EGRESS) where
> we can generate bytecode with only BPF_LDX_MEM/BPF_STX_MEM for skb->tstamp?
> (essentially a bytecode as it was prior to your patch series)
>
> Since we know that that specific program will run only at egress,
> I'm assuming we can generate simpler bytecode? (of coarse it needs more
> work on cls_bpf to enforce this new expected_attach_type constraint)
The common (if not the only useful?) use case for reading/writing
skb->tstamp should be at egress now.  For this case, the patch added
test on skb->tc_at_ingress and test the writing value is non-zero.  The
skb->mono_delivery_time bit should not be touched in this common
case at egress.  Even with expected_attach_type=TC_EGRESS, it could save
testing the tc_at_ingress (3 bpf insns) but it still needs to test the
writing value is non-zero (1 bpf insn).  Regardless, I  doubt there
is any meaningful difference for these two new tests considering other
things that a typical bpf prog is doing (e.g. parsing header,
lookup map...) and also other logic in the stack's egress path.

For adding expected_attach_type=TC_EGRESS in the future for perf reason
alone... hmm... I suspect it will make it harder/confuse to use but yeah if
there is a convincing difference to justify that.

Unrelated to the perf topic but related to adding expected_attach_type,
I had considered adding an expected_attach_type but not for the
perf reason.

The consideration was to use expected_attach_type to distinguish the
__sk_buff->tstamp behavior on ingress, although I have a hard time
thinking of a reasonable use case on accessing __sk_buff->tstamp at ingress
other than printing the (rcv) timestamp out (which could also be 0).

However, I guess we have to assume we cannot break the ingress
behavior now.  The dance in bpf_prog_run_at_ingress() in this patch
is to keep the (rcv) timestamp behavior for the existing tc-bpf@ingress.
My initial thought was to add expected_attach_type=TC_DELIVERY_TIME
to signal the bpf prog is expecting skb->tstamp could have the delviery_time at
ingress but then later I think learning this in prog->delivery_time_access
during verification should be as good, so dismissed the expected_attach_type
idea and save the user from remembering when to use this
new expected_attach_type.

Thanks for the review !

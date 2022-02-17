Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1E8B4B997B
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 07:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233851AbiBQGxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 01:53:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232385AbiBQGxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 01:53:06 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB8D274CA2;
        Wed, 16 Feb 2022 22:52:50 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21H1ZEQP005098;
        Wed, 16 Feb 2022 22:52:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=CpT9Jj6VdgUZCm5IqQknaq9j43AEkxkKrxqLJ+00FOw=;
 b=NkF+/ChqnBg/tehGFD1FXHNqlZ1k7M2z3MbsHrL/YQGvyJrdWYdeGba2bOHo0ZaQDUiC
 NSa2c60jSygI8hwaj1n00n+3TdcCkQegzFfuWP1ZJsCzS4N7Z8fxyb3kHyK7dd7Nh3Cz
 8vYAoeKurDAeGfUvDwawlYld7uZAsN2zz/Y= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e92mq6076-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 16 Feb 2022 22:52:32 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 16 Feb 2022 22:52:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nVGIpNXHvS1CxI9ArZUS3MeFcLSrzp/FA58l3zvyk5k78TlXRj2DGQVmQZ8oV0EBJzmF4Xgu/MVvsxYjPDrCplRGEhOKGl+1nMBlOTbp8nbYMKt45M8gj07NlhV+chHYIN8cyjSPDFG4Hu+lpKLa9ddtUe6mY8WebZK53YN/VXKR9ilZ0fdXnDg3OBB2Quk9WcvedhIrOcPzcAPbNK+j0YHkOho8090Uvusg44k3e6kSfRpOsOOaEMCXaVHg6k3Cs7U0OWvCrrPp4XXm3hdD6hjzHJjbgjwTjMmF3v5WZAO4GK/b+N4ytFaAgy5djjhHhoul1wSILqPxALX31l8RUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CpT9Jj6VdgUZCm5IqQknaq9j43AEkxkKrxqLJ+00FOw=;
 b=KXrGBLIb17QUc2pWcYqbvn08rVOVLU9mamODbz2uur6YJi0bHIjGsV2mtpZwyfEn6M6m1e4tpjAnNTlzTqgAwCq7NC2meEDu4xFzKtsH+QVE6o9L/G/CElxx6h/ocvCPt5x2HgvIZyWv1FufAD06HfbxiqXe+OjhzH4rFqFVTjHwzNF6l7C+soYFJAwLupE3OrS/C2VYrlTamEfEvJHDEitQh2m3+qPPdyweMtXjmApJzqxSbSGu3nJIf8+RU7bawbPbkWHVWTIY31K0V8wXRslaJSVRBuukX31uCJBQKMgATf3ZNi4hui7xYhGneNW9RPu8hdDGvYcqNe7aHwQPWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by BYAPR15MB3350.namprd15.prod.outlook.com (2603:10b6:a03:109::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.19; Thu, 17 Feb
 2022 06:52:28 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1d2d:7a0f:fa57:cbdd]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1d2d:7a0f:fa57:cbdd%6]) with mapi id 15.20.4995.016; Thu, 17 Feb 2022
 06:52:28 +0000
Date:   Wed, 16 Feb 2022 22:52:24 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH v4 net-next 5/8] bpf: Keep the (rcv) timestamp behavior
 for the existing tc-bpf@ingress
Message-ID: <20220217065224.oytqoivpngwvsufn@kafai-mbp.dhcp.thefacebook.com>
References: <20220211071232.885225-1-kafai@fb.com>
 <20220211071303.890169-1-kafai@fb.com>
 <f0d76498-0bb1-36a6-0c8c-b334f6fb13c2@iogearbox.net>
 <20220216055142.n445wwtqmqewc57a@kafai-mbp.dhcp.thefacebook.com>
 <b181acbe-caf8-502d-4b7b-7d96b9fc5d55@iogearbox.net>
 <20220217015043.khqwqklx45c4m4se@kafai-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220217015043.khqwqklx45c4m4se@kafai-mbp.dhcp.thefacebook.com>
X-ClientProxiedBy: MW4PR04CA0199.namprd04.prod.outlook.com
 (2603:10b6:303:86::24) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 26682976-3706-42a5-3645-08d9f1e20fef
X-MS-TrafficTypeDiagnostic: BYAPR15MB3350:EE_
X-Microsoft-Antispam-PRVS: <BYAPR15MB3350C20E3FE0EADFB81674BBD5369@BYAPR15MB3350.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 54QPfu64t07LrYyEcc0cyWcqVbfwuIoJTESGxAXlzIZbcRabb6qpd7JkiJp9QPMAq9g7L1cXIT/fxEn+mYJ41gTsdirNZtlMcigiPHCbXzAJJSevjHNey03qM0IhM7kvuNDS/Aag9794gP7F6yWrLzqqm3sZTAnqGOvtFbAAtCxPIocl8mP7F5iyIc63RE7/59csZ+OdB+Oxr1n9xmpsFPLCdxD6g8OS/nbnFTFluQbBU15y0yNezRfH9FB2VDvTCdNVRbhZ5ZneYwB+hQtn0oscwnMavmqnUCluI4jt+mVli5aqADppBKZ/S6hKSZMiPLtMgKOKZPa13K4ZBwdltnYQUZzI/fr0+j1qF+fwazV681K4g7rL/2fvLRk4142U/IqpRw6l8DElQm6y9TtLjUxJUxd15n6/9XTWYZknSxbmPKVHyvpG1iRSxSRFRmXTPZ9qzdLnyU5l7IfhR6hWRrNnzhCBCD6CMJJo+WxWT7HGLmt0b4Ox+yh9j8NhgCLsyKoBkAWOHJriXGqvmhCQu2B9phIoWPAo8EQNVEfWF9dSrT/HNJJo+qigLm7MGHE5DN6z0eYuHo9eVr2qBKulVqdAQXJ+T52Ki6VIQuY7BnOg2mI3hXKdWjCxofB/CCn8c3SZjT6L0KAAQuaU5SUhdQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(83380400001)(186003)(5660300002)(316002)(9686003)(54906003)(6512007)(53546011)(6486002)(6666004)(1076003)(52116002)(6916009)(66556008)(2906002)(3716004)(8936002)(66476007)(86362001)(66946007)(4326008)(8676002)(38100700002)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?m7nGvrIVn/7G3M9tOocSqcf8U0W1tf9OvJWPt+CqQw+13XrhG59IKx6sT15g?=
 =?us-ascii?Q?IsVedgTayUwSKH7j9EOc1VREW2zMkvhaJYZrgQjO9+3jfQIIrRgy7+yYt++1?=
 =?us-ascii?Q?zIoDj/2Ara3LP0Zo90A0SwBbey5tJSN/1zn7oCCSJ3V3k8ayqSl+JqV51W4f?=
 =?us-ascii?Q?TThCfxW9paSNaA5ltH192oGCPOTM8no5R/n/xPAgsJDGwFqGldOZO08iOgXw?=
 =?us-ascii?Q?xgQ3kJ3CqW70orC0Q+s4ryOI5wM1BmPRlG0l/zc8rmtmBa1V6/vaum0sZUOX?=
 =?us-ascii?Q?VyN3WWr0hJhYOMiljKXD4vU7YQb3YBK7R1x99vFTcZ1bNJ+gpjZdnrW9SfDD?=
 =?us-ascii?Q?PHciD2pCPzVK5abx+AaFIrt976uQ6/2ISEJTC5OJk0YnSfc6KyK7SxghUE3e?=
 =?us-ascii?Q?fUbyl9nHVsIjUJOnSbSAP4eFPv9+1qDVCCGX5qY32iI4BzOWjrZyJ2l0Vr6D?=
 =?us-ascii?Q?70uo3QQ4jwaY6drirdhLBKQbuZZD+p5YNb492xCFpXC7lxNxBeZNWjJtuVvM?=
 =?us-ascii?Q?QiaNhjU3JxsWXGGUWlUSH4A8B9VKU/mQ3KSgFQJ9VZLa1CLhiCEH9YME+0R2?=
 =?us-ascii?Q?p7bYI2fgOWBNAN7iV5TuMwv+NVZB0lcOPPau+aHNlae6y6HpnZKEMH4nQk1a?=
 =?us-ascii?Q?vfv7jcrAJ4PmXHrp/YMVxNt9/qVxg12FmY31ntcWz4Yr7VzLNsNSCVEhdKWV?=
 =?us-ascii?Q?oBk1SVXk8GRvx3Vfc9v10qm/Wux2hf9ngCkBVI5L2KKqFLTTx7QXFeUKrPi9?=
 =?us-ascii?Q?ekXNb/eLZCkF/MieLpRe+nPIWbaEOAeRK3fa0lG/xK9Xxmj5jfMlDgEVn664?=
 =?us-ascii?Q?1bgwooYtDi3gSnGvQTDO4vyJP/MKxpTnDC/3YEip2TX3Hu/YXxqlBnYu8EvL?=
 =?us-ascii?Q?8cXuplAnI7607geetPrTABKFfWJ7BpDcykMydmdgn1fFBSSBNccL5HCiYV5O?=
 =?us-ascii?Q?GSLPajo12wWAPf9dlsxn2v/LsKRrGVCvFeaUhgHAPPJ+EqyZiHWIcJWJ2L49?=
 =?us-ascii?Q?CO/85NFP9aRWpUT02AKrAqUqbRqDz5cg6wqvhQgpqlvv6rC3TCvV5ijA5QyT?=
 =?us-ascii?Q?T3JRy7kGWUuvi1dttSB32l+cgWIZ/+ZMEjRP4sz64faqolHXpaEtcceQLqK2?=
 =?us-ascii?Q?q07bUf+2wKgLWaM4uYxBgmgI56HJZNgieyzeAQRLECTpKioUa9Ua/ATbx2s/?=
 =?us-ascii?Q?BekeFLqKYgMPqaPa4LTIo+oh/PY7MVpKSPOmz0kNAEdWgFgJKMFDrpZcpDtG?=
 =?us-ascii?Q?b41ziJLAoPEm/es/nBeEMqRCUcocDPhwVY40aGIjnm92hPS4VyLD62pAVSfF?=
 =?us-ascii?Q?jLTShNFpDaRC6dwZBiVvourquFlK3ZR2MtBlgd8MnnxAwQQiPm8fKUCZWfm/?=
 =?us-ascii?Q?ueJ6avp1h9/SECo2OgcjY37OYKMoJj4AfsRS8CV5i/wV8DDjp4VK04UshwWg?=
 =?us-ascii?Q?bgE3sxnWumwk9I41tGFmA+VsqL/V7jl65e5CLMCn4A3+pajaGFTobGhHOAzP?=
 =?us-ascii?Q?pO9G8UFqgrS+A/JJez/l8Qd87b6gqRJ2OlYBda+HJw3KgbWnJP0p1nfv11VH?=
 =?us-ascii?Q?pgfHWpuQoDEsbeYoVJyuXpE7wDp+AXTKCm9GbI2l?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 26682976-3706-42a5-3645-08d9f1e20fef
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2022 06:52:28.6404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n04Npqe7QzLPYkS2P/1Vnx7nE30LiyXL4lR/PlgLEqiDDey2orUYyifBcrrOuSJi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3350
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: QxxsWpyQCg1kTqMQxda1yuHfn7VbLdYQ
X-Proofpoint-ORIG-GUID: QxxsWpyQCg1kTqMQxda1yuHfn7VbLdYQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-17_02,2022-02-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 phishscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 clxscore=1015 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202170029
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 16, 2022 at 05:50:43PM -0800, Martin KaFai Lau wrote:
> On Thu, Feb 17, 2022 at 01:03:21AM +0100, Daniel Borkmann wrote:
> > On 2/16/22 6:51 AM, Martin KaFai Lau wrote:
> > > On Wed, Feb 16, 2022 at 12:30:53AM +0100, Daniel Borkmann wrote:
> > > > On 2/11/22 8:13 AM, Martin KaFai Lau wrote:
> > > > > The current tc-bpf@ingress reads and writes the __sk_buff->tstamp
> > > > > as a (rcv) timestamp.  This patch is to backward compatible with the
> > > > > (rcv) timestamp expectation when the skb->tstamp has a mono delivery_time.
> > > > > 
> > > > > If needed, the patch first saves the mono delivery_time.  Depending on
> > > > > the static key "netstamp_needed_key", it then resets the skb->tstamp to
> > > > > either 0 or ktime_get_real() before running the tc-bpf@ingress.  After
> > > > > the tc-bpf prog returns, if the (rcv) timestamp in skb->tstamp has not
> > > > > been changed, it will restore the earlier saved mono delivery_time.
> > > > > 
> > > > > The current logic to run tc-bpf@ingress is refactored to a new
> > > > > bpf_prog_run_at_ingress() function and shared between cls_bpf and act_bpf.
> > > > > The above new delivery_time save/restore logic is also done together in
> > > > > this function.
> > > > > 
> > > > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > > > ---
> > > > >    include/linux/filter.h | 28 ++++++++++++++++++++++++++++
> > > > >    net/sched/act_bpf.c    |  5 +----
> > > > >    net/sched/cls_bpf.c    |  6 +-----
> > > > >    3 files changed, 30 insertions(+), 9 deletions(-)
> > > > > 
> > > > > diff --git a/include/linux/filter.h b/include/linux/filter.h
> > > > > index d23e999dc032..e43e1701a80e 100644
> > > > > --- a/include/linux/filter.h
> > > > > +++ b/include/linux/filter.h
> > > > > @@ -699,6 +699,34 @@ static inline void bpf_compute_data_pointers(struct sk_buff *skb)
> > > > >    	cb->data_end  = skb->data + skb_headlen(skb);
> > > > >    }
> > > > > +static __always_inline u32 bpf_prog_run_at_ingress(const struct bpf_prog *prog,
> > > > > +						   struct sk_buff *skb)
> > > > > +{
> > > > > +	ktime_t tstamp, saved_mono_dtime = 0;
> > > > > +	int filter_res;
> > > > > +
> > > > > +	if (unlikely(skb->mono_delivery_time)) {
> > > > > +		saved_mono_dtime = skb->tstamp;
> > > > > +		skb->mono_delivery_time = 0;
> > > > > +		if (static_branch_unlikely(&netstamp_needed_key))
> > > > > +			skb->tstamp = tstamp = ktime_get_real();
> > > > > +		else
> > > > > +			skb->tstamp = tstamp = 0;
> > > > > +	}
> > > > > +
> > > > > +	/* It is safe to push/pull even if skb_shared() */
> > > > > +	__skb_push(skb, skb->mac_len);
> > > > > +	bpf_compute_data_pointers(skb);
> > > > > +	filter_res = bpf_prog_run(prog, skb);
> > > > > +	__skb_pull(skb, skb->mac_len);
> > > > > +
> > > > > +	/* __sk_buff->tstamp was not changed, restore the delivery_time */
> > > > > +	if (unlikely(saved_mono_dtime) && skb_tstamp(skb) == tstamp)
> > > > > +		skb_set_delivery_time(skb, saved_mono_dtime, true);
> > > > 
> > > > So above detour is for skb->tstamp backwards compatibility so users will see real time.
> > > > I don't see why we special case {cls,act}_bpf-only, given this will also be the case
> > > > for other subsystems (e.g. netfilter) when they read access plain skb->tstamp and get
> > > > the egress one instead of ktime_get_real() upon deferred skb_clear_delivery_time().
> > > > 
> > > > If we would generally ignore it, then the above bpf_prog_run_at_ingress() save/restore
> > > > detour is not needed (so patch 5/6 should be dropped). (Meaning, if we need to special
> > > > case {cls,act}_bpf only, we could also have gone for simpler bpf-only solution..)
> > > The limitation here is there is only one skb->tstamp field.  I don't see
> > > a bpf-only solution or not will make a difference here.
> > 
> > A BPF-only solution would probably just treat the skb->tstamp as (semi-)opaque,
> > meaning, there're no further bits on clock type needed in skb, but given the
> > environment is controlled by an orchestrator it can decide which tstamps to
> > retain or which to reset (e.g. by looking at skb->sk). (The other approach is
> > exposing info on clock base as done here to some degree for mono/real.)
> hmm... I think we may be talking about different things.
> 
> Using a bit or not still does not change the fact that
> there is only one skb->tstamp field which may have a delivery
> time or rcv tstamp.  If the delivery time is reset before
> forwarding to ingress or the delivery time was never there, then
> it will be stamped with the rcv timestamp at ingress.
> The bpf needs a way to distinguish between them.
> skb->sk can at most tell the clock base if skb->tstamp
> does indeed have the delivery_time.
> 
> > 
> > > Regarding the netfilter (good point!), I only see it is used in nfnetlink_log.c
> > > and nfnetlink_queue.c.  Like the tapping cases (earlier than the bpf run-point)
> > > and in general other ingress cases, it cannot assume the rcv timestamp is
> > > always there, so they can be changed like af_packet in patch 3
> > > which is a straight forward change.  I can make the change in v5.
> > > 
> > > Going back to the cls_bpf at ingress.  If the concern is on code cleanliness,
> > > how about removing this dance for now while the current rcv tstamp usage is
> > > unclear at ingress.  Meaning keep the delivery_time (if any) in skb->tstamp.
> > > This dance could be brought in later when there was breakage and legit usecase
> > > reported.  The new bpf prog will have to use the __sk_buff->delivery_time_type
> > > regardless if it wants to use skb->tstamp as the delivery_time, so they won't
> > > assume delivery_time is always in skb->tstamp and it will be fine even this
> > > dance would be brought back in later.
> > 
> > Yes, imho, this is still better than the bpf_prog_run_at_ingress() workaround.
> ic. so it is ok to remove the mono dtime save/restore logic here and only brought
> back in if there was legit breakage reported?
Another idea on this which I think is a better middle ground solution
to remove the dance here.

When reading __sk_buff->tstamp, the verifier can do a rewrite if needed.
The rewrite will depend on whether the __sk_buff->delivery_time_type
has been read or not.

If delivery_time_type is not read, it will rewrite to this:
/* BPF_READ: __u64 a = __sk_buff->tstamp; */
if (!skb->tc_at_ingress || !skb->mono_delivery_time)
	a = skb->tstamp;
else
	a = 0;

That will be consistent with other kernel ingress path
expectation (either 0 or rcv tstamp).

If __sk_buff->delivery_time_type is read, no rewrite is needed
and skb->tstamp will be read as is.

> btw, did you look at patch 7 which added the __sk_buff->delivery_time_type
> and bpf_set_delivery_time()?
> 
> > Ideally, we know when we call helpers like ktime_get_ns() that the clock will
> > be mono. We could track that on verifier side in the register type, and when we
> > end up writing to skb->tstamp, we could implicitly also set the clock base bits
> > in skb for the ctx rewrite telling that it's of type 'mono'. Same for reading,
> > we could add __sk_buff->tstamp_type which program can access (imo tstamp_type
> > is more generic than a __sk_buff->delivery_time_type). If someone needs
> > ktime_get_clocktai_ns() for sch_etf in future, it could be similar tracking
> > mechanism. Also setting skb->tstamp to 0 ...
> hmm... I think it is talking about a way to automatically
> update the __sk_buff->delivery_time_type (mono_delivery_time bit) and
> also avoid adding the new bpf_set_delivery_time() helper in patch 7?
> 
> It may have case that time is not always from helper ktime_get_ns() and
> cannot be decided statically. e.g. what if we want to set the current
> skb->tstamp based on when the previous skb was sent in a cgroup.  There
> will be cases coming up that require runtime decision.
> 
> Also, imo, it may be a surprise behavior for the user who only
> changed __skb_buff->tstamp but then figured out
> __sk_buff->delivery_time_type is also changed in
> the background.
> 
> Beside, not sure if the compiler will optimize the 2nd read on
> __sk_buff->delivery_time_type.  The bpf may need a
> READ_ONCE(__sk_buff->delivery_time_type) after writing __skb_buff->tstamp.
> We can add volatile to the delivery_time_type in the UAPI but I think
> it is overkill.
> 
> It is better to treat tstamp and delivery_time_type separately
> for direct access, and have the skb_set_delivery_time() to change
> both of them together.  Also, more checks can be done in
> skb_set_delivery_time() which is more flexible to return
> errors.
> 
> For TCP, it will be already in mono, so skb_set_delivery_time()
> is usually not needed.
> 
> Regarding the name delivery_time_type vs tstamp_type, I thought about
> that and finally picked the delivery_time_type because I want
> a clear separation from rcv tstamp for now until there is more
> clarity on how rcv tstamp is used in tc-bpf.
> 
> > > Regarding patch 6, it is unrelated.  It needs to clear the
> > > mono_delivery_time bit if the bpf writes 0 to the skb->tstamp.
> > 
> > ... doesn't need to be done as code after bpf_prog_run(), but should be brought
> > closer to when we write to the ctx where verifier generates the relevant insns.
> > Imo, that's better than having this outside in bpf_prog_run() which is then
> > checked no matter what program was doing or even accessing tstamp.
> This will also change the mono_delivery_time bit in the background
> and will be similar to the above points.

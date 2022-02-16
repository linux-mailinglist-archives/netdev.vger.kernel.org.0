Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4D44B8096
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 07:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240375AbiBPFwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 00:52:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234272AbiBPFwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 00:52:19 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F64C12FB;
        Tue, 15 Feb 2022 21:52:06 -0800 (PST)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21G0rPKM019224;
        Tue, 15 Feb 2022 21:51:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=iJXfF/93DjZ4YbKrc0ujounUae9uuxgza8EWkDiqtrQ=;
 b=eDisrMOAYgQ6815grU3CrmesKNC6CweyHv0T7VnI6Wwlx/xdJLC70xZIGkXFKVWCv+7V
 WuMpVjMTDZr2RcqXXyfS77FuXGiqQ5gxF5EgdYDOjirJuc+dJCPr6e5tGvcoQAgLiTFl
 l+YVjP06Tawplqa79IZfKtM/v0DptDxT0i8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e8n4ba17g-14
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 15 Feb 2022 21:51:49 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Feb 2022 21:51:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TUPy5wHEYTWduckjT88Vo5u8oNCUhw34yggdvXfRDpryoJwCReH/3OvRfznG8+/B8hVQAEPTM2nnjJF5MG6tVBffQj62D9qgOumLLPzzlKuMvBb6Qlt8ULjvR8qD3UPwNoOSp+XrjZiZwl99nmxjN33/iN8NMYCuPHAl6gi89OzrDCfiAm7hbc6CmTEs5HXEw0WLcJI8pRrw6f8KKwsuublH8o0TCimhsfofK6IfT9+rNxPbquJtZX7yfFMB9U+RG+SQ/jb3CySSrhAY2ML5FfJIp6Fh89Acu6LA3Hgs3MdgBW5d+lCQFVZW0NxPI3VAjuANHHA4zzD0ExTPFdo9Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iJXfF/93DjZ4YbKrc0ujounUae9uuxgza8EWkDiqtrQ=;
 b=Vx9MPNZsINNXs9BGUQLFEQ7tT9T1Dfg2hY/AacTvU0W8F1zakHrYuesYFN4hO7vAjAUjmRfScGUk02cFIw6HgYi12ZMWdYR82i4qs5tBhrlohuVWziaKgj9AqgU2fgJYe3uP3ATptm8nK4JcOdve0Pn//P/bpIW8Ftg0gTCh3sfP362AYi8iXV9iyUhco2XXJNTgM9lBkWW83yB+Xg6L88Ms5dwoECH4K131d2NetNlcpOD7Py/A4xwMflJDqtjeVvmgzy1isNnC/gOdAG6qo9J8GfPiXW9dvE/ngOhCuul/bzUgIRS8OEha05boR0MHDnSirniIa+xuHb4XW+XYTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SJ0PR15MB4421.namprd15.prod.outlook.com (2603:10b6:a03:372::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.15; Wed, 16 Feb
 2022 05:51:45 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::7d65:13a6:9d7a:f311]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::7d65:13a6:9d7a:f311%6]) with mapi id 15.20.4975.019; Wed, 16 Feb 2022
 05:51:45 +0000
Date:   Tue, 15 Feb 2022 21:51:42 -0800
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
Message-ID: <20220216055142.n445wwtqmqewc57a@kafai-mbp.dhcp.thefacebook.com>
References: <20220211071232.885225-1-kafai@fb.com>
 <20220211071303.890169-1-kafai@fb.com>
 <f0d76498-0bb1-36a6-0c8c-b334f6fb13c2@iogearbox.net>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f0d76498-0bb1-36a6-0c8c-b334f6fb13c2@iogearbox.net>
X-ClientProxiedBy: MWHPR02CA0018.namprd02.prod.outlook.com
 (2603:10b6:300:4b::28) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 033fb1f0-54fb-41ae-73e8-08d9f1106a52
X-MS-TrafficTypeDiagnostic: SJ0PR15MB4421:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR15MB4421BBDA97C06C7879D27D9FD5359@SJ0PR15MB4421.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VKT28WDH+mqh29aR/2V3hUD8G/Q42/nyM+ExWGfH0nfUnRsaabiMQDKD32zN4/z6OgqRH2UlGo89HN8z2amCMxzuoSkC2TmoEI89UBRZpfXllA0SmOR3IDhqHIwGbyLJ3rbDO2UTLKojw/bXay+ecdwd/4fOtpFFYB7IArNukmJmHs81bSIa6QupZ0Cd8JhkCnleypaphuEnCrHOH799d4LRY/x0/UiDnNuXgJjsLfvg2IDtj65W70Og29AyyZQku9x+eblBxVR21TsVV79ILBd2zVkgJ6Jt7U8vihHASJ1BDQYCxdqf0n/lIlER36RYRf2Vo9eE7+E75QJh7oXKXt6rQgny4c8QoC5c2+3HdDJNByv3s0d/sjPDhk7mrYM6yoi/v9H63ZuS26HECE1+mCZXkkDD9Wx9CzuRr0Bbqucm+e1LkLJ7sFuHuHJlL9/nagleR1o4nfL3CJkPEoyHPzAHZR1h9tZoKfIiXk10um8Sljx3DSokRtVCx2S7t5Jvat41ZVZUkQyKNWRJzwrYs4DL5iiNOyChnlgOPRpd0D4+7+quVkgSlg/4uJnIDnESlDYvVO6aP092r+iWJnvgkMr6Ee/eKdJDFWgCRrOZvp02hPUfRUtP+3dLmMmCvhto7gdid15treTEtB/9ZoEoXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(6666004)(6512007)(6506007)(52116002)(2906002)(186003)(508600001)(8936002)(86362001)(1076003)(9686003)(5660300002)(53546011)(66556008)(66946007)(38100700002)(4326008)(8676002)(66476007)(54906003)(6486002)(316002)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JB9UmOEgqI0X4jPV2G7LMrmsBjqBsYVpjEB/7zkeNGGL6QznkiTyzWuaw/2Q?=
 =?us-ascii?Q?ucicPc2Wf3HC7z30S3GsvTY9gxgJsRFJBiiA7X7jGJTPeniSVmL1lZHJ4aaA?=
 =?us-ascii?Q?q2GkTlDG+C7C3ohzCp3tzk7f13RBbYIYU4POfSA09Ohan8vrscX9RdFjoEE1?=
 =?us-ascii?Q?Wv6C3ylilEJDC46wiFgLq5BNG5bv/CfJ2JHVZVUASMPzjQWbVEclYFA2vFhz?=
 =?us-ascii?Q?NI6Qm9012OLY3BWccfxg82ImO8hTi2msJ8XHyQuFBPvFohbfQ4v6R2UMQqxZ?=
 =?us-ascii?Q?KjK/4mteopeesBwFA4Uxk6EwSLeFd8oxQw31xPKcH4Mz+q3fzcPnH3uNBscX?=
 =?us-ascii?Q?LSLBL7rfj+S+5gLHZX7oiHkH3XSj7uy1xDw9gRqt0JEOu0kZX5gbqC+7jnGE?=
 =?us-ascii?Q?V2W70CZ/fSzDo4QHnucJfWQdemFd/lzo6wn8gSxUztRojsnVxDE2RjGF8oIA?=
 =?us-ascii?Q?Fk25VbpDUGBTqiQhSCO4HjcxpdVdXlA7Pli7frOjq8gJfnC+KRPWTyvPhsB2?=
 =?us-ascii?Q?Nn76TFwuG44Phx2+MEguFD/swjQfTKDcrGoy9zKJKUqAVkn+vR886YJ68OhU?=
 =?us-ascii?Q?DNfrK4xHNcOzPycMdzGHeuJxlibYgJAKRoNqMOv6c30ULnxyNMG218LT7sQ2?=
 =?us-ascii?Q?/jZOCv7L6R7PZWn8/QyXwElZ+htFLCxnK9jErDxJ5Sdkyzr+pUKece2CO3eB?=
 =?us-ascii?Q?IlNnlcE+IscL6v7T9OGFKLMgg2KGMOn30aWgR4q+n14fNr70YewIC1LBDnPP?=
 =?us-ascii?Q?mxvZYIsP7BPx6KgTiLqCmffyDAv55nrmBN2VJwoaGSO0NODCQmP33oNiu+st?=
 =?us-ascii?Q?806a8/AfvG/YFiX/L7VpIJEtavyML2s76hCelm1fdEPcMjPJ49dc48W42ka4?=
 =?us-ascii?Q?AnggIWCpZXyGcoJFV57Mk3GlTuzWflsNewofPFT71wsx4OprswZiewKc0uGm?=
 =?us-ascii?Q?XgwdQpAJPEW1G6/Nii6RGK9N7njHLhHTtA4LAGbPsMs226dpHX9WYFWsPzdI?=
 =?us-ascii?Q?i9mEHixM44hS8Ee+FaIQZoWGVM5lPLZj4wMXHhN7c+cbMf4NkLcTvKvb6gfB?=
 =?us-ascii?Q?HaLLRw1FbaBEI92YQ8uWXN9BT/ogZgW9870g30m2E5t16GPlLPN6BgWtGtmx?=
 =?us-ascii?Q?UC+LmzZkikbkR8afFCVWlZbDCF+Hx6VdQbYi77Kf2AaVw7J1/Bt1uQucxpNC?=
 =?us-ascii?Q?YQsxKUA/QZdS4g5s7kbauVIQI813qE/NHIWahXlg43iIRBKqnK3c3va8R0U3?=
 =?us-ascii?Q?tL5w4YUfVHALz2+QPOhJD7ASW3XjDhoBhflrganhiV0M4Jf0KKGyuSPah92t?=
 =?us-ascii?Q?+0JCtxLUe21fL6aKMk6kBvX7CQLdz/PKezcQERPnaihwVXi6mbCX53EZrTTt?=
 =?us-ascii?Q?ck+arvd1+rXv/xBGA9CVkBkDfPaUI49oM3VyqV/CsIg8CQH56rdHaAyiBXGj?=
 =?us-ascii?Q?2m1TQ842eL5mlytVOc0rgO59KMIXwntwNpm69Gcd50hyMa9z1r0TiokiijH8?=
 =?us-ascii?Q?UJo3L/3ksoKhBjbmptLeQmk98IOEbU25aDHDn1bESLEviPdjeyj08TTU8LUf?=
 =?us-ascii?Q?Rn2bC2utF1+p4KvAbGUI4kYu+wanJllmL6WiJj2B?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 033fb1f0-54fb-41ae-73e8-08d9f1106a52
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 05:51:45.7069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AfNDFLYGqKVtbUQBNL9CFarMhLNaFIBZfq1U1LptLfX63ztwwU3wUBiLR5uuKQu8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4421
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: aipLvjQbzL7KElzq5EqDExMpcRIUnZko
X-Proofpoint-ORIG-GUID: aipLvjQbzL7KElzq5EqDExMpcRIUnZko
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-16_02,2022-02-14_04,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 suspectscore=0 impostorscore=0
 spamscore=0 adultscore=0 priorityscore=1501 malwarescore=0 phishscore=0
 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202160028
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

On Wed, Feb 16, 2022 at 12:30:53AM +0100, Daniel Borkmann wrote:
> On 2/11/22 8:13 AM, Martin KaFai Lau wrote:
> > The current tc-bpf@ingress reads and writes the __sk_buff->tstamp
> > as a (rcv) timestamp.  This patch is to backward compatible with the
> > (rcv) timestamp expectation when the skb->tstamp has a mono delivery_time.
> > 
> > If needed, the patch first saves the mono delivery_time.  Depending on
> > the static key "netstamp_needed_key", it then resets the skb->tstamp to
> > either 0 or ktime_get_real() before running the tc-bpf@ingress.  After
> > the tc-bpf prog returns, if the (rcv) timestamp in skb->tstamp has not
> > been changed, it will restore the earlier saved mono delivery_time.
> > 
> > The current logic to run tc-bpf@ingress is refactored to a new
> > bpf_prog_run_at_ingress() function and shared between cls_bpf and act_bpf.
> > The above new delivery_time save/restore logic is also done together in
> > this function.
> > 
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
> >   include/linux/filter.h | 28 ++++++++++++++++++++++++++++
> >   net/sched/act_bpf.c    |  5 +----
> >   net/sched/cls_bpf.c    |  6 +-----
> >   3 files changed, 30 insertions(+), 9 deletions(-)
> > 
> > diff --git a/include/linux/filter.h b/include/linux/filter.h
> > index d23e999dc032..e43e1701a80e 100644
> > --- a/include/linux/filter.h
> > +++ b/include/linux/filter.h
> > @@ -699,6 +699,34 @@ static inline void bpf_compute_data_pointers(struct sk_buff *skb)
> >   	cb->data_end  = skb->data + skb_headlen(skb);
> >   }
> > +static __always_inline u32 bpf_prog_run_at_ingress(const struct bpf_prog *prog,
> > +						   struct sk_buff *skb)
> > +{
> > +	ktime_t tstamp, saved_mono_dtime = 0;
> > +	int filter_res;
> > +
> > +	if (unlikely(skb->mono_delivery_time)) {
> > +		saved_mono_dtime = skb->tstamp;
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
> > +	if (unlikely(saved_mono_dtime) && skb_tstamp(skb) == tstamp)
> > +		skb_set_delivery_time(skb, saved_mono_dtime, true);
> 
> So above detour is for skb->tstamp backwards compatibility so users will see real time.
> I don't see why we special case {cls,act}_bpf-only, given this will also be the case
> for other subsystems (e.g. netfilter) when they read access plain skb->tstamp and get
> the egress one instead of ktime_get_real() upon deferred skb_clear_delivery_time().
> 
> If we would generally ignore it, then the above bpf_prog_run_at_ingress() save/restore
> detour is not needed (so patch 5/6 should be dropped). (Meaning, if we need to special
> case {cls,act}_bpf only, we could also have gone for simpler bpf-only solution..)
The limitation here is there is only one skb->tstamp field.  I don't see
a bpf-only solution or not will make a difference here.

Regarding the netfilter (good point!), I only see it is used in nfnetlink_log.c
and nfnetlink_queue.c.  Like the tapping cases (earlier than the bpf run-point)
and in general other ingress cases, it cannot assume the rcv timestamp is
always there, so they can be changed like af_packet in patch 3
which is a straight forward change.  I can make the change in v5.

Going back to the cls_bpf at ingress.  If the concern is on code cleanliness,
how about removing this dance for now while the current rcv tstamp usage is
unclear at ingress.  Meaning keep the delivery_time (if any) in skb->tstamp.
This dance could be brought in later when there was breakage and legit usecase
reported.  The new bpf prog will have to use the __sk_buff->delivery_time_type
regardless if it wants to use skb->tstamp as the delivery_time, so they won't
assume delivery_time is always in skb->tstamp and it will be fine even this
dance would be brought back in later.

I prefer to keep it as-is to avoid unlikely breakage but open to remove
it for now.

Regarding patch 6, it is unrelated.  It needs to clear the
mono_delivery_time bit if the bpf writes 0 to the skb->tstamp.

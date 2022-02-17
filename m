Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 979364B95AD
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 02:51:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbiBQBvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 20:51:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbiBQBvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 20:51:23 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48F29DEA30;
        Wed, 16 Feb 2022 17:51:09 -0800 (PST)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21H1ZRg4023558;
        Wed, 16 Feb 2022 17:50:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=6/o6Dbvnq/EchSS4OgRb5OgJR32UPQFlNQyvPhWoLbQ=;
 b=cwhqpgBzmLoez3UJdSy6cDvTKGC+oIe6TnB2IAqZpkImufbOnxVgbopR8iTlxavJ0S9Q
 EiobNjmDdvqSXWylV8g8tFLd5V3cmCk9NKvDfTFP0doCGaClD8W+/ctbOaNEUrX8jrv+
 rf15vVjczp1zBa8KZbBmF1z/ly+ev/gRcm8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e9c3xg9hj-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 16 Feb 2022 17:50:50 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 16 Feb 2022 17:50:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CRTJuAOIofD364+xfpKjEJU2MUN7HO1U9wcJO2m2UZtH2+R8UIrqbH2pjXeMdeIqF0qGpMicZWm0EAwvA8Qw5E990SV1WRF3JkW/pP7KzqhInOFmE98SjTlhRmBFQUJx7MkR3g8QAnqgS/gZTZtv+4f4md0G0wplRaw7ysKN3j3SCAMxpIlVvxS7h6J5VrsdB/4mnmgw1NVTgzJZmM9u19xeJcgvjqYP96berleX4mvbQzkuqE4TsGD9ciHpjWQv8RomSNLIXsfjGCwUzih8nN/Y/pupb3kHT6w0KahOczthQi8bSIezGDY664qlGUJcknwGmsW+DelYP0bVyh8Igg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6/o6Dbvnq/EchSS4OgRb5OgJR32UPQFlNQyvPhWoLbQ=;
 b=NMSw5NZ292TPAcboEXXV7jS3V72RXjQY486s8xKgr5HBvJmW9YXpDx25V++abXc9j3hSvkkLSKs0TjFcatMG7gf43RpodMwkujrpFSR4dEEGVEvVsJRoNQ7T9kSqE5Dd/sTLkGwYznzfGpoGY98oXKOsS9sQMg6Rd3cHyVKyTPkPwv5nzLXOBDGNTabvE8ZwATX5NS+UPJqmhMb9PYc8lMAtb03JNN3NLLbL9YFIWbYeb40fFVA2gv4sTzutb61C++qzUJqiGBq+i64nbyUG/HZhQGCV+jJ3u3lyXI9sBKvSgNWCnDo+rutGcfmO4c9PtVpDL+0mIi4Vfw8v5R3GlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by BYAPR15MB2389.namprd15.prod.outlook.com (2603:10b6:a02:86::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.18; Thu, 17 Feb
 2022 01:50:47 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1d2d:7a0f:fa57:cbdd]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1d2d:7a0f:fa57:cbdd%6]) with mapi id 15.20.4995.016; Thu, 17 Feb 2022
 01:50:47 +0000
Date:   Wed, 16 Feb 2022 17:50:43 -0800
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
Message-ID: <20220217015043.khqwqklx45c4m4se@kafai-mbp.dhcp.thefacebook.com>
References: <20220211071232.885225-1-kafai@fb.com>
 <20220211071303.890169-1-kafai@fb.com>
 <f0d76498-0bb1-36a6-0c8c-b334f6fb13c2@iogearbox.net>
 <20220216055142.n445wwtqmqewc57a@kafai-mbp.dhcp.thefacebook.com>
 <b181acbe-caf8-502d-4b7b-7d96b9fc5d55@iogearbox.net>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <b181acbe-caf8-502d-4b7b-7d96b9fc5d55@iogearbox.net>
X-ClientProxiedBy: MWHPR1201CA0010.namprd12.prod.outlook.com
 (2603:10b6:301:4a::20) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cb3733a0-228f-4d41-f041-08d9f1b7eaa8
X-MS-TrafficTypeDiagnostic: BYAPR15MB2389:EE_
X-Microsoft-Antispam-PRVS: <BYAPR15MB23895BF4B41D5F620CAA7F7AD5369@BYAPR15MB2389.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uqGKFOQvmvFROeDHq9v++lExwJ5nKn0exLNoGSSwJZmzaOUHwPBvy209FBWKCN+DMQecuTjZcqDRsF+rHWD6gbi3JnKG7OWoCtVdLtvxlU/QoNVdTfWGiY9YPmpq47VAxF0HmS3kqBrps9cN76z6RAd/mocuF2uT23XRtkFOlQOBEIszDbAaEdWDBsfNMmzIXtAsQgjlsvXlmYFW1ZPGM3ahGSn0OxeFPMFRJg/TRtGtuUMusSApZrJTngcuFsHhzI5+VUfRHYnQjYp0WjtdqPdqwSy5UFuB4rgVajHS7ywclori9F5XL6LpjDmCI2AM0OuE4YJih0awaDzIWy20BQql3u0Q6ScP4UWn8LYIKi1JcftxNkyohBAzuNuaubCjTooj8zwbumN1fKFgE/qvacuazDWZNrSbaJoa1j6K5nde74PUKota3X2KjH2n9xhbQDZQ+bW8y48QeTCJlOCp0xWV+AZuZ0nqOCzmePMFJjxiFuIvRsvLQ1+irF3c+CVspxZ0lHsIMo+iHsLK+V59TVdzF+OFK+VkwId86ywf54awfAZ0gnTE16+vzRuliFkUIERYL97SiltxJJ2C0dJIklHam423ErnXnjGd08OKvfUNG58KZgrm3uFBujov73BNykcbSkJ6QQMUhcaOnysUWw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(2906002)(66476007)(66946007)(53546011)(1076003)(4326008)(6666004)(5660300002)(186003)(9686003)(8676002)(6512007)(83380400001)(6506007)(6486002)(52116002)(8936002)(66556008)(38100700002)(316002)(86362001)(6916009)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3rbRbe7ASHybQY4Y83QL5d90Q7Qbd39abdmn0EoAED6YQPMYjSuomuNR+l2C?=
 =?us-ascii?Q?m5BYlXHHOmicMOCqlg6jeQWU1oycc0hMCWRp6RwPH0e52Ok74znFdd6PKYlI?=
 =?us-ascii?Q?3Na/7il3gBAgruzssvh90jGrORMJVYGhtMOcE5x1bOPo8h+cg0oy1Zu6UHIQ?=
 =?us-ascii?Q?s6rDk26U142g1vUh1Llp9t8T/LhAmKSJQrV3rfT1h1vYlsSj3MePGSf4B3Iu?=
 =?us-ascii?Q?BCmGp2IBhVso3UN87vWsfFCxtVvnNWnn7cYOHcPPsH4jHoBla7oYqy5Dgab2?=
 =?us-ascii?Q?WP1OPhejCphS9xlpshInz4oICdk8wIn4q225N6H2W5hI0j3F8ZCcRc8R2DQS?=
 =?us-ascii?Q?KFzp4NZ8OiyG8R3AUj6QjLmrvELmA8SOiJEbqzx/zY85+4cdYpIzdUuMkyF9?=
 =?us-ascii?Q?k7ha1ZUVggNxSFyF/PWmcbCtaZMBeA2G5UEsAyHpz+eVeL/vDHpam14KDC+I?=
 =?us-ascii?Q?gqkUc19rvU41em9gs8N1SKpdmFMylCkCtfHIPz+hIcWPjdNH4N5OcpqgamYD?=
 =?us-ascii?Q?BnbZ/8NVsI0EmJCR4HR7yZhUcPnmSUekDDixQtA2DZQVtPe/D/BGMEAlVSu6?=
 =?us-ascii?Q?1NFmBr5S5XG1EAWmjeyabBJX02aWMFBfwfkvfdlHhfE8MxDN9uOpNWEfvDse?=
 =?us-ascii?Q?dVYfrepwkPSdx4wBxo1/hJ8JrreZDvKvjgRBw0kPeaj8jiOHqJvXYz/4Rmue?=
 =?us-ascii?Q?jbJ+ab5vrkJNeplqSyRH6pcpkJiQvTAGAevw450k8VNCrt8ayWcNswsFWHNe?=
 =?us-ascii?Q?MqR03gleb7U7XRCIwSF5Eln/+ib4RxPkFp4EfhoTf5gQ5MLFGTvyX5Klo+oZ?=
 =?us-ascii?Q?HffJZypZ3vt5WwRe3t5mljDdgJy71TnC6+uQKs/Su5+R3lW8eREcRT6PAo9l?=
 =?us-ascii?Q?Z4uSDeU+F8QurFOqoYgOvcLBhBERDDWiyIOCeQzyNODwXGU4dFFmA92TQ17v?=
 =?us-ascii?Q?LFUqMId5sn+f0k5s2Z421qi+HfofN1P4v9qu6N1XdMxUVcJRuWeA4kSKHjYx?=
 =?us-ascii?Q?GmQC/GmY148X78ohraSVkMlt+UrirZzmgOEFIusNEVDgyIMtRx2lb13tUAo7?=
 =?us-ascii?Q?cDMta0Mj+lSEEda6SvNX/XF+kdSbfLWd+SSJcVvcM3+pr1t9jdpSDL3bw709?=
 =?us-ascii?Q?7rSHLhiPUWxoaXBFQM8c5g8KS+vizuIb3sRtISbhNLvCn2XGgJRM/4+6nRxS?=
 =?us-ascii?Q?wxuspAc1l1trhpp/54y9rsGOBDRhIkGjg3vxdOM/55VIUoeXy7ps0FiCPbsN?=
 =?us-ascii?Q?JeW0i3CTxIxGgyItxeCXp1rHptIuYlzE2aZ/c81fSeEbJ15yGL25gc/I5xbE?=
 =?us-ascii?Q?NFF9smZGqhNIjBkbLhuKPYDDX6jBgSD4tO0KsQ2JIlXs4l9zkJXE1Q3L9bGp?=
 =?us-ascii?Q?usliwKDLCtQM7pc1m4tMVrMIMHjUQYVEcybjKQG//n/mEnTu1kQ7Hmh9KCK6?=
 =?us-ascii?Q?JDXLQSjjGOA5MNsBnzO9cmn4PCOYEaiBDWnNfRpDH9TxGALlqRxTFCv9zMff?=
 =?us-ascii?Q?nQ8CpDTNBvss8Ye6/hkGCwqIhE8Gj1te/EbGyvWxGXi/JLo3K6/jqpBbpE/+?=
 =?us-ascii?Q?blchTNfoDyYM2g/WlqAp+6KTqO+Bpyj9zYXvHaMf?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cb3733a0-228f-4d41-f041-08d9f1b7eaa8
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2022 01:50:47.0228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: By1DJveoTbigVaZi4knlVA8qnBgDEaFNdkCQGiWtNeMREBiXbJn+6fUIUALO2+yq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2389
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: GGZLojMww6TXd17R9dKh6LXry2j3GDKc
X-Proofpoint-GUID: GGZLojMww6TXd17R9dKh6LXry2j3GDKc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-16_11,2022-02-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 impostorscore=0
 phishscore=0 spamscore=0 suspectscore=0 bulkscore=0 clxscore=1015
 mlxscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202170006
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

On Thu, Feb 17, 2022 at 01:03:21AM +0100, Daniel Borkmann wrote:
> On 2/16/22 6:51 AM, Martin KaFai Lau wrote:
> > On Wed, Feb 16, 2022 at 12:30:53AM +0100, Daniel Borkmann wrote:
> > > On 2/11/22 8:13 AM, Martin KaFai Lau wrote:
> > > > The current tc-bpf@ingress reads and writes the __sk_buff->tstamp
> > > > as a (rcv) timestamp.  This patch is to backward compatible with the
> > > > (rcv) timestamp expectation when the skb->tstamp has a mono delivery_time.
> > > > 
> > > > If needed, the patch first saves the mono delivery_time.  Depending on
> > > > the static key "netstamp_needed_key", it then resets the skb->tstamp to
> > > > either 0 or ktime_get_real() before running the tc-bpf@ingress.  After
> > > > the tc-bpf prog returns, if the (rcv) timestamp in skb->tstamp has not
> > > > been changed, it will restore the earlier saved mono delivery_time.
> > > > 
> > > > The current logic to run tc-bpf@ingress is refactored to a new
> > > > bpf_prog_run_at_ingress() function and shared between cls_bpf and act_bpf.
> > > > The above new delivery_time save/restore logic is also done together in
> > > > this function.
> > > > 
> > > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > > ---
> > > >    include/linux/filter.h | 28 ++++++++++++++++++++++++++++
> > > >    net/sched/act_bpf.c    |  5 +----
> > > >    net/sched/cls_bpf.c    |  6 +-----
> > > >    3 files changed, 30 insertions(+), 9 deletions(-)
> > > > 
> > > > diff --git a/include/linux/filter.h b/include/linux/filter.h
> > > > index d23e999dc032..e43e1701a80e 100644
> > > > --- a/include/linux/filter.h
> > > > +++ b/include/linux/filter.h
> > > > @@ -699,6 +699,34 @@ static inline void bpf_compute_data_pointers(struct sk_buff *skb)
> > > >    	cb->data_end  = skb->data + skb_headlen(skb);
> > > >    }
> > > > +static __always_inline u32 bpf_prog_run_at_ingress(const struct bpf_prog *prog,
> > > > +						   struct sk_buff *skb)
> > > > +{
> > > > +	ktime_t tstamp, saved_mono_dtime = 0;
> > > > +	int filter_res;
> > > > +
> > > > +	if (unlikely(skb->mono_delivery_time)) {
> > > > +		saved_mono_dtime = skb->tstamp;
> > > > +		skb->mono_delivery_time = 0;
> > > > +		if (static_branch_unlikely(&netstamp_needed_key))
> > > > +			skb->tstamp = tstamp = ktime_get_real();
> > > > +		else
> > > > +			skb->tstamp = tstamp = 0;
> > > > +	}
> > > > +
> > > > +	/* It is safe to push/pull even if skb_shared() */
> > > > +	__skb_push(skb, skb->mac_len);
> > > > +	bpf_compute_data_pointers(skb);
> > > > +	filter_res = bpf_prog_run(prog, skb);
> > > > +	__skb_pull(skb, skb->mac_len);
> > > > +
> > > > +	/* __sk_buff->tstamp was not changed, restore the delivery_time */
> > > > +	if (unlikely(saved_mono_dtime) && skb_tstamp(skb) == tstamp)
> > > > +		skb_set_delivery_time(skb, saved_mono_dtime, true);
> > > 
> > > So above detour is for skb->tstamp backwards compatibility so users will see real time.
> > > I don't see why we special case {cls,act}_bpf-only, given this will also be the case
> > > for other subsystems (e.g. netfilter) when they read access plain skb->tstamp and get
> > > the egress one instead of ktime_get_real() upon deferred skb_clear_delivery_time().
> > > 
> > > If we would generally ignore it, then the above bpf_prog_run_at_ingress() save/restore
> > > detour is not needed (so patch 5/6 should be dropped). (Meaning, if we need to special
> > > case {cls,act}_bpf only, we could also have gone for simpler bpf-only solution..)
> > The limitation here is there is only one skb->tstamp field.  I don't see
> > a bpf-only solution or not will make a difference here.
> 
> A BPF-only solution would probably just treat the skb->tstamp as (semi-)opaque,
> meaning, there're no further bits on clock type needed in skb, but given the
> environment is controlled by an orchestrator it can decide which tstamps to
> retain or which to reset (e.g. by looking at skb->sk). (The other approach is
> exposing info on clock base as done here to some degree for mono/real.)
hmm... I think we may be talking about different things.

Using a bit or not still does not change the fact that
there is only one skb->tstamp field which may have a delivery
time or rcv tstamp.  If the delivery time is reset before
forwarding to ingress or the delivery time was never there, then
it will be stamped with the rcv timestamp at ingress.
The bpf needs a way to distinguish between them.
skb->sk can at most tell the clock base if skb->tstamp
does indeed have the delivery_time.

> 
> > Regarding the netfilter (good point!), I only see it is used in nfnetlink_log.c
> > and nfnetlink_queue.c.  Like the tapping cases (earlier than the bpf run-point)
> > and in general other ingress cases, it cannot assume the rcv timestamp is
> > always there, so they can be changed like af_packet in patch 3
> > which is a straight forward change.  I can make the change in v5.
> > 
> > Going back to the cls_bpf at ingress.  If the concern is on code cleanliness,
> > how about removing this dance for now while the current rcv tstamp usage is
> > unclear at ingress.  Meaning keep the delivery_time (if any) in skb->tstamp.
> > This dance could be brought in later when there was breakage and legit usecase
> > reported.  The new bpf prog will have to use the __sk_buff->delivery_time_type
> > regardless if it wants to use skb->tstamp as the delivery_time, so they won't
> > assume delivery_time is always in skb->tstamp and it will be fine even this
> > dance would be brought back in later.
> 
> Yes, imho, this is still better than the bpf_prog_run_at_ingress() workaround.
ic. so it is ok to remove the mono dtime save/restore logic here and only brought
back in if there was legit breakage reported?

btw, did you look at patch 7 which added the __sk_buff->delivery_time_type
and bpf_set_delivery_time()?

> Ideally, we know when we call helpers like ktime_get_ns() that the clock will
> be mono. We could track that on verifier side in the register type, and when we
> end up writing to skb->tstamp, we could implicitly also set the clock base bits
> in skb for the ctx rewrite telling that it's of type 'mono'. Same for reading,
> we could add __sk_buff->tstamp_type which program can access (imo tstamp_type
> is more generic than a __sk_buff->delivery_time_type). If someone needs
> ktime_get_clocktai_ns() for sch_etf in future, it could be similar tracking
> mechanism. Also setting skb->tstamp to 0 ...
hmm... I think it is talking about a way to automatically
update the __sk_buff->delivery_time_type (mono_delivery_time bit) and
also avoid adding the new bpf_set_delivery_time() helper in patch 7?

It may have case that time is not always from helper ktime_get_ns() and
cannot be decided statically. e.g. what if we want to set the current
skb->tstamp based on when the previous skb was sent in a cgroup.  There
will be cases coming up that require runtime decision.

Also, imo, it may be a surprise behavior for the user who only
changed __skb_buff->tstamp but then figured out
__sk_buff->delivery_time_type is also changed in
the background.

Beside, not sure if the compiler will optimize the 2nd read on
__sk_buff->delivery_time_type.  The bpf may need a
READ_ONCE(__sk_buff->delivery_time_type) after writing __skb_buff->tstamp.
We can add volatile to the delivery_time_type in the UAPI but I think
it is overkill.

It is better to treat tstamp and delivery_time_type separately
for direct access, and have the skb_set_delivery_time() to change
both of them together.  Also, more checks can be done in
skb_set_delivery_time() which is more flexible to return
errors.

For TCP, it will be already in mono, so skb_set_delivery_time()
is usually not needed.

Regarding the name delivery_time_type vs tstamp_type, I thought about
that and finally picked the delivery_time_type because I want
a clear separation from rcv tstamp for now until there is more
clarity on how rcv tstamp is used in tc-bpf.

> > Regarding patch 6, it is unrelated.  It needs to clear the
> > mono_delivery_time bit if the bpf writes 0 to the skb->tstamp.
> 
> ... doesn't need to be done as code after bpf_prog_run(), but should be brought
> closer to when we write to the ctx where verifier generates the relevant insns.
> Imo, that's better than having this outside in bpf_prog_run() which is then
> checked no matter what program was doing or even accessing tstamp.
This will also change the mono_delivery_time bit in the background
and will be similar to the above points.

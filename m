Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE184CC5E2
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 20:18:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235983AbiCCTSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 14:18:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235981AbiCCTSt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 14:18:49 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF4558BE0E;
        Thu,  3 Mar 2022 11:18:01 -0800 (PST)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 223DtBSP018324;
        Thu, 3 Mar 2022 11:17:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=J2IY2xdjVTEBtlt/08FCEN3aedN8wXPy1I0c7pKxSPE=;
 b=evTq4pfbRuYUBXgKd9MQpWXgl4tbzeXd2sSV9ns4Mg6613VpU3i5DjMDFhxT/MqafmnQ
 yl3PZzNX48+IyYfRZAotT1R2xcBU1va50ohqHLUqS54WZDFkaifG+7Uif/q5/DWwLHvC
 RX+QNXiFWehPg1yKcKqdUqpBd480lIYDHt8= 
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2049.outbound.protection.outlook.com [104.47.51.49])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ejxyn2dme-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Mar 2022 11:17:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TDD58+RZaUVb6xRcAEc0oU4BQEA/6wUUtLxOuKiXM3luy52v5w13owSbmO1uivPxYUlRdBJ4zqz3mLTmxwRJbi1IV2nhXg/SkSURPwsl6MBVJvqiySUAa03WiRwkB9BL3pvRjIL2STEI5yPumG7MWLFrYW2aNa+95qy2ysnjNWrEFLHWl0DF/vNJt3kBcZF9euTXAxlYt5k2iIhc8xoezE+LAFoEcZdWOoYCOdnW4ZFRAi0FMc3lnwGttVmkBx7ODx8/X8iIkGt8uOfRDvbXEG9caqlE/8b8BMz88hlXM1Pfhyrec03WTywzius/UvGqnTlmyZYRE9pTzOVxcZSfxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J2IY2xdjVTEBtlt/08FCEN3aedN8wXPy1I0c7pKxSPE=;
 b=Ag196L2dPzsH79/Uql5GDqFl7+Dr3Ib0h5Dp0rFprdl6poWeBd7SACQJTnsAhabiQsNMxwxjgbxOscsKRYqLiLoQt5c3Xzl8JOYOM/MDFA9tLX1O0m3Ck4FAI1aa2emmJ9EwjGt+sZngad6vh63peQwS+CDe1xSqUl2iMKZnhvFwWvgDzrMt18Qdl7jz5erRl7Me7WNxAnEBQfzM4/XHMU3ICt4Mq45k43aMu5ULu46/cA3ItMtX9u0Tnf5bfKNOi/OTRx1CJDUOIrimD6k8UOI2Jw3W2bsXMgwULsGgrfY7ijSCKB32IHt4ljA8abZy2POOGPEy5GHJdekYupHxmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SJ0PR15MB4219.namprd15.prod.outlook.com (2603:10b6:a03:2ca::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Thu, 3 Mar
 2022 19:17:44 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1d2d:7a0f:fa57:cbdd]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1d2d:7a0f:fa57:cbdd%7]) with mapi id 15.20.5038.015; Thu, 3 Mar 2022
 19:17:44 +0000
Date:   Thu, 3 Mar 2022 11:17:40 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH v6 net-next 03/13] net: Handle delivery_time in
 skb->tstamp during network tapping with af_packet
Message-ID: <20220303191740.kgi3pmkg7lgohnop@kafai-mbp>
References: <20220302195519.3479274-1-kafai@fb.com>
 <20220302195538.3480753-1-kafai@fb.com>
 <63e625fe-067d-bcc3-d28a-6e23402b1ff2@iogearbox.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63e625fe-067d-bcc3-d28a-6e23402b1ff2@iogearbox.net>
X-ClientProxiedBy: MW4PR04CA0375.namprd04.prod.outlook.com
 (2603:10b6:303:81::20) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d8c506b7-43ab-4a5a-8e53-08d9fd4a7e6f
X-MS-TrafficTypeDiagnostic: SJ0PR15MB4219:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR15MB421990E84F1260F71909E1C8D5049@SJ0PR15MB4219.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xvLcPsHMpIRrdnUGaJflrwUoS7qSrXc67iZgRhLNeitmk7UcOYC/COZ07iMh7aE4oYbLXDxJ1ljy43C9LZ1e+D3QX4fUbWppdLTCROG99TDxkiL0kSO2ttDUu+HCVooZR7fHZTPAVuzatLx7dglnT3WKV03/0lxEm3WhyZ5wJ8BckQO3WpwF6LfusqagJrOxwV35TP11ySE7jacPfTAwicfXOVJZS9UnRlQt9t6ntUmE46zKl1BqloJhZi9mdNh+Q/fZH1MvX3xONN7Y4rva0FSPencv9WNa4uzKYOGoE8W+iSCoiJDZH6DquJgC/mFGsujEwk+RhWi2LwyDoCz3/64D9okJXHj6uz/4MyZC75uCwinPqkAEnKx5I78Zs3BkcmQqU6k52LX89EEZhiKWUWrsE8msIDheVzNRK73br6JuQgZVLpFa/BFo2dcO2UuqEZIP1l8S2uQwAFCfsng2PZHmvLex/fLxwyn2bSz4iSDG19+eoQ+pXB1a6C6D/wONDU3Tl9dBHkZ9XcF7M9qeMawVbbHCo3TNrkVfQ0wJmbB7BVMgtMz7BRjsR7fFheY3rksk3AxuLkmTL7Vlk+h4SZYdF5stCYngJkXh79UNhUnOJIXxU+irsAPUzwI8+Wc3JSJ5Thh7grXoP8UhNTJWhA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(2906002)(86362001)(8936002)(5660300002)(38100700002)(186003)(1076003)(54906003)(6916009)(33716001)(6506007)(6512007)(508600001)(6666004)(53546011)(6486002)(52116002)(9686003)(66946007)(66476007)(66556008)(4326008)(8676002)(316002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?E8Cb88YpqOUriMrzZpPJLu1a7cel0Zz/fUstvyFbiig3ozoIbmyEpiby8HIT?=
 =?us-ascii?Q?njtoOu0PQLORLJRDeZLKZ344zxb3HfB3trSSmW2uza+JapCH0dffQpbQit9q?=
 =?us-ascii?Q?vK6dOuJuLy7atVsAnPZ8E/8/Dc3fSyfGPNejVG62Oy2bHwLeBmnHc+9gKRHO?=
 =?us-ascii?Q?YnGmqxViQksYib9mQqh0jFWn4pjcm2T3qikCaReBx29fLecSh/uUhR1n5Nap?=
 =?us-ascii?Q?18l3OZ4KIITceQFN3UzO1aRhDFwbkrjFekANzr58iUlFLfjJDkaxk+75obo1?=
 =?us-ascii?Q?KhEbn5aAFfKciQxsDZjYngNSo3v3tPLa2eEZaoyMyl5VWPJ2HnESWpkC6iNP?=
 =?us-ascii?Q?FCf4YckWXt/A5JJV5bwnrT/N7ot/8C51yTeIymGuh+RC0z8s7pxoNWD4Q9jU?=
 =?us-ascii?Q?JzGx/9os6bvz/Oc6WF8Wh0rHDykUvzbzeqzsHNEQ58GTwMHurAIvVHEy+gu6?=
 =?us-ascii?Q?ybBoz/DuUM3DPTBAi/GrlUOtAe3dPCm1z8eKGv+FnPZZm0EL2xhPFQb8z7mQ?=
 =?us-ascii?Q?KosOOidideEPWeXen0S9epcLAPBIY74c0RHRvCX4o7frPIxayZqdGCpIiliV?=
 =?us-ascii?Q?QfaHTdkG4vBkZhoZMjvCe5gIAzDAFhW025xj16JoAFsxcPMCNto7TSEWDQ01?=
 =?us-ascii?Q?mHP3to4bCg4wwC8vRKzV33k90JehFg8URXfwZQwkN9KlY3SwnwjVIrA4R0Od?=
 =?us-ascii?Q?D1Rk9oO+3NdwUPS0adXJ8OzVbtBOOb8UA3Bz+PNrS+OuHDtoTUsg4/Uv34d7?=
 =?us-ascii?Q?3686tJaZTcscobsWAFU8bztS2a9uLpxN1d1Zmo9l9tj4HFSys1wqUjO6+afT?=
 =?us-ascii?Q?V/Kc1idbMuiFdeqK/iAxjqZqxOGjFf+XbCrcQnCwR++LpI/GtGF2XtjzE5/Y?=
 =?us-ascii?Q?qdIjlmtZ/iti6/RYyX8p8Tphr81IsnEypjV+0LyR02GGdCoSvW6b89KtRRBB?=
 =?us-ascii?Q?mw3gzXCeiWHfFyXG49VDoz4beaBmbZr4RPhWcd66n6T9naZ29KRAyjbHk4Qt?=
 =?us-ascii?Q?XOs4d+R+h5XPPKKhbUDwUQGfIq+VAlD15JluhcKS9JaCAfv+r6HZfnRr2QkE?=
 =?us-ascii?Q?zaRqRW18roMHigMh4lLcHq4liLTqIuAd+2sKX2ffzbH18PsEw3aLGeAZWhDW?=
 =?us-ascii?Q?S8seCunLXQ9IKlthQsOic9bC/2It9W0NxY+oEYuPd8fHb47hYJIUePmQVIGT?=
 =?us-ascii?Q?erbxSvs6ioTZzyGhWFo9hh5MLzgqJabK+72UrBohp73o3P/KP3eH6t6GlhMB?=
 =?us-ascii?Q?zR0VRCCw+j3mKPP2YCN2p2ohcjrP1pJpzzBB8Szm4NDJxsKNKHLSW8v99gRa?=
 =?us-ascii?Q?kFUIwUYkQCVP7qVpG0P6sj93eVieOkYjYCQnGK1i9brk0HjgQJ32Ao3Hc+aP?=
 =?us-ascii?Q?8jK3WjhuE+F/TsJB52mbJzLS9CWUyQqzkE5PRTWaIwlZC0h3BY/sTI+0OD8y?=
 =?us-ascii?Q?+GPlChLIw12oqA2AG8CE9MINS0j8t7HxZNZTjvM/5SLc5Tii0R+c7oJkxuO9?=
 =?us-ascii?Q?8f45HyZRuwGB6A+iqXzvaxPPOPitcnWDE0m7U6XFbBOXvZVeYVPKjororbtc?=
 =?us-ascii?Q?t1OtrKLqJm4Mo2a6t6HWtngJQ55UN+vC1YfcRGgG?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8c506b7-43ab-4a5a-8e53-08d9fd4a7e6f
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2022 19:17:44.2626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YfHZMeJbntdQcECfbnl0Bw7gJiRqxE1Wv+nS48BsLr7kV0ySDMAYKhIktDGKEgh2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4219
X-Proofpoint-ORIG-GUID: B4hox7AtWzDqyq_2UI9AlDet8g8bzqM2
X-Proofpoint-GUID: B4hox7AtWzDqyq_2UI9AlDet8g8bzqM2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-03_09,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 adultscore=0
 impostorscore=0 mlxscore=0 spamscore=0 malwarescore=0 suspectscore=0
 bulkscore=0 priorityscore=1501 phishscore=0 mlxlogscore=410
 lowpriorityscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2203030087
X-FB-Internal: deliver
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 03, 2022 at 11:48:19AM +0100, Daniel Borkmann wrote:
> On 3/2/22 8:55 PM, Martin KaFai Lau wrote:
> [...]
> > When tapping at ingress, it currently expects the skb->tstamp is either 0
> > or the (rcv) timestamp.  Meaning, the tapping at ingress path
> > has already expected the skb->tstamp could be 0 and it will get
> > the (rcv) timestamp by ktime_get_real() when needed.
> > 
> > There are two cases for tapping at ingress:
> > 
> > One case is af_packet queues the skb to its sk_receive_queue.
> > The skb is either not shared or new clone created.  The newly
> > added skb_clear_delivery_time() is called to clear the
> > delivery_time (if any) and set the (rcv) timestamp if
> > needed before the skb is queued to the sk_receive_queue.
> [...]
> > +DECLARE_STATIC_KEY_FALSE(netstamp_needed_key);
> > +
> > +/* It is used in the ingress path to clear the delivery_time.
> > + * If needed, set the skb->tstamp to the (rcv) timestamp.
> > + */
> > +static inline void skb_clear_delivery_time(struct sk_buff *skb)
> > +{
> > +	if (skb->mono_delivery_time) {
> > +		skb->mono_delivery_time = 0;
> > +		if (static_branch_unlikely(&netstamp_needed_key))
> > +			skb->tstamp = ktime_get_real();
> > +		else
> > +			skb->tstamp = 0;
> > +	}
> > +}
> > +
> >   static inline void skb_clear_tstamp(struct sk_buff *skb)
> [...]
> > @@ -2199,6 +2199,7 @@ static int packet_rcv(struct sk_buff *skb, struct net_device *dev,
> >   	spin_lock(&sk->sk_receive_queue.lock);
> >   	po->stats.stats1.tp_packets++;
> >   	sock_skb_set_dropcount(sk, skb);
> > +	skb_clear_delivery_time(skb);
> 
> Maybe not fully clear from your description, but for ingress taps, we are allowed
> to mangle timestamp here because main recv loop enters taps via deliver_skb(), which
> bumps skb->users refcount and {t,}packet_rcv() always hits the skb_shared(skb) case
> which then clones skb.. (and for egress we are covered anyway given dev_queue_xmit_nit()
> will skb_clone() once anyway for tx tstamp)?
Yes, refcount_inc(&skb->users) and then skb_clone() is my understanding also
for the ingress tapping path.  On top of that, in general, the current
{t,}packet_rcv() is changing other fields of a skb also before queuing it,
so it has to be a clone.

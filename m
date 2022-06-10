Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30FD0546C0E
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 20:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350381AbiFJSAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 14:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349526AbiFJR7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 13:59:44 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ADDB1E450B;
        Fri, 10 Jun 2022 10:58:52 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25AD0Z9w026260;
        Fri, 10 Jun 2022 10:58:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=kFXhtDF8h/m5vyIwupKfOE/A1oq1oM4pwN3iaUPGMm0=;
 b=LGDa9dy6YTWSebcDsQWPs4I6rbVwK4UhXr4wlBTcrUeLFYhrhMmx+H1EbyC3ZaOMHL+M
 scR8ncHsND3lvHj2J/JEWUXLP39MLgBbIziwWy7bwVLuI+vs8VosA76AG125pzvlqAW4
 /4Mv0KY7zuFhbQG4b3GPGfsbcoufHb5MTN0= 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gkr0pe740-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Jun 2022 10:58:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=el6MEqRt0PClPGZ3bTKuHidFpqZHmA366km9LDqVAdqK9Ov2TKMMNDOYB1yMqE2AcBkHrVMi146ibDUxoo39D9qqIafq5ttUo8xtrcZ9jufcj6LDQb7yf1kVubl/zmGqsCrkJ2CUeE6hMJxDwB7xrcjSQlJnRhJmwiKbqWO7ETgDVWPMN7ShDyC4glewGUkrPHtWa7hFynVumB6dVyFp3IASIRQYYt5C5A+7ZSfLmrYgb/Hg4MAoufUd5GGyrven3uu+/kRCFxPHnSpShQHNr3RhIQ1ZN8DHGSdcQ21VOYju7mlNOu8PCB0Uw6VCuznhcLl0xsDqS8By4TB5QX1Lvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kFXhtDF8h/m5vyIwupKfOE/A1oq1oM4pwN3iaUPGMm0=;
 b=W2246R7S3RC9Qpwke/S7PKqbw3fABaJznhrYkfCf/+a5UBGOldBdOuz2lf7SJyZPr5suwUHB7eNfWnT+SBxSH19HgEUI3zTgfQxTNRgfWXdHsNmSCcIpoTsNw2Y4cp+GC9ZlD4s/WtJFCgVhL5WR/o2z2pEO342ax5hePSItbRbkNkqk7TAXbkSADKJYZnway9uu5cwUQ39WuHUdTBpr5gkTMaMQbeEXzLzG2R962oWFUBcIFT7C6QsL+kDkxws4kvxDtxMlaq8WFA9x7rX3s4dK61e9gjk4/DpvgG6mxjGHr8NuQAtUef7A+gmUhF3a1MP0pho0zQnULqX7O2IdmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by CO6PR15MB4212.namprd15.prod.outlook.com (2603:10b6:5:353::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.15; Fri, 10 Jun
 2022 17:58:29 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::a09e:da84:3316:6eb0]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::a09e:da84:3316:6eb0%9]) with mapi id 15.20.5332.015; Fri, 10 Jun 2022
 17:58:28 +0000
Date:   Fri, 10 Jun 2022 10:58:26 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Jon Maxwell <jmaxwell37@gmail.com>, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, atenart@kernel.org, cutaylor-pub@yahoo.com,
        alexei.starovoitov@gmail.com, joe@cilium.io, i@lmb.io,
        bpf@vger.kernel.org
Subject: Re: [PATCH net] net: bpf: fix request_sock leak in filter.c
Message-ID: <20220610175826.zbi6nwt23wky3ho2@kafai-mbp>
References: <20220609011844.404011-1-jmaxwell37@gmail.com>
 <56d6f898-bde0-bb25-3427-12a330b29fb8@iogearbox.net>
 <20220610001743.z5nxapagwknlfjqi@kafai-mbp>
 <76972cdc-6a3c-2052-f353-06ebd2d61eca@iogearbox.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76972cdc-6a3c-2052-f353-06ebd2d61eca@iogearbox.net>
X-ClientProxiedBy: BYAPR11CA0108.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::49) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 50b8815e-8892-465e-361a-08da4b0ad2f3
X-MS-TrafficTypeDiagnostic: CO6PR15MB4212:EE_
X-Microsoft-Antispam-PRVS: <CO6PR15MB4212340EE5B2147182869F3FD5A69@CO6PR15MB4212.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: afrl31THONHzBrteFISCN+yODO4ZWEGaGJEcYRnE1SChqK8s5NbflOLfp0lsA4ZO4Ke02oTZZXE+01rEnn9xn905xtpRu/GHg4zLb9RlZoz+eaNg2La0oaFNR2KhVmx3pQL5PncQaLohKKYBXJVCPgJEw+Uq2YYYpc09tSbFEsDQh1i6/u45Kz6bp1+Aqf7e3YPVXRpXD+DMw/V1z2dVy5Zczok8+bvABFAjvA7e0ZFcVWMb8LAF6GVj1Unyk7OVkCr+W/DxNMvZP00kSsYIgjWmNriU1LxXvU6694iHBpMZLVlfK2MFU9EAwpDsg8uUgQ/XeOLv9aL1Wd3OTLQkaZVe8gChaq9qEDQEWWyB3VuO6/GfzBUGp8d3PsGVoYlf2viWugRE3FIkAxhRL9xrSFLppIWZQpuKJesFWXN+Y9LfRN21noxFKuOAUH5TLz/DxkwfHd+Gol9Czcv0Juy/twXwu7t6RexeOBbr7QQxgpnR0Q7KvuNecLp2MGUhn8HGHAcZt9oYWB2wqHriVqNw8cTh1HnoNpPIdYxRa2l8R4B+6ONEGhPnNOw3gu7ds7ovzS8mGzQTiZ6rB3/rs58HVRYKIKzLhU34e051oPVDjVlNUA0B/ul2CiS6QGd5ldERev+qDJRZiG+1pJTw6X9Jbg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(52116002)(53546011)(2906002)(86362001)(6506007)(6486002)(5660300002)(83380400001)(508600001)(7416002)(8936002)(33716001)(9686003)(6512007)(38100700002)(4326008)(66556008)(66946007)(66476007)(8676002)(1076003)(6916009)(316002)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Dj1O32Jmf/C5VDeHjqvnMIseDp84CWZs3NuUbJ2Cuxldxc4LoSTMePs7dbmk?=
 =?us-ascii?Q?FTRYRnFCJfmKMjO8w4IOkoMM+Y113Jh3rx/69Dxxsfp5XVHD/8tAx+MFk/wN?=
 =?us-ascii?Q?YYj/AotHYqPilqC3jewgH9Wmyp7UHwomSR6Gzfe15jv8EFLFc3nMp+PGL8yw?=
 =?us-ascii?Q?eZ3FSCTUT45MyJCibMff+lsFdyXcReRQkrp6QXg9TTTOdpvGp33aoB2xKTBr?=
 =?us-ascii?Q?j8/x4Y+uOBoI7wBFgNoGEfCcLiB4+AkibxUWDoOzqwNQj6LUGyITfDFeN9Ar?=
 =?us-ascii?Q?9s9OG+CLCd4cF5XmUIFVc+UWjgwh5C0mssyv8DRQNvV0Hy+U2c5ZbIqb31YC?=
 =?us-ascii?Q?1NEG/TWzZAVEDzOWHthjeNklx8tPySbpoPTj7hhANmkR7I+MpsZdmWN4Bvrw?=
 =?us-ascii?Q?JtZj7VnZGAHM4dPcKhGrvhTZEYBArW7Uzm1DQ606KD8iDPngmMq9jZ/I1oCf?=
 =?us-ascii?Q?nqkoBBRJbzomWstTU6QIQelbBrjOabjRrEA3ZFJAX6iRrMZ5iMHPEiDbuen7?=
 =?us-ascii?Q?heJkyzLDDNQrmXYdcxaReMk40NLS6TP39uEQeabRN9+ys1lugr6cuGIKHkiw?=
 =?us-ascii?Q?67ljjHYxVzgM1+nsvYIxB+CFH2p36zBofcwpspE/XWVZ5PWXWpfr4e2PX2pq?=
 =?us-ascii?Q?xFqDhtC5BOHTVpLBlKsstQD8qwJgNCKNcOvMYJ2cX1zA/OQ2xPbvOweokK2v?=
 =?us-ascii?Q?wYzjNdLkZIvkKI/+5P0+0K93YpcP9euPJeQQ3Hr+cVxSm4lVkMTzvffPXkA7?=
 =?us-ascii?Q?YVStnlHzcLNBDOkTykEmzlwnJXlYm4CQCLNyR45bhL0FxauxDMWuMhqgf0Wf?=
 =?us-ascii?Q?HA6T+CDkB9fK1RMUSyBKE888HVZs9L9FpJ/AicIgSVeqcOPptHzOw3HnIY0m?=
 =?us-ascii?Q?+/d/lOZZBogub4k2DIfVh7mMwQVmmsP1vvSHjgbORnu+Wzo1GvDyB6I9UDUr?=
 =?us-ascii?Q?9EeUb0pE21sE0BH07hBc7BUqutK5fDyPlUQOF634mpD22XemN+zxLsJ/5McE?=
 =?us-ascii?Q?BRAGo+oynUsZcm4IULZKX6cpsYQ1ZpnIdj3tp+ViQ8nseNnVbOHRZJOgsc2E?=
 =?us-ascii?Q?ZvcVzOLsRNUeV2Joju64xzFFlWZw+Kb4Y9aki1n6ybHLbg+nhylX4MiatT/+?=
 =?us-ascii?Q?sbXvHw6mrU+NJaORDgdFXVUnIZyx+7FnQxEAHG2S4stZc2OCRXFdE2HtTEdy?=
 =?us-ascii?Q?BSIkaocqJh35AqfJQWS+YrXhiDSmYQiIvFHcg9ty8iJtZIw9cLCm7nraJQW/?=
 =?us-ascii?Q?XatiTWJrlA13yNQDNf/cOvN+kVVjeUnHBtiR8lj6t224itWI+JK9mWjNa/t2?=
 =?us-ascii?Q?nnPFQ/EPmcIJYv93eBcXDMEcyw3Li1Jncd8bSncZGgUNh27qh35YNI3+/I0T?=
 =?us-ascii?Q?4Q7FJdDFM1L6Wl6MbfWW+1UB8hEODH5B9IveBw3h4T7FRFnD7IOBDpaIYKh3?=
 =?us-ascii?Q?vRMO2OrM3q5SvyMa0xcF48KrMeILRa6ziYRZHxPUuNiNQpnsUE7kqACzTH5L?=
 =?us-ascii?Q?VoETA/PQ+PYpK13qJDVppWd4ZBzybRGelO99ofU+0RV1p8VFU7VmaIP8mSKr?=
 =?us-ascii?Q?ws9pEdzXNBcPrfhZzOa8GIQiyC6h1QJTGm2siMB4nLeHDTBTDGoNbPDZZyqW?=
 =?us-ascii?Q?Ja8c166FO8DCbajrZ94IR5HwEi70JQhivlsHVaE8o2os5O/uew/F8HU1k7Xf?=
 =?us-ascii?Q?Dvu6Scs4VHPjaL4iqUAC8OTRxl9p2fjV5MucbYkzNMeOdPP83YtLSiizVPMD?=
 =?us-ascii?Q?3LoJ7w+QAnHD31TeNeWG+XYYvhQtZd8=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50b8815e-8892-465e-361a-08da4b0ad2f3
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2022 17:58:28.9005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oFQwhBxxpfGq7lHLlRO++xc828RXPxvOgqLnGfdpaZuDnKEsRgQOdFVa438L9pCC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR15MB4212
X-Proofpoint-ORIG-GUID: p_10nEuf9akt28Et_-2sQxX5YrpGrU1C
X-Proofpoint-GUID: p_10nEuf9akt28Et_-2sQxX5YrpGrU1C
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-10_07,2022-06-09_02,2022-02-23_01
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 10, 2022 at 09:08:41AM +0200, Daniel Borkmann wrote:
> On 6/10/22 2:17 AM, Martin KaFai Lau wrote:
> > On Thu, Jun 09, 2022 at 10:29:15PM +0200, Daniel Borkmann wrote:
> > > On 6/9/22 3:18 AM, Jon Maxwell wrote:
> > > > A customer reported a request_socket leak in a Calico cloud environment. We
> > > > found that a BPF program was doing a socket lookup with takes a refcnt on
> > > > the socket and that it was finding the request_socket but returning the parent
> > > > LISTEN socket via sk_to_full_sk() without decrementing the child request socket
> > > > 1st, resulting in request_sock slab object leak. This patch retains the
> > Great catch and debug indeed!
> > 
> > > > existing behaviour of returning full socks to the caller but it also decrements
> > > > the child request_socket if one is present before doing so to prevent the leak.
> > > > 
> > > > Thanks to Curtis Taylor for all the help in diagnosing and testing this. And
> > > > thanks to Antoine Tenart for the reproducer and patch input.
> > > > 
> > > > Fixes: f7355a6c0497 bpf: ("Check sk_fullsock() before returning from bpf_sk_lookup()")
> > > > Fixes: edbf8c01de5a bpf: ("add skc_lookup_tcp helper")
> > Instead of the above commits, I think this dated back to
> > 6acc9b432e67 ("bpf: Add helper to retrieve socket in BPF")
> > 
> > > > Tested-by: Curtis Taylor <cutaylor-pub@yahoo.com>
> > > > Co-developed-by: Antoine Tenart <atenart@kernel.org>
> > > > Signed-off-by:: Antoine Tenart <atenart@kernel.org>
> > > > Signed-off-by: Jon Maxwell <jmaxwell37@gmail.com>
> > > > ---
> > > >    net/core/filter.c | 20 ++++++++++++++------
> > > >    1 file changed, 14 insertions(+), 6 deletions(-)
> > > > 
> > > > diff --git a/net/core/filter.c b/net/core/filter.c
> > > > index 2e32cee2c469..e3c04ae7381f 100644
> > > > --- a/net/core/filter.c
> > > > +++ b/net/core/filter.c
> > > > @@ -6202,13 +6202,17 @@ __bpf_sk_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
> > > >    {
> > > >    	struct sock *sk = __bpf_skc_lookup(skb, tuple, len, caller_net,
> > > >    					   ifindex, proto, netns_id, flags);
> > > > +	struct sock *sk1 = sk;
> > > >    	if (sk) {
> > > >    		sk = sk_to_full_sk(sk);
> > > > -		if (!sk_fullsock(sk)) {
> > > > -			sock_gen_put(sk);
> > > > +		/* sk_to_full_sk() may return (sk)->rsk_listener, so make sure the original sk1
> > > > +		 * sock refcnt is decremented to prevent a request_sock leak.
> > > > +		 */
> > > > +		if (!sk_fullsock(sk1))
> > > > +			sock_gen_put(sk1);
> > > > +		if (!sk_fullsock(sk))
> > In this case, sk1 == sk (timewait).  It is a bit worrying to pass
> > sk to sk_fullsock(sk) after the above sock_gen_put().
> > I think Daniel's 'if (sk2 != sk) { sock_gen_put(sk); }' check is better.
> > 
> > > [ +Martin/Joe/Lorenz ]
> > > 
> > > I wonder, should we also add some asserts in here to ensure we don't get an unbalance for the
> > > bpf_sk_release() case later on? Rough pseudocode could be something like below:
> > > 
> > > static struct sock *
> > > __bpf_sk_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
> > >                  struct net *caller_net, u32 ifindex, u8 proto, u64 netns_id,
> > >                  u64 flags)
> > > {
> > >          struct sock *sk = __bpf_skc_lookup(skb, tuple, len, caller_net,
> > >                                             ifindex, proto, netns_id, flags);
> > >          if (sk) {
> > >                  struct sock *sk2 = sk_to_full_sk(sk);
> > > 
> > >                  if (!sk_fullsock(sk2))
> > >                          sk2 = NULL;
> > >                  if (sk2 != sk) {
> > >                          sock_gen_put(sk);
> > >                          if (unlikely(sk2 && !sock_flag(sk2, SOCK_RCU_FREE))) {
> > I don't think it matters if the helper-returned sk2 is refcounted or not (SOCK_RCU_FREE).
> > The verifier has ensured the bpf_sk_lookup() and bpf_sk_release() are
> > always balanced regardless of the type of sk2.
> > 
> > bpf_sk_release() will do the right thing to check the sk2 is refcounted or not
> > before calling sock_gen_put().
> > 
> > The bug here is the helper forgot to call sock_gen_put(sk) while
> > the verifier only tracks the sk2, so I think the 'if (unlikely...) { WARN_ONCE(...); }'
> > can be saved.
> 
> I was mainly thinking given in sk_lookup() we have the check around `sk && !refcounted &&
> !sock_flag(sk, SOCK_RCU_FREE)` to check for unreferenced non-SOCK_RCU_FREE socket, and
> given sk_to_full_sk() can return inet_reqsk(sk)->rsk_listener we don't have a similar
> assertion there. Given we don't bump any ref on the latter, it must be SOCK_RCU_FREE then
Ah. got it.  Thanks for the explanation.

Yep, agree.  It is useful to have this check here to ensure
no need to bump the sk2 refcnt.  A comment may be useful
here also, /* Ensure there is no need to bump sk2 refcnt */

Thanks!


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3619452B12E
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 06:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbiEREQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 00:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbiEREQX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 00:16:23 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2101.outbound.protection.outlook.com [40.107.20.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26B38CE20;
        Tue, 17 May 2022 21:16:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TETdHGIKTx9ekyDvTbjxtfJSMOrEwbMShCVpkkWvZr3849wZPWwNN0OEX1XJUr/cw0HqFmEKLZCmMxHBf5l6lH5gqSpdUlDeZerMEKdfsDKJreFtY77rb+EM4pucXjT6YSUS4g0OUQLPJEgZBrsHwru7qTo4uUYbf/1q5JgXYynqRubsbofb41/487jmTrFN1zTLGjagzYU7mGokoPnnNxs0pMlROVD5wZ2RbHxfy3NtyTLGq1p3TNJOzm4gh+mEPKvgR6TA5/sDtu7hLroBjXIzieJdMNCPvZCxfGLciPkyT2L+GubYxHKtz0d3RjWkb+j1v0kiT1o+ojcJlImccw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nSPUvIXCbHPCkaD93HLKPFuJ8KP4ej20bMggLrYt8js=;
 b=JzIKqWwZPCZO+3TutRMgmVtWBOI6oUij7Ayw0+YUkDmxJ2+PvEFO35hUHx5RAGm37lpkm6DU68Ic5bOV3euNgcPoNcUjKyO5r/KJOeF6CXqosjCdnf/oQos57YuF3z/C307mtiFZrL/VaeoAt2h/8LV3XzdtOd5rCrwsyqCZegNrigpmJeO9bb8d+ywLeZc1Vju39rIBp0gzN1LDWVHRJI+w6aEWHVgY6kZhelBh0ll20zx82Hl9Z9+j9oz4+pBYfZEieGvc6bkTTx/0al/GPts+3S6Zo9qUJsCIxTl+R2rsO2wrw1XabMQYWuGR+3zu2+X1/r57M1VOwRElsIk0sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nSPUvIXCbHPCkaD93HLKPFuJ8KP4ej20bMggLrYt8js=;
 b=HyTkNTAEqdtE8nIIVv5sen+/Ay9ENTyqKHE/hbO00iSs11hA3us4pqVwWOuaRlUKaOpYShyCht6P7ZaW+Qp0tHvGukoFcma3wSuLXeSdCjU4PY7ZhHHVVD9mlS8JlvaCNpMRs41xIp6wxuUdzTzchmNOnkJcyrfnpxqfXc8bXYg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from PA4PR05MB8996.eurprd05.prod.outlook.com (2603:10a6:102:2a7::10)
 by AM0PR0502MB3713.eurprd05.prod.outlook.com (2603:10a6:208:16::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Wed, 18 May
 2022 04:16:17 +0000
Received: from PA4PR05MB8996.eurprd05.prod.outlook.com
 ([fe80::b1f3:359c:a4dd:2594]) by PA4PR05MB8996.eurprd05.prod.outlook.com
 ([fe80::b1f3:359c:a4dd:2594%7]) with mapi id 15.20.5250.018; Wed, 18 May 2022
 04:16:17 +0000
Date:   Wed, 18 May 2022 06:16:13 +0200
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     Oz Shlomo <ozsh@nvidia.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, nbd@nbd.name, fw@strlen.de,
        paulb@nvidia.com, netdev@vger.kernel.org
Subject: Re: [PATCH nf,v2] netfilter: flowtable: fix TCP flow teardown
Message-ID: <20220518041613.4caq2xneizazsaao@svensmacbookpro.sven.lan>
References: <20220517094235.10668-1-pablo@netfilter.org>
 <f8247247-4109-18bc-c422-a69619b50258@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8247247-4109-18bc-c422-a69619b50258@nvidia.com>
X-ClientProxiedBy: AM5PR0402CA0024.eurprd04.prod.outlook.com
 (2603:10a6:203:90::34) To PA4PR05MB8996.eurprd05.prod.outlook.com
 (2603:10a6:102:2a7::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 449b849e-daca-48ce-8079-08da388527bd
X-MS-TrafficTypeDiagnostic: AM0PR0502MB3713:EE_
X-Microsoft-Antispam-PRVS: <AM0PR0502MB37139DA9BAFFE729B4E38330EFD19@AM0PR0502MB3713.eurprd05.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PUEFmGjtKXu7vGZP5Dg9AgdE6nwHMdVugS140mFv5Q54C1K8H8r2ktG9BbJht/gUE6VRkAdjmi9dRWCByURKWMNxFImDTxXVbAHBOWqiB7WcuY7rj1LIq8f/ru6420V3WU8kT/20cSxS9rVvugduzCb/C55BJg9yzTCzvvCE9yrbaJeMaw0LG8DTGZDKf/ujuaNt5SId8+DSKPVWKxHp4A7o/lZLikjWk4eHnoPWDOEneJ37WEIjnTo/xjohxAEWarGvH+LQhlw/kXGrMg1H9+V8oQSDw28e8cbRSjfUCJchpK/SJy3LxYRwGgvpwYkQKCbcvbHNS0tMRI5leEust9ur+Pd662Iy44nLVMqz0nASCf/DlcGRoJJwYvrX0XFLSnZBsTGhaykQ9GrjMXYNPaLr2JCDm2JibX5jYBivkbhEoOAw14wtS/iDGlzgAwc4sYaMGej97/iy08ZuaAcNq4d5/57pdladKhynLsOw/B4F5/Nm4FxRV8SqrSApOi2pYMk4OpQgUynCE+tJy0Gdb7vA+hYsYnSVIrHugC7gYcup+4KjdZb2Aq52Ve/qyVPVMKImfXfWYYOW/mPsN5ThQ2LglAAmoWzZF/+WMEeF43RqnrWvW0w9O8IbtCyK0tHJL0Rph+WgRYSBL1mFbcS4yg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR05MB8996.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(396003)(136003)(346002)(39830400003)(366004)(376002)(66946007)(2906002)(4326008)(86362001)(66556008)(38100700002)(6506007)(5660300002)(53546011)(66476007)(6916009)(41300700001)(316002)(9686003)(6512007)(26005)(6666004)(186003)(8936002)(508600001)(6486002)(8676002)(44832011)(83380400001)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OZzgYOo/JpFWhXXWO1IQo+1lZzdVHHRPXCKRE9LTomnKdQu/a4Lpu4G8cYuG?=
 =?us-ascii?Q?ge7OGIb7YjsF9uoq5sUi7nSztTTgvl4XnNdWoSJ3l5JYAUXfygeToSmG/Gl6?=
 =?us-ascii?Q?VYLGD7OSD1sDThF0zEzo9FGK3+lX4rDgGJdLCfodGU60P+/h0bOjqaXicJ0y?=
 =?us-ascii?Q?hAOdRAbAp94UCR2dhz5kxxPZ/FE8eEhFe3xvTKDaVjhMc/3SfMCPJSEk04K0?=
 =?us-ascii?Q?+lWmAZcJXAYr2G6UToLWLrbcrbC7XGGmDbCbfEmEKJskSjp4hP3UHblb6sNK?=
 =?us-ascii?Q?XQDA+hlRwyPqQeD0lLR3vHoeGggRpBKRxAHxsuCFF4gOYcnE7Ic1tBEEKWRE?=
 =?us-ascii?Q?3hUXWtwgQBLIbogKqIBQZwKHpTi3UF4KFfWjBpIImfA9snSfrXTwSgjrqupv?=
 =?us-ascii?Q?mEhUbG9wYEqQrWX7oO3EKMa6Q+7Zl0A33ykT2nQ1G1n1O7TvD/vGrF1Jdg/K?=
 =?us-ascii?Q?1rWbv198s60L3ganQJK73MHSJ31r5aO9sqK3M8nnhAqFaZDSiBHIka644D3C?=
 =?us-ascii?Q?tmBYOZZMYL49mfzTNS4m20vqgXxJ2FVBJ2mf2KHTfGznh28WG8VfnfvQFd24?=
 =?us-ascii?Q?dlaPcyYFqn1kRDmuwzphMT7adwbV9Dj/Cs/no9pk1Pg/ZM643pUmJJ3llcuH?=
 =?us-ascii?Q?z9g9BqeoEM8QNBDVZJO+8fuPfjY0lQIdf25iT6sOf5dPwKJC5dNNhsEEoRmQ?=
 =?us-ascii?Q?aN/uBN7f6gilT8sHUXnS0cvSh5qcTDuarzxuVi/LKvq/twCIPXro5vXV0l00?=
 =?us-ascii?Q?yNEOI43E9UmlS/M/nNoTIX49VFnFyaSn9YebYLDz66qrVIHvb9vlXU3Kjr8d?=
 =?us-ascii?Q?lYcA3GmBwC9LJRNGb4tCSpFV1v+O/3dC/Fyt58JnLxMl7TcWdpt0piqCdCfL?=
 =?us-ascii?Q?BZeCVU3ZwSRElnuJwzfNd6H7wG2e/thtRx+Uo79653v4Wnm3Swy7lh6nNh9x?=
 =?us-ascii?Q?s6lgung7WQ6j0u1fJcp+DvuMTWKMsz1pWBZDNbEW9tRF2lbWNBcttaiUtE6l?=
 =?us-ascii?Q?nVjNwivv3JPruYcAoJxhcHZeqaVn6yPK2sMYyr4F91WV/fI6wUEB3p6/dfwL?=
 =?us-ascii?Q?UzaN2LSH2N/8WBA3ujo7o42q7MT+y87lAKlwsm/JF48DnJs1g41+RBp0PHvL?=
 =?us-ascii?Q?WTJLNrrllzFENYA79I61zrHidtXj0RXqEM1bVIQ0DSTA9s6eQCI4/cZxF+/W?=
 =?us-ascii?Q?NC6Yv2vaXDHLCmHuy/QzAl3L5+f4QMLO8CXrcMfopYyfsAm1cWlH3M7I3MKL?=
 =?us-ascii?Q?oxbFmAeJuavx0KF9QWpCsT6xmDzWe62AB+B7pbIpSIqaqYea69d31ZckKFzC?=
 =?us-ascii?Q?4uUKwVz0tfDmt2vJr9hAtsOOmdrw/JZThq0J4n/NiMO5/f8hiMaHje6pXby3?=
 =?us-ascii?Q?MsLOIUvjqULIa8V1C29RHc6hAegwG+HlkThTKh1tNIo/RFV/KE+oGnm/GxCW?=
 =?us-ascii?Q?H+Htn0UfjeigGTa5CP2VLw8LZ5AHchXmBpQMpj8LMyZQKFze4QR88+sHFXte?=
 =?us-ascii?Q?fPMvbCly99QfdKJtULIkByxuvmNTqNPH4rmkiKw9kBjJXc2Rx9l2dlY6INL3?=
 =?us-ascii?Q?gOrMZLI3rIiRvdKKMpWSjel9ri+E4Zndb6b6Ec1Bzxf4e8h1+TezuEvx53/D?=
 =?us-ascii?Q?oQuQNFLNBSMHSlKF+EFIqO3PD/NyWvPQm3aZvApTZl1PPrQLOBQ9d6HLDKYZ?=
 =?us-ascii?Q?PZlJzSDFk/olhWEGBKyQ8kT3MPNaa659nfdejDHGSKuYot7THpuwE11ghOes?=
 =?us-ascii?Q?HOTnYXmN3D31sAU5iLpuYgMfnFJip/c=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 449b849e-daca-48ce-8079-08da388527bd
X-MS-Exchange-CrossTenant-AuthSource: PA4PR05MB8996.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 04:16:17.6925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 50VzELjnF1QqkT+WfRFIon+pAiKFu8vZnNKrjL2RunRP1plwMjhw5Fxu8fp1GYcN9TDiLuh50SfeEavQFWbZS+dLNdNIe+Us/xhe+GCP0Bo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB3713
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


I tested the patch in production yesterday and everything looks good.

Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>

On Tue, May 17, 2022 at 01:04:53PM +0300, Oz Shlomo wrote:
> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
> 
> On 5/17/2022 12:42 PM, Pablo Neira Ayuso wrote:
> > This patch addresses three possible problems:
> > 
> > 1. ct gc may race to undo the timeout adjustment of the packet path, leaving
> >     the conntrack entry in place with the internal offload timeout (one day).
> > 
> > 2. ct gc removes the ct because the IPS_OFFLOAD_BIT is not set and the CLOSE
> >     timeout is reached before the flow offload del.
> > 
> > 3. tcp ct is always set to ESTABLISHED with a very long timeout
> >     in flow offload teardown/delete even though the state might be already
> >     CLOSED. Also as a remark we cannot assume that the FIN or RST packet
> >     is hitting flow table teardown as the packet might get bumped to the
> >     slow path in nftables.
> > 
> > This patch resets IPS_OFFLOAD_BIT from flow_offload_teardown(), so
> > conntrack handles the tcp rst/fin packet which triggers the CLOSE/FIN
> > state transition.
> > 
> > Moreover, teturn the connection's ownership to conntrack upon teardown
> > by clearing the offload flag and fixing the established timeout value.
> > The flow table GC thread will asynchonrnously free the flow table and
> > hardware offload entries.
> > 
> > Before this patch, the IPS_OFFLOAD_BIT remained set for expired flows on
> > which is also misleading since the flow is back to classic conntrack
> > path.
> > 
> > If nf_ct_delete() removes the entry from the conntrack table, then it
> > calls nf_ct_put() which decrements the refcnt. This is not a problem
> > because the flowtable holds a reference to the conntrack object from
> > flow_offload_alloc() path which is released via flow_offload_free().
> > 
> > This patch also updates nft_flow_offload to skip packets in SYN_RECV
> > state. Since we might miss or bump packets to slow path, we do not know
> > what will happen there while we are still in SYN_RECV, this patch
> > postpones offload up to the next packet which also aligns to the
> > existing behaviour in tc-ct.
> > 
> > flow_offload_teardown() does not reset the existing tcp state from
> > flow_offload_fixup_tcp() to ESTABLISHED anymore, packets bump to slow
> > path might have already update the state to CLOSE/FIN.
> > 
> > Joint work with Oz and Sven.
> > 
> > Fixes: 1e5b2471bcc4 ("netfilter: nf_flow_table: teardown flow timeout race")
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> > v2: fix nf_conntrack_tcp_established() call, reported by Oz
> > 
> >   net/netfilter/nf_flow_table_core.c | 33 +++++++-----------------------
> >   net/netfilter/nft_flow_offload.c   |  3 ++-
> >   2 files changed, 9 insertions(+), 27 deletions(-)
> > 
> > diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> > index 20b4a14e5d4e..ebdf5332e838 100644
> > --- a/net/netfilter/nf_flow_table_core.c
> > +++ b/net/netfilter/nf_flow_table_core.c
> > @@ -179,12 +179,11 @@ EXPORT_SYMBOL_GPL(flow_offload_route_init);
> >   static void flow_offload_fixup_tcp(struct ip_ct_tcp *tcp)
> >   {
> > -	tcp->state = TCP_CONNTRACK_ESTABLISHED;
> >   	tcp->seen[0].td_maxwin = 0;
> >   	tcp->seen[1].td_maxwin = 0;
> >   }
> > -static void flow_offload_fixup_ct_timeout(struct nf_conn *ct)
> > +static void flow_offload_fixup_ct(struct nf_conn *ct)
> >   {
> >   	struct net *net = nf_ct_net(ct);
> >   	int l4num = nf_ct_protonum(ct);
> > @@ -193,7 +192,9 @@ static void flow_offload_fixup_ct_timeout(struct nf_conn *ct)
> >   	if (l4num == IPPROTO_TCP) {
> >   		struct nf_tcp_net *tn = nf_tcp_pernet(net);
> > -		timeout = tn->timeouts[TCP_CONNTRACK_ESTABLISHED];
> > +		flow_offload_fixup_tcp(&ct->proto.tcp);
> > +
> > +		timeout = tn->timeouts[ct->proto.tcp.state];
> >   		timeout -= tn->offload_timeout;
> >   	} else if (l4num == IPPROTO_UDP) {
> >   		struct nf_udp_net *tn = nf_udp_pernet(net);
> > @@ -211,18 +212,6 @@ static void flow_offload_fixup_ct_timeout(struct nf_conn *ct)
> >   		WRITE_ONCE(ct->timeout, nfct_time_stamp + timeout);
> >   }
> > -static void flow_offload_fixup_ct_state(struct nf_conn *ct)
> > -{
> > -	if (nf_ct_protonum(ct) == IPPROTO_TCP)
> > -		flow_offload_fixup_tcp(&ct->proto.tcp);
> > -}
> > -
> > -static void flow_offload_fixup_ct(struct nf_conn *ct)
> > -{
> > -	flow_offload_fixup_ct_state(ct);
> > -	flow_offload_fixup_ct_timeout(ct);
> > -}
> > -
> >   static void flow_offload_route_release(struct flow_offload *flow)
> >   {
> >   	nft_flow_dst_release(flow, FLOW_OFFLOAD_DIR_ORIGINAL);
> > @@ -361,22 +350,14 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
> >   	rhashtable_remove_fast(&flow_table->rhashtable,
> >   			       &flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].node,
> >   			       nf_flow_offload_rhash_params);
> > -
> > -	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
> > -
> > -	if (nf_flow_has_expired(flow))
> > -		flow_offload_fixup_ct(flow->ct);
> > -	else
> > -		flow_offload_fixup_ct_timeout(flow->ct);
> > -
> >   	flow_offload_free(flow);
> >   }
> >   void flow_offload_teardown(struct flow_offload *flow)
> >   {
> > +	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
> >   	set_bit(NF_FLOW_TEARDOWN, &flow->flags);
> > -
> > -	flow_offload_fixup_ct_state(flow->ct);
> > +	flow_offload_fixup_ct(flow->ct);
> >   }
> >   EXPORT_SYMBOL_GPL(flow_offload_teardown);
> > @@ -466,7 +447,7 @@ static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
> >   	if (nf_flow_has_expired(flow) ||
> >   	    nf_ct_is_dying(flow->ct) ||
> >   	    nf_flow_has_stale_dst(flow))
> > -		set_bit(NF_FLOW_TEARDOWN, &flow->flags);
> > +		flow_offload_teardown(flow);
> >   	if (test_bit(NF_FLOW_TEARDOWN, &flow->flags)) {
> >   		if (test_bit(NF_FLOW_HW, &flow->flags)) {
> > diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
> > index 187b8cb9a510..6f0b07fe648d 100644
> > --- a/net/netfilter/nft_flow_offload.c
> > +++ b/net/netfilter/nft_flow_offload.c
> > @@ -298,7 +298,8 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
> >   	case IPPROTO_TCP:
> >   		tcph = skb_header_pointer(pkt->skb, nft_thoff(pkt),
> >   					  sizeof(_tcph), &_tcph);
> > -		if (unlikely(!tcph || tcph->fin || tcph->rst))
> > +		if (unlikely(!tcph || tcph->fin || tcph->rst ||
> > +			     !nf_conntrack_tcp_established(ct)))
> >   			goto out;
> >   		break;
> >   	case IPPROTO_UDP:

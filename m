Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52FC451FDD9
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 15:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235536AbiEINSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 09:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235384AbiEINSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 09:18:30 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2099.outbound.protection.outlook.com [40.107.22.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D85E41A491F;
        Mon,  9 May 2022 06:14:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LG2v9iztsHqjw8EDCPYufXRMbKq2I808YN9mdslFB5hxrkY+2n4CRfEdt33IgCuGRcbk0sGKpIgJJYdxaMVHxmJXiKFO621z6sO/nQMnig2bxKVXs7BaYriXOaF+UOdSMaLKDeXCXMhYMt+BmrLp6ntCcYyhgBr5h180UAeCm7DZOxdV5+Zx+EJOJAGeUMNtocwrLf1vzB16XGmeLSyw19qICeKaoDbXAJtKH2Ffdy85VANk+6dxX5TxnTB+j7t1q1kNpyK0Y9t5TAC7Yb6x0X1RM+HSaUjFRt8vYuou4RIGeqKjeJCTld6cR5hjj05sw3jlNNHF6gT+bTLfLwACqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XVbdgRvnjO+z/Cm3PGXYEE8jpHH1nRLwQ21nNS4SWD4=;
 b=bOovDBmu+r123JJXssxoks5B+bJCLd6yB8AvuCtHkgSnjqSy6XdjNza0JwHYc/v1SFlOe39qClA+SICC9XhAXh9UFVVFBHECJew53FVCL6XV3EoqZwKUbzYtX+on8o1BlnvtEWVlQSwaIAb661x7OaBkk5205H6db7owA+gC1J8juKdmnirvtgXMQ9f9pHKaD6zXwHhNF3Vmd1AS4OwXnX4K9pKMKCWYnkN1FSWBeXwc91ItWNySUQbvJjM93c90kVv/IrlUYkHASrjnkQsZezFGZaW+My0E6Z3+uWCW71ScLeS8pz7yFsUDyoWbtt96bry+eqkRYbGX0MUow/jRxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XVbdgRvnjO+z/Cm3PGXYEE8jpHH1nRLwQ21nNS4SWD4=;
 b=E6AWuM3eLBPaD8Y88ERtX7gR9gkpuMXM9Kk97PqB22zXp5CEPcFy6yyjIXm6gs7Ykdc0IhuuA33kr8L20M51GT/37ozSQAzYzSG9vC+HdcpK6P/INkXuJM9t0+wONNvEvEEkquS6oNNM8KxQTzVcRSYCHI/bGWdbK/rAS2MaLtM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from PA4PR05MB8996.eurprd05.prod.outlook.com (2603:10a6:102:2a7::10)
 by PR3PR05MB7513.eurprd05.prod.outlook.com (2603:10a6:102:8c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Mon, 9 May
 2022 13:14:21 +0000
Received: from PA4PR05MB8996.eurprd05.prod.outlook.com
 ([fe80::c4b9:8da4:3f97:a2c6]) by PA4PR05MB8996.eurprd05.prod.outlook.com
 ([fe80::c4b9:8da4:3f97:a2c6%5]) with mapi id 15.20.5186.021; Mon, 9 May 2022
 13:14:21 +0000
Date:   Mon, 9 May 2022 15:14:17 +0200
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     Oz Shlomo <ozsh@nvidia.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Felix Fietkau <nbd@nbd.name>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Paul Blakey <paulb@nvidia.com>
Subject: Re: [PATCH net] netfilter: nf_flow_table: fix teardown flow timeout
Message-ID: <20220509131417.oys2hgpkwhrittqi@SvensMacbookPro.hq.voleatech.com>
References: <20220509072916.18558-1-ozsh@nvidia.com>
 <20220509085149.ixdy3fbombutdpd7@SvensMacbookPro.hq.voleatech.com>
 <acba99bf-975d-54d8-01cf-938d2579f06e@nvidia.com>
 <20220509122749.yrxfzee4lzdpfkcc@SvensMacbookPro.hq.voleatech.com>
 <663024e0-ad0b-c940-903d-3f4a3a47ffd1@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <663024e0-ad0b-c940-903d-3f4a3a47ffd1@nvidia.com>
X-ClientProxiedBy: AM5PR0301CA0022.eurprd03.prod.outlook.com
 (2603:10a6:206:14::35) To PA4PR05MB8996.eurprd05.prod.outlook.com
 (2603:10a6:102:2a7::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6dc1668b-458e-4e59-8aa2-08da31bdd4c5
X-MS-TrafficTypeDiagnostic: PR3PR05MB7513:EE_
X-Microsoft-Antispam-PRVS: <PR3PR05MB751340060A3966A1E09D8CABEFC69@PR3PR05MB7513.eurprd05.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 29ixyK7edgAQOa+kxqYTRjiM43iLpfsTF9dKorWDWoqRC7HAWpUJIMXuB8Jr1PUZ2T/5vHOlEZhOQmuzF7Pa+d1GXyLI6s5sLjRC9REb3DcESZROunhNFXDUmuithAgqzQ1gdFfuS7mXe0BAoGgzQDvPjgB5jP1OGM6+nLi81lK+cD+ICCUjXGk/q2dw683FjTdq5MOkJFLNtvHLrXxid5r10/bNR4ZFuqEXKrvIrbyPWIrJ2pIKvRQub6b5fVn2/T4F6oXZOfK5m95OaVpYXdEHKRoNZt7nYlAxphkGLONLaurNVZBKTS/g0I99TrVYatbAbd5mZNs+GAngSRIjhy/76wDYc0eACNmXEavctiRXHfAQGgLlOOB9D3G9yfccf/PlxIxgCsVzvCCKzLMDAJSQWPjnZrbNVcNhKA+91VUYsd6jV5vM8x6huMgU0+I6JqSor7zy+8BOALiIW1tK+nHe/WynRZc4bIZ8t+hLb5O9faYvk1iwXcUS99mmrzEkBcuvNKBshmzcEpabo/NyIyjj4BWJtCCpeGBjOVj1R145+vOVjpYpW4w4ddh1lJ26v7/SOsRwo1VNqhd/ZzcJtUcmhGn/BsE4/4+xLTL7ejcNFuYEQdFR4RsuyBDINRhpGlTx6AlDp0wpdZTcKK3djA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR05MB8996.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(136003)(346002)(396003)(39830400003)(366004)(376002)(9686003)(4326008)(8676002)(44832011)(6512007)(26005)(2906002)(53546011)(6506007)(6666004)(8936002)(508600001)(6486002)(86362001)(5660300002)(66476007)(83380400001)(1076003)(54906003)(186003)(316002)(66556008)(6916009)(66946007)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JrtV0s7o+dYb5wGZXb+uSmtov/QE6qXWmEZClDj+jtvbRNUVyywsCqeBJ3s7?=
 =?us-ascii?Q?0m+zZfjjMJAiIZJxRMCQYOV5JOeLGoZ8qq/HBkuMsKzoEvjOHcTUhBEENlS4?=
 =?us-ascii?Q?kqhHaB9MZGyWfNB3/6qBtdjgpcCQJzQlq71EkCuRdeeXVH5pMsW/A0OF/Meq?=
 =?us-ascii?Q?G0RdPh9hbBf3DVlfSLjlshj2/Mad/bNfVxTPyKPVK6CTiYhOpAVcBt+tiICn?=
 =?us-ascii?Q?eAtonHRgRZnXbxBviXqvfBdrbdElFCrUv9HtFRCDAQWFiIjqjdx+YXZgta3L?=
 =?us-ascii?Q?gxcBe9qmENyAoaUVTL2s8MF6TrGtjMBrBoodtm6VAiXAWXr6HlNdBs6CMY1h?=
 =?us-ascii?Q?OpN/G1HaLR1xj/A3OOqTQj6mLwNoNHSZSjnYRSk+20GsuO+MFtX9KncmbRjR?=
 =?us-ascii?Q?6BmgvqWXyGe6IDcPDQXDWb3M1eaq1+m1cMOsozCqJCbfQqLlSWB00FmmGsly?=
 =?us-ascii?Q?efeZqC2hm7KuXm3hV1cw7F9zp4bKbcYucForqBCnWdKJlQcNMK3CcVw//Vsu?=
 =?us-ascii?Q?/MBMgDqKXD1wrHhVTGk3oWt9n6ywAKEnrgI95E9bw1LooTP1cDsUKhnn+U58?=
 =?us-ascii?Q?31Z3OEEU1nj3ufZSKQj77dY0rnmHgJmSDkONZh84d7tIMWSYTq7wYgWSJzLW?=
 =?us-ascii?Q?SAX/urNcF1SIGdn9OgqkYIbgeqnEt5aPqJPuRl4/nQ6SEGTBl02CrbcFadCr?=
 =?us-ascii?Q?SRo7tIq2RcFSnrV8pK6Uz1z1eHWjKpCBHjBPLz7AOJ5sxnewpsXkrHN3z+39?=
 =?us-ascii?Q?iqmZ5SDNvmeBLyXtUI6sBJR1guOaekAYVY/U0AVyVXJ8qOivvMO1hUWvknuw?=
 =?us-ascii?Q?SYSkNpT4mJeMFrf9KtTL/yIISD+VocxH9i+2WP/L77Dq2Jp6JcDEpE2TnLM7?=
 =?us-ascii?Q?LAIPDLrl/Mqfl2EtyMmOa+C63UCQunftdzn5uJb/7uiNPGlBa6pBx5/ChfZQ?=
 =?us-ascii?Q?u/BMjskWGb/4GgNM+9KNr68simkcmGu/S48tLcVVo9PYR9iTj2kJOSNw0Vfm?=
 =?us-ascii?Q?vzgXtkaJfnQT0F+jkPwKhwRDtootScDpqELjMaSyy9o8sFgcSd7tMQQVw9Bn?=
 =?us-ascii?Q?Kdw9Vila7M94iz4CeVlw863ED0JC2g5MvuC5a0r8cym2PjP802v9AF8oAAjp?=
 =?us-ascii?Q?dwWYPq064iHrJYFG8SrTvblsM61ZSVKXwAPQGFEPEK5CsOKm/Ivn2SuOtlkH?=
 =?us-ascii?Q?Xwk/mm5Xj5d/u7J5zq7qJFk4wFnJyniRajzr8MhWLIPKOTp+Wrgyfd/mL1O/?=
 =?us-ascii?Q?IjK4eljdwAPvGh76LhcH393T/Cde0aYFSfc2VArtslmCIc1eaMrid1k7pUWx?=
 =?us-ascii?Q?nduDZ+qsr3Rbq5ID/kcTrwtkUNldMYQESkRE+xHA+X/RNnADzSi88F40au0/?=
 =?us-ascii?Q?iiu2XcbW1UjhTbl2tBXdCsaIHN0K+9+cgA+3274CJtpPSfm0YhvmPZda2Hep?=
 =?us-ascii?Q?MT8HHUqz3fHbVYPbNhJ3dVzKoREgoDDjCShPxPXFgL8/vAvBzwPoXdGYHMVV?=
 =?us-ascii?Q?TTsmB3wtx6/W7DS2qjhfh/LyfKZsrwz8S2wu+CXMlMG8Bt8H9rbsTL3Z4h2Z?=
 =?us-ascii?Q?+CeqUfh11J7aUGl09NCM6e6hWwiVMa+Pt3EWDFZ/d47McAGerbn0YJRV3jhv?=
 =?us-ascii?Q?9NQlpttFws2/zZujUoujUevZSEkXqFt1FGrlvNFS6fYE/2Bp2clvZN7hda9p?=
 =?us-ascii?Q?ccTl2j8sIzAjnuDVCHypeatjMyDXMfUme42pgqU64529G+Q6yOzxahGOSfmQ?=
 =?us-ascii?Q?gsdGmV1w5i/acPI/cxElCQWTEzZNwDI=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dc1668b-458e-4e59-8aa2-08da31bdd4c5
X-MS-Exchange-CrossTenant-AuthSource: PA4PR05MB8996.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 13:14:21.6204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4z5Ehx5fU2gti6nHDLl0IME0wHydkJciuHF8fxBiVpZLaL0/hnwQi4iUlfbNxA4+0gB9nVsYXHL/JsjOgCexSsAmXfZFWmd5RGRD4UDsqO8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR05MB7513
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Oz,

On Mon, May 09, 2022 at 04:01:37PM +0300, Oz Shlomo wrote:
> Hi Sven,
> 
> On 5/9/2022 3:27 PM, Sven Auhagen wrote:
> > On Mon, May 09, 2022 at 03:18:42PM +0300, Oz Shlomo wrote:
> > Hi Oz,
> > 
> > > Hi Sven,
> > > 
> > > On 5/9/2022 11:51 AM, Sven Auhagen wrote:
> > > > Hi Oz,
> > > > 
> > > > thank you, this patch fixes the race between ct gc and flowtable teardown.
> > > > There is another big problem though in the code currently and I will send a patch
> > > > in a minute.
> > > > 
> > > > The flowtable teardown code always forces the ct state back to established
> > > > and adds the established timeout to it even if it is in CLOSE or FIN WAIT
> > > > which ultimately leads to a huge number of dead states in established state.
> > > 
> > > The system's design assumes that connections are added to nf flowtable when
> > > they are in established state and are removed when they are about to leave
> > > the established state.
> > > It is the front-end's responsibility to enforce this behavior.
> > > Currently nf flowtable is used by nft and tc act_ct.
> > > 
> > > act_ct removes the connection from nf flowtable when a fin/rst packet is
> > > received. So the connection is still in established state when it is removed
> > > from nf flow table (see tcf_ct_flow_table_lookup).
> > > act_ct then calls nf_conntrack_in (for the same packet) which will
> > > transition the connection to close/fin_wait state .
> > > 
> > > I am less familiar with nft internals.
> > > 
> > 
> > It is added when the ct state is established but not the TCP state.
> > Sorry, I was probably a little unclear about what is ct and what is TCP.
> > 
> > The TCP 3 way handshake is basically stopped after the second packet
> > because this will create the flow table entry.
> > The 3rd packet ACK is not seen by nftables anymore but passes through
> > the flowtable already which leaves the TCP state in SYN_RECV.
> > 
> > The flowtable is passing TCP FIN/RST up to nftables/slowpath for
> > processing while the flowtable entry is still active.
> > The TCP FIN will move the TCP state from SYN_RECV to FIN_WAIT and
> > also at some point the gc triggers the flowtable teardown.
> 
> So perhaps TCP FIN packets processing should first call
> flow_offload_teardown and then process the packet through the slow path.
> This will ensure that the flowtable entry is invalidated when the connection
> is still in established state (similar to what act_ct is doing).
> 

It does so at this point but it will again be set to established during flowtable delete.
If you clear the IPS_OFFLOAD_BIT in the flow_offload_teardown, as your patch does,
you will create a race condition between ct gc and flow_offload_del which will
now access ct data which have been deallocated by ct gc and will lead to
memory corruption.
So your patch will not fix the problem correctly and leads to more issues.

My patch moves all the work to flow_offload_del since this is the last step
taken before a flowtable flow is deallocated and therefore a ct state must be
safe to access. Only after the function has run all its code, the
IPS_OFFLOAD_BIT can safely be cleared.

There are more problems, if the flowtable can not process a packet for any
reason, it will push it up to nftables/slowpath.
So we might miss the FIN in the flowtable code and this might also
change the TCP state.
Therefore the TCP state must be set to ESTABLISHED somewhere in the
flowtable code so we can be sure that it has changed at
flow_offload_del or it is still established.

There is no way of resolving this on the nftable side only.

Best
Sven

> > The flowtable teardown then sets the TCP state back to ESTABLISHED
> > and puts the long ESTABLISHED timeout into the TCP state even though
> > the TCP connection is closed.
> > 
> > My patch basically also incorporates your change by adding the clearing
> > of the offload bit to the end of the teardown processing.
> > The problem in general though is that the teardown has no check or
> > assumption about what the current status of the TCP connection is.
> > It just sets it to established.
> > 
> 
> AFAIU your patch clears the bit at flow_offload_del.
> If so, then it can still race as flow_offload_del is called by the flowtable
> gc thread while the flow is deleted by flow_offload_teardown on the dp
> thread.
> 
> > I hope that it explains it in a better way.
> > 
> > Best
> > Sven
> > 
> > > > 
> > > > I will CC you on the patch, where I also stumbled upon your issue.
> > > 
> > > I reviewed the patch but I did not understand how it addresses the issue
> > > that is fixed here.
> > > 
> > > The issue here is that IPS_OFFLOAD_BIT remains set when teardown is called
> > > and the connection transitions to close/fin_wait state.
> > > That can potentially race with the nf gc which assumes that the connection
> > > is owned by nf flowtable and sets a one day timeout.
> > > 
> > > > 
> > > > Best
> > > > Sven
> > > > 
> > > > On Mon, May 09, 2022 at 10:29:16AM +0300, Oz Shlomo wrote:
> > > > > Connections leaving the established state (due to RST / FIN TCP packets)
> > > > > set the flow table teardown flag. The packet path continues to set lower
> > > > > timeout value as per the new TCP state but the offload flag remains set.
> > > > > Hence, the conntrack garbage collector may race to undo the timeout
> > > > > adjustment of the packet path, leaving the conntrack entry in place with
> > > > > the internal offload timeout (one day).
> > > > > 
> > > > > Return the connection's ownership to conntrack upon teardown by clearing
> > > > > the offload flag and fixing the established timeout value. The flow table
> > > > > GC thread will asynchonrnously free the flow table and hardware offload
> > > > > entries.
> > > > > 
> > > > > Fixes: 1e5b2471bcc4 ("netfilter: nf_flow_table: teardown flow timeout race")
> > > > > Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
> > > > > Reviewed-by: Paul Blakey <paulb@nvidia.com>
> > > > > ---
> > > > >    net/netfilter/nf_flow_table_core.c | 3 +++
> > > > >    1 file changed, 3 insertions(+)
> > > > > 
> > > > > diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> > > > > index 3db256da919b..ef080dbd4fd0 100644
> > > > > --- a/net/netfilter/nf_flow_table_core.c
> > > > > +++ b/net/netfilter/nf_flow_table_core.c
> > > > > @@ -375,6 +375,9 @@ void flow_offload_teardown(struct flow_offload *flow)
> > > > >    	set_bit(NF_FLOW_TEARDOWN, &flow->flags);
> > > > >    	flow_offload_fixup_ct_state(flow->ct);
> > > > > +	flow_offload_fixup_ct_timeout(flow->ct);
> > > > > +
> > > > > +	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
> > > > >    }
> > > > >    EXPORT_SYMBOL_GPL(flow_offload_teardown);
> > > > > -- 
> > > > > 1.8.3.1
> > > > > 

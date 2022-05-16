Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87EFE5282FE
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 13:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242964AbiEPLSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 07:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiEPLS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 07:18:29 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00123.outbound.protection.outlook.com [40.107.0.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E8F433EAC;
        Mon, 16 May 2022 04:18:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZY5csxIu7J5r5FTr2QXO/ucRi2YyMsCfMF9Kua2veaA2tVtY/asoNXvUYB6x/CRM3vi/0vSoNBenRRarmaW7/1iSFiBI7hAKVCAMNn1EPwLdi42tMdc2SxdUBxC8ooiUgi6AXe4cQvz/5j+S4D33wEW/AEd+f/72/Qq+gja65E8PBCzffqNBjCJLHagnNJMV+9ScNs71vbzheGnZ/SPJ5a8WCp1vMVehI3RNNzsE8MBwHpULxO+jZnkBi+DETwveOQL3X3RhB0jXHfTS6fUUkd4Evb6Iyt4LdSdHuYVuXi6ozyW8ABr0+0kBEqwp6Zvk6Gtw8vRFmAcMYKsq6zr+3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lDnFddkzRSttJsaAMBeXbVFWVCo+1IsNF85lR9ARusU=;
 b=mDg6BKuvjv4IXJE+sWjYS1STl1Tc+k+7FVGLPFIQbtO0pvPiHlkAQK6d2uQfv8j8nqX/lOInJXXYvwnXTXo7bZbqIVkeNj/85otdf+9rgo+w7w4Zmvvocaw7Rq3DPOhpvSlRCvsSzXwBKNxb974P5tEt/3TUEi+OD1WlF73yz8QKc08qNXLoux51RXJkfHJd8fhkZj0H+0bYvVlph4ZGXzpxUpr1JiPaHHgn6Iq0+hRM1lz7obB0WaNN21V9mVKPm8Cb9UupLrosla3FegcYM8S7rv/Ke1lHRN0ciI6bw7bP6mCUqQlUBpxtrPzVBIjE6rBMsHyR3TATvPBG8TMfBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lDnFddkzRSttJsaAMBeXbVFWVCo+1IsNF85lR9ARusU=;
 b=E/NUz/OHK71QBamakH5swL+cQoJiASx+JjQnTmZ3jpY1HY2WdhnpffpBZWsW1TnLIknwYC39rP9DmaVgj0MeMIcnqgQMIQXO0wgGZHKfiIJaFJ2BJQibYkA1LmMRw5VTzhfIKaWPHszfB4wiWaw+yaPbPeq5uZT2tNQpVHpMUW4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from PA4PR05MB8996.eurprd05.prod.outlook.com (2603:10a6:102:2a7::10)
 by PAXPR05MB8494.eurprd05.prod.outlook.com (2603:10a6:102:1a1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Mon, 16 May
 2022 11:18:25 +0000
Received: from PA4PR05MB8996.eurprd05.prod.outlook.com
 ([fe80::b1f3:359c:a4dd:2594]) by PA4PR05MB8996.eurprd05.prod.outlook.com
 ([fe80::b1f3:359c:a4dd:2594%7]) with mapi id 15.20.5250.018; Mon, 16 May 2022
 11:18:25 +0000
Date:   Mon, 16 May 2022 13:18:17 +0200
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Oz Shlomo <ozsh@nvidia.com>, Felix Fietkau <nbd@nbd.name>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>, Paul Blakey <paulb@nvidia.com>
Subject: Re: [PATCH net v2] netfilter: nf_flow_table: fix teardown flow
 timeout
Message-ID: <20220516111817.2jic2qnij2dvkp5i@Svens-MacBookPro.local>
References: <20220512182803.6353-1-ozsh@nvidia.com>
 <YoIt5rHw4Xwl1zgY@salvia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoIt5rHw4Xwl1zgY@salvia>
X-ClientProxiedBy: AS9PR06CA0412.eurprd06.prod.outlook.com
 (2603:10a6:20b:461::6) To PA4PR05MB8996.eurprd05.prod.outlook.com
 (2603:10a6:102:2a7::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4be0612f-a261-4665-7e9b-08da372dcb56
X-MS-TrafficTypeDiagnostic: PAXPR05MB8494:EE_
X-Microsoft-Antispam-PRVS: <PAXPR05MB8494E3D0E2408A18199DB74EEFCF9@PAXPR05MB8494.eurprd05.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BAqfS/TUCdnO/pPQ8OSGauy4ve5wjsXxolYYFlitJE1srW8r0TsJ1e+4R6ljqEHcWiU9wHacng58bAawCckjVUJ3+rD4qJB0MkPvxmd41oU6fbiIG6QbWmIv4a68em4a45o6IlEuwdWT6zVyV/WJyHeWaJFVVmAWb4kRJzEjFekxWwIFqtre1V/1gy/iZuYWHtjhy7ElyPeUY+BkKM6qpUyK2x73XHx3L/i71Ylh4Tcxlx1ZzE7JW1KQKaWd78U//9arAHD3Vw4CPWbMDfds/tlC5de5lfFdc1JDKeEQUzeNh8oDfA0LYA0LnyUykD+oSv/5ZkFmkCU++TjprLn/WDADSlU7XaWFczo1iCU1RnE6fMRb8Hawea9gK1y6Ix9ERBmVRFAWOKTg9nGcpGmEURVY/8p0scMsouGfvlQHpsBwbZ7Mk+IiKlSEX4wAbdpWHCCKuHoujPfz7sTleJNT/oGaUcfr/tk9mYHww2iyhOqhQ0TA7SUT21+iDKkQAVWQNLeE3w2wMVZUGQvfmYaak3PYNuEr9I2sEcsqMC1LGYWHbUHFP4E4pxu71iwa8pr9pMLJS8dW27109KAlQRXIXPSRrRfMp9oXdJc5AdxmuJ+QyuSM4si/0JdyuU5I88DmT5QsVLbYlNCBqzv469tZUg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR05MB8996.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(39830400003)(366004)(396003)(346002)(376002)(136003)(5660300002)(6506007)(2906002)(44832011)(316002)(186003)(1076003)(83380400001)(6916009)(6666004)(9686003)(6512007)(66476007)(66946007)(66556008)(508600001)(8936002)(6486002)(41300700001)(4326008)(54906003)(8676002)(38100700002)(86362001)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ErT8x7ZHs21BNEFd1FF9cRySF8z1s0D2UQOPLRUszQa+zWdEu0/3O6r4ASYA?=
 =?us-ascii?Q?PUgEqwiCfCXorzIuDno9+WlmQn5aeZnwOcZMVp/VYjDUIRIApBBUbTZcTcx9?=
 =?us-ascii?Q?hFnbArisMa/H2s/2rfh0OEqUAkD9pLQRUc7GhpxrogZOVNp1wThV7fF6xQBq?=
 =?us-ascii?Q?TY1b5n2nYhbLot8KZQBSRM856OGI80KxCj48lFjoHkr/vkjy1Y7zZ0iGj9K4?=
 =?us-ascii?Q?QGaj809FA48mq9EN1Z4xEAmMrz42wh6mQPxVJ64QmeiqBDWyuM37J3yp7Las?=
 =?us-ascii?Q?qgNXLCxB27fM5m4Wa0t7jCioO+J+70o48UGp8CgaTI6X7Vc/xqq3q6ugg4lc?=
 =?us-ascii?Q?0knPGoXbWbs7vbUeI5QmF3MsO2703cv+8aPbf/VlLBZlKtxnxogohXEnpWzz?=
 =?us-ascii?Q?5fAoMEGfY2wCCGf29Bde8D95XsyqAVUUBs8AV1IZ+iqNgrKdlQPIPbpvX6Td?=
 =?us-ascii?Q?FFYCu1YXwHmqJTV2cvmg/BaGN0LbnDD4oXL12P++nxoPMgB+zDZH9GKoEqCM?=
 =?us-ascii?Q?aQwQIudAB7iGv2lGxbwf7BlgoB7JRZH2zb9tXSEMSI4YylIc6QFwGk8YDbws?=
 =?us-ascii?Q?M4lWb7LQjA7uskr7n+j0AxFHA6WqZK/WERzs1pldgZWa0tywoNpKHPd4LitI?=
 =?us-ascii?Q?jtrce96JeNNRfwNEZZz5p7UO0+/nWaDni+zEF21/Q3bDIRoj+e0vDJGiCkQa?=
 =?us-ascii?Q?8eiBLBkBVXrdAXzGWGXghAgCzSsKpFGJj3JtPtSB0/PLADtPf/of1Cgmm9wH?=
 =?us-ascii?Q?GG5Ngtv++Wo8X0BYf8luBYdE4hfHzTbKNAPgBKACpVdABWoGBuJRa/QpbtIn?=
 =?us-ascii?Q?bG3N8HLH4fL2jPS1vX7RfLvI6lO84OrDFrykbHdiBXVS6Ne69f7XOx8u8/sB?=
 =?us-ascii?Q?9ONOGmiausA/sm87sKAu+jgIPy36UuZb4EDQG9L85S+Th1OcD2sqpFra1fSx?=
 =?us-ascii?Q?Oyy2C+2g7/X+l0D0lTP6CQQ1h4FqILpS7smGcsUfzpU0vlHqO6vGxZXJV6jv?=
 =?us-ascii?Q?Q8JCiUy2Lls46c/AVP11HdBjI9OBHTfRwJtL8HKH4gSXFbWI/5ixmwQjaLYy?=
 =?us-ascii?Q?vWbOyXB64I7NU/y/KGmo0fm6xha36C4ZDuBR4h3zJd0EfIvE/+FPhFRs5KJd?=
 =?us-ascii?Q?j1XwepvNMG8gmoQNrRKtr5uayvT73NdIVOw1iykGHkYLHhhAWLyd4Y40lSQB?=
 =?us-ascii?Q?CPRufisyNbRFuPKapvizqWXJg52gUIJ9eMFPCVuzwEKT0DEO2XDyVrPVzjo+?=
 =?us-ascii?Q?VZKWJfqCxIn6gsvqBE2suNH1lcaBGVF/hMpPrbcBzrQCgqpDgFW5Unnjp5cG?=
 =?us-ascii?Q?wqnntfZ4ll2bkq4f05+lv0NtCXwLZXO8nwjHPmcaIMmXsUggbufoc5PqrQrB?=
 =?us-ascii?Q?51UrCv8vkTs7pbkRIebwMRTioqK0BuKZZCkngOzfxomhQiEKbWz1oJOQvXBM?=
 =?us-ascii?Q?sFdKT+cyP18bH2FYHkmakX+EXJIkOzjPfT98e+8MwJXCPjjTvIJieccFlatt?=
 =?us-ascii?Q?VLK91hF+aMxpxddPXMUVQp/LGzlCICeIkodNwK4bAOIyjFgqucq3HyOdEZxl?=
 =?us-ascii?Q?CAVzxXtETFpKNc4kwEiyawkAlEkHdnvcutebwxhyyVKkeovE5aYyGPzYJJYB?=
 =?us-ascii?Q?IwqUulAkDwjWDxCQmC92Zp5mS+/GwVe6sVdElV8HTatCZ7VWdvdm6nrTPL0K?=
 =?us-ascii?Q?KICsYZKrThYKLErO5UQhSUPYhSjkmNaOSkaAamb4YCt9pLfKbG3Yxa2nqKt0?=
 =?us-ascii?Q?EJOY2sXZZcBfAhLrnNA3p0/h80o79Ls=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 4be0612f-a261-4665-7e9b-08da372dcb56
X-MS-Exchange-CrossTenant-AuthSource: PA4PR05MB8996.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2022 11:18:25.3032
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KuIC7Ny8esAf0axPW0hGJMCOq9koJveP8ObRmKvTdl2FxaCmLkrxKzKZb1JL/RCZ/Lnjbu0mijJuKlxr+iUXOPwx7m21lRMURhfCOp9o3u8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR05MB8494
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 16, 2022 at 12:56:38PM +0200, Pablo Neira Ayuso wrote:
> On Thu, May 12, 2022 at 09:28:03PM +0300, Oz Shlomo wrote:
> > Connections leaving the established state (due to RST / FIN TCP packets)
> > set the flow table teardown flag. The packet path continues to set lower
> > timeout value as per the new TCP state but the offload flag remains set.
> >
> > Hence, the conntrack garbage collector may race to undo the timeout
> > adjustment of the packet path, leaving the conntrack entry in place with
> > the internal offload timeout (one day).
> >
> > Avoid ct gc timeout overwrite by flagging teared down flowtable
> > connections.
> >
> > On the nftables side we only need to allow established TCP connections to
> > create a flow offload entry. Since we can not guaruantee that
> > flow_offload_teardown is called by a TCP FIN packet we also need to make
> > sure that flow_offload_fixup_ct is also called in flow_offload_del
> > and only fixes up established TCP connections.
> [...]
> > diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> > index 0164e5f522e8..324fdb62c08b 100644
> > --- a/net/netfilter/nf_conntrack_core.c
> > +++ b/net/netfilter/nf_conntrack_core.c
> > @@ -1477,7 +1477,8 @@ static void gc_worker(struct work_struct *work)
> >  			tmp = nf_ct_tuplehash_to_ctrack(h);
> >  
> >  			if (test_bit(IPS_OFFLOAD_BIT, &tmp->status)) {
> > -				nf_ct_offload_timeout(tmp);
> 
> Hm, it is the trick to avoid checking for IPS_OFFLOAD from the packet
> path that triggers the race, ie. nf_ct_is_expired()
> 
> The flowtable ct fixup races with conntrack gc collector.
> 
> Clearing IPS_OFFLOAD might result in offloading the entry again for
> the closing packets.
> 
> Probably clear IPS_OFFLOAD from teardown, and skip offload if flow is
> in a TCP state that represent closure?
> 
>   		if (unlikely(!tcph || tcph->fin || tcph->rst))
>   			goto out;
> 
> this is already the intention in the existing code.
> 
> If this does work, could you keep IPS_OFFLOAD_TEARDOWN_BIT internal,
> ie. no in uapi? Define it at include/net/netfilter/nf_conntrack.h and
> add a comment regarding this to avoid an overlap in the future.
> 
> > +				if (!test_bit(IPS_OFFLOAD_TEARDOWN_BIT, &tmp->status))
> > +					nf_ct_offload_timeout(tmp);
> >  				continue;
> >  			}
> >  
> > diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> > index 3db256da919b..aaed1a244013 100644
> > --- a/net/netfilter/nf_flow_table_core.c
> > +++ b/net/netfilter/nf_flow_table_core.c
> > @@ -177,14 +177,8 @@ int flow_offload_route_init(struct flow_offload *flow,
> >  }
> >  EXPORT_SYMBOL_GPL(flow_offload_route_init);
> >  
> > -static void flow_offload_fixup_tcp(struct ip_ct_tcp *tcp)
> > -{
> > -	tcp->state = TCP_CONNTRACK_ESTABLISHED;
> > -	tcp->seen[0].td_maxwin = 0;
> > -	tcp->seen[1].td_maxwin = 0;
> > -}
> >  
> > -static void flow_offload_fixup_ct_timeout(struct nf_conn *ct)
> > +static void flow_offload_fixup_ct(struct nf_conn *ct)
> >  {
> >  	struct net *net = nf_ct_net(ct);
> >  	int l4num = nf_ct_protonum(ct);
> > @@ -192,8 +186,12 @@ static void flow_offload_fixup_ct_timeout(struct nf_conn *ct)
> >  
> >  	if (l4num == IPPROTO_TCP) {
> >  		struct nf_tcp_net *tn = nf_tcp_pernet(net);
> > +		struct ip_ct_tcp *tcp = &ct->proto.tcp;
> > +
> > +		tcp->seen[0].td_maxwin = 0;
> > +		tcp->seen[1].td_maxwin = 0;
> >  
> > -		timeout = tn->timeouts[TCP_CONNTRACK_ESTABLISHED];
> > +		timeout = tn->timeouts[ct->proto.tcp.state];
> >  		timeout -= tn->offload_timeout;
> >  	} else if (l4num == IPPROTO_UDP) {
> >  		struct nf_udp_net *tn = nf_udp_pernet(net);
> > @@ -211,18 +209,6 @@ static void flow_offload_fixup_ct_timeout(struct nf_conn *ct)
> >  		WRITE_ONCE(ct->timeout, nfct_time_stamp + timeout);
> >  }
> >  
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
> >  static void flow_offload_route_release(struct flow_offload *flow)
> >  {
> >  	nft_flow_dst_release(flow, FLOW_OFFLOAD_DIR_ORIGINAL);
> > @@ -353,6 +339,10 @@ static inline bool nf_flow_has_expired(const struct flow_offload *flow)
> >  static void flow_offload_del(struct nf_flowtable *flow_table,
> >  			     struct flow_offload *flow)
> >  {
> > +	struct nf_conn *ct = flow->ct;
> > +
> > +	set_bit(IPS_OFFLOAD_TEARDOWN_BIT, &flow->ct->status);
> > +
> >  	rhashtable_remove_fast(&flow_table->rhashtable,
> >  			       &flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].node,
> >  			       nf_flow_offload_rhash_params);
> > @@ -360,12 +350,11 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
> >  			       &flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].node,
> >  			       nf_flow_offload_rhash_params);
> >  
> > -	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
> > -
> >  	if (nf_flow_has_expired(flow))
> > -		flow_offload_fixup_ct(flow->ct);
> > -	else
> > -		flow_offload_fixup_ct_timeout(flow->ct);
> > +		flow_offload_fixup_ct(ct);
> 
> Very unlikely, but race might still happen between fixup and
> clear IPS_OFFLOAD_BIT with gc below?
> 
> Without checking from the packet path, the conntrack gc might race to
> refresh the timeout, I don't see a 100% race free solution.
> 
> Probably update the nf_ct_offload_timeout to a shorter value than a
> day would mitigate this issue too.

This section of the code is now protected by IPS_OFFLOAD_TEARDOWN_BIT
which will prevent the update via nf_ct_offload_timeout.
We set it at the beginning of flow_offload_del and flow_offload_teardown.

Since flow_offload_teardown is only called on TCP packets
we also need to set it at flow_offload_del to prevent the race.

This should prevent the race at this point.

> 
> > +	clear_bit(IPS_OFFLOAD_BIT, &ct->status);
> > +	clear_bit(IPS_OFFLOAD_TEARDOWN_BIT, &ct->status);
> >  
> >  	flow_offload_free(flow);
> >  }
> > @@ -373,8 +362,9 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
> >  void flow_offload_teardown(struct flow_offload *flow)
> >  {
> >  	set_bit(NF_FLOW_TEARDOWN, &flow->flags);
> > +	set_bit(IPS_OFFLOAD_TEARDOWN_BIT, &flow->ct->status);
> >  
> > -	flow_offload_fixup_ct_state(flow->ct);
> > +	flow_offload_fixup_ct(flow->ct);
> >  }
> >  EXPORT_SYMBOL_GPL(flow_offload_teardown);
> >  
> > diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
> > index 900d48c810a1..9cc3ea08eb3a 100644
> > --- a/net/netfilter/nft_flow_offload.c
> > +++ b/net/netfilter/nft_flow_offload.c
> > @@ -295,6 +295,8 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
> >  					  sizeof(_tcph), &_tcph);
> >  		if (unlikely(!tcph || tcph->fin || tcph->rst))
> >  			goto out;
> > +		if (unlikely(!nf_conntrack_tcp_established(ct)))
> > +			goto out;
> 
> This chunk is not required, from ruleset users can do
> 
>         ... ct status assured ...
> 
> instead.

Maybe this should be mentioned in the manual or wiki if
it is not necessary in the flow offload code.

> 
> >  		break;
> >  	case IPPROTO_UDP:
> >  		break;
> > -- 
> > 1.8.3.1
> > 

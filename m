Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1923B5283FB
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 14:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240563AbiEPMRL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 08:17:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiEPMRK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 08:17:10 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2095.outbound.protection.outlook.com [40.107.20.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A47C82BB20;
        Mon, 16 May 2022 05:17:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FpteFF0ipqwk62pn0b9BdtxXHLybGmPHEu9D3vrwlBKtgrlNd5VfpbVn6NQWfCHtjqZFlmSF4lE0KicrCeyFFkipZXI6X2VZX0bVmFuOZhvmloWR8fAapNp6PJ3HWzsLAQu4wYpWeBkBW9cI4livb1l9hWEMsREidMDZoAlNyz7Cq6RV+JnQX7dnKCuMnEiGR/TVHECBkE3oJkfKcV97/vejcgzsZt5OdNTYs7pUL3RAKqhgk95RmpO3kTq3CKF+J9pbZl3QWORqvz5mTD2bcnztDktHyH7k4fAIINwdLABCExAdmJ83i2hCD3+nHT7a+d6UoTTDUddX+M+yG6Yr9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kthyUfzbO5i39Vvmq+VTbK88b5uT2+SIdtv7gB88FfU=;
 b=CQSG0xlYHyqizLvWHG32CzV4VDx+hT3YQXAg7p0IRAoTL6DdMCStL3suvbQ8uWlnKHS1U06zYav5BALUPl7NO7XLR4opofYGlRAHUKDJfw90Rgco/4vDtaA3a0E16EQS5S5Bqx8l8qpYnWt+OShEthky7itIf65Bnu51oBcCTbmkr0QgvcRFLoVfvY1BV9PxnUc59/qccjtPR/XAQkYLC2xEmMHPntagnE3p31kbxiCyoGblf2Fk5JnXm1Epv4bxaXVHOgO7I469B2lNm6LsL55RAzS0PTjo9LKz2cUPLz9LQmScqn90pVEqEvz9ZBXw1pxweqAa1cy1PhJZ0HhisA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kthyUfzbO5i39Vvmq+VTbK88b5uT2+SIdtv7gB88FfU=;
 b=S/R/QlcUHhyLI9dznr6jpNLFktC2m2UPDGxFjtpetGrZnpPnbV2pl15TpqGFH1+IvqSWowSkyL/OjcjGOUN765t8tx5B/p0jRhpMMREq85MI1LJIBRDf9yTV8cZRGUFbXO888cTG/SO5PsJ9mSrSDueKbrAAxMUc1bj1pSsY/TI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from PA4PR05MB8996.eurprd05.prod.outlook.com (2603:10a6:102:2a7::10)
 by AM9PR05MB8767.eurprd05.prod.outlook.com (2603:10a6:20b:41c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Mon, 16 May
 2022 12:17:05 +0000
Received: from PA4PR05MB8996.eurprd05.prod.outlook.com
 ([fe80::b1f3:359c:a4dd:2594]) by PA4PR05MB8996.eurprd05.prod.outlook.com
 ([fe80::b1f3:359c:a4dd:2594%7]) with mapi id 15.20.5250.018; Mon, 16 May 2022
 12:17:05 +0000
Date:   Mon, 16 May 2022 14:17:00 +0200
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Oz Shlomo <ozsh@nvidia.com>, Felix Fietkau <nbd@nbd.name>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>, Paul Blakey <paulb@nvidia.com>
Subject: Re: [PATCH net v2] netfilter: nf_flow_table: fix teardown flow
 timeout
Message-ID: <20220516121700.ug2fwqyqgsd3rmsz@SvensMacbookPro.hq.voleatech.com>
References: <20220512182803.6353-1-ozsh@nvidia.com>
 <YoIt5rHw4Xwl1zgY@salvia>
 <20220516111817.2jic2qnij2dvkp5i@Svens-MacBookPro.local>
 <YoI3gliaYc250Vnb@salvia>
 <YoI+RGnrHbTJJqxB@salvia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoI+RGnrHbTJJqxB@salvia>
X-ClientProxiedBy: AS8PR04CA0208.eurprd04.prod.outlook.com
 (2603:10a6:20b:2f3::33) To PA4PR05MB8996.eurprd05.prod.outlook.com
 (2603:10a6:102:2a7::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d96a3d9b-0013-4d19-bdd2-08da3735fd76
X-MS-TrafficTypeDiagnostic: AM9PR05MB8767:EE_
X-Microsoft-Antispam-PRVS: <AM9PR05MB8767C557AC1104F96F59B775EFCF9@AM9PR05MB8767.eurprd05.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gT5SWpJOSkIX8i/4bSb4mGk42oXiQ/9EOZ1v3PQ7XdHhOYfbR9HCSOsosnX6FWZvx4YFl4o7H98gC1pbxNQrGWkNEv1RVeCFfjsOHjvNBo8pFW+QCZUHYimt+1iWFpSJztx5WZjF+A0PuPRwV/bocsXcau+bbrpAFX/Y+G9p8tKjfkNxgDkk2EhELCFw3s3nOle4JCQ2ieQokmp5xR1VEO11XwEvSYFz3hHsurKPtc8VS7Ueu3yILEXnu7U8qUNH5iplTVVvdGAPIF85HHyDQa4Ut3yc2BdLqUN8Pd92pokSEp+ItALS4F23ha9uXhNR1zho1eGgCuYbwuNapsVcUlwDPy6fWshTQ22t4tXpeHEWWu0mTVuczQ+jIfV52YRMsgzLklFBsfIUU0Mm9dOhqA2MACeU+0nrx9AbWPxYiGHxRbh7u6EszZFXGs+bYZEPIQyNlhUxcTVRpM82j2g9FRU+A0CDlzpEJQicjkB32idrAc8xGs+O1zgaW2pM2KKCvv/oOquVAaxG+UNF8OweGoo6f4fplOXZr95Uh+fKnchjh8GSWC+OTtJ3XK5HZat/51U1JvnR5Uat07aOqAkl06VTa1EQ0an6xbZpaifGrU0UGoPnaQDVpPx689IrCl+Qp/MwWGkeA7OA2SAbgCyBM+EVnMHlITuFXGAmlbXnw+JsJdQmG6UU8nLCTZiBfx7I4yPtlODCDkWFEJPsaaGhNg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR05MB8996.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(346002)(366004)(136003)(396003)(39830400003)(376002)(6506007)(186003)(316002)(2906002)(508600001)(54906003)(6916009)(6486002)(26005)(6512007)(9686003)(44832011)(1076003)(38100700002)(6666004)(66946007)(8676002)(4326008)(66556008)(66476007)(5660300002)(8936002)(83380400001)(41300700001)(86362001)(557034005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?j/7y4FzsqNhNNRx+17OyHJf8EK9HAinYOwTK1wefsLzAlr0e+i2zw4AW/Vxq?=
 =?us-ascii?Q?JHPSR9SjxGDSyKib0Sq2WwaFkeQZ9+zmMcPbLTPg6qtIAE8bQAxYbqMwcUf8?=
 =?us-ascii?Q?5Hm+fmj/siilMUHSuvY7d8nj4zAKBKSSY6wErv6A/OAM60ntymdPl4WlM9c7?=
 =?us-ascii?Q?YE1vIP+aLnBlcRELivZybV0CrB06COUW/aGoepW0QjC3/HSwLELdAx2Wcrw5?=
 =?us-ascii?Q?qzvXUIXuZ+b9n1BXQwUCZkDH4d3mvcHgQRMY+50KqqPLWSEDZ2qlmNQ7a056?=
 =?us-ascii?Q?pxG98y81yJ8LQ6e7lUAvuDodt7AfAu2VNu9eHTftj9onpg0JfDcl8rJsvwtu?=
 =?us-ascii?Q?9zCdWkIwvvoFJNuPJq4lYDaiIMOs9MQXF5vIYc1YF2J3rqBCwoeZMxclZquM?=
 =?us-ascii?Q?L5R143m0RsO08XissIbTW5yGo74QuWdGwVdBNENMlPxCegKZq6Ey99EwsX2v?=
 =?us-ascii?Q?NCqoCZjurfX9tTZk6EFVYqWx+oJrdv1XdXQk/0E3Xv+SmakUI+B3dzb+Ur8+?=
 =?us-ascii?Q?PcC7prr8n9rPWfJvlmKhwiUdHWrlkqhFZn3n31PzBofF9Bj2FNdstqzX7LCl?=
 =?us-ascii?Q?EK5Qm+9mConhdlSh/klgafSgFBQBTfVEkXxDr6dJgcyy+oVIU8ljO9NkmSLq?=
 =?us-ascii?Q?2Rjojs7q6QCO+tM5oJT7sZUIIleLr4+/fbHmfIbazjXmB/J6CiHFI+x0adBv?=
 =?us-ascii?Q?FBRb1dRB2G4lbYB3xe2UYb9M5gj3h1qBkCCBQdwl5Tq+ZYxTxMM1vPsZZYIo?=
 =?us-ascii?Q?ksKjFC7EHjGHaYOFpFCdZDnml7qL1jscJuyEDdvyqp4eLX+vYYqsSow5VMg3?=
 =?us-ascii?Q?iZLpu1mqwAtfZIoINDQCotnUiruDV4cvadnIDrB5moQzKEwkMtdzPL3S+JPZ?=
 =?us-ascii?Q?pA08MblYDNapKzK4jAt02/AVBTFSrBXMbPZY9Ri60JMApxzY/lA+rTT3k/Dm?=
 =?us-ascii?Q?VmxQTwuNodkl64afysTuzKY0+tNXRtLIGEvDwRwaBNZDDZykUpLSa8PsLoHa?=
 =?us-ascii?Q?Te/KSze0S1FI03+qgGma2/BbeSahXVDHxbNrGZniG9BPHDtbHBXlUQ9Ozlx8?=
 =?us-ascii?Q?AaOGMbtcjZRVQb8Zd6BrPi1MpN56dCZH5Wc8jXnHc2ijzXP1Csbxoc+r99eW?=
 =?us-ascii?Q?ofrawmP/PnBBFNDDxYOSGpk9bOyCu/46qnGvxlSQzywtwbCkGTzGP5JvhnFH?=
 =?us-ascii?Q?XnDuXc3oux4eBMlwExqlBhWRfZNdn/DzmRX67NU6h8roHKOzg+pRHESzPo+x?=
 =?us-ascii?Q?EjK2neLo+Jc0s8973/UsfANCxJYZJIhfyqlDyQZSdJv1jAtTgnIUiT8QF83F?=
 =?us-ascii?Q?oTGrHWisrUyp8C8LSdCPbQNl0gBXbV7NxIh0YbfB4XblL2KSuMDdjcVNbGwx?=
 =?us-ascii?Q?rqfN9cD2jfRpv8kHs8yRAhsPQj2itCywT0H7/566RpN0Av8YODSqqICttsVb?=
 =?us-ascii?Q?pwE9SaiWNdM94oRZxiBzwRenyPeVocqIphv0cXDSYrRjeZwrvVzGLBIGTwie?=
 =?us-ascii?Q?0sTahjwnnoY6CblfgOFyJdbbl0CJl6PEoyfNfBE0AMXAhYugXGW29EuTuAjv?=
 =?us-ascii?Q?Gtrt11ZoWbgT95uvYnb7eTkzFTGHaZsucOQO2kaMM0o/xN2mZsEbpuLNJCP8?=
 =?us-ascii?Q?LnSR7EVNUgp24hzX09cgphQZ/m00v9xBSoy6jDGg2jmE8VOgghqqHRdkHKz6?=
 =?us-ascii?Q?XLRSi9m1C6bWi9rulbIPhwziC30ytIh7k/agSiURbrwtqoBJEIs4ROf0Yuqi?=
 =?us-ascii?Q?WVGX3ckUcdCQ29FU6Oo0ekevU4K1dOc=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: d96a3d9b-0013-4d19-bdd2-08da3735fd76
X-MS-Exchange-CrossTenant-AuthSource: PA4PR05MB8996.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2022 12:17:05.3589
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JBSugDmPp40HsF7XLoagoJtDhx9ELzkQu2vSO9Yy+g+oH83e/ckh0HBWCkPUKUwoUqhP+t25fq2wtSU7DDLadeHYKDP47rCMACfdkpfDupc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR05MB8767
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 16, 2022 at 02:06:28PM +0200, Pablo Neira Ayuso wrote:
> On Mon, May 16, 2022 at 01:37:40PM +0200, Pablo Neira Ayuso wrote:
> > On Mon, May 16, 2022 at 01:18:17PM +0200, Sven Auhagen wrote:
> > > On Mon, May 16, 2022 at 12:56:38PM +0200, Pablo Neira Ayuso wrote:
> > > > On Thu, May 12, 2022 at 09:28:03PM +0300, Oz Shlomo wrote:
> > > > > Connections leaving the established state (due to RST / FIN TCP packets)
> > > > > set the flow table teardown flag. The packet path continues to set lower
> > > > > timeout value as per the new TCP state but the offload flag remains set.
> > > > >
> > > > > Hence, the conntrack garbage collector may race to undo the timeout
> > > > > adjustment of the packet path, leaving the conntrack entry in place with
> > > > > the internal offload timeout (one day).
> > > > >
> > > > > Avoid ct gc timeout overwrite by flagging teared down flowtable
> > > > > connections.
> > > > >
> > > > > On the nftables side we only need to allow established TCP connections to
> > > > > create a flow offload entry. Since we can not guaruantee that
> > > > > flow_offload_teardown is called by a TCP FIN packet we also need to make
> > > > > sure that flow_offload_fixup_ct is also called in flow_offload_del
> > > > > and only fixes up established TCP connections.
> > > > [...]
> > > > > diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> > > > > index 0164e5f522e8..324fdb62c08b 100644
> > > > > --- a/net/netfilter/nf_conntrack_core.c
> > > > > +++ b/net/netfilter/nf_conntrack_core.c
> > > > > @@ -1477,7 +1477,8 @@ static void gc_worker(struct work_struct *work)
> > > > >  			tmp = nf_ct_tuplehash_to_ctrack(h);
> > > > >  
> > > > >  			if (test_bit(IPS_OFFLOAD_BIT, &tmp->status)) {
> > > > > -				nf_ct_offload_timeout(tmp);
> > > > 
> > > > Hm, it is the trick to avoid checking for IPS_OFFLOAD from the packet
> > > > path that triggers the race, ie. nf_ct_is_expired()
> > > > 
> > > > The flowtable ct fixup races with conntrack gc collector.
> > > > 
> > > > Clearing IPS_OFFLOAD might result in offloading the entry again for
> > > > the closing packets.
> > > > 
> > > > Probably clear IPS_OFFLOAD from teardown, and skip offload if flow is
> > > > in a TCP state that represent closure?
> > >
> > > >   		if (unlikely(!tcph || tcph->fin || tcph->rst))
> > > >   			goto out;
> > > > 
> > > > this is already the intention in the existing code.
> > > > 
> > > > If this does work, could you keep IPS_OFFLOAD_TEARDOWN_BIT internal,
> > > > ie. no in uapi? Define it at include/net/netfilter/nf_conntrack.h and
> > > > add a comment regarding this to avoid an overlap in the future.
> > > > 
> > > > > +				if (!test_bit(IPS_OFFLOAD_TEARDOWN_BIT, &tmp->status))
> > > > > +					nf_ct_offload_timeout(tmp);
> > > > >  				continue;
> > > > >  			}
> > > > >  
> > > > > diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> > > > > index 3db256da919b..aaed1a244013 100644
> > > > > --- a/net/netfilter/nf_flow_table_core.c
> > > > > +++ b/net/netfilter/nf_flow_table_core.c
> > > > > @@ -177,14 +177,8 @@ int flow_offload_route_init(struct flow_offload *flow,
> > > > >  }
> > > > >  EXPORT_SYMBOL_GPL(flow_offload_route_init);
> > > > >  
> > > > > -static void flow_offload_fixup_tcp(struct ip_ct_tcp *tcp)
> > > > > -{
> > > > > -	tcp->state = TCP_CONNTRACK_ESTABLISHED;
> > > > > -	tcp->seen[0].td_maxwin = 0;
> > > > > -	tcp->seen[1].td_maxwin = 0;
> > > > > -}
> > > > >  
> > > > > -static void flow_offload_fixup_ct_timeout(struct nf_conn *ct)
> > > > > +static void flow_offload_fixup_ct(struct nf_conn *ct)
> > > > >  {
> > > > >  	struct net *net = nf_ct_net(ct);
> > > > >  	int l4num = nf_ct_protonum(ct);
> > > > > @@ -192,8 +186,12 @@ static void flow_offload_fixup_ct_timeout(struct nf_conn *ct)
> > > > >  
> > > > >  	if (l4num == IPPROTO_TCP) {
> > > > >  		struct nf_tcp_net *tn = nf_tcp_pernet(net);
> > > > > +		struct ip_ct_tcp *tcp = &ct->proto.tcp;
> > > > > +
> > > > > +		tcp->seen[0].td_maxwin = 0;
> > > > > +		tcp->seen[1].td_maxwin = 0;
> > > > >  
> > > > > -		timeout = tn->timeouts[TCP_CONNTRACK_ESTABLISHED];
> > > > > +		timeout = tn->timeouts[ct->proto.tcp.state];
> > > > >  		timeout -= tn->offload_timeout;
> > > > >  	} else if (l4num == IPPROTO_UDP) {
> > > > >  		struct nf_udp_net *tn = nf_udp_pernet(net);
> > > > > @@ -211,18 +209,6 @@ static void flow_offload_fixup_ct_timeout(struct nf_conn *ct)
> > > > >  		WRITE_ONCE(ct->timeout, nfct_time_stamp + timeout);
> > > > >  }
> > > > >  
> > > > > -static void flow_offload_fixup_ct_state(struct nf_conn *ct)
> > > > > -{
> > > > > -	if (nf_ct_protonum(ct) == IPPROTO_TCP)
> > > > > -		flow_offload_fixup_tcp(&ct->proto.tcp);
> > > > > -}
> > > > > -
> > > > > -static void flow_offload_fixup_ct(struct nf_conn *ct)
> > > > > -{
> > > > > -	flow_offload_fixup_ct_state(ct);
> > > > > -	flow_offload_fixup_ct_timeout(ct);
> > > > > -}
> > > > > -
> > > > >  static void flow_offload_route_release(struct flow_offload *flow)
> > > > >  {
> > > > >  	nft_flow_dst_release(flow, FLOW_OFFLOAD_DIR_ORIGINAL);
> > > > > @@ -353,6 +339,10 @@ static inline bool nf_flow_has_expired(const struct flow_offload *flow)
> > > > >  static void flow_offload_del(struct nf_flowtable *flow_table,
> > > > >  			     struct flow_offload *flow)
> > > > >  {
> > > > > +	struct nf_conn *ct = flow->ct;
> > > > > +
> > > > > +	set_bit(IPS_OFFLOAD_TEARDOWN_BIT, &flow->ct->status);
> > > > > +
> > > > >  	rhashtable_remove_fast(&flow_table->rhashtable,
> > > > >  			       &flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].node,
> > > > >  			       nf_flow_offload_rhash_params);
> > > > > @@ -360,12 +350,11 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
> > > > >  			       &flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].node,
> > > > >  			       nf_flow_offload_rhash_params);
> > > > >  
> > > > > -	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
> > > > > -
> > > > >  	if (nf_flow_has_expired(flow))
> > > > > -		flow_offload_fixup_ct(flow->ct);
> > > > > -	else
> > > > > -		flow_offload_fixup_ct_timeout(flow->ct);
> > > > > +		flow_offload_fixup_ct(ct);
> > > > 
> > > > Very unlikely, but race might still happen between fixup and
> > > > clear IPS_OFFLOAD_BIT with gc below?
> > > > 
> > > > Without checking from the packet path, the conntrack gc might race to
> > > > refresh the timeout, I don't see a 100% race free solution.
> > > > 
> > > > Probably update the nf_ct_offload_timeout to a shorter value than a
> > > > day would mitigate this issue too.
> > > 
> > > This section of the code is now protected by IPS_OFFLOAD_TEARDOWN_BIT
> > > which will prevent the update via nf_ct_offload_timeout.
> > > We set it at the beginning of flow_offload_del and flow_offload_teardown.
> > > 
> > > Since flow_offload_teardown is only called on TCP packets
> > > we also need to set it at flow_offload_del to prevent the race.
> > > 
> > > This should prevent the race at this point.
> > 
> > OK.
> > 
> > > > > +	clear_bit(IPS_OFFLOAD_BIT, &ct->status);
> > > > > +	clear_bit(IPS_OFFLOAD_TEARDOWN_BIT, &ct->status);
> > > > >  
> > > > >  	flow_offload_free(flow);
> > > > >  }
> > > > > @@ -373,8 +362,9 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
> > > > >  void flow_offload_teardown(struct flow_offload *flow)
> > > > >  {
> > > > >  	set_bit(NF_FLOW_TEARDOWN, &flow->flags);
> > > > > +	set_bit(IPS_OFFLOAD_TEARDOWN_BIT, &flow->ct->status);
> > > > >  
> > > > > -	flow_offload_fixup_ct_state(flow->ct);
> > > > > +	flow_offload_fixup_ct(flow->ct);
> > > > >  }
> > > > >  EXPORT_SYMBOL_GPL(flow_offload_teardown);
> > > > >  
> > > > > diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
> > > > > index 900d48c810a1..9cc3ea08eb3a 100644
> > > > > --- a/net/netfilter/nft_flow_offload.c
> > > > > +++ b/net/netfilter/nft_flow_offload.c
> > > > > @@ -295,6 +295,8 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
> > > > >  					  sizeof(_tcph), &_tcph);
> > > > >  		if (unlikely(!tcph || tcph->fin || tcph->rst))
> > > > >  			goto out;
> > > > > +		if (unlikely(!nf_conntrack_tcp_established(ct)))
> > > > > +			goto out;
> > > > 
> > > > This chunk is not required, from ruleset users can do
> > > > 
> > > >         ... ct status assured ...
> > > > 
> > > > instead.
> > > 
> > > Maybe this should be mentioned in the manual or wiki if
> > > it is not necessary in the flow offload code.
> > 
> > Yes, documentation and wiki can be updated.
> > 
> > Users might want to offload the flow at a later stage in the TCP
> > connection.
> 
> Well, actually there is not later stage than established, anything
> after established are TCP teardown states.
> 
> What's the issue with allowing to offload from SYN_RECV state?

There were multiple problem in general with the code.
flow_offload_fixup_tcp always moves a TCP connection
to established even if it is in FIN or CLOSE.

The flowoffload_del function was always setting the TCP timeout
to ESTABLISHED timeout even when the state was in CLOSE and therefore
creating a very long lasting dead state.

Since we might miss or bump packets to slow path, we do not know
what will happen there when we are still in SYN_RECV.

We will have a better knowledge of the TCP state when we are in 
established first and we know that we are either still in it or
we have moved past it to a closing state.




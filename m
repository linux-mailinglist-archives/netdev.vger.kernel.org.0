Return-Path: <netdev+bounces-2667-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 20762702EB4
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 15:50:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 169021C20C20
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 13:50:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80313D2E1;
	Mon, 15 May 2023 13:48:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61FF463CA;
	Mon, 15 May 2023 13:48:47 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B13D1BC;
	Mon, 15 May 2023 06:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684158526; x=1715694526;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=VzIU5lU30ouyuzUNRAklIihjhpc9bcEC1HV7KyYiJa4=;
  b=oGkNrJLHZeizacRcyRvwHXx16fr+9P94KlB2FFduIYoKznNFehEjwAS7
   YpIk8kqawoBkH07YAvHnoEEfTyeLaa+4U68ZDOhttlEM6S8N3rX8uDTXO
   OufiCK2IYIEKMbmf34Cgdw5TD/xWQtm5SoCCTScjBTOMNL6Xd3NfG0CZv
   Vq52kpro/O1fInwFTc1at9SyVIaIrGKhtpWa7wgU7QO//7bjHfwT+FQc4
   g6htdF+smlG6Ytzd2pep0VH86+oRtrvE2P5zHkUlLKD7+UUTtGSrq79GE
   yOEYH8StBZbFi5HiHFCnPBPPshlZB3bh/2tr4rmXrRJ5zvLeiHBR0jvWH
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="414600469"
X-IronPort-AV: E=Sophos;i="5.99,276,1677571200"; 
   d="scan'208";a="414600469"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2023 06:48:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="845264158"
X-IronPort-AV: E=Sophos;i="5.99,276,1677571200"; 
   d="scan'208";a="845264158"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 15 May 2023 06:48:45 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 06:48:44 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 06:48:44 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 15 May 2023 06:48:44 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 15 May 2023 06:48:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kti6V7HLsT5F+B3PLBhfO1CnthchCi4Mcsn4n+3ChVK2zEJGOBzcHZflbKWV5JbyXXN4TaUuZ3zSdhhgxyV/GRDUCUN3O73DmktNo3G5Ww5IDf4dgTGPro1HcwRerqADZr8kM15IUrmLB3TA2CaZ0xvkqFjhnAZs3Dk65BhpN2H2dypExX5ty+z9y6/d+y69h37qkA7lgtUlhwpoRsY3F17/TRM0bwwkf16zNOkBxV5nR2SXkBpkV/jQ1cw/GbFzlXfVNRJTQJ0TSYtu327zTF7wf2vLImoO1BiCv2nAXvrCRLM1qYzzczT8EY+stBPLGrBSP4c8PGjCXbtyGLmwnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8zFeseP4nNsM21y3wXSd4faf4CeWyQmY5SrXMCOlGpw=;
 b=FZVDXT4ijx6O9rNl2tbdupoAWzgatETHGpCeJxmbXKj4G4TLgerEpqeUE/yNTy81d9oXEhTQDoUl79G0Vfu5eazIbeCYtSiJRzO2YLuRVCZuHD0tD+I3f5SgBzjYrXxY8qsGNdKlAAywaJJd6YjaruXbJXG6gYpEVhucJeA3M7KgH+kpj6CvuM2Lt8G6k3HR5uQuX8aJc6c/OxcRZwXziKzrFZ1P9dJ6AGHZXuf1jQ0VV3Yj0yBjG1+Xv/QKR9uZXvVgwBSKD8Pk2zIw7f44NMWlRagub0VmhPsFDXJnYObc9EkO34Pde97Wb+gYWpvOj6bbqURffPkziPQx2Mw6Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5471.namprd11.prod.outlook.com (2603:10b6:5:39d::10)
 by MN2PR11MB4631.namprd11.prod.outlook.com (2603:10b6:208:262::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Mon, 15 May
 2023 13:48:42 +0000
Received: from DM4PR11MB5471.namprd11.prod.outlook.com
 ([fe80::907c:ffaa:352a:8913]) by DM4PR11MB5471.namprd11.prod.outlook.com
 ([fe80::907c:ffaa:352a:8913%6]) with mapi id 15.20.6387.030; Mon, 15 May 2023
 13:48:41 +0000
Date: Mon, 15 May 2023 15:46:00 +0200
From: Larysa Zaremba <larysa.zaremba@intel.com>
To: Stanislav Fomichev <sdf@google.com>
CC: <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, "Daniel
 Borkmann" <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, "Jakub
 Kicinski" <kuba@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, "Song
 Liu" <song@kernel.org>, Yonghong Song <yhs@fb.com>, John Fastabend
	<john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Jiri Olsa
	<jolsa@kernel.org>, Jesse Brandeburg <jesse.brandeburg@intel.com>, "Tony
 Nguyen" <anthony.l.nguyen@intel.com>, Anatoly Burakov
	<anatoly.burakov@intel.com>, Jesper Dangaard Brouer <brouer@redhat.com>,
	Alexander Lobakin <alexandr.lobakin@intel.com>, Magnus Karlsson
	<magnus.karlsson@gmail.com>, Maryam Tahhan <mtahhan@redhat.com>,
	<xdp-hints@xdp-project.net>, <netdev@vger.kernel.org>,
	<intel-wired-lan@lists.osuosl.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND bpf-next 07/15] ice: Support RX hash XDP hint
Message-ID: <ZGI3mP2k/751xAhm@lincoln>
References: <20230512152607.992209-1-larysa.zaremba@intel.com>
 <20230512152607.992209-8-larysa.zaremba@intel.com>
 <ZF6DzbBlhOyIa+3N@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZF6DzbBlhOyIa+3N@google.com>
X-ClientProxiedBy: FR2P281CA0059.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:93::13) To DM4PR11MB5471.namprd11.prod.outlook.com
 (2603:10b6:5:39d::10)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5471:EE_|MN2PR11MB4631:EE_
X-MS-Office365-Filtering-Correlation-Id: b754be48-2fb3-4f9d-b9b0-08db554b17d7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rLxUhWECL3Vy+UhnYmFOEGWf81EVj9St1qJ7NUhEcMWYByYjQj5uAUhrCIyMLnkTTxW+jA3x9qHB1WLHdTu7+qMNTFL9U2R5ev0oRokoBznQPV8/2l7qo9Y1lh7l/r19fZtOmIOARvFmYfASBL60DBRykxaoGQJks5BqslZZdmMcZMz/bYPsOAORsm12tk7LQ2wx9PK6TlsA3e+PAnGkULGdYXQAX6YAMF1WmZstQyuqUoXBuaaqQxq2hJUoxXKZ4kUNHI6wIXz6iGdk/2wVuxQ3bmrDJPsufh2xse2EGJInOxNydHLjo8CjIEr6s0KwIIGCEGpCScZ/rTnGjxJmCaJo4c2p7U/uNbbjQlSpT19/7d3RjgpwwrnoiqXeMRZnfggOZ7GoU5VIwtdfCALxreWSREkIxX6e35574GI9Hrios7VC4EvvPW/2YF0uoIatwDHeYTxrDaFrUhM6c1kBRB1ZrxkEKRDPQYwRRiaEolUQxBF2SxIbt2RiOIVXSpbvTxfzShcnyZMNT4oHvz/wIMd427A5mGCEVGoF97+a6PY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(396003)(39860400002)(366004)(346002)(376002)(451199021)(33716001)(83380400001)(66476007)(66556008)(9686003)(66946007)(6486002)(26005)(6506007)(6512007)(966005)(478600001)(54906003)(44832011)(6666004)(7416002)(186003)(5660300002)(86362001)(8676002)(8936002)(2906002)(316002)(4326008)(6916009)(41300700001)(82960400001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cumvnP4sLm7ewUGK76ZuuBwll7sGDe/SfS2+onjNVdPU7DQN/XetJoQgcWUd?=
 =?us-ascii?Q?rwMJ/Z2kCCwKOp2lLeq3h2Z3+f77jU8n6aWpeN+f+99sxejSOcl/Ta1d6ajL?=
 =?us-ascii?Q?ynYHDSI8JmhKyCCjMvfUtIImX0w6baGrsYIbLmAXGljKGwGJLSybHtFOx15R?=
 =?us-ascii?Q?Rnf9uN9q2YncbZzau5gHsjfL4tWLjNzuk25FHrE7yE4FtNfKztuLWuZDGX48?=
 =?us-ascii?Q?5rS+9Dhzhim6nCsLu6zkR3WhQT5EUst0gLIS2J2b5ufmKvxtnFnXtE9xSWju?=
 =?us-ascii?Q?FEqSnbXYhT9WXIk+XLufr9zkruDX/VG4MafeRuIXGVU7jFanbaD+/4xRnDC7?=
 =?us-ascii?Q?i9oZk8CZy38OqZJ/KjHdhgsoDJzWS4kJvXdyXpBjcrnxRefL8Q+ObZRoleR8?=
 =?us-ascii?Q?TRB4ReS+voVj84JCV5Y1hQu7fKruJZjldVNJUUwamzV8fHZWoKTSk1e/hIaH?=
 =?us-ascii?Q?GgGTV9Hpvpvxk9A85ybSzFCUYo5YgQ/WXT7AgJU0tWe9n6V/jC+/j2NB3Nim?=
 =?us-ascii?Q?xUSnZsJT/EQhMcJoP/p1Vk/fcTkjX1KWlrnVm1uJnGStPE2eBFx1dAFWAnr8?=
 =?us-ascii?Q?UNnGC/bUhlp7tu0MyhaHhS4nTxejz8nWIXkBAquSnEYcWDhDF9IYoi7SgafG?=
 =?us-ascii?Q?9hS25saKLoUPHy4mTpLhlFVLSG3eySEqbPVqhZIb8hzS40hkohaqnrHSGlTL?=
 =?us-ascii?Q?62t581rvt30Qi3cRRoyXaL3ODj6Wr6Lnh9DZVfsGdC8QJRmt3ShhKzleMfXq?=
 =?us-ascii?Q?iXtx/CDCL99pivff0xMq6LPbwrifm5n3wMffDWRCR/UtRJ7dNTqZH/taq5Uc?=
 =?us-ascii?Q?lrP+w0RV374OluOXejZ1Yyofqt74BhXcwrqJj1jFudbgfmERO2tLZyYnRXyn?=
 =?us-ascii?Q?yZFDBjFMoiucG3X9GwmTVC+nlLA6I4GLkOyk+YoKTfxQ56YssRTPNO34470K?=
 =?us-ascii?Q?+H+n8C3z3H13ubUuS5MSWsccw1Jd4yoZXkj0CCf0gf0TUin8+l4HtZqUWAK5?=
 =?us-ascii?Q?LjotAzOKjiAWBEKTuSC3VQOUJW6ZShkjiQ90kfpNNULx3OnBahLfCZenNUxm?=
 =?us-ascii?Q?qhERm49Vx1bReVeL1Qcc7KFfRN1y7cj+Nne8mMCltQ2vfL4Dk8/UFD6/2S5D?=
 =?us-ascii?Q?DByGOrCJuke5oEzhAo61a53x191e5GyllyYGPcQAgTiwKKIQzHqnbNxTBZLc?=
 =?us-ascii?Q?XgLkWWJ7pONH4f5Ucq19lPAvcdQn6mFSMsSCmTCkzL1mE56S5fw+Hhj4pkH1?=
 =?us-ascii?Q?daOrAdv5lE9j6nOY9HMlukcbVL94LTHfSJ7w+ibSaTt7sAMolsqKtqBu8Q5Y?=
 =?us-ascii?Q?62BqfFMukGrAPoXn99ybOYVMT2hJfyRG0ppnpzNXKzQ/VdHsVZGK3/7hmnw4?=
 =?us-ascii?Q?xE7rgFv+Zid3n7u7X5W3iisTSQvDM2Zyf+TR0qa8oZVzXvMJvuUYVlwOQqWN?=
 =?us-ascii?Q?eB5XB3zR7sJ7iEfwj9jgkhxTcMYKWi2NBXMoZHng3dDmUOaoNtWbmaHqimsO?=
 =?us-ascii?Q?FymHFNw3bdAaG4aZKdsZcPj6DXs0YAUN3OeI+i9dbyOOCr9fQh99CxnW4q/1?=
 =?us-ascii?Q?TyJEZNOuSmxnKedFt/GKDUox4WRTraGWID8yf4NBGPORcY+4Org7KrEtvT/o?=
 =?us-ascii?Q?rg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b754be48-2fb3-4f9d-b9b0-08db554b17d7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2023 13:48:41.7281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sfz6FZiHCWkyxVzBJO21g+N7chTR2mFLaFXdyxEhL6cwQ95FcZfojFfptjnTpzt54RTrt+3FhrT3WzRicRiOAgB8KVlXM02Dn+oRhhwCIQo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4631
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 12, 2023 at 11:22:05AM -0700, Stanislav Fomichev wrote:
> On 05/12, Larysa Zaremba wrote:
> > RX hash XDP hint requests both hash value and type.
> > Type is XDP-specific, so we need a separate way to map
> > these values to the hardware ptypes, so create a lookup table.
> > 
> > Instead of creating a new long list, reuse contents
> > of ice_decode_rx_desc_ptype[] through preprocessor.
> > 
> > Current hash type enum does not contain ICMP packet type,
> > but ice devices support it, so also add a new type into core code.
> > 
> > Then use previously refactored code and create a function
> > that allows XDP code to read RX hash.
> > 
> > Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
> > ---
> >  .../net/ethernet/intel/ice/ice_lan_tx_rx.h    | 412 +++++++++---------
> >  drivers/net/ethernet/intel/ice/ice_txrx_lib.c |  72 +++
> >  include/net/xdp.h                             |   3 +
> >  3 files changed, 283 insertions(+), 204 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
> > index 89f986a75cc8..d384ddfcb83e 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
> > +++ b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
> > @@ -673,6 +673,212 @@ struct ice_tlan_ctx {
> >   *      Use the enum ice_rx_l2_ptype to decode the packet type
> >   * ENDIF
> >   */
> > +#define ICE_PTYPES								\
> > +	/* L2 Packet types */							\
> > +	ICE_PTT_UNUSED_ENTRY(0),						\
> > +	ICE_PTT(1, L2, NONE, NOF, NONE, NONE, NOF, NONE, PAY2),			\
> > +	ICE_PTT_UNUSED_ENTRY(2),						\

[...]

> > + * @eop_desc: End of Packet descriptor
> > + */
> > +static enum xdp_rss_hash_type
> > +ice_xdp_rx_hash_type(union ice_32b_rx_flex_desc *eop_desc)
> > +{
> > +	u16 ptype = ice_get_ptype(eop_desc);
> > +
> > +	if (unlikely(ptype >= ICE_NUM_DEFINED_PTYPES))
> > +		return 0;
> > +
> > +	return ice_ptype_to_xdp_hash[ptype];
> > +}
> > +
> > +/**
> > + * ice_xdp_rx_hash - RX hash XDP hint handler
> > + * @ctx: XDP buff pointer
> > + * @hash: hash destination address
> > + * @rss_type: XDP hash type destination address
> > + *
> > + * Copy RX hash (if available) and its type to the destination address.
> > + */
> > +static int ice_xdp_rx_hash(const struct xdp_md *ctx, u32 *hash,
> > +			   enum xdp_rss_hash_type *rss_type)
> > +{
> > +	const struct ice_xdp_buff *xdp_ext = (void *)ctx;
> > +
> > +	*rss_type = ice_xdp_rx_hash_type(xdp_ext->eop_desc);
> > +	if (!ice_copy_rx_hash_from_desc(xdp_ext->eop_desc, hash))
> > +		return -EOPNOTSUPP;
> 
> Same here? See the following for the context:
> https://lore.kernel.org/bpf/167940675120.2718408.8176058626864184420.stgit@firesoul/

Thanks! Will fix.


Return-Path: <netdev+bounces-2661-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 88B9A702E9B
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 15:44:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F361280FA9
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 13:44:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE49DC8FC;
	Mon, 15 May 2023 13:44:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B762C2D9;
	Mon, 15 May 2023 13:44:46 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 012E6100;
	Mon, 15 May 2023 06:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684158285; x=1715694285;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=6vPP8hPcyvdNpz63xc5uahY4IKLBO4WHpvOPfCbdTCs=;
  b=OcXG1MlkIg7y0wZka71wJzjff/IxYGgtnV1TmOR/aWr4lFCAcQ8SMzB/
   Snxqbp6RpSeOzHfyS2ScJq0JM2OiZpOTtxXMZd0MkZp5isV9kHHLt9gEH
   AmEYPfnQ7bBehmoKlBlgUGYC6Q4V1l5FBAyWSqc6lDBhyYSXz4SpRe/2Q
   IN4cmmcpgtl4czP4Pn1ZpZTRfOzddm2PW3pVDHjUFEEESnCpnGJ662SzL
   U+b2MTiV6z7Ur9q0fSvcrDw0ITwdHIdGEK1rXLWCJvS+9SkMT/Jq+OKop
   wWKzjzJokqtlZ3TZA5TRrenntzITDlD7SWVFdOx4dzJa1cNIJVSxYCQ4R
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="414599233"
X-IronPort-AV: E=Sophos;i="5.99,276,1677571200"; 
   d="scan'208";a="414599233"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2023 06:44:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="845262857"
X-IronPort-AV: E=Sophos;i="5.99,276,1677571200"; 
   d="scan'208";a="845262857"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 15 May 2023 06:44:42 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 06:44:42 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 15 May 2023 06:44:42 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 15 May 2023 06:44:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gYZL4tK/1urswbyJKCyVasPzLtLda0MLOB7l10KsapHzBhA4EvD4qldqTaKf6d4jGT0+86h3G4gqTsbE5GIEvVaMi9ygBQeLkfKptM/i4V6QblL0/1pG8MaJHfmtpfdS0TkjjDCX8r1yPddeWY4YDp3G0e+n34AcrnFCwcqE2oQK89X2vqASSfqjWoEW1VDBhEwz95iZxln6B5oN2Bf8lbqj518rjyU6E+e0dPgx/2mpl8OwEiqpJFnzkyTB9EMDLnxO8B0LQaX5HKCsoQSjh+vNKk0SgLw+iOq8zw1TRVDUB1so2YrlGURlIU3KCdJu9aogTHkvBK9//NMGfCiwIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wRkZ9g/cOaXNLBENjrJyxbPW9t5a12VJcL28dQR80OM=;
 b=ivvEmTmEWiOAqeXtWOuRZj68hcIN+ncKjyIy6J3sR69EgJuUw7ZrqqmoWpkKEkvwjy1e2vheQWt62fs3xaN/IS4xRRRZCkKVSAqGwldrwzT5rPqniPmDVvEK4vOz2mF54cY/1YUhTOXbaJnNq++1lFXEtidHOXp1KsE8TCoFiGj53YIAFkIjf4doRk7TLjUparyCRQjiKr9RfZkx9j4PGAdiYvZk+rJ2KqTmvpovFxqv02q8cAEQMlCWsVLiSXMFZq5ykFnC2rZxho3UnB8UaBpciy8d2Nd/3ZK2yZhbfASAdwnPbGxDtK/2IzgROjoyqmDdahWyPtvIiafqR4AQgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5471.namprd11.prod.outlook.com (2603:10b6:5:39d::10)
 by SN7PR11MB6702.namprd11.prod.outlook.com (2603:10b6:806:269::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Mon, 15 May
 2023 13:44:37 +0000
Received: from DM4PR11MB5471.namprd11.prod.outlook.com
 ([fe80::907c:ffaa:352a:8913]) by DM4PR11MB5471.namprd11.prod.outlook.com
 ([fe80::907c:ffaa:352a:8913%6]) with mapi id 15.20.6387.030; Mon, 15 May 2023
 13:44:36 +0000
Date: Mon, 15 May 2023 15:41:52 +0200
From: Larysa Zaremba <larysa.zaremba@intel.com>
To: Stanislav Fomichev <sdf@google.com>
CC: <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, "Daniel
 Borkmann" <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, "Jakub
 Kicinski" <kuba@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, Song
 Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>, John Fastabend
	<john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Jiri Olsa
	<jolsa@kernel.org>, Jesse Brandeburg <jesse.brandeburg@intel.com>, "Tony
 Nguyen" <anthony.l.nguyen@intel.com>, Anatoly Burakov
	<anatoly.burakov@intel.com>, Jesper Dangaard Brouer <brouer@redhat.com>,
	Alexander Lobakin <alexandr.lobakin@intel.com>, Magnus Karlsson
	<magnus.karlsson@gmail.com>, Maryam Tahhan <mtahhan@redhat.com>,
	<xdp-hints@xdp-project.net>, <netdev@vger.kernel.org>,
	<intel-wired-lan@lists.osuosl.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND bpf-next 10/15] ice: Implement VLAN tag hint
Message-ID: <ZGI2oDcWX+o9Ea0T@lincoln>
References: <20230512152607.992209-1-larysa.zaremba@intel.com>
 <20230512152607.992209-11-larysa.zaremba@intel.com>
 <ZF6F+UQlXA9REqag@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZF6F+UQlXA9REqag@google.com>
X-ClientProxiedBy: FR3P281CA0196.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a5::14) To DM4PR11MB5471.namprd11.prod.outlook.com
 (2603:10b6:5:39d::10)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5471:EE_|SN7PR11MB6702:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ff5423b-be63-413e-615e-08db554a85ee
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /b7UP+k1N5naxSwQWVnMD6PZdusQVULiNRUfSNo/M2iE37SR5rjugT5eEM2E9VMjd3LKOp0UDOjIZHLtOwBhtF1Rjl3N5CLXTDjI0FnkPKjA5BenPIxXEPeJ1H1S8JiWHE0d2M0eFgs6nzhwlodrtRVCjR4nXBi8B5KRjhnTMCy7Iu8w2zOL/4B8NuHl7F4oKZcoS0R3IrXqMGB8fnzz7zqD4kw+E07uukiKETf4Ai772NBRl6aY/ojbjAXINI+5Cl/EdYkb18dUTp9SeWcXGERgV9/RhztsFfvE2DeFdgQkHkI4cWbkNrAmijTVAufQBNbhJn1LERHEG0AlY1FlLPyu4JsXItSKdzp7hnsa+wyfKgy/442gSZnRDqKj36ZaCYz2fEI/laDVLA3cNZmnP7vrJzSdrDL4IU16bUtSVB3bIhfYyaz+eHpjd0wWB7qUFbG0BJErNxlKNyikM4QILTAg4Gh/CqrN/OlxlXk9163++pSf8ZJQjex+VowNIWIN2NXTTzyKNjh9iVn8Ujx58C5xL8n/20hfbAVaLCPoL/j/qscleY4C9LR2xAxAq3NXt7E2/1tni0QfAtmgsDuHBznYbcfk3/dOZwrpjknsnxw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(346002)(376002)(396003)(366004)(39860400002)(451199021)(33716001)(66476007)(66556008)(9686003)(66946007)(6486002)(26005)(6506007)(6512007)(478600001)(54906003)(6666004)(7416002)(186003)(44832011)(86362001)(8676002)(8936002)(5660300002)(2906002)(41300700001)(4326008)(6916009)(316002)(82960400001)(38100700002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vMiREUBAySwfSNqKr89OUuTovkHON016AdZlHoTkiXy9C2Yy2ZBi6ilUZ8Ys?=
 =?us-ascii?Q?B9hQb/7pVctZ81t/4jxej8wWofrKoVTvFCRB5H6HspNTg1wtKjiAf4GQUNLQ?=
 =?us-ascii?Q?SwoPV1vrBQDJWW474TaYg1s54waxW3GqReqeQ83/a1s7ty0A5mq+Duvmie/S?=
 =?us-ascii?Q?nVt2lR3mI1111YDVAoZ3lbecm8udGL2HnfJF1MNgZOBtRol+ksypZhg3Cv5m?=
 =?us-ascii?Q?wYmfTUk5hEWlZ3gZwbm3vMZdQ0oGdhZJ1GMJ+n5nKuT35Jhyd0Ow6QR3+nkc?=
 =?us-ascii?Q?1NfkVcqNCQdW1jhQNXA0NgLLZGuNl3mvSl4CdDtTEoyD8581VaXlo8WzlQQP?=
 =?us-ascii?Q?pqWGVnot37rGt0aE6yVUZAAEzvG0WOFfoB/d5ZoomJqmT9WmMR5ZUFqhqyan?=
 =?us-ascii?Q?CKn41G7ySyFK9P6jKUOeuPjYEdsMpukJuwwWn+m+ePLh1TybXzoI8oPCx23o?=
 =?us-ascii?Q?CqDjJ5MiQ8Eq7oMuqmh8t217gs+SWOaeDseozmG+cESFy4YgW+CE5UkgevIn?=
 =?us-ascii?Q?wGj9Lq+fTzmlLJw6Hgrp4awFaHmShiQIxHrr/uNfhrtacCie3QVFUHM3UgJy?=
 =?us-ascii?Q?fjgjrJOrsrMbklAdXD/RWCsGejqAkrMpEn/SfsUuBW2+b9NJV/RvLVSMlFQ7?=
 =?us-ascii?Q?5LgYI6JiPnzvc6cH5Jo/0ikR8kr1/kIqwofH23F4Pvri51je6h5+MnuQ49sg?=
 =?us-ascii?Q?J+IVjB3tbf3WO+LDjQP5P/FwiBBJo+6fTLGnNtvKH2nDsFIO/PDeBXtM8dai?=
 =?us-ascii?Q?KrUu4DKDj71nu8UmLNg/IqUq+XPoml4GhBmSkZz/m9ckq8eFvbiyu6cXH00U?=
 =?us-ascii?Q?mJaP2jtpPtYGhHqBjgARNKSiZdohmoBJdaeE5RFj9OzPoCpPp8tZdiIhuzYf?=
 =?us-ascii?Q?qABxvVUhCIGtLxU44iPNly00ioTbt0h6mXL2dm5rFQUY+Bhmjfocqai9L4f4?=
 =?us-ascii?Q?9qs/YvkdDYpCqs7daXACGZFkZ7eilutgNmvsoHdz8reR2UNOH2hLdlHqxrxL?=
 =?us-ascii?Q?PkjXnQO72k/0XGRqZFA+aOT2tv1zVBN26mS9njZZAQsRh6SiJ4L++IczGyAA?=
 =?us-ascii?Q?UY6gZa6kzwNTDiEMkR6D/sTRhLzoNc7GmCYrQ+9/emFGd8bv9dah2+Vef8ZX?=
 =?us-ascii?Q?hJbQDLx4tA5zjHQJ+fMwpOM3xWIq1n9GWg/TseCljU4p3ulJcuWaq2T0+JK/?=
 =?us-ascii?Q?5Phrp8bWDaA20xwqcoKThb2dlzEPwOe08wApzIlUyiVZo4iXBcs0Pje0qzfz?=
 =?us-ascii?Q?OyjaBaYFl8XlJDC/T4wAptLju1ek8obHq6N7q4bfslxjD/kSrNc5kKkOgnjk?=
 =?us-ascii?Q?qFJ2mJyY3AeCsIomabFbIMPF8CbP0c2/GvpsMxeaLQP8/pUdOQbsrURk3c/b?=
 =?us-ascii?Q?JK+EMSHr/1clbbv631evmOdx7ErDX9lhQ9gMId7Am8gGjEni0d7fVJVi9yZ4?=
 =?us-ascii?Q?KkgFgnhuu4usrTiYsh/ojP9hQnzLdsipSmtzI3t1FwILDJ1+lsOxfkGqEWTt?=
 =?us-ascii?Q?khUh5taj2vdiaWFBAt38FsR/A2Pdmyl57xagZwnfUMwaQz7QSJ4OPqXBmMCr?=
 =?us-ascii?Q?L4g5NkqUopdD3Ev946rJvZiwTRtrKkKC0HFJj3jlqZxalkZ0zvhz8oA/7ugV?=
 =?us-ascii?Q?+w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ff5423b-be63-413e-615e-08db554a85ee
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2023 13:44:36.8577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qYoUdN7cgdSepBfdeSFT+lUWtvrWcSTkVy4lNgkIyBYil3Wd6Q05dmB0fl9l1Zo91o2+yqHPJdOS9+Iwae+KOw2XBF6Bf3+EXngzbBpwXKA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6702
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 12, 2023 at 11:31:21AM -0700, Stanislav Fomichev wrote:
> On 05/12, Larysa Zaremba wrote:
> > Implement .xmo_rx_vlan_tag callback to allow XDP code to read
> > packet's VLAN tag.
> > 
> > Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
> > ---
> >  drivers/net/ethernet/intel/ice/ice_txrx_lib.c | 44 +++++++++++++++++++
> >  1 file changed, 44 insertions(+)
> > 
> > diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
> > index 1caa73644e7b..39547feb6106 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
> > @@ -627,7 +627,51 @@ static int ice_xdp_rx_hash(const struct xdp_md *ctx, u32 *hash,
> >  	return 0;
> >  }
> >  
> > +/**
> > + * ice_xdp_rx_ctag - VLAN tag XDP hint handler
> > + * @ctx: XDP buff pointer
> > + * @vlan_tag: destination address
> > + *
> > + * Copy VLAN tag (if was stripped) to the destination address.
> > + */
> > +static int ice_xdp_rx_ctag(const struct xdp_md *ctx, u16 *vlan_tag)
> > +{
> > +	const struct ice_xdp_buff *xdp_ext = (void *)ctx;
> > +	netdev_features_t features;
> > +
> 
> [..]
> 
> > +	features = xdp_ext->rx_ring->netdev->features;
> > +
> > +	if (!(features & NETIF_F_HW_VLAN_CTAG_RX))
> > +		return -EINVAL;
> 
> Passing-by comment: why do we need to check features?
> ice_get_vlan_tag_from_rx_desc seems to be checking a bunch of
> fields in the descriptors, so that should be enough?

Unfortunately, it is not enough, because it only checks, if there is a valid 
value in the descriptor, without distinguishing c-tag from s-tag. In this
hardware, c-tag and s-tag are mutually exclusive, so they can occupy same 
descriptor fields. Checking netdev features is just the easiest way to tell them 
apart.

I guess, storing this information in in the ring structure would be more 
efficient than checking netdev features. I know Piotr Raczynski indends to 
review this series, so maybe he would provide some additional 
feedback/suggestions.

> 
> > +
> > +	*vlan_tag = ice_get_vlan_tag_from_rx_desc(xdp_ext->eop_desc);
> 
> Should we also do the following:
> 
> if (!*vlan_tag)
> 	return -ENODATA;
> 
> ?

Oh, returning VLAN tag with zero value really made sense to me at the beginning,
but after playing with different kinds of packets, I think returning error makes 
more sense. Will change.

> 
> > +	return 0;
> > +}
> > +
> > +/**
> > + * ice_xdp_rx_stag - VLAN s-tag XDP hint handler
> > + * @ctx: XDP buff pointer
> > + * @vlan_tag: destination address
> > + *
> > + * Copy VLAN s-tag (if was stripped) to the destination address.
> > + */
> > +static int ice_xdp_rx_stag(const struct xdp_md *ctx, u16 *vlan_tag)
> > +{
> > +	const struct ice_xdp_buff *xdp_ext = (void *)ctx;
> > +	netdev_features_t features;
> > +
> > +	features = xdp_ext->rx_ring->netdev->features;
> > +
> > +	if (!(features & NETIF_F_HW_VLAN_STAG_RX))
> > +		return -EINVAL;
> > +
> > +	*vlan_tag = ice_get_vlan_tag_from_rx_desc(xdp_ext->eop_desc);
> > +	return 0;
> > +}
> > +
> >  const struct xdp_metadata_ops ice_xdp_md_ops = {
> >  	.xmo_rx_timestamp		= ice_xdp_rx_hw_ts,
> >  	.xmo_rx_hash			= ice_xdp_rx_hash,
> > +	.xmo_rx_ctag			= ice_xdp_rx_ctag,
> > +	.xmo_rx_stag			= ice_xdp_rx_stag,
> >  };
> > -- 
> > 2.35.3
> > 


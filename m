Return-Path: <netdev+bounces-4360-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FBE370C2FF
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 18:08:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 44F011C20B4C
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 16:08:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29043154B6;
	Mon, 22 May 2023 16:08:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 081F4154AA;
	Mon, 22 May 2023 16:08:12 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E889E9;
	Mon, 22 May 2023 09:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684771691; x=1716307691;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=VX7g1qNRZhkDQeCeG+ihrf3FqNMATyQUi0We3uJO85k=;
  b=YBHt9XU720ilZixxOVNM6LV/kXuC6UeEYRnKVZzboPU32mqW7SRjac0K
   Xq0ex0AfTb89bLBeavKiV4lybPIDM/ASkUoCjG3y7sgIgV/4mWMZxdEIu
   UtH5AC8u9AWfhZgeIQF+uYEEHwfBsDmWuTEccA327hvrjAwSrhK4KEaBn
   1CUp7ETMNWBtbXNjAEPxU4uHl+2ED5kCdyauIUYdMETpXFKwHftTkvI8f
   YAimNabpoR2jWCvCzmTe2PYqy/pOZbmTd6IRO2n+eKsovST0AshrO4216
   0np1VyXKc43NjYUyXSg98MpfAJj5dAiw83C+KoFArrtViIzMlyLkWWfO7
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="381196194"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="381196194"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 09:07:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="681005604"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="681005604"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga006.jf.intel.com with ESMTP; 22 May 2023 09:07:54 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 09:07:53 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 09:07:53 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 22 May 2023 09:07:53 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 22 May 2023 09:07:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cYu52MnnQZ8RX757pUJghM751Kb+OsYUJ7NUWPscSBYdN9UkmJrY7Ibfzhu2wn1hqzq+lp+dgKNBh2bMZTRkF1yphmXwtk7vUYfUqo+3fTxD/3N7wA0VWUYr1krHvSAhKK5mAppglrs/slV9v4zreY3r291yWeOscon39zL8t0/E0yDDpohgYDtHbj3VKQL4C37YNODlkaWsvZjJpVn3vJbfeP7+sBJ2Bsi75yhZexUDqm3GCJn+oJTKvE1hRTloQCYFXW0nVi22p/VYYEkpMfxCTsSS1p/u7M0nWS1y+6UkPRxVRxZziTWmiQIwOHl2eo+qddP5yki7a/pztI4yFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BgtI7yqlg5dy7nkwD0lkIDNtVBkPENeO3vuee9RD5dA=;
 b=BcdSNwcswMJ0rCazHj09swCJsYW0jtCwwcZQ0XPfKwfYcDVXpPIOdXd5MBnwVhuROLAfzO/houtUzUA0tfOlClDurcqMyymXDjwwFbkyTSmAE/I4QhfjmX0inz7kOJ4sRs0TU3xsBRhcnqiHalelKm7j0WSz1ucDXLFReA4Stfl4F25tye+7oqpMKYCIp08LJXoWM2nX2Aewl4sPGb6X8pYHosgKElbfz/qAK5ZTfOHRDE/cT8OgVj7YzWgFJJWv+3vrOeQgwYzq6CPFiXpcgzwIPi5wKLq6SjxVXkE6ThmwgV6z98HqSf3wO8rTVvfAaZRoB+jJGn0ljDfMVVbkNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5471.namprd11.prod.outlook.com (2603:10b6:5:39d::10)
 by PH0PR11MB5949.namprd11.prod.outlook.com (2603:10b6:510:144::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Mon, 22 May
 2023 16:07:49 +0000
Received: from DM4PR11MB5471.namprd11.prod.outlook.com
 ([fe80::907c:ffaa:352a:8913]) by DM4PR11MB5471.namprd11.prod.outlook.com
 ([fe80::907c:ffaa:352a:8913%7]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 16:07:49 +0000
Date: Mon, 22 May 2023 18:05:04 +0200
From: Larysa Zaremba <larysa.zaremba@intel.com>
To: Alexander Lobakin <aleksander.lobakin@intel.com>
CC: <bpf@vger.kernel.org>, Stanislav Fomichev <sdf@google.com>, "Alexei
 Starovoitov" <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii
 Nakryiko <andrii@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Martin KaFai
 Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, Yonghong Song
	<yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, "KP Singh"
	<kpsingh@kernel.org>, Jiri Olsa <jolsa@kernel.org>, Jesse Brandeburg
	<jesse.brandeburg@intel.com>, Tony Nguyen <anthony.l.nguyen@intel.com>,
	Anatoly Burakov <anatoly.burakov@intel.com>, Jesper Dangaard Brouer
	<brouer@redhat.com>, Alexander Lobakin <alexandr.lobakin@intel.com>, "Magnus
 Karlsson" <magnus.karlsson@gmail.com>, Maryam Tahhan <mtahhan@redhat.com>,
	<xdp-hints@xdp-project.net>, <netdev@vger.kernel.org>,
	<intel-wired-lan@lists.osuosl.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND bpf-next 03/15] ice: make RX checksum checking
 code more reusable
Message-ID: <ZGuSsBVFlEePio60@lincoln>
References: <20230512152607.992209-1-larysa.zaremba@intel.com>
 <20230512152607.992209-4-larysa.zaremba@intel.com>
 <6693bcdb-b5dc-2f5b-41fa-9a9bba909dc7@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6693bcdb-b5dc-2f5b-41fa-9a9bba909dc7@intel.com>
X-ClientProxiedBy: FR0P281CA0113.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a8::13) To DM4PR11MB5471.namprd11.prod.outlook.com
 (2603:10b6:5:39d::10)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5471:EE_|PH0PR11MB5949:EE_
X-MS-Office365-Filtering-Correlation-Id: 50863a07-94cf-47ff-8fe3-08db5adeb077
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GW9lPtOJs51wtK/UpMTP/ZrZgLwK2JkDinP6/j/a2d9hqn2TllBMHieZBpzUI2cGJ5tPVM/4f3pp3daoQrFkOUT4YgyOLSqmVOjCLluj/J4Hf+1wta+AKbEeZT11eJiVWxZTnRfrgNvXw3u/QgBY9MUbMIehJIrMFW5ASnmJH9FH+mhJ4oX4ySk/24Zev6Ww1vB8W8Ok39Dmnjgj/pvo8kVQaJdZHKjE0urCjh31bB/Er4/GpUjRC1fEQPL2lMJ6evRraRsJwdkfkGpC8TsBBdBOGFQA3oHJ3LtNiqv2y4keJAH1z5qpGO3MfNy+SZ37MvNJ4C+cWdMBLc37plD90rau5oeb58+/TNq5IJYm0R8t5HiEAozMURitzw4QQhzFEKZkiV7dPektIYzFBqK6hsh8m47+TnwucTFTiDICJFPPEGHrV1GZ5gmKBT/QI98D5BuLA9Y3ot3lu2tj9UEfUHqMc2tTpitZN0LNn3++Jx2o81dquBxvTfpUUH/QAMjbFxSiqBhCz7RO/Cdm3u3mOV51/iK0fzYWwJK1OTN3v8tJ8zk3cd6LQFpTS44UyovLyruPtj6PRamh7a9xkB3YXkUoRjYeV4Z8upfc+oWE25bBq1WmegCJwhRdTxj/Gtpj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(376002)(396003)(39860400002)(136003)(346002)(366004)(451199021)(2906002)(33716001)(38100700002)(8676002)(6506007)(26005)(83380400001)(186003)(6512007)(9686003)(8936002)(7416002)(6862004)(316002)(86362001)(4326008)(41300700001)(5660300002)(44832011)(6636002)(6486002)(6666004)(82960400001)(66946007)(54906003)(66556008)(66476007)(478600001)(134885004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TO5m01ZHEitlCuBAkuNcDwtaqh6vPSicVaBu//8lAesJDizRRIEHE1wcvGvg?=
 =?us-ascii?Q?qcYxG4k3RIp92W26nJY/QoKw7ICMD6kUtHE3vZ1J8illFtCl9yyVqv8G+0bR?=
 =?us-ascii?Q?KhW1+QDftKzvWh1VVmT0frqESgaJVtcaFKzkfNbae9GQDSRzZqjK+fbXcTXm?=
 =?us-ascii?Q?MOWEnFPA4Vi9tcF/FtDMtq43LwmZWYBqafPoPLuEQMSaiU98p1ylmkP+QF7f?=
 =?us-ascii?Q?x98mQwgtqL0o9NE+ByPBG6vWFfFRgGe8P1x65F0vEQJtpIJmT7YzSkiXdX8I?=
 =?us-ascii?Q?qeLlDiMtLFh4dvGzRq0Tm4xME/05TfOIy63Lrk0iimUEgXGCegSLwMHnsy7+?=
 =?us-ascii?Q?FqHdZfWA1Gi51yl/d3xXp8hYi2jorrGaGQgNUK5+Q6P+dl2Z6hgogTOSe+oj?=
 =?us-ascii?Q?nccQcJ/ZSU/M1Bb1E3FMQpbARgK9mw/cX/jnbOsiNZn/wT3G5R6hNh/zeTXp?=
 =?us-ascii?Q?4+rFgURp8QMc6Bu37pBSihbpfegZ/zN561qSwP+r5LA0xnmn01wb2nVRNKCU?=
 =?us-ascii?Q?s3Ehf/93ZGAvAa7eycdiV5UyZMqcDVtGAoeFZ/yxpOE+0B6ADOw9o2KnojUr?=
 =?us-ascii?Q?KOzKrxOM3KartDQ7vjTXfewfiNOFqiSj51V2yx2muywim96Sn0HC03j8couK?=
 =?us-ascii?Q?vYf4mm5TvcldxJr1lJhrjLkvbXTIaOGlW5jhNPuoZMgmHgGkSyCPhYeUZINJ?=
 =?us-ascii?Q?BUPOxGudtm7RRG/FkewmumWVJ3J1wNjLMU7CJ19qwLIMgnH7bfTMQSUhzaYC?=
 =?us-ascii?Q?uiLkcyNmSSv4LWhLD5HyYJWtiddoe2wjcAV0Ig0nuJxkyDj/1JlUxG88OMjy?=
 =?us-ascii?Q?elYm2pCkIFrhx5gpkNYN1LbI1dBW16iuBB/9HQZC9VF5AOq7MUSqMb7zuxPt?=
 =?us-ascii?Q?Amf+4/vQAxKa4TsBUaiYM7HmjmHVb2v8TOAFBFbUJR4cGbM3WAek2jpy5wiv?=
 =?us-ascii?Q?/SVDxypjqMz5h676Q99edPLojkYP3jQBf39X2dbA2keQbUweNQJVbFletGYp?=
 =?us-ascii?Q?HWw5j4xQM+3uiFAU5YLFdCA+Gzz3CXGY9DBz3BKLSn2SLIQ0UQzoS4r6hdYp?=
 =?us-ascii?Q?Ym9b/M1h9ORbphhkVHG0dGkXFScu3e5FhxqwbKIlWY/Yxiflbx4qGTwyR+78?=
 =?us-ascii?Q?RdvMhadM0gow7/9IAZScvMjOxd06AJfJQVJW/5IlnIOu3WJ80Hd3x8eWMLw3?=
 =?us-ascii?Q?lBIKKGgD28mB1ESMUCy9eGazXA2kfOuonClTliC/FbJ5VBnluFR2/pH+ZIHC?=
 =?us-ascii?Q?9ho7xHfOGubFEA4VcyyMpbJEJOfB+C/Vhh3wyYA8JevP2YIxjMKz3zFkb4A7?=
 =?us-ascii?Q?+XelSRIGb48Qyc+U8sJR/KpBNxnuq2gRjXTOX1sKktXhQXx2AIP0jti/s8jm?=
 =?us-ascii?Q?7wQ4nEyH2dER2ZaKx5uy0AjyQ8Wcla4DV6Cz3K0O3g62ga2bb9ytajQd+wYS?=
 =?us-ascii?Q?N3S5zHEbPp1Zsx2HFp/zbVPWdJN2fPTTO3ItP6umKecUAHv81RsMWcXG6P0h?=
 =?us-ascii?Q?Ut+HCEFhZ7OTYTDnrMJZN908mT7B97MCpglCJKMn2zhU/w8vnNnj0/h2ZAqG?=
 =?us-ascii?Q?QoghvvEuN8RHXdj6scO1foV7taevPw3sCE4WKLqYnPsWSGl0gxbJE30OuQug?=
 =?us-ascii?Q?jA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 50863a07-94cf-47ff-8fe3-08db5adeb077
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2023 16:07:49.5249
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: po41TiBY2XAJhCtySNskzqn1KKECZNEu27oEpfFpkvG6r8EEoVYKTtBKX/mE28HLhV3o4H56c6n4l0h3WY7c9nzqWeTN9MwQmCMnV0XWxeA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5949
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 05:51:37PM +0200, Alexander Lobakin wrote:
> From: Larysa Zaremba <larysa.zaremba@intel.com>
> Date: Fri, 12 May 2023 17:25:55 +0200
> 
> > Previously, we only needed RX checksum flags in skb path,
> > hence all related code was written with skb in mind.
> > But with the addition of XDP hints via kfuncs to the ice driver,
> > the same logic will be needed in .xmo_() callbacks.
> > 
> > Put generic process of determining checksum status into
> > a separate function.
> > 
> > Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
> > ---
> >  drivers/net/ethernet/intel/ice/ice_txrx_lib.c | 71 ++++++++++++-------
> >  1 file changed, 46 insertions(+), 25 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
> > index 1aab79dc8915..6a4fd3f3fc0a 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
> > @@ -104,17 +104,17 @@ ice_rx_hash_to_skb(struct ice_rx_ring *rx_ring,
> >  }
> >  
> >  /**
> > - * ice_rx_csum - Indicate in skb if checksum is good
> > - * @ring: the ring we care about
> > - * @skb: skb currently being received and modified
> > + * ice_rx_csum_checked - Indicates, whether hardware has checked the checksum
> 
> %CHECKSUM_UNNECESSARY means that the csum is correct / frame is not
> damaged. So "checked" is not enough I'd say, it's "verified" at least.
> OTOH that's too long already, I'd go with classic "csum_ok" :D

'csum_ok' sounds good :) 'csum_valid' if want to be fancy

> 
> >   * @rx_desc: the receive descriptor
> >   * @ptype: the packet type decoded by hardware
> > + * @csum_lvl_dst: address to put checksum level into
> > + * @ring: ring for error stats, can be NULL
> >   *
> > - * skb->protocol must be set before this function is called
> > + * Returns true, if hardware has checked the checksum.
> >   */
> > -static void
> > -ice_rx_csum(struct ice_rx_ring *ring, struct sk_buff *skb,
> > -	    union ice_32b_rx_flex_desc *rx_desc, u16 ptype)
> > +static bool
> > +ice_rx_csum_checked(union ice_32b_rx_flex_desc *rx_desc, u16 ptype,
> 
> (also const, but I guess you'll do that either way after the previous
>  mails)

OK

> 
> > +		    u8 *csum_lvl_dst, struct ice_rx_ring *ring)
> >  {
> >  	struct ice_rx_ptype_decoded decoded;
> >  	u16 rx_status0, rx_status1;
> 
> [...]
> 
> > +/**
> > + * ice_rx_csum_into_skb - Indicate in skb if checksum is good
> > + * @ring: the ring we care about
> > + * @skb: skb currently being received and modified
> > + * @rx_desc: the receive descriptor
> > + * @ptype: the packet type decoded by hardware
> > + */
> > +static void
> > +ice_rx_csum_into_skb(struct ice_rx_ring *ring, struct sk_buff *skb,
> > +		     union ice_32b_rx_flex_desc *rx_desc, u16 ptype)
> > +{
> > +	u8 csum_level = 0;
> 
> I'm not a fan of variables shorter than u32 on the stack. And since it
> gets passed by a reference, I'm not sure the compiler will inline it =\
> 
> > +
> > +	/* Start with CHECKSUM_NONE and by default csum_level = 0 */
> > +	skb->ip_summed = CHECKSUM_NONE;
> > +	skb_checksum_none_assert(skb);
> 
> Can we also remove this? Neither of these makes sense. ::ip_summed is
> always zeroed after the memset() in __build_skb_around() (somewhere
> there), while the assertion checks for `skb->ip_summed ==
> CHECKSUM_NONE`, i.e. it's *always* true here (set and check :D). It's
> some ancient pathetic rituals copied over and over again from e100
> centuries or so...

Will fix.

> 
> ...and BTW the comment is misleading, because the code doesn't zero
> ::csum_level as they claim :D
> 
> > +
> > +	/* check if Rx checksum is enabled */
> > +	if (!(ring->netdev->features & NETIF_F_RXCSUM))
> > +		return;
> > +
> > +	if (!ice_rx_csum_checked(rx_desc, ptype, &csum_level, ring))
> > +		return;
> > +
> > +	skb->ip_summed = CHECKSUM_UNNECESSARY;
> > +	skb->csum_level = csum_level;
> 
> Since csum_level is useless when ip_summed is set to NONE, what do you
> think about making the function return -1, 0, or 1 without writing
> anything by reference?
> 
> 	int csum_level;
> 
> 	csum_level = ice_rx_csum_ok(rx_desc, ptype, ring);
> 	if (csum_level < 0)
> 		return;
> 
> 	skb->ip_summed = CHECKSUM_UNNECESSARY;
> 	skb->csum_level = csum_level;
> 
> I'm not saying it's better (might be a bit at codegen), just proposing.

I think it's worth a try.

> 
> >  }
> >  
> >  /**
> > @@ -232,7 +253,7 @@ ice_process_skb_fields(struct ice_rx_ring *rx_ring,
> >  	/* modifies the skb - consumes the enet header */
> >  	skb->protocol = eth_type_trans(skb, rx_ring->netdev);
> >  
> > -	ice_rx_csum(rx_ring, skb, rx_desc, ptype);
> > +	ice_rx_csum_into_skb(rx_ring, skb, rx_desc, ptype);
> >  
> >  	if (rx_ring->ptp_rx)
> >  		ice_ptp_rx_hwts_to_skb(rx_ring, rx_desc, skb);
> 
> Thanks,
> Olek


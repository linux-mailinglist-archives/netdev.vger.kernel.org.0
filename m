Return-Path: <netdev+bounces-2724-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 860887036A8
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 19:12:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C1AC428122E
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 17:12:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 867A3FC06;
	Mon, 15 May 2023 17:12:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3E1FC00;
	Mon, 15 May 2023 17:12:20 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 462CF100E5;
	Mon, 15 May 2023 10:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684170713; x=1715706713;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=1kSOhLBOPBRsdT9Bh2FRCt41c/B5u3ZekVxkwXXpkoo=;
  b=KLIVxlseq7fsyL47IiXNgewmbuiD7ECOsdyBs12ywHJTx6OG6aOy4bIj
   DMGM8mo9K70vVrS+opA5fNTCDb6+sElAX48ywjdWgntkBxbqWqEOhV+el
   j3ONgMWgHnU/LJk7OaNOQrLI1f83+axEIOKCjXKtskU7ixkesiE08KOJM
   0obrxM08X9IffWm3hwS7U+UZC3JDL/WnFZC5gakcaOhSd9DhDasQ2WHS+
   H4lDpaDzOnIhMRG7aWjNqJZ7aKzwvpCfd9eoECOGUyGyLpDXwcKEtsWjL
   nKe0XGXvctRAmtOjnp1zb8MRRu0d4TSMfvJW4HKTRqi41G/ePIOgggBIw
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="353532121"
X-IronPort-AV: E=Sophos;i="5.99,277,1677571200"; 
   d="scan'208";a="353532121"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2023 10:11:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="770681332"
X-IronPort-AV: E=Sophos;i="5.99,277,1677571200"; 
   d="scan'208";a="770681332"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 15 May 2023 10:11:26 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 10:11:26 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 15 May 2023 10:11:26 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 15 May 2023 10:11:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E6+oL9ehgrxc/ds07gDAbHuQWXftNK0jjWt3nu2ZhjiIjhd56s5NflGQ1S+LSE6EyilvPn8fW4ytauX9e65KnWoUGe6S12nMMtBI8pKxxiOVCzkOYCGiNOUIlBxWksuQq4SARVBRe30jj++DRaVnlcCw0yByVBhmi+qYnqNGnUjSgOUPrvp2I77APKDkD95MYSHTqhs+NGK87Lx8oStcN4U8s1pBCQZNig8n/DVTu7S0f4xBBMUhI8ch7nJYODXGauaXR7SlD4Ex0cc/XtsELLpegNtUdayMuVSfO0jZ2XgoY6urOCRI9FFXnk5WTkpb2oPEphgvApZQylond441kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=io9rssTSLsKuIYzrw42TF9Fmo1ht9XbwDBXTp3gpaUo=;
 b=ejhA2SC6CzvqXYDX3C26FUW4GYEL6Us41d1ooFAK7RG+z1QvxWr9t7Su2OILei9F5u5GUC9zClkaomaMwKS4x/DjvuW1lDh3KLWnhHxY7JLnfCh0B7meg1/4H3v/G0u4ILB0H0itrEuWi2RQ1pSKFTLozvsyGPfnMHI5NYppQLvANQCkhbf/wi+el+ca3A5kqdzW1AahXO+tcIVWGL6K2+LZ9dGGOZ9m407wQGdyGaEZBvfhNQWblXyLYOSzhzNwv+mJW6sLH+rV/GeODk9KOI/wP99vn3eznRhrIsRpeF29zkfoIP6g0QJhZ7P5F2LCoayvImCA2huhf6bK3SxeKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5471.namprd11.prod.outlook.com (2603:10b6:5:39d::10)
 by SJ2PR11MB8422.namprd11.prod.outlook.com (2603:10b6:a03:542::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Mon, 15 May
 2023 17:11:23 +0000
Received: from DM4PR11MB5471.namprd11.prod.outlook.com
 ([fe80::907c:ffaa:352a:8913]) by DM4PR11MB5471.namprd11.prod.outlook.com
 ([fe80::907c:ffaa:352a:8913%6]) with mapi id 15.20.6387.030; Mon, 15 May 2023
 17:11:23 +0000
Date: Mon, 15 May 2023 19:08:39 +0200
From: Larysa Zaremba <larysa.zaremba@intel.com>
To: Jesper Dangaard Brouer <jbrouer@redhat.com>
CC: <bpf@vger.kernel.org>, <brouer@redhat.com>, Stanislav Fomichev
	<sdf@google.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann
	<daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu
	<song@kernel.org>, Yonghong Song <yhs@fb.com>, John Fastabend
	<john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Jiri Olsa
	<jolsa@kernel.org>, Jesse Brandeburg <jesse.brandeburg@intel.com>, "Tony
 Nguyen" <anthony.l.nguyen@intel.com>, Anatoly Burakov
	<anatoly.burakov@intel.com>, Alexander Lobakin <alexandr.lobakin@intel.com>,
	Magnus Karlsson <magnus.karlsson@gmail.com>, Maryam Tahhan
	<mtahhan@redhat.com>, <xdp-hints@xdp-project.net>, <netdev@vger.kernel.org>,
	<intel-wired-lan@lists.osuosl.org>, <linux-kernel@vger.kernel.org>,
	Aleksander Lobakin <aleksander.lobakin@intel.com>
Subject: Re: [PATCH RESEND bpf-next 14/15] net, xdp: allow metadata > 32
Message-ID: <ZGJnFxzDTV2qE4zZ@lincoln>
References: <20230512152607.992209-1-larysa.zaremba@intel.com>
 <20230512152607.992209-15-larysa.zaremba@intel.com>
 <ee1ad4f2-34ab-4377-14d5-532cb0687180@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ee1ad4f2-34ab-4377-14d5-532cb0687180@redhat.com>
X-ClientProxiedBy: FR0P281CA0139.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::14) To DM4PR11MB5471.namprd11.prod.outlook.com
 (2603:10b6:5:39d::10)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5471:EE_|SJ2PR11MB8422:EE_
X-MS-Office365-Filtering-Correlation-Id: d68ab9ee-7928-4f05-c991-08db556768f2
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mnkE5/w8sRXVS2jCQ3E+d5XvfEhQqk1pql9CnQuBP1UJYToGLMaf9FyYOGD94cO+jDRwbwV8isuPmgtWtrmKz74Jyl+3HH+UvegmsPde/5nab2qbBgRu5pmnC5YYxEQPrAm4GdWO0ry4omHw0EsQ/1akAVXbB29tOLZf1hnk6Vtb2QcIOnr6YcYfgvy+DNYoz2kHDvFla26n0KBp2Fts51mmYbgRwVv4fe5Tx7UktjSG8X9EmdDNCSZep0O7dRAEoaho66UMVVU7GFRYrIXa1Jh0Kqek63YVOcWhLDDJ8f8dS1pPih4R9G8Ij+fo7GfWzYPkbzBZsvKD4SRgx34z1NSN87DByuY5E97jZ7p44W2Ebt7r8wVKBVbeOibI7CZI+snO0lqCKeALqhiGfCLsrFO5wXiQ9CjznNiEdmajSpBnHTrw610XMg16zyNb+0ypGhhWoI7Gb0XDDpz+SAO7S0E0TyNmZ2YNjMQU1DhIjwLD2PZS9O1+DGpQBnvmi+g87uaibYzSNLbALphgpKzjj9E98sxMHhXUUNBB0lblxcjh2FoXfg+He+IIGRE/4nNa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(396003)(376002)(39860400002)(366004)(346002)(451199021)(83380400001)(26005)(6506007)(2906002)(6512007)(186003)(9686003)(107886003)(7416002)(86362001)(33716001)(5660300002)(6486002)(44832011)(8676002)(6666004)(478600001)(54906003)(38100700002)(8936002)(41300700001)(66476007)(316002)(82960400001)(66946007)(6916009)(66556008)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uS4XK+t6oC2AFnBTvftRNvuU1+U8Z2Z8roT6SFjpNHi314fvtaKgSw5YrMYo?=
 =?us-ascii?Q?gx23swfIYWN6aClZgQZeCpCudYipFKoulZvnw7ze9ZWO4IOy/Q9xTrYUoOFD?=
 =?us-ascii?Q?Sbz/e8ye8N4LmsAujbUidm4D4e7XubnkKOV5eKJbp3XiGCqDIC2kFf0YNn6o?=
 =?us-ascii?Q?ZBrsB7PObglP1WQ6Der0DS7YJ81zdDTHsxAlx9yk7u9wyMHnup8e4+1WMtEk?=
 =?us-ascii?Q?vO6GS9G2mGYTI8WZm8uexLxlfYZqAZ+AidG5NBzF7YQMJtY2qKf1GbkQ5owI?=
 =?us-ascii?Q?DX6dXjQnG6yxjytH+8ib7hY0IAbt8JjW0uJAdrFBUVBc5IzfN82Pl/8zBbsO?=
 =?us-ascii?Q?f7HCgAacPUxJVvMuvDxjzns/eLlh2TP3zsEFuOnG4OLrGbm1FS4mkAU0Di0i?=
 =?us-ascii?Q?ZuJhx7EPm+MLTX2VNDdi3xz1IeqTMhUe/CPX9mIZJXTyO28Ek5Q2mNwhuelX?=
 =?us-ascii?Q?WIlPwBMHdXX8VN8VzbvViTVYR9sRunxeHe4dvTTDkt3oQwqPc0UHe4LR56B4?=
 =?us-ascii?Q?FIhVR6eY0Ye80TOSfA3Y7In4pxcW4R8mUsnVBUC/A4z8XWqzmUZea4saEWjr?=
 =?us-ascii?Q?hw5yWbuRCZiOFFWoNAKXiRHZU7TanTawGjhaZH+JrSD2rcTFhGh6Yc96nAZz?=
 =?us-ascii?Q?Ng/QBd3DYQ4D58BC2+bRiqJNfXtbXbRUwetU4rWlCZS5OizIJw9ailLFuUdI?=
 =?us-ascii?Q?qcKJK4A9uqELyAH6sA+2ydOpUuS5YSKqlSRf/VoGXLrqsLVCA4dePjoVdH6o?=
 =?us-ascii?Q?+vnKDeVGkMPxzgzvbL2mmTONjKRUpV8vLqvxlfLq5hAl4xG/qW1irG7Nrtt0?=
 =?us-ascii?Q?8iBfOCI8Ni3/5XkX7sRO64LhIabqeXN2yGY0uFnNyEC9GWQm5hoAqihpF3jz?=
 =?us-ascii?Q?4E8C+c3eKSsQt8LNy8evbWo1qaZjdW4Fw/uT7DvKAl3V0sm/qFil9gXXFnbB?=
 =?us-ascii?Q?xewGvWh33V9/5xFA8L3TlNPsiu5aEhR0yUSnEjwff+EWnpyREiiEXixzSGZf?=
 =?us-ascii?Q?xGVjeL1OPl1w7UqxwO2cQ5yOtE7aBodpVCrNDMywS23rHeI9R08hE+E6v9i7?=
 =?us-ascii?Q?dUzzhwR39/0dH7ZaLNczotF3jdCaO6cEPZJq2XYirUMlUEKtSRvfU4RE+Qdw?=
 =?us-ascii?Q?SKKRS9jYJyALvLH850mxkBFj/uGdqAWexHoAl4C6pRjs7axfmxj5hry7zNiz?=
 =?us-ascii?Q?UpW3xGA3A5sRWB92BVG6egfq0W29+JAv0Kc2Mqw3NjQPTK9SZEzXkD8rZcLy?=
 =?us-ascii?Q?ZNIt8C671ioO/PHbDcJGQhBrpYSZcjWqwLu3vC7xT7Bxwgx3QuH08WYYN/ML?=
 =?us-ascii?Q?fkxAxRYZtywtJyyCoc/d6s9Cxv53LKcMqqAmPAU7/C1cw5zt/bcQauZOONi+?=
 =?us-ascii?Q?1n46R4oh2c1/9hw7LB2/mS0l+zVEM8Q0wd2sXsFLR2LVFtuN6l18hAk9gN++?=
 =?us-ascii?Q?WFQ8BzLnd9nReLW7aylATrKOrVxEXwFXMVx/HrZnhbhqRmPIwqjR+HZ3L27I?=
 =?us-ascii?Q?oDN1FBUe9/vbUNbQKazTry8DJC2UN0i2cRh4lqV3zCWJhmwCvN0lHMQik8PT?=
 =?us-ascii?Q?bH6C2kXxJVx1BdhIdu3m70HEmM4F18KpZYcjjAyjF6Y4EuQMsOyFKwrz1prP?=
 =?us-ascii?Q?fA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d68ab9ee-7928-4f05-c991-08db556768f2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2023 17:11:23.6025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: znda0rPhVzB29cZCk1dPOLbprCEoQFa1xGEbsY39LEzIxrJYJvC/QLcizp6egv5dV29kG+hnFWzD9Xfrw1d3zLu46bu53zNLAtBdqmpNGbw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8422
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 06:17:02PM +0200, Jesper Dangaard Brouer wrote:
> 
> 
> On 12/05/2023 17.26, Larysa Zaremba wrote:
> > From: Aleksander Lobakin <aleksander.lobakin@intel.com>
> > 
> > When using XDP hints, metadata sometimes has to be much bigger
> > than 32 bytes. Relax the restriction, allow metadata larger than 32 bytes
> > and make __skb_metadata_differs() work with bigger lengths.
> > 
> > Now size of metadata is only limited by the fact it is stored as u8
> > in skb_shared_info, so maximum possible value is 255.
> 
> I'm confused, IIRC the metadata area isn't stored "in skb_shared_info".
> The maximum possible size is limited by the XDP headroom, which is also
> shared/limited with/by xdp_frame.  I must be reading the sentence wrong,
> somehow.

It's not 'metadata is stored as u8', it's 'metadata size is stored as u8' :)
Maybe I should rephrase it better in v2.

> 
> > Other important
> > conditions, such as having enough space for xdp_frame building, are already
> > checked in bpf_xdp_adjust_meta().
> > 
> > The requirement of having its length aligned to 4 bytes is still
> > valid.
> > 
> > Signed-off-by: Aleksander Lobakin <aleksander.lobakin@intel.com>
> > Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
> > ---
> >   include/linux/skbuff.h | 13 ++++++++-----
> >   include/net/xdp.h      |  7 ++++++-
> >   2 files changed, 14 insertions(+), 6 deletions(-)
> > 
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index 8ddb4af1a501..afcd372aecdf 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -4219,10 +4219,13 @@ static inline bool __skb_metadata_differs(const struct sk_buff *skb_a,
> >   {
> >   	const void *a = skb_metadata_end(skb_a);
> >   	const void *b = skb_metadata_end(skb_b);
> > -	/* Using more efficient varaiant than plain call to memcmp(). */
> > -#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && BITS_PER_LONG == 64
> >   	u64 diffs = 0;
> > +	if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) ||
> > +	    BITS_PER_LONG != 64)
> > +		goto slow;
> > +
> > +	/* Using more efficient variant than plain call to memcmp(). */
> >   	switch (meta_len) {
> >   #define __it(x, op) (x -= sizeof(u##op))
> >   #define __it_diff(a, b, op) (*(u##op *)__it(a, op)) ^ (*(u##op *)__it(b, op))
> > @@ -4242,11 +4245,11 @@ static inline bool __skb_metadata_differs(const struct sk_buff *skb_a,
> >   		fallthrough;
> >   	case  4: diffs |= __it_diff(a, b, 32);
> >   		break;
> > +	default:
> > +slow:
> > +		return memcmp(a - meta_len, b - meta_len, meta_len);
> >   	}
> >   	return diffs;
> > -#else
> > -	return memcmp(a - meta_len, b - meta_len, meta_len);
> > -#endif
> >   }
> >   static inline bool skb_metadata_differs(const struct sk_buff *skb_a,
> > diff --git a/include/net/xdp.h b/include/net/xdp.h
> > index 0fbd25616241..f48723250c7c 100644
> > --- a/include/net/xdp.h
> > +++ b/include/net/xdp.h
> > @@ -370,7 +370,12 @@ xdp_data_meta_unsupported(const struct xdp_buff *xdp)
> >   static inline bool xdp_metalen_invalid(unsigned long metalen)
> >   {
> > -	return (metalen & (sizeof(__u32) - 1)) || (metalen > 32);
> > +	typeof(metalen) meta_max;
> > +
> > +	meta_max = type_max(typeof_member(struct skb_shared_info, meta_len));
> > +	BUILD_BUG_ON(!__builtin_constant_p(meta_max));
> > +
> > +	return !IS_ALIGNED(metalen, sizeof(u32)) || metalen > meta_max;
> >   }
> >   struct xdp_attachment_info {
> 
> 


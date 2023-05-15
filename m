Return-Path: <netdev+bounces-2689-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5402B7031CC
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 17:48:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0597C28118C
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 15:48:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A2D5E55F;
	Mon, 15 May 2023 15:48:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22CF2883A;
	Mon, 15 May 2023 15:48:50 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEBAD1FDF;
	Mon, 15 May 2023 08:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684165728; x=1715701728;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=3mQZ7SnAbvZPcYFXJjkGRwzOfYXinWUlTjKwZvaNiq8=;
  b=UtQjgHXEbar3G59nYzlwClvHqCzzuQBHhnYu4spJOXTkR29YwvScg2WZ
   vK8gD2DP2bR2Ys7301WlgwJzaEL6g2o8vV+XXfJHTlJPVtiIfdptw6kfh
   QsBi/OpqkOwvWPrvx68XTmveupfq1g9xD0O9Oi4hoeDA91A8qBozSt8D5
   n2HXpJXm8pCiOpMafTgm8Epw6tOz/DZgyvDRH5lpv1avNN4b5QkBYm+NC
   X5Q2yj17r1FHXNVjgcDdiQGjhf0KFgBIzr1iiUJ0gHhiySs+zWu2K1B5u
   z+LIPKqDC2VgubOI7xDhHCBXTTm38tqjtDkJiyf0KcO11ZXus3NgR6w7m
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="340589663"
X-IronPort-AV: E=Sophos;i="5.99,277,1677571200"; 
   d="scan'208";a="340589663"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2023 08:48:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="731675824"
X-IronPort-AV: E=Sophos;i="5.99,277,1677571200"; 
   d="scan'208";a="731675824"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 15 May 2023 08:48:47 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 08:48:47 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 08:48:46 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 15 May 2023 08:48:46 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 15 May 2023 08:48:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l74XF8qoovh5Gtrdd+7duud+PRzc+G3vrHg8eDY+MwallEma0vLYq3ZvMwLTAjw0sNkH0Rp7vFd+4UCQI01QDN/6c1v9IayWcjHDkI04I3Z2im1vGG41qWj0lG8B7A7cXq9U8fFZFLvzDH2Mcfksr5wroNnV0rJssovHfXXpTpJ0w9u2Pt17XZU9cJO5Lk9Zo2m9SXp14Ss4PRrEQIkRnVBUylydxALMPyb9PpwRwkHmvgQjMAy8W2nQsBeo5RPiDN0V5VfwPIG+qsLdKQJkI6HNjQVfhdb/N227ST3L0KVqKWkBCtvwUxa40fbjhlHigULQZykdMnPe/LRG0oTYpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ssSIUrVPp5bcxQ9LaSoN0JHOXfX88KS7ReFe3w7ISlU=;
 b=lGyaFT8CgorlKLs360N4dzjBrMxORxhQ1k0/J24hRqCwJFtzB/MU/uvtJC95fxyJYS9dfu3urQcASMwvojQ8y+2bA+2DR03DKvt7iXO7xyPaFYdcv16ak4IcorL8LXRte8kK9M+uhaCostX0jWV7nP6nFHLnVpECRPBvsK7jbycLsonSOEfI70cb+bt3/ASMbWEbvwqdUNDSALIAmwFySCOJetHxrURATcE3klqFWXXNtthIZG/girOs24uj7LmRQVXDuuT2FpvxtYkkK6vN/Uo7RFCa/ZNUoJzcHgeZV7gyGKUgaWVFwow09O0gYSYsTH/WsNWafNIeOOvtsGarEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5471.namprd11.prod.outlook.com (2603:10b6:5:39d::10)
 by DM4PR11MB6480.namprd11.prod.outlook.com (2603:10b6:8:8d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Mon, 15 May
 2023 15:48:39 +0000
Received: from DM4PR11MB5471.namprd11.prod.outlook.com
 ([fe80::907c:ffaa:352a:8913]) by DM4PR11MB5471.namprd11.prod.outlook.com
 ([fe80::907c:ffaa:352a:8913%6]) with mapi id 15.20.6387.030; Mon, 15 May 2023
 15:48:39 +0000
Date: Mon, 15 May 2023 17:45:54 +0200
From: Larysa Zaremba <larysa.zaremba@intel.com>
To: Jesper Dangaard Brouer <jbrouer@redhat.com>
CC: Stanislav Fomichev <sdf@google.com>, <brouer@redhat.com>,
	<bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann
	<daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu
	<song@kernel.org>, Yonghong Song <yhs@fb.com>, John Fastabend
	<john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Jiri Olsa
	<jolsa@kernel.org>, Jesse Brandeburg <jesse.brandeburg@intel.com>, "Tony
 Nguyen" <anthony.l.nguyen@intel.com>, Anatoly Burakov
	<anatoly.burakov@intel.com>, Alexander Lobakin <alexandr.lobakin@intel.com>,
	Magnus Karlsson <magnus.karlsson@gmail.com>, Maryam Tahhan
	<mtahhan@redhat.com>, <xdp-hints@xdp-project.net>, <netdev@vger.kernel.org>,
	<intel-wired-lan@lists.osuosl.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND bpf-next 10/15] ice: Implement VLAN tag hint
Message-ID: <ZGJTsgmrvylUH9cY@lincoln>
References: <20230512152607.992209-1-larysa.zaremba@intel.com>
 <20230512152607.992209-11-larysa.zaremba@intel.com>
 <ZF6F+UQlXA9REqag@google.com>
 <ZGI2oDcWX+o9Ea0T@lincoln>
 <e4a9fa43-06f7-5271-effc-20cac59b0e64@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <e4a9fa43-06f7-5271-effc-20cac59b0e64@redhat.com>
X-ClientProxiedBy: FR3P281CA0117.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a3::8) To DM4PR11MB5471.namprd11.prod.outlook.com
 (2603:10b6:5:39d::10)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5471:EE_|DM4PR11MB6480:EE_
X-MS-Office365-Filtering-Correlation-Id: 62f2ab86-d7ab-4f9b-d0e2-08db555bd9db
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YRTQGirnJlopIJ7kKt8hTpwb/XGhNCdrfZjBwEpvCtsj7H6rK4MCfe+EfANmY1X3vkJGlh2ZRHX2f2toX4TSssz6V/JS9Iubg4kjX16cxZQpP7GyeRKs2yqkwKe5svZXrg5FRZz+3ur9M3NwhMilbOkHM+2xrBA19mM9cITmk+miFq0Foh1di0massZrJZ3RhESD+zKVCxx8pSOAi541fNaMJJACcqJuEvKty0qbhU6HntWrPnxHX2q2IVygAuqYM4kk6cjECXHOo80WHinoaj8DRVmwxspGhXleleFkErYdlJFhFs4yr1vlmiusx1qZusq/e9yxUyEXdNHjfitaF4fE8zIOzsqxwasNnTtg9zo4KV4pXv5z33+CwtW1QFVVPsmNozPKo23dN3v13G/bhG9ePiBzdec4mOCHXDrVKt/TQgLbtLiIgFjXqcuOszOLiDonIYnkz0+LUixWADawhMHZAPLHspWqZ5Y/PloRjTRv7ceChbr4tUizXM1QaHj9Dlz88TFqN+VTLN0xRm3Nuf9Gj1RBT6R5SBGhag9KroSLafuXWdfuitYGe2rVqThF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(366004)(376002)(39860400002)(396003)(346002)(451199021)(33716001)(83380400001)(66476007)(66556008)(9686003)(66946007)(6486002)(26005)(6506007)(6512007)(478600001)(54906003)(6666004)(7416002)(186003)(44832011)(86362001)(8676002)(8936002)(5660300002)(2906002)(41300700001)(4326008)(6916009)(316002)(82960400001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lc5vbAsLotNMDVYSysp/hJFv6ZPFc8zOK06mDJsB0GiJDvzRIiAuZX80Blu0?=
 =?us-ascii?Q?WNVvV6xLSG+gO/JwdjEFEYDFwR4ICl+DEcqeFvnwsy9q2NXFYEFFZkRSPXIG?=
 =?us-ascii?Q?GBKxK8XiynlVLQ2rJP3HgNRmafAgPCqfMJGICI8L2ih5OAX0fLylsDan9VxG?=
 =?us-ascii?Q?k1dO8XCuZgs0T2EomvFCKoCbeFPLn9PudC8BCzScxHM2Np7tnvfgE32PU+UK?=
 =?us-ascii?Q?bGiic294+wd3IemAo5QdVrP/I6278PHwGbs9x70I+ItnhYtHeWbvclFfsQw5?=
 =?us-ascii?Q?KqVFJCoetHGp49vztz32lpE3hnCwcLB4fsV/m5VcOljRdC0B3usSiNIphOM0?=
 =?us-ascii?Q?D/gvHh9wnr2G0f1lDCJYKfl+o53Sdno5gQBJbalnveIXVvFcf4W7zEIqkq/v?=
 =?us-ascii?Q?KOg2lksmxtXFn0VxhC/ZtlgTnBSJm/cdLgo85AE6cW8QDIsL7M/tczQA2LS5?=
 =?us-ascii?Q?1zL16o9uW4BixKg8GxCI7dDJn+Pbz7ylfD95q7Cem3eKmS6un8r6T53erixt?=
 =?us-ascii?Q?dwOsQliepBbsv/55Os71q08/cC48yis3yTBfxU7JSI/89cgjjbApGSLuYdKS?=
 =?us-ascii?Q?eRsAGIZ5lgCagyltYQEvYtT+odVKzXcS1DwT0vPOw8CJLXO0iCRdRVtSrGaI?=
 =?us-ascii?Q?VdBD9kDm2fVhJxb3CiQ5Ixaa5x8DHCD6S3jR89bKfuUCMPEvwdcLdVkfIJuo?=
 =?us-ascii?Q?v85+PwU4zXjs3dgIHYBvzpeKtK5HbW3gfhPefAd9rohFAulOdXYFaFdWtZnn?=
 =?us-ascii?Q?h6Zf038h1fyCABv13qEpOGbhsTI76pwfef8Gbc9z4bsLEQSRNmbrU3Xq4s5A?=
 =?us-ascii?Q?TcddSzm2ggaixx1BNn+Lh6QYqJQ7EVIL+mgb4er4FO4c55OX3+L7InUm4n7z?=
 =?us-ascii?Q?Qc2f/qp0U0U0H7F0NbssRrKR1d2nye9BmPJvKy8y5OJwFYwek4qSTTxsdEiO?=
 =?us-ascii?Q?c6K88gmOh7HQGOs96sK2PE3AWpmtyOhvQYN4rO3ioBDOtWrzFXjuvz6HKCl0?=
 =?us-ascii?Q?1ZLRPPG+NK3G7CHcbDyzbic5/vG0q673chYXzgiJanzh9eFiHbBQHdbbwOH7?=
 =?us-ascii?Q?qIpw54NpLtFWPadOyZDqfaUwmJqKbtO1poOLsEjwfyeiRZjZ5AW+nKYNJ0uu?=
 =?us-ascii?Q?Wca6vm6YpyT//wz5VFdeCwSJlIU6XQL38RV+uHsdImrOQA3HsVjTl+bcWOXJ?=
 =?us-ascii?Q?sJy0WsWNUipHxgSXz18WGqhTOYnKaIBR9ktRgwd86xDfUjAFy2k8o3mjkdPc?=
 =?us-ascii?Q?lcPhpSh9hV4dbLPgTl2hy5OGPMk6syO2IyASPwhd4hHuwE5FVzP8uIGbXh0L?=
 =?us-ascii?Q?tmj72elQyChb97u5Enlq0oxmvL03XDEtrlBULwvkD69gCWXiZolitxq0zd4H?=
 =?us-ascii?Q?vqGH+PJ1H+SSvTTZ4THJD9Q6TMb4CH27bPJEQIN1NnKXKNu6N2knW0SoEG5U?=
 =?us-ascii?Q?N1/TprUFjbJgpapHGqhY7bgjDmng8Qn66NsCuNMzSeqGp0eEtT4nVw+eSOGf?=
 =?us-ascii?Q?AkT2qoKWG1Wsf2DmfLqFTI7DwKzj5dbs/eczuXMY9Hjmy+zLkXcuksFYfmCD?=
 =?us-ascii?Q?lWG1sRYQf3Iiy1fP+Cdd8TgtD13bHKAMDdYlkzvlwuaSsgWWNK80YEKIuYk9?=
 =?us-ascii?Q?bg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 62f2ab86-d7ab-4f9b-d0e2-08db555bd9db
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2023 15:48:39.0948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0R1wj/BfqgVm3Z8S3Zah03D5gFWznzifLYEWABTcewMUXRJUTyl1UHtyb9KCcgR/7rTqV3QLDQq1NDHKj91Uuw/uuRUBf1cYz063BPNdtr0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6480
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 05:07:19PM +0200, Jesper Dangaard Brouer wrote:
> 
> 
> On 15/05/2023 15.41, Larysa Zaremba wrote:
> > > > +	*vlan_tag = ice_get_vlan_tag_from_rx_desc(xdp_ext->eop_desc);
> > > Should we also do the following:
> > > 
> > > if (!*vlan_tag)
> > > 	return -ENODATA;
> > > 
> > > ?
> > Oh, returning VLAN tag with zero value really made sense to me at the beginning,
> > but after playing with different kinds of packets, I think returning error makes
> > more sense. Will change.
> > 
> 
> IIRC then VLAN tag zero is also a valid id, right?

AFAIK, 0x000 is reseved and basically means "no vlan tag". When ice hardware 
returns such value in descriptor, it says "no vlan tag was stripped" and this 
doesn't necessarily mean there is no VLAN tag in the packet.

For example, let us consider a packet:

  Ether/802.1ad(s-tag)/802.1q(c-tag)/...

Hardware does not strip c-tag in such case and sends 0x000 in the descriptor, 
but packet clearly does contain a c-tag, so at least in ice, it is reasonable to
not consider '0' a reliable value.

I guess, for s-tag value of 0x000 should be more reliable, so maybe
'if (!*vlan_tag)' usage can be limited to c-tag function.

> 
> --Jesper
> 


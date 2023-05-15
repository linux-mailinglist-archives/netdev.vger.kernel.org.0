Return-Path: <netdev+bounces-2668-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 52F25702EBA
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 15:52:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A0081C20B55
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 13:52:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02366C8F8;
	Mon, 15 May 2023 13:52:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A3963CA;
	Mon, 15 May 2023 13:52:17 +0000 (UTC)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE0E9E6E;
	Mon, 15 May 2023 06:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684158736; x=1715694736;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=n7yllujFV9tpaRgSKf9uC3OwShqrAhg7NEMdAe9MCgQ=;
  b=g6tESjPkLMALRrYX909PscO31lXbxAWGFFTlC+C/ZRciWs0TVKYcZXws
   hWbfdLdozPJ0xFgzqbXcQsEakurWGOGssmdPmMqBAWUvaf/jk3trAO2rf
   JsCioDgAhfwumk6rojDTXeUIkfv4wRGy2SGwSh+CnLR+OZqPr8uq/m1v+
   LKgz7vbHH41z+AZd0lVVyUxA0O30a6DTjS789fxaHyyVFQYVGMdu0L/g9
   yYEPbkPJymIdR2azNCE+TumydiMVAvyxJopmqBg7ihgCNSLxBaUNIvcmu
   dWRTw6q2T/72lz3EfHfZhSuj/ij/Dm4vuMDwOpqh89yB/5gRTDTmToQzn
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="331574354"
X-IronPort-AV: E=Sophos;i="5.99,276,1677571200"; 
   d="scan'208";a="331574354"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2023 06:52:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="765936501"
X-IronPort-AV: E=Sophos;i="5.99,276,1677571200"; 
   d="scan'208";a="765936501"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 15 May 2023 06:52:15 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 06:52:14 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 15 May 2023 06:52:14 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 15 May 2023 06:52:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CJIC5sl6933oO6QRJEpIpdAq97rQndkIdPC7qUcG5uFJ5m4nJ+Bm2ui1zvMPAQu4kRDjY90YN0YAuj5Uw9ZC5gIVBuuoCvXDkx9fdNOjdXPzSvBZwkWQuOURxmIgPRfPHu8sFtQktyCx35i4qAkJSD1qskxrUn1oKVVaKuAOgYPkZQaZABK8VZfzu+nTY8Dcx7IukNJw2YCxBODiyzffAqBM8+m0NYhkCaN9w6EfzG0MdHcCzy6fl/xzPEzAPvuTaI9Dvi+Em4UL/XNSDghLKOdSAc/xFdf67p0i2hIkMeFZCtJ4xF1YAWHfWxGXZIO7fQ3FXol7H+T7i0E5Pg95SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pvx+i4VEzeLKTatwaIQU+GYJvDB5/nqzXAA3kH7G1rk=;
 b=H2H3tQRRrYvI7exnnsHmygWR/EKZyHpnMXGBOgYVJ1Y92Ggjz2oFCQBpwlS7pxfBnvXx8GkB/6gCKGalBuz3TULpvZTLuKqVR4n8R6iACI1nk2MS2WicF/8pFHJBzUYjowkl4fCqR7qrPxF/z+DHiKnnKeg7vvtMQACxjzsLlJfHenPbW2QntJCnj3wtnebEkHOKY8doIrJ29ple4Y6c/XYAvx5QcsLDKICrsGSQm1f239d1RdNU+0v4ySVMAoXZjijbqw8m/aVBYdhhub4VivoytsxBbN1VhPAjQOxKTWLRzPf2XBrf1snhFbfseI2/fMxKAvvdjf4BMvsobMepqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5471.namprd11.prod.outlook.com (2603:10b6:5:39d::10)
 by PH0PR11MB7494.namprd11.prod.outlook.com (2603:10b6:510:283::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.29; Mon, 15 May
 2023 13:52:10 +0000
Received: from DM4PR11MB5471.namprd11.prod.outlook.com
 ([fe80::907c:ffaa:352a:8913]) by DM4PR11MB5471.namprd11.prod.outlook.com
 ([fe80::907c:ffaa:352a:8913%6]) with mapi id 15.20.6387.030; Mon, 15 May 2023
 13:52:10 +0000
Date: Mon, 15 May 2023 15:49:29 +0200
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
Subject: Re: [PATCH RESEND bpf-next 11/15] xdp: Add checksum level hint
Message-ID: <ZGI4aS9UUdW4JwZ6@lincoln>
References: <20230512152607.992209-1-larysa.zaremba@intel.com>
 <20230512152607.992209-12-larysa.zaremba@intel.com>
 <ZF6GrXsA8L0THVFB@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZF6GrXsA8L0THVFB@google.com>
X-ClientProxiedBy: FR3P281CA0165.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a2::10) To DM4PR11MB5471.namprd11.prod.outlook.com
 (2603:10b6:5:39d::10)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5471:EE_|PH0PR11MB7494:EE_
X-MS-Office365-Filtering-Correlation-Id: 6488149f-5c8d-4d52-fc24-08db554b945f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: txeaj2X04LVyk6bqnVu3dSzOYjaA9boOLl87o+Cdrq3H38u6bXpZvlxRTzo8zgCHwfILdDXY4PsBJCLX+w2LAYVz7bq3hJuaWHeAXTEHBO/VckTO1QGc7Hv7hCyqffaDeWIYoy13dcEnj9Rmh6cUwVV3e1/06KAuJPZRoM89A4r1HfUCzL3SyTg/16rP9MBObyq6s3LnDM7k+zP9Z2EHcXJH51qtLe9U7ZANGQYI3JOhoYxOqwlJ0pk2QNvEm7tkIRK7GStQkODEy4kutkrDHaawo49xPJN4I3m9Rijpl14e4e26QtNeuV+stcTKcsBWYF51t8a0w8QxVnqsjwdwPX5tXNFivJX8R6B2Q3XGKDiwTZ/+W0KkWSDlyC0a8iYuTz0oSmEiCoNhrk+lBdENACsYNovWe1Lbf8Y97Vz5eM/XdKHiXJtg9dG6GIA4SZ806RO2ct0vsJBOquK2lPsHGhgEJRgtgb4zvaELtMRf94A5hLs5HdmRumNPt0zd3URASTkDDCLQSgix+oU98ul82MTtZexitBVOzCwOyPHu7e4ydc96VyqoF+VM+qdI8SaL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(39860400002)(396003)(366004)(346002)(136003)(376002)(451199021)(86362001)(54906003)(316002)(66476007)(4326008)(6916009)(66946007)(6486002)(66556008)(478600001)(2906002)(33716001)(8936002)(5660300002)(8676002)(41300700001)(44832011)(6666004)(7416002)(38100700002)(82960400001)(9686003)(186003)(26005)(6506007)(83380400001)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2sDWlbujWPUffVyiaE5BPmn3JBi/y4A1OgsczZpvEun3BzA5KW0OzVwduNpS?=
 =?us-ascii?Q?RbBjRs/iv2Jnr4Xr4zuBSx7okdzV3+HNASi94JFt0FTZ5YKtM0fwoLGJtceT?=
 =?us-ascii?Q?FnVXmhljXwOssnTlyFjUDaxKpnIvVOcom6GJzAZMgyvws0ZOO7KUNPHQPHTt?=
 =?us-ascii?Q?IjVQ6v8OyL+FUZsrpClOcBhPwe0cirIrvNMLMhC/nzDVB8BN1xMPWVMs5aqf?=
 =?us-ascii?Q?i+ESxXNJurnwPn4pUUwx/pw+9Lh2QaiuUvlVfgGe0WWxhK8U1FHOM77NNtlm?=
 =?us-ascii?Q?SvxjhUQs0lKyXv5OvGhw7ec/b0p5meHYfMpfkgCoMs+nq8Es4d92reI3WxPZ?=
 =?us-ascii?Q?4JWwprls7Ffmdb86yxsrKdhXsfgLUL4LpxY1G8SDAaXATLgu8Z8lQ95sgZE1?=
 =?us-ascii?Q?KdMd0wnnxT54dFfxxFEAraTFOyPdJD9DWqSHtoRd/i34ZlxFJ3AuWDiJi0dH?=
 =?us-ascii?Q?L2lsYtcxM6K5LM9OmXIUZGTNBUnwgZ/qtYDP8e+SHXDnGx9kyaID34nujhA1?=
 =?us-ascii?Q?Uj+qdIL9g0QN9/cYQ2lKolSONJa9nrQCfwigMbvH/3rqNmwzxtE4K/7alAzN?=
 =?us-ascii?Q?eY9P787NIGq4RfqdpyyjgZziW9Yry1TSV4WiAqDQf7c7MK3L8sc+WxbExhOM?=
 =?us-ascii?Q?2zAEZAOPZsTum58f5UjH10imhJkizmHrqB4rCPSz8iHAt5zfX8jdBo027Q5T?=
 =?us-ascii?Q?cJakS1fACw3uCn2RPV5/9J+4gUB2ePxJJaeveGqmzKjzMo7gD8cQ/2vcoc3o?=
 =?us-ascii?Q?2Za62H0Sq8kvldU0qSJ0QrluLLuAMdOPk2/cRQWFtS2VIir3wQEwuTpVXzz6?=
 =?us-ascii?Q?mE/RGVUzO+uV9hR03rcRmxloHT8k4jf9YvUbm4+n0QGRjgAaaLU0zndBaT99?=
 =?us-ascii?Q?PHOsWfNU6/5tJWG1fwEbrudFXhajwjVxOugoqi/EQX/EzpfzYXnwL0r0+YyV?=
 =?us-ascii?Q?b+ERCOnxN10b9rLXZUkTgpyhm5HH+xVRZNRJHBHGvxFHrVx+CYYiU1uYorFK?=
 =?us-ascii?Q?6BeTdHSs7goPOneY3zZaoJNZpGIfZWkpE5wPDuV0lyT1DEZLkDBqNISPkG7h?=
 =?us-ascii?Q?m6do7MqrrNNb+z1ZRr12dqj3mle5ewHJg9htmMwMOPue0KSu+Cdkg+kIImfE?=
 =?us-ascii?Q?Be/rsL6pDePNX+EiHXVjCBl00ADh8HoQxk/QvV1ppulGg4Jo/ph1+fEA25/k?=
 =?us-ascii?Q?70bj02QRQc/c90ORURSt6W9AFqeABLxHWxJLhohYr8It85RqJA8HaLQIUhgl?=
 =?us-ascii?Q?LDZq31l/nU6b+rk9mk2KhfUpRSyJAuaDatGatqsNhbqhAWXzlCzUyusrPy9x?=
 =?us-ascii?Q?0QdnldTQkecdLtxgtHtYY1W8ntK6eT/w6NLESfHAXhq0MLWagGb0e3nRdwR+?=
 =?us-ascii?Q?+3nWupIhnQaiVE/HmBoZ21zVQ6OMY1yDdy52T0DoQmsEveTaX5smXJEDrKrN?=
 =?us-ascii?Q?RmcZbfKFbzXeLCTfcds/ZLik5u049Vkv+hjzvedpxu1vC1BIaBOmy1HD44As?=
 =?us-ascii?Q?9GARcAsS/I9kXUhYjH5+QDZ2ZtkZnSqZRNwHHowzXbUzveK1URThJwzMOuJN?=
 =?us-ascii?Q?0Clsy2HgTVj3FctoJBOJariWLX4GZKONXCK3cTKusEh4WhuT60j6n6pMicq2?=
 =?us-ascii?Q?Ig=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6488149f-5c8d-4d52-fc24-08db554b945f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2023 13:52:10.6010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dhUlJP/UxbM8+27KVBAfD1htHNsI8M51up/58XFRiS37raiSPqBL5jUykHWp9hU1UgAgjccGPbgsbjsRPWhmmCmY3IOJC9mpHAFZaqotVfc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7494
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 12, 2023 at 11:34:21AM -0700, Stanislav Fomichev wrote:
> On 05/12, Larysa Zaremba wrote:
> > Implement functionality that enables drivers to expose to XDP code,
> > whether checksums was checked and on what level.
> > 
> > Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
> > ---
> >  Documentation/networking/xdp-rx-metadata.rst |  3 +++
> >  include/linux/netdevice.h                    |  1 +
> >  include/net/xdp.h                            |  2 ++
> >  kernel/bpf/offload.c                         |  2 ++
> >  net/core/xdp.c                               | 12 ++++++++++++
> >  5 files changed, 20 insertions(+)
> > 
> > diff --git a/Documentation/networking/xdp-rx-metadata.rst b/Documentation/networking/xdp-rx-metadata.rst
> > index 73a78029c596..f74f0e283097 100644
> > --- a/Documentation/networking/xdp-rx-metadata.rst
> > +++ b/Documentation/networking/xdp-rx-metadata.rst
> > @@ -29,6 +29,9 @@ metadata is supported, this set will grow:
> >  .. kernel-doc:: net/core/xdp.c
> >     :identifiers: bpf_xdp_metadata_rx_stag
> >  
> > +.. kernel-doc:: net/core/xdp.c
> > +   :identifiers: bpf_xdp_metadata_rx_csum_lvl
> > +
> >  An XDP program can use these kfuncs to read the metadata into stack
> >  variables for its own consumption. Or, to pass the metadata on to other
> >  consumers, an XDP program can store it into the metadata area carried
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index fdae37fe11f5..ddade3a15366 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -1657,6 +1657,7 @@ struct xdp_metadata_ops {
> >  			       enum xdp_rss_hash_type *rss_type);
> >  	int	(*xmo_rx_ctag)(const struct xdp_md *ctx, u16 *vlan_tag);
> >  	int	(*xmo_rx_stag)(const struct xdp_md *ctx, u16 *vlan_tag);
> > +	int	(*xmo_rx_csum_lvl)(const struct xdp_md *ctx, u8 *csum_level);
> >  };
> >  
> >  /**
> > diff --git a/include/net/xdp.h b/include/net/xdp.h
> > index 2db7439fc60f..0fbd25616241 100644
> > --- a/include/net/xdp.h
> > +++ b/include/net/xdp.h
> > @@ -393,6 +393,8 @@ void xdp_attachment_setup(struct xdp_attachment_info *info,
> >  			   bpf_xdp_metadata_rx_ctag) \
> >  	XDP_METADATA_KFUNC(XDP_METADATA_KFUNC_RX_STAG, \
> >  			   bpf_xdp_metadata_rx_stag) \
> > +	XDP_METADATA_KFUNC(XDP_METADATA_KFUNC_RX_CSUM_LVL, \
> > +			   bpf_xdp_metadata_rx_csum_lvl) \
> >  
> >  enum {
> >  #define XDP_METADATA_KFUNC(name, _) name,
> > diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
> > index 2c6b6e82cfac..8bd54fb4ac63 100644
> > --- a/kernel/bpf/offload.c
> > +++ b/kernel/bpf/offload.c
> > @@ -852,6 +852,8 @@ void *bpf_dev_bound_resolve_kfunc(struct bpf_prog *prog, u32 func_id)
> >  		p = ops->xmo_rx_ctag;
> >  	else if (func_id == bpf_xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_STAG))
> >  		p = ops->xmo_rx_stag;
> > +	else if (func_id == bpf_xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_CSUM_LVL))
> > +		p = ops->xmo_rx_csum_lvl;
> >  out:
> >  	up_read(&bpf_devs_lock);
> >  
> > diff --git a/net/core/xdp.c b/net/core/xdp.c
> > index eff21501609f..7dd45fd62983 100644
> > --- a/net/core/xdp.c
> > +++ b/net/core/xdp.c
> > @@ -762,6 +762,18 @@ __bpf_kfunc int bpf_xdp_metadata_rx_stag(const struct xdp_md *ctx, u16 *vlan_tag
> >  	return -EOPNOTSUPP;
> >  }
> >  
> > +/**
> > + * bpf_xdp_metadata_rx_csum_lvl - Get depth at which HW has checked the checksum.
> > + * @ctx: XDP context pointer.
> > + * @csum_level: Return value pointer.
> 
> Let's maybe clarify what the level means here? For example, do we start
> counting from 0 or 1?

Sure, I'll add a comment that the meaning of level is the same as in skb, 
counting from 0.

> 
> > + *
> > + * Returns 0 on success (HW has checked the checksum) or ``-errno`` on error.
> > + */
> > +__bpf_kfunc int bpf_xdp_metadata_rx_csum_lvl(const struct xdp_md *ctx, u8 *csum_level)
> > +{
> > +	return -EOPNOTSUPP;
> > +}
> > +
> >  __diag_pop();
> >  
> >  BTF_SET8_START(xdp_metadata_kfunc_ids)
> > -- 
> > 2.35.3
> > 


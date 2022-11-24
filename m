Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1B39637CC0
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 16:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbiKXPTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 10:19:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbiKXPTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 10:19:02 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A4BC171C9E;
        Thu, 24 Nov 2022 07:17:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669303040; x=1700839040;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=66Pyz5TRCHSWKX156wQfGGTEWP/5BiKx9/Er3DAnG50=;
  b=QfgnbM7ls/aJzxhQL8F+C0zNRQGs73zQaNMzEisMJ+Hu3oevnr/K2oV3
   EttRSz5fo4vwER3CjGkpFx8DRUFEyl0arjbOnK+/FUIVddzXG63TOXli0
   /u+DaquX27AD/xEvmUQLMU/CvkgriodNC9Hkxm+A7ZBDENh/a8kjTBoll
   qUnmOeBVH66/xZuhVv8tM/R6g2ASlQZ5hBtHBQ7jtkURCVEe1vCjKxVCZ
   5sF/qpGOHbjIzcFIpD96iiEdjaWQxNB8uo7sr28w2MJlSyHH0Vrl5Negj
   jys0SBPG9oPIlUcS3fU3VFWoItBa/96/wKVZgvubmq6xPTGelzB0BZEo3
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="301883192"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="301883192"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 07:17:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="644522619"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="644522619"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 24 Nov 2022 07:17:19 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 24 Nov 2022 07:17:19 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 07:17:18 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 24 Nov 2022 07:17:18 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 24 Nov 2022 07:17:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n+pII0wkG6x97BpHeavHOE+C7wEJCtqwXdDUd+bi1VKABBecigu3lK2Gx4BLKjcAi09YGM2/+rVAuYlHxTbE8vymdVxV6+hZNfqkbk+oLMwe1aoL/m6rmy9E4hOcVRrv2y/5z97f7IgPxdlxwaRrv27985Pke63IU1WxiZg4ZvSH6t+36Cai4p9ZQdIzcYnVrxenTF57ttStNP1/H/ypGGv56qVzSFMZR7J14l58jjJKKyYWm/m8atjqbpBxED/OLiUCxhYGZgHtnPD1aSkEUx2NCaIqDcLjJyjMbRjEuPfZ6dbXFFtwsp9z8wCHjGD+IVXzLihXm2t26NwTLeonnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cDz0jIcTuAKeOfVQCnedE4NHl8Jj8fiehI7Ov0Gnpbo=;
 b=J8eZcjxeM3aqkIKqqZmHkr6FtrpmuCxWK8ezUqUijJeiv3F3lzQ+MZ6ZitNndcehtSwK9h3/MmYnJdFHB/ICmvTTj7NW3PmZspQYnRWyOkFU8TvOa2vCSTGOhjyzc3w8+DqBGVRy5AWZNyzv+xlvorspYvU8L5ORLnpY0bnL9vgi0h2t0PU1AM8fAc3rzGGLeRJHgoDHcHGBQElB8k+Q5mPcoDnOcf60WWHvA+wetiuJyViMqRMe1A9SK5lK/t4MTgR30y8d7cQnHoLMkOsIvFSKEEaHI178TfwkfJMWLpWcej0XHB2Vt6no2h+NKkwJvZmQqTeIcs9Yo3MTRy3hEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 CO6PR11MB5569.namprd11.prod.outlook.com (2603:10b6:303:139::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Thu, 24 Nov
 2022 15:17:16 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6%6]) with mapi id 15.20.5834.009; Thu, 24 Nov 2022
 15:17:16 +0000
Date:   Thu, 24 Nov 2022 16:17:01 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
CC:     Jakub Kicinski <kuba@kernel.org>, <sdf@google.com>,
        <bpf@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <andrii@kernel.org>, <martin.lau@linux.dev>, <song@kernel.org>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <haoluo@google.com>, <jolsa@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        "Jesper Dangaard Brouer" <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>,
        <xdp-hints@xdp-project.net>, <netdev@vger.kernel.org>
Subject: Re: [xdp-hints] Re: [PATCH bpf-next v2 6/8] mlx4: Introduce
 mlx4_xdp_buff wrapper for xdp_buff
Message-ID: <Y3+K7dJLFX7gRQp+@boxer>
References: <20221121182552.2152891-1-sdf@google.com>
 <20221121182552.2152891-7-sdf@google.com>
 <874jupviyc.fsf@toke.dk>
 <CAKH8qBuF_1UoUPzh_X6FMrJ61zCNDroqSuc-Pp2uH7Q4azmN8Q@mail.gmail.com>
 <20221123111431.7b54668e@kernel.org>
 <Y3557Ecr80Y9ZD2z@google.com>
 <871qptuyie.fsf@toke.dk>
 <20221123174746.418920e5@kernel.org>
 <87edts2z8n.fsf@toke.dk>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87edts2z8n.fsf@toke.dk>
X-ClientProxiedBy: LO6P265CA0015.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:339::8) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|CO6PR11MB5569:EE_
X-MS-Office365-Filtering-Correlation-Id: 2bf3162e-ddb2-4010-62b9-08dace2ef8eb
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DVGRHk8RWPf+TJhMRos5dqjNjeJaXfTG3zHOhidVtu/EdAVU2yWSxLEKOB14SH39Je0K+Hlh5mjEdOAwCSThZpf7Es0EYW8sCJONQCLez1nKwGgL6wn1kiu2hbEwV7W5yKjNr7xMBsr7PLZZzk+MCpG5PgE478FYXa5Y3yQQOXMVZ1RK79l//9yRj6YexLC0FH4gLXSA6U3gMvx9Vyii2YHn8wDLForuTWJYAWiDoLfRXQYTj0jd/+ooR83052JbevgMRU21KqSGWcqXgq9sZ9TiMu3oPwkLRqPwjUb5vG8xzqop5naqniobg91e5G2sVrA2+apha5Y0oSWZlVnKUAZKBwmFpbT6mU4HunqwSXEiAi0px18adgqMgZT4MFXgEhKc8gsWJrCzBEwvAHOAr6z5ORH562wo7czKktBRxFyUZwEdfhsNJh6fhoZ0/rBY2O2jHnrsKl2qRKTw8LUOgwfzoeVDxscRI7/pZYYGhH/wQMt3I31zOa9sU8CNZFw4aGEz252STRgHpemAmHOWBNKXV8CZbJfWQAk4aPZ6xtSxzwIgC3LfbvIpmADAq4LDW7W4OhPvZZN7YKF8VTZ1xbx8/LdzCLHRVViWtH2WAM2QCMfc0+PRujMQd/xE1Oy+qiLtPBG/PokGb+Qia6MULA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(366004)(396003)(136003)(376002)(346002)(39860400002)(451199015)(38100700002)(186003)(82960400001)(41300700001)(83380400001)(33716001)(5660300002)(7416002)(8936002)(66574015)(2906002)(44832011)(26005)(6666004)(478600001)(6486002)(9686003)(316002)(6512007)(86362001)(6916009)(54906003)(66476007)(66556008)(8676002)(4326008)(66946007)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?P9LGP3I9YX9RfVbJi3XsajiGYNp/GGDMUso0xXzj2BZzDULX9sxY98rKO4?=
 =?iso-8859-1?Q?TeaBCpvsmEvDjtLTbEoZQqzNtTNSgp/zoyvkqfg3P3gs9RrFDT8WwUcfLc?=
 =?iso-8859-1?Q?ZJdlsFRAQJ00DBwbdHGrIZx0Yt8BAWnHYfQEjoge1N+4pscEHTyysN6LH+?=
 =?iso-8859-1?Q?puEOdKDM33dsmp17IVQqJ5QUQIaeyQ3ioT7FkOwEwEpt3MLavM89AiJl3j?=
 =?iso-8859-1?Q?qDVemrvUpmwDxunukNPRYuGzeNKq3az6Y3dqcpshJ6HmWGDreT4e/i/SYV?=
 =?iso-8859-1?Q?WZHnm9FF5QhUS/rWDYbYiQ0j0/kGTgAs0ExgfiGei6QyYKVLnOVuHefNhW?=
 =?iso-8859-1?Q?DYReJ9QSsAZcJ+eEOYGvhX7C9wDKRrYuK+O7APW+ADQ1gGtzLIiv/E+It0?=
 =?iso-8859-1?Q?i6AapNWMDODvIfVvcFjS49QA4siz0qJ1pTge8kw/V920545K6XYyXGfxm2?=
 =?iso-8859-1?Q?ZtpBeiXVJy2r9L4cSBElyATcWxHS3gouKycpTTxGnis53RhyEx9kov+MT3?=
 =?iso-8859-1?Q?J77RFbUtaKQFtRjDVDl3HIIwW7vdxDGr1ETT8WzcUTwSodwC6FVXDAhPku?=
 =?iso-8859-1?Q?w9mrNjNc70L55utvBDRUErNpybxmF0XRg/LRMKUFZlUSk/I/MR4poTdZ9v?=
 =?iso-8859-1?Q?4GMa2gOIIGk+qWpGyjcEpkp2EMiE98+3VE7BpNxaB2CCsNu4SDmmpIcC/h?=
 =?iso-8859-1?Q?Y+b8Mm1S038tmq//eG0JhKte14xk13dWwdnzCyX8tgBejSwuZxnkYURQfA?=
 =?iso-8859-1?Q?0ydq50CyRaYC/Zi01DG83y2VCB+pNAd7EXp/Qr2637z/1kkiujQa4rWNt3?=
 =?iso-8859-1?Q?91APhcymL/2tAP3uQpowg4q6SE4lxFqJFUxTCPcJeCGJ8b7ODc24L1Oe21?=
 =?iso-8859-1?Q?DXSHatvwf++5ZVy+MhVAaRNRr0cMSt+tsLL9ilLtNS9Y+77yNU4Up/jp97?=
 =?iso-8859-1?Q?mOyiIvxqVmV2dhX2j3Vt9N5C2va3hjprr15XyQ1wbYWxFb1Xc9BAxwoTEZ?=
 =?iso-8859-1?Q?nsWTXWwOaj1zfIaNpY+FQMXTGHiIcwQCb/UB+NBvOmu51PVKkP98goFKc/?=
 =?iso-8859-1?Q?jsuGP8V2Yxz57QdrEVwGIvcVcpA6/jHU5orC/BYM5EpcfS1s9IxrbznbL2?=
 =?iso-8859-1?Q?IfdfNic6KLQUJELy4KxPW2hqAOJpYPKzf82tNTEpfqsqPkSDk8ucEdbWxT?=
 =?iso-8859-1?Q?MXmaMGIKebeyY7i6uwsP2OWYH+wQhYCPbOcGhFYTi8q+beM6NYElV+CI5u?=
 =?iso-8859-1?Q?IgZMAVQLnEtiQoabMXf/VfKR744FlwlSHxFYI9d2JLas70LIu752ZFQuWz?=
 =?iso-8859-1?Q?m68qBXR1lF+i7rDVyjb0puzOa6UBgajV1eacIQBiJf3cu+4G7YAgsH6fhp?=
 =?iso-8859-1?Q?U3Q46EumtXAtPPAZp5FuL0n7a2L6K1eWb+qMuQ5kHZQbzELoL5C4BRtXEf?=
 =?iso-8859-1?Q?2VVTL7QclxFJdRzySimdsBHmOtir7I20h4KxLpA0DH4SkUn+PjtH/PxcDp?=
 =?iso-8859-1?Q?sF+yk04s+o4RPzxXEP4NSXyKqkUf9BpAbPiYGUY59PZ6tcYgl3WNvZ5I7o?=
 =?iso-8859-1?Q?l8ErnXwnG22LWrI/hv/Wyn4RfJi1++zZnVH036TABMEwvA6a6meqpGkwjH?=
 =?iso-8859-1?Q?iU+8NRjZqXn56pJpeSiL/XFCO34DH/egMTl62147A+g514yRaP8m/Jag?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bf3162e-ddb2-4010-62b9-08dace2ef8eb
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2022 15:17:16.7589
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mo8ZoZ6dWMbadvHlNclNzfw+sA/oX/UalDw93l9bzt2PB9V3gE2emMeXcsQaxd1aYnk5cfC0OdYLNbPm4Gx3p1agBOjpf6cdMTmTvqc82Qo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR11MB5569
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 24, 2022 at 03:39:20PM +0100, Toke Høiland-Jørgensen wrote:
> Jakub Kicinski <kuba@kernel.org> writes:
> 
> > On Wed, 23 Nov 2022 22:55:21 +0100 Toke Høiland-Jørgensen wrote:
> >> > Good idea, prototyped below, lmk if it that's not what you had in mind.
> >> >
> >> > struct xdp_buff_xsk {
> >> > 	struct xdp_buff            xdp;                  /*     0    56 */
> >> > 	u8                         cb[16];               /*    56    16 */
> >> > 	/* --- cacheline 1 boundary (64 bytes) was 8 bytes ago --- */  
> >> 
> >> As pahole helpfully says here, xdp_buff is actually only 8 bytes from
> >> being a full cache line. I thought about adding a 'cb' field like this
> >> to xdp_buff itself, but figured that since there's only room for a
> >> single pointer, why not just add that and let the driver point it to
> >> where it wants to store the extra context data?
> >
> > What if the driver wants to store multiple pointers or an integer or
> > whatever else? The single pointer seems quite arbitrary and not
> > strictly necessary.
> 
> Well, then you allocate a separate struct and point to that? Like I did
> in mlx5:
> 
> 
> +	struct mlx5_xdp_ctx mlctx = { .cqe = cqe, .rq = rq };
> +	struct xdp_buff xdp = { .drv_priv = &mlctx };
> 
> but yeah, this does give an extra pointer deref on access. I'm not
> really opposed to the cb field either, I just think it's a bit odd to
> put it in struct xdp_buff_xsk; that basically requires the driver to
> keep the layouts in sync.
> 
> Instead, why not but a cb field into xdp_buff itself so it can be used
> for both the XSK and the non-XSK paths? Then the driver can just
> typecast the xdp_buff into its own struct that has whatever data it
> wants in place of the cb field?

Why can't you simply have a pointer to xdp_buff in driver specific
xdp_buff container which would point to xdp_buff that is stack based (or
whatever else memory that will back it up - I am about to push a change
that makes ice driver embed xdp_buff within a struct that represents Rx
ring) for XDP path and for ZC the pointer to xdp_buff that you get from
xsk_buff_pool ? This would satisfy both sides I believe and would let us
keep the same container struct.

struct mlx4_xdp_buff {
	struct xdp_buff *xdp;
	struct mlx4_cqe *cqe;
	struct mlx4_en_dev *mdev;
	struct mlx4_en_rx_ring *ring;
	struct net_device *dev;
};

(...)

	struct mlx4_xdp_buff mxbuf;
	struct xdp_buff xdp;

	mxbuf.xdp = &xdp;
	xdp_init_buff(mxbuf.xdp, priv->frag_info[0].frag_stride, &ring->xdp_rxq);

Also these additional things

+			mxbuf.cqe = cqe;
+			mxbuf.mdev = priv->mdev;
+			mxbuf.ring = ring;
+			mxbuf.dev = dev;

could be assigned once at a setup time or in worse case once per NAPI. So
maybe mlx4_xdp_buff shouldn't be stack based?

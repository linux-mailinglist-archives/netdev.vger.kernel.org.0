Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F31DC6C2F6B
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 11:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbjCUKsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 06:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbjCUKsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 06:48:52 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E4D49DF;
        Tue, 21 Mar 2023 03:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679395724; x=1710931724;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Xl2syY+G+JuTjvyZKe+P3qbG3njnsDqaJEXoU0lYe0I=;
  b=Wzabd+7vvl65ukD829ZJOg6882VWSQ0naZuV/PmcT4Z8MHTX3eo0w/nV
   QmUD8hMs0yPhjJL735FmV5RhUpcaFsZWEJK8j8kLyxl8bfVXCZdor0gqr
   nFpz2qTYI1HA0544o12e6broFohmqsVaSAbByo+iRSojjtpdO/kcQLKjy
   udxaHJ8RPCwvJIWAD5twSFoJVDJdhmPjH2k6rGvDNi4OmZpSmgJ5s/uUH
   tiBDu1Z4c9bDaBHJ5x9rbfxVvuzosayRYN7ENePLQPs+I2uCZkuwQBvgz
   HofeLMgYGkUXN8tjXFEx1wilxpstGb2OCHuuhQRLckF4vV1UUBk7EJCrm
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="401476589"
X-IronPort-AV: E=Sophos;i="5.98,278,1673942400"; 
   d="scan'208";a="401476589"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 03:48:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="792034836"
X-IronPort-AV: E=Sophos;i="5.98,278,1673942400"; 
   d="scan'208";a="792034836"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 21 Mar 2023 03:48:43 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 21 Mar 2023 03:48:43 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 21 Mar 2023 03:48:43 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 21 Mar 2023 03:48:42 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.49) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 21 Mar 2023 03:48:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=du5B3Pk0HlEJNN9MxJg/zHREEKbHK03OO2f5nt1WbLNKog9rBKyXuzhcv5CCAjzWiCTbDdpmQLC2DXcOwqTXnwRlOYuTqHDtrB68RTe96f0cyvSGTH9rXpOArCZ2RIewfXR96Dg5nLzUePHTKnn/23n6N+1ut+VSNjWNCYUJydvmHq1XO/Z+IiFEevI+jqb7kPKy6fZeDGX0GZIhbtOVakt3W8j/ToYbNJvo4RLhq6it2+oqO2S4dW67nabJO2zuKNpVFobaYx3f3gkm4sP+gmmjCioFQo0nUlrdVRSJCnz/AAOZou8FZmOtiQPlqhNZF6fT4APXANRp7PAphsGsFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DAHhfJVWAmTCcuLXHGa/D8B6wntS8pS+IiinVB1Dg9U=;
 b=YH2ewkHPluDyCeKgxKDxktCwZp6Zgo3ISAxn0WC0xWRmCWyUE5HzHelQy1K3KgX0uU7I8fHrvRQGTjSrXHi0mAKxfk3dcZew7K/JZJ0wknxX9XfPmOh6S8QYI5Db9Tk268F+QCvBR5TYGwSjUR8L8XcduvQ94+Jg2WZUVGYMK/md+6KNsGGRwJSQd0NKE8y0fZUBYh1WvrKdRVmrcHD3HbwZdtjKXW+L+JaNt/hdR337q3+VzRy59XhQJD8rgJNsmh7vDW6T4Ur8lSNNxiz0Tf8GDDNdsOjN1ZEXCTjPxKHfX2V29GCcSW7+DJrMCUqfkQgHG1ECicU0+jdDkDNQ3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 PH0PR11MB4918.namprd11.prod.outlook.com (2603:10b6:510:31::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.37; Tue, 21 Mar 2023 10:48:40 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::dbd:99dd:96d:3ab3]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::dbd:99dd:96d:3ab3%7]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 10:48:40 +0000
Date:   Tue, 21 Mar 2023 11:48:27 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Kal Conley <kal.conley@dectris.com>
CC:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/3] xsk: Support UMEM chunk_size > PAGE_SIZE
Message-ID: <ZBmLe27KrmXp7Qfc@boxer>
References: <20230319195656.326701-1-kal.conley@dectris.com>
 <20230319195656.326701-2-kal.conley@dectris.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230319195656.326701-2-kal.conley@dectris.com>
X-ClientProxiedBy: FR3P281CA0079.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1f::7) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|PH0PR11MB4918:EE_
X-MS-Office365-Filtering-Correlation-Id: 4fb3f145-be98-4c3b-d1f6-08db29f9d4e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1UrVY3uw6DjKlRLiGTkEspnsREl+ywoGX7tTDWbi7LDGaxKa+h8ISTY6WBlV87at93EFWGp15ITBQ7dvTm3tyZELHJPDO/exV0QKTVdzKIJIW7HEwUvV7ZF+RL4x/FWPKJl3wLeUnVcWycCbIJ2bgHZ8/vRHj54l2b6A/lN7q3+xC598rmeyUSr+tlke0ab81rFdtmh2Q+MfmAsNw3GLNJLw9GFzZ2xQe4LDN85xz6jJ/8qJ6sqNSs0CFdUH+kJHxSxbL2Bnm3U4YRWxW7C1Dwcqh3nLu1ZSpIyNwLpNiDsW0PJFTyLUV2bRQovzDxjzibbgq8uULp4J2HEMVu5mM6kZo6cYrWenCN8moHfQg8fGupml2AAOLpvVp6UozVpgiAxcUpTyNIKdwmmk7Ujsyvl6hSFLGSODcA4qxsknvUsiu+CGRrxM6zkHz6X9DT+eKGGHgTKrh9B2PmHvIxg+Mn2zJ97EwV5guSQ0pkp64qzGhEdP9b6o/4J887fNzstIyGuqnew1NpbeMhFa65FRANQbvxgMwsIR0gCute4LPxScXXJEEAMt60BgNlKdvlqgOrNQzLTqNkRNmqf10AWbgAobkEYrVdc9p0/H3wC3YRLAIcicbgtN2qvh9xvu0uTIqbCbxN314kcdObvsnAdwJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(346002)(396003)(376002)(39860400002)(136003)(366004)(451199018)(8676002)(4326008)(41300700001)(66556008)(66476007)(6916009)(82960400001)(2906002)(44832011)(66946007)(38100700002)(8936002)(5660300002)(86362001)(6506007)(33716001)(6666004)(26005)(6486002)(9686003)(186003)(7416002)(54906003)(6512007)(83380400001)(478600001)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D9nlPMR8VWDYlUjPGuGV0qNSXgVs5oWSQzpXz/7hGtkg+cqDAx3j8OepX/p+?=
 =?us-ascii?Q?2YImDnsjnn6gxZ1xuDXk56Wdl+rd22NlOuRM/iVZVNBe1iYBHWsb8mBqwTsZ?=
 =?us-ascii?Q?PpWTnpiyoyqmF5bWnhz7Knfxx/tpeRoYxuOFnvFlbMPp+RWeEHGxAdjTj6px?=
 =?us-ascii?Q?WBlAMgWiECR//uRPOFXOaozD7Cr9X3KYB0TASZK+EZJv+4qLbTv/NyRBzgae?=
 =?us-ascii?Q?O2lBBv/Z36YP/r1eEFlY5ZBr+QrIFqgq97iLEmf6HnKRkHazSUbij4qo1uL0?=
 =?us-ascii?Q?B4+47dqXYOS2dLMQuAcMk3AMdBo/bNPDB/raBeaPV2vCzD4Xn8jt+L7C3bT4?=
 =?us-ascii?Q?NnYhZYTUNVQbM4+1QCGp+S4ZSXltz5YiphKiqYLsJ+Nsvhw2tTBQY1ltVsdR?=
 =?us-ascii?Q?eVjPfN3kXFJF05KD36+jbIno1pYGRcT5kPQT88xpqYlwjp510uSE13oJ/WHp?=
 =?us-ascii?Q?gH+E3IsdzwSuyakGS+gzbntkdxuENaEqjfdycRSCoK8wgEdmd1Rt9ysLCno/?=
 =?us-ascii?Q?DPhrmDBHHmDFTaPKJZ7nwMoZPbxnVuHlllHvpTNjxbPqJTZRNkUyb75/B8GB?=
 =?us-ascii?Q?nNErw5yC2sKTegoNug/vlaes4ZRSxKOHziBhErfEjMiq+AmS2vFGvZbQ301a?=
 =?us-ascii?Q?d+Up10AJUp+eEgzYgKd++xQ9flkuBkzCcxr1Rhq4PZIlFR8wLH3IHxpFn8xZ?=
 =?us-ascii?Q?GlzWgyljabB74ILdSsKHH1YZkFuVrsnMm4saPmW9mTiMH75hPZ0t9V9m0R5u?=
 =?us-ascii?Q?8GWnDjbYVv5hsMQJZSHgQHb624cUbqQMrCRB8iys7dhLhG4E7W4Nel55BMfD?=
 =?us-ascii?Q?mEfqs12U0QrXD80bA8hrIwXYJxjRF9ZUfYTMhgWHFyABHeEG8SIuxV78PBeU?=
 =?us-ascii?Q?VLjJA/qLyH1bEjZh0M93J48JZy9Z69nXGwxfsTZjz7pLhhC8hXoIPz4xQ5jC?=
 =?us-ascii?Q?Fivvkj+hwXhj0lB+jrHAG2ilOA8p/VbhqyHj0gD6bc1JVgtzVnQVuHrX3tbQ?=
 =?us-ascii?Q?zVM/FhLXCaOs0FHk4Dl5J2WQ7ZnW7WsE0Ux6xnGCvswYGy+UWoDuWjIF74I7?=
 =?us-ascii?Q?BHVtnF8XRMQeA02ONhCrSKmJiyS+PYP+TlC/7ZbnXap+WPMijRY0EroGgljo?=
 =?us-ascii?Q?2jGv123SQ1vfXkqwWSk1Nita+893W533hE3nlmiCN/FHe28/Hu2egsqHcALc?=
 =?us-ascii?Q?fF/gunAKxoIGbz762ROYfkze3xaPZ7cz8aXGIUXLebvbToun2x91ud433yn3?=
 =?us-ascii?Q?n9Xd59povnl5SfWapFoialrO0gtrXHGIbhJPNiFy6IpnoZY2hEuU9D88ih8g?=
 =?us-ascii?Q?mA6Amw9vQYg2Up2r512NQIJs8WYxkOyTR5MPNdhMvlDNtS75LsztXX2UoaAP?=
 =?us-ascii?Q?GUniZXb06Xv0e/8/xe8Jxuetd8Tl1DhkY+8XnTRESf7wdpRyTmg3xS2ZGc8Q?=
 =?us-ascii?Q?CUHj5P6r9jzc7isvBJ1g/gcT7Crdk2D0UiPc/N7N42mXuUgkY4AUN2OghyCV?=
 =?us-ascii?Q?ylFI/OSLrCZZ/lFYUSnZYK3ibXpsorbIwVQf9D2dsrzWpuiy5GdlNhVHLDsH?=
 =?us-ascii?Q?8H1KolIbgKI+ILXCJktIvf5yxWjS1g8h1g7wwZj/rQ/lF6WauvAYVQXOEFpF?=
 =?us-ascii?Q?Rcv5GWm3FCIhrJRm1cwu4rs=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fb3f145-be98-4c3b-d1f6-08db29f9d4e6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 10:48:40.0736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sp3TPZSiNC4WqtkPTm/iIyeKZBCUmeJpubyHN/a15+qxezGWM8G7LMhR2AOXIZsbKHbVsVgIq8WGNfztCAoNNa964N+Un9tJX0GIMMHCBVQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4918
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 19, 2023 at 08:56:54PM +0100, Kal Conley wrote:
> Add core AF_XDP support for chunk sizes larger than PAGE_SIZE. This
> enables sending/receiving jumbo ethernet frames up to the theoretical
> maxiumum of 64 KiB. For chunk sizes > PAGE_SIZE, the UMEM is required
> to consist of HugeTLB VMAs (and be hugepage aligned). Initially, only
> XDP_COPY mode is usuable pending future driver work.
> 
> For consistency, check for HugeTLB pages during UMEM registration. This
> implies that hugepages are required for XDP_COPY mode despite DMA not
> being used. This restriction is desirable since it ensures user software
> can take advantage of future driver support.
> 
> Even in HugeTLB mode, continue to do page accounting using order-0
> (4 KiB) pages. This minimizes the size of this change and reduces the
> risk of impacting driver code. Taking full advantage of hugepages for
> accounting should improve XDP performance in the general case.
> 
> No significant change in RX/TX performance was observed with this patch.
> A few data points are reproduced below:
> 
> Machine : Dell PowerEdge R940
> CPU     : Intel(R) Xeon(R) Platinum 8168 CPU @ 2.70GHz
> NIC     : MT27700 Family [ConnectX-4]

can you tell us a bit more about your environment setup - from what i can
tell mlx4 does not support xdp multi-buffer, so you were testing this
feature with XDP program attached in generic mode?

if you were using xdpsock -S or xdpsock -c? or maybe even something
different?

what was your MTU size on NIC?

> 
> +-----+------------+-------------+---------------+
> |     | frame size | packet size | rxdrop (Mpps) |
> +-----+------------+-------------+---------------+
> | old |       4000 |         320 |          15.7 |
> | new |       4000 |         320 |          15.8 |
> +-----+------------+-------------+---------------+
> | old |       4096 |         320 |          16.4 |
> | new |       4096 |         320 |          16.3 |
> +-----+------------+-------------+---------------+
> | new |       9000 |         320 |           6.3 |
> | new |      10240 |        9000 |           0.4 |
> +-----+------------+-------------+---------------+
> 
> Signed-off-by: Kal Conley <kal.conley@dectris.com>
> ---
>  include/net/xdp_sock.h      |  1 +
>  include/net/xdp_sock_drv.h  |  6 +++++
>  include/net/xsk_buff_pool.h |  4 +++-
>  net/xdp/xdp_umem.c          | 46 +++++++++++++++++++++++++++++--------
>  net/xdp/xsk.c               |  3 +++
>  net/xdp/xsk_buff_pool.c     | 16 +++++++++----
>  6 files changed, 61 insertions(+), 15 deletions(-)
> 
> diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
> index 3057e1a4a11c..e562ac3f5295 100644
> --- a/include/net/xdp_sock.h
> +++ b/include/net/xdp_sock.h
> @@ -28,6 +28,7 @@ struct xdp_umem {
>  	struct user_struct *user;
>  	refcount_t users;
>  	u8 flags;
> +	bool hugetlb;
>  	bool zc;
>  	struct page **pgs;
>  	int id;
> diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
> index 9c0d860609ba..eb630d17f994 100644
> --- a/include/net/xdp_sock_drv.h
> +++ b/include/net/xdp_sock_drv.h
> @@ -12,6 +12,12 @@
>  #define XDP_UMEM_MIN_CHUNK_SHIFT 11
>  #define XDP_UMEM_MIN_CHUNK_SIZE (1 << XDP_UMEM_MIN_CHUNK_SHIFT)
>  
> +/* Allow chunk sizes up to the maximum size of an ethernet frame (64 KiB).
> + * Larger chunks are not guaranteed to fit in a single SKB.
> + */
> +#define XDP_UMEM_MAX_CHUNK_SHIFT 16
> +#define XDP_UMEM_MAX_CHUNK_SIZE (1 << XDP_UMEM_MAX_CHUNK_SHIFT)
> +
>  #ifdef CONFIG_XDP_SOCKETS
>  
>  void xsk_tx_completed(struct xsk_buff_pool *pool, u32 nb_entries);
> diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
> index 3e952e569418..69e3970da092 100644
> --- a/include/net/xsk_buff_pool.h
> +++ b/include/net/xsk_buff_pool.h
> @@ -78,6 +78,7 @@ struct xsk_buff_pool {
>  	u8 cached_need_wakeup;
>  	bool uses_need_wakeup;
>  	bool dma_need_sync;
> +	bool hugetlb;
>  	bool unaligned;
>  	void *addrs;
>  	/* Mutual exclusion of the completion ring in the SKB mode. Two cases to protect:
> @@ -175,7 +176,8 @@ static inline void xp_dma_sync_for_device(struct xsk_buff_pool *pool,
>  static inline bool xp_desc_crosses_non_contig_pg(struct xsk_buff_pool *pool,
>  						 u64 addr, u32 len)
>  {
> -	bool cross_pg = (addr & (PAGE_SIZE - 1)) + len > PAGE_SIZE;
> +	bool cross_pg = pool->hugetlb ? (addr & (HPAGE_SIZE - 1)) + len > HPAGE_SIZE :
> +					(addr & (PAGE_SIZE - 1)) + len > PAGE_SIZE;
>  
>  	if (likely(!cross_pg))
>  		return false;
> diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
> index 02207e852d79..c96eefb9f5ae 100644
> --- a/net/xdp/xdp_umem.c
> +++ b/net/xdp/xdp_umem.c
> @@ -10,6 +10,7 @@
>  #include <linux/uaccess.h>
>  #include <linux/slab.h>
>  #include <linux/bpf.h>
> +#include <linux/hugetlb_inline.h>
>  #include <linux/mm.h>
>  #include <linux/netdevice.h>
>  #include <linux/rtnetlink.h>
> @@ -19,6 +20,9 @@
>  #include "xdp_umem.h"
>  #include "xsk_queue.h"
>  
> +_Static_assert(XDP_UMEM_MIN_CHUNK_SIZE <= PAGE_SIZE);
> +_Static_assert(XDP_UMEM_MAX_CHUNK_SIZE <= HPAGE_SIZE);
> +
>  static DEFINE_IDA(umem_ida);
>  
>  static void xdp_umem_unpin_pages(struct xdp_umem *umem)
> @@ -91,7 +95,26 @@ void xdp_put_umem(struct xdp_umem *umem, bool defer_cleanup)
>  	}
>  }
>  
> -static int xdp_umem_pin_pages(struct xdp_umem *umem, unsigned long address)
> +/* Returns true if the UMEM contains HugeTLB pages exclusively, false otherwise.
> + *
> + * The mmap_lock must be held by the caller.
> + */
> +static bool xdp_umem_is_hugetlb(struct xdp_umem *umem, unsigned long address)
> +{
> +	unsigned long end = address + umem->npgs * PAGE_SIZE;
> +	struct vm_area_struct *vma;
> +	struct vma_iterator vmi;
> +
> +	vma_iter_init(&vmi, current->mm, address);
> +	for_each_vma_range(vmi, vma, end) {
> +		if (!is_vm_hugetlb_page(vma))
> +			return false;
> +	}
> +
> +	return true;
> +}
> +
> +static int xdp_umem_pin_pages(struct xdp_umem *umem, unsigned long address, bool hugetlb)
>  {
>  	unsigned int gup_flags = FOLL_WRITE;
>  	long npgs;
> @@ -102,8 +125,17 @@ static int xdp_umem_pin_pages(struct xdp_umem *umem, unsigned long address)
>  		return -ENOMEM;
>  
>  	mmap_read_lock(current->mm);
> +
> +	umem->hugetlb = IS_ALIGNED(address, HPAGE_SIZE) && xdp_umem_is_hugetlb(umem, address);
> +	if (hugetlb && !umem->hugetlb) {
> +		mmap_read_unlock(current->mm);
> +		err = -EINVAL;
> +		goto out_pgs;
> +	}
> +
>  	npgs = pin_user_pages(address, umem->npgs,
>  			      gup_flags | FOLL_LONGTERM, &umem->pgs[0], NULL);
> +
>  	mmap_read_unlock(current->mm);
>  
>  	if (npgs != umem->npgs) {
> @@ -152,20 +184,14 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
>  {
>  	bool unaligned_chunks = mr->flags & XDP_UMEM_UNALIGNED_CHUNK_FLAG;
>  	u32 chunk_size = mr->chunk_size, headroom = mr->headroom;
> +	bool hugetlb = chunk_size > PAGE_SIZE;
>  	u64 addr = mr->addr, size = mr->len;
>  	u32 chunks_rem, npgs_rem;
>  	u64 chunks, npgs;
>  	int err;
>  
> -	if (chunk_size < XDP_UMEM_MIN_CHUNK_SIZE || chunk_size > PAGE_SIZE) {
> -		/* Strictly speaking we could support this, if:
> -		 * - huge pages, or*
> -		 * - using an IOMMU, or
> -		 * - making sure the memory area is consecutive
> -		 * but for now, we simply say "computer says no".
> -		 */
> +	if (chunk_size < XDP_UMEM_MIN_CHUNK_SIZE || chunk_size > XDP_UMEM_MAX_CHUNK_SIZE)
>  		return -EINVAL;
> -	}
>  
>  	if (mr->flags & ~XDP_UMEM_UNALIGNED_CHUNK_FLAG)
>  		return -EINVAL;
> @@ -215,7 +241,7 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
>  	if (err)
>  		return err;
>  
> -	err = xdp_umem_pin_pages(umem, (unsigned long)addr);
> +	err = xdp_umem_pin_pages(umem, (unsigned long)addr, hugetlb);
>  	if (err)
>  		goto out_account;
>  
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 2ac58b282b5e..3899a2d235bb 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -421,6 +421,9 @@ static void xsk_destruct_skb(struct sk_buff *skb)
>  	sock_wfree(skb);
>  }
>  
> +/* Chunks must fit in the SKB `frags` array. */
> +_Static_assert(XDP_UMEM_MAX_CHUNK_SIZE / PAGE_SIZE <= MAX_SKB_FRAGS);
> +
>  static struct sk_buff *xsk_build_skb_zerocopy(struct xdp_sock *xs,
>  					      struct xdp_desc *desc)
>  {
> diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
> index b2df1e0f8153..777e8a38a232 100644
> --- a/net/xdp/xsk_buff_pool.c
> +++ b/net/xdp/xsk_buff_pool.c
> @@ -80,6 +80,7 @@ struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
>  	pool->headroom = umem->headroom;
>  	pool->chunk_size = umem->chunk_size;
>  	pool->chunk_shift = ffs(umem->chunk_size) - 1;
> +	pool->hugetlb = umem->hugetlb;
>  	pool->unaligned = unaligned;
>  	pool->frame_len = umem->chunk_size - umem->headroom -
>  		XDP_PACKET_HEADROOM;
> @@ -369,16 +370,23 @@ void xp_dma_unmap(struct xsk_buff_pool *pool, unsigned long attrs)
>  }
>  EXPORT_SYMBOL(xp_dma_unmap);
>  
> -static void xp_check_dma_contiguity(struct xsk_dma_map *dma_map)
> +/* HugeTLB pools consider contiguity at hugepage granularity only. Hence, all
> + * order-0 pages within a hugepage have the same contiguity value.
> + */
> +static void xp_check_dma_contiguity(struct xsk_dma_map *dma_map, bool hugetlb)
>  {
> +	u32 page_size = hugetlb ? HPAGE_SIZE : PAGE_SIZE;
> +	u32 n = page_size >> PAGE_SHIFT;
>  	u32 i;
>  
> -	for (i = 0; i < dma_map->dma_pages_cnt - 1; i++) {
> -		if (dma_map->dma_pages[i] + PAGE_SIZE == dma_map->dma_pages[i + 1])
> +	for (i = 0; i + n < dma_map->dma_pages_cnt; i++) {
> +		if (dma_map->dma_pages[i] + page_size == dma_map->dma_pages[i + n])
>  			dma_map->dma_pages[i] |= XSK_NEXT_PG_CONTIG_MASK;
>  		else
>  			dma_map->dma_pages[i] &= ~XSK_NEXT_PG_CONTIG_MASK;
>  	}
> +	for (; i < dma_map->dma_pages_cnt; i++)
> +		dma_map->dma_pages[i] &= ~XSK_NEXT_PG_CONTIG_MASK;
>  }
>  
>  static int xp_init_dma_info(struct xsk_buff_pool *pool, struct xsk_dma_map *dma_map)
> @@ -441,7 +449,7 @@ int xp_dma_map(struct xsk_buff_pool *pool, struct device *dev,
>  	}
>  
>  	if (pool->unaligned)
> -		xp_check_dma_contiguity(dma_map);
> +		xp_check_dma_contiguity(dma_map, pool->hugetlb);
>  
>  	err = xp_init_dma_info(pool, dma_map);
>  	if (err) {
> -- 
> 2.39.2
> 

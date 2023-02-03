Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50E43689285
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 09:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbjBCIoP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 03:44:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231905AbjBCIoN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 03:44:13 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1AFE206B9;
        Fri,  3 Feb 2023 00:44:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675413852; x=1706949852;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=nnBEHZ+VrB3cMUcTsA2EXcxV56GRtAPg/J9Xqc3405U=;
  b=dyslIOm+h+hOs985vixFSkunhDBHLqqZQlz5Li4TaXR3CvqK34ASLx6h
   8uSCLnd/GuEXS57LlbSnmpb2uV+ueJ76MS3zcvz6RY7mfOD2HceQTP7Oh
   zT9lvLk5fyETjxb3teab60mmTV1X9tMaX2MWaOGSEoDwTNikRzik0Q5Kq
   /WWZEnip3qDeY891ck7rQtKC77QIMpRDozlKjiObv8nhxcxJkro7/7zkv
   7yq2Y4o741JEPisWuqcvrYGiYoq6drHG7T8pMQQicB2tHUtqU2ukAJC1g
   mRykMOzMEP3PHrG7sgK/jGDveuguDJu7XXyjF1IxLlScZQnFa2fn/Ndqc
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="312351682"
X-IronPort-AV: E=Sophos;i="5.97,269,1669104000"; 
   d="scan'208";a="312351682"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2023 00:44:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="729196853"
X-IronPort-AV: E=Sophos;i="5.97,269,1669104000"; 
   d="scan'208";a="729196853"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga008.fm.intel.com with ESMTP; 03 Feb 2023 00:44:11 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 3 Feb 2023 00:44:11 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 3 Feb 2023 00:44:10 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 3 Feb 2023 00:44:10 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 3 Feb 2023 00:44:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HWtznQp54n9wiYcIySdeyAlbZCCuyX5YwFEwOoocy9S7bMl0BhnoN/uOJ0aBg75QAsI46rhcpUT3fPT2clchP1hHdUakyV8nY5bzNOXk1hch9t+xVXmWv0ZG2QLZR2Rvux0vZubZiR7Xf9EQDFbstdRIPcg9cysToRQrdswnJ6rAOxt9DC9WQDH86wzLnPXrgd07AC/XPguiybX+8MOi3HcmTM4rkw0yDmYa38kEY3z4r1e2n6PhFujO0QJZUpVSfHM7yWmi2MUTSU1rE+z3bEsQTaeveQ/j1VKCsX479jgr4QDwHnoBIA29eCg20CrNvtZ/NvOBomrlB1Ykjk7ltA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cSVfYTHgfDwLd2QgJJoQHLfECbM5U850G//y+ENcpmQ=;
 b=SAuROkfxPWplvO7euSgZjYQYfHS9jUMDnc/eAWcj8kEAOyJvybsxJGX03gd9wj4ryZFI/c+D3yJC4+oqeuKhrZl+A2w++RZnTekhTDRMldFYMGp/T1R9co7dENI47j6GYicuDnvGad9UICbv9m2o+yz7+vS5zqu4mHdUcEm/KJxQ0TPSiOIsStecw1MluJoaqab7swvwoa+gcMI9oqYNxXFDoegkTyeTqZr4ZOqkViwNRUWMLLI8khMYdrbEmMwqLPkC7OomnXxC11jC0zK5EKg+jbwHvb/VAXzg5w0AuaJSpUJ5lvJvfuq/GU8fdRcHaxusZHn1DVeUIlE0K6K4Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 DS0PR11MB8135.namprd11.prod.outlook.com (2603:10b6:8:155::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.38; Fri, 3 Feb 2023 08:44:04 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146%6]) with mapi id 15.20.5986.019; Fri, 3 Feb 2023
 08:44:04 +0000
Date:   Fri, 3 Feb 2023 09:43:55 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
CC:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        "Kuniyuki Iwashima" <kuniyu@amazon.com>,
        Petr Machata <petrm@nvidia.com>,
        <virtualization@lists.linux-foundation.org>, <bpf@vger.kernel.org>
Subject: Re: [PATCH 32/33] virtio_net: xsk: rx: introduce add_recvbuf_xsk()
Message-ID: <Y9zJS+ugeY9qEMt9@boxer>
References: <20230202110058.130695-1-xuanzhuo@linux.alibaba.com>
 <20230202110058.130695-33-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230202110058.130695-33-xuanzhuo@linux.alibaba.com>
X-ClientProxiedBy: LO4P265CA0080.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bd::10) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|DS0PR11MB8135:EE_
X-MS-Office365-Filtering-Correlation-Id: e59f4811-a6b1-435c-5383-08db05c2cdda
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O9IJ5sFwcYi1vPgWtuRDlSkMNlYbc2PXIrR+zrEBxJIPcdnzwAtfo+v+p8DJlXf39HbPYXp/+6PHgoXozaAxL0mBLNKrUsQszF4C5DSoJoCxBnjdubLbeySUz/dsWamI+4rsAIHcdcY8LL7iv+BcXd5FmA5esrGTtyi2lKumAIpQ3Td4LCYDg2jtXbMh3k7ETXMcrRrsW/na3y27vMB7Xg+QJvN8kZxTjVTrZa+zsxTa2uXEVWIXjxVBJ4nV6B6JHK793J6ydUPfn7YftigupdvCC4WEH0mRvr3OJ6/mRnKtam37u48VekAUSGfmxOmd8GIMj3iPFQADGGBjq2eibxPM87+B+EUjimVxavuUlphZt7MaScOieYRcqLFwLo/KSp4ASyVcSaaO6Xnr8d51mAkAk8uO59vVTLq5Ehw1Dw1ons4L8OfVNyGVfHQR7BsVxUAx9AQ8bhCQxFEALUO04TZkmAOnUE81YVCmLeR4tpQ0rP4yENehhcBg/pUxUlF1kk8NtFmW6jIlPQ5mo6k6B9K7v0UaIQ7SfHZNJbWcKEX8xHfRFVzl7mU//VC2ipqKIfcmDqrn6Ab1wMS//lWBi+RYVkzgDJUlWAEIG/iLUFu927qQVRhA0UXwCKlFGAl7w1aWrjE7aJ2AXANRSz1RiPY6YmqVYbGAYO9lIQDMriGwCF/FOdAYuTB08SF2VXMm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(346002)(39860400002)(376002)(136003)(396003)(366004)(451199018)(44832011)(7416002)(2906002)(5660300002)(38100700002)(33716001)(86362001)(54906003)(82960400001)(6506007)(26005)(6512007)(478600001)(186003)(8676002)(66556008)(6486002)(316002)(66946007)(9686003)(6916009)(66476007)(83380400001)(6666004)(4326008)(41300700001)(8936002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DOy6jdprZe4wjv5IOWmEo1PwF/xv2skXiwRQoOauPcl7th14v/KzjflkYYmX?=
 =?us-ascii?Q?ip+KnwyITvZ0XMHRwuuHop6D4G+RoYJgRp0itVE+0PW/a1xwPQKiq3GmDHEY?=
 =?us-ascii?Q?2ADGe75RQkj133H4n6SXQvC7wCRYm8LkYlQBQyvBu3xd/rBr+uhfBV4CJ8p+?=
 =?us-ascii?Q?8KNExFH6RGavudX+XOEfiOr4XCx+ShJOjucn2quaQoZUZjrI/NS98ZeCORB+?=
 =?us-ascii?Q?FxdL+kFG9KFsfVFgBKCNFHP9fj7PX1s8visy4tKxeS7hpkQPp48ao3ltgUjR?=
 =?us-ascii?Q?kj5baGLBqyIYH3onyNPxbur9HOUNi2ZiSRcwR20sQa6e29i/o1HlaX5lIdXu?=
 =?us-ascii?Q?kj37lUxEQlr4ydgdDEcmJl/PKv67158gkrETiHiTss1hkXX3ts8cjUJaooJB?=
 =?us-ascii?Q?5F7qbzK4JZItLBrePYEA1Hf5+ZeRkClnVOMY1LSzHzVoOzcHYB3nrJpOPgdz?=
 =?us-ascii?Q?vDVYOPAJKt7/Au0ddoRzaSQGhD+vNdizhWsE6k6gMNMw3hx9junqYkeBlhcU?=
 =?us-ascii?Q?oRFdYz+7Xf+cwJJygvzXu9GLnPsiQ5XAa/g/e2ZCpwNuJhUU56wQyg/1qENg?=
 =?us-ascii?Q?0/AyRCuD+sON6W/hztDGUJ0i83LYx/k0T12bt+b9gxB9USga9dCq7ief9QcA?=
 =?us-ascii?Q?x37VvpnDZ1cnVEgVT3vZlRUXO231mHacTnVHTd5Lf11gAijC6F3nUuQTw/Rw?=
 =?us-ascii?Q?Rkox52YMCRWSQIrq8JbyQpMt8hApZZDOxa5FFt36iP7f+uu4ERazRAyj7SDj?=
 =?us-ascii?Q?8l3f/qiVTFuoQWXTPFoDRiwoJTDSsEOjKxUb8qDTqO0nDvt208FRZfLeM/X3?=
 =?us-ascii?Q?iKauKKg6XEXK/znjbcUl2aaltnXfsrdlJZuaxIx/8Z1IPB7SiVzlshT1qFj2?=
 =?us-ascii?Q?KROEzpVLsd2Ib85OdWEPiUCCX4vfC+TgxaVLW8MafsJvcTAJlZaDVC1KtCfe?=
 =?us-ascii?Q?GwCX5WfSspbmwcXevO/VFs+SCNuiawQ6wwW+UwPfodCUcl4sdvkSlB0nohSe?=
 =?us-ascii?Q?3nHZ0Nza5dQW/5Gju554aAXUkQ9JhcSMEBwO36i0m0wNK66V2obLlahDmi4M?=
 =?us-ascii?Q?YUyfbsDRS+JPCUUdgRqJqC+0A+Bqv68d2MOSZjue+hKiGr1kw0oZv+pGrau5?=
 =?us-ascii?Q?aPFyeKr8AqfUiUpuh5K5KFwvQwSHZm07+J4i58EuRWWmnyh1gUJClec7kpL/?=
 =?us-ascii?Q?MVpQ+oP+alK47tXMVx8mQL57KCkiipPo8YRVZiNocPcQR08zAKDR+g50mE13?=
 =?us-ascii?Q?WEw98CVWKl1QZCc6QIkEFDggNksZuTujCiwnHovApi/G3P9kgMD/S6gJwZRl?=
 =?us-ascii?Q?xuQx8iQSO32mZSHw1DUj7z+5hvcgX+Fl1X4k1x8mGbsN6WuHOyZuWLXgMXbS?=
 =?us-ascii?Q?Yy6Li863ByM5Fi6gjHOMyWEruzoohLdm6T+rHHXKNcSAf7Aq9BwN94KSXBcz?=
 =?us-ascii?Q?nEW4pAyJhPmH/NwQOZ2r+8IAn/3opeQ/AjVBFKoMNJshe9o7Xbn1oiJ73epR?=
 =?us-ascii?Q?8BUoVbBKskmm1nR1Byni1J5cysGQbvp8Ffr8q3hRF8zP8t4OP0s8j4n/ObK2?=
 =?us-ascii?Q?6h1LNhcuYocPZs7N4IEgD9vhzYKV8gywDnuDSH3XUF2V3bkFDh11+glAs9Q2?=
 =?us-ascii?Q?FXxtUYOxqYXTfUXkMcrkxik=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e59f4811-a6b1-435c-5383-08db05c2cdda
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 08:44:04.0832
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iLCa9zMwfcdM2AFZOx9O/gMvcFGCxvoN9jA3vxULF8bbOKff+6/Sx9Xr5JWnLQW3kj6PSPPuZY82JY2mznEdHo+VewsmNwzA1ppQqrApedM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8135
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 07:00:57PM +0800, Xuan Zhuo wrote:
> Implement the logic of filling vq with XSK buffer.
> 
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  drivers/net/virtio/main.c | 11 +++++++++++
>  drivers/net/virtio/xsk.c  | 26 ++++++++++++++++++++++++++
>  drivers/net/virtio/xsk.h  |  2 ++
>  3 files changed, 39 insertions(+)
> 
> diff --git a/drivers/net/virtio/main.c b/drivers/net/virtio/main.c
> index 7259b27f5cba..2aff0eee35d3 100644
> --- a/drivers/net/virtio/main.c
> +++ b/drivers/net/virtio/main.c
> @@ -1352,10 +1352,20 @@ static int add_recvbuf_mergeable(struct virtnet_info *vi,
>   */
>  bool try_fill_recv(struct virtnet_info *vi, struct receive_queue *rq, gfp_t gfp)
>  {
> +	struct xsk_buff_pool *pool;
>  	int err;
>  	bool oom;
>  
>  	do {
> +		rcu_read_lock();
> +		pool = rcu_dereference(rq->xsk.pool);
> +		if (pool) {
> +			err = add_recvbuf_xsk(vi, rq, pool, gfp);
> +			rcu_read_unlock();
> +			goto check;
> +		}
> +		rcu_read_unlock();
> +
>  		if (vi->mergeable_rx_bufs)
>  			err = add_recvbuf_mergeable(vi, rq, gfp);
>  		else if (vi->big_packets)
> @@ -1363,6 +1373,7 @@ bool try_fill_recv(struct virtnet_info *vi, struct receive_queue *rq, gfp_t gfp)
>  		else
>  			err = add_recvbuf_small(vi, rq, gfp);
>  
> +check:
>  		oom = err == -ENOMEM;
>  		if (err)
>  			break;
> diff --git a/drivers/net/virtio/xsk.c b/drivers/net/virtio/xsk.c
> index 043b0bf2a5d7..a5e88f919c46 100644
> --- a/drivers/net/virtio/xsk.c
> +++ b/drivers/net/virtio/xsk.c
> @@ -37,6 +37,32 @@ static void virtnet_xsk_check_queue(struct send_queue *sq)
>  		netif_stop_subqueue(dev, qnum);
>  }
>  
> +int add_recvbuf_xsk(struct virtnet_info *vi, struct receive_queue *rq,
> +		    struct xsk_buff_pool *pool, gfp_t gfp)
> +{
> +	struct xdp_buff *xdp;
> +	dma_addr_t addr;
> +	u32 len;
> +	int err;
> +
> +	xdp = xsk_buff_alloc(pool);

same question as on tx side -anything stopped you from using batch API -
xsk_buff_alloc_batch() ?

> +	if (!xdp)
> +		return -ENOMEM;
> +
> +	/* use the part of XDP_PACKET_HEADROOM as the virtnet hdr space */
> +	addr = xsk_buff_xdp_get_dma(xdp) - vi->hdr_len;
> +	len = xsk_pool_get_rx_frame_size(pool) + vi->hdr_len;
> +
> +	sg_init_table(rq->sg, 1);
> +	sg_fill_dma(rq->sg, addr, len);
> +
> +	err = virtqueue_add_inbuf_premapped(rq->vq, rq->sg, 1, xdp, gfp);
> +	if (err)
> +		xsk_buff_free(xdp);
> +
> +	return err;
> +}
> +
>  static int virtnet_xsk_xmit_one(struct send_queue *sq,
>  				struct xsk_buff_pool *pool,
>  				struct xdp_desc *desc)
> diff --git a/drivers/net/virtio/xsk.h b/drivers/net/virtio/xsk.h
> index f90c28972d72..5549143ef118 100644
> --- a/drivers/net/virtio/xsk.h
> +++ b/drivers/net/virtio/xsk.h
> @@ -24,4 +24,6 @@ int virtnet_xsk_pool_setup(struct net_device *dev, struct netdev_bpf *xdp);
>  bool virtnet_xsk_xmit(struct send_queue *sq, struct xsk_buff_pool *pool,
>  		      int budget);
>  int virtnet_xsk_wakeup(struct net_device *dev, u32 qid, u32 flag);
> +int add_recvbuf_xsk(struct virtnet_info *vi, struct receive_queue *rq,
> +		    struct xsk_buff_pool *pool, gfp_t gfp);
>  #endif
> -- 
> 2.32.0.3.g01195cf9f
> 

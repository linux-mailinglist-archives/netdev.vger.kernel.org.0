Return-Path: <netdev+bounces-11960-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D476735707
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 14:42:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C59552810FB
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 12:42:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB424C8DC;
	Mon, 19 Jun 2023 12:42:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3EF33DC;
	Mon, 19 Jun 2023 12:42:02 +0000 (UTC)
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B1F91;
	Mon, 19 Jun 2023 05:41:59 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=hengqi@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VlXETWq_1687178514;
Received: from localhost(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VlXETWq_1687178514)
          by smtp.aliyun-inc.com;
          Mon, 19 Jun 2023 20:41:55 +0800
Date: Mon, 19 Jun 2023 20:41:54 +0800
From: Heng Qi <hengqi@linux.alibaba.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: netdev@vger.kernel.org, bpf@vger.kernel.org,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH net-next 4/4] virtio-net: remove F_GUEST_CSUM check for
 XDP loading
Message-ID: <20230619124154.GC74977@h68b04307.sqa.eu95>
References: <20230619105738.117733-1-hengqi@linux.alibaba.com>
 <20230619105738.117733-5-hengqi@linux.alibaba.com>
 <20230619071347-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230619071347-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 19, 2023 at 07:16:20AM -0400, Michael S. Tsirkin wrote:
> On Mon, Jun 19, 2023 at 06:57:38PM +0800, Heng Qi wrote:
> > Lay the foundation for the subsequent patch
> 
> which subsequent patch? this is the last one in series.
> 
> > to complete the coexistence
> > of XDP and virtio-net guest csum.
> > 
> > Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
> > Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
> >  drivers/net/virtio_net.c | 4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> > 
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 25b486ab74db..79471de64b56 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -60,7 +60,6 @@ static const unsigned long guest_offloads[] = {
> >  	VIRTIO_NET_F_GUEST_TSO6,
> >  	VIRTIO_NET_F_GUEST_ECN,
> >  	VIRTIO_NET_F_GUEST_UFO,
> > -	VIRTIO_NET_F_GUEST_CSUM,
> >  	VIRTIO_NET_F_GUEST_USO4,
> >  	VIRTIO_NET_F_GUEST_USO6,
> >  	VIRTIO_NET_F_GUEST_HDRLEN
> 
> What is this doing? Drop support for VIRTIO_NET_F_GUEST_CSUM? Why?

guest_offloads[] is used by the VIRTIO_NET_CTRL_GUEST_OFFLOADS_SET
command to switch features when XDP is loaded/unloaded.

If the VIRTIO_NET_F_CTRL_GUEST_OFFLOADS feature is negotiated:
1. When XDP is loaded, virtnet_xdp_set() uses virtnet_clear_guest_offloads()
to automatically turn off the features in guest_offloads[].

2. when XDP is unloaded, virtnet_xdp_set() uses virtnet_restore_guest_offloads()
to automatically restore the features in guest_offloads[].

Now, this work no longer makes XDP and _F_GUEST_CSUM mutually
exclusive, so this patch removed the _F_GUEST_CSUM from guest_offloads[].

> This will disable all of guest offloads I think ..

No. This doesn't change the dependencies of other features on
_F_GUEST_CSUM. Removing _F_GUEST_CSUM here does not mean that other
features that depend on it will be turned off at the same time, such as
_F_GUEST_TSO{4,6}, F_GUEST_USO{4,6}, etc.

Thanks.

> 
> 
> > @@ -3522,10 +3521,9 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
> >  	        virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO6) ||
> >  	        virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_ECN) ||
> >  		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_UFO) ||
> > -		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_CSUM) ||
> >  		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_USO4) ||
> >  		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_USO6))) {
> > -		NL_SET_ERR_MSG_MOD(extack, "Can't set XDP while host is implementing GRO_HW/CSUM, disable GRO_HW/CSUM first");
> > +		NL_SET_ERR_MSG_MOD(extack, "Can't set XDP while host is implementing GRO_HW, disable GRO_HW first");
> >  		return -EOPNOTSUPP;
> >  	}
> >  
> > -- 
> > 2.19.1.6.gb485710b


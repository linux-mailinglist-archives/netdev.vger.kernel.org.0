Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCBB6893BB
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 10:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232661AbjBCJaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 04:30:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232203AbjBCJa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 04:30:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D65D15CB0
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 01:29:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675416589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bNds1HI1I/0dpuSXz+oY0DFaA+4gCa4y5cBoLVvC84g=;
        b=cuAtLAewThZyS81gZkEZ7iH3uOnsYf2loYctixZd+wum6bLISpsWiiwaf8S9HDsEJvb01o
        UkAyiTwAkTZquysaoslWSMTX4GqjGuoJE+NSZKXUs+UuXZ++luALkweOHaqmCd8b6ZG1+L
        VevIf5a247nEgcg34yo9ix4pYuzPNz0=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-156-FwAkCIbdPKmroz1qcWIUOQ-1; Fri, 03 Feb 2023 04:29:48 -0500
X-MC-Unique: FwAkCIbdPKmroz1qcWIUOQ-1
Received: by mail-ed1-f72.google.com with SMTP id ec37-20020a0564020d6500b004a94daceb81so854568edb.18
        for <netdev@vger.kernel.org>; Fri, 03 Feb 2023 01:29:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bNds1HI1I/0dpuSXz+oY0DFaA+4gCa4y5cBoLVvC84g=;
        b=raCnvJy2XJcDvP1/N/s42oZ+6aYcZm7jk43VkIGadY3lqs4Hu580aViEcGmNILS1ge
         BcwV/5rregzfNJIQrxULaAtxAuBRVsQCKsvPWLom8DIbuo+F5QFozvgIom83q7WuIHso
         Z7Um6mHPsleTYjiyibWU2auCUxfPg6BJ+ui8DX7Yl5AWT//l8YL9W5b0i5E1EdZg4dbP
         zomj1jt+lUe84Az6OZSdemBpXrZyCAoasy4Fe32UuwilEdLwi+ne7y5qOyGUTv3GIzCF
         5RQO7CtXS6gl/LuW+Y7LceuduHhiPTkcA6bU+nPewJ3pYutjfd4r8LykTPULONs/J/yb
         fHiQ==
X-Gm-Message-State: AO0yUKXdRnzz2pgvlVHJeCm6odIh5U/fhmmX5kgWLvxEiaunKSItBmya
        IeqJUfng18frhhzJJa+QuQ4rgxBMIpZlFo4tYeBSRFb97nbivK4AG6k5RbIpTLLYV5I9ynDnSJf
        +tfQNonfKd1KxlP1U
X-Received: by 2002:a17:907:3e82:b0:878:6755:9089 with SMTP id hs2-20020a1709073e8200b0087867559089mr12602399ejc.39.1675416587255;
        Fri, 03 Feb 2023 01:29:47 -0800 (PST)
X-Google-Smtp-Source: AK7set/jWXVc31NjbbKgYo8E+Q5ARi8JpVQ4Jp8pluUOVMkbKQPKWx5Bd61WD+5ofhOfbTrQifSc5w==
X-Received: by 2002:a17:907:3e82:b0:878:6755:9089 with SMTP id hs2-20020a1709073e8200b0087867559089mr12602375ejc.39.1675416587074;
        Fri, 03 Feb 2023 01:29:47 -0800 (PST)
Received: from redhat.com ([2.52.156.122])
        by smtp.gmail.com with ESMTPSA id c15-20020a170906340f00b008778f177fbesm1140263ejb.11.2023.02.03.01.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 01:29:46 -0800 (PST)
Date:   Fri, 3 Feb 2023 04:29:41 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Petr Machata <petrm@nvidia.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: Re: [PATCH 24/33] virtio_net: xsk: stop disable tx napi
Message-ID: <20230203042821-mutt-send-email-mst@kernel.org>
References: <20230202110058.130695-1-xuanzhuo@linux.alibaba.com>
 <20230202110058.130695-25-xuanzhuo@linux.alibaba.com>
 <20230202122445-mutt-send-email-mst@kernel.org>
 <1675394682.9569418-1-xuanzhuo@linux.alibaba.com>
 <20230203032945-mutt-send-email-mst@kernel.org>
 <1675414156.9460502-2-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1675414156.9460502-2-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 03, 2023 at 04:49:16PM +0800, Xuan Zhuo wrote:
> On Fri, 3 Feb 2023 03:33:41 -0500, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > On Fri, Feb 03, 2023 at 11:24:42AM +0800, Xuan Zhuo wrote:
> > > On Thu, 2 Feb 2023 12:25:59 -0500, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > > On Thu, Feb 02, 2023 at 07:00:49PM +0800, Xuan Zhuo wrote:
> > > > > Since xsk's TX queue is consumed by TX NAPI, if sq is bound to xsk, then
> > > > > we must stop tx napi from being disabled.
> > > > >
> > > > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > > > ---
> > > > >  drivers/net/virtio/main.c | 9 ++++++++-
> > > > >  1 file changed, 8 insertions(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/drivers/net/virtio/main.c b/drivers/net/virtio/main.c
> > > > > index ed79e750bc6c..232cf151abff 100644
> > > > > --- a/drivers/net/virtio/main.c
> > > > > +++ b/drivers/net/virtio/main.c
> > > > > @@ -2728,8 +2728,15 @@ static int virtnet_set_coalesce(struct net_device *dev,
> > > > >  		return ret;
> > > > >
> > > > >  	if (update_napi) {
> > > > > -		for (i = 0; i < vi->max_queue_pairs; i++)
> > > > > +		for (i = 0; i < vi->max_queue_pairs; i++) {
> > > > > +			/* xsk xmit depend on the tx napi. So if xsk is active,
> > > >
> > > > depends.
> > > >
> > > > > +			 * prevent modifications to tx napi.
> > > > > +			 */
> > > > > +			if (rtnl_dereference(vi->sq[i].xsk.pool))
> > > > > +				continue;
> > > > > +
> > > > >  			vi->sq[i].napi.weight = napi_weight;
> > > >
> > > > I don't get it.
> > > > changing napi weight does not work then.
> > > > why is this ok?
> > >
> > >
> > > static void skb_xmit_done(struct virtqueue *vq)
> > > {
> > > 	struct virtnet_info *vi = vq->vdev->priv;
> > > 	struct napi_struct *napi = &vi->sq[vq2txq(vq)].napi;
> > >
> > > 	/* Suppress further interrupts. */
> > > 	virtqueue_disable_cb(vq);
> > >
> > > 	if (napi->weight)
> > > 		virtqueue_napi_schedule(napi, vq);
> > > 	else
> > > 		/* We were probably waiting for more output buffers. */
> > > 		netif_wake_subqueue(vi->dev, vq2txq(vq));
> > > }
> > >
> > >
> > > If the weight is 0, tx napi will not be triggered again.
> > >
> > > Thanks.
> >
> > This needs more thought then. First ignoring what user is requesting is
> > not nice.
> 
> Maybe we should return an error.

maybe


> >Second what if napi is first disabled and then xsk enabled?
> 
> 
> static int virtnet_xsk_pool_enable(struct net_device *dev,
> 				   struct xsk_buff_pool *pool,
> 				   u16 qid)
> {
> 	struct virtnet_info *vi = netdev_priv(dev);
> 	struct receive_queue *rq;
> 	struct send_queue *sq;
> 	int err;
> 
> 	if (qid >= vi->curr_queue_pairs)
> 		return -EINVAL;
> 
> 	sq = &vi->sq[qid];
> 	rq = &vi->rq[qid];
> 
> 	/* xsk zerocopy depend on the tx napi.
> 	 *
> 	 * All xsk packets are actually consumed and sent out from the xsk tx
> 	 * queue under the tx napi mechanism.
> 	 */
> ->	if (!sq->napi.weight)
> 		return -EPERM;
> 
> Thanks.
> 
> 
> >
> >
> > > >
> > > >
> > > > > +		}
> > > > >  	}
> > > > >
> > > > >  	return ret;
> > > > > --
> > > > > 2.32.0.3.g01195cf9f
> > > >
> >


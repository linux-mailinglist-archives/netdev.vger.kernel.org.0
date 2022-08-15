Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF6B3592A8B
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 10:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240773AbiHOHjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 03:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbiHOHjm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 03:39:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4B0DC19C04
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 00:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660549177;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OC2bkx9zJBueAPg8JEQmoRM5UxmTc8D+tbnHej4iLwk=;
        b=RHIwI5B0ipCahX7dSBUmLyuyqLbj8gH/f/tikDeNEF4yerkDb44yxHJc1hsAs1j0dyHLSb
        4vleytCjtjkEGXRyrWHI0fM269H2qp90txvCXSLWkPXX88CW5yjEd9hTdvcS7Kf+yOOwPL
        dL2RVWBjrd0gSz88X6cjNAmha/dFw+4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-595-1XI6GUlYMD-sryEVAIL0AQ-1; Mon, 15 Aug 2022 03:39:35 -0400
X-MC-Unique: 1XI6GUlYMD-sryEVAIL0AQ-1
Received: by mail-ed1-f70.google.com with SMTP id h6-20020a05640250c600b0043d9964d2ceso4252327edb.4
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 00:39:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=OC2bkx9zJBueAPg8JEQmoRM5UxmTc8D+tbnHej4iLwk=;
        b=NZHK6Ku2kTRjrMKssVpcIM+OdSkXdNJo7fUnb1wPUHHLni39hQlcZ9c+9qlAQtKCme
         /qm1cfcra3T77wEdHaesJCMWEyscycD78VeC+j2F8aXoSdvgajeCZzuMdDs5IivJiPE2
         pLHeAMwKwEZJ3ZlJ3ho/LW2vLMLo1GAFtjnBf6eFesKX3T1HRJ69P9KZXcb/AOjIZeP8
         9TrKczSuzK0P8gDjkEORR9oMiiE2X2SyvZ1KttauGXzI1C5225OQJE/uYquNupTxj6yN
         PBZs8YV4TOuVjvxQ/Nsd/IQyalPGPGUi0Vx5G/clUmGfgJKjVrpYr/HkQT2gME1PojTh
         +Krw==
X-Gm-Message-State: ACgBeo1fVwHN+N3wNpefppgMibCh7RLIpoFiiX8fLu2RLZQK+LWrwu9z
        MANn/nHs7rcuLAWef9q05zIUmsSbyLUENzDFZCWDwDIRDfZ1FCvgPTU3dVxM7cWmGmZ2pBy0iwe
        PFoZMt/9bMiWrGyTd
X-Received: by 2002:a17:907:1608:b0:730:5ad0:ae1a with SMTP id hb8-20020a170907160800b007305ad0ae1amr9813481ejc.222.1660549174253;
        Mon, 15 Aug 2022 00:39:34 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5dF4uCArlexvqL8XPZdPtg7Gr2bGirXXunwpdi3Wu1c4gmQV30+uieFh6F/qWMw4uVYBdewg==
X-Received: by 2002:a17:907:1608:b0:730:5ad0:ae1a with SMTP id hb8-20020a170907160800b007305ad0ae1amr9813461ejc.222.1660549173946;
        Mon, 15 Aug 2022 00:39:33 -0700 (PDT)
Received: from redhat.com ([2.54.169.49])
        by smtp.gmail.com with ESMTPSA id f25-20020a50fc99000000b004424429afd4sm6151850edq.16.2022.08.15.00.39.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 00:39:33 -0700 (PDT)
Date:   Mon, 15 Aug 2022 03:39:25 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     virtualization@lists.linux-foundation.org,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        linux-um@lists.infradead.org, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, bpf@vger.kernel.org,
        kangjie.xu@linux.alibaba.com
Subject: Re: [PATCH v14 37/42] virtio_net: set the default max ring size by
 find_vqs()
Message-ID: <20220815033849-mutt-send-email-mst@kernel.org>
References: <20220801063902.129329-1-xuanzhuo@linux.alibaba.com>
 <20220801063902.129329-38-xuanzhuo@linux.alibaba.com>
 <20220815015405-mutt-send-email-mst@kernel.org>
 <1660545303.436073-9-xuanzhuo@linux.alibaba.com>
 <20220815031022-mutt-send-email-mst@kernel.org>
 <1660548498.412278-11-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1660548498.412278-11-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 15, 2022 at 03:28:18PM +0800, Xuan Zhuo wrote:
> On Mon, 15 Aug 2022 03:14:43 -0400, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > On Mon, Aug 15, 2022 at 02:35:03PM +0800, Xuan Zhuo wrote:
> > > On Mon, 15 Aug 2022 02:00:16 -0400, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > > On Mon, Aug 01, 2022 at 02:38:57PM +0800, Xuan Zhuo wrote:
> > > > > Use virtio_find_vqs_ctx_size() to specify the maximum ring size of tx,
> > > > > rx at the same time.
> > > > >
> > > > >                          | rx/tx ring size
> > > > > -------------------------------------------
> > > > > speed == UNKNOWN or < 10G| 1024
> > > > > speed < 40G              | 4096
> > > > > speed >= 40G             | 8192
> > > > >
> > > > > Call virtnet_update_settings() once before calling init_vqs() to update
> > > > > speed.
> > > > >
> > > > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > > > Acked-by: Jason Wang <jasowang@redhat.com>
> > > >
> > > > I've been looking at this patchset because of the resent
> > > > reported crashes, and I'm having second thoughts about this.
> > > >
> > > > Do we really want to second-guess the device supplied
> > > > max ring size? If yes why?
> > > >
> > > > Could you please share some performance data that motivated this
> > > > specific set of numbers?
> > >
> > >
> > > The impact of this value on performance is as follows. The larger the value, the
> > > throughput can be increased, but the delay will also increase accordingly. It is
> > > a maximum limit for the ring size under the corresponding speed. The purpose of
> > > this limitation is not to improve performance, but more to reduce memory usage.
> > >
> > > These data come from many other network cards and some network optimization
> > > experience.
> > >
> > > For example, in the case of speed = 20G, the impact of ring size greater
> > > than 4096 on performance has no meaning. At this time, if the device supports
> > > 8192, we limit it to 4096 through this, the real meaning is to reduce the memory
> > > usage.
> > >
> > >
> > > >
> > > > Also why do we intepret UNKNOWN as "very low"?
> > > > I'm thinking that should definitely be "don't change anything".
> > > >
> > >
> > > Generally speaking, for a network card with a high speed, it will return a
> > > correct speed. But I think it is a good idea to do nothing.
> >
> >
> >
> >
> >
> > >
> > > > Finally if all this makes sense then shouldn't we react when
> > > > speed changes?
> > >
> > > This is the feedback of the network card when it is started, and theoretically
> > > it should not change in the future.
> >
> > Yes it should:
> > 	Both \field{speed} and \field{duplex} can change, thus the driver
> > 	is expected to re-read these values after receiving a
> > 	configuration change notification.
> >
> >
> > Moreover, during probe link can quite reasonably be down.
> > If it is, then speed and duplex might not be correct.
> >
> 
> 
> It seems that this is indeed a problem.
> 
> But I feel that this is not the reason for the abnormal network.

Yes, but it's a reason to revert this patch and rethink the approach.

> I'm still trying google cloud vm.
> 
> 
> >
> >
> >
> > > >
> > > > Could you try reverting this and showing performance results
> > > > before and after please? Thanks!
> > >
> > > I hope the above reply can help you, if there is anything else you need me to
> > > cooperate with, I am very happy.
> > >
> > > If you think it's ok, I can resubmit a commit with 'UNKNOW' set to unlimited. I
> > > can submit it with the issue of #30.
> > >
> > > Thanks.
> > >
> > >
> > > >
> > > > > ---
> > > > >  drivers/net/virtio_net.c | 42 ++++++++++++++++++++++++++++++++++++----
> > > > >  1 file changed, 38 insertions(+), 4 deletions(-)
> > > > >
> > > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > > index 8a5810bcb839..40532ecbe7fc 100644
> > > > > --- a/drivers/net/virtio_net.c
> > > > > +++ b/drivers/net/virtio_net.c
> > > > > @@ -3208,6 +3208,29 @@ static unsigned int mergeable_min_buf_len(struct virtnet_info *vi, struct virtqu
> > > > >  		   (unsigned int)GOOD_PACKET_LEN);
> > > > >  }
> > > > >
> > > > > +static void virtnet_config_sizes(struct virtnet_info *vi, u32 *sizes)
> > > > > +{
> > > > > +	u32 i, rx_size, tx_size;
> > > > > +
> > > > > +	if (vi->speed == SPEED_UNKNOWN || vi->speed < SPEED_10000) {
> > > > > +		rx_size = 1024;
> > > > > +		tx_size = 1024;
> > > > > +
> > > > > +	} else if (vi->speed < SPEED_40000) {
> > > > > +		rx_size = 1024 * 4;
> > > > > +		tx_size = 1024 * 4;
> > > > > +
> > > > > +	} else {
> > > > > +		rx_size = 1024 * 8;
> > > > > +		tx_size = 1024 * 8;
> > > > > +	}
> > > > > +
> > > > > +	for (i = 0; i < vi->max_queue_pairs; i++) {
> > > > > +		sizes[rxq2vq(i)] = rx_size;
> > > > > +		sizes[txq2vq(i)] = tx_size;
> > > > > +	}
> > > > > +}
> > > > > +
> > > > >  static int virtnet_find_vqs(struct virtnet_info *vi)
> > > > >  {
> > > > >  	vq_callback_t **callbacks;
> > > > > @@ -3215,6 +3238,7 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
> > > > >  	int ret = -ENOMEM;
> > > > >  	int i, total_vqs;
> > > > >  	const char **names;
> > > > > +	u32 *sizes;
> > > > >  	bool *ctx;
> > > > >
> > > > >  	/* We expect 1 RX virtqueue followed by 1 TX virtqueue, followed by
> > > > > @@ -3242,10 +3266,15 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
> > > > >  		ctx = NULL;
> > > > >  	}
> > > > >
> > > > > +	sizes = kmalloc_array(total_vqs, sizeof(*sizes), GFP_KERNEL);
> > > > > +	if (!sizes)
> > > > > +		goto err_sizes;
> > > > > +
> > > > >  	/* Parameters for control virtqueue, if any */
> > > > >  	if (vi->has_cvq) {
> > > > >  		callbacks[total_vqs - 1] = NULL;
> > > > >  		names[total_vqs - 1] = "control";
> > > > > +		sizes[total_vqs - 1] = 64;
> > > > >  	}
> > > > >
> > > > >  	/* Allocate/initialize parameters for send/receive virtqueues */
> > > > > @@ -3260,8 +3289,10 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
> > > > >  			ctx[rxq2vq(i)] = true;
> > > > >  	}
> > > > >
> > > > > -	ret = virtio_find_vqs_ctx(vi->vdev, total_vqs, vqs, callbacks,
> > > > > -				  names, ctx, NULL);
> > > > > +	virtnet_config_sizes(vi, sizes);
> > > > > +
> > > > > +	ret = virtio_find_vqs_ctx_size(vi->vdev, total_vqs, vqs, callbacks,
> > > > > +				       names, sizes, ctx, NULL);
> > > > >  	if (ret)
> > > > >  		goto err_find;
> > > > >
> > > > > @@ -3281,6 +3312,8 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
> > > > >
> > > > >
> > > > >  err_find:
> > > > > +	kfree(sizes);
> > > > > +err_sizes:
> > > > >  	kfree(ctx);
> > > > >  err_ctx:
> > > > >  	kfree(names);
> > > > > @@ -3630,6 +3663,9 @@ static int virtnet_probe(struct virtio_device *vdev)
> > > > >  		vi->curr_queue_pairs = num_online_cpus();
> > > > >  	vi->max_queue_pairs = max_queue_pairs;
> > > > >
> > > > > +	virtnet_init_settings(dev);
> > > > > +	virtnet_update_settings(vi);
> > > > > +
> > > > >  	/* Allocate/initialize the rx/tx queues, and invoke find_vqs */
> > > > >  	err = init_vqs(vi);
> > > > >  	if (err)
> > > > > @@ -3642,8 +3678,6 @@ static int virtnet_probe(struct virtio_device *vdev)
> > > > >  	netif_set_real_num_tx_queues(dev, vi->curr_queue_pairs);
> > > > >  	netif_set_real_num_rx_queues(dev, vi->curr_queue_pairs);
> > > > >
> > > > > -	virtnet_init_settings(dev);
> > > > > -
> > > > >  	if (virtio_has_feature(vdev, VIRTIO_NET_F_STANDBY)) {
> > > > >  		vi->failover = net_failover_create(vi->dev);
> > > > >  		if (IS_ERR(vi->failover)) {
> > > > > --
> > > > > 2.31.0
> > > >
> >


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6B06E89AC
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 07:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233502AbjDTFpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 01:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233224AbjDTFpR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 01:45:17 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE1A53A97;
        Wed, 19 Apr 2023 22:45:15 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1a6715ee82fso8176925ad.1;
        Wed, 19 Apr 2023 22:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681969515; x=1684561515;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8Tf2VpWhxjAYxcYUQ0lyc/cD0H8jUE/mITS0goQbaSM=;
        b=kmHGRQyXSOAb2hb/c/TdQ7b70sLmKBkMMlesr8i5GI5t8tp0Wfu9UYbw+5lDh4zc6w
         pfV3aLuPQSzcKGJphND4fCxArwCqz2jgYaoSzANMQnQ5YPkIUiuR8+jSEqLDZXHvv/Bf
         KREiyP+WlVuCf69MkVWr5EOyvQpaOxBq+19N0Jp8e3Y4AyKWu/g+vyGQysy9mn3L17ia
         nDq5wf7b0i0031yybcp1BQUItDAS/eO5R1ivAo4RG4Us9gax6DpnqI0vyJFV03GoSqq7
         xvStIdET0pZ24j7Qj9BntbwOVw9oRnCSzRUaL9XRH7umcsfDGAjr4H02k291U/lMcw7/
         61sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681969515; x=1684561515;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8Tf2VpWhxjAYxcYUQ0lyc/cD0H8jUE/mITS0goQbaSM=;
        b=Fo/DvwRdxPD7aOaKca9xVAgU9+6mJg87bRNYjPMEaDARme+w8dimEb/avct+hHlsT7
         y7J0qBfZ3Cdeis4hmiz2dqktzWPQ3BtLF/TAkIbU2AM7tNf7chE67hD9a8nDVgySTokF
         ksTyXiVm5+4g+g3Tk3TTp0AzTBFwa2nFcnRPpUq6MLRsGlJK8e4OZvgYBy2oSgXzKxdW
         tlNoMl1MpVfpU2GLcErLYjZ2HQC7YAu9W0bcIeF7Ee1Z7C52DiyDeTQIiL68ZwVHe5AZ
         RLAHNd7F0Xg5ZopcpFYAW4mBY7FG5e4xff8CkBV4/MFkVnhcKmhNoVZc2QY/+eloSxuC
         8tvw==
X-Gm-Message-State: AAQBX9dUt9eI9lfTt4uLEx2h88HR+hX6mxFNjoF/AoQp6qzkyJV1AJRg
        P9ZuSj1yUtqx4LsMtJ7e118=
X-Google-Smtp-Source: AKy350Y0Rncfr/8NyRfa6Y+/CLdM0DMxQ/jGouIv344inzmImgPcIc3YFQVpA9L2MYOQdMEKKcdOBg==
X-Received: by 2002:a17:902:c3c3:b0:1a2:1922:985b with SMTP id j3-20020a170902c3c300b001a21922985bmr340590plj.59.1681969515199;
        Wed, 19 Apr 2023 22:45:15 -0700 (PDT)
Received: from localhost (ec2-54-67-115-33.us-west-1.compute.amazonaws.com. [54.67.115.33])
        by smtp.gmail.com with ESMTPSA id jb4-20020a170903258400b001a682a195basm391242plb.28.2023.04.19.22.45.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 22:45:14 -0700 (PDT)
Date:   Sat, 15 Apr 2023 09:51:37 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Vishnu Dasa <vdasa@vmware.com>, Wei Liu <wei.liu@kernel.org>,
        Jiang Wang <jiang.wang@bytedance.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Dexuan Cui <decui@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Bryan Tan <bryantan@vmware.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-hyperv@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH RFC net-next v2 2/4] virtio/vsock: add
 VIRTIO_VSOCK_F_DGRAM feature bit
Message-ID: <ZDpzqTewbtuxV/Sk@bullseye>
References: <20230413-b4-vsock-dgram-v2-0-079cc7cee62e@bytedance.com>
 <20230413-b4-vsock-dgram-v2-2-079cc7cee62e@bytedance.com>
 <nbuuohh72i4n27rzlg7sj7bwsrsrnnxxcxj6w5yotw5bhpcznt@ormwl5d6jiuw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <nbuuohh72i4n27rzlg7sj7bwsrsrnnxxcxj6w5yotw5bhpcznt@ormwl5d6jiuw>
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DATE_IN_PAST_96_XX,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023 at 11:30:21AM +0200, Stefano Garzarella wrote:
> On Fri, Apr 14, 2023 at 12:25:58AM +0000, Bobby Eshleman wrote:
> > This commit adds a feature bit for virtio vsock to support datagrams.
> > This commit should not be applied without first applying the commit
> > that implements datagrams for virtio.
> > 
> > Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
> > Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> > ---
> > drivers/vhost/vsock.c             | 3 ++-
> > include/uapi/linux/virtio_vsock.h | 1 +
> > net/vmw_vsock/virtio_transport.c  | 8 ++++++--
> > 3 files changed, 9 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> > index dff6ee1c479b..028cf079225e 100644
> > --- a/drivers/vhost/vsock.c
> > +++ b/drivers/vhost/vsock.c
> > @@ -32,7 +32,8 @@
> > enum {
> > 	VHOST_VSOCK_FEATURES = VHOST_FEATURES |
> > 			       (1ULL << VIRTIO_F_ACCESS_PLATFORM) |
> > -			       (1ULL << VIRTIO_VSOCK_F_SEQPACKET)
> > +			       (1ULL << VIRTIO_VSOCK_F_SEQPACKET) |
> > +			       (1ULL << VIRTIO_VSOCK_F_DGRAM)
> > };
> > 
> > enum {
> > diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
> > index 331be28b1d30..0975b9c88292 100644
> > --- a/include/uapi/linux/virtio_vsock.h
> > +++ b/include/uapi/linux/virtio_vsock.h
> > @@ -40,6 +40,7 @@
> > 
> > /* The feature bitmap for virtio vsock */
> > #define VIRTIO_VSOCK_F_SEQPACKET	1	/* SOCK_SEQPACKET supported */
> > +#define VIRTIO_VSOCK_F_DGRAM		2	/* Host support dgram vsock */
> > 
> > struct virtio_vsock_config {
> > 	__le64 guest_cid;
> > diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> > index 582c6c0f788f..bb43eea9a6f9 100644
> > --- a/net/vmw_vsock/virtio_transport.c
> > +++ b/net/vmw_vsock/virtio_transport.c
> > @@ -29,6 +29,7 @@ static struct virtio_transport virtio_transport; /* forward declaration */
> > struct virtio_vsock {
> > 	struct virtio_device *vdev;
> > 	struct virtqueue *vqs[VSOCK_VQ_MAX];
> > +	bool has_dgram;
> > 
> > 	/* Virtqueue processing is deferred to a workqueue */
> > 	struct work_struct tx_work;
> > @@ -640,7 +641,6 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
> > 	}
> > 
> > 	vsock->vdev = vdev;
> > -
> > 	vsock->rx_buf_nr = 0;
> > 	vsock->rx_buf_max_nr = 0;
> > 	atomic_set(&vsock->queued_replies, 0);
> > @@ -657,6 +657,9 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
> > 	if (virtio_has_feature(vdev, VIRTIO_VSOCK_F_SEQPACKET))
> > 		vsock->seqpacket_allow = true;
> > 
> > +	if (virtio_has_feature(vdev, VIRTIO_VSOCK_F_DGRAM))
> > +		vsock->has_dgram = true;
> 
> This is unused for now, but I think the idea is to use in
> virtio_transport_dgram_allow(), right?
> 
> I would follow `seqpacket_allow` in this case.
> 

Got it, thanks.


> Thanks,
> Stefano
> 
> > +
> > 	vdev->priv = vsock;
> > 
> > 	ret = virtio_vsock_vqs_init(vsock);
> > @@ -749,7 +752,8 @@ static struct virtio_device_id id_table[] = {
> > };
> > 
> > static unsigned int features[] = {
> > -	VIRTIO_VSOCK_F_SEQPACKET
> > +	VIRTIO_VSOCK_F_SEQPACKET,
> > +	VIRTIO_VSOCK_F_DGRAM
> > };
> > 
> > static struct virtio_driver virtio_vsock_driver = {
> > 
> > -- 
> > 2.30.2
> > 
> 
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization

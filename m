Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FBE95EB3A0
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 23:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbiIZVwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 17:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbiIZVwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 17:52:04 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC1FB3B2E;
        Mon, 26 Sep 2022 14:52:03 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id f193so7785415pgc.0;
        Mon, 26 Sep 2022 14:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=nZktzK+zzsCjiwRA7br+CXR0Vc/qwKL2ngFhBD6+m64=;
        b=TLVJoOL3zluMziQihUabADxccWS/xFw1pnySEi88cQkx3bjbVMWPdWUQt5b0c3BjxX
         Z/E7MagaIg+4cKK745RhgOA/aCBswqEeGJPjXlbIMeXenM/1qRSMpnGd5P+rp3jeG4/p
         gseud0za4Z9lgEGsbGIxNaIgNqw9GNyZGeQAAEzcZE3SF/UQNMIqh/k0c8tc6YkpBnle
         f3G1rpEczuSi70dYZdmBEkFRQJwVbCd07j3DENNlSPRDmAsTvrW/rotZAnv2vca3CGvt
         oMSTFGsKHFe2buKxfmSh9sUjVVUd4NpNJkdOa22s2wqVjRKTWRbotq5wOgvukCRX22EF
         ieqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=nZktzK+zzsCjiwRA7br+CXR0Vc/qwKL2ngFhBD6+m64=;
        b=AUB6aFQXZt3zzv/RICOCaoDT5L/J372DLZKqtZuviPuC35QyVvj+w6Q3ZgR6jrk6oQ
         xTz2N1/GiNnsTiipqepM6HDLcmWjE0vy3evcYrPYulY8kCtDLViOhu2UrYfiYM8kv78R
         cz0XhNIkcL/2QnxsQFSwQBizr+IK9LLK4WUNx+rUHRY8XjD+Py70E6zpN+xzwun5HEaj
         k2TfGfv21FzglVU2XomcGTUXcoFj3ynznvBTEWSxbsH/kaioOSO1wwozFJNt1ZLvMcMP
         OaNL7TE/SmMdikaMFSgz3LO3rsYEyKFvVhTCuevEpCe8rqN1GbFs5D/wWy4tDffzlxIY
         YVtw==
X-Gm-Message-State: ACrzQf3pve4fD7xAHXaJX26GewTlWGNDajYWX2T2XlpChbhjk3PaxfNS
        r3NKzikYJulRQ0EAbiHSzL0=
X-Google-Smtp-Source: AMsMyM4T+ZuUoeZDY7V6nQrJ9QdjfWe5P5qUXQBQiuWQrJXCO1A7HT+7UKpdWFcIetN88mi41WTReQ==
X-Received: by 2002:a63:f20e:0:b0:439:398f:80f8 with SMTP id v14-20020a63f20e000000b00439398f80f8mr21178677pgh.494.1664229122422;
        Mon, 26 Sep 2022 14:52:02 -0700 (PDT)
Received: from localhost (c-73-164-155-12.hsd1.wa.comcast.net. [73.164.155.12])
        by smtp.gmail.com with ESMTPSA id i64-20020a62c143000000b0053617cbe2d2sm12606746pfg.168.2022.09.26.14.52.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 14:52:01 -0700 (PDT)
Date:   Mon, 26 Sep 2022 21:52:00 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Bobby Eshleman <bobby.eshleman@gmail.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Eric Dumazet <edumazet@google.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 4/6] virtio/vsock: add VIRTIO_VSOCK_F_DGRAM feature bit
Message-ID: <YzIfADqYLMUHjf2a@bullseye>
References: <cover.1660362668.git.bobby.eshleman@bytedance.com>
 <3d1f32c4da81f8a0870e126369ba12bc8c4ad048.1660362668.git.bobby.eshleman@bytedance.com>
 <20220926131751.pdlc5mbx6gxqlmkx@sgarzare-redhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926131751.pdlc5mbx6gxqlmkx@sgarzare-redhat>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 26, 2022 at 03:17:51PM +0200, Stefano Garzarella wrote:
> On Mon, Aug 15, 2022 at 10:56:07AM -0700, Bobby Eshleman wrote:
> > This commit adds a feature bit for virtio vsock to support datagrams.
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
> > index b20ddec2664b..a5d1bdb786fe 100644
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
> > index 64738838bee5..857df3a3a70d 100644
> > --- a/include/uapi/linux/virtio_vsock.h
> > +++ b/include/uapi/linux/virtio_vsock.h
> > @@ -40,6 +40,7 @@
> > 
> > /* The feature bitmap for virtio vsock */
> > #define VIRTIO_VSOCK_F_SEQPACKET	1	/* SOCK_SEQPACKET supported */
> > +#define VIRTIO_VSOCK_F_DGRAM		2	/* Host support dgram vsock */
> 
> We already allocated bit 2 for F_NO_IMPLIED_STREAM , so we should use 3:
> https://github.com/oasis-tcs/virtio-spec/blob/26ed30ccb049fd51d6e20aad3de2807d678edb3a/virtio-vsock.tex#L22
> (I'll send patches to implement F_STREAM and F_NO_IMPLIED_STREAM negotiation
> soon).
> 
> As long as it's RFC it's fine to introduce F_DGRAM, but we should first
> change virtio-spec before merging this series.
> 
> About the patch, we should only negotiate the new feature when we really
> have DGRAM support. So, it's better to move this patch after adding support
> for datagram.

Roger that, I'll reorder that for v2 and also clarify the series by
prefixing it with RFC.

Before removing "RFC" from the series, I'll be sure to send out
virtio-spec patches first.

Thanks,
Bobby

> 
> Thanks,
> Stefano
> 
> > 
> > struct virtio_vsock_config {
> > 	__le64 guest_cid;
> > diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> > index c6212eb38d3c..073314312683 100644
> > --- a/net/vmw_vsock/virtio_transport.c
> > +++ b/net/vmw_vsock/virtio_transport.c
> > @@ -35,6 +35,7 @@ static struct virtio_transport virtio_transport; /*
> > forward declaration */
> > struct virtio_vsock {
> > 	struct virtio_device *vdev;
> > 	struct virtqueue *vqs[VSOCK_VQ_MAX];
> > +	bool has_dgram;
> > 
> > 	/* Virtqueue processing is deferred to a workqueue */
> > 	struct work_struct tx_work;
> > @@ -709,7 +710,6 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
> > 	}
> > 
> > 	vsock->vdev = vdev;
> > -
> > 	vsock->rx_buf_nr = 0;
> > 	vsock->rx_buf_max_nr = 0;
> > 	atomic_set(&vsock->queued_replies, 0);
> > @@ -726,6 +726,9 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
> > 	if (virtio_has_feature(vdev, VIRTIO_VSOCK_F_SEQPACKET))
> > 		vsock->seqpacket_allow = true;
> > 
> > +	if (virtio_has_feature(vdev, VIRTIO_VSOCK_F_DGRAM))
> > +		vsock->has_dgram = true;
> > +
> > 	vdev->priv = vsock;
> > 
> > 	ret = virtio_vsock_vqs_init(vsock);
> > @@ -820,7 +823,8 @@ static struct virtio_device_id id_table[] = {
> > };
> > 
> > static unsigned int features[] = {
> > -	VIRTIO_VSOCK_F_SEQPACKET
> > +	VIRTIO_VSOCK_F_SEQPACKET,
> > +	VIRTIO_VSOCK_F_DGRAM
> > };
> > 
> > static struct virtio_driver virtio_vsock_driver = {
> > -- 
> > 2.35.1
> > 
> 
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization

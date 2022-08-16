Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5955A596047
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 18:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236451AbiHPQ15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 12:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236457AbiHPQ1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 12:27:54 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52EE27C19B;
        Tue, 16 Aug 2022 09:27:51 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id u133so9759205pfc.10;
        Tue, 16 Aug 2022 09:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=+MvwrBM8Ct1OzUTAoX6NVg1C2p4pb8PZAZsXnYjkU/8=;
        b=bmd4EjQsv9U/N9wjOFAWQyoti4YYzcd9+BEMlPgJFvjRoSEpBhknNa30NXlA9y4a2P
         btil0DBiNkLKpqQDUKhq6fPKRmzfXzlF+IEopUGz4VSp1A8zrldXC7Wt8xrxrqnw3AJw
         EI6JTFCYVS/blcPU63EZG/0aONhVNlOBpDLU9nN+3UDBtP1YOx5+i7SnAiBcjrOO18Kc
         ug6N06sU5GcircI86AG7R9aXfdxxAfhgdKX1w97Ho+EwYqt9hZZ4o8NBizbpbcyKVVFF
         jTtxz7s6k0ir6jYjdG5soWvcNCmbM+LRTle48JVC00wWNheuyakGoK8GieUcxnrMubsZ
         0nPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=+MvwrBM8Ct1OzUTAoX6NVg1C2p4pb8PZAZsXnYjkU/8=;
        b=wGJJglOP1IoHiyd/2Hsy2zSVVe6t/9RxjSS7yqPzLaHF2MjAqiNTigvzioxyNyPe4E
         w9oTQ+BBoX23JupzVVL3Sf6upW/7pG+EJnuVQlIHp+S/gNrabkYXK3QZTbJ65ajPlZsH
         KfjBgifjnGeK6jpqFJnFnxU8UQQtYDU/Wt4T1qzaNTQkT2o0M8BKotH4Cm0jI+RCs6dP
         K/HsWkbJm4NPvxFLbz253CE0ksIGZfp505LKuF8MoN/X0GhcUHwRsBFURgV4IXD5zvAq
         olrOw8ycx8LghQqCMsw04XpxNJaw+GXQKC/t2jiOyBj1+zqTgTzpVqJ+YWHs0vNZobee
         JHrw==
X-Gm-Message-State: ACgBeo28yR2FZCPfy4A5yNYLc6t2L5m1u/XVTGpY7q19iIM3DiAdTdoz
        BJV1GeLAgokG4ITwSeetCz0=
X-Google-Smtp-Source: AA6agR73Oo9c6+BKuxy+YEt/B4QMD1e/1fBoISrhIgjKInsqbPnRzTHU0p2wS4aTeW+WvTUPO0uVzA==
X-Received: by 2002:a05:6a00:e85:b0:52b:5db8:f3df with SMTP id bo5-20020a056a000e8500b0052b5db8f3dfmr21993865pfb.14.1660667270763;
        Tue, 16 Aug 2022 09:27:50 -0700 (PDT)
Received: from localhost (c-73-164-155-12.hsd1.wa.comcast.net. [73.164.155.12])
        by smtp.gmail.com with ESMTPSA id b14-20020a63930e000000b004297b8cd589sm2801164pge.21.2022.08.16.09.27.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 09:27:50 -0700 (PDT)
Date:   Tue, 16 Aug 2022 02:31:47 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     Bobby Eshleman <bobby.eshleman@gmail.com>
Cc:     virtio-dev@lists.oasis-open.org,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] virtio/vsock: add VIRTIO_VSOCK_F_DGRAM feature bit
Message-ID: <YvsBk/UnAgvrqMNR@bullseye>
References: <cover.1660362668.git.bobby.eshleman@bytedance.com>
 <3d1f32c4da81f8a0870e126369ba12bc8c4ad048.1660362668.git.bobby.eshleman@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d1f32c4da81f8a0870e126369ba12bc8c4ad048.1660362668.git.bobby.eshleman@bytedance.com>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CC'ing virtio-dev@lists.oasis-open.org

On Mon, Aug 15, 2022 at 10:56:07AM -0700, Bobby Eshleman wrote:
> This commit adds a feature bit for virtio vsock to support datagrams.
> 
> Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
> Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> ---
>  drivers/vhost/vsock.c             | 3 ++-
>  include/uapi/linux/virtio_vsock.h | 1 +
>  net/vmw_vsock/virtio_transport.c  | 8 ++++++--
>  3 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index b20ddec2664b..a5d1bdb786fe 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -32,7 +32,8 @@
>  enum {
>  	VHOST_VSOCK_FEATURES = VHOST_FEATURES |
>  			       (1ULL << VIRTIO_F_ACCESS_PLATFORM) |
> -			       (1ULL << VIRTIO_VSOCK_F_SEQPACKET)
> +			       (1ULL << VIRTIO_VSOCK_F_SEQPACKET) |
> +			       (1ULL << VIRTIO_VSOCK_F_DGRAM)
>  };
>  
>  enum {
> diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
> index 64738838bee5..857df3a3a70d 100644
> --- a/include/uapi/linux/virtio_vsock.h
> +++ b/include/uapi/linux/virtio_vsock.h
> @@ -40,6 +40,7 @@
>  
>  /* The feature bitmap for virtio vsock */
>  #define VIRTIO_VSOCK_F_SEQPACKET	1	/* SOCK_SEQPACKET supported */
> +#define VIRTIO_VSOCK_F_DGRAM		2	/* Host support dgram vsock */
>  
>  struct virtio_vsock_config {
>  	__le64 guest_cid;
> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> index c6212eb38d3c..073314312683 100644
> --- a/net/vmw_vsock/virtio_transport.c
> +++ b/net/vmw_vsock/virtio_transport.c
> @@ -35,6 +35,7 @@ static struct virtio_transport virtio_transport; /* forward declaration */
>  struct virtio_vsock {
>  	struct virtio_device *vdev;
>  	struct virtqueue *vqs[VSOCK_VQ_MAX];
> +	bool has_dgram;
>  
>  	/* Virtqueue processing is deferred to a workqueue */
>  	struct work_struct tx_work;
> @@ -709,7 +710,6 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
>  	}
>  
>  	vsock->vdev = vdev;
> -
>  	vsock->rx_buf_nr = 0;
>  	vsock->rx_buf_max_nr = 0;
>  	atomic_set(&vsock->queued_replies, 0);
> @@ -726,6 +726,9 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
>  	if (virtio_has_feature(vdev, VIRTIO_VSOCK_F_SEQPACKET))
>  		vsock->seqpacket_allow = true;
>  
> +	if (virtio_has_feature(vdev, VIRTIO_VSOCK_F_DGRAM))
> +		vsock->has_dgram = true;
> +
>  	vdev->priv = vsock;
>  
>  	ret = virtio_vsock_vqs_init(vsock);
> @@ -820,7 +823,8 @@ static struct virtio_device_id id_table[] = {
>  };
>  
>  static unsigned int features[] = {
> -	VIRTIO_VSOCK_F_SEQPACKET
> +	VIRTIO_VSOCK_F_SEQPACKET,
> +	VIRTIO_VSOCK_F_DGRAM
>  };
>  
>  static struct virtio_driver virtio_vsock_driver = {
> -- 
> 2.35.1
> 

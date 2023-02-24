Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9B866A17E7
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 09:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbjBXI0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 03:26:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbjBXI0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 03:26:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF1363A2B
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 00:25:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677227118;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=j1W3jI18Ol3sw6DqC+LMvzH80d9+CkyCSgdVYfhjlHU=;
        b=DxSGJuZTSW5kN1Gi6loX5NgfpvamZUmfhuFpf5Hn1esGxwW8DavjoGrl9mYTcjv4laqCdN
        IL4TwK48SrfhbvM1Tk72qKaE82oymoM6epQQIkXdZ8G38GvkBE84WCdByn5UziIVrFii+d
        EdUC+6c0J6f39ihWUZE4rkdqH9g8xJ0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-199-U6AoGg7hME6-EvfFIP8TTQ-1; Fri, 24 Feb 2023 03:25:17 -0500
X-MC-Unique: U6AoGg7hME6-EvfFIP8TTQ-1
Received: by mail-wm1-f69.google.com with SMTP id bi27-20020a05600c3d9b00b003e9d0925341so2741495wmb.8
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 00:25:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j1W3jI18Ol3sw6DqC+LMvzH80d9+CkyCSgdVYfhjlHU=;
        b=vF7dVKpJqj57XFS5/5mczQLBVYHfZ2dTMaRz/+tYpKvpoEFR+lXyDWdav4rhuvG96j
         sQFKrMlX/cs/HIROHx8koJKjFwRXJs91su5OTQlk0liQE8UPHPQIUs0RQA6X2MD/WsZ+
         mLH7XmZxkcrkoDg+S2esQRzbgPIzF/3v5W5lJ6Y3AzFwcSfpeZCOTApVkAWaKBNv2Rvr
         4rGyJxIknyJd+7f7L23/pC90qv6gYOc+sO7uFzHRQIrENrtbgbG+zqwZNCe6g3UBnonN
         xIxm6jTvq2R2d/k/w+CsTwRmNtknZpwPWy5BTvvenSCWrrFwoHIkc0vkegnog6ukcqGj
         rLBw==
X-Gm-Message-State: AO0yUKUaHTpTt53bqszEAkaakF7iTuN0FfCh6Fuhu6z7SFK7AO1vv+EW
        MmwjEU6/SbL6/mYIvGEiJoTiWRuhlx8ZCBv+siWnDX+myCGZSoAfKJgO4UcLjgrbqvZj67EIYPq
        4agXHHxZCM6LpDTNx
X-Received: by 2002:adf:ee4f:0:b0:2c7:1c08:1224 with SMTP id w15-20020adfee4f000000b002c71c081224mr1628709wro.29.1677227115947;
        Fri, 24 Feb 2023 00:25:15 -0800 (PST)
X-Google-Smtp-Source: AK7set+h0Q7ERAnJwpkJ6HirjyyhDbxWWMeG9atCKfDjQQWWffqd+OeTYMlx9rmh9c2GF8h0QSmFvw==
X-Received: by 2002:adf:ee4f:0:b0:2c7:1c08:1224 with SMTP id w15-20020adfee4f000000b002c71c081224mr1628686wro.29.1677227115641;
        Fri, 24 Feb 2023 00:25:15 -0800 (PST)
Received: from redhat.com ([2a02:14f:1f0:a3e9:76f3:3a96:2a:eb18])
        by smtp.gmail.com with ESMTPSA id g11-20020a5d698b000000b002c5a1bd5280sm13137905wru.95.2023.02.24.00.25.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 00:25:15 -0800 (PST)
Date:   Fri, 24 Feb 2023 03:25:10 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     rbradford@rivosinc.com
Cc:     Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] virtio-net: Fix probe of virtio-net on kvmtool
Message-ID: <20230224031932-mutt-send-email-mst@kernel.org>
References: <20230223-virtio-net-kvmtool-v2-1-8ec93511e67f@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230223-virtio-net-kvmtool-v2-1-8ec93511e67f@rivosinc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 23, 2023 at 07:38:25PM +0000, Rob Bradford via B4 Relay wrote:
> From: Rob Bradford <rbradford@rivosinc.com>
> 
> kvmtool does not support the VIRTIO_NET_F_CTRL_GUEST_OFFLOADS feature
> but does advertise the VIRTIO_NET_F_GUEST_TSO{4,6} features. Check that
> the VIRTIO_NET_F_CTRL_GUEST_OFFLOADS feature is present before setting
> the NETIF_F_GRO_HW feature bit as otherwise an attempt will be made to
> program the virtio-net device using the ctrl queue which will fail.
> 
> This resolves the following error when running on kvmtool:
> 
> [    1.865992] net eth0: Fail to set guest offload.
> [    1.872491] virtio_net virtio2 eth0: set_features() failed (-22); wanted 0x0000000000134829, left 0x0080000000134829
> 
> Signed-off-by: Rob Bradford <rbradford@rivosinc.com>
> ---
> Changes in v2:
> - Use parentheses to group logical OR of features 
> - Link to v1:
>   https://lore.kernel.org/r/20230223-virtio-net-kvmtool-v1-1-fc23d29b9d7a@rivosinc.com
> ---
>  drivers/net/virtio_net.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 61e33e4dd0cd..f8341d1a4ccd 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -3780,10 +3780,9 @@ static int virtnet_probe(struct virtio_device *vdev)
>  	}
>  	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_CSUM))
>  		dev->features |= NETIF_F_RXCSUM;
> -	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
> -	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6))
> -		dev->features |= NETIF_F_GRO_HW;
> -	if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS))
> +	if ((virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
> +	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6)) &&
> +	    virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS))
>  		dev->hw_features |= NETIF_F_GRO_HW;

This will disable GRO/LRO on kvmtool completely causing a significant
performance regression.

Jason, isn't this what
	commit dbcf24d153884439dad30484a0e3f02350692e4c
	Author: Jason Wang <jasowang@redhat.com>
	Date:   Tue Aug 17 16:06:59 2021 +0800

	    virtio-net: use NETIF_F_GRO_HW instead of NETIF_F_LRO

was supposed to address?


And apropos this:
    
    Fix this by using NETIF_F_GRO_HW instead. Though the spec does not
    guarantee packets to be re-segmented as the original ones,
    we can add that to the spec, possibly with a flag for devices to
    differentiate between GRO and LRO.

this never happened. What's the plan exactly?




>  	dev->vlan_features = dev->features;
> 
> ---
> base-commit: c39cea6f38eefe356d64d0bc1e1f2267e282cdd3
> change-id: 20230223-virtio-net-kvmtool-87f37515be22
> 
> Best regards,
> -- 
> Rob Bradford <rbradford@rivosinc.com>


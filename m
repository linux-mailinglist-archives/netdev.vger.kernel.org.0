Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A766369E5D4
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 18:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234717AbjBURWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 12:22:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233810AbjBURWM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 12:22:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A02729424
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 09:21:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677000084;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/m8VwT5q+IEQCUF2d/PwSBsc8aImFdA/guFZRJFeDAM=;
        b=Vbe+jlfXKEw8Oslmc8hokCpD2cjbmMN3Pu+vG8v9PLcapeAxdHVvlSVb9LbVJfLHpYtwLM
        tIHn51bFfrnmvBFczOuRnVDa2iSc+vWjfQypmwmdcr95cERv1a8eT/ioC1DbmQYBfH3vbS
        kdX5v/cIV3tyEUDOJyNFMCcAQ9W4nCs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-320-0YcB4hVBN_iFN_V3HeLR-g-1; Tue, 21 Feb 2023 12:21:22 -0500
X-MC-Unique: 0YcB4hVBN_iFN_V3HeLR-g-1
Received: by mail-wm1-f72.google.com with SMTP id s18-20020a7bc392000000b003deaf780ab6so2053409wmj.4
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 09:21:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/m8VwT5q+IEQCUF2d/PwSBsc8aImFdA/guFZRJFeDAM=;
        b=htnLeQr4XJr0TrXkCjfBeJFw3y+Z+8+/sp82p83rO8+TYmF94YcjCZwDfVs77tFHZD
         RLG5PWiHRqBVt/USaqJwJkeikLg8LvmYpobltxdo6+N8EVTGTkH7RQAsNiOjIjN/AeEX
         L6mdlxA5XJcowZmuhQw8E7J4YcgYsL5ub7QZUzF5Yc1HgNrWuqTFcqzUUqGzWgoajqGs
         MMn9NwkvlHAbykfkCxGhvykSiiHubX3cBK013eST3YybMhjUdo8qwZ0lDOMk18VlsnAk
         iNs3KtEApbpm0+oHM++c3FZXbqOc2fFaqK1jsAE4HEVLl9DhXLFYBl6pGH+FaxoqNmcR
         I7/w==
X-Gm-Message-State: AO0yUKUBDbwzu6nbOwxeNWwAsnQ3K3eHPJ+FRAZQ5Oa/hKy0U/g1F+Td
        GEisSEp66XLL9kn3aHPKFVE30eQtwAbIrHwMC/AH4WMbq/Bzd9+zOau/5pDLeN0XQYKiiiQew7Z
        IFRxFm6OHioYA0fTe
X-Received: by 2002:a5d:410b:0:b0:2c5:58f5:3c40 with SMTP id l11-20020a5d410b000000b002c558f53c40mr3878924wrp.47.1677000081318;
        Tue, 21 Feb 2023 09:21:21 -0800 (PST)
X-Google-Smtp-Source: AK7set92PXvkKYybMFyuZBNH8dfngZt4TBEFZfWE8mDOCU9ySWWLv5BCvRdTh2TqIrRRJv/2MGUtiA==
X-Received: by 2002:a5d:410b:0:b0:2c5:58f5:3c40 with SMTP id l11-20020a5d410b000000b002c558f53c40mr3878911wrp.47.1677000081017;
        Tue, 21 Feb 2023 09:21:21 -0800 (PST)
Received: from redhat.com ([2.52.2.78])
        by smtp.gmail.com with ESMTPSA id p7-20020a5d48c7000000b002c3d29d83d2sm4284356wrs.63.2023.02.21.09.21.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 09:21:20 -0800 (PST)
Date:   Tue, 21 Feb 2023 12:21:16 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org,
        alvaro.karsz@solid-run.com, vmireyno@marvell.com, parav@nvidia.com
Subject: Re: [patch net-next v2] net: virtio_net: implement exact header
 length guest feature
Message-ID: <20230221121543-mutt-send-email-mst@kernel.org>
References: <20230221144741.316477-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230221144741.316477-1-jiri@resnulli.us>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 21, 2023 at 03:47:41PM +0100, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Virtio spec introduced a feature VIRTIO_NET_F_GUEST_HDRLEN which when
> set implicates that the driver provides the exact size of the header.

OK but I feel this is not the important point. The important points are:
- this bit means device needs this info
- driver also has to set this bit
For example one might replace above with:

	Virtio spec introduced a feature VIRTIO_NET_F_GUEST_HDRLEN which when
	which when set implicates that device benefits from knowing the exact
	size of the header. For compatiblity, to signal to the device that the header
	is reliable driver also needs to set this feature.
	Without this feature set by driver, device has to figure
	out the header size itself.

and the below is ok.

> Quoting the original virtio spec:
> "hdr_len is a hint to the device as to how much of the header needs to
>  be kept to copy into each packet"
> 
> "a hint" might not be clear for the reader what does it mean, if it is
> "maybe like that" of "exactly like that". This feature just makes it
> crystal clear and let the device count on the hdr_len being filled up
> by the exact length of header.
> 
> Also note the spec already has following note about hdr_len:
> "Due to various bugs in implementations, this field is not useful
>  as a guarantee of the transport header size."
> 
> Without this feature the device needs to parse the header in core
> data path handling. Accurate information helps the device to eliminate
> such header parsing and directly use the hardware accelerators
> for GSO operation.
> 
> virtio_net_hdr_from_skb() fills up hdr_len to skb_headlen(skb).
> The driver already complies to fill the correct value. Introduce the
> feature and advertise it.
> 
> Note that virtio spec also includes following note for device
> implementation:
> "Caution should be taken by the implementation so as to prevent
>  a malicious driver from attacking the device by setting
>  an incorrect hdr_len."
> 
> There is a plan to support this feature in our emulated device.
> A device of SolidRun offers this feature bit. They claim this feature
> will save the device a few cycles for every GSO packet.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

I'm fine with patch itself. with commit log tweak:

Acked-by: Michael S. Tsirkin <mst@redhat.com>


> ---
> v1->v2:
> - extended patch description
> ---
>  drivers/net/virtio_net.c        | 6 ++++--
>  include/uapi/linux/virtio_net.h | 1 +
>  2 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index fb5e68ed3ec2..e85b03988733 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -62,7 +62,8 @@ static const unsigned long guest_offloads[] = {
>  	VIRTIO_NET_F_GUEST_UFO,
>  	VIRTIO_NET_F_GUEST_CSUM,
>  	VIRTIO_NET_F_GUEST_USO4,
> -	VIRTIO_NET_F_GUEST_USO6
> +	VIRTIO_NET_F_GUEST_USO6,
> +	VIRTIO_NET_F_GUEST_HDRLEN
>  };
>  
>  #define GUEST_OFFLOAD_GRO_HW_MASK ((1ULL << VIRTIO_NET_F_GUEST_TSO4) | \
> @@ -4213,7 +4214,8 @@ static struct virtio_device_id id_table[] = {
>  	VIRTIO_NET_F_CTRL_MAC_ADDR, \
>  	VIRTIO_NET_F_MTU, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
>  	VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY, \
> -	VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT, VIRTIO_NET_F_NOTF_COAL
> +	VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT, VIRTIO_NET_F_NOTF_COAL, \
> +	VIRTIO_NET_F_GUEST_HDRLEN
>  
>  static unsigned int features[] = {
>  	VIRTNET_FEATURES,
> diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
> index b4062bed186a..12c1c9699935 100644
> --- a/include/uapi/linux/virtio_net.h
> +++ b/include/uapi/linux/virtio_net.h
> @@ -61,6 +61,7 @@
>  #define VIRTIO_NET_F_GUEST_USO6	55	/* Guest can handle USOv6 in. */
>  #define VIRTIO_NET_F_HOST_USO	56	/* Host can handle USO in. */
>  #define VIRTIO_NET_F_HASH_REPORT  57	/* Supports hash report */
> +#define VIRTIO_NET_F_GUEST_HDRLEN  59	/* Guest provides the exact hdr_len value. */
>  #define VIRTIO_NET_F_RSS	  60	/* Supports RSS RX steering */
>  #define VIRTIO_NET_F_RSC_EXT	  61	/* extended coalescing info */
>  #define VIRTIO_NET_F_STANDBY	  62	/* Act as standby for another device
> -- 
> 2.39.0


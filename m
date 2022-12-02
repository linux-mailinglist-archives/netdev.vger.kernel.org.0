Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C95E640405
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 11:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233150AbiLBKEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 05:04:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232536AbiLBKEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 05:04:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A068D4C266
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 02:03:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669975410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=n9awmabG6XvbNEKd1oVF0XKSctjBCIkEyRVzKA78FSM=;
        b=h0u4/AbGsy0qmFLyEFn4dbqh1xwayqg2OuVW0x5KZ3aN63kGCHxjy+oQGpm8jka5xJiX0D
        xaPGS+CASFjSmtEB09mKF3AWwO2pxxwCtOrUB2JHqZYcBzG7Lq5vSmongcZ1goxz8mmE0m
        g0xGseYTQDvKHuapAdVahNvN0ywpmV0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-88--PTJoodtP8Sb9SPlDSiUMA-1; Fri, 02 Dec 2022 05:03:29 -0500
X-MC-Unique: -PTJoodtP8Sb9SPlDSiUMA-1
Received: by mail-wr1-f72.google.com with SMTP id t12-20020adfa2cc000000b0022adcbb248bso937698wra.1
        for <netdev@vger.kernel.org>; Fri, 02 Dec 2022 02:03:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n9awmabG6XvbNEKd1oVF0XKSctjBCIkEyRVzKA78FSM=;
        b=s9BiAC5tGqTVqTMeqd42O/qAs7R0YWT8+UwFB6Vf3YDYs375SU96bBEsX71glJUys2
         QQE6P98Uvjm0dCnv66rLy9uE6iL62GoMqoR9lPUCyw20Of5tdoXz0WuDtoFNE+2HP90o
         ucIrUmTSMjV2vU72UNwqQzjrEuD6g7jYVJwDH6rGSWvc7MUHKu6XqPNqTy2tebJiY43C
         K8XZDG9/Cpw7rGzNjkOlLtVVXQij0KECGEWOXWolWWtZHTSCb6U1U4BSCAr/lZEjV6P3
         kjIhIKhZgGhjGOLahtDyFJYKOZuNcjxyFucW4NrTJ54TKZNz1hlplaP00Aw8wOJQONmk
         O+4A==
X-Gm-Message-State: ANoB5pnjkvRtCqs1Ihkw/Sei/krf7air304POuaA6eojJMXuI+gUuLI1
        3JobGHUzYcV2UxqG8GZc4w6tHRvIGYewxoezcedncN+v6BRhtEaDfuhkCMLZQ+tXyKDn3Tdp1D6
        JyX+8ls1abMPSHlW4
X-Received: by 2002:adf:dbcd:0:b0:242:1294:5174 with SMTP id e13-20020adfdbcd000000b0024212945174mr16694578wrj.249.1669975408253;
        Fri, 02 Dec 2022 02:03:28 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6QQzz2WQf7FwPPGbf38zlKpQ+ep18wbfi3hGdiVjM24Y7h+bdOIA1f/rLK+OFoxrrZJquhlw==
X-Received: by 2002:adf:dbcd:0:b0:242:1294:5174 with SMTP id e13-20020adfdbcd000000b0024212945174mr16694570wrj.249.1669975408027;
        Fri, 02 Dec 2022 02:03:28 -0800 (PST)
Received: from redhat.com ([2.52.16.138])
        by smtp.gmail.com with ESMTPSA id w6-20020adfec46000000b0022efc4322a9sm6895537wrn.10.2022.12.02.02.03.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 02:03:27 -0800 (PST)
Date:   Fri, 2 Dec 2022 05:03:23 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Andrew Melnychenko <andrew@daynix.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jasowang@redhat.com, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, devel@daynix.com
Subject: Re: [PATCH v4 4/6] uapi/linux/virtio_net.h: Added USO types.
Message-ID: <20221202050230-mutt-send-email-mst@kernel.org>
References: <20221201223332.249441-1-andrew@daynix.com>
 <20221201223332.249441-4-andrew@daynix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221201223332.249441-4-andrew@daynix.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 02, 2022 at 12:33:30AM +0200, Andrew Melnychenko wrote:
> Added new GSO type for USO: VIRTIO_NET_HDR_GSO_UDP_L4.
> Feature VIRTIO_NET_F_HOST_USO allows to enable NETIF_F_GSO_UDP_L4.
> Separated VIRTIO_NET_F_GUEST_USO4 & VIRTIO_NET_F_GUEST_USO6 features
> required for Windows guests.
> 
> Signed-off-by: Andrew Melnychenko <andrew@daynix.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  include/uapi/linux/virtio_net.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
> index 6cb842ea8979..cbc631247489 100644
> --- a/include/uapi/linux/virtio_net.h
> +++ b/include/uapi/linux/virtio_net.h
> @@ -57,6 +57,10 @@
>  					 * Steering */
>  #define VIRTIO_NET_F_CTRL_MAC_ADDR 23	/* Set MAC address */
>  #define VIRTIO_NET_F_NOTF_COAL	53	/* Device supports notifications coalescing */
> +#define VIRTIO_NET_F_GUEST_USO4	54	/* Guest can handle USOv4 in. */
> +#define VIRTIO_NET_F_GUEST_USO6	55	/* Guest can handle USOv6 in. */
> +#define VIRTIO_NET_F_HOST_USO	56	/* Host can handle USO in. */
> +

for consistency pls don't add an empty line here.

>  #define VIRTIO_NET_F_HASH_REPORT  57	/* Supports hash report */
>  #define VIRTIO_NET_F_RSS	  60	/* Supports RSS RX steering */
>  #define VIRTIO_NET_F_RSC_EXT	  61	/* extended coalescing info */
> @@ -130,6 +134,7 @@ struct virtio_net_hdr_v1 {
>  #define VIRTIO_NET_HDR_GSO_TCPV4	1	/* GSO frame, IPv4 TCP (TSO) */
>  #define VIRTIO_NET_HDR_GSO_UDP		3	/* GSO frame, IPv4 UDP (UFO) */
>  #define VIRTIO_NET_HDR_GSO_TCPV6	4	/* GSO frame, IPv6 TCP */
> +#define VIRTIO_NET_HDR_GSO_UDP_L4	5	/* GSO frame, IPv4& IPv6 UDP (USO) */
>  #define VIRTIO_NET_HDR_GSO_ECN		0x80	/* TCP has ECN set */
>  	__u8 gso_type;
>  	__virtio16 hdr_len;	/* Ethernet + IP + tcp/udp hdrs */
> -- 
> 2.38.1


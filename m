Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A749C63FAA1
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 23:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbiLAWeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 17:34:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiLAWeS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 17:34:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09C0463D44
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 14:33:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669933998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/2O4LegilVsQdyPuKZbJssTZDoZcgdukJ0d/d1p6i90=;
        b=BIMoCMBskBt6lB+bwRtfCrGpaHG5GEgV6YlIRMTfrFjW6EwOEEhRJFvBFSLPGgf8yqcppF
        694/wi4UM30oeRFKJvcAtJHlR/1V4aQcuAAGvLxfzSHH9xT30eFq5GkOlPVybxEv35dRbD
        9Tqgxje/cE/Td+6CNqQQ0xDw3xuB4DA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-356-bjB0CHPbMf2vN_X6lt3cTg-1; Thu, 01 Dec 2022 17:33:17 -0500
X-MC-Unique: bjB0CHPbMf2vN_X6lt3cTg-1
Received: by mail-wr1-f70.google.com with SMTP id o8-20020adfba08000000b00241e80f08e0so691673wrg.12
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 14:33:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/2O4LegilVsQdyPuKZbJssTZDoZcgdukJ0d/d1p6i90=;
        b=ryAp/41Rcpt9VcUOy72A0/5X/hnP/wbeZNZJ2+H0yUb9MiaSFcJ0boFzqx3uz1fbrz
         4vfqkC4JB+HLQ/m+p7UXZhV5WLaPyDPlNnZN9zWUs7qCCNOGNKXniiPkSG3KGPMav9mY
         3qEM68auUU+GoLWNZA+yrrwpa3fyiDKt/bEWVkoXExzumdUxfkIF2inF25c2eKBJab9s
         jS93lnizXl4FH4yiPz6Coq03fAOQ61+pfcFJSQHV/KedX6I+6mZz4tcloa2PRy3wTV4E
         hTOARPiqaClyHg96eaTLMBkp14lH/tlDO7cixnZZXpJGyNBAgvQsWiZT88MzTRAOFCag
         YkxQ==
X-Gm-Message-State: ANoB5pnNccKuAeU/oUqpfou9nbwTfFSc+Ec+rlhrXItj01vfppYhsImZ
        kNdddqz1C2GOqhxSHKc+WmYs1LXQx5LQwbAZUzcUccV+/1Xdapz5x4aaM3tsPX3HCgIKRcFiImE
        WKnIhEoWVpL8WYgug
X-Received: by 2002:adf:f60f:0:b0:22e:6564:e987 with SMTP id t15-20020adff60f000000b0022e6564e987mr42165683wrp.401.1669933995892;
        Thu, 01 Dec 2022 14:33:15 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4SwqSn8+94MC8XNNJvmxjUkYSbcbXFohTxf/WlvTlCWz77FFhQffJ2sV3nppJe5VRZILk7iQ==
X-Received: by 2002:adf:f60f:0:b0:22e:6564:e987 with SMTP id t15-20020adff60f000000b0022e6564e987mr42165669wrp.401.1669933995602;
        Thu, 01 Dec 2022 14:33:15 -0800 (PST)
Received: from redhat.com ([2.52.16.138])
        by smtp.gmail.com with ESMTPSA id l9-20020a05600c2cc900b003cf9bf5208esm9663857wmc.19.2022.12.01.14.33.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 14:33:15 -0800 (PST)
Date:   Thu, 1 Dec 2022 17:33:11 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Andrew Melnychenko <andrew@daynix.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jasowang@redhat.com, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, devel@daynix.com
Subject: Re: [PATCH v4 0/6] TUN/VirtioNet USO features support.
Message-ID: <20221201173252-mutt-send-email-mst@kernel.org>
References: <20221201215644.246571-1-andrew@daynix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221201215644.246571-1-andrew@daynix.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 01, 2022 at 11:56:38PM +0200, Andrew Melnychenko wrote:
> Added new offloads for TUN devices TUN_F_USO4 and TUN_F_USO6.
> Technically they enable NETIF_F_GSO_UDP_L4
> (and only if USO4 & USO6 are set simultaneously).
> It allows the transmission of large UDP packets.
> 
> UDP Segmentation Offload (USO/GSO_UDP_L4) - ability to split UDP packets
> into several segments. It's similar to UFO, except it doesn't use IP
> fragmentation. The drivers may push big packets and the NIC will split
> them(or assemble them in case of receive), but in the case of VirtioNet
> we just pass big UDP to the host. So we are freeing the driver from doing
> the unnecessary job of splitting. The same thing for several guests
> on one host, we can pass big packets between guests.
> 
> Different features USO4 and USO6 are required for qemu where Windows
> guests can enable disable USO receives for IPv4 and IPv6 separately.
> On the other side, Linux can't really differentiate USO4 and USO6, for now.
> For now, to enable USO for TUN it requires enabling USO4 and USO6 together.
> In the future, there would be a mechanism to control UDP_L4 GSO separately.
> 
> New types for virtio-net already in virtio-net specification:
> https://github.com/oasis-tcs/virtio-spec/issues/120
> 
> Test it WIP Qemu https://github.com/daynix/qemu/tree/USOv3
> 
> Andrew (5):
>   uapi/linux/if_tun.h: Added new offload types for USO4/6.
>   driver/net/tun: Added features for USO.
>   uapi/linux/virtio_net.h: Added USO types.
>   linux/virtio_net.h: Support USO offload in vnet header.
>   drivers/net/virtio_net.c: Added USO support.
> 
> Andrew Melnychenko (1):
>   udp: allow header check for dodgy GSO_UDP_L4 packets.

I don't see patches except 0 on list.

>  drivers/net/tap.c               | 10 ++++++++--
>  drivers/net/tun.c               |  8 +++++++-
>  drivers/net/virtio_net.c        | 24 +++++++++++++++++++++---
>  include/linux/virtio_net.h      |  9 +++++++++
>  include/uapi/linux/if_tun.h     |  2 ++
>  include/uapi/linux/virtio_net.h |  5 +++++
>  net/ipv4/udp_offload.c          |  3 ++-
>  net/ipv6/udp_offload.c          |  3 ++-
>  8 files changed, 56 insertions(+), 8 deletions(-)
> 
> -- 
> 2.38.1
> 
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization
> 


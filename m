Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2393050950B
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 04:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243732AbiDUCfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 22:35:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiDUCfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 22:35:02 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB922BC
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 19:32:14 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id ga4-20020a17090b038400b001d4b33c74ccso2639671pjb.1
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 19:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=46L8jCZ6x8xV0fBOzBFQCDyUC4oxiKRLy9gbSja1o78=;
        b=FkY1vlJyc7EQBXGTIbUZAqLxBjl82wDnDAIPc6oX4s0oW5hJjeQcCVmnlQy8gjHv9e
         MhV4Eb9aoY+FPNKwrcwdDHQCqQj9ScIuhU+7XpTly1PLbD//zqJSET9ydpS53jua3WmY
         9j5lvgtrYdGsTlDg6djp9YFz9ISYFWRPCUVja2UNev4pRCOXNiaxbd8t9IYWqWVlhS+t
         PWr64Gjb3BHn6kvlHuLmRsIxzioc3kzyimgmaIpnIhsJzvbpOGSa/ghgcs6E1e1dxJKe
         B9kNVJbJoynxKDj0W7P5SgGpuuvC5U8P9ZHZNbbHeLMmbT6lVDfqajX7o5rMqS+ogSsM
         JzzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=46L8jCZ6x8xV0fBOzBFQCDyUC4oxiKRLy9gbSja1o78=;
        b=xb0q1knYrBnIO1yGV7c8NgB1DhseIOwReHn4E/V4CKx66lm4aWe7sBiwHjI5zdxJyZ
         9xt6iA0iH1qrZbUHSL11MzwPnLfdbbbrrGffzB4P+VD2iFYYD0kOL9iBHYnKu/T3TPun
         agHLl4Kg6lzNJTvDSIMFQg6BtGDSicGXI402RlSKe/Lq00XBFUQz9bF6hhQN92FhbH9B
         vBUA4zj3br4ccQX8xNXdOYxJq8zKJa4g3W8hoVSj4M8m/XjamOEa+fQkoApVRrNIqVIF
         ZniE8VIdeKFeD8OI2uqcFi735ZSid+vZK5H2KAYjbR7L/mA8KuDJ/0d/WwwkgG2C+K/v
         3nAA==
X-Gm-Message-State: AOAM530j0IJ1E1a3mBTEVG4CbvXysFKxqy+4LIngNNvClJRQW1lCGqGi
        rZJ7/RmRzS3XcwAsjWJwM/Y=
X-Google-Smtp-Source: ABdhPJym07Kre7IF2GbSNvDzKwEnGCBfWL3CZM4v82FzKOv19fdaSc3xJ3TAh/YmRL/RvsMl4LQHWA==
X-Received: by 2002:a17:90b:1807:b0:1d5:540d:4b6a with SMTP id lw7-20020a17090b180700b001d5540d4b6amr3107094pjb.240.1650508333620;
        Wed, 20 Apr 2022 19:32:13 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d206-20020a621dd7000000b0050acf2c1303sm2999148pfd.107.2022.04.20.19.32.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 19:32:12 -0700 (PDT)
Date:   Thu, 21 Apr 2022 10:31:56 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        virtualization@lists.linux-foundation.org,
        Balazs Nemeth <bnemeth@redhat.com>,
        Mike Pattrick <mpattric@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next] net/af_packet: add VLAN support for AF_PACKET
 SOCK_RAW GSO
Message-ID: <YmDCHI330AUfcYKa@Laptop-X1>
References: <20220420082758.581245-1-liuhangbin@gmail.com>
 <CA+FuTScyF4BKEcNSCYOv8SBA_EmB806YtKA17jb3F+fymVF-Pg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTScyF4BKEcNSCYOv8SBA_EmB806YtKA17jb3F+fymVF-Pg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 20, 2022 at 09:45:15AM -0400, Willem de Bruijn wrote:
> On Wed, Apr 20, 2022 at 4:28 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
> >
> > Currently, the kernel drops GSO VLAN tagged packet if it's created with
> > socket(AF_PACKET, SOCK_RAW, 0) plus virtio_net_hdr.
> >
> > The reason is AF_PACKET doesn't adjust the skb network header if there is
> > a VLAN tag. Then after virtio_net_hdr_set_proto() called, the skb->protocol
> > will be set to ETH_P_IP/IPv6. And in later inet/ipv6_gso_segment() the skb
> > is dropped as network header position is invalid.
> >
> > Let's handle VLAN packets by adjusting network header position in
> > packet_parse_headers(), and move the function in packet_snd() before
> > calling virtio_net_hdr_set_proto().
> 
> The network header is set in
> 
>         skb_reset_network_header(skb);
> 
>         err = -EINVAL;
>         if (sock->type == SOCK_DGRAM) {
>                 offset = dev_hard_header(skb, dev, ntohs(proto), addr,
> NULL, len);
>                 if (unlikely(offset < 0))
>                         goto out_free;
>         } else if (reserve) {
>                 skb_reserve(skb, -reserve);
>                 if (len < reserve + sizeof(struct ipv6hdr) &&
>                     dev->min_header_len != dev->hard_header_len)
>                         skb_reset_network_header(skb);
>         }
> 
> If all that is needed is to move the network header beyond an optional
> VLAN tag in the case of SOCK_RAW, then this can be done in the else
> for Ethernet packets.

Before we set network position, we need to check the skb->protocol to make
sure it's a VLAN packet.

If we set skb->protocol and adjust network header here, like
packet_parse_headers() does. How should we do with later

        skb->protocol = proto;
        skb->dev = dev;

settings?

If you are afraid that skb_probe_transport_header(skb) would affect the
virtio_net_hdr operation. How about split the skb_probe_transport_header()
from packet_parse_headers()? Something like

--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1924,13 +1924,19 @@ static int packet_rcv_spkt(struct sk_buff *skb, struct net_device *dev,

 static void packet_parse_headers(struct sk_buff *skb, struct socket *sock)
 {
+       int depth;
+
        if ((!skb->protocol || skb->protocol == htons(ETH_P_ALL)) &&
            sock->type == SOCK_RAW) {
                skb_reset_mac_header(skb);
                skb->protocol = dev_parse_header_protocol(skb);
        }

-       skb_probe_transport_header(skb);
+       /* Move network header to the right position for VLAN tagged packets */
+       if (likely(skb->dev->type == ARPHRD_ETHER) &&
+           eth_type_vlan(skb->protocol) &&
+           __vlan_get_protocol(skb, skb->protocol, &depth) != 0)
+               skb_set_network_header(skb, depth);
 }

 /*
@@ -3047,6 +3055,8 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
        skb->mark = sockc.mark;
        skb->tstamp = sockc.transmit_time;

+       packet_parse_headers(skb, sock);
+
        if (has_vnet_hdr) {
                err = virtio_net_hdr_to_skb(skb, &vnet_hdr, vio_le());
                if (err)
@@ -3055,7 +3065,7 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
                virtio_net_hdr_set_proto(skb, &vnet_hdr);
        }

-       packet_parse_headers(skb, sock);
+       skb_probe_transport_header(skb);

        if (unlikely(extra_len == 4))
                skb->no_fcs = 1;


> 
> It is not safe to increase reserve, as that would eat into the
> reserved hlen LL_RESERVED_SPACE(dev), which does not account for
> optional VLAN headers.
> 
> Instead of setting here first, then patching up again later in
> packet_parse_headers.
> 
> This change affects all packets with VLAN headers, not just those with
> GSO. I imagine that moving the network header is safe for all, but
> don't know that code well enough to verify that it does not have
> unintended side effects. Does dev_queue_xmit expect the network header
> to point to the start of the VLAN headers or after, for instance?

I think adjust the network position should be safe, as tap device also did that.

Thanks
Hangbin

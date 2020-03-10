Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 942FA17F0B6
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 07:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726244AbgCJGnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 02:43:13 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53159 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725919AbgCJGnN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 02:43:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583822592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XeHR2vOfelMUkQttsgwhPIHttmwjAMJvHP1q+S8R+fg=;
        b=ewEmVug1C/h8peeP4C56PR2C+ghY5ifmusGRdNvZMRoLc/GBDUliIeXol7qSZ3FLsZA00A
        MiTBco17KSFr9OqI2ZFD1UgBTo/j3sxDmhB/WPNFABmkmJwgxckV8DqgpQf1Ue5gaaz27C
        cVpE1iec4w4fSD+JJhWIUQfjv0ABq60=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-U5z5gdkFNUiUspQYSruW9A-1; Tue, 10 Mar 2020 02:43:10 -0400
X-MC-Unique: U5z5gdkFNUiUspQYSruW9A-1
Received: by mail-qk1-f199.google.com with SMTP id k194so9042963qke.10
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 23:43:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XeHR2vOfelMUkQttsgwhPIHttmwjAMJvHP1q+S8R+fg=;
        b=F40DkKbFxW/HPIjb0ssTMFCE8RXwsDGEkULrEwKvgQ+s44hCvXlP6nDUdl1dcjtH3d
         7hCuIEn2WV2Lzep80Z0hSjY8eTMye0t+44ymZsYzyzGykYS0fUZOG3snQmnZzqKCq4ph
         IsWpQ4c6FYwyhmZ+JyNqHHSWTaVgK3xDJZYJJEyv5VNMjT/X6EqqDa9vGvJPBbaMQk8f
         dKqiB9nau/XPyA9RGR9ZrakDjniofmhR7KlFhECiPkEmf3RB8nKYtCGwR4fL39UlZpYs
         r9FM/4emom4oq/FGShqx06S2zrQnzz9g1VChbioUx/WfhCfvtR0JZuRCs+pYkkaIgNgC
         V9fA==
X-Gm-Message-State: ANhLgQ2piC5K/9mUz4XeZcaHAtY9anzZ1/N+SZZTz03rkd7RBslg1PPM
        FhiY2OhNpWT457yikBL9t3ROb2eiulUAByIrEj07qQ6n77fhdHgIno7r9ymlhvxxH6vBbCD7mJ/
        CGLZaQDkkHSlXw6za
X-Received: by 2002:a37:b902:: with SMTP id j2mr16483355qkf.247.1583822590347;
        Mon, 09 Mar 2020 23:43:10 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtjJMy7kVZseBdf5oNvgTw9c5a0qiS/bkS1LBhyfF1TwHMOZc6cOASuIkSaPyW2wncf2gF8JQ==
X-Received: by 2002:a37:b902:: with SMTP id j2mr16483341qkf.247.1583822590121;
        Mon, 09 Mar 2020 23:43:10 -0700 (PDT)
Received: from redhat.com (bzq-79-178-2-19.red.bezeqint.net. [79.178.2.19])
        by smtp.gmail.com with ESMTPSA id 10sm2885472qtt.65.2020.03.09.23.43.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 23:43:09 -0700 (PDT)
Date:   Tue, 10 Mar 2020 02:43:05 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH net] net/packet: tpacket_rcv: do not increment ring index
 on drop
Message-ID: <20200310023528-mutt-send-email-mst@kernel.org>
References: <20200309153435.32109-1-willemdebruijn.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200309153435.32109-1-willemdebruijn.kernel@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 09, 2020 at 11:34:35AM -0400, Willem de Bruijn wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> In one error case, tpacket_rcv drops packets after incrementing the
> ring producer index.
> 
> If this happens, it does not update tp_status to TP_STATUS_USER and
> thus the reader is stalled for an iteration of the ring, causing out
> of order arrival.
> 
> The only such error path is when virtio_net_hdr_from_skb fails due
> to encountering an unknown GSO type.
> 
> Signed-off-by: Willem de Bruijn <willemb@google.com>
> 
> ---
> 
> I wonder whether it should drop packets with unknown GSO types at all.
> This consistently blinds the reader to certain packets, including
> recent UDP and SCTP GSO types.

Ugh it looks like you have found a bug.  Consider a legacy userspace -
it was actually broken by adding USD and SCTP GSO.  I suspect the right
thing to do here is actually to split these packets up, not drop them.


> The peer function virtio_net_hdr_to_skb already drops any packets with
> unknown types, so it should be fine to add an SKB_GSO_UNKNOWN type and
> let the peer at least be aware of failure.
> 
> And possibly add SKB_GSO_UDP_L4 and SKB_GSO_SCTP types to virtio too.

This last one is possible for sure, but for virtio_net_hdr_from_skb
we'll need more flags to know whether it's safe to pass
these types to userspace.


> ---
>  net/packet/af_packet.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index 30c6879d6774..e5b0986215d2 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -2274,6 +2274,13 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
>  					TP_STATUS_KERNEL, (macoff+snaplen));
>  	if (!h.raw)
>  		goto drop_n_account;
> +
> +	if (do_vnet &&
> +	    virtio_net_hdr_from_skb(skb, h.raw + macoff -
> +				    sizeof(struct virtio_net_hdr),
> +				    vio_le(), true, 0))
> +		goto drop_n_account;
> +
>  	if (po->tp_version <= TPACKET_V2) {
>  		packet_increment_rx_head(po, &po->rx_ring);
>  	/*
> @@ -2286,12 +2293,6 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
>  			status |= TP_STATUS_LOSING;
>  	}
>  
> -	if (do_vnet &&
> -	    virtio_net_hdr_from_skb(skb, h.raw + macoff -
> -				    sizeof(struct virtio_net_hdr),
> -				    vio_le(), true, 0))
> -		goto drop_n_account;
> -
>  	po->stats.stats1.tp_packets++;
>  	if (copy_skb) {
>  		status |= TP_STATUS_COPY;
> -- 
> 2.25.1.481.gfbce0eb801-goog


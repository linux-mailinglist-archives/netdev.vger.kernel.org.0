Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5333323EE
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 12:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbhCIL0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 06:26:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58187 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229544AbhCIL0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 06:26:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615289175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QJTu97af+WLCQFYiPKebiLOkL3siT4cw4KW3jFKHkGM=;
        b=JTkw02qxwdqGxdbjofEMDXVLXkMt2vmGoggdI7qQaRUvucN18o6RbTOCKgTwKYfLAy8qkt
        c0lcoZ2RYzyIbmuy9hLHbYwnMU4/2rhgcH5tDWiDwh4t9nNR7MVR6z1ZAkfChZVzgI0yQg
        mnkVBqgUA4b0mtVQWC4RKzz3qKFLfXo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-11-RbZJnIHiN3OehPaxmTGKbg-1; Tue, 09 Mar 2021 06:26:14 -0500
X-MC-Unique: RbZJnIHiN3OehPaxmTGKbg-1
Received: by mail-wr1-f72.google.com with SMTP id y5so6287682wrp.2
        for <netdev@vger.kernel.org>; Tue, 09 Mar 2021 03:26:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QJTu97af+WLCQFYiPKebiLOkL3siT4cw4KW3jFKHkGM=;
        b=Wc+OrcNtQVbGfre1c2mBHpqlL6a8l5dh/6XcKFF9v8bI7X/77zYG+g5FCqx5lBp2sw
         g3ZzEMcpoHUiAjG2Ms2eAwrKXPLWuV5dglJa18fJHPDTexgZ4esjTu+Z7kEqPUYs5quI
         q9fxGXLKQIT9AKfRo3QkPzCjpIZ541C73syDbj9Gg3gxtEf/ZLqijrf/r7mVdRd5ndG3
         Rzv6BWC8X2FCpThBw2f7skLgRoXEIzKjQXZx9U8Lexqc5tyiOLiyPpJkCq4A2lxKA0a+
         Dliqwl/AxiPS3S2xqYo+Ljhvmp6xWlDUAGf6bC6V9M47l/3KQHnA+HyykaNPQ7qU3ANQ
         s5ig==
X-Gm-Message-State: AOAM530rMaXEhTAR4x8Farlq2sAHro4iYYu51MtZRdetfgzK6PJ338kA
        /BpAuDSpzTvhDkASYhmclvKuWAt4IH3wLd4ntruOp1r61Yso+RHlfaOCOY08HxCsN+vLBQHHd5M
        XZKYm6mieW8Cx5VvJ
X-Received: by 2002:a1c:67d6:: with SMTP id b205mr3538408wmc.118.1615289170673;
        Tue, 09 Mar 2021 03:26:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxGyKCvOiCoJXkY1zxim1zjyVYdNBYQs3pqMhTrVxV5v8BM0tI/MjusSGpEIQUXq09e+JkHjw==
X-Received: by 2002:a1c:67d6:: with SMTP id b205mr3538382wmc.118.1615289170481;
        Tue, 09 Mar 2021 03:26:10 -0800 (PST)
Received: from redhat.com (bzq-79-180-2-31.red.bezeqint.net. [79.180.2.31])
        by smtp.gmail.com with ESMTPSA id f17sm22314511wru.31.2021.03.09.03.26.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 03:26:09 -0800 (PST)
Date:   Tue, 9 Mar 2021 06:26:06 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Balazs Nemeth <bnemeth@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jasowang@redhat.com, davem@davemloft.net, willemb@google.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v2 1/2] net: check if protocol extracted by
 virtio_net_hdr_set_proto is correct
Message-ID: <20210309062116-mutt-send-email-mst@kernel.org>
References: <cover.1615199056.git.bnemeth@redhat.com>
 <8f2cb8f8614d86bba02df73c1a0665179583f1c3.1615199056.git.bnemeth@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f2cb8f8614d86bba02df73c1a0665179583f1c3.1615199056.git.bnemeth@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 08, 2021 at 11:31:25AM +0100, Balazs Nemeth wrote:
> For gso packets, virtio_net_hdr_set_proto sets the protocol (if it isn't
> set) based on the type in the virtio net hdr, but the skb could contain
> anything since it could come from packet_snd through a raw socket. If
> there is a mismatch between what virtio_net_hdr_set_proto sets and
> the actual protocol, then the skb could be handled incorrectly later
> on.
> 
> An example where this poses an issue is with the subsequent call to
> skb_flow_dissect_flow_keys_basic which relies on skb->protocol being set
> correctly. A specially crafted packet could fool
> skb_flow_dissect_flow_keys_basic preventing EINVAL to be returned.
> 
> Avoid blindly trusting the information provided by the virtio net header
> by checking that the protocol in the packet actually matches the
> protocol set by virtio_net_hdr_set_proto. Note that since the protocol
> is only checked if skb->dev implements header_ops->parse_protocol,
> packets from devices without the implementation are not checked at this
> stage.
> 
> Fixes: 9274124f023b ("net: stricter validation of untrusted gso packets")
> Signed-off-by: Balazs Nemeth <bnemeth@redhat.com>
> ---
>  include/linux/virtio_net.h | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
> index e8a924eeea3d..6c478eee0452 100644
> --- a/include/linux/virtio_net.h
> +++ b/include/linux/virtio_net.h
> @@ -79,8 +79,14 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
>  		if (gso_type && skb->network_header) {
>  			struct flow_keys_basic keys;
>  
> -			if (!skb->protocol)
> +			if (!skb->protocol) {
> +				const struct ethhdr *eth = skb_eth_hdr(skb);
> +				__be16 etype = dev_parse_header_protocol(skb);
> +
>  				virtio_net_hdr_set_proto(skb, hdr);
> +				if (etype && etype != skb->protocol)
> +					return -EINVAL;
> +			}


Well the protocol in the header is an attempt at an optimization to
remove need to parse the packet ... any data on whether this
affecs performance?

>  retry:
>  			if (!skb_flow_dissect_flow_keys_basic(NULL, skb, &keys,
>  							      NULL, 0, 0, 0,
> -- 
> 2.29.2


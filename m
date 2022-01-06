Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63DA3485F2D
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 04:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbiAFDXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 22:23:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiAFDW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 22:22:59 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45355C061245
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 19:22:59 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id p65so1564967iof.3
        for <netdev@vger.kernel.org>; Wed, 05 Jan 2022 19:22:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=sHi57HV++5xv/ykq/23Y/LNrIk8wzH2AVC1hz3SfaOM=;
        b=ivDozmdpG2xf/ey/A89FRGkA3CNSYDgWe25cn/MyliTxx6EAk99aa2tDdnTMtDN/N9
         XcVi6PUi+yyGExCwP6Ycd0SWltmrXTtkcrOCVG4VEguBwO0G3S554Yf7KP7bPvjtG+ME
         DpTVtRG9v/2uv5B2SuBxBVDMISocUxw5ZNL45QCA7FJvCdhgTlHjNCHRa5zsLkobZtlh
         fANmaAw5n3lCotrHIf87+z4BAxhAa56vhizuGn8+MHzVuD/soluDeTo4Z34XJESQlfsm
         +u8yL28j5Qq+AMBQHInBWJ+ueXrNGsRLENrcwyVZBIiHXEU425WVoX8HoGIsuss81/aY
         5Vnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=sHi57HV++5xv/ykq/23Y/LNrIk8wzH2AVC1hz3SfaOM=;
        b=QanE41L/VZ23tYbos7+owyenXCVXclBCpFg/T2kaRNo/g+jpeFyqO9QiJL/zwxkU9z
         SQQslIdVU7Ju3jfW3LYJlsatgonfByHQ3PX2h7lbc5YiGNQZ1mtZOz9Acx/kUlRFyp+A
         uCybf8LkeHfukelzaFWx5L74gmDikgtrRzSYJW2QIK+ppNQahx1xmQ3ekkpINGoLhNLm
         jFslY9qbUqc1BZrFBo5UIFmt3DsApY9sUJRhTUosCjzvWplN7uO6k/YIpIzwz4wJogMM
         Pa3WW64EcD/ltyIn0GZX7At4vjqguxFQ046qa9MVtdjxDNg+O0y9NnOWB4StygRkCU9K
         13uQ==
X-Gm-Message-State: AOAM533dZdCuEijsnQJnyP8VkBIzq4V11Y7+wbWIzINo1vlBlw6mhLwo
        r6rhIg5Crk9GDv9duTZS7MvTZvJoQlU=
X-Google-Smtp-Source: ABdhPJxg2xukV36VTVa9Z2T50c7y6nQUSt8QYDztFoRGdYEmLI1qUfi1UQCe84BRFhghyONxmmWVpw==
X-Received: by 2002:a05:6638:11c5:: with SMTP id g5mr26867710jas.47.1641439378595;
        Wed, 05 Jan 2022 19:22:58 -0800 (PST)
Received: from localhost ([99.197.200.79])
        by smtp.gmail.com with ESMTPSA id k7sm493291iom.34.2022.01.05.19.22.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 19:22:58 -0800 (PST)
Date:   Wed, 05 Jan 2022 19:22:49 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, laurent.bernaille@datadoghq.com,
        maciej.fijalkowski@intel.com, toshiaki.makita1@gmail.com,
        eric.dumazet@gmail.com, pabeni@redhat.com,
        john.fastabend@gmail.com, willemb@google.com,
        Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <61d660891a4ed_6ee92085e@john.notmuch>
In-Reply-To: <ef4cf3168907944502c81d8bf45e24eea1061e47.1641427152.git.daniel@iogearbox.net>
References: <ef4cf3168907944502c81d8bf45e24eea1061e47.1641427152.git.daniel@iogearbox.net>
Subject: RE: [PATCH net-next] veth: Do not record rx queue hint in veth_xmit
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann wrote:
> Laurent reported that they have seen a significant amount of TCP retransmissions
> at high throughput from applications residing in network namespaces talking to
> the outside world via veths. The drops were seen on the qdisc layer (fq_codel,
> as per systemd default) of the phys device such as ena or virtio_net due to all
> traffic hitting a _single_ TX queue _despite_ multi-queue device. (Note that the
> setup was _not_ using XDP on veths as the issue is generic.)
> 
> More specifically, after edbea9220251 ("veth: Store queue_mapping independently
> of XDP prog presence") which made it all the way back to v4.19.184+,
> skb_record_rx_queue() would set skb->queue_mapping to 1 (given 1 RX and 1 TX
> queue by default for veths) instead of leaving at 0.
> 
> This is eventually retained and callbacks like ena_select_queue() will also pick
> single queue via netdev_core_pick_tx()'s ndo_select_queue() once all the traffic
> is forwarded to that device via upper stack or other means. Similarly, for others
> not implementing ndo_select_queue() if XPS is disabled, netdev_pick_tx() might
> call into the skb_tx_hash() and check for prior skb_rx_queue_recorded() as well.
> 
> In general, it is a _bad_ idea for virtual devices like veth to mess around with
> queue selection [by default]. Given dev->real_num_tx_queues is by default 1,
> the skb->queue_mapping was left untouched, and so prior to edbea9220251 the
> netdev_core_pick_tx() could do its job upon __dev_queue_xmit() on the phys device.
> 
> Unbreak this and restore prior behavior by removing the skb_record_rx_queue()
> from veth_xmit() altogether.
> 
> If the veth peer has an XDP program attached, then it would return the first RX
> queue index in xdp_md->rx_queue_index (unless configured in non-default manner).
> However, this is still better than breaking the generic case.

Agree on all the above. Fix LGTM thanks!

Acked-by: John Fastabend <john.fastabend@gmail.com>

> 
> Fixes: edbea9220251 ("veth: Store queue_mapping independently of XDP prog presence")
> Fixes: 638264dc9022 ("veth: Support per queue XDP ring")
> Reported-by: Laurent Bernaille <laurent.bernaille@datadoghq.com>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Cc: Toshiaki Makita <toshiaki.makita1@gmail.com>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Willem de Bruijn <willemb@google.com>
> ---
>  drivers/net/veth.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index d21dd25f429e..354a963075c5 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -335,7 +335,6 @@ static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
>  		 */
>  		use_napi = rcu_access_pointer(rq->napi) &&
>  			   veth_skb_is_eligible_for_gro(dev, rcv, skb);
> -		skb_record_rx_queue(skb, rxq);
>  	}
>  
>  	skb_tx_timestamp(skb);
> -- 
> 2.21.0
> 



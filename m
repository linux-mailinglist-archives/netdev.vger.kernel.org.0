Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DCC154AB40
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 09:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355140AbiFNH4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 03:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237682AbiFNH4G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 03:56:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CE411286C8
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 00:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655193364;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bqvjbHl4O7aAazVjgU0+rYNf6xag116Xp+xxmxTG8u8=;
        b=IYMS9TE44YlahnpIsfIWMWDZk+xZ8C6jJFfR25js0JMVFiQ2a+8AxnM8pfn9a9HUaKNmEe
        GuGRb2bSpkZMWx/g6+CnysBEYlCKn0uYsOBE97UMxz9/CibOoODoFbc/gUCd8ISQ95xORd
        98nCeg8uMZED+HM9Bh91E7eYLBBCo0U=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-169-LMbNYApUNAqPvNIwVYY67A-1; Tue, 14 Jun 2022 03:55:57 -0400
X-MC-Unique: LMbNYApUNAqPvNIwVYY67A-1
Received: by mail-qk1-f197.google.com with SMTP id j17-20020a05620a289100b006a6a4ffc9a3so6894831qkp.10
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 00:55:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=bqvjbHl4O7aAazVjgU0+rYNf6xag116Xp+xxmxTG8u8=;
        b=JramSkTXCRCuulpm1DCmFIqhdcA3/0j3J9yz3qJeXssMl+QFVbD460InXyheU0CyEI
         NLFCbqagxSgl2fQD13MZM9hIJGx/1FBS+KOODY9dQb848PJbqXxEuhy350oG2PedyDw4
         DjSoK9KhbO+28XN2k4EZBflqwhxWtke9OeydSAn2F1lps4rcOpT8ASLW8r6a7UgRE41Z
         5lR6yrINAEv6VUatY0JmncV7/dmfV9IsKu2W433dWbV+dEpdj3AJiVdixuQdemXYotDY
         +pI3Mcy8sgMev+e9T9k8Et6d5TZStz4IzmyXArusKMzhgLQvv0X4rq3hnsybTRNk8WwL
         YpoA==
X-Gm-Message-State: AOAM530t0GkBKtKrg8nKX/kam72bZQXj+sqk52pynPSI7Yt2dR2eC6ID
        INbBTwjx1XJ4qlfAZ+SjCYFB+/E/4Nz54ipGqRm8pVJGdmUU5vmJpN78L0dIJmbuqhVSm6IJie2
        yc7qwPF+nDKKZfHGK
X-Received: by 2002:a05:620a:258f:b0:680:f657:d3d0 with SMTP id x15-20020a05620a258f00b00680f657d3d0mr2953312qko.707.1655193357125;
        Tue, 14 Jun 2022 00:55:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxu05MQJVTTSqmNxmxBqfO72WFs2b0o9N2r99njW9ULp29VrSo+Y87mnXLsjrb79IGBDz6pnQ==
X-Received: by 2002:a05:620a:258f:b0:680:f657:d3d0 with SMTP id x15-20020a05620a258f00b00680f657d3d0mr2953293qko.707.1655193356780;
        Tue, 14 Jun 2022 00:55:56 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-113-202.dyn.eolo.it. [146.241.113.202])
        by smtp.gmail.com with ESMTPSA id y21-20020a05620a44d500b006a36b0d7f27sm9244895qkp.76.2022.06.14.00.55.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 00:55:56 -0700 (PDT)
Message-ID: <cd01402d7567184c39fc0cc884cd58232b2e65c9.camel@redhat.com>
Subject: Re: [PATCH net-next,2/2] net: mana: Add support of XDP_REDIRECT
 action
From:   Paolo Abeni <pabeni@redhat.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
Cc:     decui@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        paulros@microsoft.com, shacharr@microsoft.com, olaf@aepfle.de,
        vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Date:   Tue, 14 Jun 2022 09:55:48 +0200
In-Reply-To: <1654811828-25339-3-git-send-email-haiyangz@microsoft.com>
References: <1654811828-25339-1-git-send-email-haiyangz@microsoft.com>
         <1654811828-25339-3-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-06-09 at 14:57 -0700, Haiyang Zhang wrote:
> Support XDP_REDIRECT action
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

You really should expand the changelog a little bit...

> ---
>  drivers/net/ethernet/microsoft/mana/mana.h    |  6 ++
>  .../net/ethernet/microsoft/mana/mana_bpf.c    | 64 +++++++++++++++++++
>  drivers/net/ethernet/microsoft/mana/mana_en.c | 13 +++-
>  .../ethernet/microsoft/mana/mana_ethtool.c    | 12 +++-
>  4 files changed, 93 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/microsoft/mana/mana.h b/drivers/net/ethernet/microsoft/mana/mana.h
> index f198b34c232f..d58be64374c8 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana.h
> +++ b/drivers/net/ethernet/microsoft/mana/mana.h
> @@ -53,12 +53,14 @@ struct mana_stats_rx {
>  	u64 bytes;
>  	u64 xdp_drop;
>  	u64 xdp_tx;
> +	u64 xdp_redirect;
>  	struct u64_stats_sync syncp;
>  };
>  
>  struct mana_stats_tx {
>  	u64 packets;
>  	u64 bytes;
> +	u64 xdp_xmit;
>  	struct u64_stats_sync syncp;
>  };
>  
> @@ -311,6 +313,8 @@ struct mana_rxq {
>  	struct bpf_prog __rcu *bpf_prog;
>  	struct xdp_rxq_info xdp_rxq;
>  	struct page *xdp_save_page;
> +	bool xdp_flush;
> +	int xdp_rc; /* XDP redirect return code */
>  
>  	/* MUST BE THE LAST MEMBER:
>  	 * Each receive buffer has an associated mana_recv_buf_oob.
> @@ -396,6 +400,8 @@ int mana_probe(struct gdma_dev *gd, bool resuming);
>  void mana_remove(struct gdma_dev *gd, bool suspending);
>  
>  void mana_xdp_tx(struct sk_buff *skb, struct net_device *ndev);
> +int mana_xdp_xmit(struct net_device *ndev, int n, struct xdp_frame **frames,
> +		  u32 flags);
>  u32 mana_run_xdp(struct net_device *ndev, struct mana_rxq *rxq,
>  		 struct xdp_buff *xdp, void *buf_va, uint pkt_len);
>  struct bpf_prog *mana_xdp_get(struct mana_port_context *apc);
> diff --git a/drivers/net/ethernet/microsoft/mana/mana_bpf.c b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
> index 1d2f948b5c00..421fd39ff3a8 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_bpf.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
> @@ -32,9 +32,55 @@ void mana_xdp_tx(struct sk_buff *skb, struct net_device *ndev)
>  	ndev->stats.tx_dropped++;
>  }
>  
> +static int mana_xdp_xmit_fm(struct net_device *ndev, struct xdp_frame *frame,
> +			    u16 q_idx)
> +{
> +	struct sk_buff *skb;
> +
> +	skb = xdp_build_skb_from_frame(frame, ndev);
> +	if (unlikely(!skb))
> +		return -ENOMEM;

... especially considering this implementation choice: converting the
xdp frame to an skb in very bad for performances.

You could implement a mana xmit helper working on top of the xdp_frame
struct, and use it here.

Additionally you could consider revisiting the XDP_TX path: currently
it builds a skb from the xdp_buff to xmit it locally, while it could
resort to a much cheaper xdp_buff to xdp_frame conversion.

The traditional way to handle all the above is keep all the
XDP_TX/XDP_REDIRECT bits in the device-specific _run_xdp helper, that
will additional avoid several conditionals in mana_rx_skb(). 

The above refactoring would probably require a bit of work, but it will
pay-off for sure and will become more costily with time. Your choice ;)

But at the very least we need a better changelog here.

Cheers,

Paolo


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32A5A5435CA
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 17:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242199AbiFHPAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 11:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243383AbiFHO6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 10:58:22 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 717F913F0A
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 07:55:12 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id z17so18544391pff.7
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 07:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=ouIv3yuMD+fs6onJQHmG4NBDLGih2MdXqdMrDSRKCsQ=;
        b=iHdOGy51SISYIjCKOSiKDzub3ag/c/YB/M+J0IrPPaHIE1iOQUXAPEPy75WiPIJmas
         TegGXF0wEPRekd5eH/mgbOvUNHIGl45HdnK9CHe5xOncmZj1TWKOD7HNIOuHd2iceTGB
         MirjXSzk/xlmPpCpJkOm8jGYauGjlnptfp1/m0fGbHfg8GMV7XixG7+IWfWLX7IcxiJc
         2cnW9+gRjSSYm3dunGVkFWhqZhwGEbFdJT+o1dIGT1e6SjT5DaQJuEh9mdoQ2+71e7FF
         AokLHIxv0mYX53SrjnlsL4+oPwhfDlT9wmQqp5K6BzypW+Yx94wm/Kwx/3j9aBTZEazD
         jVWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=ouIv3yuMD+fs6onJQHmG4NBDLGih2MdXqdMrDSRKCsQ=;
        b=aOfpT5/z+TsXCaZUdmp4MT1+LtoiiKwthur/Yyl22AH1xdjLjykeSunBoSy3KsxPNV
         S+JQrExdeR8KDX3pXtbAIh9HDyZ5cw3gCWzuzKgMabpAg+8PiFIzNI3SYuMi3sEAMhfx
         3mR7UiAgQc8q3+YKeU/OPoRTRTLhck+0y9QnX3f7gy59raO7c7pR5QZf+EvkJkz9p6G2
         77slZy1Jm4f+bNz7gpY3tVfLO+HElRTsVrrmPOEAHiATSgufQRb8d1aDCKGienTyoI3p
         AfVuyjjfoSoCIy5itSgF66s9Lw1zn8h8YEcF1ifsPt3aUAIl1ZDagLBnSs+AqFr6wDDs
         RtzQ==
X-Gm-Message-State: AOAM532lI+cwIXwhZDeVt13/YcJNBaaHyBS17RXnDFBVcidQ0xwABrez
        UmITDgQPyNlu3LN3/Pb6zE6rbjX4QNg=
X-Google-Smtp-Source: ABdhPJxnkIxdsvtyP4/uiQLov88i9KHNpaLJ3rPYd85OHciGo3TjAXCjuyAtcLnJjHf7CSluSUki3Q==
X-Received: by 2002:a63:6c42:0:b0:3fe:465:7a71 with SMTP id h63-20020a636c42000000b003fe04657a71mr7284318pgc.101.1654700090376;
        Wed, 08 Jun 2022 07:54:50 -0700 (PDT)
Received: from [192.168.0.128] ([98.97.38.167])
        by smtp.googlemail.com with ESMTPSA id b11-20020a170902d50b00b0015e8d4eb276sm14992859plg.192.2022.06.08.07.54.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 07:54:49 -0700 (PDT)
Message-ID: <5c3f80585b414afb4b6bd49f46bcec77c1ba5fc8.camel@gmail.com>
Subject: Re: [PATCH net] ip_gre: test csum_start instead of transport header
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, Willem de Bruijn <willemb@google.com>,
        syzbot <syzkaller@googlegroups.com>
Date:   Wed, 08 Jun 2022 07:54:48 -0700
In-Reply-To: <20220606132107.3582565-1-willemdebruijn.kernel@gmail.com>
References: <20220606132107.3582565-1-willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-06-06 at 09:21 -0400, Willem de Bruijn wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> GRE with TUNNEL_CSUM will apply local checksum offload on
> CHECKSUM_PARTIAL packets.
> 
> ipgre_xmit must validate csum_start after an optional skb_pull,
> else lco_csum may trigger an overflow. The original check was
> 
> 	if (csum && skb_checksum_start(skb) < skb->data)
> 		return -EINVAL;
> 
> This had false positives when skb_checksum_start is undefined:
> when ip_summed is not CHECKSUM_PARTIAL. A discussed refinement
> was straightforward
> 
> 	if (csum && skb->ip_summed == CHECKSUM_PARTIAL &&
> 	    skb_checksum_start(skb) < skb->data)
> 		return -EINVAL;
> 
> But was eventually revised more thoroughly:
> - restrict the check to the only branch where needed, in an
>   uncommon GRE path that uses header_ops and calls skb_pull.
> - test skb_transport_header, which is set along with csum_start
>   in skb_partial_csum_set in the normal header_ops datapath.
> 
> Turns out skbs can arrive in this branch without the transport
> header set, e.g., through BPF redirection.
> 
> Revise the check back to check csum_start directly, and only if
> CHECKSUM_PARTIAL. Do leave the check in the updated location.
> Check field regardless of whether TUNNEL_CSUM is configured.
> 
> Link: https://lore.kernel.org/netdev/YS+h%2FtqCJJiQei+W@shredder/
> Link: https://lore.kernel.org/all/20210902193447.94039-2-willemdebruijn.kernel@gmail.com/T/#u
> Fixes: 8a0ed250f911 ("ip_gre: validate csum_start only on pull")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Willem de Bruijn <willemb@google.com>
> ---
>  net/ipv4/ip_gre.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
> index 7e474a85deaf..3b9cd487075a 100644
> --- a/net/ipv4/ip_gre.c
> +++ b/net/ipv4/ip_gre.c
> @@ -629,21 +629,20 @@ static netdev_tx_t ipgre_xmit(struct sk_buff *skb,
>  	}
>  
>  	if (dev->header_ops) {
> -		const int pull_len = tunnel->hlen + sizeof(struct iphdr);
> -
>  		if (skb_cow_head(skb, 0))
>  			goto free_skb;
>  
>  		tnl_params = (const struct iphdr *)skb->data;
>  
> -		if (pull_len > skb_transport_offset(skb))
> -			goto free_skb;
> -
>  		/* Pull skb since ip_tunnel_xmit() needs skb->data pointing
>  		 * to gre header.
>  		 */
> -		skb_pull(skb, pull_len);
> +		skb_pull(skb, tunnel->hlen + sizeof(struct iphdr));
>  		skb_reset_mac_header(skb);
> +
> +		if (skb->ip_summed == CHECKSUM_PARTIAL &&
> +		    skb_checksum_start(skb) < skb->data)
> +			goto free_skb;
>  	} else {
>  		if (skb_cow_head(skb, dev->needed_headroom))
>  			goto free_skb;

The one thing I might change would be the ordering of your two tests at
the end. It is more likely that skb_checksum_start will be less than
skb->data in most cases as skb->csum_start is initialized to 0 at
allocation. So cases where it is greater than skb->data should be rare
whereas the CHECKSUM_PARTIAL check will come up as true probably more
often then not as it isn't uncommon to see checksum or TSO offloaded
frames.

Anyway functionality-wise this looks good to me and what I suggested is
more of an optimization anyway.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C08332CAE56
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 22:26:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387893AbgLAVZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 16:25:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbgLAVZL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 16:25:11 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85C10C0613CF
        for <netdev@vger.kernel.org>; Tue,  1 Dec 2020 13:24:30 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id a16so7393120ejj.5
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 13:24:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=P9WCvftkC4FV47KTMgLhwfRItHLg0ryjxgY9QZ8YLwM=;
        b=ZrFj177MNCEIJLPVBhBw5+kjNNg/F3NjlqOhj0ypAqvMZoL+pDly/Io8EmhiLBwMBU
         j+9//3pb5hGDfh1BLNbqV3AKQEA1pnn9SxkGyFI6cm8ULHC7VJoGHZMrUom12LOZvkQW
         NCgnmlPfuwg32goxuWdQguCCzvvgG+t5SkIBRN/Zct76gEOqh786TrphaZxDok0b2y7y
         l+S/O92Doz6St6HLl6/tLk8hUSVOouvk4e0SvsMGm3nuQ70iwoFvn6VQd5pyco379vum
         LqbMW1NFC6eIHwNCmAN2sbkFUCdj/tDINwSq2XsnceSfQR8KgTQXGumxS1rwLe+Fjfg4
         zzQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=P9WCvftkC4FV47KTMgLhwfRItHLg0ryjxgY9QZ8YLwM=;
        b=CklYAjf4x0exFH91Atuwy0e7i6lo3Eioq8EMm+9Dm5r421VANDYYkc2J2r17hnZJjl
         68CbbuIO8SDoBouaKE/BjGjfi7LELWCCfI0Nz+U62DS6VIvgWKQtQaxZNxclp4tuvzad
         VzVSDLd4HKTDTuJxlZxNkgmXKe47gjjzQaXe0lRqLzeTWwu2RMbYFmxZPCBapp3pRBky
         NshY1dJL3eFbQEIOATIgiRj4C1BF9l3vAXBnx+7H0H3Z39nft7IoK5qt/v6zEfa2BcDG
         UcEF7Rr9+c8XAvUsdduEDpcPsk+SgsI47ea3FOGnMP595l8dNfNfATcyqxcOFks0x8sC
         qunA==
X-Gm-Message-State: AOAM531PgBjgRgF8uz2deFpzIn94zzNj5Fxf0MU/FV8v4YrTWFhNeCwQ
        gBzSvztQRmkqH6YVMkwzaAM=
X-Google-Smtp-Source: ABdhPJz4k4D4XzHUuGR+eftan0TAeVg/lnS9lFY3YqFa/wUengK9LHMWTf1SoB+BaQ7pb+D/v5ZxRw==
X-Received: by 2002:a17:906:a982:: with SMTP id jr2mr5112252ejb.292.1606857869242;
        Tue, 01 Dec 2020 13:24:29 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id a12sm178454edt.1.2020.12.01.13.24.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 13:24:28 -0800 (PST)
Date:   Tue, 1 Dec 2020 23:24:27 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 4/4] net: dsa: tag_dsa: Support reception of
 packets from LAG devices
Message-ID: <20201201212427.sewnqf7muxwisbcm@skbuf>
References: <20201130140610.4018-1-tobias@waldekranz.com>
 <20201130140610.4018-5-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201130140610.4018-5-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 03:06:10PM +0100, Tobias Waldekranz wrote:
> Packets ingressing on a LAG that egress on the CPU port, which are not
> classified as management, will have a FORWARD tag that does not
> contain the normal source device/port tuple. Instead the trunk bit
> will be set, and the port field holds the LAG id.
> 
> Since the exact source port information is not available in the tag,
> frames are injected directly on the LAG interface and thus do never
> pass through any DSA port interface on ingress.
> 
> Management frames (TO_CPU) are not affected and will pass through the
> DSA port interface as usual.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
>  net/dsa/dsa.c     | 12 +++++++++++-
>  net/dsa/tag_dsa.c | 17 ++++++++++++++++-
>  2 files changed, 27 insertions(+), 2 deletions(-)
> 
> diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
> index a1b1dc8a4d87..7325bf4608e9 100644
> --- a/net/dsa/dsa.c
> +++ b/net/dsa/dsa.c
> @@ -219,11 +219,21 @@ static int dsa_switch_rcv(struct sk_buff *skb, struct net_device *dev,
>  	}
>  
>  	skb = nskb;
> -	p = netdev_priv(skb->dev);
>  	skb_push(skb, ETH_HLEN);
>  	skb->pkt_type = PACKET_HOST;
>  	skb->protocol = eth_type_trans(skb, skb->dev);
>  
> +	if (unlikely(!dsa_slave_dev_check(skb->dev))) {
> +		/* Packet is to be injected directly on an upper
> +		 * device, e.g. a team/bond, so skip all DSA-port
> +		 * specific actions.
> +		 */
> +		netif_rx(skb);
> +		return 0;

netif_rx returns an int code, it seems odd to ignore it.

> +	}
> +
> +	p = netdev_priv(skb->dev);
> +
>  	if (unlikely(cpu_dp->ds->untag_bridge_pvid)) {
>  		nskb = dsa_untag_bridge_pvid(skb);
>  		if (!nskb) {

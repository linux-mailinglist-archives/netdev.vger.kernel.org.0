Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1427A0E05
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 01:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727139AbfH1XDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 19:03:14 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:46537 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726954AbfH1XDK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 19:03:10 -0400
Received: by mail-ed1-f68.google.com with SMTP id z51so1760821edz.13
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 16:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=819swzQKe98LdzJrxDCxiGarxJHyCdbjjXG7zzq6Gf4=;
        b=QubqZWHDcswIDRZ8UX5aJXD/sm3fEumW25hWHLvukFM819Yknc/uzen5kBObQFjrdN
         XmFszcsJ+GPcabhUnQT1QZN/w+PEpinIsaoZaVN3ECc0kcf60/vQ8pnlJD8N6G5S45ds
         U4nOHX9dKdLgiNdKat17I/2K1IKRnkemIE5FRUhHjwIWSZvpT49XEePRucm0LPPssiP/
         eNrQgiMr4oO3n1I2TRi1W8epuOB/BSo2TQ4NXTwQ9tMoyIUsSMYyQOtgjCD4HdSNHI45
         Q1uGRcf12BioBGyMHqAyd0jv/HvOl73jHciadrnImwkS3urwM1/v69qBrZiTpCMpl7ns
         7hHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=819swzQKe98LdzJrxDCxiGarxJHyCdbjjXG7zzq6Gf4=;
        b=aQ8AbRp6w/Pz+DCGxsQgkjRkFkDMo3lMouGN4LVbZfJu2qw6a4/bLsRiOiDWJiNGMq
         JGB8M3zCZlHD4nfwHhoLAryEuSBojA1T4EHowUXoMVcaiBeJCwGmubKBW4M+3PgaZi4x
         k3hgLxcQ48OILGpHMRHoDkZ5mp3VjnWUAT40EewYGmNZMn8jCqYpuc6bZAOdclh6E2wX
         t2qzbTgluOMxSE0IhSnbTlJzetKgordXbUu/AXWEJ0spUZxUsLsQn5SNZ/H8BtuSA81Z
         glJ/VmzN618/PL7f8RcLoVxgNbJ8Eg62fqZoBGBxdNCND6xC0QM2hH80a1M/ygfZrnUn
         UgVA==
X-Gm-Message-State: APjAAAXHQA9jTO18Sz/t6I+RWwckTdevdfrdvo3sBlweNz2/iqixrQ1v
        LvE1akUsjmXUl6a/4+kSpAvA5Q==
X-Google-Smtp-Source: APXvYqwBNeZBsZAb2QiHZ3ka+pGiYcIhUqd3Va0L+/ypOzKgUthP1oIon5KcXep4ANSKBdqvf6IDlg==
X-Received: by 2002:a50:9116:: with SMTP id e22mr6723578eda.161.1567033388739;
        Wed, 28 Aug 2019 16:03:08 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id f6sm96846edn.63.2019.08.28.16.03.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 16:03:08 -0700 (PDT)
Date:   Wed, 28 Aug 2019 16:02:46 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Thomas Bogendoerfer <tbogendoerfer@suse.de>
Cc:     Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 06/15] net: sgi: ioc3-eth: get rid of
 ioc3_clean_rx_ring()
Message-ID: <20190828160246.7b211f8a@cakuba.netronome.com>
In-Reply-To: <20190828140315.17048-7-tbogendoerfer@suse.de>
References: <20190828140315.17048-1-tbogendoerfer@suse.de>
        <20190828140315.17048-7-tbogendoerfer@suse.de>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Aug 2019 16:03:05 +0200, Thomas Bogendoerfer wrote:
> Clean rx ring is just called once after a new ring is allocated, which
> is per definition clean. So there is not need for this function.
> 
> Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
> ---
>  drivers/net/ethernet/sgi/ioc3-eth.c | 21 ---------------------
>  1 file changed, 21 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sgi/ioc3-eth.c b/drivers/net/ethernet/sgi/ioc3-eth.c
> index 6ca560d4ab79..39631e067b71 100644
> --- a/drivers/net/ethernet/sgi/ioc3-eth.c
> +++ b/drivers/net/ethernet/sgi/ioc3-eth.c
> @@ -761,26 +761,6 @@ static void ioc3_mii_start(struct ioc3_private *ip)
>  	add_timer(&ip->ioc3_timer);
>  }
>  
> -static inline void ioc3_clean_rx_ring(struct ioc3_private *ip)
> -{
> -	struct ioc3_erxbuf *rxb;
> -	struct sk_buff *skb;
> -	int i;
> -
> -	for (i = ip->rx_ci; i & 15; i++) {
> -		ip->rx_skbs[ip->rx_pi] = ip->rx_skbs[ip->rx_ci];
> -		ip->rxr[ip->rx_pi++] = ip->rxr[ip->rx_ci++];
> -	}
> -	ip->rx_pi &= RX_RING_MASK;
> -	ip->rx_ci &= RX_RING_MASK;
> -
> -	for (i = ip->rx_ci; i != ip->rx_pi; i = (i + 1) & RX_RING_MASK) {
> -		skb = ip->rx_skbs[i];
> -		rxb = (struct ioc3_erxbuf *)(skb->data - RX_OFFSET);
> -		rxb->w0 = 0;

There's gotta be some purpose to setting this w0 word to zero no?
ioc3_rx() uses that to see if the descriptor is done, and dutifully
clears it after..

> -	}
> -}
> -
>  static inline void ioc3_clean_tx_ring(struct ioc3_private *ip)
>  {
>  	struct sk_buff *skb;
> @@ -860,7 +840,6 @@ static void ioc3_init_rings(struct net_device *dev)
>  	ioc3_free_rings(ip);
>  	ioc3_alloc_rings(dev);
>  
> -	ioc3_clean_rx_ring(ip);
>  	ioc3_clean_tx_ring(ip);
>  
>  	/* Now the rx ring base, consume & produce registers.  */


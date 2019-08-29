Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 884A6A289E
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 23:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728230AbfH2VGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 17:06:06 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:44689 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727857AbfH2VGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 17:06:04 -0400
Received: by mail-ed1-f67.google.com with SMTP id a21so5530136edt.11
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 14:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=mjeDM1ef59jHGyITUEWKWasfOEJ0lhbfqjEvHa/i+Bc=;
        b=C/MonQxuUjA5OS8d5fmb1X7dzmJV0jA/mpbw81KMoaWWx12Ur45uzcUPiyItofO4v9
         ZMj31l1mLBk4UYgZWQMPClJjRLmg984pRbGnjiQ2wWDCUkxvF1I+1fH5h/d1GcxHtHf8
         ZKyevKI9p7RRxOkpxiOTHK345zHfkJgCWRVJQBRjgmZJZcKw2vovVBq5A9qJ0BqQUL79
         Snd5sFvGZgbt9oslfbZhqPuHOncfZMRCcoaP7tqTK6fqT2C3aC+u+W3lVp2ZZbyg6i3n
         4mCLRie4ILXwTkCGQ3pbUklEBecKmO/y5dmAQRUWaE/4l2A5XdbA2N5jxEeRaAtVz39f
         hKCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=mjeDM1ef59jHGyITUEWKWasfOEJ0lhbfqjEvHa/i+Bc=;
        b=sUGGq6ND4uE5HqYIFtmQOWNuhjz1dkLS2EraZjE1utJReoy4gQ/gphGEIscY//4BIF
         tWzT2i27IA7gkKmk+CY9fM8qbvrkgf3+D7yclvHWMDDYVHuFVnKFQWsVmNY6AhGTfAjw
         x3TUH8R+Rg4PfRtrx2qmg7p1daQUSVKD75JcXiOZChYtVgEkRtKyjki7Orn6UKIWlyEi
         J1lXniPTpGzHPO67VzjHoTf6B4836+FBHbh/6AlvpLZjcKLqMw9dTuWk4hIXzyvgsV1L
         RkGG5ohzsmGb9tdXXK0w00ugreEATubzPR4ZU8GZ8DT77uDP41tAJ0/1LCDOBDuQbDn/
         Jnfg==
X-Gm-Message-State: APjAAAUzj3l9mAgPRtLsKgAtw6UKTYrfXnYNyP4N0R7F/5ve6sBktEZg
        t2xH5qp/tIaNyXb30cWS84YF5Q==
X-Google-Smtp-Source: APXvYqxkf3fLJCOCftLxVNmTyA/z4TI2hfVEFN6q2d+atf4OWedLQfzK96Qaw5gyDlRRT9vKcpKKUQ==
X-Received: by 2002:a05:6402:1344:: with SMTP id y4mr11932199edw.124.1567112762386;
        Thu, 29 Aug 2019 14:06:02 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id f6sm640076edv.30.2019.08.29.14.05.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 14:06:02 -0700 (PDT)
Date:   Thu, 29 Aug 2019 14:05:37 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Thomas Bogendoerfer <tbogendoerfer@suse.de>
Cc:     Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 05/15] net: sgi: ioc3-eth: allocate space
 for desc rings only once
Message-ID: <20190829140537.68abfc9f@cakuba.netronome.com>
In-Reply-To: <20190829155014.9229-6-tbogendoerfer@suse.de>
References: <20190829155014.9229-1-tbogendoerfer@suse.de>
        <20190829155014.9229-6-tbogendoerfer@suse.de>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Aug 2019 17:50:03 +0200, Thomas Bogendoerfer wrote:
> Memory for descriptor rings are allocated/freed, when interface is
> brought up/down. Since the size of the rings is not changeable by
> hardware, we now allocate rings now during probe and free it, when
> device is removed.
> 
> Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
> ---
>  drivers/net/ethernet/sgi/ioc3-eth.c | 103 ++++++++++++++++++------------------
>  1 file changed, 51 insertions(+), 52 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sgi/ioc3-eth.c b/drivers/net/ethernet/sgi/ioc3-eth.c
> index ba18a53fbbe6..d9d94a55ac34 100644
> --- a/drivers/net/ethernet/sgi/ioc3-eth.c
> +++ b/drivers/net/ethernet/sgi/ioc3-eth.c
> @@ -803,25 +803,17 @@ static void ioc3_free_rings(struct ioc3_private *ip)
>  	struct sk_buff *skb;
>  	int rx_entry, n_entry;
>  
> -	if (ip->txr) {
> -		ioc3_clean_tx_ring(ip);
> -		free_pages((unsigned long)ip->txr, 2);
> -		ip->txr = NULL;
> -	}
> +	ioc3_clean_tx_ring(ip);
>  
> -	if (ip->rxr) {
> -		n_entry = ip->rx_ci;
> -		rx_entry = ip->rx_pi;
> +	n_entry = ip->rx_ci;
> +	rx_entry = ip->rx_pi;
>  
> -		while (n_entry != rx_entry) {
> -			skb = ip->rx_skbs[n_entry];
> -			if (skb)
> -				dev_kfree_skb_any(skb);
> +	while (n_entry != rx_entry) {
> +		skb = ip->rx_skbs[n_entry];
> +		if (skb)
> +			dev_kfree_skb_any(skb);

I think dev_kfree_skb_any() accepts NULL

>  
> -			n_entry = (n_entry + 1) & RX_RING_MASK;
> -		}
> -		free_page((unsigned long)ip->rxr);
> -		ip->rxr = NULL;
> +		n_entry = (n_entry + 1) & RX_RING_MASK;
>  	}
>  }
>  
> @@ -829,49 +821,34 @@ static void ioc3_alloc_rings(struct net_device *dev)
>  {
>  	struct ioc3_private *ip = netdev_priv(dev);
>  	struct ioc3_erxbuf *rxb;
> -	unsigned long *rxr;
>  	int i;
>  
> -	if (!ip->rxr) {
> -		/* Allocate and initialize rx ring.  4kb = 512 entries  */
> -		ip->rxr = (unsigned long *)get_zeroed_page(GFP_ATOMIC);
> -		rxr = ip->rxr;
> -		if (!rxr)
> -			pr_err("%s: get_zeroed_page() failed!\n", __func__);
> -
> -		/* Now the rx buffers.  The RX ring may be larger but
> -		 * we only allocate 16 buffers for now.  Need to tune
> -		 * this for performance and memory later.
> -		 */
> -		for (i = 0; i < RX_BUFFS; i++) {
> -			struct sk_buff *skb;
> +	/* Now the rx buffers.  The RX ring may be larger but
> +	 * we only allocate 16 buffers for now.  Need to tune
> +	 * this for performance and memory later.
> +	 */
> +	for (i = 0; i < RX_BUFFS; i++) {
> +		struct sk_buff *skb;
>  
> -			skb = ioc3_alloc_skb(RX_BUF_ALLOC_SIZE, GFP_ATOMIC);
> -			if (!skb) {
> -				show_free_areas(0, NULL);
> -				continue;
> -			}
> +		skb = ioc3_alloc_skb(RX_BUF_ALLOC_SIZE, GFP_ATOMIC);
> +		if (!skb) {
> +			show_free_areas(0, NULL);
> +			continue;
> +		}
>  
> -			ip->rx_skbs[i] = skb;
> +		ip->rx_skbs[i] = skb;
>  
> -			/* Because we reserve afterwards. */
> -			skb_put(skb, (1664 + RX_OFFSET));
> -			rxb = (struct ioc3_erxbuf *)skb->data;
> -			rxr[i] = cpu_to_be64(ioc3_map(rxb, 1));
> -			skb_reserve(skb, RX_OFFSET);
> -		}
> -		ip->rx_ci = 0;
> -		ip->rx_pi = RX_BUFFS;
> +		/* Because we reserve afterwards. */
> +		skb_put(skb, (1664 + RX_OFFSET));
> +		rxb = (struct ioc3_erxbuf *)skb->data;
> +		ip->rxr[i] = cpu_to_be64(ioc3_map(rxb, 1));
> +		skb_reserve(skb, RX_OFFSET);
>  	}
> +	ip->rx_ci = 0;
> +	ip->rx_pi = RX_BUFFS;
>  
> -	if (!ip->txr) {
> -		/* Allocate and initialize tx rings.  16kb = 128 bufs.  */
> -		ip->txr = (struct ioc3_etxd *)__get_free_pages(GFP_KERNEL, 2);
> -		if (!ip->txr)
> -			pr_err("%s: __get_free_pages() failed!\n", __func__);
> -		ip->tx_pi = 0;
> -		ip->tx_ci = 0;
> -	}
> +	ip->tx_pi = 0;
> +	ip->tx_ci = 0;
>  }
>  
>  static void ioc3_init_rings(struct net_device *dev)
> @@ -1239,6 +1216,23 @@ static int ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	timer_setup(&ip->ioc3_timer, ioc3_timer, 0);
>  
>  	ioc3_stop(ip);
> +
> +	/* Allocate and rx ring.  4kb = 512 entries  */
> +	ip->rxr = (unsigned long *)get_zeroed_page(GFP_ATOMIC);
> +	if (!ip->rxr) {
> +		pr_err("ioc3-eth: rx ring allocation failed\n");
> +		err = -ENOMEM;
> +		goto out_stop;
> +	}
> +
> +	/* Allocate tx rings.  16kb = 128 bufs.  */
> +	ip->txr = (struct ioc3_etxd *)__get_free_pages(GFP_KERNEL, 2);
> +	if (!ip->txr) {
> +		pr_err("ioc3-eth: tx ring allocation failed\n");
> +		err = -ENOMEM;
> +		goto out_stop;
> +	}

Please just use kcalloc()/kmalloc_array() here, and make sure the flags
are set to GFP_KERNEL whenever possible. Here and in ioc3_alloc_rings()
it looks like GFP_ATOMIC is unnecessary.

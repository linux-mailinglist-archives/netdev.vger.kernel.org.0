Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69E7583D37
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 00:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727501AbfHFWIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 18:08:31 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:41159 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727453AbfHFWIb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 18:08:31 -0400
Received: by mail-qt1-f195.google.com with SMTP id d17so7359535qtj.8
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 15:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=lgpI3ynHW3gTvfclzfXkVuyqpqeD3VNzN05HaWx4zvc=;
        b=uoHPmS9+YoOxcoJBDbzfC+2fbzNEkLRoav7HUYfBUs9/anx0fxJOpaTnyi46GM/rJJ
         CqXno/3jcs1X1U0FuCvbUjuZt95T++kOykcCT1edliWysW7pqf2xdfINEWc+GSF69zPE
         jtHxEzv4MwSIFGUNIT7R9gz1Bv1LSteX2Sid9G0hOHIfI49Hp3EpcE/5Ogq45V9pl/7H
         wcb0ruPFB9D2hHg4FQIgrCXvkjhcPzLVr3u8ROXXrOFetGkQXdUBrnr0D3+gaAAeZ3e3
         dEjz9enIH+6aoeYC0FoZNymuqfkuvnM+oCZwxsW+T5CwZJTgU2KaRQgxxqWprLgJKSFB
         98wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=lgpI3ynHW3gTvfclzfXkVuyqpqeD3VNzN05HaWx4zvc=;
        b=IverKTz1x/xOrmb+9Fe8OMvjzwPZI8qsZaj0s0VRWkqmphHkHkB+rhDvdeMOPiCsiQ
         YKI9bWAhHCBdDW0GbC82SsOl8ibDi40ABswreppLHCnSxpqhLASNdIM5jXQ28eUFBGFz
         iijJxf8OusyvhgF4I0mA/CH+5NzM4WTDUPcWh6DLMEZTUiz4ap9OxV55lGgyvgIj6Ase
         SNACG7BSpvfep8QeXmqkdqAT8q7h3UwOQvwdwNMOJtTclU+CzPGMTc1zYmpnTZGWRixf
         GuXtLLgWRy4ssFupZ7v2dmlIZ4wj6Mfp8nIV727X5yQSI9NUS4k536bgjJjFEmOZp7rw
         iveQ==
X-Gm-Message-State: APjAAAVCFtJLoLtfHmmgwI7jUv2zIKLXSggvlZi0k49OkX/JP7EcRYrv
        ZLejiDJkIElGYdSUY1feR7Duog==
X-Google-Smtp-Source: APXvYqyM775FoP3ymrZoS1cfi0VLU7KWY4ABIV0dCgd+BKaX2iGy1XM4e6b8j0l6rf7gx/MWm2HYZg==
X-Received: by 2002:ad4:5405:: with SMTP id f5mr5184364qvt.242.1565129310229;
        Tue, 06 Aug 2019 15:08:30 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id z5sm36883130qti.80.2019.08.06.15.08.28
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 15:08:29 -0700 (PDT)
Date:   Tue, 6 Aug 2019 15:08:02 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     <netdev@vger.kernel.org>, <nic_swsd@realtek.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH net-next 4/5] r8152: support skb_add_rx_frag
Message-ID: <20190806150802.72e0ef02@cakuba.netronome.com>
In-Reply-To: <1394712342-15778-293-albertk@realtek.com>
References: <1394712342-15778-289-albertk@realtek.com>
        <1394712342-15778-293-albertk@realtek.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 6 Aug 2019 19:18:03 +0800, Hayes Wang wrote:
> Use skb_add_rx_frag() to reduce the memory copy for rx data.
> 
> Use a new list of rx_used to store the rx buffer which couldn't be
> reused yet.
> 
> Besides, the total number of rx buffer may be increased or decreased
> dynamically. And it is limited by RTL8152_MAX_RX_AGG.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> index 401e56112365..1615900c8592 100644
> --- a/drivers/net/usb/r8152.c
> +++ b/drivers/net/usb/r8152.c
> @@ -584,6 +584,9 @@ enum rtl_register_content {
>  #define TX_ALIGN		4
>  #define RX_ALIGN		8
>  
> +#define RTL8152_MAX_RX_AGG	(10 * RTL8152_MAX_RX)
> +#define RTL8152_RXFG_HEADSZ	256
> +
>  #define INTR_LINK		0x0004
>  
>  #define RTL8152_REQT_READ	0xc0
> @@ -720,7 +723,7 @@ struct r8152 {
>  	struct net_device *netdev;
>  	struct urb *intr_urb;
>  	struct tx_agg tx_info[RTL8152_MAX_TX];
> -	struct list_head rx_info;
> +	struct list_head rx_info, rx_used;

I don't see where entries on the rx_used list get freed when driver is
unloaded, could you explain how that's taken care of?

>  	struct list_head rx_done, tx_free;
>  	struct sk_buff_head tx_queue, rx_queue;
>  	spinlock_t rx_lock, tx_lock;
> @@ -1476,7 +1479,7 @@ static void free_rx_agg(struct r8152 *tp, struct rx_agg *agg)
>  	list_del(&agg->info_list);
>  
>  	usb_free_urb(agg->urb);
> -	__free_pages(agg->page, get_order(tp->rx_buf_sz));
> +	put_page(agg->page);
>  	kfree(agg);
>  
>  	atomic_dec(&tp->rx_count);
> @@ -1493,7 +1496,7 @@ static struct rx_agg *alloc_rx_agg(struct r8152 *tp, gfp_t mflags)
>  	if (rx_agg) {
>  		unsigned long flags;
>  
> -		rx_agg->page = alloc_pages(mflags, order);
> +		rx_agg->page = alloc_pages(mflags | __GFP_COMP, order);
>  		if (!rx_agg->page)
>  			goto free_rx;
>  
> @@ -1951,6 +1954,50 @@ static u8 r8152_rx_csum(struct r8152 *tp, struct rx_desc *rx_desc)
>  	return checksum;
>  }
>  
> +static inline bool rx_count_exceed(struct r8152 *tp)
> +{
> +	return atomic_read(&tp->rx_count) > RTL8152_MAX_RX;
> +}
> +
> +static inline int agg_offset(struct rx_agg *agg, void *addr)
> +{
> +	return (int)(addr - agg->buffer);
> +}
> +
> +static struct rx_agg *rtl_get_free_rx(struct r8152 *tp, gfp_t mflags)
> +{
> +	struct list_head *cursor, *next;
> +	struct rx_agg *agg_free = NULL;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&tp->rx_lock, flags);
> +
> +	list_for_each_safe(cursor, next, &tp->rx_used) {
> +		struct rx_agg *agg;
> +
> +		agg = list_entry(cursor, struct rx_agg, list);
> +
> +		if (page_count(agg->page) == 1) {
> +			if (!agg_free) {
> +				list_del_init(cursor);
> +				agg_free = agg;
> +				continue;
> +			} else if (rx_count_exceed(tp)) {

nit: else unnecessary after continue

> +				list_del_init(cursor);
> +				free_rx_agg(tp, agg);
> +			}
> +			break;
> +		}
> +	}
> +
> +	spin_unlock_irqrestore(&tp->rx_lock, flags);
> +
> +	if (!agg_free && atomic_read(&tp->rx_count) < RTL8152_MAX_RX_AGG)
> +		agg_free = alloc_rx_agg(tp, mflags);
> +
> +	return agg_free;
> +}
> +
>  static int rx_bottom(struct r8152 *tp, int budget)
>  {
>  	unsigned long flags;

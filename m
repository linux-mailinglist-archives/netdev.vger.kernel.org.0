Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99F532623AB
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 01:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728954AbgIHXk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 19:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726340AbgIHXk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 19:40:56 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D7D0C061573
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 16:40:56 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id m15so1717pls.8
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 16:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Vd1mXvxdeywg9l/ehVIw9S2bl7ysNRVz4531qzUfpkM=;
        b=fHQazEjvO9a3YaOkEODlnY9wyPVgSJunJjFCWWjKmYYN8Dw5ovFphna3Le4SbFC/G4
         m9spG++s/NwU3QHKOnVpmEEcrhtNSWyiEMDPYnIwLgsI2ZlUZyIe6llC4z0wTyrKtTHf
         D3v3p7pzozgtDggoefp9GJwkCgzP9nFdZIce1Eks/2vuXPuYI3zZdb3vbVlISx5fo6U+
         UA7pZLBsKZ7vUz3RyIDXRW8B8qVRfd3LZqyvXf3kPwcm8WsEDEbzBe0FKltAl4RpDKEv
         RlntZBTQGJsBXssES42KgNOeiAM+303ExrkQjUOOdii+bGRyieGcUz1AWy9O8FHdvurq
         /zKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Vd1mXvxdeywg9l/ehVIw9S2bl7ysNRVz4531qzUfpkM=;
        b=t4mhiisQvIfl3qqYUhUVgUp2FxUysE8E7GkgL8mcM8AwfcYdsJKcTcnjcWviZyi2Qh
         dIa9L67YdC+4vHaDTkjqETFLbsUzZjCFLg+sXPqcfhK0dL2zM9BRzoTwIWM7vSI885Z1
         ZD0qTyzIAcM97ys/LsaJjB3zulmUoR8f5J4un/E8R9K1uBvXfzUDFbkqkQBpqPquzbOq
         z/OlxsPGmjBVIbDJDFvpFGL5UiqBgzlrSlWrnoCefCXezNTkdKgxhwjPg2KHjtV8MH5y
         MWFWv+plWSaXAXYfcaNWekiATbDvidQtd2SI0rm+8tHDPI76bbf7LdfgA0nT2JobdNNE
         RhEw==
X-Gm-Message-State: AOAM530Cl7cB6CR0hXIm3dQxeTjs5eJ7dkoC6zzxty/TNElTJWFHo10O
        HngTBwY8VvC3h+rIxtxdu5M=
X-Google-Smtp-Source: ABdhPJybpdLtu8CVadilRPy0n1xQl/LT6/uVTU22VyQBXCqLg8Le26LoUBUGMr5QpbX3gad5yaCO+Q==
X-Received: by 2002:a17:902:a5c3:: with SMTP id t3mr1021055plq.134.1599608455499;
        Tue, 08 Sep 2020 16:40:55 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id j11sm340974pgh.8.2020.09.08.16.40.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 16:40:54 -0700 (PDT)
Date:   Tue, 8 Sep 2020 16:40:52 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Matteo Croce <mcroce@redhat.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 7/7] net: mvpp2: ptp: add support for
 transmit timestamping
Message-ID: <20200908234052.GA11215@hoboy>
References: <20200908214727.GZ1551@shell.armlinux.org.uk>
 <E1kFlfN-0006di-Pu@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1kFlfN-0006di-Pu@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 08, 2020 at 11:00:41PM +0100, Russell King wrote:

> @@ -2984,13 +2985,19 @@ static irqreturn_t mvpp2_isr(int irq, void *dev_id)
>  
>  static void mvpp2_isr_handle_ptp_queue(struct mvpp2_port *port, int nq)
>  {
> +	struct skb_shared_hwtstamps shhwtstamps;
> +	struct mvpp2_hwtstamp_queue *queue;
> +	struct sk_buff *skb;
>  	void __iomem *ptp_q;
> +	unsigned int id;
>  	u32 r0, r1, r2;
>  
>  	ptp_q = port->priv->iface_base + MVPP22_PTP_BASE(port->gop_id);
>  	if (nq)
>  		ptp_q += MVPP22_PTP_TX_Q1_R0 - MVPP22_PTP_TX_Q0_R0;
>  
> +	queue = &port->tx_hwtstamp_queue[nq];
> +
>  	while (1) {
>  		r0 = readl_relaxed(ptp_q + MVPP22_PTP_TX_Q0_R0) & 0xffff;
>  		if (!r0)
> @@ -2998,6 +3005,19 @@ static void mvpp2_isr_handle_ptp_queue(struct mvpp2_port *port, int nq)
>  
>  		r1 = readl_relaxed(ptp_q + MVPP22_PTP_TX_Q0_R1) & 0xffff;
>  		r2 = readl_relaxed(ptp_q + MVPP22_PTP_TX_Q0_R2) & 0xffff;
> +
> +		id = (r0 >> 1) & 31;
> +
> +		skb = queue->skb[id];
> +		queue->skb[id] = NULL;
> +		if (skb) {
> +			u32 ts = r2 << 19 | r1 << 3 | r0 >> 13;
> +
> +			netdev_info(port->dev, "tx stamp 0x%08x\n", ts);

This probably should be _debug instead.

> +			mvpp22_tai_tstamp(port->priv->tai, ts, &shhwtstamps);
> +			skb_tstamp_tx(skb, &shhwtstamps);
> +			dev_kfree_skb_any(skb);
> +		}
>  	}
>  }

Thanks,
Richard

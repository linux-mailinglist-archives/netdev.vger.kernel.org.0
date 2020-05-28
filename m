Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B54C11E640E
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 16:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbgE1Oeq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 10:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725846AbgE1Oep (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 10:34:45 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D83A1C05BD1E;
        Thu, 28 May 2020 07:34:44 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id d3so11630890pln.1;
        Thu, 28 May 2020 07:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hjoI/U6bg7DFkwk9kr0gcJqlMcgi/p4xIsK/OlPqaRY=;
        b=iimzCxLUMSNVF4D1Csp6nKVJdEylGywOKSOK+eVXAegAnF/a4TKYYgrCQdL4Iz7b6m
         6cSn1tq6NNJ90jYYW/siTIGrW39a4w43lxJCLLcZzL/xpF1lTtPbmlDcPbG+MVBHc0Aw
         xoGVhO5pnWSnO6AiGnjpxrpcOG++/I7jGCbKRyfydEiFkKe5LvX0BgiqLLdLupaeZXmI
         y0mCUEqUdu6RBtMHQNhtH9sNVNktO3jmPNcqJ0Xnb9Qi2RordMKT7os14TtrkwtcxQVY
         T0kgJlrfeEcAfXoUvdwwycI5UW38RmWBBr1+9TXHPgORgUsD8mCGw0cmKTqgTc45T7uR
         dMVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hjoI/U6bg7DFkwk9kr0gcJqlMcgi/p4xIsK/OlPqaRY=;
        b=dIILnZrGZBCofU97luN2tgj2eyGfBY/0YEHxgNyODxXUtcLc5jKgs4DjibJY5t0wvi
         JzUzcYnyFYRODdixVGDVZ6VDApZYIRyXxr8I8gTYe909dztPviZNr9xI6ygL1tr9Yl+N
         mg9pFsj3dWb02knIc16qhTaLFn7M4bfw/cE9/2SAyrrFy2+jShfFEDWeU3k96P2Sw4yZ
         neMMmRNMICdgyMUvKMvBLUjPZcRf9qp+P0oLL3OYSE3wX7uQniQ9Xn3YqlAqoIkYsqel
         8imC+en2hvz93bI2fTrTbwJRNUm/uk6KaUMyi7P6WpyVqqUq308vF5izwp9k8mmuF792
         zwag==
X-Gm-Message-State: AOAM530wSQfm44GAo0B6l8au/TKhnmMKDXkBKQGYj57HN1wv+GRJpDa0
        ojuNpXRsUxixB/ub/mMeN4w=
X-Google-Smtp-Source: ABdhPJx1PTl3qGEofBe38Y0amhNRMPJHzhqVZH3iN36nPBDqlippHHMEL7cEkrfqV7s6Qe7xdF6Dkg==
X-Received: by 2002:a17:90a:cc05:: with SMTP id b5mr4085220pju.102.1590676484294;
        Thu, 28 May 2020 07:34:44 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id q26sm4857467pfh.74.2020.05.28.07.34.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 07:34:43 -0700 (PDT)
Date:   Thu, 28 May 2020 07:34:40 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        allan.nielsen@microchip.com, foss@0leil.net
Subject: Re: [PATCH net-next 6/8] net: phy: mscc: timestamping and PHC support
Message-ID: <20200528143440.GB14844@localhost>
References: <20200527164158.313025-1-antoine.tenart@bootlin.com>
 <20200527164158.313025-7-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200527164158.313025-7-antoine.tenart@bootlin.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 06:41:56PM +0200, Antoine Tenart wrote:

> +static struct vsc85xx_ptphdr *get_ptp_header(struct sk_buff *skb)
> +{
> +	struct ethhdr *ethhdr = eth_hdr(skb);
> +	struct iphdr *iphdr = ip_hdr(skb);
> +	struct udphdr *udphdr;
> +	__u8 proto;
> +
> +	if (ethhdr->h_proto == htons(ETH_P_1588))
> +		return (struct vsc85xx_ptphdr *)(((unsigned char *)ethhdr) +
> +					 skb_mac_header_len(skb));
> +
> +	if (ethhdr->h_proto != htons(ETH_P_IP))
> +		return NULL;
> +
> +	proto = iphdr->protocol;
> +	if (proto != IPPROTO_UDP)
> +		return NULL;
> +
> +	udphdr = udp_hdr(skb);
> +
> +	if (udphdr->source != ntohs(PTP_EV_PORT) ||
> +	    udphdr->dest != ntohs(PTP_EV_PORT))
> +		return NULL;
> +
> +	return (struct vsc85xx_ptphdr *)(((unsigned char *)udphdr) + UDP_HLEN);
> +}

This looks a lot like get_ptp_header_rx() below.  Are you sure you
need two almost identical methods?

> +static void vsc85xx_get_tx_ts(struct vsc85xx_ptp *ptp)
> +{
> +	struct skb_shared_hwtstamps shhwtstamps;
> +	struct sk_buff *skb, *first_skb = NULL;
> +	struct vsc85xx_ts_fifo fifo;
> +	u8 i, skb_sig[16], *p;
> +	unsigned long ns;
> +	s64 secs;
> +	u32 reg;
> +
> +next_in_fifo:
> +	memset(&fifo, 0, sizeof(fifo));
> +	p = (u8 *)&fifo;
> +
> +	reg = vsc85xx_ts_read_csr(ptp->phydev, PROCESSOR,
> +				  MSCC_PHY_PTP_EGR_TS_FIFO(0));
> +	if (reg & PTP_EGR_TS_FIFO_EMPTY)
> +		goto out;
> +
> +	*p++ = reg & 0xff;
> +	*p++ = (reg >> 8) & 0xff;
> +
> +	/* Reading FIFO6 pops the FIFO item */
> +	for (i = 1; i < 7; i++) {
> +		reg = vsc85xx_ts_read_csr(ptp->phydev, PROCESSOR,
> +					  MSCC_PHY_PTP_EGR_TS_FIFO(i));
> +		*p++ = reg & 0xff;
> +		*p++ = (reg >> 8) & 0xff;
> +		*p++ = (reg >> 16) & 0xff;
> +		*p++ = (reg >> 24) & 0xff;
> +	}
> +
> +next_in_queue:
> +	skb = skb_dequeue(&ptp->tx_queue);
> +	if (!skb || skb == first_skb)
> +		goto out;
> +
> +	/* Keep the first skb to avoid looping over it again. */
> +	if (!first_skb)
> +		first_skb = skb;
> +
> +	/* Can't get the signature of the packet, won't ever
> +	 * be able to have one so let's dequeue the packet.
> +	 */
> +	if (get_sig(skb, skb_sig) < 0)
> +		goto next_in_queue;
> +
> +	/* Valid signature but does not match the one of the
> +	 * packet in the FIFO right now, reschedule it for later
> +	 * packets.
> +	 */
> +	if (memcmp(skb_sig, fifo.sig, sizeof(fifo.sig))) {
> +		skb_queue_tail(&ptp->tx_queue, skb);
> +		goto next_in_queue;
> +	}
> +
> +	ns = fifo.ns;
> +	secs = fifo.secs;
> +
> +	memset(&shhwtstamps, 0, sizeof(shhwtstamps));
> +	shhwtstamps.hwtstamp = ktime_set(secs, ns);
> +	skb_complete_tx_timestamp(skb, &shhwtstamps);
> +
> +out:
> +	/* If other timestamps are available in the FIFO, process them. */
> +	reg = vsc85xx_ts_read_csr(ptp->phydev, PROCESSOR,
> +				  MSCC_PHY_PTP_EGR_TS_FIFO_CTRL);
> +	if (PTP_EGR_FIFO_LEVEL_LAST_READ(reg) > 1)
> +		goto next_in_fifo;
> +}

AFAICT, there is no need for labels and jumps here.  Two nested 'for'
loops will do nicely.  The inner skb loop can be in a helper function
for clarity.  Be sure to use the "safe" iterator over the skbs.


> +static void vsc85xx_txtstamp(struct mii_timestamper *mii_ts,
> +			     struct sk_buff *skb, int type)
> +{
> +	struct vsc8531_private *vsc8531 =
> +		container_of(mii_ts, struct vsc8531_private, mii_ts);
> +
> +	if (!skb || !vsc8531->ptp->configured)

The skb cannot be NULL here.  See net/core/timestamping.c

> +		return;
> +
> +	if (vsc8531->ptp->tx_type == HWTSTAMP_TX_OFF) {
> +		kfree_skb(skb);
> +		return;
> +	}
> +
> +	skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
> +	skb_queue_tail(&vsc8531->ptp->tx_queue, skb);
> +	/* Scheduling the work for the TS FIFO is handled by the IRQ routine */
> +}
> +
> +static bool vsc85xx_rxtstamp(struct mii_timestamper *mii_ts,
> +			     struct sk_buff *skb, int type)
> +{
> +	struct vsc8531_private *vsc8531 =
> +		container_of(mii_ts, struct vsc8531_private, mii_ts);
> +	struct skb_shared_hwtstamps *shhwtstamps = NULL;
> +	struct vsc85xx_ptphdr *ptphdr;
> +	struct timespec64 ts;
> +	unsigned long ns;
> +
> +	if (!skb || !vsc8531->ptp->configured)

Again, skb can't be null.

Thanks,
Richard

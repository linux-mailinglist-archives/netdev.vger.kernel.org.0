Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFBF3468F04
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 03:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232978AbhLFCNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 21:13:51 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:39944 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231177AbhLFCNu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Dec 2021 21:13:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Swo208tOljQuvZEYwEz9ixKgro94zaxzLnCN0z69dtU=; b=s0fSFgDNRkQf4hNcRG4u+c4+CM
        xRieDwmir/vcUNXRNKnfQz3vN5QDh8WDPdwVDO4I5RhWISLwnwARdmFffwssnMbw+szZrrSP0JmFr
        hgTuFCxT35IZTH3d1SYqh9tnv0cVta39/JJWzuSgEeRF1PFVLLdpv/aaJxI+6SU36oUo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mu3SC-00Fd4e-Pt; Mon, 06 Dec 2021 03:10:08 +0100
Date:   Mon, 6 Dec 2021 03:10:08 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Aleksander Jan Bajkowski <olek2@wp.pl>
Cc:     hauke@hauke-m.de, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: lantiq_xrx200: increase buffer reservation
Message-ID: <Ya1xAHpTH72VUj35@lunn.ch>
References: <20211205222359.42913-1-olek2@wp.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211205222359.42913-1-olek2@wp.pl>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static inline int xrx200_max_frame_len(int mtu)
> +{
> +	return VLAN_ETH_HLEN + mtu + ETH_FCS_LEN;
> +}
> +
> +static inline int xrx200_buffer_size(int mtu)
> +{
> +	return round_up(xrx200_max_frame_len(mtu) - 1, 4 * XRX200_DMA_BURST_LEN);
> +}

Please don't use inline in .c files. Let the compiler decide.

       Andrew

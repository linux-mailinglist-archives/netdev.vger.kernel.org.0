Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC60443E5B5
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 18:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbhJ1QFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 12:05:47 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36220 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229565AbhJ1QFr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 12:05:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=JY/7f/3+3T4R1QU9s5VuG3d2oqQFG7r7RdSo3Y5eAOE=; b=nMukhgedRVkTMg9xraKN3Vsv/4
        va9Y0L3S2ZdGsK+SmxEMH3qei8dokeDiK4QQcP8GHCpGp2moD6/jZNhAzjQNKHTf+RdCVO+knbkoe
        6lKVw0nJ+3CUYehkKc1SCQe4SQnpdJJ8kqCYv2LtiMLWAkG5qZpbCcPvfKLP3eg5wj5M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mg7s5-00C0ur-A8; Thu, 28 Oct 2021 18:03:17 +0200
Date:   Thu, 28 Oct 2021 18:03:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yuiko Oshino <yuiko.oshino@microchip.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        bryan.whitehead@microchip.com, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net] net: ethernet: microchip: lan743x: Increase rx ring
 size to improve rx performance
Message-ID: <YXrJxb0LtllPkOse@lunn.ch>
References: <20211028150315.19270-1-yuiko.oshino@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211028150315.19270-1-yuiko.oshino@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 28, 2021 at 11:03:15AM -0400, Yuiko Oshino wrote:
> Increase the rx ring size (LAN743X_RX_RING_SIZE) to improve rx performance on some platforms.
> Tested on x86 PC with EVB-LAN7430.
> The iperf3.7 TCPIP improved from 881 Mbps to 922 Mbps, and UDP improved from 817 Mbps to 936 Mbps.
> 
> Fixes: 23f0703c125b ("lan743x: Add main source files for new lan743x driver")
> Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>
> ---
>  drivers/net/ethernet/microchip/lan743x_main.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/microchip/lan743x_main.h b/drivers/net/ethernet/microchip/lan743x_main.h
> index 34c22eea0124..aaf7aaeaba0c 100644
> --- a/drivers/net/ethernet/microchip/lan743x_main.h
> +++ b/drivers/net/ethernet/microchip/lan743x_main.h
> @@ -831,7 +831,7 @@ struct lan743x_rx_buffer_info {
>  	unsigned int    buffer_length;
>  };
>  
> -#define LAN743X_RX_RING_SIZE        (65)

65 is interesting. 2^N + 1. So there might be a reason for this?

> +#define LAN743X_RX_RING_SIZE        (128)

129?

	Andrew

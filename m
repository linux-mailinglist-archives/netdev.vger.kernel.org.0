Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 336589E871
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 14:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbfH0MzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 08:55:08 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34224 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725920AbfH0MzI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 08:55:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=QQIZRKtBn4+mCRvrRB7rANCiu7s243FAxJxmiRuz/gE=; b=r3xQ/FkOpOf7TZVM3ElpTJ1S5x
        dHcBJlwUfU7QrDlwfFKJ6y42kryByRVRx+7k9NnkTeCEt5OGgkXrnDmerB24TXvYC2EaP/jxuu9DV
        p7OgTUqO0FoqATus5zeDeLUbFkV1yJhCSnpJFV5RMprMZrpnb7MwPOfPkiUEs7aZhlRg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i2b04-0003AX-Tl; Tue, 27 Aug 2019 14:55:04 +0200
Date:   Tue, 27 Aug 2019 14:55:04 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Razvan Stefanescu <razvan.stefanescu@microchip.com>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] net: dsa: microchip: avoid hard-codded port count
Message-ID: <20190827125504.GB11471@lunn.ch>
References: <20190827093110.14957-1-razvan.stefanescu@microchip.com>
 <20190827093110.14957-5-razvan.stefanescu@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827093110.14957-5-razvan.stefanescu@microchip.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 27, 2019 at 12:31:10PM +0300, Razvan Stefanescu wrote:
> Use port_cnt value to disable interrupts on switch reset.
> 
> Signed-off-by: Razvan Stefanescu <razvan.stefanescu@microchip.com>
> ---
>  drivers/net/dsa/microchip/ksz9477.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
> index 187be42de5f1..54fc05595d48 100644
> --- a/drivers/net/dsa/microchip/ksz9477.c
> +++ b/drivers/net/dsa/microchip/ksz9477.c
> @@ -213,7 +213,7 @@ static int ksz9477_reset_switch(struct ksz_device *dev)
>  
>  	/* disable interrupts */
>  	ksz_write32(dev, REG_SW_INT_MASK__4, SWITCH_INT_MASK);
> -	ksz_write32(dev, REG_SW_PORT_INT_MASK__4, 0x7F);
> +	ksz_write32(dev, REG_SW_PORT_INT_MASK__4, dev->port_cnt);
>  	ksz_read32(dev, REG_SW_PORT_INT_STATUS__4, &data32);

Humm, is this correct? 0x7f suggests this is a bitmap for 7 ports.
The name port_cnt suggests it is a count, e.g. 7 for 7 ports.

0x7f != 7.

Thanks
	Andrew

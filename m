Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 954592ED773
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 20:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729195AbhAGT2R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 14:28:17 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55674 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729008AbhAGT2R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 14:28:17 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kxawY-00GjX7-NB; Thu, 07 Jan 2021 20:27:34 +0100
Date:   Thu, 7 Jan 2021 20:27:34 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, roland@kernel.org
Subject: Re: [PATCH 2/3] usbnet: add method for reporting speed without MDIO
Message-ID: <X/dgphCCXr9KHY7h@lunn.ch>
References: <20210107113518.21322-1-oneukum@suse.com>
 <20210107113518.21322-3-oneukum@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107113518.21322-3-oneukum@suse.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 07, 2021 at 12:35:17PM +0100, Oliver Neukum wrote:

Hi Oliver

> +++ b/include/linux/usb/usbnet.h
> @@ -53,6 +53,8 @@ struct usbnet {
>  	u32			hard_mtu;	/* count any extra framing */
>  	size_t			rx_urb_size;	/* size for rx urbs */
>  	struct mii_if_info	mii;
> +	long			rxspeed;	/* if MII is not used */
> +	long			txspeed;	/* if MII is not used */

How generic is this really? I don't know USB networking, so i cannot
say for myself.

I'm wondering if these should be added to cdc_ncm_ctx, and
usbnet_get_link_ksettings_ncm function should be added?

Having said that, USB_CDC_NOTIFY_SPEED_CHANGE seems like it could also
use this. Should the patch set also handle that notification and set
usbnet->rxspeed and usbnet->txspeed? These would then be used in
multiple places and that would justify it being in struct usbnet.

       Andrew

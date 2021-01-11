Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 107D72F121E
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 13:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbhAKMIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 07:08:17 -0500
Received: from mx2.suse.de ([195.135.220.15]:56176 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726419AbhAKMIR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 07:08:17 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1610366851; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XHB0RyrJUB7eAhIarQq70P2hSjCGemOpdgbSlmvs+3M=;
        b=negvonpaJqBS45q5/RwtDuuc/jMsErRmsQymYSLjKi4JQ3qGyW0UqSRiFunJPXtZwBeUwa
        ikpkZNbBYAers0ICjdMFMPC3cxb65x/NBvN97BBYPYRnN+bolmSGih1N4VioySH8cJm9+J
        kM9zOP5jpF1Bobn9PR+k11DM0+O7WmA=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 29C7AAB92;
        Mon, 11 Jan 2021 12:07:31 +0000 (UTC)
Message-ID: <3ad450f9af5ff391df1d182c0efda90a28f54ff9.camel@suse.com>
Subject: Re: [PATCH 2/3] usbnet: add method for reporting speed without MDIO
From:   Oliver Neukum <oneukum@suse.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, roland@kernel.org
Date:   Mon, 11 Jan 2021 13:07:28 +0100
In-Reply-To: <X/dgphCCXr9KHY7h@lunn.ch>
References: <20210107113518.21322-1-oneukum@suse.com>
         <20210107113518.21322-3-oneukum@suse.com> <X/dgphCCXr9KHY7h@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Donnerstag, den 07.01.2021, 20:27 +0100 schrieb Andrew Lunn:
> On Thu, Jan 07, 2021 at 12:35:17PM +0100, Oliver Neukum wrote:
> 
> Hi Oliver
> 
> > +++ b/include/linux/usb/usbnet.h
> > @@ -53,6 +53,8 @@ struct usbnet {
> >  	u32			hard_mtu;	/* count any extra framing */
> >  	size_t			rx_urb_size;	/* size for rx urbs */
> >  	struct mii_if_info	mii;
> > +	long			rxspeed;	/* if MII is not used */
> > +	long			txspeed;	/* if MII is not used */
> 
> How generic is this really? I don't know USB networking, so i cannot
> say for myself.
> 
> I'm wondering if these should be added to cdc_ncm_ctx, and
> usbnet_get_link_ksettings_ncm function should be added?
> 
> Having said that, USB_CDC_NOTIFY_SPEED_CHANGE seems like it could also
> use this. Should the patch set also handle that notification and set
> usbnet->rxspeed and usbnet->txspeed? These would then be used in
> multiple places and that would justify it being in struct usbnet.

Hi,

yes, everything that gets notification in CDC style should use this
mechanism.

	Regards
		Oliver



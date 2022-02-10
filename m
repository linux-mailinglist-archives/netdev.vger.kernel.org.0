Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 601F84B137B
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 17:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244826AbiBJQvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 11:51:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244375AbiBJQvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 11:51:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E406F9;
        Thu, 10 Feb 2022 08:51:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3EDDB80839;
        Thu, 10 Feb 2022 16:51:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2709C340F0;
        Thu, 10 Feb 2022 16:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644511904;
        bh=eoJlvJOb/SY66Oz8CCQuLmMbp6i8xGQ09mexiNYeKNE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xtqyd0Xf7mauo3wZyNh7Ag8VabtW8ywTG5SVRd9UQy0VWhDtYKi27E59MeIITUtRK
         GrKHvR8Trj5Z9jOcKgB9PYbuHQrC3jDoViPNW2jdvjWrWmug+0C8x5cMlZD969OFBD
         o59ENpZBdzUVfG5/Mx1jMoDRDPjxjkOeRwfJ572w=
Date:   Thu, 10 Feb 2022 17:51:36 +0100
From:   Greg KH <gregKH@linuxfoundation.org>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        Ross Maynard <bids.7405@bigpond.com>
Subject: Re: [PATCHv2] USB: zaurus: support another broken Zaurus
Message-ID: <YgVCmCbXnW7QFrL5@kroah.com>
References: <20220210155911.15973-1-oneukum@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220210155911.15973-1-oneukum@suse.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 10, 2022 at 04:59:11PM +0100, Oliver Neukum wrote:
> This SL-6000 says Direct Line, not Ethernet
> 
> v2: added Reporter and Link

This line goes below the --- line, right?

> 
> Signed-off-by: Oliver Neukum <oneukum@suse.com>
> Reported-by: Ross Maynard <bids.7405@bigpond.com>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=215361
> ---
>  drivers/net/usb/cdc_ether.c | 12 ++++++++++++
>  drivers/net/usb/zaurus.c    | 12 ++++++++++++
>  2 files changed, 24 insertions(+)
> 
> diff --git a/drivers/net/usb/cdc_ether.c b/drivers/net/usb/cdc_ether.c
> index eb3817d70f2b..9b4dfa3001d6 100644
> --- a/drivers/net/usb/cdc_ether.c
> +++ b/drivers/net/usb/cdc_ether.c
> @@ -583,6 +583,11 @@ static const struct usb_device_id	products[] = {
>  	.bInterfaceSubClass	= USB_CDC_SUBCLASS_ETHERNET, \
>  	.bInterfaceProtocol	= USB_CDC_PROTO_NONE
>  
> +#define ZAURUS_FAKE_INTERFACE \
> +	.bInterfaceClass	= USB_CLASS_COMM, \
> +	.bInterfaceSubClass	= USB_CDC_SUBCLASS_MDLM, \
> +	.bInterfaceProtocol	= USB_CDC_PROTO_NONE
> +
>  /* SA-1100 based Sharp Zaurus ("collie"), or compatible;
>   * wire-incompatible with true CDC Ethernet implementations.
>   * (And, it seems, needlessly so...)
> @@ -636,6 +641,13 @@ static const struct usb_device_id	products[] = {
>  	.idProduct              = 0x9032,	/* SL-6000 */
>  	ZAURUS_MASTER_INTERFACE,
>  	.driver_info		= 0,
> +}, {
> +	.match_flags    =   USB_DEVICE_ID_MATCH_INT_INFO
> +		 | USB_DEVICE_ID_MATCH_DEVICE,
> +	.idVendor               = 0x04DD,
> +	.idProduct              = 0x9032,	/* SL-6000 */
> +	ZAURUS_FAKE_INTERFACE,
> +	.driver_info		= 0,
>  }, {
>  	.match_flags    =   USB_DEVICE_ID_MATCH_INT_INFO
>  		 | USB_DEVICE_ID_MATCH_DEVICE,
> diff --git a/drivers/net/usb/zaurus.c b/drivers/net/usb/zaurus.c
> index 8e717a0b559b..5289b6e31713 100644
> --- a/drivers/net/usb/zaurus.c
> +++ b/drivers/net/usb/zaurus.c
> @@ -256,6 +256,11 @@ static const struct usb_device_id	products [] = {
>  	.bInterfaceSubClass	= USB_CDC_SUBCLASS_ETHERNET, \
>  	.bInterfaceProtocol	= USB_CDC_PROTO_NONE
>  
> +#define ZAURUS_FAKE_INTERFACE \
> +	.bInterfaceClass	= USB_CLASS_COMM, \
> +	.bInterfaceSubClass	= USB_CDC_SUBCLASS_MDLM, \
> +	.bInterfaceProtocol	= USB_CDC_PROTO_NONE
> +
>  /* SA-1100 based Sharp Zaurus ("collie"), or compatible. */
>  {
>  	.match_flags	=   USB_DEVICE_ID_MATCH_INT_INFO
> @@ -313,6 +318,13 @@ static const struct usb_device_id	products [] = {
>  	.idProduct              = 0x9032,	/* SL-6000 */
>  	ZAURUS_MASTER_INTERFACE,
>  	.driver_info = ZAURUS_PXA_INFO,
> +}, {
> +        .match_flags    =   USB_DEVICE_ID_MATCH_INT_INFO
> +                 | USB_DEVICE_ID_MATCH_DEVICE,
> +        .idVendor		= 0x04DD,
> +        .idProduct		= 0x9032,	/* SL-6000 */
> +        ZAURUS_FAKE_INTERFACE,
> +        .driver_info = (unsigned long) &bogus_mdlm_info,
>  }, {
>  	.match_flags    =   USB_DEVICE_ID_MATCH_INT_INFO
>  		 | USB_DEVICE_ID_MATCH_DEVICE,

Did you run this through checkpatch?  You forgot the leading tabs here
in this last chunk again :(

thanks,

greg k-h

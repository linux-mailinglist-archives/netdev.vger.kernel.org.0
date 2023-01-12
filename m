Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FECF667ADE
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 17:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233851AbjALQam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 11:30:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232292AbjALQaA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 11:30:00 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07715C79;
        Thu, 12 Jan 2023 08:28:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2B491CE1ECF;
        Thu, 12 Jan 2023 16:28:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25D9DC433F1;
        Thu, 12 Jan 2023 16:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673540936;
        bh=qij1R0vXzD38ZLpPtADU1ZqQUUcA/+J6ljH+2LwenWg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nRclD84m+ajAjyAaYtu5isq54YdeVzFXVOPh2dQUq77DD321OdsbJ2jWNeieC7ES4
         J+giW4d5+qxPBd4W5FJYGs8dk7TKrgf3gdZREgQyC6tm1qZRbDWH628GDEOWGNYpM2
         hKmZWU+CNCgo3IzBQD4Tps2EBQCO/D05BgkOGSEYaVxqP42owvFpA25pwdmr1VWMyy
         eKU1F3zxkyDs75HHLZMqF6JBWmH7JaDMWBAQylM8+IcKQSYHFcq4jhw5Dl1EpYClL5
         aZH17VYD11QHAq4bzcGMVoVzcrv31Olx8Dnk6/udT82NHrFzrekSnfIW7X+Pm4B5u9
         1j6zG0fBACsmw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1pG0Rr-0003Z5-Uu; Thu, 12 Jan 2023 17:29:04 +0100
Date:   Thu, 12 Jan 2023 17:29:03 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Matthew Garrett <mjg59@srcf.ucam.org>
Cc:     bjorn@mork.no, netdev@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH V2 3/3] USB: serial: option: Add Novatel MiFi 8800L diag
 endpoint
Message-ID: <Y8A1TzUO9JB5c+lQ@hovoldconsulting.com>
References: <20221226234751.444917-1-mjg59@srcf.ucam.org>
 <20221226234751.444917-4-mjg59@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221226234751.444917-4-mjg59@srcf.ucam.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 26, 2022 at 03:47:51PM -0800, Matthew Garrett wrote:
> The Novatel MiFi 8800L can be configured into exposing additional
> endpoints by sending four bytes of 0s to the HID endpoint it exposes by
> default. One of the additional exposed endpoints is a Qualcomm DIAG protocol
> interface. Add the information for that in order to allow it to be used.

Could you include usb-devices output here too?

> Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>
> ---
>  drivers/usb/serial/option.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
> index 5025810db8c9..40a4ccb888f9 100644
> --- a/drivers/usb/serial/option.c
> +++ b/drivers/usb/serial/option.c
> @@ -161,6 +161,7 @@ static void option_instat_callback(struct urb *urb);
>  #define NOVATELWIRELESS_PRODUCT_U620L		0x9022
>  #define NOVATELWIRELESS_PRODUCT_G2		0xA010
>  #define NOVATELWIRELESS_PRODUCT_MC551		0xB001
> +#define NOVATELWIRELESS_PRODUCT_8800L		0xB023
>  
>  #define UBLOX_VENDOR_ID				0x1546
>  
> @@ -1055,6 +1056,7 @@ static const struct usb_device_id option_ids[] = {
>  	{ USB_DEVICE_AND_INTERFACE_INFO(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_E362, 0xff, 0xff, 0xff) },
>  	{ USB_DEVICE_AND_INTERFACE_INFO(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_E371, 0xff, 0xff, 0xff) },
>  	{ USB_DEVICE_AND_INTERFACE_INFO(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_U620L, 0xff, 0x00, 0x00) },
> +	{ USB_DEVICE_AND_INTERFACE_INFO(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_8800L, 0xff, 0xff, 0xff) },
>  
>  	{ USB_DEVICE(AMOI_VENDOR_ID, AMOI_PRODUCT_H01) },
>  	{ USB_DEVICE(AMOI_VENDOR_ID, AMOI_PRODUCT_H01A) },

Johan

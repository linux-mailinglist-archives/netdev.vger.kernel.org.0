Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 569BB483137
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 14:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232101AbiACND1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 08:03:27 -0500
Received: from wnew3-smtp.messagingengine.com ([64.147.123.17]:48521 "EHLO
        wnew3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229514AbiACND0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 08:03:26 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.west.internal (Postfix) with ESMTP id BB2602B001EB;
        Mon,  3 Jan 2022 08:03:23 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 03 Jan 2022 08:03:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=WplENM2h9IHtw/qRxZid+AwiRh7
        x8LVHHM217ruNw/M=; b=QZNgG81iFvUAgOYNbvZsKjxdFbFTFoDEjoBY/IqnwmW
        v6YcEG3pia6HA7VtWlSyvin3yGSmkzR+h5cID4lqV7KDXGcIFOX6QJJLxzHlMPrV
        UO4+obc/VrmzFrJ4xpEUjoS1femQL3KxNGex3aEl0duJLYCwZ19aKBLkJ1ykP23m
        2h0w1xfiFRkbTbv0+FYLBVyEFCSUbHWOVpVPKjXYwjdb4fWacozWPwL/RsvYsy4c
        MrX9zhQx4H7VBeNupeuVLmhuJXVr1O6Ka0kDySlAfmoEJQvcvjT1xY5aRuMQ87de
        ZaDWNnp0Jg7Mi4cdilCN0nmRkD81xEIVEULWeDpsJyw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=WplENM
        2h9IHtw/qRxZid+AwiRh7x8LVHHM217ruNw/M=; b=XYnF1mQyoI23hvp8mFWf/d
        Ib8GCgHGBmco094ftdMcA2X05hLTPDSyq3ACapD50T1dkZv6VhWfw3ZQ5PAMzXXE
        2/oyLNuR4ro7/N1yq+5KOj8DfZ0cExEDJbMJtLYGCqjWlz/Lm9rdzp7duXxpOBiN
        KAyTRbod8zCm/gkmckVvBn1xKnG6NdcRHGjj2Ik+FwsIjro4SCFK1zM3+UdGAt8v
        k998tObQsnUStJc7p397GsU8jRJk6TP3y9SjmUGwpJRkRGPSFjBaKPj1X3KbJ3n1
        7zI9CTgAxHNf6xGGdiMvtL4tzKNeg43lGrPOE4MN7Q2CO48GQltO+6yYcGLXKVBg
        ==
X-ME-Sender: <xms:GvTSYZFn8id0WgoRNQDLaxoGJFIw-WCQ5AVOnGsdeWKrB3JtVOmyLw>
    <xme:GvTSYeV65ErgS2viio7uRN45tvqUOBn2H6G2_zQTAqo59MpM0s97CPN9aQH2i2Trt
    KWW1bQ5ybIBnQ>
X-ME-Received: <xmr:GvTSYbJpLgK2H7AFshb3xHzHbTKt_efii9aPMpfdVUBAzMV_X5oO6M1mxG5kE9-2Wz0k5uQ3o-CZ30bIAETlLckjDlGBpGD4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrudefuddggeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:GvTSYfFYtLEQE629dbGDduGG_tCt0XnLlMcaFp1LVxXlLXpiOqBTiw>
    <xmx:GvTSYfUoIupt-iRxtBAglIGx3pjGVsci3s7DX8qxHHyf8JM0xQkBKg>
    <xmx:GvTSYaMqGho0-_h3zykc6OdahLMtvh9i-55QgcO7YJuSBCGaTiKNnA>
    <xmx:G_TSYWOB6CLM9sdkZfBVfuCURuxP-XVhAfO5Q6loTimE6xkGVaQmy1oAtuQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 3 Jan 2022 08:03:21 -0500 (EST)
Date:   Mon, 3 Jan 2022 14:03:20 +0100
From:   Greg KH <greg@kroah.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     stefan@datenfreihafen.org, alex.aring@gmail.com,
        davem@davemloft.net, kuba@kernel.org, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Alexander Potapenko <glider@google.com>
Subject: Re: [PATCH RFT] ieee802154: atusb: move to new USB API
Message-ID: <YdL0GPxy4TdGDzOO@kroah.com>
References: <CAG_fn=VDEoQx5c7XzWX1yaYBd5y5FrG1aagrkv+SZ03c8TfQYQ@mail.gmail.com>
 <20220102171943.28846-1-paskripkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220102171943.28846-1-paskripkin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 02, 2022 at 08:19:43PM +0300, Pavel Skripkin wrote:
> Alexander reported a use of uninitialized value in
> atusb_set_extended_addr(), that is caused by reading 0 bytes via
> usb_control_msg().
> 
> Since there is an API, that cannot read less bytes, than was requested,
> let's move atusb driver to use it. It will fix all potintial bugs with
> uninit values and make code more modern
> 
> Fail log:
> 
> BUG: KASAN: uninit-cmp in ieee802154_is_valid_extended_unicast_addr include/linux/ieee802154.h:310 [inline]
> BUG: KASAN: uninit-cmp in atusb_set_extended_addr drivers/net/ieee802154/atusb.c:1000 [inline]
> BUG: KASAN: uninit-cmp in atusb_probe.cold+0x29f/0x14db drivers/net/ieee802154/atusb.c:1056
> Uninit value used in comparison: 311daa649a2003bd stack handle: 000000009a2003bd
>  ieee802154_is_valid_extended_unicast_addr include/linux/ieee802154.h:310 [inline]
>  atusb_set_extended_addr drivers/net/ieee802154/atusb.c:1000 [inline]
>  atusb_probe.cold+0x29f/0x14db drivers/net/ieee802154/atusb.c:1056
>  usb_probe_interface+0x314/0x7f0 drivers/usb/core/driver.c:396
> 
> Fixes: 7490b008d123 ("ieee802154: add support for atusb transceiver")
> Cc: stable@vger.kernel.org # 5.9
> Reported-by: Alexander Potapenko <glider@google.com>
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> ---
>  drivers/net/ieee802154/atusb.c | 61 +++++++++++++++++++++-------------
>  1 file changed, 38 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/net/ieee802154/atusb.c b/drivers/net/ieee802154/atusb.c
> index 23ee0b14cbfa..43befea0110f 100644
> --- a/drivers/net/ieee802154/atusb.c
> +++ b/drivers/net/ieee802154/atusb.c
> @@ -80,10 +80,9 @@ struct atusb_chip_data {
>   * in atusb->err and reject all subsequent requests until the error is cleared.
>   */
>  
> -static int atusb_control_msg(struct atusb *atusb, unsigned int pipe,
> -			     __u8 request, __u8 requesttype,
> -			     __u16 value, __u16 index,
> -			     void *data, __u16 size, int timeout)
> +static int atusb_control_msg_recv(struct atusb *atusb, __u8 request, __u8 requesttype,
> +				  __u16 value, __u16 index,
> +				  void *data, __u16 size, int timeout)

Why do you need a wrapper function at all?  Why not just call the real
usb functions instead?

>  {
>  	struct usb_device *usb_dev = atusb->usb_dev;
>  	int ret;
> @@ -91,8 +90,30 @@ static int atusb_control_msg(struct atusb *atusb, unsigned int pipe,
>  	if (atusb->err)
>  		return atusb->err;
>  
> -	ret = usb_control_msg(usb_dev, pipe, request, requesttype,
> -			      value, index, data, size, timeout);
> +	ret = usb_control_msg_recv(usb_dev, 0, request, requesttype,
> +				   value, index, data, size, timeout, GFP_KERNEL);
> +	if (ret < 0) {
> +		atusb->err = ret;
> +		dev_err(&usb_dev->dev,
> +			"%s: req 0x%02x val 0x%x idx 0x%x, error %d\n",
> +			__func__, request, value, index, ret);
> +	}

Why save off the error value at all?  And was that message needed?


> +
> +	return ret;
> +}
> +
> +static int atusb_control_msg_send(struct atusb *atusb, __u8 request, __u8 requesttype,
> +				  __u16 value, __u16 index,
> +				  void *data, __u16 size, int timeout)
> +{
> +	struct usb_device *usb_dev = atusb->usb_dev;
> +	int ret;
> +
> +	if (atusb->err)
> +		return atusb->err;
> +
> +	ret = usb_control_msg_send(usb_dev, 0, request, requesttype,
> +				   value, index, data, size, timeout, GFP_KERNEL);
>  	if (ret < 0) {
>  		atusb->err = ret;
>  		dev_err(&usb_dev->dev,
> @@ -107,8 +128,7 @@ static int atusb_command(struct atusb *atusb, u8 cmd, u8 arg)
>  	struct usb_device *usb_dev = atusb->usb_dev;
>  
>  	dev_dbg(&usb_dev->dev, "%s: cmd = 0x%x\n", __func__, cmd);
> -	return atusb_control_msg(atusb, usb_sndctrlpipe(usb_dev, 0),
> -				 cmd, ATUSB_REQ_TO_DEV, arg, 0, NULL, 0, 1000);
> +	return atusb_control_msg_send(atusb, cmd, ATUSB_REQ_TO_DEV, arg, 0, NULL, 0, 1000);
>  }
>  
>  static int atusb_write_reg(struct atusb *atusb, u8 reg, u8 value)
> @@ -116,9 +136,8 @@ static int atusb_write_reg(struct atusb *atusb, u8 reg, u8 value)
>  	struct usb_device *usb_dev = atusb->usb_dev;
>  
>  	dev_dbg(&usb_dev->dev, "%s: 0x%02x <- 0x%02x\n", __func__, reg, value);
> -	return atusb_control_msg(atusb, usb_sndctrlpipe(usb_dev, 0),
> -				 ATUSB_REG_WRITE, ATUSB_REQ_TO_DEV,
> -				 value, reg, NULL, 0, 1000);
> +	return atusb_control_msg_send(atusb, ATUSB_REG_WRITE, ATUSB_REQ_TO_DEV,
> +				      value, reg, NULL, 0, 1000);

This return value can be different, are you sure you want to call this
this way?

I would recommend just moving to use the real USB functions and no
wrapper function at all like this, it will make things more obvious and
easier to understand over time.

thanks,

greg k-h

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15FF7224C4
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 22:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729206AbfERULb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 May 2019 16:11:31 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36963 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbfERULb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 May 2019 16:11:31 -0400
Received: by mail-wr1-f65.google.com with SMTP id e15so10433065wrs.4;
        Sat, 18 May 2019 13:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7Ed+VZRB6xkgrgm66qqD4/H342rN7RabjGvrm7K/6mU=;
        b=JjYaUCgpVuSXPLOwmEyvo1GlS2LUE0ybl2+yUcJFMc8ajsDJAM6SImyOtQrDl6TwbU
         /obfSiP+J3A6ia3rGEobGHzc7JMvgZdpW5KGds1ETDlMcDK5RlWqU5a3TTnKk4/qgSIJ
         hOSHXNVSru4DFXyq581K/u2NIG6qUhkFGXPCJMs/977gPS2HABsLD+uIerKVudRUL/mO
         a0ioQdo3oZAnIP32BHAbYVSLmXasz+XtS8BZsdQ7WBaQVw8qv05On5fQaBvv23QweFls
         ku3lv0SjbesX7a3xuH+9cItRWUxNM1tBFGKNLQR5OfZ2oae2jbxUMExbDbAoLend5G11
         WzPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7Ed+VZRB6xkgrgm66qqD4/H342rN7RabjGvrm7K/6mU=;
        b=L3YqW73YraWh0vPcLyFNrJjGKWL1WGujOhLdStH2zsyDvQCCzb1RuprxF2TrWLzNGJ
         tADefi1sueatzJPGt3LTbLM9n8ce2hbKbSXJfahzK/+IDXWojB53EypUF7ZlrLWJDH8Z
         tO7MNJudi7b4vXnvaoAM76IRUlk6F6gIc/JbEuBtMKD31NEmlptaccFw40WcG9SkdZZg
         N53CLjeq2cIdKLkhoLFdo77rYY5kFemVHIXRgEMUXKK/EbWJ5/XLMacWwLoJKjB3BgM5
         GNiTTzJDAXkbu79Lfi5DhMsnFW4EtaWfgD5GSQKMvZ5SFNoG2zGB03eq0Vg+bbvdn28j
         S3ow==
X-Gm-Message-State: APjAAAW2Eb0/8wPQSUQBjMI03Gych939ARYXrCPJ+tsDEJUEsAn0Ek2p
        Bt9uJeHLmKKi9ptyplZhTTE=
X-Google-Smtp-Source: APXvYqzxhJMpsHTuk8Du+YvpVpK0p6Y81VoYMKDS1dVytZvR5NJ2LH25CPr9jqBkE2ZrxaUtHFOWLA==
X-Received: by 2002:a5d:4e46:: with SMTP id r6mr39171782wrt.290.1558210287808;
        Sat, 18 May 2019 13:11:27 -0700 (PDT)
Received: from debian64.daheim (p4FD0962E.dip0.t-ipconnect.de. [79.208.150.46])
        by smtp.gmail.com with ESMTPSA id u11sm4067405wrn.1.2019.05.18.13.11.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 18 May 2019 13:11:27 -0700 (PDT)
Received: from localhost.daheim ([127.0.0.1] helo=debian64.localnet)
        by debian64.daheim with esmtp (Exim 4.92)
        (envelope-from <chunkeey@gmail.com>)
        id 1hS5fy-00024r-Df; Sat, 18 May 2019 22:11:26 +0200
From:   Christian Lamparter <chunkeey@gmail.com>
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     syzbot <syzbot+200d4bb11b23d929335f@syzkaller.appspotmail.com>,
        andreyknvl@google.com, chunkeey@googlemail.com,
        davem@davemloft.net, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        oneukum@suse.com, syzkaller-bugs@googlegroups.com
Subject: Re: KASAN: use-after-free Read in p54u_load_firmware_cb
Date:   Sat, 18 May 2019 22:11:26 +0200
Message-ID: <1715066.X1OYgGOCOL@debian64>
In-Reply-To: <Pine.LNX.4.44L0.1905181346380.10594-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.1905181346380.10594-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Saturday, May 18, 2019 7:49:49 PM CEST you wrote:
> On Sat, 18 May 2019, syzbot wrote:
> > 
> > syzbot has tested the proposed patch but the reproducer still triggered  
> > crash:
> > KASAN: use-after-free Read in usb_driver_release_interface
> > 
> > usb 1-1: Loading firmware file isl3887usb
> > usb 1-1: Direct firmware load for isl3887usb failed with error -2
> > usb 1-1: Firmware not found.
> > p54usb 1-1:0.143: failed to initialize device (-2)
> > ==================================================================
> > BUG: KASAN: use-after-free in usb_driver_release_interface+0x16b/0x190  
> > drivers/usb/core/driver.c:584
> > Read of size 8 at addr ffff88808fc31218 by task kworker/0:1/12
> 
> Now the bad access is in a different place.  That's a good sign.
> In this case it indicates that although udev is still hanging around, 
> intf has already been freed.  We really should acquire a reference to 
> it instead.
> 
> Alan Stern

Thanks. I can confirm that it works with the real ISL3887 
hardware as well. Can you please spin up a patch or how
should this be continued?

Cheers,
Christian 

>  drivers/net/wireless/intersil/p54/p54usb.c |   43 ++++++++++++-----------------
>  1 file changed, 18 insertions(+), 25 deletions(-)
> 
> Index: usb-devel/drivers/net/wireless/intersil/p54/p54usb.c
> ===================================================================
> --- usb-devel.orig/drivers/net/wireless/intersil/p54/p54usb.c
> +++ usb-devel/drivers/net/wireless/intersil/p54/p54usb.c
> @@ -33,6 +33,8 @@ MODULE_ALIAS("prism54usb");
>  MODULE_FIRMWARE("isl3886usb");
>  MODULE_FIRMWARE("isl3887usb");
>  
> +static struct usb_driver p54u_driver;
> +
>  /*
>   * Note:
>   *
> @@ -921,9 +923,9 @@ static void p54u_load_firmware_cb(const
>  {
>  	struct p54u_priv *priv = context;
>  	struct usb_device *udev = priv->udev;
> +	struct usb_interface *intf = priv->intf;
>  	int err;
>  
> -	complete(&priv->fw_wait_load);
>  	if (firmware) {
>  		priv->fw = firmware;
>  		err = p54u_start_ops(priv);
> @@ -932,26 +934,22 @@ static void p54u_load_firmware_cb(const
>  		dev_err(&udev->dev, "Firmware not found.\n");
>  	}
>  
> -	if (err) {
> -		struct device *parent = priv->udev->dev.parent;
> -
> -		dev_err(&udev->dev, "failed to initialize device (%d)\n", err);
> -
> -		if (parent)
> -			device_lock(parent);
> +	complete(&priv->fw_wait_load);
> +	/*
> +	 * At this point p54u_disconnect may have already freed
> +	 * the "priv" context. Do not use it anymore!
> +	 */
> +	priv = NULL;
>  
> -		device_release_driver(&udev->dev);
> -		/*
> -		 * At this point p54u_disconnect has already freed
> -		 * the "priv" context. Do not use it anymore!
> -		 */
> -		priv = NULL;
> +	if (err) {
> +		dev_err(&intf->dev, "failed to initialize device (%d)\n", err);
>  
> -		if (parent)
> -			device_unlock(parent);
> +		usb_lock_device(udev);
> +		usb_driver_release_interface(&p54u_driver, intf);
> +		usb_unlock_device(udev);
>  	}
>  
> -	usb_put_dev(udev);
> +	usb_put_intf(intf);
>  }
>  
>  static int p54u_load_firmware(struct ieee80211_hw *dev,
> @@ -972,14 +970,14 @@ static int p54u_load_firmware(struct iee
>  	dev_info(&priv->udev->dev, "Loading firmware file %s\n",
>  	       p54u_fwlist[i].fw);
>  
> -	usb_get_dev(udev);
> +	usb_get_intf(intf);
>  	err = request_firmware_nowait(THIS_MODULE, 1, p54u_fwlist[i].fw,
>  				      device, GFP_KERNEL, priv,
>  				      p54u_load_firmware_cb);
>  	if (err) {
>  		dev_err(&priv->udev->dev, "(p54usb) cannot load firmware %s "
>  					  "(%d)!\n", p54u_fwlist[i].fw, err);
> -		usb_put_dev(udev);
> +		usb_put_intf(intf);
>  	}
>  
>  	return err;
> @@ -1011,8 +1009,6 @@ static int p54u_probe(struct usb_interfa
>  	skb_queue_head_init(&priv->rx_queue);
>  	init_usb_anchor(&priv->submitted);
>  
> -	usb_get_dev(udev);
> -
>  	/* really lazy and simple way of figuring out if we're a 3887 */
>  	/* TODO: should just stick the identification in the device table */
>  	i = intf->altsetting->desc.bNumEndpoints;
> @@ -1053,10 +1049,8 @@ static int p54u_probe(struct usb_interfa
>  		priv->upload_fw = p54u_upload_firmware_net2280;
>  	}
>  	err = p54u_load_firmware(dev, intf);
> -	if (err) {
> -		usb_put_dev(udev);
> +	if (err)
>  		p54_free_common(dev);
> -	}
>  	return err;
>  }
>  
> @@ -1072,7 +1066,6 @@ static void p54u_disconnect(struct usb_i
>  	wait_for_completion(&priv->fw_wait_load);
>  	p54_unregister_common(dev);
>  
> -	usb_put_dev(interface_to_usbdev(intf));
>  	release_firmware(priv->fw);
>  	p54_free_common(dev);
>  }
> 
> 





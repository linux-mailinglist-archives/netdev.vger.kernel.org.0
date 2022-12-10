Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFAB5648E45
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 11:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbiLJK7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 05:59:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiLJK7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 05:59:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B49DBCA4;
        Sat, 10 Dec 2022 02:59:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F84460B2B;
        Sat, 10 Dec 2022 10:59:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A1BDC433EF;
        Sat, 10 Dec 2022 10:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670669974;
        bh=9Ba55FamUQD94n7+bqRFC7LNfipEY1H++sF1ApKOw4c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HldOCBwKAo1ZvYfSMLipFcFrb6nAK5WqavEa4FPhS3b0iQa5y3I7D0af7P5C3v3rd
         /Zgk8XLopjlqjBaM2Dp9l84a/1a1+azpRSBry9EcMxLaKwjJSN/r4ilmjIaaxxwnVR
         z0L0wFTLNiy8vwesv673SaCpBH6Zmc3kBVN2hx77Frw7J9lP2yXX3jbI+SSi0EM1rX
         6CpIFoLkvRN9dQ79EEXnNjZyhR/N1HVxh7bPbwFdGdLdFEf0oq7I5cQpME+4v2042u
         Hzxg+xNfJVc2Xss/kU6AwkvuVe0LvXW0oZ/wwhqtP/DlT+I+KKVODbszwNT3YbN60i
         5zKJ03RmH3sdw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1p3xaB-0005xq-OH; Sat, 10 Dec 2022 11:59:52 +0100
Date:   Sat, 10 Dec 2022 11:59:51 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        Oliver Neukum <oneukum@suse.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Frank Jungclaus <frank.jungclaus@esd.eu>, socketcan@esd.eu,
        Yasushi SHOJI <yashi@spacecubics.com>,
        Stefan =?utf-8?B?TcOkdGpl?= <stefan.maetje@esd.eu>,
        Hangyu Hua <hbh25y@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Peter Fink <pfink@christ-es.de>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        Christoph =?utf-8?Q?M=C3=B6hring?= <cmoehring@christ-es.de>,
        John Whittington <git@jbrengineering.co.uk>,
        Vasanth Sadhasivan <vasanth.sadhasivan@samsara.com>,
        Jimmy Assarsson <extja@kvaser.com>,
        Anssi Hannula <anssi.hannula@bitwise.fi>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        Dongliang Mu <dzm91@hust.edu.cn>,
        Sebastian Haas <haas@ems-wuensche.com>,
        Maximilian Schneider <max@schneidersoft.net>,
        Daniel Berglund <db@kvaser.com>,
        Olivier Sobrie <olivier@sobrie.be>,
        Remigiusz =?utf-8?B?S2/FgsWCxIV0YWo=?= 
        <remigiusz.kollataj@mobica.com>,
        Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>,
        Martin Elshuber <martin.elshuber@theobroma-systems.com>,
        Bernd Krumboeck <b.krumboeck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v2 1/9] can: ems_usb: ems_usb_disconnect(): fix NULL
 pointer dereference
Message-ID: <Y5Rmp66zvlwykRLq@hovoldconsulting.com>
References: <20221203133159.94414-1-mailhol.vincent@wanadoo.fr>
 <20221210090157.793547-1-mailhol.vincent@wanadoo.fr>
 <20221210090157.793547-2-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221210090157.793547-2-mailhol.vincent@wanadoo.fr>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 10, 2022 at 06:01:49PM +0900, Vincent Mailhol wrote:
> ems_usb sets the driver's priv data to NULL before waiting for the
> completion of outsdanding urbs. This can results in NULL pointer
> dereference, c.f. [1] and [2].

Please stop making hand-wavy claims like this. There is no risk for a
NULL-pointer deference here, and if you think otherwise you need to
explain how that can happen in detail for each driver.

> Remove the call to usb_set_intfdata(intf, NULL). The core will take
> care of setting it to NULL after ems_usb_disconnect() at [3].
> 
> [1] c/27ef17849779 ("usb: add usb_set_intfdata() documentation")
> Link: https://git.kernel.org/gregkh/usb/c/27ef17849779

The claim in this commit is not correct either.

> [2] thread about usb_set_intfdata() on linux-usb mailing.
> Link: https://lore.kernel.org/linux-usb/Y4OD70GD4KnoRk0k@rowland.harvard.edu/
> 
> [3] function usb_unbind_interface() from drivers/usb/core/driver.c
> Link: https://elixir.bootlin.com/linux/v6.0/source/drivers/usb/core/driver.c#L497
> 
> Fixes: 702171adeed3 ("ems_usb: Added support for EMS CPC-USB/ARM7 CAN/USB interface")
> Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> ---
>  drivers/net/can/usb/ems_usb.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/net/can/usb/ems_usb.c b/drivers/net/can/usb/ems_usb.c
> index 050c0b49938a..c64cb40ac8de 100644
> --- a/drivers/net/can/usb/ems_usb.c
> +++ b/drivers/net/can/usb/ems_usb.c
> @@ -1062,8 +1062,6 @@ static void ems_usb_disconnect(struct usb_interface *intf)
>  {
>  	struct ems_usb *dev = usb_get_intfdata(intf);

The interface data pointer is only used in this function so there is no
risk for any NULL pointer dereference here. I only checked one of the
other drivers you patch, but I'm pretty sure all of your claims about
fixing NULL-pointer dereferences in this series are equally bogus.

>  
> -	usb_set_intfdata(intf, NULL);
> -
>  	if (dev) {
>  		unregister_netdev(dev->netdev);

Johan

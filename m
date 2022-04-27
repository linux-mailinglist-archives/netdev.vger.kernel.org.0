Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 071B7511736
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 14:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233131AbiD0LyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 07:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233100AbiD0LyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 07:54:12 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A1AD81656;
        Wed, 27 Apr 2022 04:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=B0DGrj8gjA7CDp3u5XWWbAMnHrzUw9RKhTFVio8B3QA=; b=JKZHvzifzVQVHvHdBafJUb/wyh
        /rBcOPhBoNnnZhf28r3cqZheonp6eUBrEP6TpALa5UcO1NA8+/8GcSltoA0qfstH5y4T2laIdZkjM
        2eG7R9pog8598e94TJEbKTpqlLPGa07SVPbr0RiLKhR3aQ4IFME2MyAqH2BFc5jaxCJQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1njgBu-0006Sa-WE; Wed, 27 Apr 2022 13:50:43 +0200
Date:   Wed, 27 Apr 2022 13:50:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, Andre Edich <andre.edich@microchip.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Martyn Welch <martyn.welch@collabora.com>,
        Gabriel Hojda <ghojda@yo2urs.ro>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next 4/7] usbnet: smsc95xx: Avoid link settings race
 on interrupt reception
Message-ID: <YmkuEtyhwuayYdWJ@lunn.ch>
References: <cover.1651037513.git.lukas@wunner.de>
 <28fd5a3d53a401cdf8ae0a116108702a46d2c7a2.1651037513.git.lukas@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28fd5a3d53a401cdf8ae0a116108702a46d2c7a2.1651037513.git.lukas@wunner.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  static void smsc95xx_status(struct usbnet *dev, struct urb *urb)
> @@ -607,7 +607,7 @@ static void smsc95xx_status(struct usbnet *dev, struct urb *urb)
>  	netif_dbg(dev, link, dev->net, "intdata: 0x%08X\n", intdata);
>  
>  	if (intdata & INT_ENP_PHY_INT_)
> -		usbnet_defer_kevent(dev, EVENT_LINK_RESET);
> +		;
>  	else
>  		netdev_warn(dev->net, "unexpected interrupt, intdata=0x%08X\n",
>  			    intdata);

Hi Lukas

It would probably make sense to invert the condition and remove the ;

   Andrew

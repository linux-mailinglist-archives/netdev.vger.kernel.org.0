Return-Path: <netdev+bounces-3351-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CB7D706882
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 14:46:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 342801C20C2F
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 12:46:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F31F18B13;
	Wed, 17 May 2023 12:46:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B1D18B0D
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 12:46:00 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F0E61BF;
	Wed, 17 May 2023 05:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=BWYqbwkLKMTrdnMEBJD94Fcz+RfaghXSbYUJZ/5uHgE=; b=Ret9o0w+It8gwyudUkdi3qC1yy
	xVsJmZenx45/jjMrZnFm91vre2Uj2adrtEDA2C/ZE5SQ6lDjztthyZwo0Epk2Pcl/vhgTNtKHlPqD
	9NHHb7XXAtB4s2dfkJuzybK9WPyvV8qIG0ddT+uMPw/WKEOCulB41EtZYvONO+q9J2XmQ7SPuU1ZM
	IBjJYWv7H62HZcd3vCde8xRVZSGCprz+IFdk5nBiAz2Et7jXFrOW/igKYzauY82klvejxjaVftfEG
	rpnQx6m1kyQiVWTECrMHUCrobhfv8cEn7yZZWfDxqDve1VI/C50zfC88Nn2FCpEl7pHkkmtIgLGTr
	k2xpra8Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:53524)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1pzGXM-0007oG-6r; Wed, 17 May 2023 13:45:48 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1pzGXK-0001rr-1S; Wed, 17 May 2023 13:45:46 +0100
Date: Wed, 17 May 2023 13:45:46 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>, Andrew Lunn <andrew@lunn.ch>,
	Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Woojung Huh <woojung.huh@microchip.com>,
	Arun Ramadoss <arun.ramadoss@microchip.com>, kernel@pengutronix.de,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v2 1/2] net: dsa: microchip: ksz8: Make flow
 control, speed, and duplex on CPU port configurable
Message-ID: <ZGTMepjv33bJbck/@shell.armlinux.org.uk>
References: <20230517121034.3801640-1-o.rempel@pengutronix.de>
 <20230517121034.3801640-2-o.rempel@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517121034.3801640-2-o.rempel@pengutronix.de>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 17, 2023 at 02:10:33PM +0200, Oleksij Rempel wrote:
> +/**
> + * ksz8_upstram_link_up - Configures the CPU/upstream port of the switch.
> + * @dev: The KSZ device instance.
> + * @port: The port number to configure.
> + * @speed: The desired link speed.
> + * @duplex: The desired duplex mode.
> + * @tx_pause: If true, enables transmit pause.
> + * @rx_pause: If true, enables receive pause.
> + *
> + * Description:
> + * The function configures flow control and speed settings for the CPU/upstream
> + * port of the switch based on the desired settings, current duplex mode, and
> + * speed.
> + */
> +static void ksz8_upstram_link_up(struct ksz_device *dev, int port, int speed,
> +				 int duplex, bool tx_pause, bool rx_pause)
> +{
> +	u8 ctrl = 0;
> +
> +	if (duplex) {
> +		if (tx_pause || rx_pause)
> +			ctrl |= SW_FLOW_CTRL;
> +	} else {
> +		ctrl |= SW_HALF_DUPLEX;
> +		if (tx_pause || rx_pause)
> +			ctrl |= SW_HALF_DUPLEX_FLOW_CTRL;

It's come up before whether the pause settings should be used to control
half-duplex flow control, and I believe the decision was they shouldn't.

The other thing I find slightly weird is that this is only being done
for upstream ports - why would a port that's between switches or the
switch and the CPU be in half duplex mode?

Also, why would such a port want to use some kind of flow control? If
the CPU starts sending pause frames because its got stuck, doesn't
that eventually kill the entire network? Also doesn't it limit the
network bandwidth to the ability of the host CPU *not* to send
pause frames?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!


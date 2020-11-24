Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31FA92C19E4
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 01:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729145AbgKXAUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 19:20:23 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46338 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726844AbgKXAUX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 19:20:23 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1khM4D-008ZOl-0v; Tue, 24 Nov 2020 01:20:21 +0100
Date:   Tue, 24 Nov 2020 01:20:21 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: sfp: VSOL V2801F / CarlitoxxPro
 CPGOS03-0490 v2.0 workaround
Message-ID: <20201124002021.GB2031446@lunn.ch>
References: <E1khJlv-0003Jq-ET@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1khJlv-0003Jq-ET@rmk-PC.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -335,10 +336,19 @@ static int sfp_i2c_read(struct sfp *sfp, bool a2, u8 dev_addr, void *buf,
>  			size_t len)
>  {
>  	struct i2c_msg msgs[2];
> -	u8 bus_addr = a2 ? 0x51 : 0x50;
> +	size_t block_size;
>  	size_t this_len;
> +	u8 bus_addr;
>  	int ret;
>  
> +	if (a2) {
> +		block_size = 16;
> +		bus_addr = 0x51;

Hi Russell, Thomas

Does this man the diagnostic page can be read 16 bytes at a time, even
when the other page has to be 1 bytes at a time? That seems rather
odd. Or is the diagnostic page not implemented in these SFPs?

     Andrew

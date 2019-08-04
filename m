Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CEE180B57
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 17:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbfHDPER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 11:04:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59802 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726181AbfHDPER (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Aug 2019 11:04:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=9YmikpTEpr5D1kpfN5dBORPimRY5G5XZGxcVzG0I71E=; b=sspKmymJGZKyjEHU4QnsfXYY76
        Q2i1TaxOrrITR9iSoME1XCUXeqEjE4k83TV2x0Q9W/xoaFALuH5E+lwtSQRed+T7gFn6UY1kbbEuW
        gMxQPRzHSsppP3vmlVagR1MvTM0Ir/xR7ST7MwOY87thZjkW0XlRnSfBJDPY4+ej98TA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1huI3S-000248-Lh; Sun, 04 Aug 2019 17:04:14 +0200
Date:   Sun, 4 Aug 2019 17:04:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hubert Feurstein <h.feurstein@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: drop adjust_link to enabled
 phylink
Message-ID: <20190804150414.GC6800@lunn.ch>
References: <20190731154239.19270-1-h.feurstein@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190731154239.19270-1-h.feurstein@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 31, 2019 at 05:42:39PM +0200, Hubert Feurstein wrote:
> We have to drop the adjust_link callback in order to finally migrate to
> phylink.
> 
> Otherwise we get the following warning during startup:
>   "mv88e6xxx 2188000.ethernet-1:10: Using legacy PHYLIB callbacks. Please
>    migrate to PHYLINK!"
> 
> The warning is generated in the function dsa_port_link_register_of in
> dsa/port.c:
> 
>   int dsa_port_link_register_of(struct dsa_port *dp)
>   {
>   	struct dsa_switch *ds = dp->ds;
> 
>   	if (!ds->ops->adjust_link)
>   		return dsa_port_phylink_register(dp);
> 
>   	dev_warn(ds->dev,
>   		 "Using legacy PHYLIB callbacks. Please migrate to PHYLINK!\n");
>   	[...]
>   }
> 
> Signed-off-by: Hubert Feurstein <h.feurstein@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

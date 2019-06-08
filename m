Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF63C3A154
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 20:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbfFHS5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 14:57:35 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38558 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727250AbfFHS5f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Jun 2019 14:57:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Sxr+YCiSfpfPT5QGkRqyvmziLIKDNIEsqqcZXqpDP04=; b=gU07JcuYtOZP016p1ZeMV904vc
        /gy4yDTBPn2yRpTlF/yRbctPhpIP00BU72Hg4z+RxNs7KjxGGlBKJ+FcCZ/JJKo96acinGWI9bT2o
        mbfy5Ed7a3IwpRV8lHZGKP/n2NO7xBTw41IWa7yLBHVSLDvOJtd37tL6RBg9QjjH7hKs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hZgWy-0006An-9r; Sat, 08 Jun 2019 20:57:32 +0200
Date:   Sat, 8 Jun 2019 20:57:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 4/4] net: dsa: sja1105: Rethink the PHYLINK
 callbacks
Message-ID: <20190608185732.GF22700@lunn.ch>
References: <20190608130344.661-1-olteanv@gmail.com>
 <20190608130344.661-5-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190608130344.661-5-olteanv@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 08, 2019 at 04:03:44PM +0300, Vladimir Oltean wrote:
> The first fact that needs to be stated is that the per-MAC settings in
> SJA1105 called EGRESS and INGRESS do *not* disable egress and ingress on
> the MAC. They only prevent non-link-local traffic from being
> sent/received on this port.
> 
> So instead of having .phylink_mac_config essentially mess with the STP
> state and force it to DISABLED/BLOCKING (which also brings useless
> complications in sja1105_static_config_reload), simply add the
> .phylink_mac_link_down and .phylink_mac_link_up callbacks which inhibit
> TX at the MAC level, while leaving RX essentially enabled.
> 
> Also stop from trying to put the link down in .phylink_mac_config, which
> is incorrect.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

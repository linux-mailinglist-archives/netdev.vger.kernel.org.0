Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9395363C767
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 19:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236177AbiK2Sv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 13:51:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236192AbiK2Svy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 13:51:54 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA613C6F1;
        Tue, 29 Nov 2022 10:51:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=XpEeI/9mKQwH7FbdFrYBkMz1l2jJHzNNlZ7rFT6aPG8=; b=2cByblDprP8Xs/49TMYmd39s3/
        4Z+1m9pffoBseTe8ti59Lh00z6V/yQ8reHGulCF/5AlspB1s0I81IWVt5n9ht8kn14GsEh+i+bol7
        eRaXzEWqVEWXEI/XC4X6mWAcj1rhVW4jVd925QTolUI35OfZulonxJCktMFD0wAFBIZA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p05hq-003u6g-5c; Tue, 29 Nov 2022 19:51:46 +0100
Date:   Tue, 29 Nov 2022 19:51:46 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 04/12] net: dpaa2-mac: remove defensive check in
 dpaa2_mac_disconnect()
Message-ID: <Y4ZUwlGPZZCEDUp9@lunn.ch>
References: <20221129141221.872653-1-vladimir.oltean@nxp.com>
 <20221129141221.872653-5-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129141221.872653-5-vladimir.oltean@nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 29, 2022 at 04:12:13PM +0200, Vladimir Oltean wrote:
> dpaa2_mac_disconnect() will only be called with a NULL mac->phylink if
> dpaa2_mac_connect() failed, or was never called.
> 
> The callers are these:
> 
> dpaa2_eth_disconnect_mac():
> 
> 	if (dpaa2_eth_is_type_phy(priv))
> 		dpaa2_mac_disconnect(priv->mac);
> 
> dpaa2_switch_port_disconnect_mac():
> 
> 	if (dpaa2_switch_port_is_type_phy(port_priv))
> 		dpaa2_mac_disconnect(port_priv->mac);
> 
> priv->mac can be NULL, but in that case, dpaa2_eth_is_type_phy() returns
> false, and dpaa2_mac_disconnect() is never called. Similar for
> dpaa2-switch.
> 
> When priv->mac is non-NULL, it means that dpaa2_mac_connect() returned
> zero (success), and therefore, priv->mac->phylink is also a valid
> pointer.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

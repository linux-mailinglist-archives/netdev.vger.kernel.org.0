Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DFDE6B9B8D
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbjCNQcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbjCNQcL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:32:11 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A73A19C7A;
        Tue, 14 Mar 2023 09:32:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xoOdp0YkUjLCyhucmrAncUd+xFPtepn+KugDr1Gd1jA=; b=Vp0YBavg+airyOwPHld1HkuktS
        F7rH3XyWXoOY1VV3T8zFDL5nYXnE3l7WiZF2ibtuCxJycl7Ozq7fSQh6lAxj+KR8UsvdXC+IGCjXo
        bP8R7cpf0oXf5fNG7Cg1a2CfI+ixJyt3ZX0At5SSyS9i5iyxLDEYZIyNyl7VDJV5QiCw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pc7Yv-007JFW-Js; Tue, 14 Mar 2023 17:31:45 +0100
Date:   Tue, 14 Mar 2023 17:31:45 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: phy: mscc: fix deadlock in
 phy_ethtool_{get,set}_wol()
Message-ID: <a9bfe427-4d76-44ea-9890-3b0c44ccb551@lunn.ch>
References: <20230314153025.2372970-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314153025.2372970-1-vladimir.oltean@nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 05:30:25PM +0200, Vladimir Oltean wrote:
> Since the blamed commit, phy_ethtool_get_wol() and phy_ethtool_set_wol()
> acquire phydev->lock, but the mscc phy driver implementations,
> vsc85xx_wol_get() and vsc85xx_wol_set(), acquire the same lock as well,
> resulting in a deadlock.
> 
> Fixes: 2f987d486610 ("net: phy: Add locks to ethtool functions")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Thanks Vladimir.

[Goes and checks to see if the same problem exists for other PHY drivers]

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

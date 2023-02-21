Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEF5469EA80
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 23:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbjBUW46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 17:56:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjBUW45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 17:56:57 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B5F4305E3;
        Tue, 21 Feb 2023 14:56:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=3Um0gYxCLjjbUMnFCJsEhD54ZTYx7XMQAgQMesWXaJo=; b=gF1ZnA2Yrkkx0yVu72vo8HjfMa
        RlNnuDDEUzpY3sQZ/SHRIyhIVmIcnND2fqwvGs3e5y8xs6S1fihHuBtL0iQjdozHYG07XrAY9lTBQ
        HaLiJTmHQrhN/i8qRjLw2b6bsKRKq2bZd71d8uCjDw+CrTQ6RGsI8k9DT8kZKzg/3Bw8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pUbYy-005doV-9k; Tue, 21 Feb 2023 23:56:44 +0100
Date:   Tue, 21 Feb 2023 23:56:44 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Li Yang <leoyang.li@nxp.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Luo Jie <luoj@codeaurora.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viorel Suman <viorel.suman@nxp.com>,
        Wei Fang <wei.fang@nxp.com>
Subject: Re: [PATCH] net: phy: at803x: fix the wol setting functions
Message-ID: <Y/VMLF0NGgO1F34K@lunn.ch>
References: <20230221224031.7244-1-leoyang.li@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230221224031.7244-1-leoyang.li@nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 21, 2023 at 04:40:31PM -0600, Li Yang wrote:
> In 7beecaf7d507 ("net: phy: at803x: improve the WOL feature"), it seems
> not correct to use a wol_en bit in a 1588 Control Register which is only
> available on AR8031/AR8033(share the same phy_id) to determine if WoL is
> enabled.  Change it back to use AT803X_INTR_ENABLE_WOL for determining
> the WoL status which is applicable on all chips supporting wol. Also
> update the at803x_set_wol() function to only update the 1588 register on
> chips having it.

> After this change, disabling wol at probe from
> d7cd5e06c9dd ("net: phy: at803x: disable WOL at probe") is no longer
> needed.  So it is removed.

Rather than remove it, please git revert it, and explain in the commit
message why.

> 
> Also remove the set_wol()/get_wol() callbacks from AR8032 which doesn't
> support WoL.

This change was part of 5800091a2061 ("net: phy: at803x: add support for AR8032 PHY")

Please break this patch up into individual fixes. The different fixes
might need different levels of backporting etc.

      Andrew

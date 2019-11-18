Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30087100F6A
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 00:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbfKRX3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 18:29:20 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:45236 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726787AbfKRX3U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 18:29:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=xzBLEuBAmReKOhXVQby8OFn3Jmtd/Rt5Q7hgYK/UCWw=; b=cg0haprZrdpQKsqvln7fj76kIU
        MX1eUaJ7SamaxwgZf5VLiBH4UYIeGLB1l+YkR0sulZPyhQXbT9okN7cB7KMIq3RZd3vXiPt43QaC3
        i1e5/NIgG8rwB/RrX4cGKYk/ij4/wCaCWaIsjQeyHL9dHsmhE+nNAyXT/RYshWqnoJlc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iWqSG-0005oY-9m; Tue, 19 Nov 2019 00:29:12 +0100
Date:   Tue, 19 Nov 2019 00:29:12 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Colin King <colin.king@canonical.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Dan Murphy <dmurphy@ti.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] net: phy: dp83869: fix return of uninitialized
 variable ret
Message-ID: <20191118232912.GC15395@lunn.ch>
References: <20191118114835.39494-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191118114835.39494-1-colin.king@canonical.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 18, 2019 at 11:48:35AM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> In the case where the call to phy_interface_is_rgmii returns zero
> the variable ret is left uninitialized and this is returned at
> the end of the function dp83869_configure_rgmii.  Fix this by
> returning 0 instead of the uninitialized value in ret.
> 
> Addresses-Coverity: ("Uninitialized scalar variable")
> Fixes: 01db923e8377 ("net: phy: dp83869: Add TI dp83869 phy")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Dan: phy_modify_mmd() could fail. You check the return value for
phy_read and phy_write, so it would be consistent to also check

	 Andrew

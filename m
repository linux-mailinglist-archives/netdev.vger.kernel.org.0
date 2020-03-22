Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A13618E9C0
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 16:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgCVPjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 11:39:51 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50362 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725970AbgCVPjv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Mar 2020 11:39:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=rEi0j46bS6kvyWAOGk3YeA0EJnQmsmMcV2ungd/+OYI=; b=oywd+Bwo5a/xI+VW+CADtxL1c5
        J59l/zr+xkHENCqMV7kkopp99BLQig1S0d8OCKbVbRZ7HmVwmW6/WKXaF2BP3qJEyxBK612TzfUm4
        vbkcSJ0cVdA2+oYET5HEwvOb8oSbdl2cbKpkSYtLpsAW2GMV+AlcEcs5sbLDlwxCqR70=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jG2hS-0000cN-EK; Sun, 22 Mar 2020 16:39:42 +0100
Date:   Sun, 22 Mar 2020 16:39:42 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dejin Zheng <zhengdejin5@gmail.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        broonie@kernel.org, alexios.zavras@intel.com, tglx@linutronix.de,
        mchehab+samsung@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4 8/9] net: phy: smsc: use
 phy_read_poll_timeout() to simplify the code
Message-ID: <20200322153942.GQ11481@lunn.ch>
References: <20200322065555.17742-1-zhengdejin5@gmail.com>
 <20200322065555.17742-9-zhengdejin5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200322065555.17742-9-zhengdejin5@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -125,15 +123,11 @@ static int lan87xx_read_status(struct phy_device *phydev)
>  			return rc;
>  
>  		/* Wait max 640 ms to detect energy */
> -		for (i = 0; i < 64; i++) {
> -			/* Sleep to allow link test pulses to be sent */
> -			msleep(10);

Another example where you should add an msleep() before
phy_read_poll_timeout().

	Andrew

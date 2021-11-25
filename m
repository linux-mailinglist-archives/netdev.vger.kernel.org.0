Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1B7145DDD5
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 16:45:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356201AbhKYPsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 10:48:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356170AbhKYPqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 10:46:52 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B99B1C0617A2;
        Thu, 25 Nov 2021 07:35:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4ZeojgPqWWrsMI5BHeJYX983PNTgh8dQN9F2ioLGkIs=; b=fBMUWHnUBpQs3qU9Nq4aPHReY7
        19sN6LtcvO+1tO01gi432dy2Hr+LDGv9p/F5YxpbSsTLAZzUd+q6A6Ng5b1x4nTEyM9SWKJKHBKSh
        poCFCNfK5RS40voK6YrugKO6S6MJkzOORq2mOMfXI/ZiFJd8BrE1185BQuV6caPzxIKAK9I5WwUow
        ilQzkFMVKVpt+JcV0WJOlgBoi+5gzyLIlKwC0k7Sxpyn9/h+v57wOJYaKvSGxswIpI6/8OIncVi6K
        H2JI9zCtBYIEqdR9uSEGdxW+UQRSfYnweSMLMqXFSUcLoXviemf8ml7FRMhxSu+UtU2Aae14IkhEM
        MDvlN7oA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55896)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mqGmi-000240-E6; Thu, 25 Nov 2021 15:35:40 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mqGme-0002Oo-7d; Thu, 25 Nov 2021 15:35:36 +0000
Date:   Thu, 25 Nov 2021 15:35:36 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Dylan Hung <dylan_hung@aspeedtech.com>
Cc:     linux-kernel@vger.kernel.org, linux-aspeed@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        andrew@aj.id.au, joel@jms.id.au, kuba@kernel.org,
        davem@davemloft.net, hkallweit1@gmail.com, andrew@lunn.ch,
        BMC-SW@aspeedtech.com, stable@vger.kernel.org
Subject: Re: [PATCH v2] mdio: aspeed: Fix "Link is Down" issue
Message-ID: <YZ+tSMT4Z6CpOgJ3@shell.armlinux.org.uk>
References: <20211125024432.15809-1-dylan_hung@aspeedtech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211125024432.15809-1-dylan_hung@aspeedtech.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 25, 2021 at 10:44:32AM +0800, Dylan Hung wrote:
> The issue happened randomly in runtime.  The message "Link is Down" is
> popped but soon it recovered to "Link is Up".
> 
> The "Link is Down" results from the incorrect read data for reading the
> PHY register via MDIO bus.  The correct sequence for reading the data
> shall be:
> 1. fire the command
> 2. wait for command done (this step was missing)
> 3. wait for data idle
> 4. read data from data register
> 
> Fixes: f160e99462c6 ("net: phy: Add mdio-aspeed")
> Cc: stable@vger.kernel.org
> Reviewed-by: Joel Stanley <joel@jms.id.au>
> Signed-off-by: Dylan Hung <dylan_hung@aspeedtech.com>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26B8C307B44
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 17:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232676AbhA1QrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 11:47:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232642AbhA1QoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 11:44:02 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D3C3C061756;
        Thu, 28 Jan 2021 08:43:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=jr4vFfg++SnMXfOeSfc+6KemdjdKPH7hTDK3XX4rC9M=; b=KM3uQh4JFyuNplHnKH/rJXVnx
        J+cgzF8Z/PYEp3QUsF6JKWFkp4CZ/Vy71vvMoEjJbZheADzt5Bk1F8DvHVHK38s2DQR2VStlyAngC
        INbcXo9MYDcrLq8F49R8MN7rXdoeRQe0mxPYai0vQVO21rjwrnaj5Ea3YQVpN58B2yz019BxczEeU
        qEJS+ev1Qd2KDPMtL2qgVj1Wvq6lvar7kuzib0bmuyPnouM5tH/ZUIpY/iXjQKpf8MGj0EcxcQBZb
        fXIVOxtR8jN4hvymof8CDHVlLgkyYFA17y+Wb2pgQHZXaX3gkNVXdrcdNXx/FM6pw549uIKez+2Jj
        u4QJsk4dw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:53860)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l5AO6-0006sN-Nf; Thu, 28 Jan 2021 16:43:18 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l5AO6-0005ye-02; Thu, 28 Jan 2021 16:43:18 +0000
Date:   Thu, 28 Jan 2021 16:43:17 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     stefanc@marvell.com
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org, mw@semihalf.com,
        andrew@lunn.ch, atenart@kernel.org
Subject: Re: [PATCH v4 net-next 00/19] net: mvpp2: Add TX Flow Control support
Message-ID: <20210128164317.GS1551@shell.armlinux.org.uk>
References: <1611747815-1934-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1611747815-1934-1-git-send-email-stefanc@marvell.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 01:43:16PM +0200, stefanc@marvell.com wrote:
> Armada hardware has a pause generation mechanism in GOP (MAC).
> The GOP generate flow control frames based on an indication programmed in Ports Control 0 Register. There is a bit per port.
> However assertion of the PortX Pause bits in the ports control 0 register only sends a one time pause.
> To complement the function the GOP has a mechanism to periodically send pause control messages based on periodic counters.
> This mechanism ensures that the pause is effective as long as the Appropriate PortX Pause is asserted.

I've tested this on my Macchiatobin SingleShot, which seems to be Ax
silicon (and I've checked a couple of my other Armada 8040 platforms
which are also Ax silicon too) and networking remains functional
without flow control with the gigabit port achieving wire speed. I
have not yet tested the 10G ports.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

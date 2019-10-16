Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1F1FD9050
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 14:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388454AbfJPMDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 08:03:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48160 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726845AbfJPMDs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 08:03:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=NBc8vNMTMHQOQr0qJqJ1ykg36+K8LkXUK+za7gCE8KM=; b=r3/LAoaD96vbDU2j+fvPIFoD20
        SGEOx5nSaf0Ts1XkiSI0c4QtBHAi5E2p/7fvmhYK18KKifoC6D6/42VS/1xilxmI/n9GD9KuFHOVq
        eloXC0prcgrF1TWl49J3B7JCgz54XjEObpPRSiY6Z9bOiuiRtgyQWymKFJwjqQQXbnco=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iKi1p-0007DI-GX; Wed, 16 Oct 2019 14:03:45 +0200
Date:   Wed, 16 Oct 2019 14:03:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH V2 2/2] net: dsa: microchip: Add shared regmap mutex
Message-ID: <20191016120345.GC4780@lunn.ch>
References: <20191013193238.1638-1-marex@denx.de>
 <20191013193238.1638-2-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191013193238.1638-2-marex@denx.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 13, 2019 at 09:32:38PM +0200, Marek Vasut wrote:
> The KSZ driver uses one regmap per register width (8/16/32), each with
> it's own lock, but accessing the same set of registers. In theory, it
> is possible to create a race condition between these regmaps, although
> the underlying bus (SPI or I2C) locking should assure nothing bad will
> really happen and the accesses would be correct.
> 
> To make the driver do the right thing, add one single shared mutex for
> all the regmaps used by the driver instead. This assures that even if
> some future hardware is on a bus which does not serialize the accesses
> the same way SPI or I2C does, nothing bad will happen.
> 
> Note that the status_mutex was unused and only initied, hence it was
> renamed and repurposed as the regmap mutex.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>

Apart from the reverse Christmas tree:

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

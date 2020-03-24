Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE3F1190364
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 02:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbgCXBuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 21:50:46 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53286 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727050AbgCXBup (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 21:50:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=X8eOYh8U+SAUyVMLYIeB5WW0gAe8+eI9Xw4DGhrAeeo=; b=WSIQMlZHaYEZzORPN0cHU35VX8
        cyn96AoiefhBXEXIHBrZQ8eBQ/f0/EuCYGVd3dJ+qPYKdzL1Yx2MJCw7lVCWqMJZBZSNFEV6BCbOJ
        FFG03vtyVupsJzDnlMuSHJkY1pqDsTJy8R8Gg5XaB3zd1XvEDvgHWtyzgpSXbdW0wM7M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jGYiH-0005g4-7p; Tue, 24 Mar 2020 02:50:41 +0100
Date:   Tue, 24 Mar 2020 02:50:41 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH 08/14] net: ks8851: Use 16-bit read of RXFC register
Message-ID: <20200324015041.GO3819@lunn.ch>
References: <20200323234303.526748-1-marex@denx.de>
 <20200323234303.526748-9-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323234303.526748-9-marex@denx.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -470,7 +455,7 @@ static void ks8851_rx_pkts(struct ks8851_net *ks)
>  	unsigned rxstat;
>  	u8 *rxpkt;
>  
> -	rxfc = ks8851_rdreg8(ks, KS_RXFC);
> +	rxfc = (ks8851_rdreg16(ks, KS_RXFCTR) >> 8) & 0xff;

The datasheet says:

2. When software driver reads back Receive Frame Count (RXFCTR)
Register; the KSZ8851 will update both Receive Frame Header Status and
Byte Count Registers (RXFHSR/RXFHBCR)

Are you sure there is no side affect here?

    Andrew

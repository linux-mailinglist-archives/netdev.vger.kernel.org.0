Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCF4C1BA81A
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 17:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbgD0Phx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 11:37:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38610 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726539AbgD0Phw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 11:37:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=tbO/qInFT/ce0RNaDB+incm3fmexORcfN7BfcatGOzU=; b=EnznLQsoTlG3Bj8lf0dDmEUvEg
        APTU67yif43WOms8Mo7O3iWVkUr+0Fb240tC7M4MTQ5HdiqNDcVgGTT9itpKB4kE8fcuPvzyyryML
        tSeT2r9HiSVe05o8t2aM3dg5C9l+rm8fA2pKGmPjw9Nv/RSKz2MG7WPGEowvaZKtp0IY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jT5pO-005Eq3-9b; Mon, 27 Apr 2020 17:37:50 +0200
Date:   Mon, 27 Apr 2020 17:37:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Leonard Crestez <leonard.crestez@nxp.com>
Cc:     Andy Duan <fugang.duan@nxp.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Chris Healy <Chris.Healy@zii.aero>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH] net: ethernet: fec: Replace interrupt driven MDIO with
 polled IO
Message-ID: <20200427153750.GE1212378@lunn.ch>
References: <20200414004551.607503-1-andrew@lunn.ch>
 <VI1PR04MB6941D611F6EF67BB42826D4EEEAF0@VI1PR04MB6941.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR04MB6941D611F6EF67BB42826D4EEEAF0@VI1PR04MB6941.eurprd04.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 03:19:54PM +0000, Leonard Crestez wrote:
> Hello,
> 
> This patch breaks network boot on at least imx8mm-evk. Boot works if I 
> revert just commit 29ae6bd1b0d8 ("net: ethernet: fec: Replace interrupt 
> driven MDIO with polled IO") on top of next-20200424.
> 
> Running with tp_printk trace_event=mdio:* shows the phy identifier is 
> not read correctly:
> 
> BAD:
> [    9.058457] mdio_access: 30be0000.ethernet-1 read  phy:0x00 reg:0x02 
> val:0x0000
> [    9.065857] mdio_access: 30be0000.ethernet-1 read  phy:0x00 reg:0x03 
> val:0x0000
> 
> GOOD:
> [    9.100485] mdio_access: 30be0000.ethernet-1 read  phy:0x00 reg:0x02 
> val:0x004d
> [    9.108271] mdio_access: 30be0000.ethernet-1 read  phy:0x00 reg:0x03 
> val:0xd074
> 
> I don't have the original patch in my inbox, hope the manual In-Reply-To 
> header is OK.

Hi Leonard

Thanks for you message. You are the first to provide useful
debug information.

Are you using NFS root?

Do you see any ETIMEOUT messages in the bad case?

Thanks
	Andrew

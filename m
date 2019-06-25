Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6BB55285
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 16:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731155AbfFYOvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 10:51:10 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58142 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730777AbfFYOvK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 10:51:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZgkOw5D3P/fjtwFB3Tcj7uXmbq5UBoyXYtEvi0Cd5KQ=; b=H31eTT/zqFXIrWiHqPMM5QkYYw
        WYq1+nRYh3eLMpTzHQG7qEy5Ae75pW2TtG9fvMLqz9NRepPGejbzjVEun4doa8/2kLWioOy9Y1+of
        K6kD32lrJfTt4gjLMqNUeOymXU2cJiC1NAO1NH6KvOvx3nayhOaziJTYa9M8Y6+BDXBc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hfmmn-000747-F7; Tue, 25 Jun 2019 16:51:05 +0200
Date:   Tue, 25 Jun 2019 16:51:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Katsuhiro Suzuki <katsuhiro@katsuster.net>
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: Re: [PATCH net-next] net: stmmac: Fix the case when PHY handle is
 not present
Message-ID: <20190625145105.GA4722@lunn.ch>
References: <351cce38d1c572d8b171044f2856c7fae9f89cbc.1561450696.git.joabreu@synopsys.com>
 <78EB27739596EE489E55E81C33FEC33A0B9D78A2@DE02WEMBXB.internal.synopsys.com>
 <5859e2c5-112f-597c-3bd5-e30e96b86152@katsuster.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5859e2c5-112f-597c-3bd5-e30e96b86152@katsuster.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 11:40:00PM +0900, Katsuhiro Suzuki wrote:
> Hello Jose,
> 
> This patch works fine with my Tinker Board. Thanks a lot!
> 
> Tested-by: Katsuhiro Suzuki <katsuhiro@katsuster.net>
> 
> 
> BTW, from network guys point of view, is it better to add a phy node
> into device trees that have no phy node such as the Tinker Board?

Hi Katsuhiro

It makes it less ambiguous if there is a phy-handle. It is then very
clear which PHY should be used. For a development board, which people
can be tinkering around with, there is a chance they add a second PHY
to the MDIO bus, or an Ethernet switch, etc. Without explicitly
listing the PHY, it might get the wrong one. However this is generally
a problem if phy_find_first() is used. I think in this case, something
is setting priv->plat->phy_addr, so it is also clearly defined which
PHY to use.

	  Andrew

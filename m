Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBE929F90
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 22:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391730AbfEXUGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 16:06:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57068 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391612AbfEXUGz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 16:06:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=gOrnkBTQTWZF9Sd/TECoA6yoR+L+Dk7IJXkNWEb1Ydk=; b=VmDghN6QMlnNwntqe8bCzFpSgc
        zQ/fPWnWYLe0se0LHaYW5649/s+/Fzw7QUFwhFNR7iMKRc/bXCAySCwgMBz2j3RJhwLAVjnf3jN05
        CTE6pKtBkt5qIWgypiWo9Ysg0wxjJlLn7VP/PdqA3269YhPmiUvwea43UtoDV6tvS5jE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hUGSq-0004NF-04; Fri, 24 May 2019 22:06:52 +0200
Date:   Fri, 24 May 2019 22:06:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Krzysztof Halasa <khalasa@piap.pl>
Subject: Re: [PATCH 7/8] net: ethernet: ixp4xx: Add DT bindings
Message-ID: <20190524200651.GQ21208@lunn.ch>
References: <20190524162023.9115-1-linus.walleij@linaro.org>
 <20190524162023.9115-8-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190524162023.9115-8-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +description: |
> +  The Intel IXP4xx ethernet makes use of the IXP4xx NPE (Network
> +  Processing Engine) and the IXP4xx Queue Mangager to process
> +  the ethernet frames. It can optionally contain an MDIO bus to
> +  talk to PHYs.

Hi Linus

You mention MDIO and PHYs, but the code is not there yet. When you do
add the needed code, it is a good idea to place the PHY nodes inside a
container node:

    ethernet@c8009000 {
        compatible = "intel,ixp4xx-ethernet";
        reg = <0xc8009000 0x1000>;
        status = "disabled";
        queue-rx = <&qmgr 3>;
        queue-txready = <&qmgr 20>;

        mdio {
		phy0: phy@0 {
		      reg = <0>;
		};
	};
    };

    Andrew

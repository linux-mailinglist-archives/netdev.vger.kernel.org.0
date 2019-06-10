Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAACF3B5F2
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 15:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390318AbfFJNZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 09:25:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41360 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388848AbfFJNZ6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 09:25:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=YI80HFnKhwfC06RagYAUP7ThPG5kbxVc9JBgg7X0bw4=; b=GRCoQxzsfFqofI/UoDR47FyGeh
        PXcWJC0FwW5udvg5zB6I1T1LiChU8rv8Jthx+vt8ENT0ibn9T3tlEYZ0FXRYnP3ryf1pXwTWnmJCv
        gOtGl5LRYrKCfS6iAGy680Rc8vL0QfqpdtYcupc3fDaOQSXeQ3e+62boTKbSztAhwzmc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1haKJ0-0006kC-Nt; Mon, 10 Jun 2019 15:25:46 +0200
Date:   Mon, 10 Jun 2019 15:25:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     Maxime Ripard <maxime.ripard@bootlin.com>, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linus.walleij@linaro.org, bgolaszewski@baylibre.com,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, devicetree@vger.kernel.org,
        Neil Armstrong <narmstrong@baylibre.com>, khilman@baylibre.com,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC next v1 0/5] stmmac: honor the GPIO flags for the PHY reset
 GPIO
Message-ID: <20190610132546.GE8247@lunn.ch>
References: <20190609180621.7607-1-martin.blumenstingl@googlemail.com>
 <20190609204510.GB8247@lunn.ch>
 <20190610114700.tymqzzax334ahtz4@flea>
 <CAFBinCCs5pa1QmaV32Dk9rOADKGXXFpZsSK=LUk4CGWMrG5VUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFBinCCs5pa1QmaV32Dk9rOADKGXXFpZsSK=LUk4CGWMrG5VUQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> if anyone else (just like me) doesn't know about it, there are generic
> bindings defined here: [0]
> 
> I just tested this on my X96 Max by defining the following properties
> inside the PHY node:
>   reset-delay-us = <10000>;
>   reset-assert-us = <10000>;
>   reset-deassert-us = <10000>;
>   reset-gpios = <&gpio GPIOZ_15 (GPIO_ACTIVE_LOW | GPIO_OPEN_DRAIN)>;
> 
> that means I don't need any stmmac patches which seems nice.
> instead I can submit a patch to mark the snps,reset-gpio properties in
> the dt-bindings deprecated (and refer to the generic bindings instead)
> what do you think?

Hi Martin

I know Linus wants to replace all users of old GPIO numbers with gpio
descriptors. So your patches have value, even if you don't need them.

One other things to watch out for. We have generic code at two
levels. Either the GPIO is per PHY, and the properties should be in
the PHY node, or the reset is for all PHYs of an MDIO bus, and then
the properties should be in the MDIO node.

    Andrew

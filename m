Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA8D43ABD3
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 22:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730208AbfFIUik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 16:38:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39560 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725933AbfFIUij (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 9 Jun 2019 16:38:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=aAgxuie2Hz2Ygvh1FvKs8sfXSa5TA6FHsD2v2BeNmlU=; b=loFZ3wg+RZyrJP5WO6P8HV8ypt
        gJzwviy22tCzfN56o6PocZ5VpSRqs864Mo6i6I+Uw8bhxw/vrbHap1giCG/rTkFt64tRsLPv8TE/L
        pPNZIwacKiE8RFy8kheg+N5BzbBM0mDbgETBoA9ACUsBkqJgg0bAHswXQXmQ2g7Xzl9k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1ha4aC-0002PI-Ik; Sun, 09 Jun 2019 22:38:28 +0200
Date:   Sun, 9 Jun 2019 22:38:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     netdev@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-amlogic@lists.infradead.org, linus.walleij@linaro.org,
        bgolaszewski@baylibre.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com,
        devicetree@vger.kernel.org, narmstrong@baylibre.com,
        khilman@baylibre.com, linux-kernel@vger.kernel.org,
        davem@davemloft.net, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC next v1 2/5] gpio: of: parse stmmac PHY reset line specific
 active-low property
Message-ID: <20190609203828.GA8247@lunn.ch>
References: <20190609180621.7607-1-martin.blumenstingl@googlemail.com>
 <20190609180621.7607-3-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190609180621.7607-3-martin.blumenstingl@googlemail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 09, 2019 at 08:06:18PM +0200, Martin Blumenstingl wrote:
> The stmmac driver currently ignores the GPIO flags which are passed via
> devicetree because it operates with legacy GPIO numbers instead of GPIO
> descriptors.

Hi Martin

I don't think this is the reason. I think historically stmmac messed
up and ignored the flags. There are a number of device tree blobs
which have the incorrect flag value, but since it was always ignored,
it did not matter. Then came along a board which really did need the
flag, but it was too late, it could not be enabled because too many
boards would break. So the hack was made, and snps,reset-active-low
was added.

Since snps,reset-active-low is a hack, it should not be in the
core. Please don't add it to gpiolib-of.c, keep it within stmmac
driver.

	Andrew

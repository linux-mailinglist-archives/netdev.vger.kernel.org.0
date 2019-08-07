Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADD2D852CB
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 20:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389231AbfHGSPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 14:15:46 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41822 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388612AbfHGSPq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Aug 2019 14:15:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8Qba0xb6CNPFUNLkgGQKGkFWoIe0CEd3T5TzJ9TtU5w=; b=Ljfs6FU6l0i8nZ1hYQhOmvpw4E
        btOB3Cq2t0t4yqYcBFnRNuVNpuHhC6c6tWk/rVpnc1OG2Tnj5TCFD83GDnACV+dKaKn04SkhvCJPv
        QoF+Grk3oupl3fjRtyAaNSnjLC880fl/WBacg+4FdT2XAbA0/L66yuOx6t64ESVh3T/Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hvQTI-0006pq-Vi; Wed, 07 Aug 2019 20:15:36 +0200
Date:   Wed, 7 Aug 2019 20:15:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Matthias Kaehlcke <mka@chromium.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>
Subject: Re: [PATCH v5 2/4] net: phy: Add support for generic LED
 configuration through the DT
Message-ID: <20190807181536.GA26047@lunn.ch>
References: <20190807170449.205378-1-mka@chromium.org>
 <20190807170449.205378-3-mka@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807170449.205378-3-mka@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	for_each_child_of_node(np, child) {
> +		u32 led;
> +
> +		if (of_property_read_u32(child, "reg", &led))
> +			goto skip_config;


> +
> +	skip_config:
> +		of_node_put(child);

There is no need for this put. So long as you don't break out of
for_each_child_of_node() with a return, it will correctly release
child at the end of each loop. A continue statement is also O.K.

      Andrew

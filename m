Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53F943F5323
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 00:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233013AbhHWWCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 18:02:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37566 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232898AbhHWWCr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 18:02:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=MlJCiy5HfG8+LBY7t6BSnHFgiD/Uog0xgn9jINZ9n+o=; b=VqdGDrznCoCR6TPSXUwHHwEEVY
        uMe9AAcYiwlTkroL3Z45iSRs7PxAV4SZLMTbDtr1qS7B6+pFb0qGCqRD9Z1encObrMAhnqtjdIdoc
        ScHoyZsUoYpZttDRNIoE54L/nRModIfTGDepl+q0EJidAHKAiIiGYlTF8jnj6gfA3Aew=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mII0y-003WP2-D8; Tue, 24 Aug 2021 00:01:56 +0200
Date:   Tue, 24 Aug 2021 00:01:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>, netdev@vger.kernel.org,
        kernel-team@android.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Neil Armstrong <narmstrong@baylibre.com>,
        linux-amlogic@lists.infradead.org
Subject: Re: [PATCH v2] of: property: fw_devlink: Add support for
 "phy-handle" property
Message-ID: <YSQa1K2J4RG7xgWN@lunn.ch>
References: <CGME20210823120849eucas1p11d3919886444358472be3edd1c662755@eucas1p1.samsung.com>
 <20210818021717.3268255-1-saravanak@google.com>
 <0a2c4106-7f48-2bb5-048e-8c001a7c3fda@samsung.com>
 <CAGETcx_xJCqOWtwZ9Ee2+0sPGNLM5=F=djtbdYENkAYZa0ynqQ@mail.gmail.com>
 <YSP91FfbzUHKiv+L@lunn.ch>
 <CAGETcx8j+bOPL_-qFzHHJkX41Ljzq8HBkbBqtd4E0-2u6a3_Hg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx8j+bOPL_-qFzHHJkX41Ljzq8HBkbBqtd4E0-2u6a3_Hg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 23, 2021 at 01:48:23PM -0700, Saravana Kannan wrote:
> On Mon, Aug 23, 2021 at 12:58 PM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > > PHY seems to be one of those cases where it's okay to have the
> > > compatible property but also okay to not have it.
> >
> > Correct. They are like PCI or USB devices. You can ask it, what are
> > you? There are two registers in standard locations which give you a
> > vendor and product ID. We use that to find the correct driver.
> 
> For all the cases of PHYs that currently don't need any compatible
> string, requiring a compatible string of type "ethernet-phy-standard"
> would have been nice.

How does this help you? You cannot match that against anything?

How do you handle PCI and USB devices? e.g.

arch/arm/boot/dts/imx6qdl-zii-rdu2.dtsi

&pcie {
        pinctrl-names = "default";
        pinctrl-0 = <&pinctrl_pcie>;
        reset-gpio = <&gpio7 12 GPIO_ACTIVE_LOW>;
        status = "okay";

        host@0 {
                reg = <0 0 0 0 0>;

                #address-cells = <3>;
                #size-cells = <2>;

                i210: i210@0 {
                        reg = <0 0 0 0 0>;
                };
        };
};

There is an intel i210 Ethernet control on the PCIe bus. There is no
compatible string, none is needed. This is no different to a PHY.

	   Andrew

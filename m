Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71AC84A7D26
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 02:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348720AbiBCBBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 20:01:46 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:39960 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348704AbiBCBBp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Feb 2022 20:01:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=p/zPqhK7rICYn+fsLs3IXm5cKsznKQy/YMAmPq7nniU=; b=yogmTzkFdURCUDAn/stzjxjV8u
        rCoHcf2lIgFQ+ntjcLO9MOuexhyI04CXHzXVGepe4V8FF9nycQ+3wzb4EIgiiO++ktgpxK7z1H2g0
        yfNWiNW1i2Xz8rP7E/hqJDfcP4ALWws/uF9xoM702YoABiCXZLYI1j8kwZR5WW+Hhog8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nFQV9-0042X4-O4; Thu, 03 Feb 2022 02:01:31 +0100
Date:   Thu, 3 Feb 2022 02:01:31 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     Martin Schiller <ms@dev.tdt.de>, Hauke Mehrtens <hauke@hauke-m.de>,
        martin.blumenstingl@googlemail.com,
        Florian Fainelli <f.fainelli@gmail.com>, hkallweit1@gmail.com,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v3] net: phy: intel-xway: enable integrated led
 functions
Message-ID: <YfspazpWoKuHEwPU@lunn.ch>
References: <20210421055047.22858-1-ms@dev.tdt.de>
 <CAJ+vNU1=4sDmGXEzPwp0SCq4_p0J-odw-GLM=Qyi7zQnVHwQRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ+vNU1=4sDmGXEzPwp0SCq4_p0J-odw-GLM=Qyi7zQnVHwQRA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> As a person responsible for boot firmware through kernel for a set of
> boards I continue to do the following to keep Linux from mucking with
> various PHY configurations:
> - remove PHY reset pins from Linux DT's to keep Linux from hard resetting PHY's
> - disabling PHY drivers
> 
> What are your thoughts about this?

Hi Tim

I don't like the idea that the bootloader is controlling the hardware,
not linux.

There are well defined ways for telling Linux how RGMII delays should
be set, and most PHY drivers do this. Any which don't should be
extended to actually set the delay as configured.

LEDs are trickier. There is a slow on going effort to allow PHY LEDs
to be configured as standard Linux LEDs. That should result in a DT
binding which can be used to configure LEDs from DT.

You probably are going to have more and more issues if you think the
bootloader is controlling the hardware, so you really should stop
trying to do that.

       Andrew

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 140452793FE
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 00:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727324AbgIYWOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 18:14:11 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56110 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726687AbgIYWOK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 18:14:10 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kLvyd-00GDLd-Vn; Sat, 26 Sep 2020 00:14:03 +0200
Date:   Sat, 26 Sep 2020 00:14:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     netdev@vger.kernel.org, linux-amlogic@lists.infradead.org,
        alexandre.torgue@st.com, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk, joabreu@synopsys.com, kuba@kernel.org,
        peppe.cavallaro@st.com, davem@davemloft.net,
        linux-arm-kernel@lists.infradead.org
Subject: Re: RGMII timing calibration (on 12nm Amlogic SoCs) - integration
 into dwmac-meson8b
Message-ID: <20200925221403.GE3856392@lunn.ch>
References: <CAFBinCATt4Hi9rigj52nMf3oygyFbnopZcsakGL=KyWnsjY3JA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFBinCATt4Hi9rigj52nMf3oygyFbnopZcsakGL=KyWnsjY3JA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 25, 2020 at 11:47:18PM +0200, Martin Blumenstingl wrote:
> Hello,
> 
> Amlogic's 12nm SoC generation requires some RGMII timing calibration
> within the Ethernet controller glue registers.
> This calibration is only needed for the RGMII modes, not for the
> (internal) RMII PHY.
> With "incorrect" calibration settings Ethernet speeds up to 100Mbit/s
> will still work fine, but no data is flowing on 1Gbit/s connections
> (similar to when RX or TX delay settings are incorrect).

Hi Martin

Is this trying to detect the correct RGMII interface mode:
        PHY_INTERFACE_MODE_RGMII,
        PHY_INTERFACE_MODE_RGMII_ID,
        PHY_INTERFACE_MODE_RGMII_RXID,
        PHY_INTERFACE_MODE_RGMII_TXID,

In general, we recommend the MAC does not insert any delay, we leave
it up to the PHY. In DT, you then set the correct phy-mode value,
which gets passed to the PHY when the MAC calls the connect function.

Is there any documentation as to what the calibration values mean?  I
would just hard code it to whatever means 0uS delay, and be done. The
only time the MAC needs to add delays is when the PHY is not capable
of doing it, and generally, they all are.

      Andrew

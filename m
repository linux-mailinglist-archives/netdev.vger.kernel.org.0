Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77C3639F662
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 14:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232568AbhFHMXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 08:23:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51480 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232316AbhFHMXR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 08:23:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Q358deKO0MihPyIqvyu38upjUiXQjkj1FqyY/WxW6nI=; b=cMloeQTcBpRPBKzrnmZVTDQgaH
        qWorJTk3VV5bV/smsCzdneITpX/oUu3Lrmf5xWVj+UG4DrIjj/F9Iaw+shEkiSCS7pluGQTlWfjdt
        DVKK4F8l6ywjDuvgY+nThwjkf66cBITrlSi/skyy0Hhkaq/KDFIwGOBeu/f1P2pfW/tw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lqaj9-008KzF-3J; Tue, 08 Jun 2021 14:21:03 +0200
Date:   Tue, 8 Jun 2021 14:21:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Zhou Yanjie <zhouyanjie@wanyeetech.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, dongsheng.qiu@ingenic.com,
        aric.pzqi@ingenic.com, rick.tyliu@ingenic.com,
        sihui.liu@ingenic.com, jun.jiang@ingenic.com,
        sernia.zhou@foxmail.com, paul@crapouillou.net
Subject: Re: [PATCH 2/2] net: stmmac: Add Ingenic SoCs MAC support.
Message-ID: <YL9gr2QQ/YEXNUmP@lunn.ch>
References: <1623086867-119039-1-git-send-email-zhouyanjie@wanyeetech.com>
 <1623086867-119039-3-git-send-email-zhouyanjie@wanyeetech.com>
 <YL6zYgGdqxqL9c0j@lunn.ch>
 <6532a195-65db-afb3-37a2-f68bfed9d908@wanyeetech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6532a195-65db-afb3-37a2-f68bfed9d908@wanyeetech.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +	case PHY_INTERFACE_MODE_RGMII:
> > > +		val = FIELD_PREP(MACPHYC_TX_SEL_MASK, MACPHYC_TX_SEL_DELAY) |
> > > +			  FIELD_PREP(MACPHYC_TX_DELAY_MASK, MACPHYC_TX_DELAY_63_UNIT) |
> > > +			  FIELD_PREP(MACPHYC_RX_SEL_MASK, MACPHYC_RX_SEL_ORIGIN) |
> > > +			  FIELD_PREP(MACPHYC_PHY_INFT_MASK, MACPHYC_PHY_INFT_RGMII);
> > What exactly does MACPHYC_TX_DELAY_63_UNIT mean here? Ideally, the MAC
> > should not be adding any RGMII delays. It should however pass mode
> > through to the PHY, so it can add the delays, if the mode indicates it
> > should, e.g. PHY_INTERFACE_MODE_RGMII_ID. This is also why you should
> > be handling all 4 RGMII modes here, not just one.
> 
> 
> MACPHYC_TX_DELAY_63_UNIT means set MAC TX clk delay to 63 units (similar to the "tx-delay" in dwmac-rk.c). However, the manual does not clearly describe the time span of one unit, after consulting engineer of Ingenic, I learned that the value is recommended to be set to 63.
> I will change it to be similar to the way done in dwmac-rk.c.

Please wrap your text to around 75 characters per line.

I suspect you don't understand RGMII delays. As i said, normally, the
MAC does not add delays, the PHY does. Please take a closer look at
this.

	Andrew

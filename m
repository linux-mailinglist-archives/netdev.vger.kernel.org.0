Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B734950D57B
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 00:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239706AbiDXWEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 18:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234105AbiDXWEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 18:04:22 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC96B42482;
        Sun, 24 Apr 2022 15:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=1uhfKcZ+6BWyxBcenyGt8hZC2w8nrTOjeFtKsnxgUy0=; b=TYE4+wL+QXKlSp17Wikv0KyXHZ
        Qn70ubLFPRDJAeMtovP97e10wosR4s9CTGdpCxzqzRc/wx9c5gOZ/1gwguUBGPOLWl2hFfawrU+U0
        9vQCEnnK71mumG96EQk/s8M1TwwNY39oh98GaobVmtn5OVsOxGOQ+PIKJsPyrYDduPno=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nikHz-00HJOS-Ep; Mon, 25 Apr 2022 00:01:07 +0200
Date:   Mon, 25 Apr 2022 00:01:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marcel Ziswiler <marcel.ziswiler@toradex.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux-imx@nxp.com" <linux-imx@nxp.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "festevam@gmail.com" <festevam@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: Re: net: stmmac: dwmac-imx: half duplex crash
Message-ID: <YmXIo6q8vVkL6zLp@lunn.ch>
References: <36ba455aad3e57c0c1f75cce4ee0f3da69e139a1.camel@toradex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36ba455aad3e57c0c1f75cce4ee0f3da69e139a1.camel@toradex.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 23, 2022 at 10:58:07PM +0000, Marcel Ziswiler wrote:
> Hi there
> 
> We lately tried operating the IMX8MPEVK ENET_QOS imx-dwmac driver in half-duplex modes which crashes as
> follows:

How many transmit queues do you have in operation:

       /* Half-Duplex can only work with single queue */
        if (priv->plat->tx_queues_to_use > 1)
                priv->phylink_config.mac_capabilities &=
                        ~(MAC_10HD | MAC_100HD | MAC_1000HD);

What does ethtool show before you force it? Does it actually list the
HALF modes?

     Andrew

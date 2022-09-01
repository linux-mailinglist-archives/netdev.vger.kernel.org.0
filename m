Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F30705A965F
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 14:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233273AbiIAMIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 08:08:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232065AbiIAMIw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 08:08:52 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E40E4EA338;
        Thu,  1 Sep 2022 05:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=LaFtjcKE2V/P1S6QroWS+3k5zrDKN1D6ktj5C2pZ8Ek=; b=U6GQYqOERXA3BfsLz0EQzJErri
        lMNRyeaGK8SIJHmNPrIyRs+84fwcuZNoDn5kha7nFPApyY4FU1OcVBnb/CHF6vOBkKyqXQQjyB9ZS
        HpUPy2KGpcnKvC+bejy0wSRfHMqDxCs8cRhSa26mOJWKxkRBpnzyYijxnIyvvgWW4DK0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oTizf-00FIgL-Q0; Thu, 01 Sep 2022 14:08:23 +0200
Date:   Thu, 1 Sep 2022 14:08:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Anand Moon <anand@edgeble.ai>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Sugar Zhang <sugar.zhang@rock-chips.com>,
        David Wu <david.wu@rock-chips.com>,
        Jagan Teki <jagan@edgeble.ai>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net: ethernet: stmicro: stmmac: dwmac-rk: Add rv1126
 support
Message-ID: <YxCgtyqZ6+D5MBY5@lunn.ch>
References: <20220829065044.1736-1-anand@edgeble.ai>
 <20220829065044.1736-2-anand@edgeble.ai>
 <Ywy6o2d9j4Z7+WYX@lunn.ch>
 <CACF1qnfmzcq55GvsD=GQ+ciLRstZ-7ef1EDaBzKMqBzU0O+WRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACF1qnfmzcq55GvsD=GQ+ciLRstZ-7ef1EDaBzKMqBzU0O+WRw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > On Mon, Aug 29, 2022 at 06:50:42AM +0000, Anand Moon wrote:
> > > Rockchip RV1126 has GMAC 10/100/1000M ethernet controller
> > > via RGMII and RMII interfaces are configured via M0 and M1 pinmux.
> > >
> > > This patch adds rv1126 support by adding delay lines of M0 and M1
> > > simultaneously.
> >
> > What does 'delay lines' mean with respect to RGMII?
> >
> > The RGMII signals need a 2ns delay between the clock and the data
> > lines. There are three places this can happen:
> >
> > 1) In the PHY
> > 2) Extra long lines on the PCB
> > 3) In the MAC
> >
> > Generally, 1) is used, and controlled via phy-mode. A value of
> > PHY_INTERFACE_MODE_RGMII_ID passed to the PHY driver means it will add
> > these delays.
> >
> > You don't want both the MAC and the PHY adding delays.
> >
> These are set to enable MAC transmit clock delay set for Tx and Rx for
> iomux group.

Which does not answer my question. Is this the same as, or different
to, the 2ns delay required by RGMII?

    Andrew

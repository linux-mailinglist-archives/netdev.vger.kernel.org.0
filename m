Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 613F76BEFC0
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 18:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbjCQReg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 13:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjCQRef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 13:34:35 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E101751FA6
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 10:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=dcnDEPhnIALH7baeRcHtAIJ4mkDdFCeRzeKfND18+ng=; b=sb
        jo6Js9MMCadEM1hTd96lZaYeoXZ441yzMf1bIctQ90QuLcUlud1xnuT1faDw1XwkuJ0XN/kdc1WuO
        tJymoTVN0l/7ZJblaoY8ttP/50YiokT/3ARuUOEuMqPutrzLWzvyh9N503ZE041a4LaSNnGEXrAan
        9UBzNMtCUmgEOR8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pdDy1-007dXW-BO; Fri, 17 Mar 2023 18:34:13 +0100
Date:   Fri, 17 Mar 2023 18:34:13 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Shenwei Wang <shenwei.wang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, imx@lists.linux.dev
Subject: Re: [PATCH 1/1] net: stmmac: start PHY early in __stmmac_open
Message-ID: <f348ece4-90ef-4368-893a-73de37410fd2@lunn.ch>
References: <20230316205449.1659395-1-shenwei.wang@nxp.com>
 <ZBOQecR6q5Xgr75F@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZBOQecR6q5Xgr75F@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> NAK. A patch similar to this has already been sent.
> 
> The problem with just moving this is that phylink can call the
> mac_link_up() method *before* phylink_start() has returned - and as
> this driver has not completed the setup, it doesn't expect the link
> to come up at that point.
> 
> There are several issues with this driver wanting the PHY clock early,
> and there have been two people working on addressing this previously,
> proposing two different changes to phylink.
> 
> I sent them away to talk to each other and come back with a unified
> solution. Shock horror, they never came back.
> 
> Now we seem to be starting again from the beginning.
> 
> stmmac folk really need to get a handle on this so reviewers are not
> having to NAK similar patches time and time again, resulting in the
> problem not being solved.

And just adding to that, Developers should also get into the habit of
searching to see if somebody has already tried and failed to solve the
problem.

“Those Who Do Not Learn History Are Doomed To Repeat It.”

Try avoiding wasting everybody's times by learning a bit of history.

    Andrew

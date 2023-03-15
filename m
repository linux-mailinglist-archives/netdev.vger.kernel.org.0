Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2BA6BB50C
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 14:46:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232656AbjCONqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 09:46:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232655AbjCONqP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 09:46:15 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2F6772B28;
        Wed, 15 Mar 2023 06:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Ultoh+izloFNi3nqswAf85U56f1iSt1KCWgkHSrwPjU=; b=vK4sJzzT1qySmwWg9jWsqknRBW
        VhfZ7o8tP2obRj2KBJAZ74lgPZMBOdhLuJAyhbYq8n56kJwNSg4Xgh4HXFuiZlbH1J4zodWOP/8iw
        8QTfZxhWW0pyURukxMmdwXyOIJ9rtnCXu8SOQWqVI6MJRN0dWMhN8FLdRTEE9IrXkfR4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pcRRo-007Ouz-Ny; Wed, 15 Mar 2023 14:45:44 +0100
Date:   Wed, 15 Mar 2023 14:45:44 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 1/2] net: dsa: realtek: fix out-of-bounds access
Message-ID: <5c11a9b5-80f9-4b59-938b-4061d0756aba@lunn.ch>
References: <20230315130917.3633491-1-a.fatoum@pengutronix.de>
 <2f0cb0a4-5611-4c61-9165-30cf1b1ef543@lunn.ch>
 <4ad22818-6304-f00d-fa58-ad8b5de10495@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ad22818-6304-f00d-fa58-ad8b5de10495@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 02:35:34PM +0100, Ahmad Fatoum wrote:
> Hello Andrew,
> 
> On 15.03.23 14:30, Andrew Lunn wrote:
> > On Wed, Mar 15, 2023 at 02:09:15PM +0100, Ahmad Fatoum wrote:
> >> The probe function sets priv->chip_data to (void *)priv + sizeof(*priv)
> >> with the expectation that priv has enough trailing space.
> >>
> >> However, only realtek-smi actually allocated this chip_data space.
> >> Do likewise in realtek-mdio to fix out-of-bounds accesses.
> > 
> > Hi Ahmad
> > 
> > It is normal to include a patch 0/X which gives the big picture, what
> > does this patch set do as a whole.
> > 
> > Please try to remember this for the next set you post.
> 
> Ok, will do next time. I didn't include one this time, because there's
> no big picture here; Just two fixes for the same driver.

Fine. You could just say that. Patch 0/X is then used as the merge
commit messages.

       Andrew

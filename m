Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA333573F2C
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 23:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237071AbiGMVws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 17:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236680AbiGMVwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 17:52:47 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E37E31217;
        Wed, 13 Jul 2022 14:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=G2ZOPGS1s/jNjHUZohK4oD7bAWGFIaLsK1fmshVdrLA=; b=lCP1Z88lpIqV+na/2FY7KizYUu
        VEHdfudO26jYIrXf4IXcQT8Sbr9+Cswaq2oI1t01M5EQaC0ZJfSueHkRqj3dpTl740wRNmtPhN9e1
        0/cDBxx1abEqG2Foug2G3wg+W2sV0xnmXMv6WqmwH1K81AjEKasejuPNoLuqELc4J4PU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oBkHh-00ADyR-AM; Wed, 13 Jul 2022 23:52:41 +0200
Date:   Wed, 13 Jul 2022 23:52:41 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, yevhen.orlov@plvision.eu,
        taras.chornyi@plvision.eu
Subject: Re: [PATCH V2 net-next] net: marvell: prestera: add phylink support
Message-ID: <Ys8+qT6ED4dty+3i@lunn.ch>
References: <20220713172013.29531-1-oleksandr.mazur@plvision.eu>
 <Ys8lgQGBsvWAtXDZ@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ys8lgQGBsvWAtXDZ@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 13, 2022 at 09:05:21PM +0100, Russell King (Oracle) wrote:
> On Wed, Jul 13, 2022 at 08:20:13PM +0300, Oleksandr Mazur wrote:
> > For SFP port prestera driver will use kernel
> > phylink infrastucture to configure port mode based on
> > the module that has beed inserted
> > 
> > Co-developed-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
> > Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
> > Co-developed-by: Taras Chornyi <taras.chornyi@plvision.eu>
> > Signed-off-by: Taras Chornyi <taras.chornyi@plvision.eu>
> > Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> > 
> > PATCH V2:
> >   - fix mistreat of bitfield values as if they were bools.
> >   - remove phylink_config ifdefs.
> >   - remove obsolete phylink pcs / mac callbacks;
> >   - rework mac (/pcs) config to not look for speed / duplex
> >     parameters while link is not yet set up.
> >   - remove unused functions.
> >   - add phylink select cfg to prestera Kconfig.
> 
> I would appreciate answers to my questions, rather than just another
> patch submission. So I'll repeat my question in the hope of an answer:
> 
> First question which applies to everything in this patch is - why make
> phylink conditional for this driver?

Hi Oleksandr

I agree with Russell here. This driver should depend on PHYLINK and
remove all the #ifdefs. We try to avoid this sort of code, it hides
bugs and does not get compile tested very well etc.

You need to give us a good reason if you want to keep the code like this.

    Andrew

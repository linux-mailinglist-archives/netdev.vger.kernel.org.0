Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F21756DDB14
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 14:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbjDKMnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 08:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbjDKMnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 08:43:09 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2171C1FD0;
        Tue, 11 Apr 2023 05:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=e5rSoQ2ltFwZvI3y01OSJh2LqqItWeYuiKUGftoUB4c=; b=DvrLrdAAspxFfhLaC1zpUQQl24
        +iRwXE14M9wXA2OCWvBZSLOYyh4aSQSPzsLqhTObLIKeRbx6k5DC5wWdzEbdzLemNRRYW8XScniBP
        LVNt0FYmzA2qJgL6SpCgBRJSTQ6v0j+V9ZwIgxAx6n3/jhNp/ZKf85rjoZTH2dQFluoA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pmDL0-009zLj-5H; Tue, 11 Apr 2023 14:43:06 +0200
Date:   Tue, 11 Apr 2023 14:43:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>, netdev@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
        mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next v2 6/6] net: txgbe: Support phylink MAC layer
Message-ID: <d810223e-1b56-450b-997a-d0cdf0d3974a@lunn.ch>
References: <20230411092725.104992-1-jiawenwu@trustnetic.com>
 <20230411092725.104992-7-jiawenwu@trustnetic.com>
 <ZDU6EtWVL5JqqerL@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDU6EtWVL5JqqerL@shell.armlinux.org.uk>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > @@ -204,7 +205,7 @@ static int txgbe_request_irq(struct wx *wx)
> >  
> >  static void txgbe_up_complete(struct wx *wx)
> >  {
> > -	u32 reg;
> > +	struct txgbe *txgbe = (struct txgbe *)wx->priv;
> 
> Personal choice I guess, but normally we tend to rely on compilers
> accepting the implicit cast from void * to whatever struct pointer
> in the kernel.

Davem used to strongly push back against a cast when the pointer was a
void *. Please remove the cast.

     Andrew

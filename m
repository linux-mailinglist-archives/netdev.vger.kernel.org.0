Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD41B5BD730
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 00:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbiISWWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 18:22:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiISWWl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 18:22:41 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 534DD113D
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 15:22:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=9v4glxiwuweoBM14KzbWIk+SqCeni9ZX05A4a0qVMMA=; b=LYlz+J0z8yI3+phBd6mkUq0fd5
        2PQaTYRnnWvVsN2eQK4eqtF5MDaUgbWcePeXc3Mu5i+VzUSSL1tOcnqu9JhMB/8E8Ew5LDYK5wB73
        FryxUV9qmsf4K/Yt5tRw5keoWd04PbQ3ZbL+PNx5+PJyDee7lQbOLNAB9H36S9lcQ2cQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oaP9x-00HBWM-De; Tue, 20 Sep 2022 00:22:37 +0200
Date:   Tue, 20 Sep 2022 00:22:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Mattias Forsblad <mattias.forsblad@gmail.com>,
        netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux@armlinux.org.uk,
        ansuelsmth@gmail.com
Subject: Re: [PATCH net-next v14 2/7] net: dsa: Add convenience functions for
 frame handling
Message-ID: <YyjrrbSjhJjaQ/bK@lunn.ch>
References: <20220919110847.744712-1-mattias.forsblad@gmail.com>
 <20220919110847.744712-3-mattias.forsblad@gmail.com>
 <20220919221445.a7gypaggf2wmnf5i@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220919221445.a7gypaggf2wmnf5i@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +
> > +	return wait_for_completion_timeout(com, msecs_to_jiffies(timeout));
> 
> If this is going to be provided as a DSA common layer "helper" function,
> at least make an effort to document the expected return code.
> 
> Hint, wait_for_completion_timeout() returns an unsigned long time_left,
> you return an int. What does it mean?!
> 
> At the bare minimum, leave a comment, especially when it's not obvious
> (DSA typically uses negative integer values as error codes, and zero on
> success. Here, zero is an error - timeout. If the amount of time left
> does not matter, do translate this into 0 for success, and -ETIMEDOUT
> for timeout). If you're also feeling generous, do please also update
> Documentation/networking/dsa/dsa.rst with the info about the flow of
> Ethernet-based register access that you wish was available while you
> were figuring out how things worked.

Hi Vladimir

I just posted an alternative to this patch. One of the patches
addresses this point. I convert the return value to the more normal
-ve for error, 0 for success, including -ETIMEOUT if the completion
times out.

My patchset is however missing documentation. Once we get the basic
API agreed on, i can extend Documentation/networking/dsa/dsa.rst.

       Andrew

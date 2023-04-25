Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1CE6EEA29
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 00:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbjDYWBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 18:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232003AbjDYWBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 18:01:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F75AA7
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 15:01:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE48662FF8
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 22:01:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE330C433EF;
        Tue, 25 Apr 2023 22:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682460072;
        bh=l0Zpbnqe1RRbJ72PnlWCBmP2XYR0o1BmKtk3lY2cNWk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=td0/oucEbjV2MfDPmOjq2RZAD11z6N2eDFpUyW2h6qxgNkb15pZILT3MIB5m+hUjr
         1+19VfpH0QMXcQlY9QV4IhIXGRSvJNDoq0yt0RMEUHWiSCBZeCDECF0fB1DslfJY5+
         j8LfxLolgdNufag5x6DNvriZCS/cZWMhSjPkPH3WD4myUdu4DZeeoIM9rBLIGs8ed+
         qz9G8Q7L8Fz8V7QkMKaahWJLEt7282jUYBC762cf3ZmcuKp86+2i5b2d3a6FKKGKri
         oKYwO5K8BWsjErFnH88AVISaUznANsQM46NcA/e4qd05/byZfIieJnC9QOI7qI0/p3
         rhyIT2gVo44lA==
Date:   Tue, 25 Apr 2023 15:01:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Arnd Bergmann" <arnd@arndb.de>
Cc:     "Andrew Lunn" <andrew@lunn.ch>, "Paolo Abeni" <pabeni@redhat.com>,
        Netdev <netdev@vger.kernel.org>,
        "Heiner Kallweit" <hkallweit1@gmail.com>,
        "Russell King" <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>
Subject: Re: [PATCH net-next] net: phy: drop PHYLIB_LEDS knob
Message-ID: <20230425150111.1b17b17b@kernel.org>
In-Reply-To: <e1e1022a-da6e-4267-bca9-18cd76e0d218@app.fastmail.com>
References: <c783f6b8d8cc08100b13ce50a1330913dd95dbce.1682457539.git.pabeni@redhat.com>
        <ce81b985-ebcf-46f7-b773-50e42d2d10e7@lunn.ch>
        <e1e1022a-da6e-4267-bca9-18cd76e0d218@app.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Apr 2023 22:44:34 +0100 Arnd Bergmann wrote:
> On Tue, Apr 25, 2023, at 22:38, Andrew Lunn wrote:
> >>  
> >> -config PHYLIB_LEDS
> >> -	bool "Support probing LEDs from device tree"  
> >
> > I don't know Kconfig to well, but i think you just need to remove the
> > text, just keep the bool.
> >
> > -       bool "Support probing LEDs from device tree"
> > +       bool  
> 
> Right, that should work, or it can become
> 
>         def_bool y
> 
> or even
> 
>         def_bool OF
> 
> for brevity.

Hm, I think Paolo was concerned that we'd get PHYLIB_LEDS=y if PHYLIB=n
and LEDS_CLASS=n. But that's not possible because the option is in the
"if PHYLIB" section.

Is that right?

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86A59614E98
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 16:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbiKAPta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 11:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiKAPt3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 11:49:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EFAF13E9B;
        Tue,  1 Nov 2022 08:49:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19FFB61585;
        Tue,  1 Nov 2022 15:49:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5398C433C1;
        Tue,  1 Nov 2022 15:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667317767;
        bh=DfUrWwktIzT3nEPqxzqndsQ774MPvZ61GZ6Ia/dmz0g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mTqr5cpjVIBbghNfV8kxdo+cAH20M1mnx1D3hRpQjc2dUKNVjyJh2x5gLuoU6srzA
         6TkehApgi8hjBByjFZvXpRAYnV/37M6wWJQaZbbMLaXMhbJWGasY35VYr0NhyGcK2O
         gGS8665B9MnIx9y5Z/j+qHHgjyGcmYB+twbQ7hvwyl01a7oVfAJlnYVhNyc9Znr89y
         deGrbWCtmxW1dtQzkBhJxuQzUDf6UUWFG7oCEjUmBEqHWNoeCRD41nFRh+/fAett3l
         LnQNSC6qNkdzlJ7DrAFWsIJehCiuxifnV4/eBrsvlQVTW7Nr8tL7Fg5ekGfwXqos/r
         +PtsRTaXpOG5g==
Date:   Tue, 1 Nov 2022 08:49:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     Casper Andersson <casper.casan@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        <UNGLinuxDriver@microchip.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "Wan Jiabing" <wanjiabing@vivo.com>,
        Nathan Huckleberry <nhuck@google.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Daniel Machon <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Subject: Re: [PATCH net-next v2 2/5] net: microchip: sparx5: Adding more tc
 flower keys for the IS2 VCAP
Message-ID: <20221101084925.7d8b7641@kernel.org>
In-Reply-To: <741b628857168a6844b6c2e0482beb7df9b56520.camel@microchip.com>
References: <20221028144540.3344995-1-steen.hegelund@microchip.com>
        <20221028144540.3344995-3-steen.hegelund@microchip.com>
        <20221031103747.uk76tudphqdo6uto@wse-c0155>
        <51622bfd3fe718139cece38493946c2860ebdf77.camel@microchip.com>
        <20221031184128.1143d51e@kernel.org>
        <741b628857168a6844b6c2e0482beb7df9b56520.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Nov 2022 08:31:16 +0100 Steen Hegelund wrote:
> > Previous series in this context means previous revision or something
> > that was already merged?  
> 
> Casper refers to this series (the first of the VCAP related series) that was merged on Oct 24th:
> 
> https://lore.kernel.org/all/20221020130904.1215072-1-steen.hegelund@microchip.com/

Alright, looks like this is only in net-next so no risk of breaking
existing users.
 
That said you should reject filters you can't support with an extack
message set. Also see below.

> > > tc filter add dev eth3 ingress chain 8000000 prio 10 handle 10 \  
> > 
> > How are you using chains?  
> 
> The chain ids are referring to the VCAP instances and their lookups.  There are some more details
> about this in the series I referred to above.
> 
> The short version is that this allows you to select where in the frame processing flow your rule
> will be inserted (using ingress or egress and the chain id).
> 
> > I thought you need to offload FLOW_ACTION_GOTO to get to a chain,
> > and I get no hits on this driver.  
> 
> I have not yet added the goto action, but one use of that is to chain a filter from one VCAP
> instance/lookup to another.
> 
> The goto action will be added in a soon-to-come series.  I just wanted to avoid a series getting too
> large, but on the other hand each of them should provide functionality that you can use in practice.

The behavior of the offload must be the same as the SW implementation.
It sounds like in your case it very much isn't, as adding rules to 
a magic chain in SW, without the goto will result in the rules being
unused.

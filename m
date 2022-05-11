Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DBF9523DC3
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 21:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240682AbiEKTmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 15:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345289AbiEKTmu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 15:42:50 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 879615AA62
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 12:42:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EBCACCE26FF
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 19:42:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4AFEC340EE;
        Wed, 11 May 2022 19:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652298165;
        bh=XXsU/zm28X0Lp6DlBJ8IVyPjazz1Eq8rOS6aUySBxrQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZZ7H9o8sEWbKM58sETLclwPJAEZBMKsx99MjzZ5Ari53fpvidtOG9GkHtUvuFbdzi
         jIwL3TTlz9sLGIfycnvOeCyLJ8IS8Di6MWUVfOEcchZmJxuUfQtJMXshymiikojTy4
         iiWteplx1k0yD3dAQjugmeLa5Ya2FgXGUSoj7qPoHkwaRzAnFkNFkjl3ahBfKE85Nu
         t9w/mTFu3oUJu4bcqv3hXtEnOLeM5Pw1pVpHO/ocbJscmQjCeVRMgwup5rpZSp9Dos
         2QNJCIa8oBBg56xgxh08ZoaDqOYgpgWm/0C7Iahxt9+dO/OME8CMKByBuBppvuEnmJ
         7+PaVQ2rAXTng==
Date:   Wed, 11 May 2022 12:42:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Walle <michael@walle.cc>
Cc:     alexandru.ardelean@analog.com, alvaro.karsz@solid-run.com,
        davem@davemloft.net, edumazet@google.com, josua@solid-run.com,
        krzysztof.kozlowski+dt@linaro.org, michael.hennerich@analog.com,
        netdev@vger.kernel.org, pabeni@redhat.com, robh+dt@kernel.org
Subject: Re: [PATCH v4 1/3] dt-bindings: net: adin: document phy clock
Message-ID: <20220511124241.7880ef52@kernel.org>
In-Reply-To: <c457047dd2af8fc0db69d815db981d61@walle.cc>
References: <20220510133928.6a0710dd@kernel.org>
        <20220511125855.3708961-1-michael@walle.cc>
        <20220511091136.34dade9b@kernel.org>
        <c457047dd2af8fc0db69d815db981d61@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 May 2022 19:10:36 +0200 Michael Walle wrote:
> Am 2022-05-11 18:11, schrieb Jakub Kicinski:
> > On Wed, 11 May 2022 14:58:55 +0200 Michael Walle wrote:  
> >> FWIW, the recovered clock only works if there is a link. AFAIR on the
> >> AR8031 you can have the free-running one enabled even if there is no
> >> link, which might sometimes be useful.  
> > 
> > Is that true for all PHYs? I've seen "larger" devices mention holdover
> > or some other form of automatic fallback in the DPLL if input clock is
> > lost.  
> 
> I certainly can't speak of 'all' PHYs, who can ;) But how is the
> switchover for example? hitless? will there be a brief period of
> no clock at all?
> 
> The point I wanted to add is that the user should have the choice or
> at least you should clearly mention that. If you drop the suffix and 
> just
> use "25mhz" is that now the recovered one or the free-running one. And
> why is that one preferred over the other? Eg. if I were a designer for a
> cheapo board and I'd need a 125MHz clock and want to save some bucks
> for the 125MHz osc and the PHY could supply one, I'd use the
> free-running mode. Just to avoid any surprises with a switchover
> or whatever.

It's pure speculation on my side. I don't even know if PHYs use 
the recovered clock to clock its output towards the MAC or that's 
a different clock domain.

My concern is that people will start to use DT to configure SyncE which
is entirely a runtime-controllable thing, and doesn't belong. Hence
my preference to hide the recovered vs free-running detail if we can
pick one that makes most sense for now.

Again, if you feel strongly that the current design is indeed needed 
to configure pure SOC<>PHY / MAC<>PHY clocking, just send a review tag
and I'll apply :)

> > I thought that's the case here, too:
> 
> I read "reference" as being the 25MHz (maybe when the PHY is in 10Mbit
> mode? I didn't read the datasheet) because the first mode is called
> 25mhz-reference. So it might be switching between 25MHz and 125MHz?
> I don't know.

I couldn't grok that from the datasheet. Anyway, it'd be good to make
it clearer that the second sentence refers to the "adaptive" mode and
not the behavior of the recovered clock when lock is lost. Just put
(adaptive) in the sentence somewhere.

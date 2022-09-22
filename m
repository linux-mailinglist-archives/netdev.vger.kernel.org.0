Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF5E55E57BE
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 03:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbiIVBGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 21:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiIVBGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 21:06:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D50883DA;
        Wed, 21 Sep 2022 18:06:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FE5763331;
        Thu, 22 Sep 2022 01:06:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5789C433C1;
        Thu, 22 Sep 2022 01:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663808802;
        bh=Lqql20nTSnQlo3UFTHU7a3vI+xkva1fKFe3nZS5Lp4g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gPiukSsEugg8Lc4O5ByTkiYnYX0Qhdwg7dw2bwdf6wdRfIFOqi/yU0eOyW/JUi0a3
         Rm7fIuhXfrXOeyjiUhOAq4Dk96KHtuLw7UHp5OM8AYzINZHpe6ZKXcfbtUkt2rIzRd
         yzt4u2mu8MFg9bfEP2+9whv+iZWOaTS6+gZJGUlTL+kTP9c43PXH9KfzT6OqihKX2+
         eQvAn4kJ2dCFOA2owCeuA9Y5yFcib6qF0Zsrigp9j8hM5OWZr1rbGlwujpaNdcHGYV
         XH0AQeB7yPL+WQgyjHcKwO+ginr0XknOn+U+LAkG+zdTfbfVK8c4BO/zejrb14f839
         QW5LEfavE2SaA==
Date:   Wed, 21 Sep 2022 18:06:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     "kishon@ti.com" <kishon@ti.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux-phy@lists.infradead.org" <linux-phy@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: Re: [PATCH v2 0/8] treewide: Add R-Car S4-8 Ethernet Switch support
Message-ID: <20220921180640.696efb1a@kernel.org>
In-Reply-To: <TYBPR01MB534186B5BA8E5936C46E3B6DD84E9@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20220921084745.3355107-1-yoshihiro.shimoda.uh@renesas.com>
        <20220921074004.43a933fe@kernel.org>
        <TYBPR01MB534186B5BA8E5936C46E3B6DD84E9@TYBPR01MB5341.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Sep 2022 00:46:34 +0000 Yoshihiro Shimoda wrote:
> I thought we have 2 types about the use of the treewide:
> 1) Completely depends on multiple subsystems and/or
>    change multiple subsystems in a patch.
> 2) Convenient for review.
> 
> This patch series type is the 2) above. However, should I use
> treewide for the 1) only?

I thought "treewide" means you're changing something across the tree.
If you want to get a new platform reviewed I'd just post the patches
as RFC without any prefix in the subject. But I could be wrong.

My main point (which I did a pretty poor job of actually making)
was that for the networking driver to be merged it needs to get
posted separately.

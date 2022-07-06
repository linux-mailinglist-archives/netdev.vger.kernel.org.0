Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98A47569026
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 18:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232789AbiGFQ6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 12:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233758AbiGFQ6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 12:58:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A3B2A728;
        Wed,  6 Jul 2022 09:57:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA35261DAD;
        Wed,  6 Jul 2022 16:57:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 555C8C3411C;
        Wed,  6 Jul 2022 16:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657126630;
        bh=GF/aKIAzhOdpyO5Xdb1pXVqwDvZ44YUeDjQ86DdLEVU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B7UfPWR6H7wHVWrVGgUXtsz5mVegP0uqNRm7Rl0GaG6lSk3/XF0bJ1dRDz910/nrw
         ArJlrBbcmQVUkXNEozaNrykOgZ0XjbILwzH8Eig5ZPcPfEFKMTk1JzxGSdij9yq67/
         xOtgyfqkH+q2ZHp2h9BXhpi1JfDk6uKgD51fVcSVBFpqrBwKzY7rLXfVsxlhUhgZM9
         CMDchWma018hV0+3hZpxLL5P198TNxnQukwCj8zo74rOMxLjpft0GWboEFVGfNRYBH
         dVp5s+/IxNrMQyMbS6/mLBlKrb3ESTrf8ZNrF6Lyz4CJD9yebEDJ5ftpznp9zNLEc9
         NUsajuj6c/aKA==
Date:   Wed, 6 Jul 2022 22:27:05 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-phy@lists.infradead.org
Subject: Re: [PATCH net-next v2 04/35] [RFC] phy: fsl: Add Lynx 10G SerDes
 driver
Message-ID: <YsW+4fm/613ByK09@matsya>
References: <20220628221404.1444200-1-sean.anderson@seco.com>
 <20220628221404.1444200-5-sean.anderson@seco.com>
 <YsPWMYjyu2nyk+w8@matsya>
 <431a014a-3a8f-fdc7-319e-29df52832128@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <431a014a-3a8f-fdc7-319e-29df52832128@seco.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05-07-22, 11:29, Sean Anderson wrote:

> >> +	/* TODO: wait for the PLL to lock */
> > 
> > when will this be added?
> 
> I'm not sure. I haven't had any issues with this, and waiting on the lock bit is
> only mentioned in some datasheets for this SerDes. On the LS1046A for example,
> there is no mention of waiting for lock.

okay maybe remove the comment then?

> >> +static const struct clk_ops lynx_pll_clk_ops = {
> >> +	.enable = lynx_pll_enable,
> >> +	.disable = lynx_pll_disable,
> >> +	.is_enabled = lynx_pll_is_enabled,
> >> +	.recalc_rate = lynx_pll_recalc_rate,
> >> +	.round_rate = lynx_pll_round_rate,
> >> +	.set_rate = lynx_pll_set_rate,
> >> +};
> > 
> > right, this should be a clk driver
> 
> Well, it is a clock driver, effectively internal to the SerDes. There are a few
> examples of this already (e.g. the qualcomm and cadence phys). It could of course
> be split off, but I would prefer that they remained together.

I would prefer clk driver is split and we maintain clean split b/w phy
and clk

-- 
~Vinod

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20E2360C270
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 06:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiJYEA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 00:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiJYEAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 00:00:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B00384504D;
        Mon, 24 Oct 2022 21:00:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAD2061725;
        Tue, 25 Oct 2022 04:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81CFBC433D7;
        Tue, 25 Oct 2022 04:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666670421;
        bh=3TINTyanXuh5N7qudvfxQz6WRFTsujLwEF2pzywIiiE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=P+KnXybmZVUF8gekFdWhYtiDldRQa2c58xCgS3Ba/n5uiZdtsuWFZ+YgTBOfCxIHh
         2JmNbKMTzQwkP8wWeXWN2Os2mG4mnBgJ/9yKp58256KL8zWaqwPMtdEdg+ArHDKycg
         02kzSCX5iq2Y4S4E3QzNG7VeZ3438EHSHLKAVtGBxw4wmKzSVRuj17oS7aN+z19Y1z
         +ImrrVUaFfuvbjHy2V8HvOYinRuzKFsSkySjPDDzVwHxyFMXzwzVfdn0W2UwUYgWRG
         dTP7g6yEgrQosSJxkBhpHnNRj89zSHufDIwjY3zdGheve31DXS+GteBnYkIAMaW8zX
         kUU5UgHNUKAbw==
Date:   Mon, 24 Oct 2022 21:00:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Junxiao Chang <junxiao.chang@intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        Joao.Pinto@synopsys.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: stmmac: fix unsafe MTL DMA macro
Message-ID: <20221024210019.551e64ae@kernel.org>
In-Reply-To: <20221021114711.1610797-1-junxiao.chang@intel.com>
References: <20221021114711.1610797-1-junxiao.chang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Oct 2022 19:47:10 +0800 Junxiao Chang wrote:
> Macro like "#define abc(x) (x, x)" is unsafe which might introduce
> side effects. Each MTL RxQ DMA channel mask is 4 bits, so using
> (0xf << chan) instead of GENMASK(x + 3, x) to avoid unsafe macro.
> 
> Fixes: d43042f4da3e ("net: stmmac: mapping mtl rx to dma channel")

You need to point out an existing usage where this is causing problems,
otherwise this is not a fix.

And squash the two patches together, it's going to be easier to review.

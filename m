Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36E8F6BDCC7
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 00:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbjCPXSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 19:18:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbjCPXSQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 19:18:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28B4F7A9C;
        Thu, 16 Mar 2023 16:18:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C11626215C;
        Thu, 16 Mar 2023 23:18:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE9C1C433D2;
        Thu, 16 Mar 2023 23:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679008694;
        bh=OYxBo4djlS61XYzgafFcijG0gwXMYYjumjcr57f8sII=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rWb1M0TbcYdWvys6U7qm+pWzcbxM7BHmg+3uLg8AfqIyld4olOVBoV7jkl+r81Jqj
         f+RYlS2hnjRsQhaxz9CTN25s8fDp/fsMetItOKM8tj+8I64oI3bgs+2g/8CpvLHz+V
         i2QtxX2WI2LbSernJmYN7v8czmwcu+VELH30cD2EWMDSt/cjjLxP45bEUVDsqO/mDC
         pW7SpbAbEmFGp9EuTGd4JfmBm1fU7ZDOWfsyPg6pBOfMYFUwqgP4vtvlG7jrH97Xej
         IlUUblIFivZyHGgsbp2ciNDZtBzbljRkS8veHt81beTxQIGhLQQ5NZykN4zVwtay8L
         rvOAS06RYJB+Q==
Date:   Thu, 16 Mar 2023 16:18:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Halaney <ahalaney@redhat.com>, linux-kernel@vger.kernel.org,
        agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        vkoul@kernel.org, bhupesh.sharma@linaro.org,
        mturquette@baylibre.com, sboyd@kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, richardcochran@gmail.com,
        veekhee@apple.com, tee.min.tan@linux.intel.com,
        mohammad.athari.ismail@intel.com, jonathanh@nvidia.com,
        ruppala@nvidia.com, bmasney@redhat.com,
        andrey.konovalov@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-clk@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, ncai@quicinc.com,
        jsuraj@qti.qualcomm.com, hisunil@quicinc.com
Subject: Re: [PATCH net-next 08/11] net: stmmac: Add EMAC3 variant of dwmac4
Message-ID: <20230316161811.64d14cb3@kernel.org>
In-Reply-To: <ZBOfuSBifFO7O/xQ@shell.armlinux.org.uk>
References: <20230313165620.128463-1-ahalaney@redhat.com>
        <20230313165620.128463-9-ahalaney@redhat.com>
        <20230313173904.3d611e83@kernel.org>
        <20230316183609.a3ymuku2cmhpyrpc@halaney-x13s>
        <20230316115234.393bca5d@kernel.org>
        <ZBOfuSBifFO7O/xQ@shell.armlinux.org.uk>
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

On Thu, 16 Mar 2023 23:01:13 +0000 Russell King (Oracle) wrote:
> What I would say is be careful with that - make sure "struct bla" is
> specific to the interface being called and not generic.
> 
> I had that mistake with struct phylink_state... and there is an
> endless stream of people who don't seem to bother reading the
> documentation, who blindly access whatever members of that they
> damn well please because it suits them, even when either they
> shouldn't be writing to them, or when phylink doesn't guarantee
> their contents, they read them.

Right, gotta take it case by case. I really like structs for
const capabilities of the driver / device, which need to be
communicated to the core.

> As a result, I'm now of the opinion that using a struct to pass
> arguments is in principle a bad idea.
> 
> There's other reasons why it's a bad idea. Many ABIs are capable of
> passing arguments to functions via processor registers. As soon as
> one uses a struct, they typically end up being written to memory.
> Not only does that potentially cause cache line churn, it also
> means that there could be more slow memory accesses that have to be
> made at some point, potentially making other accesses slow.
> 
> So, all in all, I'm really not a fan of the struct approach for
> all the reasons above.

Also true, one has to be careful on the fast paths. There are cases
where similar set of arguments is passed multiple functions down.
Making the code hard to follow and extend. But you're right, structs
will be slower for the most part.

For stmmac I figured it can only help. The driver is touched my very
many people, it has layers and confusions...

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B25A4BC55B
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 05:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234421AbiBSEdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 23:33:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232527AbiBSEdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 23:33:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4AAA50E3B
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 20:33:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 710BA60018
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 04:33:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 548C4C340EC;
        Sat, 19 Feb 2022 04:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645245209;
        bh=Rs4cMPN9TM4IX/vQWrInXDPL6gf4BDqIhlJMXPdzig4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tnRqV7FW16sCEwlmc039O5/sVLO6OtKxIdSxWPMTw9C1VWTL6uZw+6/6rf8C3Rr+R
         Kdi6t/WHyF0xICWUasHPw+4wn1PhMz0c3HRijAgWVN9Zusq3OfRqmMufrw10Bfi7pQ
         AwtM9aeciKHbL7Xn3q3raVYV24cdJwbcG033m23dXuVuo6Ggp4YBZQL8mtY5ZcYYaG
         w+2LzSl5KFbB6CO42N2TtWP+aDVB3QGerlA50BiqyHUzyXrnOXYnpub6CZYYoeAqiM
         hqt2LNCWhTBTDLVPs61sQ8JmSgbTDf4YVImbv8qtqo3k02kmmO97sZHcwXP3snNfdx
         g5Um/TFMgvZRg==
Date:   Fri, 18 Feb 2022 20:33:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>, kernel@axis.com,
        Lars Persson <larper@axis.com>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] net: stmmac: Enable NAPI before interrupts go live
Message-ID: <20220218203328.20318a68@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220218104504.62sfwbc4yoaceqdw@pengutronix.de>
References: <20220217145527.2696444-1-vincent.whitchurch@axis.com>
        <20220217203604.39e318d0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20220218104504.62sfwbc4yoaceqdw@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Feb 2022 11:45:04 +0100 Marc Kleine-Budde wrote:
> >  - request irq
> >  - mask irq  
> 
> I think you can merge these, to avoid a race condition, see:
> 
> | cbe16f35bee6 genirq: Add IRQF_NO_AUTOEN for request_irq/nmi()

GTK, finally someone implemented it! :)

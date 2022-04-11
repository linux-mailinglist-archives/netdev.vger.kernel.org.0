Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5AA4FC6C6
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 23:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233040AbiDKVff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 17:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231789AbiDKVfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 17:35:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 781CEB7EE
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 14:33:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E993B818C4
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 21:33:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B0A9C385A3;
        Mon, 11 Apr 2022 21:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649712796;
        bh=lEYz4+ERIjZyTTLkGjkRDmNUp6uVkmGZIVZ/FkmwMEY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tzEuM2scRaNRnLZH5XnCszne4cBhexTFKyC5R7hBuDspiTe93+tYKUZ3z1M8VyS9e
         +J9k/o/42dRN1VlNRBkim1RNfl6/ERLFNjXWuGmpQe0esBXL/p//WRfJMvu1yywK8h
         LSlf+QzQSLuhF7nP1bIYoAHw9fcusn6sQJl2TYK7EGb+nZ3pg1N/EXp00WjpVIEWOR
         WVx65ablWaAl7SN3QZMvQ2NSO+LSwRs3Q0p5mvYXdTT+WcRnOmGeKRuCQXIdGir8da
         gaLEzbOSpCoIxM93jeY3ybR2d1s0O2/LXnFxFhfN8a5wdtXB5HoOXaeLUNYs4b7Sqw
         0RLTrawyeTidA==
Date:   Mon, 11 Apr 2022 14:33:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Josua Mayer <josua@solid-run.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        netdev@vger.kernel.org, alvaro.karsz@solid-run.com,
        Michael Hennerich <michael.hennerich@analog.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: Re: [PATCH 1/3] dt: adin: document clk-out property
Message-ID: <20220411143315.6cd5484e@kernel.org>
In-Reply-To: <YlSWz+XELKV3LK8s@lunn.ch>
References: <20220410104626.11517-1-josua@solid-run.com>
        <20220410104626.11517-2-josua@solid-run.com>
        <d83be897-55ee-25d2-4048-586646cd7151@linaro.org>
        <bc0e507b-338b-8a86-1a7b-8055e2cf9a3a@solid-run.com>
        <e0511d39-7915-3ce1-60c7-9d7739f1b253@linaro.org>
        <b519690c-a487-e64c-86e1-bd37e38dc7a7@solid-run.com>
        <20220411130715.516fc5cc@kernel.org>
        <YlSWz+XELKV3LK8s@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Apr 2022 22:59:59 +0200 Andrew Lunn wrote:
> > Noob question - can you explain how this property describes HW?
> > I thought we had a framework for clock config, and did not require
> > vendor specific properties of this sort.
> > 
> > The recovered vs free running makes the entire thing sound like
> > a SyncE related knob, irrelevant to normal HW operation.  
> 
> It is not necessarily SyncE. Fast Ethernet is based around a 25MHz
> clock. Something needs to provide that clock. Sometimes the SoC/MAC
> provides it, and passes it to the PHY. Sometimes the PHY provides it,
> and passes it to the SoC/MAC.
> 
> There are a couple of PHYs which make use of the common clock
> framework, when the SoC is the clock source. However, i don't think
> there are any PHYs which provide a clock to the common clock framework
> when they are the source. We do however have a number of vendor
> properties to control the PHY clock output, disable the PHY clock
> output, select the PHY clock output, etc. There is not too much
> standardisation here, and it is made worse by some PHYs needing a
> reset once the clock is ticking, some MACs stop the clock when the
> link is administrative down, some PHYs stop the clock a short time
> after the link goes down which can be bad for the MAC etc.

I see. Why would the MAC/SoC care if the clock is recovered or free
running, tho?

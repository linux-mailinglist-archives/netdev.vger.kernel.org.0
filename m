Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED0DD6CCFDE
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 04:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjC2CRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 22:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjC2CRT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 22:17:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BB08271C;
        Tue, 28 Mar 2023 19:17:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5DC3619C4;
        Wed, 29 Mar 2023 02:17:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 235D6C433EF;
        Wed, 29 Mar 2023 02:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680056238;
        bh=HFOVDJOz0rbImC9oGs5gHJAEVLKuq6QbRug+jFmJR5Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BLYaPxU7FwPY+yezNxX8b+04N3VOjJX1R4VH9FfD2FmrXIPxaWF9GXMx+bR+wGUgq
         FcTP3nGb5mD360od7UXDV+CsJdl0B/z0xYOLo8t2AueXz9/bvW4nWy0aH19dWvWJCv
         rngogYAcmgzwCYs3tXrQ/7lJbby6V072F9ly974jhtWzPaAH+94fgAxhMlQNzXni+e
         /KEc+cgXRrTQnH1mZHNT6HaMDJniM5DwMpw5vejG1mjqLxvp9nMQ9/2q1O7+Q9guV1
         b7UFbDATJ3YUpZXvh825j2ta0uxs/YMWBNYGBQmv/GtI1SDseD25/1pmvmLmfazqzb
         9zyosH8AZMpHg==
Date:   Tue, 28 Mar 2023 19:17:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Samin Guo <samin.guo@starfivetech.com>
Cc:     <linux-kernel@vger.kernel.org>, <linux-riscv@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Jose Abreu <joabreu@synopsys.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Conor Dooley <conor@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>,
        Tommaso Merciai <tomm.merciai@gmail.com>
Subject: Re: [net-next v9 5/6] net: stmmac: Add glue layer for StarFive
 JH7110 SoC
Message-ID: <20230328191716.18a302a1@kernel.org>
In-Reply-To: <20230328062009.25454-6-samin.guo@starfivetech.com>
References: <20230328062009.25454-1-samin.guo@starfivetech.com>
        <20230328062009.25454-6-samin.guo@starfivetech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Mar 2023 14:20:08 +0800 Samin Guo wrote:
> This adds StarFive dwmac driver support on the StarFive JH7110 SoC.
> 
> Tested-by: Tommaso Merciai <tomm.merciai@gmail.com>
> Co-developed-by: Emil Renner Berthing <kernel@esmil.dk>
> Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
> Signed-off-by: Samin Guo <samin.guo@starfivetech.com>

Excellent, now it applies cleanly :)

Our clang build with W=1 complains that:

drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c:37:2: warning: variable 'rate' is used uninitialized whenever switch default is taken [-Wsometimes-uninitialized]
        default:
        ^~~~~~~
drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c:42:36: note: uninitialized use occurs here
        err = clk_set_rate(dwmac->clk_tx, rate);
                                          ^~~~
drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c:24:20: note: initialize the variable 'rate' to silence this warning
        unsigned long rate;
                          ^
                           = 0


not sure how you prefer to fix this. Maybe return early?

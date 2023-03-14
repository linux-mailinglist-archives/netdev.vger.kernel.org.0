Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFDEF6B874C
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 01:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbjCNA6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 20:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjCNA6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 20:58:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F9C85290D;
        Mon, 13 Mar 2023 17:58:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BEB05B81185;
        Tue, 14 Mar 2023 00:58:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11FE4C433D2;
        Tue, 14 Mar 2023 00:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678755497;
        bh=ISTNUtSnHwm0emzir3zxzTqaw3LgECpTiMZ3wrsTEaE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hjiCuJH90/WUOhNJ5tLvPiCHlp8Q4nV1kQbNMrZLEvBgpp2QJyCoB/aszMbx1+PXP
         t71hLh/julqDuLOp+8bn2tBetegL7nU0yesl2mTs8AhqOASTFOaX/Q/JvM6IzId13a
         nfOw2jt14Jwzq1gRrSugwQuZHdOb3qT0oH1CzwQGhefu7E8y5prCe4eID24wJAW+4s
         2ZAtvwZ35kzbZ6xN5ZPZqbFBUq2qKf4JJPrym4ZrD1Am/laWPHu1CpoVvM8vck6u3x
         7eqhvbAtW2kS7AE0zP3UHhbQgiAuT8pr982szyxgeXFtf7F/Wld63hl5n5kKGtd69s
         9czjhjIBjg0Ow==
Date:   Tue, 14 Mar 2023 08:58:08 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Andrew Halaney <ahalaney@redhat.com>
Cc:     devicetree@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        s.hauer@pengutronix.de, kernel@pengutronix.de, festevam@gmail.com,
        linux-imx@nxp.com, alexandre.torgue@foss.st.com,
        peppe.cavallaro@st.com, joabreu@synopsys.com, mripard@kernel.org,
        shenwei.wang@nxp.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 2/2] arm64: dts: imx8dxl-evk: Fix eqos phy reset gpio
Message-ID: <20230314005808.GV143566@dragon>
References: <20230214171505.224602-1-ahalaney@redhat.com>
 <20230214171505.224602-2-ahalaney@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230214171505.224602-2-ahalaney@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 14, 2023 at 11:15:05AM -0600, Andrew Halaney wrote:
> The deprecated property is named snps,reset-gpio, but this devicetree
> used snps,reset-gpios instead which results in the reset not being used
> and the following make dtbs_check error:
> 
>     ./arch/arm64/boot/dts/freescale/imx8dxl-evk.dtb: ethernet@5b050000: 'snps,reset-gpio' is a dependency of 'snps,reset-delays-us'
>         From schema: ./Documentation/devicetree/bindings/net/snps,dwmac.yaml
> 
> Use the preferred method of defining the reset gpio in the phy node
> itself. Note that this drops the 10 us pre-delay, but prior this wasn't
> used at all and a pre-delay doesn't make much sense in this context so
> it should be fine.
> 
> Fixes: 8dd495d12374 ("arm64: dts: freescale: add support for i.MX8DXL EVK board")
> Signed-off-by: Andrew Halaney <ahalaney@redhat.com>

Applied, thanks!

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1F5765E9EB
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 12:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233234AbjAELa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 06:30:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233231AbjAELaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 06:30:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58FF812A80;
        Thu,  5 Jan 2023 03:30:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ADC8AB81AB1;
        Thu,  5 Jan 2023 11:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5C753C433F0;
        Thu,  5 Jan 2023 11:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672918217;
        bh=b1cMDTIygvvXUMrshTqkW1iYTGx7cseBKBFJN+D6sAY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ce+gtpUBlw9twyhd2rK/zhUXyThZIUlSwFrqk1yPj9acoJDfrM1fOEf4/HZTdx928
         nnyNJ+cJCatamDUDz4DQflAFEgLyMHp3Yk1zy79QL0Ckq83IeCIfVDMBTyQ2nedJuA
         z3yxRIn05duTxEjehR9xJSzIpRGzXBXz3/S5FButN8N6H5o96xKkIJl5MNWXQCYJ1K
         yqbVj0XqEkpLLX4WYJO3LM8mHTUm8mQQxdxrwDddV7aj01EnqYy5W49BQrcrMENFtS
         hbViUJm7W5759+S8guBhk4KdCwORdkDD+dKBucHnWs+CXJ8C+sUMsXSyek4pcg/+4m
         OaEU+biccJnNA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3C6A6E5724E;
        Thu,  5 Jan 2023 11:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v6 0/3] Add support for QSGMII mode for J721e CPSW9G
 to am65-cpsw driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167291821724.17194.2169796185615843957.git-patchwork-notify@kernel.org>
Date:   Thu, 05 Jan 2023 11:30:17 +0000
References: <20230104103432.1126403-1-s-vadapalli@ti.com>
In-Reply-To: <20230104103432.1126403-1-s-vadapalli@ti.com>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski@linaro.org, krzysztof.kozlowski+dt@linaro.org,
        linux@armlinux.org.uk, vladimir.oltean@nxp.com, vigneshr@ti.com,
        nsekhar@ti.com, netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        srk@ti.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 4 Jan 2023 16:04:29 +0530 you wrote:
> Add compatible to am65-cpsw driver for J721e CPSW9G, which contains 8
> external ports and 1 internal host port.
> 
> Add support to power on and power off the SERDES PHY which is used by the
> CPSW MAC.
> 
> =========
> Changelog
> =========
> v5 -> v6:
> 1. Add member "serdes_phy" in struct "am65_cpsw_slave_data" to store the
>    SERDES PHY for each port, if present. This is done to cache the SERDES
>    PHY beforehand, without depending on devm_of_phy_get().
> 2. Rebase series on net-next tree.
> 
> [...]

Here is the summary with links:
  - [net-next,v6,1/3] dt-bindings: net: ti: k3-am654-cpsw-nuss: Add J721e CPSW9G support
    https://git.kernel.org/netdev/net-next/c/c85b53e32c8e
  - [net-next,v6,2/3] net: ethernet: ti: am65-cpsw: Enable QSGMII mode for J721e CPSW9G
    https://git.kernel.org/netdev/net-next/c/944131fa65d7
  - [net-next,v6,3/3] net: ethernet: ti: am65-cpsw: Add support for SERDES configuration
    https://git.kernel.org/netdev/net-next/c/dab2b265dd23

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



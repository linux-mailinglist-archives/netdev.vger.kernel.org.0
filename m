Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DAED5280B2
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 11:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234637AbiEPJUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 05:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235024AbiEPJUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 05:20:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 756BF25EAC;
        Mon, 16 May 2022 02:20:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9CB08B80F62;
        Mon, 16 May 2022 09:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 40979C34100;
        Mon, 16 May 2022 09:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652692818;
        bh=wRK3W4kkTL91oUEb7BaY00QOBPsJRzSa8p8mNImhh+8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Gl+KBgvDdwmZN09ENrMC9KrP//i0Q1iM9NiqGDKgJWmlaNXAZlO+MaAWnjlKpTi4F
         00qmAa6jDo/M/SguVgt4xI6Oce6mKD8pJxL5IpFkxGMRW2ruRrtCXmFS6HdSQIa3gt
         Rtr5HBOQ7okYWmUjC8tScguwUY14+ZYgQTf3sW055C5OhE32Zesv8sFJgBD1Fi90kZ
         ZrBzfJwpimRh97RasKdBheSGmHWiCTnQyD8fWkkLEC8WyefzJTdfOudHxwjKWpZyEj
         xbk1M4EoCt2Rp1eUaJoKFZKbSKWoZKJP1Jz2jQ2sYWWQyOM7LdNuNUJ+vwtHchg1R7
         a7bso+S699GDw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 18280F03935;
        Mon, 16 May 2022 09:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 0/5] Add Renesas RZ/V2M Ethernet support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165269281808.1627.2981856718769988919.git-patchwork-notify@kernel.org>
Date:   Mon, 16 May 2022 09:20:18 +0000
References: <20220512114722.35965-1-phil.edworthy@renesas.com>
In-Reply-To: <20220512114722.35965-1-phil.edworthy@renesas.com>
To:     Phil Edworthy <Phil.Edworthy@renesas.com>
Cc:     mturquette@baylibre.com, sboyd@kernel.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        phil.edworthy@renesas.com, geert+renesas@glider.be,
        s.shtylyov@omp.ru, sergei.shtylyov@gmail.com,
        biju.das.jz@bp.renesas.com,
        prabhakar.mahadev-lad.rj@bp.renesas.com,
        Chris.Paterson2@renesas.com, magnus.damm@gmail.com,
        linux-clk@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 12 May 2022 12:47:17 +0100 you wrote:
> The RZ/V2M Ethernet is very similar to R-Car Gen3 Ethernet-AVB, though
> some small parts are the same as R-Car Gen2.
> Other differences are:
> * It has separate data (DI), error (Line 1) and management (Line 2) irqs
>   rather than one irq for all three.
> * Instead of using the High-speed peripheral bus clock for gPTP, it has
>   a separate gPTP reference clock.
> 
> [...]

Here is the summary with links:
  - [v4,1/5] dt-bindings: net: renesas,etheravb: Document RZ/V2M SoC
    https://git.kernel.org/netdev/net-next/c/a7931ac16128
  - [v4,2/5] ravb: Separate handling of irq enable/disable regs into feature
    https://git.kernel.org/netdev/net-next/c/cb99badde146
  - [v4,3/5] ravb: Support separate Line0 (Desc), Line1 (Err) and Line2 (Mgmt) irqs
    https://git.kernel.org/netdev/net-next/c/b0265dcba3d6
  - [v4,4/5] ravb: Use separate clock for gPTP
    https://git.kernel.org/netdev/net-next/c/72069a7b2821
  - [v4,5/5] ravb: Add support for RZ/V2M
    https://git.kernel.org/netdev/net-next/c/e1154be73153

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



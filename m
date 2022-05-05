Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFA1B51B4E4
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 02:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233530AbiEEBBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 21:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232501AbiEEBBi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 21:01:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F0422287;
        Wed,  4 May 2022 17:58:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D13D61D72;
        Thu,  5 May 2022 00:58:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE9C6C385A5;
        Thu,  5 May 2022 00:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651712279;
        bh=PNhBXOPnVpmHDlq1hrRy+qlY1DmxGj2kaPbLINje80Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TFohAHCcDsAtmbs/giK1b2ijhjJCSMJntoZo+KtAppYdiz/Bm0wjs5jCrtQ1qAO9W
         BtaI2njyCFM4lfmUgoiwv0RV33+yIqIJAbPWEoFxl+4GQUtLDpGM4ZZ8k5l/8Uy9Bh
         aBONPgsNwYzzxNqG0bDVOptOhfD6hJxDPECbLPYaWo//8x8DwTil8BuXM3F1Hehd24
         XjdQ+cRpqM/oA00fQPKSpwhQSIMKcaBIaPXSfIZ4xKOSwUNUWADPh9YJelGPn+qYlF
         nNEBJYz4q1X9GL5ZqBamT6ptYCJuCgpm+DXyJH9AGW/xuPaRAOdc5VggboYxzElMRO
         EHR91wOM11s2g==
Date:   Wed, 4 May 2022 17:57:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Phil Edworthy <phil.edworthy@renesas.com>
Cc:     Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-clk@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 0/9] Add Renesas RZ/V2M Ethernet support
Message-ID: <20220504175757.0a3c1a6a@kernel.org>
In-Reply-To: <20220504145454.71287-1-phil.edworthy@renesas.com>
References: <20220504145454.71287-1-phil.edworthy@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  4 May 2022 15:54:45 +0100 Phil Edworthy wrote:
> The RZ/V2M Ethernet is very similar to R-Car Gen3 Ethernet-AVB, though
> some small parts are the same as R-Car Gen2.
> Other differences are:
> * It has separate data (DI), error (Line 1) and management (Line 2) irqs
>   rather than one irq for all three.
> * Instead of using the High-speed peripheral bus clock for gPTP, it has
>   a separate gPTP reference clock.
> 
> The dts patches depend on v4 of the following patch set:
> "Add new Renesas RZ/V2M SoC and Renesas RZ/V2M EVK support"
> 
> Phil Edworthy (9):
>   clk: renesas: r9a09g011: Add eth clock and reset entries
>   dt-bindings: net: renesas,etheravb: Document RZ/V2M SoC
>   ravb: Separate use of GIC reg for PTME from multi_irqs
>   ravb: Separate handling of irq enable/disable regs into feature
>   ravb: Support separate Line0 (Desc), Line1 (Err) and Line2 (Mgmt) irqs
>   ravb: Use separate clock for gPTP
>   ravb: Add support for RZ/V2M
>   arm64: dts: renesas: r9a09g011: Add ethernet nodes
>   arm64: dts: renesas: rzv2m evk: Enable ethernet

How are you expecting this to be merged?

I think you should drop the first (clk) patch from this series 
so we can apply the series to net-next. And route the clk patch 
thru Geert's tree separately? 

Right now patchwork thinks the series is incomplete because it 
hasn't received patch 1.

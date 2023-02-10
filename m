Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA45D6918C6
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 07:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbjBJGyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 01:54:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbjBJGys (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 01:54:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF3BD20064;
        Thu,  9 Feb 2023 22:54:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A70DB823F3;
        Fri, 10 Feb 2023 06:54:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E85EFC433EF;
        Fri, 10 Feb 2023 06:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676012085;
        bh=09gUWptY/BbuIMzWbqSjyJe1S02IFSMhcohNYddSSgE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HSjTpTzHZoFbipoV+LpZdBskzS/ag4uT/3oIszVu/2F4J6ovVwdhbhvM7ZWZcNhnf
         71p5YVrmag22+n4US6k+AKoVfrFd6m4VNYkD+/UZEcDlbW/t6ACJCnJgEOUf3V7qiL
         pO4yHMrftBz3KSgbYVmnn+hWKl0L62j73X05vtBsf3v7+6EV1NvXwMPHtHi85Y2jrN
         ru/O3Bf5vplzMRPzY3tz4wtPhm88zw1uAF7cy8eb2gt6R1/fO7Mjt65UpbT2oAzse6
         N+cGe9UED6Nnz89BlkwjfHIpW5oWivWZSNoTYh60vdl2OVleV/wLWkbaGd/umoeUhE
         2Vny6amTJCmSg==
Date:   Thu, 9 Feb 2023 22:54:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alain Volmat <avolmat@me.com>
Cc:     Jonathan Corbet <corbet@lwn.net>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com, linux-pm@vger.kernel.org,
        linux-clk@vger.kernel.org
Subject: Re: [PATCH 07/11] net: ethernet: stmmac: dwmac-sti: remove
 stih415/stih416/stid127
Message-ID: <20230209225442.2b11878e@kernel.org>
In-Reply-To: <20230209091659.1409-8-avolmat@me.com>
References: <20230209091659.1409-1-avolmat@me.com>
        <20230209091659.1409-8-avolmat@me.com>
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

On Thu,  9 Feb 2023 10:16:55 +0100 Alain Volmat wrote:
> Remove no more supported platforms (stih415/stih416 and stid127)
> 
> Signed-off-by: Alain Volmat <avolmat@me.com>

No idea who's gonna take these, but FWIW:

Acked-by: Jakub Kicinski <kuba@kernel.org>

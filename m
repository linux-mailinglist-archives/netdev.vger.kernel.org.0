Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E575E69251B
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 19:13:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232807AbjBJSN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 13:13:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231970AbjBJSNY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 13:13:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 180433A0AC;
        Fri, 10 Feb 2023 10:13:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5E2D61E7A;
        Fri, 10 Feb 2023 18:13:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E21C433EF;
        Fri, 10 Feb 2023 18:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676052803;
        bh=6FLDH++aUj095WH9otN0bkobiJlSDQziX4LlJjA4wS4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OBeovfgBitTlBAxZHZpmc5RTctjYTaEPJRtQRt9AvYMQm79B2inSL2GCVqGCNRThH
         uv6ZV5NIrYKBg1+2+8prF8TmMOpdfezRGuXAkz8fEki6YKNfYEgQsrVy4DcI/tlxqp
         BjPhcwp6vQgLawKj8Ly+E/Ov7p2zGAok4V94flhRydi9R2Egj6Sf6g/jAVQJW0ZVo5
         cJoC2H2enzXbF7VRM7BZfUXTIjCQRtMOzFdO1qG+m5YKLLg6dWRjl1YKw05SSM+Ew4
         JgenQnvyNc+qu3vklc1eq/zqASHpAUXRSN8u5zXM1BZ+wZosIxSXf1FRTcsMOiXuz9
         xuTk5ILD8DMEg==
Date:   Fri, 10 Feb 2023 10:13:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alain Volmat <avolmat@me.com>
Cc:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Rob Herring <robh+dt@kernel.org>,
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
Subject: Re: [PATCH 00/11] ARM: removal of STiH415/STiH416 remainings bits
Message-ID: <20230210101320.331c1d95@kernel.org>
In-Reply-To: <Y+YKeVoq91/mtlo2@imac101>
References: <20230209091659.1409-1-avolmat@me.com>
        <20230210090420.GB175687@linaro.org>
        <Y+YKeVoq91/mtlo2@imac101>
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

On Fri, 10 Feb 2023 10:12:25 +0100 Alain Volmat wrote:
> Having seen situations like that for some other series I was guessing
> that each maintainer would apply the relevant patches on his side.
> Those two platforms being no more used, there is no specific patch
> ordering to keep.
> 
> I've actually been wondering at the beginning how should I post those
> patches.  If another way is preferrable I can post again differently
> if that helps.

You'd have most luck getting the changes accepted for 6.3 if you split
this up and resend to individual maintainers.

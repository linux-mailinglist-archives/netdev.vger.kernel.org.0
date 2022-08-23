Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF73D59CE13
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 03:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239268AbiHWBto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 21:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235768AbiHWBtn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 21:49:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AE135A3CF;
        Mon, 22 Aug 2022 18:49:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C73D61210;
        Tue, 23 Aug 2022 01:49:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F95C433C1;
        Tue, 23 Aug 2022 01:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661219381;
        bh=4jo3/HTAIGPj7v3Ycu0rq1evDYi72QmZ2J3Kd6UV6eA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DVqz2MU9B5DlJWKEnxslB1nbRCVmd1jG9FFJFoDvPaQS03j/8KRcNTfp7h1LYZedl
         c8DHj+Fu7SzGDzjrtyhIsZsUzmhKWcXWA8kM7wEJH2K1Q+Bpew6gHY8iwpGNLakvjz
         kAypy/G1InJtYQ2rC8+0qCKKYfKf0Lth3aaUuMI73j6i2NJvftU5ZDWJqZAzdykncs
         I12W3R7qSTDDmB/qLL/QzvxVDKH12QBmQGHwPtVOT6z1tZZue+bUC5+WoLkauKxUNl
         9YHJO38Kgf2M3EhuHlF2sDRTuQ8YJmYjdq6P3S9ISf+DrPt7kZUi/95TYKRS5+qfZI
         TI0scv9eXWOOg==
Date:   Mon, 22 Aug 2022 18:49:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 00/17] net: dsa: microchip: add error
 handling and register access validation
Message-ID: <20220822184940.125e7246@kernel.org>
In-Reply-To: <20220822110358.2310055-1-o.rempel@pengutronix.de>
References: <20220822110358.2310055-1-o.rempel@pengutronix.de>
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

On Mon, 22 Aug 2022 13:03:41 +0200 Oleksij Rempel wrote:
> changes v2:
> - add regmap_ranges for KSZ9477
> - drop output clock devicetree in driver validation patches. DTs need
>   some more refactoring and can be done in a separate patch set.
> - remove some unused variables.
> 
> This patch series adds error handling for the PHY read/write path and optional
> register access validation.
> After adding regmap_ranges for KSZ8563 some bugs was detected, so
> critical bug fixes are sorted before ragmap_range patch.
> 
> Potentially this bug fixes can be ported to stable kernels, but need to be
> reworked.

This does not build in a fairly obvious way between patches 2 and 11 :(

Please make sure you do some form of a

  git rebase --exec='make W=1 O=build_allmodconfig/'

where build_allmodconfig is a dir configured with make allmodconfig.
*Especially* when posting a large series.

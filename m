Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8746EA17A
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 04:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233436AbjDUCJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 22:09:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231660AbjDUCJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 22:09:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 906142722;
        Thu, 20 Apr 2023 19:09:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B73564CFC;
        Fri, 21 Apr 2023 02:09:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0365FC433EF;
        Fri, 21 Apr 2023 02:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682042947;
        bh=BwdBwfjbVB9EPWiZveM6m+4QA1UmPP83yiLco/1D4sk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tWgnziutyzEFA7cypLheDuFNAzJgv49Sc6B0UPqHItFVK/WYExbU4sPJC4x6SG17U
         XMnuaUJ1GBVYxN+mQtgtXDhO3Xxm5GIZvJTrnjzqjyckoH8AcjyiHaMnLjcnyltBoc
         MB4arMVtoM19dfTG6gvXP148lbq9R+qkXpWbNYndKArksGaFhtCuYYB4mGowTbunsA
         ghZ8gJxyAFh4ZXxTRO1LY9XYGcq0CS6Rjqf38paIKInlSE0fkLna1bBV+2Ec2GsJHV
         TESAW3Kq41p5YzRGu8SvdVUyuc30XGKdC5jCTvheYiHCSRurlB+7oayayiZ2FOSq7F
         0o5vYmpU5Jfyw==
Date:   Thu, 20 Apr 2023 19:09:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@armlinux.org.uk>,
        Frank Sae <Frank.Sae@motor-comm.com>,
        Randy Dunlap <rdunlap@infradead.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: fix circular LEDS_CLASS dependencies
Message-ID: <20230420190905.47c54ccd@kernel.org>
In-Reply-To: <20230420084624.3005701-1-arnd@kernel.org>
References: <20230420084624.3005701-1-arnd@kernel.org>
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

On Thu, 20 Apr 2023 10:45:51 +0200 Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The CONFIG_PHYLIB symbol is selected by a number of device drivers that
> need PHY support, but it now has a dependency on CONFIG_LEDS_CLASS,
> which may not be enabled, causing build failures.
> 
> Avoid the risk of missing and circular dependencies by guarding the
> phylib LED support itself in another Kconfig symbol that can only be
> enabled if the dependency is met.
> 
> This could be made a hidden symbol and always enabled when both CONFIG_OF
> and CONFIG_LEDS_CLASS are reachable from the phylib, but there may be an
> advantage in having users see this option when they have a misconfigured
> kernel without built-in LED support.

The problem is breaking build for the config I use in testing,
so let me apply without waiting full review period. Thanks!

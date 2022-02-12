Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95F674B3217
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 01:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354452AbiBLAiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 19:38:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354444AbiBLAiV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 19:38:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D603B35
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 16:38:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B62AB61C55
        for <netdev@vger.kernel.org>; Sat, 12 Feb 2022 00:38:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E44E0C340E9;
        Sat, 12 Feb 2022 00:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644626298;
        bh=PbkglsZ5pGHenN7Xz98qpvWgdypqSv0PgSwaprK6RHI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Of7VgPuN1IHnchwRypXWc8IfZ3zPn8Lg439Zf4UFSWnKdnQXshYJz8dPSWZGnqeUz
         7Rj8BBc2h7aXs207DM3t2NfUomC4+V36m5euawDfvdSCbmTTbyd2ZoyzvbpQu+25N2
         o9ZAFuevHrEPocVtd9+jFOEpezj1KFaaOQ66cjrSgvQVHGqvh9uY8XM35CsFutYJss
         TBtRAMAzta4utPGNMQsJpwH9QgTyJFRUwalnGwRRna36tasiu+wwRaPAw8GCsiL+ou
         kn3vm2tIdXt+KRFWIWo1U3gAjKFWFlgPPmIRjW+r3oek46oxjqUo0rmu6daguX0QIT
         P7n9Siv0xzuSw==
Date:   Fri, 11 Feb 2022 16:38:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     linux-arm-kernel@lists.infradead.org,
        Imre Kaloz <kaloz@openwrt.org>,
        Krzysztof Halasa <khalasa@piap.pl>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 09/13 v2] net: ixp4xx_hss: Check features using syscon
Message-ID: <20220211163817.682df7c3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220211223238.648934-10-linus.walleij@linaro.org>
References: <20220211223238.648934-1-linus.walleij@linaro.org>
        <20220211223238.648934-10-linus.walleij@linaro.org>
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

On Fri, 11 Feb 2022 23:32:34 +0100 Linus Walleij wrote:
> If we access the syscon (expansion bus config registers) using the
> syscon regmap instead of relying on direct accessor functions,
> we do not need to call this static code in the machine
> (arch/arm/mach-ixp4xx/common.c) which makes things less dependent
> on custom machine-dependent code.
> 
> Look up the syscon regmap and handle the error: this will make
> deferred probe work with relation to the syscon.
> 
> Select the syscon in Kconfig and depend on OF so we know that
> all we need will be available.
> 
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v1->v2:
> - No changes.
> 
> Network maintainers: I'm looking for an ACK to take this
> change through ARM SoC along with other changes removing
> these accessor functions.

Acked-by: Jakub Kicinski <kuba@kernel.org>

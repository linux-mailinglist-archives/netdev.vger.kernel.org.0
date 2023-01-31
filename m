Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 281BF68357B
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 19:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231550AbjAaSl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 13:41:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbjAaSl1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 13:41:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7217B2365C
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 10:41:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27405B81E60
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 18:41:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B1A7C433EF;
        Tue, 31 Jan 2023 18:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675190483;
        bh=FwFibnCUKACHjfolIwMVhZor8Hgt4WpBeYj6B2UwLWU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QV1gN3UEznmXPfmb6q+RlD/Gyzkt8F11JHEM0Fwo3xqhAx18fElY4GdtQPxxDkJJh
         Pyqi1Vr6xNHuqNBqCPEO5qNZsE4H1oUc3dabN0dk4GYTjHvBx0GSjpcarhxIYdFpPM
         Wr6dnWNbVWVJFKI4HtzreXQhUW77fQjYpsexIahA7juv5y8wTm0zV+5eyiWi1dSU7p
         8M/RISuh+kRhgSKsuloyuywIGbMOHP5t+XQhY6MstFk1SOrFANP4VOQrklRR/QDpqs
         XjmIPQ5b7MH/+Uu/P3RLsq0gJ+tO/70lhtRsnHUKKSdnkSL7rIMbNKS2/Dvo2nGXgv
         ehfoSVJuKYP+w==
Date:   Tue, 31 Jan 2023 10:41:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Michael Walle <michael@walle.cc>, Andrew Lunn <andrew@lunn.ch>,
        Jiri Pirko <jiri@resnulli.us>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Keller Jacob E <jacob.e.keller@intel.com>
Subject: Re: PHY firmware update method
Message-ID: <20230131104122.20c143a2@kernel.org>
In-Reply-To: <Y9lB0MmgyCZxnk3N@shell.armlinux.org.uk>
References: <YzQ96z73MneBIfvZ@lunn.ch>
        <YzVDZ4qrBnANEUpm@nanopsycho>
        <YzWPXcf8kXrd73PC@lunn.ch>
        <20220929071209.77b9d6ce@kernel.org>
        <YzWxV/eqD2UF8GHt@lunn.ch>
        <Yzan3ZgAw3ImHfeK@nanopsycho>
        <Yzbi335GQGbGLL4k@lunn.ch>
        <ced75f7f596a146b58b87dd2d6bad210@walle.cc>
        <Y9BCrtlXXGO5WOKN@lunn.ch>
        <7bd02bf6880a092b64a0c27d3715f5b6@walle.cc>
        <Y9lB0MmgyCZxnk3N@shell.armlinux.org.uk>
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

On Tue, 31 Jan 2023 16:29:04 +0000 Russell King (Oracle) wrote:
> I really don't like the idea of the kernel automatically updating
> non-volatile firmware - that sounds to me like a recipe for all
> sorts of disasters.

FWIW we had a concept of "FW load policy" in devlink but IDK if it
addresses the concern sufficiently. For mlxsw IIRC the load policy
"from disk" means "flash the device if loaded FW is older".

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E38F6B6FB3
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 07:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbjCMG4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 02:56:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjCMG4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 02:56:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC494D621;
        Sun, 12 Mar 2023 23:56:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12792B80E1C;
        Mon, 13 Mar 2023 06:56:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43AD8C433EF;
        Mon, 13 Mar 2023 06:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678690590;
        bh=q5NIoj6sHVjFnHkOzQQT84DcmJS5L1Vnj9AJbL0MMaQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=RMXER/VZvg0jEyWlzyHEYOykQziCMrz5wcD8XSJRP4/4efKf2MdoEVD9sSHxBl6TR
         OKMf5NiomJPpzA1r64rXngINUFZfuavqgU+WxOyewhaRvK+NrcFYszvJqJSMwfADBp
         6vXvjFNN0O9/rmCTBFwCh109XcmxbDBaeOjJRFOjY1lZiqJPyg13YJuye4Muq8bTAq
         7F7yXL5iCl5MiUQ5CvrODKJZVkU4eRGbntCCGjehxq8WSJ+42HNaRoUmILuivlMJ5V
         7HzzAIi8uu0qBB0PNjadWTOSA0ngggRneSwq5QaOwCD3WdhOey/XaSLdDeyUaJzvjU
         8tvWbzq8BbtKg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
Subject: Re: [PATCH] net: Use of_property_present() for testing DT property presence
References: <20230310144716.1544083-1-robh@kernel.org>
Date:   Mon, 13 Mar 2023 08:56:21 +0200
In-Reply-To: <20230310144716.1544083-1-robh@kernel.org> (Rob Herring's message
        of "Fri, 10 Mar 2023 08:47:16 -0600")
Message-ID: <87y1o1nnqi.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rob Herring <robh@kernel.org> writes:

> It is preferred to use typed property access functions (i.e.
> of_property_read_<type> functions) rather than low-level
> of_get_property/of_find_property functions for reading properties. As
> part of this, convert of_get_property/of_find_property calls to the
> recently added of_property_present() helper when we just want to test
> for presence of a property and nothing more.
>
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  drivers/net/mdio/of_mdio.c                            | 4 ++--
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)

For wireless:

Acked-by: Kalle Valo <kvalo@kernel.org>

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D89745AA6CB
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 06:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234953AbiIBEKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 00:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234042AbiIBEK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 00:10:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C77532066;
        Thu,  1 Sep 2022 21:10:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EEA89B829B6;
        Fri,  2 Sep 2022 04:10:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D456C433D7;
        Fri,  2 Sep 2022 04:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662091822;
        bh=DMJ96U1Ye9ZdZJB6gAjWggjLAyw4oFxSjCp3KrydwRI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i5pzFEqb6hLC2scXahDCWsIy9XEk1GzEs/x4JRfxQ4J5533rhHHv7E48Z+gl9l8US
         uoASCnYqengigR9/e0+YnmehFtKEeWvZCe4rmH4C2tDsYp1JE/1Cefy/lCSBQTIUDi
         11ZbGAt2bVtWXkmFpzV7cTcXPl7oqnchutYLKXCtvFjHtA6Zx7W/KZFqdjd2/EZUSb
         IDKDv1uZriy/IsKrMRJqCW1po7Q7Yi9TIT9NkwFSDLfZn9u3XFm7BacJTuGOsZX9xD
         JvGu0JXFmJyI63CoQQXdwjQUwi6rb0qfh07+s4C3yGCYN3ABwu5LOtnqMMbjq8D7oZ
         umJRDitOkGCaw==
Date:   Thu, 1 Sep 2022 21:10:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v3 4/5] net: altera: tse: convert to phylink
Message-ID: <20220901211021.52520588@kernel.org>
In-Reply-To: <20220901143543.416977-5-maxime.chevallier@bootlin.com>
References: <20220901143543.416977-1-maxime.chevallier@bootlin.com>
        <20220901143543.416977-5-maxime.chevallier@bootlin.com>
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

On Thu,  1 Sep 2022 16:35:42 +0200 Maxime Chevallier wrote:
> This commit converts the Altera Triple Speed Ethernet Controller to
> phylink. This controller supports MII, GMII and RGMII with its MAC, and
> SGMII + 1000BaseX through a small embedded PCS.
> 
> The PCS itself has a register set very similar to what is found in a
> typical 802.3 ethernet PHY, but this register set memory-mapped instead
> of lying on an mdio bus.

allmodconfig builds report:

ERROR: modpost: missing MODULE_LICENSE() in drivers/net/pcs/pcs-altera-tse.o

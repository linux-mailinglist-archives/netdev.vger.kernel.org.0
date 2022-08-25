Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C90505A186C
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 20:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243258AbiHYSKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 14:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243250AbiHYSK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 14:10:29 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16FA4A927A;
        Thu, 25 Aug 2022 11:10:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CD716CE292B;
        Thu, 25 Aug 2022 18:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D623C433C1;
        Thu, 25 Aug 2022 18:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661451021;
        bh=Er8V9jNbcvkm1yktE0q1q+gaOywFHNbKENwzjuzsnpk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=c3UkDop3oO43oJhqNyBuSPAFSouev7/BICPgYp4oeVQB4vqSSZ3dTBFcoHV3jR1eg
         02FgisMPYnCaKBwXe2JuSpOLV/FrZsifmSq5LDmChTtAZUsp/BQOKdfdGgclTziAfn
         skf6YPayTB9zEuhxk3tqYH0FpwKxra/psXWasHQUrk5QJ9TMt35wbw38k3jTUe0G/Z
         LVaZKqorz5gAvzX7bm81C1ngf63fn4uGWm1EfZsptc1k5GAFONdPWkN7hoPfBDDRvt
         mEAbxWTNsIfpJY8y1110qJwW1nuFR8rqMT9x/IUgNZjkgigBvkBhjsVWuxQSvksJKD
         8q1z61szHCW5w==
Date:   Thu, 25 Aug 2022 11:10:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        kernel test robot <lkp@intel.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        David Jander <david@protonic.nl>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v2 6/7] ethtool: add interface to interact with
 Ethernet Power Equipment
Message-ID: <20220825111019.1dc3dae0@kernel.org>
In-Reply-To: <20220825130211.3730461-7-o.rempel@pengutronix.de>
References: <20220825130211.3730461-1-o.rempel@pengutronix.de>
        <20220825130211.3730461-7-o.rempel@pengutronix.de>
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

On Thu, 25 Aug 2022 15:02:10 +0200 Oleksij Rempel wrote:
> +enum ethtool_podl_pse_admin_state {
> +	ETHTOOL_PODL_PSE_ADMIN_STATE_UNKNOWN = 1,

Why define UNKNOWN.. as 1? No real objection here, just in my head
somehow UNKNOWN = 0 or just start from 1.

> +	ETHTOOL_PODL_PSE_ADMIN_STATE_DISABLED,
> +	ETHTOOL_PODL_PSE_ADMIN_STATE_ENABLED,
> +
> +	/* add new constants above here */
> +	ETHTOOL_PODL_PSE_ADMIN_STATE_COUNT

Why define count for a value enum like this? For attrs we define it
because it's used to size tables, don't think anyone will size tables
based on states.

There's a bunch of kdoc warnings in the patches as well.

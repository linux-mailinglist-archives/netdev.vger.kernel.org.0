Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03FBF50C3E0
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 01:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232725AbiDVWWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 18:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232665AbiDVWWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 18:22:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F3D1B45F8;
        Fri, 22 Apr 2022 14:12:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85FD261D50;
        Fri, 22 Apr 2022 19:25:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B088C385A0;
        Fri, 22 Apr 2022 19:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650655519;
        bh=WYqnuhXjI+/exhaILQxhAiYQgAemTlqPINtEIH6j1CQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tDLCgpzdk25UmYaYYQWNuuMTHiodmybPYVgnllJRpzph3GkvCXhAymiuQFmDf9tb4
         wq/rp8GViY1G3sBZpDRpBNH27jZqSwjw1zCkecvIHaUQvkfNSSaPO0GIVH2o7am0lZ
         fKonI5zfaeVtR1tWBw28+pbXthudgjVXU+uR4P7Jz7wF8ROh1TpJaiOnoaccNaSIs5
         qzKOur5UE6yha/e2xTHQqnibPyRMK6tB4zusU8N9hvKwN9qJwndldGV74eDy7TIBby
         ejnLaAZC65Yb8ZiXxK4cofso6jSpTcIs8dzRSHsYzmkQBUhw+SQrq4g8CP6ykvwCy6
         LRbtDNkY+7o+Q==
Date:   Fri, 22 Apr 2022 12:25:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dylan Hung <dylan_hung@aspeedtech.com>
Cc:     <robh+dt@kernel.org>, <joel@jms.id.au>, <andrew@aj.id.au>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <pabeni@redhat.com>,
        <p.zabel@pengutronix.de>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-aspeed@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <krzk+dt@kernel.org>,
        <BMC-SW@aspeedtech.com>
Subject: Re: [PATCH net-next RESEND v5 0/3] Add reset deassertion for Aspeed
 MDIO
Message-ID: <20220422122518.347d7779@kernel.org>
In-Reply-To: <20220418014059.3054-1-dylan_hung@aspeedtech.com>
References: <20220418014059.3054-1-dylan_hung@aspeedtech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Apr 2022 09:40:56 +0800 Dylan Hung wrote:
> Add missing reset deassertion for Aspeed MDIO bus controller. The reset
> is asserted by the hardware when power-on so the driver only needs to
> deassert it. To be able to work with the old DT blobs, the reset is
> optional since it may be deasserted by the bootloader or the previous
> kernel.

still doesn't apply cleanly to net-next:

$ git checkout net-next/master 
HEAD is now at c78c5a660439 dt-bindings: net: mediatek,net: convert to the json-schema

$ git pw series apply 632891
Applying: dt-bindings: net: add reset property for aspeed, ast2600-mdio binding
Applying: net: mdio: add reset control for Aspeed MDIO
Using index info to reconstruct a base tree...
M	drivers/net/mdio/mdio-aspeed.c
Falling back to patching base and 3-way merge...
Auto-merging drivers/net/mdio/mdio-aspeed.c
Applying: ARM: dts: aspeed: add reset properties into MDIO nodes

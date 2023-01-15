Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 488D066B2AD
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 17:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbjAOQ6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 11:58:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230501AbjAOQ6G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 11:58:06 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D0F4EC49
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 08:58:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=IEF0Qvv1dJejX3FJqZ7ClcaaOMLVeaZoXIK0QOB2NJc=; b=rY9jXOhXJYB8QlnIQVAW4HgsS9
        b/EcScbj8xQpuMdL0xbky2+M+8Aj9ZEpnyXuaMzMFYL746cx5Nsy9zXcmvB+Uce9xCYJJ68F39qQu
        U3xoU44N2ZH6HiPvIDCanl2TjxMXJj73IqLCF6Uq7CSa8bxiaQAxkbcHyV66+pFGsHuQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pH6KR-0028uw-Vm; Sun, 15 Jan 2023 17:57:55 +0100
Date:   Sun, 15 Jan 2023 17:57:55 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>
Subject: Re: [PATCH net-next] net: phy: meson-gxl: support more G12A-internal
 PHY versions
Message-ID: <Y8Qwk5H8Yd7qiN0j@lunn.ch>
References: <d75ef7df-a645-7fdd-491a-f89f70dbea01@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d75ef7df-a645-7fdd-491a-f89f70dbea01@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 15, 2023 at 04:19:37PM +0100, Heiner Kallweit wrote:
> On my SC2-based system the genphy driver was used because the PHY
> identifies as 0x01803300. It works normal with the meson g12a
> driver after this change.
> Switch to PHY_ID_MATCH_MODEL to cover the different sub-versions.

Hi Heiner

Are there any datasheets for these devices? Anything which documents
the lower nibble really is a revision?

I'm just trying to avoid future problems where we find it is actually
a different PHY, needs its own MATCH_EXACT entry, and then we find we
break devices using 0x01803302 which we had no idea exists, but got
covered by this change.

	Andrew

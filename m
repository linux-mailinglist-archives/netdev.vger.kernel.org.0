Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6CE36132C4
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 10:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbiJaJdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 05:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiJaJdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 05:33:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD554CE20;
        Mon, 31 Oct 2022 02:33:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D493B81232;
        Mon, 31 Oct 2022 09:33:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C760C433C1;
        Mon, 31 Oct 2022 09:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667208779;
        bh=w/3KNfzjLA7QkRXDTQiecgRoc2V898KDK8Z4fbHT+Lc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oAdqKcT8Iy8q+bTtPhxtWaugmvg91tNc7D/CaXE9/zxtqxuOIHuSAD7Fw8o8hDHiq
         5zquXXZERE7pObCQlmgKfo761sGPhNMm9AFpQS16rLSFCytllreNjcV503x701PI++
         Ey7vK5SbaEpviS65Pc1lIb6uL2Nd0ldl4j5ddZH7le3+dAiK/XphL1XN/gdSiCsQcK
         v66NjXhThb27u3hDb67DGeBGCRBXdYQHdQIvke2NX+L2/sCkQDGchwy3hwSdCjbqLA
         aJDv+qeO6vaXxhCLq6V4Hq0WJEac+vpAKiINuQqzGj1H8oZ1f415pJKb7j05Tc90jx
         9tDJjRwWu1qog==
Date:   Mon, 31 Oct 2022 09:32:51 +0000
From:   Lee Jones <lee@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [RFC v4 net-next 11/17] mfd: ocelot: prepend resource size
 macros to be 32-bit
Message-ID: <Y1+WQ2ebtoBw0AgB@google.com>
References: <20221008185152.2411007-1-colin.foster@in-advantage.com>
 <20221008185152.2411007-12-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221008185152.2411007-12-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 08 Oct 2022, Colin Foster wrote:

> The *_RES_SIZE macros are initally <= 0x100. Future resource sizes will be
> upwards of 0x200000 in size.
> 
> To keep things clean, fully align the RES_SIZE macros to 32-bit to do
> nothing more than make the code more consistent.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---
> 
> v3-v4
>     * No change
> 
> v2
>     * New patch - broken out from a different one
> 
> ---
>  drivers/mfd/ocelot-core.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

I'm guessing some of the other patches depend on this?

How should it be handled?

For my own reference (apply this as-is to your sign-off block):

  Acked-for-MFD-by: Lee Jones <lee@kernel.org>

-- 
Lee Jones [李琼斯]

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6ED757F743
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 23:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbiGXVyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 17:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiGXVyH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 17:54:07 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7303CE19;
        Sun, 24 Jul 2022 14:54:06 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id b11so17312196eju.10;
        Sun, 24 Jul 2022 14:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Iud5FUy3OZWLd15hXCRbvZsIvxpax/LEixyfDAvU5jg=;
        b=N8jcFg0CBOtwtU6H4Lv8mCc2cc+Y4aIQjhKrJ+lSVXhHCb7pRykX7bOTen/QYQTINA
         zu7Y9Jdj6VRtGmvHd7v4tgBpMD4QUfuuL+zhLIbI6e6bjYOh7GxBYfl17wq8C3/lD5ce
         kKN3t88yJT4jaBwGnTO3TVHmCtaJv55FE2jk3pf+mtB7Vp2C8pdZhkEvbbArkgVxy++S
         hoj2g3FNfYN80q0kQFya1+dVfSBRMWwwXDwtDpwGv994AMUsuDWOiCzhewnGOhKXNV6R
         /vXB+wSbObE84S75z0JmX6B+MddPwt6UlnJkwM80r9AIq0+SjlFbGpAgBheO9FpyuE1D
         ea8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Iud5FUy3OZWLd15hXCRbvZsIvxpax/LEixyfDAvU5jg=;
        b=piJHY9XIUcpLF16B/GhuEfzM7SgqUFR8I1PydZnYUcjAaKyK9o89EXPPflJBg24nof
         5F+ey+b9CaQyahs2Nra5FCJX+N3gCV7+SLgU7BQFj0KT5iGx72k/pQtbdqE6SPfPlwjd
         WR8P0qa+qg8NikbGmevTxAXhQer/sth1EnuSDbm52Wz+nJzCNPN0OTlVL+R1c7azcHPr
         DK5dKZsjwYRIvkvmHnuFt3Ra9uRuYhQttWs1hxhiAl21rJmASwOt9Z+ztitTy+GVfsp4
         5Lk9LeqAavJ/vLldh9aAAQNr8v07Gf17jp/Ixe4aBKbpGg4+0fACeQmiWqWIpLMAR2m3
         rBMQ==
X-Gm-Message-State: AJIora/OIwFcn+unLr9KdZqh3Toj1EYNAOe0m2csvC34QG01xfawHyK+
        V22sO7T0gx/zQUtUJHb1ATNpuIL66nE=
X-Google-Smtp-Source: AGRyM1u2/AuF1xzh4ljm4CZPNmjLy24N4PnF/FN4onqEMSp2N4Zn7NFKMHM7wbuuaDYzUcufuDIu1g==
X-Received: by 2002:a17:907:96a9:b0:72e:ddc3:279c with SMTP id hd41-20020a17090796a900b0072eddc3279cmr7715738ejc.138.1658699645059;
        Sun, 24 Jul 2022 14:54:05 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id 11-20020a170906310b00b0072b3391193dsm4542438ejx.154.2022.07.24.14.54.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jul 2022 14:54:04 -0700 (PDT)
Date:   Mon, 25 Jul 2022 00:54:02 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [Patch net-next v2 0/9] net: dsa: microchip: add support for
 phylink mac config and link up
Message-ID: <20220724215402.24426hipwgxlctly@skbuf>
References: <20220724092823.24567-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220724092823.24567-1-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 24, 2022 at 02:58:14PM +0530, Arun Ramadoss wrote:
> This patch series add support common phylink mac config and link up for the ksz
> series switches. At present, ksz8795 and ksz9477 doesn't implement the phylink
> mac config and link up. It configures the mac interface in the port setup hook.
> ksz8830 series switch does not mac link configuration. For lan937x switches, in
> the part support patch series has support only for MII and RMII configuration.
> Some group of switches have some register address and bit fields common and
> others are different. So, this patch aims to have common phylink implementation
> which configures the register based on the chip id.

I don't see something problematic with this patch set.

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

> 
> Changes in v2
> - combined the modification of duplex, tx_pause and rx_pause into single
>   function.
> 
> Changes in v1
> - Squash the reading rgmii value from dt to patch which apply the rgmii value
> - Created the new function ksz_port_set_xmii_speed
> - Seperated the namespace values for xmii_ctrl_0 and xmii_ctrl_1 register
> - Applied the rgmii delay value based on the rx/tx-internal-delay-ps
> 
> Arun Ramadoss (9):
>   net: dsa: microchip: add common gigabit set and get function
>   net: dsa: microchip: add common ksz port xmii speed selection function
>   net: dsa: microchip: add common duplex and flow control function
>   net: dsa: microchip: add support for common phylink mac link up
>   net: dsa: microchip: lan937x: add support for configuing xMII register
>   net: dsa: microchip: apply rgmii tx and rx delay in phylink mac config
>   net: dsa: microchip: ksz9477: use common xmii function
>   net: dsa: microchip: ksz8795: use common xmii function
>   net: dsa: microchip: add support for phylink mac config
> 
>  drivers/net/dsa/microchip/ksz8795.c      |  40 ---
>  drivers/net/dsa/microchip/ksz8795_reg.h  |   8 -
>  drivers/net/dsa/microchip/ksz9477.c      | 183 +------------
>  drivers/net/dsa/microchip/ksz9477_reg.h  |  24 --
>  drivers/net/dsa/microchip/ksz_common.c   | 312 ++++++++++++++++++++++-
>  drivers/net/dsa/microchip/ksz_common.h   |  54 ++++
>  drivers/net/dsa/microchip/lan937x.h      |   8 +-
>  drivers/net/dsa/microchip/lan937x_main.c | 125 +++------
>  drivers/net/dsa/microchip/lan937x_reg.h  |  32 ++-
>  9 files changed, 431 insertions(+), 355 deletions(-)
> 
> 
> base-commit: 502c6f8cedcce7889ccdefeb88ce36b39acd522f
> -- 
> 2.36.1
> 

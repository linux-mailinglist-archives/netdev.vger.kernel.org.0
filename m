Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68B723BC60
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 21:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388816AbfFJTDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 15:03:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:56404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387674AbfFJTDC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 15:03:02 -0400
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E8482085A;
        Mon, 10 Jun 2019 19:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560193381;
        bh=NblxIERz+Cyc8pebQ/YTyK3Qt134gIJ9b11F5HCfcSw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=PgJJh642AWLqqi0z4cBc8Uz8AaKinC3+7XqnMIaw+qbjRmFeUnOF9pmKTHsL4eTK+
         00D2dCkgrqb7KkPk9lllmW1lWRxp2XPZ1jf4C905eYEKe+RTNiHPksmJInX6DeFguH
         ajEfOhWUGO9IuJjJNba0/6WgzIHh7EeZvR62u+8s=
Received: by mail-qt1-f176.google.com with SMTP id p15so4275806qtl.3;
        Mon, 10 Jun 2019 12:03:01 -0700 (PDT)
X-Gm-Message-State: APjAAAXNQiDODVuWa4sqBSGzhS66VbBlgWGjafxo3AiyiIPnota0KqpY
        c/xftRf/XWgLrb5Tjvp2ie5xHRtfnPF5V1NReQ==
X-Google-Smtp-Source: APXvYqy9lwcAc459jdixSn0EhQcrOn2ydIJGUumtuZb7Ajh2SHHffvWIy0UNqYr9ntVCWt/AeFq56dTqVeVGcjluGpQ=
X-Received: by 2002:aed:3b33:: with SMTP id p48mr53898280qte.143.1560193380845;
 Mon, 10 Jun 2019 12:03:00 -0700 (PDT)
MIME-Version: 1.0
References: <91618c7e9a5497462afa74c6d8a947f709f54331.1560158667.git-series.maxime.ripard@bootlin.com>
In-Reply-To: <91618c7e9a5497462afa74c6d8a947f709f54331.1560158667.git-series.maxime.ripard@bootlin.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Mon, 10 Jun 2019 13:02:49 -0600
X-Gmail-Original-Message-ID: <CAL_Jsq+8_+OPVO14xu1yZU8q1Nux70TjP42j6SiBo9KdHL-4qQ@mail.gmail.com>
Message-ID: <CAL_Jsq+8_+OPVO14xu1yZU8q1Nux70TjP42j6SiBo9KdHL-4qQ@mail.gmail.com>
Subject: Re: [PATCH v2 01/11] dt-bindings: net: Add YAML schemas for the
 generic Ethernet options
To:     Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        netdev <netdev@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        =?UTF-8?Q?Antoine_T=C3=A9nart?= <antoine.tenart@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 10, 2019 at 3:26 AM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
>
> The Ethernet controllers have a good number of generic options that can be
> needed in a device tree. Add a YAML schemas for those.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
>
> ---
>
> Changes from v1:
>   - Use an enum for phy-connection-types
>   - Validate the items for the fixed-link array
>   - Set the number of valid items for link-gpios to 1
>   - Removed deprecated properties (phy-mode, phy, phy-device)
> ---
>  Documentation/devicetree/bindings/net/ethernet-controller.yaml | 194 +++++++-
>  Documentation/devicetree/bindings/net/ethernet.txt             |  69 +--
>  Documentation/devicetree/bindings/net/fixed-link.txt           |  55 +--
>  3 files changed, 196 insertions(+), 122 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/ethernet-controller.yaml

Reviewed-by: Rob Herring <robh@kernel.org>

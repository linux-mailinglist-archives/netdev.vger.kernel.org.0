Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 421884BAE1
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 16:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728926AbfFSOMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 10:12:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:56470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbfFSOMX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 10:12:23 -0400
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20B7B21855;
        Wed, 19 Jun 2019 14:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560953542;
        bh=LFjHq6ftsF8ixON43fD3Q6Ndtpt2rar3Y+/uG+MLXjw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=prEsNKmyAvAq7H0E/JU6DGY/fpy4Y2cDr8VFkyP0FxHF4wONETOFKBqM0n7WkBUfm
         j52OugjC0IgrqAnsfY6ZBep9HodrOSCoRjJZixWjWyXd0qw8a1RksAOO01lwa+FqSs
         q4uKK+ubteTIwOfjnQvUas0PoXRu5TyEwwd9xWFA=
Received: by mail-qt1-f178.google.com with SMTP id h21so19981813qtn.13;
        Wed, 19 Jun 2019 07:12:22 -0700 (PDT)
X-Gm-Message-State: APjAAAWa6I3VqUT2v7ZDnbZ920SVkS7NB8Bujnc5rIerijFKYGNM90iK
        vNq81TxFgjNihkCXd/5/ySJ0lsVK0wSym66mvQ==
X-Google-Smtp-Source: APXvYqx7bOz4FzfPsClBOol4RpULcypOHhAO+WI7MhBrQEIGcxX/3pwVQ40KBd7vbLC3LPe64QmnNa+B23EWoR33xWw=
X-Received: by 2002:ac8:368a:: with SMTP id a10mr23661785qtc.143.1560953541290;
 Wed, 19 Jun 2019 07:12:21 -0700 (PDT)
MIME-Version: 1.0
References: <27aeb33cf5b896900d5d11bd6957eda268014f0c.1560937626.git-series.maxime.ripard@bootlin.com>
 <60569c4326437aeb1c13b3da4d00bcf6202e9e6b.1560937626.git-series.maxime.ripard@bootlin.com>
In-Reply-To: <60569c4326437aeb1c13b3da4d00bcf6202e9e6b.1560937626.git-series.maxime.ripard@bootlin.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Wed, 19 Jun 2019 08:12:09 -0600
X-Gmail-Original-Message-ID: <CAL_Jsq+D_=3V26Yj-EH4nJ0Hsx7-+73Q8iGD+s40iRz-EpS=kQ@mail.gmail.com>
Message-ID: <CAL_Jsq+D_=3V26Yj-EH4nJ0Hsx7-+73Q8iGD+s40iRz-EpS=kQ@mail.gmail.com>
Subject: Re: [PATCH v3 08/16] dt-bindings: net: stmmac: Convert the binding to
 a schemas
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

On Wed, Jun 19, 2019 at 3:48 AM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
>
> Switch the STMMAC / Synopsys DesignWare MAC controller binding to a YAML
> schema to enable the DT validation.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
>
> ---
>
> Changes from v2:
>   - Switch to phy-connection-type instead of phy-mode
>   - Fix the snps,*pbl properties type
>
> Changes from v1:
>   - Restrict snps,tso to only a couple of compatibles
>   - Use an enum for the compatibles
>   - Add a custom select statement with the compatibles of all the generic
>     compatibles, including the deprecated ones. Remove the deprecated ones
>     from the valid compatible values to issue a warning when used.
> ---
>  Documentation/devicetree/bindings/net/snps,dwmac.yaml | 389 +++++++++++-
>  Documentation/devicetree/bindings/net/stmmac.txt      | 179 +-----
>  2 files changed, 390 insertions(+), 178 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/snps,dwmac.yaml

Reviewed-by: Rob Herring <robh@kernel.org>

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3FF54BAD3
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 16:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbfFSOK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 10:10:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:55454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbfFSOK0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 10:10:26 -0400
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75EEF206BF;
        Wed, 19 Jun 2019 14:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560953425;
        bh=eAkETR1airFEdkrvmqxKAnHpAPALZYjF/U5gjIALrUM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=UuVQ+dfW0se8BadL24kxy8KpYt7nswO2DeKP9VFDc4smOqGT+DUiRX0yB2SodJEw6
         CeSGRrMV5AncEhb1NwIH0SZMxo3PI6/ZbYRrgYvx+eCJzBIBd/BfQAnhOGveFtLUgY
         NJcF4UvAjiAAShvHlsvcpVNeAgNYZa70+fg9sNY8=
Received: by mail-qk1-f175.google.com with SMTP id m14so10963159qka.10;
        Wed, 19 Jun 2019 07:10:25 -0700 (PDT)
X-Gm-Message-State: APjAAAW/e6WePJDk6xWx4CwxqR7ZBprbuWNta+bxsGQTAxZjoyEpGKK+
        1FJ5wzF9HGkviYc7Lq764or3B5BndWMOh1dfRw==
X-Google-Smtp-Source: APXvYqw9X46Mgu2RprjLazOYn0ITq1U9dAZj6F7rqFtXuTxJ4ZNpg2PAEqixE+a2M0Jx4daY2/u8dIsGscF4zKKrR5U=
X-Received: by 2002:a37:a6c9:: with SMTP id p192mr102502666qke.184.1560953424738;
 Wed, 19 Jun 2019 07:10:24 -0700 (PDT)
MIME-Version: 1.0
References: <27aeb33cf5b896900d5d11bd6957eda268014f0c.1560937626.git-series.maxime.ripard@bootlin.com>
 <a9c556114ab21793d100f31361da01a579bae84e.1560937626.git-series.maxime.ripard@bootlin.com>
In-Reply-To: <a9c556114ab21793d100f31361da01a579bae84e.1560937626.git-series.maxime.ripard@bootlin.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Wed, 19 Jun 2019 08:10:13 -0600
X-Gmail-Original-Message-ID: <CAL_JsqLyByqjpdSoebU7xboupmnbZb5q3D2L_oQt_sigBQeMnQ@mail.gmail.com>
Message-ID: <CAL_JsqLyByqjpdSoebU7xboupmnbZb5q3D2L_oQt_sigBQeMnQ@mail.gmail.com>
Subject: Re: [PATCH v3 10/16] dt-bindings: net: sun8i-emac: Convert the
 binding to a schemas
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
> Switch our Allwinner H3 EMAC controller binding to a YAML schema to enable
> the DT validation. Since that controller is based on a Synopsys IP, let's
> add the validation to that schemas with a bunch of conditionals.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
>
> ---
>
> Changes from v2:
>   - Switch to phy-connection-type instead of phy-mode
>   - Change the delay enum to using multipleOf
>
> Changes from v1:
>   - Add specific binding document
> ---
>  Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml | 321 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  Documentation/devicetree/bindings/net/dwmac-sun8i.txt                | 201 +---------------------------------------------
>  Documentation/devicetree/bindings/net/snps,dwmac.yaml                |  15 +++-
>  3 files changed, 336 insertions(+), 201 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/dwmac-sun8i.txt

Reviewed-by: Rob Herring <robh@kernel.org>

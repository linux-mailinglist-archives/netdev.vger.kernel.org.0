Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1A6315A89
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 01:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234785AbhBJADv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 19:03:51 -0500
Received: from mail-oi1-f175.google.com ([209.85.167.175]:38530 "EHLO
        mail-oi1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234568AbhBIXOh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 18:14:37 -0500
Received: by mail-oi1-f175.google.com with SMTP id h6so21327021oie.5;
        Tue, 09 Feb 2021 15:14:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iqog8CsMHZIPOPeN6dyy7RBD2+MWiYCuwU7gMHDgn+E=;
        b=MDJ2TV7F9r7oP7aqAjeP36mbng/fC8Rzv+wJGXSv5kjQFDK0g0kuT+5Za/f3BTE6xQ
         mUTJITo+qL53i8+UoemfGXvzFH/8qVU0YcwpjCGwAsaxFsU6z4PA86fBSryjSe08i1Oo
         JVltNfRnp68R/dQHs7tRvup3OIa/gpyJQmtAD8oTzBgZYcUGCenKPF6gQOhAHh9cxrMw
         wvy6OlKKPJ5s9pRwiLEHK/8vUD+VyvlZcjXg1iJ9ZLDq6a7hyKVE8+gkJIyaUgXmnidJ
         bTjmP1bXb5RYlHr2t5mzzSEIdR/hs+7aN8nRBF224kY1WvZ3xiM+ulPUJuGr8yww7Db2
         gPug==
X-Gm-Message-State: AOAM5336qvsSbTIZ76kiI0tUNxjeycrYVUkyZbsojn1yLuA5x6WdrCWV
        s5CeX9r0sWVrPi9vdXlaRw==
X-Google-Smtp-Source: ABdhPJzM6bjqNck+607mXDy9PNLPvWoFJltI+hjArBy4hP5rzbxs58R6CIAoKNThG27jqmChAp+4ng==
X-Received: by 2002:aca:4b43:: with SMTP id y64mr86780oia.156.1612912434949;
        Tue, 09 Feb 2021 15:13:54 -0800 (PST)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id i16sm7022oto.45.2021.02.09.15.13.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 15:13:53 -0800 (PST)
Received: (nullmailer pid 410105 invoked by uid 1000);
        Tue, 09 Feb 2021 23:13:52 -0000
Date:   Tue, 9 Feb 2021 17:13:52 -0600
From:   Rob Herring <robh@kernel.org>
To:     Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Serge Semin <fancer.lancer@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Vyacheslav Mitrofanov 
        <Vyacheslav.Mitrofanov@baikalelectronics.ru>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/16] dt-bindings: net: dwmac: Add DW GMAC GPIOs
 properties
Message-ID: <20210209231352.GA402351@robh.at.kernel.org>
References: <20210208140820.10410-1-Sergey.Semin@baikalelectronics.ru>
 <20210208140820.10410-2-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208140820.10410-2-Sergey.Semin@baikalelectronics.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 08, 2021 at 05:08:05PM +0300, Serge Semin wrote:
> Synopsys DesignWare Ethernet controllers can be synthesized with
> General-Purpose IOs support. GPIOs can work either as inputs or as outputs
> thus belong to the gpi_i and gpo_o ports respectively. The ports width
> (number of possible inputs/outputs) and the configuration registers layout
> depend on the IP-core version. For instance, DW GMAC can have from 0 to 4
> GPIs and from 0 to 4 GPOs, while DW xGMAC have a wider ports width up to
> 16 pins of each one.
> 
> So the DW MAC DT-node can be equipped with "ngpios" property, which can't
> have a value greater than 32, standard GPIO-related properties like
> "gpio-controller" and "#gpio-cells", and, if GPIs are supposed to be
> detected, IRQ-controller related properties.
> 
> Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> ---
>  .../devicetree/bindings/net/snps,dwmac.yaml     | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> index bdc437b14878..fcca23d3727e 100644
> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> @@ -110,6 +110,23 @@ properties:
>    reset-names:
>      const: stmmaceth
>  
> +  ngpios:
> +    description:
> +      Total number of GPIOs the MAC supports. The property shall include both
> +      the GPI and GPO ports width.
> +    minimum: 1
> +    maximum: 32

Does the driver actually need this? I'd omit it if just to validate 
consumers are in range.

Are GPI and GPO counts independent? If so, this isn't really sufficient.

Rob

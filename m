Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D37852DB258
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 18:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729769AbgLORPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 12:15:17 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:34574 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727063AbgLORO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 12:14:58 -0500
Received: by mail-oi1-f195.google.com with SMTP id s75so24135240oih.1;
        Tue, 15 Dec 2020 09:14:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+Qu4+kvBzm3PqXb1At7zY+1pW2euTQkxhk/cm9SbdHY=;
        b=porVhyXOQV+Xm8GqXoFBYH15ecd4J/j2QeUz2aUojP16pvhTQqpk0WAcUGSSA6JlUa
         G9zgqkCvbNX0UttGVKg+tg1jpuVvw+pvCkc1mkdAgsKvgXiHpJ0BsY99Un4KLUOYsiOS
         Z2MLnVmWKoegle8t8ANRahw+D2AzgDal/QRXiiB/Gn/+NcdZ4mlI1id3Mqed0Ox4u1jz
         0UR1IAqvPleJqLX0uqC3YHgQa/hi6aXMeFXa1OHoagAz9Mb15ASrj23ZAoxwHrFwab2p
         dFHvVmZljCfX12RMjtMp7s2Fto2mYH19X/fvgPjp3rTaBkmvlVzN9SB6tHp/I8mEpQXn
         JO5g==
X-Gm-Message-State: AOAM533rNtWJqH6qMOUtJ+cUZpbZ6XgKhZNrdtNRIST1qbsGL1W1cPGN
        tfdPrqSDAC2CL8LeMaxtFSdYJIRqyg==
X-Google-Smtp-Source: ABdhPJzVpgelZd7N6boJkoJWy3kD5FQdlN3JtoRPvXPhm8+og2A32ilo2++TNDM964Exsl6NSovr0A==
X-Received: by 2002:aca:bc84:: with SMTP id m126mr22208391oif.169.1608052457156;
        Tue, 15 Dec 2020 09:14:17 -0800 (PST)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id l6sm548795otf.34.2020.12.15.09.14.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 09:14:16 -0800 (PST)
Received: (nullmailer pid 4046464 invoked by uid 1000);
        Tue, 15 Dec 2020 17:14:15 -0000
Date:   Tue, 15 Dec 2020 11:14:15 -0600
From:   Rob Herring <robh@kernel.org>
To:     Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc:     Johan Hovold <johan@kernel.org>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        netdev@vger.kernel.org, Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        Jakub Kicinski <kuba@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Serge Semin <fancer.lancer@gmail.com>,
        Maxime Ripard <mripard@kernel.org>,
        Vyacheslav Mitrofanov 
        <Vyacheslav.Mitrofanov@baikalelectronics.ru>,
        devicetree@vger.kernel.org,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Lars Persson <larper@axis.com>,
        Joao Pinto <jpinto@synopsys.com>
Subject: Re: [PATCH 01/25] dt-bindings: net: dwmac: Validate PBL for all
 IP-cores
Message-ID: <20201215171415.GA4046412@robh.at.kernel.org>
References: <20201214091616.13545-1-Sergey.Semin@baikalelectronics.ru>
 <20201214091616.13545-2-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201214091616.13545-2-Sergey.Semin@baikalelectronics.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Dec 2020 12:15:51 +0300, Serge Semin wrote:
> Indeed the maximum DMA burst length can be programmed not only for DW
> xGMACs, Allwinner EMACs and Spear SoC GMAC, but in accordance with [1]
> for Generic DW *MAC IP-cores. Moreover the STMMAC set of drivers parse
> the property and then apply the configuration for all supported DW MAC
> devices. All of that makes the property being available for all IP-cores
> the bindings supports. Let's make sure the PBL-related properties are
> validated for all of them by the common DW MAC DT schema.
> 
> [1] DesignWare Cores Ethernet MAC Universal Databook, Revision 3.73a,
>     October 2013, p. 380.
> 
> Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> ---
>  .../devicetree/bindings/net/snps,dwmac.yaml   | 69 +++++++------------
>  1 file changed, 26 insertions(+), 43 deletions(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>

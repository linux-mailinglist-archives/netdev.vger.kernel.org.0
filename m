Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE55315A9C
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 01:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234904AbhBJAGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 19:06:20 -0500
Received: from mail-oi1-f176.google.com ([209.85.167.176]:37015 "EHLO
        mail-oi1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233798AbhBIXZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 18:25:00 -0500
Received: by mail-oi1-f176.google.com with SMTP id y199so26267oia.4;
        Tue, 09 Feb 2021 15:24:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=c0+mQvbUzr0QHjab9b+cDuiuwKG7CNWq4G/aggiV8ko=;
        b=nyTHHV9UtdMqt8tZ8jiAOXADWcOkSZSf4xkFI2nt39rZVcxu+mfPpg+AeSL9fIDEi6
         BP/49IJ4OtPPAccpCshnPciZRE/ROG95jFHftEF6k79VOymu8E2aFQTT5Vag62ZK5FfJ
         PP821L+TAL/0lMOOiC9V+bGBsv9ALx+Q5tfppIBLsLZo8+l8vs+tSjnxZszxD94EcdVZ
         xHvIN4+n2ffDUNgj13B4bqw/kqX4Gxze+XxAyanMCfkbG+LrAkMdmuXOdcsAOVQBIDRo
         YDWOdN8YA9wFA0yOCGMjgvp55MRILKn73apacpaIFzi03+sRecxSmDGG7X20HEIaARQL
         pahg==
X-Gm-Message-State: AOAM532N/pY1UonNpz40YHk8A+nm607WiReb5bdMRfICT8DtQiN57/UU
        rD+imT+gqNmPrGDvITgJUM2jalxTqg==
X-Google-Smtp-Source: ABdhPJz6qtqiolUfmqOCucOTDw4UZsTDHjUdAxJoYxLAfMasBXNXmWyKEfqfN3viNqLICssfBelF6g==
X-Received: by 2002:aca:570d:: with SMTP id l13mr91914oib.159.1612913053378;
        Tue, 09 Feb 2021 15:24:13 -0800 (PST)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id q3sm51946oih.35.2021.02.09.15.24.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 15:24:11 -0800 (PST)
Received: (nullmailer pid 428235 invoked by uid 1000);
        Tue, 09 Feb 2021 23:24:10 -0000
Date:   Tue, 9 Feb 2021 17:24:10 -0600
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
Subject: Re: [PATCH 02/16] dt-bindings: net: Add Baikal-T1 GMAC bindings
Message-ID: <20210209232410.GA410815@robh.at.kernel.org>
References: <20210208140820.10410-1-Sergey.Semin@baikalelectronics.ru>
 <20210208140820.10410-3-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208140820.10410-3-Sergey.Semin@baikalelectronics.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 08, 2021 at 05:08:06PM +0300, Serge Semin wrote:
> Baikal-T1 SoC is equipped with two DW GMAC v3.73a-based 1GBE ethernet
> interfaces synthesized with: RGMII PHY interface, AXI-DMA and APB3 CSR,
> 16KB Tx/Rx FIFOs and PBL up to half of that, PTP, PMT, TCP/IP CoE, up to 4
> outstanding AXI read/write requests, maximum AXI burst length of 16 beats,
> up to eight MAC address slots, one GPI and one GPO ports. Generic DW
> MAC/STMMAC driver will easily handle the DT-node describing the Baikal-T1
> GMAC network devices, but the bindings still needs to be created to have a
> better understanding of what the interface looks like.
> 
> Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> 
> ---
> 
> Rob, please note I couldn't declare the axi-config object properties constraints
> without specifying the properties type and description. If I remove them the
> dt_binding_check will curse with the error:
> 
> >> .../baikal,bt1-gmac.yaml: properties:axi-config:properties:snps,blen: 'description' is a required property
> >> .../baikal,bt1-gmac.yaml: properties:axi-config:properties:snps,wr_osr_lmt: 'oneOf' conditional failed, one must be fixed:
>         'type' is a required property
>         Additional properties are not allowed ('maximum' was unexpected)
> >> ...
> 
> I did't know what to do with these errors, so I just created normal sub-node
> properties with stricter constraints than they are specified in the main
> snps,dwmac.yaml schema. Any suggestion what is a better way to apply
> additional constraints on sub-node properties?

Yes, that's known problem which I don't have a solution for. I think the 
solution is checking all properties have a type defined once and only 
once. That would also make sure we don't have 2 property names with 
different types. With that we can loosen the meta-schema checks. In the 
vast majority of cases though we need a type, so the exceptions like 
here will need to duplicate the type and description.


Reviewed-by: Rob Herring <robh@kernel.org>

> ---
>  .../bindings/net/baikal,bt1-gmac.yaml         | 150 ++++++++++++++++++
>  1 file changed, 150 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/baikal,bt1-gmac.yaml

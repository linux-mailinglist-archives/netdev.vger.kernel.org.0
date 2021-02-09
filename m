Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79ADB31592B
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 23:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233921AbhBIWKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 17:10:10 -0500
Received: from mail-oi1-f182.google.com ([209.85.167.182]:44956 "EHLO
        mail-oi1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232975AbhBIWFk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 17:05:40 -0500
Received: by mail-oi1-f182.google.com with SMTP id r75so7522076oie.11;
        Tue, 09 Feb 2021 14:04:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bOiEgQJc9F4c/q7bHFCKm4lcHmd+4+4DEwd4LTgy3IY=;
        b=LrOBmEHzUSCvqN/HFKohTnVg+lR9vlyce1MqNEK2vRxDGgCLbnzz9zl4owonoTt/uk
         2EZyYM0hba2EGyohR1s1728+4oJOTaVW7KSJaAwtGm+dFkZo2URCC0zoDE9agOPdZ9/9
         8X5/g0BmY6x60J1vrPrP8S+bHgYjhcIZttGUQPIumVN9I8IZuPmgFd3AMyQjEAYtIvuX
         DjPz7GSWIUub/5X8fQT2iDqMkDVxqP3DwMvfFcROjlnJ3jt5E8HSvC84HCzNNjs5gc/M
         D2fQ6O69G0qU/f+928YCmi+gD1lDyOkGh900fzyip0jBL2Cce1e7Z6DbMzwJz45lKsam
         mQeg==
X-Gm-Message-State: AOAM532rmihfTiTO9uzzN12RngIYrwELSo7A7DzgHj7K4Q2YEtUH8z3j
        8qp/wELt6XtXtA15lH0J7EfxpA8DWw==
X-Google-Smtp-Source: ABdhPJx4uyiqqNf8J2Db0GfnFr86BDYIdEH1ii5Rx3XOwGmxWp5YiGpid9GYa8CRIZoTR6fO/8pZuw==
X-Received: by 2002:a05:6808:a01:: with SMTP id n1mr3914674oij.19.1612907644210;
        Tue, 09 Feb 2021 13:54:04 -0800 (PST)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id a18sm4791oia.0.2021.02.09.13.54.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 13:54:02 -0800 (PST)
Received: (nullmailer pid 268551 invoked by uid 1000);
        Tue, 09 Feb 2021 21:54:00 -0000
Date:   Tue, 9 Feb 2021 15:54:00 -0600
From:   Rob Herring <robh@kernel.org>
To:     Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc:     Jakub Kicinski <kuba@kernel.org>, Lars Persson <larper@axis.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Johan Hovold <johan@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxime Ripard <mripard@kernel.org>,
        Serge Semin <fancer.lancer@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        devicetree@vger.kernel.org,
        Vyacheslav Mitrofanov 
        <Vyacheslav.Mitrofanov@baikalelectronics.ru>,
        Joao Pinto <jpinto@synopsys.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: Re: [PATCH v2 03/24] dt-bindings: net: dwmac: Fix the TSO property
 declaration
Message-ID: <20210209215400.GA268498@robh.at.kernel.org>
References: <20210208135609.7685-1-Sergey.Semin@baikalelectronics.ru>
 <20210208135609.7685-4-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208135609.7685-4-Sergey.Semin@baikalelectronics.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 08 Feb 2021 16:55:47 +0300, Serge Semin wrote:
> Indeed the STMMAC driver doesn't take the vendor-specific compatible
> string into account to parse the "snps,tso" boolean property. It just
> makes sure the node is compatible with DW MAC 4.x, 5.x and DW xGMAC
> IP-cores. The original allwinner sunXi bindings file also didn't have the
> TSO-related property declared. Taking all of that into account fix the
> conditional statement so the TSO-property would be evaluated for the
> compatibles having the corresponding IP-core version.
> 
> While at it move the whole allOf-block from the tail of the binding file
> to the head of it, as it's normally done in the most of the DT schemas.
> 
> Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> 
> ---
> 
> Note this won't break the bindings description, since the "snps,tso"
> property isn't parsed by the Allwinner SunX GMAC glue driver, but only
> by the generic platform DT-parser.
> 
> Changelog v2:
> - Use correct syntax of the JSON pointers, so the later would begin
>   with a '/' after the '#'.
> ---
>  .../devicetree/bindings/net/snps,dwmac.yaml   | 52 +++++++++----------
>  1 file changed, 24 insertions(+), 28 deletions(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21AC43448E2
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 16:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbhCVPLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 11:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbhCVPK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 11:10:58 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FD5EC061756
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 08:10:57 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id dm8so19814357edb.2
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 08:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=BblDdmrktMK5tFFD4LOpFP77ijBklviaU26xu4C63tQ=;
        b=IT2iGJQyBA7Y1+dCJvTIJziErQmWcbn0+kMr4Y273pDNqodHvB6Ww7nGeAozLlDj16
         AaZFlWmlmAzS7zUACjHtiaCrXpOhiRROiQFyU4auZ+13hpjjdqVYNePQ5Cyp/9DkkrQC
         b91OFvMWYHKs9MAA7wM3CC0WQRuzxtVRw66hiamNYNrYJOlJE43oIsVGuMZ9kLPAqUbQ
         nynbvcEhIJeX2PlbMuKhnlTT65dd9GDFO83TYP0QzGcN6dLgdO2DDjR1KDBGvGzAifvT
         3iM6ErE3HQUX/Nd9uR6OnpKDyBISmiXqsi9ileg7sykq6tbAiP06wPIgKKPW7GTaZvHL
         iZmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=BblDdmrktMK5tFFD4LOpFP77ijBklviaU26xu4C63tQ=;
        b=jl8o7bVqLs3c1U+Z5FZi6uKaSZeaxkBTBnx/pjpGz5olD3wKySq1TKRxVtXW9VO3n4
         nGpVClDWmbisUBaN91QXby/I5uOubSfdQlM1UzS7R+0If3f41b1kJ/s711uvh1Ia0+/R
         2u7b3OON0tI32xgIfRyj6c4zcdzRUDrWMfJbwgDqg0u69gmK+9Mg4r6f5BKLfNjitqvW
         hXCq0x6rfWsmvkSBsszwvgYupzI5DAoVcS4AhaMjqotvKJ0cuDGNmIrqQGN4QXtpfUsh
         kIhS9aZrJMYED9xVvXr1kB+hgTgEVHj9dLR+bxE74sH68e34yKT1Bx4bSVBFcNVUXB9C
         ETyA==
X-Gm-Message-State: AOAM531dIBZ0tIkRBV94YNnzwcBkQHb2Wtb/u7YsEPgrKOEk2ygY+Vsg
        uld93XTXzTNhayjk14QYAcw6Qg==
X-Google-Smtp-Source: ABdhPJwxMVa4A4qij3tXD3Epc4EsEgsbfdMWBHLOdKIarJBUoxpk8xvIYdSjs+oVvVNjC/1HEN64aQ==
X-Received: by 2002:a05:6402:22b5:: with SMTP id cx21mr26421224edb.27.1616425856228;
        Mon, 22 Mar 2021 08:10:56 -0700 (PDT)
Received: from dell ([91.110.221.180])
        by smtp.gmail.com with ESMTPSA id e4sm9768413ejz.4.2021.03.22.08.10.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 08:10:55 -0700 (PDT)
Date:   Mon, 22 Mar 2021 15:10:53 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Russell King <linux@armlinux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        soc@kernel.org, Rob Herring <robh+dt@kernel.org>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        James Morse <james.morse@arm.com>,
        Robert Richter <rric@kernel.org>,
        Moritz Fischer <mdf@kernel.org>, Tom Rix <trix@redhat.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-clk@vger.kernel.org,
        dmaengine@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-fpga@vger.kernel.org, linux-i2c@vger.kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com
Subject: Re: [PATCH v3 03/15] mfd: altera: merge ARCH_SOCFPGA and
 ARCH_STRATIX10
Message-ID: <20210322151053.GB2916463@dell>
References: <20210311152545.1317581-1-krzysztof.kozlowski@canonical.com>
 <20210311152545.1317581-4-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210311152545.1317581-4-krzysztof.kozlowski@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Mar 2021, Krzysztof Kozlowski wrote:

> Simplify 32-bit and 64-bit Intel SoCFPGA Kconfig options by having only
> one for both of them.  This the common practice for other platforms.
> Additionally, the ARCH_SOCFPGA is too generic as SoCFPGA designs come
> from multiple vendors.
> 
> The side effect is that the MFD_ALTERA_A10SR will now be available for
> both 32-bit and 64-bit Intel SoCFPGA, even though it is used only for
> 32-bit.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
>  drivers/mfd/Kconfig | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog

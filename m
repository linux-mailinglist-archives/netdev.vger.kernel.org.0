Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C154488DE3
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 02:04:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234950AbiAJBCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 20:02:20 -0500
Received: from mail-oo1-f45.google.com ([209.85.161.45]:46055 "EHLO
        mail-oo1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237701AbiAJBBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 20:01:53 -0500
Received: by mail-oo1-f45.google.com with SMTP id l10-20020a4a840a000000b002dc09752694so3200077oog.12;
        Sun, 09 Jan 2022 17:01:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KWpmkjiUIyUY2lA1KsnFQOkJyry+8M6U0ghEbesXMkQ=;
        b=GzqxDmHEDhYbhMCrSkcw2r9W3O1TeFcusyMuyT/tDfzA/wl1eEzxMYWH9Wn2lCYMIo
         DBqL4uzEnajNzKHapsTseq7MQmK3yIIlEiVw2J2PhPqKI6LjoEPLyCpvPhhup2DDdKEP
         cVKusDBQCl9fc3evEahB9gOTMWD5tUf5TExa2Ah51FxigLl3SU+G2ovgJbniBiqFduWr
         Kd50YKck4GuOE2OO8hkzd1/6h3YppvtI5IODsia59FjTEQ59CXDntzNiDr63NXLGxlN0
         ZfnYP4b2r1niLkGC77fgmWw7uH93zkOejq/y1r3LSXCMzZIKL3oQne1swZvKrG/zwkMm
         Q/LA==
X-Gm-Message-State: AOAM532uGrqaX/c0Cbt7TjVUum3XSagAThwby9eNq5RC8yeq754R9/N5
        kUyPse5Ox1yo3fSGLRTFXbkuZ8VjSQ==
X-Google-Smtp-Source: ABdhPJzSwu+MA9PPmYKot8/OcE6YcFe0MvStp77rt6t8Xs5z1by7C/Lg7ygERL0JMpiwW7ax1OAuIg==
X-Received: by 2002:a4a:2a1b:: with SMTP id k27mr46565083oof.97.1641776513030;
        Sun, 09 Jan 2022 17:01:53 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id k9sm1172261otp.71.2022.01.09.17.01.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jan 2022 17:01:52 -0800 (PST)
Received: (nullmailer pid 3955438 invoked by uid 1000);
        Mon, 10 Jan 2022 01:01:51 -0000
Date:   Sun, 9 Jan 2022 19:01:51 -0600
From:   Rob Herring <robh@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        devicetree@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jose Abreu <joabreu@synopsys.com>
Subject: Re: [PATCH] dt-bindings: net: snps,dwmac: Enable burst length
 properties for more compatibles
Message-ID: <YduFfyejCrjxqW4v@robh.at.kernel.org>
References: <20211206174147.2296770-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206174147.2296770-1-robh@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 06 Dec 2021 11:41:47 -0600, Rob Herring wrote:
> With 'unevaluatedProperties' support implemented, the properties
> 'snps,pbl', 'snps,txpbl', and 'snps,rxpbl' are not allowed in the
> examples for some of the DWMAC versions:
> 
> Documentation/devicetree/bindings/net/intel,dwmac-plat.example.dt.yaml: ethernet@3a000000: Unevaluated properties are not allowed ('snps,pbl', 'mdio0' were unexpected)
> Documentation/devicetree/bindings/net/stm32-dwmac.example.dt.yaml: ethernet@5800a000: Unevaluated properties are not allowed ('reg-names', 'snps,pbl' were unexpected)
> Documentation/devicetree/bindings/net/stm32-dwmac.example.dt.yaml: ethernet@40028000: Unevaluated properties are not allowed ('reg-names', 'snps,pbl' were unexpected)
> Documentation/devicetree/bindings/net/stm32-dwmac.example.dt.yaml: ethernet@40027000: Unevaluated properties are not allowed ('reg-names', 'snps,pbl' were unexpected)
> Documentation/devicetree/bindings/net/toshiba,visconti-dwmac.example.dt.yaml: ethernet@28000000: Unevaluated properties are not allowed ('snps,txpbl', 'snps,rxpbl', 'mdio0' were unexpected)
> 
> This appears to be an oversight, so fix it by allowing the properties
> on the v3.50a, v4.10a, and v4.20a versions of the DWMAC.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
> Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> Cc: Jose Abreu <joabreu@synopsys.com>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  Documentation/devicetree/bindings/net/snps,dwmac.yaml | 3 +++
>  1 file changed, 3 insertions(+)
> 

Applied, thanks!

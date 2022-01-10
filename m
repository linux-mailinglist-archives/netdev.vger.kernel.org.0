Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49C4848966C
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 11:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244021AbiAJKdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 05:33:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243970AbiAJKdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 05:33:21 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E81BC061757
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 02:33:21 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id k18so25775846wrg.11
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 02:33:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Ux09BdvBfy5otBeH83si9wqeKjp8gHNJ9Zt3Er9zFxE=;
        b=uXYTgRqNTmPW/huo6KEYGPOM4ISUhPLQBff/OQu1mryKVB8bfEA9SMGpAzs8WENMSr
         fuyNQuevmAkNaM1DIBs9B5ePOxvg6kIQUNCfH4GFaXO0BAGjC6GgZqB5Fa+1alU087Z8
         P+Vm7f+/pCXvExKs6et7iTpYsEWdwEv98+Oj1Ut/3CLURBSYQn8BBRcI2i4huO0Nyhig
         jAh0PzBKkTaun4SPlD9rbsylUIDBnG5CqjHmWput0432gybnuR4m4QvkFs0RSDDvlb27
         XDCH8P8FAS/PXCOIbQZcLNaqtzSULbKkPi6r/pLPsz//6OCjXG/9tpB7zbwtR5B9wtSf
         7hog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Ux09BdvBfy5otBeH83si9wqeKjp8gHNJ9Zt3Er9zFxE=;
        b=aUztawsayWWzXJGKf82h0eFgytCRl53iQ80AHOjcCgQTmf3XWcm5Gytotw8k3Jh62F
         n1wtrSpkLboOQznOQW/P9E62NFVtTiobjJJWbXpVjMDfe37gFoIzMXE/WdUpCq2gIqNH
         aM7IGzf+p5/y4flA5ncwooiC1u/zitE4cX+LhrgPCRD98glsOvWfyvvJUeQ8lKc6//jQ
         AIj9Eh7Df9UhzyVRRRZ1ylX8coKWuZ99qAVZILrKVCfFhIN78McZETDTnI5nouT05RZN
         6wbni+q1zwpNutOsVhjhBopvzKHfeHiGjd7I90JUzD6JnEKkFh5J/kJs5nVkMwLBeOXg
         E37Q==
X-Gm-Message-State: AOAM531ilV4Hv97EFXFu7yJVuQJyJEWCkUjQh6JekXWuU/wArD4h1I0f
        7rvEABkUXOWSqeeAE1eF1i5RWQ==
X-Google-Smtp-Source: ABdhPJzMfF4X4m8rqBSMupPmJ6wMSv1HcNXmy8LWfHPif6guaPAHOVr+QYANksWrPaZREcLyZVwvuQ==
X-Received: by 2002:a5d:6d06:: with SMTP id e6mr63672846wrq.273.1641810799760;
        Mon, 10 Jan 2022 02:33:19 -0800 (PST)
Received: from google.com ([31.124.24.179])
        by smtp.gmail.com with ESMTPSA id ba18sm6324269wrb.40.2022.01.10.02.33.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 02:33:19 -0800 (PST)
Date:   Mon, 10 Jan 2022 10:33:23 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Rob Herring <robh@kernel.org>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Greentime Hu <greentime.hu@sifive.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Suman Anna <s-anna@ti.com>, - <patches@opensource.cirrus.com>,
        John Crispin <john@phrozen.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Kumar Gogada <bharat.kumar.gogada@xilinx.com>,
        linux-gpio@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: Re: [PATCH] dt-bindings: Drop required 'interrupt-parent'
Message-ID: <YdwLc2ZTERBoXgxR@google.com>
References: <20220107031905.2406176-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220107031905.2406176-1-robh@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 06 Jan 2022, Rob Herring wrote:

> 'interrupt-parent' is never required as it can be in a parent node or a
> parent node itself can be an interrupt provider. Where exactly it lives is
> outside the scope of a binding schema.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  .../devicetree/bindings/gpio/toshiba,gpio-visconti.yaml  | 1 -
>  .../devicetree/bindings/mailbox/ti,omap-mailbox.yaml     | 9 ---------
>  Documentation/devicetree/bindings/mfd/cirrus,madera.yaml | 1 -

Acked-by: Lee Jones <lee.jones@linaro.org>

>  .../devicetree/bindings/net/lantiq,etop-xway.yaml        | 1 -
>  .../devicetree/bindings/net/lantiq,xrx200-net.yaml       | 1 -
>  .../devicetree/bindings/pci/sifive,fu740-pcie.yaml       | 1 -
>  .../devicetree/bindings/pci/xilinx-versal-cpm.yaml       | 1 -
>  7 files changed, 15 deletions(-)

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog

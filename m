Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 738DA3C3683
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 21:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbhGJTuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 15:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbhGJTup (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Jul 2021 15:50:45 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E398C0613DD;
        Sat, 10 Jul 2021 12:47:59 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id nd37so23751952ejc.3;
        Sat, 10 Jul 2021 12:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9VoCeaEveZ8HDe5aNV8uZi+sK3K1wmWPsEr1ebKlPbg=;
        b=soTJB/WZ3yC4A3ZZUqTTnXY4RAsi4uTxd+Dxzzrt6yPovDI0d1/fImpIvxOLKpq3k0
         qS4l0p+f091oPUlwbEKEW9eb0Nbv3xcGaTUhF4b1uoDppeG3iKx14tGn3F2WjN7vxPiY
         +4oDtOD2iUeoxelkxb0yRtKOSLUvTZZbuc3FJMrHs7YJ54jjeR53rAMNfLGUrRxjUaay
         kA7Yz++t9UyUzCKWDGhXhnZ//PkInMKjVm6BPpDLOzGlZBiYtQyc/13frPspfU3bSFbs
         IZtpBLCB7PrSkT7uQeqY4DLhwIsd2Av9WynYixnnxzPkuZL753+YQBy5VaLmvFTs8w2/
         GwJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9VoCeaEveZ8HDe5aNV8uZi+sK3K1wmWPsEr1ebKlPbg=;
        b=e5j4Hn5eXN8NNJ6d1bOJ1n8QI108WrufqvWc7wJ+FWDaX0bDUX43LgVPO/1rupS3P5
         Y+Z2v37+lP98tj4PZqj3O2ny/U0JQ3hX8jEtRaUj0/f0vCrUCqd4wOnL5PfeYS8JULo0
         vOsdfC5VkUAP3xQMmxuzlGmUFedZ/6BfVDjOOZgMkKZQH3xxHB/rJvtM2SwtbUSq1UGi
         NMzXAXu7E8Jf6DNM9Q0AYhbPERY/qxFKToyowOjeyjPJNWeA2/ZJaN3vrUfiK3VIJjiO
         9Qxp/9iarM+uCv4+SeDMuW3h2y4Y7fJlDifOU0i5uUqgjnrqiQd2a2br3zg6h/vNXkbc
         czew==
X-Gm-Message-State: AOAM531ds/G63uIhH1Kld2W9mITWmpg15n6lyhr8Tf+l6BKG+2y8/jqQ
        7oKzGeD1Jm/u4sPKwX0FhDM=
X-Google-Smtp-Source: ABdhPJxhJyZ7sNMI7im3tLUUdqajn+gq3RTGfSBL3ice3P1cDERLnWXEEJGj3pV0WClWpbzCEnp/8Q==
X-Received: by 2002:a17:907:990d:: with SMTP id ka13mr45353356ejc.392.1625946477480;
        Sat, 10 Jul 2021 12:47:57 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id n10sm5155152edw.70.2021.07.10.12.47.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jul 2021 12:47:57 -0700 (PDT)
Date:   Sat, 10 Jul 2021 22:47:55 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 net-next 0/8] Add support for VSC7511-7514 chips
 over SPI
Message-ID: <20210710194755.xmt5jnaanh45dmlm@skbuf>
References: <20210710192602.2186370-1-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210710192602.2186370-1-colin.foster@in-advantage.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 10, 2021 at 12:25:54PM -0700, Colin Foster wrote:
> 1. The first probe of the internal MDIO bus fails. I suspect this is related to
> power supplies / grounding issues that would not appear on standard hardware.

Where and with what error code does it fail exactly? I don't understand
the concept of "the first probe"? You mean that there is an
-EPROBE_DEFER and it tries again immediately afterwards? Or you need to
unbind and rebind the driver to the device, or what?

> 2. Communication to the CPU bus doesn't seem to function properly. I suspect
> this is due to the fact that ocelot / felix assumes it is using the built-in CPU
> / NPI port for forwarding, though I am not positive.

What is the CPU bus and what doesn't function properly about it?

> Nonetheless, these two issues likely won't require a large architecture change,
> and perhaps those who know much more about the ocelot chips than I could chime
> in.

I guess you don't know if that's the case or not until you know what the
problem is...

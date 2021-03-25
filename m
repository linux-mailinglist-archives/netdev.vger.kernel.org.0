Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6E73492FB
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 14:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhCYNT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 09:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbhCYNTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 09:19:32 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2006C06174A;
        Thu, 25 Mar 2021 06:19:31 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id o16so2316986wrn.0;
        Thu, 25 Mar 2021 06:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yM+7txaY3YaPXxI4ZrWQxkRlDAfwRXr5c8eBWKInYrQ=;
        b=Y/6H+C9Ccxwfb26nyliwjTZ6wUHcKjA6cY1a3ELSQhduNGnkbMLX/s4ClGf9azMDvM
         6w6eVC2vqUKf4I3eQ6rzw9UWM2mi+t4bjUcyLA19m/UJNNXsumxyi8hNGJBzs43yybMd
         Fdcmu6BgPrv0gxs7sEeUGbTYibJnISr0doSjtzLX+0Z1BsXwuWZPP2epdzG/herOodI+
         D5lotveJ9EBPGljf/Hujdzg1m8S9pEEZYKmJSwNWKySB8WiDR+gD+2Obk9J6aXZUHipA
         ePBprKPtmEooD/mf4l8Rjh4kerm70pFEfQGRxkeZO1PuSAEo+SHxEUKYv/n1ZZ/HqWme
         VpWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yM+7txaY3YaPXxI4ZrWQxkRlDAfwRXr5c8eBWKInYrQ=;
        b=EtNPzCScRqxFL1QbfX9DQ3MRk2lwvJLBygkZb8SKAoQYkj+9e5rYFPyYYTwxKyBnAO
         ZprxmDZe2X55owfyVqhEOS0LDas8SorwSkGac48ciAmvxmrqllE6Gr5Add9sHKsvKHg7
         ngTD+D0e+HAdyEKrkRpjGFhjmRrRFAuGSrpSwYyVNVrYYrEM0bfozOwPNq5dnqra8p61
         w9vSdMpftrCBb4jv3Kdff7KrdgffER6tTxg/kb2YCRKAtHNzJmrCDXP2QKEIFs2hbO9d
         J5FRHIlRxZhKzIOms8fvDrgdeMGCWgt6tzGNOiyuDhyoEMrbrDjcp6lWTZfLCVjfHTsS
         6Yzg==
X-Gm-Message-State: AOAM530DuBpDk/wzil6x1BhtfvU0OLgRqn9HNKzG0PqNygHzwpserbHI
        ZX1Bmyd2HPbboKnre74O1GU=
X-Google-Smtp-Source: ABdhPJxgNiEwF1vncF6OavhaphzdsDVLGyJbTMXInPwidHzU7AfICxxIUG2+OLej1IihRS+1fGzRUQ==
X-Received: by 2002:adf:f743:: with SMTP id z3mr9037377wrp.304.1616678370546;
        Thu, 25 Mar 2021 06:19:30 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f1f:bb00:ec1d:f023:8a26:fc6b? (p200300ea8f1fbb00ec1df0238a26fc6b.dip0.t-ipconnect.de. [2003:ea:8f1f:bb00:ec1d:f023:8a26:fc6b])
        by smtp.googlemail.com with ESMTPSA id q19sm6298427wmc.44.2021.03.25.06.19.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Mar 2021 06:19:30 -0700 (PDT)
To:     Anand Moon <linux.amoon@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org
References: <20210325124225.2760-1-linux.amoon@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCHv1 0/6] Amlogic Soc - Add missing ethernet mdio compatible
 string
Message-ID: <4ce8997b-9f20-2c77-2d75-93e038eec6d8@gmail.com>
Date:   Thu, 25 Mar 2021 14:19:23 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210325124225.2760-1-linux.amoon@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.03.2021 13:42, Anand Moon wrote:
> On most of the Amlogic SoC I observed that Ethernet would not get
> initialize when try to deploy the mainline kernel, earlier I tried to
> fix this issue with by setting ethernet reset but it did not resolve
> the issue see below.
> 	resets = <&reset RESET_ETHERNET>;
> 	reset-names = "stmmaceth";
> 
> After checking what was the missing with Rockchip SoC dts
> I tried to add this missing compatible string and then it
> started to working on my setup.
> 
> Also I tried to fix the device tree binding to validate the changes.
> 
> Tested this on my Odroid-N2 and Odroid-C2 (64 bit) setup.
> I do not have ready Odroid C1 (32 bit) setup so please somebody test.
> 

When working on the Odroid-C2 I did not have such a problem.
And if you look at of_mdiobus_child_is_phy() and
of_mdiobus_register_phy() you'll see that your change shouldn't be
needed.

Could you please elaborate on:
- What is the exact problem you're facing? Best add a dmesg log.
- Which kernel version are you using?


> Best Regards
> -Anand
> 
> Anand Moon (6):
>   dt-bindings: net: ethernet-phy: Fix the parsing of ethernet-phy
>     compatible string
>   arm: dts: meson: Add missing ethernet phy mdio compatible string
>   arm64: dts: meson-gxbb: Add missing ethernet phy mimo compatible
>     string
>   arm64: dts: meson-gxl: Add missing ethernet phy mdio compatible string
>   arm64: dts: meson-g12: Add missing ethernet phy mdio compatible string
>   arm64: dts: meson-glx: Fix the ethernet phy mdio compatible string
> 
>  Documentation/devicetree/bindings/net/ethernet-phy.yaml | 6 +++---
>  arch/arm/boot/dts/meson8b-ec100.dts                     | 1 +
>  arch/arm/boot/dts/meson8b-mxq.dts                       | 1 +
>  arch/arm/boot/dts/meson8b-odroidc1.dts                  | 1 +
>  arch/arm/boot/dts/meson8m2-mxiii-plus.dts               | 1 +
>  arch/arm64/boot/dts/amlogic/meson-axg-s400.dts          | 1 +
>  arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dts      | 1 +
>  arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dtsi   | 3 ++-
>  arch/arm64/boot/dts/amlogic/meson-g12b-w400.dtsi        | 1 +
>  arch/arm64/boot/dts/amlogic/meson-gx-libretech-pc.dtsi  | 1 +
>  arch/arm64/boot/dts/amlogic/meson-gxbb-kii-pro.dts      | 1 +
>  arch/arm64/boot/dts/amlogic/meson-gxbb-nanopi-k2.dts    | 1 +
>  arch/arm64/boot/dts/amlogic/meson-gxbb-nexbox-a95x.dts  | 1 +
>  arch/arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts     | 1 +
>  arch/arm64/boot/dts/amlogic/meson-gxbb-p200.dts         | 1 +
>  arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95.dtsi    | 1 +
>  arch/arm64/boot/dts/amlogic/meson-gxbb-wetek.dtsi       | 1 +
>  arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p230.dts    | 1 +
>  arch/arm64/boot/dts/amlogic/meson-gxl.dtsi              | 2 +-
>  arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dts   | 1 +
>  arch/arm64/boot/dts/amlogic/meson-gxm-nexbox-a1.dts     | 1 +
>  arch/arm64/boot/dts/amlogic/meson-gxm-q200.dts          | 1 +
>  arch/arm64/boot/dts/amlogic/meson-gxm-rbox-pro.dts      | 1 +
>  arch/arm64/boot/dts/amlogic/meson-gxm-vega-s96.dts      | 1 +
>  arch/arm64/boot/dts/amlogic/meson-khadas-vim3.dtsi      | 1 +
>  arch/arm64/boot/dts/amlogic/meson-sm1-odroid.dtsi       | 1 +
>  26 files changed, 29 insertions(+), 5 deletions(-)
> 


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8DFA2976D2
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 20:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1754598AbgJWSV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 14:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750611AbgJWSVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 14:21:55 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74839C0613CE;
        Fri, 23 Oct 2020 11:21:55 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id h2so1344046pll.11;
        Fri, 23 Oct 2020 11:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DhJ2M9etE05g9DAQn74dGP4ADoN0HRdR9kAVpceJW1k=;
        b=icdOmlayutfegPWtHkHoQY6Hr8UxDj6zRe4vkAtEZQ4m1ieIiCb60V96j8jZ+9U5W3
         /A702KPQV1FZiKX2fuMANZhVOSKnPpLOKfjt1/Hs1SZUSOqYhwraO7sed09JBvpmQTGi
         eqVpJ7zTHgEc8F3h5+eDjKR3rdWiu7bQl/aU2SHP+50lmmE+mqi7OwOQxDRJ24nxUusG
         do2AYoe86SBd0yUbQIwpZsCzva7xyHopxQs7MzCPT5fMn17YbnH4qzvhHY/ZoQjs1ENV
         XgtwowSFYiQ4fxaNrbb205ItVe8sH9WdUgHd0IR4Fo+oT8z/mXjaRU/k0VbyPYqB7GLp
         ZhxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=DhJ2M9etE05g9DAQn74dGP4ADoN0HRdR9kAVpceJW1k=;
        b=VjvPyK2uAxtzUs9Ejnv0iMLMcAw7ZoL8ACw4yJkixymH3KekJENdoSgZlKfYH05elY
         1eO0ti588DwdZ0HxC+sajqW9xxc8oUgV/3I9tixq3YbowNBcl64nZ6hFMCD40cjR7lgO
         cC/eszMXPGujzGeHwBTErCWckFoX3B3prEcZulPa8OtjLoy+SQsOAibbtPZF1BXH622f
         rZNrhcJAHkC+Oou8gzymRVNhrVL1eGL26KoFmX7BqfuAIasUAreKpGLaN0tb/04tfAN2
         gJBBNXm91yvt8qdWa+7Dvd0BLEIW6AWivCHW08T+vMvCxGRX55J+W0rb9Ez/NYW0xFuG
         mw8g==
X-Gm-Message-State: AOAM530En3aZ2zau4VhieiU5Ks1kFnWB5SxfZclkv4aAt5ZevZ1UVrIJ
        HdKx223qcVJkDYFVJvXoatc=
X-Google-Smtp-Source: ABdhPJy1XzMfYNd2QCT+9Ss1DEpdoJEPrtCgVx8Bq4QnkYsOb5bxDFEbc2MZnPYGr7H8KZtFTyPlrg==
X-Received: by 2002:a17:902:b113:b029:d3:c5c2:e667 with SMTP id q19-20020a170902b113b02900d3c5c2e667mr335497plr.35.1603477314809;
        Fri, 23 Oct 2020 11:21:54 -0700 (PDT)
Received: from [10.67.48.230] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id e4sm2513777pgg.37.2020.10.23.11.21.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Oct 2020 11:21:54 -0700 (PDT)
Subject: Re: [PATCH] RFC: net: phy: of phys probe/reset issue
To:     Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Sekhar Nori <nsekhar@ti.com>, linux-kernel@vger.kernel.org,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Roger Quadros <rogerq@ti.com>,
        Russell King <linux@armlinux.org.uk>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
References: <20201023174750.21356-1-grygorii.strashko@ti.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <450d262e-242c-77f1-9f06-e25943cc595c@gmail.com>
Date:   Fri, 23 Oct 2020 11:21:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201023174750.21356-1-grygorii.strashko@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/23/20 10:47 AM, Grygorii Strashko wrote:
> Hi All,
> 
> The main intention of this mail is to trigger discussion to find a proper
> solution. All code is hackish and based on v5.9.
> 
> Problem statement:
> 
> There is an issue observed with MDIO OF PHYs discover/reset sequence in
> case PHY has reset line with default state is (1).
> In this case, when Linux boots PHY is in reset and following code fails:
> 
> of_mdiobus_register()
> |- for_each_available_child_of_node(np, child)
>    |- of_mdiobus_register_phy
>       |- get_phy_device
>          |- get_phy_c22_id ---- > *fails as PHY is in reset*
>       ...
>       |- of_mdiobus_phy_device_register() --> can't be reached
> 
> The current PHY allows to specify PHY reset line for PHY:
> &mdio {
>         phy0: ethernet-phy@0 {
>                 reg = <0>;
>                 ti,rx-internal-delay = <DP83867_RGMIIDCTL_2_00_NS>;
>                 ti,fifo-depth = <DP83867_PHYCR_FIFO_DEPTH_4_B_NIB>;
> +               reset-gpios = <&pca9555 4 GPIO_ACTIVE_LOW>;
>                 ti,dp83867-rxctrl-strap-quirk;
>         };
>  };
> 
> But it doesn't help in this case, as PHY's reset code is initialized when
> PHY's mdio_device is registered, which, in turn, happens after
> get_phy_device() call (and get_phy_device() is failed).
> 
> of_mdiobus_phy_device_register()
>  |-phy_device_register
>    |-mdiobus_register_device()
>      |-mdiobus_register_gpiod(mdiodev);
>      |-mdiobus_register_reset(mdiodev);
> 
> There is also possibility to add GPIO reset line to MDIO node itself, but
> It also doesn't help when there are >1 PHY and every PHY has it own reset
> line.
> 
> Only one possible W/A now is to use GPIO HOG, with drawback that PHY will
> stay active always.
> 
> Some history:
> 
> - commit 69226896ad63 ("mdio_bus: Issue GPIO RESET to PHYs") from Roger
> Quadros <rogerq@ti.com> originally added possibility to specify >1 GPIO
> reset line in MDIO node, which allowed to solve such issues.
>  - commit 4c5e7a2c0501 ("dt-bindings: mdio: Clarify binding document") and
> follow up commit d396e84c5604 ("mdio_bus: handle only single PHY reset
> GPIO") rolled back original solution to only one GPIO reset line, which
> causes problems now.
> 
> Possible solutions I come up with:
>  1) Try to add PHY reset code around get_phy_device() call in of_mdiobus_register_phy()
>   cons:
>    - need to extract/share mdio_device reset code as PHY may have not only GPIO,
>      but also reset_control object assigned.
>      And all current mdio_device rest code expected to have mdio_device already initialized.
>    - There 12 calls to get_phy_device() in v5.9 Kernel
>  2) Try to consolidate OF mdio_device/PHY initialization in one place, as
> illustrated by of_phy_device_create() function (marked by "// option 2" in
> code).
>  3) Return back possibility to use >1 GPIO reset line in MDIO node. Even if
> It seems right thing to do by itself (Devices attached to MDIO bus may have
> any combination of shared reset lines - not always "one for all"), there
> are more things to consider:
>    - PHY reset_control objects handling
>    - the fact that MDIO reset will put PHY out of reset and not allow to
>      reset it again (more like gpio-hog)
> 
> I'd be appreciated for any comments to help resolve it. May be there is
> better way to handle this?

Yes there is: have your Ethernet PHY compatible string be of the form
"ethernetAAAA.BBBB" and then there is no need for such hacking.
of_get_phy_id() will parse that compatible and that will trigger
of_mdiobus_register_phy() to take the phy_device_create() path.

The other advantage I see to the explicit PHY ID in compatible string
approach is that it is easier to scale to other bus subsystems that have
similar requirements like PCI, USB, SPI, I2C etc.

Your solution is not inelegant in that you took care of parsing the
Ethernet PHY (child) device_node, however I see two problems with it:

- it deals only with reset, but there are other essential resources such
as clocks and regulators that would need an equivalent treatment. While
the CLK API has support for device_node references, the regulator API
does not AFAICT.

0 in a world where we move towards supporting ACPI (there is work in
progress on this). We would need a solution that scales to both
"firmware" implementations and using APIs that expect a device_node
reference does not really make that possible. You could argue that the
solution I am offering is currently OF centric and that is true, however
it is easily extensible to ACPI as well (if the ACPI folks and kernel
developers manage to settle on what an appropriate representation for
MDIO/PHY/SFPs looks like).

Since I am officially no longer a PHY library maintainer, you would need
someone more authoritative to weigh in the approach you have taken.
-- 
Florian

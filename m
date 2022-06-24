Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7307955A3D7
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 23:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbiFXVng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 17:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231437AbiFXVnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 17:43:35 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2082E47AF9;
        Fri, 24 Jun 2022 14:43:34 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id e40so5236537eda.2;
        Fri, 24 Jun 2022 14:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=rIPSikCgCozwD8cY/gDO4W9S61J9jcsGKVD8+FXmORA=;
        b=ccAsiIxCfFwhzQdKBR570jMO06NZ7vSGDBiGhQY9esd9nia/dQ695xXpblvX5DBlgR
         YU7IHCnsUllQ5Mfng5ucfa5fZIxx11JPB57pFqPg8UnOXPUvGd8CCLmPc5r1mPK/a5vO
         PDc99p9BgkznLpFrkFYj/vW5iNcEw8bNG6tnXR1hyM4jrIcKkxhBGhsBHuriEuXIitgx
         klvJv+Et90ZPTNXQTleLmFRliedSUo+fpqMtRvrRz4gv8lbyD+VhEXCwXDQv0x/iYein
         CbPX41V3zXDgenw6Wk20u1I/qoNFdfx/nJdASJ8KFqRjJE5jYsfGu/kg8Nn8Dqltk2M7
         U5Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=rIPSikCgCozwD8cY/gDO4W9S61J9jcsGKVD8+FXmORA=;
        b=SIipVmcNvDnW9/xc5gw6x1YK3JiFH85LTLzZvDrTiKZTwmQbAhYWED69AQShMmURmB
         4L9MrdSMHvg34KL5mNtR0QkYR4BGp12LJNhGI0KEWEhvY87Ki6libC7uB1BJcfwmfSy5
         oG5jzHXyU+32kyfRmVoPD9U8f+OEom4YHoPrsE5Twu2uY5yPMoFHvK9GdZXZA/DokNhw
         NwSxRAIqyj9Z7dWGTORabCoVydb7IP7GTq8Xh7QpNhCKUQERtX1I/j1FUAxHMPqOZbss
         AFBDqEoJdr0XcNfEZfYagRRmm6wkqxR/ezx63/WFvcx7gzXzDi01QQ516zuAxgiXlTwV
         eBzA==
X-Gm-Message-State: AJIora/RtlAACTAAWjNdmY/MuyVghDD+l/dK1o9I0PW6VQoP851vaRXc
        q7DWUuUZAjMaDCbtaM8+W9U=
X-Google-Smtp-Source: AGRyM1s4ghk80L2wpQWZoG7dffSE0yVM8u3MwZeKPNhRAj17XcTleK6+OmEiBde6brVHC7GcJZxwYw==
X-Received: by 2002:a05:6402:5254:b0:435:bc97:e300 with SMTP id t20-20020a056402525400b00435bc97e300mr1486211edd.65.1656107012714;
        Fri, 24 Jun 2022 14:43:32 -0700 (PDT)
Received: from skbuf ([188.27.185.253])
        by smtp.gmail.com with ESMTPSA id m7-20020a056402050700b004356c0d7436sm2870117edv.42.2022.06.24.14.43.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 14:43:32 -0700 (PDT)
Date:   Sat, 25 Jun 2022 00:43:30 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?utf-8?Q?Miqu=C3=A8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v9 00/16] add support for Renesas RZ/N1 ethernet
 subsystem devices
Message-ID: <20220624214330.aezwdsirjvvoha45@skbuf>
References: <20220624144001.95518-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220624144001.95518-1-clement.leger@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 24, 2022 at 04:39:45PM +0200, Clément Léger wrote:
> The Renesas RZ/N1 SoCs features an ethernet subsystem which contains
> (most notably) a switch, two GMACs, and a MII converter [1]. This
> series adds support for the switch and the MII converter.
> 
> The MII converter present on this SoC has been represented as a PCS
> which sit between the MACs and the PHY. This PCS driver is probed from
> the device-tree since it requires to be configured. Indeed the MII
> converter also contains the registers that are handling the muxing of
> ports (Switch, MAC, HSR, RTOS, etc) internally to the SoC.
> 
> The switch driver is based on DSA and exposes 4 ports + 1 CPU
> management port. It include basic bridging support as well as FDB and
> statistics support.
> 
> Link: [1] https://www.renesas.com/us/en/document/mah/rzn1d-group-rzn1s-group-rzn1l-group-users-manual-r-engine-and-ethernet-peripherals
> 
> -----
> Changes in V9:
> - Cover letter:
>   - Remove comment about RZN1 patches that are now in the master branch.
> - Commits:
>   - Add Vladimir Oltean Reviewed-by
> - PCS:
>   - Add "Depends on OF" for PCS_RZN1_MIIC due to error found by intel
>     kernel test robot <lkp@intel.com>.
>   - Check return value of of_property_read_u32() for
>     "renesas,miic-switch-portin" property before setting conf.
>   - Return miic_parse_dt() return value in miic_probe() on error
> - Switch:
>   - Add "Depends on OF" for NET_DSA_RZN1_A5PSW due to errors found by
>     intel kernel test robot <lkp@intel.com>.
> - DT:
>   - Add spaces between switch port and '{'

I took one more look through the series and this looks good, thanks.

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

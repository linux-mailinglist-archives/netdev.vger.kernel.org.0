Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B28F2B0469
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 12:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728298AbgKLLx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 06:53:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:54674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728247AbgKLLxc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 06:53:32 -0500
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 670A922228;
        Thu, 12 Nov 2020 11:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605182011;
        bh=StUZENy+EqpA+v5bMTo8klXuvmlElJqapUnjCI4L0FI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=amtd+lbLS9WC8iApliLmMWZ1Qf1MuZA52rP/yrEjsWbrvzVAiQ/o2Wq7PCHBGHlCL
         3E7bZDuicVbOmgutSHqisGc7Nn+eIEqp3ahyFCw2B13/QGi0go1tHSSQNfe500wMnF
         9bn90zCIl4DiKp/RRas8eIXrUk6q+KxmhztKyH7Q=
Received: by mail-ej1-f45.google.com with SMTP id cw8so7271519ejb.8;
        Thu, 12 Nov 2020 03:53:31 -0800 (PST)
X-Gm-Message-State: AOAM531v9fFC/5nBgvvRwlA7ase6zMnf1aXp4oV+R816vYqrdEE41/7n
        a34ssAa6yijs1dHCIhioz2vjH0nw/SvJ9XEdWPA=
X-Google-Smtp-Source: ABdhPJwpu3Qzv0aVpWz0TpMkSYylnZML4PSBTVDNybtAlg8bUufujwuSXvcMDt8/roomQlOeRRweOPWtpYSkoXboybg=
X-Received: by 2002:a17:907:d1e:: with SMTP id gn30mr31142306ejc.148.1605182009793;
 Thu, 12 Nov 2020 03:53:29 -0800 (PST)
MIME-Version: 1.0
References: <CGME20201112115107eucas1p1abe7589e6caffc579c22d39395f1efa0@eucas1p1.samsung.com>
 <20201112115106.16224-1-l.stelmach@samsung.com>
In-Reply-To: <20201112115106.16224-1-l.stelmach@samsung.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Thu, 12 Nov 2020 12:53:17 +0100
X-Gmail-Original-Message-ID: <CAJKOXPeAwUG4fRxb5KANg90SLAmJ27dj9fO5e2nWrbVGqpzRFg@mail.gmail.com>
Message-ID: <CAJKOXPeAwUG4fRxb5KANg90SLAmJ27dj9fO5e2nWrbVGqpzRFg@mail.gmail.com>
Subject: Re: [PATCH v6 0/5] AX88796C SPI Ethernet Adapter
To:     =?UTF-8?Q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, jim.cromie@gmail.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>,
        =?UTF-8?Q?Bart=C5=82omiej_=C5=BBolnierkiewicz?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 at 12:51, =C5=81ukasz Stelmach <l.stelmach@samsung.com>=
 wrote:
>
> This is a driver for AX88796C Ethernet Adapter connected in SPI mode as
> found on ARTIK5 evaluation board. The driver has been ported from a
> v3.10.9 vendor kernel for ARTIK5 board.
>
> Changes in v6:
>   - fixed typos in Kconfig
>   - checked argument value in ax88796c_set_tunable
>   - updated tags in commit messages
>
> Changes in v5:
>   - coding style (local variable declarations)
>   - added spi0 node in the DT binding example and removed
>     interrupt-parent
>   - removed comp module parameter
>   - added CONFIG_SPI_AX88796C_COMPRESSION option to set the initial
>     state of SPI compression
>   - introduced new ethtool tunable "spi-compression" to controll SPI
>     transfer compression
>   - removed unused fields in struct ax88796c_device
>   - switched from using buffers allocated on stack for SPI transfers
>     to DMA safe ones embedded in struct ax_spi and allocated with
>     kmalloc()
>
> Changes in v4:
>   - fixed compilation problems in asix,ax88796c.yaml and in
>   ax88796c_main.c introduced in v3
>
> Changes in v3:
>   - modify vendor-prefixes.yaml in a separate patch
>   - fix several problems in the dt binding
>     - removed unnecessary descriptions and properties
>     - changed the order of entries
>     - fixed problems with missing defines in the example
>   - change (1 << N) to BIT(N), left a few (0 << N)
>   - replace ax88796c_get_link(), ax88796c_get_link_ksettings(),
>     ax88796c_set_link_ksettings(), ax88796c_nway_reset(),
>     ax88796c_set_mac_address() with appropriate kernel functions.
>   - disable PHY auto-polling in MAC and use PHYLIB to track the state
>     of PHY and configure MAC
>   - propagate return values instead of returning constants in several
>     places
>   - add WARN_ON() for unlocked mutex
>   - remove local work queue and use the system_wq
>   - replace phy_connect_direct() with phy_connect() and move
>     devm_register_netdev() to the end of ax88796c_probe()
>     (Unlike phy_connect_direct() phy_connect() does not crash if the
>     network device isn't registered yet.)
>   - remove error messages on ENOMEM
>   - move free_irq() to the end of ax88796c_close() to avoid race
>     condition
>   - implement flow-control
>
> Changes in v2:
>   - use phylib
>   - added DT bindings
>   - moved #includes to *.c files
>   - used mutex instead of a semaphore for locking
>   - renamed some constants
>   - added error propagation for several functions
>   - used ethtool for dumping registers
>   - added control over checksum offloading
>   - remove vendor specific PM
>   - removed macaddr module parameter and added support for reading a MAC
>     address from platform data (e.g. DT)
>   - removed dependency on SPI from NET_VENDOR_ASIX
>   - added an entry in the MAINTAINERS file
>   - simplified logging with appropriate netif_* and netdev_* helpers
>   - lots of style fixes
>
> =C5=81ukasz Stelmach (5):
>   dt-bindings: vendor-prefixes: Add asix prefix
>   dt-bindings: net: Add bindings for AX88796C SPI Ethernet Adapter
>   net: ax88796c: ASIX AX88796C SPI Ethernet Adapter Driver
>   ARM: dts: exynos: Add Ethernet to Artik 5 board
>   ARM: defconfig: Enable ax88796c driver

Please don't send patches which were applied. It confuses everyone and
could cause double-applying through different tree.

Best regards,
Krzysztof

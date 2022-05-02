Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD254517037
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 15:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235383AbiEBN10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 09:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231477AbiEBN1Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 09:27:25 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C9EE10FD5;
        Mon,  2 May 2022 06:23:53 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id a15-20020a17090ad80f00b001dc2e23ad84so4114038pjv.4;
        Mon, 02 May 2022 06:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=BcnUXZZNeIgPM3jDnRqr16Lhe4Q17iMrfxOnue80pmo=;
        b=P8RYjY8IdTpemn0mW+H76/VggJPGQeDixJnUQn8d+Y/yzZZqOZvjWVOzjvhXTBhq0F
         D/lBp8Jdb63Xqrmrstk0m4aQDN6uGqESqSIXFmPevsh0nQohzHoLxta9cMXA8pG3fl7q
         yzrI8vr4gMqUTBpatsHkKXbPN71kwyui6i3WPLi3x9KmDuy8UbSMrSWFayYTNEjn21Af
         qBf6Dwzi58k9stSEczKQMe07eO0YUQ+jW2TYQWEw1uorFjQIzEPk2Wt1FTmsEcDc43fM
         lW59WD5L/4owtBSYW1rrNWZ+Ftso/98a2gFDoCdonwGv5THGkZ45oiYC5wM2mM98bopm
         G68Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=BcnUXZZNeIgPM3jDnRqr16Lhe4Q17iMrfxOnue80pmo=;
        b=S5SyWI8UsyS5kyQKvI2b/nC/Q+ei9VMSK0kM+GWy0T+wmF29uA5uDyzi/rsABYInvm
         sQg6q44IUnvUS3sbmsszxIlVIAGRxj7L/9fwzW0Riy7ioD9tPklHKmdo4fTQ5Snv0Fsg
         dU9KMcm/dJ9BeUVNk0cG+lVw9FAETvzHlvK7VQ2HcMNknGiLKBDZUUH2TWal9mnJuaHn
         UxRg31A+f6n/8JQ9dlOmucoc/15tjrZfyhG4TZFDLxoPZg0aXZLN1b7mUbDDQqpSP/5z
         WzckXa4VsgDmWBS4PQXwAcWG0L2FuE3WC/wW2wSpnEbcgn2tgNbKKn4fTILXO3cOoPX3
         ucZg==
X-Gm-Message-State: AOAM531yBbdJ+QYGd6nT1AoaD8Hq5ClgRGuyfw4swM+niHjxaXBKvZq2
        d9q8xGgcIMAw1geZ2kSLvj3bixv3VE0ixQ==
X-Google-Smtp-Source: ABdhPJxWwrSAYD/A1KNYAnij2ANPC+T7EvfmpWZ+0EUrolZz+TENBzr/4frtJObv9aHBGMtx4PxLVQ==
X-Received: by 2002:a17:90a:7f94:b0:1cb:1853:da1b with SMTP id m20-20020a17090a7f9400b001cb1853da1bmr13065757pjl.14.1651497832840;
        Mon, 02 May 2022 06:23:52 -0700 (PDT)
Received: from scdiu3.sunplus.com ([113.196.136.192])
        by smtp.googlemail.com with ESMTPSA id e11-20020a62ee0b000000b0050dc762818bsm4676897pfi.101.2022.05.02.06.23.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 May 2022 06:23:52 -0700 (PDT)
From:   Wells Lu <wellslutw@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, p.zabel@pengutronix.de,
        pabeni@redhat.com, krzk+dt@kernel.org, roopa@nvidia.com,
        andrew@lunn.ch, edumazet@google.com
Cc:     wells.lu@sunplus.com, Wells Lu <wellslutw@gmail.com>
Subject: [PATCH net-next v10 0/2] This is a patch series for Ethernet driver of Sunplus SP7021 SoC.
Date:   Mon,  2 May 2022 21:23:36 +0800
Message-Id: <1651497818-25352-1-git-send-email-wellslutw@gmail.com>
X-Mailer: git-send-email 2.7.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sunplus SP7021 is an ARM Cortex A7 (4 cores) based SoC. It integrates
many peripherals (ex: UART, I2C, SPI, SDIO, eMMC, USB, SD card and
etc.) into a single chip. It is designed for industrial control
applications.

Refer to:
https://sunplus.atlassian.net/wiki/spaces/doc/overview
https://tibbo.com/store/plus1.html

Wells Lu (2):
  devicetree: bindings: net: Add bindings doc for Sunplus SP7021.
  net: ethernet: Add driver for Sunplus SP7021

 .../bindings/net/sunplus,sp7021-emac.yaml     | 141 +++++
 MAINTAINERS                                   |   8 +
 drivers/net/ethernet/Kconfig                  |   1 +
 drivers/net/ethernet/Makefile                 |   1 +
 drivers/net/ethernet/sunplus/Kconfig          |  35 ++
 drivers/net/ethernet/sunplus/Makefile         |   6 +
 drivers/net/ethernet/sunplus/spl2sw_define.h  | 270 ++++++++
 drivers/net/ethernet/sunplus/spl2sw_desc.c    | 228 +++++++
 drivers/net/ethernet/sunplus/spl2sw_desc.h    |  19 +
 drivers/net/ethernet/sunplus/spl2sw_driver.c  | 578 ++++++++++++++++++
 drivers/net/ethernet/sunplus/spl2sw_int.c     | 273 +++++++++
 drivers/net/ethernet/sunplus/spl2sw_int.h     |  13 +
 drivers/net/ethernet/sunplus/spl2sw_mac.c     | 274 +++++++++
 drivers/net/ethernet/sunplus/spl2sw_mac.h     |  18 +
 drivers/net/ethernet/sunplus/spl2sw_mdio.c    | 126 ++++
 drivers/net/ethernet/sunplus/spl2sw_mdio.h    |  12 +
 drivers/net/ethernet/sunplus/spl2sw_phy.c     |  92 +++
 drivers/net/ethernet/sunplus/spl2sw_phy.h     |  12 +
 .../net/ethernet/sunplus/spl2sw_register.h    |  86 +++
 19 files changed, 2193 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml
 create mode 100644 drivers/net/ethernet/sunplus/Kconfig
 create mode 100644 drivers/net/ethernet/sunplus/Makefile
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_define.h
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_desc.c
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_desc.h
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_driver.c
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_int.c
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_int.h
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_mac.c
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_mac.h
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_mdio.c
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_mdio.h
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_phy.c
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_phy.h
 create mode 100644 drivers/net/ethernet/sunplus/spl2sw_register.h

-- 
2.25.1


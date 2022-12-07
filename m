Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC78E644FE3
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 01:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbiLGAAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 19:00:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiLGAAu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 19:00:50 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61E251ADBF;
        Tue,  6 Dec 2022 16:00:49 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id z92so22720748ede.1;
        Tue, 06 Dec 2022 16:00:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zQ+9J6wl28AsagTlVgvAUH1ii/kD1nYUFQekk4fHWuw=;
        b=a8voM1F7EhGc4y30jJoOLPNSeihiSJx0v/hewqCjeHd6lbrMMgPAAV1GGkvLcNiX1/
         jx2kTz9UZkxVfnbpK7VY/tE7qqCtU4w+L/U3B8qP2aWRmFZPK7ud5YIkR3t/T6xuGNFk
         0Iqn99bqlCzKSIZuOSDTW09lUeKZ4PnagTnjKpm1Nrg+qYLQpFuGuBPUKiJpaitD4mHd
         YpYaVpUee/QxhJFB71fGSnUTT/DpJEYGOkZ61hx6CaUXHC37sc/3pUd43rn8VckPuVBY
         F/v+/QTUSjpmN0AI346CETbI8ONFjRhwBVGx/P7YM3ERhW34Y258BjVoyYjRJBpbOLcn
         aH0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zQ+9J6wl28AsagTlVgvAUH1ii/kD1nYUFQekk4fHWuw=;
        b=ydlx3Nysc8LJgH9q1QWxOIKSlboFn78z47KHOnV+aSdPzP/bzNF7Ohm7z2eCcPJQtf
         otbg25yw5n1tAbu2xKWgqEEZyiNUypo2Zq5JvW4TkkCaIU9C2v5VOVP8k3zi2hvOr6s2
         /xiA6xZC234NFfkLDRV04WGnWNM6j2ZbBr1lAlO4MjMHWP6V0ickvYf44c+EaJMhamMj
         A4Wr24UuQ5zGsN7UQQeW2k8q8LYUjNpxvIzA/1ozelS/EVw8TsxXf+k7X2MleH32QOom
         TuBh1Ad/dnTj7cKvTZEJNEJi1bYCQGutl6XFfWQqgaIbW+ZfELRuUTuY0xRvlj2zDyFs
         VHQQ==
X-Gm-Message-State: ANoB5pkN4X9F72y1pCPBBxBxqIH1czWlpnkexArnxDrnDI6ihsxDq9Xo
        R5foyMP0ABarAaOYyILiGp0=
X-Google-Smtp-Source: AA0mqf6ppNBePBpbvhmeRdeBIAhrxq9raZOjXe2cUHKVU9Uq5zfBm/vw+zQ3EsCzgWyQO/NuacR9Sg==
X-Received: by 2002:a05:6402:4504:b0:463:71ef:b9ce with SMTP id ez4-20020a056402450400b0046371efb9cemr7122876edb.75.1670371247702;
        Tue, 06 Dec 2022 16:00:47 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id ga18-20020a170906b85200b00781be3e7badsm7873939ejb.53.2022.12.06.16.00.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 16:00:47 -0800 (PST)
Date:   Wed, 7 Dec 2022 01:00:58 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: [PATCH v5 net-next 0/5] add PLCA RS support and onsemi NCN26000
Message-ID: <cover.1670371013.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds support for getting/setting the Physical Layer 
Collision Avoidace (PLCA) Reconciliation Sublayer (RS) configuration and
status on Ethernet PHYs that supports it.

PLCA is a feature that provides improved media-access performance in terms
of throughput, latency and fairness for multi-drop (P2MP) half-duplex PHYs.
PLCA is defined in Clause 148 of the IEEE802.3 specifications as amended
by 802.3cg-2019. Currently, PLCA is supported by the 10BASE-T1S single-pair
Ethernet PHY defined in the same standard and related amendments. The OPEN
Alliance SIG TC14 defines additional specifications for the 10BASE-T1S PHY,
including a standard register map for PHYs that embeds the PLCA RS (see
PLCA management registers at https://www.opensig.org/about/specifications/).

The changes proposed herein add the appropriate ethtool netlink interface
for configuring the PLCA RS on PHYs that supports it. A separate patchset
further modifies the ethtool userspace program to show and modify the
configuration/status of the PLCA RS.

Additionally, this patchset adds support for the onsemi NCN26000
Industrial Ethernet 10BASE-T1S PHY that uses the newly added PLCA
infrastructure.

Piergiorgio Beruto (5):
  net/ethtool: add netlink interface for the PLCA RS
  drivers/net/phy: add the link modes for the 10BASE-T1S Ethernet PHY
  drivers/net/phy: add connection between ethtool and phylib for PLCA
  drivers/net/phy: add helpers to get/set PLCA configuration
  drivers/net/phy: add driver for the onsemi NCN26000 10BASE-T1S PHY

 Documentation/networking/ethtool-netlink.rst | 133 +++++++++
 MAINTAINERS                                  |  14 +
 drivers/net/phy/Kconfig                      |   7 +
 drivers/net/phy/Makefile                     |   1 +
 drivers/net/phy/mdio-open-alliance.h         |  47 +++
 drivers/net/phy/ncn26000.c                   | 201 +++++++++++++
 drivers/net/phy/phy-c45.c                    | 183 ++++++++++++
 drivers/net/phy/phy-core.c                   |   5 +-
 drivers/net/phy/phy.c                        | 175 +++++++++++
 drivers/net/phy/phy_device.c                 |   3 +
 drivers/net/phy/phylink.c                    |   6 +-
 include/linux/ethtool.h                      |  11 +
 include/linux/phy.h                          |  81 ++++++
 include/uapi/linux/ethtool.h                 |   3 +
 include/uapi/linux/ethtool_netlink.h         |  25 ++
 net/ethtool/Makefile                         |   2 +-
 net/ethtool/common.c                         |   8 +
 net/ethtool/netlink.c                        |  29 ++
 net/ethtool/netlink.h                        |   6 +
 net/ethtool/plca.c                           | 290 +++++++++++++++++++
 20 files changed, 1227 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/phy/mdio-open-alliance.h
 create mode 100644 drivers/net/phy/ncn26000.c
 create mode 100644 net/ethtool/plca.c

-- 
2.35.1


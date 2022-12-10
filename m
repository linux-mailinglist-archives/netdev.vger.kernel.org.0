Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BBD4649114
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 23:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbiLJWpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 17:45:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiLJWpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 17:45:53 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6CD5644D;
        Sat, 10 Dec 2022 14:45:51 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id t17so19525416eju.1;
        Sat, 10 Dec 2022 14:45:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=45NKaKQKmH8Eot2nWO6w0/o2HQSVVna7KPFVEAGhZ5U=;
        b=PORNRolG8Ug31pin0wUNjgHTgAzP9xclPeAYQhE1sbGbKx/wjdQC2kdfKgxsKpdYhZ
         DXUm27zCASoXjsaZdddu6zqPS07NrUYkQc+nbMiJ02YUkMKdCMGz/2aR1YAArwCGhuyk
         Z9VwEurGaZJYHyLzcpVUS7gdKiBGkcaWwqlmDKfvjtBoVPqJtXJ3+hdzaXhK892cQhtj
         UyFtTmbl4ImRRAnHKfWAUJhOBx2GwYldyqu5kOItiRgyUAGfDNuwzobeKkyzJRJDm0v2
         rM27UUbz50MR4zm432oQKcr5L8haWN2b5SSa5SXrNJKJTg1UnkVcKlyV9UiJuqAquP5g
         o15A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=45NKaKQKmH8Eot2nWO6w0/o2HQSVVna7KPFVEAGhZ5U=;
        b=gxRgEYFr8ElfuHO69un0Zq/NPId59fifV5lFNpBtjIZfbH4sMi6wXFQdk5jkERaXb1
         8XQFmjqE3OnEcYy0Sl/ai4HEFejQfPIARP5My7PyJ5JrHGDca8U98i2Eci+hC8iSQwzl
         DRFr1w58Htl2hDP1okzC27bOWbL5XBJOtRhzh9NcBnNScFxGcjwnSvsFaXsr8BlYuDjd
         O5ZlWwImxvpXfWdu2zd3a9CBgmSOmwXW/JgpEjVJKGYzuoftQRzRR57M4jnJaEEB0s5B
         kYO/ZZUaVtwfIrC58l0W+5/B5dAesZ0LOAOYc9n72rvnN2HD/CKbeTcJrJM8N0XOgbMv
         sbXg==
X-Gm-Message-State: ANoB5pmLP2KdWSljpmQUEGsV7OjLEOdBfpLl2bZa0U/meDcp00YCwqsV
        1kfkwJBQtjvuNG42htSrj1c=
X-Google-Smtp-Source: AA0mqf7oL5iXizF4XTZqk+JjAcvyaWZ0oLSit7taumM3+EYurTepihQN+tSTG784L9WyYwyvn9+kmQ==
X-Received: by 2002:a17:906:9d9f:b0:7c0:f90e:e5b6 with SMTP id fq31-20020a1709069d9f00b007c0f90ee5b6mr7614100ejc.31.1670712350217;
        Sat, 10 Dec 2022 14:45:50 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id se17-20020a170907a39100b007bf988ce9f7sm1448730ejc.38.2022.12.10.14.45.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Dec 2022 14:45:49 -0800 (PST)
Date:   Sat, 10 Dec 2022 23:45:48 +0100
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
Subject: [PATCH v6 net-next 0/5] add PLCA RS support and onsemi NCN26000
Message-ID: <cover.1670712151.git.piergiorgio.beruto@gmail.com>
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

 Documentation/networking/ethtool-netlink.rst | 138 ++++++++++
 MAINTAINERS                                  |  14 +
 drivers/net/phy/Kconfig                      |   7 +
 drivers/net/phy/Makefile                     |   1 +
 drivers/net/phy/mdio-open-alliance.h         |  47 ++++
 drivers/net/phy/ncn26000.c                   | 171 ++++++++++++
 drivers/net/phy/phy-c45.c                    | 183 +++++++++++++
 drivers/net/phy/phy-core.c                   |   5 +-
 drivers/net/phy/phy.c                        | 175 ++++++++++++
 drivers/net/phy/phy_device.c                 |  17 ++
 drivers/net/phy/phylink.c                    |   6 +-
 include/linux/ethtool.h                      |  12 +
 include/linux/phy.h                          |  83 ++++++
 include/uapi/linux/ethtool.h                 |   3 +
 include/uapi/linux/ethtool_netlink.h         |  25 ++
 net/ethtool/Makefile                         |   2 +-
 net/ethtool/common.c                         |   8 +
 net/ethtool/netlink.c                        |  29 ++
 net/ethtool/netlink.h                        |   6 +
 net/ethtool/plca.c                           | 272 +++++++++++++++++++
 20 files changed, 1201 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/phy/mdio-open-alliance.h
 create mode 100644 drivers/net/phy/ncn26000.c
 create mode 100644 net/ethtool/plca.c

-- 
2.37.4


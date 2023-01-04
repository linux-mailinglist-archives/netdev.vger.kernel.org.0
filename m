Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E49F965D4F2
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 15:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239436AbjADOFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 09:05:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239430AbjADOFT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 09:05:19 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F81B1ADBB;
        Wed,  4 Jan 2023 06:05:18 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id tz12so82836302ejc.9;
        Wed, 04 Jan 2023 06:05:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=omjjaDP/LgtiwtMeTshwHRcoEfKVz88lQXr6vhpQX7U=;
        b=NRxTkCEHs+jUaIEdhc1YbJId89SvZp9B6wbB1x4tXPdqhkccLYlcFKe2MLxWTOfQ+R
         pLm+ZuOi4eqS3EuNZERb7uHMYVO/Pxkpv1kvPxNPelypMD0GQX3GjIYJ3wgkChDbrzP8
         cGVoHfIOg3VOVHuOQCgEvWkPA+8n2xy2WhSes+g8EETQ/x21MKst82sdk/h8E5qSIM5V
         PSMegNYP0V62Z/7k4R0lN+tFb0QCW5PmsFpHG8hHpkfmURToZ1zKL3TCk5sLnwluKA67
         ZOPaMYMSGAkCu+HsNY5tQVhhKQuDkK+MYIxEAKqW3TlPkrt1JxdO+MMaXqDNwUxqDoPa
         VcrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=omjjaDP/LgtiwtMeTshwHRcoEfKVz88lQXr6vhpQX7U=;
        b=esulOfsiHq/w8coXmSYmpRiMX9mbMwHfutRaV2kD/1qe6zDC30wSVihYvExZqkZSgS
         rlmFLnM5+3CitNCHhG9Nge0l73By96QkIZBNTyVNp8udQ4VjXfnXJPXH/pSrLtxWgvMI
         XGD49Vhb2vse4gUeokZrnbPmNZQPl0/qVMouotGvxPfQf6OijIoOhi5nc3Ff3C4sDEiC
         QspcCvsd0FcEq+8ry/JeJ48Ljcd5WHiLGJIFW5H1wn05veyr691Vjt9qzKAM3OesSpDl
         Xks+aE9nxv+wzo+KAxK26xRUg6dvdLprpkq6jwFiJ0mrrL7HtvAJAp9BsovZnC+phnTo
         3zaw==
X-Gm-Message-State: AFqh2kpSeb71s9KT0MsI9aLMiRTWSD3B40v+H4TlVQr3mttoqbA7eXSP
        82cDL+jTn32t/Eeoepl36KQ=
X-Google-Smtp-Source: AMrXdXtzaZH0hKIHcFwkAOS0sIhsKaCOQ9xnQkuxnjepURuUQIMIU2bCyeHJl8Y7yqiLRFXWLC7wzw==
X-Received: by 2002:a17:906:30c2:b0:7ae:c0b:a25c with SMTP id b2-20020a17090630c200b007ae0c0ba25cmr37612280ejb.13.1672841116699;
        Wed, 04 Jan 2023 06:05:16 -0800 (PST)
Received: from gvm01 (net-5-89-66-224.cust.vodafonedsl.it. [5.89.66.224])
        by smtp.gmail.com with ESMTPSA id l18-20020a1709060cd200b0084c70c187e8sm9838522ejh.165.2023.01.04.06.05.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 06:05:16 -0800 (PST)
Date:   Wed, 4 Jan 2023 15:05:24 +0100
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
Subject: [PATCH net-next 0/5] add PLCA RS support and onsemi NCN26000
Message-ID: <cover.1672840325.git.piergiorgio.beruto@gmail.com>
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
 drivers/net/phy/mdio-open-alliance.h         |  46 ++++
 drivers/net/phy/ncn26000.c                   | 171 ++++++++++++
 drivers/net/phy/phy-c45.c                    | 183 ++++++++++++
 drivers/net/phy/phy-core.c                   |   5 +-
 drivers/net/phy/phy.c                        | 172 ++++++++++++
 drivers/net/phy/phy_device.c                 |  17 ++
 drivers/net/phy/phylink.c                    |   6 +-
 include/linux/ethtool.h                      |  12 +
 include/linux/phy.h                          |  84 ++++++
 include/uapi/linux/ethtool.h                 |   3 +
 include/uapi/linux/ethtool_netlink.h         |  25 ++
 net/ethtool/Makefile                         |   2 +-
 net/ethtool/common.c                         |   8 +
 net/ethtool/netlink.c                        |  29 ++
 net/ethtool/netlink.h                        |   6 +
 net/ethtool/plca.c                           | 276 +++++++++++++++++++
 20 files changed, 1202 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/phy/mdio-open-alliance.h
 create mode 100644 drivers/net/phy/ncn26000.c
 create mode 100644 net/ethtool/plca.c

-- 
2.37.4


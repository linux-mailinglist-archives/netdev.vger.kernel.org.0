Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9224F661B41
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 01:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233212AbjAIAJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 19:09:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230441AbjAIAJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 19:09:11 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8EF6A1B2;
        Sun,  8 Jan 2023 16:09:09 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id j7so1619960wrn.9;
        Sun, 08 Jan 2023 16:09:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uShLzRkWIJUVNBRowkxfnWm7ulrWmxpVJXFpj3CBVBs=;
        b=kTuwKcmiJ2A4AKdaWQp4/G28P+tw2WI2kn9pEgCU0ou9YWPSUT6C1XsKnKXckkfV3o
         +8qq3eZRrSfZ9Cc0xjacgZdx/2ejjU4s9Uk3h/8gYEbODppMROI52CcjDmEXMWd5gzA0
         gPzlBsc/TVLkW+cBD11lLsF+laNAUv1FTKRfP1/8c2xDGFO7jjuJaOVUDSEeLnTzuK9H
         ENeDtIAs1YgQqNlFu5NObJDzeB/HYyEeZJv+QxJTKR8FKgCU9HQy8m9hEmKlJBKk/eoS
         kE7n3aJgI8rFKbWStMrrJxs95zV4phjgs3L+FPys5awicADcZdFwOvXI4RS4pFMBALzQ
         +SGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uShLzRkWIJUVNBRowkxfnWm7ulrWmxpVJXFpj3CBVBs=;
        b=hRDT4YTkAr8V2tUcUMYveeO/08Sf3psaaNIRICT9WDgbVqaAp2vAhunVlntDtm5K7x
         Ajh0Wxv7I/5eSPAKRb/nWZLNJ5UbIYxOi+VD2dsUaOIAQyquZNAY5iVmam2I+7Vy6vZF
         4zQcnoymWeCHaN8VkhCvUt35TIe6Ng37u3mB35nBxGFm4/VsrIvnHYD2xjKSuxllrnjy
         xIDvy0TVi8NBtrQsh7rbpIV4XFf7Y+Fh4Izyp1r2jwA6LeDsFYMCiWsaAEvtossdfqXz
         64de8KbFbrgXumF415KynB68wTXuEdK1N67fxBIIZA17aWzosXwLMZTDYgnlplWH87LE
         H69w==
X-Gm-Message-State: AFqh2kpoHpSE1YVE9KgvMacG+buMsQKQmdqqIYvfCe784VDelMnClGbT
        NJjwN4qyKirDnPGDjaP+0ms=
X-Google-Smtp-Source: AMrXdXu5W6iI+iBrupeOuKoVZtViIEnhxxg+8PbvJmcG41galzxP3vDm4ItZJao2F+drVroTcOOO5Q==
X-Received: by 2002:adf:e101:0:b0:2ba:dce5:ee28 with SMTP id t1-20020adfe101000000b002badce5ee28mr7233432wrz.18.1673222948437;
        Sun, 08 Jan 2023 16:09:08 -0800 (PST)
Received: from gvm01 (net-5-89-66-224.cust.vodafonedsl.it. [5.89.66.224])
        by smtp.gmail.com with ESMTPSA id s1-20020a5d4ec1000000b002882600e8a0sm7192839wrv.12.2023.01.08.16.09.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Jan 2023 16:09:07 -0800 (PST)
Date:   Mon, 9 Jan 2023 01:09:06 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        mailhol.vincent@wanadoo.fr, sudheer.mogilappagari@intel.com,
        sbhatta@marvell.com, linux-doc@vger.kernel.org,
        wangjie125@huawei.com, corbet@lwn.net, lkp@intel.com,
        gal@nvidia.com, gustavoars@kernel.org, bagasdotme@gmail.com
Subject: [PATCH v3 net-next 0/5] add PLCA RS support and onsemi NCN26000
Message-ID: <cover.1673222807.git.piergiorgio.beruto@gmail.com>
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

 Documentation/networking/ethtool-netlink.rst | 138 +++++++++
 MAINTAINERS                                  |  14 +
 drivers/net/phy/Kconfig                      |   7 +
 drivers/net/phy/Makefile                     |   1 +
 drivers/net/phy/mdio-open-alliance.h         |  46 +++
 drivers/net/phy/ncn26000.c                   | 171 ++++++++++++
 drivers/net/phy/phy-c45.c                    | 191 +++++++++++++
 drivers/net/phy/phy-core.c                   |   5 +-
 drivers/net/phy/phy.c                        | 192 +++++++++++++
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
 net/ethtool/plca.c                           | 277 +++++++++++++++++++
 20 files changed, 1231 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/phy/mdio-open-alliance.h
 create mode 100644 drivers/net/phy/ncn26000.c
 create mode 100644 net/ethtool/plca.c

-- 
2.37.4


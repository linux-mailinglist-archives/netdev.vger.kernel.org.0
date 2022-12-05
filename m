Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8CCA642E7C
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 18:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbiLERQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 12:16:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231883AbiLERQm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 12:16:42 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368431C13B;
        Mon,  5 Dec 2022 09:16:41 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id ud5so146112ejc.4;
        Mon, 05 Dec 2022 09:16:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=laPwog8WkXCJhI71D2YypJt1OtK6OgZOguBUrA2D4xA=;
        b=cFWSd7n1B1fei6Lke10BxDnV4DGSSUbBZwxt8TfXfvHCO6Tzk3Zs+HaO6YVn5Hd8GY
         Tk7+PvEN/uBQkjzF87Ko9JRimlS5QSYZuW27Ui8nwIiUwhYSi9HvzyS+G9QCmgzgKWlK
         s6DFuw8rAPv8eGTuUSqVYdvjJ9gzH6n0i4JAhEdJi0+fmIJb4nbHWRwn+iKdz51Hsj0/
         TPSASTZ0fVCqeqHtQwxFS19HtjzezE7g4MTXOq2dEPVVVNS4x/8xHw1W1/GR1c6dkDPo
         1ETqtPrw9h3AkNbX0ndXkY+bjjx7jch+rAbPk80BDHi/vRK+hlnyhGWqGiKL1yvjzb3M
         kzdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=laPwog8WkXCJhI71D2YypJt1OtK6OgZOguBUrA2D4xA=;
        b=dlY7FqK0WUblKpUkHPI8ieYeZueqV0X8hW4psvxY56O4/d8Zhm6ioj6Ax+YvG9qmgW
         QnApRy+tdlZJrdbtQcjiSDOQDPkeoKdsz+U+6LLGTmqN/Z58xYDYumRVxQYgn7l1MvQG
         OPFoIAqoqScKMiUNgvFLAub0gyd5H0a4eaVV9loyauvRg0BIfmMV8CikRdOjlcJwil7f
         Z4HdEtk0cVc+30bNqMcd0znitGwKxU92eLWQFUm+2wiMMIrnvyKVlqV8wpB77n+BL5aH
         EkSU1R+m9K8CeXB0IiI9gD90e2r3DznSNjmDPE447d3Rbrb24RU2y8+Zw2kJYC1btbi9
         ebEA==
X-Gm-Message-State: ANoB5pmHVYWui1SO44KBGlld5IUdqQbLKE3N9pCjZ1a6uNVZZHCUIKIN
        MeT3gs0CTxhe8/V6U/vvlxk=
X-Google-Smtp-Source: AA0mqf7lTLb2lBeEWCewgwlgWK+VR/PCeoqMhB0YTrOVjz2Y7OZVr151byTIkqGQ6v0HNmi/eYzLwA==
X-Received: by 2002:a17:907:9842:b0:7b9:9492:b3f4 with SMTP id jj2-20020a170907984200b007b99492b3f4mr48738019ejc.688.1670260599654;
        Mon, 05 Dec 2022 09:16:39 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id p17-20020a056402045100b0046aa78ecd8asm33033edw.3.2022.12.05.09.16.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 09:16:39 -0800 (PST)
Date:   Mon, 5 Dec 2022 18:16:48 +0100
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
Subject: [PATCH v3 net-next 0/4] add PLCA RS support and onsemi NCN26000
Message-ID: <cover.1670258773.git.piergiorgio.beruto@gmail.com>
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

Piergiorgio Beruto (4):
  net/ethtool: add netlink interface for the PLCA RS
  drivers/net/phy: add the link modes for the 10BASE-T1S Ethernet PHY
  drivers/net/phy: add connection between ethtool and phylib for PLCA
  drivers/net/phy: add driver for the onsemi NCN26000 10BASE-T1S PHY

 Documentation/networking/ethtool-netlink.rst | 133 +++++++++
 MAINTAINERS                                  |  14 +
 drivers/net/phy/Kconfig                      |   7 +
 drivers/net/phy/Makefile                     |   1 +
 drivers/net/phy/mdio-open-alliance.h         |  44 +++
 drivers/net/phy/ncn26000.c                   | 193 ++++++++++++
 drivers/net/phy/phy-c45.c                    | 180 ++++++++++++
 drivers/net/phy/phy-core.c                   |   5 +-
 drivers/net/phy/phy.c                        | 179 ++++++++++++
 drivers/net/phy/phy_device.c                 |   3 +
 drivers/net/phy/phylink.c                    |   6 +-
 include/linux/ethtool.h                      |  11 +
 include/linux/phy.h                          |  81 ++++++
 include/uapi/linux/ethtool.h                 |   3 +
 include/uapi/linux/ethtool_netlink.h         |  25 ++
 net/ethtool/Makefile                         |   2 +-
 net/ethtool/common.c                         |   8 +
 net/ethtool/netlink.c                        |  30 ++
 net/ethtool/netlink.h                        |   6 +
 net/ethtool/plca.c                           | 290 +++++++++++++++++++
 20 files changed, 1218 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/phy/mdio-open-alliance.h
 create mode 100644 drivers/net/phy/ncn26000.c
 create mode 100644 net/ethtool/plca.c

-- 
2.35.1


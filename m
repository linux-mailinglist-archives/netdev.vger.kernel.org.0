Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8572D64F67E
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 01:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbiLQAsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 19:48:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbiLQAsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 19:48:14 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 232AB5E0AA;
        Fri, 16 Dec 2022 16:48:13 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id i15so5890492edf.2;
        Fri, 16 Dec 2022 16:48:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Eo9BD39xovb+4SmlChbAPl02KDedlYTq0BQcBYiGyQo=;
        b=bWFvV7zwBAcLx+brYrQt77v7ozyes6O4mAD/+HzyiUXYbwd+fRfePdTuwAC30p7nBe
         wvwFw9MHqxrwBDo5nagBzqtYq43047ULStofn1l75uBpcepR57Elry4l+0T2FpYwxFkl
         oBu4IYFolOOXcPlXbOEw+GmtfVneqTYLf+2Kr+MQqM0ozYs7WZlV47tQyzGNRKV4Zwdw
         xIlNYxtX+jiuR0uAHWpERKUHjBoqMBolAqn7YJAWDlbUagG4tAbhOdyWyVc/B7KILB5N
         ThX9CsOpkKv5f3sKVOPxe2QV0Xu7TZhoSjj9tRHGgNTdFdcX7unzZtX2hzR3M5p1C2T/
         psVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Eo9BD39xovb+4SmlChbAPl02KDedlYTq0BQcBYiGyQo=;
        b=kaTsfeFXNLhAzBDTUPXyXhMfkQdPw5MSXJEMqYK/hp4EnW4MFf997QQqG/MUgMhHi4
         k6NEfLwIYe7RcWajjeuTz55EqekZzSGszPWmvyzzYGcPQR+zpXw2mAtSyQoOoymMQaN5
         2BsdSLqLl87CHvkiEeNOqf7NJwPwCbQ6SP3Xb9PEQ9p+3D4OzA2WhU44HVwZv9fRXSbc
         dIsJYzsJvV794Pyze+K0CWaskjUFz7ggcYsMUTsaALupF6zGR2RVbT7CATBbmAB0odt3
         6Tzmx8MfX/vlruwfTzPQjSjDkLgPI/FDnYhikZNrGFFxuuwXw18258oAirMprpUsFJnP
         3WUQ==
X-Gm-Message-State: AFqh2krKc9jRZxIIERxfUNm1A+cVrjzfN5q6/nR1Gk2YTKpgVAkTUaYy
        JYHx4jxmLDoHCau9dfcOg3ObSJKMrpD8Z8Z6Qy4=
X-Google-Smtp-Source: AMrXdXsR4FCRnH/52kLHL9jUWUiE23LcxGm18mk7WjN+7M45fSYqdeMQ+z50YHfsWdSjJW9KBm1SvA==
X-Received: by 2002:aa7:c6c4:0:b0:472:2d7e:8c6d with SMTP id b4-20020aa7c6c4000000b004722d7e8c6dmr12034750eds.28.1671238091588;
        Fri, 16 Dec 2022 16:48:11 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id f4-20020a056402068400b0046951b43e84sm1410850edy.55.2022.12.16.16.48.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 16:48:11 -0800 (PST)
Date:   Sat, 17 Dec 2022 01:48:09 +0100
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
Subject: [PATCH v7 net-next 0/5] add PLCA RS support and onsemi NCN26000
Message-ID: <cover.1671234284.git.piergiorgio.beruto@gmail.com>
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
 include/linux/phy.h                          |  83 ++++++
 include/uapi/linux/ethtool.h                 |   3 +
 include/uapi/linux/ethtool_netlink.h         |  25 ++
 net/ethtool/Makefile                         |   2 +-
 net/ethtool/common.c                         |   8 +
 net/ethtool/netlink.c                        |  29 ++
 net/ethtool/netlink.h                        |   6 +
 net/ethtool/plca.c                           | 276 +++++++++++++++++++
 20 files changed, 1201 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/phy/mdio-open-alliance.h
 create mode 100644 drivers/net/phy/ncn26000.c
 create mode 100644 net/ethtool/plca.c

-- 
2.37.4


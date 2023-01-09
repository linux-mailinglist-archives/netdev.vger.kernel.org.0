Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE081662BF1
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 18:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237383AbjAIRAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 12:00:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237358AbjAIQ7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 11:59:33 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2050F3C3BD;
        Mon,  9 Jan 2023 08:59:30 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id x10so10575227edd.10;
        Mon, 09 Jan 2023 08:59:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lzYeE0k+RbKjBKSNKa4zV/0U3B6MFOwQNa0CRLnETjE=;
        b=VAflwCUjBRcz6tGtZhzENyN2lOh8MNjUWoYII2o0JVHyxvkNZHL1q/Qp0u6qPjkL66
         71Ob7s36bXfS4t+l3nQ1TCnMTS00Tj+GgILHRctRji3Hp5eBcn25FJWCsnDG0oMJjwjr
         H4nsSLMruZp8s2WWae+pkWVnDDeinRavePt7cie+GHMucXc78Uu7Q8Jsi4nQySxW76Xe
         n9lPTa8VPkWU6y208GTCgnDaUnd1XEU/NFKYLn5EWv6VCVpfNfCrIrUiIS7v/4AJJ+XE
         JfYHvSQXE4OwAhWGsMP0nBUbinW7vbx2iJycm5CsFrwYU6JHvgBGK+9dLg8iLvDCfMxX
         HV4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lzYeE0k+RbKjBKSNKa4zV/0U3B6MFOwQNa0CRLnETjE=;
        b=qPQwKOUuIM1sTvCBmyZz6+QMUNdrzngqsKF/fdu9UFtlvYqanwHhUg1vktU1L1+yIR
         02YlZ1l5vEWsGHgzALxonTOGWEoK3MljosV8s/JaawP+Pbq8eo6HxnYBFrkevtWOabE5
         VEexbCRu1gEll5xTHCMbch5ZCrHVpZmJ8mdZIqTxPbAPZ3UF6KM7Ur8mzcS8kKbGZ8Zb
         cHWacJPcAMHrOaA7+UcIe/oPrXjkAQpPed3H4CgMBjGLT2tAc+7zFMXGchK4/8TaZpxL
         fWQwhAJ0dsFUdrNZgJ7JSK2ypTY3SMPonoAGZpD6imrFLQUhXlWiGbUxOPpzUSh2MZT5
         CE1A==
X-Gm-Message-State: AFqh2kpLTsXR5WAXvNcHG2w5Rds2tXIjDd0MaTptq5pBoMHgA/ebMB6f
        FMJ6Fb7Jb5K2/pw5NbfM4fU=
X-Google-Smtp-Source: AMrXdXsCHTFqzmTA1/rruTMbQxh2xwP+UC8572LAdBqDnhDQT4ju5z0690MC/mE1PtRvRCltFqhg1g==
X-Received: by 2002:a05:6402:1caa:b0:46c:72fb:3810 with SMTP id cz10-20020a0564021caa00b0046c72fb3810mr64929745edb.41.1673283568604;
        Mon, 09 Jan 2023 08:59:28 -0800 (PST)
Received: from gvm01 ([91.199.164.40])
        by smtp.gmail.com with ESMTPSA id e15-20020a056402104f00b004918b6b5e30sm3887564edu.15.2023.01.09.08.59.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 08:59:28 -0800 (PST)
Date:   Mon, 9 Jan 2023 17:59:25 +0100
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
Subject: [PATCH v4 net-next 0/5] add PLCA RS support and onsemi NCN26000
Message-ID: <cover.1673282912.git.piergiorgio.beruto@gmail.com>
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
 drivers/net/phy/phy-c45.c                    | 193 +++++++++++++
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
 20 files changed, 1233 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/phy/mdio-open-alliance.h
 create mode 100644 drivers/net/phy/ncn26000.c
 create mode 100644 net/ethtool/plca.c

-- 
2.37.4


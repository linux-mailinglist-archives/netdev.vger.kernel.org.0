Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86F31641A64
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 03:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiLDC31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 21:29:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiLDC30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 21:29:26 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 253D56418;
        Sat,  3 Dec 2022 18:29:25 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id o13so20073636ejm.1;
        Sat, 03 Dec 2022 18:29:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gbsKjL8utqHF/zRtn4Y5KwVEZc3aCwdXT8ihIn22F7g=;
        b=SfD5+i9f3V/lC53i+kJ3SPOfy2pSKCcmSaKcnFiwXNToYhbEssuMnCthyq6GBAAXq+
         6+z6x4FlldRifJ7iWm1tdjoSN2/+L2MBz6f+zNE/SiDF2GWc66PA+zru3Up2Ky9I6zwY
         /SozH78UbK/AkVzo5oGKaqdkryGTZzUOq4qRNei0wu91OvBbJ1920yoY4+4VGp0BEvfv
         mNEXyrw5ReJlb/i/B+KlIdGlAgMUYaniaGmcL7hHw8Vb0SvTRRnhopzqsQX8DDi+jc94
         iRduNlwo9KsM+qrRGvD2yJ9MaRl+eICg8odxgZM/4eVI61f9PrulgYAEpW2oHEQzmBDM
         ZP3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gbsKjL8utqHF/zRtn4Y5KwVEZc3aCwdXT8ihIn22F7g=;
        b=8GImfNW+9F7n8qHYTIXOavBrBZTF75nYSUmpiDPM9NIA3r7FINig6ExqurEUsU6b/N
         7z1M1GQSLmi0nTqNExRjB1oVYuS1DNdA4goblrHeJAKoZ3Syn3czjescIaoqZawHx1S3
         eQXPNbKkJcLBAuC81liO2QddpQNb4uSJVwLP6bJuCHDNkRHd+/6+IE83EPG0cLCUveqQ
         GJrbZUCM2uW4tMfpJYfuKEbKyP+tzmQxLkrkNbMuawGzXMs9d8Z+t7/sssW/lUp6kxMk
         DIeBT+aFe5EHmpLf1rxzDcoOZMfqjS9+pVo6iJhavjcKYbNLVa2+stu3arjkj43u6F8H
         yVIg==
X-Gm-Message-State: ANoB5pl8A1lHRrETI/xJLrCZ5XOXuxi7h1EMeISyT1CgD8sNAqLrLj2i
        c04BQ77Jvs1bKF+xyWVaEF0pn/wvXfRszFi1
X-Google-Smtp-Source: AA0mqf6gqnPBWdHFXPwqyjdCyP5TWjTJhDhBUs4p+gZPmed/C+VKEgYcZQ3Iz6X0TFuhZaSeaiS6og==
X-Received: by 2002:a17:906:14d0:b0:7c0:a356:b41b with SMTP id y16-20020a17090614d000b007c0a356b41bmr14462091ejc.158.1670120963537;
        Sat, 03 Dec 2022 18:29:23 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id ec16-20020a0564020d5000b00467481df198sm4677087edb.48.2022.12.03.18.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Dec 2022 18:29:23 -0800 (PST)
Date:   Sun, 4 Dec 2022 03:29:30 +0100
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
Subject: [PATCH net-next 0/4] add PLCA RS support and onsemi NCN26000
Message-ID: <cover.1670117772.git.piergiorgio.beruto@gmail.com>
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

PLCA is a feature that provides improved media-access performance in
terms of throughput, latency and fairness for multi-drop (P2MP)
half-duplex PHYs. PLCA is defined in Clause 148 of the IEEE802.3
specifications as amended by 802.3cg-2019. Currently, PLCA is supported
by the 10BASE-T1S single-pair Ethernet PHY defined in the same standard
and related amendments. The OPEN Alliance SIG TC14 defines additional
specifications for the 10BASE-T1S PHY, including a standard register map
for PHYs that embeds the PLCA RS (see PLCA management registers at
https://www.opensig.org/about/specifications/).

The changes proposed herein add the appropriate ethtool netlink interface for
configuring the PLCA RS on PHYs that supports it. A seperate patchset
further modifies the ethtool userspace program to show and modify the
configuration/status of the PLCA RS.

Additionally, this patchset adds support for the onsemi NCN26000
Industrial Ethernet 10BASE-T1S PHY that uses the newly added PLCA
infrastructure.

Piergiorgio Beruto (4):
  net/ethtool: Add netlink interface for the PLCA RS
  phylib: Add support for 10BASE-T1S link modes and PLCA config
  drivers/net/phy: Add driver for the onsemi NCN26000 10BASE-T1S PHY
  driver/ncn26000: add PLCA support

 MAINTAINERS                          |  13 ++
 drivers/net/phy/Kconfig              |   7 +
 drivers/net/phy/Makefile             |   1 +
 drivers/net/phy/ncn26000.c           | 209 +++++++++++++++++++
 drivers/net/phy/phy-c45.c            | 187 +++++++++++++++++
 drivers/net/phy/phy-core.c           |   2 +-
 drivers/net/phy/phy.c                | 179 +++++++++++++++++
 drivers/net/phy/phy_device.c         |   3 +
 drivers/net/phy/phylink.c            |   6 +-
 include/linux/ethtool.h              |  11 +
 include/linux/phy.h                  |  81 ++++++++
 include/uapi/linux/ethtool.h         |   3 +
 include/uapi/linux/ethtool_netlink.h |  25 +++
 include/uapi/linux/mdio.h            |  31 +++
 net/ethtool/Makefile                 |   2 +-
 net/ethtool/common.c                 |   8 +
 net/ethtool/netlink.c                |  30 +++
 net/ethtool/netlink.h                |   6 +
 net/ethtool/plca.c                   | 290 +++++++++++++++++++++++++++
 19 files changed, 1091 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/phy/ncn26000.c
 create mode 100644 net/ethtool/plca.c

-- 
2.35.1


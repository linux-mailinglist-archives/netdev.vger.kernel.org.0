Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BEAB660687
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 19:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231493AbjAFSoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 13:44:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbjAFSoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 13:44:07 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7D267DE0C;
        Fri,  6 Jan 2023 10:44:03 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id kw15so5357813ejc.10;
        Fri, 06 Jan 2023 10:44:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Cfpx3g9v5AR6G8kG2cS5fJ9THDFlF/zwp2XZ7O1aB6Y=;
        b=hWWJnFBRR2/Gmb8I8D+EnJba19lmiM337s1QXVwn751WfEk/3RIbshgvlnnE5HmT2e
         ZmljFtLNPf7hMf3hUVSwYqU3iCPX+PC/l+nLfyVSXgOjvE5qfx1FhFO+bAniJ6OnfEb/
         9whdvL5UlfQevUiVuqSxG2m90McXN3MY8fskJZNVlSUBgplLeQIB3X7kqP74+awKAcEt
         giEPPLs5SCPfUDiVNMPLwp+CUz/E2ghbBVyaYvDJ6ojfU4N38dHvRF3RpPANEVkWHlWR
         Ge0F/RudkIQtHUA4QnDWPenVU3WgnFnfd6hyDsmqt7gSIh/NdRHEm1Hi+UaJ6IVBhLd6
         DCNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Cfpx3g9v5AR6G8kG2cS5fJ9THDFlF/zwp2XZ7O1aB6Y=;
        b=ZrcsVSfubq1FeidKMLcHSmXsTQehpkGc9cj/PaV5QM4uY0BbTEjQFpzmrESdj5Mxjj
         HrfgqtS4AkQCimL0sCUQKki+STi8dNbjqFSJJEBZqVHv4maue0VcrJVGlVIhqG9pBIsd
         ypuII9OtElIuPqxa84KOtcKEgooJbsDN0/67gV1SvkwRQbZphonay3pmfsEQ36iIOqF7
         f/8WW8E/immf3Lxq44L1rDCeMCCZDmb6GYM7kNvbtiyb9a9FmUMOTcOJyhtgnBcKMSpy
         wk71rrCK9T88fU40uS/oJNo4bQSEZ7PCersDeJXZyxKPQGgJTO5HVn3qBNmDpUwil5/3
         DKjQ==
X-Gm-Message-State: AFqh2kpaQBvbFAGnMxwKWSTam4o248CZfVwx+IoMrr9l1xJuP/q4eFRf
        cYeVpPdeneObPP9cfhKJi5c=
X-Google-Smtp-Source: AMrXdXvCWfB13TqTXXHwfWRrvS30ChgUx9hcD829visB8YXozDP3X7bTQtdMqbnvSIoi17gDedUmmA==
X-Received: by 2002:a17:906:d96c:b0:7c1:7cc2:1f1e with SMTP id rp12-20020a170906d96c00b007c17cc21f1emr54899363ejb.35.1673030642386;
        Fri, 06 Jan 2023 10:44:02 -0800 (PST)
Received: from gvm01 ([91.199.164.40])
        by smtp.gmail.com with ESMTPSA id g17-20020a17090670d100b007bb86679a32sm634050ejk.217.2023.01.06.10.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 10:44:01 -0800 (PST)
Date:   Fri, 6 Jan 2023 19:43:56 +0100
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
        gal@nvidia.com, gustavoars@kernel.org
Subject: [PATCH v2 net-next 0/5] add PLCA RS support and onsemi NCN26000
Message-ID: <cover.1673030528.git.piergiorgio.beruto@gmail.com>
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
 drivers/net/phy/ncn26000.c                   | 173 ++++++++++++
 drivers/net/phy/phy-c45.c                    | 183 ++++++++++++
 drivers/net/phy/phy-core.c                   |   5 +-
 drivers/net/phy/phy.c                        | 174 ++++++++++++
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
 20 files changed, 1207 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/phy/mdio-open-alliance.h
 create mode 100644 drivers/net/phy/ncn26000.c
 create mode 100644 net/ethtool/plca.c

-- 
2.37.4


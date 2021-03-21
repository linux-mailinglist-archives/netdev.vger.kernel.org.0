Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E80513435B2
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 00:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbhCUXaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 19:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbhCUX3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 19:29:50 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EA1CC061574;
        Sun, 21 Mar 2021 16:29:49 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id r12so18352271ejr.5;
        Sun, 21 Mar 2021 16:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7pOLNQfROV9DESH9c1z/95PUsvdUmS+ux4xUVmugTq0=;
        b=h9qc2xEvgfRcB+T+8D4cDQ+gO7nMzZAye7jQiJqFNHSVNa4+cj/xwYUwklpJl9xV33
         mqXJU3Xy44xfdONRVov7Wa24Gz16ZPufnUPAPg7v9aP51g7iNohl+CNR8QimxgcBqKZq
         6kA1ig9kralNr6tedvjWNlaYZaeNti05dDjou9IlJ/TF77+GDHkySX2sDlX4YNNztwao
         uajypSuKh+TX6sWyralMuN8waKHdAmhK2HVgtMrTJeDDwgRs3kL3wDuB1+oi9FR2ELi6
         CcJspofOkDRKuPaMiNe06bu7Xp9rQ4GTNaS73oOJae/zOW6hyDA6bnqKf37FXbAG7nCH
         YFyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7pOLNQfROV9DESH9c1z/95PUsvdUmS+ux4xUVmugTq0=;
        b=OqWhQZF+ji9oDdzgDxHL2kE/3ASfquGxYmWTsnShcQsPq08mo1pbWRI4iew5nfgN41
         n7wr/cGvbgACJfGyOtwjTKYDWOw+XKOoc40NX6+e28R3LGOYm4DOOr0aAQlkBQRZLrS4
         BTeJ/jkFy/AvVkLCKHTihibkN8N5kcZQv3URfIgx1dj1/XA6OTKdj90Tq8Fz5GM7niR3
         QYAUJM0m1gDXsOszPbU5FcsOqFgCu6Gbxprn8kG3+e7ZFW/vBJuwl8hygW3hEvdOdBuG
         lWBpE36xz4ckZOh075vKnehP2CMfitTqKoYlU6mcPYegn9AJrkAGHv6gKe1ruqgPmw73
         5D+g==
X-Gm-Message-State: AOAM533ztcrZErzryFcGja4iOTf6b3AeA3pyd5skOkCBeOMHKS3jtPSN
        iPJrC1Elb7Ogq8yM6dkfJLU=
X-Google-Smtp-Source: ABdhPJz6DWGODcj429igJhmLIHWMUTHzDEAasDLnQIVoj9x7rHcLoKbHHOoDgqdUl0liiet5NjJj5g==
X-Received: by 2002:a17:906:13c4:: with SMTP id g4mr16551073ejc.390.1616369388113;
        Sun, 21 Mar 2021 16:29:48 -0700 (PDT)
Received: from localhost.localdomain ([188.24.140.160])
        by smtp.gmail.com with ESMTPSA id bt14sm9801472edb.92.2021.03.21.16.29.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 16:29:47 -0700 (PDT)
From:   Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-actions@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/3] Add support for Actions Semi Owl Ethernet MAC
Date:   Mon, 22 Mar 2021 01:29:42 +0200
Message-Id: <cover.1616368101.git.cristian.ciocaltea@gmail.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds support for the Ethernet MAC found on the Actions
Semi Owl family of SoCs.

For the moment I have only tested the driver on RoseapplePi SBC, which is
based on the S500 SoC variant. It might work on S900 as well, but I cannot
tell for sure since the S900 datasheet I currently have doesn't provide
any information regarding the MAC registers - so I couldn't check the
compatibility with S500.

Similar story for S700: the datasheet I own is incomplete, but it seems
the MAC is advertised with Gigabit capabilities. For that reason most
probably we need to extend the current implementation in order to support
this SoC variant as well.

Please note that for testing the driver it is also necessary to update the
S500 clock subsystem:

https://lore.kernel.org/lkml/cover.1615221459.git.cristian.ciocaltea@gmail.com/

The DTS changes for the S500 SBCs will be provided separately.

Thanks,
Cristi

Changes in v3:
 - Dropped the 'debug' module parameter and passed the default NETIF_MSG flags
to netif_msg_init(), according to David's review

 - Removed the owl_emac_generate_mac_addr() function and the related
OWL_EMAC_GEN_ADDR_SYS_SN config option until a portable solution to get
the system serial number is found - when building on arm64 the following
error is thrown (as reported by Rob's kernel bot):
 '[...]/owl-emac.c:9:10: fatal error: asm/system_info.h: No such file or directory'

 - Rebased patchset on v5.12-rc4

Changes in v2:
* According to Philipp's review
 - Requested exclusive control over serial line via
   devm_reset_control_get_exclusive()
 - Optimized error handling by using dev_err_probe()

* According to Andrew's review
 - Dropped the inline keywords
 - Applied Reverse Christmas Tree format to local variable declarations
 - Renamed owl_emac_phy_config() to owl_emac_update_link_state()
 - Documented the purpose of the special descriptor used in the context of
   owl_emac_setup_frame_xmit()
 - Updated comment inside owl_emac_mdio_clock_enable() regarding the MDC
   clock divider setup
 - Indicated MAC support for symmetric pause via phy_set_sym_pause()
   in owl_emac_phy_init()
 - Changed the MAC addr generation algorithm in owl_emac_generate_mac_addr()
   by setting the locally administered bit in byte 0 and replacing bytes 1 & 2
   with additional entries from enc_sn
 - Moved devm_add_action_or_reset() before clk_set_rate() in owl_emac_probe()

* Other
 - Added SMII interface support: updated owl_emac_core_sw_reset(), added
   owl_emac_clk_set_rate(), updated description in the YAML binding
 - Changed OWL_EMAC_TX_TIMEOUT from 0.05*HZ to 2*HZ
 - Rebased patchset on v5.12-rc3

Cristian Ciocaltea (3):
  dt-bindings: net: Add Actions Semi Owl Ethernet MAC binding
  net: ethernet: actions: Add Actions Semi Owl Ethernet MAC driver
  MAINTAINERS: Add entries for Actions Semi Owl Ethernet MAC

 .../bindings/net/actions,owl-emac.yaml        |   92 +
 MAINTAINERS                                   |    2 +
 drivers/net/ethernet/Kconfig                  |    1 +
 drivers/net/ethernet/Makefile                 |    1 +
 drivers/net/ethernet/actions/Kconfig          |   26 +
 drivers/net/ethernet/actions/Makefile         |    6 +
 drivers/net/ethernet/actions/owl-emac.c       | 1625 +++++++++++++++++
 drivers/net/ethernet/actions/owl-emac.h       |  280 +++
 8 files changed, 2033 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/actions,owl-emac.yaml
 create mode 100644 drivers/net/ethernet/actions/Kconfig
 create mode 100644 drivers/net/ethernet/actions/Makefile
 create mode 100644 drivers/net/ethernet/actions/owl-emac.c
 create mode 100644 drivers/net/ethernet/actions/owl-emac.h

-- 
2.31.0


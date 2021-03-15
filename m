Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1C833B11C
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 12:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbhCOL3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 07:29:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbhCOL3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 07:29:23 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB349C061574;
        Mon, 15 Mar 2021 04:29:22 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id o19so16884717edc.3;
        Mon, 15 Mar 2021 04:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rGW6cctDZoxABCsL4nhXCJwptF8+bYgkqPIEjnnUAYE=;
        b=mR+um3ko28cgPbFRVeDD5k3WaH0Enn8IRarFjH9efZ8D4VpVOiPN1BSi7f9e0+tpYC
         moBg5EQsiZBW5RMP1ia6sJOPQ/f/cTZdpI1cix8ALgyCVNs0kr1KBc0pCZXlh9ExfbiD
         ATcFdDjWWNkkWEm6Z/meUUXZIOLgsZfMlZm0lcT/HKpsY8WkZgxowTrssM/nxtYP+hkf
         yTXaFlGHxhV80FkReVab6tkXGAbE1TQMEHd0xZT5ruWHFLQkfDRYcIZoDumG8hvCjTaH
         qH+pSQ2BkA2F1R3JNhpDUUproOSczjcjisISPRsl2IQpgmToXc823hxlOeSoMND6H9lU
         Kmrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rGW6cctDZoxABCsL4nhXCJwptF8+bYgkqPIEjnnUAYE=;
        b=l1a9/WI0+28l3TUrr3A098usa0Zu7MYve0iZEPOG6oNqPrCDPcsUK1g1joBkfajBYn
         GR5J7+yR6S1IZXX7kh3QouwXEMwBPF/L41kyf+jFLd0itsQTGK671RWeosHaVAkT47op
         Wyuz5eAR4r4W7O5DQT6rtSyrWmcv6QoxD8pXrEDfV+RpPHy9bx11hNbeZrXCoN/Q9QbH
         tnzfqwRDL6oPLl5g05M7MhRQOiczu9mQIFyVEAsebiSgC1jCAwPs/HkjxCN0LFb9C29t
         /pmrf6ApTL7TBtLvN9Elaf+M+fdGZM8XkWHVvOqq1TZeVapybKuVAt7fyBDPDxOJkQoA
         24fA==
X-Gm-Message-State: AOAM5312kbM1WscdEPMXhCvk3jyQxtff19GzmXb4ZV1L6xwM7wl5kULn
        pO4JgeFUJeYTNgKsWSiykfs=
X-Google-Smtp-Source: ABdhPJySTUuRdpTPNyo+Tq2X7aniRxhHUl89LTEuEgh+8jCpVdcnSjxEEWCugKU6hXJTdxpwyXV25w==
X-Received: by 2002:aa7:c14a:: with SMTP id r10mr28301174edp.132.1615807761453;
        Mon, 15 Mar 2021 04:29:21 -0700 (PDT)
Received: from localhost.localdomain ([188.24.140.160])
        by smtp.gmail.com with ESMTPSA id q25sm3921423edt.51.2021.03.15.04.29.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 04:29:20 -0700 (PDT)
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
Subject: [PATCH v2 0/3] Add support for Actions Semi Owl Ethernet MAC
Date:   Mon, 15 Mar 2021 13:29:15 +0200
Message-Id: <cover.1615807292.git.cristian.ciocaltea@gmail.com>
X-Mailer: git-send-email 2.30.2
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
 drivers/net/ethernet/actions/Kconfig          |   39 +
 drivers/net/ethernet/actions/Makefile         |    6 +
 drivers/net/ethernet/actions/owl-emac.c       | 1703 +++++++++++++++++
 drivers/net/ethernet/actions/owl-emac.h       |  280 +++
 8 files changed, 2124 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/actions,owl-emac.yaml
 create mode 100644 drivers/net/ethernet/actions/Kconfig
 create mode 100644 drivers/net/ethernet/actions/Makefile
 create mode 100644 drivers/net/ethernet/actions/owl-emac.c
 create mode 100644 drivers/net/ethernet/actions/owl-emac.h

-- 
2.30.2


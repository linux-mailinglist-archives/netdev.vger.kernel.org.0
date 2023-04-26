Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 297A26EFA61
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 20:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236225AbjDZSyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 14:54:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236056AbjDZSyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 14:54:45 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1542283E7;
        Wed, 26 Apr 2023 11:54:44 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-63b4dfead1bso6245763b3a.3;
        Wed, 26 Apr 2023 11:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682535283; x=1685127283;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R07Mi9Mz971NXlM6C0+9m3ePvBeyQwkx2T3l6oVaSvA=;
        b=Qye9OWjFuOEWZhcxm7u9djE3RkEO2zz5jUeRowPRUvM3LdUaM6cwmH2RJmcvMYNHT4
         GrckvKFHj9z01woq1G8sG0XtwNhF2Xf4Emh7RNl2SKucGuxocCGTwCj7MdI3+a69zjsE
         spa0kK5D03b0kby7d98GBeUuM72sxNuibrA8UD9AqVj9XcvZ3RIDf98d0NchVYzIv+HK
         1ilmdFhHAVYNUctSTvtSGPgZIjYAdmU/nxgXQxX4fdcZSmzDBIQqCUi7LsvukS2syA1u
         vGLpG3YHSF/pC919ecvDP8y6vHIqYnkykmLJmHs+UGF5tCBSooRY6z29sMiW6qrIhj94
         kMsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682535283; x=1685127283;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R07Mi9Mz971NXlM6C0+9m3ePvBeyQwkx2T3l6oVaSvA=;
        b=bPyuxvP9gfS+beYHe/DDpibsxCt18d3emnvnCevLe4zGiJZ9TD3VvrcwfhpQpdF9Fp
         rgPFFKkgViVIemvENzbDWNaT34IDuJXFerbYs8O8G1wUjYiiVAhzKQkq+P6VCz8U1t+L
         ih34lWsRa89ToLCMuOPwTNkqDFFE+5BXLGM0CjHCwQJkabgqtndJFtU4u5aq2xpXep2n
         CvkMdliPiVkw9awfNxCH/AZFrCpblIBiu/P2MAIRYXjSggTNFa1F3H1znNh08oZ89eXh
         aaYP7jjsjkiJO6GP0nMfpyF6/3n1Dp2LR1UlOc2rC8Jw5hn3ubB9L49cnmDpwWETYpQL
         AsZQ==
X-Gm-Message-State: AAQBX9c+9HbvR2/AhGpK5xwUIpi6C2IysC2ngOQS4PJScm0lbndo2kDm
        ZFpkEP+jtl9cic5gd3KBuZ0j6la/76im9w==
X-Google-Smtp-Source: AKy350ayADESKqZUED8JafpEZGIjCz4hY19zWIUoZp0bX0AJ4jiUhsSvlxpczQ8Kb+xGm37lSzOy2g==
X-Received: by 2002:a05:6a00:1acd:b0:63d:2aac:7b88 with SMTP id f13-20020a056a001acd00b0063d2aac7b88mr31945188pfv.25.1682535283105;
        Wed, 26 Apr 2023 11:54:43 -0700 (PDT)
Received: from stbirv-lnx-2.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y72-20020a62644b000000b006372791d708sm11639254pfb.104.2023.04.26.11.54.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Apr 2023 11:54:42 -0700 (PDT)
From:   Justin Chen <justinpopo6@gmail.com>
To:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        bcm-kernel-feedback-list@broadcom.com
Cc:     justinpopo6@gmail.com, justin.chen@broadcom.com,
        f.fainelli@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, opendmb@gmail.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        richardcochran@gmail.com, sumit.semwal@linaro.org,
        christian.koenig@amd.com
Subject: [PATCH v2 net-next 0/6] Brcm ASP 2.0 Ethernet controller
Date:   Wed, 26 Apr 2023 11:54:26 -0700
Message-Id: <1682535272-32249-1-git-send-email-justinpopo6@gmail.com>
X-Mailer: git-send-email 2.7.4
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v2
	- Updates to yaml dt documentation
	- Replace a couple functions with helper functions
	- Minor formatting fixes
	- Fix a few WoL issues

Add support for the Broadcom ASP 2.0 Ethernet controller which is first
introduced with 72165.

Add support for 74165 10/100 integrated Ethernet PHY which also uses
the ASP 2.0 Ethernet controller.

Florian Fainelli (2):
  dt-bindings: net: Brcm ASP 2.0 Ethernet controller
  net: phy: bcm7xxx: Add EPHY entry for 74165

Justin Chen (4):
  dt-bindings: net: brcm,unimac-mdio: Add asp-v2.0
  net: bcmasp: Add support for ASP2.0 Ethernet controller
  net: phy: mdio-bcm-unimac: Add asp v2.0 support
  MAINTAINERS: ASP 2.0 Ethernet driver maintainers

 .../devicetree/bindings/net/brcm,asp-v2.0.yaml     |  145 ++
 .../devicetree/bindings/net/brcm,unimac-mdio.yaml  |    2 +
 MAINTAINERS                                        |    9 +
 drivers/net/ethernet/broadcom/Kconfig              |   11 +
 drivers/net/ethernet/broadcom/Makefile             |    1 +
 drivers/net/ethernet/broadcom/asp2/Makefile        |    2 +
 drivers/net/ethernet/broadcom/asp2/bcmasp.c        | 1476 ++++++++++++++++++++
 drivers/net/ethernet/broadcom/asp2/bcmasp.h        |  636 +++++++++
 .../net/ethernet/broadcom/asp2/bcmasp_ethtool.c    |  585 ++++++++
 drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c   | 1435 +++++++++++++++++++
 .../net/ethernet/broadcom/asp2/bcmasp_intf_defs.h  |  238 ++++
 drivers/net/mdio/mdio-bcm-unimac.c                 |    2 +
 drivers/net/phy/bcm7xxx.c                          |    1 +
 include/linux/brcmphy.h                            |    1 +
 14 files changed, 4544 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml
 create mode 100644 drivers/net/ethernet/broadcom/asp2/Makefile
 create mode 100644 drivers/net/ethernet/broadcom/asp2/bcmasp.c
 create mode 100644 drivers/net/ethernet/broadcom/asp2/bcmasp.h
 create mode 100644 drivers/net/ethernet/broadcom/asp2/bcmasp_ethtool.c
 create mode 100644 drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
 create mode 100644 drivers/net/ethernet/broadcom/asp2/bcmasp_intf_defs.h

-- 
2.7.4


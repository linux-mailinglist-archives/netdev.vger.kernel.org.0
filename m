Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D50D6BE844
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 12:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbjCQLgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 07:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbjCQLga (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 07:36:30 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAFD1A8E97;
        Fri, 17 Mar 2023 04:35:43 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id r18so4136590wrx.1;
        Fri, 17 Mar 2023 04:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679052904;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7+WArVlrOZPWJhbqeKS4okYM7u1jSMClFvsx3vbO9bE=;
        b=ErmwZ3Q7haGH+EoQxqn9NAbJgdp6CdDWQ3uMpQJRYNWBxX1VZH3i+gwFYwLVm8w/cO
         27iEIROMyUeCrQsk0RV89MEG649dBhSaThI/7jXUujan8T4sufr9+r4GwbP3cYBUI7at
         NO/Cd/a9mr2AdpSgteyEixZpXC8F4AEguUeBctwEZEZjPOsTaCAHP6ItCsulQJzFCIFi
         kykLdqEuCF+RnS3oUFK6QQgiUGIqGNlhOasPy9Nf5H1FzE8Wk+GWfw7BFwHbKVjO8WhB
         sH5pWz8078MaktpxrQOYFQkpH1qlgVToIL+iiJ61oymfSTuymlLDas1e3q2dUMJRmdFV
         NdXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679052904;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7+WArVlrOZPWJhbqeKS4okYM7u1jSMClFvsx3vbO9bE=;
        b=mZGiIzpNdGZagu96aJQcFUyCWLI8Kj3DTdU5qKETrT2JT7T9ozjB9fU32bUfVyOzUP
         yihqjF5vJdzSy8yVOhBKPVV4N1e9yKmel9dI4azIKFOV6eyFFikYP7XwO1ORtwo4TxxO
         vYQkmQWY/DAouVULsaebNqmlq76lhqW7i6imToiYEVsN+4x2g2+9Dt4p/YMk2hRmF1PX
         wWoPp4MOMkztvKm1SC1R5ZnNuA4Yq6zSaTvUBQuwtIJgtYs9+FtTaoGm7Ad/0WS1IIix
         dlzgMHoN589y3xXlwnf52R1JSQUywxJ6U0rfauGfcp5GDuTVMgcc6M+YEnRQcwLm+ZH6
         pDcA==
X-Gm-Message-State: AO0yUKUm8AN6OInAl/GXsAGCUogM4/jc5yQO8D2ktBqy3oy5niMuQE2v
        hwRUXx9H+LulY9JrcU4aQEE=
X-Google-Smtp-Source: AK7set8r6yNQQkYT4XEGSlpTbfB7lvfocMNbnaBNzb1dUpAM/wbtnRB2XNEMnjne354V0Ymmlc3nyg==
X-Received: by 2002:a5d:5511:0:b0:2cf:e759:58a3 with SMTP id b17-20020a5d5511000000b002cfe75958a3mr6640621wrv.13.1679052904080;
        Fri, 17 Mar 2023 04:35:04 -0700 (PDT)
Received: from atlantis.lan (255.red-79-146-124.dynamicip.rima-tde.net. [79.146.124.255])
        by smtp.gmail.com with ESMTPSA id p17-20020adfcc91000000b002c71dd1109fsm1763505wrj.47.2023.03.17.04.35.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 04:35:03 -0700 (PDT)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, f.fainelli@gmail.com,
        jonas.gorski@gmail.com, andrew@lunn.ch, olteanv@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
Subject: [PATCH 0/3] net: dsa: b53: mmap: add MDIO Mux bus controller
Date:   Fri, 17 Mar 2023 12:34:24 +0100
Message-Id: <20230317113427.302162-1-noltari@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

B53 MMAP devices have a MDIO Mux bus controller that must be registered after
properly initializing the switch.
If the MDIO Mux controller is registered from a separate driver and the device
has an external switch present, it will cause a race condition which will hang
the device.

Álvaro Fernández Rojas (3):
  dt-bindings: net: move bcm6368-mdio-mux bindings to b53
  net: dsa: b53: mmap: register MDIO Mux bus controller
  net: mdio: remove BCM6368 MDIO mux bus driver

 .../bindings/net/brcm,bcm6368-mdio-mux.yaml   |  52 -----
 .../devicetree/bindings/net/dsa/brcm,b53.yaml | 131 +++++++++++++
 drivers/net/dsa/b53/Kconfig                   |   1 +
 drivers/net/dsa/b53/b53_mmap.c                | 127 +++++++++++-
 drivers/net/mdio/Kconfig                      |  11 --
 drivers/net/mdio/Makefile                     |   1 -
 drivers/net/mdio/mdio-mux-bcm6368.c           | 184 ------------------
 7 files changed, 258 insertions(+), 249 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/brcm,bcm6368-mdio-mux.yaml
 delete mode 100644 drivers/net/mdio/mdio-mux-bcm6368.c

-- 
2.30.2


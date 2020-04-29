Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8E01BDA49
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 13:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbgD2LHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 07:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726426AbgD2LHq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 07:07:46 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 671E9C035494
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 04:07:46 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id x25so1561486wmc.0
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 04:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura-hr.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j/VyKcY8b8oiztzP2PPDO3W5n2EDqYUH2AhxchTmUF0=;
        b=Lm3tknJGHzMuoo/JoKQcKf/hq4d9/u81G9cSDkiJvcxCVQSQzcl6q9J5/V8Ycxz6F/
         U+gDZbCQdbhZHXlkVzcz1f72M1K5qjNwzfGBcEu+IqARI2VGamUJOEbQqEifS184y/Dz
         pV9iR1c/pHqOEFNQlK5EX+6aiGHVU9Blbm4mVDvkjn0gLp5vGRI6Tiv9OPH1WxkgAWop
         dMgNj9r8mvXP79+eqS27Pch3gAYX40tuies6jIZH0FbzMK7g4JBcO7N40GM+MU/K5zHx
         SlVrjBbBam5GkD1cuMa+Wr0Lr0gtsWIuZL3n+fT8ITCPpjOEM4Z5Ry7lDc9HFd7Np77Q
         bcpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j/VyKcY8b8oiztzP2PPDO3W5n2EDqYUH2AhxchTmUF0=;
        b=gs7HJ1r1GHu1mrMupPwPSI0804DAUOo/e86/zH2bMBSIpCfCraQlGLA+xSf81IHdzy
         0h0N4gQ/T1/clvWSjiuDjo+4l2scCWyAXbFxRcRk1DbfYXuVEA0N/5rPoK9XwVDyDgE2
         MYjSYrq/nw4sfVUKxl6L6Pk9K0OJnHU15DYVJ97WguUvlrySi3qFYcdFtkqMiGk7vzyv
         /pEZ+J2rb3QbLDrZYoOoGmVBurPybvGrR4ugtrqR18aHeZH86Y2IlKzKb9bVXrXyqjLx
         JtBs97ZRgPDuu5ecm5CHCqjfzVm3SsXdsuVefTkSbGJXQ5ZZy5QcLRxBS64jFFaM2EaQ
         7vrQ==
X-Gm-Message-State: AGi0PuZtyn4Ouu0cgZAszTl4dAhmV8hn4XoVFFIw+J2HDgRFuItY7Us1
        ROK7UCWFeNj6lFjjsk9OSRPmnA==
X-Google-Smtp-Source: APiQypL5WqrsJXFEguAFnCHDsfTAN940DneFBGtmY/ARw5g4wutj/XK9n/4MOOXWknLhcLYqKfK1Wg==
X-Received: by 2002:a7b:cd10:: with SMTP id f16mr2779712wmj.21.1588158464824;
        Wed, 29 Apr 2020 04:07:44 -0700 (PDT)
Received: from localhost.localdomain ([2a0e:b107:830:0:47e5:c676:4796:5818])
        by smtp.googlemail.com with ESMTPSA id u7sm7679963wmg.41.2020.04.29.04.07.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 04:07:44 -0700 (PDT)
From:   Robert Marko <robert.marko@sartura.hr>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, agross@kernel.org,
        bjorn.andersson@linaro.org, robh+dt@kernel.org,
        mark.rutland@arm.com, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Robert Marko <robert.marko@sartura.hr>
Subject: [PATCH net-next v4 0/3] net: phy: mdio: add IPQ40xx MDIO support
Date:   Wed, 29 Apr 2020 13:07:24 +0200
Message-Id: <20200429110726.448625-1-robert.marko@sartura.hr>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series provides support for the IPQ40xx built-in MDIO interface.
Included are driver, devicetree bindings for it and devicetree node.

Robert Marko (3):
  net: phy: mdio: add IPQ4019 MDIO driver
  dt-bindings: add Qualcomm IPQ4019 MDIO bindings
  ARM: dts: qcom: ipq4019: add MDIO node

 .../bindings/net/qcom,ipq4019-mdio.yaml       |  61 +++++++
 arch/arm/boot/dts/qcom-ipq4019.dtsi           |  28 +++
 drivers/net/phy/Kconfig                       |   7 +
 drivers/net/phy/Makefile                      |   1 +
 drivers/net/phy/mdio-ipq4019.c                | 160 ++++++++++++++++++
 5 files changed, 257 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml
 create mode 100644 drivers/net/phy/mdio-ipq4019.c

-- 
2.26.2


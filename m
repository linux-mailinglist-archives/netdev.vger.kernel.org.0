Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78D583403A0
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 11:41:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbhCRKlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 06:41:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbhCRKk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 06:40:56 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA972C06175F
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 03:40:45 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id t9so4939895wrn.11
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 03:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qCYiJkeZCY1l1SsCcTK0HNnk7v48LS6Za9V5wjwv5dY=;
        b=r4VVygKbT2vZHjUCjcrGtSyTQZBbmgOWydhHOkizgxJOp+lVAY8nBIGrVgsIWwlJIl
         ru+6ybaMvIeLcJfT0O5EGsOlKPK77oIlbl4QQYEUaS1KRO2A3HfQgt7XqISGewXlfreL
         QR7Wj35qfPf/G04wEIrOo7xtJlvUlE1l1wJffflwLIw5cmcHGXC21jRTa6v2VK9kmp/j
         uTh613RAdUT5hGGmlPGl2PNrsiJtkep8RuwdkZpfHPMciXqqFMBbuVHnLccYzZPH4TsE
         z6fqb2vnfTchZz7K4oyFTHV8YlZelZS8rK28QpIkKUhCztoFpfvvNVpW/dRCIR5PNtUb
         2TcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qCYiJkeZCY1l1SsCcTK0HNnk7v48LS6Za9V5wjwv5dY=;
        b=SclCgQIyVMbD4wbbMRXWneqXP5VL5OZSgSIiNeuLevdFL2pdw32JLCKNE1xRxSOLkS
         DCSwVjZg9BmSVy+clqyQarkaJDni/cZcFFokuGd69x6LrZCoosvr/O7u4QcMtNFgzJCZ
         Km8s6hKUmVVDTT/EkxVgbLWu6e7+8OASraVn7V93lryo5QeiChUVzB0QQWhYWnkIDBoa
         2jHvpg2NxW+O2tNUcUSkgIQXZ9l6srbnGypUc13KQnto9GEfKYD/jsbwAaWgnQlfl55A
         1T5b2GYxYs9LL4pfXYMQj6HbpJ5ZcWfFKj2AGLOUnmm1yzopx+74YTEXR8igcfKsL5mR
         A1ew==
X-Gm-Message-State: AOAM530LlX8nMqnswgdEMXLWjzn/kUkVynhHrqQmeiQk33qRKaKa9bG9
        4hKlD3CmeLC+OdRil92/rwe1OQ==
X-Google-Smtp-Source: ABdhPJwiyeOQSgB7d0Zh4PqZBrRW1L3J8yQ1rpmoDN74JORGtwBg1/+jZleEMAq/ZeX6kahGfjkjMw==
X-Received: by 2002:adf:efc7:: with SMTP id i7mr8994793wrp.182.1616064044413;
        Thu, 18 Mar 2021 03:40:44 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id z1sm2426033wru.95.2021.03.18.03.40.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 03:40:44 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Anton Vorontsov <anton@enomsg.org>, benh@kernel.crashing.org,
        Colin Cross <ccross@android.com>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Frank Rowand <frowand.list@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Kees Cook <keescook@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        netdev@vger.kernel.org,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Tony Luck <tony.luck@intel.com>
Subject: [PATCH v2 00/10] Rid W=1 warnings from OF
Date:   Thu, 18 Mar 2021 10:40:26 +0000
Message-Id: <20210318104036.3175910-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set is part of a larger effort attempting to clean-up W=1
kernel builds, which are currently overwhelmingly riddled with
niggly little warnings.

v2:
 - Provided some descriptions to exported functions

Lee Jones (10):
  of: device: Fix function name in header and provide missing
    descriptions
  of: dynamic: Fix incorrect parameter name and provide missing
    descriptions
  of: platform: Demote kernel-doc abuse
  of: base: Fix some formatting issues and provide missing descriptions
  of: property: Provide missing member description and remove excess
    param
  of: address: Provide descriptions for 'of_address_to_resource's params
  of: fdt: Demote kernel-doc abuses and fix function naming
  of: of_net: Provide function name and param description
  of: overlay: Fix function name disparity
  of: of_reserved_mem: Demote kernel-doc abuses

 drivers/of/address.c         |  3 +++
 drivers/of/base.c            | 16 +++++++++++-----
 drivers/of/device.c          |  7 ++++++-
 drivers/of/dynamic.c         |  4 +++-
 drivers/of/fdt.c             | 23 ++++++++++++-----------
 drivers/of/of_net.c          |  3 +++
 drivers/of/of_reserved_mem.c |  6 +++---
 drivers/of/overlay.c         |  2 +-
 drivers/of/platform.c        |  2 +-
 drivers/of/property.c        |  2 +-
 10 files changed, 44 insertions(+), 24 deletions(-)

Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Anton Vorontsov <anton@enomsg.org>
Cc: benh@kernel.crashing.org
Cc: Colin Cross <ccross@android.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: devicetree@vger.kernel.org
Cc: Frank Rowand <frowand.list@gmail.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Josh Cartwright <joshc@codeaurora.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: netdev@vger.kernel.org
Cc: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Tony Luck <tony.luck@intel.com>
-- 
2.27.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD2812FE0CD
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 05:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732183AbhAUEfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 23:35:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727570AbhAUEHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 23:07:32 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9ABC061793;
        Wed, 20 Jan 2021 20:06:13 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id 11so734736pfu.4;
        Wed, 20 Jan 2021 20:06:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AIpUkEzQRIQ1JtayAQGLOFR4gfftGr1JTJc3syKkHkA=;
        b=NS2qpjB15kdLX8w3huSUJngpg1qwMj8Lf+aB1u8ofKFBz+7r7OnobTCXsaKfBrjYBj
         NjO9U+vM491vCxXXH90HKDEEpbpfwkZPOdISKNApkUZaDnv4rUHb+BoKGgUnQPFRIm6q
         Ys2alv6iDLdB8fJoyYzS7KSeZTb2Ace9zoMjbu10zBwXsoBA+sE4XoavBthPlJKXIIx/
         jjui2ZwrLDpVtp5r6de/lgi/YH162eoJFYJP1xplmQtKg9dVlAB6YCgg6wQmvPUDJ6hn
         Xyj9OAu/Un7yJ7ldMq3zC5109I7YvGnamlZ8UKVue/Yb8ZMogjU3tbDkTBoAstlAaHMd
         lFZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AIpUkEzQRIQ1JtayAQGLOFR4gfftGr1JTJc3syKkHkA=;
        b=X26TbimgF67XGVJnXr6MEzLWuvLo2dwaQPhjYuxqmBTcWs4TkmBtQTfwEvD+HctK1F
         PKmOYby0GhgfaVR2uVp9Y6Y02fSnDnNBDeByfLy9YUAM49y8V9NMXkMwoattbdbT8j4x
         RQpPmpxiINTMETJqY+TH8h4vKfUHDy0R4M17W3+vGP0RQvo0fRi2ftgugb0If6Yqvba5
         CrkZZPdJA8EUfd1aGzBrDRUEm618md1oq4DC9M7k8gtnMW5GuLXZ3YLmOQo7Ymm8RGZT
         MbXztGavdHR4A2E7EV3mJSoFd1KHxpemQxLxIGLjV1Lp43lg/hJfFA4LKnzdPVG8NVkP
         ry+g==
X-Gm-Message-State: AOAM533GosNWlED7ipWqEx4dnCu7oirQgq7E8/750DrcaRJ64CI2wrN6
        C+uDB36uyU/mo7uO6P3iyq7xHQnIPmk=
X-Google-Smtp-Source: ABdhPJzyVK0Mi7Qkyx7htecoKKO2EjVmqGQ0RQqv4Qv1BeR0eTRDW2+6QoaMyu1T1ZDdTPCVx/VqJQ==
X-Received: by 2002:a63:2cd:: with SMTP id 196mr12734157pgc.398.1611201972497;
        Wed, 20 Jan 2021 20:06:12 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id f24sm3808567pjj.5.2021.01.20.20.06.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 20:06:11 -0800 (PST)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Brandon Streiff <brandon.streiff@ni.com>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Marc Zyngier <maz@kernel.org>, Olof Johansson <olof@lixom.net>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 3/4] ARM: socfpga_defconfig: Disable PHY time stamping by default.
Date:   Wed, 20 Jan 2021 20:06:02 -0800
Message-Id: <5ba5eaabd8dd610fa6b269fc746fd98421fe22a0.1611198584.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1611198584.git.richardcochran@gmail.com>
References: <cover.1611198584.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The NETWORK_PHY_TIMESTAMPING configuration option adds overhead into
the networking stack.  When enabled, all transmitted and received
frames are subjected to extra tests to determine whether they just
might be PTP frames to be presented to esoteric PHY time stamping
drivers.

However, no System on Chip, least ways not the socfpga SoC, includes
such a PHY time stamping device.  Disable the unneeded option by
default.

The diff includes a bit of extra churn caused by "make savedefconfig",
but the generated defconfig is now in the canonical form.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
---
 arch/arm/configs/socfpga_defconfig | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/arm/configs/socfpga_defconfig b/arch/arm/configs/socfpga_defconfig
index e73c97b0f5b0..5bd433028285 100644
--- a/arch/arm/configs/socfpga_defconfig
+++ b/arch/arm/configs/socfpga_defconfig
@@ -14,8 +14,6 @@ CONFIG_ARM_THUMBEE=y
 CONFIG_SMP=y
 CONFIG_NR_CPUS=2
 CONFIG_HIGHMEM=y
-CONFIG_ZBOOT_ROM_TEXT=0x0
-CONFIG_ZBOOT_ROM_BSS=0x0
 CONFIG_VFP=y
 CONFIG_NEON=y
 CONFIG_OPROFILE=y
@@ -33,7 +31,6 @@ CONFIG_IP_PNP=y
 CONFIG_IP_PNP_DHCP=y
 CONFIG_IP_PNP_BOOTP=y
 CONFIG_IP_PNP_RARP=y
-CONFIG_NETWORK_PHY_TIMESTAMPING=y
 CONFIG_VLAN_8021Q=y
 CONFIG_VLAN_8021Q_GVRP=y
 CONFIG_CAN=y
@@ -48,12 +45,10 @@ CONFIG_DEVTMPFS=y
 CONFIG_DEVTMPFS_MOUNT=y
 CONFIG_MTD=y
 CONFIG_MTD_BLOCK=y
-CONFIG_MTD_M25P80=y
 CONFIG_MTD_RAW_NAND=y
 CONFIG_MTD_NAND_DENALI_DT=y
 CONFIG_MTD_SPI_NOR=y
 # CONFIG_MTD_SPI_NOR_USE_4K_SECTORS is not set
-CONFIG_SPI_CADENCE_QUADSPI=y
 CONFIG_OF_OVERLAY=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=y
@@ -89,6 +84,7 @@ CONFIG_I2C=y
 CONFIG_I2C_CHARDEV=y
 CONFIG_I2C_DESIGNWARE_PLATFORM=y
 CONFIG_SPI=y
+CONFIG_SPI_CADENCE_QUADSPI=y
 CONFIG_SPI_DESIGNWARE=y
 CONFIG_SPI_DW_MMIO=y
 CONFIG_SPI_SPIDEV=y
-- 
2.20.1


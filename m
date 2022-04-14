Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8494F5018B4
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 18:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234101AbiDNQfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 12:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232575AbiDNQen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 12:34:43 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 623EED59
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 09:03:19 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id mp16-20020a17090b191000b001cb5efbcab6so9675426pjb.4
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 09:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gYZcqKE4gPDeEOq6vTanVgpcbt838PrfODIBOARgOwI=;
        b=4vuqFuX1dWiC5cbQZSo/4Nymm/397TPgn4uZnwxpIHvo7WmsxxQEWcubR+78H9RGkS
         tqwbnVO6dIGbhVLHh4EcXCkn4PtpZgmVDO8AjkKEKTV+6FOzUGn9o9QzQsE3usQ1Pv8+
         A9YQHbxVWcxkYB6k98I7dBsIpti/5SF3Vd0xVmKorRrldBywq40dJWsbeFlknWApg2WJ
         VF9COUCF7DFhm4zkTc3pYEI22QCZF15AThM2bok7ptikUiJT8gV3Sb597vhM9fPDGC7N
         KqKPx1caag9BIPESKDcKIGKf/EYsZ1xaK5/NXpz7hLRVNX5sx35CNbqmuUJ15M2dk1pY
         5TZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gYZcqKE4gPDeEOq6vTanVgpcbt838PrfODIBOARgOwI=;
        b=dj9lyPUB5kBLLWQ1tn2FPHLUMEixMYGDdJTcxWl3S4yq//TkBLNklb2CH+X8AyZc9v
         BZnc9cUoVbHsJozpTJciv708nZ/FdU+lSiszEtkkRlnpVRCZ4Hh0rgveBh2qIYBEbALB
         Ukgp5ysH2vTLbxGtEmVpDv/pJ9naKJMtb4Lxurtlijz9llA+YgC0IY939kfj76o4ROT0
         RthwyJazPGnPsj12aYcNl1czgcf9Su8KMU8DxutNz/AHPYAE2JupCUKwozmIZG5AWRhu
         yXmbCoGhm/xJmVoLiIq3Ghc43oYWVhX5JrWhZLss9XZORoe6ju0DX58N17QhlF6PX8Kd
         IYkw==
X-Gm-Message-State: AOAM532reScm4ZPbFQmqt4cN9tWL35/Uvxdvu4k9ZgzozZWYBd4N1l/R
        0VS4tex0owphqSKw2gP9p/nKt2/i6JDH2A==
X-Google-Smtp-Source: ABdhPJxwpB4OEHYX+HrxFPLkb3cIMhFw8/1arc2ZYfNvjukO2q+K0xJUf8EeHiI49j7WNtRMHneGWQ==
X-Received: by 2002:a17:902:854c:b0:158:35ce:9739 with SMTP id d12-20020a170902854c00b0015835ce9739mr26794439plo.150.1649952198568;
        Thu, 14 Apr 2022 09:03:18 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id h14-20020a63384e000000b00366ba5335e7sm2310922pgn.72.2022.04.14.09.03.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 09:03:17 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Shachar Raindel <shacharr@microsoft.com>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Dimitris Michailidis <d.michailidis@fungible.com>,
        =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>,
        Dexuan Cui <decui@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] net: restore alpha order to Ethernet devices in config
Date:   Thu, 14 Apr 2022 09:03:12 -0700
Message-Id: <20220414160315.105212-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The displayed list of Ethernet devices in make menuconfig
has gotten out of order. This is mostly due to changes in vendor
names etc, but also because of new Microsoft entry in wrong place.

This restores so that the display is in order even if the names
of the sub directories are not.

Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 drivers/net/ethernet/Kconfig | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/Kconfig b/drivers/net/ethernet/Kconfig
index bd4cb9d7c35d..827993022386 100644
--- a/drivers/net/ethernet/Kconfig
+++ b/drivers/net/ethernet/Kconfig
@@ -35,15 +35,6 @@ source "drivers/net/ethernet/aquantia/Kconfig"
 source "drivers/net/ethernet/arc/Kconfig"
 source "drivers/net/ethernet/asix/Kconfig"
 source "drivers/net/ethernet/atheros/Kconfig"
-source "drivers/net/ethernet/broadcom/Kconfig"
-source "drivers/net/ethernet/brocade/Kconfig"
-source "drivers/net/ethernet/cadence/Kconfig"
-source "drivers/net/ethernet/calxeda/Kconfig"
-source "drivers/net/ethernet/cavium/Kconfig"
-source "drivers/net/ethernet/chelsio/Kconfig"
-source "drivers/net/ethernet/cirrus/Kconfig"
-source "drivers/net/ethernet/cisco/Kconfig"
-source "drivers/net/ethernet/cortina/Kconfig"
 
 config CX_ECAT
 	tristate "Beckhoff CX5020 EtherCAT master support"
@@ -57,6 +48,14 @@ config CX_ECAT
 	  To compile this driver as a module, choose M here. The module
 	  will be called ec_bhf.
 
+source "drivers/net/ethernet/broadcom/Kconfig"
+source "drivers/net/ethernet/cadence/Kconfig"
+source "drivers/net/ethernet/calxeda/Kconfig"
+source "drivers/net/ethernet/cavium/Kconfig"
+source "drivers/net/ethernet/chelsio/Kconfig"
+source "drivers/net/ethernet/cirrus/Kconfig"
+source "drivers/net/ethernet/cisco/Kconfig"
+source "drivers/net/ethernet/cortina/Kconfig"
 source "drivers/net/ethernet/davicom/Kconfig"
 
 config DNET
@@ -85,7 +84,6 @@ source "drivers/net/ethernet/huawei/Kconfig"
 source "drivers/net/ethernet/i825xx/Kconfig"
 source "drivers/net/ethernet/ibm/Kconfig"
 source "drivers/net/ethernet/intel/Kconfig"
-source "drivers/net/ethernet/microsoft/Kconfig"
 source "drivers/net/ethernet/xscale/Kconfig"
 
 config JME
@@ -128,8 +126,9 @@ source "drivers/net/ethernet/mediatek/Kconfig"
 source "drivers/net/ethernet/mellanox/Kconfig"
 source "drivers/net/ethernet/micrel/Kconfig"
 source "drivers/net/ethernet/microchip/Kconfig"
-source "drivers/net/ethernet/moxa/Kconfig"
 source "drivers/net/ethernet/mscc/Kconfig"
+source "drivers/net/ethernet/microsoft/Kconfig"
+source "drivers/net/ethernet/moxa/Kconfig"
 source "drivers/net/ethernet/myricom/Kconfig"
 
 config FEALNX
@@ -141,10 +140,10 @@ config FEALNX
 	  Say Y here to support the Myson MTD-800 family of PCI-based Ethernet
 	  cards. <http://www.myson.com.tw/>
 
+source "drivers/net/ethernet/ni/Kconfig"
 source "drivers/net/ethernet/natsemi/Kconfig"
 source "drivers/net/ethernet/neterion/Kconfig"
 source "drivers/net/ethernet/netronome/Kconfig"
-source "drivers/net/ethernet/ni/Kconfig"
 source "drivers/net/ethernet/8390/Kconfig"
 source "drivers/net/ethernet/nvidia/Kconfig"
 source "drivers/net/ethernet/nxp/Kconfig"
@@ -164,6 +163,7 @@ source "drivers/net/ethernet/packetengines/Kconfig"
 source "drivers/net/ethernet/pasemi/Kconfig"
 source "drivers/net/ethernet/pensando/Kconfig"
 source "drivers/net/ethernet/qlogic/Kconfig"
+source "drivers/net/ethernet/brocade/Kconfig"
 source "drivers/net/ethernet/qualcomm/Kconfig"
 source "drivers/net/ethernet/rdc/Kconfig"
 source "drivers/net/ethernet/realtek/Kconfig"
@@ -171,10 +171,10 @@ source "drivers/net/ethernet/renesas/Kconfig"
 source "drivers/net/ethernet/rocker/Kconfig"
 source "drivers/net/ethernet/samsung/Kconfig"
 source "drivers/net/ethernet/seeq/Kconfig"
-source "drivers/net/ethernet/sfc/Kconfig"
 source "drivers/net/ethernet/sgi/Kconfig"
 source "drivers/net/ethernet/silan/Kconfig"
 source "drivers/net/ethernet/sis/Kconfig"
+source "drivers/net/ethernet/sfc/Kconfig"
 source "drivers/net/ethernet/smsc/Kconfig"
 source "drivers/net/ethernet/socionext/Kconfig"
 source "drivers/net/ethernet/stmicro/Kconfig"
-- 
2.35.1


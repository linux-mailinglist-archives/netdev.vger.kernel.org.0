Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7208411BCF5
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 20:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729394AbfLKT2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 14:28:15 -0500
Received: from mail-ua1-f74.google.com ([209.85.222.74]:49660 "EHLO
        mail-ua1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729346AbfLKT2O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 14:28:14 -0500
Received: by mail-ua1-f74.google.com with SMTP id n6so6470898uae.16
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 11:28:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=RQFDo13VZRdiKwc/pVrHKJHbLovklfvTM/XI87MZyHc=;
        b=hk5XU7cUaCcQ0Nde+eT5cb/6qwUvOjqFutXP7PRicgzyIGfK7KSbsZII98DfGIn2FW
         dtQymELG0GrhacSnYHQp3RHByaT46VfTyG6tnTl4Jsk836X8X+fyiDg1vDM0umT5oppm
         UgVIqhFFhkz4LTwJvtJFgchjlga2R0OupRlXvw3oko/W+1K9fRHoYDgICYr3QjciF1hv
         60PjkiTLGt5xA3chP4Yx0vIchU/ZZ3iaMRNuguxvUHnFe1WEFaZso9+eBFcxLjuV0NVZ
         /07928V8wcKVNcx4O0aZhvCWDioa2HlcD1rankvFdc0518jUklNNTHG92Y9KtstUiOND
         P6JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=RQFDo13VZRdiKwc/pVrHKJHbLovklfvTM/XI87MZyHc=;
        b=PDwXsptM9qT3aq4j2rKBKWFyk9dqtCHz2PT86BL6i7EoF2ypxMvjhcpZDiMtKyTikW
         mfJVnr6gu4prwKgB0ZKAwTTpcKIWaIkCHEcx5Twgd8LESGCn3Gvcfmri2Y+wKL3J6ndI
         2yZTgugKFpgGAALRRzMrClCGIJAYQ5SPRzDb8MLb2RMff/Ubc1CLCPXRKQJb0H4NNBSE
         xjK3i7XwZk3fVWDnzLmCVKIQ2jf7u8Oww6PCzoZ/njRCtiHhU3ncsfFRHIr/oXJIelGy
         xeWIvX3x82bH9nrzXFPLQUJmBAyzmVyFJ4DD7ZeHavtDhZIF8Fo0Ui0/FQ25sx6RXuoo
         iGAA==
X-Gm-Message-State: APjAAAU/CMcUoEOm9xBcjO96s0stuRxXERz0tIAN+o0ejmi2cbI7eqnq
        i88Q3ZAL7vRMD0CfpNgFiZ3m8GOr5OH/NUFsTZJLgw==
X-Google-Smtp-Source: APXvYqxn1i43i48Jqfr6hVocDDO1DiINGbV0G5JeKpjCv8KvGUu2v9FiOXP9TMA8RDO8XOUYwG4WIpJMJNZpSQ90pHgIUg==
X-Received: by 2002:a1f:6103:: with SMTP id v3mr5185450vkb.60.1576092492825;
 Wed, 11 Dec 2019 11:28:12 -0800 (PST)
Date:   Wed, 11 Dec 2019 11:27:38 -0800
In-Reply-To: <20191211192742.95699-1-brendanhiggins@google.com>
Message-Id: <20191211192742.95699-4-brendanhiggins@google.com>
Mime-Version: 1.0
References: <20191211192742.95699-1-brendanhiggins@google.com>
X-Mailer: git-send-email 2.24.0.525.g8f36a354ae-goog
Subject: [PATCH v1 3/7] net: axienet: add unspecified HAS_IOMEM dependency
From:   Brendan Higgins <brendanhiggins@google.com>
To:     jdike@addtoit.com, richard@nod.at, anton.ivanov@cambridgegreys.com,
        "David S. Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Cc:     linux-um@lists.infradead.org, linux-kernel@vger.kernel.org,
        davidgow@google.com, Brendan Higgins <brendanhiggins@google.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently CONFIG_XILINX_AXI_EMAC=y implicitly depends on
CONFIG_HAS_IOMEM=y; consequently, on architectures without IOMEM we get
the following build error:

ld: drivers/net/ethernet/xilinx/xilinx_axienet_main.o: in function `axienet_probe':
drivers/net/ethernet/xilinx/xilinx_axienet_main.c:1680: undefined reference to `devm_ioremap_resource'
ld: drivers/net/ethernet/xilinx/xilinx_axienet_main.c:1779: undefined reference to `devm_ioremap_resource'
ld: drivers/net/ethernet/xilinx/xilinx_axienet_main.c:1789: undefined reference to `devm_ioremap_resource'

Fix the build error by adding the unspecified dependency.

Reported-by: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Brendan Higgins <brendanhiggins@google.com>
---
 drivers/net/ethernet/xilinx/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/xilinx/Kconfig b/drivers/net/ethernet/xilinx/Kconfig
index 6304ebd8b5c69..b1a285e693756 100644
--- a/drivers/net/ethernet/xilinx/Kconfig
+++ b/drivers/net/ethernet/xilinx/Kconfig
@@ -25,6 +25,7 @@ config XILINX_EMACLITE
 
 config XILINX_AXI_EMAC
 	tristate "Xilinx 10/100/1000 AXI Ethernet support"
+	depends on HAS_IOMEM
 	select PHYLINK
 	---help---
 	  This driver supports the 10/100/1000 Ethernet from Xilinx for the
-- 
2.24.0.525.g8f36a354ae-goog


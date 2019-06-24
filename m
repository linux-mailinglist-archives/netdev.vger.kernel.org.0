Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 005DD50CA6
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 15:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731601AbfFXNxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 09:53:12 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44560 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725562AbfFXNxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 09:53:11 -0400
Received: by mail-pg1-f194.google.com with SMTP id n2so7149080pgp.11;
        Mon, 24 Jun 2019 06:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mlREJgkyzOGgqa6hvXlcb+zdPjqgmfDST6qRrYmoOVw=;
        b=pnutwrSCoeiVbQcU9DkZgxhdQoYC5u3JvE+2/kRDTf4CcjA+odO39HCpoT8nNdUoyx
         72AKfdG/8Ly1X37qsowfkEO7Yf+lURhuSCuX/iC28dooZGA5EZ3bHHsKho6TlAQTa6/v
         ujo8thuH53L0+e4Hu6gHI95j+DvGQleG8rpS5/1BxhB/mkOOZjNdKaWK0J1RC116NEny
         lXj+/7W0Hq7s8wQirE82ewxN0xSy/XHbbLhCNrOxBn1xRnirlQYKobWSJr4axbwbX86t
         nhcrXkVbrTrLBCOamZgakH4jaKbwnuTyRMY+YI5itoZBaGq+I0wOz5265IlnTGblOeza
         w5Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mlREJgkyzOGgqa6hvXlcb+zdPjqgmfDST6qRrYmoOVw=;
        b=mZ5n46OcDgRpI1QEWpafw6Q8EWl41l6W9aaDZ5HWcXKgnoiW4HwfJkkm1c4EdYJK+B
         TFO2qAVuUP8u19TdnePo9RCtUUUS5SJyXUheGgOZx+lLlEst6cVvZqEAVIglFIxSZIm0
         S6z66R6i87/jm+Dt2cUhwfafZPpwfvQU1NwG8ixRy8PK0LeD2WaGCqQs97c9JCGfFDwA
         z7EYqDdtHBgIc40/e0jrYM1fiSZlDp2W+3aEOlNNjAdiBMrdhYYySPniAFqC5i/li9bw
         JsZ50r/ZDClTI1x2idcWSEQFrbuMSyXHGo8K2x1ikX99hq6uwhndO4AAI/VbGqvw9UPd
         +eVw==
X-Gm-Message-State: APjAAAW8RxXKReXCaFF3mb2dKfHflhlHn2sv7iQIs36u1fEjN4vGhFoI
        W/67Uw4qNVGWJSFgaU7zQrk=
X-Google-Smtp-Source: APXvYqzse+VFf64kzLouPN0q5GfeLrAJ/iw4TIxkxhixEbOwGKoY5YEMBiAgvW+wzZlQdLb6eoCK7g==
X-Received: by 2002:a17:90a:2ec1:: with SMTP id h1mr25021009pjs.101.1561384390859;
        Mon, 24 Jun 2019 06:53:10 -0700 (PDT)
Received: from debian.net.fpt ([58.187.168.105])
        by smtp.gmail.com with ESMTPSA id 85sm11187901pgb.52.2019.06.24.06.53.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 06:53:10 -0700 (PDT)
From:   Phong Tran <tranmanphong@gmail.com>
To:     tranmanphong@gmail.com
Cc:     acme@kernel.org, alexander.shishkin@linux.intel.com,
        alexander.sverdlin@gmail.com, allison@lohutok.net, andrew@lunn.ch,
        ast@kernel.org, bgolaszewski@baylibre.com, bpf@vger.kernel.org,
        daniel@iogearbox.net, daniel@zonque.org, dmg@turingmachine.org,
        festevam@gmail.com, gerg@uclinux.org, gregkh@linuxfoundation.org,
        gregory.clement@bootlin.com, haojian.zhuang@gmail.com,
        hsweeten@visionengravers.com, illusionist.neo@gmail.com,
        info@metux.net, jason@lakedaemon.net, jolsa@redhat.com,
        kafai@fb.com, kernel@pengutronix.de, kgene@kernel.org,
        krzk@kernel.org, kstewart@linuxfoundation.org,
        linux-arm-kernel@lists.infradead.org, linux-imx@nxp.com,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux@armlinux.org.uk,
        liviu.dudau@arm.com, lkundrak@v3.sk, lorenzo.pieralisi@arm.com,
        mark.rutland@arm.com, mingo@redhat.com, namhyung@kernel.org,
        netdev@vger.kernel.org, nsekhar@ti.com, peterz@infradead.org,
        robert.jarzmik@free.fr, s.hauer@pengutronix.de,
        sebastian.hesselbarth@gmail.com, shawnguo@kernel.org,
        songliubraving@fb.com, sudeep.holla@arm.com, swinslow@gmail.com,
        tglx@linutronix.de, tony@atomide.com, will@kernel.org, yhs@fb.com
Subject: [PATCH V2 10/15] ARM: orion5x: cleanup cppcheck shifting errors
Date:   Mon, 24 Jun 2019 20:51:00 +0700
Message-Id: <20190624135105.15579-11-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190624135105.15579-1-tranmanphong@gmail.com>
References: <20190623151313.970-1-tranmanphong@gmail.com>
 <20190624135105.15579-1-tranmanphong@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[arch/arm/mach-orion5x/pci.c:281]: (error) Shifting signed 32-bit value
by 31 bits is undefined behaviour
[arch/arm/mach-orion5x/pci.c:305]: (error) Shifting signed 32-bit value
by 31 bits is undefined behaviour

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 arch/arm/mach-orion5x/pci.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-orion5x/pci.c b/arch/arm/mach-orion5x/pci.c
index 76951bfbacf5..f47668530d5e 100644
--- a/arch/arm/mach-orion5x/pci.c
+++ b/arch/arm/mach-orion5x/pci.c
@@ -200,13 +200,13 @@ static int __init pcie_setup(struct pci_sys_data *sys)
 /*
  * PCI_MODE bits
  */
-#define PCI_MODE_64BIT			(1 << 2)
-#define PCI_MODE_PCIX			((1 << 4) | (1 << 5))
+#define PCI_MODE_64BIT			BIT(2)
+#define PCI_MODE_PCIX			(BIT(4) | BIT(5))
 
 /*
  * PCI_CMD bits
  */
-#define PCI_CMD_HOST_REORDER		(1 << 29)
+#define PCI_CMD_HOST_REORDER		BIT(29)
 
 /*
  * PCI_P2P_CONF bits
@@ -223,7 +223,7 @@ static int __init pcie_setup(struct pci_sys_data *sys)
 #define PCI_CONF_FUNC(func)		(((func) & 0x3) << 8)
 #define PCI_CONF_DEV(dev)		(((dev) & 0x1f) << 11)
 #define PCI_CONF_BUS(bus)		(((bus) & 0xff) << 16)
-#define PCI_CONF_ADDR_EN		(1 << 31)
+#define PCI_CONF_ADDR_EN		BIT(31)
 
 /*
  * Internal configuration space
-- 
2.11.0


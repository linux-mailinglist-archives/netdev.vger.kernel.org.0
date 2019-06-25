Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44E37521B3
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 06:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbfFYEGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 00:06:06 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38005 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbfFYEGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 00:06:05 -0400
Received: by mail-pf1-f194.google.com with SMTP id y15so4086204pfn.5;
        Mon, 24 Jun 2019 21:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7+uT5l4SI9KUGhnGj8pF0zC23hQ8u8aSZYqwmnqFj+w=;
        b=PNlyZWSoCU7l5uDic3Knn28MqbfxUiHK4vRg2k9s5new2imIWuYxxYzc2KUG6h7bZJ
         xtg9GiD/Z99BkkXe1vbzqVGUb/2+5MzOCOLTIh6qi3GEEQ3TTvocnZj2q/HRnX8f/5Vj
         NeaHoK4yjxNkTgrxzKDQuJh1/+ayo9px3D+LfTdJN+8G4Xbn8/C8F47PJqXJtzrmFy3e
         gP1dJ932jvHmv8FTIOsy/5bLVHZH40zATj+mDJZzVreCUKvyRY2QjYBqVatOC3pk6Nod
         G37fTmWNrl8RY4Flcqld8MovGl8uJcj2Ak/vw+ythRSAHILLkYSTRRxT5CO+scg5JGRt
         rfKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7+uT5l4SI9KUGhnGj8pF0zC23hQ8u8aSZYqwmnqFj+w=;
        b=jL8TN4B69XGHyHUaHHwbhtnhbzB/Qp36MzI4tM/0CEInTknHtGpgQX3+v2G8tvu9HR
         WbJA5wwHuKLeb/y1SNYm8y/7qfAyofq9FLulr5xyfHqMQYOPDaG1Cq/1EJbX9wcQt801
         Q4WyS7xu047j8johMDv2Nf6IqCVFjm7DTFDKIGjja0hRu3NlLT6F9jYQD8jgYmVK4A2q
         DAnlUAM71LT7xQo86Bu2XFK6F/5D2BcoJhj+kFFhzsSWp3HEDrY0Yf8h7N6ueK0JAH0Y
         MTAY7TAOahsZrNDFbW53VHLvQrJWFyxpxXNSxhx5mW2NWEly2lmqbpiaZb0xHO5/UrUi
         x9/g==
X-Gm-Message-State: APjAAAXjAP3bJzDwzDy0MBIE1ncgTaeDaLh++jxJyKYGh5L7for0jV9P
        um4rbZPleFOW1wnoU7zvnHY=
X-Google-Smtp-Source: APXvYqxDpEvH6x3GHM0J9Nas5JkbUnDtRpo/mtpP9ZL404it433mB9RPxi/8HhaPU+n0KCgsqBSp+g==
X-Received: by 2002:a63:130c:: with SMTP id i12mr1386060pgl.316.1561435564661;
        Mon, 24 Jun 2019 21:06:04 -0700 (PDT)
Received: from debian.net.fpt ([58.187.168.105])
        by smtp.gmail.com with ESMTPSA id b24sm12408944pfd.98.2019.06.24.21.05.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 21:06:03 -0700 (PDT)
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
Subject: [PATCH V3 10/15] ARM: orion5x: cleanup cppcheck shifting errors
Date:   Tue, 25 Jun 2019 11:03:51 +0700
Message-Id: <20190625040356.27473-11-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190625040356.27473-1-tranmanphong@gmail.com>
References: <20190624135105.15579-1-tranmanphong@gmail.com>
 <20190625040356.27473-1-tranmanphong@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is error from cppcheck tool
"Shifting signed 32-bit value by 31 bits is undefined behaviour errors"
change to use BIT() marco for improvement.

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


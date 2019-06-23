Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 244014FC52
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 17:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbfFWPPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 11:15:51 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34747 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbfFWPPu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 11:15:50 -0400
Received: by mail-pg1-f194.google.com with SMTP id p10so5743425pgn.1;
        Sun, 23 Jun 2019 08:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=iEUMhUEjEitOfWF+vqNDIhFcTHZuZVGZY7Fo6d46hHU=;
        b=JDDns5vZSYa4pTYj+E3oSZbh2fc9cS7+LGq38tiYcpQKqkk/6HqlxUxGVNZ8Giskf2
         wVc63GW8jff2J7Stnfvg+seZnm4HKr4tsCGgfZfgEhSnOIyghq3J3zMMCOoxApJBD0tN
         7bEZREn44y7JORzIMGaLxa+B0lJ8Q6maCFT5Kc5v2cPGDcM1iushQFJ/ZrxZ95K+BVyj
         0KuUqG+FjW9/UwGordFk3hX31egSaqGQItlNtp3VmQlXYfRAba2tBnA9xgU/DKuI6a3U
         Uey5tSWcFsmnAEGI3NSq5RNsXjyZhTyoOb7QkA7nWVWtHqg/01j57HpaEjJgN3engorh
         0a0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=iEUMhUEjEitOfWF+vqNDIhFcTHZuZVGZY7Fo6d46hHU=;
        b=lG9J3NMXINrAdRjW7NUJEMOnxMdLhqx1Z8vOMPOLTps98EF5PY9HLOWMKhfy4oY0AD
         H8vtt8UrkBJqCZPdhcghMsUdg/hb3mO/eVwCO72o+XCb18MvUouBp85whFXvWkmOfbH/
         pG0C42y/5k8fkXqFunaMRBk0WzxUDayt71gd7Q9aGblnxCfAlyy6rUNXfOUndt9E3PMn
         NC5rv3d9RxC73LGcsIdoEWLoSH1WYKBA+kOb1N8oa4GN+Q61ikASxtMIsaVok0oEIxYT
         OIU+OpOrqrlY3cBl3E4XY1zdZ4xkKTtEWk+g4Ct2OktoaD1Ohba7+vK+IN5u+N4UHYmp
         VJWA==
X-Gm-Message-State: APjAAAWOWF+NRWdWiBvace+92QYu4uTygTJKHN/cIeNkATofKQ3yLeLq
        eirJD2/GuE2zeX1NvgjGjSI=
X-Google-Smtp-Source: APXvYqw/LW9dpuMtgQ6hdyukbmfTSOGbcbw75mt7vXGI4TjQSlgJCDboV6mow3iVH/btREzmijvbSQ==
X-Received: by 2002:a17:90a:7107:: with SMTP id h7mr18900324pjk.38.1561302949745;
        Sun, 23 Jun 2019 08:15:49 -0700 (PDT)
Received: from debian.net.fpt ([1.55.47.94])
        by smtp.gmail.com with ESMTPSA id p6sm8329194pgs.77.2019.06.23.08.15.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 23 Jun 2019 08:15:49 -0700 (PDT)
From:   Phong Tran <tranmanphong@gmail.com>
To:     mark.rutland@arm.com, kstewart@linuxfoundation.org,
        songliubraving@fb.com, andrew@lunn.ch, peterz@infradead.org,
        nsekhar@ti.com, ast@kernel.org, jolsa@redhat.com,
        netdev@vger.kernel.org, gerg@uclinux.org,
        lorenzo.pieralisi@arm.com, will@kernel.org,
        linux-samsung-soc@vger.kernel.org, daniel@iogearbox.net,
        tranmanphong@gmail.com, festevam@gmail.com,
        gregory.clement@bootlin.com, allison@lohutok.net,
        linux@armlinux.org.uk, krzk@kernel.org, haojian.zhuang@gmail.com,
        bgolaszewski@baylibre.com, tony@atomide.com, mingo@redhat.com,
        linux-imx@nxp.com, yhs@fb.com, sebastian.hesselbarth@gmail.com,
        illusionist.neo@gmail.com, jason@lakedaemon.net,
        liviu.dudau@arm.com, s.hauer@pengutronix.de, acme@kernel.org,
        lkundrak@v3.sk, robert.jarzmik@free.fr, dmg@turingmachine.org,
        swinslow@gmail.com, namhyung@kernel.org, tglx@linutronix.de,
        linux-omap@vger.kernel.org, alexander.sverdlin@gmail.com,
        linux-arm-kernel@lists.infradead.org, info@metux.net,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        alexander.shishkin@linux.intel.com, hsweeten@visionengravers.com,
        kgene@kernel.org, kernel@pengutronix.de, sudeep.holla@arm.com,
        bpf@vger.kernel.org, shawnguo@kernel.org, kafai@fb.com,
        daniel@zonque.org
Subject: [PATCH 10/15] ARM: orion5x: cleanup cppcheck shifting errors
Date:   Sun, 23 Jun 2019 22:13:08 +0700
Message-Id: <20190623151313.970-11-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190623151313.970-1-tranmanphong@gmail.com>
References: <20190623151313.970-1-tranmanphong@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[arch/arm/mach-orion5x/pci.c:281]: (error) Shifting signed 32-bit value
by 31 bits is undefined behaviour
[arch/arm/mach-orion5x/pci.c:305]: (error) Shifting signed 32-bit value
by 31 bits is undefined behaviour

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
---
 arch/arm/mach-orion5x/pci.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-orion5x/pci.c b/arch/arm/mach-orion5x/pci.c
index 76951bfbacf5..1b2c077ee7b8 100644
--- a/arch/arm/mach-orion5x/pci.c
+++ b/arch/arm/mach-orion5x/pci.c
@@ -200,13 +200,13 @@ static int __init pcie_setup(struct pci_sys_data *sys)
 /*
  * PCI_MODE bits
  */
-#define PCI_MODE_64BIT			(1 << 2)
-#define PCI_MODE_PCIX			((1 << 4) | (1 << 5))
+#define PCI_MODE_64BIT			(1U << 2)
+#define PCI_MODE_PCIX			((1U << 4) | (1U << 5))
 
 /*
  * PCI_CMD bits
  */
-#define PCI_CMD_HOST_REORDER		(1 << 29)
+#define PCI_CMD_HOST_REORDER		(1U << 29)
 
 /*
  * PCI_P2P_CONF bits
@@ -223,7 +223,7 @@ static int __init pcie_setup(struct pci_sys_data *sys)
 #define PCI_CONF_FUNC(func)		(((func) & 0x3) << 8)
 #define PCI_CONF_DEV(dev)		(((dev) & 0x1f) << 11)
 #define PCI_CONF_BUS(bus)		(((bus) & 0xff) << 16)
-#define PCI_CONF_ADDR_EN		(1 << 31)
+#define PCI_CONF_ADDR_EN		(1U << 31)
 
 /*
  * Internal configuration space
-- 
2.11.0


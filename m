Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 992594FC45
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 17:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbfFWPPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 11:15:21 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41690 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726429AbfFWPPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 11:15:20 -0400
Received: by mail-pg1-f194.google.com with SMTP id y72so5718101pgd.8;
        Sun, 23 Jun 2019 08:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=tYXgV+4FEeL0stwiIRomoDd4zL1RwU+zsYxx6pR+GDg=;
        b=iyDbf5jlcK5ckqHBofdjPOTeaOjt1s9Bz0tufSk8MuyD6kKQ16ULq/0uDoakNxthGu
         PCYPz0UYxjvTrms3agRe0akLUxfOh2Zy1jtc22jlpLVqysEfoyhbnEuAtiMf3cWVmEPb
         uXuKZHREovOuTFjOGSrrCZdaQDKkNEuxZDAnfglkU0RsWP4/NwQLbcj4GO/zf4v290FR
         moLz2g/f/5xqCY5JdBbA7677bQ/O0zon3J+fTgf52dIpVyGB7yoodE/CLWVjDYYZiK2d
         Pnv9PLY0DGJzZ72awpIzgpIe+md7pW+kxTG7+R+S6UH4kgRwX6yaD/ej87MQBjv2E0ow
         KLxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=tYXgV+4FEeL0stwiIRomoDd4zL1RwU+zsYxx6pR+GDg=;
        b=dnWzCANNYh9lz6ZZK8UVdGTb3R7t+Mt3khG0QDV1YSOWyyk6RD5lSt5KONqQuZnF3P
         1MkyHRcVHJ+d9LIsS7iR6t6PD+gm4hz5m+PJe9eQJl+f/8PNWezsXOdhjsoD5hR9J0Yz
         ju17RGwhUO2M02oZ5wKWUWCMbVmnM9DWv+MuavXF6ewwDCikPtf09opAg0n1nyWOkIA2
         4mljcYj2rGZfHh33yHZnLj0riyBR9/L43fO2J9fIpvbdvytsf9S38BdNqc8r7qW9qKfi
         krzKYI4yk7qTkSo/dX8aukhAqIwj1fQkA85Ro8sHYYjPp4J67MI/dxiOt0jZbQzp75bi
         zrKA==
X-Gm-Message-State: APjAAAVUxgvvwfgXcNhFp3XcryMv2ykzv/AD0MxEriSbYcQlHw+tTxdB
        Fs2fX5JfZdnQ3bUoRcC0rEQ=
X-Google-Smtp-Source: APXvYqyOlJHB20geOttzXlzod9Mc8Zo/Cs1PMwf2nI3ZP/QmU8m75HiB+SrarD3dipOxvAplDbM3ZA==
X-Received: by 2002:a65:6481:: with SMTP id e1mr20881530pgv.408.1561302919678;
        Sun, 23 Jun 2019 08:15:19 -0700 (PDT)
Received: from debian.net.fpt ([1.55.47.94])
        by smtp.gmail.com with ESMTPSA id p6sm8329194pgs.77.2019.06.23.08.15.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 23 Jun 2019 08:15:18 -0700 (PDT)
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
Subject: [PATCH 07/15] ARM: ks8695: cleanup cppcheck shifting error
Date:   Sun, 23 Jun 2019 22:13:05 +0700
Message-Id: <20190623151313.970-8-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190623151313.970-1-tranmanphong@gmail.com>
References: <20190623151313.970-1-tranmanphong@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[arch/arm/mach-ks8695/pci.c:33]: (error) Shifting signed 32-bit value by
31 bits is undefined behaviour

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
---
 arch/arm/mach-ks8695/regs-pci.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-ks8695/regs-pci.h b/arch/arm/mach-ks8695/regs-pci.h
index 75a9db6edbd9..9ddab054c6fc 100644
--- a/arch/arm/mach-ks8695/regs-pci.h
+++ b/arch/arm/mach-ks8695/regs-pci.h
@@ -45,9 +45,9 @@
 
 
 
-#define CFRV_GUEST		(1 << 23)
+#define CFRV_GUEST		(1U << 23)
 
 #define PBCA_TYPE1		(1)
-#define PBCA_ENABLE		(1 << 31)
+#define PBCA_ENABLE		(1U << 31)
 
 
-- 
2.11.0


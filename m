Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8905C4FC33
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 17:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbfFWPOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 11:14:50 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37409 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726429AbfFWPOu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 11:14:50 -0400
Received: by mail-pf1-f194.google.com with SMTP id 19so6057830pfa.4;
        Sun, 23 Jun 2019 08:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=BY5QZaIeTLWKQM1WRccSODWu7bx9/tzUnh00J2x+e1s=;
        b=M5olsLDJoVv+l6GDqFZmV6Wt0aSRXkIkMDnPprXL1MnDVIBnTmgSiOeqKihC0qvOZ9
         GpxMIh/I1NMTys+g0wXZZOh5rU/kOZHNGqSMcKKjde+tKCXp5BOz8ul+feRuSiETM+45
         MXWXOcyjWHDvAMIV5CIL/JuDZPZOUdUSj1klrGbxX2PXBhwEEcKdPlZ9aFYx9TYCqeS8
         zx4cplvfKIYwdh5BKnglybyVnWmEgmURRBj+9G/dYIjD8DAQhwasdNON+0aDQ6mSnsc0
         7hN4uBqQ9fkbe1R8SBk+6ZiFhCapwrwI/3dpB2s0Q15V+FoKS3av7Yy2/EeUAtqv5cRq
         uSZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=BY5QZaIeTLWKQM1WRccSODWu7bx9/tzUnh00J2x+e1s=;
        b=m6ACggvsIoGaOdSZpHp1xf6eM/WcuUayczcEbtd3Ulcxtfv1n9C4GjOZ2seaWHKlpx
         rXA9K1RF2var4DD8Dwim6kh8SHky7Xjq3lrsKdLlK6ovj3XGiFPHcmwn43zeZH4u1JZ7
         VdSAMO/7juk4ZrSLcxisz4S8JM4FD4OHtNtoQyq+kKSOrpTXjrjTefs6h4maMKmOW/LM
         bU4YnDDwZwpTtxpvyVhuzhWVCewKVRrOwjEUJjdlHaQbSvm+p3yD8q0YTYPKlpfybgU+
         cvts39HmJPOx/fiOFdd8Q2ArI+TPiNjh3XrZ8BngSjuWguymuceORVctSo1ijEOHJQk6
         geNQ==
X-Gm-Message-State: APjAAAXe2UZF7SB1quts0eg8lztPA6zZYWlyYsqv/9f8KeCjH/WazXCr
        rUQcA13LqrkFqMFSTKvcJ30=
X-Google-Smtp-Source: APXvYqw8k9K6P1usstyY/TK4fH/2yn8PTMcksgDV6ptk0DtjWV+3yrNCZmM9+6BePCx3SZxjd7SkCA==
X-Received: by 2002:a63:f648:: with SMTP id u8mr28255062pgj.132.1561302889518;
        Sun, 23 Jun 2019 08:14:49 -0700 (PDT)
Received: from debian.net.fpt ([1.55.47.94])
        by smtp.gmail.com with ESMTPSA id p6sm8329194pgs.77.2019.06.23.08.14.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 23 Jun 2019 08:14:48 -0700 (PDT)
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
Subject: [PATCH 04/15] ARM: exynos: cleanup cppcheck shifting error
Date:   Sun, 23 Jun 2019 22:13:02 +0700
Message-Id: <20190623151313.970-5-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190623151313.970-1-tranmanphong@gmail.com>
References: <20190623151313.970-1-tranmanphong@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[arch/arm/mach-exynos/suspend.c:288]: (error) Shifting signed 32-bit
value by 31 bits is undefined behaviour

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
---
 arch/arm/mach-exynos/suspend.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-exynos/suspend.c b/arch/arm/mach-exynos/suspend.c
index be122af0de8f..8b93d130f79c 100644
--- a/arch/arm/mach-exynos/suspend.c
+++ b/arch/arm/mach-exynos/suspend.c
@@ -285,7 +285,7 @@ static void exynos_pm_set_wakeup_mask(void)
 	 * Set wake-up mask registers
 	 * EXYNOS_EINT_WAKEUP_MASK is set by pinctrl driver in late suspend.
 	 */
-	pmu_raw_writel(exynos_irqwake_intmask & ~(1 << 31), S5P_WAKEUP_MASK);
+	pmu_raw_writel(exynos_irqwake_intmask & ~(1U << 31), S5P_WAKEUP_MASK);
 }
 
 static void exynos_pm_enter_sleep_mode(void)
-- 
2.11.0


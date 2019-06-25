Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DAAB5218D
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 06:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbfFYEFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 00:05:01 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33077 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727521AbfFYEFB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 00:05:01 -0400
Received: by mail-pg1-f195.google.com with SMTP id m4so7627081pgk.0;
        Mon, 24 Jun 2019 21:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=tcmSm3hw/C8D+isK27AbfqRPmFCyR1+5B65dPM4uqtg=;
        b=mu1QVdM1AkIn8/v63c/WAWX38xkY+s9zX86yN8ezeyi38zz7UMXQqXRAIrpWTdEj22
         ADYxJkjVzJW29+m0cOYfIWcJOZA+McBGv5n8cPFyZl9zUPkHTxX+tQzyN3u3lLIHB+B+
         oNrOHO4FTVSc6kt0xEaV+IpEkz7SzzjlgCQyIRnQJC8GQZfo2cGKyG7h2slh/aSdeSV1
         /C9nywHxGxtnmDOEqS4uis4AwMoHyPFM/XdWkvUQ9Ivv52gi1SXNJmv496LD4z/IxnNO
         xporYbqLrwnulcN+LQ+D5OsbqKDLwkUP9J0OhPxVw50LvUAGHHx8jL8n98ZfT6sGQsY0
         HvAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=tcmSm3hw/C8D+isK27AbfqRPmFCyR1+5B65dPM4uqtg=;
        b=nVvqeZuv5FB1EPngznMVca0DqtSAJLWA1+dwv7fkFKtkRZ4j+guo8H4S5fyq8plnUZ
         ClXA07wzgPrKvFUOlgw4tyRegCfKWlMz9h/t/eCUooUMGdGzX647DHCigN7Vs140uAqu
         OUfBOjdimQw2N+EYWSjJ+3SwPO8XW+ccXRxEszIAGe/EdXMFHSDZNKZaFApm82WEUJZG
         KE5cV12Ipm4NMzyuytOVjjTBkRCiqve0UT0mTRWe1gfA25i6SXwbIKKzUUBx2IQ2/b1s
         u/k7TvgtHo+qvYsSo5RyMunIRlGHGwLgeXzUuijUI+HFqui3BLq0bvuzuprfInCsNXzv
         yCIw==
X-Gm-Message-State: APjAAAU0Yp9/i62mJ2l7z46YqqpkqVCjeooibCye0mPQ8KlnPV2U7lAP
        DvCJ/JTbl6yixBUqT2hDYu4=
X-Google-Smtp-Source: APXvYqx9oMj075qmx/aNwhyyhT7MNXmzmt1m9Bg4eZQVB6M3zczaguDlo2yDNPIf5Ye91pmut4aS2A==
X-Received: by 2002:a17:90a:360c:: with SMTP id s12mr29602003pjb.30.1561435500184;
        Mon, 24 Jun 2019 21:05:00 -0700 (PDT)
Received: from debian.net.fpt ([58.187.168.105])
        by smtp.gmail.com with ESMTPSA id b24sm12408944pfd.98.2019.06.24.21.04.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 21:04:59 -0700 (PDT)
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
Subject: [PATCH V3 04/15] ARM: exynos: cleanup cppcheck shifting error
Date:   Tue, 25 Jun 2019 11:03:45 +0700
Message-Id: <20190625040356.27473-5-tranmanphong@gmail.com>
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
---
 arch/arm/mach-exynos/suspend.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-exynos/suspend.c b/arch/arm/mach-exynos/suspend.c
index be122af0de8f..983d5f1d0c29 100644
--- a/arch/arm/mach-exynos/suspend.c
+++ b/arch/arm/mach-exynos/suspend.c
@@ -285,7 +285,7 @@ static void exynos_pm_set_wakeup_mask(void)
 	 * Set wake-up mask registers
 	 * EXYNOS_EINT_WAKEUP_MASK is set by pinctrl driver in late suspend.
 	 */
-	pmu_raw_writel(exynos_irqwake_intmask & ~(1 << 31), S5P_WAKEUP_MASK);
+	pmu_raw_writel(exynos_irqwake_intmask & ~BIT(31), S5P_WAKEUP_MASK);
 }
 
 static void exynos_pm_enter_sleep_mode(void)
-- 
2.11.0


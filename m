Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC5450C82
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 15:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731483AbfFXNwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 09:52:09 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:43398 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725562AbfFXNwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 09:52:08 -0400
Received: by mail-pg1-f193.google.com with SMTP id f25so7155722pgv.10;
        Mon, 24 Jun 2019 06:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=a9A1DjNMPibSIyfls26mUTjJ41Uw7fmS48NUbISOVuE=;
        b=ZSV56tuzi9jRFZ87sy6UKh7K51sffeNl14L5uwn3KwXuAatCwEhq1YcJI6RjNX1l/z
         FA7A2qy+jZbu3JEfvg9jynx6ffa+zT+0vTeGDPxsloSGtY/tPdd0q/ruywZWPVMAwn+F
         alqIRHtJ3PWqCJ/VhKmlsbe/oDyVB8TICUEYq7Kyy6KI9219HNVjN/kDgERyUtI+5iXA
         vIFaCf6KgSuw2AQ6c0bwJf9W9kA9dw3CQZdRYnOhh7R8PJr/6unRbBo5uYzbCX3H2UvV
         vtMknNAlPmlDC/gHYSafEMaAxQKMkFBp7hWQvb8DpcYRZBExvbobYrS9lhzhQR2cc6Qo
         t+Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=a9A1DjNMPibSIyfls26mUTjJ41Uw7fmS48NUbISOVuE=;
        b=hsoFwByK/kX8xjSbndr3InhXevC3NpyDEzHkwij/uflyOZiEyXMA3IDR3r7o/xLZXJ
         pqKkuAglPoF/7Cuz5hi//9Eu7Aw8SnHrU8vhXeYB4mSQ490/vMsOkLGYJThVwmS8r4HN
         ViQDO3VuGOgU8thUki/CSII3AHj2IvnGhLbK7pMuKq8pPJDBu4mxluZ/jgeEUQnBxurk
         9hroSEG11CZmwlnCJ4psmYpA2S76UmZM0krrpSVO4xJMSQ1FD9xWJXsWGB2wWcPW3i38
         99VdOhHAtvAVX+MXImewVny9YXdRViitfwOyo7frgUCaiQVZNR2ZZGi1oh9lVRiS6swd
         m73g==
X-Gm-Message-State: APjAAAVRrXJLEQV2vPpRGNzqlYyQ115KcBzbsbDaMNm3r3JWE1+eWZUR
        tSrfX9HthWtSueIF+3zq4TI=
X-Google-Smtp-Source: APXvYqzWLRe5ho/KC6c2PfJorBb2hgnPOXRcR6jNOASc6NDJ7ICAz5C+LH3b5p3zniITMyaTVc83JA==
X-Received: by 2002:a63:735d:: with SMTP id d29mr20319762pgn.276.1561384327657;
        Mon, 24 Jun 2019 06:52:07 -0700 (PDT)
Received: from debian.net.fpt ([58.187.168.105])
        by smtp.gmail.com with ESMTPSA id 85sm11187901pgb.52.2019.06.24.06.51.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 06:52:06 -0700 (PDT)
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
Subject: [PATCH V2 04/15] ARM: exynos: cleanup cppcheck shifting error
Date:   Mon, 24 Jun 2019 20:50:54 +0700
Message-Id: <20190624135105.15579-5-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190624135105.15579-1-tranmanphong@gmail.com>
References: <20190623151313.970-1-tranmanphong@gmail.com>
 <20190624135105.15579-1-tranmanphong@gmail.com>
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
index be122af0de8f..b6a73dc5bde4 100644
--- a/arch/arm/mach-exynos/suspend.c
+++ b/arch/arm/mach-exynos/suspend.c
@@ -285,7 +285,7 @@ static void exynos_pm_set_wakeup_mask(void)
 	 * Set wake-up mask registers
 	 * EXYNOS_EINT_WAKEUP_MASK is set by pinctrl driver in late suspend.
 	 */
-	pmu_raw_writel(exynos_irqwake_intmask & ~(1 << 31), S5P_WAKEUP_MASK);
+	pmu_raw_writel(exynos_irqwake_intmask & ~(BIT(31)), S5P_WAKEUP_MASK);
 }
 
 static void exynos_pm_enter_sleep_mode(void)
-- 
2.11.0


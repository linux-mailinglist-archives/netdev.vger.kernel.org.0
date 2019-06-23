Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 725EA4FC57
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 17:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbfFWPQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 11:16:01 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35149 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbfFWPQA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 11:16:00 -0400
Received: by mail-pl1-f195.google.com with SMTP id p1so5455122plo.2;
        Sun, 23 Jun 2019 08:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=27Dd+11hcQLVrCDdfJRmH2CVp0pm40m3tYEo3qo12qs=;
        b=NXRendbFoWcBJVE1B14YBXSstsRgsHHtt6tr0UZTG3m4kpQJfh4KTbvO68o4fhW1Zq
         pG0NHgRgu8itpBoS0yruwpcfCgICUg0E3gCUZoRHFslejfqTrinEuvXmQ/xeFHjdoeeh
         +JmMT1YxZsYKrwqXSeXst4CtzMmqMJsKH3PyfErSFRY1aBpRfc9aZhYsPVw/WJzbvzCr
         lqmKtFjCl5gttQUnsWRYLF/hHtKg+DAaw3YZ7eg2V+nn1dim9i2zOFJkxQyk1RGMWtzY
         UM6lc0HJLy1Y6zavZ9mIomCdC54EAsH/v5s2JZHc0GTaJC17QFZVCenkKLvbID2iG/iK
         5dSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=27Dd+11hcQLVrCDdfJRmH2CVp0pm40m3tYEo3qo12qs=;
        b=CaeceKmBf+cMPJRJkfCQz8DBybLfayCym2EB2seIsRX/4x8118+kdThP6uV99+Z2LS
         7HuSsVO/lAv7tot0pRiwntKnlJUOYvDJ6eHr+/9vT+SbCbewHwq6xEOLwLZF2v2WFt9+
         j6PZWgFbwWZa9m3DRKKf/kX4xPF12UEgR5gZpchCUX/uxeRAxpHR1toXCNXI6qwJvMXk
         8gLguBChO9/43p4MINEGc3gqg6zdo2ir3r8v3xiv5GdoHTBwmZp6MTl7Ee6e95v8fEZj
         6IWMK+riVKS5WP4RcLcK7c/qAE2Qw+3v727YLXUZVWGg+Cw4RCbWfr3p43UWSOw6mC+U
         lUlA==
X-Gm-Message-State: APjAAAWbArpk91M+niXq9J5IM+fe93ZZtgktSMjuGG/RPd/o3FqzdpLo
        QwwuIi9+t30Ktk4Lb0n4obrfcutbr9o1kg==
X-Google-Smtp-Source: APXvYqxQ93R3laytQj718jAAXcWvFOXAsJuHuOgep9JQF9VRasKqF4H5KZMcJMj/Lt2ULQo0lN01kg==
X-Received: by 2002:a17:902:f204:: with SMTP id gn4mr125374032plb.3.1561302959602;
        Sun, 23 Jun 2019 08:15:59 -0700 (PDT)
Received: from debian.net.fpt ([1.55.47.94])
        by smtp.gmail.com with ESMTPSA id p6sm8329194pgs.77.2019.06.23.08.15.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 23 Jun 2019 08:15:58 -0700 (PDT)
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
Subject: [PATCH 11/15] ARM: pxa: cleanup cppcheck shifting errors
Date:   Sun, 23 Jun 2019 22:13:09 +0700
Message-Id: <20190623151313.970-12-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190623151313.970-1-tranmanphong@gmail.com>
References: <20190623151313.970-1-tranmanphong@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[arch/arm/mach-pxa/irq.c:117]: (error) Shifting signed 32-bit value by
31 bits is undefined behaviour
[arch/arm/mach-pxa/irq.c:131]: (error) Shifting signed 32-bit value by
31 bits is undefined behaviour

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
---
 arch/arm/mach-pxa/irq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-pxa/irq.c b/arch/arm/mach-pxa/irq.c
index 74efc3ab595f..2e2afe16069c 100644
--- a/arch/arm/mach-pxa/irq.c
+++ b/arch/arm/mach-pxa/irq.c
@@ -35,9 +35,9 @@
 #define IPR(i)			(((i) < 32) ? (0x01c + ((i) << 2)) :		\
 				((i) < 64) ? (0x0b0 + (((i) - 32) << 2)) :	\
 				      (0x144 + (((i) - 64) << 2)))
-#define ICHP_VAL_IRQ		(1 << 31)
+#define ICHP_VAL_IRQ		(1U << 31)
 #define ICHP_IRQ(i)		(((i) >> 16) & 0x7fff)
-#define IPR_VALID		(1 << 31)
+#define IPR_VALID		(1U << 31)
 
 #define MAX_INTERNAL_IRQS	128
 
-- 
2.11.0


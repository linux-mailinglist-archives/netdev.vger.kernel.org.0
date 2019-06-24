Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D34550CB0
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 15:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731635AbfFXNxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 09:53:32 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46323 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729369AbfFXNxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 09:53:32 -0400
Received: by mail-pl1-f196.google.com with SMTP id e5so6920500pls.13;
        Mon, 24 Jun 2019 06:53:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jk/nkeoPZWAilrlY249GKOGI7chJgqVYG9Jn6652O3Q=;
        b=WYRY4/m7v5XlIHLE0K719PBFDmz7aerKZmduAbK8JKl7G/vG8cu6ZP8tgKrxMhiNxH
         w/Tkijyj0faAuRs1Tk6kcJiopUol4dIh0kr9/4j1jLZREXTCwup7rKgHoBrEF03X/Fxs
         cSJG24D1OXRMiSArpxke7TVjZ22jd7/VJXSGNjXWilttaMikBGy0KDSXWRtgy4a7+Pde
         Ah3hZGSErFoAweFcdFoCThoYIDP4R3BQ6DdStZ4sq3wsh/L0wPhINbWYoncsJEHFNDXc
         jOcfcP18tlqaLjKBFmT3L1i2xQRs/O6OuTIdSak+KFDowhUKHcrMtv3Pw0UQy3O07zr2
         M60Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jk/nkeoPZWAilrlY249GKOGI7chJgqVYG9Jn6652O3Q=;
        b=VOjJaEQ8S/M0aVTgWBpkq1O0iuxYumygjE97teJh6QaqSvBfvvR9toourGmzQ8LzGv
         SOD1tG6zG2Fjo5kHkuB5XaZzVlkXlRFHeEZSQ3SEYIkqmqJA3PgBZ3pIBQkJ9GwDQP7M
         hPR8KbJhVNXJb31fHoJmhhu3WnmD+ZOkb4x8evCTv/c8gfz6swBGlP48mdjlFqjgdFxa
         /TwKeOCeuPw8O9+YH1/8ZAQqO258bCpXndpfDyDfsmB8PVg/YFGlH6TVrUA+d7BZkGV8
         kTy90wz7YWE/eK7SiUtU/eW4EZ98NMuxVBds5wWDjXQBb88nea6Kb8SFvJ1lCvuuEx9M
         xGPg==
X-Gm-Message-State: APjAAAUprZhowXNF/rCVwY+TMTJxYY4RwilCF7RxYpa67QqCawCfA00f
        GR4nTmpNzHDcvyWJFGa4NvU=
X-Google-Smtp-Source: APXvYqwEQV9HHSfeeV7MNZ8IutXxdSYkacVL9fCVOI6cbPhD3Wh0gpNwYJTeSy29jkQylxSHhWnh5g==
X-Received: by 2002:a17:902:7b84:: with SMTP id w4mr38339789pll.22.1561384411503;
        Mon, 24 Jun 2019 06:53:31 -0700 (PDT)
Received: from debian.net.fpt ([58.187.168.105])
        by smtp.gmail.com with ESMTPSA id 85sm11187901pgb.52.2019.06.24.06.53.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 06:53:30 -0700 (PDT)
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
Subject: [PATCH V2 12/15] ARM: vexpress: cleanup cppcheck shifting error
Date:   Mon, 24 Jun 2019 20:51:02 +0700
Message-Id: <20190624135105.15579-13-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190624135105.15579-1-tranmanphong@gmail.com>
References: <20190623151313.970-1-tranmanphong@gmail.com>
 <20190624135105.15579-1-tranmanphong@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[arch/arm/mach-vexpress/spc.c:366]: (error) Shifting signed 32-bit value
by 31 bits is undefined behaviour

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
---
 arch/arm/mach-vexpress/spc.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-vexpress/spc.c b/arch/arm/mach-vexpress/spc.c
index 0f5381d13494..425ce633667a 100644
--- a/arch/arm/mach-vexpress/spc.c
+++ b/arch/arm/mach-vexpress/spc.c
@@ -57,8 +57,8 @@
 
 /* SPC CPU/cluster reset statue */
 #define STANDBYWFI_STAT		0x3c
-#define STANDBYWFI_STAT_A15_CPU_MASK(cpu)	(1 << (cpu))
-#define STANDBYWFI_STAT_A7_CPU_MASK(cpu)	(1 << (3 + (cpu)))
+#define STANDBYWFI_STAT_A15_CPU_MASK(cpu)	BIT((cpu))
+#define STANDBYWFI_STAT_A7_CPU_MASK(cpu)	BIT((3 + (cpu)))
 
 /* SPC system config interface registers */
 #define SYSCFG_WDATA		0x70
@@ -69,7 +69,7 @@
 #define A7_PERFVAL_BASE		0xC30
 
 /* Config interface control bits */
-#define SYSCFG_START		(1 << 31)
+#define SYSCFG_START		BIT(31)
 #define SYSCFG_SCC		(6 << 20)
 #define SYSCFG_STAT		(14 << 20)
 
@@ -90,8 +90,8 @@
 #define CA15_DVFS	0
 #define CA7_DVFS	1
 #define SPC_SYS_CFG	2
-#define STAT_COMPLETE(type)	((1 << 0) << (type << 2))
-#define STAT_ERR(type)		((1 << 1) << (type << 2))
+#define STAT_COMPLETE(type)	(BIT(0) << (type << 2))
+#define STAT_ERR(type)		(BIT(1) << (type << 2))
 #define RESPONSE_MASK(type)	(STAT_COMPLETE(type) | STAT_ERR(type))
 
 struct ve_spc_opp {
@@ -162,7 +162,7 @@ void ve_spc_cpu_wakeup_irq(u32 cluster, u32 cpu, bool set)
 	if (cluster >= MAX_CLUSTERS)
 		return;
 
-	mask = 1 << cpu;
+	mask = BIT(cpu);
 
 	if (!cluster_is_a15(cluster))
 		mask <<= 4;
-- 
2.11.0


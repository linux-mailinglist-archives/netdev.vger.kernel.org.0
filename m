Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B13D4FC5D
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 17:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbfFWPQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 11:16:11 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39712 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbfFWPQL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 11:16:11 -0400
Received: by mail-pf1-f193.google.com with SMTP id j2so6054172pfe.6;
        Sun, 23 Jun 2019 08:16:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=g6cYAr6rL/+jYC23/L1x66RBujGVa5//C8DvDyA+gwo=;
        b=CPSTkOdxTJ45w8px0vdfpfrctn7T4ptrZq2v6v1r3tr8V3Uv4lRycX9so92kdriHpg
         FHm4lBYdOa3YPnNNosVLi6AA6RX6Nidhv2nD3Jx8fMdDE3i2ZEYf8hQ/Gx//CYFGK0Y/
         Uuw/CXxxWDv11wtGDnppP3Li7hrH3yNONiPQTfCZvcT6nZcvLfgb3c1cyTU5ZNQA7FKR
         HezquCS9Xs9q6Ip2/MN7Aiqqx3hXiVx/T+W20DV8QJ5pixnei6g9ArRyJ+lq+AkCKSQ9
         9yU6HpvlOEEt9f/ci388+7DLzSnxyyj6JtcCciK8nZEDZ/DNkk6vSJLO4zlG2CxsXC9j
         3A0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=g6cYAr6rL/+jYC23/L1x66RBujGVa5//C8DvDyA+gwo=;
        b=B5xM3z1J1qn6N/53DIlYFe4sLpHcmaE0iBUzy+g60PZ1bVG1k+s8fR3i/BbmO+/bAA
         7WXYQnYtunglcXnF4U4LwhiG73SFFAStpcazpXHiAWyXcPnkPZdZdxHhpnHeIMN6YuJq
         cVCpvl+Xil/xCw21vRyKTf2M3M5VrRUQxhKBOFNI2gq29wKl88H/Lw17YmNIIMwiRA1u
         7qiLIYD7o7Tzp6Bx47Bt+WUTleaebwVRCrOJGYDJmAUQD3xZr/1thz2sEnem2rhZHPT5
         q+QS5i9cbT3bxJPZeMeEgSOLmpmeWSoFITssC3zJP7LEIERfH6JPUgWhx8yjq68XNEJV
         zT8g==
X-Gm-Message-State: APjAAAVK9KnRqvq2lfngLnUd0INRukogu4QypInjr0v2+UrL4fJEjnb8
        EhrNG17NTW0cLrOwt2yZPaE=
X-Google-Smtp-Source: APXvYqyDYRcdKS3/DTrSmn64cZHgBGyezpncmJNfr48KnZ4uNgA+rfBKxjXpDx835pH5cubNdandxA==
X-Received: by 2002:a17:90a:d3d7:: with SMTP id d23mr18137289pjw.26.1561302970189;
        Sun, 23 Jun 2019 08:16:10 -0700 (PDT)
Received: from debian.net.fpt ([1.55.47.94])
        by smtp.gmail.com with ESMTPSA id p6sm8329194pgs.77.2019.06.23.08.15.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 23 Jun 2019 08:16:09 -0700 (PDT)
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
Subject: [PATCH 12/15] ARM: vexpress: cleanup cppcheck shifting error
Date:   Sun, 23 Jun 2019 22:13:10 +0700
Message-Id: <20190623151313.970-13-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190623151313.970-1-tranmanphong@gmail.com>
References: <20190623151313.970-1-tranmanphong@gmail.com>
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
index 0f5381d13494..f8911dae776c 100644
--- a/arch/arm/mach-vexpress/spc.c
+++ b/arch/arm/mach-vexpress/spc.c
@@ -57,8 +57,8 @@
 
 /* SPC CPU/cluster reset statue */
 #define STANDBYWFI_STAT		0x3c
-#define STANDBYWFI_STAT_A15_CPU_MASK(cpu)	(1 << (cpu))
-#define STANDBYWFI_STAT_A7_CPU_MASK(cpu)	(1 << (3 + (cpu)))
+#define STANDBYWFI_STAT_A15_CPU_MASK(cpu)	(1U << (cpu))
+#define STANDBYWFI_STAT_A7_CPU_MASK(cpu)	(1U << (3 + (cpu)))
 
 /* SPC system config interface registers */
 #define SYSCFG_WDATA		0x70
@@ -69,7 +69,7 @@
 #define A7_PERFVAL_BASE		0xC30
 
 /* Config interface control bits */
-#define SYSCFG_START		(1 << 31)
+#define SYSCFG_START		(1U << 31)
 #define SYSCFG_SCC		(6 << 20)
 #define SYSCFG_STAT		(14 << 20)
 
@@ -90,8 +90,8 @@
 #define CA15_DVFS	0
 #define CA7_DVFS	1
 #define SPC_SYS_CFG	2
-#define STAT_COMPLETE(type)	((1 << 0) << (type << 2))
-#define STAT_ERR(type)		((1 << 1) << (type << 2))
+#define STAT_COMPLETE(type)	((1U << 0) << (type << 2))
+#define STAT_ERR(type)		((1U << 1) << (type << 2))
 #define RESPONSE_MASK(type)	(STAT_COMPLETE(type) | STAT_ERR(type))
 
 struct ve_spc_opp {
@@ -162,7 +162,7 @@ void ve_spc_cpu_wakeup_irq(u32 cluster, u32 cpu, bool set)
 	if (cluster >= MAX_CLUSTERS)
 		return;
 
-	mask = 1 << cpu;
+	mask = 1U << cpu;
 
 	if (!cluster_is_a15(cluster))
 		mask <<= 4;
-- 
2.11.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86B0E4FC29
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 17:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfFWPO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 11:14:29 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33251 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726417AbfFWPO2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 11:14:28 -0400
Received: by mail-pg1-f195.google.com with SMTP id m4so5120639pgk.0;
        Sun, 23 Jun 2019 08:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=OxL4DcuMN/R/b7W39ei0mEoo56IxfagFhh/wYo+mbyo=;
        b=CZzqwGVnlqKr+KxYP0L0Qe7BBRJ2mJiwArZMV1SMgUpjGOnuAMQlGsWBtssw2nacEj
         2TvCxDwF4TZcWO1aufbDdVSodHGio8j2kJXNLlun5Kozd6j6fEyKUCdZdYSOOKjTZfR/
         /9LgsfP/fdo0wBPB43C89m0r6wZZrTmlQ/h4Snzq+GShTseMp6TL7XyQ/Kh9S0jEi5qw
         zBMUiXLyrn7byeOXggsKnXgekoOUQJrEwWV3kr3UxD2TNEChwabQtkDiFswmIKGxjBsj
         Z/smOeINGXrVstJU03VlHeQ71HZokSFh6Ks5XLD8rdTc+FFDCfEFH3slT88osMOt3oZb
         yejw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=OxL4DcuMN/R/b7W39ei0mEoo56IxfagFhh/wYo+mbyo=;
        b=If2+jvu4Y+OIFe4O07W39WkWAiDeDGU7lWDVjsam14zDly+bHbAKR2lXFKxSdVFljX
         6ZbRWsopnAJDg/cpLOU7wg68Ruw54YZqtf0WfoQXzc8hrzLPgp6y/KNUHQ9tLnQ6EjtI
         Z46LJfiJIRKjTXbG+F5T/oN9nLm31mayRkwuDRoORVsb29rZ5OcilwwLI6Xr6GlS8Csg
         BYniEhhrRR+QwoMnrZXN6mKPKupgMCJf25KAYtRH7UujWrwO2t+d2JW7PsJnGCMlxgcP
         8AhISjmW+9Ql63S0cFKOO9NLYuPAWLdYZL/lA8NmbCHXS6D932TCsBs1R2Loz8hrHRHk
         OLJQ==
X-Gm-Message-State: APjAAAW0mxoQAqgWxTM31/Sdiytn9JeWWTqTKrx19zaBBXRt9cAL40wd
        qy7VWWLudx0w5PhezGBuvBk=
X-Google-Smtp-Source: APXvYqzZYy2hs8hFJAsOaB5RRuq6UvCi3sKQtQ9dnjDN4SDRyq5KDjbq3TPCujYdPV0DKvSyFFfbSQ==
X-Received: by 2002:a63:601:: with SMTP id 1mr15278220pgg.380.1561302867810;
        Sun, 23 Jun 2019 08:14:27 -0700 (PDT)
Received: from debian.net.fpt ([1.55.47.94])
        by smtp.gmail.com with ESMTPSA id p6sm8329194pgs.77.2019.06.23.08.14.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 23 Jun 2019 08:14:27 -0700 (PDT)
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
Subject: [PATCH 02/15] ARM: davinci: cleanup cppcheck shifting errors
Date:   Sun, 23 Jun 2019 22:13:00 +0700
Message-Id: <20190623151313.970-3-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190623151313.970-1-tranmanphong@gmail.com>
References: <20190623151313.970-1-tranmanphong@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[arch/arm/mach-davinci/cpuidle.c:41]: (error) Shifting signed 32-bit
value by 31 bits is undefined behaviour
[arch/arm/mach-davinci/cpuidle.c:43]: (error) Shifting signed 32-bit
value by 31 bits is undefined behaviour

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
---
 arch/arm/mach-davinci/ddr2.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-davinci/ddr2.h b/arch/arm/mach-davinci/ddr2.h
index 4f7d7824b0c9..76d78ffe2702 100644
--- a/arch/arm/mach-davinci/ddr2.h
+++ b/arch/arm/mach-davinci/ddr2.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #define DDR2_SDRCR_OFFSET	0xc
-#define DDR2_SRPD_BIT		(1 << 23)
-#define DDR2_MCLKSTOPEN_BIT	(1 << 30)
-#define DDR2_LPMODEN_BIT	(1 << 31)
+#define DDR2_SRPD_BIT		(1U << 23)
+#define DDR2_MCLKSTOPEN_BIT	(1U << 30)
+#define DDR2_LPMODEN_BIT	(1U << 31)
-- 
2.11.0


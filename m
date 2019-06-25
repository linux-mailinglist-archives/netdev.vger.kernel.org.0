Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E890D521BC
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 06:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728507AbfFYEG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 00:06:27 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38678 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbfFYEG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 00:06:27 -0400
Received: by mail-pg1-f193.google.com with SMTP id z75so5628098pgz.5;
        Mon, 24 Jun 2019 21:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=sKdpNSUQdGXxX8wZfroYxmDSvESfGqvaVysgZIwVWtg=;
        b=DEGqy4zi+TJd12rMQbgrA3DNBj8QdIs6IdKpALCGfew4KjRYSfJmWiiPd7OGR3zuCl
         zw52yR84tYlKk9RljyOPQjVlH8mZf8EUyZjN6qqA48QuY5IU+RD3KmXNpvjOq7lBtEGT
         cPQDnh74chBo7asDpEfCs2k5O1df+ozXEZ7vGYI+ch++6vaDxdpV2O15htpiwWZyQwZy
         abCz3V88allbjP6/VWNmDrFqH/s+jy/obn6Z6dHq9n3JJXWGRdh4xWtKwUy7VrbmwB46
         5O86bToNwLX4v8FHiGeUN28Rto9gHb0ebjfiDGv3Ibmdx/sp8nKiewgeYIMsU7Av3NFl
         YgXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=sKdpNSUQdGXxX8wZfroYxmDSvESfGqvaVysgZIwVWtg=;
        b=nOLetyen4+RkQtqJukAryWducQA1C0np5xxXeWmbAj0utY6hSOwGMmvHJyMEJE2iY2
         dMzq4eZ0u5xlKZEZAh/ZAsXSI4+xxUgXeRjN4CW4X4YXEFqGo/EUogjzk35fLucLZ5n5
         XRX2hLFfeF2fF3mC3ZqTZ1bjtUscLXoW74wMeKiz4/nlxI3BlNeUmlqxn0ecaMOa7B1t
         yH01Ff0tt4iGObWHORN0t99Pftd/zCIlgqObi1sDlbkjjYiNF7n5f0fgFcJpLT2cmg9e
         KsPJjL/PjH4gPXnEtGCTmOnkmY/KqbtHZy89M05fKh69720yNH3Z3GIPOcb/+07K3dwy
         4WpA==
X-Gm-Message-State: APjAAAVzZTD6utS5QRGcg88WRAeYLsfAwsIdptRjUz4el6BIUvq0KO9Z
        zuVFVcRKBjiDsLj+41ACmNs=
X-Google-Smtp-Source: APXvYqxeIv3TJu9AJVj8LhZ8T/IfwNNmzFXxLFTuqhUVLDzyeiKIc+k9xzlxlALyhQJ9BU15U8jpKA==
X-Received: by 2002:a65:664d:: with SMTP id z13mr11453666pgv.99.1561435586131;
        Mon, 24 Jun 2019 21:06:26 -0700 (PDT)
Received: from debian.net.fpt ([58.187.168.105])
        by smtp.gmail.com with ESMTPSA id b24sm12408944pfd.98.2019.06.24.21.06.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 21:06:25 -0700 (PDT)
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
Subject: [PATCH V3 12/15] ARM: vexpress: cleanup cppcheck shifting error
Date:   Tue, 25 Jun 2019 11:03:53 +0700
Message-Id: <20190625040356.27473-13-tranmanphong@gmail.com>
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
 arch/arm/mach-vexpress/spc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-vexpress/spc.c b/arch/arm/mach-vexpress/spc.c
index 0f5381d13494..354e0e7025ae 100644
--- a/arch/arm/mach-vexpress/spc.c
+++ b/arch/arm/mach-vexpress/spc.c
@@ -69,7 +69,7 @@
 #define A7_PERFVAL_BASE		0xC30
 
 /* Config interface control bits */
-#define SYSCFG_START		(1 << 31)
+#define SYSCFG_START		BIT(31)
 #define SYSCFG_SCC		(6 << 20)
 #define SYSCFG_STAT		(14 << 20)
 
@@ -162,7 +162,7 @@ void ve_spc_cpu_wakeup_irq(u32 cluster, u32 cpu, bool set)
 	if (cluster >= MAX_CLUSTERS)
 		return;
 
-	mask = 1 << cpu;
+	mask = BIT(cpu);
 
 	if (!cluster_is_a15(cluster))
 		mask <<= 4;
-- 
2.11.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDC6850C7A
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 15:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731451AbfFXNvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 09:51:47 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39061 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731432AbfFXNvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 09:51:47 -0400
Received: by mail-pf1-f193.google.com with SMTP id j2so7554829pfe.6;
        Mon, 24 Jun 2019 06:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XeelbuqeW5y33N8d1ijYmgxZuObEd378TU1ddXNdHBg=;
        b=eZDQHFQEb3Qaxu1uQXyb+4XzgZNV+xjY5evkbwj5Z5rEQCmqnj4z/nRQizGk6envsh
         YYWcrUOPIgfGcpqnCZ4MEOrOvDtl739M0MgpNHCfCxllcVTUv/oBcT3Ioq6mpTF/S/hu
         x72kZZIVa97G9smPur9BXeTVSDLZR8HAMUJcTzAGJs5k9+P6m713Z71fgof7CvzbePlA
         WEZ/DtetV4bp1GEDYTWcY3zf/GLAQuYN8l5gvL4JY74Bn9nU3guTT9vsktbX0e0bAFKU
         GVJIsHCo5lT5u0xz/ErZPR6jD3ewmhqpWa2/2l0Xz1f8Y3Kt8hHvE2qYtcF6Jd/sY4N5
         UJHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XeelbuqeW5y33N8d1ijYmgxZuObEd378TU1ddXNdHBg=;
        b=jZ2wBuH1jbOzqEmZED5ihAy65tPKcA8N2UXhN7v240of3Mwi26s94OCH3R/KPLktpR
         NVnf4iY3fN5vMatgJCjgdXiriPJWLGTfW5RoqGRZMJuPdxIL+IQSk1K1gksbkCR3CroR
         zDxN/vFFSwpiU1Bi3/rYVDIMOYZIjBEDMb3kuzmoxLQ2DvdxAmqSTiDuQpXuPHbEOjsK
         K5UTvclzdqcEvih+TuVAbyPbdNoY9ZoK7Omt1gDTnfq9gIgLfnc4YUABCpeacw+1DRKS
         EpokCEzKP9C3ioKbirAeiaLCmXmn2Zk57XtgjGd7FsYdte3EiC9iBo1LQc5W3juPOgmW
         lu/Q==
X-Gm-Message-State: APjAAAUwNYQHhfzshimHxxOByMJKIKuE8IlG94+PVPYLtBnIsR44sjXA
        kuEDPemV2H5lIPnduvgd+64=
X-Google-Smtp-Source: APXvYqyuEnUO6D20SoScm9Vr+SO06i+MMxQ8CMeva4iZe7YYn2UpBpFWiNOA/8Uv45HjkgGbEm/qLA==
X-Received: by 2002:a63:5d54:: with SMTP id o20mr31625270pgm.97.1561384306046;
        Mon, 24 Jun 2019 06:51:46 -0700 (PDT)
Received: from debian.net.fpt ([58.187.168.105])
        by smtp.gmail.com with ESMTPSA id 85sm11187901pgb.52.2019.06.24.06.51.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 06:51:45 -0700 (PDT)
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
Subject: [PATCH V2 02/15] ARM: davinci: cleanup cppcheck shifting errors
Date:   Mon, 24 Jun 2019 20:50:52 +0700
Message-Id: <20190624135105.15579-3-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190624135105.15579-1-tranmanphong@gmail.com>
References: <20190623151313.970-1-tranmanphong@gmail.com>
 <20190624135105.15579-1-tranmanphong@gmail.com>
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
index 4f7d7824b0c9..f2f56d16d7d5 100644
--- a/arch/arm/mach-davinci/ddr2.h
+++ b/arch/arm/mach-davinci/ddr2.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #define DDR2_SDRCR_OFFSET	0xc
-#define DDR2_SRPD_BIT		(1 << 23)
-#define DDR2_MCLKSTOPEN_BIT	(1 << 30)
-#define DDR2_LPMODEN_BIT	(1 << 31)
+#define DDR2_SRPD_BIT		BIT(23)
+#define DDR2_MCLKSTOPEN_BIT	BIT(30)
+#define DDR2_LPMODEN_BIT	BIT(31)
-- 
2.11.0


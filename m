Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29BA652183
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 06:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727715AbfFYEEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 00:04:38 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34562 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727540AbfFYEEi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 00:04:38 -0400
Received: by mail-pf1-f195.google.com with SMTP id c85so8735946pfc.1;
        Mon, 24 Jun 2019 21:04:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DDy1WkQD0dK7gdWmitUgF418A+VoWDfrpb0wHmc1mYA=;
        b=K7gwR0CyijlbY3YZc8B2x2u0/adB0A+/R04ABH63rc2y+6gv1B68/8FhSZKao0dYp4
         mZx0Sn6E8g7yMaMUuxlnw9SnQ6k/XhG4BkSJfPNFKvVg2Fk8KKQtxyvM7+L1htTL3x/k
         e0Qr2gFAhtRbwdPL1NkDO6gx/VILUsHza0JQLOIJ5LrXvITtdRgz4zrk7Vhapb/lRE+I
         g5CaWjAYu8sx+pDTOp1mJ5q4+OgGIi7jgbIbu9Ies6tH7GcR/DC4KhavfLBpqhvW/4nx
         JuYNJMS1Y8L6q1m0j4+cS58+ON+zI4s3ThYtsgjo16wK/LKYYzdoVVPjZm6t4vSLFglT
         z9ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DDy1WkQD0dK7gdWmitUgF418A+VoWDfrpb0wHmc1mYA=;
        b=PKL0Qv0TBXO1IVAnBEB0F+vpdjSryHsotUN5knOadYoKWBV4ewYIBWFj+HowUVmwuC
         XFvRck3u2z7xY9sT495jkSaH/7oxELbCIlpsGlMzpClUJa59Wfg08cYVCZrNWX7CRHnC
         rb0Xh0mFIrDsd9hv1hpAFoJ2OlCAmPgTKHmt7EcwW//oYd2m4+csTAllxJwY3dxpPoDa
         ygGZ7vGUVdKfpaDkNdngd89+ucoayyQqNjVGCmEsimxgHI96763VAB/fzC91uqUFSxv1
         XemZOS8YMslKuAK+CXcU3LX/FoST7DsLmcxZJJKriiuldDZCIb3zXlgmAx+mGurzdNqf
         tYMQ==
X-Gm-Message-State: APjAAAW4Cpv3/kuv4d+PJ/W+IHKMHuPupRBMEWTTtPgIaQzzkFSfsKR0
        S9qq4x6SZ17fzj2v3hE+E9s=
X-Google-Smtp-Source: APXvYqzE/jneACOKQHIUzLdU0Rs2n+Lx05YqPiShfm/TNG5baavnFWWNvRflijx3fuT44ITIWu5wjQ==
X-Received: by 2002:a63:2985:: with SMTP id p127mr34417218pgp.400.1561435477442;
        Mon, 24 Jun 2019 21:04:37 -0700 (PDT)
Received: from debian.net.fpt ([58.187.168.105])
        by smtp.gmail.com with ESMTPSA id b24sm12408944pfd.98.2019.06.24.21.04.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 21:04:36 -0700 (PDT)
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
Subject: [PATCH V3 02/15] ARM: davinci: cleanup cppcheck shifting errors
Date:   Tue, 25 Jun 2019 11:03:43 +0700
Message-Id: <20190625040356.27473-3-tranmanphong@gmail.com>
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


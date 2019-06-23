Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A73E4FC62
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 17:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbfFWPQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 11:16:21 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37949 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbfFWPQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 11:16:21 -0400
Received: by mail-pf1-f195.google.com with SMTP id y15so1412119pfn.5;
        Sun, 23 Jun 2019 08:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=IoP8D0WJcZ+nUeH2d4IFJC7Cz28BXgT9XkcXycZQXDQ=;
        b=tYjNTkzYJIV44hLSjn2CUsRyotVWuDBiY5aI8ERvgiqStomLMuplfFMM1e7C1HYfs5
         wswLA8ijbrG//R9y9uE0n8uWS0OOOMkT1qQCgnza/PU+HEAfN4tB6caA7VUeEe1DzeLK
         V5Hw5kLpeDoQCjCJXjbFjk2NlyPJoKR8agQAIBXxojoPwCBUyOQ9QtkfzCZSWRKPsJoX
         IGrDkvoxN+xlsMjI+L+61GQuK6ESp4qJE3fhlS0vc/rEdCG28A1oapuwe1FTPB+cOIqX
         LFUtzw4vR8+IF5or2QU7wzGLX2Dwau+yS5dumQPQGWjLBPS/qiGQMDIO8Qcaiz1TmPdr
         qtmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=IoP8D0WJcZ+nUeH2d4IFJC7Cz28BXgT9XkcXycZQXDQ=;
        b=Hswv7hmtUf4Y6lLyXIe3eYqU/03qalSXpKAsOWHSoJSFTziHjSKLcWqORznK3G70Ze
         JJ0DBUGcyWf3yRXkw3f83x+EoPDRYEvpskaVzVo6373RkrX4HYRcpTAI2NwIosDJXljJ
         ZIYNZ7HfRiSICtXcbb8bGpoex65d339tRN0T23a/3ST5gTlyFPAkfwX+cb7IAqCygEsi
         5/Tu87xN5n1Qu0OPmsq+ntEXH+3neJa5Lq6k3YDznTcc3bIPCl1tMS6RPgmktTYb0puR
         P0h56VpiDiLIx44gNnszBJ9MkNiHAM3D4U6P9qixEZpDs9JBNGhul2Uz+xtY4NWpfBZY
         54FQ==
X-Gm-Message-State: APjAAAUR4QgJy1BV6p9T5xAaoI7hTSNXTd4HQsAynHz+qnoCSmDPwAH5
        6I0WuDGEuKIzjqIuQwfgtmQ=
X-Google-Smtp-Source: APXvYqyXjcDInzY2Ky3UgxMRp36S+dej580QKwClw7XL+wmxH62Ylvey0uMhf27m1eScDntjLG1vuQ==
X-Received: by 2002:a17:90a:634a:: with SMTP id v10mr17154909pjs.16.1561302980538;
        Sun, 23 Jun 2019 08:16:20 -0700 (PDT)
Received: from debian.net.fpt ([1.55.47.94])
        by smtp.gmail.com with ESMTPSA id p6sm8329194pgs.77.2019.06.23.08.16.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 23 Jun 2019 08:16:19 -0700 (PDT)
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
Subject: [PATCH 13/15] ARM: mm: cleanup cppcheck shifting errors
Date:   Sun, 23 Jun 2019 22:13:11 +0700
Message-Id: <20190623151313.970-14-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190623151313.970-1-tranmanphong@gmail.com>
References: <20190623151313.970-1-tranmanphong@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[arch/arm/mm/alignment.c:875]: (error) Shifting signed 32-bit value by
31 bits is undefined behaviour
[arch/arm/mm/fault.c:556]: (error) Shifting signed 32-bit value by 31
bits is undefined behaviour
[arch/arm/mm/fault.c:585]: (error) Shifting signed 32-bit value by 31
bits is undefined behaviour
[arch/arm/mm/fault.c:219]: (error) Shifting signed 32-bit value by 31
bits is undefined behaviour

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
---
 arch/arm/mm/fault.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mm/fault.h b/arch/arm/mm/fault.h
index c063708fa503..159c4e7bff09 100644
--- a/arch/arm/mm/fault.h
+++ b/arch/arm/mm/fault.h
@@ -5,9 +5,9 @@
 /*
  * Fault status register encodings.  We steal bit 31 for our own purposes.
  */
-#define FSR_LNX_PF		(1 << 31)
-#define FSR_WRITE		(1 << 11)
-#define FSR_FS4			(1 << 10)
+#define FSR_LNX_PF		(1U << 31)
+#define FSR_WRITE		(1U << 11)
+#define FSR_FS4			(1U << 10)
 #define FSR_FS3_0		(15)
 #define FSR_FS5_0		(0x3f)
 
-- 
2.11.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB80050C88
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 15:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731506AbfFXNwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 09:52:20 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44469 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725562AbfFXNwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 09:52:20 -0400
Received: by mail-pg1-f195.google.com with SMTP id n2so7147603pgp.11;
        Mon, 24 Jun 2019 06:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4YxMHBm2SnqxBVKghZYd5jwr6fv/9cNEFelVXaGNkFk=;
        b=e8ZSR6ho5uxjtHe5N1QmLicgOcuVPwCpB/A/NgnLkQGNtmyHPyOLAH+Z/IpaGHLRH/
         tl834F4hSp6nS/C7pxd5+PG1+Sn3C+ROQTY206/glbpHIzaUZQR+QaT40ypUpwR7XrH0
         G98uEZywsseRhjvTLq+mZdn/PnwsXQ6kEy7EetSndtI+OAHGoGsE543Oa95dkJ09zSbd
         E2mmS+F3jlZoKXtXtcaJx5I+Pjq2HaBAHNvSOW/APKdPusYj/3THxUUaUeSAeLEPrHRP
         r3ohEY6mvxEDbAra8k+u1hLj9w1moVPGNe+ThXJ72ERDJ4m/sxl3XeQbQ51XMR1UAxDn
         pPCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4YxMHBm2SnqxBVKghZYd5jwr6fv/9cNEFelVXaGNkFk=;
        b=fBlns+bZddajcxm+yjock4LH/mPUTOV9KODlDPF8NRGN1PB7IIzGxiBUQbOmOGbEUx
         jOJr6SwFfjQHnrzswqCgm2Vb0K1T/UuACb9ooeCBMc3rCm+NRxGJcRDMyg4fMf5LHLoF
         Mkcgf32mY/N1hB1FSJ+sM+HRJbBFe3JXOv0ufyrAVI107DC1H99eMOh1zc3jgasHaOEn
         Tp41l+wjKHz4mGuqlYWwxKbzwTkcYpFbEWqHOONm8gav64ytP3MaoP9a4GdEYWJG/hst
         MLZOsyTiMHuLt71Gvt60qaQ4KdVLYgbbHk6bgr1meA+V0u8woktuMu7vq9HxiM7mJOBE
         JwzA==
X-Gm-Message-State: APjAAAWhBcQ8RqOL8124OYbyK7E0Gm0jDBn5z4RQvvPiH8gUBvUSd9io
        B/p9ea1gXG8KECK+zkYl2YE=
X-Google-Smtp-Source: APXvYqx9gf1JA/RBMwoVESQCrIeinti9kZYk40nQT9LE7xSC7rfMLCVVjhbBasWhbLaeAY6r/WXcLQ==
X-Received: by 2002:a63:4f53:: with SMTP id p19mr1113561pgl.327.1561384339119;
        Mon, 24 Jun 2019 06:52:19 -0700 (PDT)
Received: from debian.net.fpt ([58.187.168.105])
        by smtp.gmail.com with ESMTPSA id 85sm11187901pgb.52.2019.06.24.06.52.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 06:52:18 -0700 (PDT)
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
Subject: [PATCH V2 05/15] ARM: footbridge: cleanup cppcheck shifting error
Date:   Mon, 24 Jun 2019 20:50:55 +0700
Message-Id: <20190624135105.15579-6-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190624135105.15579-1-tranmanphong@gmail.com>
References: <20190623151313.970-1-tranmanphong@gmail.com>
 <20190624135105.15579-1-tranmanphong@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[arch/arm/mach-footbridge/dc21285.c:236]: (error) Shifting signed 32-bit
value by 31 bits is undefined behaviour

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
---
 arch/arm/mach-footbridge/dc21285.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-footbridge/dc21285.c b/arch/arm/mach-footbridge/dc21285.c
index 8b81a17f675d..edea41e0256f 100644
--- a/arch/arm/mach-footbridge/dc21285.c
+++ b/arch/arm/mach-footbridge/dc21285.c
@@ -230,7 +230,7 @@ static irqreturn_t dc21285_parity_irq(int irq, void *dev_id)
 	printk("\n");
 
 	cmd = *CSR_PCICMD & 0xffff;
-	*CSR_PCICMD = cmd | 1 << 31;
+	*CSR_PCICMD = cmd | BIT(31);
 
 	/*
 	 * back off this interrupt
-- 
2.11.0


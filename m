Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED2452193
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 06:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbfFYEFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 00:05:12 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33115 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727521AbfFYEFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 00:05:11 -0400
Received: by mail-pf1-f195.google.com with SMTP id x15so8746469pfq.0;
        Mon, 24 Jun 2019 21:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NwvK03LyNmiunrWDZlJJgmSS8YZo2C1RqTMo9dix3Fs=;
        b=AAoNPyt3mDNtyitZPCM2n9R1V+8lOxDrljEZ9C4uePvYyDM/UJsfFgcIlJM3WtkGkI
         /oWTlZnnBCoIeJwiJ0/htBXQ9r7aGBcPEVXERVZj0lqExPoE3RsTEvWGrHFhU3As3WBC
         X1MWbeVNF//UzWsGYwNFDKmkYbQFP9QWlTlVi73U4C7ORLit+UBWKBGVF/eJGYqUykSZ
         EFXlvTI2lYGJbXPMBrXQwpZOvOhPAgAa3UUu4keLtM8PKiKs0hzkLkG+LypHuwlj8+VO
         Hn2f5kRJ3Tkfzgj+4/5f9IDpKVgUtO3y+x6IuL8gaprH6VYg/4H8Vh8blaihIkKxk9XE
         Q7iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NwvK03LyNmiunrWDZlJJgmSS8YZo2C1RqTMo9dix3Fs=;
        b=YQfv2WvpW/b2cSzYRw2QLFFbeRTnS/OHAlMW9UVgqzW0O1C/zdcH2f55RvJ6n1Wrme
         GxlgR/jL6H5JqwHYzuMCPPaPJG7pC1EILfDpPumR47hKCblSvD/i3uiD21ZAxDfHBKuF
         FSsKkxgcjUUmCnwf9HyhYjFP0yepNtLPesDZHrLwHUb46tAjEyIzedH1m/pYK1NXOlsP
         ThjeUeZjkqPBstXQVAF7XLuXl46ZVetR7Bj7JBnGDQwV3wUqOsGVuuzk5GmM+pN8JxIQ
         8BRGTMAk1qkt94E0XgcILWCPbrjpY8yqnnwzwKEbD0Hgkk0XKJfFelKxbjGRQe7+eeXT
         Cjcg==
X-Gm-Message-State: APjAAAW2wVtUuA8VI2B2FzRYM1xYRkpgkQ9A9Pc5gtZTCzJPNsDaIDUC
        5QCcYxfwcyK48VHPrUMdJtc=
X-Google-Smtp-Source: APXvYqwl9bb5pqm7bGxTCo7Jmg3L12Vp3eOl6vq5TM2UCQhs4IfP2UhLaSguPxoJaJVj6MMigvLLvg==
X-Received: by 2002:a63:d1d:: with SMTP id c29mr26905708pgl.251.1561435510818;
        Mon, 24 Jun 2019 21:05:10 -0700 (PDT)
Received: from debian.net.fpt ([58.187.168.105])
        by smtp.gmail.com with ESMTPSA id b24sm12408944pfd.98.2019.06.24.21.05.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 21:05:10 -0700 (PDT)
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
Subject: [PATCH V3 05/15] ARM: footbridge: cleanup cppcheck shifting error
Date:   Tue, 25 Jun 2019 11:03:46 +0700
Message-Id: <20190625040356.27473-6-tranmanphong@gmail.com>
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC4F4FC3A
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 17:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbfFWPPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 11:15:01 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33575 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726429AbfFWPPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 11:15:00 -0400
Received: by mail-pl1-f194.google.com with SMTP id c14so5444321plo.0;
        Sun, 23 Jun 2019 08:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=x8vjNtHwOtOiYp+v5zcfCgEak2OUOTXNTlrGHys9wmc=;
        b=prY5NPMjkWQ8IFspCac++UoQiVBiMhoieVp4FWcrCVEgMMyWl/cauItbgNbhSG0GHk
         tP4CBpb/GIBmR0CQ9tBByyxfEUtOAMk+b/o2IkzNFU20UV3KGJWH89ZRkPmocq0LA0dv
         LjPIZDcIPe1OsLX2O9OVgm6Hjz1tstE8/jvdUl32kNSuE4LVD186nseuEmCxcf1RUhr9
         nSSM0RhF9kIw1bJeMpdO4T4FYsxJSU2YALWh/inwhTqO4BzCQ6o1BtcCKif3UKjaxH6Q
         rHMHfvhlTQZv5Zirc9pYKdOb6nVV5SopNNmfabEwQ1dU+bSOn41lh4JbAp3lfde8+/dZ
         FTjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=x8vjNtHwOtOiYp+v5zcfCgEak2OUOTXNTlrGHys9wmc=;
        b=ZqfbgiWoFPgAqQCYnBXlIfHa6PxuWCANaJYBX+DGmZXjAIFA3WBSb0C7GW6rwQubMm
         akC7yIn4G5pAobtBYoD01NqYu5phhS1gwxUwyERaq/AHGfxBsjH3v5Z67gwdnUqX79d8
         +4TMxC7l4cWdYF97KTu6ig9BI+rR1PHTSVv6OdjuiX3lgEELsaXLoIe29gp09bmqOBmg
         stQaKjt6lcE+0bb0ifFmGuvs1ZsTA7yd38IT9YLnfJk3L3PcnYtSlJ4JJiZqFIeBVJ3T
         uU9KZ/VRTpF5iw2kc6HKbq0LkY+3bV9IqHNbb/A8v1dTGNTZDupgczcwGOUHjOp4v/cD
         58Ag==
X-Gm-Message-State: APjAAAX9aLz9v9jnxrzbdo/OXNTDHpS8RbZodq9xz/AP30a74A1A92Z8
        XmOdaxspandI2EzvXp67LMs=
X-Google-Smtp-Source: APXvYqxsTR3lNL33V7DnaOKPQ/zlcHAgAHS4ziDze8yeNHKWjnpGcM6F2nh0rNuYMTmiqnqh/Ngk8w==
X-Received: by 2002:a17:902:d707:: with SMTP id w7mr25735197ply.128.1561302899620;
        Sun, 23 Jun 2019 08:14:59 -0700 (PDT)
Received: from debian.net.fpt ([1.55.47.94])
        by smtp.gmail.com with ESMTPSA id p6sm8329194pgs.77.2019.06.23.08.14.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 23 Jun 2019 08:14:58 -0700 (PDT)
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
Subject: [PATCH 05/15] ARM: footbridge: cleanup cppcheck shifting error
Date:   Sun, 23 Jun 2019 22:13:03 +0700
Message-Id: <20190623151313.970-6-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190623151313.970-1-tranmanphong@gmail.com>
References: <20190623151313.970-1-tranmanphong@gmail.com>
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
index 8b81a17f675d..a6c86175e76c 100644
--- a/arch/arm/mach-footbridge/dc21285.c
+++ b/arch/arm/mach-footbridge/dc21285.c
@@ -230,7 +230,7 @@ static irqreturn_t dc21285_parity_irq(int irq, void *dev_id)
 	printk("\n");
 
 	cmd = *CSR_PCICMD & 0xffff;
-	*CSR_PCICMD = cmd | 1 << 31;
+	*CSR_PCICMD = cmd | 1U << 31;
 
 	/*
 	 * back off this interrupt
-- 
2.11.0


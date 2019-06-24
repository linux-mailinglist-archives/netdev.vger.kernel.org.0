Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2064950CA2
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 15:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731582AbfFXNxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 09:53:02 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:34636 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725562AbfFXNxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 09:53:01 -0400
Received: by mail-pl1-f196.google.com with SMTP id i2so6938173plt.1;
        Mon, 24 Jun 2019 06:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=o+ZDWBfm2abAbsaQJdJWT0tYwJIbtKKTiQzNHlOhOmc=;
        b=mATa2ATeRIqXLHNrCKLKzhr/2hskya7Ak4UVgBjx0zZE1lUOuyUqZM/SbPgTJVYxbG
         kBbiRUM29IPbKOjBpLw7MPxd4rJKxLo1kEjhgTH2SDeL42XYDBzdEGFAgIcBPV+PLrZv
         BVoRIQNSL69D69kfrskmDDo7mp2uQnWLAMVgZ/uNS6MojURn8aquNJCnOenRC2Xl9knh
         B2D0WrwQ/e0mqWVqDa44NgijhhkY68Y8VSWYuby/3qu6JmoVMkyMrz7FlRzerxw6JF/p
         46niQRO0gRqB2eRVrpyiRoVlfR4ZWcysbnnDHPZOtvsNpmpjjjA0kqhJTLLPWu1hXJqN
         1WOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=o+ZDWBfm2abAbsaQJdJWT0tYwJIbtKKTiQzNHlOhOmc=;
        b=YXeypvxuSVxzMZ4e8bm+uzeXv7yIGSsBvQH3x6zPsVVeTiOiwPIU5Nnzsx6ULpCeb0
         ZcvylimDaztiJWXbgARl1rl+gAjM4dsb9rnRhD3R96nITMhqrUiV725Jh/skZcyLjT/X
         3NNap3u/3B1H1CK8WSAVirkBSzqlEZ40K3fBh+uxtQ4GrtU9ThLPLS7599cjrxR9Cvn+
         +M5fRrv3azwWjCmN03jtZpBlQEQ2oG7B0bbFCKeQ+aXesii7nkyEpn+WQ144Udn7O7Dp
         7fW9KUiuVXhDx0GRcyriYjJDRAvE/D95uKG9/JQlqKndOWdcRctaLeOnf1Nt3IqLo6vv
         eJCg==
X-Gm-Message-State: APjAAAXrT1dkR9JFSTe3zL0Hb8isz19fNrX2W0riucXdvs06IO5cIHjB
        xNT05fpjQLlhGC4/WttVSnI=
X-Google-Smtp-Source: APXvYqyFvSUOW1M5UN3D0xuSlAwvYuYUqbXawl50oHczacseIZIUy2d9AFm4wsrEbGnjiugAv+3LBA==
X-Received: by 2002:a17:902:d88e:: with SMTP id b14mr95284050plz.153.1561384380597;
        Mon, 24 Jun 2019 06:53:00 -0700 (PDT)
Received: from debian.net.fpt ([58.187.168.105])
        by smtp.gmail.com with ESMTPSA id 85sm11187901pgb.52.2019.06.24.06.52.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 06:52:59 -0700 (PDT)
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
Subject: [PATCH V2 09/15] ARM: omap2: cleanup cppcheck shifting error
Date:   Mon, 24 Jun 2019 20:50:59 +0700
Message-Id: <20190624135105.15579-10-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190624135105.15579-1-tranmanphong@gmail.com>
References: <20190623151313.970-1-tranmanphong@gmail.com>
 <20190624135105.15579-1-tranmanphong@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[arch/arm/mach-omap2/powerdomain.c:190]: (error) Shifting signed 32-bit
value by 31 bits is undefined behaviour

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
---
 arch/arm/mach-omap2/powerdomain.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/powerdomain.c b/arch/arm/mach-omap2/powerdomain.c
index 1cbac76136d4..886961726380 100644
--- a/arch/arm/mach-omap2/powerdomain.c
+++ b/arch/arm/mach-omap2/powerdomain.c
@@ -35,7 +35,7 @@
 #include "soc.h"
 #include "pm.h"
 
-#define PWRDM_TRACE_STATES_FLAG	(1<<31)
+#define PWRDM_TRACE_STATES_FLAG	BIT(31)
 
 void pwrdms_save_context(void);
 void pwrdms_restore_context(void);
-- 
2.11.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF3184FC4E
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 17:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbfFWPPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 11:15:41 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:42425 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbfFWPPk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 11:15:40 -0400
Received: by mail-pl1-f194.google.com with SMTP id ay6so5413091plb.9;
        Sun, 23 Jun 2019 08:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=3+L+m92RKVlxIth04caf4Zltjx0JFkHOCKxF0c91WgY=;
        b=dIfhu/+wcLcn3FRJePZkcj3m3UIw5F8tRx+ntxu6JlzAyAyfk4Q7NnyzRl/Y8qnLnn
         OiT+qZoFJ5RYByKyJO/lELxsiv3nDjBuC6SAhOUGIcc1qs+RbfHGz6vL+txBe+0HD0cC
         uAKNUQshNv6075rri9m6JwwbnVIF2VrvT7HAKHHAa8sgeO14gN6QKofunt3myASc46Om
         N0sR58ttGDg7VqomHJtuAciW6ZqE+GoffNrr9xVWAZw1HzJ7Pq9CeUsfCgb6l2qyJ3uU
         X2XkyMllO3tE/bK2C92azHgOKWB/1SZYHTPC3qqiuFfx9obP+SOn2BTvPBlJQqqWUzkG
         TweA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=3+L+m92RKVlxIth04caf4Zltjx0JFkHOCKxF0c91WgY=;
        b=VlNZBPvQSp0VAdn1jmmiz3CEY7f/VlEmyYdZOjqVcuUgncYps76BLsm1Z8vX8wn+o6
         62sAKQEmT9EmaYZUqbvxbGZN5osjzF3XvCGPm7tbdy9seC+uVCu6mEZMxxGQzfwtbHgM
         pYOCnVdv7/qR95fjveaLNVwHX5OAchpUVxPcAyJOkzk+8EZMytpheg7aPstHLH8YvsSZ
         ZA6nlTHqzopRvHiQ8R4zMB3jchBFtMIVF3zvtGqFI3VRPoGycRA8GvubbqbS/T0+Kq5k
         xs5jhhCyvc+LB946nGzUPqR660TpYOv5COH1uCzX75UfGkLw/PbzuIceccKXtfCMixMr
         c6+A==
X-Gm-Message-State: APjAAAVpSOwTqd007/Nh0LunOW6Yr0Touk1qACT4/Gru8PWKbqPXXGta
        +hHY2TYROnOoGIbtBq2keX4=
X-Google-Smtp-Source: APXvYqya6AOQmWLiHbLRxhTc/YEJqY7mob3UttIwLVQQNhX+dXLowCCBoXn4G9qN9EXDIwRyYxdqmg==
X-Received: by 2002:a17:902:e2:: with SMTP id a89mr143941191pla.210.1561302939772;
        Sun, 23 Jun 2019 08:15:39 -0700 (PDT)
Received: from debian.net.fpt ([1.55.47.94])
        by smtp.gmail.com with ESMTPSA id p6sm8329194pgs.77.2019.06.23.08.15.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 23 Jun 2019 08:15:39 -0700 (PDT)
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
Subject: [PATCH 09/15] ARM: omap2: cleanup cppcheck shifting error
Date:   Sun, 23 Jun 2019 22:13:07 +0700
Message-Id: <20190623151313.970-10-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190623151313.970-1-tranmanphong@gmail.com>
References: <20190623151313.970-1-tranmanphong@gmail.com>
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
index 1cbac76136d4..4e2eb39bc698 100644
--- a/arch/arm/mach-omap2/powerdomain.c
+++ b/arch/arm/mach-omap2/powerdomain.c
@@ -35,7 +35,7 @@
 #include "soc.h"
 #include "pm.h"
 
-#define PWRDM_TRACE_STATES_FLAG	(1<<31)
+#define PWRDM_TRACE_STATES_FLAG	(1U<<31)
 
 void pwrdms_save_context(void);
 void pwrdms_restore_context(void);
-- 
2.11.0


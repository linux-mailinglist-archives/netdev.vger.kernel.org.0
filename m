Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 039A44FC24
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 17:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbfFWPOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 11:14:16 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37379 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726417AbfFWPOP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 11:14:15 -0400
Received: by mail-pf1-f195.google.com with SMTP id 19so6057433pfa.4;
        Sun, 23 Jun 2019 08:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=vyn7/J6WtFqIgwRgd3bOo6fzSejJfTSgtqjS1/ZB+c0=;
        b=c4UGlyPAQFWxnUFzIHpN9PK/1UAkdiP0wHX591aQvU+VaG5vobK1l+jhu8JjTAHWx4
         PX9TGvgnXXcDbbCSQbjGFntFQSovX3Kv00SSfo4siU/jR00o5oNeWkU5RBCKOTV1ivgv
         jgWLvIH++KHJ+lZxFqUlWKrR4gY+UEbQUIyv0mwhBE4gEu5bqaOHqHBoyzcDuUt/Nj4M
         O719CMy7/5OdSSbZYe1is/dDdvpWJZos9Q6dBWwA3qr8b//6Elcn7/DtRSio/Yzy+uJO
         QxfSmr84FYhenR6h9/L1xhdbvthxAtXhS+pvu5b1ZMaeCRtPOfMHrSMsfI2ckzToIyB7
         OCCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=vyn7/J6WtFqIgwRgd3bOo6fzSejJfTSgtqjS1/ZB+c0=;
        b=n0X7bYXyzV8tDLM+CXK4GM3wP5WV2UvGcwNJANdi1qx9KqqXhKWWzqDKYDsX+wOLpU
         mgb7VlKlHgz/Gkhi6Dq9Bt7EspJFKlfEonK47kPoeEfpb0J0MoSXvA7ClG1I0xcVhjMe
         DOaOzc0nIT6t4lD2DhQJXLMqIZwkAnGjlX6O95nLmPxDdWdvzHfvqUbQQ41Mr21TbTWY
         t/n8oMN0PrBijgVFOuWINDf8cwzRExRAN20CY3G/qtaxecMDU+Z5zZ0hDPxT2BcnVy0U
         6EW4NjVMzS+AXfffulCXH3e+cE5rvHoAl+ryjiMmj/YzuiOUoH0fxeDoRIOxexul8AVD
         GjdQ==
X-Gm-Message-State: APjAAAV89HVClSdNumwDiaoD7hFwJoQSkmZ5DLzVseVNAAH0TBI9VWOy
        KMjFM55JpJy9bEKHP6IcgVk=
X-Google-Smtp-Source: APXvYqwWurJt/gVmQMSK4uD+ZWYajKFCJvoak+ySh0QBSZIVNlGPKNVwYFC55ffGFpHzajFSctII6A==
X-Received: by 2002:a17:90a:5887:: with SMTP id j7mr18982260pji.136.1561302855004;
        Sun, 23 Jun 2019 08:14:15 -0700 (PDT)
Received: from debian.net.fpt ([1.55.47.94])
        by smtp.gmail.com with ESMTPSA id p6sm8329194pgs.77.2019.06.23.08.13.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 23 Jun 2019 08:14:14 -0700 (PDT)
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
Subject: [PATCH 01/15] arm: perf: cleanup cppcheck shifting error
Date:   Sun, 23 Jun 2019 22:12:59 +0700
Message-Id: <20190623151313.970-2-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190623151313.970-1-tranmanphong@gmail.com>
References: <20190623151313.970-1-tranmanphong@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fix "Shifting signed 32-bit value by 31 bits is undefined behaviour
errors"

[arch/arm/kernel/perf_event_v7.c:1080]: (error) Shifting signed 32-bit
value by 31 bits is undefined behaviour
[arch/arm/kernel/perf_event_v7.c:1436]: (error) Shifting signed 32-bit
value by 31 bits is undefined behaviour
[arch/arm/kernel/perf_event_v7.c:1783]: (error) Shifting signed 32-bit
value by 31 bits is undefined behaviour

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
---
 arch/arm/kernel/perf_event_v7.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kernel/perf_event_v7.c b/arch/arm/kernel/perf_event_v7.c
index a4fb0f8b8f84..83dc472a39b2 100644
--- a/arch/arm/kernel/perf_event_v7.c
+++ b/arch/arm/kernel/perf_event_v7.c
@@ -697,9 +697,9 @@ static struct attribute_group armv7_pmuv2_events_attr_group = {
 /*
  * Event filters for PMUv2
  */
-#define	ARMV7_EXCLUDE_PL1	(1 << 31)
-#define	ARMV7_EXCLUDE_USER	(1 << 30)
-#define	ARMV7_INCLUDE_HYP	(1 << 27)
+#define	ARMV7_EXCLUDE_PL1	(1U << 31)
+#define	ARMV7_EXCLUDE_USER	(1U << 30)
+#define	ARMV7_INCLUDE_HYP	(1U << 27)
 
 /*
  * Secure debug enable reg
-- 
2.11.0


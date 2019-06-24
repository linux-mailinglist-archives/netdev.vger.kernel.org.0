Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8169D50C74
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 15:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731421AbfFXNvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 09:51:36 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36808 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729897AbfFXNvg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 09:51:36 -0400
Received: by mail-pl1-f194.google.com with SMTP id k8so6946246plt.3;
        Mon, 24 Jun 2019 06:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=g+59H8Z9R6aFCllHzxZMVdaWp3beSnoXs0YpMI9P76I=;
        b=CNu8Tey5ecdeC0dxmKIylKFuyktEfUiiGmsdAp8NYLO60i0F+s+Q2eveqKWRpdPK9+
         F3iqkZmTIAQV5TH/ufwj/38JJF90U6smjtSpKEm+yz9nwbY0kGSrngmjhqAeFJMHdaRY
         rj5akUsjX/F7aDLKDQgBJJIqhrhg6ef1PsheYB3e0UtfGrhmeYTdMOdbCZ96dwrzp7GN
         RMQwkKt/nfqxn0BGbFuRoQZzZAVt6t2XoIvDLn0qRNwyF3dQwfY1nm1+JZCgellhWdzU
         Q+qW047N6aI86rlH5r326qwyXCeYmMRsed4pNYcplLsxxH1yY68rFfkXVGCu26yzEF9u
         5e0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=g+59H8Z9R6aFCllHzxZMVdaWp3beSnoXs0YpMI9P76I=;
        b=hHDnCVJNpAR6ObpYlButXjcPCPorv02nX0FSitIsxY1C++fT6wMsVJT95eQkOHE+zT
         WJZGFgc1kPqMuu/kKuyllO42a8uopARlOTrY/R5eJK2OsESiSTDrMbLbhtpgqHt3E3Cj
         7SPh5VfFiQ0JqsvTSuqvjjU/NeXtKJ7pqjWxLA8dlz9krLAX0DKMTY+c7hbdqXAoSe7h
         P54opNPQGXGEey4zAfB5SPUkSWwO87YtI17xDeHPcooHAcY9L3VsORz0mSF+EtLmXYGB
         18r7vqXrFU/k2GFeX6nkTnFFgZDKH5MaXnOstMC0tpbCwRygpUWPey6Dv7mgZEUq3zpb
         5frA==
X-Gm-Message-State: APjAAAXloNCijVANyuP7grhf47B7NBDB++N6js8cV8fjAOHvUDNS8Zn4
        B0/PWqlp8OBmbr+MepvNcjVgz6o0FbJ++A==
X-Google-Smtp-Source: APXvYqwTfafEH1f93hVfmGDpur/BL1hHytFvk2bWzOAsumoC9Z8Pd2e84hLPwl90XKTXBjrzIG+Kog==
X-Received: by 2002:a17:902:9a84:: with SMTP id w4mr45508269plp.160.1561384295411;
        Mon, 24 Jun 2019 06:51:35 -0700 (PDT)
Received: from debian.net.fpt ([58.187.168.105])
        by smtp.gmail.com with ESMTPSA id 85sm11187901pgb.52.2019.06.24.06.51.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 06:51:34 -0700 (PDT)
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
Subject: [PATCH V2 01/15] arm: perf: cleanup cppcheck shifting error
Date:   Mon, 24 Jun 2019 20:50:51 +0700
Message-Id: <20190624135105.15579-2-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190624135105.15579-1-tranmanphong@gmail.com>
References: <20190623151313.970-1-tranmanphong@gmail.com>
 <20190624135105.15579-1-tranmanphong@gmail.com>
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
index a4fb0f8b8f84..2924d7910b10 100644
--- a/arch/arm/kernel/perf_event_v7.c
+++ b/arch/arm/kernel/perf_event_v7.c
@@ -697,9 +697,9 @@ static struct attribute_group armv7_pmuv2_events_attr_group = {
 /*
  * Event filters for PMUv2
  */
-#define	ARMV7_EXCLUDE_PL1	(1 << 31)
-#define	ARMV7_EXCLUDE_USER	(1 << 30)
-#define	ARMV7_INCLUDE_HYP	(1 << 27)
+#define	ARMV7_EXCLUDE_PL1	BIT(31)
+#define	ARMV7_EXCLUDE_USER	BIT(30)
+#define	ARMV7_INCLUDE_HYP	BIT(27)
 
 /*
  * Secure debug enable reg
-- 
2.11.0


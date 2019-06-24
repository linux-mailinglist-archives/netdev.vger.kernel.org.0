Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 880AA50CC0
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 15:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731683AbfFXNyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 09:54:04 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39396 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727140AbfFXNyD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 09:54:03 -0400
Received: by mail-pg1-f196.google.com with SMTP id 196so7165424pgc.6;
        Mon, 24 Jun 2019 06:54:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zQjmLUgEgoPYdrEskiQd4eI/hvTCG1dio5TGPGs8EvU=;
        b=UXviz1FYWv8LN1KB9XAPp5ETo+uB/IhP6eA5IhifyHK/8l+NW03wtZF7RX4PrIXsHx
         dp8ULP35iE7bckUFcqETJi1pxJxGwde4NNtkPv9J6pmTKcJq7Lq0/QzBWaMH1cXxjmK1
         VVk1vfcf54VSZJz1ijVnEwQQnYomeeJ/gRPYU++4kuF8C0B6Nb+AptRraMhGsMGuCC5U
         kk+PG4vkVCWPqKSKvkJklXXFevySyZbuyoWMaKpu8ZKML1tybp8WFKgDuOugpXza09O2
         ax9D28gHNmZ/4fR2gzO9BDBcY1gTo9oJJpt57uo+9h4sUyRp87sAjnYObb8pGDxn37MI
         sroA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zQjmLUgEgoPYdrEskiQd4eI/hvTCG1dio5TGPGs8EvU=;
        b=jV3wuEbYwB1DE2z+wkofAR+sE0v6SaTjUYNwiL+qz2dbXJy4X+xxYhdymSLj0IktXw
         4JA3wZPbxet8l3TT0EkcIzYIslpBWX5FaD1iyHkGzrwH0ZvsqT6EkHT6VtOJOp2vCq08
         PK0JrlFmYKVvVwQb48Hjlf65iwAeqpjCIhFtWDzMRC1sTr6/1AbWEq0yXJPzMzEj0SPs
         I3et15C1Sxo47d+vbeBCSm6J7j/T+1gKsHM+Ur7gaAov5PQ4d4ZkyMRxLAmBekpZztUD
         M2Wb+RGuJey5l+ncgNFMe/L+c+J1hGTn03+6La2YX+Qjmy8JS7xkscoOSaNLkDoqGplv
         WOrQ==
X-Gm-Message-State: APjAAAVlFUfIAHBVw1SQ/LFzbh930oHDWIxx+OpHLC0JpXYzhiPkAtDV
        ytYBHaHQqt25fhUnAWul09s=
X-Google-Smtp-Source: APXvYqwsnArH+danaJWoE22SfrR+t5xwX6bWxe/Zdpf+y6WnyhMXlbKolknDOiUoSOzrR5fKf1OJdw==
X-Received: by 2002:a17:90a:cb12:: with SMTP id z18mr23838087pjt.82.1561384442876;
        Mon, 24 Jun 2019 06:54:02 -0700 (PDT)
Received: from debian.net.fpt ([58.187.168.105])
        by smtp.gmail.com with ESMTPSA id 85sm11187901pgb.52.2019.06.24.06.53.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 06:54:02 -0700 (PDT)
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
Subject: [PATCH V2 15/15] ARM: vfp: cleanup cppcheck shifting errors
Date:   Mon, 24 Jun 2019 20:51:05 +0700
Message-Id: <20190624135105.15579-16-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190624135105.15579-1-tranmanphong@gmail.com>
References: <20190623151313.970-1-tranmanphong@gmail.com>
 <20190624135105.15579-1-tranmanphong@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[arch/arm/vfp/vfpdouble.c:397]: (error) Shifting signed 32-bit value by
31 bits is undefined behaviour
[arch/arm/vfp/vfpdouble.c:407]: (error) Shifting signed 32-bit value by
31 bits is undefined behaviour
[arch/arm/vfp/vfpmodule.c:263]: (error) Shifting signed 32-bit value by
31 bits is undefined behaviour
[arch/arm/vfp/vfpmodule.c:264]: (error) Shifting signed 32-bit value by
31 bits is undefined behaviour
[arch/arm/vfp/vfpsingle.c:441]: (error) Shifting signed 32-bit value by
31 bits is undefined behaviour
[arch/arm/vfp/vfpsingle.c:451]: (error) Shifting signed 32-bit value by
31 bits is undefined behaviour

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
---
 arch/arm/vfp/vfpinstr.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/vfp/vfpinstr.h b/arch/arm/vfp/vfpinstr.h
index 38dc154e39ff..8951637c58ff 100644
--- a/arch/arm/vfp/vfpinstr.h
+++ b/arch/arm/vfp/vfpinstr.h
@@ -57,10 +57,10 @@
 
 #define vfp_single(inst)	(((inst) & 0x0000f00) == 0xa00)
 
-#define FPSCR_N	(1 << 31)
-#define FPSCR_Z	(1 << 30)
-#define FPSCR_C (1 << 29)
-#define FPSCR_V	(1 << 28)
+#define FPSCR_N	BIT(31)
+#define FPSCR_Z	BIT(30)
+#define FPSCR_C BIT(29)
+#define FPSCR_V	BIT(28)
 
 /*
  * Since we aren't building with -mfpu=vfp, we need to code
-- 
2.11.0


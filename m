Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2369521CA
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 06:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728691AbfFYEHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 00:07:00 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42967 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbfFYEG7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 00:06:59 -0400
Received: by mail-pg1-f196.google.com with SMTP id k13so2061214pgq.9;
        Mon, 24 Jun 2019 21:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=AkRO8e5ycrnKuMZ4NjLtJGYkQOt0yCD26N+5kX9ibhg=;
        b=t2YZaCuhvjFlf7YncEX3gIhPMcL7Iu0FY+acuNPHA6QV81xTms2oc7LIg2W9Bax5+H
         T5+ekJ51erToESTcK4rhSaiuPsRlYc7av1WygdOg8RB8WAqvsmluOIkrkqRUrDTMlbDr
         1zBS12N5VDuDkhmYfGHnDSoc0dAHhIBC8uRDdHN+gluFmuzeoE/Gb2GrC+lJxhMXCTO7
         tXjnOr36Ra0/76T3Mp8QEN9oxn1vnlMsRqxu9aOHc1i/HO3f7pG99tfg4o56/r+bj0Sp
         Gm7qJMC7B9qToK5MSc4MClny4ZBzDcV/c3GxiqOF8WMZsq+VLM2beXAJe1Cxav6uZMFd
         Q7cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=AkRO8e5ycrnKuMZ4NjLtJGYkQOt0yCD26N+5kX9ibhg=;
        b=qBkbFqcCLm8CM36rWJ4oRi2u8VnCTKQedQbzbR8aHlboCyriAMmyGTyPnSzeUVqQPG
         Fwk1MSF6RzUzLrQ7Sv1wG3KLTHvnxGPsGRRF3iBO9W1JEmA31XoPSTRGepjxz2vnAYFt
         s8KyNkG2gS+TAnjkWNIpraDWesqr8MELOvwGGBpiKtrgaMO1qJ0a4ezTS0P33lIeTA9b
         N7AmNmWRdY15m2/3TvwBQ9/yFJpTCBt55QSxkja42dhrHuQFXAzGN87PawnBwr2jMTVs
         /VhG0gziyI0d5K23MoebG+sXqLGNWEjC9CMn3niu/Z5aUAHJlwgubpwT58zXniKfP313
         oUFw==
X-Gm-Message-State: APjAAAXgFeb1fErp7t9RdEbVuTTyInPDSjP5H1LSefSNnQ3SauYBEhfr
        OLbLf1ZZEUbShEwxPm+MeoU=
X-Google-Smtp-Source: APXvYqxGPcvS+CgSVL0iAo8yD0dXMNypsdhxM+aU3y+08qc2XIBNbVS4ubqgvBDyXo5VTAuPulM0Og==
X-Received: by 2002:a17:90a:601:: with SMTP id j1mr28615892pjj.96.1561435618978;
        Mon, 24 Jun 2019 21:06:58 -0700 (PDT)
Received: from debian.net.fpt ([58.187.168.105])
        by smtp.gmail.com with ESMTPSA id b24sm12408944pfd.98.2019.06.24.21.06.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 21:06:58 -0700 (PDT)
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
Subject: [PATCH V3 15/15] ARM: vfp: cleanup cppcheck shifting errors
Date:   Tue, 25 Jun 2019 11:03:56 +0700
Message-Id: <20190625040356.27473-16-tranmanphong@gmail.com>
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


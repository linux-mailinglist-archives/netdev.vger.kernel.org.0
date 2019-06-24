Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79C1550CB6
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 15:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731651AbfFXNxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 09:53:43 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44429 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727140AbfFXNxn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 09:53:43 -0400
Received: by mail-pf1-f194.google.com with SMTP id t16so7542907pfe.11;
        Mon, 24 Jun 2019 06:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2Ib6apxv8gRjgx2W+rU23MZovgO1Rv4rO0KoJJn7KBQ=;
        b=QXxv4Pc4UhV6ADq8OmnYNeL+B0h/eFNOSeeSzwI3LvyZ2n111P6QQ6RcWIBUNOXJ0z
         VNLD0gK/XIijZyx14lpOE7XaACCVSurxwJKNHb3eYyplp9arLF3AT8cI0e30r5Cz7v1B
         14AcRpDKhGAY0penUp9IlQ44ASSri9j5WgODEsD8bmRSUgtsO9Xb8hJJsv8Xna8GotI8
         drhanKgYEbuo/VYjttS8aq/Ho9rKJh2t9lv05p/0gYArSbc7Ytmw7g53H1ub8A0DFXX6
         M8onvoepnmP4MBK0muFBXirmAGqElNXDQUC2+WBGwED3holXEVjicYo6GEZ3uWfWP0ho
         BA3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2Ib6apxv8gRjgx2W+rU23MZovgO1Rv4rO0KoJJn7KBQ=;
        b=hg05FddCA++WGl/BApLqeK2HAyDeHYtUsztNN0G0Ybl0X+nYd4rnhRt7scsQH7/hF8
         qY9+MGtNhOv4BQkbOujiSAIEm/9Pp0ftPkX7O9vpm1SAAsqLXi24e93E25xPIX0d5siX
         O0Hp7nTgmAL7V+gvpiRQxu9oOE7R4iYDKHsZE1LTSWRGDh4VnbUQ3Iqv4fbz8MT/pEsr
         mhnJmTaEabhLdVj0rQ7mIsqfnAHX5p2doUkKxfbwlvJ0udUablTWeU/1xK5RhR/kFGZp
         +qCYPM0l80REkJmnK4cUU93xePOxcY/de+RO/TQdHoJZNnXKBOrrfuOqJaOeJFH0T7jf
         nzcQ==
X-Gm-Message-State: APjAAAWGOwLgWQbHsdzgIzTPYb7T0F0vs9b8IXgMcLUr0CHZSH2J8ZqN
        5P5U5v/6nCJRbnS/nsxjIl4=
X-Google-Smtp-Source: APXvYqxrHRC0GblqNGotiF+GZCcz9/8gz186EXl0dhoRCdfQOZBidgjVd63dyLThBbMCx1972glsPQ==
X-Received: by 2002:a63:6986:: with SMTP id e128mr17939443pgc.220.1561384422032;
        Mon, 24 Jun 2019 06:53:42 -0700 (PDT)
Received: from debian.net.fpt ([58.187.168.105])
        by smtp.gmail.com with ESMTPSA id 85sm11187901pgb.52.2019.06.24.06.53.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 06:53:41 -0700 (PDT)
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
Subject: [PATCH V2 13/15] ARM: mm: cleanup cppcheck shifting errors
Date:   Mon, 24 Jun 2019 20:51:03 +0700
Message-Id: <20190624135105.15579-14-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190624135105.15579-1-tranmanphong@gmail.com>
References: <20190623151313.970-1-tranmanphong@gmail.com>
 <20190624135105.15579-1-tranmanphong@gmail.com>
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
index c063708fa503..8a706cb7f21d 100644
--- a/arch/arm/mm/fault.h
+++ b/arch/arm/mm/fault.h
@@ -5,9 +5,9 @@
 /*
  * Fault status register encodings.  We steal bit 31 for our own purposes.
  */
-#define FSR_LNX_PF		(1 << 31)
-#define FSR_WRITE		(1 << 11)
-#define FSR_FS4			(1 << 10)
+#define FSR_LNX_PF		BIT(31)
+#define FSR_WRITE		BIT(11)
+#define FSR_FS4			BIT(10)
 #define FSR_FS3_0		(15)
 #define FSR_FS5_0		(0x3f)
 
-- 
2.11.0


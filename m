Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8CFDEC2EE
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 13:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730855AbfKAMnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 08:43:05 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:35773 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730837AbfKAMnB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 08:43:01 -0400
Received: by mail-lf1-f66.google.com with SMTP id y6so7148105lfj.2
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 05:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gyqRKyTXLr3cbd727hzyVbLDXzQNlutZJPmZlRbflNM=;
        b=aJggUxwL9FLbxqyLFcy7mPAsdu7B5NE3B0CcDXY5Xq3/1jU1wpEbTBIRlA5TdkovvK
         YrBP1OnWco5wWah9kA7xb6Uul3pCywE5VSldtrcZOf0D9aO5FvHxB4ekLfnZtOcOgaQa
         KXg1qmuWEC/xejE1gjB3RPnrIhT61rNL3oNHA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gyqRKyTXLr3cbd727hzyVbLDXzQNlutZJPmZlRbflNM=;
        b=ZPHlKJJ0uoF5XTuzVF3/k2biWJSTpm3gYw2MjOMEvyrc8gs0kEVWXI9Exbtc498DUF
         fU1C9doH4psa39LNGSKSQBabCFHKx3RfgK+cmL6qkAf6zrr5sGQY68te9fPwBWA+v3HK
         otAnvnjCk7Ms7W1/y3gi25enic1ufxJx7ThSfDw4wu6hhkwchzAe+jsuBAjQQxp7uNAD
         1GYy4EkPMS17mB8TJuiINkMEMRoiRTSuKVI9Nnh0MNO+JoAxiXe/WaFcFQ1abpQv3I0c
         +R4/2b16YuT/tT1rDLkwPCKnqprJ5Sw7S78VICtl7pXHIzOXbKfrY2bJiZECXNbs0HiA
         dwCQ==
X-Gm-Message-State: APjAAAWDWTJZgbgwLw1BqMz8q1bAnsX3MfZ1cAYELza3qJw9T3wDUGIn
        2fR1TbkUdvdiM3cBS64HHVH6Pw==
X-Google-Smtp-Source: APXvYqy4fEEOS681BI9of8caQte+TOAv9T+4kQxBaUmvtiH4cO+gztE83kQOLok3stailVX2gSWAwA==
X-Received: by 2002:ac2:420a:: with SMTP id y10mr7037550lfh.65.1572612177646;
        Fri, 01 Nov 2019 05:42:57 -0700 (PDT)
Received: from prevas-ravi.prevas.se ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id o26sm2458540lfi.57.2019.11.01.05.42.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 05:42:57 -0700 (PDT)
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
To:     Qiang Zhao <qiang.zhao@nxp.com>, Li Yang <leoyang.li@nxp.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>
Cc:     linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Scott Wood <oss@buserror.net>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        netdev@vger.kernel.org
Subject: [PATCH v3 35/36] net/wan: make FSL_UCC_HDLC explicitly depend on PPC32
Date:   Fri,  1 Nov 2019 13:42:09 +0100
Message-Id: <20191101124210.14510-36-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191101124210.14510-1-linux@rasmusvillemoes.dk>
References: <20191018125234.21825-1-linux@rasmusvillemoes.dk>
 <20191101124210.14510-1-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, FSL_UCC_HDLC depends on QUICC_ENGINE, which in turn depends
on PPC32. As preparation for removing the latter and thus allowing the
core QE code to be built for other architectures, make FSL_UCC_HDLC
explicitly depend on PPC32.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/net/wan/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wan/Kconfig b/drivers/net/wan/Kconfig
index dd1a147f2971..78785d790bcc 100644
--- a/drivers/net/wan/Kconfig
+++ b/drivers/net/wan/Kconfig
@@ -270,7 +270,7 @@ config FARSYNC
 config FSL_UCC_HDLC
 	tristate "Freescale QUICC Engine HDLC support"
 	depends on HDLC
-	depends on QUICC_ENGINE
+	depends on QUICC_ENGINE && PPC32
 	help
 	  Driver for Freescale QUICC Engine HDLC controller. The driver
 	  supports HDLC in NMSI and TDM mode.
-- 
2.23.0


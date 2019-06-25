Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 373C8521C0
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 06:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728553AbfFYEGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 00:06:38 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38050 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbfFYEGh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 00:06:37 -0400
Received: by mail-pf1-f195.google.com with SMTP id y15so4086873pfn.5;
        Mon, 24 Jun 2019 21:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7yVxj7qKDtvL1bbpI3Z9+uvLXYYsfj4EfWE4pae8tOM=;
        b=TgO1bd2E3txQAnLRmmK7nedFUr0FJpwuh/ubKaSgG7b8MsG7RFDKCXwsST+HwENLIl
         u6kdJClv3IX6Fn3/ErXTChm+Jy9KfhiPBxx4dA2hLtd6zdCJtWSCqrYXfGkKbu2SOUXB
         rupZZ3OgxlRZtooEg5sWSoFTfsOZXjbkpKk9wEjD9tZ9HPSi4C8Pivuipn0npv5AM9pN
         OiYAkoGb9v2izLjeXnMmTShUre3BdVyjU0WNXgxDIn6DKeF1oPT7yZ9UM8NjQ6mp4Fy6
         Tqm+LdQoYbCaCKCKN97LieN+C7FIsw6OLZ7DfaVpD5xWBoXLKKwGShfjLiohv+vbJlbg
         4deQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7yVxj7qKDtvL1bbpI3Z9+uvLXYYsfj4EfWE4pae8tOM=;
        b=TJfuQZrnAkvGYfk5TsGXkt/KTK43Ia9Kb/oTQJlAbxHc8S37Bm567RNa2rG+aY3Hbk
         RmdMS7jiFEmxlR3M67C+/mvRrTHsu3q2bgKeEeyXmgUiJVGsL6m1DrMRunF+TY31aA92
         yn4um1TGP2lWUDHrB75vQ2CnAsBBsHx5KEoe9ttCu2TQ6XRGeKmdN4LLUTvfeOh5rN1j
         5Q79/yb+idIbWrpKf8rdOvRXU2ctXAdUSMF+voEJvWbgVc6LhH1X3N+7IJB2F6sx0d2D
         zm+dPeWVt87wcOtxW+YZcJFydjo0svzU2vq16EVagppIV+xiZDftXq6Hu+4rcsOm0kRS
         4twQ==
X-Gm-Message-State: APjAAAUnPRF3al9h4Udgum7zY7X3klus1WLmAKgCstSiOLYJSCuLagkJ
        o4PFTzuC9GcUGbrsbojF9lI=
X-Google-Smtp-Source: APXvYqyxnGl4XLuhQlGi7nSJsX/EE/BeJaywRYOKuiI0RY7sOOkzi2bS3YItHdEFZiG0l4utiPR3dw==
X-Received: by 2002:a63:d53:: with SMTP id 19mr1890365pgn.453.1561435596806;
        Mon, 24 Jun 2019 21:06:36 -0700 (PDT)
Received: from debian.net.fpt ([58.187.168.105])
        by smtp.gmail.com with ESMTPSA id b24sm12408944pfd.98.2019.06.24.21.06.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 21:06:36 -0700 (PDT)
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
Subject: [PATCH V3 13/15] ARM: mm: cleanup cppcheck shifting errors
Date:   Tue, 25 Jun 2019 11:03:54 +0700
Message-Id: <20190625040356.27473-14-tranmanphong@gmail.com>
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2FC05219B
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 06:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728066AbfFYEFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 00:05:33 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36237 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727521AbfFYEFd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 00:05:33 -0400
Received: by mail-pf1-f193.google.com with SMTP id r7so8736594pfl.3;
        Mon, 24 Jun 2019 21:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YRyG2m/HTgUXvb9XPa4NKmZS68q/D8dq2TH6hCDyN6g=;
        b=MD8nMSyWkqgB9886a77oHe9Ojrkt37f+JaT0Og5afSgCAJEAzkBVNZXdmWchGl4NCa
         yP1bAIv9Rx40J9EDvwT2D+LvbN8zwdBSQfsOkLf/0tUOsO7zX+Rg6Ne4q8Ggkd5nxrTn
         A2uViA0BsQQpw5hl0COiSXM5vSMRKQeodOZB/x6Un4p/jRnbfJBNUaYdePJ8fOJWCiE6
         tOzWC4oXE+21kpAawt33vXU6s6pFWnNujwFf8UK47wxlnyttO/s6wg3HWZCxuJzZaXSp
         uf/k1lIYp6hM/mNIIPkU2dBqyu1jniXQsDGE/AxhS3KJGEJvQ7P1PxMY2Wjg9gutgHRH
         vFAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YRyG2m/HTgUXvb9XPa4NKmZS68q/D8dq2TH6hCDyN6g=;
        b=qi+nZga1AUMXBzRPqTLhBFR+kj0PEYWYyiyqW6K4zyIrTxHAAxG3WnDfRHzaJUxer6
         oHB0r3O/Y5+8nsJIaykNFmxSTrpJM2c3OxWScvbBSkSWQ6l/HIJgdU3p5gV1eJyyplPT
         HRsdvY7scYpZ6V8o9eojtAttZgqUyFhONEsecudTk+SZf1KldM6NqnVL4IzquXhs6xI7
         aolO8HVMf0OR7fWdJ75+gYUlG7zUur2kwKiIdLDz87XjRKJDbgHgoq3pYRlHzzcQOt3y
         04G+4sPwf2LT6qxwxlOo6vxTGBkqMWWkh+Uqn2EJuwjkbQ23pybN9OgSo77pr1mluVv5
         2Zbw==
X-Gm-Message-State: APjAAAX3sQaOsx7lfawnp3lxBEX8kYeHksqBbjXLg/sGcPGJyh5O1xGD
        xNIPONEfI9CgsIiZX57YfpA=
X-Google-Smtp-Source: APXvYqy62/xvfadVbHvWl8aZK6eiO4mnUmJVdf2xlhll5ZmBu5m7hFTBzduvDIwyiC7ECD26+EBqBQ==
X-Received: by 2002:a63:c106:: with SMTP id w6mr36891650pgf.422.1561435532450;
        Mon, 24 Jun 2019 21:05:32 -0700 (PDT)
Received: from debian.net.fpt ([58.187.168.105])
        by smtp.gmail.com with ESMTPSA id b24sm12408944pfd.98.2019.06.24.21.05.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 21:05:31 -0700 (PDT)
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
Subject: [PATCH V3 07/15] ARM: ks8695: cleanup cppcheck shifting error
Date:   Tue, 25 Jun 2019 11:03:48 +0700
Message-Id: <20190625040356.27473-8-tranmanphong@gmail.com>
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
 arch/arm/mach-ks8695/regs-pci.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-ks8695/regs-pci.h b/arch/arm/mach-ks8695/regs-pci.h
index 75a9db6edbd9..7d28a83bb574 100644
--- a/arch/arm/mach-ks8695/regs-pci.h
+++ b/arch/arm/mach-ks8695/regs-pci.h
@@ -45,9 +45,9 @@
 
 
 
-#define CFRV_GUEST		(1 << 23)
+#define CFRV_GUEST		BIT(23)
 
 #define PBCA_TYPE1		(1)
-#define PBCA_ENABLE		(1 << 31)
+#define PBCA_ENABLE		BIT(31)
 
 
-- 
2.11.0


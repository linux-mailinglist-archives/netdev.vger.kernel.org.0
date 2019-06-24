Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 437ED50CAA
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 15:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731431AbfFXNxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 09:53:22 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42481 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725562AbfFXNxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 09:53:22 -0400
Received: by mail-pg1-f194.google.com with SMTP id k13so992147pgq.9;
        Mon, 24 Jun 2019 06:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=raVJBU8207gShtfTdRs3l2KLAdt9jZCcffD+8sYG0VY=;
        b=BVqge9OLq9qeD3V89m4OuzGgzrApYQwkzBwjUwqBkXmckYKU91Udvn4HutN82b3Iqb
         PN/90m3BdK0exj4X5zbuE+RMRjCVaFyVxdfragmJw42wYQa7QTUSbHkpA1j6kr4uTmRo
         JlHi3/Gnw5OEQv8D2eacwKA5HTXXcNXqc6fpLhG/3teokPmlz+8seeiy1XcYtd1+LPwk
         lFRO/2r/e6hpi6Pr7OaAIRYYrJsbGQ2t20fM8yxPxwTXK62sKVUb52z6THE5CqaPdWXc
         9eMTEzjLJXapMauYf3fsDJIJRJr1GaTuX+ElGMAa3c8tEXc7qg2b3AnkynJL9mDk3w+a
         ssuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=raVJBU8207gShtfTdRs3l2KLAdt9jZCcffD+8sYG0VY=;
        b=nVyRFIseiG/U4MDP0efYnRo62PqmqgXKPXYNR8L8Q0oAO7yZr3X95sjAaO0yfFH+BN
         stHml2UsDQIm/VRUCOWYDFkSnj/cY1O9cfbwL5g9PsX3bUjKxgnfl88bsgCjoi/Opgxi
         srU9BrIcCvJFojHfgXHf3aFfYsd4Zedli3PwEKVcDk3Drv3xeqZiRIrQis2QodArjpZy
         qJSosOB8JtEccvndfoQFTKCCf173kE/sW7gQyiBbRcF7HOf93q1Qfh6uONqLXXtde1z2
         Ap/oFF5EQIDXRReXxN8Qmtf+IK93XsqoA21+lyMWMiBT5r100oLddRjc4FPRXr+TWkeP
         oYsw==
X-Gm-Message-State: APjAAAXx8cMXS1xGkLWONQG1pE3VbQ1Wii5PiepWZMmpdADvKlEfEUWY
        gamKzh7gBzpBJOR3WYTke0g=
X-Google-Smtp-Source: APXvYqwqoVy4ekR/8QXl5JienzO8OFO2RD6jNmakDvHPO2EmFeMJlxW+hDvaaNnQNde1P+cYR3ddiw==
X-Received: by 2002:a63:360d:: with SMTP id d13mr33093291pga.80.1561384401174;
        Mon, 24 Jun 2019 06:53:21 -0700 (PDT)
Received: from debian.net.fpt ([58.187.168.105])
        by smtp.gmail.com with ESMTPSA id 85sm11187901pgb.52.2019.06.24.06.53.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 06:53:20 -0700 (PDT)
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
Subject: [PATCH V2 11/15] ARM: pxa: cleanup cppcheck shifting errors
Date:   Mon, 24 Jun 2019 20:51:01 +0700
Message-Id: <20190624135105.15579-12-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190624135105.15579-1-tranmanphong@gmail.com>
References: <20190623151313.970-1-tranmanphong@gmail.com>
 <20190624135105.15579-1-tranmanphong@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[arch/arm/mach-pxa/irq.c:117]: (error) Shifting signed 32-bit value by
31 bits is undefined behaviour
[arch/arm/mach-pxa/irq.c:131]: (error) Shifting signed 32-bit value by
31 bits is undefined behaviour

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
---
 arch/arm/mach-pxa/irq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-pxa/irq.c b/arch/arm/mach-pxa/irq.c
index 74efc3ab595f..cbbb5cfecb60 100644
--- a/arch/arm/mach-pxa/irq.c
+++ b/arch/arm/mach-pxa/irq.c
@@ -35,9 +35,9 @@
 #define IPR(i)			(((i) < 32) ? (0x01c + ((i) << 2)) :		\
 				((i) < 64) ? (0x0b0 + (((i) - 32) << 2)) :	\
 				      (0x144 + (((i) - 64) << 2)))
-#define ICHP_VAL_IRQ		(1 << 31)
+#define ICHP_VAL_IRQ		BIT(31)
 #define ICHP_IRQ(i)		(((i) >> 16) & 0x7fff)
-#define IPR_VALID		(1 << 31)
+#define IPR_VALID		BIT(31)
 
 #define MAX_INTERNAL_IRQS	128
 
-- 
2.11.0


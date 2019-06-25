Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6E5521B7
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 06:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728431AbfFYEGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 00:06:16 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35123 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbfFYEGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 00:06:16 -0400
Received: by mail-pg1-f193.google.com with SMTP id s27so8244727pgl.2;
        Mon, 24 Jun 2019 21:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=goeM92i1Az854qebwEYGpO+VPnAwIplO3LHWjlZyCPE=;
        b=PNBTVDHwxTggd7WlWW0fjIC6NjsivutmfL8hHRk9KBOMW4LWYgIthawZKe+LGiasEI
         G6PC5QLbjU1YGzpY5y7I3c5ChnNNxPIP0SXX+6xVH4XXTcWdiw4nxmhOqXyvgpxFrSCJ
         Pumu7yQAg04FYXYwlB+hxSXtWpnr62OO2jQACK6/pL1Z0cS9LthgI0wj1GV+O83cAYn0
         XqaxkxnsODcUuiCI3DzaImRv3lTmwenvEZ7DcliGviyWj3+n1xc3AmfaP9irWeBw/QXV
         2Fn1OYNHAolqRRh3VR6KZMDAcwbceTO0sNAYnAbVB6unEgDZ/kuVgWAiKh4AfMs6yw+U
         K/kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=goeM92i1Az854qebwEYGpO+VPnAwIplO3LHWjlZyCPE=;
        b=sv9Ngh7JIb4cdcwYFBbsXBCpngnjImhZYPJtZuQsg+wXr+9NvYvBQoui2olFdf21r/
         7vcf76gEg4y/PW5BS+4Xz81ARyCPsIG4GrHI1w+xEXPqEi/Dq8rmBDzPCfsS7G+abJ2n
         JU3e+hmGhOGYWYPpU3CvEgInTDfgslJXsSxp/ZzCqYmgHUIwuqjfmRdpx9hFG9iIeCmL
         /XeKNwoUCLwtlVSvER0wAd6IAPjFS4OaGmwCE/SvDiu4me3AaWfUd8V+YSp0bvdVktLN
         rjQIPxsDiiBgp4z3j/mlCu+0i+NeQbAybfXPtlNJVH8iCfHVLDHv1QIk2steZJBIIQ2k
         QsMA==
X-Gm-Message-State: APjAAAWobhl1hqRXrKbvCdYgyIxGtJZSq0GpRB6o+/TTtZrTNndDDpr8
        P+QSKUym9j4EF5E/VJMIESc=
X-Google-Smtp-Source: APXvYqzjr3cIxERQsRtrkbahOBfG6zzN5JJAW2g74Ei/K18gXbR4tAtRnx3ZAeAKjbOiYQH09SKUzg==
X-Received: by 2002:a63:7f56:: with SMTP id p22mr14017413pgn.32.1561435575395;
        Mon, 24 Jun 2019 21:06:15 -0700 (PDT)
Received: from debian.net.fpt ([58.187.168.105])
        by smtp.gmail.com with ESMTPSA id b24sm12408944pfd.98.2019.06.24.21.06.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 21:06:14 -0700 (PDT)
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
Subject: [PATCH V3 11/15] ARM: pxa: cleanup cppcheck shifting errors
Date:   Tue, 25 Jun 2019 11:03:52 +0700
Message-Id: <20190625040356.27473-12-tranmanphong@gmail.com>
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


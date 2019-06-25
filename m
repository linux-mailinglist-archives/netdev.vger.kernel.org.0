Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59A29521AC
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 06:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728278AbfFYEFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 00:05:55 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40956 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbfFYEFy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 00:05:54 -0400
Received: by mail-pf1-f194.google.com with SMTP id p184so8724609pfp.7;
        Mon, 24 Jun 2019 21:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KDwfnX7xwMMDkQMnHt3pFpXnjghwDdHkKtC4VLqB4SU=;
        b=rDQhi8bGChxtNTh0gJtFuNhA03rAKj8scYAP7zQ3uoDPLFL73c2ylvY99p16axkPaL
         kbScHvo2weEld0oKeaEF2JxNAe+ielVIRdbMoa+XVd6KR3XbetkuDPI6BO7nEVSVi1fK
         Hto0YznWmSl3cRt0lQg47xEmErd7f8tDXwQf4gLRkYHrQx9ZWNisKDPYSmr9sae3W34+
         lC9yTM8o3eXYvfIG8mvFNWcYDVw9JOQVK8mQP8h+Nr1M2vN+LFgSV0ie1K9dPWXQmqEH
         FLl5xEktRDb4+x+l3CkIYsi6YLJkwdAJRwWmlSMDXlKEidhZZxF6y9Lvl+6EWWkR+I77
         oDXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KDwfnX7xwMMDkQMnHt3pFpXnjghwDdHkKtC4VLqB4SU=;
        b=AYvagOEriaVTQSZbntBp13zQbhM0Kxkkrg1sbqMauvvZwqfWQPr0WB3mdrgbvJrbKe
         yL+ohubEzfEh44rF1cu1twnB4ucCo4n7tOkp45j9gc2XokWT80hHdjxNXIXWvNwdVXEd
         jZ/jPgx6XkKcmT02HPdFNgJXuUP2CYtO4tUlQNneO4FFJZUEr30MrPrt+TMGYQ4zXXJ0
         H2272Zv4qjN3u6wqdmvip5Nh1eb4vtuGoC9eAyQRMk/L6jrBIt10Agv4sXlyhpGZ2IbT
         eCsx8+3XWam72TAzrxoPqmgEv5ypvDlC6lLW9KTINe4wEunHant70t7iCEvenOsSCuHi
         rfXQ==
X-Gm-Message-State: APjAAAV6ae8KKZJuZNYxEi26boc1QCnE0rb+5QU92EkAl3bA5vTG0ZCf
        +9daAJET0qLNi7AqUBux5HY=
X-Google-Smtp-Source: APXvYqwIvSMIpqVD3ElwkpvCRmsXFTRnj87S4mkbg/jIQCkNu8APQo0Y4URhYDaPYz89wZaHPKLEnQ==
X-Received: by 2002:a63:d53:: with SMTP id 19mr1887507pgn.453.1561435553986;
        Mon, 24 Jun 2019 21:05:53 -0700 (PDT)
Received: from debian.net.fpt ([58.187.168.105])
        by smtp.gmail.com with ESMTPSA id b24sm12408944pfd.98.2019.06.24.21.05.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 21:05:53 -0700 (PDT)
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
Subject: [PATCH V3 09/15] ARM: omap2: cleanup cppcheck shifting error
Date:   Tue, 25 Jun 2019 11:03:50 +0700
Message-Id: <20190625040356.27473-10-tranmanphong@gmail.com>
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
 arch/arm/mach-omap2/powerdomain.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/powerdomain.c b/arch/arm/mach-omap2/powerdomain.c
index 1cbac76136d4..886961726380 100644
--- a/arch/arm/mach-omap2/powerdomain.c
+++ b/arch/arm/mach-omap2/powerdomain.c
@@ -35,7 +35,7 @@
 #include "soc.h"
 #include "pm.h"
 
-#define PWRDM_TRACE_STATES_FLAG	(1<<31)
+#define PWRDM_TRACE_STATES_FLAG	BIT(31)
 
 void pwrdms_save_context(void);
 void pwrdms_restore_context(void);
-- 
2.11.0


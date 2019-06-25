Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4832E5217F
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 06:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727651AbfFYEE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 00:04:28 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42769 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727540AbfFYEE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 00:04:27 -0400
Received: by mail-pg1-f193.google.com with SMTP id k13so2057971pgq.9;
        Mon, 24 Jun 2019 21:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=g9gX3zxll6zE+1uSeRtgAyQGhpa5fKumdosEKJfzBW0=;
        b=p+bcQPG1DVyB7xMBrPkvvc0Ox5Iz9EBMpyV0raFeoKQmP6LJ0QzMVHaAG0yS8+BLqq
         j6wQjW15M4RY2XkDn07BTZ15lUq4QJuhdY1LF8aZSFj0nao/xFNLqAL7vAA9EDYFysI2
         jLMDupU8+Ap51UUyJSIQ/x00FJJ74rWTB5Oa6Db9anDfbGbl1dZ3CatqM8WAgKWxhFBX
         DdXAIZtkucpinIk+H8T1a3me8wKz5PzH4NkG5YiHcbr5ds+PbhA+NsLIed16ouZzRcHg
         WcO376mVd1S/qqWEoGnQvFVygb3NAf9CdhttjNtovc2CdIkRDR8onXzQfViYDoSyFYkj
         05dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=g9gX3zxll6zE+1uSeRtgAyQGhpa5fKumdosEKJfzBW0=;
        b=RLV1jo2V9xecEi6/+yz4OUCUYGjXxXf+Gg4cTJgwjnL/wtpSAZ6PRCqEs7iB7u79SV
         ypp8UBjxrtlRozYCyAypwUVrlywkCzfHYDfVKpru/MlBzxxNs1UMdq4wXxRjyN2joJTt
         Lc6LQhZ8uIGIn1XlZ725XyxPQvlg2ruW+lDDT69OqCAwHaXc0bgQG/93UEy70Hn++KZB
         z7UEZr8t0CKFaEUhHc9CK9sYNV7N0chmXsp4HbpT4kOjzd9fQkekWtSz9hihsq9rzgci
         wKDjxfI2NxHx053aNvzvLnyZHqpisFK2coycpy9BsLtRAck0CzQB7mIyejDw1LZnY1DR
         mTLQ==
X-Gm-Message-State: APjAAAXaRg69ROyGANamwt/gB2cmKca8UgKfck8EeicxQzRxzMPX/hbh
        kdDlMV2vSGxHMqyXDo3Va5Q=
X-Google-Smtp-Source: APXvYqyNN77OOXop+gEg4sOeYGo8mqh8bsP9mbQeXWgn4HKyTdkIWs0BlsqL+j9klhaVMVDd5jkLgw==
X-Received: by 2002:a63:c006:: with SMTP id h6mr35712535pgg.285.1561435466679;
        Mon, 24 Jun 2019 21:04:26 -0700 (PDT)
Received: from debian.net.fpt ([58.187.168.105])
        by smtp.gmail.com with ESMTPSA id b24sm12408944pfd.98.2019.06.24.21.04.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 21:04:25 -0700 (PDT)
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
Subject: [PATCH V3 01/15] arm: perf: cleanup cppcheck shifting error
Date:   Tue, 25 Jun 2019 11:03:42 +0700
Message-Id: <20190625040356.27473-2-tranmanphong@gmail.com>
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


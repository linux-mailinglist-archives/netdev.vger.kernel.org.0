Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9B60521C4
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 06:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728620AbfFYEGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 00:06:49 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:40170 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbfFYEGs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 00:06:48 -0400
Received: by mail-pl1-f196.google.com with SMTP id a93so8093806pla.7;
        Mon, 24 Jun 2019 21:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5JwRNim3rOSWEmaOkWCuYyX/NF5I/OM/lvjIjZv9TgA=;
        b=gt4q1QhMb1DH/lpvQ7aBuGothKXXSjA1h2R+DXuEwbbwhT+4GGxBNuQiJrNG3g6wlc
         2sOM2sn6kNuDk65YciXdt6FXp9a8zFL91wUsRfPuALOsMq5ulGBgpq5zZ9rYyKFro2ti
         rkTC2gbwRznm72eBguYZkoLCBhvA7e6ovlEl+KbusRkQdgP8TESDeUnTi1AG9FtaMqhc
         vpqCQTGnQzukvTtXyn+hJmc6vqUMhESkcLhktKd6SkjsGlKG7T0inoRkqtUyi/xb6dKR
         lroymLNRVneRrp1OsqI/ooFoV9QAlBsqdsVLMEHsO9Ks9gYXFYWNK8hRHmc9QWbFSosv
         b4gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5JwRNim3rOSWEmaOkWCuYyX/NF5I/OM/lvjIjZv9TgA=;
        b=q8Fzg05AWD+2uxbovrEoIkbiocs+elKHz5+KzarfQz+qWkSijuambbdkGewgAtl79N
         lEWO79yC/TCV99FPN9T9Aoaw5zes4oKVMvhCJndiiausbd3kf2r6HZWFCHwCzQ+fgcmJ
         wDyxBG2bATyOu0lIViHHPNNkBzk3tHtAdvkh/JbjsOGmSoKnv14rGTIy1i/CxX9Bn+2J
         VmWpjj2xICkWEE6yYC8ZMqILkxf5oAtBtEGRBeQQIBXIULSHyTPTmie/T7R4U2HC6pr0
         xe7KT9zdab/hXsO9xsnpyP5sVli56pYmS+prol8d0NOyn0UrPfyc0vxzqcOhd5awolnT
         8jeg==
X-Gm-Message-State: APjAAAXqCLMoJTdgltQVUct0LSFM1HYGTN+UFrme4yZllgmPfn5Ceaxk
        26RCvalYSrhGMhdKHvZudoI=
X-Google-Smtp-Source: APXvYqxe+YkEEX8coxMf/ZLBIurRDaBiUt3OmZVW/IvWX4kLCOfOcSFunco4dZa4p7+f354X1KstdQ==
X-Received: by 2002:a17:902:1e6:: with SMTP id b93mr108038324plb.295.1561435607482;
        Mon, 24 Jun 2019 21:06:47 -0700 (PDT)
Received: from debian.net.fpt ([58.187.168.105])
        by smtp.gmail.com with ESMTPSA id b24sm12408944pfd.98.2019.06.24.21.06.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 21:06:46 -0700 (PDT)
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
Subject: [PATCH V3 14/15] ARM: bpf: cleanup cppcheck shifting error
Date:   Tue, 25 Jun 2019 11:03:55 +0700
Message-Id: <20190625040356.27473-15-tranmanphong@gmail.com>
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
 arch/arm/net/bpf_jit_32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/net/bpf_jit_32.c b/arch/arm/net/bpf_jit_32.c
index adff54c312bf..8904d16a8754 100644
--- a/arch/arm/net/bpf_jit_32.c
+++ b/arch/arm/net/bpf_jit_32.c
@@ -612,7 +612,7 @@ static inline void emit_a32_mov_se_i64(const bool is64, const s8 dst[],
 				       const u32 val, struct jit_ctx *ctx) {
 	u64 val64 = val;
 
-	if (is64 && (val & (1<<31)))
+	if (is64 && (val & BIT(31)))
 		val64 |= 0xffffffff00000000ULL;
 	emit_a32_mov_i64(dst, val64, ctx);
 }
-- 
2.11.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28C0A4FC68
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 17:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbfFWPQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 11:16:32 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:32790 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbfFWPQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 11:16:31 -0400
Received: by mail-pf1-f196.google.com with SMTP id x15so6073029pfq.0;
        Sun, 23 Jun 2019 08:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=ZxzCRyv0CcL1EwsY/PU88e+Vu4wijfnzZQqmGfRcvmQ=;
        b=vgTCL0YBz+SjMkIA6M21UqkDR5Sm+MyXUpUAt2ppFbRP6h4lQkU1ALA8+1lifxZEqC
         CrHNO4PI9dNjKUmiw53MJEiUKVo4QWpH/TYezTMZGEVvV632GITn4gTxn7XWyrz9Y/Ha
         yRq07HeukfO0uzwequyJA8X/R39UE2QsHIWyY0KH8k4ElHtAZoKH0j+NJFiZHH+6O1Jl
         0b22ljuBF+fFNV4xIrj917s+IRzHbm1Hbai3C4Kp20nRBh+6vANvN0qniAx7/KVSTTVz
         n1/3ZvCv4h8Dq/Y2KI8Tq3eFpkRDadVzgekap6P7+iCBB5qWI7zHOcmQMHSL9/y8VxCi
         YFuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=ZxzCRyv0CcL1EwsY/PU88e+Vu4wijfnzZQqmGfRcvmQ=;
        b=DW/RhgUpIWaUXk1wyEEUi/2DS3dTITAEU4Qy4F2p0vCz4vXyGfHhUigMcbTxJnkCLs
         RCZavpG7a1oNL6oSs6zEgMld0vP3kSC2wMi4h227OLlWHMoUzmGnejkEyrnV7TBVAY2R
         KTx7JcwwHpl5GMcJoEkBOCSjtQkSwsK2ayxURYpBtIfRAErxUHsp8SLk00L94hweMMr0
         2ypJaDmUIOHANQS+zfo4bQQSPZHFxYofI9HG0T5vrUpEKuT2SGW/un0a2cmrhKbFS4PF
         csGHZLPwTXS7VXn6qEjtvtIG6r/bcB72MdMPEpcS+qfuBhlYGv6epN5Sl2IULczNTS48
         IPiw==
X-Gm-Message-State: APjAAAVuRPfu77A2HPbDqvLXGykb+yRw3HbGKfeYfDcHqMUuwwsb+LPV
        JlvI+LqY14cIzIge/WEBEO4=
X-Google-Smtp-Source: APXvYqwo4amEEfrtcLpVpipuvjZjsG52wTMkzw5+Un4n/rYYWv3AaPkXLqYWhMVMyCD0gqJ8amTsiw==
X-Received: by 2002:a17:90a:9b88:: with SMTP id g8mr19522545pjp.100.1561302990450;
        Sun, 23 Jun 2019 08:16:30 -0700 (PDT)
Received: from debian.net.fpt ([1.55.47.94])
        by smtp.gmail.com with ESMTPSA id p6sm8329194pgs.77.2019.06.23.08.16.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 23 Jun 2019 08:16:29 -0700 (PDT)
From:   Phong Tran <tranmanphong@gmail.com>
To:     mark.rutland@arm.com, kstewart@linuxfoundation.org,
        songliubraving@fb.com, andrew@lunn.ch, peterz@infradead.org,
        nsekhar@ti.com, ast@kernel.org, jolsa@redhat.com,
        netdev@vger.kernel.org, gerg@uclinux.org,
        lorenzo.pieralisi@arm.com, will@kernel.org,
        linux-samsung-soc@vger.kernel.org, daniel@iogearbox.net,
        tranmanphong@gmail.com, festevam@gmail.com,
        gregory.clement@bootlin.com, allison@lohutok.net,
        linux@armlinux.org.uk, krzk@kernel.org, haojian.zhuang@gmail.com,
        bgolaszewski@baylibre.com, tony@atomide.com, mingo@redhat.com,
        linux-imx@nxp.com, yhs@fb.com, sebastian.hesselbarth@gmail.com,
        illusionist.neo@gmail.com, jason@lakedaemon.net,
        liviu.dudau@arm.com, s.hauer@pengutronix.de, acme@kernel.org,
        lkundrak@v3.sk, robert.jarzmik@free.fr, dmg@turingmachine.org,
        swinslow@gmail.com, namhyung@kernel.org, tglx@linutronix.de,
        linux-omap@vger.kernel.org, alexander.sverdlin@gmail.com,
        linux-arm-kernel@lists.infradead.org, info@metux.net,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        alexander.shishkin@linux.intel.com, hsweeten@visionengravers.com,
        kgene@kernel.org, kernel@pengutronix.de, sudeep.holla@arm.com,
        bpf@vger.kernel.org, shawnguo@kernel.org, kafai@fb.com,
        daniel@zonque.org
Subject: [PATCH 14/15] ARM: bpf: cleanup cppcheck shifting error
Date:   Sun, 23 Jun 2019 22:13:12 +0700
Message-Id: <20190623151313.970-15-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190623151313.970-1-tranmanphong@gmail.com>
References: <20190623151313.970-1-tranmanphong@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[arch/arm/net/bpf_jit_32.c:618]: (error) Shifting signed 32-bit value by
31 bits is undefined behaviour

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
---
 arch/arm/net/bpf_jit_32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/net/bpf_jit_32.c b/arch/arm/net/bpf_jit_32.c
index adff54c312bf..9c3f8fb871e5 100644
--- a/arch/arm/net/bpf_jit_32.c
+++ b/arch/arm/net/bpf_jit_32.c
@@ -612,7 +612,7 @@ static inline void emit_a32_mov_se_i64(const bool is64, const s8 dst[],
 				       const u32 val, struct jit_ctx *ctx) {
 	u64 val64 = val;
 
-	if (is64 && (val & (1<<31)))
+	if (is64 && (val & (1U<<31)))
 		val64 |= 0xffffffff00000000ULL;
 	emit_a32_mov_i64(dst, val64, ctx);
 }
-- 
2.11.0


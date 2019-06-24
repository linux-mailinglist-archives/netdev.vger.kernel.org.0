Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB9A50CBB
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 15:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731667AbfFXNxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 09:53:53 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34580 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727140AbfFXNxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 09:53:53 -0400
Received: by mail-pg1-f195.google.com with SMTP id p10so7182789pgn.1;
        Mon, 24 Jun 2019 06:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=e4SvJC/VcAmADHIIGDsXsxmclHfJr0B6HPSZ3ZBfFbk=;
        b=POib6P+x3BBQ2Q8FedwzMwtSgpdrbHMypQ9Q7up1MGvXn4sGY+IU/kbo4QkJHeJbrs
         SvcuhUmYM01dB1xtm1RQt17t1P6UBMcZ9cwTqq5Nh0a6gBeGdqQfPeqVIMB51ovb5Vxk
         Bqxuzejn+ovqGykl9SqzPShYvCgGKmHsDeHYxsk0nahXB5EAep9gZ0npba0y1yiRYBTO
         u7UtCl3JC3LMTFlQmMXHQTaNMNogISoOwPSBDj0ML6jH9DmAhHLbIXhexqwHjkpN6mOR
         li+y/m8U/SKqbL5Ar6/U1CFhrJNi9TfmD8qkcGWHjUGf2iDDWuIxyJqgqccjOhj8i3Ik
         oyRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=e4SvJC/VcAmADHIIGDsXsxmclHfJr0B6HPSZ3ZBfFbk=;
        b=VKRzTGwEDLWuCdWuxSwSCUYaC9hRMM3HQF6lBzywDrxPN8kGI8+g+bPZ/TR6ZRM1gP
         xTYe7KXcUMup3WBoFVRLDiUMMRHETEyD7xjdF0/Gs1++2B/2/BYqD/HkDYKf3SzfwiyO
         pty40iJrUlKcUODij6GGspSBXcV7O8Q0Je/J2+zSlpAIL3VGonJfG2ipUTXm7evTmKSo
         dTJl2tL9qMzVb9b71vvauPaasSPqnP1CJBbwJFM+enOGjWmEWi8IGcDnIGqPq51F/2jw
         sf1eEsQiYPyWElE6Hu0gV8vB17V3IZmzLItj74xXyR8wL9ftfHDmKYOvx8jYuDCQuA0R
         uTUA==
X-Gm-Message-State: APjAAAUMT2frEEaK+A8i/mzEsCQJn/PfX+Gs1GreHksBvskjAfVpKsNA
        YxKPco8K3xPZqPCJYMp+/Nk=
X-Google-Smtp-Source: APXvYqw9auIzqVAIEihwdK6Pu50000lruya5S38Moea4IfQqfHfx0hok9D7NHSMXFDkoFojk+pQgmA==
X-Received: by 2002:a63:6a47:: with SMTP id f68mr32508154pgc.230.1561384432470;
        Mon, 24 Jun 2019 06:53:52 -0700 (PDT)
Received: from debian.net.fpt ([58.187.168.105])
        by smtp.gmail.com with ESMTPSA id 85sm11187901pgb.52.2019.06.24.06.53.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 06:53:51 -0700 (PDT)
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
Subject: [PATCH V2 14/15] ARM: bpf: cleanup cppcheck shifting error
Date:   Mon, 24 Jun 2019 20:51:04 +0700
Message-Id: <20190624135105.15579-15-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190624135105.15579-1-tranmanphong@gmail.com>
References: <20190623151313.970-1-tranmanphong@gmail.com>
 <20190624135105.15579-1-tranmanphong@gmail.com>
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
index adff54c312bf..4e8ad26305ca 100644
--- a/arch/arm/net/bpf_jit_32.c
+++ b/arch/arm/net/bpf_jit_32.c
@@ -612,7 +612,7 @@ static inline void emit_a32_mov_se_i64(const bool is64, const s8 dst[],
 				       const u32 val, struct jit_ctx *ctx) {
 	u64 val64 = val;
 
-	if (is64 && (val & (1<<31)))
+	if (is64 && (val & (BIT(31))))
 		val64 |= 0xffffffff00000000ULL;
 	emit_a32_mov_i64(dst, val64, ctx);
 }
-- 
2.11.0


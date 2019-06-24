Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D684950C94
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 15:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731544AbfFXNwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 09:52:41 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42412 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728789AbfFXNwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 09:52:40 -0400
Received: by mail-pg1-f196.google.com with SMTP id k13so990999pgq.9;
        Mon, 24 Jun 2019 06:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6Rl1Rw52Am1I8m2WryMsusM3MGfrM8Bk30uCJ+05MEU=;
        b=ADhfwRf6R9ObgqU4OrDi6gyPC9FQsexdSIR7mdd2foTq4NqZfpBHm5MbIwXc9r1Lov
         BUT9b+YbAeGm0dRjzQZIXSd120rnkhk7gvQeJrurE7Q7vA3J2gSEztsKSBYyJxKuRpcK
         6YQPKqLPzGLC/KtBIyK4+rS4CRTt3vkI2Rr4+xX0lBSop0KyViBCJGCM3LvSUig3CvYg
         GP1cov+BB67FIM+dhcQCLDT51WzrtXYq58YuJM5h7Xs0LIwKZiriV9QYkpgh2Jcld2Se
         OrtJ37eS2eS+hOLIDaYr4k6Cjes1pJp+zbUxU1PkAfagLYTsMnuFckULBo4q1KfyyNzF
         KLfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6Rl1Rw52Am1I8m2WryMsusM3MGfrM8Bk30uCJ+05MEU=;
        b=ZZxuX+UN8MASv2dFIkfDW2Eu70QeiHndl0pJ3DM7zN8wYeLxTTt5ArU6hpjGGx5T+W
         trJdUbKq82m3KZEFY/1UhNXX2PAfnF3uwLyIl7CdgHo61Mz8Xt/aC9ffCU5GbXCJA29Z
         /PSjxo4Lrabnp66o8FbB89vpatj0tDeDRM2ChKteWv2eXPK3CyGkkWydmMX5aiJRTkdA
         7HviGdp36vaN5XThgnoGvm74fBRQktmvj+r/tz6+wwFfu5Kn/mShYzehrW/1D6XhJhXC
         Ju3du1C9vl3ODqGAHSVR5rkSBVTXjsgHHnflpZUZJOPGjuqyW+/Uby5Tb2ilvw9x2Zpf
         lyag==
X-Gm-Message-State: APjAAAVuLVDlLNhNxRus43MxKcqbvDojYn9RJ4wb9sq6cxqk67KHrFTh
        HHqsZnHZMLZx6Z6cv3B1Agk=
X-Google-Smtp-Source: APXvYqyPdTV36HEtdPywV22V9ONssruwsFKv2jKTKnbWlYFq50JNtS0DZMajyK+tRfW8ZehydJzkHg==
X-Received: by 2002:a63:ec13:: with SMTP id j19mr13305911pgh.174.1561384359719;
        Mon, 24 Jun 2019 06:52:39 -0700 (PDT)
Received: from debian.net.fpt ([58.187.168.105])
        by smtp.gmail.com with ESMTPSA id 85sm11187901pgb.52.2019.06.24.06.52.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 06:52:39 -0700 (PDT)
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
Subject: [PATCH V2 07/15] ARM: ks8695: cleanup cppcheck shifting error
Date:   Mon, 24 Jun 2019 20:50:57 +0700
Message-Id: <20190624135105.15579-8-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190624135105.15579-1-tranmanphong@gmail.com>
References: <20190623151313.970-1-tranmanphong@gmail.com>
 <20190624135105.15579-1-tranmanphong@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[arch/arm/mach-ks8695/pci.c:33]: (error) Shifting signed 32-bit value by
31 bits is undefined behaviour

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


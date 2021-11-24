Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64FDC45B2D3
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 04:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240905AbhKXDxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 22:53:37 -0500
Received: from mail.loongson.cn ([114.242.206.163]:58092 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240893AbhKXDxf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 22:53:35 -0500
Received: from localhost.localdomain (unknown [111.9.175.10])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9DxeNJ3tp1hx9oAAA--.1299S6;
        Wed, 24 Nov 2021 11:50:24 +0800 (CST)
From:   Huang Pei <huangpei@loongson.cn>
To:     netdev@vger.kernel.org, ambrosehua@gmail.com
Cc:     linux-arch@vger.kernel.org
Subject: [PATCH 4/4] MIPS: loongson64: fix FTLB configuration
Date:   Wed, 24 Nov 2021 11:50:04 +0800
Message-Id: <20211124035004.7871-5-huangpei@loongson.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211124035004.7871-1-huangpei@loongson.cn>
References: <20211124035004.7871-1-huangpei@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf9DxeNJ3tp1hx9oAAA--.1299S6
X-Coremail-Antispam: 1UD129KBjvJXoW7Gry8WFyDJF1UCrW8Kw4Durg_yoW8Jr17pr
        1qya17Kr4UAFy2yayDJFZ5Wry3ZFyDWFZxWFW29rWYv3ZxZr1UXF97Xa13JrsrZryI93Wr
        Wa9agFW5KFs7Cr7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUBab7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI
        8067AKxVWUAVCq3wA2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28C
        jxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI
        8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E
        87Iv6xkF7I0E14v26F4UJVW0owAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0V
        AKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1l
        Ox8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkIecxEwVAFwVW8GwCF04k20x
        vY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I
        3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jrv_JF1lIxkGc2Ij64vIr41lIx
        AIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAI
        cVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2js
        IEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07b43ktUUUUU=
X-CM-SenderInfo: xkxd0whshlqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit "da1bd29742b1" ("MIPS: Loongson64: Probe CPU features via
CPUCFG") makes 'set_ftlb_enable' called under c->cputype unset,
which leaves FTLB disabled on BOTH 3A2000 and 3A3000

Fixes: da1bd29742b1 ("MIPS: Loongson64: Probe CPU features via CPUCFG")
Signed-off-by: Huang Pei <huangpei@loongson.cn>
---
 arch/mips/kernel/cpu-probe.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
index ac0e2cfc6d57..24a529c6c4be 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -1734,8 +1734,6 @@ static inline void decode_cpucfg(struct cpuinfo_mips *c)
 
 static inline void cpu_probe_loongson(struct cpuinfo_mips *c, unsigned int cpu)
 {
-	decode_configs(c);
-
 	/* All Loongson processors covered here define ExcCode 16 as GSExc. */
 	c->options |= MIPS_CPU_GSEXCEX;
 
@@ -1796,6 +1794,8 @@ static inline void cpu_probe_loongson(struct cpuinfo_mips *c, unsigned int cpu)
 		panic("Unknown Loongson Processor ID!");
 		break;
 	}
+
+	decode_configs(c);
 }
 #else
 static inline void cpu_probe_loongson(struct cpuinfo_mips *c, unsigned int cpu) { }
-- 
2.20.1


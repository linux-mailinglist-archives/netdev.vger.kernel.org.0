Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7DD6AC78A
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 17:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbjCFQTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 11:19:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbjCFQSb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 11:18:31 -0500
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403E331E26;
        Mon,  6 Mar 2023 08:15:44 -0800 (PST)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-536cb25982eso192429647b3.13;
        Mon, 06 Mar 2023 08:15:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678119264;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eWkkRYesFCW1vKhYnmJIj+4iqGRi3O7KEL7awX6yNM8=;
        b=pmjrtiY7gp20NCr+vKnn4yGu04mC3tZN9zzamVSVVrmNoZg79k94s5yiqQxqiDCLs8
         sgEtKrOsdGrbZ+j6+N8SpebLVmMluBNm4Xmiyw1tSsjtZuMqUAqoECEoIpVAlmJBQrvg
         1R7oOfN3oPqlD1fI3NyPKKaHKbcCyWscdWUGc/hCdpi1kn3QxQC9P2FqHVrdI4bOpUQo
         FpM0nBmgGQDB5VWTozNa/GJN6rsM6iC1phCrzxb6vIBy7ZqvmLkv6w3AWdBmeScS/yLk
         d1p1Ls2w4kt7vL1nYaynzaEGd5IifDxEWKJPPut1GRZYHsyXLsC2WoaoH2j0qPnOXbOV
         EpPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678119264;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eWkkRYesFCW1vKhYnmJIj+4iqGRi3O7KEL7awX6yNM8=;
        b=A7wuKV8/AdN/+c8CbSSBKGR1Ldz3vaV3FQM2dHXx3BHI1RVEn4FJz/u2pixX2kcr30
         v8FY7ZQEsd4sFQGtzXI25clOgRvs37x0s2iisUo861/I0YS88ACZrkxzL9a4jLvLajRd
         G9AoBA16+UlO+L0w+cAQ44niSr5vsjNX+DerXRWj8oJeWPtgimEBCqdGsl7RtQYBbT6m
         uqObyRq8zqxH5v1MJuUlAWYrLQutovlV06sD1TkIHW+TsOf2aZMs2ZRNrd2JyPqld+JF
         h1G7FvqmpND/gIrgaqSCmQeAvOsIRh+rS7mCjzbcK5cpNH8gMuySCwZJMDiwkUxH37Mp
         eWZw==
X-Gm-Message-State: AO0yUKW+Tbxvi8lnnnYEl96h0Cz8Edg0CeEudlVml1NPgK2sJpdO/Rer
        +Z5runJjfZ0JrBqcTelbddjAV+NfHGYTf3dq
X-Google-Smtp-Source: AK7set/jXyku28q+ivaz+ryE2alL97ENe0rhsGlfLmALivyk2C0qphcGmohIX43LtAVrDFFmgh+SZA==
X-Received: by 2002:a62:1dd0:0:b0:590:7616:41eb with SMTP id d199-20020a621dd0000000b00590761641ebmr10105161pfd.30.1678118832374;
        Mon, 06 Mar 2023 08:07:12 -0800 (PST)
Received: from vernon-pc.. ([49.67.2.142])
        by smtp.gmail.com with ESMTPSA id u6-20020aa78386000000b005d35695a66csm6465318pfm.137.2023.03.06.08.07.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 08:07:12 -0800 (PST)
From:   Vernon Yang <vernon2gm@gmail.com>
To:     torvalds@linux-foundation.org, tytso@mit.edu, Jason@zx2c4.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        yury.norov@gmail.com, andriy.shevchenko@linux.intel.com,
        linux@rasmusvillemoes.dk, james.smart@broadcom.com,
        dick.kennedy@broadcom.com
Cc:     linux-kernel@vger.kernel.org, wireguard@lists.zx2c4.com,
        netdev@vger.kernel.org, linux-scsi@vger.kernel.org,
        Vernon Yang <vernon2gm@gmail.com>
Subject: [PATCH 2/5] wireguard: fix wg_cpumask_choose_online() if no further cpus set
Date:   Tue,  7 Mar 2023 00:06:48 +0800
Message-Id: <20230306160651.2016767-3-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230306160651.2016767-1-vernon2gm@gmail.com>
References: <20230306160651.2016767-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit 596ff4a09b89 ("cpumask: re-introduce constant-sized cpumask
optimizations"), when NR_CPUS <= BITS_PER_LONG, small_cpumask_bits used
a macro instead of variable-sized for efficient.

If no further cpus set, the cpumask_next() returns small_cpumask_bits,
it must greater than or equal to nr_cpumask_bits, so fix it to correctly.

Signed-off-by: Vernon Yang <vernon2gm@gmail.com>
---
 drivers/net/wireguard/queueing.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireguard/queueing.h b/drivers/net/wireguard/queueing.h
index 583adb37ee1e..41adeac3ee0b 100644
--- a/drivers/net/wireguard/queueing.h
+++ b/drivers/net/wireguard/queueing.h
@@ -106,7 +106,7 @@ static inline int wg_cpumask_choose_online(int *stored_cpu, unsigned int id)
 {
 	unsigned int cpu = *stored_cpu, cpu_index, i;
 
-	if (unlikely(cpu == nr_cpumask_bits ||
+	if (unlikely(cpu >= nr_cpumask_bits ||
 		     !cpumask_test_cpu(cpu, cpu_online_mask))) {
 		cpu_index = id % cpumask_weight(cpu_online_mask);
 		cpu = cpumask_first(cpu_online_mask);
-- 
2.34.1


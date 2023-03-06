Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F09A76ACFBC
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 22:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbjCFVDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 16:03:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjCFVDo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 16:03:44 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3834E37579;
        Mon,  6 Mar 2023 13:03:43 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id n5so6736686pfv.11;
        Mon, 06 Mar 2023 13:03:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678136622;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ohhBlm5/EvdaRANIY+/17hlHt7n4eAlMQRKCzUzJefs=;
        b=jddwh84zwUpSQuatvj4c7Dpgl/B68lIc/yasenGO6pdLPdPi5mYHxG8eXh62Yz++wr
         64vwB8kutOmKeAyu9i2kM3ICs828b7TCLH1GK0jUbMwkeQbvl0Ii8ptdMYZhXHMuzIPL
         V+3uMHRGAOPTgIkB94ykDqXF8VeLLXqH/ZMXQi8Ve4saIO0PImMGq3bxlmzsZFS15pQG
         NoIWQlxj3IqaCV7yHbxIrQ0fa/vPWBV4XKjFE5PjiYzL8MaaZyakd/MKhl/WaZ1C7mch
         4IobHwykjv/5tIFUOenW8tcEBFDD+ZAL/zwr9gNMnLbPmDRDzCnw+cfg89CxNO266///
         ye2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678136622;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ohhBlm5/EvdaRANIY+/17hlHt7n4eAlMQRKCzUzJefs=;
        b=5xJOZXxGTqRNiTItWUbWSyA+Rg+ivxenKGFFToOnYeije+/pRjR1jCtopC7w08g8WW
         fJpnms4CNnI9NWfobQFwrtC7z/vJ7MjxZhNOcT2tsNF8gGDOk4gpkbCTOujE3qZ+1jl3
         FLmDR80YljX8nkyrxf4mp/H6aL74sJbTW4lua6usu6e54hb1lCkIoel8hblhMuW3mUFA
         Y3hSV+oUjUII/mrI43t/5YKZTiVHsXEIYotgiUI95+IJaZBHeaTrGH7fr4lV1R4l+fLs
         wwBwopvLDRMgb0nJebp3x0xiNmS7WCDU45xIwst2JOM8oDLj28vWFGA/Kn5WriDUITJ9
         Hpkw==
X-Gm-Message-State: AO0yUKWv8toMaT8r+Lb/SNSE0Ml5Ry1nui/vVdEr2/ItZfOiCHxd84Vf
        HCUgtdZnHQGvQtdZBNxGwBU=
X-Google-Smtp-Source: AK7set9C+GX1uA5tZkGP2zTQMIs94EYIBwyVaiOu7iZSR8QoXhcin7YC0GzM7XQYnpJ1bW1BZLgToQ==
X-Received: by 2002:a62:5105:0:b0:593:ed9c:9f07 with SMTP id f5-20020a625105000000b00593ed9c9f07mr11960629pfb.27.1678136622631;
        Mon, 06 Mar 2023 13:03:42 -0800 (PST)
Received: from vernon-pc.. ([49.67.2.142])
        by smtp.gmail.com with ESMTPSA id 3-20020aa79143000000b005810c4286d6sm6706760pfi.0.2023.03.06.13.03.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 13:03:42 -0800 (PST)
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
Subject: [PATCH v2 1/4] random: fix try_to_generate_entropy() if no further cpus set
Date:   Tue,  7 Mar 2023 05:03:09 +0800
Message-Id: <20230306210312.2614988-2-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230306210312.2614988-1-vernon2gm@gmail.com>
References: <20230306210312.2614988-1-vernon2gm@gmail.com>
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

When cpumask_next() the return value is greater than or equal to
nr_cpu_ids, it indicates invalid.

Before commit 596ff4a09b89 ("cpumask: re-introduce constant-sized cpumask
optimizations"), when cpumask_next() returned an invalid cpu, the driver
used the judgment equal to nr_cpu_ids to indicate the invalid cpu, so it
happened to work normally, but this is the wrong approach.

After commit 596ff4a09b89 ("cpumask: re-introduce constant-sized cpumask
optimizations"), these incorrect practices actively buggy, so fix it to
correctly.

Signed-off-by: Vernon Yang <vernon2gm@gmail.com>
---
 drivers/char/random.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index ce3ccd172cc8..253f2ddb8913 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1311,7 +1311,7 @@ static void __cold try_to_generate_entropy(void)
 			/* Basic CPU round-robin, which avoids the current CPU. */
 			do {
 				cpu = cpumask_next(cpu, &timer_cpus);
-				if (cpu == nr_cpumask_bits)
+				if (cpu >= nr_cpu_ids)
 					cpu = cpumask_first(&timer_cpus);
 			} while (cpu == smp_processor_id() && num_cpus > 1);
 
-- 
2.34.1


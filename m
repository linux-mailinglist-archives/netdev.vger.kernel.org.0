Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1773F6ACF6F
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 21:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbjCFUr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 15:47:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjCFUrx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 15:47:53 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E9E7201B;
        Mon,  6 Mar 2023 12:47:52 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id c4so6757374pfl.0;
        Mon, 06 Mar 2023 12:47:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678135672;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ohhBlm5/EvdaRANIY+/17hlHt7n4eAlMQRKCzUzJefs=;
        b=P9VGVXIw6J51iOQeGUMdlchyu9nMT+CJXhCGQt5j0A3EMcsN9uwA+ikRPkdjw/loKH
         32Mgu+nPV0wqlP8lBPfETTy9cIvJXNdzA/PRaRLJ9cOuURQpNM3tnNfbMRnh0CQpnzwX
         Twu30sMOpTzjtgBep+klHkWeG1VgaBxPxapwBJt57r/FE9G1mjZbX2cMfgoD+LCn8PGz
         DsUVAC9dZggw9ZhlOygRzfLR1C0/dxVRb+NyH9gzP9jg5+Bt2z/SdLk7bnVvXWOWfjow
         vDs6MxWlMkw3lCOqt4AJKJsHwlfHCoBydyRPwn9tzGk7j5tVgjG8Jkec0aarUwYqhMMv
         XITg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678135672;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ohhBlm5/EvdaRANIY+/17hlHt7n4eAlMQRKCzUzJefs=;
        b=Vhov+hPpFIN+VRnZ1cH9eFITRx6Y+9YuXHe1i4i1JQ3Hmfs91YSTKJckKykOH4EdCE
         mgpwf8Y3QCR3n9IWSlVqCKyBp+ZZKPFN32fXx2YQZKwUYuUKkmCv1fi29xW4yYZ9Zjll
         ltfBghdVPpSS5z0gYHUgbt+SOeeYzbDPfSDYOzG1dRvUCrMbLG2K1uJMmIS8y9iHJDJP
         r+pVXtruomI/38Mk4YoLwSePoHjbS4Yfl/UPyTn213gt5AFxLxBl8g7YJCHdknaDYht4
         b047d8J8EnAOkMOFVrEo2yiaXBQJev73dFeRziduF0aV2MMqiie2EwMwI0VuEvCGbK+8
         0/IA==
X-Gm-Message-State: AO0yUKXtYINKfa3fR+fKdcS8dVphKLNrat/nzRD+U9dsRQOjCrEQo13N
        tRH8r8LM42p3cMrkgGpuTIE=
X-Google-Smtp-Source: AK7set9iSDUiwRSSU+iAktisKbnMBWUM4GX842oxXYu7f5iOPfLRWS9DR+Fg3gD6eN2AelR9p6vmtA==
X-Received: by 2002:a62:3814:0:b0:5a9:c533:3c06 with SMTP id f20-20020a623814000000b005a9c5333c06mr9912111pfa.14.1678135672104;
        Mon, 06 Mar 2023 12:47:52 -0800 (PST)
Received: from vernon-pc.. ([49.67.2.142])
        by smtp.gmail.com with ESMTPSA id e23-20020aa78c57000000b005a75d85c0c7sm6699772pfd.51.2023.03.06.12.47.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 12:47:51 -0800 (PST)
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
Date:   Tue,  7 Mar 2023 04:47:20 +0800
Message-Id: <20230306204723.2584724-2-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230306204723.2584724-1-vernon2gm@gmail.com>
References: <20230306204723.2584724-1-vernon2gm@gmail.com>
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


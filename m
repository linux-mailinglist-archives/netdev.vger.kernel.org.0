Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF266AC790
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 17:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbjCFQT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 11:19:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbjCFQTJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 11:19:09 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E8792CFD0;
        Mon,  6 Mar 2023 08:16:30 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id e21so7464901oie.1;
        Mon, 06 Mar 2023 08:16:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678119321;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0XbTdGx8oMSPf4HhkoZWFz5gkpw9U1/T7K2pkx4Uby0=;
        b=fxiIFrRAiYwXMWVwLl0J/TnSrG/3gWirNRX//9xrxQirrRzkifylGupfFSquPy2NX/
         cjsso/QxXb15E/BA/+oXrKU0cXo0+QwGBsczSi4mxQy/RiVQFwIMTkr8i+ouxB1Gl0vw
         J6tzlBo8rTml7rGXfhsI79Fxvyzw7DDG5ZTX1Wb2G+6X2AzTy6687ai8AMhSmVmuleiL
         r1hHDkGpKqRJprzblWRpdCU3OpEO7H1hVcsldtpkH4JNfo5w1SvK2kyFPl3QXFVST7Oz
         kjTbHaIGaJXWufEtD3f5WvUpBN7hPIGRZ7Q2ehVbGHrfPrmN2q91JJELNReZbv3l4XUN
         bO6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678119321;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0XbTdGx8oMSPf4HhkoZWFz5gkpw9U1/T7K2pkx4Uby0=;
        b=fERl1uf/nh/gqj0xSf5muVxUQ5n+8ki5gEBYxZ9HOu2NADrQwT2fMmRQxUMZwHInRo
         8RUMHEWFFT1QYuUHfC/Cfr7AguR12pfLG2PA4eCa6qPiN8KTMwA2Vj1MUWXRqQaC67I5
         ugCRdmvA+N6qY287BXnj+5FTy8zmoekUAj85R4pMemPtH/hyfmsFTeDb44/yVNR2Zu0H
         UewVvDh9KmkJ5GaX3CZIhyR1qPssPb3vcPS1Y4FC+D9ydI7amhNu+4xcnnzRlEME2PlA
         u4kWiNb2t4M39nXjRNEcUkMU7VgkWycQzTtc2yCpSqUsvS08qdLqcuoCP2+6+RhXKEz1
         OL4w==
X-Gm-Message-State: AO0yUKWT+DcxARGV28vLRb9XN/FJ5QcT6d99wlI1K8+DO8sd384wwRbp
        FbbWZkj0+YCZkmzUZXcW6UtIHTEqF+ryFyjO
X-Google-Smtp-Source: AK7set+tQVdHJh4e+PqliYudDb3ddl76u0In93Ak366TBVp36ZG0/TpUrXOnnQYXS7peWeuLObbsvQ==
X-Received: by 2002:a05:6a00:2d28:b0:5a8:4ae7:25d5 with SMTP id fa40-20020a056a002d2800b005a84ae725d5mr17256165pfb.8.1678118837403;
        Mon, 06 Mar 2023 08:07:17 -0800 (PST)
Received: from vernon-pc.. ([49.67.2.142])
        by smtp.gmail.com with ESMTPSA id u6-20020aa78386000000b005d35695a66csm6465318pfm.137.2023.03.06.08.07.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 08:07:17 -0800 (PST)
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
Subject: [PATCH 3/5] scsi: lpfc: fix lpfc_cpu_affinity_check() if no further cpus set
Date:   Tue,  7 Mar 2023 00:06:49 +0800
Message-Id: <20230306160651.2016767-4-vernon2gm@gmail.com>
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
 drivers/scsi/lpfc/lpfc_init.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 61958a24a43d..01c0e2f47cf7 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -12563,7 +12563,7 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, int vectors)
 					goto found_same;
 				new_cpu = cpumask_next(
 					new_cpu, cpu_present_mask);
-				if (new_cpu == nr_cpumask_bits)
+				if (new_cpu >= nr_cpumask_bits)
 					new_cpu = first_cpu;
 			}
 			/* At this point, we leave the CPU as unassigned */
@@ -12577,7 +12577,7 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, int vectors)
 			 * selecting the same IRQ.
 			 */
 			start_cpu = cpumask_next(new_cpu, cpu_present_mask);
-			if (start_cpu == nr_cpumask_bits)
+			if (start_cpu >= nr_cpumask_bits)
 				start_cpu = first_cpu;
 
 			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
@@ -12613,7 +12613,7 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, int vectors)
 					goto found_any;
 				new_cpu = cpumask_next(
 					new_cpu, cpu_present_mask);
-				if (new_cpu == nr_cpumask_bits)
+				if (new_cpu >= nr_cpumask_bits)
 					new_cpu = first_cpu;
 			}
 			/* We should never leave an entry unassigned */
@@ -12631,7 +12631,7 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, int vectors)
 			 * selecting the same IRQ.
 			 */
 			start_cpu = cpumask_next(new_cpu, cpu_present_mask);
-			if (start_cpu == nr_cpumask_bits)
+			if (start_cpu >= nr_cpumask_bits)
 				start_cpu = first_cpu;
 
 			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
@@ -12704,7 +12704,7 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, int vectors)
 				goto found_hdwq;
 			}
 			new_cpu = cpumask_next(new_cpu, cpu_present_mask);
-			if (new_cpu == nr_cpumask_bits)
+			if (new_cpu >= nr_cpumask_bits)
 				new_cpu = first_cpu;
 		}
 
@@ -12719,7 +12719,7 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, int vectors)
 				goto found_hdwq;
 
 			new_cpu = cpumask_next(new_cpu, cpu_present_mask);
-			if (new_cpu == nr_cpumask_bits)
+			if (new_cpu >= nr_cpumask_bits)
 				new_cpu = first_cpu;
 		}
 
@@ -12730,7 +12730,7 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, int vectors)
  found_hdwq:
 		/* We found an available entry, copy the IRQ info */
 		start_cpu = cpumask_next(new_cpu, cpu_present_mask);
-		if (start_cpu == nr_cpumask_bits)
+		if (start_cpu >= nr_cpumask_bits)
 			start_cpu = first_cpu;
 		cpup->hdwq = new_cpup->hdwq;
  logit:
-- 
2.34.1


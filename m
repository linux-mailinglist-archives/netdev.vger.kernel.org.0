Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7EF6ACFC2
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 22:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbjCFVEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 16:04:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbjCFVEA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 16:04:00 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 669932CC4C;
        Mon,  6 Mar 2023 13:03:53 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id y10so6736508pfi.8;
        Mon, 06 Mar 2023 13:03:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678136633;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=owzTi2WIrDoJ2tUDhRyb29KrwMVbrS1C/TJgwosgU78=;
        b=YjMSjNXKfSQ5CrOSsj61TknVLEJ2Ck8oiqxUfixqm9jTDETQ3EcQrRCUDZ8tnIfw98
         JQymHl5Buh+924x8uGeQddKpVyL5EVQGBiw4/MN4Pslp2/TCR+RT1ofy/cfWTSTo95ZJ
         dK1BzqKLyktWh29KorGBUrSMOv4M7GerwtKm0pZ/6HylKW6/EWoYF78GdMGf2XlGs2MV
         ttdtwZFbh1OebAVywUYYgwFaA6kRa3lE6TaNOr4b8NcFIjoDo6VcjqoaCLlCgPF6LzU/
         FH//CMZdP0c9oXOerTrS3BZ3qh2Z7lE+Bqeomv5K/np2eKkQ5S/ENAbC0ZGI5EQDwVm0
         qPFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678136633;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=owzTi2WIrDoJ2tUDhRyb29KrwMVbrS1C/TJgwosgU78=;
        b=jpq7lUBSDNFP5/nFgGkZJHtCnrYXlh7k6PHoOg6qulxL5pVGuiiHmhgmhMpwlIAl1Y
         mKlGE/pscnW+LjF53CdQ4vbR+jrH7ZSHfBT0Ch95vEmIua5oa17HinDeMtuX+zVgY6/o
         X9PF0auH+Tnq0uVUEJoykO6sx9MgV4jkAcRnmCE143/lZqNH/KbeiV1X/REzduaD/uO7
         iU1hEfFPvVjnuV1iFzbY3DjUVon4Z0oxutq+hcxNkmn/ucp8MnxOGujM0OmSbYrAgmf5
         WCdgqjjOfsnskg4SeDS5SQE73LEBFdNZ4117b+pkhfMZIbAj3cdOIhSPM3Hh/2vxJlTI
         cKLA==
X-Gm-Message-State: AO0yUKU0dG11cn7faQwH0yJYVo7Nr3ANrCpFyv6oISzhnXV5+xsIcQQI
        isICdegsrmUGQW9jxZPfEIg=
X-Google-Smtp-Source: AK7set9i2UM7diB4lzv9/1oeYY77meyAKEBYgbqmgaG7P75rOHMznZ36mGqdngTWVMk9b212VmLlLA==
X-Received: by 2002:a62:8453:0:b0:60a:e919:51ef with SMTP id k80-20020a628453000000b0060ae91951efmr13232719pfd.9.1678136632678;
        Mon, 06 Mar 2023 13:03:52 -0800 (PST)
Received: from vernon-pc.. ([49.67.2.142])
        by smtp.gmail.com with ESMTPSA id 3-20020aa79143000000b005810c4286d6sm6706760pfi.0.2023.03.06.13.03.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 13:03:52 -0800 (PST)
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
Subject: [PATCH v2 3/4] scsi: lpfc: fix lpfc_cpu_affinity_check() if no further cpus set
Date:   Tue,  7 Mar 2023 05:03:11 +0800
Message-Id: <20230306210312.2614988-4-vernon2gm@gmail.com>
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
 drivers/scsi/lpfc/lpfc_init.c | 43 ++++++++++++++++-------------------
 1 file changed, 20 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 61958a24a43d..acfffdbe9ba1 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -12473,6 +12473,16 @@ lpfc_hba_eq_hdl_array_init(struct lpfc_hba *phba)
 	}
 }
 
+static inline int lpfc_next_present_cpu(int n, int first_cpu)
+{
+	n = cpumask_next(n, cpu_present_mask);
+
+	if (n >= nr_cpu_ids)
+		n = first_cpu;
+
+	return n;
+}
+
 /**
  * lpfc_cpu_affinity_check - Check vector CPU affinity mappings
  * @phba: pointer to lpfc hba data structure.
@@ -12561,10 +12571,8 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, int vectors)
 				    (new_cpup->eq != LPFC_VECTOR_MAP_EMPTY) &&
 				    (new_cpup->phys_id == cpup->phys_id))
 					goto found_same;
-				new_cpu = cpumask_next(
-					new_cpu, cpu_present_mask);
-				if (new_cpu == nr_cpumask_bits)
-					new_cpu = first_cpu;
+
+				new_cpu = lpfc_next_present_cpu(new_cpu, first_cpu);
 			}
 			/* At this point, we leave the CPU as unassigned */
 			continue;
@@ -12576,9 +12584,7 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, int vectors)
 			 * chance of having multiple unassigned CPU entries
 			 * selecting the same IRQ.
 			 */
-			start_cpu = cpumask_next(new_cpu, cpu_present_mask);
-			if (start_cpu == nr_cpumask_bits)
-				start_cpu = first_cpu;
+			start_cpu = lpfc_next_present_cpu(new_cpu, first_cpu);
 
 			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 					"3337 Set Affinity: CPU %d "
@@ -12611,10 +12617,8 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, int vectors)
 				if (!(new_cpup->flag & LPFC_CPU_MAP_UNASSIGN) &&
 				    (new_cpup->eq != LPFC_VECTOR_MAP_EMPTY))
 					goto found_any;
-				new_cpu = cpumask_next(
-					new_cpu, cpu_present_mask);
-				if (new_cpu == nr_cpumask_bits)
-					new_cpu = first_cpu;
+
+				new_cpu = lpfc_next_present_cpu(new_cpu, first_cpu);
 			}
 			/* We should never leave an entry unassigned */
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
@@ -12630,9 +12634,7 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, int vectors)
 			 * chance of having multiple unassigned CPU entries
 			 * selecting the same IRQ.
 			 */
-			start_cpu = cpumask_next(new_cpu, cpu_present_mask);
-			if (start_cpu == nr_cpumask_bits)
-				start_cpu = first_cpu;
+			start_cpu = lpfc_next_present_cpu(new_cpu, first_cpu);
 
 			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 					"3338 Set Affinity: CPU %d "
@@ -12703,9 +12705,8 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, int vectors)
 			    new_cpup->core_id == cpup->core_id) {
 				goto found_hdwq;
 			}
-			new_cpu = cpumask_next(new_cpu, cpu_present_mask);
-			if (new_cpu == nr_cpumask_bits)
-				new_cpu = first_cpu;
+
+			new_cpu = lpfc_next_present_cpu(new_cpu, first_cpu);
 		}
 
 		/* If we can't match both phys_id and core_id,
@@ -12718,9 +12719,7 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, int vectors)
 			    new_cpup->phys_id == cpup->phys_id)
 				goto found_hdwq;
 
-			new_cpu = cpumask_next(new_cpu, cpu_present_mask);
-			if (new_cpu == nr_cpumask_bits)
-				new_cpu = first_cpu;
+			new_cpu = lpfc_next_present_cpu(new_cpu, first_cpu);
 		}
 
 		/* Otherwise just round robin on cfg_hdw_queue */
@@ -12729,9 +12728,7 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, int vectors)
 		goto logit;
  found_hdwq:
 		/* We found an available entry, copy the IRQ info */
-		start_cpu = cpumask_next(new_cpu, cpu_present_mask);
-		if (start_cpu == nr_cpumask_bits)
-			start_cpu = first_cpu;
+		start_cpu = lpfc_next_present_cpu(new_cpu, first_cpu);
 		cpup->hdwq = new_cpup->hdwq;
  logit:
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-- 
2.34.1


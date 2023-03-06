Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D10D06AC75E
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 17:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbjCFQMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 11:12:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232802AbjCFQMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 11:12:00 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B20951F88;
        Mon,  6 Mar 2023 08:08:40 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id p3-20020a17090ad30300b0023a1cd5065fso9279474pju.0;
        Mon, 06 Mar 2023 08:08:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678118843;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5DGQdrsotz8W8EizOYEyX2DBff0cLsAl7IvbnLHf+bg=;
        b=nXoibcR7ByMCQICFh5RhNYtLXdctMhTA+mzKcFRnYoLe927/eL+h0tzDLTd0dnKoT0
         Z3z05jUPKUt4emgJ2q/iGj/eZsyitdS6TXa8ihVDkWpV5/onJknq0FNf2pphCFSu+Hui
         bfptA7x0gTIXK959Q7/8biA0Vay9WSDh5KGaN/pBGNJ4AwT+lqKhbtwJOumDaShaudGH
         eK3XnWbpdhfZ94ConuZv+3ifSNIUkwJtJW+K4hV2030YfNY2qXypG3VI4bApQIEQmMeI
         +blufCszN17pGg/ZQbNZPcgOJn42gOhr8krF48cXhsPkmWGitk3GARXgsrXa8ghyVQzo
         cI4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678118843;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5DGQdrsotz8W8EizOYEyX2DBff0cLsAl7IvbnLHf+bg=;
        b=KvaCHzqGpFrm+i+msy9s54lfypKKNNDFtdTXb+rc9ijlrGQpyP8yONbZIV8OT8gmMD
         13SMoBHCtharMQoiEFQOqrM2ja/n9YE58HVi4GEtTcrYhlPLV/nH9qrAK9TycczSVgmk
         QP4FG7Rl5XOK/8C/PaKXh7qCLmBJN0CSJVhss+n1ncDInOCArcm9owHcObu31uXOiqRO
         /0ILE934odIlKJxo7lbxN3XGij4CvwCMBpMj+E+OfNmE08hm9szs4VEfh9SVb23b4juI
         cUPAnDGYxZtV+aftrE5TcO8cG9MGEU9y+aQY1MEteaitcBHfh9z71Knugi67D/3OlzUD
         w8Vw==
X-Gm-Message-State: AO0yUKVck0KpqH8AOnDeCs5/fGc08skr+FWSIF3LPhARx2DtGiqQLm2S
        tt9gj0klaDroMRBbmYoLKHA=
X-Google-Smtp-Source: AK7set/tMWsOQQEdPjLWbhhz2SNcZHDm9AMA47AGQ9t0MP6KYTtdnCDlPd0/4DIKsgVEc6b4smPKLA==
X-Received: by 2002:a05:6a20:a10b:b0:c7:1da3:e3a with SMTP id q11-20020a056a20a10b00b000c71da30e3amr13357543pzk.16.1678118842755;
        Mon, 06 Mar 2023 08:07:22 -0800 (PST)
Received: from vernon-pc.. ([49.67.2.142])
        by smtp.gmail.com with ESMTPSA id u6-20020aa78386000000b005d35695a66csm6465318pfm.137.2023.03.06.08.07.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 08:07:22 -0800 (PST)
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
Subject: [PATCH 4/5] scsi: lpfc: fix lpfc_nvmet_setup_io_context() if no further cpus set
Date:   Tue,  7 Mar 2023 00:06:50 +0800
Message-Id: <20230306160651.2016767-5-vernon2gm@gmail.com>
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
 drivers/scsi/lpfc/lpfc_nvmet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index 7517dd55fe91..3ae7f330f827 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -1621,7 +1621,7 @@ lpfc_nvmet_setup_io_context(struct lpfc_hba *phba)
 			continue;
 		}
 		cpu = cpumask_next(cpu, cpu_present_mask);
-		if (cpu == nr_cpu_ids)
+		if (cpu >= nr_cpu_ids)
 			cpu = cpumask_first(cpu_present_mask);
 
 	}
-- 
2.34.1


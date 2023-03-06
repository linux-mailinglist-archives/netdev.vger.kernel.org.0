Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02F626ACFC5
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 22:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbjCFVE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 16:04:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbjCFVEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 16:04:21 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E24D67017;
        Mon,  6 Mar 2023 13:03:58 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id a9so11877057plh.11;
        Mon, 06 Mar 2023 13:03:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678136637;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z+JZSTuFczC5mo7PEY3yBvoy/91ay9ZlZhiG7/0/jdU=;
        b=J0G/0FbeicKyFQgCtYlOOk4T3oRqyNdGAmPLsHhC+AQzhfqNm09l3mAHs8IQpeDEK5
         tXW5R82OI7u7bhUdeK8PTTb/Xa9tmNRW7An5ryNY/VlLVIorS/f6VDFNRkHmqPkgNexd
         2V3nsdCrTizVcd32Nzq54QHft2pumYH/7g99jp8KyqObk62dxUAhMUOvzYwk4eHeaqYi
         mFS8sQLnUlwEgOfm+7KQW3KulkPpElt6qFYGnOKeiXEHNGxbOKze1nQsgpi92CJ1qwSo
         3KKUgdfecQl+4WpkS+onsXDqnrl4hRx53yIXhebFwMkVPogmwvrypbhF/nK3UGyGfLIU
         dnAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678136637;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z+JZSTuFczC5mo7PEY3yBvoy/91ay9ZlZhiG7/0/jdU=;
        b=I2qoBWXpa7O4XHvL+4BqWsTXf61fQc0nTX5d8q86t1XaYhxWqccn3O+xWMmQt3dQPJ
         AClu9wxJEvO+10BjZT+VwnxwHajmVzyimSSHAISOGECMw8ArPTz/Pn9Y9ZDmsxgSm1DE
         tUk/T3aElUkjFkAwMXuNbHaiLDdgg3cVkLrPf4CJ28HwTyVX8+jAXPA3MyXfJwTB+8L1
         sA1CpIXHr+YNnEOHCRpzlokix/nKt4f4WnSov/UASoreOH2zlglqnLOYC26Vu3NJFkSj
         4gTkLskhH8ZnO6IsGOkh+dOH1J+6CYxax9k06Et2szm0vwDNBRzsxY22qHPIyWagX62Z
         1g6g==
X-Gm-Message-State: AO0yUKX5lWfXzIA0Vl7rtvkn0ZuRLACTgXcawkLpDzcZgd2exl7xoMua
        OLpkUIrgdrVfSdyYJIfFRD0=
X-Google-Smtp-Source: AK7set9bJ+RZpctLL9LNRn8+W3MRhstsXchoF/02mRPZgh29TAeFmlavfd29dFchZTN62FY8teR5EQ==
X-Received: by 2002:a05:6a20:394f:b0:bc:8254:ddff with SMTP id r15-20020a056a20394f00b000bc8254ddffmr15220080pzg.1.1678136637715;
        Mon, 06 Mar 2023 13:03:57 -0800 (PST)
Received: from vernon-pc.. ([49.67.2.142])
        by smtp.gmail.com with ESMTPSA id 3-20020aa79143000000b005810c4286d6sm6706760pfi.0.2023.03.06.13.03.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 13:03:57 -0800 (PST)
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
Subject: [PATCH v2 4/4] scsi: lpfc: fix lpfc_nvmet_setup_io_context() if no further cpus set
Date:   Tue,  7 Mar 2023 05:03:12 +0800
Message-Id: <20230306210312.2614988-5-vernon2gm@gmail.com>
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


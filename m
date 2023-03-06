Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3458D6AC79F
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 17:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjCFQUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 11:20:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231636AbjCFQT5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 11:19:57 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92DBF3928F;
        Mon,  6 Mar 2023 08:17:42 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id c3so11092033qtc.8;
        Mon, 06 Mar 2023 08:17:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678119375;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IYGyvuAOKnVSJLZ+PGJAH4uPpRYGFdgKO1BedlDVykI=;
        b=kgi1+iWFbxRLTFxekjD2pI2NKmQgD+RR4bdx2BeL+4I/+FSqc5MHFSucYLuIohUpfa
         0345mB2OordJ4yoq9g5ZqU5h5S6HXkLlCJTBmm5KS1MY2jgy5zaC4Kw7q9JK3dAqjt5Y
         Y9mnpyZ/39xns9YJxuiTnFz5lCiwRFa6gkdGYyKIx21hcLaLytX3yhaFob4UvWdnLyvV
         HQRc5NdeHtka0/Fw7mDs+/regvI+w/sWpWbOitUTXj18CkacGgUUL8guO/5WYpDVvzFh
         n0FDNV5EAN51UuNBhea3wLhq3oYrnQHiHevrMTRk9GXoS6JFBtlu21u3GXFxYov7OinU
         sdtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678119375;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IYGyvuAOKnVSJLZ+PGJAH4uPpRYGFdgKO1BedlDVykI=;
        b=R1HTbg/r7jGD/VOvLvnmokJ41mWdEitSgVv2m97OPoB8Yt2mbG3QwTjAkNYeUnasvh
         O0NNY5WUkJ6PavXP4ngGiOMYFGmA6zfVuhh0oZhSsCnJraOha0l2WwaDJjY3hLotR84S
         g9AsPyD2yoEXoW4pnUJLpPVY3PAIpfjWGoBkCYtPmSICg9RCuYDgv9EyO0z3MmxbLMPP
         /OihA2MdmOu+bBAHe/uK6pt0p/DVBd2EG/Rw9Q/PpfQ29ss9VqdNsJ+eaUulf8WRNhhE
         ia2/j1AiGKCAt+pFSxEwKLhPYzwFQu2W3lUsUW+TsWOWuieeAsE8gw2P7/vGgzF15YVS
         yU/A==
X-Gm-Message-State: AO0yUKVYuxUueYcKfZaWp3YUD1W+kA5Du7vzEh6KhJWU7keow2lvrBKK
        s9CFwDO5yPTz0C7zLpxEMsOFUGLwdHo6V6dC
X-Google-Smtp-Source: AK7set9FRJJ4bXIzCpqYTe8FRO5hxEPWPyG4KeJpbdnQ94eOSJ9cEuAei2kEStRQ6ROkgIXiyTXqbg==
X-Received: by 2002:a62:7b45:0:b0:5a9:b4eb:d262 with SMTP id w66-20020a627b45000000b005a9b4ebd262mr10996934pfc.1.1678118827070;
        Mon, 06 Mar 2023 08:07:07 -0800 (PST)
Received: from vernon-pc.. ([49.67.2.142])
        by smtp.gmail.com with ESMTPSA id u6-20020aa78386000000b005d35695a66csm6465318pfm.137.2023.03.06.08.07.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 08:07:06 -0800 (PST)
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
Subject: [PATCH 1/5] random: fix try_to_generate_entropy() if no further cpus set
Date:   Tue,  7 Mar 2023 00:06:47 +0800
Message-Id: <20230306160651.2016767-2-vernon2gm@gmail.com>
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
 drivers/char/random.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index ce3ccd172cc8..d76f12a5f74f 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1311,7 +1311,7 @@ static void __cold try_to_generate_entropy(void)
 			/* Basic CPU round-robin, which avoids the current CPU. */
 			do {
 				cpu = cpumask_next(cpu, &timer_cpus);
-				if (cpu == nr_cpumask_bits)
+				if (cpu >= nr_cpumask_bits)
 					cpu = cpumask_first(&timer_cpus);
 			} while (cpu == smp_processor_id() && num_cpus > 1);
 
-- 
2.34.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18610626B2E
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 20:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235094AbiKLTJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 14:09:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234967AbiKLTJx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 14:09:53 -0500
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D2917E30;
        Sat, 12 Nov 2022 11:09:52 -0800 (PST)
Received: by mail-qv1-xf32.google.com with SMTP id mi9so5532318qvb.8;
        Sat, 12 Nov 2022 11:09:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C0ZwMR2gCmjCo8DSne7eN5n31OgpWeA+QwMIe/AT+TA=;
        b=EWbVcRK6VQQtBX4Tw7NbZb11qrqsmGD9Jz7Ot3MeTptcgDZLc39mF82hrl6ywjrbGO
         5DByMs2+I/BKQAcmYr+M1oulbaFFR6fvvCL1VeoXyITEu+c7LOlxKBZr/B1yiagKsHz/
         N9iZiiGa0dvk/iIMA1qC+r9oxhwONnN+biuByTPkrUqgI2iIW2l87LwX6tgI3lNXwjqt
         +vNTOOL2/FmFLVwQhoQjYogKD5yIQK2zy4+QlvaJ0iAP/an3r6WmvEDR1+gE3BWwQEL0
         vsSsbuoMlUmnsQq+bNA0hKDexmx9FLzjsxm5BZN2hfp+NiTZzGbAP19s3mtS0XTYkAXn
         Dq3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C0ZwMR2gCmjCo8DSne7eN5n31OgpWeA+QwMIe/AT+TA=;
        b=wCpC/n214E3DtoMznShvqVU71CbY5BQJYafdvsrL/XEfI9JOq4kUJyAHndkuK3W8hR
         800r5o3c3lePFKoH0ZNPBf9ZoS0kqa8GBlR+AfVmKrwDf7x6+aBmGuERJPLBNsK5CPo8
         H9UUHNijGPIUh/5v5cLCvpCAYI8DcYOWpOTsxUBXBDvCi9T+2FAguGrdgcRrVSqHEV67
         iV6+fxPXF8JmiXISGBOuLu/idSoFYpPfCO+n5UIHMwtsIZ23e/XpdcX3DiTWBidSS+xv
         ZJBwxFOZd5FdYT/iPB0Ja09RL65GBgW47Uz1pqhxFjzEMW+XoI1hUk06t2BsKmpNcAAC
         dJEg==
X-Gm-Message-State: ANoB5plekUzv6XiBZHMB7rg9uCESn9Z2VEeXU88Rr+8aFZmziJLYisDC
        wKIFYyyjA2NPSZtRvVT1v/IqX4opA+M=
X-Google-Smtp-Source: AA0mqf7QvfhjET/seOjh75TRhk2tq5bA2F/OeMmuwwt/hZZHlDiRotzdRhTdoZGFvZRyZDq5pElPhA==
X-Received: by 2002:a05:6214:428f:b0:4bb:d68d:2744 with SMTP id og15-20020a056214428f00b004bbd68d2744mr6920529qvb.5.1668280191620;
        Sat, 12 Nov 2022 11:09:51 -0800 (PST)
Received: from localhost (user-24-236-74-177.knology.net. [24.236.74.177])
        by smtp.gmail.com with ESMTPSA id f2-20020ac87f02000000b003a4c3c4d2d4sm3192944qtk.49.2022.11.12.11.09.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Nov 2022 11:09:51 -0800 (PST)
From:   Yury Norov <yury.norov@gmail.com>
To:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Barry Song <baohua@kernel.org>,
        Ben Segall <bsegall@google.com>,
        haniel Bristot de Oliveira <bristot@redhat.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Gal Pressman <gal@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Mel Gorman <mgorman@suse.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Cc:     Yury Norov <yury.norov@gmail.com>, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH v2 2/4] cpumask: introduce cpumask_nth_and_andnot
Date:   Sat, 12 Nov 2022 11:09:44 -0800
Message-Id: <20221112190946.728270-3-yury.norov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221112190946.728270-1-yury.norov@gmail.com>
References: <20221112190946.728270-1-yury.norov@gmail.com>
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

Introduce cpumask_nth_and_andnot() based on find_nth_and_andnot_bit().
It's used in the following patch to traverse cpumasks without storing
intermediate result in temporary cpumask.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 include/linux/cpumask.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index c2aa0aa26b45..debfa2261569 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -391,6 +391,26 @@ unsigned int cpumask_nth_andnot(unsigned int cpu, const struct cpumask *srcp1,
 				nr_cpumask_bits, cpumask_check(cpu));
 }
 
+/**
+ * cpumask_nth_and_andnot - get the Nth cpu set in 1st and 2nd cpumask, and clear in 3rd.
+ * @srcp1: the cpumask pointer
+ * @srcp2: the cpumask pointer
+ * @srcp3: the cpumask pointer
+ * @cpu: the N'th cpu to find, starting from 0
+ *
+ * Returns >= nr_cpu_ids if such cpu doesn't exist.
+ */
+static inline
+unsigned int cpumask_nth_and_andnot(unsigned int cpu, const struct cpumask *srcp1,
+							const struct cpumask *srcp2,
+							const struct cpumask *srcp3)
+{
+	return find_nth_and_andnot_bit(cpumask_bits(srcp1),
+					cpumask_bits(srcp2),
+					cpumask_bits(srcp3),
+					nr_cpumask_bits, cpumask_check(cpu));
+}
+
 #define CPU_BITS_NONE						\
 {								\
 	[0 ... BITS_TO_LONGS(NR_CPUS)-1] = 0UL			\
-- 
2.34.1


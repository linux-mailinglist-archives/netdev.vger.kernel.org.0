Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7B86763BB
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 05:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbjAUEZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 23:25:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjAUEYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 23:24:46 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B290D4FCF8;
        Fri, 20 Jan 2023 20:24:43 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id j9so5243825qvt.0;
        Fri, 20 Jan 2023 20:24:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WJDoNgHHINrCbuwq1iSTb+uK/rqsM0fqmFaN0vHyvak=;
        b=Jqhz0cRYfCQpS/zjF90KMvOTK02E3o9qpdRZlGwEW4cocE3H5NsKl2zJaBwazrc3XK
         sPBzcj/azPDRhd6MJnoywMNrFUUwuBBNUI+rnM2CL4aNLGSv0W/mmmuuzOE05/dVpMUS
         1m0NfxS72zjlo5IinxUwwd1vpCR/Wj5yp/cyRLpFCP6NwBt2VdtftCn7Nzxa7UBOpM4z
         Nby+cBRpwvkBTsi0rhpJrcsiEF1izLkf1yDoDwk3gm7ElZSla8KKA+QIGGwKloBSaUBL
         NxbYs0DTgbqoxFuxM8e+Ut8VsVXH/yzsJjrgb0ytgZ5pqUIEWhO/a7mzI6wSNUDxAJDC
         tvkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WJDoNgHHINrCbuwq1iSTb+uK/rqsM0fqmFaN0vHyvak=;
        b=4gxf498YG70mfiEPI90ty1Nm0pB5/iDSF508uVE6EYFnIG3HxtLr5ZPx2hVhd9jCDY
         UWC+0K4qLAlk0eCYQD/33XWY57aK1CsQUleKkY/xMAxu1GePTqVqKreUluJfCRkamxSH
         xyujwQWJVD/fUDdqEpXg4ullbIx5Jzfl6KZ2lIvM2jzDtbk0XiFyysD3lsvzI2ME6LRr
         sVu27LA2GAjwx1Fh6ehsGaj91IKVkRrNkOBi45k1NSftcbGiNTF7dy6uZ2VrJ06UYd3x
         Zz+5aqaVx/IBxatVkUEe2EmxmW+9xErcYnpOmtwwPR9XikuKwv6IZCec/JC2n+tQL4Tq
         lHbA==
X-Gm-Message-State: AFqh2kpv7w/aIhpJ/5t9ZmZf6++2Pf1VLBS8yX6wzG9N2tiP22UTrTJE
        BB0+x2erNucI0nHFr0fv073mpSpzh0Q=
X-Google-Smtp-Source: AMrXdXt+x7F7BF6amhpW8X6fhkbnxy/Qfp8YpiM8O3I3IWVoBHj8FrRu4KFPnN3aXGJ9oL8H+03SJA==
X-Received: by 2002:a0c:e8c4:0:b0:534:7cf3:44b4 with SMTP id m4-20020a0ce8c4000000b005347cf344b4mr24906622qvo.50.1674275082339;
        Fri, 20 Jan 2023 20:24:42 -0800 (PST)
Received: from localhost (50-242-44-45-static.hfc.comcastbusiness.net. [50.242.44.45])
        by smtp.gmail.com with ESMTPSA id c5-20020a05620a268500b006e8f8ca8287sm22782385qkp.120.2023.01.20.20.24.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 20:24:41 -0800 (PST)
From:   Yury Norov <yury.norov@gmail.com>
To:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Barry Song <baohua@kernel.org>,
        Ben Segall <bsegall@google.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Gal Pressman <gal@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Haniel Bristot de Oliveira <bristot@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        Peter Lafreniere <peter@n8pjl.ca>,
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
Subject: [PATCH 2/9] cpumask: introduce cpumask_nth_and_andnot
Date:   Fri, 20 Jan 2023 20:24:29 -0800
Message-Id: <20230121042436.2661843-3-yury.norov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230121042436.2661843-1-yury.norov@gmail.com>
References: <20230121042436.2661843-1-yury.norov@gmail.com>
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
Acked-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Peter Lafreniere <peter@n8pjl.ca>
---
 include/linux/cpumask.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index c2aa0aa26b45..7b16aede7ac5 100644
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
+static __always_inline
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F894647592
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 19:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbiLHSbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 13:31:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbiLHSbK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 13:31:10 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BFCD9B2A7;
        Thu,  8 Dec 2022 10:31:09 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id s30-20020a056830439e00b0067052c70922so1362809otv.11;
        Thu, 08 Dec 2022 10:31:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LbKgne40p2rihRA02W+HijcyMxRa1yUI8+yJKRvf/NQ=;
        b=Bo31gsyp0J+TM4su3QjnRadwNIVXJy/+Lrdq6df32Kz4GdD2b0xgWMgT7N5K/DDwWU
         jfqLjlaQ8YRbgzCn1ch/yeC8xrsJP1640IroCB9FHD16GRqM/Ta8ROXek+v9w7MaRM75
         0DzIOVFzssMmPt50XPvrT+5BmlptjQscuSrI/lQ9xH+E5B1C5HJpwGBfktPgPoj2yWWG
         m8woPWvOB0Zh38DJsq1tEjPsZ3FIN14HgQJJifleKRi22Bne5WnvlqgqBlJNVC2cUoPV
         b/e4nq92OOcGXb7Yh5WF0V2sEAs+iWV1lXLQspuNK61QhRyKYDPqgkgrKfVVwTwaqIjK
         69Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LbKgne40p2rihRA02W+HijcyMxRa1yUI8+yJKRvf/NQ=;
        b=4b5g97O3OvTiF/2LL93J/fINjP2H1Nr9UZzMFEw2CnPpf9OttxXQ2v/bnLHp3kJywT
         bX4kmhwL8lLl+wD5ktwvke6/rrF07/OeYKDnUrFRXbjQUicaSHCkWykEWTwi1d8U+bxA
         99gy13kyuHR0xUNZ7mjKS/HPNAYSd8qio6RAqeovbxRhtmZx77MZppl4xucMTEln45HT
         AaDTjhIBj9uyrW7twgXQwmX5mcXqj7V0QbsxefnIyry8X/QI2Aqzuw6jbkUFutUgbRZr
         HGKDkFxPg+GKIbSEwlW3UAF6jD3cK6j+Nfmj4LtuyvMU74kQQl8yV/jLy/szTEyBFwK7
         jY5g==
X-Gm-Message-State: ANoB5pkDYXOR51k57zIepRCaExOfe8T8HagEfl8YsH/FoYgZS5HaJxX0
        ZNZkNfikXMbq1X+3HxTnJvYx0dnjalc=
X-Google-Smtp-Source: AA0mqf5S/KEvDVb/hsApCxLtfK1h78S1yk8iDwtF6DYH8dBGFneQlN/N/5/NO1fxSDgDkb8tg21Ovw==
X-Received: by 2002:a05:6830:d8c:b0:66a:ea19:28ea with SMTP id bv12-20020a0568300d8c00b0066aea1928eamr2139337otb.38.1670524268597;
        Thu, 08 Dec 2022 10:31:08 -0800 (PST)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id i21-20020a9d68d5000000b00662228a27d3sm11783552oto.57.2022.12.08.10.31.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 10:31:08 -0800 (PST)
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
Subject: [PATCH v3 2/5] cpumask: introduce cpumask_nth_and_andnot
Date:   Thu,  8 Dec 2022 10:30:58 -0800
Message-Id: <20221208183101.1162006-3-yury.norov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221208183101.1162006-1-yury.norov@gmail.com>
References: <20221208183101.1162006-1-yury.norov@gmail.com>
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
index 9543b22d6dc2..5c4905108d1b 100644
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


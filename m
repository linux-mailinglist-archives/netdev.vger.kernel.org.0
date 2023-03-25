Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 238986C903E
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 19:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbjCYSzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 14:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231248AbjCYSze (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 14:55:34 -0400
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5219CA5E5;
        Sat, 25 Mar 2023 11:55:30 -0700 (PDT)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-177b78067ffso5184860fac.7;
        Sat, 25 Mar 2023 11:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679770529;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=owQqtMurqm2qI+24ndEGs/qWEaDzKKQeglmv6UMu1sw=;
        b=CyTkRcKyeCvHukeGZUb4EgoTMd6scDuf5XkWBsZ5Xoj3o1Fis9RgqD2p3HM3ksyjQV
         18iVk82ZJHo6+dn14ukQS0wClpxYkDUsffKEuU8zwuWA3mKkFaOa2B+KSWgTD34oCX+n
         OKwp9AaawRw9VpgolapOtgK2tO1ald8AQqzD9uFo3gP2Z5HjCOWtGdAaltv5/aZh2BaZ
         UF2W6B7MvTK4j1vP8FvJ4brIFGtsCHHxp6ndHNIFBRq7cgQ8CtFNQmpCbjyMAL5NKPmB
         nUg1OUP0cJBLGiS4njWpN6yHp2PYQqcxnb2g1SpoaFJhRX0Y8+PQ/VYqE6SEnoDAKMQ2
         kMJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679770529;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=owQqtMurqm2qI+24ndEGs/qWEaDzKKQeglmv6UMu1sw=;
        b=McqSa8r1Cv40Di09d+N7xWTDNp4EfMqrplldz7v1d+RngHAHarENIsnnhFyy8q7bhN
         NYogltvp4lxZPSD9a/efJJu0w5nEkRza1qb7hobo9gbqb8rDFpm2qBSKGO85qlFPO4+Q
         tZ2soSRNsYNKnL+mDPHMmXdDLgB3hli30Gx2ViDEYrjLyiRK/3OqCZcHmVROquSXG/DO
         zKgAGc4DtKNC2orQdHKntcPm82OfaRKjpLpM7mPNCZe/ed+sGWEG6ApXBp8vNlXWi/47
         H9P41zkviiQv+mwG03eujcdZxcfR5t812Lk9ZuLHOYYJk+ztsBtKCrqQ0V/2eDnEjmkC
         Vofw==
X-Gm-Message-State: AAQBX9e00w6SMztbyO7RYCN74KlwtcsG/0AEcUXWnavoN9F2TRBsZ7z4
        otwj7HlgjXAfMJgI2SIgvYM=
X-Google-Smtp-Source: AKy350YzaBpxv8S1DyMSbE8BfbzwOluEWimBlPVsmxBI48AxRWDEh3uryOJykSUgwOkLM5yiZprepQ==
X-Received: by 2002:a05:6871:a5:b0:177:956c:36d5 with SMTP id u37-20020a05687100a500b00177956c36d5mr5680776oaa.29.1679770529568;
        Sat, 25 Mar 2023 11:55:29 -0700 (PDT)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id q130-20020acaf288000000b00383ef567cfdsm9417909oih.21.2023.03.25.11.55.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Mar 2023 11:55:29 -0700 (PDT)
From:   Yury Norov <yury.norov@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Yury Norov <yury.norov@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Pawel Chmielewski <pawel.chmielewski@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Barry Song <baohua@kernel.org>
Subject: [PATCH 4/8] net: mlx5: switch comp_irqs_request() to using for_each_numa_cpu
Date:   Sat, 25 Mar 2023 11:55:10 -0700
Message-Id: <20230325185514.425745-5-yury.norov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230325185514.425745-1-yury.norov@gmail.com>
References: <20230325185514.425745-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

for_each_numa_cpu() is a more straightforward alternative to
for_each_numa_hop_mask() + for_each_cpu_andnot().

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 38b32e98f3bd..80368952e9b1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -817,12 +817,10 @@ static void comp_irqs_release(struct mlx5_core_dev *dev)
 static int comp_irqs_request(struct mlx5_core_dev *dev)
 {
 	struct mlx5_eq_table *table = dev->priv.eq_table;
-	const struct cpumask *prev = cpu_none_mask;
-	const struct cpumask *mask;
 	int ncomp_eqs = table->num_comp_eqs;
 	u16 *cpus;
 	int ret;
-	int cpu;
+	int cpu, hop;
 	int i;
 
 	ncomp_eqs = table->num_comp_eqs;
@@ -844,15 +842,11 @@ static int comp_irqs_request(struct mlx5_core_dev *dev)
 
 	i = 0;
 	rcu_read_lock();
-	for_each_numa_hop_mask(mask, dev->priv.numa_node) {
-		for_each_cpu_andnot(cpu, mask, prev) {
-			cpus[i] = cpu;
-			if (++i == ncomp_eqs)
-				goto spread_done;
-		}
-		prev = mask;
+	for_each_numa_cpu(cpu, hop, dev->priv.numa_node, cpu_possible_mask) {
+		cpus[i] = cpu;
+		if (++i == ncomp_eqs)
+			break;
 	}
-spread_done:
 	rcu_read_unlock();
 	ret = mlx5_irqs_request_vectors(dev, cpus, ncomp_eqs, table->comp_irqs);
 	kfree(cpus);
-- 
2.34.1


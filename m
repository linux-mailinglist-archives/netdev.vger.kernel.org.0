Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 659F45F50D8
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 10:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbiJEIcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 04:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbiJEIcn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 04:32:43 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A2E6D9E5
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 01:32:42 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id lx7so15019897pjb.0
        for <netdev@vger.kernel.org>; Wed, 05 Oct 2022 01:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date;
        bh=bJlYpEHuGteSJYoWYcuqwtV+VIvtgUlEz8rUGsVoQjk=;
        b=wL1DDtBFmuHQUdMOTWtEGr0NdsA1syEXxHDCRSlaru+nrpvnw2185xhFEOryfFV6PE
         tOSy/dhkvaGgyBx3uq9EijGtk4UmLdlVfGfKGvGvqESqHPlfU3pjKF1KE0D2HS2AuXVu
         u7xCv/30ioB94QCjdL1B8zHa1TnRVTe8lP/CU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date;
        bh=bJlYpEHuGteSJYoWYcuqwtV+VIvtgUlEz8rUGsVoQjk=;
        b=hGXS0Yqk3rtpywVWwvQZSeRdW4A+uiXcZJT+M31VQJKTBm1x2VmPUuVb/f3gz1GMNw
         HzP2ty29DmPiSZn3LGV2hNgUkonvJUFv3GNx+wDI0XEjx7AhmuGC3cfTWszlj7nBJniM
         GOPcajwzEkI9Lfv7DfP3ojy/Hg5G9GSoTdSdxBARXo4FVSq6lR58fXdvAg2gF9M+J7BI
         c7bZb9+yIOoKoBuf83bQzTUgaVxhFX4z4lodJzSySdy0lnYEOc417p2ez6MiSBwgqEc3
         3oB/U/j4o+FbJQAQBYH+1GEyNXOuBAz4UpojZVXW3dpxRKx4J7LqLkKJBk7mZ7rei0mc
         zS/Q==
X-Gm-Message-State: ACrzQf2sPwgU0pZK2EdtXm7Mj1eHQBhYHbvvGIL0bdJPf6WyiS0nSJcc
        BltLt/pDScnKk/FF6ba1qhGh0mUCj0KrGw==
X-Google-Smtp-Source: AMsMyM4e1IgzBSwzbAN1NcOz9z3wDCw8ret5SbCIH1oL8oONRg/y/frZr3ZBmUJdWAEWfiRySb0Obg==
X-Received: by 2002:a17:902:6546:b0:17f:7888:58b with SMTP id d6-20020a170902654600b0017f7888058bmr5318982pln.140.1664958761819;
        Wed, 05 Oct 2022 01:32:41 -0700 (PDT)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id jj9-20020a170903048900b0017ec1b1bf9fsm5899320plb.217.2022.10.05.01.32.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Oct 2022 01:32:41 -0700 (PDT)
From:   Joe Damato <jdamato@fastly.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        anthony.l.nguyen@intel.com, jesse.brandeburg@intel.com,
        Joe Damato <jdamato@fastly.com>
Subject: [next-queue 3/3] i40e: Add i40e_napi_poll tracepoint
Date:   Wed,  5 Oct 2022 01:31:43 -0700
Message-Id: <1664958703-4224-4-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1664958703-4224-1-git-send-email-jdamato@fastly.com>
References: <1664958703-4224-1-git-send-email-jdamato@fastly.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a tracepoint for i40e_napi_poll that allows users to get detailed
information about the amount of work done. This information can help users
better tune the correct NAPI parameters (like weight and budget), as well
as debug NIC settings like rx-usecs and tx-usecs, etc.

An example of the output from this tracepoint:

[...snip...]

1029.268 :0/0 i40e:i40e_napi_poll(i40e_napi_poll on dev eth1 q i40e-eth1-TxRx-30 irq 172 irq_mask 00000000,00000000,00000000,00000010,00000000,00000000 curr_cpu 68 budget 64 bpr 64 work_done 0 tx_work_done 2 clean_complete 1 tx_clean_complete 1)
	i40e_napi_poll ([i40e])
	i40e_napi_poll ([i40e])
	__napi_poll ([kernel.kallsyms])
	net_rx_action ([kernel.kallsyms])
	__do_softirq ([kernel.kallsyms])
	common_interrupt ([kernel.kallsyms])
	asm_common_interrupt ([kernel.kallsyms])
	intel_idle_irq ([kernel.kallsyms])
	cpuidle_enter_state ([kernel.kallsyms])
	cpuidle_enter ([kernel.kallsyms])
	do_idle ([kernel.kallsyms])
	cpu_startup_entry ([kernel.kallsyms])
	[0x243fd8] ([kernel.kallsyms])
	secondary_startup_64_no_verify ([kernel.kallsyms])

Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 drivers/net/ethernet/intel/i40e/i40e_trace.h | 50 ++++++++++++++++++++++++++++
 drivers/net/ethernet/intel/i40e/i40e_txrx.c  |  3 ++
 2 files changed, 53 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_trace.h b/drivers/net/ethernet/intel/i40e/i40e_trace.h
index b5b1229..779d046 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_trace.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_trace.h
@@ -55,6 +55,56 @@
  * being built from shared code.
  */
 
+#define NO_DEV "(i40e no_device)"
+
+TRACE_EVENT(i40e_napi_poll,
+
+	TP_PROTO(struct napi_struct *napi, struct i40e_q_vector *q, int budget,
+		 int budget_per_ring, int work_done, int tx_work_done, bool clean_complete,
+		 bool tx_clean_complete),
+
+	TP_ARGS(napi, q, budget, budget_per_ring, work_done, tx_work_done,
+		clean_complete, tx_clean_complete),
+
+	TP_STRUCT__entry(
+		__field(int, budget)
+		__field(int, budget_per_ring)
+		__field(int, work_done)
+		__field(int, tx_work_done)
+		__field(int, clean_complete)
+		__field(int, tx_clean_complete)
+		__field(int, irq_num)
+		__field(int, curr_cpu)
+		__string(qname, q->name)
+		__string(dev_name, napi->dev ? napi->dev->name : NO_DEV)
+		__bitmask(irq_affinity,	nr_cpumask_bits)
+	),
+
+	TP_fast_assign(
+		__entry->budget = budget;
+		__entry->budget_per_ring = budget_per_ring;
+		__entry->work_done = work_done;
+		__entry->tx_work_done = tx_work_done;
+		__entry->clean_complete = clean_complete;
+		__entry->tx_clean_complete = tx_clean_complete;
+		__entry->irq_num = q->irq_num;
+		__entry->curr_cpu = get_cpu();
+		__assign_str(qname, q->name);
+		__assign_str(dev_name, napi->dev ? napi->dev->name : NO_DEV);
+		__assign_bitmask(irq_affinity, cpumask_bits(&q->affinity_mask),
+				 nr_cpumask_bits);
+	),
+
+	TP_printk("i40e_napi_poll on dev %s q %s irq %d irq_mask %s curr_cpu %d "
+		  "budget %d bpr %d work_done %d tx_work_done %d "
+		  "clean_complete %d tx_clean_complete %d",
+		__get_str(dev_name), __get_str(qname), __entry->irq_num,
+		__get_bitmask(irq_affinity), __entry->curr_cpu, __entry->budget,
+		__entry->budget_per_ring, __entry->work_done,
+		__entry->tx_work_done,
+		__entry->clean_complete, __entry->tx_clean_complete)
+);
+
 /* Events related to a vsi & ring */
 DECLARE_EVENT_CLASS(
 	i40e_tx_template,
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index ed88309..8b72f1b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -2743,6 +2743,9 @@ int i40e_napi_poll(struct napi_struct *napi, int budget)
 			clean_complete = false;
 	}
 
+	trace_i40e_napi_poll(napi, q_vector, budget, budget_per_ring, work_done, tx_wd,
+			     clean_complete, tx_clean_complete);
+
 	/* If work not completed, return budget and polling will return */
 	if (!clean_complete || !tx_clean_complete) {
 		int cpu_id = smp_processor_id();
-- 
2.7.4


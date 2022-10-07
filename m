Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C86615F802F
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 23:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbiJGVjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 17:39:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiJGVjm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 17:39:42 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBDD4F25
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 14:39:40 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id q10-20020a17090a304a00b0020b1d5f6975so4710125pjl.0
        for <netdev@vger.kernel.org>; Fri, 07 Oct 2022 14:39:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=z0vFULdBKwrocYcOtwwM7mQLQOp60to46d8PtAxnk1M=;
        b=UgrFMxcroGOVU8LnSMIcenQy8uSEnuAYINFxotf9XLElzqCAf5s4lEORyi4Uw2VDRJ
         868Mvbg12HUfoSxa24GfnEgzq3s22kH74yUbuZVSyBCNuCud4j5zJAeCYT594Z+OzkTn
         d9l3/q21azUcz2FZ2LqvNrQEFGJtJzjpKeJ3k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z0vFULdBKwrocYcOtwwM7mQLQOp60to46d8PtAxnk1M=;
        b=jMObphQW1A70voCZDus1FNEhYEmfg3G5YAFHvVi/b1YNRLd/JZNp93z+nrzxv987wP
         0ZAXAE0ApkzKWCefORIxkJYL6PVJSg4SSQV28JF7eCejScf1KP63cT6k8+A2I9RtttHF
         l/5bMGDldkpxI7cpswbvibwaEXv2/6eHZY+Gk6NfQVpCEQCJ2p9DZbRN8T0zWi7gzVmd
         kN5Zjq33J8W8rexv8mjiKAGXWnPm1Yw4T0C+FECHo7m/ztpuUuI5fPBfd5sUkj5Z1cy1
         M58r5FSep7tkb88Ddo2AJdJASf/RGRzXeb6TgxiMkq11zV3YPrq032IyexwlSdBWdCmx
         s5Yg==
X-Gm-Message-State: ACrzQf2fPtOd3mKHf0SW60OY0N70oY7EHNdzbeL6i/xzSkVpquS8/HiF
        dd4N3va5ARqDhEcJLKEn0dzsw3Xb4ppVnA==
X-Google-Smtp-Source: AMsMyM7GDXRatllZhBdz3awwyEocviEAFfinyRSstgbzMXRwYLTSpU8/bjhHjP5rAJIc3/ygK9POJQ==
X-Received: by 2002:a17:90b:1d4c:b0:20a:8db1:da52 with SMTP id ok12-20020a17090b1d4c00b0020a8db1da52mr18088096pjb.98.1665178780266;
        Fri, 07 Oct 2022 14:39:40 -0700 (PDT)
Received: from localhost.localdomain (c-24-6-151-244.hsd1.ca.comcast.net. [24.6.151.244])
        by smtp.gmail.com with ESMTPSA id m24-20020a17090a7f9800b001f2fa09786asm2012655pjl.19.2022.10.07.14.39.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Oct 2022 14:39:39 -0700 (PDT)
From:   Joe Damato <jdamato@fastly.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        anthony.l.nguyen@intel.com, jesse.brandeburg@intel.com,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        Joe Damato <jdamato@fastly.com>
Subject: [next-queue v4 4/4] i40e: Add i40e_napi_poll tracepoint
Date:   Fri,  7 Oct 2022 14:38:43 -0700
Message-Id: <1665178723-52902-5-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1665178723-52902-1-git-send-email-jdamato@fastly.com>
References: <1665178723-52902-1-git-send-email-jdamato@fastly.com>
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

When perf is attached, this tracepoint only fires when not in XDP mode.

An example of the output from this tracepoint:

$ sudo perf trace -e i40e:i40e_napi_poll -a --call-graph=fp --libtraceevent_print

[..snip..]

388.258 :0/0 i40e:i40e_napi_poll(i40e_napi_poll on dev eth2 q i40e-eth2-TxRx-9 irq 346 irq_mask 00000000,00000000,00000000,00000000,00000000,00800000 curr_cpu 23 budget 64 bpr 64 rx_cleaned 28 tx_cleaned 0 rx_clean_complete 1 tx_clean_complete 1)
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
Acked-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Acked-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_trace.h | 49 ++++++++++++++++++++++++++++
 drivers/net/ethernet/intel/i40e/i40e_txrx.c  |  4 +++
 2 files changed, 53 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_trace.h b/drivers/net/ethernet/intel/i40e/i40e_trace.h
index b5b1229..79d587a 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_trace.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_trace.h
@@ -55,6 +55,55 @@
  * being built from shared code.
  */
 
+#define NO_DEV "(i40e no_device)"
+
+TRACE_EVENT(i40e_napi_poll,
+
+	TP_PROTO(struct napi_struct *napi, struct i40e_q_vector *q, int budget,
+		 int budget_per_ring, unsigned int rx_cleaned, unsigned int tx_cleaned,
+		 bool rx_clean_complete, bool tx_clean_complete),
+
+	TP_ARGS(napi, q, budget, budget_per_ring, rx_cleaned, tx_cleaned,
+		rx_clean_complete, tx_clean_complete),
+
+	TP_STRUCT__entry(
+		__field(int, budget)
+		__field(int, budget_per_ring)
+		__field(unsigned int, rx_cleaned)
+		__field(unsigned int, tx_cleaned)
+		__field(int, rx_clean_complete)
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
+		__entry->rx_cleaned = rx_cleaned;
+		__entry->tx_cleaned = tx_cleaned;
+		__entry->rx_clean_complete = rx_clean_complete;
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
+		  "budget %d bpr %d rx_cleaned %u tx_cleaned %u "
+		  "rx_clean_complete %d tx_clean_complete %d",
+		__get_str(dev_name), __get_str(qname), __entry->irq_num,
+		__get_bitmask(irq_affinity), __entry->curr_cpu, __entry->budget,
+		__entry->budget_per_ring, __entry->rx_cleaned, __entry->tx_cleaned,
+		__entry->rx_clean_complete, __entry->tx_clean_complete)
+);
+
 /* Events related to a vsi & ring */
 DECLARE_EVENT_CLASS(
 	i40e_tx_template,
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 5901e58..f2b1b94 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -2752,6 +2752,10 @@ int i40e_napi_poll(struct napi_struct *napi, int budget)
 			clean_complete = rx_clean_complete = false;
 	}
 
+	if (!i40e_enabled_xdp_vsi(vsi))
+		trace_i40e_napi_poll(napi, q_vector, budget, budget_per_ring, rx_cleaned,
+				     tx_cleaned, rx_clean_complete, tx_clean_complete);
+
 	/* If work not completed, return budget and polling will return */
 	if (!clean_complete) {
 		int cpu_id = smp_processor_id();
-- 
2.7.4


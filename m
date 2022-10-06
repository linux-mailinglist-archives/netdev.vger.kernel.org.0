Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7825F71FF
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 01:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232203AbiJFXo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 19:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232385AbiJFXot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 19:44:49 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10CB91BEAC
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 16:44:48 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id j71so3203854pge.2
        for <netdev@vger.kernel.org>; Thu, 06 Oct 2022 16:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GPTFsWXnUF1t4YsdsaSodcYPSmixZRIQrf+mhIR5IvA=;
        b=oziab/z1fFFEqKv5NdSoNc8530zFl92rhX5GvQ9/d1JQJ+GRFNG56yxPqi3TuqPD1T
         VtfHZ0AQ9FfZVLuR2dgvS32OsVJ9Zob9NpqmCAuKEa/IoozlhpYoZY3qisBvuet9C0mI
         gTzRf78h+Qvrb8J8nwgNmLQjmfpIPifJAS9AQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GPTFsWXnUF1t4YsdsaSodcYPSmixZRIQrf+mhIR5IvA=;
        b=HLDwGPv2PRwfind0J6lXy5Us/NKPdxdKqFO3S6Ivb12d0XjOgbvLFVlV9uE6Vov6/6
         DCNowhQhEhC4AKAF32QjcJf0IRRdvMAhdP8HLuFS5cN48uI3ySGpYAZjdZrU6tp+zJn1
         f3GX4n/K7Uf5mmJbUBSUty/do6eDLvUFO4KtoXfwc7SI2GToo/l3cwatwj36eas5o6Ht
         biYu+CcKl2PBwCiRkFXWL3iYgdUrLLZSworRvP9qZpzhbCGH7o68FX5Q613TZjAjpuMH
         /pMEzEatfyDGQdoxg7vXG5GJbHVkLZ3qArLPkm5p1RmrMvtA5KUNMrUtcAPj5K96zcD2
         eEVw==
X-Gm-Message-State: ACrzQf3TpWe3QyZib/v4D2U4eAqRjFB61+IZ2ULkwBQvZPoVVTj7FVqD
        lComNcgSOetHAdZpAnFnqalbSQ==
X-Google-Smtp-Source: AMsMyM55E19vOgYYzGx2uJq5Br5O2PAtKHWRUapQlvr12s7MkdtQa9BFXmom7F+FpWrUbkZ0lV0IKw==
X-Received: by 2002:a65:62c5:0:b0:434:d997:5848 with SMTP id m5-20020a6562c5000000b00434d9975848mr1896545pgv.603.1665099887388;
        Thu, 06 Oct 2022 16:44:47 -0700 (PDT)
Received: from localhost.localdomain (c-24-6-151-244.hsd1.ca.comcast.net. [24.6.151.244])
        by smtp.gmail.com with ESMTPSA id u4-20020a631404000000b0045935b12e97sm308124pgl.36.2022.10.06.16.44.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Oct 2022 16:44:46 -0700 (PDT)
From:   Joe Damato <jdamato@fastly.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        anthony.l.nguyen@intel.com, jesse.brandeburg@intel.com,
        maciej.fijalkowski@intel.com, Joe Damato <jdamato@fastly.com>
Subject: [next-queue v3 0/4] i40e: Add an i40e_napi_poll tracepoint
Date:   Thu,  6 Oct 2022 16:43:54 -0700
Message-Id: <1665099838-94839-1-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings:

Welcome to v3.

Debugging and tuning the NAPI and i40e NIC parameters can be a bit tricky
as there are many different options to test.

This change adds a tracepoint to i40e_napi_poll which exposes a lot of
helpful debug information for users who'd like to get a better
understanding of how their NIC is performing as they adjust various
parameters and tuning knobs.

With this series applied, you can use the tracepoint with perf by running:

$ sudo perf trace -e i40e:i40e_napi_poll -a --call-graph=fp --libtraceevent_print

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

The output is verbose, but is helpful when trying to determine the impact of
various turning parameters.

Thanks,
Joe

v2 -> v3:
	- Add an rx_clean_complete to the RX patch so that it can be output
	  in tracepoint instead of the valued of 'clean_complete' which can
	  be ambiguous (patch 3/4 was updated).
	- Update the tracepoint to swap 'clean_complete' with
	  'rx_clean_complete' (patch 4/4 was updated).

v1 -> v2:
	- TX path modified to push an out parameter through the function
	  call chain instead of modifying control flow.
	- RX path modified to also use an out parameter to track the number
	  of packets processed.
	- Naming of tracepoint struct members and format string modified to
	  be more readable.


Joe Damato (4):
  i40e: Store the irq number in i40e_q_vector
  i40e: Record number TXes cleaned during NAPI
  i40e: Record number of RXes cleaned during NAPI
  i40e: Add i40e_napi_poll tracepoint

 drivers/net/ethernet/intel/i40e/i40e.h       |  1 +
 drivers/net/ethernet/intel/i40e/i40e_main.c  |  1 +
 drivers/net/ethernet/intel/i40e/i40e_trace.h | 49 ++++++++++++++++++++++++++++
 drivers/net/ethernet/intel/i40e/i40e_txrx.c  | 33 ++++++++++++++-----
 drivers/net/ethernet/intel/i40e/i40e_xsk.c   | 21 +++++++++---
 drivers/net/ethernet/intel/i40e/i40e_xsk.h   |  6 ++--
 6 files changed, 95 insertions(+), 16 deletions(-)

-- 
2.7.4


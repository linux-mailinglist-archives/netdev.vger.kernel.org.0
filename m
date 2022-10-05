Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38F305F5B9E
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 23:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbiJEVWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 17:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbiJEVWv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 17:22:51 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82CB07E335
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 14:22:50 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id b15so8737117pje.1
        for <netdev@vger.kernel.org>; Wed, 05 Oct 2022 14:22:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=JNakE1w5IeFv8n3LGgBITtV5IyGP6gCrIGjrqiJR+sg=;
        b=s5tVBez4pTyRHbBsm067ooK9aedKv7SPMysMOcI3PYdRPNmT9Zn6iBAIwPTnmVIr54
         J1fr0ddOCBrUf0KDJQ+2YbHvv0PuuDweXCSIIYpn2QuDZtNXekOOj8kEvUfCY8+2T6UY
         HpMUI0MDVXO0sNhsZ9aiRnnQGeeP7WJzi7B4o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=JNakE1w5IeFv8n3LGgBITtV5IyGP6gCrIGjrqiJR+sg=;
        b=qsRGObj9u9oLiiueRbNQ7lOjkfyT3BSg4mqlhjrdKNcAjOaHIDfS9dthntDgcxbc6D
         EO9FzCIO2c4XyF7tYg9UUjwkiKO4k4pkLmh8U+bLk04ZI6qumaFXXZsHDlEqEmPZagR8
         Ne1uTeBTxz7gnc+fa82vy6JOqKahlwwjLHoZ0PsnXSkHvymh/NDyTkgqgZrqzn8Pu8eH
         6sS1NomCc/DLpJrna1Kb18Y4fcrUIJUBism8Hxya1Qgf/Ze5seDCCL3Zrm9PWKmuRDgb
         z5iCEw3TodINQ22BrZf8Tgfwcx1CO6dNZ612oHEqECZLEbDXJ5Q2hg/9glTWqs6GAX1n
         8YwQ==
X-Gm-Message-State: ACrzQf0jbp7SBkWnNA9MnJVcxhWoEn2aNRiR++8vGyLBq9tIVqlezDnR
        n0mOSUTybEB0zAS6tE37hUeXY6F/TpuE9w==
X-Google-Smtp-Source: AMsMyM6NXwuCsm3wdhLdy0GvRv5PrjAD+9x+Ksi9QoY2G0GS6VM+A12wgXHx68EoHE6NDzP3SFnHcQ==
X-Received: by 2002:a17:902:db11:b0:17d:5e67:c51c with SMTP id m17-20020a170902db1100b0017d5e67c51cmr1374699plx.64.1665004970019;
        Wed, 05 Oct 2022 14:22:50 -0700 (PDT)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id q12-20020a170902dacc00b0017f7b6e970esm2404666plx.146.2022.10.05.14.22.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Oct 2022 14:22:49 -0700 (PDT)
From:   Joe Damato <jdamato@fastly.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        anthony.l.nguyen@intel.com, jesse.brandeburg@intel.com,
        maciej.fijalkowski@intel.com, Joe Damato <jdamato@fastly.com>
Subject: [next-queue v2 0/4] i40e: Add an i40e_napi_poll tracepoint
Date:   Wed,  5 Oct 2022 14:21:49 -0700
Message-Id: <1665004913-25656-1-git-send-email-jdamato@fastly.com>
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
 drivers/net/ethernet/intel/i40e/i40e_txrx.c  | 30 ++++++++++++-----
 drivers/net/ethernet/intel/i40e/i40e_xsk.c   | 21 +++++++++---
 drivers/net/ethernet/intel/i40e/i40e_xsk.h   |  6 ++--
 6 files changed, 93 insertions(+), 15 deletions(-)

-- 
2.7.4


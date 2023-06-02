Return-Path: <netdev+bounces-7323-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 140CA71FA98
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 09:04:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A11F1C20C82
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 07:04:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 031FC5384;
	Fri,  2 Jun 2023 07:04:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60FA291C
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 07:04:37 +0000 (UTC)
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 037B3E71;
	Fri,  2 Jun 2023 00:04:28 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-64d24136685so1392452b3a.1;
        Fri, 02 Jun 2023 00:04:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685689468; x=1688281468;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Zx4FMc0sVk+rwjCWqO76VEczo14IYbRluwgeL4nENPs=;
        b=PmVs8Q7YIRLQab59Z5PrWLF8LtScAkyvxfEyncKDeQn0VgRQpcn+CzE6E1yxwc8/Ve
         entQ11T96eUdvRIKVjiR0rd/k53AmAUnKvx4UJmgaHAVki9p9Q5bLjLOeXyTjThQnsbQ
         q0rYzTgbzEdVZ0A2HFo8ZylTih6paODNKbLwI9HKvGMB+AmSfVuOua5ZmIUCVHpuM4HH
         cpqxhbwbJQXH/lqswAJjWjaAazXQo3NJ2MDip/1OZaCnsOGV5HftC7x9uahIMsdzScTh
         kN+vQ2zjk3WpuxZpkxFgDAHYx/b3jArKlZQ7fLjcgm/AXiS1rHWzGsYSF4zwN0YF7zao
         INpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685689468; x=1688281468;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zx4FMc0sVk+rwjCWqO76VEczo14IYbRluwgeL4nENPs=;
        b=QiAWDLZHsWmBPlW27NQ7ZveEfvPF6xPoajauv9Eu5ycLXRiQrLe+avSYCg57ZZFdpA
         amg+Jyz4euIFzfdciw9XDge93eLtE1ChG7FjayrkLEHnpJvlle9TtWGJ/1WG55C/qY8l
         GFrfShbwWAO++5Nbt68pM00CZm6ebZDwapdebtR5RVvsbPQOC+G3zdlz92XzjsLCqctx
         7a5a0kIyqtV0VuodjOOSbPUfcqN8UkmaY76CTo0DuxFrcuBtXPQbTMbchbUuRGWg/qNb
         hBGd+piREA8gDCFDaenOI4itiDfxjM0vo6t6MPNP9onaNLwhPUbrlG7j3jHuxFMD9ia9
         28xw==
X-Gm-Message-State: AC+VfDy7HhsVdI+T51PgqywTAqS5JBBr9mu3fTsBq5P3BGdBZ78AnD/u
	nsrfp/rvXTYWHK3bZntnAlQ=
X-Google-Smtp-Source: ACHHUZ4d2bX/UI/9TjW/+9fZety85pnDvoU1eN9s8tbpuQPK4d3S5wWBhLVhBjBL5PhUAvm4M56hKw==
X-Received: by 2002:a05:6a21:7891:b0:10a:eea0:6987 with SMTP id bf17-20020a056a21789100b0010aeea06987mr4999826pzc.26.1685689468352;
        Fri, 02 Jun 2023 00:04:28 -0700 (PDT)
Received: from dnptp-9.. ([111.198.57.33])
        by smtp.gmail.com with ESMTPSA id p30-20020a631e5e000000b00514256c05c2sm570259pgm.7.2023.06.02.00.04.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jun 2023 00:04:27 -0700 (PDT)
From: Yuezhen Luan <eggcar.luan@gmail.com>
To: jesse.brandeburg@intel.com,
	anthony.l.nguyen@intel.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: intel-wired-lan@lists.osuosl.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jacob.e.keller@intel.com,
	Yuezhen Luan <eggcar.luan@gmail.com>
Subject: [PATCHv3 net] igb: Fix extts capture value format for 82580/i354/i350
Date: Fri,  2 Jun 2023 07:04:22 +0000
Message-Id: <20230602070422.1808-1-eggcar.luan@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

82580/i354/i350 features circle-counter-like timestamp registers
that are different with newer i210. The EXTTS capture value in
AUXTSMPx should be converted from raw circle counter value to
timestamp value in resolution of 1 nanosec by the driver.

This issue can be reproduced on i350 nics, connecting an 1PPS
signal to a SDP pin, and run 'ts2phc' command to read external
1PPS timestamp value. On i210 this works fine, but on i350 the
extts is not correctly converted.

The i350/i354/82580's SYSTIM and other timestamp registers are
40bit counters, presenting time range of 2^40 ns, that means these
registers overflows every about 1099s. This causes all these regs
can't be used directly in contrast to the newer i210/i211s.

The igb driver needs to convert these raw register values to
valid time stamp format by using kernel timecounter apis for i350s
families. Here the igb_extts() just forgot to do the convert.

Fixes: 38970eac41db ("igb: support EXTTS on 82580/i354/i350")
Signed-off-by: Yuezhen Luan <eggcar.luan@gmail.com>
---
V2 -> V3: Add 'Fixes' tag, and add 'net' tag in patch title
V1 -> V2: Fix typo in the source code, and add detailed explanation

 drivers/net/ethernet/intel/igb/igb_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 58872a4c2..bb3db387d 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -6947,6 +6947,7 @@ static void igb_extts(struct igb_adapter *adapter, int tsintr_tt)
 	struct e1000_hw *hw = &adapter->hw;
 	struct ptp_clock_event event;
 	struct timespec64 ts;
+	unsigned long flags;
 
 	if (pin < 0 || pin >= IGB_N_SDP)
 		return;
@@ -6954,9 +6955,12 @@ static void igb_extts(struct igb_adapter *adapter, int tsintr_tt)
 	if (hw->mac.type == e1000_82580 ||
 	    hw->mac.type == e1000_i354 ||
 	    hw->mac.type == e1000_i350) {
-		s64 ns = rd32(auxstmpl);
+		u64 ns = rd32(auxstmpl);
 
-		ns += ((s64)(rd32(auxstmph) & 0xFF)) << 32;
+		ns += ((u64)(rd32(auxstmph) & 0xFF)) << 32;
+		spin_lock_irqsave(&adapter->tmreg_lock, flags);
+		ns = timecounter_cyc2time(&adapter->tc, ns);
+		spin_unlock_irqrestore(&adapter->tmreg_lock, flags);
 		ts = ns_to_timespec64(ns);
 	} else {
 		ts.tv_nsec = rd32(auxstmpl);
-- 
2.34.1



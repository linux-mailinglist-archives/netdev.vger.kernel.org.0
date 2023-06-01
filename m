Return-Path: <netdev+bounces-6955-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA7A471904C
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 03:59:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D67101C20FB5
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 01:59:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20DE91874;
	Thu,  1 Jun 2023 01:59:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 109F51842
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 01:59:52 +0000 (UTC)
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 950FFA3;
	Wed, 31 May 2023 18:59:51 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 41be03b00d2f7-53f70f7c2d2so130506a12.3;
        Wed, 31 May 2023 18:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685584791; x=1688176791;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Jdxxh2L1GD1WdZkYYziFAmyUtgwXwDB1emmhtFEA2sM=;
        b=Oih3AhNmb0cusPW/ZitzBoCgoGC9evQgOEor7/GXLLHcV2qvdgZW2RWLChJ/xN7MaB
         t1zaNsQdUfHkCeeYPV1IugTm5maq28JVw3Y6fGEdVeEzkiSApOaB3ofagN1IR7EB4pkI
         9ur+SucXtYGfu/pAVhVRdPPq2p0udQme+keM6rPYgdH8kAevZubYO6aUhjpEcSUapXTR
         uokZ9DTzTWeqp1h466cWiHfX8f7voZGZLJVUEnGTmjePdl64svrWQPTODffe3VwuEeCP
         aCleDFmHNfiEFeZX+GJyVPEx9X9KkO8mRNVezGoK7QwpJ9xdFq6c4+KqBJQ0P4qqr71w
         BRmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685584791; x=1688176791;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Jdxxh2L1GD1WdZkYYziFAmyUtgwXwDB1emmhtFEA2sM=;
        b=d3t+KHwlWpEwO0rmTagzowZ6BIaXYRuGtB2j0vf6I0NU3J0QEaDOEM19DCovxt8UB9
         Rj8yM/jbw2/ck51SbbjhXOXXJT1mwirEmY7rK40UeCgltfDEBqZ7F5AJRehHv/79Yarx
         0rYPy89QYP6PWIaTU5uugVcMLdTE24QyvJqxQy3gGkqvrHyeWIU+NCuexVyPXYcuC39Y
         EFX8GHO0Ie8hyfmW2EHkdbwu066qRWzJb5kvqrg9XOq5EXZ18Ul93gSXG3258XTVrvJR
         8941y2xDte9EGh/stoqhX/ySOVn1pcyiQQCd7bJkB/3C19KTT5OoVfFFSC7m0oG4Kh82
         XKPQ==
X-Gm-Message-State: AC+VfDzpxxdZohkyPWgBXewL2LIt26pGmZBDATrb489VUzdvODthyspv
	+zLop8JtHsioWuMH4tqpYIk=
X-Google-Smtp-Source: ACHHUZ7ZFmpjxk6hnAAfSXhlZcWQV0HmU+rN1vBZNd7ozRoimzKvZknP67nyT/0Ui5qaytH93QtCww==
X-Received: by 2002:a17:90a:c20d:b0:256:44f3:35e2 with SMTP id e13-20020a17090ac20d00b0025644f335e2mr5834673pjt.4.1685584790967;
        Wed, 31 May 2023 18:59:50 -0700 (PDT)
Received: from dnptp-9.. ([111.198.57.33])
        by smtp.gmail.com with ESMTPSA id k59-20020a17090a4cc100b0024df7d7c35esm189547pjh.43.2023.05.31.18.59.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 May 2023 18:59:50 -0700 (PDT)
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
Subject: [PATCH] igb: Fix extts capture value format for 82580/i354/i350
Date: Thu,  1 Jun 2023 01:59:43 +0000
Message-Id: <20230601015943.1815-1-eggcar.luan@gmail.com>
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

Signed-off-by: Yuezhen Luan <eggcar.luan@gmail.com>
---
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



Return-Path: <netdev+bounces-6735-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C320E717B4F
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 11:08:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0E0B6281346
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 09:08:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BC39C130;
	Wed, 31 May 2023 09:08:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FCF17E1
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 09:08:45 +0000 (UTC)
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6F8D135;
	Wed, 31 May 2023 02:08:18 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-64d57cd373fso524838b3a.1;
        Wed, 31 May 2023 02:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685524092; x=1688116092;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zNY4EKzfKsAn+Tw0pdU/DlskQLBEcbNUP9B//ABNXKo=;
        b=HVxqm7U5R6Ltzm1U6CfDIcHedKqA6ItNj4qNL9ntOHlC4ImTd6w5SkwEOrZTodpQPo
         8LFcVzQ91JtjMgezIC5DAmUPiOuPJXDAluOkF4Yrvc/MhHho1PMHzgrqlHVP8ddXIaN/
         B/87YpqBufsonhciCiywd4e7BLiWbe8hgByfmxTfy79XwvuniUAJyB7BbAEVNgq9ECWX
         dRq7vW3bon4Y9CCwefhthtdPAxsW0Q2Tk9SSwREhhJa/IkOZKwYk5Wbu95qG53n3viYu
         al22pDkTECcvdGLTfVjQg4GSCmpq7sFlntIAXzi+t3kPZOBQCAfsn6A1EPP7pVZkHp0w
         ow9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685524092; x=1688116092;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zNY4EKzfKsAn+Tw0pdU/DlskQLBEcbNUP9B//ABNXKo=;
        b=L+w9DvSj9PkoORWI56nXRChJ4TOuu5kODpO54o7vtaVaC18v1RFUHqznb3KA6ZTyVl
         3PdaOSls0niMfQCOgROOM4rsqH3+e+T04zrDDNtaqQ/CgU97gatPkIxJUlIadYlFM8Y+
         h22L9Fie9ok204G6iHOHJzQ+SpH1/UeM0JSpGPBd1eRhHYY4c58of7adgz8s5yxWmORn
         vMbzBo3JMWQOYLyQKSEJSMrZVLu2c4gsme2lptrpaBKdw9g7/faGScmoTJX3OERrWRsm
         4SCcuS2xkCN0Lb3xF0+kqXajFJ2E/skoHNf1QiuUKiD7JwDNuDM3ZIMAcuxNZhBPwFoT
         yvuA==
X-Gm-Message-State: AC+VfDzVXSHAL2rtQM1BO7/Dr+tMV4C4qkiGXTR5Bd6Be2UUa8nRNrRr
	QUWBwx2hDbUvdXhZU/iRLDA=
X-Google-Smtp-Source: ACHHUZ7PlcGg25hqG5yK0pvujwaiLLSRqp1UCGBgYjGU+csBEfyU/PrJhHHWONWkARerQcIF7Cqqow==
X-Received: by 2002:a17:903:120b:b0:1af:e10f:ba96 with SMTP id l11-20020a170903120b00b001afe10fba96mr5564993plh.1.1685524092348;
        Wed, 31 May 2023 02:08:12 -0700 (PDT)
Received: from dnptp-9.. ([111.198.57.33])
        by smtp.gmail.com with ESMTPSA id ij17-20020a170902ab5100b001ae4e8e8edasm857822plb.18.2023.05.31.02.08.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 May 2023 02:08:12 -0700 (PDT)
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
Date: Wed, 31 May 2023 09:08:05 +0000
Message-Id: <20230531090805.3959-1-eggcar.luan@gmail.com>
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
index 58872a4c2..187daa8ef 100644
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
+		spin_lock_irqsave(&adapter->tc, ns);
+		ns = timecounter_cyc2time(&adapter->tc, ns);
+		spin_unlock_irqrestore(&adapter->tc, ns);
 		ts = ns_to_timespec64(ns);
 	} else {
 		ts.tv_nsec = rd32(auxstmpl);
-- 
2.34.1



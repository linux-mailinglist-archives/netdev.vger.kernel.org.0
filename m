Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 927A6266AB2
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 00:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725910AbgIKWAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 18:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725846AbgIKWAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 18:00:35 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4147FC061573;
        Fri, 11 Sep 2020 15:00:34 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id n25so13689943ljj.4;
        Fri, 11 Sep 2020 15:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aEgWM0r5trDxYSVZugmm4kVCes2l5cIV/KtzSzEdKs8=;
        b=QPThOWpmoTeN+/VzCdTyY2AxRP6XR0kodivTJH9kX/DHLx6SugAlfBl4MWNjOPaF9a
         Ktn1m/LB4CMHl1xZHwZa94fO3G64zhkne/UeAFVxnAVkGFVwSDMYFLcPsNp9TXtH9OWC
         Jo3nIskbIqjz0Vxqms4AXMVEd2C+yMyrpiU56GqSBx1g9MR0WHIIVWZYt/6PRJBJpvd1
         348OAGUifELBi6bRfxBh5KF1N+2lTrn2ryU5v+48Kr5DAxmrL9NlqYzlKksLG+aP/dL5
         +zBlG+WedPkBmukpTrMDN5J8W8Qp/dT9cj9OMFuFw6wN2YuYMb7Imhj9xGbnDpGkVRql
         Sn3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aEgWM0r5trDxYSVZugmm4kVCes2l5cIV/KtzSzEdKs8=;
        b=DJX7PA8LxcrhzVMBIbXTrJME5DrMStmZa8eJwS02VESkuX/6pVs/zlINvcPbX0cjjy
         mpqFNisDR1fdmBjrFIXywfGcGybFfxhS4mnCXFaM7fNaodCH/9IT8XMdPPkrvKD1YIpE
         lqk8l8rJKu4zX5rGait783vkR8yrtBPl3ZFOmR59XFSNUPa0lzTLolOOpRIAmoZKfK5F
         +nqGUxnwkNpcLtpCjKdNda3hpYUpIZuQcP3mF/Q2cCzG81p6BP7jGep03TVFfH5+ESmA
         yI4qp8zXb9UFkIFlYaZ6ulmDqBkOq9ExvA0t2yHGdpVxFISfavSMkx3njyQDt/e+maLn
         PBmA==
X-Gm-Message-State: AOAM531LvDrn4MDh81hQzwccNX3tn1yczv9+RL/cb63TGsKJ9/S6jkCh
        B28FBPgTJl0VjRRiwECY6kw=
X-Google-Smtp-Source: ABdhPJwaQ1zNtGFUUMSerl15iT5BaTZTabcPeauEEEe3mqogKMt0WDbzttjo9xpMC0WWtzByMd1DJQ==
X-Received: by 2002:a2e:92cb:: with SMTP id k11mr1438939ljh.163.1599861630076;
        Fri, 11 Sep 2020 15:00:30 -0700 (PDT)
Received: from localhost.localdomain (h-82-196-111-59.NA.cust.bahnhof.se. [82.196.111.59])
        by smtp.gmail.com with ESMTPSA id k10sm688507lja.112.2020.09.11.15.00.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 15:00:29 -0700 (PDT)
From:   Rikard Falkeborn <rikard.falkeborn@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Jerin Jacob <jerinj@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>
Subject: [PATCH net-next] octeontx2-af: Constify npc_kpu_profile_{action,cam}
Date:   Sat, 12 Sep 2020 00:00:15 +0200
Message-Id: <20200911220015.41830-1-rikard.falkeborn@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are never modified, so constify them to allow the compiler to
place them in read-only memory. This moves about 25kB to read-only
memory as seen by the output of the size command.

Before:
   text    data     bss     dec     hex filename
 296203   65464    1248  362915   589a3 drivers/net/ethernet/marvell/octeontx2/af/octeontx2_af.ko

After:
   text    data     bss     dec     hex filename
 321003   40664    1248  362915   589a3 drivers/net/ethernet/marvell/octeontx2/af/octeontx2_af.ko

Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
---
 .../net/ethernet/marvell/octeontx2/af/npc.h   |  4 +-
 .../marvell/octeontx2/af/npc_profile.h        | 68 +++++++++----------
 .../ethernet/marvell/octeontx2/af/rvu_npc.c   |  6 +-
 3 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc.h b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
index 3803af9231c6..95c646ae7e23 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
@@ -173,8 +173,8 @@ struct npc_kpu_profile_action {
 struct npc_kpu_profile {
 	int cam_entries;
 	int action_entries;
-	struct npc_kpu_profile_cam *cam;
-	struct npc_kpu_profile_action *action;
+	const struct npc_kpu_profile_cam *cam;
+	const struct npc_kpu_profile_action *action;
 };
 
 /* NPC KPU register formats */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
index aa2727e6211a..b29c6689ace2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
@@ -418,7 +418,7 @@ enum NPC_ERRLEV_E {
 	NPC_ERRLEV_ENUM_LAST = 16,
 };
 
-static struct npc_kpu_profile_action ikpu_action_entries[] = {
+static const struct npc_kpu_profile_action ikpu_action_entries[] = {
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		12, 16, 20, 0, 0,
@@ -997,7 +997,7 @@ static struct npc_kpu_profile_action ikpu_action_entries[] = {
 	},
 };
 
-static struct npc_kpu_profile_cam kpu1_cam_entries[] = {
+static const struct npc_kpu_profile_cam kpu1_cam_entries[] = {
 	{
 		NPC_S_KPU1_ETHER, 0xff,
 		NPC_ETYPE_IP,
@@ -1666,7 +1666,7 @@ static struct npc_kpu_profile_cam kpu1_cam_entries[] = {
 	},
 };
 
-static struct npc_kpu_profile_cam kpu2_cam_entries[] = {
+static const struct npc_kpu_profile_cam kpu2_cam_entries[] = {
 	{
 		NPC_S_KPU2_CTAG, 0xff,
 		NPC_ETYPE_IP,
@@ -2794,7 +2794,7 @@ static struct npc_kpu_profile_cam kpu2_cam_entries[] = {
 	},
 };
 
-static struct npc_kpu_profile_cam kpu3_cam_entries[] = {
+static const struct npc_kpu_profile_cam kpu3_cam_entries[] = {
 	{
 		NPC_S_KPU3_CTAG, 0xff,
 		NPC_ETYPE_IP,
@@ -3913,7 +3913,7 @@ static struct npc_kpu_profile_cam kpu3_cam_entries[] = {
 	},
 };
 
-static struct npc_kpu_profile_cam kpu4_cam_entries[] = {
+static const struct npc_kpu_profile_cam kpu4_cam_entries[] = {
 	{
 		NPC_S_KPU4_MPLS, 0xff,
 		NPC_MPLS_S,
@@ -4006,7 +4006,7 @@ static struct npc_kpu_profile_cam kpu4_cam_entries[] = {
 	},
 };
 
-static struct npc_kpu_profile_cam kpu5_cam_entries[] = {
+static const struct npc_kpu_profile_cam kpu5_cam_entries[] = {
 	{
 		NPC_S_KPU5_IP, 0xff,
 		0x0000,
@@ -4576,7 +4576,7 @@ static struct npc_kpu_profile_cam kpu5_cam_entries[] = {
 	},
 };
 
-static struct npc_kpu_profile_cam kpu6_cam_entries[] = {
+static const struct npc_kpu_profile_cam kpu6_cam_entries[] = {
 	{
 		NPC_S_KPU6_IP6_EXT, 0xff,
 		0x0000,
@@ -4921,7 +4921,7 @@ static struct npc_kpu_profile_cam kpu6_cam_entries[] = {
 	},
 };
 
-static struct npc_kpu_profile_cam kpu7_cam_entries[] = {
+static const struct npc_kpu_profile_cam kpu7_cam_entries[] = {
 	{
 		NPC_S_KPU7_IP6_EXT, 0xff,
 		0x0000,
@@ -5140,7 +5140,7 @@ static struct npc_kpu_profile_cam kpu7_cam_entries[] = {
 	},
 };
 
-static struct npc_kpu_profile_cam kpu8_cam_entries[] = {
+static const struct npc_kpu_profile_cam kpu8_cam_entries[] = {
 	{
 		NPC_S_KPU8_TCP, 0xff,
 		0x0000,
@@ -5872,7 +5872,7 @@ static struct npc_kpu_profile_cam kpu8_cam_entries[] = {
 	},
 };
 
-static struct npc_kpu_profile_cam kpu9_cam_entries[] = {
+static const struct npc_kpu_profile_cam kpu9_cam_entries[] = {
 	{
 		NPC_S_KPU9_TU_MPLS_IN_GRE, 0xff,
 		NPC_MPLS_S,
@@ -6334,7 +6334,7 @@ static struct npc_kpu_profile_cam kpu9_cam_entries[] = {
 	},
 };
 
-static struct npc_kpu_profile_cam kpu10_cam_entries[] = {
+static const struct npc_kpu_profile_cam kpu10_cam_entries[] = {
 	{
 		NPC_S_KPU10_TU_MPLS, 0xff,
 		NPC_MPLS_S,
@@ -6499,7 +6499,7 @@ static struct npc_kpu_profile_cam kpu10_cam_entries[] = {
 	},
 };
 
-static struct npc_kpu_profile_cam kpu11_cam_entries[] = {
+static const struct npc_kpu_profile_cam kpu11_cam_entries[] = {
 	{
 		NPC_S_KPU11_TU_ETHER, 0xff,
 		NPC_ETYPE_IP,
@@ -6808,7 +6808,7 @@ static struct npc_kpu_profile_cam kpu11_cam_entries[] = {
 	},
 };
 
-static struct npc_kpu_profile_cam kpu12_cam_entries[] = {
+static const struct npc_kpu_profile_cam kpu12_cam_entries[] = {
 	{
 		NPC_S_KPU12_TU_IP, 0xff,
 		NPC_IPNH_TCP,
@@ -7063,7 +7063,7 @@ static struct npc_kpu_profile_cam kpu12_cam_entries[] = {
 	},
 };
 
-static struct npc_kpu_profile_cam kpu13_cam_entries[] = {
+static const struct npc_kpu_profile_cam kpu13_cam_entries[] = {
 	{
 		NPC_S_KPU13_TU_IP6_EXT, 0xff,
 		0x0000,
@@ -7075,7 +7075,7 @@ static struct npc_kpu_profile_cam kpu13_cam_entries[] = {
 	},
 };
 
-static struct npc_kpu_profile_cam kpu14_cam_entries[] = {
+static const struct npc_kpu_profile_cam kpu14_cam_entries[] = {
 	{
 		NPC_S_KPU14_TU_IP6_EXT, 0xff,
 		0x0000,
@@ -7087,7 +7087,7 @@ static struct npc_kpu_profile_cam kpu14_cam_entries[] = {
 	},
 };
 
-static struct npc_kpu_profile_cam kpu15_cam_entries[] = {
+static const struct npc_kpu_profile_cam kpu15_cam_entries[] = {
 	{
 		NPC_S_KPU15_TU_TCP, 0xff,
 		0x0000,
@@ -7288,7 +7288,7 @@ static struct npc_kpu_profile_cam kpu15_cam_entries[] = {
 	},
 };
 
-static struct npc_kpu_profile_cam kpu16_cam_entries[] = {
+static const struct npc_kpu_profile_cam kpu16_cam_entries[] = {
 	{
 		NPC_S_KPU16_TCP_DATA, 0xff,
 		0x0000,
@@ -7345,7 +7345,7 @@ static struct npc_kpu_profile_cam kpu16_cam_entries[] = {
 	},
 };
 
-static struct npc_kpu_profile_action kpu1_action_entries[] = {
+static const struct npc_kpu_profile_action kpu1_action_entries[] = {
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		8, 0, 6, 3, 0,
@@ -7962,7 +7962,7 @@ static struct npc_kpu_profile_action kpu1_action_entries[] = {
 	},
 };
 
-static struct npc_kpu_profile_action kpu2_action_entries[] = {
+static const struct npc_kpu_profile_action kpu2_action_entries[] = {
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		8, 0, 6, 2, 0,
@@ -8965,7 +8965,7 @@ static struct npc_kpu_profile_action kpu2_action_entries[] = {
 	},
 };
 
-static struct npc_kpu_profile_action kpu3_action_entries[] = {
+static const struct npc_kpu_profile_action kpu3_action_entries[] = {
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		8, 0, 6, 1, 0,
@@ -9960,7 +9960,7 @@ static struct npc_kpu_profile_action kpu3_action_entries[] = {
 	},
 };
 
-static struct npc_kpu_profile_action kpu4_action_entries[] = {
+static const struct npc_kpu_profile_action kpu4_action_entries[] = {
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		0, 0, 0, 0, 0,
@@ -10043,7 +10043,7 @@ static struct npc_kpu_profile_action kpu4_action_entries[] = {
 	},
 };
 
-static struct npc_kpu_profile_action kpu5_action_entries[] = {
+static const struct npc_kpu_profile_action kpu5_action_entries[] = {
 	{
 		NPC_ERRLEV_LC, NPC_EC_IP_TTL_0,
 		0, 0, 0, 0, 1,
@@ -10550,7 +10550,7 @@ static struct npc_kpu_profile_action kpu5_action_entries[] = {
 	},
 };
 
-static struct npc_kpu_profile_action kpu6_action_entries[] = {
+static const struct npc_kpu_profile_action kpu6_action_entries[] = {
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		0, 0, 0, 0, 1,
@@ -10857,7 +10857,7 @@ static struct npc_kpu_profile_action kpu6_action_entries[] = {
 	},
 };
 
-static struct npc_kpu_profile_action kpu7_action_entries[] = {
+static const struct npc_kpu_profile_action kpu7_action_entries[] = {
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		0, 0, 0, 0, 1,
@@ -11052,7 +11052,7 @@ static struct npc_kpu_profile_action kpu7_action_entries[] = {
 	},
 };
 
-static struct npc_kpu_profile_action kpu8_action_entries[] = {
+static const struct npc_kpu_profile_action kpu8_action_entries[] = {
 	{
 		NPC_ERRLEV_LD, NPC_EC_TCP_FLAGS_FIN_ONLY,
 		0, 0, 0, 0, 1,
@@ -11703,7 +11703,7 @@ static struct npc_kpu_profile_action kpu8_action_entries[] = {
 	},
 };
 
-static struct npc_kpu_profile_action kpu9_action_entries[] = {
+static const struct npc_kpu_profile_action kpu9_action_entries[] = {
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		0, 0, 0, 0, 0,
@@ -12114,7 +12114,7 @@ static struct npc_kpu_profile_action kpu9_action_entries[] = {
 	},
 };
 
-static struct npc_kpu_profile_action kpu10_action_entries[] = {
+static const struct npc_kpu_profile_action kpu10_action_entries[] = {
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		8, 0, 6, 1, 0,
@@ -12261,7 +12261,7 @@ static struct npc_kpu_profile_action kpu10_action_entries[] = {
 	},
 };
 
-static struct npc_kpu_profile_action kpu11_action_entries[] = {
+static const struct npc_kpu_profile_action kpu11_action_entries[] = {
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		8, 0, 6, 0, 0,
@@ -12536,7 +12536,7 @@ static struct npc_kpu_profile_action kpu11_action_entries[] = {
 	},
 };
 
-static struct npc_kpu_profile_action kpu12_action_entries[] = {
+static const struct npc_kpu_profile_action kpu12_action_entries[] = {
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		2, 12, 0, 2, 0,
@@ -12763,7 +12763,7 @@ static struct npc_kpu_profile_action kpu12_action_entries[] = {
 	},
 };
 
-static struct npc_kpu_profile_action kpu13_action_entries[] = {
+static const struct npc_kpu_profile_action kpu13_action_entries[] = {
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		0, 0, 0, 0, 1,
@@ -12774,7 +12774,7 @@ static struct npc_kpu_profile_action kpu13_action_entries[] = {
 	},
 };
 
-static struct npc_kpu_profile_action kpu14_action_entries[] = {
+static const struct npc_kpu_profile_action kpu14_action_entries[] = {
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		0, 0, 0, 0, 1,
@@ -12785,7 +12785,7 @@ static struct npc_kpu_profile_action kpu14_action_entries[] = {
 	},
 };
 
-static struct npc_kpu_profile_action kpu15_action_entries[] = {
+static const struct npc_kpu_profile_action kpu15_action_entries[] = {
 	{
 		NPC_ERRLEV_LG, NPC_EC_TCP_FLAGS_FIN_ONLY,
 		0, 0, 0, 0, 1,
@@ -12964,7 +12964,7 @@ static struct npc_kpu_profile_action kpu15_action_entries[] = {
 	},
 };
 
-static struct npc_kpu_profile_action kpu16_action_entries[] = {
+static const struct npc_kpu_profile_action kpu16_action_entries[] = {
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		0, 0, 0, 0, 1,
@@ -13015,7 +13015,7 @@ static struct npc_kpu_profile_action kpu16_action_entries[] = {
 	},
 };
 
-static struct npc_kpu_profile npc_kpu_profiles[] = {
+static const struct npc_kpu_profile npc_kpu_profiles[] = {
 	{
 		ARRAY_SIZE(kpu1_cam_entries),
 		ARRAY_SIZE(kpu1_action_entries),
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index e2e585d4de9b..6a1ddb2da1a5 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -906,7 +906,7 @@ static void npc_load_mkex_profile(struct rvu *rvu, int blkaddr)
 }
 
 static void npc_config_kpuaction(struct rvu *rvu, int blkaddr,
-				 struct npc_kpu_profile_action *kpuaction,
+				 const struct npc_kpu_profile_action *kpuaction,
 				 int kpu, int entry, bool pkind)
 {
 	struct npc_kpu_action0 action0 = {0};
@@ -948,7 +948,7 @@ static void npc_config_kpuaction(struct rvu *rvu, int blkaddr,
 }
 
 static void npc_config_kpucam(struct rvu *rvu, int blkaddr,
-			      struct npc_kpu_profile_cam *kpucam,
+			      const struct npc_kpu_profile_cam *kpucam,
 			      int kpu, int entry)
 {
 	struct npc_kpu_cam cam0 = {0};
@@ -976,7 +976,7 @@ static inline u64 enable_mask(int count)
 }
 
 static void npc_program_kpu_profile(struct rvu *rvu, int blkaddr, int kpu,
-				    struct npc_kpu_profile *profile)
+				    const struct npc_kpu_profile *profile)
 {
 	int entry, num_entries, max_entries;
 
-- 
2.28.0


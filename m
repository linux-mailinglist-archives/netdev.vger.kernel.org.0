Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3DC268790
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 10:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgINIuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 04:50:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgINIuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 04:50:10 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28AE3C061353
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 01:50:09 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id s13so9806931wmh.4
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 01:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=monstr-eu.20150623.gappssmtp.com; s=20150623;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6RihlPiUoKJ5dO8u5VgwLil1hFKYQdPZrQdkm6dxH7U=;
        b=OGWWk4oUqeZhemDzsBit+3ybTzgLDKa8+inPhCSBdmqT0VzUjdt473bbAx3PXD/Me1
         eom9s9PKN5pOuPDzFY8AmNEoCYJLd74DOxySWtNOyilvYNdjkPP9vo2ruWNm2vZzzLwc
         clrzILcPcXnV9H59MtGhVLK9Q3XhKSWhFpes4vKRRbtz1Ujtg943pwlv3IOxo4PawCsA
         wFlI3O3k5pELJnuaLXjy1AocjNWv277s1Z7ijKfV7B8NMJefnKlW5XwzMPckNmVoAcDa
         MHjzDGi6vpv4Pd0z8TG8BIYNFAwiOvw3crmxTlPMJ8DAudVkWC6dooPf1kpLi9WwgHfs
         KZ7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=6RihlPiUoKJ5dO8u5VgwLil1hFKYQdPZrQdkm6dxH7U=;
        b=MsumMn7BTC4ZvMljgZ1vaZV2s8t0JhpY7gV75rP8mrfMTymwEnCR50G4F8w15J0AJF
         F/m2Eo3MDgKMDJPPiNVE/RMlx38GyI8HDFaIJkyPPSHxp8dtmgoaPx5a/KBIKgFjfU2i
         h5M+FfI/WtEqLydYjxSL7nD8w8YT8qckfMCS5ppcTtQ59Mtg2TvLTjPjFfd70BLFdd/i
         Bnh+agNwpMbs8wRVQX3ehmhtxF9UedR7rvj1dtAt9O0Xd3OoEoPzl5JIEcUL9zP4T7ze
         UNeM3aKY8fFYQLCVecKqDZ3fHNmn7uR/Oi0i8b63DQPuIb1A7fudx7/sTU33+eLC0Spw
         KuWg==
X-Gm-Message-State: AOAM533hhqknhuK4PG6WbJE3F3h8nIR7JYrP6QEdRfxsHHGtFKWhnOdj
        p8RBdi0JP4xBYo2bfMp6SuYjPY9yMOdOzg==
X-Google-Smtp-Source: ABdhPJwdaqg5f5Kke+vMgGPevV790jo7Y8/D5K3C8rI0hjcUYSusmPhaIAH2G6dWHFzgQjwy7rM1wA==
X-Received: by 2002:a1c:750d:: with SMTP id o13mr11267961wmc.54.1600073405221;
        Mon, 14 Sep 2020 01:50:05 -0700 (PDT)
Received: from localhost (nat-35.starnet.cz. [178.255.168.35])
        by smtp.gmail.com with ESMTPSA id q12sm18980386wrs.48.2020.09.14.01.50.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 14 Sep 2020 01:50:04 -0700 (PDT)
From:   Michal Simek <michal.simek@xilinx.com>
To:     linux-kernel@vger.kernel.org, monstr@monstr.eu,
        michal.simek@xilinx.com, git@xilinx.com
Cc:     Srinivas Neeli <srinivas.neeli@xilinx.com>,
        Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-arm-kernel@lists.infradead.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 1/3] can: xilinx_can: Limit CANFD brp to 2
Date:   Mon, 14 Sep 2020 10:49:56 +0200
Message-Id: <bca871d7f3ca9c653d50e63c5b60028f2bdf3fb0.1600073396.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1600073396.git.michal.simek@xilinx.com>
References: <cover.1600073396.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Srinivas Neeli <srinivas.neeli@xilinx.com>

Bit enlarging is observed for CANFD2.0 when brp is 1,
So change brp_min value to 2.

Signed-off-by: Srinivas Neeli <srinivas.neeli@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

 drivers/net/can/xilinx_can.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index c1dbab8c896d..f4b544b69646 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -259,7 +259,7 @@ static const struct can_bittiming_const xcan_bittiming_const_canfd2 = {
 	.tseg2_min = 1,
 	.tseg2_max = 128,
 	.sjw_max = 128,
-	.brp_min = 1,
+	.brp_min = 2,
 	.brp_max = 256,
 	.brp_inc = 1,
 };
@@ -272,7 +272,7 @@ static struct can_bittiming_const xcan_data_bittiming_const_canfd2 = {
 	.tseg2_min = 1,
 	.tseg2_max = 16,
 	.sjw_max = 16,
-	.brp_min = 1,
+	.brp_min = 2,
 	.brp_max = 256,
 	.brp_inc = 1,
 };
-- 
2.28.0


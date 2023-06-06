Return-Path: <netdev+bounces-8499-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CA9D7724522
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 16:00:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0C2671C20B3B
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 14:00:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1BB52D25A;
	Tue,  6 Jun 2023 14:00:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D807137B71
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 14:00:50 +0000 (UTC)
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA4DB198B
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 07:00:44 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-bac6a453dd5so7157035276.2
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 07:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686060043; x=1688652043;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=S6bABvrmsSInWb8fnuh4ITkDJEvWLg0D4R3//Td0SQE=;
        b=kEgWoJ49N2whPXRJaq/b8YUNnuy53VuV4VogxQBdtVGh7K6G2usK2oAdAsNXkCEyVj
         MNZF1nOPM0Zw0jMJziXYNV8bNHqxGz2Dxo990m13oURN+iYndqqrVQ/i4ZnLgPXtzhiL
         54HwrLuHd8Wgi9mcroDbDvi7VsZop9AkynLKTIsoAChiyBp/Z/eA6/SdGJSXNyZnySV+
         NE8oJitgXuLzbzPYX+BlJhZy4VWABtlvzYPRWiisKqLOjtRlwko27m8LgY6C09gIcMsG
         okHpEkKiYa8ETBqpurh2HSOXb5fI7TwXwAuIbRIOx/YvixnOnYukV0YmpuFP2cAxCItP
         LHEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686060043; x=1688652043;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S6bABvrmsSInWb8fnuh4ITkDJEvWLg0D4R3//Td0SQE=;
        b=ODVR0d+soDAAuVvRbXTHpHPTcUERZtwBtheaDri3pByDk1MpWTHAjtVeQ9UNWonpVz
         ftu36Lp3gaAJPk3R3IeRLIeN3O8JcBef9hqhSHyHgUtqZyYX9FJe5khbQfWP9ua6B599
         CVm4b+nRn0qbk5F127OPeeUaDRRXLp0eDIGjtFHG8LMNkVGt8G1L3SdEgELYmZiIFj/Q
         x6z5FT8pXlz0rRb8O2KOvZbo2jY3FOf8aXY0U5w/zh8yAe4s+snPCar1srRYNf6cbpoX
         sTOtEUO21fy6GykKryrkHcdAD2/rG4dmWWYDukXl3HMlDHPTwxEaSbhyRMCpk7SArgju
         B9kQ==
X-Gm-Message-State: AC+VfDzwryb4qXbIL2wi5mbs/qXutWABsphinycFzSxMiD8IiEqd7dCD
	VyabJLAFmoIcnCW7W83IngLKItg=
X-Google-Smtp-Source: ACHHUZ52QT/eB8BKHEzn6E94GeOQS/r0FOgsbZh9T/CpgqQyCi2PdRDg7H6Yi8ImeRi6e7th9vZJykg=
X-Received: from ptf16.nyc.corp.google.com ([2620:0:1003:314:f52a:f978:3766:4700])
 (user=ptf job=sendgmr) by 2002:a25:e6d6:0:b0:ba7:5d7a:b50d with SMTP id
 d205-20020a25e6d6000000b00ba75d7ab50dmr1144964ybh.10.1686060043589; Tue, 06
 Jun 2023 07:00:43 -0700 (PDT)
Date: Tue,  6 Jun 2023 10:00:36 -0400
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230606140041.3244713-1-ptf@google.com>
Subject: [PATCH] r8169: Disable multicast filter for RTL_GIGA_MAC_VER_46
From: Patrick Thompson <ptf@google.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Patrick Thompson <ptf@google.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Heiner Kallweit <hkallweit1@gmail.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org, 
	nic_swsd@realtek.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

MAC_VER_46 ethernet adapters fail to detect IPv6 multicast packets
unless allmulti is enabled. Add exception for VER_46 in the same way
VER_35 has an exception.

Signed-off-by: Patrick Thompson <ptf@google.com>
---

 drivers/net/ethernet/realtek/r8169_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 4b19803a7dd01..96245e96ee507 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2583,7 +2583,8 @@ static void rtl_set_rx_mode(struct net_device *dev)
 		rx_mode |= AcceptAllPhys;
 	} else if (netdev_mc_count(dev) > MC_FILTER_LIMIT ||
 		   dev->flags & IFF_ALLMULTI ||
-		   tp->mac_version == RTL_GIGA_MAC_VER_35) {
+		   tp->mac_version == RTL_GIGA_MAC_VER_35 ||
+		   tp->mac_version == RTL_GIGA_MAC_VER_46) {
 		/* accept all multicasts */
 	} else if (netdev_mc_empty(dev)) {
 		rx_mode &= ~AcceptMulticast;
-- 
2.41.0.rc0.172.g3f132b7071-goog



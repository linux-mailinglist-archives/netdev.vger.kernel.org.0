Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 550EC46867C
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 18:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377558AbhLDRRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 12:17:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345154AbhLDRRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 12:17:52 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D0CC061751;
        Sat,  4 Dec 2021 09:14:26 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id d9so12798813wrw.4;
        Sat, 04 Dec 2021 09:14:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/cksNdFZj9IWFAKVJL2S+JO52BCjhptq1rRTsh39hwU=;
        b=hDkp38Hh5EL0JAbauIY7IrYLaUFIMb2J4WxSWavCR0/NMFUkQswvhavyBvH0Xhmr65
         hT646y40uhe90P6mM9+QwIF0UgGfQhtPf7M9HH8prcEgoduOae0QeHKbuOF+2SzQpUKE
         LWdbd3HfEbQzzu/k1Z8Ot2PeTPSOztxBWbpDticprF7d+Tlwv7HoaMz3sysO+Vuasebj
         RKzcTIJBqNejda+yMZGuNE7mNbWWap4zkLHwKrtyThPJXQ8uVF93thxI9Am15jPsjU3e
         09VeM7aFt+UKrrWRaY4OGlJvgamgXlrjz037CYX/0Ic2tUzXgPEGehiwazukuSVDEMmu
         m/Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/cksNdFZj9IWFAKVJL2S+JO52BCjhptq1rRTsh39hwU=;
        b=JOGh5fxFiYwkGisYwJ4rEFaLkBlcdjO7WXV8RjiiPchBNO4bVWREiA6C6eh4VnzJ3y
         0zwI+hTwcCNnnEQo2lcQ9lx3GqXS7+w2dZnnCHqMPqU1rbNlV0nhNInxUZC3w6v4R65u
         2AQu8OMVnj4fDg4Xk6nxf7MGJXnftljZqIHuZoLDuoJYuAtij5HGW1t95A/1OhLAe4K0
         OBHFLsPwFA4dmSSSMsnQO5O1/ePmjiz0Fu58RLZUlY4g7ssxEec+67TwJUtu5nQsuflu
         DvSF0ahzgwF/92jkkiH+Tc6MC1XJ2J61R2zQ89i631Dwl1cZW/D7VMiET++VF9a5Q0T9
         eHMQ==
X-Gm-Message-State: AOAM533Jzw3s+94h9fRfhTy4cXOYagQoFfLlv+AqedeKdCBTndL+etMz
        Rp6FuIzOc6TY6pQhnFdN01J1ZYzAbWQ=
X-Google-Smtp-Source: ABdhPJzrI2rcwOxTlv1tvwELn9+hzWwa9IDuSn8C7BHPXcI4Rul83GKkIdn2/l/7qHb0tWVXpNgnrQ==
X-Received: by 2002:adf:f189:: with SMTP id h9mr31297571wro.463.1638638065263;
        Sat, 04 Dec 2021 09:14:25 -0800 (PST)
Received: from localhost.localdomain ([217.113.240.86])
        by smtp.gmail.com with ESMTPSA id h13sm6122049wrx.82.2021.12.04.09.14.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Dec 2021 09:14:24 -0800 (PST)
From:   =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>
To:     tchornyi@marvell.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        kernel-hardening@lists.openwall.com, gustavoars@kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>
Subject: [PATCH] net: prestera: replace zero-length array with flexible-array member
Date:   Sat,  4 Dec 2021 18:13:49 +0100
Message-Id: <20211204171349.22776-1-jose.exposito89@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

One-element and zero-length arrays are deprecated and should be
replaced with flexible-array members:
https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays

Replace zero-length array with flexible-array member and make use
of the struct_size() helper.

Link: https://github.com/KSPP/linux/issues/78
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
---
 drivers/net/ethernet/marvell/prestera/prestera_hw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
index 92cb5e9099c6..6282c9822e2b 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
@@ -443,7 +443,7 @@ struct prestera_msg_counter_resp {
 	__le32 offset;
 	__le32 num_counters;
 	__le32 done;
-	struct prestera_msg_counter_stats stats[0];
+	struct prestera_msg_counter_stats stats[];
 };
 
 struct prestera_msg_span_req {
@@ -1900,7 +1900,7 @@ int prestera_hw_counters_get(struct prestera_switch *sw, u32 idx,
 		.block_id = __cpu_to_le32(idx),
 		.num_counters = __cpu_to_le32(*len),
 	};
-	size_t size = sizeof(*resp) + sizeof(*resp->stats) * (*len);
+	size_t size = struct_size(resp, stats, *len);
 	int err, i;
 
 	resp = kmalloc(size, GFP_KERNEL);
-- 
2.25.1


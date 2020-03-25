Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C490F192C38
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 16:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbgCYPWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 11:22:42 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34857 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727721AbgCYPWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 11:22:21 -0400
Received: by mail-wm1-f65.google.com with SMTP id m3so3184069wmi.0
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 08:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qkBkSQlmZBtW+3eOW+ETmspoEdY7TQLubAkc5GH2IOU=;
        b=QvHUvYHXou95eNd3IIz3RiTOJexJbmDCfWw0pI+74k3a4r+hpp7zJCqZDBDq+5Qk02
         +bJJAFzH4fN2ksVc04H8Ih0jnwCVmSZhFunuWSZhdGV1dcEFVA3IjOnVixRxkw12kxAF
         JVc+onxd4KyNdkxEhbZW2l7kiOnSNTEI+WSVlaFMXLcBUdg3kr7Ac0tdiBibiDL7MZZE
         XpQYqaPLJbbGkepxBDn+15L5L607zNDFSkOckYL0ztoYzAq/G+LbNLr5re6KzFleydG6
         BSmF+2jt9ozvsyC74tLXudfHvOkiO4wtVMSKSt5miKoLctRtLSxpsWwY/XYzKkShoPcw
         qDEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qkBkSQlmZBtW+3eOW+ETmspoEdY7TQLubAkc5GH2IOU=;
        b=tl/3He36I4rkuc4wueQmuhB+q42uHMc7yKBQknmNyajKWipId3PDBpkvKAkZFLnrQG
         Dx+F/D90q8PFLfD+cW5i0swTC9Gz4ufG7ke1LKYVYeT8aymDUB86qAyhJs8XEhK5h011
         q2kQBaJb2ySdzb27i65Ohuhl6mKNtB7LSPreZNKCac77OAWCuRS6/IOrnv1l+JqgKubS
         Lur1MFwU7vyUYZmmIyfnR9wf3kWCF73q5rxl72u4ISqGbaRglrhEyVCTgt3yNRLWwOf3
         gKIN1PZOSc/I1fJgVR5XLmnfShIwMkeJkTEYQD2BvT1LX/Ztcmhrrm56PQqJF4He6NxN
         yhmQ==
X-Gm-Message-State: ANhLgQ1HS1kNHUcBxkE40kz3JtaBkAGQKdWq6t8sANqMwkG2fMDKCr7s
        IvrF0H3Jm7/kjVNJtLswZlU=
X-Google-Smtp-Source: ADFU+vtuPe5sxIxBFrCu68o7ZLAVrW0RmYx4HerxH72zlvbY2sr24dIh6FE3DeJTgqWwPGWFs29Ryg==
X-Received: by 2002:a1c:2056:: with SMTP id g83mr3890892wmg.179.1585149738793;
        Wed, 25 Mar 2020 08:22:18 -0700 (PDT)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id n9sm6309165wru.50.2020.03.25.08.22.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 08:22:18 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     murali.policharla@broadcom.com, stephen@networkplumber.org,
        jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        nikolay@cumulusnetworks.com, netdev@vger.kernel.org
Subject: [PATCH v2 net-next 03/10] bgmac: Add support for Jumbo frames
Date:   Wed, 25 Mar 2020 17:22:02 +0200
Message-Id: <20200325152209.3428-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200325152209.3428-1-olteanv@gmail.com>
References: <20200325152209.3428-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Murali Krishna Policharla <murali.policharla@broadcom.com>

Max frame length updated to enable support for jumbo frames.

Signed-off-by: Murali Krishna Policharla <murali.policharla@broadcom.com>
Reviewed-by: Ray Jui <ray.jui@broadcom.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/broadcom/bgmac.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bgmac.h b/drivers/net/ethernet/broadcom/bgmac.h
index 40d02fec2747..041ad069b5c8 100644
--- a/drivers/net/ethernet/broadcom/bgmac.h
+++ b/drivers/net/ethernet/broadcom/bgmac.h
@@ -366,7 +366,8 @@
 #define BGMAC_RX_FRAME_OFFSET			30		/* There are 2 unused bytes between header and real data */
 #define BGMAC_RX_BUF_OFFSET			(NET_SKB_PAD + NET_IP_ALIGN - \
 						 BGMAC_RX_FRAME_OFFSET)
-#define BGMAC_RX_MAX_FRAME_SIZE			1536		/* Copied from b44/tg3 */
+/* Jumbo frame size */
+#define BGMAC_RX_MAX_FRAME_SIZE			9720
 #define BGMAC_RX_BUF_SIZE			(BGMAC_RX_FRAME_OFFSET + BGMAC_RX_MAX_FRAME_SIZE)
 #define BGMAC_RX_ALLOC_SIZE			(SKB_DATA_ALIGN(BGMAC_RX_BUF_SIZE + BGMAC_RX_BUF_OFFSET) + \
 						 SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))
-- 
2.17.1


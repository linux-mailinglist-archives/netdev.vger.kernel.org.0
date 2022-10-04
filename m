Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29FF45F47A1
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 18:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbiJDQcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 12:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiJDQcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 12:32:39 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A22952825;
        Tue,  4 Oct 2022 09:32:38 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id b4so15223983wrs.1;
        Tue, 04 Oct 2022 09:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=KkyjHkIVAxjkk7zn0+JItE+iFfNARRnB8aGnYrfZaWI=;
        b=o4Mdjf7R+FfV4456WLzSZG+eiAvS8pbuSRTf8aXIvDYA6fAKWnpCRIJgYoYqcny7p5
         wPdmbxopI9WzdrELpeWjljB2HQ7wJl8z+2aKDlANPna5QQlxph/aZKXjRQqMKfapQnkz
         Ex7URCgEJ7eilLFSASfkY2d846IRvjZAxp12SgFbGLSaybLRGjArei9yn26GjPIOsL0Z
         II1D0rP5eC22yC8iCfTYRm14CJkp5m+6q6sxWgMKMH3a8LnmfhDpnXsv3gphkm97Cj+C
         SEmPtyWLersQbKJLE7FOUzZZHOf65t8EwfMGrrYorETutKYiiqry95pZwCsxQmUkF1x7
         EwNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=KkyjHkIVAxjkk7zn0+JItE+iFfNARRnB8aGnYrfZaWI=;
        b=mnd5tNpVN1oGVWPHiea9ie+9PqmYbtJee6MpwwUX+LSD8pFnnSYZfkGxCqD0lDUp1t
         Qamka/oeSV9mCnCKKUPcI3QFT0LMfiA2NSVwhRwrZx8MfcToaM/5FR0T0rne6QkvF9++
         l2aDNg6qp4DiG1UIZzMA0SSDctu1grSv4O5JBTXogemeGCS7W5yCYRJCdx5CsIP5mfua
         XozUgtd/FDKFgDo9fgv02HdFpUU/JS79/MVBcsyShXzipUcm9cH2NCZApwAipj15/MRC
         wP2bBeCfNtxu+SzfZDBmtG7ks8xPVMUqaEFovVGCtJHXEHwHRbhiLf4m4LmjPpsqdY42
         0Bxw==
X-Gm-Message-State: ACrzQf2CoWw6ogn887H6yh5vSXG6gBD+Udv2LpIz/iNj/UMBxQUbqKFd
        K+UtS17y5ZJzh6r8g8Uwa6A=
X-Google-Smtp-Source: AMsMyM4w7JGL4GZbCEs0/CeC+ym6VteG1jUa730B6JnJs2MLFPNY2IvxyUSWoklrLjZaaGL8apfn4Q==
X-Received: by 2002:a05:6000:1a8f:b0:228:e3c3:679 with SMTP id f15-20020a0560001a8f00b00228e3c30679mr16606635wry.281.1664901156708;
        Tue, 04 Oct 2022 09:32:36 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id b17-20020adfee91000000b0022865038308sm12563744wro.93.2022.10.04.09.32.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 09:32:36 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: bnx2x: Fix spelling mistake "tupple" -> "tuple"
Date:   Tue,  4 Oct 2022 17:32:35 +0100
Message-Id: <20221004163235.157485-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are several spelling mistakes of tuple in comments and messages.
Fix them.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c | 10 +++++-----
 fs/freevxfs/vxfs_olt.c                              |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
index bda3ccc28eca..49f2a0b45b20 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
@@ -3388,7 +3388,7 @@ static int bnx2x_set_rss_flags(struct bnx2x *bp, struct ethtool_rxnfc *info)
 	switch (info->flow_type) {
 	case TCP_V4_FLOW:
 	case TCP_V6_FLOW:
-		/* For TCP only 4-tupple hash is supported */
+		/* For TCP only 4-tuple hash is supported */
 		if (info->data ^ (RXH_IP_SRC | RXH_IP_DST |
 				  RXH_L4_B_0_1 | RXH_L4_B_2_3)) {
 			DP(BNX2X_MSG_ETHTOOL,
@@ -3399,7 +3399,7 @@ static int bnx2x_set_rss_flags(struct bnx2x *bp, struct ethtool_rxnfc *info)
 
 	case UDP_V4_FLOW:
 	case UDP_V6_FLOW:
-		/* For UDP either 2-tupple hash or 4-tupple hash is supported */
+		/* For UDP either 2-tuple hash or 4-tuple hash is supported */
 		if (info->data == (RXH_IP_SRC | RXH_IP_DST |
 				   RXH_L4_B_0_1 | RXH_L4_B_2_3))
 			udp_rss_requested = 1;
@@ -3418,7 +3418,7 @@ static int bnx2x_set_rss_flags(struct bnx2x *bp, struct ethtool_rxnfc *info)
 		    (bp->rss_conf_obj.udp_rss_v4 != udp_rss_requested)) {
 			bp->rss_conf_obj.udp_rss_v4 = udp_rss_requested;
 			DP(BNX2X_MSG_ETHTOOL,
-			   "rss re-configured, UDP 4-tupple %s\n",
+			   "rss re-configured, UDP 4-tuple %s\n",
 			   udp_rss_requested ? "enabled" : "disabled");
 			if (bp->state == BNX2X_STATE_OPEN)
 				return bnx2x_rss(bp, &bp->rss_conf_obj, false,
@@ -3427,7 +3427,7 @@ static int bnx2x_set_rss_flags(struct bnx2x *bp, struct ethtool_rxnfc *info)
 			   (bp->rss_conf_obj.udp_rss_v6 != udp_rss_requested)) {
 			bp->rss_conf_obj.udp_rss_v6 = udp_rss_requested;
 			DP(BNX2X_MSG_ETHTOOL,
-			   "rss re-configured, UDP 4-tupple %s\n",
+			   "rss re-configured, UDP 4-tuple %s\n",
 			   udp_rss_requested ? "enabled" : "disabled");
 			if (bp->state == BNX2X_STATE_OPEN)
 				return bnx2x_rss(bp, &bp->rss_conf_obj, false,
@@ -3437,7 +3437,7 @@ static int bnx2x_set_rss_flags(struct bnx2x *bp, struct ethtool_rxnfc *info)
 
 	case IPV4_FLOW:
 	case IPV6_FLOW:
-		/* For IP only 2-tupple hash is supported */
+		/* For IP only 2-tuple hash is supported */
 		if (info->data ^ (RXH_IP_SRC | RXH_IP_DST)) {
 			DP(BNX2X_MSG_ETHTOOL,
 			   "Command parameters not supported\n");
diff --git a/fs/freevxfs/vxfs_olt.c b/fs/freevxfs/vxfs_olt.c
index 23f35187c289..48027a421fa3 100644
--- a/fs/freevxfs/vxfs_olt.c
+++ b/fs/freevxfs/vxfs_olt.c
@@ -63,7 +63,7 @@ vxfs_read_olt(struct super_block *sbp, u_long bsize)
 
 	op = (struct vxfs_olt *)bp->b_data;
 	if (fs32_to_cpu(infp, op->olt_magic) != VXFS_OLT_MAGIC) {
-		printk(KERN_NOTICE "vxfs: ivalid olt magic number\n");
+		printk(KERN_NOTICE "vxfs: invalid olt magic number\n");
 		goto fail;
 	}
 
-- 
2.37.1


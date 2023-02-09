Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 322AF691355
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 23:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbjBIW1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 17:27:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbjBIW1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 17:27:06 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC8A266EE4;
        Thu,  9 Feb 2023 14:27:03 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id c4-20020a1c3504000000b003d9e2f72093so5023665wma.1;
        Thu, 09 Feb 2023 14:27:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mA+W2iIOZyTuxfiY1E6tdbEkL6JPb15N04qIIGKc1Bo=;
        b=grXmBtKibLp67pM4ScaLs8kExZlNValb1oKoIp5YGcr5Ka8i5Vst+TIefQJ5MpCB2K
         VpPw/jCAfXG9qHDSmBCEXEsY5abPFUomHZoUOkjAhusUsT0KWs/mRzHw/Bjytfo2xvqB
         35I0J8FA2XqUPrUh/JwRiZql3tU04aw8cu907PJbOcyPSxWYifpN076p3fVwKC+9GZCs
         XsavH/GYiGWIL+sOHCxOTYP9yRpJGezm2MWtd9+01hSuQ+dWDRs+OPRkXZoixrYwbeNd
         Okax6wTuJMxGGj1Rhvi+8GnzIctYs5qdmDjNexCH6XjlPTSe915zwj5iqq9V8luXkvb5
         7nQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mA+W2iIOZyTuxfiY1E6tdbEkL6JPb15N04qIIGKc1Bo=;
        b=UIbVfPxtG2v4nsjCfjzTFLwP2SP1sXFVf/H9RmQc7sv85d008WCe7bDK/iG+d/rqNE
         XWXyu3d6vzetyppbeCsEsUkgnHsMuy/a+i2ujsumfi63EELZLZ7utACdnbU0g//EV6ci
         pr5Sd8kBU7x6fGj5IQWoSqKLqw+D0B0onktnBOMLLGUd856qDvuHyqgrfU0W4XBLrwG6
         X3pcvKR20C2naBM0XmEmBMElxOn6dgPIEYQPbmtOdcjFyZJbB0warE0JHUU2rqkdA+Sl
         K9DJzgjPHoC95kRGZz9CyrIrx2MuLkcQSCleh0YwLEsBDRbWk73QhcYtjkkMvIg79I83
         AzBg==
X-Gm-Message-State: AO0yUKULeYFjA/39SyjuPWtEsYag8CfgNECu16V9mIMNeFabuaceau3n
        E3UNBI8fJ8YtEfqZ/IU98udpT6CWH34=
X-Google-Smtp-Source: AK7set9Ua413yrHnTvV7eGnWB8gqVZ8rPiEhK2aJcYr1DUcPahcls/IN6j8/3u9hoWhWels9ombxLQ==
X-Received: by 2002:a05:600c:45cf:b0:3df:9858:c03c with SMTP id s15-20020a05600c45cf00b003df9858c03cmr7827388wmo.17.1675981622191;
        Thu, 09 Feb 2023 14:27:02 -0800 (PST)
Received: from localhost.localdomain (93-34-91-73.ip49.fastwebnet.it. [93.34.91.73])
        by smtp.googlemail.com with ESMTPSA id l40-20020a05600c1d2800b003dd1b00bd9asm3573030wms.32.2023.02.09.14.27.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 14:27:01 -0800 (PST)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Dan Carpenter <error27@gmail.com>
Subject: [PATCH] wifi: ath11k: fix SAC bug on peer addition with sta band migration
Date:   Thu,  9 Feb 2023 23:26:22 +0100
Message-Id: <20230209222622.1751-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
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

Fix sleep in atomic context warning detected by Smatch static checker
analyzer.

Following the locking pattern for peer_rhash_add lock tbl_mtx_lock mutex
always even if sta is not transitioning to another band.
This is peer_add function and a more secure locking should not cause
performance regression.

Fixes: d673cb6fe6c0 ("wifi: ath11k: fix peer addition/deletion error on sta band migration")
Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/wireless/ath/ath11k/peer.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/peer.c b/drivers/net/wireless/ath/ath11k/peer.c
index 1ae7af02c364..1380811827a8 100644
--- a/drivers/net/wireless/ath/ath11k/peer.c
+++ b/drivers/net/wireless/ath/ath11k/peer.c
@@ -382,22 +382,23 @@ int ath11k_peer_create(struct ath11k *ar, struct ath11k_vif *arvif,
 		return -ENOBUFS;
 	}
 
+	mutex_lock(&ar->ab->tbl_mtx_lock);
 	spin_lock_bh(&ar->ab->base_lock);
 	peer = ath11k_peer_find_by_addr(ar->ab, param->peer_addr);
 	if (peer) {
 		if (peer->vdev_id == param->vdev_id) {
 			spin_unlock_bh(&ar->ab->base_lock);
+			mutex_unlock(&ar->ab->tbl_mtx_lock);
 			return -EINVAL;
 		}
 
 		/* Assume sta is transitioning to another band.
 		 * Remove here the peer from rhash.
 		 */
-		mutex_lock(&ar->ab->tbl_mtx_lock);
 		ath11k_peer_rhash_delete(ar->ab, peer);
-		mutex_unlock(&ar->ab->tbl_mtx_lock);
 	}
 	spin_unlock_bh(&ar->ab->base_lock);
+	mutex_unlock(&ar->ab->tbl_mtx_lock);
 
 	ret = ath11k_wmi_send_peer_create_cmd(ar, param);
 	if (ret) {
-- 
2.38.1


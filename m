Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 361C365ADEB
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 09:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbjABILz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 03:11:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230509AbjABILx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 03:11:53 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10AF7B4;
        Mon,  2 Jan 2023 00:11:53 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id c8-20020a17090a4d0800b00225c3614161so25134674pjg.5;
        Mon, 02 Jan 2023 00:11:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xoAMGm4CGvulGlKzCI+T5yNGQVVBplAVmvUDydQXfE4=;
        b=g0YrG0K+HIe6E9s0E3k+f0UfLVIOE4dhrwK0h1beLo+prLcCLcbMoBAxYTOjCQcCD0
         wFau4LuG1IqnSrVVgPCi7hA/H+LTaJMjl7NFVwJJzc8nfTUfYvL67wxus/3RrlaBcdOD
         7PLtsjbqeJGBL3jUSamUIiFLnFdJCMwEOLkJVyKaHRb6vpmuRF4rAHCI4KIsssqIJ7CF
         z/1gpL1VQetrYPOCN2ByKr/i/SOTZYhGUmEQJ/RC/JhvMiXMyJVDucclgYtIzELuU8Uf
         vLM0h2nD3/i++P34kGtTkwPPzTQJ98JHsO26C48Ody/tI8dxAvX7kBBICO+EGB169O7d
         SE0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xoAMGm4CGvulGlKzCI+T5yNGQVVBplAVmvUDydQXfE4=;
        b=DtspuNFxhhANhpb/egkv46IbIByIL0Go8OMEr2PNhmtMJrJjVq4VGwd8EYRfcD9w/Y
         GZS/YJCfeP6QBLtPRj4ELshs2DLXAZJMupoCYScaV24xhELr5ytroYl4X/FKUhkJVg6o
         71mHUXgWo4Q8Pi0EDuu0Nl6XCBzditFx0ic0wRzjHz0AYRDVumffHtGtsPY/7A/u0N+6
         hkoXQbX6OwqA6lzURpd0bUKiQx9SMleEPHqnHaG5GLjEuTRBe144So85PTSm6J7xkvt6
         MdDRNg7truKAZIjNo+ITcagwfk8lzqje8GDbXlhpa1BmuDyAKBhR8TIDD90Wn+f+Z/Lp
         aOlg==
X-Gm-Message-State: AFqh2kpPj7i10Eoi4jQeVN/9bORqWbgj00QGKDmcwiXRO2V7Sl3WLGOb
        MbMuLhI+FlR9zzT6WdvCkBI=
X-Google-Smtp-Source: AMrXdXuVvPcP9uxZ92+n+yZ1f4eQ0Oxnv6FSfkNmp7LL/1Xf01k25Czk/idkZV/0rWox39I2gxNyCg==
X-Received: by 2002:a17:90a:e513:b0:225:fb71:efc1 with SMTP id t19-20020a17090ae51300b00225fb71efc1mr24410317pjy.0.1672647112573;
        Mon, 02 Jan 2023 00:11:52 -0800 (PST)
Received: from localhost.localdomain ([202.120.234.246])
        by smtp.googlemail.com with ESMTPSA id on16-20020a17090b1d1000b0020b21019086sm32585201pjb.3.2023.01.02.00.11.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jan 2023 00:11:51 -0800 (PST)
From:   Miaoqian Lin <linmq006@gmail.com>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Manikanta Pubbisetty <mpubbise@codeaurora.org>,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     linmq006@gmail.com
Subject: [PATCH v2] wifi: ath11k: Fix memory leak in ath11k_peer_rx_frag_setup
Date:   Mon,  2 Jan 2023 12:11:42 +0400
Message-Id: <20230102081142.3937570-1-linmq006@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

crypto_alloc_shash() allocates resources, which should be released by
crypto_free_shash(). When ath11k_peer_find() fails, there has memory
leak. Add missing crypto_free_shash() to fix this.

Fixes: 243874c64c81 ("ath11k: handle RX fragments")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
---
change in v2:
- add crypto_free_shash() in the error path instead of move
crypto_alloc_shash().
---
 drivers/net/wireless/ath/ath11k/dp_rx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index c5a4c34d7749..0c53d88293eb 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -3126,6 +3126,7 @@ int ath11k_peer_rx_frag_setup(struct ath11k *ar, const u8 *peer_mac, int vdev_id
 	if (!peer) {
 		ath11k_warn(ab, "failed to find the peer to set up fragment info\n");
 		spin_unlock_bh(&ab->base_lock);
+		crypto_free_shash(tfm);
 		return -ENOENT;
 	}
 
-- 
2.25.1


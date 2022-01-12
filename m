Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8149E48BF7D
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 09:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351393AbiALIGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 03:06:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349140AbiALIGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 03:06:38 -0500
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41966C06173F;
        Wed, 12 Jan 2022 00:06:38 -0800 (PST)
Received: by mail-qv1-xf2a.google.com with SMTP id iw1so2140029qvb.1;
        Wed, 12 Jan 2022 00:06:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s9wP9RSrgr08glKF9dncR1CuR8sUvA64NLVwaMsEmbU=;
        b=ogcCtyIpl7XMHQhcKCT/FAzS4h1kiYH97fEBksTunkvVyezNqhSGGfvfQ9+0mWFFzd
         7F4c1j7IADAECwYvbe8EbzKyiGBte4fvT0VyL4w56GC6/16oCim7ofaqrVx/0ujGexK1
         +q3Ik/qv9HPUTGTRGOiTSVWK4y737fKb+fMv/iU+ND6gmsUuA9bSm8fvY9WLG1VQWliG
         bqr5iP5Xkt6HOuXNUfP9CR4+9ZrWGIg2LJQ8mcDSMtRlsyvMoleA8jXeHNP23a76D7Be
         rdsbuXXP35366F6F0+bRLv/jPGJdUOwTVGlQ2/Q+NTMkqZIoaEPa/VDwD0Jfr8B+9IPF
         l1Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s9wP9RSrgr08glKF9dncR1CuR8sUvA64NLVwaMsEmbU=;
        b=DEp8BBjjcf7w5VGwF6WxubTuZCE2Ul/AZqlx3YeO3RaDZ7HgQ/23oODewzuZjg058E
         7ZPYxIMpg8V4QqOjQA0k7bi3JTIPugL48vU+vAz/uLlWQVEnu/TlmJVu9PVVU3spw2be
         rW1JAQfiMaxO73aVLyG7uxBOBOuUWOxN3jihXcqcL7w48+zb9aAPUYu2Jkf5blhA6DVO
         cXbAjAJUglLQ61DHxLXDONV3ysakWg5niRLYloxZ6mt5c2peMqEH9rov4XMYFmCvVVX8
         wSQBWgP5i9h9knv9/5PWv86X7s86xtxXW7q3RYzY+mKlfirbHnzetcAZW4kPEpvXPWnr
         wWaw==
X-Gm-Message-State: AOAM530Ny1ecgTnT/TFBse4IWk1XSVjOGmYdFWabRvQAxz5gnhzNBlMi
        jb50zF1iyhheW3oEczMaa7Q=
X-Google-Smtp-Source: ABdhPJwm0V0bPtI8HXjfNZ/O4N0UAjpRihZIarKX3MZU85E5mJUIIZNmlXu2DRyT8OmNEh38J6JfnA==
X-Received: by 2002:a05:6214:f25:: with SMTP id iw5mr6709778qvb.3.1641974797539;
        Wed, 12 Jan 2022 00:06:37 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id g13sm4199068qko.34.2022.01.12.00.06.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 00:06:37 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     wg@grandegger.com
Cc:     mkl@pengutronix.de, davem@davemloft.net, kuba@kernel.org,
        mailhol.vincent@wanadoo.fr, jiapeng.chong@linux.alibaba.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>, CGEL ZTE <cgel.zte@gmail.com>
Subject: [PATCH] drivers/net/can/softing: remove redundant ret variable
Date:   Wed, 12 Jan 2022 08:06:29 +0000
Message-Id: <20220112080629.667191-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Minghao Chi <chi.minghao@zte.com.cn>

Return value from softing_startstop() directly instead
of taking this in another redundant variable.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
Signed-off-by: CGEL ZTE <cgel.zte@gmail.com>
---
 drivers/net/can/softing/softing_main.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/can/softing/softing_main.c b/drivers/net/can/softing/softing_main.c
index cfc1325aad10..737dac5ea3b1 100644
--- a/drivers/net/can/softing/softing_main.c
+++ b/drivers/net/can/softing/softing_main.c
@@ -392,13 +392,10 @@ static int softing_netdev_open(struct net_device *ndev)
 
 static int softing_netdev_stop(struct net_device *ndev)
 {
-	int ret;
-
 	netif_stop_queue(ndev);
 
 	/* softing cycle does close_candev() */
-	ret = softing_startstop(ndev, 0);
-	return ret;
+	return softing_startstop(ndev, 0);
 }
 
 static int softing_candev_set_mode(struct net_device *ndev, enum can_mode mode)
-- 
2.25.1


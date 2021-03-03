Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69D8D32C453
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392242AbhCDANC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:13:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447750AbhCCPQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 10:16:21 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A5EEC061788
        for <netdev@vger.kernel.org>; Wed,  3 Mar 2021 06:44:33 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id v6so26978859ybk.9
        for <netdev@vger.kernel.org>; Wed, 03 Mar 2021 06:44:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=bzKuvW9FCkH6licndn+SzAtNwuuz2TrI6nL9ZvvyxFM=;
        b=lPFo9IN+dGrDOjv+BhbTPZ4WfHw6JGhNOxJ0y3oPyP70sDcwRIgvXghVviaGr/dlb3
         gatdQAOb8HxnuuPhVJypacJcwLme8jb3BX30c6a+VBRdOLZ9+keb5zSEcu0wBiSUxkPt
         pG9A23BGc8I5YSNaLP9dQ9DX+dsPymt1oxMmyfKv7rhDPBE0AOhOoQMch3/YJ1HMeubK
         rkeN+UO2+jrRGGp4VRO7SKaCLuN0UzhRubEbKGjvT+1+RcpUahM7LnKENMdkRQBUPtGF
         OzwBuKLlhpktSI0cjwBpHbbfuH+swbrfxqb3Z3IydIR4jVi/QrRSfEvSeu4hqourq4Ow
         5ZTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=bzKuvW9FCkH6licndn+SzAtNwuuz2TrI6nL9ZvvyxFM=;
        b=uQ4IsaPwzyUGfQOj9IN32BP44Enl+0BQGcLUUn24BSqDltefCCimzAEv0T+X4befWY
         oy/mwzONtO7yjm63FP/pi43DeHQoDGbOpqxt4Wwd2K9Wi3OydKmu9xgrVM2PtD3WXTs7
         xP/3D3CR2yucAfh8vJD3MpMGHCazYaBv6bRFF+bQf70Cr5aJUMZkDm1B18e0z7wuqKco
         0v62K+y7/3j4nAGwj34P4SxQQK2tvIgS+EohNaI2vVwJl6bmYODOfI3Awm/B9zxDJqjW
         kqNX0juucTmGPwDIDBIn0ebZdwUHdNeFTablINTk3VrmWR+q+jhK3jEL8VIdBKscD4TB
         66sQ==
X-Gm-Message-State: AOAM530IeGBA00gd8c6TDnmmakxitAOmPD6h9d4PGVAy1Ll+9RcZsKJS
        nck3i6VaWULVZ67ah752EucoePg6TzYWicGADrjOEjIsSMaic5IDOf/7F3QRJwBuBOodAC00fF1
        xNXWAQSniwt+TMrYY6PT/WRqkPaqRdOeYbtsbtixI/iG28PrvtEO/fg==
X-Google-Smtp-Source: ABdhPJwPc0TZ0jtEBjO633u5xdFA3yd8JZAc993t0ycRFFgolt+LpZVOyQADq5N2mOKyBOnQFYBCiAo=
Sender: "yyd via sendgmr" <yyd@yyd.nyc.corp.google.com>
X-Received: from yyd.nyc.corp.google.com ([100.119.158.72]) (user=yyd
 job=sendgmr) by 2002:a25:41d0:: with SMTP id o199mr19239010yba.458.1614782672585;
 Wed, 03 Mar 2021 06:44:32 -0800 (PST)
Date:   Wed,  3 Mar 2021 09:43:54 -0500
Message-Id: <20210303144354.4176857-1-yyd@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH] net/mlx4_en: update moderation when config reset
From:   "Kevin(Yudong) Yang" <yyd@google.com>
To:     netdev@vger.kernel.org
Cc:     "Kevin(Yudong) Yang" <yyd@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Tariq Toukan <tariqt@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes a bug that the moderation config will not be
applied when calling mlx4_en_reset_config. For example, when
turning on rx timestamping, mlx4_en_reset_config() will be called,
causing the NIC to forget previous moderation config.

This fix is in phase with a previous fix:
commit 79c54b6bbf06 ("net/mlx4_en: Fix TX moderation info loss
after set_ringparam is called")

Tested: Before this patch, on a host with NIC using mlx4, run
netserver and stream TCP to the host at full utilization.
$ sar -I SUM 1
                 INTR    intr/s
14:03:56          sum  48758.00

After rx hwtstamp is enabled:
$ sar -I SUM 1
14:10:38          sum 317771.00
We see the moderation is not working properly and issued 7x more
interrupts.

After the patch, and turned on rx hwtstamp, the rate of interrupts
is as expected:
$ sar -I SUM 1
14:52:11          sum  49332.00

Fixes: 79c54b6bbf06 ("net/mlx4_en: Fix TX moderation info loss after set_ringparam is called")
Signed-off-by: Kevin(Yudong) Yang <yyd@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Neal Cardwell <ncardwell@google.com>
CC: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c | 2 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c  | 2 ++
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h    | 1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
index 23849f2b9c25..1434df66fcf2 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
@@ -47,7 +47,7 @@
 #define EN_ETHTOOL_SHORT_MASK cpu_to_be16(0xffff)
 #define EN_ETHTOOL_WORD_MASK  cpu_to_be32(0xffffffff)
 
-static int mlx4_en_moderation_update(struct mlx4_en_priv *priv)
+int mlx4_en_moderation_update(struct mlx4_en_priv *priv)
 {
 	int i, t;
 	int err = 0;
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 51b9700fce83..5d0c9c62382d 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -3554,6 +3554,8 @@ int mlx4_en_reset_config(struct net_device *dev,
 			en_err(priv, "Failed starting port\n");
 	}
 
+	if (!err)
+		err = mlx4_en_moderation_update(priv);
 out:
 	mutex_unlock(&mdev->state_lock);
 	kfree(tmp);
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
index e8ed23190de0..f3d1a20201ef 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
@@ -775,6 +775,7 @@ void mlx4_en_ptp_overflow_check(struct mlx4_en_dev *mdev);
 #define DEV_FEATURE_CHANGED(dev, new_features, feature) \
 	((dev->features & feature) ^ (new_features & feature))
 
+int mlx4_en_moderation_update(struct mlx4_en_priv *priv);
 int mlx4_en_reset_config(struct net_device *dev,
 			 struct hwtstamp_config ts_config,
 			 netdev_features_t new_features);
-- 
2.30.1.766.gb4fecdf3b7-goog


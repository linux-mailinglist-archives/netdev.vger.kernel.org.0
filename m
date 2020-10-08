Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA30C28781D
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731330AbgJHPwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729982AbgJHPwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:52:35 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C65AC061755;
        Thu,  8 Oct 2020 08:52:34 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id b193so3755199pga.6;
        Thu, 08 Oct 2020 08:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xj0pBgVhNxASlVfolFKflNWPpnHbrw3tqtatCMh94uE=;
        b=Gi/MBK/zSigEUmRQV5eefcrEvYNXyp2yDzSz0V3A1Y0olRjxPJr8Fg2qK96Pg28Jdb
         O2YyJWbtbWlD/4qROzv4lhQMei73kiXoqp266WthEXAKoLu3TSSU8FsjjWcY/mKehUvD
         7VILyFvwaKEvK/8Lq+zhHGUYmPy1rAyl0EmpRwPUD7h+sYw9eYNtmjUV4McyIyFeLnsr
         NYdkFzQrEXWEZfb+7hJWDMgN6ZqabiqqgfFse84i78dwmGr7+k1yy+k8MUYtxhTbDu+V
         THJO8gpspa2PZAAoWK5htYIrJVddxsrbp2CTFcBthT7n3s+HYm8enwTfceyTckvfRadV
         cNpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xj0pBgVhNxASlVfolFKflNWPpnHbrw3tqtatCMh94uE=;
        b=lapI3VX9l3dU/nuONtcboVPZ//iNLB43KDs986ikPbPyXzlgeyMhPrE/HmM3p2BtpG
         QtDESi9H9oL+Xig3d74Balh0L8y4lqSlD/33OV2fHelu6fJemYNHxldUy0pELO/AZTlt
         Ru3Se2IgNVvd8cp3ax5iH/idoz2Gedx/mW8ijE7UqW/TQnluPfo2q6Kyqe49yvS4/DTu
         i5Wzl64xGnO0frNIC7UL58Ar0tGJE+Myk1VOo4AS6BOJ/6mKY4Agwhif0Yo9Ngms+V24
         /QCuONRCvxDniI4AbP8UezAmeL6soWwGpSquOwhtxlTBLJjuFXt+vFtibeyg05dgpA4D
         3MMg==
X-Gm-Message-State: AOAM532lfY0PXCvjS/l2JGIZvPIlu60cTjRIorRwB6ZixZUdHj2duhdu
        lTtDniSRHuJxHZ+VHJu1EK0=
X-Google-Smtp-Source: ABdhPJwUWyUV/89Wyk3kcwIfb8yq68HvUAd0AsM8BaiE5evpCm0v2VmtFXC9yfa/RYT/vAhJSJTWmQ==
X-Received: by 2002:a17:90a:1704:: with SMTP id z4mr8749305pjd.7.1602172353708;
        Thu, 08 Oct 2020 08:52:33 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.52.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:52:32 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 004/117] mac80211: set minstrel_ht_stat_csv_fops.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:50:16 +0000
Message-Id: <20201008155209.18025-4-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 2cae0b6a70d6 ("mac80211: add new Minstrel-HT statistic output via csv")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/mac80211/rc80211_minstrel_ht_debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/rc80211_minstrel_ht_debugfs.c b/net/mac80211/rc80211_minstrel_ht_debugfs.c
index 6021e394e5da..cdb51aa460a3 100644
--- a/net/mac80211/rc80211_minstrel_ht_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_ht_debugfs.c
@@ -312,6 +312,7 @@ static const struct file_operations minstrel_ht_stat_csv_fops = {
 	.read = minstrel_stats_read,
 	.release = minstrel_stats_release,
 	.llseek = no_llseek,
+	.owner = THIS_MODULE,
 };
 
 void
-- 
2.17.1


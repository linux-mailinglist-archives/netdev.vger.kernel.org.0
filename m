Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5112F1EEFE5
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 05:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbgFED1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 23:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbgFED1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 23:27:40 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADADEC08C5C0;
        Thu,  4 Jun 2020 20:27:40 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id p5so8202218ile.6;
        Thu, 04 Jun 2020 20:27:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Wso3Uq4ZK5HIlYrGw+m1OLsKrcnMVzQIdIiN1bfsOnU=;
        b=jpm0Bkg5ZInuslfAoRflVOENbBUZ5F2G1M+QXSVgKRgP7zXhR2ZLd3rjA+I+ZF8Bfa
         XFS6r9BwWoY1xOACIwhP47GjjjZ5M+06YSxHTh7gZ8MX38MwhZKyHpZxius1xBPEUKGa
         OueeNzSZTmrtmQ3s6+kvZ5+pQvjKMjgciWNb5KpFW73lYc+ATx+cvIywu2tJpcG5DN8i
         5oxFTFQHXnDYNUpvbVQo5r5o1YVOiP7VjTu4zL7fhorJI15WCULvw1abhktLc4u/eFM9
         6Fmk3wEwsN5V97/PHFgnrC3Ieut5TmJxIPLCi2ggyM785/pvnYTBNYgpPeM7G2G/nUHZ
         I9Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Wso3Uq4ZK5HIlYrGw+m1OLsKrcnMVzQIdIiN1bfsOnU=;
        b=R0+Hd1l0i4JL2PrD4SHr3Gd457czURZUuBLL5wFy+E83bPU2mdSMLidJMx6FusU5wc
         9UxyBzYBBa9jw90U8y5QcnC+asK5LQmK573wRJtrOktEpZ1TvT8agF2q62yCdWgo6BLl
         pB/o8hENl4XgShIIE6dy+mfp8Jdp6enqXuu0PQ2bYJUw6jP7fCn9qDfM5DlB2nWcPlLZ
         V3iaKv44Xj55ojvQNAqQOS3b4U/MyzkHCcBp18+fap9QkVf2GUHFrAA4v14DpKp7Svr/
         oS3GuOh0k8grgngYsv8sYqdaTHArndR2lMG7TgqrBjnjF/bFHWPiUpXFyhidf144/jKZ
         eSSA==
X-Gm-Message-State: AOAM531lmN0iQ61eAa/DZph1nUXeXNHB6FvTW03MKGmUtC+oITXlZQaQ
        CINhUB7LwIowvKSR8PLpSSU=
X-Google-Smtp-Source: ABdhPJxPEuoMTJOGdljOCBOOB+kz2nQkQ48+9ttzR6Xu/dk6kci6f3Gcj1qVZsnYWKcGGir28gz9wg==
X-Received: by 2002:a92:a112:: with SMTP id v18mr6320491ili.278.1591327659958;
        Thu, 04 Jun 2020 20:27:39 -0700 (PDT)
Received: from cs-u-kase.dtc.umn.edu (cs-u-kase.cs.umn.edu. [160.94.64.2])
        by smtp.googlemail.com with ESMTPSA id v3sm2287930ilh.53.2020.06.04.20.27.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2020 20:27:39 -0700 (PDT)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes.berg@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hari Nagalla <hnagalla@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Maital Hahn <maitalm@ti.com>,
        Fuqian Huang <huangfq.daxian@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     emamd001@umn.edu, wu000273@umn.edu, kjlu@umn.edu, smccaman@umn.edu
Subject: [PATCH] wlcore: mesh: handle failure case of pm_runtime_get_sync
Date:   Thu,  4 Jun 2020 22:27:31 -0500
Message-Id: <20200605032733.49846-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Calling pm_runtime_get_sync increments the counter even in case of
failure, causing incorrect ref count. Call pm_runtime_put if
pm_runtime_get_sync fails.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
 drivers/net/wireless/ti/wlcore/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index f140f7d7f553..c7e4f5a80b9e 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -3662,8 +3662,10 @@ void wlcore_regdomain_config(struct wl1271 *wl)
 		goto out;
 
 	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_autosuspend(wl->dev);
 		goto out;
+	}
 
 	ret = wlcore_cmd_regdomain_config_locked(wl);
 	if (ret < 0) {
-- 
2.17.1


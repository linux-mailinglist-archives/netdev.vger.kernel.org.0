Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 733D134D522
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 18:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbhC2Qa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 12:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbhC2Qam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 12:30:42 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE44C061574;
        Mon, 29 Mar 2021 09:30:42 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id x13so13477034wrs.9;
        Mon, 29 Mar 2021 09:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JfodvBmL1giHTDOb6VQdTtKC1BE+voaSb1GB+u3DriA=;
        b=G8KKJkNvlEgT3kTgPZPrDx2mm5Z5xCX7koJQGp/Wl6zrE3poywWgVBXiRD24kDn/Hl
         91h9DtK1qmcu7dn9tMPzJ8YWiwhIzKDNlkNj2QYK8Xh8C2lpgcOqTmoR5LvmTiiDi4r9
         tOCAz7jp8JQie8SFChG8HvvamGgnYQJEKv3U0yzl9pb4v1egNNlyAK2sppRcKPtUxxWM
         XYCTFv+uSqOZsqusMv54sjm/ISqStgsa0ex4RwwUea6aKb3SGS0MdpT/44ztliDhWIWs
         Qag46vn/EaIr6RxXZrE9iuyeFbnVRQrtx+/XXCB9UleLcCYt5K2Fn1EekKXrty2yfzhk
         MVHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JfodvBmL1giHTDOb6VQdTtKC1BE+voaSb1GB+u3DriA=;
        b=A+ulrtHBXCPG8S0HyKm5iwxs6YkEYWRzeOFoFrAXXovMCeyX2R+y7bVCSuyrR4oqPN
         +CKEbKEgszJmxNPrfwXxPSf+jvSGjwDeI8kIib+RB+YDiYam5/8tpGcmow9LQYhTEFYT
         tVnI2WovD5GLGmGsjmCIuGa5YRShI2CMVDfVj+QnEDD3HF8HRDbC4oWod9s5+RsYZn3B
         HGU0JBlYoM0oW2e+UKGklcLMyF7Iat8AttjA+fbSvENHjd0xJwtdyWtlqyXs/E2LJB43
         /mboYLSBz3Qxzz7bo02bMFMrQ1vT3a+2BeUsezMBJybi+sK+RNX/18dQElBaHh4+cgNK
         pZkA==
X-Gm-Message-State: AOAM533mUpfMvpetNxbxv2lx3wW7VEupCEyXBQFB9z9xxcTYkzKAxFMs
        mvtrLTx1jnyHCJp4b3UnV6U=
X-Google-Smtp-Source: ABdhPJz98MmiuzWGvEVbP2nuC3fZae7F7DDYVWiYWJROZKzZAVq4FEUVE4dKQECoxZcgHkcNnU3rbA==
X-Received: by 2002:a5d:4307:: with SMTP id h7mr29153237wrq.227.1617035441156;
        Mon, 29 Mar 2021 09:30:41 -0700 (PDT)
Received: from alaa ([197.57.128.221])
        by smtp.gmail.com with ESMTPSA id z82sm24614118wmg.19.2021.03.29.09.30.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 09:30:40 -0700 (PDT)
From:   Alaa Emad <alaaemadhossney.ae@gmail.com>
To:     johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org
Cc:     gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller@googlegroups.com,
        Alaa Emad <alaaemadhossney.ae@gmail.com>,
        syzbot+72b99dcf4607e8c770f3@syzkaller.appspotmail.com
Subject: [PATCH] wireless/nl80211.c: fix uninitialized variable
Date:   Mon, 29 Mar 2021 18:30:36 +0200
Message-Id: <20210329163036.135761-1-alaaemadhossney.ae@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reported-by: syzbot+72b99dcf4607e8c770f3@syzkaller.appspotmail.com
Signed-off-by: Alaa Emad <alaaemadhossney.ae@gmail.com>
---
 net/wireless/nl80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 775d0c4d86c3..b87ab67ad33d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -210,7 +210,7 @@ static int validate_beacon_head(const struct nlattr *attr,
 	const struct element *elem;
 	const struct ieee80211_mgmt *mgmt = (void *)data;
 	bool s1g_bcn = ieee80211_is_s1g_beacon(mgmt->frame_control);
-	unsigned int fixedlen, hdrlen;
+	unsigned int fixedlen = 0, hdrlen;
 
 	if (s1g_bcn) {
 		fixedlen = offsetof(struct ieee80211_ext,
-- 
2.25.1


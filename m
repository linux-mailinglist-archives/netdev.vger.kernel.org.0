Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFF5B34EF50
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 19:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232236AbhC3RX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 13:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232048AbhC3RW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 13:22:59 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B07C061574;
        Tue, 30 Mar 2021 10:22:59 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id n11-20020a05600c4f8bb029010e5cf86347so1347619wmq.1;
        Tue, 30 Mar 2021 10:22:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=etdLuWb8OudHnTGScju4iFuelQF1D5YN0QKx+VliIUg=;
        b=Xd/xg1PUdNrHQgAV0iG1BsXmo6MHEfKOtyM/zrAeSrqnvNFH3Amirs5v5Qy/X+wcq6
         QMmpmZyTR/J9eHkK9A6hsHjHW8HrDD6VGgCWog+rJ+MDhxV+kiDfj6LuY7smoCboQEUt
         gk7EEpQtKNYMBQHhZpsderUpMNtImTzRzjupUj92xxWYPRpr2TKqKxaUoccXC97/fXrH
         cAOQcS43mO6yKvAGFWgUWTyM5e+dPSafoziDhTZgpfjDLBfpe9tH+/pEE2gwJHKMS6IK
         Z6IK1bvm7+rf1vcpOAzCxgq0ab2gVKRz4Kq6IwwG+THY33tu4lVTmqs0T8H3mHa3eLHP
         8dcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=etdLuWb8OudHnTGScju4iFuelQF1D5YN0QKx+VliIUg=;
        b=TP3guc2QQ50LKBBkuAgjq4+1YmYw9oK0yuY5FTHxPMKjIzSjKwfFVg+dcB89dBBA+9
         myngFRkdxUeGGtsENKqMUy86ZntO3iHVDMXzxxK5NrV/HE+40RAPW05Owjxm0J1QYzvM
         5iqt4pEvvUEZAtOeoQwtI7BA63VSJAFoq5MtGSQrBiJKJnidfNenkjJda4wP0wSV9Pv+
         tHLMlH9ZDkp6ltYtwjECXllhKrz0Aq2knvhVWGG8hjs35xkpzi9BV0/TbNHh/0GkpXU/
         YrWn9+Nagd9QDFK5dIKn7Dvq3EV/AkNPdzJPyXK1t3ciPyASkh3LpX6s4kHrfRsaIqJ6
         3Brg==
X-Gm-Message-State: AOAM530RCNths2tycjXbrLNmz65ZHn/84L60zOrKbJw59db3kNEjmufW
        XyRCvNI2D7zObxb0JxuoggpXslDQs+m0ivtK
X-Google-Smtp-Source: ABdhPJyu62dTbhj0ksMQOMovJWP1dMVyEA74m15yTC1Qeu8adpzxfy9VYpKVwkm8mvWpniEkULD67A==
X-Received: by 2002:a1c:3b43:: with SMTP id i64mr5076868wma.43.1617124977945;
        Tue, 30 Mar 2021 10:22:57 -0700 (PDT)
Received: from alaa ([197.57.128.221])
        by smtp.gmail.com with ESMTPSA id 1sm6772095wmj.0.2021.03.30.10.22.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 10:22:57 -0700 (PDT)
From:   Alaa Emad <alaaemadhossney.ae@gmail.com>
To:     johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org
Cc:     gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller@googlegroups.com,
        Alaa Emad <alaaemadhossney.ae@gmail.com>,
        syzbot+72b99dcf4607e8c770f3@syzkaller.appspotmail.com
Subject: [PATCH v2] wireless/nl80211.c: fix uninitialized variable
Date:   Tue, 30 Mar 2021 19:22:53 +0200
Message-Id: <20210330172253.10076-1-alaaemadhossney.ae@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change fix  KMSAN uninit-value in net/wireless/nl80211.c:225 , That
because of `fixedlen` variable uninitialized,So I initialized it by zero.

Reported-by: syzbot+72b99dcf4607e8c770f3@syzkaller.appspotmail.com
Signed-off-by: Alaa Emad <alaaemadhossney.ae@gmail.com>
---
Changes in v2:
  - Make the commit message more clearer.
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


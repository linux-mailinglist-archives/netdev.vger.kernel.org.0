Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FCA123C12E
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 23:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726356AbgHDVHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 17:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725863AbgHDVHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 17:07:39 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 661AEC06174A;
        Tue,  4 Aug 2020 14:07:39 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id t6so23169717pgq.1;
        Tue, 04 Aug 2020 14:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X4nVZfpA11bzJ0RFuzyjFl+xrsu2f4zFX7lnVom+av8=;
        b=mk1qdIp+4HC4+UL/kW+mW8mQ/Rw6yZzVC67WWvZcchMN2DNXgrSKLPgyq7SwpjzKiy
         3idJOI7eGfzGbfdlHS9/OHRksjqggSH5BgbC+KqkShb6TUiVvbVKpSJ4DsYBV1q17jAK
         1tcrcc8nVCZuAK2Cl/HHz4Z719deYxa7Zlf8MlJAcYi5Oon3+loWtiQFcbom+LUj4fuY
         X0hFtAhI8Qr8SREaH5mxG6n5p6omI0oD1NJuXdT1cbBJH2LdcEmngwS2+FWGUlJimBzl
         7JSf6HHPR3/RKZKnB23QEY3QwcaJSIpLANTxnrGAj9gM6IprU+49bU047/ZLbtJlWS2z
         usMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X4nVZfpA11bzJ0RFuzyjFl+xrsu2f4zFX7lnVom+av8=;
        b=h4uJUu5tjmXcaB1WNkkILkMII4xelUoBA1xeWkReBfxHTPcKfkJHHEO7Uf/d5cvFws
         2B+UGhNHO8xm0tKXatpAJnSUPNQEVnBjgyif/v1gMGhCFxflS6WAdmmN2OD9F/XdSQbP
         aVaW8mTiLYmy/ry7Ias8SjJIa5amjCynHxAVTyeBaEPpqDoWNfF0y1TSqm1NByaBFSEc
         tfGHFiqPtXWjN2CByu15aubWemlmP7xjSOiVE2ifMDuYQZ7+zd5Ed+/B76PXTs/j6hCm
         tYZWnIpd6PpEWkfW3v++cZ0UhVxcRTjcqIKGD6CWlmrCXxEMvUF3lycPIl7qFH32Ff8Z
         8gcw==
X-Gm-Message-State: AOAM532NkGTsnl8IjAEovNcHxTUxN0ZDmeJHaYVAw305jjuAVDtVqaod
        KlvvItlG223tnic/hJ+gVoI=
X-Google-Smtp-Source: ABdhPJyl6c6dDxe/VGp11VcyqUQxFYTc3kD/Ll6YHHCa/ElQt3nb70ErxeGejwYrEfJpsjXGN8X83g==
X-Received: by 2002:a05:6a00:14d0:: with SMTP id w16mr239593pfu.39.1596575258714;
        Tue, 04 Aug 2020 14:07:38 -0700 (PDT)
Received: from thinkpad.teksavvy.com (104.36.148.139.aurocloud.com. [104.36.148.139])
        by smtp.gmail.com with ESMTPSA id t28sm19979675pgn.81.2020.08.04.14.07.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 14:07:38 -0700 (PDT)
From:   Rustam Kovhaev <rkovhaev@gmail.com>
To:     johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rustam Kovhaev <rkovhaev@gmail.com>
Subject: [PATCH] cfg80211: switch from WARN() to pr_warn() in is_user_regdom_saved()
Date:   Tue,  4 Aug 2020 14:05:46 -0700
Message-Id: <20200804210546.319249-1-rkovhaev@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

this warning can be triggered by userspace, so it should not cause a
panic if panic_on_warn is set

Reported-and-tested-by: syzbot+d451401ffd00a60677ee@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=d451401ffd00a60677ee
Signed-off-by: Rustam Kovhaev <rkovhaev@gmail.com>
---
 net/wireless/reg.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 0d74a31ef0ab..86355938ae8f 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -415,10 +415,10 @@ static bool is_user_regdom_saved(void)
 		return false;
 
 	/* This would indicate a mistake on the design */
-	if (WARN(!is_world_regdom(user_alpha2) && !is_an_alpha2(user_alpha2),
-		 "Unexpected user alpha2: %c%c\n",
-		 user_alpha2[0], user_alpha2[1]))
+	if (!is_world_regdom(user_alpha2) && !is_an_alpha2(user_alpha2)) {
+		pr_warn("Unexpected user_alpha2: %c%c\n", user_alpha2[0], user_alpha2[1]);
 		return false;
+	}
 
 	return true;
 }
-- 
2.27.0


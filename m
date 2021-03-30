Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE06634EE0A
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 18:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbhC3Qha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 12:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232265AbhC3QhK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 12:37:10 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B510C061574;
        Tue, 30 Mar 2021 09:37:10 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id v4so16834988wrp.13;
        Tue, 30 Mar 2021 09:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7sRhKh3GLNxqtU4KR0efYl5BLkUT3Mu3oQdsaHdmyHo=;
        b=agyO6O3xOB04Jn8K9mJRfhjKlAjAXmP2lckMcu/SpHm1Ls5Zq4294skPiQlLMlr+N4
         hP2Tdw9ZKe1WWe3gm9ZrjGvrcHeEpx00e27I4A8vUxYgBkScMwtyES+DSvhOpEj2pkA9
         SDx2zUeXhrpghP7q/DfqzrP0DdK7SW+FqPgMSoz/IXLTcdUymsAWvqZ1DlPRWlf/6/54
         oxUk0KtwYfr3NkJiK1A+ZcqECesYxLzdI1TuGkaVXV5rDbTDdtRDuaLH5vFbkzfGCHOp
         LgWBhHMy2Oau8UZ+bTa5+WwWFBn0Xyai2H6pJiVTObGOERyufmmADa4MCa3xtDs4Ql4R
         /axg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7sRhKh3GLNxqtU4KR0efYl5BLkUT3Mu3oQdsaHdmyHo=;
        b=kJRltLBiMXqnZ7aNM4w20i6CjtNpqaKQeu5OJEnGc9ovxXWDdfiZmrOdD+uX9Tnwjn
         H2U9vSLxFlP3WzjJTsBemtxq893CdIdshnL8Oo2g7dPhIO2vus33mnKP5K9bC+6Cl85e
         Avp+EhqSX2gWQ9CYRWPhryHF+Gf4L0wp/rICZM+aZ9YoEBvQHupo1gvA1qC87hiybUs/
         a+yK66BKVxxYye0kzoLjrjXTyqGxEimBY424d3rKdJZdxibAg7atTzzNV628tLUjtpdK
         N71tQ4jT7gf+dhqvy4xOBiPzQrGbHxyCl9LqXsaRpgr76+8iiLhR+EY/Y09caObIz3yK
         6B/w==
X-Gm-Message-State: AOAM53180FUkNxoHTc6L5h6/O86dYEe3XpZSf2/LsdMQ069jsTuDC0Il
        nwT2KGyNOIyPlf8hCeqM1/Q=
X-Google-Smtp-Source: ABdhPJzRG7mcccGH3OspE8/iK0w+WYXSQRvquksBIbeZYKrfuRcBM6FJcKj190KFuW6joogs4zwoew==
X-Received: by 2002:a5d:6b86:: with SMTP id n6mr7485580wrx.52.1617122228783;
        Tue, 30 Mar 2021 09:37:08 -0700 (PDT)
Received: from alaa ([197.57.128.221])
        by smtp.gmail.com with ESMTPSA id z25sm6177108wmi.23.2021.03.30.09.37.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 09:37:08 -0700 (PDT)
From:   Alaa Emad <alaaemadhossney.ae@gmail.com>
To:     johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org
Cc:     gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller@googlegroups.com,
        Alaa Emad <alaaemadhossney.ae@gmail.com>,
        syzbot+72b99dcf4607e8c770f3@syzkaller.appspotmail.com
Subject: [PATCH v2] wireless/nl80211.c: fix uninitialized variable
Date:   Tue, 30 Mar 2021 18:37:05 +0200
Message-Id: <20210330163705.8061-1-alaaemadhossney.ae@gmail.com>
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
+	unsigned int fixedlen = 0 , hdrlen;
 
 	if (s1g_bcn) {
 		fixedlen = offsetof(struct ieee80211_ext,
-- 
2.25.1


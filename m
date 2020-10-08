Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD2D287813
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729355AbgJHPwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgJHPwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:52:21 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 029A8C061755;
        Thu,  8 Oct 2020 08:52:20 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id b193so3754636pga.6;
        Thu, 08 Oct 2020 08:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=m3D6Kmj4pHoutaz/rCS7qlyaBoowYkXG/yMmgXucQh8=;
        b=HVdQVGA8kdLw7h7OQDnSatWnt2UM4FvjoT7GntRqEcOyzYjF7DigsDKO03o2ef5Tcw
         fmLOLbbhwwWP3n/pY+60vIPtOt++aOykfC/e5j1VxiXBebp5DP9ircgq+Z1s0fG17LMA
         4CwWS/rEFEl4UgVSVeaF58BbGHGwiTdYlvzw6IYNMN5h2aOgtas0sY/ORYAgiJnfRnIg
         gdB0dLQyimHhiuwZMHvwdQHnmV6mNygOE4n7vOeJRT9/P9F9iYALq49wJabbOojpoMpb
         N9C4X5eQ4SPBm9rDXoTC+yLY7C3PopLZA5Bwsg8ZNwD2TDhnw3WM+dHAAeBsPCzrt4cE
         GoiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=m3D6Kmj4pHoutaz/rCS7qlyaBoowYkXG/yMmgXucQh8=;
        b=dR0bEVhxUdO/8bWOViv8AisO0VFMPFxmC3RZf86rwUz5WTUbmf2r4jM25b5jJ0S50i
         5MsxW4UAvIEX/CaiehqZoG6z2zfUDIEqRmO61JlZ1Yt8PWQ3FmNkq/kuwPkGXFCMMRyu
         VpufqPXcCzvztAwdqaXEp3qIJWuFT5F25wjNShDk686Mcy02tO6dPV8ogj60CmH8xJeg
         bKBwf2NDI32mVqzkLOhzFiZmj7cSdVlbQk0Flg8mroB1XTAquauHPGi5h39UeSjJn2vr
         zfuCphkQuRQmjRDAJGyCXUajFVDDOdNVwAMsCRV1TmFzhXL+HHb/RwvYP0OHo+pZsawd
         rdeg==
X-Gm-Message-State: AOAM532LDc+jpXDiqR1ccshwffGL6EUE6XxbsKboz0MUwLUWYC/PGjtm
        oNcXvOsVva8E0dLf5rKXleU=
X-Google-Smtp-Source: ABdhPJx19UvtHzx8iv51HU3jzWKPCcjTX+jkuGDvZg8tt3IcRR7V4sUWQk+TN3cSc6hDhAXfYGz/tw==
X-Received: by 2002:a17:90a:7089:: with SMTP id g9mr9042123pjk.4.1602172339528;
        Thu, 08 Oct 2020 08:52:19 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.52.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:52:18 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 001/117] mac80211: set .owner to THIS_MODULE in debugfs_netdev.c
Date:   Thu,  8 Oct 2020 15:50:13 +0000
Message-Id: <20201008155209.18025-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: e9f207f0ff90 ("[MAC80211]: Add debugfs attributes.")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/mac80211/debugfs_netdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index fe8a7a87e513..8efa31ae7334 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -127,6 +127,7 @@ static const struct file_operations name##_ops = {			\
 	.write = (_write),						\
 	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
+	.owner = THIS_MODULE,						\
 }
 
 #define _IEEE80211_IF_FILE_R_FN(name)					\
-- 
2.17.1


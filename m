Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0B083627CE
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 20:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243997AbhDPSgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 14:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241863AbhDPSgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 14:36:08 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD15C061574
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 11:35:43 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id f29so19772446pgm.8
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 11:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SD4eH82CdyEsyaEl3Vacc+rj/EvkWfwC7vF1Mw4S1o0=;
        b=lBYbx2fnKdqAWGCjge+t20UNggpjCpB4tPrd84l/Uuje0OCeuTNSqM5Ug/aKHaWnbx
         gKUVWXJwnqGS62KCAzjcLKpWrYgnfXaWtKm08ukT56w0ZC1vRwe2Sk0VRtUcSA4HFvG1
         Ohtcv+swdQe/N4E0BIjEAFK1SSw3Xaj4SQ4QqCNw/AK2watwE/J2nyNprdzX1J7qUcR9
         wr93hoDRnW5yFL1bmaA+wKE0MChZGUDbL9J7DOPH6KGD9dycJ5k3CwZRkVTtNScmLnRz
         ZAwa0VySTGeKwNsiticBxC48RI4ETOfclQDbOcM7Pigz8ho/tZH4RhwhhnXEN2+ZR5W/
         PhlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SD4eH82CdyEsyaEl3Vacc+rj/EvkWfwC7vF1Mw4S1o0=;
        b=Dom745uJYUxWpI800sXLEheuho1faxNr6LZsX5+0s5kM/c4f2cefGq0u/ET3ABkSll
         AK/Z79KLjWGxWKwsJUTiLU8MWvB2jbhOLzFIn/7tlNo0gl5+07Xev+mbZoXKIhsTU0dg
         j4asbE/6/xr3dxlBKlHcgtc5cpGYecQMEthDTBjDG5/Q4OQD5jJXa6vIy8x/yTpo6hms
         LZcLv1s1rwiTobg2BEgOXWx8OnPeliUtzZHAqX4SXOe85Gl3G+WRR2Js7CNW+A89Xhm+
         0K5cMDsqPhybjcJX1KNRAXvUcrOotY3XfVVaPmF0/BRAHNURa0CAxz0so1bwmmhCqhWw
         iwSw==
X-Gm-Message-State: AOAM531aVe57GNRaFMQ0iOn25R2C/qdtLYuUtxKwV5/1HAIaeXHroSyk
        yYWnXKYAyToJK4SUxrsf56XvBJ9WF0o=
X-Google-Smtp-Source: ABdhPJxiOdttWjobHfNf7Q6xtFLlE0KtAHdMW7BSVPU1qf9/tjWNG6DC7VVQaLmH5cZ97UyjrzXqzg==
X-Received: by 2002:a63:330b:: with SMTP id z11mr414756pgz.32.1618598143063;
        Fri, 16 Apr 2021 11:35:43 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:8178:2218:96f0:c55c])
        by smtp.gmail.com with ESMTPSA id u4sm2424632pfk.56.2021.04.16.11.35.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 11:35:42 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next] scm: fix a typo in put_cmsg()
Date:   Fri, 16 Apr 2021 11:35:38 -0700
Message-Id: <20210416183538.1194197-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.31.1.368.gbe11c130af-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

We need to store cmlen instead of len in cm->cmsg_len.

Fixes: 38ebcf5096a8 ("scm: optimize put_cmsg()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Jakub Kicinski <kuba@kernel.org>
---
 net/core/scm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/scm.c b/net/core/scm.c
index bd96c922041d22a2f3b7ee73e4b3183316f9b616..ae3085d9aae8adb81d3bb42c8a915a205476a0ee 100644
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -232,7 +232,7 @@ int put_cmsg(struct msghdr * msg, int level, int type, int len, void *data)
 		if (!user_write_access_begin(cm, cmlen))
 			goto efault;
 
-		unsafe_put_user(len, &cm->cmsg_len, efault_end);
+		unsafe_put_user(cmlen, &cm->cmsg_len, efault_end);
 		unsafe_put_user(level, &cm->cmsg_level, efault_end);
 		unsafe_put_user(type, &cm->cmsg_type, efault_end);
 		unsafe_copy_to_user(CMSG_USER_DATA(cm), data,
-- 
2.31.1.368.gbe11c130af-goog


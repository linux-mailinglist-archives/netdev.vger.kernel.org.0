Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9E121500
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 09:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbfEQH7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 03:59:44 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37319 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727800AbfEQH7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 03:59:44 -0400
Received: by mail-pf1-f196.google.com with SMTP id g3so3297959pfi.4;
        Fri, 17 May 2019 00:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=e+cYjn/QHZqjyb98SahRwhYR3b8ZyPa5/0Rrq4E7Mbk=;
        b=YW+cgWC5iVLIOyziymhXzyaxaHkVoX7DEO0jimcP9LjPY5Grg+sAZWR1M6FqEn7+WN
         agMLbm6DZSpwXdMZd6eqRiiRRA+N/YZUJpUbRSpUtvVmsqP4CUqqiWJDEMmy1FhB5ilJ
         H4HXd+ZC66/8B41uMFlBue/Q3w93JpBMt1Zni8Lg6wN+tBoPU21z6Mu+L6ecVdoAtU9D
         liStQL+1tsn6qoWLf3tMJTAgv4aNiff+u8wFXGiJENbRHACTsB04G8IIskwcftyszN4g
         GainFm8rzB0DzIQ11LcNuRgeV2yw7FCpk/6Z/cU+AACJIYWXnPaaxnxJxkiJ4yIKFkWA
         MF3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=e+cYjn/QHZqjyb98SahRwhYR3b8ZyPa5/0Rrq4E7Mbk=;
        b=lMdscYMCSQg4BE4nORwylop36MuDjjxzz3bxt16WO6RCu6yHip+di+ioT9CahdJVDV
         O4J3wvhFn5TebxxdoiF60IGNlJPUqW9zfkFvkCCOPohN4WX4HDpuDfTr1PLlINsO8/d/
         9swbtmRYTRShbhTi4iNM2l0rq9IT7jbdRR/qaRwPd7epce+tUjSFtGZ9MeDFmwEbBhL/
         Oa/Jt9ykFoMcnkWGa1H6ekrIq14NwqkZRPqlgKvdZ3l8hUeW2zNKaTri+CnPp+hKMpRR
         sejl8BCMwYHU50tFhaeObbw+svqwgZRUFJSnJeSOi14mqIlHzJxBf0nUNZQWKcg2x+qG
         Wcow==
X-Gm-Message-State: APjAAAVDIH6jTWj8NYBAjXZUgMpWwZfRTKD2Dq7RPMfvVFxJ+GuUBPtE
        BXcEmejL14nWxedQXGg5CRk=
X-Google-Smtp-Source: APXvYqwaPSO7sciUnMA7lAOuHW97sk00RtZt8QQm+ZKMayoZl+Opd10q6to48YQ2TdPf1TZmgmJFSA==
X-Received: by 2002:a63:9242:: with SMTP id s2mr38323853pgn.220.1558079983538;
        Fri, 17 May 2019 00:59:43 -0700 (PDT)
Received: from localhost.localdomain ([185.241.43.160])
        by smtp.gmail.com with ESMTPSA id j2sm2911052pfb.157.2019.05.17.00.59.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 May 2019 00:59:42 -0700 (PDT)
From:   Weikang shi <swkhack@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        swkhack <swkhack@gmail.com>
Subject: [PATCH] net: caif: fix the value of size argument of snprintf
Date:   Fri, 17 May 2019 15:59:22 +0800
Message-Id: <20190517075922.29123-1-swkhack@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: swkhack <swkhack@gmail.com>

Because the function snprintf write at most size bytes(including the
null byte).So the value of the argument size need not to minus one.

Signed-off-by: swkhack <swkhack@gmail.com>
---
 net/caif/cfdbgl.c  | 2 +-
 net/caif/cfdgml.c  | 3 +--
 net/caif/cfutill.c | 2 +-
 net/caif/cfveil.c  | 2 +-
 net/caif/cfvidl.c  | 2 +-
 5 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/caif/cfdbgl.c b/net/caif/cfdbgl.c
index 7aae0b568..cce839bf4 100644
--- a/net/caif/cfdbgl.c
+++ b/net/caif/cfdbgl.c
@@ -26,7 +26,7 @@ struct cflayer *cfdbgl_create(u8 channel_id, struct dev_info *dev_info)
 	cfsrvl_init(dbg, channel_id, dev_info, false);
 	dbg->layer.receive = cfdbgl_receive;
 	dbg->layer.transmit = cfdbgl_transmit;
-	snprintf(dbg->layer.name, CAIF_LAYER_NAME_SZ - 1, "dbg%d", channel_id);
+	snprintf(dbg->layer.name, CAIF_LAYER_NAME_SZ, "dbg%d", channel_id);
 	return &dbg->layer;
 }
 
diff --git a/net/caif/cfdgml.c b/net/caif/cfdgml.c
index 3bdddb32d..58fdb99a3 100644
--- a/net/caif/cfdgml.c
+++ b/net/caif/cfdgml.c
@@ -33,8 +33,7 @@ struct cflayer *cfdgml_create(u8 channel_id, struct dev_info *dev_info)
 	cfsrvl_init(dgm, channel_id, dev_info, true);
 	dgm->layer.receive = cfdgml_receive;
 	dgm->layer.transmit = cfdgml_transmit;
-	snprintf(dgm->layer.name, CAIF_LAYER_NAME_SZ - 1, "dgm%d", channel_id);
-	dgm->layer.name[CAIF_LAYER_NAME_SZ - 1] = '\0';
+	snprintf(dgm->layer.name, CAIF_LAYER_NAME_SZ, "dgm%d", channel_id);
 	return &dgm->layer;
 }
 
diff --git a/net/caif/cfutill.c b/net/caif/cfutill.c
index 1728fa447..be7c43a92 100644
--- a/net/caif/cfutill.c
+++ b/net/caif/cfutill.c
@@ -33,7 +33,7 @@ struct cflayer *cfutill_create(u8 channel_id, struct dev_info *dev_info)
 	cfsrvl_init(util, channel_id, dev_info, true);
 	util->layer.receive = cfutill_receive;
 	util->layer.transmit = cfutill_transmit;
-	snprintf(util->layer.name, CAIF_LAYER_NAME_SZ - 1, "util1");
+	snprintf(util->layer.name, CAIF_LAYER_NAME_SZ, "util1");
 	return &util->layer;
 }
 
diff --git a/net/caif/cfveil.c b/net/caif/cfveil.c
index 262224581..35dd3a600 100644
--- a/net/caif/cfveil.c
+++ b/net/caif/cfveil.c
@@ -32,7 +32,7 @@ struct cflayer *cfvei_create(u8 channel_id, struct dev_info *dev_info)
 	cfsrvl_init(vei, channel_id, dev_info, true);
 	vei->layer.receive = cfvei_receive;
 	vei->layer.transmit = cfvei_transmit;
-	snprintf(vei->layer.name, CAIF_LAYER_NAME_SZ - 1, "vei%d", channel_id);
+	snprintf(vei->layer.name, CAIF_LAYER_NAME_SZ, "vei%d", channel_id);
 	return &vei->layer;
 }
 
diff --git a/net/caif/cfvidl.c b/net/caif/cfvidl.c
index b3b110e8a..73615e3b3 100644
--- a/net/caif/cfvidl.c
+++ b/net/caif/cfvidl.c
@@ -29,7 +29,7 @@ struct cflayer *cfvidl_create(u8 channel_id, struct dev_info *dev_info)
 	cfsrvl_init(vid, channel_id, dev_info, false);
 	vid->layer.receive = cfvidl_receive;
 	vid->layer.transmit = cfvidl_transmit;
-	snprintf(vid->layer.name, CAIF_LAYER_NAME_SZ - 1, "vid1");
+	snprintf(vid->layer.name, CAIF_LAYER_NAME_SZ, "vid1");
 	return &vid->layer;
 }
 
-- 
2.17.1


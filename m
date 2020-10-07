Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC9F285CA4
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 12:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728032AbgJGKN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 06:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728025AbgJGKN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 06:13:28 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DFB0C061755
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 03:13:28 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id g29so1094379pgl.2
        for <netdev@vger.kernel.org>; Wed, 07 Oct 2020 03:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e4124ZcFqiqae4etVgXkb0JmPtNmt23EjDbzK6zJ4Ds=;
        b=uSOVFrro4nr1hbuBaZoDzAoLC9nwe81KWhN2vNBsg7UeSHzXy6yWG93+TY/er1rcuW
         PDa0nbvbsISgJhEu5CsJJW84/WwUL/xSHILrssR6EKI3kh+wpdm+qNi52lMo7INQqeXj
         cYOWVcj7J/liEbSKE5xiqnnPrzk9/VZNwFQcQrPEGH63PyfkE23yrXM3G4GzIv7nexIF
         QND1RIcqVizY2sUIP8w8w3HyrlCrLEGcpfj02Snd3npa/V0/yn2cf6ql7XdpPFA8+UrY
         j7jHiyDgWOgL1SuWjVo4I6860EvofOOX2VJv7QsqvsM7lC/daXpDKUyooCQY/4Bdw7c9
         oLYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e4124ZcFqiqae4etVgXkb0JmPtNmt23EjDbzK6zJ4Ds=;
        b=VywFXTD8IDc3bOSf0jpUsYDim9wopX2Pe1dhf4+ZiojdCyMTybhzFvzbA2Ck3HJOZP
         SOIAxwvrc35Rds8yyWRK4X1zDbVArJ2svKV4MVC2uSoP/Cxtr2r+3TVFJHDpNDZt+BMm
         ZoBfyDCkvqlqvgcPK9vvimH91BJcwaPQfvyThH4braYtpq+UvYVzZsOc0xM9tgVREwe0
         ZejmUfo5vLomYZ43CxlKxzulYQmk/5UYQj7uj5dgtP5Cce87LLE6sAaJL3YQoUzwovdr
         DdZj9gfdcMla0/8y3Dk20cZ9JmR9+CwGBOAypwW/ZsayMz9VDqAHWFvu2+jAtsP04Q/5
         Gtzw==
X-Gm-Message-State: AOAM530jHGTIxXpxRD8kSye7mHnnslU79EOkDE0rb/0ejldd5/W7DBxT
        Dtk9Pps/JcMl9FkdKPzG39c=
X-Google-Smtp-Source: ABdhPJxL4P1eSYGZgjVTaGnyQrY+Xx9rpKnFqBJhHqfO4GGNT9eZD99JvDpcYFCVKJq1haaZTppbrQ==
X-Received: by 2002:aa7:9f04:0:b029:13e:d13d:a08c with SMTP id g4-20020aa79f040000b029013ed13da08cmr2299359pfr.35.1602065608115;
        Wed, 07 Oct 2020 03:13:28 -0700 (PDT)
Received: from localhost.localdomain ([49.207.204.22])
        by smtp.gmail.com with ESMTPSA id q24sm1105291pgb.12.2020.10.07.03.13.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 03:13:27 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     gerrit@erg.abdn.ac.uk, kuba@kernel.org, edumazet@google.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        johannes@sipsolutions.net, alex.aring@gmail.com,
        stefan@datenfreihafen.org, santosh.shilimkar@oracle.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [net-next v2 8/8] net: xfrm: convert tasklets to use new tasklet_setup() API
Date:   Wed,  7 Oct 2020 15:42:19 +0530
Message-Id: <20201007101219.356499-9-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201007101219.356499-1-allen.lkml@gmail.com>
References: <20201007101219.356499-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
---
 net/xfrm/xfrm_input.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 37456d022..be6351e3f 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -760,9 +760,9 @@ int xfrm_input_resume(struct sk_buff *skb, int nexthdr)
 }
 EXPORT_SYMBOL(xfrm_input_resume);
 
-static void xfrm_trans_reinject(unsigned long data)
+static void xfrm_trans_reinject(struct tasklet_struct *t)
 {
-	struct xfrm_trans_tasklet *trans = (void *)data;
+	struct xfrm_trans_tasklet *trans = from_tasklet(trans, t, tasklet);
 	struct sk_buff_head queue;
 	struct sk_buff *skb;
 
@@ -818,7 +818,6 @@ void __init xfrm_input_init(void)
 
 		trans = &per_cpu(xfrm_trans_tasklet, i);
 		__skb_queue_head_init(&trans->queue);
-		tasklet_init(&trans->tasklet, xfrm_trans_reinject,
-			     (unsigned long)trans);
+		tasklet_setup(&trans->tasklet, xfrm_trans_reinject);
 	}
 }
-- 
2.25.1


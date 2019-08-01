Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3047D259
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 02:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728540AbfHAApS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 20:45:18 -0400
Received: from mail-pf1-f181.google.com ([209.85.210.181]:38146 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728417AbfHAApR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 20:45:17 -0400
Received: by mail-pf1-f181.google.com with SMTP id y15so32816163pfn.5
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 17:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Qdu9lEx41c+ZHa0YXQznt4V45evW3QjJLERtup6N8hg=;
        b=BrKrbDwr8IQWngJqwGL+A6XOE3YzkAjJRxOIEx1D5sdIR90xBopv/UElcrvCTVEBjw
         JeQWxwrcf/s0Ha18fYKmgAVvCXPiVrJr6cZTzmBhOKJNO2DyKWKfNCPOQ0Cw8nGJNjBK
         wqsAUVkJdzkvh6JdfHx7no1m/H7WBCjeWj7djABC9EKv+SbmuPuDBlN6wMy5wRU3zZVg
         qFl/eQsKS0V2R2oIuY1/i9QZ3JjpfiaeoVjIT9jmKCzx+yEiSuyf0leJOO+IGW8NsiMG
         qyONNUa7g3Pf5SwlkYN33ckOo49Su1nGp6cqxS9h5FJxmmoHGC7oVzr/GM5LmcXt40xt
         PL5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Qdu9lEx41c+ZHa0YXQznt4V45evW3QjJLERtup6N8hg=;
        b=ReV4kF6OX/lIji7xjL3A69Izfv3Lvhqpq1oZKUnFonjsEXYlqOWUvh0Ha/3V/Tf+PE
         FcEmuetMSrLnSGT0IH8QLVsiuarDVoO16nuvRb3jjci4pEidOWaPxDxawt/xlW66h7OW
         jQXfIjWZ/gg1POlbSC2kNLfrJ5h8aTzdkpZ9aFoue5j0zeJf5nROKiFERSuwixKcfQ2X
         OFpjHdinEZ0C5l49QsE4ggWJbG+jgOqwLD7ZBHf8yS6C8vRIgeFp7HxBE9UlPTtPNTcO
         p+zNLSu8gkL4D0HaFWFXn/swsNpEJ2y/mN2/E83/uBZJXsNlhaJltVEjsuvWc8dZnyYz
         Z3Uw==
X-Gm-Message-State: APjAAAWUbKi0CPq1RBp9+a3U4JguxHPySqWJgI/FTcq8qyfL7bfUrpA1
        CywnVUx5lt1ZhCk6sch1f24=
X-Google-Smtp-Source: APXvYqw0tja6aXaJnvzHXfWr41HHIissNF4jmqko0kADCk45CHaxTgFw4oeI/tZQ0yEKrZjE+O/92w==
X-Received: by 2002:a62:e710:: with SMTP id s16mr51736475pfh.183.1564620316302;
        Wed, 31 Jul 2019 17:45:16 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id f32sm2435978pgb.21.2019.07.31.17.45.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 31 Jul 2019 17:45:15 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     jiri@resnulli.us, chrism@mellanox.com
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [RFC iproute2 3/4] Revert "tc: fix batch force option"
Date:   Wed, 31 Jul 2019 17:45:05 -0700
Message-Id: <20190801004506.9049-4-stephen@networkplumber.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190801004506.9049-1-stephen@networkplumber.org>
References: <20190801004506.9049-1-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit b133392468d1f404077a8f3554d1f63d48bb45e8.
---
 tc/tc.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/tc/tc.c b/tc/tc.c
index c115155b2234..b7b6bd288897 100644
--- a/tc/tc.c
+++ b/tc/tc.c
@@ -334,7 +334,6 @@ static int batch(const char *name)
 	int batchsize = 0;
 	size_t len = 0;
 	int ret = 0;
-	int err;
 	bool send;
 
 	batch_mode = 1;
@@ -403,9 +402,9 @@ static int batch(const char *name)
 			continue;	/* blank line */
 		}
 
-		err = do_cmd(largc, largv, tail == NULL ? NULL : tail->buf,
+		ret = do_cmd(largc, largv, tail == NULL ? NULL : tail->buf,
 			     tail == NULL ? 0 : sizeof(tail->buf));
-		if (err != 0) {
+		if (ret != 0) {
 			fprintf(stderr, "Command failed %s:%d\n", name,
 				cmdlineno - 1);
 			ret = 1;
@@ -427,17 +426,15 @@ static int batch(const char *name)
 				iov->iov_len = n->nlmsg_len;
 			}
 
-			err = rtnl_talk_iov(&rth, iovs, batchsize, NULL);
-			put_batch_bufs(&buf_pool, &head, &tail);
-			free(iovs);
-			if (err < 0) {
+			ret = rtnl_talk_iov(&rth, iovs, batchsize, NULL);
+			if (ret < 0) {
 				fprintf(stderr, "Command failed %s:%d\n", name,
-					cmdlineno - (batchsize + err) - 1);
-				ret = 1;
-				if (!force)
-					break;
+					cmdlineno - (batchsize + ret) - 1);
+				return 2;
 			}
+			put_batch_bufs(&buf_pool, &head, &tail);
 			batchsize = 0;
+			free(iovs);
 		}
 	} while (!lastline);
 
-- 
2.20.1


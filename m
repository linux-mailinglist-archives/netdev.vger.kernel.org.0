Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90599143F02
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 15:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729187AbgAUONO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 09:13:14 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44634 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727508AbgAUONO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 09:13:14 -0500
Received: by mail-pf1-f193.google.com with SMTP id 62so1555840pfu.11
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 06:13:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=R8o/e98Y1o4b0t9zPieroZgdORNBdpNL7fXG7tccg/Q=;
        b=T8PyxVI1rxTLmKO9kVr+k2KZMan8b+EbqdnIcLfBhTAbTBIyMlDfrGRejSB8/MFhbR
         dMmpz9K218prYYCmk5gJmfQO4xk+3h+VzXAJqOVhTYqbZ5m7NIreCtNbj8ykXldksx2N
         Q53G17Le7LEyovJ79+hLePqQEYPy1SThZybntyq4Q62XfpriTYza3glhrzVGt6mGU0/x
         KkHPPSJKIf8wkTF4y/x7bvb/S4qTTF9uGPdrCuwKAclUbTz7/hsjw8sKZ9g8+1U+lcLo
         uFJ9IsH1FepkOYQpAIvkxo2PaqKjMsuvUwJXLV2Ends599PNyLalfTocObrKKE1LOOUX
         Zjww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=R8o/e98Y1o4b0t9zPieroZgdORNBdpNL7fXG7tccg/Q=;
        b=aKYhUIC7rTyOwpSphzr8IiBAzOgizcgla8StwoHBuGijz2PAxDS899TjjkOPb+VNPe
         FvnqFvIKtI7FKDQHp8omTEgF8tIktupRl4wW5Kq4fEzddrssUzJ29TdCfuX6AV+2LrFp
         9jCFj5PssNge1/5LULgR3sCV/wq2JL6HaKHY9SiNKJQhzcS8ZNQbGr2KUMrQ2Ot8xipl
         HOtti/7zADLKGctzFzVuKaT7W0HFUZauCIHYa78zOtywABiXAdvaC033mxMISCsaD3T9
         bre7DC0e2JLO2Wo0mIkyQP5sFFZWLNurVV+KTshW9uOKp6bkVUHW2lNM9TXt/JkPg/3O
         qQMQ==
X-Gm-Message-State: APjAAAUk0DRJJB09P3tqQ/vicrzz8DiGHWGgzzoBR8cofEIc88WXrMWv
        ESliHvtAK24yaa0v7xYyrwrTxbcCtN6XvA==
X-Google-Smtp-Source: APXvYqzoDlghdF6wfrRj/yoFkclxTKR8skZVkaZiTaDRWKXXiQCOEbSHOFuYa37ft7mjjL/VJ2cmZQ==
X-Received: by 2002:a63:2355:: with SMTP id u21mr5580669pgm.179.1579615993695;
        Tue, 21 Jan 2020 06:13:13 -0800 (PST)
Received: from localhost.localdomain ([223.186.212.224])
        by smtp.gmail.com with ESMTPSA id y203sm44836443pfb.65.2020.01.21.06.13.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2020 06:13:13 -0800 (PST)
From:   gautamramk@gmail.com
To:     netdev@vger.kernel.org
Cc:     "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>,
        Dave Taht <dave.taht@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Leslie Monis <lesliemonis@gmail.com>,
        Gautam Ramakrishnan <gautamramk@gmail.com>
Subject: [PATCH net-next v4 02/10] pie: use U64_MAX to denote (2^64 - 1)
Date:   Tue, 21 Jan 2020 19:42:41 +0530
Message-Id: <20200121141250.26989-3-gautamramk@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200121141250.26989-1-gautamramk@gmail.com>
References: <20200121141250.26989-1-gautamramk@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>

Use the U64_MAX macro to denote the constant (2^64 - 1).

Signed-off-by: Mohit P. Tahiliani <tahiliani@nitk.edu.in>
Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
Signed-off-by: Gautam Ramakrishnan <gautamramk@gmail.com>
---
 include/net/pie.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/pie.h b/include/net/pie.h
index 440213ec83eb..7ef375db5bab 100644
--- a/include/net/pie.h
+++ b/include/net/pie.h
@@ -10,8 +10,8 @@
 
 #define QUEUE_THRESHOLD 16384
 #define DQCOUNT_INVALID -1
-#define DTIME_INVALID 0xffffffffffffffff
-#define MAX_PROB 0xffffffffffffffff
+#define DTIME_INVALID U64_MAX
+#define MAX_PROB U64_MAX
 #define PIE_SCALE 8
 
 /* parameters used */
-- 
2.17.1


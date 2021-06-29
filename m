Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41CFE3B7385
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 15:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233478AbhF2Nzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 09:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233315AbhF2Nzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 09:55:46 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55FEDC061760
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 06:53:18 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id cs1-20020a17090af501b0290170856e1a8aso1972124pjb.3
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 06:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8xOEtj5mnztXicwvYwri1sbc7OMDUP0KqeYQpkbWHXQ=;
        b=G3eJKTxT7iMvDsl9sV9OLiz7w1xw26uiDDhFuQh2B1TcHbc/Vyc/Mpc9h14zMyFdSA
         vEtLm9L8vLAKXrxS23F2JYxaW4ULgn5fqAQJCR7NrF7slIGFoGvl+H/PJkBrAxEKRBww
         RORaeqol44GtgrsLuZjBI3+SKV0a5anmfRdrp7tZO8VrGknanki5a7pD9MMqh/aElxMi
         1bIYMeG5ZnHRj/VwfQuyCgwvF5ZzXsTAed9nIBtSjxjeLU3Qn7ArQ8pVO4z6gPWmnTyD
         6bVdR6jUixJaxAu4hdvLDJhmgUoO6deXY9tA8wIuRhWBMEqWT19MqTquD6XPJoQEsPor
         Zv8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8xOEtj5mnztXicwvYwri1sbc7OMDUP0KqeYQpkbWHXQ=;
        b=fc5BOWZQxkJkXR2MpkY7ElzO+MHiz9NeCKsCRo72olKp+g+HBUTv0i5gIytMaZS4kJ
         aS7lpx04/zyEt3+7hf74/SblfrepHQybnUbLQCQNu8DfTDvpzRwXpGa/AshKvyq9jiw2
         Oht/uiOHtQf6+VjXkystxxz+zEjydbHzsfqBed+rPRrct5AFlbMgTELYid+Z8/pSB2oV
         A9JFrwFsIgCvNPYtxsGUCIvoR3xnUk6miorllUDmsQl4h9M9vQHRj89u2WpLLjViqVG4
         nQGzWztlVekOnl6FqgJu2I+5Ipny8de/it3xxz/SMKUsjxf/C7sbNN/WxW2zwKtp3iYJ
         TBWA==
X-Gm-Message-State: AOAM5332oFbgNNdKJYWAteUp6VrRwBiSFpY/owu8G2v/8FfpA9m/fjzo
        ZKaCmWFtGXHoz/wnJzEJ2w8=
X-Google-Smtp-Source: ABdhPJzU/CVL4W5r8a59HeQ2+l/Z+FyCWnYc2ruielLbPfbfLR6aoWPI0VuAmtfJwnxJ8q4FDNSNkw==
X-Received: by 2002:a17:902:ce91:b029:127:9386:932d with SMTP id f17-20020a170902ce91b02901279386932dmr28162666plg.5.1624974797928;
        Tue, 29 Jun 2021 06:53:17 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6838:b492:569f:2a9a])
        by smtp.gmail.com with ESMTPSA id m14sm18806807pgu.84.2021.06.29.06.53.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 06:53:17 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next] tcp: change ICSK_CA_PRIV_SIZE definition
Date:   Tue, 29 Jun 2021 06:53:14 -0700
Message-Id: <20210629135314.1070666-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Instead of a magic number (13 currently) and having
to change it every other year, use sizeof_field() macro.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/inet_connection_sock.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index 3c8c59471bc19d53c0cebd4a7e5ef42886d34783..b06c2d02ec84e96c6222ac608473d7eaf71e5590 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -135,7 +135,7 @@ struct inet_connection_sock {
 	u32			  icsk_user_timeout;
 
 	u64			  icsk_ca_priv[104 / sizeof(u64)];
-#define ICSK_CA_PRIV_SIZE      (13 * sizeof(u64))
+#define ICSK_CA_PRIV_SIZE	  sizeof_field(struct inet_connection_sock, icsk_ca_priv)
 };
 
 #define ICSK_TIME_RETRANS	1	/* Retransmit timer */
-- 
2.32.0.93.g670b81a890-goog


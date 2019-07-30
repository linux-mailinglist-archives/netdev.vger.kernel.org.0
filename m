Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6687A8BF
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 14:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730011AbfG3Miu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 08:38:50 -0400
Received: from mail-pl1-f170.google.com ([209.85.214.170]:45446 "EHLO
        mail-pl1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729579AbfG3Miu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 08:38:50 -0400
Received: by mail-pl1-f170.google.com with SMTP id y8so28869771plr.12;
        Tue, 30 Jul 2019 05:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=P+auAfI6DiqKAPOLSQ5VazEmxtgO6mrEHHqE+Zds81Q=;
        b=DB7EOZqV6UqioLKcSVrz9MEj9HIOUr3UjlFsiK33kmXNLSJ1WcBdc+URQoMDkaKC+T
         o63JbZymWJixzXArw7L1Qyeh7xhLzUrL7BfsT1f98qVDHEF8TPvUUmtkNeP8Gf9BiClP
         O3BcL1R0QTuZjfrJY4GXkV06uub5eeUurwgOprv/+t6qRNnT1/fzJalQye6aAoti/7pt
         +OdSh/k5ZRGZOw8eB8oCVwszNW06jFbAIm7eeBIataowRPsrCDLCFmQfwXZ4ebskzWJd
         2J4+8liR2KhjTiyQeDIU1On7swLZslkSYp2TmixFhix3R/IP7a529pZZgnvSZmiSXom3
         PRfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=P+auAfI6DiqKAPOLSQ5VazEmxtgO6mrEHHqE+Zds81Q=;
        b=YHcTKWli1qaFC+c05QPWSciuBOE7zivrlAWCZAo1lHIrTZdcbChF4FjGW9k/fkLvoj
         u62NxJd2UooA4DilYRAFil2rSuK7jAutdZP+w5uL9FHIbB7wWi3bIrE0NLirbSremWDy
         IppSDC1uMa/yQzvCvzo6vOje2a2nHZEgW1zymW9hIWhIaHb3Zuz74WW1/sJ80uu8uoas
         Qdj7G69JBoPYP81TKL+VXhDZbEuLMbNu9I6LC+u/MCdAbG5QfDGd1gZlQEfvg/oVKuRY
         pMlk0DdtHw2F9NY8GYlNPMySaVA56D86k5CnGLNUeKREB7Oex+VouQWqJ/PmMPbGdZqK
         ndUw==
X-Gm-Message-State: APjAAAXYkCHIhH8shiWblrmItjyi7VK38NRpIyJTdLWYF3qtIZbwlpXz
        VLsn9YqW3ixYeZUrSKGvPrSUWfmX
X-Google-Smtp-Source: APXvYqzUBh8OeHvGxEjOGac65tDaqPbZYUr/lgu296YI4Uc0RzJTsPMMzgEcMvbmcuSxolDExMsBFg==
X-Received: by 2002:a17:902:e282:: with SMTP id cf2mr116476151plb.301.1564490329611;
        Tue, 30 Jul 2019 05:38:49 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id r6sm146503092pjb.22.2019.07.30.05.38.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 05:38:48 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net
Subject: [PATCHv2 net-next 2/5] sctp: check addr_size with sa_family_t size in __sctp_setsockopt_connectx
Date:   Tue, 30 Jul 2019 20:38:20 +0800
Message-Id: <2fe592e724eee4e9b00097485a5bccf317907874.1564490276.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <bb6e9856c2db0f24b91fb326fbe3c9c013f2459b.1564490276.git.lucien.xin@gmail.com>
References: <cover.1564490276.git.lucien.xin@gmail.com>
 <bb6e9856c2db0f24b91fb326fbe3c9c013f2459b.1564490276.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1564490276.git.lucien.xin@gmail.com>
References: <cover.1564490276.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now __sctp_connect() is called by __sctp_setsockopt_connectx() and
sctp_inet_connect(), the latter has done addr_size check with size
of sa_family_t.

In the next patch to clean up __sctp_connect(), we will remove
addr_size check with size of sa_family_t from __sctp_connect()
for the 1st address.

So before doing that, __sctp_setsockopt_connectx() should do
this check first, as sctp_inet_connect() does.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index aa80cda..e9c5b39 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1311,7 +1311,8 @@ static int __sctp_setsockopt_connectx(struct sock *sk,
 	pr_debug("%s: sk:%p addrs:%p addrs_size:%d\n",
 		 __func__, sk, addrs, addrs_size);
 
-	if (unlikely(addrs_size <= 0))
+	/* make sure the 1st addr's sa_family is accessible later */
+	if (unlikely(addrs_size < sizeof(sa_family_t)))
 		return -EINVAL;
 
 	kaddrs = memdup_user(addrs, addrs_size);
-- 
2.1.0


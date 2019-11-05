Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0F2F091C
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 23:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387403AbfKEWMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 17:12:07 -0500
Received: from mail-pg1-f202.google.com ([209.85.215.202]:48335 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728515AbfKEWMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 17:12:06 -0500
Received: by mail-pg1-f202.google.com with SMTP id q20so3450241pgj.15
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 14:12:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=RiORQ2X1tZhUyZD3xj19+UWoTeUyqzwOxOpBa0lgcj0=;
        b=iEhwo3wfPybTBkqkbeBVadfaFu9upn1b0zcAx3PgCM0IXOlcMi/FKVRC8YHunADu04
         ag2mJAzXZSve+EcNz/QaTm3yjiqoTP4jjF81R8X0R3RvRt+3gZH3j3XYy5JkDJJCqx7L
         OVaBjkmeZF/mOk9r8/8TZEuvHjXVto17S070OYRISvlVStgpZud3F0fdCtUi1rthJPWK
         ych5ZL8ekBlyIOBG+MfsxHJN6bcSfCRfFdleN3L/llo8CJeu0cbu9uqhjNDuCJDNSCP9
         EvcPkKYSVHmVvoxPqjXHySOXjAIa6Y7movKVcFeJgvbaCySF/JNPdd9+SQELH3QsnFe5
         va4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=RiORQ2X1tZhUyZD3xj19+UWoTeUyqzwOxOpBa0lgcj0=;
        b=UqMXF0S6SkQ+uW7sViIb47PWYOKoMAF3nNiZ4/9XtjfAUtFrjwCDCqRj7fW9Uk11qU
         ZD95s95bA8NLAPc2WxxB2KXgn8BV74IeurZir5x6xfhKm8kLzBkyIikSN6X/SJaUTljp
         tEhCW/5YbxtoUiy5IJBgwPBFL3Sy369AEGqBNdvpiXSDKTb590NrrkXCjPIxlf+97oOg
         qbB6kG2uZ5ATzVUO/BL4aG8iM3sLHo+Sv77FuEhSYtxyJBkIwwvOO0n1M9blJR3rwH5y
         jMjxy4oY22b4f+rfhUgHUFtH3KD0SpZUjr/ogWp3Xd8djACW09lficrevYhAUwMrACI4
         G9Ng==
X-Gm-Message-State: APjAAAUTieKrPf1mB8gCq2TJFLQO+yiLi/SQ/p9IAUp9cgheffm8fo2v
        MwNQM5jWpzxG+TRckpf9XgFNG6J3tXatOw==
X-Google-Smtp-Source: APXvYqyKXszj19NF2R2wf4p5Hh10Rm7804GuSPMI56gJth+CZhFZEF0kar41CoCirBmQtdsY5k3dD25LUcXkMA==
X-Received: by 2002:a63:151:: with SMTP id 78mr36030247pgb.95.1572991926023;
 Tue, 05 Nov 2019 14:12:06 -0800 (PST)
Date:   Tue,  5 Nov 2019 14:11:49 -0800
In-Reply-To: <20191105221154.232754-1-edumazet@google.com>
Message-Id: <20191105221154.232754-2-edumazet@google.com>
Mime-Version: 1.0
References: <20191105221154.232754-1-edumazet@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH net-next 1/6] net: neigh: use long type to store jiffies delta
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A difference of two unsigned long needs long storage.

Fixes: c7fb64db001f ("[NETLINK]: Neighbour table configuration and statistics via rtnetlink")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/neighbour.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 5480edff0c8687a0b3a0e2dca90a83dc7ca52fe8..8c82e95f75394cba3688bc2a960804b1f967f508 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -2052,8 +2052,8 @@ static int neightbl_fill_info(struct sk_buff *skb, struct neigh_table *tbl,
 		goto nla_put_failure;
 	{
 		unsigned long now = jiffies;
-		unsigned int flush_delta = now - tbl->last_flush;
-		unsigned int rand_delta = now - tbl->last_rand;
+		long flush_delta = now - tbl->last_flush;
+		long rand_delta = now - tbl->last_rand;
 		struct neigh_hash_table *nht;
 		struct ndt_config ndc = {
 			.ndtc_key_len		= tbl->key_len,
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog


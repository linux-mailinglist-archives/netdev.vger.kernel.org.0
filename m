Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4B5D188B8A
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 18:04:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbgCQREv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 13:04:51 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40403 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgCQREv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 13:04:51 -0400
Received: by mail-wm1-f68.google.com with SMTP id z12so57747wmf.5
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 10:04:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KQfg7DCu72eifsIXbwUE7SsyybaOyhWpBLosdsttlhc=;
        b=eN/660DjaoMYaRVaGZPsZSclxXFN6782ZtrxIhjA+n2dgadzqE09RdRWLLNcej9aug
         deTBhIKD39T5g6N6JoZ4njdF0XGkWTNf6r3U5c/pYPk8b0cIeK2zpZNgyXKBeQcNjFmS
         MhDubYtkUYlR10oNMh0W+qpsJim99BxW50kWo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KQfg7DCu72eifsIXbwUE7SsyybaOyhWpBLosdsttlhc=;
        b=YaSeawIjUK6cnKlh/iow2RqxgcyxliLN+4DWcdd72FWyJdsMzhr9H8gkpVN55SuPSl
         Hjkxp8VUfhqOkmZGHuYuUR72eY77DkDf66DrX+6gio+o2G0MGTW3CrTg7Fez4uf1Rwuc
         r6795TRO5UbddNsIetguXaAwyQEUCBizLbJ8E5A7VqZWUncI/V2G1RV5Axg/YoKGvtoN
         YLCfB5EasyC5AN8W+szyiZvYHNEoY2ilPRvQAtTSrZ1JmIglmjvhYE3aDLzHv9dwrh9a
         3lBoakeiEk6WP8RdkaKtbnXHjf9Heba8pO5zqFIiVXWROvmsXr7BdlMRxD+yz+qN4PZj
         TbGg==
X-Gm-Message-State: ANhLgQ2I1aIYX4Osy/WET7LJk43oIzXuxnoe6KJ1nI8KLLEu3UZ/WLDJ
        vsqH4gN6/CsectjtxoCg+TYkjxRrzCgfTA==
X-Google-Smtp-Source: ADFU+vtTyNJi+2inazClMBpzOC+3gYcKLWgQoJfwBDzNZ9eVl1OI9zRxlPeebNGxYiKQIwPXP0R9eg==
X-Received: by 2002:a05:600c:2c4a:: with SMTP id r10mr40334wmg.32.1584464688276;
        Tue, 17 Mar 2020 10:04:48 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id l18sm5339388wrr.17.2020.03.17.10.04.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2020 10:04:45 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     netdev@vger.kernel.org
Cc:     kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH net-next 1/3] net/tls: Constify base proto ops used for building tls proto
Date:   Tue, 17 Mar 2020 18:04:37 +0100
Message-Id: <20200317170439.873532-2-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200317170439.873532-1-jakub@cloudflare.com>
References: <20200317170439.873532-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The helper that builds kTLS proto ops doesn't need to and should not modify
the base proto ops. Annotate the parameter as read-only.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 net/tls/tls_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 82225bcc1117..ff08b2ff7597 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -63,7 +63,7 @@ static DEFINE_MUTEX(tcpv4_prot_mutex);
 static struct proto tls_prots[TLS_NUM_PROTS][TLS_NUM_CONFIG][TLS_NUM_CONFIG];
 static struct proto_ops tls_sw_proto_ops;
 static void build_protos(struct proto prot[TLS_NUM_CONFIG][TLS_NUM_CONFIG],
-			 struct proto *base);
+			 const struct proto *base);
 
 void update_sk_prot(struct sock *sk, struct tls_context *ctx)
 {
@@ -652,7 +652,7 @@ static void tls_build_proto(struct sock *sk)
 }
 
 static void build_protos(struct proto prot[TLS_NUM_CONFIG][TLS_NUM_CONFIG],
-			 struct proto *base)
+			 const struct proto *base)
 {
 	prot[TLS_BASE][TLS_BASE] = *base;
 	prot[TLS_BASE][TLS_BASE].setsockopt	= tls_setsockopt;
-- 
2.24.1


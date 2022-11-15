Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE59A629A19
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 14:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbiKON0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 08:26:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiKON0N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 08:26:13 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF621116B;
        Tue, 15 Nov 2022 05:26:12 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id l14so24247849wrw.2;
        Tue, 15 Nov 2022 05:26:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UkG9A5GEaL+iS91A1sP8f+OHFyccXyI/9fKl7gdZSI4=;
        b=lYC5JBRTM5eHKD6SMbbqo7rjWAdVHt8UX8yK3yeoJdAquX9842yoOmuh6Ksj3+V2Xx
         KVEHb/gU1xog5n1xXCS9ATcEiK4Hmw4comE9Ws9+2aiqXzujEhcuW5hTW1c1+2KeRksw
         I7mSyYzo+jECQNfFsMeK5TLPoq9uYJC7TiA+tU9AsCIQTdSwo677tmmnZHcglrK4YYe9
         moF5uN8rA3NdjVJo5uk6lnj7Yc6ZhoKqjx2phIGeOAlqJQLavqYKd8dSmYRFNHkz4lB+
         BW/hjj6RYrtMdhFJoiluvtWNu9Q+z7mqc8eQ0cajwY8gP5rVQVO5grFMom3rw/qYmwen
         VRGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UkG9A5GEaL+iS91A1sP8f+OHFyccXyI/9fKl7gdZSI4=;
        b=iSFrfPKU3QKYIbyyENYOtFkTVsIpfg0EX2IwBj4L/In5fzxPUMtF5ymFG+J54jgI+a
         CXHLeidM1KR78bOJhvl0L3RLccoIufps7MiUSHtePLGTWMrINAltS53dtryrREfuEqo1
         XEVif2jD4tcVEIXKC2Oq0fT2q8TLmbMIGKxlsSkkhr+VNmN1FHxIhzVYYZjjahO+Ua8j
         BoRbHD9HDLYsPChHq8sgNYRaZLjn7omvX3dXf9f+mP5pp91LdCK2EKY1AlnIK/jaKRac
         PAWwGV/ZPK9yTRDbTcK045mYnhO9KBqpo5JsGzbcViKC76SzN1OO+YdMVVvQBUbFzcTf
         mU+A==
X-Gm-Message-State: ANoB5pnB8NstQwyd8BlBRFxQEYRq4FEqXZGBVqRnU74vwd4lwXtFIn3O
        iTVKOTPWHQle4OT9xhkk3Gk=
X-Google-Smtp-Source: AA0mqf65gfPaZvyGgF2Go0sorV/aS1Gnaa76RvR8QG13OhEGBZmfq+49ld6g7elY235WTkAGgSYn4g==
X-Received: by 2002:adf:fc0a:0:b0:22d:6988:30de with SMTP id i10-20020adffc0a000000b0022d698830demr10613276wrr.186.1668518771269;
        Tue, 15 Nov 2022 05:26:11 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id r2-20020a5d6942000000b0022e47b57735sm12557498wrw.97.2022.11.15.05.26.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 05:26:10 -0800 (PST)
Date:   Tue, 15 Nov 2022 16:26:07 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net-next/netfilter] netfilter: nft_inner: fix IS_ERR() vs
 NULL check
Message-ID: <Y2PTO4xIJrwhcgyM@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The __nft_expr_type_get() function returns NULL on error.  It never
returns error pointers.

Fixes: 3a07327d10a0 ("netfilter: nft_inner: support for inner tunnel header matching")
Signed-off-by: Dan Carpenter <error27@gmail.com>
---
This applies to net-next but presumably it's going to go through the
netfilter tree?

 net/netfilter/nf_tables_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 62da204eed41..6b159494c86b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2873,8 +2873,8 @@ int nft_expr_inner_parse(const struct nft_ctx *ctx, const struct nlattr *nla,
 		return -EINVAL;
 
 	type = __nft_expr_type_get(ctx->family, tb[NFTA_EXPR_NAME]);
-	if (IS_ERR(type))
-		return PTR_ERR(type);
+	if (!type)
+		return -ENOENT;
 
 	if (!type->inner_ops)
 		return -EOPNOTSUPP;
-- 
2.35.1


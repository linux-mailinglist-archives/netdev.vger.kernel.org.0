Return-Path: <netdev+bounces-5697-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 451CD7127B6
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 15:39:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ACEFD28183E
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 13:39:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87B071D2CD;
	Fri, 26 May 2023 13:39:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76ADC168D7
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 13:39:24 +0000 (UTC)
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 022D0D8
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 06:39:23 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-3f603ff9c02so5494505e9.2
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 06:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685108361; x=1687700361;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IQe4D67cLwl8q+STJZyTgJruFga6QG8sQ8P+KxpYejc=;
        b=jc7V1YMBetwGSRvkKFZ+6dh8gJrr5wiQWRWwN8i3KAl27iedIHi+G+Bo1SclUN2ICY
         cqNx6JxMG4d31ML3G4MnsjjmN93dk234eFpRf3y2aXAMZd6X+WLFqBbGSd/cAmTJ4msq
         WnDrzQTLsrFINzP71zxQ6u+oUeYusxOoQW6olGTTqqiXP9UrJQuctZ3c9MsZhzSakHM0
         xqxfHzkwoVejRegr4S4uAdPcgTRsF5awHoo0A647hCiMe1jH0FhsnOlY//jkbTSLtTLG
         aBRxwRYI8qbFrQ5FqRPqAiVvipEkWQjhbXEVBBWqlZleXvtmYzxrGdLjoemJIKxPihkH
         l8lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685108361; x=1687700361;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IQe4D67cLwl8q+STJZyTgJruFga6QG8sQ8P+KxpYejc=;
        b=Q5XbNG8pnMQaz2OllbATaAGs7cq/DZTBYJlKRB/bdBaNLCHoZDEGHRe+OK8YlJy8O8
         7lthq6R8taeV4b2NmmsocSLmw2rlvvEOnY/s3tN1/EZZmvKwikxMwEiRH5wGHey4mCkW
         rFCIr0FMI5eQV1/Kgc/UOjwmH/e5xQT1cpWn+CBIi3SDMNHNVRuKVjS1sdM0xAfnPQnC
         KbbZOuEnQ/giqoOhcTIa1SvSZ7c/tCudxfvP5Inh3hy9JKql3FrHtuAjG0I0PbkNk5I0
         TKvm1ljKIpz+KLfUJHpNXcYmO6mFw61cDky5jYqdriuEO7NgXuaBvkEZGm5YBokE+JHi
         bvlA==
X-Gm-Message-State: AC+VfDwYjlW4qAyi0yaZW4xfSCSt8c684euZloSTlvwElWlezYhn5JAq
	gxFmqaK8J8mqKeDDm7W83oBJPA==
X-Google-Smtp-Source: ACHHUZ567Rfv8QITDsWSQhkOFgWyFK5JKKFtFu5uduajc0RdjdJBTa5ULiFPBK1LMD77u6Y+hEJFrQ==
X-Received: by 2002:adf:e8cc:0:b0:309:419b:925d with SMTP id k12-20020adfe8cc000000b00309419b925dmr1549281wrn.70.1685108361469;
        Fri, 26 May 2023 06:39:21 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id a16-20020a5d4d50000000b003047ea78b42sm5185266wru.43.2023.05.26.06.39.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 06:39:18 -0700 (PDT)
Date: Fri, 26 May 2023 16:39:15 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: David Howells <dhowells@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Alexander Duyck <alexanderduyck@fb.com>,
	Jesper Dangaard Brouer <brouer@redhat.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Kees Cook <keescook@chromium.org>, Jiri Benc <jbenc@redhat.com>,
	netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net-next v2] net: fix signedness bug in skb_splice_from_iter()
Message-ID: <366861a7-87c8-4bbf-9101-69dd41021d07@kili.mountain>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The "len" variable needs to be signed for the error handling to work
correctly.

Fixes: 2e910b95329c ("net: Add a function to splice pages into an skbuff for MSG_SPLICE_PAGES")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
v2: tidy up a style mistake in v1.

 net/core/skbuff.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 653abd8a6975..7c4338221b17 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -6931,8 +6931,8 @@ ssize_t skb_splice_from_iter(struct sk_buff *skb, struct iov_iter *iter,
 	unsigned int i;
 
 	while (iter->count > 0) {
-		ssize_t space, nr;
-		size_t off, len;
+		ssize_t space, nr, len;
+		size_t off;
 
 		ret = -EMSGSIZE;
 		space = frag_limit - skb_shinfo(skb)->nr_frags;
-- 
2.39.2



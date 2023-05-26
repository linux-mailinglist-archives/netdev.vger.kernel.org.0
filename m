Return-Path: <netdev+bounces-5663-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 26FBC7125D8
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 13:46:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D37F62817CB
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 11:46:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1BA7156DC;
	Fri, 26 May 2023 11:46:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70A9742FE
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 11:46:10 +0000 (UTC)
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4ADF116
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 04:46:07 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-96fbe7fbdd4so110935266b.3
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 04:46:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685101566; x=1687693566;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8bwapPzIksejMYPOzqAciWFpX9l//k+2i55qcaQ4U84=;
        b=p3WyE9ux4z7bTVG/oB1m/AWwln/iJau/yc6molMdnqw6xkXJYqkuoI1laOAsMHFpRR
         wCcLnR3pP6wY74NBo5me/FTomaeKpRxLxoZb9Ozb/w8LPfB5Ymfv8FmqOtCjnW5k+hiK
         Cvz73iX3brazRkjgGRbiwF50TshODMHl87v9hCVlvc3OBG00dsTzuchR/hqgR80xCDih
         xofXkqQRKXBss+g1xUgqmMWLe3uEIUxNoRrupxnJuk0pOIJcuOBxDnNgLhOg7hZPXudR
         AKcJjF8Vnaa9CQXbHbSmpQPBGWgw+hoZxlCvXocRBmmvhYw3mnsoI7DqtYrCTwUKPdZn
         SdYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685101566; x=1687693566;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8bwapPzIksejMYPOzqAciWFpX9l//k+2i55qcaQ4U84=;
        b=kFh7lMStoNYpEMBeR07vGzoztTeAS0UR2OJdGCoaUgzP7o9XdGuxi7CDfSHqQ2ZhiY
         aRQbrD0nlT7KOAGTYO7GSoI23Xn3CPt4Y2uX9RJvvwpactTJZ8+UsVZmoLkKKPhfGg2X
         1djcbQ5kiE9J6M3w/D+wtaofS+88cBEhOCnI1t6HiZS7wbWdXckttdw/qrIadKc5A+dO
         gvZai9RaI+Q9TrQCewd1eHZcpQnpPbFXCmUZ2GRNeR4dQ1kfQEAkTnoRS543T119wP5S
         VX6eOJ5VQh6Ev6hi1QlaCNVSP5ZmmdA+o6pEtQwgyvve4VG22o4/+E4OC8ZxgIseRct3
         4b5w==
X-Gm-Message-State: AC+VfDwQotE77vMnV0BvG02jnkXppKriUwnLCedQkIYgggfMzVsS+0IH
	rvm9hN1tPeiMQ1moNGsGRlY6Kw==
X-Google-Smtp-Source: ACHHUZ73fSEuuH8M5GmwuCqDSX4tpkKYV/d7ZDsczAlnmbtNwJzOzfpLbhQJlSBHzvq+mLdAJUA5OA==
X-Received: by 2002:a17:907:6da7:b0:962:9ffa:be02 with SMTP id sb39-20020a1709076da700b009629ffabe02mr1835688ejc.36.1685101566472;
        Fri, 26 May 2023 04:46:06 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id le8-20020a170907170800b0096f803afbe3sm2079506ejc.66.2023.05.26.04.46.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 04:46:05 -0700 (PDT)
Date: Fri, 26 May 2023 14:46:02 +0300
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
Subject: [PATCH net-next] net: fix signedness bug in skb_splice_from_iter()
Message-ID: <99284df8-9190-4deb-ad7c-c0557614a1c8@kili.mountain>
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
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The "len" variable needs to be signed for the error handling to work
correctly.

Fixes: 2e910b95329c ("net: Add a function to splice pages into an skbuff for MSG_SPLICE_PAGES")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 net/core/skbuff.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 653abd8a6975..57a8ba81ab39 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -6932,7 +6932,8 @@ ssize_t skb_splice_from_iter(struct sk_buff *skb, struct iov_iter *iter,
 
 	while (iter->count > 0) {
 		ssize_t space, nr;
-		size_t off, len;
+		ssize_t len;
+		size_t off;
 
 		ret = -EMSGSIZE;
 		space = frag_limit - skb_shinfo(skb)->nr_frags;
-- 
2.39.2



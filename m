Return-Path: <netdev+bounces-9505-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B177D7297C7
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 13:05:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E8FCC280C42
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 11:05:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39AD510960;
	Fri,  9 Jun 2023 11:05:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DFE9377
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 11:05:28 +0000 (UTC)
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8399B1FF3
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 04:05:26 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3f6d7abe9a4so12431575e9.2
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 04:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686308725; x=1688900725;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tFyWP/Gv04JokRZ90bRXNAF0sLVUQUnwQyZmUvgIR0w=;
        b=oxspjefXVCLflDUTz7ZGtjCzKu/BHHdCyNz5Xjs/hyGClXt45cDE6xpGXm3A3e2uEr
         RV40rCeCFMtX7Jis8IJcXJpoBUqS/MWvIdpi09CerEM1wHdV2QIwiBlFWyIDRUP1G8Wq
         e2DrjWL3R5yTGPKUfClD4kAstCdFn5x4cnmAXdf9YZG+SD86bLS36QNjjVQcuXte2Cqn
         XlVojEDTz8daeIRYxQarDF9PvmO8Vbszv2iBY80R9P+dD2OLqjYDoCRzK5O0JNfc0m/y
         dVfTg0UjIWqVMu6Y1OH75KbORgBRK3pl2h722//pIiRZZ8l1LiA45A8FJ04y4JkQgZoV
         p/UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686308725; x=1688900725;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tFyWP/Gv04JokRZ90bRXNAF0sLVUQUnwQyZmUvgIR0w=;
        b=ggLtBQZuId7cfEepSuCj+wixZ/Tc9JlmULwua89EogrHWjRCPO4FZsT7NrhTlCnE/K
         iHdsuSPfd7FrdYNMHwtaw80P2YAXPI2vTQgYWYX4HmZYXj49eDMyFdl18+8AYwxc1JpZ
         5GoipeGpF6qsP3q2Yh8cLaQBnZo11JoMJtBizz2WLh4xmqFwubvdy1GG58ij6mEUcgX7
         b4DJPL42wo6Xu1xIvnHQKxfPwrKDo4o0SI4JjfGw7L84Mx71SeDAlEbhOT9IPSnpZGKN
         8tFbJlEnluI8zxKKAL/vIhd3xjDS3SnfZfuoyMLGtw0S83NMpDdAt1mStDmR2ZpMJp/8
         OoOQ==
X-Gm-Message-State: AC+VfDxecjt5z8F0vLGEdoBiHW7N+YX6XRG7SB49j92ndGrd8ReqcSNP
	8JLc1z0xd06k8koHDwnzuvSM7g==
X-Google-Smtp-Source: ACHHUZ5a/3SspzqfpjyWpYpyUKU5uGfftwmHY0tsmPA6mLLzprhRTE8IrmzxR+xp0QDfSwZaPDVDPQ==
X-Received: by 2002:a05:600c:384:b0:3f4:2897:4eb7 with SMTP id w4-20020a05600c038400b003f428974eb7mr911968wmd.38.1686308724936;
        Fri, 09 Jun 2023 04:05:24 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id n6-20020a7bcbc6000000b003f6f6a6e769sm2336197wmi.17.2023.06.09.04.05.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 04:05:23 -0700 (PDT)
Date: Fri, 9 Jun 2023 14:05:19 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2 net] sctp: fix an error code in sctp_sf_eat_auth()
Message-ID: <bfb9c077-b9a6-47f4-8cd8-a7a86b056a21@moroto.mountain>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4629fee1-4c9f-4930-a210-beb7921fa5b3@moroto.mountain>
X-Mailer: git-send-email haha only kidding
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The sctp_sf_eat_auth() function is supposed to enum sctp_disposition
values and returning a kernel error code will cause issues in the
caller.  Change -ENOMEM to SCTP_DISPOSITION_NOMEM.

Fixes: 65b07e5d0d09 ("[SCTP]: API updates to suport SCTP-AUTH extensions.")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 net/sctp/sm_statefuns.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 97f1155a2045..08fdf1251f46 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -4482,7 +4482,7 @@ enum sctp_disposition sctp_sf_eat_auth(struct net *net,
 				    SCTP_AUTH_NEW_KEY, GFP_ATOMIC);
 
 		if (!ev)
-			return -ENOMEM;
+			return SCTP_DISPOSITION_NOMEM;
 
 		sctp_add_cmd_sf(commands, SCTP_CMD_EVENT_ULP,
 				SCTP_ULPEVENT(ev));
-- 
2.39.2



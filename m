Return-Path: <netdev+bounces-2439-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6937C701F56
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 21:53:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3812F1C209D1
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 19:53:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53197BA43;
	Sun, 14 May 2023 19:52:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48B58BE65
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 19:52:38 +0000 (UTC)
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 652EC10E9
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 12:52:35 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id d75a77b69052e-3f507edcaaaso19849341cf.2
        for <netdev@vger.kernel.org>; Sun, 14 May 2023 12:52:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684093954; x=1686685954;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jyvf4TEwS2vn6fQxq7OrYN1TDJ6PU+gnGXB81K2v2K0=;
        b=r99P5Df+3D3jsNP+KIrOr+xBLW2RECHOkLT4DUjVxA7bq2PuOnq7HAJTGv2Ax9+LL+
         K5kDeHm8Cjj4YzcxJ7N1ZYZvCMgl3gEOG5fiMyQyHcGEsFtZTwIhMiR1GhzeXvBXzROw
         c9H9CtPHRXrIDhwLmTIw1UEIonku/fzVkfTq0Ci7d0TyaByjAv3ZxHc2RrYb6uIXK4W7
         PaUdAjaBgriO5UoZpmr3DaR0msEwG9FyuwsD2c+9hqFreVd3tHZ6cn0jKi/3bjGWDZuO
         lNY1wkqIqTf4QV7vnptoJzQC5+CfdOfnh1Jn7sTfEGAZqc1fCAK9wLo13iX2hzuy6G1v
         CooQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684093954; x=1686685954;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jyvf4TEwS2vn6fQxq7OrYN1TDJ6PU+gnGXB81K2v2K0=;
        b=E/hHBQeX1CHSmgqkfIW8RSJU8GrWQTtiPiIV1yEcM8q1LIG8SkSroXjTt7LPX07rym
         aH7Ew6P55WbPK8c68NzcVqIQnAOMKuuyykbndgvgobILx5r1yKFJ7L95mma1NPGecgD3
         WUtuJ+Z5b7mQGnzYpXSg15HCYWBOagWCnIeaWJW4hrh57mdCizpeBP0G2j8DQy221ds0
         EFG0rEGXtQX2wAka504kRaX6axn4RHlSZSteyIEBd3t9SKkUa51hbD/VTtoelrLKSlFl
         GkcOEWjlwsu9pzTOptBkkgg/+r7sxFptF80QccuiN2jojEjURFU5vuCOZvmH9zLXx6gf
         VQ7A==
X-Gm-Message-State: AC+VfDwoLYcV8UuaSUgwPioTalsSBE0yp5b+gjMqq1U351cHUY4+LGxk
	/FMl1T6XlgPGp+Q7slzCKyhVt8PZcQTd0A==
X-Google-Smtp-Source: ACHHUZ5HO2jd3PRwDBjHw9uFywTkOFHu4MNDhdqs954iR5WE41qYYX1Cyn222mMEEF70mpJj2ReMYQ==
X-Received: by 2002:a05:622a:1a21:b0:3ef:36d0:c06e with SMTP id f33-20020a05622a1a2100b003ef36d0c06emr58804137qtb.33.1684093954367;
        Sun, 14 May 2023 12:52:34 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id fa11-20020a05622a4ccb00b003f517e1fed2sm1069444qtb.15.2023.05.14.12.52.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 May 2023 12:52:34 -0700 (PDT)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>,
	tipc-discussion@lists.sourceforge.net
Cc: davem@davemloft.net,
	kuba@kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jon Maloy <jmaloy@redhat.com>,
	Tung Nguyen <tung.q.nguyen@dektech.com.au>
Subject: [PATCHv3 net 3/3] tipc: check the bearer min mtu properly when setting it by netlink
Date: Sun, 14 May 2023 15:52:29 -0400
Message-Id: <401254e10285db58966f64793d4762c23a25f9d3.1684093873.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1684093873.git.lucien.xin@gmail.com>
References: <cover.1684093873.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Checking the bearer min mtu with tipc_udp_mtu_bad() only works for
IPv4 UDP bearer, and IPv6 UDP bearer has a different value for the
min mtu. This patch checks with encap_hlen + TIPC_MIN_BEARER_MTU
for min mtu, which works for both IPv4 and IPv6 UDP bearer.

Note that tipc_udp_mtu_bad() is still used to check media min mtu
in __tipc_nl_media_set(), as m->mtu currently is only used by the
IPv4 UDP bearer as its default mtu value.

Fixes: 682cd3cf946b ("tipc: confgiure and apply UDP bearer MTU on running links")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Jon Maloy <jmaloy@redhat.com>
---
 net/tipc/bearer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
index 0e9a29e1536b..53881406e200 100644
--- a/net/tipc/bearer.c
+++ b/net/tipc/bearer.c
@@ -1151,8 +1151,8 @@ int __tipc_nl_bearer_set(struct sk_buff *skb, struct genl_info *info)
 				return -EINVAL;
 			}
 #ifdef CONFIG_TIPC_MEDIA_UDP
-			if (tipc_udp_mtu_bad(nla_get_u32
-					     (props[TIPC_NLA_PROP_MTU]))) {
+			if (nla_get_u32(props[TIPC_NLA_PROP_MTU]) <
+			    b->encap_hlen + TIPC_MIN_BEARER_MTU) {
 				NL_SET_ERR_MSG(info->extack,
 					       "MTU value is out-of-range");
 				return -EINVAL;
-- 
2.39.1



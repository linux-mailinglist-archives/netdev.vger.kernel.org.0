Return-Path: <netdev+bounces-33-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CCC826F4CD2
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 00:14:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 89E10280D54
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 22:13:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D066FBA34;
	Tue,  2 May 2023 22:13:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDBDABA2B
	for <netdev@vger.kernel.org>; Tue,  2 May 2023 22:13:25 +0000 (UTC)
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 095E21FFF
	for <netdev@vger.kernel.org>; Tue,  2 May 2023 15:13:21 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id af79cd13be357-75131c2997bso27122385a.1
        for <netdev@vger.kernel.org>; Tue, 02 May 2023 15:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683065600; x=1685657600;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=13KxgOJcr7gVZ8an57+aultClqJTer559gf4P+MeESk=;
        b=QQ/dHUjVwfaIetW2niX6G2tMyGPOV/RB7Qf1YTojUht72nMIs9k16ZxT1vvJpfBjy+
         0XT6dIB1rjjDYg2aj64LsZTyJAG3kj1SEPNN16fhkjLHfijzzls5cL1Jg+PwaVZ1Ojtt
         j2gtj+n1vfrumZ3dyDbUKG6gm9KP/9MuXbpCO5GjN01kBPi4abANY3rkQFMAsJEQXBhd
         3M0bwyVJc/NABoJzIfd97VyfaiFRUx47FNfVg0b7WiaIhqXcJhnIWXKegAZ8UZHdXyep
         ri4Ao3CCbmFfpGaakrnfii/2TZGFoKtypjrC4BncKk6g+J86VUhY5aZdeIDI7nyMoVoU
         yP/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683065600; x=1685657600;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=13KxgOJcr7gVZ8an57+aultClqJTer559gf4P+MeESk=;
        b=hUPE8XZeX9b2GikGpdWuIaTCBxXv0Xy4BzROItC+DXABJJAx2V37lAK/qUA7FJ1yE1
         Dq7gK9kpcQxPJFhbb5zt+p0pvm5fu7LOx1vecBo0Vv1l/s6Rid8lpTI/u3cjqk7U99Mt
         Jx93hxo+D2P19bNn9KUfupjA4+CYqQbcUIAxzye3CMi9xelPd85pPykrP9CSWFyCkINR
         CaE2E9k4m6pvRHf3naB4yFQjLjawUFzsdL3+inqAP2mDvZAfv8RvWWgK4oTbSjtKkhpb
         LjGaXTw9uTMjZInd50C+GzGaLpr+XYkcKZWokvJLJrpA38h10WUijOrhAxIO8ZlYkAn9
         pQHw==
X-Gm-Message-State: AC+VfDyheH4cvyZtaKKyONyH4ZAL8YrXx5H/okltz12TBAXqa3RuiOyy
	KJcwxn0Pu8yp5WnrYstnL04wSGjm+D5Ttw==
X-Google-Smtp-Source: ACHHUZ7XyuwUpeuXxLxeC+nX1/WQjqdrgU6QbBdfyffj1IifPnPzZt45bIwiX9H/vaQSGtWT21I80A==
X-Received: by 2002:ac8:7f48:0:b0:3e3:9185:cb15 with SMTP id g8-20020ac87f48000000b003e39185cb15mr186278qtk.7.1683065600032;
        Tue, 02 May 2023 15:13:20 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id cf23-20020a05622a401700b003ef58044a4bsm10362636qtb.34.2023.05.02.15.13.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 15:13:19 -0700 (PDT)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>,
	tipc-discussion@lists.sourceforge.net
Cc: davem@davemloft.net,
	kuba@kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jon Maloy <jmaloy@redhat.com>,
	Tung Nguyen <tung.q.nguyen@dektech.com.au>
Subject: [PATCHv2 net 3/3] tipc: check the bearer min mtu properly when setting it by netlink
Date: Tue,  2 May 2023 18:13:15 -0400
Message-Id: <1a6d4021e30266c8ff11a2eb25390ccd32766cf4.1683065352.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1683065352.git.lucien.xin@gmail.com>
References: <cover.1683065352.git.lucien.xin@gmail.com>
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



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6A8F3BF472
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 06:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbhGHENn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 00:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbhGHENm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 00:13:42 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07415C061574
        for <netdev@vger.kernel.org>; Wed,  7 Jul 2021 21:11:00 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id t9so4607415pgn.4
        for <netdev@vger.kernel.org>; Wed, 07 Jul 2021 21:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pwoYyUf9phYtBv7Kn8sbTMMzQzyNENeo3snZZ+p4YOQ=;
        b=reaKSEDQrSDwPzKMvRLZuIto/d3firO+I0KbC4UQBGEnyELzo0zOOtGSX9DRPXWoeo
         6VXmEXne0PYCix74zzyDExM1nW8GsC/YqXOuHoxOjzLkiuG9UHWqunC++j31id4dRUad
         sGK5+nbsTHDH5cq3zA5v7/fv0kVG7i/et5je6i+gWjRiNxCYvtSw60Xb5ZIg3drsWyFk
         NKGWDPkADbSexRfCnCXwgdoRsq/hatDdePcidLAACBu62S1OPXLZgDs5M+HFJWb5Yira
         lKwUbbJnGL9SjjSFnCSwLNcxiu4n5TzUgLVylNUlui5MXr0f187fLv1DAqxPnZiWPxhN
         9+RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pwoYyUf9phYtBv7Kn8sbTMMzQzyNENeo3snZZ+p4YOQ=;
        b=ZVxHQ4yDgQlmyIQBJLBaNT1pH4enbMBiGUlGUWAOJf7amUOuUy6JYuw0YBYdx2Mpfw
         4FbjKbrJIKDaiy+M+l3QALjx2hbkojZLKt3lXMuKjM7KAsr+QPNBEQeJnqlIeHKtnMzZ
         ZHYDi5yxPOK37q8pqCWTcMbIPSxx+TRfiuepBmq36CiHHR0StipBUWEwehfKRCaQjMeD
         kfP8kL7gm//PzRBO+cifUqC2GWv7qvufop6VYCNi9YDRAWVkN1P6tLdtKwVPLwD+/pm0
         YfuNo7kPCX9F7HDOwcacsrrnArRAffhnUqsUu7zPbuqQLTTvqolWbPde239Psd47MCo9
         UuzA==
X-Gm-Message-State: AOAM5321sOjwnLuIATdy4CkUixNaw2/EvpTvdHlNtG/0LabMW3cUw8Ov
        sGBBm6+q+OKMgf3kZaUHF5+ywgwhd0G5rQ==
X-Google-Smtp-Source: ABdhPJzZZr/63IkevJVJb2blx9nVF+90+kM+y7o6cZM1tHHj5zT5qp9T4JBnhW9XXPELQ57zeGTxEw==
X-Received: by 2002:a05:6a00:23d0:b029:2de:c1a2:f1e with SMTP id g16-20020a056a0023d0b02902dec1a20f1emr29182471pfc.60.1625717459473;
        Wed, 07 Jul 2021 21:10:59 -0700 (PDT)
Received: from 7YHHR73.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q14sm804226pfh.135.2021.07.07.21.10.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 21:10:58 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Paul Blakey <paulb@nvidia.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        mika penttila <mika.penttila@nextfour.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net] skbuff: Fix build with SKB extensions disabled
Date:   Wed,  7 Jul 2021 21:10:51 -0700
Message-Id: <20210708041051.17851-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We will fail to build with CONFIG_SKB_EXTENSIONS disabled after
8550ff8d8c75 ("skbuff: Release nfct refcount on napi stolen or re-used
skbs") since there is an unconditionally use of skb_ext_find() without
an appropriate stub. Simply build the code conditionally and properly
guard against both COFNIG_SKB_EXTENSIONS as well as
CONFIG_NET_TC_SKB_EXT being disabled.

Fixes: Fixes: 8550ff8d8c75 ("skbuff: Release nfct refcount on napi stolen or re-used skbs")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/core/dev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 177a5aec0b6b..03c95a0867bb 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6010,7 +6010,7 @@ static void gro_list_prepare(const struct list_head *head,
 				       maclen);
 
 		diffs |= skb_get_nfct(p) ^ skb_get_nfct(skb);
-
+#if IS_ENABLED(CONFIG_SKB_EXTENSIONS) && IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
 		if (!diffs) {
 			struct tc_skb_ext *skb_ext = skb_ext_find(skb, TC_SKB_EXT);
 			struct tc_skb_ext *p_ext = skb_ext_find(p, TC_SKB_EXT);
@@ -6019,6 +6019,7 @@ static void gro_list_prepare(const struct list_head *head,
 			if (!diffs && unlikely(skb_ext))
 				diffs |= p_ext->chain ^ skb_ext->chain;
 		}
+#endif
 
 		NAPI_GRO_CB(p)->same_flow = !diffs;
 	}
-- 
2.25.1


Return-Path: <netdev+bounces-5483-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 88E2471198A
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 23:50:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 461F91C20F52
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 21:50:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4891E261C1;
	Thu, 25 May 2023 21:49:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 287A624EBE
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 21:49:44 +0000 (UTC)
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F5B11702
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 14:49:23 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id d75a77b69052e-3f7fd59bb13so10613881cf.3
        for <netdev@vger.kernel.org>; Thu, 25 May 2023 14:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685051362; x=1687643362;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2wL1AkVOAyRTlNU+Tx0ajbjL9OHVFrEnvCQlNmY/nOQ=;
        b=n+KLLMiPZAWZ1slEabD5htcj+OX229Q32j8QdddmBElOen4nxDLFXz243W/gLN7Qdp
         DtGapUyamsk5lmBXeZMtViR6BGEL1KX29WFZFSmQsHtHLv8xC/YOuVYqtVwY3djPGRQ8
         al8NopYicPQwqIvnaotWKU+t2jcur0/T0MHd99CeiYx3vL9mizkMk5iOrUtK/GL9vuSO
         mJYg14PXmEEqJtkDcKn8a1iQjbkDGuuCFw510nyMhg3emnx0tfVXH5cxpCLNGXXa5neE
         hk2P2+KLMnPjNnN31CDh/bhvqGoV6PNbjxI6PaRGaePL6b8ZWM+h2oHUzmY+tEVIdZNm
         7qRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685051362; x=1687643362;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2wL1AkVOAyRTlNU+Tx0ajbjL9OHVFrEnvCQlNmY/nOQ=;
        b=gTrj/6vyRUJi8fHrZiVH6BubHy6B8wKgEy7tkmmPcAbjcNkXtW2+g+YG345/XwPFZd
         SYdUc3GEsG4Iju7lVC0I54ZlLr08TZ8tWxghdmrek8CeJbGxsF1HwsVqvTwOWFpoCfQB
         5bvOTDsfEmDbpLR9E0xyCMCedgnXbjlSXecbGJHd8DIJqTyRJgZ64ct/xHDW6BjE9Gj1
         mae6eygc61HagdoxaZQn1BYhNOPGRVbp+N+E/fZ1Klttsi5A0A6GT7sRMHq6q8tIq0hL
         rPJzaxiXdxjmCXjXmqHivAIS4gks+qcrwxZ44jnG9k0Nuwmt9KsAchILYfa6fpr2fkVL
         60WQ==
X-Gm-Message-State: AC+VfDxabFTH5whgyy30VzA68QkNJ+qw5NGhe584KidO4bisx07kzuOw
	TiFT8vX8NLJ7Pz+flK0ZkABcXks/rnxvBA==
X-Google-Smtp-Source: ACHHUZ5iBATTCITOJ0DpTJOTPeQMPVcTa3GZxApbhivV03v4H1OadzQkYPKhs/hRJqHkI3Yy9jeVyQ==
X-Received: by 2002:ac8:7f51:0:b0:3f5:c257:9f13 with SMTP id g17-20020ac87f51000000b003f5c2579f13mr989553qtk.51.1685051361975;
        Thu, 25 May 2023 14:49:21 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id x7-20020ac81207000000b003f7f66d5a0esm735742qti.44.2023.05.25.14.49.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 14:49:21 -0700 (PDT)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>
Cc: davem@davemloft.net,
	kuba@kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Thomas Graf <tgraf@infradead.org>,
	Alexander Duyck <alexanderduyck@fb.com>
Subject: [PATCH net 2/3] rtnetlink: move IFLA_GSO_ tb check to validate_linkmsg
Date: Thu, 25 May 2023 17:49:16 -0400
Message-Id: <63779aa1c36d5bdcb6c004df23430372db351d46.1685051273.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1685051273.git.lucien.xin@gmail.com>
References: <cover.1685051273.git.lucien.xin@gmail.com>
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

These IFLA_GSO_* tb check should also be done for the new created link,
otherwise, they can be set to a huge value when creating links:

  # ip link add dummy1 gso_max_size 4294967295 type dummy
  # ip -d link show dummy1
    dummy addrgenmode eui64 ... gso_max_size 4294967295

Fixes: 46e6b992c250 ("rtnetlink: allow GSO maximums to be set on device creation")
Fixes: 9eefedd58ae1 ("net: add gso_ipv4_max_size and gro_ipv4_max_size per device")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/core/rtnetlink.c | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index d1f88ba7e391..68a58d0a7b79 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2385,6 +2385,25 @@ static int validate_linkmsg(struct net_device *dev, struct nlattr *tb[],
 	    nla_len(tb[IFLA_BROADCAST]) < dev->addr_len)
 		return -EINVAL;
 
+	if (tb[IFLA_GSO_MAX_SIZE] &&
+	    nla_get_u32(tb[IFLA_GSO_MAX_SIZE]) > dev->tso_max_size) {
+		NL_SET_ERR_MSG(extack, "too big gso_max_size");
+		return -EINVAL;
+	}
+
+	if (tb[IFLA_GSO_MAX_SEGS] &&
+	    (nla_get_u32(tb[IFLA_GSO_MAX_SEGS]) > GSO_MAX_SEGS ||
+	     nla_get_u32(tb[IFLA_GSO_MAX_SEGS]) > dev->tso_max_segs)) {
+		NL_SET_ERR_MSG(extack, "too big gso_max_segs");
+		return -EINVAL;
+	}
+
+	if (tb[IFLA_GSO_IPV4_MAX_SIZE] &&
+	    nla_get_u32(tb[IFLA_GSO_IPV4_MAX_SIZE]) > dev->tso_max_size) {
+		NL_SET_ERR_MSG(extack, "too big gso_ipv4_max_size");
+		return -EINVAL;
+	}
+
 	if (tb[IFLA_AF_SPEC]) {
 		struct nlattr *af;
 		int rem, err;
@@ -2856,11 +2875,6 @@ static int do_setlink(const struct sk_buff *skb,
 	if (tb[IFLA_GSO_MAX_SIZE]) {
 		u32 max_size = nla_get_u32(tb[IFLA_GSO_MAX_SIZE]);
 
-		if (max_size > dev->tso_max_size) {
-			err = -EINVAL;
-			goto errout;
-		}
-
 		if (dev->gso_max_size ^ max_size) {
 			netif_set_gso_max_size(dev, max_size);
 			status |= DO_SETLINK_MODIFIED;
@@ -2870,11 +2884,6 @@ static int do_setlink(const struct sk_buff *skb,
 	if (tb[IFLA_GSO_MAX_SEGS]) {
 		u32 max_segs = nla_get_u32(tb[IFLA_GSO_MAX_SEGS]);
 
-		if (max_segs > GSO_MAX_SEGS || max_segs > dev->tso_max_segs) {
-			err = -EINVAL;
-			goto errout;
-		}
-
 		if (dev->gso_max_segs ^ max_segs) {
 			netif_set_gso_max_segs(dev, max_segs);
 			status |= DO_SETLINK_MODIFIED;
@@ -2893,11 +2902,6 @@ static int do_setlink(const struct sk_buff *skb,
 	if (tb[IFLA_GSO_IPV4_MAX_SIZE]) {
 		u32 max_size = nla_get_u32(tb[IFLA_GSO_IPV4_MAX_SIZE]);
 
-		if (max_size > dev->tso_max_size) {
-			err = -EINVAL;
-			goto errout;
-		}
-
 		if (dev->gso_ipv4_max_size ^ max_size) {
 			netif_set_gso_ipv4_max_size(dev, max_size);
 			status |= DO_SETLINK_MODIFIED;
-- 
2.39.1



Return-Path: <netdev+bounces-6856-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C5FB97186F6
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 18:02:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E9E91C20E54
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 16:02:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A22831772E;
	Wed, 31 May 2023 16:01:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9694D17AD4
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 16:01:58 +0000 (UTC)
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 104E0E2
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 09:01:50 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id af79cd13be357-75b0830e2eeso64587385a.1
        for <netdev@vger.kernel.org>; Wed, 31 May 2023 09:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685548909; x=1688140909;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9XixacrYPdu8hpoaAamQBV+6PgyNbJudw+yfUyFQC9I=;
        b=JL51xSzzRTEl+APbDTePMQj+8A/I9Rhuky4LMBqqFhvBrtJ9e35daE4WkYI4I8TcIM
         I+LZ1uNEbui4RZNSZP2salQSgiS/osxr2GGEEngtkpfcBOiXk51dGjvipVD+U0PyipSp
         7Msf8mG6GHBc1hEbM1Tsn5O399PPRXhi0CMlANmwhHdQLeukT3K6rTqtKU8xWkp2O2Tc
         VtvAAfkcL45KlSu7pxqeEXYRUMivfPNfnGntSj3Ujsxp8AkH4PItWqIBQZQdJbgyIsv1
         rQSvvOD9ip0Z7LEW4TEheiuaj4HNE0pQIyVVWiwJ/yZkFljgUJxVEOIMXgcHy54rNAVn
         3GQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685548909; x=1688140909;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9XixacrYPdu8hpoaAamQBV+6PgyNbJudw+yfUyFQC9I=;
        b=ZTPsjJCUxC0hl78Dwsv3HbNX2+p3qj6S9GXLcogjUkTH2Exp/wQ9JvQRElLomHSl/T
         BaKp35yrcFCAjyKOi2jXJy5eeBtjn9Wr8hbbp40qh3NXvBzKWCXN5fGRpEPY2eT9b1WB
         nZtHFnS/ZJsBhaeNLu74+sSoUSM9A6Sik3QUofIJcOTQ2vczH7q/0qCMXKaVIbqmsb57
         +W8F9tj6h3omGE+HtSHQFXN9Z476u2zK2UaOS2xwKyBY57Gz0xMHspDIsQPdoGTRrnl2
         DarurEHphUOeygFa0/Q7ddSOuM4ekaate43QteiVTcKTHcnOjUFhNodXTjRvHLDia1f/
         +Jgg==
X-Gm-Message-State: AC+VfDyBRminhupibYf8f0F1dnMPtl43PnwRv3yKen2bXr2gQGEWiVDw
	TUJt0rwHE5/gwtFCMsBFTPeGqT2Yu0aVVQ==
X-Google-Smtp-Source: ACHHUZ619nOxHzomhdx/E/6FYUNGdAC3MPdZTLsdH3mgIM5WOM46fv+CNqa9wjAOKKe+DIuM0h8pCw==
X-Received: by 2002:a37:420e:0:b0:75b:23a1:d847 with SMTP id p14-20020a37420e000000b0075b23a1d847mr13983752qka.9.1685548908980;
        Wed, 31 May 2023 09:01:48 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id s11-20020ae9f70b000000b007594a7aedb2sm5261050qkg.105.2023.05.31.09.01.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 May 2023 09:01:48 -0700 (PDT)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>
Cc: davem@davemloft.net,
	kuba@kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Stephen Hemminger <stephen@networkplumber.org>,
	Patrick McHardy <kaber@trash.net>,
	Thomas Graf <tgraf@infradead.org>,
	Alexander Duyck <alexanderduyck@fb.com>,
	Simon Horman <simon.horman@corigine.com>
Subject: [PATCHv2 net 2/3] rtnetlink: move IFLA_GSO_ tb check to validate_linkmsg
Date: Wed, 31 May 2023 12:01:43 -0400
Message-Id: <e379e457090aad55f0f14fedab3bc66733a7ce02.1685548598.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1685548598.git.lucien.xin@gmail.com>
References: <cover.1685548598.git.lucien.xin@gmail.com>
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
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
 net/core/rtnetlink.c | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 824688edb722..bc068a857219 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2385,6 +2385,25 @@ static int validate_linkmsg(struct net_device *dev, struct nlattr *tb[],
 		if (tb[IFLA_BROADCAST] &&
 		    nla_len(tb[IFLA_BROADCAST]) < dev->addr_len)
 			return -EINVAL;
+
+		if (tb[IFLA_GSO_MAX_SIZE] &&
+		    nla_get_u32(tb[IFLA_GSO_MAX_SIZE]) > dev->tso_max_size) {
+			NL_SET_ERR_MSG(extack, "too big gso_max_size");
+			return -EINVAL;
+		}
+
+		if (tb[IFLA_GSO_MAX_SEGS] &&
+		    (nla_get_u32(tb[IFLA_GSO_MAX_SEGS]) > GSO_MAX_SEGS ||
+		     nla_get_u32(tb[IFLA_GSO_MAX_SEGS]) > dev->tso_max_segs)) {
+			NL_SET_ERR_MSG(extack, "too big gso_max_segs");
+			return -EINVAL;
+		}
+
+		if (tb[IFLA_GSO_IPV4_MAX_SIZE] &&
+		    nla_get_u32(tb[IFLA_GSO_IPV4_MAX_SIZE]) > dev->tso_max_size) {
+			NL_SET_ERR_MSG(extack, "too big gso_ipv4_max_size");
+			return -EINVAL;
+		}
 	}
 
 	if (tb[IFLA_AF_SPEC]) {
@@ -2858,11 +2877,6 @@ static int do_setlink(const struct sk_buff *skb,
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
@@ -2872,11 +2886,6 @@ static int do_setlink(const struct sk_buff *skb,
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
@@ -2895,11 +2904,6 @@ static int do_setlink(const struct sk_buff *skb,
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



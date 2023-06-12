Return-Path: <netdev+bounces-10178-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CEF7672CABF
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 17:55:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 74FEC280FE8
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 15:55:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7DB81E52E;
	Mon, 12 Jun 2023 15:55:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB361D2DD
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 15:55:39 +0000 (UTC)
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36906DE
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 08:55:38 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id d75a77b69052e-3f9df7eb837so109411cf.2
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 08:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686585336; x=1689177336;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=44gi+NItEDM4kwe/K0I6niLp3nIeVk9HyG2d32WhRhY=;
        b=THUsaIi2gGqkHh4r5fgmUJ5LOFaPIQIcXvvOpHFWdi3OLdrsCF/oeBVBWGEefkaRm7
         kmtJSG+isJIdHlqhLCPuCgA5d9O0dU5uCr8ObGq4jJr5ceoU0FrSdai3SBVO0VI7pAyH
         J9+8uZExTSd/9x3Q2dSVMsLO2VIw0IKqioqs1MLYVeNbqtLAYCt8c/uxHYbIM5iq8Zkg
         IOCV+DRSLbo9SNSLIQHkGdaRHidG/7IxbiBc3s+8v/pqZKT+V3lBg5/4wtF7tl2hYnLF
         m8uL7R/48Up9SznY3DGGXKaqab20nJclPB/Dqx22NmL+uar42zf78Z0eiz9jS6hTkQHL
         IXmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686585336; x=1689177336;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=44gi+NItEDM4kwe/K0I6niLp3nIeVk9HyG2d32WhRhY=;
        b=LBubQkL3qtIgrab1YB2cCmHv21GWqKrs5sRJXQjdknavdzsCJ4xDEy0SxXvDutLK5K
         NL0lQYvoIenkibFQ54aeEjNXrV8mu8HNcW5Dfuwo8eoJpU2RSLy2SRek7AyeyBwC217Q
         HmhvWhpA4QeF4IQLuWKoKnbSxxEbM7aot2kPNM026MKV7q6OSiaJnX6zHfelCdiISTtv
         jvY3NyKDnUSVNmr5iL3svYEJ+sp7Je2jXzk1SIEhW/ZwvxltRKgNuLeh7P48st38Q5PW
         rt8LEuOzAVI01pf5vs067fS9KCI/8A/0CIIcHiDF+toAe/FkRWh2eKSwGhULqJnA6Xoc
         +iSQ==
X-Gm-Message-State: AC+VfDxysB9h66F/vPBbMEAucUYSk8Y+ILbc8Nb6Qr3PGtXbSgCm54Jm
	ZnXnCHGz41EZdzwU6xPIVjEtrdgiwkiRvA==
X-Google-Smtp-Source: ACHHUZ7JB+31933zIhd1G89uhdbbIKWNkJlf7SeIewasyh5n26o55ww8ypmRYmpMsRB8l5zrTK0s1g==
X-Received: by 2002:a05:622a:509:b0:3f6:a92e:7f47 with SMTP id l9-20020a05622a050900b003f6a92e7f47mr10337617qtx.13.1686585336107;
        Mon, 12 Jun 2023 08:55:36 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id a22-20020ac844b6000000b003f6c9f8f0a8sm3465636qto.68.2023.06.12.08.55.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 08:55:35 -0700 (PDT)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>
Cc: davem@davemloft.net,
	kuba@kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next] rtnetlink: move validate_linkmsg out of do_setlink
Date: Mon, 12 Jun 2023 11:55:34 -0400
Message-Id: <cf2ef061e08251faf9e8be25ff0d61150c030475.1686585334.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.39.1
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

This patch moves validate_linkmsg() out of do_setlink() to its callers
and deletes the early validate_linkmsg() call in __rtnl_newlink(), so
that it will not call validate_linkmsg() twice in either of the paths:

  - __rtnl_newlink() -> do_setlink()
  - __rtnl_newlink() -> rtnl_newlink_create() -> rtnl_create_link()

Additionally, as validate_linkmsg() is now only called with a real
dev, we can remove the NULL check for dev in validate_linkmsg().

Note that we moved validate_linkmsg() check to the places where it has
not done any changes to the dev, as Jakub suggested.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/core/rtnetlink.c | 83 ++++++++++++++++++++++----------------------
 1 file changed, 42 insertions(+), 41 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 41de3a2f29e1..b9824708c3bd 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2377,45 +2377,43 @@ static	int rtnl_set_vf_rate(struct net_device *dev, int vf, int min_tx_rate,
 static int validate_linkmsg(struct net_device *dev, struct nlattr *tb[],
 			    struct netlink_ext_ack *extack)
 {
-	if (dev) {
-		if (tb[IFLA_ADDRESS] &&
-		    nla_len(tb[IFLA_ADDRESS]) < dev->addr_len)
-			return -EINVAL;
+	if (tb[IFLA_ADDRESS] &&
+	    nla_len(tb[IFLA_ADDRESS]) < dev->addr_len)
+		return -EINVAL;
 
-		if (tb[IFLA_BROADCAST] &&
-		    nla_len(tb[IFLA_BROADCAST]) < dev->addr_len)
-			return -EINVAL;
+	if (tb[IFLA_BROADCAST] &&
+	    nla_len(tb[IFLA_BROADCAST]) < dev->addr_len)
+		return -EINVAL;
 
-		if (tb[IFLA_GSO_MAX_SIZE] &&
-		    nla_get_u32(tb[IFLA_GSO_MAX_SIZE]) > dev->tso_max_size) {
-			NL_SET_ERR_MSG(extack, "too big gso_max_size");
-			return -EINVAL;
-		}
+	if (tb[IFLA_GSO_MAX_SIZE] &&
+	    nla_get_u32(tb[IFLA_GSO_MAX_SIZE]) > dev->tso_max_size) {
+		NL_SET_ERR_MSG(extack, "too big gso_max_size");
+		return -EINVAL;
+	}
 
-		if (tb[IFLA_GSO_MAX_SEGS] &&
-		    (nla_get_u32(tb[IFLA_GSO_MAX_SEGS]) > GSO_MAX_SEGS ||
-		     nla_get_u32(tb[IFLA_GSO_MAX_SEGS]) > dev->tso_max_segs)) {
-			NL_SET_ERR_MSG(extack, "too big gso_max_segs");
-			return -EINVAL;
-		}
+	if (tb[IFLA_GSO_MAX_SEGS] &&
+	    (nla_get_u32(tb[IFLA_GSO_MAX_SEGS]) > GSO_MAX_SEGS ||
+	     nla_get_u32(tb[IFLA_GSO_MAX_SEGS]) > dev->tso_max_segs)) {
+		NL_SET_ERR_MSG(extack, "too big gso_max_segs");
+		return -EINVAL;
+	}
 
-		if (tb[IFLA_GRO_MAX_SIZE] &&
-		    nla_get_u32(tb[IFLA_GRO_MAX_SIZE]) > GRO_MAX_SIZE) {
-			NL_SET_ERR_MSG(extack, "too big gro_max_size");
-			return -EINVAL;
-		}
+	if (tb[IFLA_GRO_MAX_SIZE] &&
+	    nla_get_u32(tb[IFLA_GRO_MAX_SIZE]) > GRO_MAX_SIZE) {
+		NL_SET_ERR_MSG(extack, "too big gro_max_size");
+		return -EINVAL;
+	}
 
-		if (tb[IFLA_GSO_IPV4_MAX_SIZE] &&
-		    nla_get_u32(tb[IFLA_GSO_IPV4_MAX_SIZE]) > dev->tso_max_size) {
-			NL_SET_ERR_MSG(extack, "too big gso_ipv4_max_size");
-			return -EINVAL;
-		}
+	if (tb[IFLA_GSO_IPV4_MAX_SIZE] &&
+	    nla_get_u32(tb[IFLA_GSO_IPV4_MAX_SIZE]) > dev->tso_max_size) {
+		NL_SET_ERR_MSG(extack, "too big gso_ipv4_max_size");
+		return -EINVAL;
+	}
 
-		if (tb[IFLA_GRO_IPV4_MAX_SIZE] &&
-		    nla_get_u32(tb[IFLA_GRO_IPV4_MAX_SIZE]) > GRO_MAX_SIZE) {
-			NL_SET_ERR_MSG(extack, "too big gro_ipv4_max_size");
-			return -EINVAL;
-		}
+	if (tb[IFLA_GRO_IPV4_MAX_SIZE] &&
+	    nla_get_u32(tb[IFLA_GRO_IPV4_MAX_SIZE]) > GRO_MAX_SIZE) {
+		NL_SET_ERR_MSG(extack, "too big gro_ipv4_max_size");
+		return -EINVAL;
 	}
 
 	if (tb[IFLA_AF_SPEC]) {
@@ -2736,10 +2734,6 @@ static int do_setlink(const struct sk_buff *skb,
 	char ifname[IFNAMSIZ];
 	int err;
 
-	err = validate_linkmsg(dev, tb, extack);
-	if (err < 0)
-		return err;
-
 	if (tb[IFLA_IFNAME])
 		nla_strscpy(ifname, tb[IFLA_IFNAME], IFNAMSIZ);
 	else
@@ -3156,6 +3150,10 @@ static int rtnl_setlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 		goto errout;
 	}
 
+	err = validate_linkmsg(dev, tb, extack);
+	if (err < 0)
+		goto errout;
+
 	err = do_setlink(skb, dev, ifm, extack, tb, 0);
 errout:
 	return err;
@@ -3399,6 +3397,9 @@ static int rtnl_group_changelink(const struct sk_buff *skb,
 
 	for_each_netdev_safe(net, dev, aux) {
 		if (dev->group == group) {
+			err = validate_linkmsg(dev, tb, extack);
+			if (err < 0)
+				return err;
 			err = do_setlink(skb, dev, ifm, extack, tb, 0);
 			if (err < 0)
 				return err;
@@ -3556,10 +3557,6 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 			m_ops = master_dev->rtnl_link_ops;
 	}
 
-	err = validate_linkmsg(dev, tb, extack);
-	if (err < 0)
-		return err;
-
 	if (tb[IFLA_LINKINFO]) {
 		err = nla_parse_nested_deprecated(linkinfo, IFLA_INFO_MAX,
 						  tb[IFLA_LINKINFO],
@@ -3623,6 +3620,10 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 		if (nlh->nlmsg_flags & NLM_F_REPLACE)
 			return -EOPNOTSUPP;
 
+		err = validate_linkmsg(dev, tb, extack);
+		if (err < 0)
+			return err;
+
 		if (linkinfo[IFLA_INFO_DATA]) {
 			if (!ops || ops != dev->rtnl_link_ops ||
 			    !ops->changelink)
-- 
2.39.1



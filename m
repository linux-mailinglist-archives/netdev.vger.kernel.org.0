Return-Path: <netdev+bounces-10273-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E67F572D676
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 02:34:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2EDD91C20BCE
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 00:34:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 326C619D;
	Tue, 13 Jun 2023 00:34:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A26196
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 00:34:42 +0000 (UTC)
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EACDE188;
	Mon, 12 Jun 2023 17:34:40 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id ca18e2360f4ac-77ad3bba2a9so305273939f.1;
        Mon, 12 Jun 2023 17:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686616480; x=1689208480;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wvMdVrWmm1KsKBFUWEX6pgpKCo/fWwZOLXy0dcLNEyU=;
        b=mCW+LG6bMXAYtLCunsvonmLxyBwyUFcx5jUrWNVjeHc7toh2Dq4/vOar2JNiboPLme
         YcOH0Fu+C6tihvwzzV4+yjl3a4IPYxr19Og3DsyjYJg0mChL7A8gjWUvRQjPjr4213w4
         Jfc35+Oj6B6tYLRkMf082yIDz6YpUeGnlo4OjrUHXMCekHvCreSqrC3KmpGGs5Wnf0cI
         IjB79ujFXXWDosvZfxjNzM/FPiUsCwj5V+SvNyaGdDZCyaw+ztAt5x5HR6YKSn8SjqnC
         v0Y+YLVRqSn5BO4mRLTRTc825WBm4b6PzRUqx/M8hNBp+O3e8rJC+HOZp6L8dSVPXWmP
         R0iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686616480; x=1689208480;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wvMdVrWmm1KsKBFUWEX6pgpKCo/fWwZOLXy0dcLNEyU=;
        b=LbwvehTKKdfwjPVj8sI+Z3dSKvjq/rxsQ6Uydz3GY5NHfBa1q6dgw2axtMroJAqOjQ
         n81o63lkYe2+EOiRscqaFThRGyQw2ayT8s/X5WPfcfxMKRYAtLNd7FdZ0bp86pQnXueh
         LorgTrlllmxXt87EE6lIqPTayvu9lz+S5Zr90wRzEMYrWAbcwJ73e+Yid7mtWq39IwXV
         FogEMl5YWiZSBNU7pGLyx9jwLBSSt2legyaagucsb47TcJm72+BhIKU2ijYU7lP4SZLJ
         VghEzfjbP6G87VWEBZChTA8qV74qShu7Pn7oli+FlG69rgcKl3Xb/YoyMIvBcThIXJ+l
         9+dA==
X-Gm-Message-State: AC+VfDy2f7Kkwe1EbboPb4LBwbPeWoLhn0JL9Fb4HG55MRSp58Zff6sW
	ZOjhRBsmT4F335ecVBJ5Cp0=
X-Google-Smtp-Source: ACHHUZ4feAvrqg921toBhoDlWAO1vwl0K8oIcaaXToOdRvE3/z0T+XUpqJRbfQv4M6eTOEyMgG9Sdg==
X-Received: by 2002:a05:6602:1851:b0:77a:c00c:1166 with SMTP id d17-20020a056602185100b0077ac00c1166mr9660252ioi.15.1686616480236;
        Mon, 12 Jun 2023 17:34:40 -0700 (PDT)
Received: from azeems-kspp.c.googlers.com.com (54.70.188.35.bc.googleusercontent.com. [35.188.70.54])
        by smtp.gmail.com with ESMTPSA id f5-20020a056638118500b0041eb1fb695csm3115812jas.105.2023.06.12.17.34.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 17:34:39 -0700 (PDT)
From: Azeem Shaikh <azeemshaikh38@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: linux-hardening@vger.kernel.org,
	Azeem Shaikh <azeemshaikh38@gmail.com>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: [PATCH] netfilter: ipset: Replace strlcpy with strscpy
Date: Tue, 13 Jun 2023 00:34:37 +0000
Message-ID: <20230613003437.3538694-1-azeemshaikh38@gmail.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

strlcpy() reads the entire source buffer first.
This read may exceed the destination size limit.
This is both inefficient and can lead to linear read
overflows if a source string is not NUL-terminated [1].
In an effort to remove strlcpy() completely [2], replace
strlcpy() here with strscpy().

Direct replacement is safe here since return value from all
callers of STRLCPY macro were ignored.

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
[2] https://github.com/KSPP/linux/issues/89

Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>
---
 net/netfilter/ipset/ip_set_hash_netiface.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/ipset/ip_set_hash_netiface.c
index 031073286236..95aeb31c60e0 100644
--- a/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -40,7 +40,7 @@ MODULE_ALIAS("ip_set_hash:net,iface");
 #define IP_SET_HASH_WITH_MULTI
 #define IP_SET_HASH_WITH_NET0
 
-#define STRLCPY(a, b)	strlcpy(a, b, IFNAMSIZ)
+#define STRSCPY(a, b)	strscpy(a, b, IFNAMSIZ)
 
 /* IPv4 variant */
 
@@ -182,11 +182,11 @@ hash_netiface4_kadt(struct ip_set *set, const struct sk_buff *skb,
 
 		if (!eiface)
 			return -EINVAL;
-		STRLCPY(e.iface, eiface);
+		STRSCPY(e.iface, eiface);
 		e.physdev = 1;
 #endif
 	} else {
-		STRLCPY(e.iface, SRCDIR ? IFACE(in) : IFACE(out));
+		STRSCPY(e.iface, SRCDIR ? IFACE(in) : IFACE(out));
 	}
 
 	if (strlen(e.iface) == 0)
@@ -400,11 +400,11 @@ hash_netiface6_kadt(struct ip_set *set, const struct sk_buff *skb,
 
 		if (!eiface)
 			return -EINVAL;
-		STRLCPY(e.iface, eiface);
+		STRSCPY(e.iface, eiface);
 		e.physdev = 1;
 #endif
 	} else {
-		STRLCPY(e.iface, SRCDIR ? IFACE(in) : IFACE(out));
+		STRSCPY(e.iface, SRCDIR ? IFACE(in) : IFACE(out));
 	}
 
 	if (strlen(e.iface) == 0)
-- 
2.41.0.162.gfafddb0af9-goog




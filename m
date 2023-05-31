Return-Path: <netdev+bounces-6857-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B4AD47186F7
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 18:02:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 101E61C20F2A
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 16:02:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B313B182AB;
	Wed, 31 May 2023 16:01:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6179182AA
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 16:01:59 +0000 (UTC)
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B7DD8E
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 09:01:51 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id 46e09a7af769-6af7d6f6f41so2936758a34.1
        for <netdev@vger.kernel.org>; Wed, 31 May 2023 09:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685548910; x=1688140910;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2+aAf6CEo9Mvn0fPnc4Wgd4UhgHJNzVrY0YQmWkbWvc=;
        b=NnSPsF3DTlFdVwzZ368wo1p/KxjMThEpMVqdr+/it0n5cj4sgq2t5MSqamgYsWNmmb
         VckJPHIohx2p1FhVDR0WrFLvVBQdmnhZi1fwVJQZpxP8LKdE3Skk0HrHh0oqnzhjMT6+
         FwFHjNWpxHYtKmFBS043C9CQZ8jeTeRsnIj10w7n3M1p4D81aebFJ1wZtIT8TbnIeMei
         /oAQs90dhFA8pWxZYEb09AWGQC7dof+tjYQevkfOdsITncRpoO6JtAEoIQm27zaYmNJW
         bB0ZlJTsAg8aAAOfFhD3LWMs10qBFDeWOKzpK3nQrIK5s6ixuEcF5fH+nQRVUC8i3x4i
         nLfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685548910; x=1688140910;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2+aAf6CEo9Mvn0fPnc4Wgd4UhgHJNzVrY0YQmWkbWvc=;
        b=jYQZ7i9MSUj5OauDECCeOsdnhx32Yb7cgakjK2Jx26MNy0jMkR6FzWNbGxNPSxmhTL
         qdcWUYt0QQc7m/GeT9ezTk+2MH8qdgcr2Pe9ShSu3Cl2urqINPiFNsJRs7dif8LFVedC
         SNgEfdqyuAVGqDowUOd8CccRmUqrv8YgRApeZHspU/DC1u68a+kkNozT4l1ttW/OGwwq
         VqKYTRqdVfVnupIQXqieRu7Ywphcg84Zy0D8R38+ujg0h1ZAhYbNJt4bb4C4b0nIMOjm
         cqLxPQTKrb4pepIAIzB6dmSC9iuqH/vK8w7m6roH70AyvAWHyZe/9mpnIJhm7JDfqgYp
         W+VQ==
X-Gm-Message-State: AC+VfDwCsQm9mB8WSqCfIHfDoxeYlYL3DFT3unAE+h6UvfVydUglJn4k
	iizkm7WccAUH3yi2p815yq+tMAHnWhWZVw==
X-Google-Smtp-Source: ACHHUZ7Dkr6HU/2q6W3k5wH3Jka22DKQWd2/5dLb+w3NHCcnVEqFQF6lk7UIHhh6lR2mHD+wDWe+Ww==
X-Received: by 2002:a05:6830:22e3:b0:6a6:4ef2:7c98 with SMTP id t3-20020a05683022e300b006a64ef27c98mr2550883otc.31.1685548909871;
        Wed, 31 May 2023 09:01:49 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id s11-20020ae9f70b000000b007594a7aedb2sm5261050qkg.105.2023.05.31.09.01.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 May 2023 09:01:49 -0700 (PDT)
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
Subject: [PATCHv2 net 3/3] rtnetlink: add the missing IFLA_GRO_ tb check in validate_linkmsg
Date: Wed, 31 May 2023 12:01:44 -0400
Message-Id: <70169240cb4430a9b09e89c27ef268e772b68548.1685548598.git.lucien.xin@gmail.com>
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

This fixes the issue that dev gro_max_size and gso_ipv4_max_size
can be set to a huge value:

  # ip link add dummy1 type dummy
  # ip link set dummy1 gro_max_size 4294967295
  # ip -d link show dummy1
    dummy addrgenmode eui64 ... gro_max_size 4294967295

Fixes: 0fe79f28bfaf ("net: allow gro_max_size to exceed 65536")
Fixes: 9eefedd58ae1 ("net: add gso_ipv4_max_size and gro_ipv4_max_size per device")
Reported-by: Xiumei Mu <xmu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
 net/core/rtnetlink.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index bc068a857219..41de3a2f29e1 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2399,11 +2399,23 @@ static int validate_linkmsg(struct net_device *dev, struct nlattr *tb[],
 			return -EINVAL;
 		}
 
+		if (tb[IFLA_GRO_MAX_SIZE] &&
+		    nla_get_u32(tb[IFLA_GRO_MAX_SIZE]) > GRO_MAX_SIZE) {
+			NL_SET_ERR_MSG(extack, "too big gro_max_size");
+			return -EINVAL;
+		}
+
 		if (tb[IFLA_GSO_IPV4_MAX_SIZE] &&
 		    nla_get_u32(tb[IFLA_GSO_IPV4_MAX_SIZE]) > dev->tso_max_size) {
 			NL_SET_ERR_MSG(extack, "too big gso_ipv4_max_size");
 			return -EINVAL;
 		}
+
+		if (tb[IFLA_GRO_IPV4_MAX_SIZE] &&
+		    nla_get_u32(tb[IFLA_GRO_IPV4_MAX_SIZE]) > GRO_MAX_SIZE) {
+			NL_SET_ERR_MSG(extack, "too big gro_ipv4_max_size");
+			return -EINVAL;
+		}
 	}
 
 	if (tb[IFLA_AF_SPEC]) {
-- 
2.39.1



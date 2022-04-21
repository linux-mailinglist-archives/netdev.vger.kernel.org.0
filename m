Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7EB50AB32
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 00:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442349AbiDUWLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 18:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442351AbiDUWLE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 18:11:04 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA234EDDD;
        Thu, 21 Apr 2022 15:08:13 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id d9so4723648qvm.4;
        Thu, 21 Apr 2022 15:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6gYFSoVcpwLd28VgNWwfiPjbVU28eosEw1LDKSZ8KQc=;
        b=ZJDNoA9FyoglICDWyPkyyPe9AqQzHNUZSXcw2ST/ZWMMRff+/7FUB2XngF5Gad1Xax
         756WjkDh9c+tZBn2MKByXXylogEPCrIgdkFXvWbxNocv2EpK8I7JbxENgwhvcf72qDNr
         WoIoCxeHdzlLfUvVZz+BWTTscphkXG8wWf2BjLRYfXnD64NxQsXv1sI/5h7ZHEYnNArW
         CnHcpoYEi9DsmlPnI0q9HeT5xo+tPZzr1Y65b2+424+m3w3TGGlIuIZh7eon4MEVnQAz
         QLjwm6yPntWJ6MuHZrF70BwHvB/h/N/FIiIYHO7cxvkLVgeKg7RfGfSWfluM6e9mQnJc
         d/UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6gYFSoVcpwLd28VgNWwfiPjbVU28eosEw1LDKSZ8KQc=;
        b=TOLuLvmu3ctT1ZDcI8BJbJAR2y5zD2BEAIlMqUQWCGsx25Nl8Sfm3PQ065R6qYXFmc
         4Dg0ieWjCizAsqtTgN+y6vS9yGy2xdyO4dqAbTbAwyX3fs0JEu08PIvpa9kVjdOyYMrn
         H51OMJcbJQdP3aplzz6UvJ6crBD3rn3yZq+RHzoafVlR1xnvGnQHhuvayzYTPrYz9a+c
         B8DUchF+AKKKTIiuWVLr8U8CN5XPqPFIKKevZo0Im92DP2s0w0JVYFbsJAK6XEkfs1FF
         w5+e//1kjJjzJoiD23tGjba0eHDY4YPNdUFV7gUIKSQDE3zcOshW8Q2HkTxFwTjEezmP
         80iQ==
X-Gm-Message-State: AOAM531NuWxIP1bNBQ1GTPdxeFIpczEkR54WFVpt4XEm7TK/5uqCJ0/J
        3wzimtHgdOkuzbQVnJsF3Ls49aPdoQ==
X-Google-Smtp-Source: ABdhPJzLoETi2+sYSibFwua+LrkvqKACoyLJUhtbvOHHyfuCf5ADpsXYHj4JeNsBsKTC/gMi+c4MwQ==
X-Received: by 2002:a05:6214:5284:b0:444:10c8:ee59 with SMTP id kj4-20020a056214528400b0044410c8ee59mr1525618qvb.68.1650578892675;
        Thu, 21 Apr 2022 15:08:12 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-13-57-97-131.us-west-1.compute.amazonaws.com. [13.57.97.131])
        by smtp.gmail.com with ESMTPSA id h18-20020ac85e12000000b002f341c6d20esm182178qtx.80.2022.04.21.15.08.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 15:08:12 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Peilin Ye <peilin.ye@bytedance.com>, "xeb@mail.ru" <xeb@mail.ru>,
        William Tu <u9012063@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH net 1/3] ip_gre: Make o_seqno start from 0 in native mode
Date:   Thu, 21 Apr 2022 15:07:57 -0700
Message-Id: <dd63f881729052aa4e08a5c7cb9732724c557dfd.1650575919.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1650575919.git.peilin.ye@bytedance.com>
References: <cover.1650575919.git.peilin.ye@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peilin Ye <peilin.ye@bytedance.com>

For GRE and GRETAP devices, currently o_seqno starts from 1 in native
mode.  According to RFC 2890 2.2., "The first datagram is sent with a
sequence number of 0."  Fix it.

It is worth mentioning that o_seqno already starts from 0 in collect_md
mode, see gre_fb_xmit(), where tunnel->o_seqno is passed to
gre_build_header() before getting incremented.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
 net/ipv4/ip_gre.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 99db2e41ed10..ca70b92e80d9 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -459,14 +459,12 @@ static void __gre_xmit(struct sk_buff *skb, struct net_device *dev,
 		       __be16 proto)
 {
 	struct ip_tunnel *tunnel = netdev_priv(dev);
-
-	if (tunnel->parms.o_flags & TUNNEL_SEQ)
-		tunnel->o_seqno++;
+	__be16 flags = tunnel->parms.o_flags;
 
 	/* Push GRE header. */
 	gre_build_header(skb, tunnel->tun_hlen,
-			 tunnel->parms.o_flags, proto, tunnel->parms.o_key,
-			 htonl(tunnel->o_seqno));
+			 flags, proto, tunnel->parms.o_key,
+			 (flags & TUNNEL_SEQ) ? htonl(tunnel->o_seqno++) : 0);
 
 	ip_tunnel_xmit(skb, dev, tnl_params, tnl_params->protocol);
 }
-- 
2.20.1


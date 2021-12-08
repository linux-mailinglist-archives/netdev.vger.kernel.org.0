Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A295346D633
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 15:55:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235569AbhLHO6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 09:58:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235568AbhLHO6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 09:58:44 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17CF3C0617A1
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 06:55:13 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id u80so2643586pfc.9
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 06:55:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8mApNYIlmyYDE92hmrIu9j0ZnkBUvjBpogxont+LFMc=;
        b=RMiUZbtMdh/V5CLz4eAW/XZHW0PJIvmuEld2vi1BpqEIRmNd46xx8qYbSJQuunI69W
         6vhHvnPCXBBKhg4x/U4AJKs2MkDkGKDRqSCTQcA399xhJ2r37rOPZHxTMkf4L5bGZKp6
         iStAd1+7iRiVRsBFVws8XHtc0lRRMfpXjUGO2wm4IWBGb+dAHUNZ0AKRnB8DTeFBTkxi
         lpFsbx2EYumXBqo6NCNv+qjOsokUO9UdeAddF/h4L6dBWK0kDe2lHIbsKsAeBOjKnIPi
         ugin9k2fU64N9SOSXmHLtaky2q+x4HIlvxWODmNykAX9yBqBaERWv2/lKLXyyxr+sztc
         416Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8mApNYIlmyYDE92hmrIu9j0ZnkBUvjBpogxont+LFMc=;
        b=Gfm6igu0nncTwI25KuLNCvnNAXwGD4LFQAhJUmqcfVHKv3eNJZMrDP5w1fkLRSDDrx
         2XVqfiBQ6Iuorp5f3CfczScUC+v8O6AFDErKRwOCuWEg4Ty1RKeWH38vN3+qmnEDVK0Q
         SiVGDpBsURd+AnI2G7kFd8Ylz4fQL+zGDp+oepLRnIqa3kHSzM5cd+ovgOLxKfc+w0YM
         HES8GHJhHr/2WUOI9JtZs3xNU2n2oD2pL5e+5Fxuty3bG2rjN/tV5MX9rwHl7O4gb6DE
         wcUGxLBfXYZfRX/0wocPE4WPXQuGxVfIW40IxSaEw6THxPZ3Uija6OjMDtOM/GnX6Z+v
         b1qA==
X-Gm-Message-State: AOAM530GIBJM6hv3JYHNp5kJT2tRzxBu41AaoRdaCZfZMpr8wZe/T05c
        Auh3UVLbB34mxbyRHMoPPJI6KvCh3H0Lxw==
X-Google-Smtp-Source: ABdhPJzJf/7Kacd+7pwUGZwnNyperw2jdp6/iImZxWPwphOcEq2Es/Xcm8KP1abWxEIvwrzPUDynkA==
X-Received: by 2002:a63:5906:: with SMTP id n6mr28622380pgb.563.1638975312349;
        Wed, 08 Dec 2021 06:55:12 -0800 (PST)
Received: from bogon.xiaojukeji.com ([111.201.150.233])
        by smtp.gmail.com with ESMTPSA id kk7sm7562763pjb.19.2021.12.08.06.55.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Dec 2021 06:55:11 -0800 (PST)
From:   xiangxia.m.yue@gmail.com
To:     netdev@vger.kernel.org
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [net v5 1/3] net: core: set skb useful vars in __bpf_tx_skb
Date:   Wed,  8 Dec 2021 22:54:57 +0800
Message-Id: <20211208145459.9590-2-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20211208145459.9590-1-xiangxia.m.yue@gmail.com>
References: <20211208145459.9590-1-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

We may use bpf_redirect to redirect the packets to other
netdevice (e.g. ifb) in ingress or egress path.

The target netdevice may check the *skb_iif, *redirected
and *from_ingress. For example, if skb_iif or redirected
is 0, ifb will drop the packets.

bpf_redirect may be invoked in ingress or egress path, so
we set the *skb_iif unconditionally.

Fixes: a70b506efe89 ("bpf: enforce recursion limit on redirects")
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Antoine Tenart <atenart@kernel.org>
Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
Cc: Wei Wang <weiwan@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 net/core/filter.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 8271624a19aa..bcfdce9e99f4 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2107,9 +2107,19 @@ static inline int __bpf_tx_skb(struct net_device *dev, struct sk_buff *skb)
 		return -ENETDOWN;
 	}
 
-	skb->dev = dev;
+	/* The target netdevice (e.g. ifb) may use the:
+	 * - skb_iif, bpf_redirect invoked in ingress or egress path.
+	 * - redirected
+	 * - from_ingress
+	 */
+	skb->skb_iif = skb->dev->ifindex;
+#ifdef CONFIG_NET_CLS_ACT
+	skb_set_redirected(skb, skb->tc_at_ingress);
+#else
 	skb->tstamp = 0;
+#endif
 
+	skb->dev = dev;
 	dev_xmit_recursion_inc();
 	ret = dev_queue_xmit(skb);
 	dev_xmit_recursion_dec();
-- 
2.27.0


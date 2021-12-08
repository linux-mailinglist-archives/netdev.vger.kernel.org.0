Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB18746D634
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 15:55:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235571AbhLHO6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 09:58:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235568AbhLHO6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 09:58:49 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79D6BC061746
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 06:55:17 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id r5so2266334pgi.6
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 06:55:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TepUL+oYncu3pNffxE3UV5HQ+Dtz5mhJODp0jU3UZ/M=;
        b=gCBtvAK+o5GnNdcr9rqAwgPX0nCkZl7albeFKt3gfC1NSYtjTfW2uCpqCEbpmZ474r
         U1eHytKRGKFjWzvZpuNuRWtg3sYTXcALO4u9pENf6WlxeE07IW5kC1hvsswq8ynACG8f
         FP/ArFVXrQov2NefeZSkbrFCPObJz0h5I/8rDJ+8++SAgSP33Vb9ykC8Ryk/JugM7DOI
         XM3UTgFRxs4dR820gSJl3doT+WYLUE1AChPviF42ww0qFl980qyoKo63HmICmtyuMCdq
         f6BYXMb6jrGumia+y2Q00IbBEy1JNFxcXWCHPRSH4SslE28lzitJYX5InP6QcLcHjIjZ
         M8Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TepUL+oYncu3pNffxE3UV5HQ+Dtz5mhJODp0jU3UZ/M=;
        b=0nZQJ3ORms6UB1wbbH9kwbKJYfKkVqiPDvQI5QGtHDhPCKYq7k7n2IgSbGPzzg/yxi
         68oIAyPyh/LV3KKYFW3Ys2Kfvwu55ErHUoFEGUfFxBrgz1S6Zv8mSmyclXzAIYMMHida
         Knm+lpX59WvyStr9HdWPetrMwZwXWfXk75B9vkGxye0oeFd4L3GWeLs0o4iwYaa02hJc
         JCPUj9IuwWRL+Xk5KELhSlR1JxeToGE7DrxN7MJgW9OqjZkeYT1i5ewClF/27kjEH7kf
         +XCdSeYNyHZchWZD5FaRkfb6Zj4l+skVTBE0XVErmEpRFv0eRm6Zz8oTMPGvPjdynkYs
         d93g==
X-Gm-Message-State: AOAM530PCSwN5a4XjFlj6cL9/8hdif5qqW8MRBTfhLrf9SH8JIxrqYnt
        KwVXQtukG/Nsb2X53+GJeT84FVU91qSXHA==
X-Google-Smtp-Source: ABdhPJzBQ5O5IYI1XNTCWeB/MR6/TfPtGY01A1j8AjlArT+AILmc++2GvGyAocJmROu9N+fGnZiaqA==
X-Received: by 2002:a63:4c09:: with SMTP id z9mr28850108pga.561.1638975316699;
        Wed, 08 Dec 2021 06:55:16 -0800 (PST)
Received: from bogon.xiaojukeji.com ([111.201.150.233])
        by smtp.gmail.com with ESMTPSA id kk7sm7562763pjb.19.2021.12.08.06.55.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Dec 2021 06:55:16 -0800 (PST)
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
Subject: [net v5 2/3] net: sched: add check tc_skip_classify in sch egress
Date:   Wed,  8 Dec 2021 22:54:58 +0800
Message-Id: <20211208145459.9590-3-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20211208145459.9590-1-xiangxia.m.yue@gmail.com>
References: <20211208145459.9590-1-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Try to resolve the issues as below:
* We look up and then check tc_skip_classify flag in net
  sched layer, even though skb don't want to be classified.
  That case may consume a lot of cpu cycles. This patch
  is useful when there are a lot of filters with different
  prio. There is ~5 prio in in production, ~1% improvement.

  Rules as below:
  $ for id in $(seq 1 5); do
  $       tc filter add ... egress prio $id ... action mirred egress redirect dev ifb0
  $ done

* bpf_redirect may be invoked in egress path. If we don't
  check the flags and then return immediately, the packets
  will loopback.

  $ tc filter add dev eth0 egress bpf direct-action obj ifb.o sec ifb

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
 net/core/dev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index a64297a4cc89..81ad415b78f9 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3823,6 +3823,9 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
 	if (!miniq)
 		return skb;
 
+	if (skb_skip_tc_classify(skb))
+		return skb;
+
 	/* qdisc_skb_cb(skb)->pkt_len was already set by the caller. */
 	qdisc_skb_cb(skb)->mru = 0;
 	qdisc_skb_cb(skb)->post_ct = false;
-- 
2.27.0


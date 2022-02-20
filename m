Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 062AF4BCCF7
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 08:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242920AbiBTHI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 02:08:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239157AbiBTHIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 02:08:18 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ACB54D9C8;
        Sat, 19 Feb 2022 23:07:57 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id i21so5938628pfd.13;
        Sat, 19 Feb 2022 23:07:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+zj+yKOOAhMIrT7/fa7Kt9wEioXPkrCjpEMqA6i4/zg=;
        b=ktskm5JJNJzRwK2BdESHlVWUEyr3cDAJOMNV26aHNcoSvtDhYSEqq+3IuKMuHle7LZ
         n2EbF9lwnTTDbi9rXp/GouLzbmlFSi4x7ui1tswxHhmBT6Jwogp3XY+C+9uGGtdT3wjB
         S1zMwT/BamCbnFk8GAVb9A1pd000wNB19R5ecPV3OnLTMlxw5Z51fIPftbFxkQMlb0Ra
         /ksRRI5jKSEuixYBOO1Kg1MF9LYd6IkDrUqPKyNVZHg0wwSn3LAtklEFPlXak/lQRVHC
         Z9wSgYX/s5RVNDP63WU7hAQdGGezj9Nk7Yqj41+oivF0U5dsd2P5fIFIFvNBrDU17BKT
         uT3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+zj+yKOOAhMIrT7/fa7Kt9wEioXPkrCjpEMqA6i4/zg=;
        b=yoYDT9ooiNNAWx+ycHk7rcpqH56Rjb0vVcVxBzlJl+mj3NyK3dIc62wBjsoIMihLyw
         JqXT4tjJE/1BDiEO+Bo5ySOp3u45Z5qATxAUiavBRDTdloZ89XTUwSAYmax5xZ/qBAgR
         WNr4ax0vO/VI1KUZPGLhlMCZ2xrGbecRPjPMI7Gq80y5bdYGxyeLk2q5FecKugTQ7FBt
         /nBHhlWLASTcLdgWLEmKoW7m+iEXWCr/jnrgompjaLP4OYN9izu3bKeZoRyY7Pnqkt5z
         lvVUM6H00GvpI96Y26+MrMuA/Oi9noVdQVUkFrzSpnBoWK6A6XUNbZ5cZvyR7TzioG/j
         +3ZQ==
X-Gm-Message-State: AOAM530X1yR87Cri1fjkcIUnBAHytI9MscG4+EaLI5ELjrJ6OtAe8+Us
        e8ON8osat96VvCV0zfOB/p0=
X-Google-Smtp-Source: ABdhPJyPJBzi6n4eVRH7QLIn5zQP7POaIgpOFomfa8aXQLvP9JI/gotL3CGGzK4OchXTWaa6Umoqrg==
X-Received: by 2002:a05:6a00:1995:b0:4e1:a7dd:96d6 with SMTP id d21-20020a056a00199500b004e1a7dd96d6mr14842539pfl.16.1645340876722;
        Sat, 19 Feb 2022 23:07:56 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.114])
        by smtp.gmail.com with ESMTPSA id p1sm8351326pfo.212.2022.02.19.23.07.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Feb 2022 23:07:56 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org, kuba@kernel.org
Cc:     edumazet@google.com, davem@davemloft.net, rostedt@goodmis.org,
        mingo@redhat.com, yoshfuji@linux-ipv6.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        imagedong@tencent.com, talalahmad@google.com,
        keescook@chromium.org, ilias.apalodimas@linaro.org, alobakin@pm.me,
        memxor@gmail.com, atenart@kernel.org, bigeasy@linutronix.de,
        pabeni@redhat.com, linyunsheng@huawei.com, arnd@arndb.de,
        yajun.deng@linux.dev, roopa@nvidia.com, willemb@google.com,
        vvs@virtuozzo.com, cong.wang@bytedance.com,
        luiz.von.dentz@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        flyingpeng@tencent.com, mengensun@tencent.com
Subject: [PATCH net-next v3 2/9] net: tcp: add skb drop reasons to tcp_v4_rcv()
Date:   Sun, 20 Feb 2022 15:06:30 +0800
Message-Id: <20220220070637.162720-3-imagedong@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220220070637.162720-1-imagedong@tencent.com>
References: <20220220070637.162720-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

Use kfree_skb_reason() for some path in tcp_v4_rcv() that missed before,
including:

SKB_DROP_REASON_SOCKET_FILTER
SKB_DROP_REASON_XFRM_POLICY

Reviewed-by: Mengen Sun <mengensun@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
---
v2:
- let NO_SOCKET trump the XFRM failure
---
 net/ipv4/tcp_ipv4.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 6873f46fc8ba..a3beab01e9a7 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2057,6 +2057,8 @@ int tcp_v4_rcv(struct sk_buff *skb)
 			iph = ip_hdr(skb);
 			tcp_v4_fill_cb(skb, iph, th);
 			nsk = tcp_check_req(sk, skb, req, false, &req_stolen);
+		} else {
+			drop_reason = SKB_DROP_REASON_SOCKET_FILTER;
 		}
 		if (!nsk) {
 			reqsk_put(req);
@@ -2092,8 +2094,10 @@ int tcp_v4_rcv(struct sk_buff *skb)
 		}
 	}
 
-	if (!xfrm4_policy_check(sk, XFRM_POLICY_IN, skb))
+	if (!xfrm4_policy_check(sk, XFRM_POLICY_IN, skb)) {
+		drop_reason = SKB_DROP_REASON_XFRM_POLICY;
 		goto discard_and_relse;
+	}
 
 	if (tcp_v4_inbound_md5_hash(sk, skb, dif, sdif))
 		goto discard_and_relse;
@@ -2166,6 +2170,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 
 do_time_wait:
 	if (!xfrm4_policy_check(NULL, XFRM_POLICY_IN, skb)) {
+		drop_reason = SKB_DROP_REASON_XFRM_POLICY;
 		inet_twsk_put(inet_twsk(sk));
 		goto discard_it;
 	}
-- 
2.35.1


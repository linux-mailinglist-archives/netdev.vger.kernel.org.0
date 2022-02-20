Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 254C44BCD0E
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 08:18:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234910AbiBTHIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 02:08:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234501AbiBTHIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 02:08:10 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 206EB4D244;
        Sat, 19 Feb 2022 23:07:50 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id d17so5995236pfl.0;
        Sat, 19 Feb 2022 23:07:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WjAM/H6V8k6iZ0h/t53GnXn7S+EJJ1PCS7UmZdIQVy8=;
        b=O+cyc5udZpU4yHr2EPNr0sJYLCARZEX+7ZO1ttqmPRwSENUoO0Vp+SNs4phv3Y3z2a
         epLgHnQFoLKZF7UaFsS9hKBWrzhA7gIsur3bujkKiD7i+9D09HxWJTI3AnHCHPSqNN8U
         fjLy84hMRBkOHxRQjaXopQW/W304CAhNiXe1ooOBIyxacaR7TgJ0DrdelE2ELXVlG0ke
         77Ue2p/nEkv5O6JDXE7U9SXdzRKX86PRMtngSfFSZ+aeEC1iT5Uqjoz5X8nO2fnakjGG
         P2ZYPzJkjDlHyxabLn9k4INCBIXQ8hLzUnlX+kz7d7F4ilel/SCAX77V4CgEBLYjXs6R
         CASw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WjAM/H6V8k6iZ0h/t53GnXn7S+EJJ1PCS7UmZdIQVy8=;
        b=L0KBg5hEh8C80D8ljOJa+4gEDpoeyfXD7EBZw2ke4BPommscCHILjV2TPXt3JyBrIg
         /CFXndprjQES4XMz9+VosQhbF7shXFJQFIyqc7OM7/qX3HL14HoGxsOjv6ZBSUVticwP
         a71ks6tCfU7MHhGjjgENZqBSjMb+dJlVLO8PQphl0HuNzBc1cs6t9SmTTbqMoGheqTXa
         3sBF4r6nX2YQA952AxG9ZzORWYsSUfdIlpwBGO6FMgwg6pHg/+RLmzZ4AuiLLtRuy7eR
         Y59OmLIFXqqYf+LXlAZCuyaHPC3p/lNbAMUmBu8Y2yFxENrxrdhn33dvjo83vechMvCj
         8kAw==
X-Gm-Message-State: AOAM533DNeRpQxeasgudKlmqMKGhafocdsV7dqlhvVOdk1pc2kd2rRwU
        9xzOpzPI9dpDgJtWo00QzP8=
X-Google-Smtp-Source: ABdhPJyvXrJ78R86NabS4SWc47bJcQrA4vRrbIAbpeLGtsp7EfikVFBINoHX572LfD9/BD23sTJhXg==
X-Received: by 2002:a63:1844:0:b0:36c:6a88:ad72 with SMTP id 4-20020a631844000000b0036c6a88ad72mr11664906pgy.329.1645340869710;
        Sat, 19 Feb 2022 23:07:49 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.114])
        by smtp.gmail.com with ESMTPSA id p1sm8351326pfo.212.2022.02.19.23.07.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Feb 2022 23:07:49 -0800 (PST)
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
Subject: [PATCH net-next v3 1/9] net: tcp: introduce tcp_drop_reason()
Date:   Sun, 20 Feb 2022 15:06:29 +0800
Message-Id: <20220220070637.162720-2-imagedong@tencent.com>
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

For TCP protocol, tcp_drop() is used to free the skb when it needs
to be dropped. To make use of kfree_skb_reason() and pass the drop
reason to it, introduce the function tcp_drop_reason(). Meanwhile,
make tcp_drop() an inline call to tcp_drop_reason().

Reviewed-by: Mengen Sun <mengensun@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
---
v3:
- remove the 'inline' of tcp_drop()
---
 net/ipv4/tcp_input.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index af94a6d22a9d..2bcbefa4322a 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4684,10 +4684,16 @@ static bool tcp_ooo_try_coalesce(struct sock *sk,
 	return res;
 }
 
-static void tcp_drop(struct sock *sk, struct sk_buff *skb)
+static void tcp_drop_reason(struct sock *sk, struct sk_buff *skb,
+			    enum skb_drop_reason reason)
 {
 	sk_drops_add(sk, skb);
-	__kfree_skb(skb);
+	kfree_skb_reason(skb, reason);
+}
+
+static void tcp_drop(struct sock *sk, struct sk_buff *skb)
+{
+	tcp_drop_reason(sk, skb, SKB_DROP_REASON_NOT_SPECIFIED);
 }
 
 /* This one checks to see if we can put data from the
-- 
2.35.1


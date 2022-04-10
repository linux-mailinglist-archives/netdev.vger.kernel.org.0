Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 955554FAECA
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 18:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243530AbiDJQNH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 12:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240087AbiDJQNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 12:13:04 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B30FA483BB
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 09:10:53 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id c24-20020a9d6c98000000b005e6b7c0a8a8so6243915otr.2
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 09:10:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EvgYX1I2TdvOBiZ7Pfh0m7DvERKxA/qS4bF/+kJQmJY=;
        b=OIr7sHYqFIe/bUaPQD6Zs8UM64PdCgbYdCcEP0aqU5V8xjJJf/zEZruXSwimZiJpI2
         iv8BwtKeWOXek75ThuUc1mimiBg9NEgRCfTABcw4e2cUZ5oy8o/kDU1lfQlWlJuT8SjZ
         53Brbrg2EQd9YnSxS81+FQoKysoVN9y4Tg/eHNaGoid4/B6A0CCmU4cjYk5gMkQWZzTY
         7+nxxO+Ysdn3d46apFbIDnSOrGLjJhBfb/44gSx7anvvhuZm5G9sw4I0hO6QkWVtbngn
         oIwOmXycJigYzgE+f1stzNIrVIQ7AIOi/0Bm3f3ij9ONKIUz1w3Ij3dlug0Io6Z6GNlg
         ppoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EvgYX1I2TdvOBiZ7Pfh0m7DvERKxA/qS4bF/+kJQmJY=;
        b=vpuUWVUpcQuRXwCqmzBHRlVWTlYtSeI4G9jKRyl9olqIniq1tC1Ue9g3qu3QvC6oqz
         MsIGxesCbBIyqpEo/BUcGK/0/d+7/XWw/jsmf5Waod13WB+1TwD+1VwgOSOQ8XOTAiLu
         b/S2g2CBQAd6fFfxQTGpd74z8G+mVVO5pQV1p9anxNzmHr2ghWGzDSjWZpM44Pz1GxPz
         hsfDfAulDEoy0RAn5s2y3G2+KXXexjo548b23y2cSxsPszEmTCIZtO3pjQw80l+SVEIV
         1iSu51CfOMScIpfE0MEYz6xRzTchRjcImNu2mmVW3Iiv3dZ+7CVAVYn0sWHbmw5w7i7o
         esWg==
X-Gm-Message-State: AOAM531rs4+WXXoXM1ionWAoCzPd1ZD/qb7uZTyUOWch5df+URgxc4DW
        8hfBZmhENmQQus3gyV1euhHn1y2cgvI=
X-Google-Smtp-Source: ABdhPJy/qxWLv1T45pcC0edqIzX1BnX23utGJ4I6mhleP7Q1Qj4xcjWXmwrzlz+7Ny8EXQSlOT+Jjg==
X-Received: by 2002:a05:6830:138d:b0:5b2:4b0a:a4fa with SMTP id d13-20020a056830138d00b005b24b0aa4famr10067980otq.380.1649607052947;
        Sun, 10 Apr 2022 09:10:52 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:9a32:f478:4bc0:f027])
        by smtp.gmail.com with ESMTPSA id v21-20020a4ade95000000b00320f814c73bsm10550200oou.47.2022.04.10.09.10.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Apr 2022 09:10:52 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: [Patch bpf-next v1 3/4] skmsg: get rid of skb_clone()
Date:   Sun, 10 Apr 2022 09:10:41 -0700
Message-Id: <20220410161042.183540-4-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220410161042.183540-1-xiyou.wangcong@gmail.com>
References: <20220410161042.183540-1-xiyou.wangcong@gmail.com>
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

From: Cong Wang <cong.wang@bytedance.com>

With ->read_skb() now we have an entire skb dequeued from
receive queue, now we just need to grab an addtional refcnt
before passing its ownership to recv actors.

And we should not touch them any more, particularly for
skb->sk. Fortunately, skb->sk is already set for most of
the protocols except UDP where skb->sk has been stolen,
so we have to fix it up for UDP case.

Cc: Eric Dumazet <edumazet@google.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/core/skmsg.c | 7 +------
 net/ipv4/udp.c   | 1 +
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 19bca36940a2..7aa37b6287e1 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -1162,10 +1162,7 @@ static int sk_psock_verdict_recv(struct sock *sk, struct sk_buff *skb)
 	int ret = __SK_DROP;
 	int len = skb->len;
 
-	/* clone here so sk_eat_skb() in tcp_read_sock does not drop our data */
-	skb = skb_clone(skb, GFP_ATOMIC);
-	if (!skb)
-		return 0;
+	skb_get(skb);
 
 	rcu_read_lock();
 	psock = sk_psock(sk);
@@ -1178,12 +1175,10 @@ static int sk_psock_verdict_recv(struct sock *sk, struct sk_buff *skb)
 	if (!prog)
 		prog = READ_ONCE(psock->progs.skb_verdict);
 	if (likely(prog)) {
-		skb->sk = sk;
 		skb_dst_drop(skb);
 		skb_bpf_redirect_clear(skb);
 		ret = bpf_prog_run_pin_on_cpu(prog, skb);
 		ret = sk_psock_map_verd(ret, skb_bpf_redirect_fetch(skb));
-		skb->sk = NULL;
 	}
 	if (sk_psock_verdict_apply(psock, skb, ret) < 0)
 		len = 0;
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 9faca5758ed6..dbf33f68555d 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1818,6 +1818,7 @@ int udp_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 			continue;
 		}
 
+		WARN_ON(!skb_set_owner_sk_safe(skb, sk));
 		used = recv_actor(sk, skb);
 		if (used <= 0) {
 			if (!copied)
-- 
2.32.0


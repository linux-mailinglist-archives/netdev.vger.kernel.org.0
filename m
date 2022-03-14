Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80DEC4D80C1
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 12:33:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238957AbiCNLeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 07:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238978AbiCNLeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 07:34:11 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A026E140A0;
        Mon, 14 Mar 2022 04:32:55 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id q19so13502721pgm.6;
        Mon, 14 Mar 2022 04:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qa86P5vWTRRVjIwybfrryRnJY/KdwATX4VyldijUHvM=;
        b=ddS5K9aX45rhC7ImoWuabI7ggSHmTY2Le7iScs8kFC7gvWXkVltk8EA5K+39Uz5T4z
         NniW4YbCynsZsRYw7U8FO/wmFavDMl+pzFuHCh/maKd7F7d3kP04T2n4EoWxyPMwRS9U
         V1mZBWVg4KT+sQpgItTLe4IDPKoeNJkkyU8QLFFiUzvTTEZPsK9vOajqsNZtsSTsz9G6
         CWpFwcZKaVKK4HbtWYSEY0xhjNKoagpNXg7kAmvqnRUToqsjwAsDyPW/ubf43esbC9zk
         TEdvwW7zC5ABnwCnaZgCuTH9bfw79Hwe0pxDI6A9JrwQEUbG3cBQm0hyabQJRbpetl2J
         ILCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qa86P5vWTRRVjIwybfrryRnJY/KdwATX4VyldijUHvM=;
        b=GcMOGDBWzvnXWnj/AXKSVO1VsNaxjV9MrsxQfmHvcdXLJsLaQ9gKS2THDg9y1Pg3Jw
         7UCgVL2sx4cQwVeksm0/6iWmIrNrcKwRdINOPVnpVyFZ2tnPbPojoW0mbarlVNolnVc1
         88FVjiGdaco+oeysQ39UzhJYej9QvykqAEfVAw0eqdDR8kLRa3HvP8hYQxCvKrVxrzKy
         mIyFACor+n8H9fNYuxdN9bFLbW2PxgHeYZEk3QfBIqg5R1keYcke0d5+dIhPUtfD8DSE
         dBjLTd7ZLmQPXem8XCmlZwOi/g09UXPj2Uom4IsP5/0gBBsNoo6IzMFknmVLnt2Aw4e9
         eHsA==
X-Gm-Message-State: AOAM533352mMn2oxfi1F8FbEA0QgdE7jv6E6mVEXAuZlVyG6paFevGC+
        4xr9bXwQ3dhOtz105RUGE34=
X-Google-Smtp-Source: ABdhPJxbTX6Fx8R6Mqcg/iY5+M2weGh+9Dw2off2NPnfgAri7DDBzAQaLv78Yxgmf/DaEg4IU6DZrw==
X-Received: by 2002:a63:cc:0:b0:380:afc4:bb07 with SMTP id 195-20020a6300cc000000b00380afc4bb07mr20106740pga.341.1647257575227;
        Mon, 14 Mar 2022 04:32:55 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.118])
        by smtp.gmail.com with ESMTPSA id l2-20020a056a0016c200b004f7e3181a41sm2645197pfc.98.2022.03.14.04.32.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 04:32:54 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org, kuba@kernel.org
Cc:     davem@davemloft.net, rostedt@goodmis.org, mingo@redhat.com,
        yoshfuji@linux-ipv6.org, imagedong@tencent.com,
        edumazet@google.com, kafai@fb.com, talalahmad@google.com,
        keescook@chromium.org, alobakin@pm.me, dongli.zhang@oracle.com,
        pabeni@redhat.com, maze@google.com, aahringo@redhat.com,
        weiwan@google.com, yangbo.lu@nxp.com, fw@strlen.de,
        tglx@linutronix.de, rpalethorpe@suse.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 2/3] net: icmp: add skb drop reasons to ping_queue_rcv_skb()
Date:   Mon, 14 Mar 2022 19:32:24 +0800
Message-Id: <20220314113225.151959-3-imagedong@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314113225.151959-1-imagedong@tencent.com>
References: <20220314113225.151959-1-imagedong@tencent.com>
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

In order to get the reasons of skb drops, replace sock_queue_rcv_skb()
used in ping_queue_rcv_skb() with sock_queue_rcv_skb_reason().
Meanwhile, use kfree_skb_reason() instead of kfree_skb().

As we can see in ping_rcv(), 'skb' will be freed if '-1' is returned
by ping_queue_rcv_skb(). In order to get the drop reason of 'skb',
make ping_queue_rcv_skb() return the drop reason.

As ping_queue_rcv_skb() is used as 'ping_prot.backlog_rcv()', we can't
change its return type. (Seems ping_prot.backlog_rcv() is not used?)
Therefore, make it return 'drop_reason * -1' to keep the origin logic.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 net/ipv4/ping.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 3ee947557b88..cd4eb211431a 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -936,12 +936,13 @@ EXPORT_SYMBOL_GPL(ping_recvmsg);
 
 int ping_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
 {
+	enum skb_drop_reason reason;
 	pr_debug("ping_queue_rcv_skb(sk=%p,sk->num=%d,skb=%p)\n",
 		 inet_sk(sk), inet_sk(sk)->inet_num, skb);
-	if (sock_queue_rcv_skb(sk, skb) < 0) {
-		kfree_skb(skb);
+	if (sock_queue_rcv_skb_reason(sk, skb, &reason) < 0) {
+		kfree_skb_reason(skb, reason);
 		pr_debug("ping_queue_rcv_skb -> failed\n");
-		return -1;
+		return -reason;
 	}
 	return 0;
 }
-- 
2.35.1


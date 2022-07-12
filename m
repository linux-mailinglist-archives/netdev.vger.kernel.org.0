Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34DC35727CC
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 22:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233896AbiGLUxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 16:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233849AbiGLUxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 16:53:13 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1543CDA00;
        Tue, 12 Jul 2022 13:53:12 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id o4so12838546wrh.3;
        Tue, 12 Jul 2022 13:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JiEsoyPR3qDUo4aXLZKMJBh9ZQXVTPlwfAb5ffGVmj0=;
        b=kOIFXsBdRObEqASUMsZzEh/aqoqwqbwCDOMq4rqv3GXJSxLYwgkQuRVixFReggbWWP
         W7wsVjozBM9egJSxeN8TJhWQPbrnjWWSOh04GlSP2Ay62v2qBc6/uVSIiaSaWY+ThvMK
         PpDmYplls0IEY9flosZjKGTz829ZsJs86Zoh8U1kzgohq46fbjiP1IP5/b5M3C/UWl1E
         r0uXA4xUabOQH8R0zXEnlRR37+NAxQN4OlNd7Ciho3eC1JGz6m9Y8q8/lxurekHLwJkU
         A7AZbLFUxbpZh/wcpokeIjuhHdGUv7Ij0CmleYgIZ6y3LkLiXCJz8fgrj9jWFdxeZp5d
         TuLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JiEsoyPR3qDUo4aXLZKMJBh9ZQXVTPlwfAb5ffGVmj0=;
        b=orwbmPSfCbwUtDBciK0+on9LY1eytetwQzymSauFoQ7V8mL7CjCSFtwXKq7axf4r6L
         mw0SVoIxrzeWnhfmhBxWiv9Too5pmqnqbUbvHC5oUOhva+e7FcqHDItrVu6QLGgpySHR
         DhJLHsIB40D+c/VONnEvGqy1fF9YlDzdO4+l/Rf5b0+C+PAcy68FUqUVug9CvJEEsHdS
         SSiq236eh3rnr0nrq4/1S/ykKeemIYHu21oN154ic+g/D+zbx/0EPozrNxOrB/ARzzic
         C4F7mZJo4Y/bzj4ODkbIek2oDmdu1QR1tAhNaR6yfpFdVO8IbOdGakEqsoTcped8SdzG
         C/Zw==
X-Gm-Message-State: AJIora9BCJk2Rs1Rl2+TYLaVnlbuVqYUrKB1HlRI9q1UDpxFAGl8UxSB
        xDX5SvH7aZxg0Yb2yIWyikJwnu/DQIU=
X-Google-Smtp-Source: AGRyM1uBhbY/jrqGtZBYelVX2VgWJoU+7kXWyEfnVRt1KHsCgZ9RpY5dibKUaueTWeOjEyxP0ZTDSg==
X-Received: by 2002:a5d:5c05:0:b0:21d:83b4:d339 with SMTP id cc5-20020a5d5c05000000b0021d83b4d339mr23672288wrb.611.1657659190968;
        Tue, 12 Jul 2022 13:53:10 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id c14-20020a7bc00e000000b003a044fe7fe7sm89833wmb.9.2022.07.12.13.53.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 13:53:10 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v5 03/27] skbuff: don't mix ubuf_info from different sources
Date:   Tue, 12 Jul 2022 21:52:27 +0100
Message-Id: <8fc991e842a43fef95b09f2d387567d06999c11c.1657643355.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1657643355.git.asml.silence@gmail.com>
References: <cover.1657643355.git.asml.silence@gmail.com>
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

We should not append MSG_ZEROCOPY requests to skbuff with non
MSG_ZEROCOPY ubuf_info, they might be not compatible.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/core/skbuff.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 5b3559cb1d82..09f56bfa2771 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1212,6 +1212,10 @@ struct ubuf_info *msg_zerocopy_realloc(struct sock *sk, size_t size,
 		const u32 byte_limit = 1 << 19;		/* limit to a few TSO */
 		u32 bytelen, next;
 
+		/* there might be non MSG_ZEROCOPY users */
+		if (uarg->callback != msg_zerocopy_callback)
+			return NULL;
+
 		/* realloc only when socket is locked (TCP, UDP cork),
 		 * so uarg->len and sk_zckey access is serialized
 		 */
-- 
2.37.0


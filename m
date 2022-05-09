Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60E28520783
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 00:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbiEIW0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 18:26:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231515AbiEIWZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 18:25:55 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C24163F4B
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 15:22:00 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id c9so14464041plh.2
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 15:22:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0lXlqc23Yx9Pf3fkU4RfFaCsBTSFaDKO0o2nPd2QWzw=;
        b=E2FXbNX8HXmH6f3+ZPcrBFXcmMzuQ55O93c3GCyFtryGoSrNZSELOddw6k7vEWV/e9
         NyoQNj0+ijpnZikFgSjcTnZ8zwO6pTbAScDYaW/UcI5EtcfL+jJgEuMf7gPViacfl4dG
         pBr5EzzKhIAaJsAhM9frWGDtR9aL7UqcooXlKpSlTWb5N0a4dntl5lOBigZ6CZLKv9mU
         B46CJzkOu2aqpxdMODkrJ4HoSn0tvGzWNVuftfix/g34vaqp5WI77u1rhr+rgYBGOXR/
         fyeShmdN/MaljQGLeKsFI7UaW3fie5doU7IX3pz9IZpVsMeebLrRJXWCjy5hlc3r9pMy
         v6eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0lXlqc23Yx9Pf3fkU4RfFaCsBTSFaDKO0o2nPd2QWzw=;
        b=7AiFusZycJGx7ub20Ci9Rwk9LZRddGBi2j2O4pYc8cg8y+nsMWfpK+KiQyHEoRj3xo
         VFhyZ8DXoE4gP7xcfalTRrgZFVt1BkHJ9AhiJd8/j50y5udrvJC9aM8HUKk4QVHlMkjN
         rURda1oMaAGr+jCSNz5hIoQ2h0CdnKireRsVDRHXrazkv1qldKbPZMpVjRJIoiq4XWFZ
         j/GzVUIjKJWn5/E+GlCQr1FMHPkmk2FENIG/GojAxpCH9nBnBaAc8Ikp3OU8B1MVGwvV
         gUSVcw8wCoorvN+i2JnJiV6vwSk05l9GSavrYlwVAgY5nq1qDdMMpyDXP0NnbFPaUS5e
         eDlw==
X-Gm-Message-State: AOAM5339kUZjSoYtavdILIoDr+hnSTFNNZ62RBSNUm6Lbj28wVRevRtU
        E4ncAJEvZ61wAQIOVHEQnHY=
X-Google-Smtp-Source: ABdhPJxbyTcCuikIqneC1Wjeqec5/r+eURwuwqGA6oUZRHsTI4ZKsR4rb8ey3tSotTc0nwWilTFZ0A==
X-Received: by 2002:a17:90b:1d83:b0:1dc:4362:61bd with SMTP id pf3-20020a17090b1d8300b001dc436261bdmr28210859pjb.126.1652134919892;
        Mon, 09 May 2022 15:21:59 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5d30:4e79:203f:a909])
        by smtp.gmail.com with ESMTPSA id v11-20020a170902f0cb00b0015e8d4eb1efsm395823pla.57.2022.05.09.15.21.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 15:21:59 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v5 net-next 03/13] net: limit GSO_MAX_SIZE to 524280 bytes
Date:   Mon,  9 May 2022 15:21:39 -0700
Message-Id: <20220509222149.1763877-4-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
In-Reply-To: <20220509222149.1763877-1-eric.dumazet@gmail.com>
References: <20220509222149.1763877-1-eric.dumazet@gmail.com>
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

From: Eric Dumazet <edumazet@google.com>

Make sure we will not overflow shinfo->gso_segs

Minimal TCP MSS size is 8 bytes, and shinfo->gso_segs
is a 16bit field.

TCP_MIN_GSO_SIZE is currently defined in include/net/tcp.h,
it seems cleaner to not bring tcp details into include/linux/netdevice.h

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/netdevice.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 9a34cc45b20a4465a9e1532c39f410b26604144f..2ef9254a9d3a57403f510d32194d8be6730b1645 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2263,12 +2263,17 @@ struct net_device {
 
 	/* for setting kernel sock attribute on TCP connection setup */
 #define GSO_LEGACY_MAX_SIZE	65536u
-#define GSO_MAX_SIZE		UINT_MAX
+#define GSO_MAX_SEGS		65535u
+
+/* TCP minimal MSS is 8 (TCP_MIN_GSO_SIZE),
+ * and shinfo->gso_segs is a 16bit field.
+ */
+#define GSO_MAX_SIZE		(8 * GSO_MAX_SEGS)
+
 	unsigned int		gso_max_size;
 #define TSO_LEGACY_MAX_SIZE	65536
 #define TSO_MAX_SIZE		UINT_MAX
 	unsigned int		tso_max_size;
-#define GSO_MAX_SEGS		65535
 	u16			gso_max_segs;
 #define TSO_MAX_SEGS		U16_MAX
 	u16			tso_max_segs;
-- 
2.36.0.512.ge40c2bad7a-goog


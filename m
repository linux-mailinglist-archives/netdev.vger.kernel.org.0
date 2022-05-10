Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12C58520C15
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 05:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235460AbiEJDgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 23:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233562AbiEJDgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 23:36:25 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 612CE179096
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 20:32:28 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id c11so15612853plg.13
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 20:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xzXs/zuHTV23h7UsS5AYqZN2KZ1Khfn0fAekTFBxMZ4=;
        b=c7n40i8M5WH/lLlh9KUi+JHDJOAPqZAXB17zwLdGDTfyNOxgoRUGy8h2sQUl3oDfxZ
         MatChBh5pJXhMAy2nsUjho6LvwTY9UsF4700U4ATkRGtwSqrlkysBmkCqWOa/td8cyoz
         VZhMGCNjfpH3DXW7qMU1AvX0nc6xvThQ2rZHubP6kO5RZyF6uu2NnSd5YmY6d0kuGR0v
         zKYI9fmP8SoqOfRuPQfr+DuBK190JgP/Ay+Y24uDaxnGI0nEdAauhrJJmczPY8fJNpWW
         VxCFEVWmUz9JdLlEHF8anCLsLb0Ce+A6trFtIkSOL8IoQv1m5ks0qSIB2kCYeMGrZxWs
         2FXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xzXs/zuHTV23h7UsS5AYqZN2KZ1Khfn0fAekTFBxMZ4=;
        b=2QnPIaTmcrvEp7YySzWyp0QodI05FPbouVzbt8g1IBJVxWEQTYyH6twbc5VUxigPhL
         qqidPllF129zACUdBZwlM+XSKCapp2h003rJ9XrCpPxVNQKxFGC5Bkl/8fL2hYY9FKI2
         pQml+USDwunw1qsm6ukkzTVBxcoL8XXkp0fEcIsbI6Mijz53zRfKBqqmQ/1vk0wKcV5o
         7r90S9aathWYCvsAlVb1s7JpF7V9pGEyPeB3BmH/2chA0Tuo4lEYWeOmmDJgjxD+y8Th
         uQWQWOzW+9oqf8wf1dEhdeLT9qEBxxK9M+zm000fxwHfGpvyE+13udPq7pFll4gq/LKh
         S3Kw==
X-Gm-Message-State: AOAM532xagXueAZ+YIXNoU3Bp0TGaWK1CKtaCRIdGF9Ra1crc4O2AZLI
        9Dp94Q06jmGg1zcGRFWnjT03HMN2/a8=
X-Google-Smtp-Source: ABdhPJyFbiJynlu3iQ2D4Ed9vJXgtcEk1eIX1QZcfUc2nqvjyVBwO81Wk8p4P4TjNbo/Cm2A4RKj5w==
X-Received: by 2002:a17:902:e393:b0:15c:f1c1:c527 with SMTP id g19-20020a170902e39300b0015cf1c1c527mr19033228ple.22.1652153547965;
        Mon, 09 May 2022 20:32:27 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5d30:4e79:203f:a909])
        by smtp.gmail.com with ESMTPSA id me16-20020a17090b17d000b001d77f392280sm538185pjb.30.2022.05.09.20.32.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 20:32:27 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v6 net-next 03/13] net: limit GSO_MAX_SIZE to 524280 bytes
Date:   Mon,  9 May 2022 20:32:09 -0700
Message-Id: <20220510033219.2639364-4-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
In-Reply-To: <20220510033219.2639364-1-eric.dumazet@gmail.com>
References: <20220510033219.2639364-1-eric.dumazet@gmail.com>
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
 include/linux/netdevice.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 6150e3a7ce9dc743129d3f4f240329dd688b49a4..673c444aae874428b117df45dffcaf702ac72a47 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2262,14 +2262,17 @@ struct net_device {
 	const struct rtnl_link_ops *rtnl_link_ops;
 
 	/* for setting kernel sock attribute on TCP connection setup */
+#define GSO_MAX_SEGS		65535u
 #define GSO_LEGACY_MAX_SIZE	65536u
-#define GSO_MAX_SIZE		UINT_MAX
+/* TCP minimal MSS is 8 (TCP_MIN_GSO_SIZE),
+ * and shinfo->gso_segs is a 16bit field.
+ */
+#define GSO_MAX_SIZE		(8 * GSO_MAX_SEGS)
 
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


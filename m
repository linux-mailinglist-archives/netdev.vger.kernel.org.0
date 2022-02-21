Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 924594BD5AF
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 07:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344794AbiBUFzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 00:55:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344798AbiBUFzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 00:55:47 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08CC251336
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 21:55:25 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id ay3so3194295plb.1
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 21:55:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8B1jWTjFa77XeHMV6CAXE4AxnHKSH48IdIzr9OEnlRw=;
        b=bpEBBxoodkMNNjr7olPoTMMVEzjgSqHGQyMqRYbh1Nk2xFKnyJig6o3bkQGxd667T2
         sunZ03ZX7WocUyG+8/no8LnqBdi9/DAqad61RQvjwcK29OooFkOlnoo4HOko1yVYowFP
         40q0//HvtLCDBr50EG1NMsMyptXFWTRMa6UKFM1x13jXT8u5O86k1CdruvWsfDXw/8mt
         tZXc9xoOAordacfCEL7XIC9SYiGfSbDnW2wzr9hDHWjFW+7uTQZjCknbBf9c1j2e5fog
         Rb4wkl6lJxIon6nps2Ad0kklw4hlAJjyhS4BQ9TXDTr9fm/ZPGs4OL6coCVTFd4rv5Jy
         EYBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8B1jWTjFa77XeHMV6CAXE4AxnHKSH48IdIzr9OEnlRw=;
        b=IGtueyOwzK8Zbxle7Kg82443eYtUOOaz/ePS4w5eSibup2VyUJd1QoAG8ZX+KCrOep
         PfLyyGWNpdYtTTAJIaH8iSzyO4maJg33nZVxMZidygQQMCdn+6qBaSQ/04G2V3F0KDy3
         z7gywNbXh+0ZreagSy6rXgFTkyXKdUFUYfsfKXOuMPH4DUUSS/NMADKmH9tqxOqBtj9P
         cXEQdsbkkyZC5Rg5Fsi/e9zOOJzAmBRRAE4+kWKQv8+MDwYcezK0EZ2CvV3AjHEv+t6Z
         wT1bKgg9+29E8r+qNBg4SmNEHA7LxbpDZshqL2YEmd43iEq3Fk9hkQi1DikTxwdYEZRK
         918w==
X-Gm-Message-State: AOAM531ulmiaGJFnQW0RejsREutt5wvzkzFk5Ug7ZzyRWewBgovgPMgG
        FidGEgy8GZsS8dGJmu3KiJ47f13arcE=
X-Google-Smtp-Source: ABdhPJx4SRP/9Lawlm9lV8f2r/JwHrX6blE1fUUgHNNzH7+j2i92j8fkXghkc62h/ineowPM1qbcpw==
X-Received: by 2002:a17:903:3002:b0:14f:cd29:409 with SMTP id o2-20020a170903300200b0014fcd290409mr766561pla.45.1645422924117;
        Sun, 20 Feb 2022 21:55:24 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s15sm17359767pgn.30.2022.02.20.21.55.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Feb 2022 21:55:23 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 net-next 3/5] bonding: add extra field for bond_opt_value
Date:   Mon, 21 Feb 2022 13:54:55 +0800
Message-Id: <20220221055458.18790-4-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220221055458.18790-1-liuhangbin@gmail.com>
References: <20220221055458.18790-1-liuhangbin@gmail.com>
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

Adding an extra storage field for bond_opt_value so we can set large
bytes of data for bonding options in future, e.g. IPv6 address.

Define a new call bond_opt_initextra(). Also change the checking order of
__bond_opt_init() and check values first.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 include/net/bond_options.h | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/include/net/bond_options.h b/include/net/bond_options.h
index dd75c071f67e..286b29c6c451 100644
--- a/include/net/bond_options.h
+++ b/include/net/bond_options.h
@@ -71,14 +71,18 @@ enum {
 
 /* This structure is used for storing option values and for passing option
  * values when changing an option. The logic when used as an arg is as follows:
- * - if string != NULL -> parse it, if the opt is RAW type then return it, else
- *   return the parse result
- * - if string == NULL -> parse value
+ * - if value != ULLONG_MAX -> parse value
+ * - if string != NULL -> parse string
+ * - if the opt is RAW data and length less than maxlen,
+ *   copy the data to extra storage
  */
+
+#define BOND_OPT_EXTRA_MAXLEN 16
 struct bond_opt_value {
 	char *string;
 	u64 value;
 	u32 flags;
+	char extra[BOND_OPT_EXTRA_MAXLEN];
 };
 
 struct bonding;
@@ -118,17 +122,22 @@ const struct bond_opt_value *bond_opt_get_val(unsigned int option, u64 val);
  * When value is ULLONG_MAX then string will be used.
  */
 static inline void __bond_opt_init(struct bond_opt_value *optval,
-				   char *string, u64 value)
+				   char *string, u64 value,
+				   void *extra, size_t extra_len)
 {
 	memset(optval, 0, sizeof(*optval));
 	optval->value = ULLONG_MAX;
-	if (value == ULLONG_MAX)
-		optval->string = string;
-	else
+	if (value != ULLONG_MAX)
 		optval->value = value;
+	else if (string)
+		optval->string = string;
+	else if (extra_len <= BOND_OPT_EXTRA_MAXLEN)
+		memcpy(optval->extra, extra, extra_len);
 }
-#define bond_opt_initval(optval, value) __bond_opt_init(optval, NULL, value)
-#define bond_opt_initstr(optval, str) __bond_opt_init(optval, str, ULLONG_MAX)
+#define bond_opt_initval(optval, value) __bond_opt_init(optval, NULL, value, NULL, 0)
+#define bond_opt_initstr(optval, str) __bond_opt_init(optval, str, ULLONG_MAX, NULL, 0)
+#define bond_opt_initextra(optval, extra, extra_len) \
+	__bond_opt_init(optval, NULL, ULLONG_MAX, extra, extra_len)
 
 void bond_option_arp_ip_targets_clear(struct bonding *bond);
 
-- 
2.31.1


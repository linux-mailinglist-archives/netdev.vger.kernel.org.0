Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7E84B829F
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 09:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbiBPIJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 03:09:18 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:47182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231365AbiBPIJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 03:09:18 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ACCDA650F
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 00:09:05 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id 132so1484712pga.5
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 00:09:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8B1jWTjFa77XeHMV6CAXE4AxnHKSH48IdIzr9OEnlRw=;
        b=nbr8U8CBkJZJUqFy2y9Azf62JbYY8cOfTSwOBCjpAmhrwbmhLKp7s3V73bdga2qN0n
         q59MbFnzuXumCsADyjzkgX+dBcDDdwTky3qINXT+rRZZ+RbNytQKTKT6VK8C6Bxw1e0f
         VPUX4HA5kEEE2NhFw9O6jVOvDZyCjqmlNegpTJx86++08Q99J8Y9NgFRtl4N7YWpJTJo
         e8JcAyNG1lHpafazZsfZconPGsuiTQYZsh5Vsu9lpvgiWWyw/c15mMDuF1A681jXiaLH
         /cQPoveSaE4WyEYNg0TrIN55NDnWWEjEzLh/fUq++KHzR9hu4OOQcT0DRIDCqSu8qVEP
         MWeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8B1jWTjFa77XeHMV6CAXE4AxnHKSH48IdIzr9OEnlRw=;
        b=4rzAa2edD+e4jtrc/Y1wDHpm2TVZSvnzrLLUV9S//ZBL/RJdZdQlhAVosFM/bxaEEk
         rgx4PYMfq7BpeUgTY94frmdPu/lcKkNleqIguMOt66WVJOaQ3t3bLMczNhEaWt1+Dj8d
         N2lmFFdIYsphtZGY7hmKrg3lhuD4AGHijrbokCEV58Ke/qNCmK5Z6Y5BtgbQr0GkosBV
         tOgwizHEhgrCnfzIJkexnC0Zh3BXOZHB8qNbWvUW98p8z4LTW6oYvDZnAeivxwTnFS/H
         /XqyBtdPTD7Hsgb7qUdvC/bEnEUqOOdMuNcXntCOVgHFP0deMvY8BcUlzFRGTUmeTtiu
         0Lmw==
X-Gm-Message-State: AOAM532vfyUVUWcn13pshp/Y0jN5PHCU2eSJv7qLP0A3XY8trVIYfLCs
        licf+803tvnshZx/OPDj2YhbYQxxjkY=
X-Google-Smtp-Source: ABdhPJx2/4M4QuRJSf2AA4vtpPtOcDrV9qhWLXX1ps8GjAX9HfQbOs3Xyl7718iMZtgV8tZOcaeoaQ==
X-Received: by 2002:a63:824a:0:b0:372:be18:dafa with SMTP id w71-20020a63824a000000b00372be18dafamr1272419pgd.581.1644998944876;
        Wed, 16 Feb 2022 00:09:04 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s15sm4635662pgn.30.2022.02.16.00.09.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 00:09:04 -0800 (PST)
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
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net-next 3/5] bonding: add extra field for bond_opt_value
Date:   Wed, 16 Feb 2022 16:08:36 +0800
Message-Id: <20220216080838.158054-4-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220216080838.158054-1-liuhangbin@gmail.com>
References: <20220216080838.158054-1-liuhangbin@gmail.com>
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


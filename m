Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62E534B3435
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 11:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233399AbiBLK3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Feb 2022 05:29:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbiBLK3s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Feb 2022 05:29:48 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15B5022B15;
        Sat, 12 Feb 2022 02:29:45 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id k41so5694514wms.0;
        Sat, 12 Feb 2022 02:29:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xqJJY8/5GMDNbZo3wGlH9hcKpw7Tt831PGQrbENIu9g=;
        b=GAU0pitkgryScL3ZI6Fn+ifObmJTCUv/3VfAEokYXhFOHhXZzmIZNPpsOdhx0bHVp2
         wGDEtWpSJwg+8FvwJd3d8n2B1Yhp045RFIkMqYrS9AU45RpMcq+cLpQsELoLgqNnjIyy
         0o6m9X1QI9g607DzkKPYO9WJ6Hcx0Z16UEKtzMshuOHs84ooTL4Bygn+EdTpfBchFAnY
         aUWUbkYEk9ob5S5uG+cD0E1BU2DBBNnxoGQifctWxmdLR7FmPN1Vp/xsfBuqdi1+SUGD
         o8YXyfzp9JI9BYv0w62laq+whoAf4TStHDEd1cFTsLPWaon1aU6NB89sgzywS2SPeMq9
         9EQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xqJJY8/5GMDNbZo3wGlH9hcKpw7Tt831PGQrbENIu9g=;
        b=50IaJvCUpgafg5UHs1UhDE8pKvOEG81t4sowXkEGpF+DKafcacZxxqZuGQm9ZohJ5+
         SjgX297r7iWN+b91cWxYS8CJ1oKs236/sVeG0hYj/Par67oZIz+f08AeU80smu7rvAQp
         n4e7gAz4B0TgJb4ucoy2M4Qi6cpfikLHmvXw63UmBuRrVlWp5+9rJDXOWm57g/FNkMPO
         P304EUnnAvnb5hD0WVZB2tuS36gqz0bpLjfehBSHllNFaY/XOupTUr4AQY/oN0e6IeK3
         SSWI3TAbszIVt9eixIuFpHTnx5gApGTCqGnIIMz0d8b/hNuu0tdvhqDJYqVzODRU0O/Z
         34Ew==
X-Gm-Message-State: AOAM530lhUTjjmF4IBMRpobBH0/z/GJVZuDFJodl0TZenF3lZz6as5UT
        YSaZmqpg2nhr2UU5kve+8Hzzw4uQNpS3bQ==
X-Google-Smtp-Source: ABdhPJzbLZMn8CM8qV69WdrF8UgeFGL9v83h8zii/cf51D0s5xXu535N4qEGgQva5nZ839RBrQ5c2w==
X-Received: by 2002:a05:600c:220e:: with SMTP id z14mr3703502wml.52.1644661783562;
        Sat, 12 Feb 2022 02:29:43 -0800 (PST)
Received: from LAPTOP-3IBRGB1C.localdomain ([185.175.34.247])
        by smtp.googlemail.com with ESMTPSA id b2sm26180974wri.88.2022.02.12.02.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Feb 2022 02:29:43 -0800 (PST)
From:   Alex Maydanik <alexander.maydanik@gmail.com>
Cc:     alexander.maydanik@gmail.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] net: fix documentation for kernel_getsockname
Date:   Sat, 12 Feb 2022 12:29:27 +0200
Message-Id: <20220212102927.25436-1-alexander.maydanik@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes return value documentation of kernel_getsockname()
and kernel_getpeername() functions.

The previous documentation wrongly specified that the return
value is 0 in case of success, however sock->ops->getname returns
the length of the address in bytes in case of success.

Signed-off-by: Alex Maydanik <alexander.maydanik@gmail.com>
---
 net/socket.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index 50cf75730fd7..982eecad464c 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -3448,7 +3448,7 @@ EXPORT_SYMBOL(kernel_connect);
  *	@addr: address holder
  *
  * 	Fills the @addr pointer with the address which the socket is bound.
- *	Returns 0 or an error code.
+ *	Returns the length of the address in bytes or an error code.
  */
 
 int kernel_getsockname(struct socket *sock, struct sockaddr *addr)
@@ -3463,7 +3463,7 @@ EXPORT_SYMBOL(kernel_getsockname);
  *	@addr: address holder
  *
  * 	Fills the @addr pointer with the address which the socket is connected.
- *	Returns 0 or an error code.
+ *	Returns the length of the address in bytes or an error code.
  */
 
 int kernel_getpeername(struct socket *sock, struct sockaddr *addr)
-- 
2.25.1


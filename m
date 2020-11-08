Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E93F42AA8AE
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 02:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728388AbgKHBG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 20:06:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgKHBG3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 20:06:29 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23538C0613CF;
        Sat,  7 Nov 2020 17:06:29 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id r9so1326727pjl.5;
        Sat, 07 Nov 2020 17:06:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4p7MLHdjYoSQcOW0ePKkC140sS/G2OV9q0zQzuCRpho=;
        b=Yvxnwp8jgOYgQNtNnwQ5KXkLij+1twQ0UvY64r7AJYtJ7f2ZSaMsA0DYaADAhlRVLm
         e8VVjxFOPwfIB3EUjJvwPCg1CNvmupli0qJA5rhxenRx5H/KjRCrfspBwL8Nws6ra03P
         O16ma3654RdEoC0Ex+0EvlB2blp2OISYqidSGvrZ7V6H2BcTgOMomtNUHfzrBKio+C5B
         HVvrPZVGTkWFYnDGv21V47MONwUkzCgfj1nZbHRVGXQRg11ofcycooZonv1+a3FeMMcG
         2Uysyj0qrqqdHitMMobmFOj/AAY4oku1c1VlK15tIZnkSNWkQxtG7lPWr7vGwggjyP/6
         Jhyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4p7MLHdjYoSQcOW0ePKkC140sS/G2OV9q0zQzuCRpho=;
        b=GsnaPDdU59cP61g7eVVzwwJM0VM1SJxxKPG7td/QuugnbyJ+72T8A0K40d/Tq0Zri7
         5+QPoqT3ousjGhvNmZ2W1hiiKZEBesj1X7B9/HjdRvu3KfwfByOh19vusVH6bEJwgDJ3
         DyFWGKuyeG3pIE2qgJnJtrFjI8rOAbw7ll+6vwCMy+FnF7FZInE5pUJOba30pWUEG90K
         a7j0TuvD95nRwOWgO1rVL9MGOjXKbv/1b7dnqCc1JiiRnDZwrzgPeYg7+gW8ZuY2SW2s
         +LQHB4g1YNoSAQ6hA43kET3M9NT4lv+TgGis2v/aRA3bbPneWzHb5V3AveWenj1suRs1
         hnrA==
X-Gm-Message-State: AOAM532hiVMgEJQKpIL6xTrd1/R1HvS667FxYV2qCqJfOU74x9ggx/FS
        aAGGJCGU43/M2rxKUYaI6kQxPiyokFUosQ==
X-Google-Smtp-Source: ABdhPJwk878CEeeSPaDWXZVRrVCdl9xxiEcnYTeSp4WSiFXXtViCdwnIg6tzwFxOPDjxNr6CZ1XE7g==
X-Received: by 2002:a17:902:164:b029:d6:a42a:a952 with SMTP id 91-20020a1709020164b02900d6a42aa952mr7196991plb.44.1604797587800;
        Sat, 07 Nov 2020 17:06:27 -0800 (PST)
Received: from localhost.localdomain ([154.93.3.113])
        by smtp.gmail.com with ESMTPSA id 16sm6725648pfp.163.2020.11.07.17.06.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 17:06:27 -0800 (PST)
From:   Menglong Dong <menglong8.dong@gmail.com>
X-Google-Original-From: Menglong Dong <dong.menglong@zte.com.cn>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Menglong Dong <dong.menglong@zte.com.cn>
Subject: [PATCH v2] net: ipv4: remove redundant initialization in inet_rtm_deladdr
Date:   Sun,  8 Nov 2020 09:05:41 +0800
Message-Id: <20201108010541.12432-1-dong.menglong@zte.com.cn>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The initialization for 'err' with '-EINVAL' is redundant and
can be removed, as it is updated soon.

Changes since v1:
- Remove redundant empty line

Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
---
 net/ipv4/devinet.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 123a6d39438f..43e04382c593 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -650,8 +650,7 @@ static int inet_rtm_deladdr(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct in_device *in_dev;
 	struct ifaddrmsg *ifm;
 	struct in_ifaddr *ifa;
-
-	int err = -EINVAL;
+	int err;
 
 	ASSERT_RTNL();
 
-- 
2.29.2


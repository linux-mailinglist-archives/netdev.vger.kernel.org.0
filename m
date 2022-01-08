Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59E254885F1
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 21:47:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232833AbiAHUq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 15:46:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232828AbiAHUqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 15:46:55 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE767C06173F
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 12:46:54 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id c14-20020a17090a674e00b001b31e16749cso15511002pjm.4
        for <netdev@vger.kernel.org>; Sat, 08 Jan 2022 12:46:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XNRt6/aITGiiV0hFDQpp/ZDiBu3MId5tidREj5NDK10=;
        b=u+M7onowdXG0STrbSbB8ysKzsH67HxEGDkBe5jXLr3U0oI81B6aEE5Dl46zA8Q7r6v
         Y3pY8KjjA4KWV1avYrXR+tLbo6gJv3zN+q2NaJGBwtfx7JenfOrAQswxZW8b2GAmmu+F
         bVgFNeUeXuakKrUnsnVlxmIkCfFhRd4jCOF6GSQTsSpkcoFvkVBsgdGH9I1FXvTX2MmM
         3HDUqViGzuk59W1+tgiBIJAZ+bnzk76SpSZd2tEhcnxXbruKz3qViwgxiJFB+dDQ4i08
         p9PkUiJMcWh4EYblm6JsPfBD3YQ60/2J0xWq53rBXf0MIqhh4E46Xrp4/knl89vLmfEP
         OepA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XNRt6/aITGiiV0hFDQpp/ZDiBu3MId5tidREj5NDK10=;
        b=k3/HDldizhkHz+NlDeVCz4A2tfghmXm92iMBtPxHUHp65QcMBzIhgNXW5DtzOGEEXS
         eUOEKta+jd0lzz/L7iY3t02w8LhobwvBRLJ6sShPyUptQ/OKsu5ZDTBf/Qd5EDWskbru
         DbeHtk5T/Z8IIk9W/cuV/pKGg+if/srMRz19cPHPNTS/d0qAerwDAxeeoy46hWQKv6q1
         NUWcb+0gYJ2nXWwH6nQ1U7RHXtPLo08/s4DsE3bVtwGOnii2stf7KaO1oSm1trN6gwoe
         ZFzmhaUKDeZQkLWRTSXAQswjYvpO6ifK6r/RNTiy8GJN+wslfsCv5yuH6hepCdHPRRyk
         yEng==
X-Gm-Message-State: AOAM532nb9uAVB/DZCyo5evef7eFGO3lMeEQUkASw2ZYu6W3DulCZYPu
        3z2fBmhNXpbttCnsEigk4AUjk6gT5ImF5Q==
X-Google-Smtp-Source: ABdhPJzGT6M6ESUmn3e9MvM4R7yDXn5QkJevozGVV6KEF+oMpEsQ5NPgKorQqP39rT6dXSfUOZZI2A==
X-Received: by 2002:a17:90a:1108:: with SMTP id d8mr21567035pja.175.1641674814245;
        Sat, 08 Jan 2022 12:46:54 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id u71sm2129393pgd.68.2022.01.08.12.46.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Jan 2022 12:46:53 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
X-Google-Original-From: Stephen Hemminger <sthemmin@microsoft.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next 02/11] utils: add format attribute
Date:   Sat,  8 Jan 2022 12:46:41 -0800
Message-Id: <20220108204650.36185-3-sthemmin@microsoft.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220108204650.36185-1-sthemmin@microsoft.com>
References: <20220108204650.36185-1-sthemmin@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Hemminger <stephen@networkplumber.org>

One more format attribute needed to resolve clang warnings.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 include/utils.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/utils.h b/include/utils.h
index b6c468e9cc86..d644202cc529 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -261,7 +261,9 @@ int print_timestamp(FILE *fp);
 void print_nlmsg_timestamp(FILE *fp, const struct nlmsghdr *n);
 
 unsigned int print_name_and_link(const char *fmt,
-				 const char *name, struct rtattr *tb[]);
+				 const char *name, struct rtattr *tb[])
+	__attribute__((format(printf, 1, 0)));
+
 
 #define BIT(nr)                 (UINT64_C(1) << (nr))
 
-- 
2.30.2


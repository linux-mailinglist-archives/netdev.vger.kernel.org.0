Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDD7D4955D1
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 22:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377769AbiATVMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 16:12:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233724AbiATVL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 16:11:59 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56BFEC061574
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 13:11:59 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id f13so6332826plg.0
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 13:11:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ORemWkIgIhYpjv2L/896OhU0cTQPr2PhxjAVl6VzpJo=;
        b=vcowV/vGulYppKQ8y6QYNc/bHaMrTFffWbRhGkK0VE+yudP+KZqnL2aopL3Tz7gu1J
         fr1BNPWtENSNUIpmEbDiU3zfhnsTbXx1AabbxTRJGaiQ85ZNzceVwNTTWUoaxMo5pxyo
         7Y+dQ5UtfyaWmN4ByKiRtr7Q6Svs8UYAKI60/x//m0ZlmPVg4umdrKT0vBdl+w9jIRFj
         024utsuWGYRvnHaxmaUYI5rQGEEHDLwIcu0XMYJfsw67j3HUoWXdCenhOvhPCeaQqlkM
         s/30ycQ/zVMq6KJxnA8lGid7TjJfALoaE7wuAxFSI6tl5HQdEhsEok4G+WnOaIeq6W11
         95Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ORemWkIgIhYpjv2L/896OhU0cTQPr2PhxjAVl6VzpJo=;
        b=cpdrXbE0Jh8FctC7KytjKa9vv2/9sTS9uZpL+GmrCySjcBE+5R43QrRn0AUwqXfPKs
         GWv7ZMoSN90DUEnlQG/3K6xvV9eB5ViBQy7eoCaJdBEQdRYv4N9bVilBVtUYr0yUFQqh
         p9CNjPCtjcoE1+q534pyB82Qgj4npJ/lIjDPBJ9wi9CqgjDZ0PY4AVihDR+CoKsigQfz
         DAYLNTHXmkx51xZ3D48nE099ij97+gteVnZdnkh+3JsXvTqgQOOAgxs8AG5rOBxXbfyb
         YOvo4FYRT444wEEor45dTAGiKd9BO8nJh+/LPIwEyMAcxj/XFy9wKDqzKOc7UPTlXIVO
         IMAQ==
X-Gm-Message-State: AOAM533GIoS7WkpShoIDcAFwS4PF6lSbC8H6xVj7MC+cWTSzj9vAGs09
        ocFya0Ws4JwlUMWg7avTEHzhGeJ5vTMLgQ==
X-Google-Smtp-Source: ABdhPJyJ55gOzAs5TzjW++ps+TG93QRInyR6hJdlZG4PM7uyO4EFCE9gnbW3RcwcIxi0IXBWYqTDyQ==
X-Received: by 2002:a17:902:7fc8:b0:14a:e403:2f18 with SMTP id t8-20020a1709027fc800b0014ae4032f18mr831639plb.45.1642713118512;
        Thu, 20 Jan 2022 13:11:58 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id rj9sm3357187pjb.49.2022.01.20.13.11.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 13:11:57 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v4 iproute2-next 02/11] utils: add format attribute
Date:   Thu, 20 Jan 2022 13:11:44 -0800
Message-Id: <20220120211153.189476-3-stephen@networkplumber.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220120211153.189476-1-stephen@networkplumber.org>
References: <20220120211153.189476-1-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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


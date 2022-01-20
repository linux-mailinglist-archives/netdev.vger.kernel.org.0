Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4244F4955D7
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 22:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377783AbiATVMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 16:12:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377777AbiATVMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 16:12:06 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A8BCC061574
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 13:12:05 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id e9so6375585pgb.3
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 13:12:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=74kcV1kq3XqBCswjyh0NmJxjkLOaCkow0LnYZQJp7Ng=;
        b=EJA0z/Yx1G2LbG0RG6Q/M1LTJksD2bgyhAPQS0FwKD0RyfG+faq+r9qM6ODPJitX+R
         GO6DSwC6s3T59XpkkIPZdTSXfIx5u3jZwhPcs3+C7GxtxN90vnOmCmeWOXwL7acZz8P2
         gRt3KAU8cFJQCDcH8UHTh03KDUlGoowe/njzVMEUbV0GQsv615cxSEacX2PVZNSkWae2
         e/aHr6HSQrt1N07lSgHUooNW7L/IKzWqAbShh5LtTgQwpMiaU0ReljQ/ojbbeTjTV3AE
         o+pct9E6XDrzmoxCDPq8U0HGtwRJ3y5tdcY8XgNLc7yrtjUjVMjBQBwkcp6vb/2X0SVI
         HP8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=74kcV1kq3XqBCswjyh0NmJxjkLOaCkow0LnYZQJp7Ng=;
        b=hYdkV3KkBK3/KDiIV/GYrG8NVwd+005PsV48dl0a6WY0nDNloEiySa2HlqUjnKthp5
         v3zM0Mr5pZwVraYTbYlGu8EVvhTYuB5u0dwk4IbsdPS8t68GTng2y8VZWrqkPU1FWmEd
         1w87d1l4CaRdvVTr57pDTt8lY4ZACuDKKVB9jAisMh1suPs1gONI5N01i1qblM+9KTin
         4hL4HCdbakdeOfp5HDm+j29fuudGfqgnG4v3etjgTUy8GJOdhccHYB04BVSUwrMS2Zst
         h7ykequ/xMfTKDsEGyYkttVDv6TShrRRjT9KF2yQGlBoV4l/KUyBwrj+frx2VVxtNJXs
         8upQ==
X-Gm-Message-State: AOAM531+RGTsV1yVMr96jpZ28v0Ki9YxFU3z6HPR+9l4c1EDhGVOLjWQ
        QwoHnYinwZfgWWahEgj7M0yn0iFksQap/w==
X-Google-Smtp-Source: ABdhPJx6NUpKxTH/hUNJrDsky20WeXJa+G7C5lZPRf4XXr5zSkj68J1RvnyR90CVoG2Af409kTxFzw==
X-Received: by 2002:aa7:8043:0:b0:4bc:1e18:466e with SMTP id y3-20020aa78043000000b004bc1e18466emr748291pfm.49.1642713124639;
        Thu, 20 Jan 2022 13:12:04 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id rj9sm3357187pjb.49.2022.01.20.13.12.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 13:12:04 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v4 iproute2-next 08/11] tipc: fix clang warning about empty format string
Date:   Thu, 20 Jan 2022 13:11:50 -0800
Message-Id: <20220120211153.189476-9-stephen@networkplumber.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220120211153.189476-1-stephen@networkplumber.org>
References: <20220120211153.189476-1-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When calling json_print with json only use a NULL instead of
empty string.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 tipc/link.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tipc/link.c b/tipc/link.c
index 9994ada2a367..53f49c8937db 100644
--- a/tipc/link.c
+++ b/tipc/link.c
@@ -332,7 +332,7 @@ static int _show_link_stat(const char *name, struct nlattr *attrs[],
 	open_json_object(NULL);
 
 	print_string(PRINT_ANY, "link", "Link <%s>\n", name);
-	print_string(PRINT_JSON, "state", "", NULL);
+	print_string(PRINT_JSON, "state", NULL, NULL);
 	open_json_array(PRINT_JSON, NULL);
 	if (attrs[TIPC_NLA_LINK_ACTIVE])
 		print_string(PRINT_ANY, NULL, "  %s", "ACTIVE");
-- 
2.30.2


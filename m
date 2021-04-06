Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3CD135592C
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 18:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346415AbhDFQ2U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 12:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244099AbhDFQ2T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 12:28:19 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02884C06174A
        for <netdev@vger.kernel.org>; Tue,  6 Apr 2021 09:28:11 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id b17so7096102pgh.7
        for <netdev@vger.kernel.org>; Tue, 06 Apr 2021 09:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f0Ztp1qxg3Yhuq9120+tTNYzczpHet72VMErNGrN01c=;
        b=f+sGEDwoGjgEEdDZc9wZhlqcuWIC05/w6ilO3/V6+57SuQLR4fBiXTqNzV1PLwPPT/
         ddBz7xDX8Doa8VFaYbrQmrqzzZThVBbpaMjT6gGZHh/Qd3Y/TQzk0CGY0v4tUbyWGBoo
         1nyMZc+s1Zj+jc7jXQ9BYvFAqnmIQsBVJ7eiDXOZqwDkbms9AIZ4pHVrARoLjFlpymE/
         tHzhWqI2A8uEOaLSPpoR30YSSqrtpJW/Ck3/5ZbrvmQslrVTy9ArxzhE6qUEQrdS6oot
         Xn/VjK/dUlklClnk73fYKvVRGAqLK4UhZtTOz5UXV48oQMksNO/CFZo8er1g+Zzyqt76
         e64g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f0Ztp1qxg3Yhuq9120+tTNYzczpHet72VMErNGrN01c=;
        b=E5GaZOHDFZsjg5NARpzhuBB3c/yQ7Pb4EZVsjU0cnR2zgxWvqYGBQVRxDw7OeZldOx
         OzbqdmOkPCEj0XxKvKkwkJDccpHWVOoYBgZCWsMP1vxTZiLUzI9n+ylMgBqFrMxY1HLy
         jsctGJivyVeTl0Skysl+YbLydkqmQrHKC7b0iSiXdeTeVfYlaUVl+0Uq2LeQ/v7W5+iE
         F0E0OdcNz6VKM8vtxbTjmin4A1jm3OfD7TDTu8b6OBH0oisnKVoDJvQXflfbFTMpQqCO
         YPNH9QAiGMN1uvBoqRlRGNS1k9Hfel/IKFeLgLvdVF7vZYuVJEPUl/kT0/tuwb5yobkw
         Ek5g==
X-Gm-Message-State: AOAM5311Z7ey+tAMEC0of7H9YvMPZ1KANw8OKEgFQz16DMpYJ7UFcpjB
        LowycLm3POFVWAZJ5+bYa43USA==
X-Google-Smtp-Source: ABdhPJwhQtL9b6RdznSXQf2vSrgYVe30NOfVSzPgNn3O7Xy8NXOOegUiw2cdWCtM3QbleI+kTfBG6w==
X-Received: by 2002:a63:3189:: with SMTP id x131mr27646198pgx.430.1617726490489;
        Tue, 06 Apr 2021 09:28:10 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id d2sm18504889pgp.47.2021.04.06.09.28.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 09:28:09 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     =?UTF-8?q?Christian=20P=C3=B6ssinger?= <christian@poessinger.com>
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        u9012063@gmail.com
Subject: [PATCH iproute2] erspan: fix JSON output
Date:   Tue,  6 Apr 2021 09:28:02 -0700
Message-Id: <20210406162802.9041-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <3ac544c09842410fb863b332917a03ad@poessinger.com>
References: <3ac544c09842410fb863b332917a03ad@poessinger.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The format for erspan output is not valid JSON.
The direction should be value and erspan_dir should be the key.

Fixes: 289763626721 ("erspan: add erspan version II support")
Cc: u9012063@gmail.com
Reported-by: Christian Pössinger <christian@poessinger.com>
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 ip/link_gre6.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/ip/link_gre6.c b/ip/link_gre6.c
index 9d270f4b4455..f33598af8989 100644
--- a/ip/link_gre6.c
+++ b/ip/link_gre6.c
@@ -594,10 +594,10 @@ static void gre_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 
 		if (erspan_dir == 0)
 			print_string(PRINT_ANY, "erspan_dir",
-				     "erspan_dir ingress ", NULL);
+				     "erspan_dir %s ", "ingress");
 		else
 			print_string(PRINT_ANY, "erspan_dir",
-				     "erspan_dir egress ", NULL);
+				     "erspan_dir %s ", "egress");
 	}
 
 	if (tb[IFLA_GRE_ERSPAN_HWID]) {
-- 
2.30.2


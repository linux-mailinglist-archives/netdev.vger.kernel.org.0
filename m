Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31B70490FEA
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 18:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242003AbiAQRue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 12:50:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241684AbiAQRu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 12:50:29 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B6DC06161C
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 09:50:29 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id b1-20020a17090a990100b001b14bd47532so509461pjp.0
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 09:50:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6Lu8Ofe9OiOomvfdmKceVGmq8zIVB6BYh6XUCUGTXdg=;
        b=3FJoKOfor8mP8CaX+K//wMKJFZGvy/niBeVbaL8O3HCr90LGdFcCWj4SDoGkF1Oj9L
         AEd8cI7k3vdiBv+/zTFWKhqimFo8U9c/RBJsKdGJYFauLOaHDC3f+q44QXPPuSf5aXUW
         7uDz7NiCMGO/Kov9+8rgWnDTjo331b+yuJhRGugafuYFhX6p1hQOM66qGUj80KOjKekK
         AYzTDq/Tc5xymLKpyoRt5QIQJycrsf4u5FDLC3bx8GGnvJArGmADHCZlr/mXcl4nysF7
         AfXGhW9PdvZTK6W+B1akP5BhJcJqHJHoW8SGinFQil4tDzFS0tMWWd57mdtOa8YGM+ty
         ldKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6Lu8Ofe9OiOomvfdmKceVGmq8zIVB6BYh6XUCUGTXdg=;
        b=n+0T6vLrHe84r++FXCTF/u/Uau8glNJyrtV2RJtNENBJ9P29DKx36SMt7ZdrjUiLsH
         /TUS3Y6snaNHagwTAGSsaAzPffM9/6yr4RGEw4lOOOAaivCtrli53JnjhXKIpzpP7cgV
         dCmgr4oW98F2dN/Yv9ssShH+hntETxmukLMemNV5IO6PnyaF+hCRSF+9qF9mAvvGqcso
         qfzPBkYJgiOX7/V8Kd7PFSDCTXFOFGRrAJlShpoqwAqQLE2C/knpTTEGuUMCOVWEZD5U
         qh02PnpV4MlpxPrGqOaLMCbys32UqdEYI/MrFeNKLHH4P+FJiuMm0LTI33jZz3j1vynI
         Y34w==
X-Gm-Message-State: AOAM533mBa41+xy1WdhCk2p5flvHVQAdb0oq6utsXeyxBBwluOEstmCY
        4hrMj/whv1KC0c94wsCB69bJq9uwVHPutw==
X-Google-Smtp-Source: ABdhPJwVVTYJaqLzikqxbUYiqyTRpzw6MlTKEl4cr9XEV9XW4f7eLs+3B+RnqUDNJVsmT5f1I8gP7w==
X-Received: by 2002:a17:902:6bcc:b0:14a:bd99:1ae9 with SMTP id m12-20020a1709026bcc00b0014abd991ae9mr5355096plt.62.1642441828577;
        Mon, 17 Jan 2022 09:50:28 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id q19sm15819117pfk.131.2022.01.17.09.50.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 09:50:28 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v3 iproute2-next 07/11] can: fix clang warning
Date:   Mon, 17 Jan 2022 09:50:15 -0800
Message-Id: <20220117175019.13993-8-stephen@networkplumber.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220117175019.13993-1-stephen@networkplumber.org>
References: <20220117175019.13993-1-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix warning about passing non-format string.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 ip/iplink_can.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/ip/iplink_can.c b/ip/iplink_can.c
index 854ccc314e2b..6ea02a2a51c4 100644
--- a/ip/iplink_can.c
+++ b/ip/iplink_can.c
@@ -330,8 +330,9 @@ static void can_print_nl_indent(void)
 	print_string(PRINT_FP, NULL, "%s", "\t ");
 }
 
-static void can_print_timing_min_max(const char *json_attr, const char *fp_attr,
-				     int min, int max)
+static void __attribute__((format(printf, 2, 0)))
+can_print_timing_min_max(const char *json_attr, const char *fp_attr,
+			 int min, int max)
 {
 	print_null(PRINT_FP, NULL, fp_attr, NULL);
 	open_json_object(json_attr);
-- 
2.30.2


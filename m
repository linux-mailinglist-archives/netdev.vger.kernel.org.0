Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3663E353027
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 22:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236406AbhDBUMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 16:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbhDBUMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 16:12:09 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E5AC0613E6;
        Fri,  2 Apr 2021 13:12:07 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id x21-20020a17090a5315b029012c4a622e4aso3027400pjh.2;
        Fri, 02 Apr 2021 13:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y1RHCSC+V11qd9eqh8bG77F8uwj+77oBzm4p8tM50sA=;
        b=XeC/pJBkpIbRf6GgSFJGe85Yd4CZILNbPufOyxgb8LXPhhHX2LHH4F+tmcdS9O44DB
         cWK16sobfxN6t/lkJreCdHtyGnytdM8A/Bl9N0rVKhIiDfWfy6Finmqse10A3qN54nIJ
         7dB8uCp86pkRLql8PCm0od4h0ahAg5lDvdwXsrp8GzCUBStsv9cFiOwuY8SrjwZyU/MS
         JXM/P72IHGzT6liKrlSobLMQ4esS1IExs9hcXUHFBjnVcmVGxVlI7I5jpyZaReJGdCcJ
         J/ZYbODpegxP2Qqtb/tzJFVv8EF3SbDXinRi8QhCUzQoTjfK3im3sOl8l0xA8BlRRi5H
         QEpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y1RHCSC+V11qd9eqh8bG77F8uwj+77oBzm4p8tM50sA=;
        b=FKCxvrHHlbuJxA27xjJz7LHzk3JKvRU2hOw8FaqyS5RENjSXzpq8RjpPwtVQIlO+bE
         VXGAGZy+eT6VhA4O9jEWTxtYVsKD2Br01UbB5kgGgA8Wfx8gV1AKtymJ9LAQQk1Uezux
         NzrP2LMTZQ5D3py8hg9Eg7ZdzML3Rv0SglSqbL8Viav7S87GDzy6sISv6WRfoqVEdKJj
         F7X1bfqz/J7XnTgMmCdw+tlHvD0TlvDmzGCtr6dpKYHmYUpLu9CzhDQwiSnGPErm3fO1
         0LHwBIIBwEbbzufmOicX4WC57Nvl2gXXq13eA2Kq9bXYCQx/TpfKCvz5+9MjZrTgPyRl
         XSsw==
X-Gm-Message-State: AOAM5322ceQsLAPN68Ba7tq6p8xqqFju6/e8BNzSLiHqtQRuEBRMle5I
        4TmIAI6JMqcCgIXeqLXibJc=
X-Google-Smtp-Source: ABdhPJyeHnx3PhROsSay6Qhc5/rhXrmHJTSBl2GIY8CnL3ORSt1GC+9SGXsO6+s8MgqhLCZwcuKbCg==
X-Received: by 2002:a17:90a:fc5:: with SMTP id 63mr15560949pjz.233.1617394327238;
        Fri, 02 Apr 2021 13:12:07 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:e15f:835a:6bcd:3410])
        by smtp.gmail.com with ESMTPSA id h15sm8864994pfo.20.2021.04.02.13.12.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 13:12:06 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>,
        Manoj Basapathi <manojbm@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: [PATCH netfilter] netfilter: xt_IDLETIMER: fix idletimer_tg_helper non-kosher casts
Date:   Fri,  2 Apr 2021 13:11:56 -0700
Message-Id: <20210402201156.2789453-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

The code is relying on the identical layout of the beginning
of the v0 and v1 structs, but this can easily lead to code bugs
if one were to try to extend this further...

I use:
  char (*plabel)[MAX_IDLETIMER_LABEL_SIZE]
instead of:
  char label[MAX_IDLETIMER_LABEL_SIZE]
as the helper's argument to get better type safety
(the former checks array size, the latter does not).

Cc: Manoj Basapathi <manojbm@codeaurora.org>
Cc: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 net/netfilter/xt_IDLETIMER.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/xt_IDLETIMER.c b/net/netfilter/xt_IDLETIMER.c
index 7b2f359bfce4..2b5e81f6e0bd 100644
--- a/net/netfilter/xt_IDLETIMER.c
+++ b/net/netfilter/xt_IDLETIMER.c
@@ -283,18 +283,19 @@ static unsigned int idletimer_tg_target_v1(struct sk_buff *skb,
 	return XT_CONTINUE;
 }
 
-static int idletimer_tg_helper(struct idletimer_tg_info *info)
+static int idletimer_tg_helper(__u32 timeout,
+			       char (*plabel)[MAX_IDLETIMER_LABEL_SIZE])
 {
-	if (info->timeout == 0) {
+	if (timeout == 0) {
 		pr_debug("timeout value is zero\n");
 		return -EINVAL;
 	}
-	if (info->timeout >= INT_MAX / 1000) {
+	if (timeout >= INT_MAX / 1000) {
 		pr_debug("timeout value is too big\n");
 		return -EINVAL;
 	}
-	if (info->label[0] == '\0' ||
-	    strnlen(info->label,
+	if ((*plabel)[0] == '\0' ||
+	    strnlen(*plabel,
 		    MAX_IDLETIMER_LABEL_SIZE) == MAX_IDLETIMER_LABEL_SIZE) {
 		pr_debug("label is empty or not nul-terminated\n");
 		return -EINVAL;
@@ -310,9 +311,8 @@ static int idletimer_tg_checkentry(const struct xt_tgchk_param *par)
 
 	pr_debug("checkentry targinfo%s\n", info->label);
 
-	ret = idletimer_tg_helper(info);
-	if(ret < 0)
-	{
+	ret = idletimer_tg_helper(info->timeout, &info->label);
+	if (ret < 0) {
 		pr_debug("checkentry helper return invalid\n");
 		return -EINVAL;
 	}
@@ -349,9 +349,8 @@ static int idletimer_tg_checkentry_v1(const struct xt_tgchk_param *par)
 	if (info->send_nl_msg)
 		return -EOPNOTSUPP;
 
-	ret = idletimer_tg_helper((struct idletimer_tg_info *)info);
-	if(ret < 0)
-	{
+	ret = idletimer_tg_helper(info->timeout, &info->label);
+	if (ret < 0) {
 		pr_debug("checkentry helper return invalid\n");
 		return -EINVAL;
 	}
-- 
2.31.0.208.g409f899ff0-goog


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3F11D6840
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 15:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbgEQN3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 09:29:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727893AbgEQN3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 May 2020 09:29:13 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E7FC061A0C
        for <netdev@vger.kernel.org>; Sun, 17 May 2020 06:29:13 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id i14so7459817qka.10
        for <netdev@vger.kernel.org>; Sun, 17 May 2020 06:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=XUNKycY4gNFtt7omWikhxK68lI5q2O29FKop8FjZqtE=;
        b=vWzJaXe3FNf/Jx7ok0qlhLHSiAIxI3WQh1YtRqpEussVOvpHk8lQvPdCodS1NB59UG
         XEs7ggujnGuVChmm4gmlFGlHyLmk0xa9EH2T1q+Jk84Ny2Oaxm1NjDyxAN/vddv77zCu
         EzFa5WAJARSrPAnFyeCVlJjMmWXjwFAok6sVWffQFHDp6/zsVDIUsmcLxvObyZlP1MVW
         vMzEJV4LIl6IPEuvvdp8LNHjnLnqfKHjpMi3pg3CBbk0EVZ9AH0pCZH52FrIfHOt4W0f
         gLBA1QvxRhS/ysQ9a6GT74lC+g6wO+cUAaC4/Yyy2ftA2jePeZ0266q1tvhplgPtU3cq
         TICQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=XUNKycY4gNFtt7omWikhxK68lI5q2O29FKop8FjZqtE=;
        b=LCbEx9FpIztZJvja9CGx1yjvXZZVCR2A1VB7wPeIuYsUqUq5xiY0i3LT+tj8PtihMr
         8buM/lJ+7yEkz4M/Z67hKltPqGrViXCaVtJ0wTO5QyBYmNkzHfaEoGxs9laop7tEiZcO
         PZyCMpcE5xt5J1pFpD5tmDFqmkEc3DH3MXqJRNLTkMldP0dKCoEkJHZSS0R/ghc9H/wm
         8PnaHcrxPf2acve+97wT4xFitFpv/7wivgV15YdDV6x8npBVKxaVXGi7yQTKKWkjOi7g
         XL+Kf1N1L9yA0MIWW+x9ZxleO5Xi26B8FT1ebGvgzwoOh/4EnbodELvKoUwnWXC1yyMP
         StYA==
X-Gm-Message-State: AOAM532KZ9eGnDygssPS/VJqEJgANeJ7aNKwWYhFxlKYDm8FQli2lcT2
        meJViEfXuAazaDt5g75RfJ3saA==
X-Google-Smtp-Source: ABdhPJwuXV+jmjs73tKkWj/3MviLaO8NvZk4jX3aw6XAkjkajqkdkq/92Me4SLWD0fBcTMF1NwyTMA==
X-Received: by 2002:a05:620a:a93:: with SMTP id v19mr11443711qkg.416.1589722152801;
        Sun, 17 May 2020 06:29:12 -0700 (PDT)
Received: from mojatatu.com ([74.127.203.199])
        by smtp.gmail.com with ESMTPSA id f33sm4839028qta.44.2020.05.17.06.29.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 17 May 2020 06:29:12 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     dsahern@gmail.com
Cc:     stephen@networkplumber.org, netdev@vger.kernel.org,
        kernel@mojatatu.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH iproute2-next 1/1] tc: report time an action was first used
Date:   Sun, 17 May 2020 09:28:45 -0400
Message-Id: <1589722125-21710-1-git-send-email-mrv@mojatatu.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Have print_tm() dump firstuse value along with install, lastuse
and expires.

Signed-off-by: Roman Mashak <mrv@mojatatu.com>
---
 tc/tc_util.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tc/tc_util.c b/tc/tc_util.c
index 12f865cc71bf..f6aa2ed552a9 100644
--- a/tc/tc_util.c
+++ b/tc/tc_util.c
@@ -760,6 +760,11 @@ void print_tm(FILE *f, const struct tcf_t *tm)
 		print_uint(PRINT_FP, NULL, " used %u sec",
 			   (unsigned int)(tm->lastuse/hz));
 	}
+	if (tm->firstuse != 0) {
+		print_uint(PRINT_JSON, "first_used", NULL, tm->firstuse);
+		print_uint(PRINT_FP, NULL, " firstused %u sec",
+			   (unsigned int)(tm->firstuse/hz));
+	}
 	if (tm->expires != 0) {
 		print_uint(PRINT_JSON, "expires", NULL, tm->expires);
 		print_uint(PRINT_FP, NULL, " expires %u sec",
-- 
2.7.4


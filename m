Return-Path: <netdev+bounces-4766-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D4F070E287
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 18:59:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E08201C20D2B
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 16:59:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD68C206A6;
	Tue, 23 May 2023 16:59:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D211B206A2
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 16:59:37 +0000 (UTC)
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C76DD
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 09:59:36 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-64d44b198baso74971b3a.0
        for <netdev@vger.kernel.org>; Tue, 23 May 2023 09:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1684861176; x=1687453176;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aaevM9BfQQ0Et7TptAOei2iDqnn44+cVy5H+Vqe/tqg=;
        b=fXVYue3y9jqKPhe6Vws77+tckHsqEhgKJJCkC1RxlWMqK4Xc/jkzPMwJskJTyE911r
         G2UWwD7YTkbYjuYHb28FdseQU9IDdaHQ7XQ64rvnbUYv21ztet26YfWjM2/OiIbsgVb/
         vKO/B/Rah7aQQJzsokLxmvCkuhiUE9KVZl3fIGr6jTWW3pYAB3WRA9aYM7AfQ8xX8LJR
         szBVMUXivp5FlfjhuOw5+rQbCb5nJOJGjPelkygwkhFW/VfLEVAn29MZRivZmrsH519V
         KMlQBYLq4nyc4Cab7ln1zhc7P76fgkEN4X9lbSa/W5rHErR4C1m1yjvaysBMuWPb3bTe
         JeOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684861176; x=1687453176;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aaevM9BfQQ0Et7TptAOei2iDqnn44+cVy5H+Vqe/tqg=;
        b=S6ydmqf7QObR1KQh1DjvqmojsWaTMSRDBm5cbNXCojHhyIFYZreyxdMlNlGRtX/UX0
         rqOXvNOPIeLyR8RBk7z1FRdCEFfFl/sOSJ667klJbrKVff/D9DuOK1m4OUUd1mmrp47L
         Jlf/q9zegrU0ht3TaoQHk+jcdpEYY7fYbZmjTo0TAJ1ZdXC8lUAkhEsED72SohtdK9r3
         d0pHMzSTP5YtPCwc370LKL1JJJEoTMBDDwxWFTKvbkoH8B2E16pZL8osyXrZLjnzU7Lb
         plHE8C0yDLrsj6HdPnGqiuHPqu2cI/DsEHMdNQ9710omOj5hWS1iFcn2t2yNBKXwaJNY
         yayg==
X-Gm-Message-State: AC+VfDwzq/RFJIXwkf5Co7IpR7PvEmHqw22qNXwUDzjiHfUV0rZb9hsU
	DFul3EvlDYlc/m9ksvtqmoCLQroeqfhpOvoX/PtJ9w==
X-Google-Smtp-Source: ACHHUZ4GrK4Un4/YWlTE432qmPu6tOsFE9aAVQdRt9+UhG6wrCS0IRohbMaFgtDuJgMYZKHUb/MEgg==
X-Received: by 2002:aa7:88d5:0:b0:63d:3c39:ecc2 with SMTP id k21-20020aa788d5000000b0063d3c39ecc2mr15422063pff.12.1684861175790;
        Tue, 23 May 2023 09:59:35 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id a14-20020a62e20e000000b00643889e30c2sm3836891pfi.180.2023.05.23.09.59.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 09:59:35 -0700 (PDT)
From: Stephen Hemminger <stephen@networkplumber.org>
To: netdev@vger.kernel.org
Cc: Stephen Hemminger <stephen@networkplumber.org>
Subject: [RFC 1/2] vxlan: use print_nll for gbp and gpe
Date: Tue, 23 May 2023 09:59:31 -0700
Message-Id: <20230523165932.8376-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The Gbp and Gpe are presence, not booleans so use print_null()
for them

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 ip/iplink_vxlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/ip/iplink_vxlan.c b/ip/iplink_vxlan.c
index c7e0e1c47606..cb6745c74507 100644
--- a/ip/iplink_vxlan.c
+++ b/ip/iplink_vxlan.c
@@ -650,9 +650,9 @@ static void vxlan_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 		print_bool(PRINT_ANY, "remcsum_rx", "remcsumrx ", true);
 
 	if (tb[IFLA_VXLAN_GBP])
-		print_bool(PRINT_ANY, "gbp", "gbp ", true);
+		print_null(PRINT_ANY, "gbp", "gbp ", NULL);
 	if (tb[IFLA_VXLAN_GPE])
-		print_bool(PRINT_ANY, "gpe", "gpe ", true);
+		print_null(PRINT_ANY, "gpe", "gpe ", NULL);
 }
 
 static void vxlan_print_help(struct link_util *lu, int argc, char **argv,
-- 
2.39.2



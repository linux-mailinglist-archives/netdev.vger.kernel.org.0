Return-Path: <netdev+bounces-9822-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C302F72AD13
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 18:15:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 08FB21C20A82
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 16:14:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71CF820989;
	Sat, 10 Jun 2023 16:11:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6111B206A9
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 16:11:58 +0000 (UTC)
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38F7A3A89
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 09:11:55 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id ffacd0b85a97d-30fbac9639fso6650f8f.1
        for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 09:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1686413513; x=1689005513;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dzcW0Rg0MJsYKH97rS9LM5MknKKz1Cy5IxSSDaK0D2Q=;
        b=MEircifRXpTm5J8hUulXKd4LzKicm835J68wDg5i0azcYpp4+szeMHWJ2OUuKn5+Y3
         dcqLYH7dZJKmphyTOx/whvDmpBoIYG+SmFM8oaU2jExtJY+lpWZAuNcrtbzA2MgFrZf6
         Mt2JbGfPfL98ArMATr/koSRhWludlHKy7G5MHVsFkv8pp/gcibau5ETR/fM7CWIZa0W+
         RbNcUGvccBXqvLHfHL2OF4Oz8Kpk6GjdwEMZgs4a6DKUu1LOIE6F18ruxOwZX+AQ0y+Q
         J+GfUzM51XnXI2kOiddwxa1KLrkz7N9cInK0rj7J9PisjVBtjlGBqwsID0EyegYELSrG
         jMEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686413513; x=1689005513;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dzcW0Rg0MJsYKH97rS9LM5MknKKz1Cy5IxSSDaK0D2Q=;
        b=Z3yA5QWb65TTlXlz/K3ycv7Ol+zUWLlxykPzu1/PqFJJOoVdCMTbSNLF9j4nuZF10C
         o9nLkR6aFgR+1Ag5+AFKGp+vSXSoKqdC4Uom6lptL9KG/YZ/idUYSJMRrbd7wKDR4XRS
         Y52fWb3uSTUvYy8NmBlrAVveGZ7ymo9KXQCrq81lR5fbuqrBhQi7Nl2/ZvSXwK7ElHT9
         CDIQGy3AFUKpUFCSszVmH3CxjkCDIMpI04XaEKr7fBkFLr7zy6QYPWTXrWS7/0+6fKzm
         NW33WD3t7hCrC2bWPGE+M7AvqJDChHIcO1HU5tjdjJUcEA+PjicJhm4WOYOleW8RrDe5
         38PA==
X-Gm-Message-State: AC+VfDxOeAmTMPVmAqPH7a1hmT6oVG9J+L1CnmBNULtC4QGIUv+EJtGe
	P+B6GRpOqZGNt9RJTeRScPQhbw==
X-Google-Smtp-Source: ACHHUZ7CC9VFs3pFwJ+D6PfVuqzPiZjDLvWjB4EapkqrZo+EUE8UK5+m7dxozWNfmGICHlin3F8LEQ==
X-Received: by 2002:a5d:44d2:0:b0:30a:e954:fde2 with SMTP id z18-20020a5d44d2000000b0030ae954fde2mr1559786wrr.53.1686413513342;
        Sat, 10 Jun 2023 09:11:53 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id u9-20020a5d4349000000b003079c402762sm7431145wrr.19.2023.06.10.09.11.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jun 2023 09:11:52 -0700 (PDT)
From: Matthieu Baerts <matthieu.baerts@tessares.net>
Date: Sat, 10 Jun 2023 18:11:41 +0200
Subject: [PATCH net 06/17] selftests: mptcp: join: support local endpoint
 being tracked or not
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230609-upstream-net-20230610-mptcp-selftests-support-old-kernels-part-3-v1-6-2896fe2ee8a3@tessares.net>
References: <20230609-upstream-net-20230610-mptcp-selftests-support-old-kernels-part-3-v1-0-2896fe2ee8a3@tessares.net>
In-Reply-To: <20230609-upstream-net-20230610-mptcp-selftests-support-old-kernels-part-3-v1-0-2896fe2ee8a3@tessares.net>
To: mptcp@lists.linux.dev, Mat Martineau <martineau@kernel.org>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Shuah Khan <shuah@kernel.org>, Florian Westphal <fw@strlen.de>, 
 Davide Caratti <dcaratti@redhat.com>, Christoph Paasch <cpaasch@apple.com>, 
 Geliang Tang <geliangtang@gmail.com>, Geliang Tang <geliang.tang@suse.com>
Cc: netdev@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 Matthieu Baerts <matthieu.baerts@tessares.net>, stable@vger.kernel.org
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2059;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=q7mGRV6R7dK4lJiqWQ6yuoyaRF44AvUMt35UM+xNDyY=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkhKC+Kv3447FwCDieRpr89Tn6WwHLQnDDABzCk
 ko/rq9+RSmJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZISgvgAKCRD2t4JPQmmg
 cyg+D/0d7ZzzM4y0hVok/ZmwMLscGPbkkSd83O6Zf0uGLWFTKvNI1ZS5YI3YWbbhsy9Tv1JOzjV
 +FALcA/QmGyO/XtjUPthjnWx3W+9DS95NKdRZyq1VERLAxCv2a33KtAsHJOnmIZmKo55vK7cZ0o
 hV9lqLF25Fn5/k22qaDiWwKvJyK4J2VedipZI3+ezfpxgAHPrjd1W9Cj8lZlJgiLRrQ21a4/i7v
 30t6R6xVk9ldppHQNxPknO2PmHnQ83yZqeLsd8Vn3qX9XlrA+8KTFNBMP6ICwF/usnFTdiIpnG2
 GMRokmYeP6SRL1FlzvwneqIGPv/2ccxZI6dskL7tImyv2z7dIVEnP/L4lXqEb3tg+OFPEf3ry8c
 2fS0x+XFE6eR7RNqNJYl6doaDbzilPmy3My4Rkx5GPn3JWegZV4Bo42tO5uBBZj3YKnEEs6u2FK
 +zs7tuUsgUxRfB024fQsut70hJlVLOYy1y8TsfvF3IxRvvCgaNT64UWY2GwO/NFw6JT3xv+IdI2
 1Zl3xDyZ/dG66eLHQylMm7jmYKotlnUNV4+C5xRp/HVXpFZgoBPHuyvX4726BK6ty9F35uekCu5
 qo5nwPrIw8xGfIZM0dlc0zsgJ889qiXiHnYSjpoODzqEAZH93T2yC4QaCSEKltWMyUMrRtypsJH
 j2uGcEglKD11lnA==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Selftests are supposed to run on any kernels, including the old ones not
supporting all MPTCP features.

At some points, a new feature caused internal behaviour changes we are
verifying in the selftests, see the Fixes tag below. It was not a uAPI
change but because in these selftests, we check some internal
behaviours, it is normal we have to adapt them from time to time after
having added some features.

It is possible to look for "mptcp_pm_subflow_check_next" in kallsyms
because it was needed to introduce the mentioned feature. So we can know
in advance what the behaviour we are expecting here instead of
supporting the two behaviours.

Link: https://github.com/multipath-tcp/mptcp_net-next/issues/368
Fixes: 86e39e04482b ("mptcp: keep track of local endpoint still available for each msk")
Cc: stable@vger.kernel.org
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index c471934ad5e0..3da39febb09e 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -2129,11 +2129,18 @@ signal_address_tests()
 		# the peer could possibly miss some addr notification, allow retransmission
 		ip netns exec $ns1 sysctl -q net.mptcp.add_addr_timeout=1
 		run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow
-		chk_join_nr 3 3 3
 
-		# the server will not signal the address terminating
-		# the MPC subflow
-		chk_add_nr 3 3
+		# It is not directly linked to the commit introducing this
+		# symbol but for the parent one which is linked anyway.
+		if ! mptcp_lib_kallsyms_has "mptcp_pm_subflow_check_next$"; then
+			chk_join_nr 3 3 2
+			chk_add_nr 4 4
+		else
+			chk_join_nr 3 3 3
+			# the server will not signal the address terminating
+			# the MPC subflow
+			chk_add_nr 3 3
+		fi
 	fi
 }
 

-- 
2.40.1



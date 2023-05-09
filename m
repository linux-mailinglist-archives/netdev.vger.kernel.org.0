Return-Path: <netdev+bounces-1025-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D66D6FBD8C
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 05:13:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B8AC62811E9
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 03:13:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9415817F1;
	Tue,  9 May 2023 03:12:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86DA620F2
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 03:12:28 +0000 (UTC)
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 331C9659F
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 20:12:17 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1ab1ce53ca6so38323365ad.0
        for <netdev@vger.kernel.org>; Mon, 08 May 2023 20:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683601936; x=1686193936;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N2Gjn/Xn7/rXFOIsbTHIvULH0U+fm/sURSyKXcEl/zg=;
        b=S9s4gTPwngiuYYvTAxFSFmMburvz76tB/1uJbeQxBQg8TW1sdueiQrExSafvNv1xOu
         ZMlyW7v3fZSPE/OAnclfglKjKNxhBihDYoOZH0w77ogWwpDKKfsCw6m3e0mUFDAFrzLa
         5cFiD+rY6gU/igMyS5yYhLKmOG9XfZzYo42bD7YJBbLyBlV1Oy4PP1F8CfEBsC9eR4jQ
         +ftsYHSUhtBqkNYzOk+99knrUKmLq4uzpswpsEfhGfuoF2iyHAXvdgO4UP4nLVh6qt9e
         1C4g6aCD0sRAwxV1kYAOcuEZZR6J3Z2iwL/yMUd73sOcAB2g9jRYoCvo8LhPqIlCnGv2
         HmSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683601936; x=1686193936;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N2Gjn/Xn7/rXFOIsbTHIvULH0U+fm/sURSyKXcEl/zg=;
        b=BPSn9cMiv80SQ3nizbmyTVd6BbaCurCAjPON1zFYI6DkqOqA1eS0ngw4EGYBAMFk26
         J5scwwFg7lqlUIlhcm/Sh43WvyNT+54qWGfNt3Fd7uyoHXlPsRLfOGVNojmwvmucnq68
         PNTHB2IwkhFP6YGXIQ/0L+t4EdyiJgyuIrVP8kJbe4CRyjr0Mc4ZRRCxaoz3UsOS5t7b
         v+o9Y49poWjpYLXRsJVB+gM2UJMclCPw3cg8rom5AVTV5J6S6yLvHy6Qs45j4UBrhmoX
         Gh/GMOlpBzEZPXXH7v/NfED5THfsR4cnZ9NZ5x1zN9G7vK1Q9ZSJAB96dtalP/Uz2uyr
         52Gw==
X-Gm-Message-State: AC+VfDyOG+z+ty99JppRPuJATv2gzg8E4m4t0HMMrm9Yelqtme2rPm2m
	v/8L1lZDGz1MH+50NdnCY1Q9TktRV6PkIt+U
X-Google-Smtp-Source: ACHHUZ6MfVYEWu/MM9sOe2+s9cJzunJ2ex6Raaxdp0ExbfPDjEZu8c/w35nHvFvnJ9Wms2dWRa5Aaw==
X-Received: by 2002:a17:902:d4c6:b0:1ac:8ad0:1707 with SMTP id o6-20020a170902d4c600b001ac8ad01707mr3952107plg.1.1683601936107;
        Mon, 08 May 2023 20:12:16 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id j2-20020a170902da8200b001ab19724f64sm250768plx.38.2023.05.08.20.12.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 20:12:15 -0700 (PDT)
From: Hangbin Liu <liuhangbin@gmail.com>
To: netdev@vger.kernel.org
Cc: Jay Vosburgh <j.vosburgh@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Liang Li <liali@redhat.com>,
	Vincent Bernat <vincent@bernat.ch>,
	Simon Horman <simon.horman@corigine.com>,
	Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv3 net 3/4] selftests: forwarding: lib: add netns support for tc rule handle stats get
Date: Tue,  9 May 2023 11:11:59 +0800
Message-Id: <20230509031200.2152236-4-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230509031200.2152236-1-liuhangbin@gmail.com>
References: <20230509031200.2152236-1-liuhangbin@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

When run the test in netns, it's not easy to get the tc stats via
tc_rule_handle_stats_get(). With the new netns parameter, we can get
stats from specific netns like

  num=$(tc_rule_handle_stats_get "dev eth0 ingress" 101 ".packets" "-n ns")

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/net/forwarding/lib.sh | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 057c3d0ad620..9ddb68dd6a08 100755
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -791,8 +791,9 @@ tc_rule_handle_stats_get()
 	local id=$1; shift
 	local handle=$1; shift
 	local selector=${1:-.packets}; shift
+	local netns=${1:-""}; shift
 
-	tc -j -s filter show $id \
+	tc $netns -j -s filter show $id \
 	    | jq ".[] | select(.options.handle == $handle) | \
 		  .options.actions[0].stats$selector"
 }
-- 
2.38.1



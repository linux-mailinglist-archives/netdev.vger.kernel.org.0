Return-Path: <netdev+bounces-7569-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F0C0720A0C
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 21:55:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C95902819F7
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 19:55:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 089771EA7E;
	Fri,  2 Jun 2023 19:55:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA831EA7A
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 19:55:01 +0000 (UTC)
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A64419A
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 12:55:00 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-bb05f0e6ef9so3442696276.1
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 12:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685735700; x=1688327700;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wvC6wmElZRvpiH+E9L3WfoP2SwSbGd7WVHWRFrOxZPI=;
        b=wsRD0Zar9MaDd0qyE6WTlk+K/eZ5x8B3psJKtTHmSL3pIe5Un8FIOTldhFWGd5MKgC
         B9A1+v5QpmkQ5KskiJTRuLdwRDHYwaWVOlt94UMhvZLk9atnEs0TIvCRF6fK7ZblC7i0
         BtSjmwLmyFGjPav2GJkNERHRqMHEc2SreymXCCkvulycHbzHLXfDIKMjTAiMVIfdEDKu
         BKm1qlM1MjKYLvKKP5WCv2/uzi1CPrVXMsoG+uPyAQ6JKrjDUr3UkV8/58Ov278pClYA
         2WJebWN5OaWWg99R14kwO6f+IhQhmwf7AooxaZmHu9iXUXkaGPx9o2Xj8XRqlnQ2pHSt
         TOBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685735700; x=1688327700;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wvC6wmElZRvpiH+E9L3WfoP2SwSbGd7WVHWRFrOxZPI=;
        b=kvsvE3BVlLNrlx96J3WIn2KEa7brwQTpZDf29v+x+14LFgw1FPVVh6UCIJdLt4ju9T
         LPWPZdPJEMcdRajr63O4xWV3Waf58Mlvxp2+8ZwnRWYyMoxRaBdPSmDvBuyfcR4emqEK
         z23fv9+bdjP/wDvbASR7Di85VJrXZdfZESb96jejgTZ2HOvXBo+U6yp18LGh9iAjIp2B
         Vol5ItdBMfYxQ7v6i7E1MbiDoDxh8u2rzkkrCqYv9q/SSxRc80Bq/t08Ye7xV5jX/+kP
         +fxsiSUXnhWnLwxXZk96UvbeNXMimn5Xf9+N3wc4Nb+Gn45jvhHat/kP+0V7bFmGLkY+
         9dAw==
X-Gm-Message-State: AC+VfDwiYOe85pYaHu/3w5wylk6a1GLHrtZ6bLJ2gBziBGYzqKFTgYJp
	zv5F38FISypKtfFfNrzE1nCeA3RHpzhQ6Nw=
X-Google-Smtp-Source: ACHHUZ4GaYGWl55WZGgfw+yOAPT8336nv+q0TvP+cvQiTk6jVpc/RyyGtR3bRWQbdkqi+GXIKPVOZzKp9Gsqs3o=
X-Received: from wg.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:3423])
 (user=weihaogao job=sendgmr) by 2002:a25:d4c8:0:b0:ba8:1e72:2c88 with SMTP id
 m191-20020a25d4c8000000b00ba81e722c88mr2279165ybf.13.1685735699800; Fri, 02
 Jun 2023 12:54:59 -0700 (PDT)
Date: Fri,  2 Jun 2023 19:54:50 +0000
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602195451.2862128-1-weihaogao@google.com>
Subject: [PATCH] Fix gitignore for recently added usptream self tests
From: Weihao Gao <weihaogao@google.com>
To: "David S . Miller " <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: netdev@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, trivial@kernel.org, 
	Weihao Gao <weihaogao@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This resolves the issue that generated binary is showing up as an untracked git file after every build on the kernel.

Signed-off-by: Weihao Gao <weihaogao@google.com>
---
 tools/testing/selftests/net/.gitignore | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
index 80f06aa62034..f27a7338b60e 100644
--- a/tools/testing/selftests/net/.gitignore
+++ b/tools/testing/selftests/net/.gitignore
@@ -8,8 +8,10 @@ diag_uid
 fin_ack_lat
 gro
 hwtstamp_config
+io_uring_zerocopy_tx
 ioam6_parser
 ip_defrag
+ip_local_port_range
 ipsec
 ipv6_flowlabel
 ipv6_flowlabel_mgr
@@ -26,6 +28,7 @@ reuseport_bpf_cpu
 reuseport_bpf_numa
 reuseport_dualstack
 rxtimestamp
+sctp_hello
 sk_bind_sendto_listen
 sk_connect_zero_addr
 socket
-- 
2.41.0.rc0.172.g3f132b7071-goog



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2807D22F503
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 18:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729280AbgG0QZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 12:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729099AbgG0QZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 12:25:36 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F15BC061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 09:25:36 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id h7so15768906qkk.7
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 09:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G7ShOKZ/8tLBooUqQziGfzC2qCV64R5oqgMbsVY4Ejs=;
        b=NokNMk5bpQXnRRmYgx0oYf1qSEInT259RzwkpkJSYdGMgWz5GBDdn4VFrDUevl1Ind
         npxppKLX3362i1AxAV9BpJiCrfueKJ+sN1Sfo/bf3Cq6qvHn/vJBE4OZ9W4Grbrv/EN1
         qw15VtknRA5hX1/WAS81q700NXt1BVr07mkp31Ett7QH91sINvinV+NHawHypo0NkQIq
         8U5ZPJMEtCnmu2tAurz+0GgYX6FCuIETOvbRmpCOF5Hd0e3PODNBld4zszAOXVuAXPUr
         nFlj0LbWsf2Iu2RFN+3pnJRcayilkPPJdSd1f8QEIUHjTx4QrM3C5sezJiE2ziv8C0/b
         LeJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G7ShOKZ/8tLBooUqQziGfzC2qCV64R5oqgMbsVY4Ejs=;
        b=CFCtnzC5rvOTE2XMkUHSlNqQ/37KClcXMo1K51OXSivCxeT9z111yFZMHseebax7rt
         zhSXZPwMacknunyQ792upKLciZ52TOhpbgt6/Ox9zC+WVU95aMnidhvQQ3dBh60dRWWD
         haq5p6+r0USey7h4WKQLBjw+qx/RuDmX7QcnIPjxrWO9DKWTYCbdQLHbYw2McTgC9uQk
         8iOQ/wSQJZZaZcFgZisZK/PTFMABvq+ykTcVxtGMhqD4rLZwGu/56AsGV+jKK/9Sh1Jv
         VrAUb78pziyHG7i9UoYZzrJex9GDRqHmEaiNVf2vxAn7FsD8x3RITA5WqpGKSN3Zp9uh
         PXgg==
X-Gm-Message-State: AOAM533JmyOToYb/U1zKCPtXC0+9oLrGXC1mRY47Pto4+2EpOih5qMfk
        1x2rHWeRJ+OIYul2i4pm38AoFnmG
X-Google-Smtp-Source: ABdhPJwwN3eHeN4astvmGnidoDI3qT8frXRmLi/7lY9w92JUSI+V+WBlDPsCL3oGpoWH1VTwWRIffA==
X-Received: by 2002:a37:62d4:: with SMTP id w203mr22999197qkb.463.1595867134212;
        Mon, 27 Jul 2020 09:25:34 -0700 (PDT)
Received: from tannerlove.nyc.corp.google.com ([2620:0:1003:316:f693:9fff:feea:df57])
        by smtp.gmail.com with ESMTPSA id o37sm16764529qte.9.2020.07.27.09.25.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 09:25:33 -0700 (PDT)
From:   Tanner Love <tannerlove.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Tanner Love <tannerlove@google.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net 1/4] selftests/net: rxtimestamp: fix clang issues for target arch PowerPC
Date:   Mon, 27 Jul 2020 12:25:28 -0400
Message-Id: <20200727162531.4089654-2-tannerlove.kernel@gmail.com>
X-Mailer: git-send-email 2.28.0.rc0.142.g3c755180ce-goog
In-Reply-To: <20200727162531.4089654-1-tannerlove.kernel@gmail.com>
References: <20200727162531.4089654-1-tannerlove.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tanner Love <tannerlove@google.com>

The signedness of char is implementation-dependent. Some systems
(including PowerPC and ARM) use unsigned char. Clang 9 threw:
warning: result of comparison of constant -1 with expression of type \
'char' is always true [-Wtautological-constant-out-of-range-compare]
                                  &arg_index)) != -1) {

Tested: make -C tools/testing/selftests TARGETS="net" run_tests

Fixes: 16e781224198 ("selftests/net: Add a test to validate behavior of rx timestamps")
Signed-off-by: Tanner Love <tannerlove@google.com>
Acked-by: Willem de Bruijn <willemb@google.com>
---
 tools/testing/selftests/net/rxtimestamp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/rxtimestamp.c b/tools/testing/selftests/net/rxtimestamp.c
index 422e7761254d..bcb79ba1f214 100644
--- a/tools/testing/selftests/net/rxtimestamp.c
+++ b/tools/testing/selftests/net/rxtimestamp.c
@@ -329,8 +329,7 @@ int main(int argc, char **argv)
 	bool all_tests = true;
 	int arg_index = 0;
 	int failures = 0;
-	int s, t;
-	char opt;
+	int s, t, opt;
 
 	while ((opt = getopt_long(argc, argv, "", long_options,
 				  &arg_index)) != -1) {
-- 
2.28.0.rc0.142.g3c755180ce-goog


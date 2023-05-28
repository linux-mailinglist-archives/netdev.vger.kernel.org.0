Return-Path: <netdev+bounces-5968-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 36232713B4D
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 19:38:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF06C280E51
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 17:38:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61FC97471;
	Sun, 28 May 2023 17:36:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F9A17460
	for <netdev@vger.kernel.org>; Sun, 28 May 2023 17:36:19 +0000 (UTC)
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91245106
	for <netdev@vger.kernel.org>; Sun, 28 May 2023 10:36:12 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-3f6077660c6so16188635e9.0
        for <netdev@vger.kernel.org>; Sun, 28 May 2023 10:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1685295371; x=1687887371;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Dv/yh1ez4MwkuLkx8esU0Cb+ZDlD0gjn5YXP4X/VzdA=;
        b=20jbrVmGwi4TuTnfu3xvKOsXYIn/VTHSr6q3sVvyvPG/QkjR4Sw/MXRUzH6Rmwghcd
         doEj7GBVjVH51Zc4lQmCSAn/fuiZ7VMfzMK3+UTH42K1e8BrbrjvouachZzT3PRKp+mO
         v7E1gV3hzGxur+ZKqPjaKd2yAOL8x4xeAPV5ZbUMR4YiER/Yn3IfTW/XvVbJnegONSwJ
         N4dfiTvbeBslFAvsdlqWhN8iuzfaPgMkdkt7CN6u8AioTwyLTL+8SvZfeazFHFTlC1OV
         WGDZGJwtaWec+oNCU0ZWnvile3cHge48sWDdf1xAUXf1HsfR5vEfG1ZqJip/VOMnAvdI
         psyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685295371; x=1687887371;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dv/yh1ez4MwkuLkx8esU0Cb+ZDlD0gjn5YXP4X/VzdA=;
        b=eq8oezOJM3Oz691B2CzY4km/PYJo9tR+S8uNMs0sRxrWELcbmOqhtgKO32GqsDwKV3
         YW9giHYwANKBv8AGppYjxZTwBsuPmZyYa7G5L9fU3zZVSTW5SRBZdUkI+wzZjSflznos
         bsFD9VZVdchyl6uG+XgM0G5RbJ/ElXDSV5hp+hPlz6FEOi3WTyZPpZxppJxQHOMo7jfD
         zj6Yjeyx+0yQLZTpxSzdJ6TM9D7YVqITdD8hwz675uaP5DJ26lCiE6qNgViSfTr6GY+1
         f8h7WZbJD6LokK+9DfPlGRFxJHM7E86YXR5qgF1hB+4vJDn+Zw/fklcoAeTfpf/qB0pM
         f+4g==
X-Gm-Message-State: AC+VfDxD4v+LqI31+y1ULT+/SORATUjsjNOy5f2TuYU+UCM81+7gVJV5
	6TG5PTifymcJVWsi2DCXhYqXVw==
X-Google-Smtp-Source: ACHHUZ7dC2h3fvG5MNDtlL7Fkgjyh8JJtwzKCQ6vEoZk7kEMXIXObjLWpUoeFImTibNfDjbflG8bsw==
X-Received: by 2002:a05:600c:2210:b0:3f4:2b13:f0fb with SMTP id z16-20020a05600c221000b003f42b13f0fbmr8320180wml.13.1685295371067;
        Sun, 28 May 2023 10:36:11 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id z10-20020a7bc7ca000000b003f602e2b653sm15334523wmk.28.2023.05.28.10.36.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 May 2023 10:36:10 -0700 (PDT)
From: Matthieu Baerts <matthieu.baerts@tessares.net>
Date: Sun, 28 May 2023 19:35:33 +0200
Subject: [PATCH net 8/8] selftests: mptcp: userspace pm: skip if MPTCP is
 not supported
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230528-upstream-net-20230528-mptcp-selftests-support-old-kernels-part-1-v1-8-a32d85577fc6@tessares.net>
References: <20230528-upstream-net-20230528-mptcp-selftests-support-old-kernels-part-1-v1-0-a32d85577fc6@tessares.net>
In-Reply-To: <20230528-upstream-net-20230528-mptcp-selftests-support-old-kernels-part-1-v1-0-a32d85577fc6@tessares.net>
To: mptcp@lists.linux.dev, Mat Martineau <martineau@kernel.org>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Shuah Khan <shuah@kernel.org>, Christoph Paasch <cpaasch@apple.com>, 
 Florian Westphal <fw@strlen.de>, Davide Caratti <dcaratti@redhat.com>, 
 Kishen Maloor <kishen.maloor@intel.com>
Cc: netdev@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 Matthieu Baerts <matthieu.baerts@tessares.net>, stable@vger.kernel.org
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1128;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=KmD6FWDokOOmgvkIHaO501SBS+m5bjw9eufDZhLROe8=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkc5EB0fds7CPvvv1yzueGAxIwy+BEXWt5telsx
 Es9ICH7W1yJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZHORAQAKCRD2t4JPQmmg
 czNXEACwTRfzBsR4CqhB9CChs90m1paBf8LijwU92DYy1hFF5RRvMpgUvOagqh/ECw+XEY2yZ8r
 eP90H0FcEQ4vXKcwDpmArjZVLOhXW4xx/BGyEruSOKgRgS8SyUGRnatPjd/oZTPA6XCQxN6Pqi9
 CfGGOhAQRZklZhx/r6yi+2aKboecxPhvtbFBBx3Ty/lRgSiWs6/05puflU7hutnlla3gCPfeq8q
 PXxK5bVrvkZ8hGVxKYGNdTY8/BNPseMQekCjRVLSA09UXStGVLcSHhzxB1Do4M8Dqm5pWwIIuC2
 GYvxBQLWNjPtVmU8ugP+yc4YGlpPq0v/ddffac148wal1l6/SWuBZd8s9eXNZpvqT5wsF3rDss0
 ZtMalRi/amRQBhAwOfpNCYM5aCGDVt7O4se99wOFU/wcdIJ8DMpBqbL3oruQ0duQHuuVg27SxpH
 5AQiuQWVUK9Q36hMcMWx6qmJgwSATVaku2FGqd7vk6lobbBfO7IiG09ECwvljOChuVCh1r5HnDa
 pN/+I8uxTfMUEpY5qbxRW6KvTQpf7jYafL6otbyqP7L5qdi3ex5ieAHzJJbpp8NlNww5c1sh8YK
 R/cKXpb7vyi+2tFeF1JUGR9R7GD2oBWTb3fNVUGHb3nm++LSAMkAP2YwzTS8cnMRtGa3gzptR5X
 CrqQv1fsMg5Ic3Q==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Selftests are supposed to run on any kernels, including the old ones not
supporting MPTCP.

A new check is then added to make sure MPTCP is supported. If not, the
test stops and is marked as "skipped".

Link: https://github.com/multipath-tcp/mptcp_net-next/issues/368
Fixes: 259a834fadda ("selftests: mptcp: functional tests for the userspace PM type")
Cc: stable@vger.kernel.org
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 tools/testing/selftests/net/mptcp/userspace_pm.sh | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/net/mptcp/userspace_pm.sh b/tools/testing/selftests/net/mptcp/userspace_pm.sh
index b1eb7bce599d..8092399d911f 100755
--- a/tools/testing/selftests/net/mptcp/userspace_pm.sh
+++ b/tools/testing/selftests/net/mptcp/userspace_pm.sh
@@ -1,6 +1,10 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
+. "$(dirname "${0}")/mptcp_lib.sh"
+
+mptcp_lib_check_mptcp
+
 ip -Version > /dev/null 2>&1
 if [ $? -ne 0 ];then
 	echo "SKIP: Cannot not run test without ip tool"

-- 
2.39.2



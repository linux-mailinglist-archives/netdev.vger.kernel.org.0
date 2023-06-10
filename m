Return-Path: <netdev+bounces-9827-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A79EB72AD24
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 18:17:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F20011C20B22
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 16:17:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5171C2340F;
	Sat, 10 Jun 2023 16:12:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 467B12340C
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 16:12:09 +0000 (UTC)
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE7D3C2A
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 09:12:01 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id ffacd0b85a97d-30fb7e668c8so191777f8f.1
        for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 09:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1686413520; x=1689005520;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RyTC3i+tL1e1KohwNfL5rcAn2kD/jZ7ZYJWIbElBNMQ=;
        b=8SYbwS8quGxgs0rUrCRIrQCB5iXdv1yrre5Db/uHWslG4hWS8z0hYEUcDAxVuBB0u3
         Q7ezw1BGhWwQQaZwPqOVyMhahbYdPMeCizqFc6U91WMKgeC1KEOiRlvywL17p2bgsZzf
         P4Gzl8Y3ojdwPTQfhAv/gQqKegOEeRkIzQB5OQ63BDSj2mM1eDaQDoliaSk9CuBeWZU6
         nzciJpwPkL2mi6ASNqDNzqbNbHvC9KARARrrfzy2TNtiOsDm3AylEhntSWRvjPmTpB8l
         LVrCJW6Tc9ONpcnU6B+w8cexPb7t/tPkxFtO9mYlSY2+LNubLxULb7Ck+8LjvAfzSD60
         UfRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686413520; x=1689005520;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RyTC3i+tL1e1KohwNfL5rcAn2kD/jZ7ZYJWIbElBNMQ=;
        b=Nhmz3Pf9oYIxbK+FMApSsDmU1YS7NzRGqmb4s38DEDsAV3b6Gtg+ebyNk6JYqGg0AI
         aZOLxXqYPTe9OUyXRUrLtnkDuTXCaFwhTlyAsSsHd/xFKih2Q7UbEZ7JidOLZ7HUY9Jb
         WltgYow16UnP5RL66gET5oy6glyPO+O5YfnUsYNxyC9YPOnWp7Ayujzv6SXdtxLEa87D
         DB30KB55CuOzSs/XO2KLxVfza3QKOudgzs4vL1rn+AOzvrkhlcjNDvE9cvM4VJYashDe
         YAODKwBi8lJNjtL3qfoU+E5CgleuQD9YJJvx/pvQgjFJVd0AH+OnWXE/bv9TCVMi21gm
         H0ig==
X-Gm-Message-State: AC+VfDzcfIlgo5m7wfJYva5JXCcCl8LUXkl4mlykHYoEFY2R5avzyj9S
	NCKFpMqEoNMhaD/buOmSfT7ilQ==
X-Google-Smtp-Source: ACHHUZ6YpDEMouSjwol8z+p7bYurmmH74xuvGbojtJsg1H/xz6aUPiX0Y/YhIs7KeGogNDgKHdoGjg==
X-Received: by 2002:adf:e38f:0:b0:307:9081:d355 with SMTP id e15-20020adfe38f000000b003079081d355mr1444633wrm.26.1686413520223;
        Sat, 10 Jun 2023 09:12:00 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id u9-20020a5d4349000000b003079c402762sm7431145wrr.19.2023.06.10.09.11.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jun 2023 09:11:59 -0700 (PDT)
From: Matthieu Baerts <matthieu.baerts@tessares.net>
Date: Sat, 10 Jun 2023 18:11:46 +0200
Subject: [PATCH net 11/17] selftests: mptcp: join: skip fullmesh flag tests
 if not supported
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230609-upstream-net-20230610-mptcp-selftests-support-old-kernels-part-3-v1-11-2896fe2ee8a3@tessares.net>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2784;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=S7UdnJ4qdCLymGYFyzykYWhOhatHjYbGlgY4hALZQAg=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkhKC+xCmMmEjDr4x8Nfmu4YujlzmCdrVCWER/f
 2hJ1zmuzLyJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZISgvgAKCRD2t4JPQmmg
 c9eOD/9e+ou2ZTUkv/YpCHinhIImNnS+mPi225Ia4FKa8Fe6prJGKR44qpX7rJqj9CY/UXOQLC7
 90arvoruPiDgq2/Gzf8FtevKpwP7EXOiKsKjXP5LNFuVt1C/o40dvjMG0oKqgNBbuipqQAjm+gw
 9+sZCBhIJK/DyFR8VWX4TGtVMkEMPQCOaWIh5odiNvihJI8aQVfVK4wZBwMJFoh5FvXt3gHCaYp
 fZ94ImXgxazRPKV4+o5Sro73sb+aHRYKt+QGK77iD6RzTcb4P5FUi3jKS6nz95vQXTDxc38u9xG
 2NU9eHZ62XSaK+6gZFfJxVAtW2yRMeAgyOtD6sqKsifGyxWJtBJhbF33gENJ1jsG9UvU6wUMwzg
 KAnX1NEgaVPL0f0X/PP/tp+CMtsRWFcQAcm9iIIKT3QvIZCM0oHHidGKQkMPBVu7hUMncUz5VkU
 Dvfr1QBWhDOZcY3Wm2WVFxI14qGBLiZhZXbyaaYMUCra038PrxoyV/nq+j45juX2kqqSSOQgvJm
 N9iB0t97cjtset/SIOYF59ieBs136NvuvgApCrS9Lv2676tPd+xI9MigiqmlpeNh6WYVIsGmMMT
 CFuzrKFEdzHnWi6GzybgyHXv+wJycwaDglmY9KfbQdvfcF6uxtf5ERpUclKRLUF20W/tgAhBm3Q
 A34nRtELxAGfPKA==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Selftests are supposed to run on any kernels, including the old ones not
supporting all MPTCP features.

One of them is the support of the fullmesh flag for the in-kernel PM
introduced by commit 2843ff6f36db ("mptcp: remote addresses fullmesh")
and commit 1a0d6136c5f0 ("mptcp: local addresses fullmesh").

It looks like there is no easy external sign we can use to predict the
expected behaviour. We could add the flag and then check if it has been
added but for that, and for each fullmesh test, we would need to setup a
new environment, do the checks, clean it and then only start the test
from yet another clean environment. To keep it simple and avoid
introducing new issues, we look for a specific kernel version. That's
not ideal but an acceptable solution for this case.

Link: https://github.com/multipath-tcp/mptcp_net-next/issues/368
Fixes: 6a0653b96f5d ("selftests: mptcp: add fullmesh setting tests")
Cc: stable@vger.kernel.org
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index adbe297a95cf..f8e58ebcdd54 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -3098,7 +3098,8 @@ fullmesh_tests()
 	fi
 
 	# set fullmesh flag
-	if reset "set fullmesh flag test"; then
+	if reset "set fullmesh flag test" &&
+	   continue_if mptcp_lib_kversion_ge 5.18; then
 		pm_nl_set_limits $ns1 4 4
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags subflow
 		pm_nl_set_limits $ns2 4 4
@@ -3108,7 +3109,8 @@ fullmesh_tests()
 	fi
 
 	# set nofullmesh flag
-	if reset "set nofullmesh flag test"; then
+	if reset "set nofullmesh flag test" &&
+	   continue_if mptcp_lib_kversion_ge 5.18; then
 		pm_nl_set_limits $ns1 4 4
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags subflow,fullmesh
 		pm_nl_set_limits $ns2 4 4
@@ -3118,7 +3120,8 @@ fullmesh_tests()
 	fi
 
 	# set backup,fullmesh flags
-	if reset "set backup,fullmesh flags test"; then
+	if reset "set backup,fullmesh flags test" &&
+	   continue_if mptcp_lib_kversion_ge 5.18; then
 		pm_nl_set_limits $ns1 4 4
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags subflow
 		pm_nl_set_limits $ns2 4 4
@@ -3129,7 +3132,8 @@ fullmesh_tests()
 	fi
 
 	# set nobackup,nofullmesh flags
-	if reset "set nobackup,nofullmesh flags test"; then
+	if reset "set nobackup,nofullmesh flags test" &&
+	   continue_if mptcp_lib_kversion_ge 5.18; then
 		pm_nl_set_limits $ns1 4 4
 		pm_nl_set_limits $ns2 4 4
 		pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow,backup,fullmesh

-- 
2.40.1



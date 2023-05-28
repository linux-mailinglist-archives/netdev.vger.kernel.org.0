Return-Path: <netdev+bounces-5966-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 111A4713B4A
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 19:38:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B25B41C209AD
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 17:37:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 280126AA9;
	Sun, 28 May 2023 17:36:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125BB6AA3
	for <netdev@vger.kernel.org>; Sun, 28 May 2023 17:36:18 +0000 (UTC)
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B250C6
	for <netdev@vger.kernel.org>; Sun, 28 May 2023 10:36:10 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id ffacd0b85a97d-3093eb8cd1fso1526722f8f.1
        for <netdev@vger.kernel.org>; Sun, 28 May 2023 10:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1685295369; x=1687887369;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1iFsQSoektVWo2hESWKZtZkktu5l6M6gOCDs+m+CLio=;
        b=a4tjax/M037J4XbF6dF2XBpbWlJBX6yjwE0k5qXuPWPE3SMUGoct7HZBuY2/j7YKo7
         zLaS9ywinq8EuJ+wSZMD7GvdeeNbqs53v22RL7OUxgDe4WJR9rR61MwgR9gFi9qn+nIi
         BWCiu5P4s3+1xSaP3j3qyLhYbXx9vgnbh7l58Gb0jvS2kFUxNQrAZmJ2YdmT4in6rfy5
         iNVmvTr4ybYda6DiBx56ZvNxFsTsMN+zgV+R7HnIq5zmY7eVsZpQLklhLvqBX9nOCWG4
         5nd5O0mNuu0OtvOfOztIvPUOxBWgPFVfXgB+6S73fYwzEjGV5Vk1LkijAX4gsKKdaQjG
         lipQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685295369; x=1687887369;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1iFsQSoektVWo2hESWKZtZkktu5l6M6gOCDs+m+CLio=;
        b=X8unUwmXaH/h3wE2vKAH0v7kAxEULlYWs06gXrrD1onP5+5dU+yEVbDBKxe+vjciWR
         3bo2ljjN7sC2MulK18dJouOvrGzfsCTTDqdR6oARCQG8QlU4QXg5GNv5DgEvhUP4BUsW
         O5QszAQIwGLcP2YKqqTiCyp0UI+0MdpFcZcOOFMeJqxJr0Y9bOCuDWE9wnHCZTQLgB24
         fazqhfEd55Bkc3l4Y4N9Xc4SO/jNttbUkGcpHNMJkMyBLbT+I5y5sOA4cwx83zFTuyAP
         a4sMXYdoFBM+AiN8V83ZfabEQWokuyc86Q4lZ3DCWoXVVmRwymF8wi9Dyvza3ordayGo
         8B1A==
X-Gm-Message-State: AC+VfDz6QkQOpBKHYdIa8kk3BPLN4dMGQ4r2lsrVss5ed1ADGMtcYj5i
	yuf8pKUUvFzrBFNYmy5hmDL75g==
X-Google-Smtp-Source: ACHHUZ7lEvgV+qut8uP8royK7zsV4iUfaV7/oCLmJ3rXb8INkqqpzBbYMEkUYnHNz2Acj5w8YLFygg==
X-Received: by 2002:adf:d089:0:b0:307:9f8:4f30 with SMTP id y9-20020adfd089000000b0030709f84f30mr5825464wrh.70.1685295368987;
        Sun, 28 May 2023 10:36:08 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id z10-20020a7bc7ca000000b003f602e2b653sm15334523wmk.28.2023.05.28.10.36.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 May 2023 10:36:08 -0700 (PDT)
From: Matthieu Baerts <matthieu.baerts@tessares.net>
Date: Sun, 28 May 2023 19:35:31 +0200
Subject: [PATCH net 6/8] selftests: mptcp: simult flows: skip if MPTCP is
 not supported
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230528-upstream-net-20230528-mptcp-selftests-support-old-kernels-part-1-v1-6-a32d85577fc6@tessares.net>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1220;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=v3FXhGp3rLA92fFtVw6q1d5taMCbFn424ZxPvKCJnwY=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkc5EBEEKka3mFHa3kBEbaRn4dGVLd1UAKUl96L
 82Sf1dCsKqJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZHORAQAKCRD2t4JPQmmg
 c1fiEACI6DNewO2JBxnZ2diUvafyiEsds+h9elQVCf6sS6J1NOthez6aPSn+CBp8SNYjQ/13MRX
 RdktsaoaNMf69NKQGm1zIaTlU1e3AJaiwqx6bJcCAnMqEc+BlP+RuV51/AB8F6hc5ORiSHKvzqd
 sGvFwhICaF8eEbYv+Mew0fqSQexJdcHy9ABHQJEvsWJa5pdSv8Ojl7OWPakE3ldqpSH0L16oBxs
 ipY3qO+0JkBdpmCBLCbUE6ilkjovLurvmkXpK0k0t4e3aRpk0FhH1mUiTnlj4uaByZHJH53UTwU
 xuGvAcxiFpg9GCkVQAf8A4peVDReZUlLhw91ftPg/uJJSGly4gfKvaopDA5K9U8+Uj/El4tOQag
 vVToFZ4asX/o9rThmFzMXJHakRmiufxZG9midl0dScVB0EzsJgaYdPT0LB8h2i19vJUttGkvREo
 pwfLpSrKgdgwBpK79NU/1JHINZwBJ/qdlPuRjl1bA7rUiYl5e8c1+p9ZoYUCSIX11tdgh4HXsja
 nU+qmEV4i3xAn0QQwjWSKhPE9atWttMQrl7MC+TtdmRm1stdLJu4NgSPzfGOt8hjWVnac4h3Afk
 O4dOniWiXgsNnzp1IUflixhjCQ0gnqP+aujJEtMtUPRRgp4dWgLTIFvLWcyVttkK/O/RqFzhnEF
 5YxSNMA7W66gO2w==
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
Fixes: 1a418cb8e888 ("mptcp: simult flow self-tests")
Cc: stable@vger.kernel.org
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 tools/testing/selftests/net/mptcp/simult_flows.sh | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/net/mptcp/simult_flows.sh b/tools/testing/selftests/net/mptcp/simult_flows.sh
index 9f22f7e5027d..36a3c9d92e20 100755
--- a/tools/testing/selftests/net/mptcp/simult_flows.sh
+++ b/tools/testing/selftests/net/mptcp/simult_flows.sh
@@ -1,6 +1,8 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
+. "$(dirname "${0}")/mptcp_lib.sh"
+
 sec=$(date +%s)
 rndh=$(printf %x $sec)-$(mktemp -u XXXXXX)
 ns1="ns1-$rndh"
@@ -34,6 +36,8 @@ cleanup()
 	done
 }
 
+mptcp_lib_check_mptcp
+
 ip -Version > /dev/null 2>&1
 if [ $? -ne 0 ];then
 	echo "SKIP: Could not run test without ip tool"

-- 
2.39.2



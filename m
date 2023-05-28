Return-Path: <netdev+bounces-5965-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E2625713B49
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 19:37:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 630F61C20972
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 17:37:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1503E6AA4;
	Sun, 28 May 2023 17:36:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0903D6AA2
	for <netdev@vger.kernel.org>; Sun, 28 May 2023 17:36:18 +0000 (UTC)
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85335100
	for <netdev@vger.kernel.org>; Sun, 28 May 2023 10:36:09 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id ffacd0b85a97d-30ad99fa586so2280906f8f.2
        for <netdev@vger.kernel.org>; Sun, 28 May 2023 10:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1685295368; x=1687887368;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AX0sr/PbmfXMRT0E3FKR7vPpjL8rwaKTtVDAJqhMqgY=;
        b=EY+2YTKvShTyvWZoi+qEzRbIh7STaLYSxenN389oH5pyQ3B+M6jSpEI8GNpm5CpraP
         09RcCudi4w5jNwK0MOlckZAwUlm3hacHFR2OmuNNhyTHNaHquEseO6Ua2wNKnOf7z8vk
         0CQjiXnQ/ulYYqxXYEuZqqg3QynYsLTFWrf+qBfEj5MMiGGAuDhGJOato0aChAVOWYmY
         FBAXMmloa0jrqH7V01MYLn0CyzCw0qOqqxWAvMCn/A76Wmh19/J4Z3BLwlcTCizWspqZ
         bp9zeWc+d9MSA1swO9j8agu031xbqLLEpAZC/aHWFh5TUsD1PZUELh/BQfcLoWRRoXif
         Nhyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685295368; x=1687887368;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AX0sr/PbmfXMRT0E3FKR7vPpjL8rwaKTtVDAJqhMqgY=;
        b=DZE6xiJqBo6NsHkHjyqJYuGNAgqzI0FRqQsDnJ/pmDJ6Z+zDLj7s9b5EuP7ge9L2oZ
         uPLK2RqCOi75//hMKlyseZvp9RbxspYgBxU6Hp9YgO7cAX3tO0nNcwuvAj0xn7dI1b9Y
         dNuzwPM/fS0/qwsmaqk6pmx/LS6TFj0H8KeNdWMYUiYStYHxk4AYHiu4GX9+GJS3Epfa
         pRI7gP8e1reS39CSjEmn7Vk4McOD/StEyGGIxaCHdf8nAp9rDC5rBNsVcEwO5ajFcWWm
         tX9QOUryQCrHKVzRRwb/SdXnlgQcukSCg0+fZhLCssA/hMddYl1UOiflK6r2J83XIG6P
         bLCA==
X-Gm-Message-State: AC+VfDyH7xqC+nRz32vu5/zhBNUs2D5d2gYFi2kZGY+UYNkZGBg1+S7D
	WBbhPcnthKRMj6FfD0bByNE3oQ==
X-Google-Smtp-Source: ACHHUZ7KAR8RXl6O+5H4v9gJJWlzSY/1hej76B1j5B7n8S6haKDU+hOJztCZ51pMTxrr47XPx0UCdg==
X-Received: by 2002:a5d:4ac6:0:b0:309:54b6:33b0 with SMTP id y6-20020a5d4ac6000000b0030954b633b0mr7315737wrs.44.1685295367931;
        Sun, 28 May 2023 10:36:07 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id z10-20020a7bc7ca000000b003f602e2b653sm15334523wmk.28.2023.05.28.10.36.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 May 2023 10:36:07 -0700 (PDT)
From: Matthieu Baerts <matthieu.baerts@tessares.net>
Date: Sun, 28 May 2023 19:35:30 +0200
Subject: [PATCH net 5/8] selftests: mptcp: diag: skip if MPTCP is not
 supported
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230528-upstream-net-20230528-mptcp-selftests-support-old-kernels-part-1-v1-5-a32d85577fc6@tessares.net>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1203;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=2XieG7aH+1H6UjQufr7rYq3MJt3yeF3n93mM9qxyF/k=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkc5EBVsy9726j4G9jjMrxnRAZd2w+eAda1JbfZ
 BSSWuPepeaJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZHORAQAKCRD2t4JPQmmg
 c90rEADZxBUPh9w2TPif0/EokmXKrf1ty8a3RmkE20WglnJTTAowpUPzIxTQnA2mMH6G4T+iD50
 f/vCtbr8xigVWUf2mFE8RY+ijac4XnuctSmaj1SY8L3xTE+3+1k6G/XC8COwJrpcQVE9o5i98Z7
 gO/j8Oh47+FMeaUB/xyXEO8T14bbG8w8JnRpy6n3olvwbvMqtuVGEre7BoyuvWpV05Nqmz1DLA0
 S5fYqrf1BHCmobd7JGoiFlIiYkuaxee9qm/fi/dEIw0QUgVMq8NSVouzi4kIp6WbPvmn4lMJdre
 iiAvIO84IN7unWkXg9nVefl8u0x22W7IYsPAByQUSRyIBYAghF0S1UouHO952bCpC0ZF+Nczx25
 Rzs5Q2vJgOAdZR3hutsfSeO5YGeS897blfYpL8xW7EDY+CKDvzHaVnFHDvyt2Mc5dcOWXgPUhoE
 71AfIOvO+8qs6f57QGqn8T/Kg8EvtrWYXxVbx1iIqi6Q/CkqNlvaLi/KenhiXDOQyO8Fza6Y8KC
 WBcZvy3JNBOGQA9VZ6d+05SB9vJta8QyZkiSoO6zkVwjsYt1NLobmuv2nkXCHYpaRJzetj3tC7u
 tW3xlwCtqwXYOAnOPq65RmKtfv73nLWaJ/lsB1GwqXXfxjIwvmrfAXaM4B6eVAunAEM6sNY84Bj
 VbNoHru1F33zdYw==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Selftests are supposed to run on any kernels, including the old ones not
supporting MPTCP.

A new check is then added to make sure MPTCP is supported. If not, the
test stops and is marked as "skipped".

Link: https://github.com/multipath-tcp/mptcp_net-next/issues/368
Fixes: df62f2ec3df6 ("selftests/mptcp: add diag interface tests")
Cc: stable@vger.kernel.org
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 tools/testing/selftests/net/mptcp/diag.sh | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/net/mptcp/diag.sh b/tools/testing/selftests/net/mptcp/diag.sh
index ef628b16fe9b..4eacdb1ab962 100755
--- a/tools/testing/selftests/net/mptcp/diag.sh
+++ b/tools/testing/selftests/net/mptcp/diag.sh
@@ -1,6 +1,8 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
+. "$(dirname "${0}")/mptcp_lib.sh"
+
 sec=$(date +%s)
 rndh=$(printf %x $sec)-$(mktemp -u XXXXXX)
 ns="ns1-$rndh"
@@ -31,6 +33,8 @@ cleanup()
 	ip netns del $ns
 }
 
+mptcp_lib_check_mptcp
+
 ip -Version > /dev/null 2>&1
 if [ $? -ne 0 ];then
 	echo "SKIP: Could not run test without ip tool"

-- 
2.39.2



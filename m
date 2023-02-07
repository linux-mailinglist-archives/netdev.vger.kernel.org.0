Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A62968D80E
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 14:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbjBGNFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 08:05:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232133AbjBGNE7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 08:04:59 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D97035246
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 05:04:49 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id h3so5644326wrp.10
        for <netdev@vger.kernel.org>; Tue, 07 Feb 2023 05:04:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a0Y8tyC3pK8u+WZc5J76WveIdzupFDlp0O56ysPrgH0=;
        b=3WoqCjTezdZ2HvWTXpQgaeHBror8v9K25Pq7QMpyvy9K+LXX+CluHaMFg0NR+NHRdd
         UzX24bpsqKjYuM4wa1XKMkFZM5FT5JcoY9KqpTrz5YPzDmxtMT8lUXfhOcTVGfaBLI/c
         TnpYs22zIw/Sphcbm2C57LK+UWuNKaLKeQoLdLwAxz1FwJSnK5Ax/HoBeSLw3nGtR4uv
         PWRkT/DoTbvXfXOfLlzeRc/0We/IjvG+HxeidLe84FG9HelSlOI0wtqgNWsABYoshlEv
         NVnhpyVOos7i3+UXtlZuuMPF/G0qqhZ+BqOaxmJqtDHU5QWdAOSuIoxeZt267tdR7AVh
         hD0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a0Y8tyC3pK8u+WZc5J76WveIdzupFDlp0O56ysPrgH0=;
        b=T2pVQa3HyFgehJoEq7BTSpAjF4rDefhxUgFEFjN1YFXXNkG6DYjU2rfKRdKoYNTWn2
         1wwEPcko+FpVBJmzykXRBFuWFD9Rlbg81Ve2k0F2gfBUQ7TYDLXT1zYNU8vKnujsoRRa
         dNAqZSPW2kKBN7NQ2/83XLOqNuBlTuOKEq1KAWy41zq4/nlpTwsVFCIEJUr+yKslDDV/
         YdEejnoQ5WWsAHFjTkxMWdMZkfvmHOWIXEVMBaPcqubI/jkdog4KMajSxNgQY4MnDjJT
         G/ZC9fazChRh0P9lJ+evWt1c+BR0vxUSi1IV0UgTD71nCeSsI2js9CjoROJg62ffmodX
         1b7A==
X-Gm-Message-State: AO0yUKXG0KZviiDPCe8814XmudFteAhHNnglm4Az5WIKjkepQbztx5+R
        S2CeKlyDfrLidaz46mXqFY7Q03ogk1QOKzgMXPo=
X-Google-Smtp-Source: AK7set/ScvLTSPdWOiUsdHz4wMaykHV+Tz8Bdlp16+9fg49JaRV5zs3FsOsbnWnbUkyqh01eBwmdNg==
X-Received: by 2002:a5d:54c5:0:b0:242:5563:c3b with SMTP id x5-20020a5d54c5000000b0024255630c3bmr2597223wrv.59.1675775087480;
        Tue, 07 Feb 2023 05:04:47 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id n9-20020a5d5989000000b002bc7fcf08ddsm11645394wri.103.2023.02.07.05.04.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 05:04:47 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Tue, 07 Feb 2023 14:04:17 +0100
Subject: [PATCH net 5/6] selftests: mptcp: allow more slack for slow
 test-case
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230207-upstream-net-20230207-various-fix-6-2-v1-5-2031b495c7cc@tessares.net>
References: <20230207-upstream-net-20230207-various-fix-6-2-v1-0-2031b495c7cc@tessares.net>
In-Reply-To: <20230207-upstream-net-20230207-various-fix-6-2-v1-0-2031b495c7cc@tessares.net>
To:     mptcp@lists.linux.dev, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Benjamin Hesmans <benjamin.hesmans@tessares.net>,
        Geliang Tang <geliangtang@gmail.com>,
        Shuah Khan <shuah@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        stable@vger.kernel.org
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2005;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=AILf6Fyo4IBHsevAQsi9GsBqKL6JDAR81hNQ+zuL7qM=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBj4kxoxL9EoJ2PfjY7DmpSW0mNFaszQF/VMNcBh
 wBdajIFnweJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCY+JMaAAKCRD2t4JPQmmg
 c8a6D/9my65gtxLGq2sJ2h8g+iW00BjsGojU58vmtp2V4SMJb1/Jjoq2D2uiHVVNkA5dfCKTSZk
 DL8HKJ44dOEC4c7zWRZpRlB8OmCkn29yxwc70IXHjlUJUAdjHgAY65uNCYs78i281cj655/DDJv
 zRHvr5Ui+3RPE3t5pwBOhzfGOs10CKc2BYW14J7tITTBf/2o8wLrRtiuUNU8rIFPurDPVB6YUUt
 R4Jvrt9xjzopjxKfDfR7jXFVxZlU3k2N9fKlb/S3WBkO9+O8oNDnOYH9zcUsEXPQEDd8NLEgv2F
 dhIOWjfDgh6/YUM1v8eNt6Lmq81HNLGqZ7zYQxYzeXxVnlFfQEmkHCqmNrhHzK4gtKWeeq1WpJW
 2J/tfS6B66PQWZGEnZ6QStdBEPpoB588DSz2eQ60tO7JI4H7KsmbNLbLxJB/llUPndeN7Hrop2R
 8rW1UOSJR5kZ52CjNw8PjtNm/SnRNZjR+MGjNKEi5RMDjgI7d5dP+1o3iG+VMt5QLJ5/QbBoQpr
 IhI94VCeiWb8+O4X1i/rPCali5u3Cxav9/eiZvwJhZu4f+ghZQLigj0nMJaUxsEg7zcbr9vU96i
 PogIwvnJIleTjFvgnQT5a67ck+n98yLx0sGytl0rmqZU0mlC37FnHGU3V8Egzcg4yEVxG0RdxnG
 SC1b0DqfqERZjVg==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

A test-case is frequently failing on some extremely slow VMs.
The mptcp transfer completes before the script is able to do
all the required PM manipulation.

Address the issue in the simplest possible way, making the
transfer even more slow.

Additionally dump more info in case of failures, to help debugging
similar problems in the future and init dump_stats var.

Fixes: e274f7154008 ("selftests: mptcp: add subflow limits test-cases")
Cc: stable@vger.kernel.org
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/323
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index d11d3d566608..f8a969300ef4 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -1694,6 +1694,7 @@ chk_subflow_nr()
 	local subflow_nr=$3
 	local cnt1
 	local cnt2
+	local dump_stats
 
 	if [ -n "${need_title}" ]; then
 		printf "%03u %-36s %s" "${TEST_COUNT}" "${TEST_NAME}" "${msg}"
@@ -1711,7 +1712,12 @@ chk_subflow_nr()
 		echo "[ ok ]"
 	fi
 
-	[ "${dump_stats}" = 1 ] && ( ss -N $ns1 -tOni ; ss -N $ns1 -tOni | grep token; ip -n $ns1 mptcp endpoint )
+	if [ "${dump_stats}" = 1 ]; then
+		ss -N $ns1 -tOni
+		ss -N $ns1 -tOni | grep token
+		ip -n $ns1 mptcp endpoint
+		dump_stats
+	fi
 }
 
 chk_link_usage()
@@ -3069,7 +3075,7 @@ endpoint_tests()
 		pm_nl_set_limits $ns1 1 1
 		pm_nl_set_limits $ns2 1 1
 		pm_nl_add_endpoint $ns2 10.0.2.2 id 2 dev ns2eth2 flags subflow
-		run_tests $ns1 $ns2 10.0.1.1 4 0 0 slow &
+		run_tests $ns1 $ns2 10.0.1.1 4 0 0 speed_20 &
 
 		wait_mpj $ns2
 		pm_nl_del_endpoint $ns2 2 10.0.2.2

-- 
2.38.1


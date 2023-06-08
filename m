Return-Path: <netdev+bounces-9276-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 53165728590
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 18:42:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A94511C2104D
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 16:42:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA7731DCB6;
	Thu,  8 Jun 2023 16:39:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC6A1DCB5
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 16:39:40 +0000 (UTC)
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC24735B8
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 09:39:18 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id ffacd0b85a97d-30ae61354fbso653306f8f.3
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 09:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1686242346; x=1688834346;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=25ZaF3JsFYErEFoIbwPYOVDqmdE5+qzB+30gx62T0y8=;
        b=bLE4kzr1bCQ0rzhbxY0Bt2OGLWYWKUZUwOYk/Uv3yrqZC4kbVx5rg5DiQzYVWyZa+R
         FaZQ+3Ucbvs9Q0kYkMlU6FkvzDbO9YKspfiklSDL8M/PjPOtuK4VmxEMue8L5L4sNjwK
         Elfr4IyYglh1HPIsBF/Jo76xv6l0n6yddU7X1jLX83bevK1ZGiERRZK1v9Tb27hbH0RJ
         Jei0rFxsjerhn+sFbdi6juWAKH9iQTNQ/FTCBq3RDDe9A/2lRyL3hp+ILbQAQ5yyUQ1a
         YJjCWU888tmCtXnPr6UdXbQGkhdeKubc4ZTxnKqeLDqE33HltjLTZpa1jfJlTrtm7OVR
         TVTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686242346; x=1688834346;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=25ZaF3JsFYErEFoIbwPYOVDqmdE5+qzB+30gx62T0y8=;
        b=gs0q7+6boJtvTpMUy9+SFSI2bzqVcTXSEeC67oIqHwEEKkJYYKFvMVygTnWfmZnyEm
         2hDxTssWvACz1v95gZAas/OgwYfFb5942AuFoecc9jrKqIhNwYvaweTLWq0QEtpqcHmU
         fd+QVsE5rsY3AbH2DZijs36kRwU/SSN0fArc7+W2TWywCMT9HiwKP+zmgGQB9s/oifxl
         b/d83t/PR2eKL+cmAE80OT4prGoTy62BdimrYWLGlTvN8ZWv5u9DwykMYlJP+8XJd03F
         NdMVfEDFZrvTFOnHKCGXvK0XVBhKRsQHkjpTdEcEf5pFa9uzOgIgC2yqEA83q47UBG+m
         3Emg==
X-Gm-Message-State: AC+VfDyepOlUYzC+AN1pVYxP8VQebNedxmPk73/uGRmGNOarc3RI5M2G
	VfRsNeWxmyvJwKpL8UQHKQqGrA==
X-Google-Smtp-Source: ACHHUZ65wUtjJyqPFNvZuE1f6WBvIeZZIadiu1Pgy4n7Ffa7OL1OMBN55r1OPGcfegL0pNfZ2vA9Ww==
X-Received: by 2002:a5d:5915:0:b0:30e:438f:8ceb with SMTP id v21-20020a5d5915000000b0030e438f8cebmr7199002wrd.59.1686242346219;
        Thu, 08 Jun 2023 09:39:06 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id e13-20020adfef0d000000b0030aeb3731d0sm2038215wro.98.2023.06.08.09.39.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 09:39:05 -0700 (PDT)
From: Matthieu Baerts <matthieu.baerts@tessares.net>
Date: Thu, 08 Jun 2023 18:38:53 +0200
Subject: [PATCH net 11/14] selftests: mptcp: sockopt: skip TCP_INQ checks
 if not supported
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230608-upstream-net-20230608-mptcp-selftests-support-old-kernels-part-2-v1-11-20997a6fd841@tessares.net>
References: <20230608-upstream-net-20230608-mptcp-selftests-support-old-kernels-part-2-v1-0-20997a6fd841@tessares.net>
In-Reply-To: <20230608-upstream-net-20230608-mptcp-selftests-support-old-kernels-part-2-v1-0-20997a6fd841@tessares.net>
To: mptcp@lists.linux.dev, Mat Martineau <martineau@kernel.org>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Shuah Khan <shuah@kernel.org>, Davide Caratti <dcaratti@redhat.com>, 
 Dmytro Shytyi <dmytro@shytyi.net>, Menglong Dong <imagedong@tencent.com>, 
 Geliang Tang <geliang.tang@suse.com>, 
 Kishen Maloor <kishen.maloor@intel.com>
Cc: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Matthieu Baerts <matthieu.baerts@tessares.net>, stable@vger.kernel.org
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2133;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=1OsCicu/3vbKAvtKytrt0z0ywt61KRKpMc3STXoQXA8=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkggQawz6TxWhaJHOCzsoj7Dunv2uUMLzRPPKj2
 W1VAUZNjaiJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZIIEGgAKCRD2t4JPQmmg
 c+JJD/4nMV96ft2RW4sWQl2h5V60vSuGvtu8Fj57RT4rjI8alspOTImfQDSHV2VT0jvyK73a2NN
 JcBwh0n2KlCAcqU3yRL5Yxe36fHk2ZMJMUi4WUnc1KhOauu9GbtXDgKqgLjk50w69a2msxXrB1/
 BzP0Ih1mfkVrKPnsUwbORN+wUjE5jqy+9rP78316DlCkrihfSV9o5yXiwOJJ6qfSbqSKCSt2vMR
 vdwYxKtLLh137dUTEzaIymzu8z6ZeFw8FXUmGwXXuHHqy7tmr04vFFtP5+Pe0dwZr/1eCP4sOKy
 +bBIkjQAaz0hzN09loIChJYeJIziWtfxC8KDkpIWl/Voqdfnye2MfE7q4PLN16+Xro81sf8WhQJ
 rzq0VzRkLDWcXAeiUAgLUw0DfCZsJy33gLTuAMfLqDLW9waL/rbJLF46zo2GBmRTBDPHexcgwHj
 ht4DgOE/Mgl5XUWbcH36p2TPiR8jK8JIt7Q8+OVNlU9HUTnB1KwzF59WViYddFICF4NxK3+5s99
 I3psrh50vH4op27pQiGJkm0wibIQAqED5A8ezAJJ8XAyG3Kplv8RTlQKz4bURFrv0QEWEBKVprp
 y4qGrl3N5S/nGIe9cptNKHf0m+gS8irTTywG5VbZkeronyhJu2GKkAKYH9Ty8YAwO66aIYObQkN
 /bhqNwA09G2k+EA==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Selftests are supposed to run on any kernels, including the old ones not
supporting all MPTCP features.

One of them is TCP_INQ cmsg support introduced in commit 2c9e77659a0c
("mptcp: add TCP_INQ cmsg support").

It is possible to look for "mptcp_ioctl" in kallsyms because it was
needed to introduce the mentioned feature. We can skip these tests and
not set TCPINQ option if the feature is not supported.

Link: https://github.com/multipath-tcp/mptcp_net-next/issues/368
Fixes: 5cbd886ce2a9 ("selftests: mptcp: add TCP_INQ support")
Cc: stable@vger.kernel.org
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 tools/testing/selftests/net/mptcp/mptcp_sockopt.sh | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_sockopt.sh b/tools/testing/selftests/net/mptcp/mptcp_sockopt.sh
index 1d4ae8792227..f295a371ff14 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_sockopt.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_sockopt.sh
@@ -187,9 +187,14 @@ do_transfer()
 		local_addr="0.0.0.0"
 	fi
 
+	cmsg="TIMESTAMPNS"
+	if mptcp_lib_kallsyms_has "mptcp_ioctl$"; then
+		cmsg+=",TCPINQ"
+	fi
+
 	timeout ${timeout_test} \
 		ip netns exec ${listener_ns} \
-			$mptcp_connect -t ${timeout_poll} -l -M 1 -p $port -s ${srv_proto} -c TIMESTAMPNS,TCPINQ \
+			$mptcp_connect -t ${timeout_poll} -l -M 1 -p $port -s ${srv_proto} -c "${cmsg}" \
 				${local_addr} < "$sin" > "$sout" &
 	local spid=$!
 
@@ -197,7 +202,7 @@ do_transfer()
 
 	timeout ${timeout_test} \
 		ip netns exec ${connector_ns} \
-			$mptcp_connect -t ${timeout_poll} -M 2 -p $port -s ${cl_proto} -c TIMESTAMPNS,TCPINQ \
+			$mptcp_connect -t ${timeout_poll} -M 2 -p $port -s ${cl_proto} -c "${cmsg}" \
 				$connect_addr < "$cin" > "$cout" &
 
 	local cpid=$!
@@ -313,6 +318,11 @@ do_tcpinq_tests()
 {
 	local lret=0
 
+	if ! mptcp_lib_kallsyms_has "mptcp_ioctl$"; then
+		echo "INFO: TCP_INQ not supported: SKIP"
+		return
+	fi
+
 	local args
 	for args in "-t tcp" "-r tcp"; do
 		do_tcpinq_test $args

-- 
2.40.1



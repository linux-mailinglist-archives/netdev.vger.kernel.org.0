Return-Path: <netdev+bounces-9268-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 287A8728555
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 18:40:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C95B12812EC
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 16:40:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FF25174DF;
	Thu,  8 Jun 2023 16:39:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5029C17AC1
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 16:39:19 +0000 (UTC)
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5610130C2
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 09:38:59 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id ffacd0b85a97d-30e57e0a0c7so645793f8f.2
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 09:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1686242334; x=1688834334;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vCtw9PrOLNArcQLmhG5Q8vIjJqO0AaB9WueRBaBXF60=;
        b=tXL/drIY7f3MtCB92yRvPxZ9xCTaX0hOPfRz/rUAvsHx53Ajafcx8IOWAIXRnATmx5
         EBeRncwYce2/jEJsdbzeRIrK2fx/CZ+zIMMjt+gYCPXx3A6MWLhgG+75HI6WROhbMpF/
         0ITsOD0V79rA0GHdCoo3xIhpEMebXSJBLNJg0nKjza35dwXFC5ZGaoX5ONDQr/lg+ktC
         uPGa10QJKS3WdBp/UxUEp17BdiE/zgyV8BFPP2SSMfHJ4q9wezcj2bOfGxCB6Gfmp4qB
         cGzzra29qUE5b2qEWCD4hy2razKzweTSpRZlzT01Vy9tonmPq54hGIwnWCkfj1DK41Ta
         er0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686242334; x=1688834334;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vCtw9PrOLNArcQLmhG5Q8vIjJqO0AaB9WueRBaBXF60=;
        b=jS59caGQwJRrfCvn3hUrhr3JFDwOcRmEcqqJBtpNJG2lhcdM/r2Kq5FF5zhGxGprsl
         WGBdRLU6KCDc0aZWvWXHrl5blwojVjt4orPRrYOBvO+0XXhvE7lHS/IEaJnxxBRcYI86
         Dp6sM7OLBnUqmFlONqiztz3uE+ptueN7CvWWDAdOHo1ITv0nt3ZwFGCATVtqxYrfje9c
         VdhoIVgKvHGQZVrSfaa+aPjr+FV9bFaRuoPUDLG5nBaB+5I62aJ5VE0ZfvKEzVSyDvas
         A7BKiQqBhN7Zo6ndRuveYT+QiE2EL9uaxPbBbQv8g+iI92MZr5OT+LAGdF1wpX1M+BkJ
         yuEQ==
X-Gm-Message-State: AC+VfDxQI/mp9eoEhcQorpRtks844h8NQ9gCxWhagl0DMCb6krUUGPZs
	QnqFXHSxKNnxKmWrnMluLCPrSQ==
X-Google-Smtp-Source: ACHHUZ6UYtkV/BRN58QcXvsxCkID55O4V7in4RcbVabEQQjQB5KY5QZfk9kaARtgpAXOPbdY1XoOrw==
X-Received: by 2002:adf:fccf:0:b0:309:5068:9ebe with SMTP id f15-20020adffccf000000b0030950689ebemr6705019wrs.50.1686242334665;
        Thu, 08 Jun 2023 09:38:54 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id e13-20020adfef0d000000b0030aeb3731d0sm2038215wro.98.2023.06.08.09.38.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 09:38:54 -0700 (PDT)
From: Matthieu Baerts <matthieu.baerts@tessares.net>
Date: Thu, 08 Jun 2023 18:38:44 +0200
Subject: [PATCH net 02/14] selftests: mptcp: connect: skip transp tests if
 not supported
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230608-upstream-net-20230608-mptcp-selftests-support-old-kernels-part-2-v1-2-20997a6fd841@tessares.net>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1974;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=R/V9S3P7iUXd6JZdAlgHifqyiG2/fdAKNW6ncrS04vo=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkggQZ+289JuG8nUU0lVwm58ouXSZYgDPVcbH/c
 KhcDv70cLmJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZIIEGQAKCRD2t4JPQmmg
 c8d9D/9H5uHAzLzmBYQN1zmUUbrX52oDu3mMYbl269BVrbFew7wuA+Sv/+1Qf4YdLV8h9/FlmAB
 cVr6fplajCSksF2IVxrjpkS8593uJqyW8sP1bMDm7BVwg+DfqtrAuXTs3LPSgyw7mdyR+PyuDvq
 RC7bFC9eT5yoETH6G9ZawftQBs7YEcPdTSgFJsvUrqkrELHljjyg2SQn6os38Ts1avKQBvV5vOP
 0mgePIFX+gX3neoTW3QDZphMcrEKTe//SW2nAAfoWQVQkMdI50uuHV2wrApQ2zNU781VJnkAC08
 2uvdnJWRK02wJRaTuVOnLpx8Yx7DvsQ61yRLHZI9A0p0El+7GDlvZJxVoWYmGs/2cHNG6/4+e0U
 4bFZzNJdMFHm+MUKlUViD4DLvLGtjUALsc/i9BCldJeiwIPby5DeKGYe2Wo3CuTf6prJW406wW6
 FviBYmDijhnZzQRf888m1B3ZKUDkH1BRz1hpO4voot3exqnspAUIBk5h3ya8MuQ/zdsaYU0ox08
 qjSXqwsspyJ+XizgUzs9T/06oa2+wpsYJ5RajT+ufLzatuqUEc6NzHXscjifeb/tEfuLvFrWOZH
 2CF1DoL4QyfCcR8kM0qocA/ifR5kRU6nZFVOoKuWIhmmIkDg/VpMkTP+aXvRK1EZ+pUCjSkONfF
 62sCTo+HrCETciw==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Selftests are supposed to run on any kernels, including the old ones not
supporting all MPTCP features.

One of them is the support of IP(V6)_TRANSPARENT socket option with
MPTCP connections introduced by commit c9406a23c116 ("mptcp: sockopt:
add SOL_IP freebind & transparent options").

It is possible to look for "__ip_sock_set_tos" in kallsyms because
IP(V6)_TRANSPARENT socket option support has been added after TOS
support which came with the required infrastructure in MPTCP sockopt
code. To support TOS, the following function has been exported (T). Not
great but better than checking for a specific kernel version.

Link: https://github.com/multipath-tcp/mptcp_net-next/issues/368
Fixes: 5fb62e9cd3ad ("selftests: mptcp: add tproxy test case")
Cc: stable@vger.kernel.org
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 tools/testing/selftests/net/mptcp/mptcp_connect.sh | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.sh b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
index c1f7bac19942..f9c36c6929cc 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -144,6 +144,7 @@ cleanup()
 }
 
 mptcp_lib_check_mptcp
+mptcp_lib_check_kallsyms
 
 ip -Version > /dev/null 2>&1
 if [ $? -ne 0 ];then
@@ -695,6 +696,15 @@ run_test_transparent()
 		return 0
 	fi
 
+	# IP(V6)_TRANSPARENT has been added after TOS support which came with
+	# the required infrastructure in MPTCP sockopt code. To support TOS, the
+	# following function has been exported (T). Not great but better than
+	# checking for a specific kernel version.
+	if ! mptcp_lib_kallsyms_has "T __ip_sock_set_tos$"; then
+		echo "INFO: ${msg} not supported by the kernel: SKIP"
+		return
+	fi
+
 ip netns exec "$listener_ns" nft -f /dev/stdin <<"EOF"
 flush ruleset
 table inet mangle {

-- 
2.40.1



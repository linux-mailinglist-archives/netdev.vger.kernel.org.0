Return-Path: <netdev+bounces-9817-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF1ED72ACDB
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 18:12:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4E3CF1C20A4A
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 16:12:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D161A1DDED;
	Sat, 10 Jun 2023 16:11:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69C51DDDE
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 16:11:50 +0000 (UTC)
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DF6E30EC
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 09:11:48 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id ffacd0b85a97d-30e4eec95c8so2548534f8f.3
        for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 09:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1686413506; x=1689005506;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J9ydP1eQsAqgHsLKHcUQ2BwON2NYDSPWGMYtQ1Ca9t4=;
        b=oA+qbYnSebfwGIytxIm+hAbAgpQmiSR0y7k7IwZvHWVHfcLyNdq/7Pe2bydOMr89w6
         rJ+TP7C9DoUEqOufkKGuncKcceubQLoBSMvncnzeDUvt8EPTO5pnri7JdfsPzLF4wban
         +Fj3rj7/Nb619BgsxGSeab1J6d7td01y51KIgiMe5GHNZmpGkIDkg2YDEIe6I+NXbRmK
         rmxi+ZZd5guFeBolfgG/eotiF0latXDUar1+o28j3DFyaOkrR6zbMqrogVsVgwMzE3X5
         AtHlBjXjy77F5P5egKZ9pPZ8OMresqeBvjE5xCOLuDe0Lx4qPwphM1PM4ChLLs9kcNXT
         9IKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686413506; x=1689005506;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J9ydP1eQsAqgHsLKHcUQ2BwON2NYDSPWGMYtQ1Ca9t4=;
        b=L+zUJ/rVWgd7yrKFhpXfK9XtZ3NsxwpxEpuMRvkIjwIKgWM81Xs7SIxTLgOak9L7By
         /frwc34ZNy3yIjaw65pRLXrdHHW3UwOsl2BWu+ut06LQPWU/Ik+a2cST1ySWG4x/F/sL
         pkQO1u0FrqJHZQhut5jN5y5WvwwjPtKIORvwD7H75Q+HgMaDetAoAhBbFHFj2aSktAYO
         iNVKebNuCxgWJ55aAWzYsrBIg5xXG7DX+D7vjRZeuZOFCekyKhpjzorsNmDyKFyogQ+Z
         BVZX1dyazMh3nrfc1HqTCp4nqhN3KGFixUXHurDzeHnSFKf+gvzffnfuW3ThPZqk7DNy
         9qPg==
X-Gm-Message-State: AC+VfDwsKLwwdRJQLXhIS36A3X7ophsFxePt0RfTfhIgyy/3wyVV+ZGk
	SM7fmmLbtTOVXSog8G22YXYaWw==
X-Google-Smtp-Source: ACHHUZ6zSmlMj4S5vqJgjbIErmm5GSFGZntnUD8JlLEXtBGF6z8EUPMlDeZKtPE2DxT+DSqRpxWt/Q==
X-Received: by 2002:a5d:474e:0:b0:30e:57e0:a0c1 with SMTP id o14-20020a5d474e000000b0030e57e0a0c1mr1499029wrs.65.1686413506385;
        Sat, 10 Jun 2023 09:11:46 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id u9-20020a5d4349000000b003079c402762sm7431145wrr.19.2023.06.10.09.11.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jun 2023 09:11:45 -0700 (PDT)
From: Matthieu Baerts <matthieu.baerts@tessares.net>
Date: Sat, 10 Jun 2023 18:11:36 +0200
Subject: [PATCH net 01/17] selftests: mptcp: lib: skip if not below kernel
 version
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230609-upstream-net-20230610-mptcp-selftests-support-old-kernels-part-3-v1-1-2896fe2ee8a3@tessares.net>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2806;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=Q8eml6N8B8SHqHUyo58PbB8e7k7W1vtr1TjWM9dwoo4=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkhKC9JRSHzNnZd6ZUPuZjmNO0nqMQC/ojooypf
 JOnOuLDuUeJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZISgvQAKCRD2t4JPQmmg
 c4T7D/wOvWXoyVAs+hN2WciF7uslyfB9gavueCBHNFbzl01dFsN1JywDZ9zIpZoP3ByzGjk8NiY
 7YTSYn4Yczt+idBlGi2hxR8s0QicXm2W5VVCTIb3flrnLBqcYJDoBLHzKkwgXLLkgw+Gmi2d8bt
 2EeKlmb7ZMs7nWm3rK9jNH3I2ictUSATF/V9InFMGjTegciIDqKHPrU/YIGmfHP78pRzGL+RNEi
 POKMrxCElw8nsFK1cKIxREna2mJzNnXzgTZsU8AWLr2bUVn1Bl5cCXc8qgxChvrbcr4wSmZqh2d
 jQ6i/xV21a2Gruz7k0E0CchMHhf6SD4yr2xrazIfHSTHMnEyBIYLx9RzqlypubTWqRIp/eqNNKq
 BtrMcxb4EMqVePVeV+3l4A9/2RasvK61CjILdKAbtTuGSXatFI04MykeyXh4LCCAB/Z2BYk2KjE
 AnCLmtLxhtKhxc7vX4ulxttpPc2XNMQrhRfAxDgBmZz2xEtKmbFUA08MNqEjtTxfk5Zmrcpw4NX
 ZEyOxcjt6aFLVM1dYIBze1fFsuLDMNlsaRlPhItzCmbRogvwCJUYs07yLJXvnfDHN4GDzkyy647
 YLORR3HiMWsJammnWTvsH0V/a7O5z/NN1GwWj7vzeTzuxx/bggHLx21X2YG31DDVU043HD44WSw
 I4h+qrvGWX7OtsA==
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

A new function is now available to easily detect if a feature is
missing by looking at the kernel version. That's clearly not ideal and
this kind of check should be avoided as soon as possible. But sometimes,
there are no external sign that a "feature" is available or not:
internal behaviours can change without modifying the uAPI and these
selftests are verifying the internal behaviours. Sometimes, the only
(easy) way to verify if the feature is present is to run the test but
then the validation cannot determine if there is a failure with the
feature or if the feature is missing. Then it looks better to check the
kernel version instead of having tests that can never fail. In any case,
we need a solution not to have a whole selftest being marked as failed
just because one sub-test has failed.

Note that this env var car be set to 1 not to do such check and run the
linked sub-test: SELFTESTS_MPTCP_LIB_NO_KVERSION_CHECK.

This new helper is going to be used in the following commits. In order
to ease the backport of such future patches, it would be good if this
patch is backported up to the introduction of MPTCP selftests, hence the
Fixes tag below: this type of check was supposed to be done from the
beginning.

Link: https://github.com/multipath-tcp/mptcp_net-next/issues/368
Fixes: 048d19d444be ("mptcp: add basic kselftest for mptcp")
Cc: stable@vger.kernel.org
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 tools/testing/selftests/net/mptcp/mptcp_lib.sh | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_lib.sh b/tools/testing/selftests/net/mptcp/mptcp_lib.sh
index 29b65f4b73b2..f32045b23b89 100644
--- a/tools/testing/selftests/net/mptcp/mptcp_lib.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_lib.sh
@@ -76,3 +76,29 @@ mptcp_lib_kallsyms_doesnt_have() {
 
 	mptcp_lib_fail_if_expected_feature "${sym} symbol has been found"
 }
+
+# !!!AVOID USING THIS!!!
+# Features might not land in the expected version and features can be backported
+#
+# $1: kernel version, e.g. 6.3
+mptcp_lib_kversion_ge() {
+	local exp_maj="${1%.*}"
+	local exp_min="${1#*.}"
+	local v maj min
+
+	# If the kernel has backported features, set this env var to 1:
+	if [ "${SELFTESTS_MPTCP_LIB_NO_KVERSION_CHECK:-}" = "1" ]; then
+		return 0
+	fi
+
+	v=$(uname -r | cut -d'.' -f1,2)
+	maj=${v%.*}
+	min=${v#*.}
+
+	if   [ "${maj}" -gt "${exp_maj}" ] ||
+	   { [ "${maj}" -eq "${exp_maj}" ] && [ "${min}" -ge "${exp_min}" ]; }; then
+		return 0
+	fi
+
+	mptcp_lib_fail_if_expected_feature "kernel version ${1} lower than ${v}"
+}

-- 
2.40.1



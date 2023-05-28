Return-Path: <netdev+bounces-5961-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 33188713B31
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 19:36:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E2546280E71
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 17:36:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA09F5692;
	Sun, 28 May 2023 17:36:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90BF4568F
	for <netdev@vger.kernel.org>; Sun, 28 May 2023 17:36:10 +0000 (UTC)
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D449C9
	for <netdev@vger.kernel.org>; Sun, 28 May 2023 10:36:05 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-3f6dfc4e01fso26771025e9.0
        for <netdev@vger.kernel.org>; Sun, 28 May 2023 10:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1685295363; x=1687887363;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Gw5Qo+KgJFEsvwVTc4nzprJkJaDeXrbywxB/oWvh/40=;
        b=g6ggxEtGVEtUCktAAhTgXY3WVZk1YMCG1UgXrLSNHm58s7+ASvPprSVWRIYVvaoTEy
         jWJaBEk62igYLdKu6NMhExmstadX52pSZZ4C7P17urQqKz6vrHQgZfFFyTzkmwcbC6iC
         N32nUEMfi1vjQC7lnLw3o3xNccWCb7GCnjWhZDndpp1jZV0mTKMB2uu71mBaJxoOGeSU
         5n7dxkjAoL3SjhHmts0+D7Bw1P3/OiJDomd7LCwr900M/fJf2pUTkunlPncWbh4jNqLQ
         BphtUD5VSq7l2P9MjaPJyh+0bYjT+3yAG51sg/7pGGrIP7HQ6zvU2/P2Lo20/4pAwHXf
         7UqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685295363; x=1687887363;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gw5Qo+KgJFEsvwVTc4nzprJkJaDeXrbywxB/oWvh/40=;
        b=G7VzPakSPLc9HoPbq3CNObSY5HAJ2oadzPFA2jrnh3bYebay3lAFTH+Nhfstb3RgwS
         NrMLtkCbhAkoIiIz5C+bWzzoYBygj3O90TI2SV1HHAAMyf975+PhHWuQCoW0HcpKeHTz
         OIDPRKaIOE03/VGsRiFK8KnZginNIDM8IqZ9t7JnKLFDC55K+fx0R4hKu960ZlvT8oup
         1o974k33u/IbyQeX4Fa+oFniZXyIMLmZwZOaaO1di3V0BgL1W/makfMEFCWRc0MEUqjo
         vsu5L/gugqBkoTFlOpLx9OmcAzWyBcV2humZEaWJTTE+nRXZByAKk1offbAF523ZVQIn
         HPxA==
X-Gm-Message-State: AC+VfDw9pLhKrzdzANEA6Ozzktnldrhjta3blGUu+hkgAR8cnE1/80O0
	nN7lTLAHSgkGlfDASaUIXPUP8mQzCPc+tdVikLaodQ==
X-Google-Smtp-Source: ACHHUZ4l6vEImJ2U7p4a3wLkpr9DEz+bGVkmasIbjHIzp2R+PS5BFhqAktWcU9e2ai/HRU0ZQzHUuw==
X-Received: by 2002:a5d:5750:0:b0:306:2d32:8ec with SMTP id q16-20020a5d5750000000b003062d3208ecmr7086294wrw.6.1685295363515;
        Sun, 28 May 2023 10:36:03 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id z10-20020a7bc7ca000000b003f602e2b653sm15334523wmk.28.2023.05.28.10.36.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 May 2023 10:36:03 -0700 (PDT)
From: Matthieu Baerts <matthieu.baerts@tessares.net>
Date: Sun, 28 May 2023 19:35:26 +0200
Subject: [PATCH net 1/8] selftests: mptcp: join: avoid using 'cmp --bytes'
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230528-upstream-net-20230528-mptcp-selftests-support-old-kernels-part-1-v1-1-a32d85577fc6@tessares.net>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2362;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=N4Z8l0nJwYTCI5X9SpYQxTwd5KLfEUZJxihQPgZ+eIM=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkc5EAU38GHrb57SA9i8biGZvD1yosPf830vFU2
 kNgxETB4qKJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZHORAAAKCRD2t4JPQmmg
 c3bhD/0eOYcaxbZo7nEfJcBVAs+tJ4IXpv3FvVHmUn1/aOVTceLeAgNO9teozN+LIZ6DTcF3FJw
 PsYvgKYNjVZFNTwNyGB1me7fYFhNOF0/AepoFgzv9MUlmINpeApdQjJ84g8zIbYIaCR464jIc4S
 ylLC8+NVxllBuGfyHaoVdrJWkq3LzcqlMzFfZWs8Z+c0VboUCkQGpw4JYSkInm9u4ugTevn7dBz
 f4K0S5TemszQUD11oShZvdx4Pzghwzr3cgO/SZAYzDP1a+bZp0uj+04I/7wulcnw/BNpBtrXSlT
 /Aj4ljycP8NOPEWlXYbfGWfs54hFEQ5CB4DCCH1dd90c9uTAzfWDvgAO5gO3inzJ5JJUmlYcOCO
 TV8nZ1QXdGKm1GCcUblvih6l+1Hdmy/RbNxKLUjQnR3vCEiy7VVuoaFTdjHpZ8ixQp841FlkJ0C
 If703hO+3ie610NIOkio/IFhJPiLzQ6Rjd5B5y/Id7sO99HgpbA/QIxOGUWKBlGcAD8TRz5KcYJ
 c+seEmeEGca3KBpdEIXxxSWllM85xiTpMEhuPVKSM5+HKIADsUIoJQTex5h/lNS6WGYTAElLfGW
 PnqrIrJqXqel/v/6auE+dW5kd8x+/6VwiS00tuKXxqsW6eNmQONt8sHd0ZNIbK7Z4lvDejcBzEv
 vS7pEhMJCUW8pRg==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

BusyBox's 'cmp' command doesn't support the '--bytes' parameter.

Some CIs -- i.e. LKFT -- use BusyBox and have the mptcp_join.sh test
failing [1] because their 'cmp' command doesn't support this '--bytes'
option:

    cmp: unrecognized option '--bytes=1024'
    BusyBox v1.35.0 () multi-call binary.

    Usage: cmp [-ls] [-n NUM] FILE1 [FILE2]

Instead, 'head --bytes' can be used as this option is supported by
BusyBox. A temporary file is needed for this operation.

Because it is apparently quite common to use BusyBox, it is certainly
better to backport this fix to impacted kernels.

Fixes: 6bf41020b72b ("selftests: mptcp: update and extend fastclose test-cases")
Cc: stable@vger.kernel.org
Link: https://qa-reports.linaro.org/lkft/linux-mainline-master/build/v6.3-rc5-5-g148341f0a2f5/testrun/16088933/suite/kselftest-net-mptcp/test/net_mptcp_userspace_pm_sh/log [1]
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 26310c17b4c6..4f3fe45f8f71 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -17,6 +17,7 @@ sout=""
 cin=""
 cinfail=""
 cinsent=""
+tmpfile=""
 cout=""
 capout=""
 ns1=""
@@ -175,6 +176,7 @@ cleanup()
 {
 	rm -f "$cin" "$cout" "$sinfail"
 	rm -f "$sin" "$sout" "$cinsent" "$cinfail"
+	rm -f "$tmpfile"
 	rm -rf $evts_ns1 $evts_ns2
 	cleanup_partial
 }
@@ -383,9 +385,16 @@ check_transfer()
 			fail_test
 			return 1
 		fi
-		bytes="--bytes=${bytes}"
+
+		# note: BusyBox's "cmp" command doesn't support --bytes
+		tmpfile=$(mktemp)
+		head --bytes="$bytes" "$in" > "$tmpfile"
+		mv "$tmpfile" "$in"
+		head --bytes="$bytes" "$out" > "$tmpfile"
+		mv "$tmpfile" "$out"
+		tmpfile=""
 	fi
-	cmp -l "$in" "$out" ${bytes} | while read -r i a b; do
+	cmp -l "$in" "$out" | while read -r i a b; do
 		local sum=$((0${a} + 0${b}))
 		if [ $check_invert -eq 0 ] || [ $sum -ne $((0xff)) ]; then
 			echo "[ FAIL ] $what does not match (in, out):"

-- 
2.39.2



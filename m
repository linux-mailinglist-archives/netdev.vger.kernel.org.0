Return-Path: <netdev+bounces-9275-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4039D72858E
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 18:42:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 883DF1C21068
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 16:42:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A33D174FB;
	Thu,  8 Jun 2023 16:39:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D4A19E5A
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 16:39:38 +0000 (UTC)
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17ACF35AB
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 09:39:17 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id ffacd0b85a97d-30ae5f2ac94so863147f8f.1
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 09:39:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1686242343; x=1688834343;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0SeIVqfDIJ5M+hwTQOEMBeQrB+d7nlSQcKhwVwTtbA0=;
        b=PKE5oK5KGY4ma9jGzewDadwzaiA2O8Ub9z2aWRW2Zw0Ab6RQDseA2a9nVCtiA1wgTy
         pt9Z+swTeoNTXsnQ0hxjkmu3n7rfs9QIL8/9kQ9w0XnWXGljXuJgUcJ4lpugzv45hbw7
         SmfBpvPfYm2GHr2bswOyyeIL/8ju134caaLCZOXAyvyJIKSBtL7dLg7MYGf956EsuJgu
         G61TrWm12iUPzxCXs4mWdbYov0BApBshQmldY5zlQojhAzNXy6izScgbF8LQZWlZB90g
         kscAL4Rwr1tW2hr63vMn+cKd0fqk126qFLwkw4spcRQ9yvxRY1PE1Yov0CZYYXgJAsV4
         uO/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686242343; x=1688834343;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0SeIVqfDIJ5M+hwTQOEMBeQrB+d7nlSQcKhwVwTtbA0=;
        b=bq7PdlsWzgIxs3fyzzTrrJYBAaV7xRfY5Zt0rI0tJkX2rUOtq0XJPEjew7p+uocbvu
         YVw7D1u8GAi8txT7RKV+0KGHMz9gOeKg1JEApS/XZ3AkJYY/yD6oB4qLSWVoXWTCUK8N
         W2itSRQd3xHF0NmofuK/LKMaoC7iv2dmuc1ULyoiJtlBKLLjCnPOnDeay/rLxG1xxG8F
         X28f2KHO71BFlA3qwzOiYV7oFwQrW3BAiTzEt8Vvyxd7hfSFo93Ifnq56YEiWN/vOhq8
         +CDdMeAn9LFtkCWr191dZFhz7dJc8HRCr/oGIoXVgYVrFHWjgPGRlTPdu+DG0mJeLdX/
         Eapw==
X-Gm-Message-State: AC+VfDzt4XnFr8yj+mfYuH3cwxwr5GiFgzynPwGJVzORALkhfTwpWK9L
	87SJ1Kcy7z4qO7Wtn2q7y/iH1w==
X-Google-Smtp-Source: ACHHUZ6yurkoDraX+JVU46TTVJ2MRrt+TCpcI/s2PSIbLlBZf42OvA/DRkeZVRZAV3vbPyQNmtxxtQ==
X-Received: by 2002:adf:d083:0:b0:2dc:cad4:87b9 with SMTP id y3-20020adfd083000000b002dccad487b9mr8050050wrh.68.1686242343680;
        Thu, 08 Jun 2023 09:39:03 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id e13-20020adfef0d000000b0030aeb3731d0sm2038215wro.98.2023.06.08.09.39.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 09:39:03 -0700 (PDT)
From: Matthieu Baerts <matthieu.baerts@tessares.net>
Date: Thu, 08 Jun 2023 18:38:51 +0200
Subject: [PATCH net 09/14] selftests: mptcp: sockopt: relax expected
 returned size
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230608-upstream-net-20230608-mptcp-selftests-support-old-kernels-part-2-v1-9-20997a6fd841@tessares.net>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3171;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=GQeNP3ltipPT1KJXTiCPa8omelDx4jZnpR+BwG9Is00=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkggQa5Qov3Fm/bDBsD6CR3oljXLClang/MHNLi
 wAtvYGLcoyJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZIIEGgAKCRD2t4JPQmmg
 c+syEADSQGmhuKC+jL1Bbph2uy7m/3SgiQ/Rjsewr3kgOOoWSkI0PiBA9l3d33m5A3stWa+m5cW
 4h3QM4CZV2Q0OMhe+9D3NxlwodEyXVAdoR0HbHYTb2587u4XQe0yQuqC1J1VRLZZWWTDw5HSYLd
 LAM+aTCwDUVEhscCJBavOWcyhzife41OhauVMOvwuICpuADLAGoGRIyoT8ulyodHphBNY1wgTjl
 BUu2xZxX+/xnjpIf3vfPqna4w7rcOFpjjSW4unyNTPbyfvdi4MGSeGb9quzTgeVxRoM39qfXd2M
 /Vk7jy5bS7R+raVsSijiU2L0bQvK1MrHdOegnkX8yjZjdQ1sD0PzHPZ82s3g0zbDw4ybrxgQ0wq
 jQc2L8ZE/oVmIEEDPF0/Cb7DofA3XYBRdss8FZFxIONIUDDzuucHgOw6ceu0ehHtklC9AsddAIK
 /2m0h6ZPAiUbU7m+oV/xODXdOPJl1xsTMZ+gT9Ty8ws7S+Jqg2cpFDkn/ArszNepyylYfqnWkeb
 aBng4kd+RggojDawfTjbCN1nv3Cdvi7DD5xNVyIPzQviT+pOsI/IrTLn3g7BRsuIuTIPLVHfkcb
 ujwm75fK61gPmojrfB0EHbQOcGG7rMpLESGijU/MZjfbn91o+e0An9tPVwVr+DUHkei7JyqVTZ5
 LrK04fBk+bt8vfQ==
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

One of them is the getsockopt(SOL_MPTCP) to get info about the MPTCP
connections introduced by commit 55c42fa7fa33 ("mptcp: add MPTCP_INFO
getsockopt") and the following ones.

We cannot guess in advance which sizes the kernel will returned: older
kernel can returned smaller sizes, e.g. recently the tcp_info structure
has been modified in commit 71fc704768f6 ("tcp: add rcv_wnd and
plb_rehash to TCP_INFO") where a new field has been added.

The userspace can also expect a smaller size if it is compiled with old
uAPI kernel headers.

So for these sizes, we can only check if they are above a certain
threshold, 0 for the moment. We can also only compared sizes with the
ones set by the kernel.

Link: https://github.com/multipath-tcp/mptcp_net-next/issues/368
Fixes: ce9979129a0b ("selftests: mptcp: add mptcp getsockopt test cases")
Cc: stable@vger.kernel.org
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 tools/testing/selftests/net/mptcp/mptcp_sockopt.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_sockopt.c b/tools/testing/selftests/net/mptcp/mptcp_sockopt.c
index ae61f39556ca..b35148edbf02 100644
--- a/tools/testing/selftests/net/mptcp/mptcp_sockopt.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_sockopt.c
@@ -87,6 +87,10 @@ struct so_state {
 	uint64_t tcpi_rcv_delta;
 };
 
+#ifndef MIN
+#define MIN(a, b) ((a) < (b) ? (a) : (b))
+#endif
+
 static void die_perror(const char *msg)
 {
 	perror(msg);
@@ -349,13 +353,14 @@ static void do_getsockopt_tcp_info(struct so_state *s, int fd, size_t r, size_t
 			xerror("getsockopt MPTCP_TCPINFO (tries %d, %m)");
 
 		assert(olen <= sizeof(ti));
-		assert(ti.d.size_user == ti.d.size_kernel);
-		assert(ti.d.size_user == sizeof(struct tcp_info));
+		assert(ti.d.size_kernel > 0);
+		assert(ti.d.size_user ==
+		       MIN(ti.d.size_kernel, sizeof(struct tcp_info)));
 		assert(ti.d.num_subflows == 1);
 
 		assert(olen > (socklen_t)sizeof(struct mptcp_subflow_data));
 		olen -= sizeof(struct mptcp_subflow_data);
-		assert(olen == sizeof(struct tcp_info));
+		assert(olen == ti.d.size_user);
 
 		if (ti.ti[0].tcpi_bytes_sent == w &&
 		    ti.ti[0].tcpi_bytes_received == r)
@@ -401,13 +406,14 @@ static void do_getsockopt_subflow_addrs(int fd)
 		die_perror("getsockopt MPTCP_SUBFLOW_ADDRS");
 
 	assert(olen <= sizeof(addrs));
-	assert(addrs.d.size_user == addrs.d.size_kernel);
-	assert(addrs.d.size_user == sizeof(struct mptcp_subflow_addrs));
+	assert(addrs.d.size_kernel > 0);
+	assert(addrs.d.size_user ==
+	       MIN(addrs.d.size_kernel, sizeof(struct mptcp_subflow_addrs)));
 	assert(addrs.d.num_subflows == 1);
 
 	assert(olen > (socklen_t)sizeof(struct mptcp_subflow_data));
 	olen -= sizeof(struct mptcp_subflow_data);
-	assert(olen == sizeof(struct mptcp_subflow_addrs));
+	assert(olen == addrs.d.size_user);
 
 	llen = sizeof(local);
 	ret = getsockname(fd, (struct sockaddr *)&local, &llen);

-- 
2.40.1



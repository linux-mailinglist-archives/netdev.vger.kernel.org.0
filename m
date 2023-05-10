Return-Path: <netdev+bounces-1478-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CB576FDE4B
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 15:15:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D54A12814A6
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 13:15:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2109012B70;
	Wed, 10 May 2023 13:15:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3FC6FC3
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 13:15:49 +0000 (UTC)
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC0D0E5A
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 06:15:47 -0700 (PDT)
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 44E1B3F4A6
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 13:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1683724546;
	bh=a4+m+7dc0UGwNdAzW/ds7TFtd8vcV7ga23RII0fZY0k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
	b=q3cXHBnAWbZkw9aLwkdg3gpfu3wdU8n0VlsIMsPxghYLXZ5D2DtHBSS+2/byCppSm
	 +WJIubF6gQpmBGFYEOrt87XxVWjYoAdzv5VhaTixOG0A800Oq+uFovJpK7577+BmY7
	 Tru/Gp3DjAW+YMNNAcJmiY8HMYZNIZY3yWpG10kQCjUrka5PDQnp7DyAeGitUwoMeS
	 Xt6aDlzcKunDUI/X4goqLNCiTe4FEYWmCQH9SHMJQQhSc48ikgHQEcHyk7cmdbxjJo
	 IK6FhzizgKlUXDI5ehuznyc+zt769E0VP+cU3Lkj5GgV22Logs/xTkPmn/wUzBVRpX
	 mcSw6ohvT3trw==
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-50de84a3861so86565a12.3
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 06:15:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683724544; x=1686316544;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a4+m+7dc0UGwNdAzW/ds7TFtd8vcV7ga23RII0fZY0k=;
        b=DcfJznPcW28OElNpsOm81lDHdtLnrXDShornlLZNOjt2AYyRaOnQSpYdwSyOT67TMz
         hOIupfwTYP/jNKD/8Df5iiI9kwZbsprN/OhQe2I0Xiz7KHwgGtunV2yiXAIV76unhVh0
         Wq8UJiREdMwr1mfHZ35IQppGKnAG0IpwtPQMDFrDWv16oL9+ochUotDZVgbb/wwi+cB/
         9NWPIpEL+qKVbpLp7qaCBpC2SGK+NKvrRkBZc4A8i1ZN3XJoZyKOwkKw83ioVGq/rBnY
         bziqCg2w/sYQRHuyNv/ZbTJIojBPzFjkO0oD5fiJnrBE35Hrc+O2scokUrSB4VRiFCX3
         YDpw==
X-Gm-Message-State: AC+VfDwuhURY+UR2x2u1FAqJ1uLc8DxfCddEXuPyHCWMMRQER4zmeJAJ
	edgu4JELDDFDQ9STDsrKR4NkGCqMKbzTY6efFwKDKHs+W0D54atWdjImtlRRXdNi24xAzorxQ8R
	iQqOiuY+pNQG+kjpAoiEIiqA/gMOeG1BDcg==
X-Received: by 2002:a05:6402:10cc:b0:502:2494:b8fc with SMTP id p12-20020a05640210cc00b005022494b8fcmr12892374edu.7.1683724544608;
        Wed, 10 May 2023 06:15:44 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4hrt4igaxYX0S+3W3IYOURDdu03frwLJLDVV2qaMORLrSqzNtHujKSnoTSphWi+E7qjc5YGQ==
X-Received: by 2002:a05:6402:10cc:b0:502:2494:b8fc with SMTP id p12-20020a05640210cc00b005022494b8fcmr12892359edu.7.1683724544287;
        Wed, 10 May 2023 06:15:44 -0700 (PDT)
Received: from amikhalitsyn.. (ip5f5bf3d5.dynamic.kabel-deutschland.de. [95.91.243.213])
        by smtp.gmail.com with ESMTPSA id e2-20020a50fb82000000b00509e3053b66sm1824750edq.90.2023.05.10.06.15.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 06:15:43 -0700 (PDT)
From: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To: nhorman@tuxdriver.com
Cc: davem@davemloft.net,
	Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Christian Brauner <brauner@kernel.org>,
	Stanislav Fomichev <sdf@google.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	linux-sctp@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH net-next] sctp: add bpf_bypass_getsockopt proto callback
Date: Wed, 10 May 2023 15:15:27 +0200
Message-Id: <20230510131527.1244929-1-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add bpf_bypass_getsockopt proto callback and filter out
SCTP_SOCKOPT_PEELOFF and SCTP_SOCKOPT_PEELOFF_FLAGS socket options
from running eBPF hook on them.

These options do fd_install(), and if BPF_CGROUP_RUN_PROG_GETSOCKOPT
hook returns an error after success of the original handler
sctp_getsockopt(...), userspace will receive an error from getsockopt
syscall and will be not aware that fd was successfully installed into fdtable.

This patch was born as a result of discussion around a new SCM_PIDFD interface:
https://lore.kernel.org/all/20230413133355.350571-3-aleksandr.mikhalitsyn@canonical.com/

Fixes: 0d01da6afc54 ("bpf: implement getsockopt and setsockopt hooks")
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Stanislav Fomichev <sdf@google.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Xin Long <lucien.xin@gmail.com>
Cc: linux-sctp@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
---
 net/sctp/socket.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index cda8c2874691..a9a0ababea90 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -8281,6 +8281,29 @@ static int sctp_getsockopt(struct sock *sk, int level, int optname,
 	return retval;
 }
 
+bool sctp_bpf_bypass_getsockopt(int level, int optname)
+{
+	/*
+	 * These options do fd_install(), and if BPF_CGROUP_RUN_PROG_GETSOCKOPT
+	 * hook returns an error after success of the original handler
+	 * sctp_getsockopt(...), userspace will receive an error from getsockopt
+	 * syscall and will be not aware that fd was successfully installed into fdtable.
+	 *
+	 * Let's prevent bpf cgroup hook from running on them.
+	 */
+	if (level == SOL_SCTP) {
+		switch (optname) {
+		case SCTP_SOCKOPT_PEELOFF:
+		case SCTP_SOCKOPT_PEELOFF_FLAGS:
+			return true;
+		default:
+			return false;
+		}
+	}
+
+	return false;
+}
+
 static int sctp_hash(struct sock *sk)
 {
 	/* STUB */
@@ -9650,6 +9673,7 @@ struct proto sctp_prot = {
 	.shutdown    =	sctp_shutdown,
 	.setsockopt  =	sctp_setsockopt,
 	.getsockopt  =	sctp_getsockopt,
+	.bpf_bypass_getsockopt	= sctp_bpf_bypass_getsockopt,
 	.sendmsg     =	sctp_sendmsg,
 	.recvmsg     =	sctp_recvmsg,
 	.bind        =	sctp_bind,
@@ -9705,6 +9729,7 @@ struct proto sctpv6_prot = {
 	.shutdown	= sctp_shutdown,
 	.setsockopt	= sctp_setsockopt,
 	.getsockopt	= sctp_getsockopt,
+	.bpf_bypass_getsockopt	= sctp_bpf_bypass_getsockopt,
 	.sendmsg	= sctp_sendmsg,
 	.recvmsg	= sctp_recvmsg,
 	.bind		= sctp_bind,
-- 
2.34.1



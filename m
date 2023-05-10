Return-Path: <netdev+bounces-1505-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 349796FE0AC
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 16:43:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F252B280FD1
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 14:43:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B16214AA7;
	Wed, 10 May 2023 14:43:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5B46AA8
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 14:43:35 +0000 (UTC)
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 760FB5BAC
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 07:43:31 -0700 (PDT)
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 258B23F4D7
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 14:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1683729808;
	bh=VsRr4UycG64Ad7Wwitdyuus/KJ2GRNbGK68qU7i6U64=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
	b=U+JZqyV9QFYLkjndtBq79le2uXPK5NZXf1y3uurPJex5UlHlYJ7T4giZqYPqWTlte
	 PYBPCJkM1DUNhFKpcluQCUSLiaXIIJNTBAe1qXSTv71DEDyvfFMhjOv5Hd8qveR9BL
	 DtVp+4US5qeaPA2x1lEmI47wCXFflonKlVTjHzC6mrgiQRWViDcdM3bxwZlvoOi7nB
	 1npkDKU94FiU1HCnXNReAdUYRScdCIZfXrPggn6WG03XR8G9Slux4lOS+TuyvFQZVL
	 07oXH5UdiNy+g5Ha7/RPnZRqh6TmiChwXeEO5z7XPAqrBJA9y9LzYu4TCLUcSOJm0d
	 b0u9X+BTaas8Q==
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-9662ead7bf8so453302666b.0
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 07:43:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683729804; x=1686321804;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VsRr4UycG64Ad7Wwitdyuus/KJ2GRNbGK68qU7i6U64=;
        b=TYc2ACllucCkEcVrVRPYBImrcIFbgVNwwYSN/WyzCFlY/DDVY/+aFGw8KM2qS1NPa8
         o7RFWaqCpG6m6sWD7wtH4jM4G0mVj9D+MQod45sgB02DouBb5U1UtaU6QD17n+2vv9rG
         eQyqjx3CZ8uzmtuJruuTcHxusHWwajBkr7KiQShwTFyGsPCCINMJon8galTr5PDNeQjp
         9LKegfstbxiYb8j6rfaIWwhvSfflaiVkFnB4RM/Xuu1V+yCOemwcHQp7z3+tIsYkn6s/
         grxllcKjV+qtd4/guINxruiFWhCR2v+tnemYiWyN86M2ctn7+ZlxjxDeDau+tkrs9ifs
         Jc5g==
X-Gm-Message-State: AC+VfDxo51QlTH78TpSJn9BlGG+eS4HishAgspkDSTavPOS8FC2b6kcl
	imNYyB4IE6hL+XONUhlTiAZbn4RUTm9aFMBkmRKAa3a8KBY+j5xVdb34MXrRNSq5xH2g+c2fdwI
	mv6vVxpkwfPeiFzH17vKBhYAqSqoqFt5E1w==
X-Received: by 2002:a17:907:94cf:b0:8b8:c06e:52d8 with SMTP id dn15-20020a17090794cf00b008b8c06e52d8mr18552874ejc.36.1683729804688;
        Wed, 10 May 2023 07:43:24 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4p3WcCR9YYlvqH5FEUdsaxVk8iHhVqAwORD/x5tdhZuSVIvkPty0YtMpelRGfmwuLtWDzKFw==
X-Received: by 2002:a17:907:94cf:b0:8b8:c06e:52d8 with SMTP id dn15-20020a17090794cf00b008b8c06e52d8mr18552853ejc.36.1683729804415;
        Wed, 10 May 2023 07:43:24 -0700 (PDT)
Received: from amikhalitsyn.. (ip5f5bf3d5.dynamic.kabel-deutschland.de. [95.91.243.213])
        by smtp.gmail.com with ESMTPSA id ci18-20020a170907267200b009659ecdf29fsm2753044ejc.1.2023.05.10.07.43.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 07:43:23 -0700 (PDT)
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
Subject: [PATCH net-next v2] sctp: add bpf_bypass_getsockopt proto callback
Date: Wed, 10 May 2023 16:42:58 +0200
Message-Id: <20230510144258.1343471-1-aleksandr.mikhalitsyn@canonical.com>
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
Suggested-by: Stanislav Fomichev <sdf@google.com>
Acked-by: Stanislav Fomichev <sdf@google.com>
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
---
 net/sctp/socket.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index cda8c2874691..fed6057beb60 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -8281,6 +8281,29 @@ static int sctp_getsockopt(struct sock *sk, int level, int optname,
 	return retval;
 }
 
+static bool sctp_bpf_bypass_getsockopt(int level, int optname)
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



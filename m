Return-Path: <netdev+bounces-1812-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D37756FF326
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:38:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 82CD22809B2
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 13:38:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26B3119BDA;
	Thu, 11 May 2023 13:35:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2AC1F920
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 13:35:44 +0000 (UTC)
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43E71106D3
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 06:35:29 -0700 (PDT)
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 96F653F4A4
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 13:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1683811531;
	bh=ch7davOyHO5vzgs3WrwY5EQ2yT5MouTazclXi2xArF8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
	b=KavhHiCiKn/QOQF5nlTJZvM1b+/A0FNB6etexmx0a24iVupBQgTNPpFdHTA8BylHw
	 F2l9fQ5Q0gAGQjUZuQ/Az8MRLFpQB4Dd8uVjt4tt/udAMg4A9SW36EeF9kzsAUkC8k
	 rfaBeHqyLUCPs+4OF+qeJmjz6kQDVyQxkEWvHt87gSDIQa4A3aoM7hWiofr0sBUU6L
	 CnIE4JB7utW+hH6+CTVrfn5pOwK1F7IK7/Uf2kI9hXIt78bHL4g53bQkz6SIv8nPrO
	 wXZbw7gHBflOEpxmkMBEcP+fL+rkQteOHQ/7eBwsQlUH1k/M7YeVN3Xv9zxz8h22QW
	 oRUwXvv+euCCw==
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-94a355cf318so1008356266b.2
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 06:25:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683811531; x=1686403531;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ch7davOyHO5vzgs3WrwY5EQ2yT5MouTazclXi2xArF8=;
        b=i+EWbM6hm0KmjbNqW6HJRdjmAUbVP7cdymyJqQ1QL0QxtHUfppqKyeCaY59yjgzi50
         VCGfqWGutTPe1Pnhxzz0fc36Kyr8A8GNB+OeF0+JK2UGxMV+AeMI8FC+GB7QkLK5cgTl
         56WrqjEg7vvAdZ1gCPAwFjStK14kVNVVsFyzgTMqwGv+g9vhcL6lKgpfG3R6wJV/OSSo
         foyzfM3yTZPD+vfIJTJHtKK2d5K12G0HbekRphg69n0X4zlrzgj8YnvVjjwSOrbO4Lr+
         SkVYWkhaqUom/TsmPKKXPSf5mN2Qi6EabHqDYtQNJWRy4S3FWhgZFLA6LE85cUk/CqlG
         AT0w==
X-Gm-Message-State: AC+VfDy0dACbQGm5nVAB7Imr3hWv5XNpPH3BzO4tXyBKdejHovAeb9Wi
	8bziZxeW367i3tY2FxOVJ9lu3Sbl0czXK1W+QD/w5a9nuHUkI8lJ1fTtR031Uxa1qSeFP1goban
	gv5uQiDXzpQCe4NlodClEp9BpheqqBt5SBQ==
X-Received: by 2002:a17:907:3d9f:b0:959:5454:1db7 with SMTP id he31-20020a1709073d9f00b0095954541db7mr21156778ejc.3.1683811531211;
        Thu, 11 May 2023 06:25:31 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4xYBBCiS0F3m++AIGabvifZQOL5/jshhNMHmOdRosjw/dT+tJALMD25HPpXkwEl9AGcsMRMw==
X-Received: by 2002:a17:907:3d9f:b0:959:5454:1db7 with SMTP id he31-20020a1709073d9f00b0095954541db7mr21156743ejc.3.1683811530743;
        Thu, 11 May 2023 06:25:30 -0700 (PDT)
Received: from amikhalitsyn.. (ip5f5bf3d5.dynamic.kabel-deutschland.de. [95.91.243.213])
        by smtp.gmail.com with ESMTPSA id l19-20020a170906939300b0094e7d196aa4sm3936099ejx.160.2023.05.11.06.25.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 06:25:30 -0700 (PDT)
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
Subject: [PATCH net-next v3] sctp: add bpf_bypass_getsockopt proto callback
Date: Thu, 11 May 2023 15:25:06 +0200
Message-Id: <20230511132506.379102-1-aleksandr.mikhalitsyn@canonical.com>
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
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Implement ->bpf_bypass_getsockopt proto callback and filter out
SCTP_SOCKOPT_PEELOFF, SCTP_SOCKOPT_PEELOFF_FLAGS and SCTP_SOCKOPT_CONNECTX3
socket options from running eBPF hook on them.

SCTP_SOCKOPT_PEELOFF and SCTP_SOCKOPT_PEELOFF_FLAGS options do fd_install(),
and if BPF_CGROUP_RUN_PROG_GETSOCKOPT hook returns an error after success of
the original handler sctp_getsockopt(...), userspace will receive an error
from getsockopt syscall and will be not aware that fd was successfully
installed into a fdtable.

As pointed by Marcelo Ricardo Leitner it seems reasonable to skip
bpf getsockopt hook for SCTP_SOCKOPT_CONNECTX3 sockopt too.
Because internaly, it triggers connect() and if error is masked
then userspace will be confused.

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
v3: fix commit description and remove comments
v2: filter out SCTP_SOCKOPT_CONNECTX3
---
 net/sctp/socket.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index cda8c2874691..a68e1d541b12 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -8281,6 +8281,22 @@ static int sctp_getsockopt(struct sock *sk, int level, int optname,
 	return retval;
 }
 
+static bool sctp_bpf_bypass_getsockopt(int level, int optname)
+{
+	if (level == SOL_SCTP) {
+		switch (optname) {
+		case SCTP_SOCKOPT_PEELOFF:
+		case SCTP_SOCKOPT_PEELOFF_FLAGS:
+		case SCTP_SOCKOPT_CONNECTX3:
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
@@ -9650,6 +9666,7 @@ struct proto sctp_prot = {
 	.shutdown    =	sctp_shutdown,
 	.setsockopt  =	sctp_setsockopt,
 	.getsockopt  =	sctp_getsockopt,
+	.bpf_bypass_getsockopt	= sctp_bpf_bypass_getsockopt,
 	.sendmsg     =	sctp_sendmsg,
 	.recvmsg     =	sctp_recvmsg,
 	.bind        =	sctp_bind,
@@ -9705,6 +9722,7 @@ struct proto sctpv6_prot = {
 	.shutdown	= sctp_shutdown,
 	.setsockopt	= sctp_setsockopt,
 	.getsockopt	= sctp_getsockopt,
+	.bpf_bypass_getsockopt	= sctp_bpf_bypass_getsockopt,
 	.sendmsg	= sctp_sendmsg,
 	.recvmsg	= sctp_recvmsg,
 	.bind		= sctp_bind,
-- 
2.34.1



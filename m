Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33A451D7CF4
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 17:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728309AbgERPfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 11:35:38 -0400
Received: from www62.your-server.de ([213.133.104.62]:34760 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727040AbgERPfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 11:35:37 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jahni-00029H-Ir; Mon, 18 May 2020 17:35:34 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, rdna@fb.com,
        sdf@google.com, Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf-next 2/4] bpf, libbpf: enable get{peer,sock}name attach types
Date:   Mon, 18 May 2020 17:35:13 +0200
Message-Id: <1b92b124eef59946c3b0b051e39161ff66533ed9.1589813738.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1589813738.git.daniel@iogearbox.net>
References: <cover.1589813738.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25816/Mon May 18 14:17:08 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Trivial patch to add the new get{peer,sock}name attach types to the section
definitions in order to hook them up to sock_addr cgroup program type.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 tools/lib/bpf/libbpf.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 292257995487..fa04cbe547ed 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -6705,6 +6705,14 @@ static const struct bpf_sec_def section_defs[] = {
 						BPF_CGROUP_UDP4_RECVMSG),
 	BPF_EAPROG_SEC("cgroup/recvmsg6",	BPF_PROG_TYPE_CGROUP_SOCK_ADDR,
 						BPF_CGROUP_UDP6_RECVMSG),
+	BPF_EAPROG_SEC("cgroup/getpeername4",	BPF_PROG_TYPE_CGROUP_SOCK_ADDR,
+						BPF_CGROUP_INET4_GETPEERNAME),
+	BPF_EAPROG_SEC("cgroup/getpeername6",	BPF_PROG_TYPE_CGROUP_SOCK_ADDR,
+						BPF_CGROUP_INET6_GETPEERNAME),
+	BPF_EAPROG_SEC("cgroup/getsockname4",	BPF_PROG_TYPE_CGROUP_SOCK_ADDR,
+						BPF_CGROUP_INET4_GETSOCKNAME),
+	BPF_EAPROG_SEC("cgroup/getsockname6",	BPF_PROG_TYPE_CGROUP_SOCK_ADDR,
+						BPF_CGROUP_INET6_GETSOCKNAME),
 	BPF_EAPROG_SEC("cgroup/sysctl",		BPF_PROG_TYPE_CGROUP_SYSCTL,
 						BPF_CGROUP_SYSCTL),
 	BPF_EAPROG_SEC("cgroup/getsockopt",	BPF_PROG_TYPE_CGROUP_SOCKOPT,
-- 
2.21.0


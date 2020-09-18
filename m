Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7A026FC35
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 14:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbgIRMMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 08:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbgIRMMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 08:12:33 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 739D4C061756
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 05:12:33 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id c8so5870301edv.5
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 05:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CbLoMvbCVZR7v2qr1uLu68maulfUQM+3TJzgKeP8L7U=;
        b=ARLlP/MI0ddfuPiVcUweomzB1eTSRRV+yworw6SVPrtnqjFn6hOLe3fLWaLcaMkXwe
         enMhMKYrQQr5fEc0mb+IwCxK8QepcWsINr9KN8R1XNYOm841LzFb6GDySIeZRQNz6X11
         ObJbBnLjmkABvmgRrdLKXSodve6GlaxbVn61a4QhINKVKHCS+R+Hn5LvEzy4TafoK5OI
         oYS8Ph48ZVpAd9DdKOLU8Sa/5e5Vt3cjTmZ73j2pWpe3ZHg/XqQtvPyMYnYjz6lMdLNC
         RtM+C+cDCJWWuHRb+e/4a35WlkbWRvJEPLEJsUs1+yXnZl4v2PRwEbvoG1jw9Aj07QaQ
         tAfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CbLoMvbCVZR7v2qr1uLu68maulfUQM+3TJzgKeP8L7U=;
        b=GrpbUUGsOPkiUvru1TzLF/G0SDJEfIszGo2R4BPXUj6qol8ns9D6AisD3lq02ZxH+q
         sPVNChiMwsdSe+gtZhXxB0okHr9bphCyQm5zUC9jMvc9vqUMC/n11SwlYd4N+4A3FXjU
         K0YdlZD816toAuhmTgD7kdQq7faAuzyY5uTzJ7eybjqqQg+/e+NL+WtXvCX4Y7OuABVW
         AVkO5aiqbx57tR/dC8YKyvDkMvTs7kSdEV7COo8+cDmc7WGyS5YGxkM181aNGM2v1cS4
         z7PN2lcEHUahZZWoWJx6R5dSXUA8mnY/OPx/Er7kvoTqp0kQ4EDSWfpVBwtDT9rHBNMZ
         YFLw==
X-Gm-Message-State: AOAM533duLy+IRAZ+xHHw+loJzzLIKtvjSR2Df9WRcktXGM4F1SLLLrc
        si7/DcckDK57bAuGgoL4o7PFow==
X-Google-Smtp-Source: ABdhPJzDfSsq2yp8nRiSvTZJdAK37gQFaNJFTMbYKv3ygzB+9nz9o2282pJYtE+ZnNoHhQFk/SUYtg==
X-Received: by 2002:a50:f687:: with SMTP id d7mr39717142edn.353.1600431152011;
        Fri, 18 Sep 2020 05:12:32 -0700 (PDT)
Received: from localhost.localdomain ([87.66.33.240])
        by smtp.gmail.com with ESMTPSA id h64sm2084555edd.50.2020.09.18.05.12.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 05:12:31 -0700 (PDT)
From:   Nicolas Rybowski <nicolas.rybowski@tessares.net>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Nicolas Rybowski <nicolas.rybowski@tessares.net>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v3 1/5] bpf: expose is_mptcp flag to bpf_tcp_sock
Date:   Fri, 18 Sep 2020 14:10:40 +0200
Message-Id: <20200918121046.190240-1-nicolas.rybowski@tessares.net>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

is_mptcp is a field from struct tcp_sock used to indicate that the
current tcp_sock is part of the MPTCP protocol.

In this protocol, a first socket (mptcp_sock) is created with
sk_protocol set to IPPROTO_MPTCP (=262) for control purpose but it
isn't directly on the wire. This is the role of the subflow (kernel)
sockets which are classical tcp_sock with sk_protocol set to
IPPROTO_TCP. The only way to differentiate such sockets from plain TCP
sockets is the is_mptcp field from tcp_sock.

Such an exposure in BPF is thus required to be able to differentiate
plain TCP sockets from MPTCP subflow sockets in BPF_PROG_TYPE_SOCK_OPS
programs.

The choice has been made to silently pass the case when CONFIG_MPTCP is
unset by defaulting is_mptcp to 0 in order to make BPF independent of
the MPTCP configuration. Another solution is to make the verifier fail
in 'bpf_tcp_sock_is_valid_ctx_access' but this will add an additional
'#ifdef CONFIG_MPTCP' in the BPF code and a same injected BPF program
will not run if MPTCP is not set.

An example use-case is provided in
https://github.com/multipath-tcp/mptcp_net-next/tree/scripts/bpf/examples

Suggested-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Acked-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Nicolas Rybowski <nicolas.rybowski@tessares.net>
---
 include/uapi/linux/bpf.h       | 1 +
 net/core/filter.c              | 9 ++++++++-
 tools/include/uapi/linux/bpf.h | 1 +
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index a22812561064..351b3d0a6ca8 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4067,6 +4067,7 @@ struct bpf_tcp_sock {
 	__u32 delivered;	/* Total data packets delivered incl. rexmits */
 	__u32 delivered_ce;	/* Like the above but only ECE marked packets */
 	__u32 icsk_retransmits;	/* Number of unrecovered [RTO] timeouts */
+	__u32 is_mptcp;		/* Is MPTCP subflow? */
 };
 
 struct bpf_sock_tuple {
diff --git a/net/core/filter.c b/net/core/filter.c
index d266c6941967..dab48528dceb 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5837,7 +5837,7 @@ bool bpf_tcp_sock_is_valid_access(int off, int size, enum bpf_access_type type,
 				  struct bpf_insn_access_aux *info)
 {
 	if (off < 0 || off >= offsetofend(struct bpf_tcp_sock,
-					  icsk_retransmits))
+					  is_mptcp))
 		return false;
 
 	if (off % size != 0)
@@ -5971,6 +5971,13 @@ u32 bpf_tcp_sock_convert_ctx_access(enum bpf_access_type type,
 	case offsetof(struct bpf_tcp_sock, icsk_retransmits):
 		BPF_INET_SOCK_GET_COMMON(icsk_retransmits);
 		break;
+	case offsetof(struct bpf_tcp_sock, is_mptcp):
+#ifdef CONFIG_MPTCP
+		BPF_TCP_SOCK_GET_COMMON(is_mptcp);
+#else
+		*insn++ = BPF_MOV32_IMM(si->dst_reg, 0);
+#endif
+		break;
 	}
 
 	return insn - insn_buf;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index a22812561064..351b3d0a6ca8 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4067,6 +4067,7 @@ struct bpf_tcp_sock {
 	__u32 delivered;	/* Total data packets delivered incl. rexmits */
 	__u32 delivered_ce;	/* Like the above but only ECE marked packets */
 	__u32 icsk_retransmits;	/* Number of unrecovered [RTO] timeouts */
+	__u32 is_mptcp;		/* Is MPTCP subflow? */
 };
 
 struct bpf_sock_tuple {
-- 
2.28.0


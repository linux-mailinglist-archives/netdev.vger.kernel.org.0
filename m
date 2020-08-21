Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51CC024D866
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 17:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbgHUPTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 11:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728153AbgHUPSP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 11:18:15 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B29F6C061573
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 08:18:13 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id df16so1715974edb.9
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 08:18:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rQR67AqDgTFceM1GcH2o1VP0eXhNCBh9bwg17gfoTgU=;
        b=1yxK8FrAf4JsUoVuTMaIeajsDp7BkyBW/nIt5zPEpq0A5jbvKscdEPur41ES+s4LjB
         YzceM+KnfPfM0ob8s3SLA4DJz5LU2oDIc6HO0bh5W5xf1Gw9UeC7/XaFhXGaq4OLW2+n
         4IDSN/klhWSlzfzWyN2TeMrYu+EUk5dtYqlkp4tZI4UFmSMJEgTMR/1J4iR/4A1Gv8ox
         8G3+ez8CiW0u2ok6Ib3LW/QAfL6m9uguROWnrZuIUjMhqb9BrvHQO/CgTa7PY81DOBCh
         9H7PoNj7mTzRcz4nHkV26CikoPkkdUFhFD2v7vX/dXYE8M/sBlKgane36KSzePtex7x0
         3IAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rQR67AqDgTFceM1GcH2o1VP0eXhNCBh9bwg17gfoTgU=;
        b=HHDVJvdxCuYqOwFL4xRu8U1kHI78lyUFlecy2REaMbN9gBYMt63omKRDl3hGxYGgWP
         g8XLSLRDOVF36/rG3W2Gsne3+Po6SvRYKJM0RlpVdSPqwZC6I4RaN5CngjQ2dgKOC1Q3
         mjDyOhw0TQjgFcSjAbAUyM96n043QG82YsvDpelsaCOEmXYyClzj6cOnX/flAPK+MMU3
         e5UXY5UhzZd5ff03/wmbShbB4k5ytPBsyTbtEZmrRmm0ot4mmeHI81P3+0iz3PZH68xP
         6BUy26QjzO851ltdsuOwn09Cb8p2oHCMBEmIf3JPSoR7l9TWRj4B2AgiFAcC3qS1HT1D
         TFpw==
X-Gm-Message-State: AOAM5325O1d3HJGaizmv8pibA1Tv3ns2mzsUSZaMzJKF3P+DIBT9Kdpa
        COVO/gfuSqIPJ/Z6ZFWWTPUQTQ==
X-Google-Smtp-Source: ABdhPJyi0tkiH5q/ltl//GjdPiGKtU+rjkFW0l048hREebCe9VF5uhvGKNPNQnNuLlWSRFI9KMG57g==
X-Received: by 2002:a50:93a2:: with SMTP id o31mr3343896eda.203.1598023092403;
        Fri, 21 Aug 2020 08:18:12 -0700 (PDT)
Received: from localhost.localdomain (223.60-242-81.adsl-dyn.isp.belgacom.be. [81.242.60.223])
        by smtp.gmail.com with ESMTPSA id qp16sm1482709ejb.89.2020.08.21.08.18.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 08:18:11 -0700 (PDT)
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
Subject: [PATCH bpf-next 1/3] bpf: expose is_mptcp flag to bpf_tcp_sock
Date:   Fri, 21 Aug 2020 17:15:39 +0200
Message-Id: <20200821151544.1211989-2-nicolas.rybowski@tessares.net>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200821151544.1211989-1-nicolas.rybowski@tessares.net>
References: <20200821151544.1211989-1-nicolas.rybowski@tessares.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
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
index 0480f893facd..a9fccfdb3a62 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3865,6 +3865,7 @@ struct bpf_tcp_sock {
 	__u32 delivered;	/* Total data packets delivered incl. rexmits */
 	__u32 delivered_ce;	/* Like the above but only ECE marked packets */
 	__u32 icsk_retransmits;	/* Number of unrecovered [RTO] timeouts */
+	__u32 is_mptcp;		/* Is MPTCP subflow? */
 };
 
 struct bpf_sock_tuple {
diff --git a/net/core/filter.c b/net/core/filter.c
index b2df52086445..eb400aeea282 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5742,7 +5742,7 @@ bool bpf_tcp_sock_is_valid_access(int off, int size, enum bpf_access_type type,
 				  struct bpf_insn_access_aux *info)
 {
 	if (off < 0 || off >= offsetofend(struct bpf_tcp_sock,
-					  icsk_retransmits))
+					  is_mptcp))
 		return false;
 
 	if (off % size != 0)
@@ -5876,6 +5876,13 @@ u32 bpf_tcp_sock_convert_ctx_access(enum bpf_access_type type,
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
index 0480f893facd..a9fccfdb3a62 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3865,6 +3865,7 @@ struct bpf_tcp_sock {
 	__u32 delivered;	/* Total data packets delivered incl. rexmits */
 	__u32 delivered_ce;	/* Like the above but only ECE marked packets */
 	__u32 icsk_retransmits;	/* Number of unrecovered [RTO] timeouts */
+	__u32 is_mptcp;		/* Is MPTCP subflow? */
 };
 
 struct bpf_sock_tuple {
-- 
2.28.0


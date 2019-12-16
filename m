Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82334120351
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 12:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727549AbfLPLIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 06:08:04 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:56180 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727317AbfLPLIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 06:08:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576494482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=chyqtSEdAwhoRoXKSKJmi+K70iH1cRRoR0UE4h42q90=;
        b=GxFGooruM2lpEU5kIcZ3g/9V67CSBMV56pU/3EXFHddW6J1AGtFdiHq6iu+/pvp4XzylzK
        9yCH+BKBcotEy7+mtkhAtS6YUVX9NqkJvApoMCc2Dh67fYvHBwYjm2gCyZiZOmhGRtnvzE
        oPqsB8w1RHap/mvY9EU8wfW/iOiikR4=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-294-T1Ha4ullOLi7jpA-DzR63A-1; Mon, 16 Dec 2019 06:07:58 -0500
X-MC-Unique: T1Ha4ullOLi7jpA-DzR63A-1
Received: by mail-lj1-f200.google.com with SMTP id g16so2007893ljj.12
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 03:07:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=chyqtSEdAwhoRoXKSKJmi+K70iH1cRRoR0UE4h42q90=;
        b=sDQXhfrtvCYMzNhjLTTqedZRyKzRUWCLGIiMUDcItTXEEoDilw7CEQ8BHwO4v55RSQ
         EY7bP6c5gkBAcurCtI7wXnismB2bHYPRtUDJaYJuMUQqiGnxZRAmU+1OEcJ1F/S93Twu
         W0cKhWPxXEF9UfeMlnxhBouR8iHKdLnOJrZMRNbBquNnGUxxjQkyqL6s9OuVIJQjzRDo
         HxZVSyQjcsB04ri7zLRJdW+4+hnfnYo9lfyKAh0Ogspg2mPQpt/kLFQR8uOP1w7nzSVy
         p6EDQu6CWPETvnZqWuQ1yrlad07MuBwq+ZPK9Jt1LGdBGSluNpPu+sAKNjSSvxo8tliz
         AHow==
X-Gm-Message-State: APjAAAXDpcMscIBJr2KWTNpLNvFuHu1l7izBx1gaV4017fNyHj08goP5
        ef4ASadMPotdXbkHIlY/OB3ETWw/Az80evoZuEUVuVQLA92ZYudRTZvdv0PSzQ/64sNWDypw7kk
        g2r7bhumuyBvyrhrg
X-Received: by 2002:a05:6512:4c6:: with SMTP id w6mr16432271lfq.157.1576494476648;
        Mon, 16 Dec 2019 03:07:56 -0800 (PST)
X-Google-Smtp-Source: APXvYqxSpH6ez5P8fTg8lLepdw1crwbEiX/4gTwLsw9dPHwW1B8dIOVMcMq8mueK1RTYwj8eI0Q7yg==
X-Received: by 2002:a05:6512:4c6:: with SMTP id w6mr16432254lfq.157.1576494476299;
        Mon, 16 Dec 2019 03:07:56 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id u16sm10174323ljo.22.2019.12.16.03.07.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 03:07:55 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 10AC51819EB; Mon, 16 Dec 2019 12:07:54 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: [PATCH bpf-next] samples/bpf: Attach XDP programs in driver mode by default
Date:   Mon, 16 Dec 2019 12:07:42 +0100
Message-Id: <20191216110742.364456-1-toke@redhat.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When attaching XDP programs, userspace can set flags to request the attach
mode (generic/SKB mode, driver mode or hw offloaded mode). If no such flags
are requested, the kernel will attempt to attach in driver mode, and then
silently fall back to SKB mode if this fails.

The silent fallback is a major source of user confusion, as users will try
to load a program on a device without XDP support, and instead of an error
they will get the silent fallback behaviour, not notice, and then wonder
why performance is not what they were expecting.

In an attempt to combat this, let's switch all the samples to default to
explicitly requesting driver-mode attach. As part of this, ensure that all
the userspace utilities have a switch to enable SKB mode. For those that
have a switch to request driver mode, keep it but turn it into a no-op.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 samples/bpf/xdp1_user.c             |  5 ++++-
 samples/bpf/xdp_adjust_tail_user.c  |  5 ++++-
 samples/bpf/xdp_fwd_user.c          | 17 ++++++++++++++---
 samples/bpf/xdp_redirect_cpu_user.c |  4 ++++
 samples/bpf/xdp_redirect_map_user.c |  5 ++++-
 samples/bpf/xdp_redirect_user.c     |  5 ++++-
 samples/bpf/xdp_router_ipv4_user.c  |  3 +++
 samples/bpf/xdp_rxq_info_user.c     |  4 ++++
 samples/bpf/xdp_sample_pkts_user.c  | 12 +++++++++---
 samples/bpf/xdp_tx_iptunnel_user.c  |  5 ++++-
 samples/bpf/xdpsock_user.c          |  5 ++++-
 11 files changed, 58 insertions(+), 12 deletions(-)

diff --git a/samples/bpf/xdp1_user.c b/samples/bpf/xdp1_user.c
index 3e553eed95a7..38a8852cb57f 100644
--- a/samples/bpf/xdp1_user.c
+++ b/samples/bpf/xdp1_user.c
@@ -98,7 +98,7 @@ int main(int argc, char **argv)
 			xdp_flags |= XDP_FLAGS_SKB_MODE;
 			break;
 		case 'N':
-			xdp_flags |= XDP_FLAGS_DRV_MODE;
+			/* default, set below */
 			break;
 		case 'F':
 			xdp_flags &= ~XDP_FLAGS_UPDATE_IF_NOEXIST;
@@ -109,6 +109,9 @@ int main(int argc, char **argv)
 		}
 	}
 
+	if (!(xdp_flags & XDP_FLAGS_SKB_MODE))
+		xdp_flags |= XDP_FLAGS_DRV_MODE;
+
 	if (optind == argc) {
 		usage(basename(argv[0]));
 		return 1;
diff --git a/samples/bpf/xdp_adjust_tail_user.c b/samples/bpf/xdp_adjust_tail_user.c
index d86e9ad0356b..008789eb6ada 100644
--- a/samples/bpf/xdp_adjust_tail_user.c
+++ b/samples/bpf/xdp_adjust_tail_user.c
@@ -120,7 +120,7 @@ int main(int argc, char **argv)
 			xdp_flags |= XDP_FLAGS_SKB_MODE;
 			break;
 		case 'N':
-			xdp_flags |= XDP_FLAGS_DRV_MODE;
+			/* default, set below */
 			break;
 		case 'F':
 			xdp_flags &= ~XDP_FLAGS_UPDATE_IF_NOEXIST;
@@ -132,6 +132,9 @@ int main(int argc, char **argv)
 		opt_flags[opt] = 0;
 	}
 
+	if (!(xdp_flags & XDP_FLAGS_SKB_MODE))
+		xdp_flags |= XDP_FLAGS_DRV_MODE;
+
 	for (i = 0; i < strlen(optstr); i++) {
 		if (opt_flags[(unsigned int)optstr[i]]) {
 			fprintf(stderr, "Missing argument -%c\n", optstr[i]);
diff --git a/samples/bpf/xdp_fwd_user.c b/samples/bpf/xdp_fwd_user.c
index 97ff1dad7669..c30f9acfdb84 100644
--- a/samples/bpf/xdp_fwd_user.c
+++ b/samples/bpf/xdp_fwd_user.c
@@ -27,11 +27,13 @@
 #include "libbpf.h"
 #include <bpf/bpf.h>
 
+static __u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
+
 static int do_attach(int idx, int prog_fd, int map_fd, const char *name)
 {
 	int err;
 
-	err = bpf_set_link_xdp_fd(idx, prog_fd, 0);
+	err = bpf_set_link_xdp_fd(idx, prog_fd, xdp_flags);
 	if (err < 0) {
 		printf("ERROR: failed to attach program to %s\n", name);
 		return err;
@@ -49,7 +51,7 @@ static int do_detach(int idx, const char *name)
 {
 	int err;
 
-	err = bpf_set_link_xdp_fd(idx, -1, 0);
+	err = bpf_set_link_xdp_fd(idx, -1, xdp_flags);
 	if (err < 0)
 		printf("ERROR: failed to detach program from %s\n", name);
 
@@ -83,11 +85,17 @@ int main(int argc, char **argv)
 	int attach = 1;
 	int ret = 0;
 
-	while ((opt = getopt(argc, argv, ":dD")) != -1) {
+	while ((opt = getopt(argc, argv, ":dDSF")) != -1) {
 		switch (opt) {
 		case 'd':
 			attach = 0;
 			break;
+		case 'S':
+			xdp_flags |= XDP_FLAGS_SKB_MODE;
+			break;
+		case 'F':
+			xdp_flags &= ~XDP_FLAGS_UPDATE_IF_NOEXIST;
+			break;
 		case 'D':
 			prog_name = "xdp_fwd_direct";
 			break;
@@ -97,6 +105,9 @@ int main(int argc, char **argv)
 		}
 	}
 
+	if (!(xdp_flags & XDP_FLAGS_SKB_MODE))
+		xdp_flags |= XDP_FLAGS_DRV_MODE;
+
 	if (optind == argc) {
 		usage(basename(argv[0]));
 		return 1;
diff --git a/samples/bpf/xdp_redirect_cpu_user.c b/samples/bpf/xdp_redirect_cpu_user.c
index 0da6e9e7132e..72af628529b5 100644
--- a/samples/bpf/xdp_redirect_cpu_user.c
+++ b/samples/bpf/xdp_redirect_cpu_user.c
@@ -728,6 +728,10 @@ int main(int argc, char **argv)
 			return EXIT_FAIL_OPTION;
 		}
 	}
+
+	if (!(xdp_flags & XDP_FLAGS_SKB_MODE))
+		xdp_flags |= XDP_FLAGS_DRV_MODE;
+
 	/* Required option */
 	if (ifindex == -1) {
 		fprintf(stderr, "ERR: required option --dev missing\n");
diff --git a/samples/bpf/xdp_redirect_map_user.c b/samples/bpf/xdp_redirect_map_user.c
index f70ee33907fd..cc840661faab 100644
--- a/samples/bpf/xdp_redirect_map_user.c
+++ b/samples/bpf/xdp_redirect_map_user.c
@@ -116,7 +116,7 @@ int main(int argc, char **argv)
 			xdp_flags |= XDP_FLAGS_SKB_MODE;
 			break;
 		case 'N':
-			xdp_flags |= XDP_FLAGS_DRV_MODE;
+			/* default, set below */
 			break;
 		case 'F':
 			xdp_flags &= ~XDP_FLAGS_UPDATE_IF_NOEXIST;
@@ -127,6 +127,9 @@ int main(int argc, char **argv)
 		}
 	}
 
+	if (!(xdp_flags & XDP_FLAGS_SKB_MODE))
+		xdp_flags |= XDP_FLAGS_DRV_MODE;
+
 	if (optind == argc) {
 		printf("usage: %s <IFNAME|IFINDEX>_IN <IFNAME|IFINDEX>_OUT\n", argv[0]);
 		return 1;
diff --git a/samples/bpf/xdp_redirect_user.c b/samples/bpf/xdp_redirect_user.c
index 5440cd620607..71dff8e3382a 100644
--- a/samples/bpf/xdp_redirect_user.c
+++ b/samples/bpf/xdp_redirect_user.c
@@ -117,7 +117,7 @@ int main(int argc, char **argv)
 			xdp_flags |= XDP_FLAGS_SKB_MODE;
 			break;
 		case 'N':
-			xdp_flags |= XDP_FLAGS_DRV_MODE;
+			/* default, set below */
 			break;
 		case 'F':
 			xdp_flags &= ~XDP_FLAGS_UPDATE_IF_NOEXIST;
@@ -128,6 +128,9 @@ int main(int argc, char **argv)
 		}
 	}
 
+	if (!(xdp_flags & XDP_FLAGS_SKB_MODE))
+		xdp_flags |= XDP_FLAGS_DRV_MODE;
+
 	if (optind == argc) {
 		printf("usage: %s <IFNAME|IFINDEX>_IN <IFNAME|IFINDEX>_OUT\n", argv[0]);
 		return 1;
diff --git a/samples/bpf/xdp_router_ipv4_user.c b/samples/bpf/xdp_router_ipv4_user.c
index 1469b66ebad1..fef286c5add2 100644
--- a/samples/bpf/xdp_router_ipv4_user.c
+++ b/samples/bpf/xdp_router_ipv4_user.c
@@ -662,6 +662,9 @@ int main(int ac, char **argv)
 		}
 	}
 
+	if (!(flags & XDP_FLAGS_SKB_MODE))
+		flags |= XDP_FLAGS_DRV_MODE;
+
 	if (optind == ac) {
 		usage(basename(argv[0]));
 		return 1;
diff --git a/samples/bpf/xdp_rxq_info_user.c b/samples/bpf/xdp_rxq_info_user.c
index 8fc3ad01de72..fc4983fd6959 100644
--- a/samples/bpf/xdp_rxq_info_user.c
+++ b/samples/bpf/xdp_rxq_info_user.c
@@ -551,6 +551,10 @@ int main(int argc, char **argv)
 			return EXIT_FAIL_OPTION;
 		}
 	}
+
+	if (!(xdp_flags & XDP_FLAGS_SKB_MODE))
+		xdp_flags |= XDP_FLAGS_DRV_MODE;
+
 	/* Required option */
 	if (ifindex == -1) {
 		fprintf(stderr, "ERR: required option --dev missing\n");
diff --git a/samples/bpf/xdp_sample_pkts_user.c b/samples/bpf/xdp_sample_pkts_user.c
index a5760e8bf2c4..8c1af1b7372d 100644
--- a/samples/bpf/xdp_sample_pkts_user.c
+++ b/samples/bpf/xdp_sample_pkts_user.c
@@ -52,13 +52,13 @@ static int do_detach(int idx, const char *name)
 	__u32 curr_prog_id = 0;
 	int err = 0;
 
-	err = bpf_get_link_xdp_id(idx, &curr_prog_id, 0);
+	err = bpf_get_link_xdp_id(idx, &curr_prog_id, xdp_flags);
 	if (err) {
 		printf("bpf_get_link_xdp_id failed\n");
 		return err;
 	}
 	if (prog_id == curr_prog_id) {
-		err = bpf_set_link_xdp_fd(idx, -1, 0);
+		err = bpf_set_link_xdp_fd(idx, -1, xdp_flags);
 		if (err < 0)
 			printf("ERROR: failed to detach prog from %s\n", name);
 	} else if (!curr_prog_id) {
@@ -115,7 +115,7 @@ int main(int argc, char **argv)
 		.prog_type	= BPF_PROG_TYPE_XDP,
 	};
 	struct perf_buffer_opts pb_opts = {};
-	const char *optstr = "F";
+	const char *optstr = "FS";
 	int prog_fd, map_fd, opt;
 	struct bpf_object *obj;
 	struct bpf_map *map;
@@ -127,12 +127,18 @@ int main(int argc, char **argv)
 		case 'F':
 			xdp_flags &= ~XDP_FLAGS_UPDATE_IF_NOEXIST;
 			break;
+		case 'S':
+			xdp_flags |= XDP_FLAGS_SKB_MODE;
+			break;
 		default:
 			usage(basename(argv[0]));
 			return 1;
 		}
 	}
 
+	if (!(xdp_flags & XDP_FLAGS_SKB_MODE))
+		xdp_flags |= XDP_FLAGS_DRV_MODE;
+
 	if (optind == argc) {
 		usage(basename(argv[0]));
 		return 1;
diff --git a/samples/bpf/xdp_tx_iptunnel_user.c b/samples/bpf/xdp_tx_iptunnel_user.c
index 2fe4c7f5ffe5..5f33b5530032 100644
--- a/samples/bpf/xdp_tx_iptunnel_user.c
+++ b/samples/bpf/xdp_tx_iptunnel_user.c
@@ -231,7 +231,7 @@ int main(int argc, char **argv)
 			xdp_flags |= XDP_FLAGS_SKB_MODE;
 			break;
 		case 'N':
-			xdp_flags |= XDP_FLAGS_DRV_MODE;
+			/* default, set below */
 			break;
 		case 'F':
 			xdp_flags &= ~XDP_FLAGS_UPDATE_IF_NOEXIST;
@@ -243,6 +243,9 @@ int main(int argc, char **argv)
 		opt_flags[opt] = 0;
 	}
 
+	if (!(xdp_flags & XDP_FLAGS_SKB_MODE))
+		xdp_flags |= XDP_FLAGS_DRV_MODE;
+
 	for (i = 0; i < strlen(optstr); i++) {
 		if (opt_flags[(unsigned int)optstr[i]]) {
 			fprintf(stderr, "Missing argument -%c\n", optstr[i]);
diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index a15480010828..e7829e5baaff 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -440,7 +440,7 @@ static void parse_command_line(int argc, char **argv)
 			opt_xdp_bind_flags |= XDP_COPY;
 			break;
 		case 'N':
-			opt_xdp_flags |= XDP_FLAGS_DRV_MODE;
+			/* default, set below */
 			break;
 		case 'n':
 			opt_interval = atoi(optarg);
@@ -474,6 +474,9 @@ static void parse_command_line(int argc, char **argv)
 		}
 	}
 
+	if (!(opt_xdp_flags & XDP_FLAGS_SKB_MODE))
+		opt_xdp_flags |= XDP_FLAGS_DRV_MODE;
+
 	opt_ifindex = if_nametoindex(opt_if);
 	if (!opt_ifindex) {
 		fprintf(stderr, "ERROR: interface \"%s\" does not exist\n",
-- 
2.24.0


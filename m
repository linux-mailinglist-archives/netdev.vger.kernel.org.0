Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27B8D2CBAB8
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 11:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729504AbgLBKkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 05:40:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbgLBKkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 05:40:12 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21A2BC0617A7;
        Wed,  2 Dec 2020 02:39:32 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id l11so3835984lfg.0;
        Wed, 02 Dec 2020 02:39:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t0z8hFuN0CmWfy4MMYvH83rJGlqQzj1t5SRgUnGKKQM=;
        b=XRWwgfy43TBuRJrvsdSS9mrArYU2qd42M22SrCTGgNUQ0XNUXbmIGoCiAxKvuOlyYG
         b+mazWkQRpLHM2TlepqUOQaI+OeDCmw962CFHmv/BbXsdxMJgLWGi52fCxi/2AbdfnMl
         KsrkpS85R8okLLaTmSz/W1pJyW8swn+zik5cbMahGGnKb/Y2JFXej0ksn0n9bZBKptHk
         lDMW8QOqBSiu9hQt4OUJpGvUcE9EO7/Nj4I3+ZcU1ceGpOtLiP7muvYSkVzHlHlgXMdq
         AT0xciqXORAoqdqCxVuA9YhI/O6X8hrQoBxhpcrA5jt8jE8xdBH3Xsc97ZPsy+Totk8o
         0j8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t0z8hFuN0CmWfy4MMYvH83rJGlqQzj1t5SRgUnGKKQM=;
        b=al8k6aHZ91GVBGbBRTaI2OboNZh7cvdnNpRaCpe4q84171jmoZphYzC6ZEWSk017ov
         ke1VhXV1qJMn9U0nQD50TxyQesrkuHlumSPnhfdlx8f0pXB2hTVCz0qd4SKGd5TxcNYm
         XAfrkdKaiE4h//XJEAlChkzaK8fq2aYg1ocK9qhUnMt8ZG/VpbQ89rgzgANXkM9RN9+n
         EfQppktuYl77bBqCFdCmDiXNeQ0KqoGqMvCMjdZv0Ws/SRxglfe9N4sNR1yE7S4eoI1M
         aAs29PYnvGP+HqF/p87sv6VH/bDPhtN5ruIttIXwMQGjNCHryYok+0eCPi0n41kqd/Ql
         xb0w==
X-Gm-Message-State: AOAM5322uvXIgt56ZnqYpEaqSHK5hTkEUilMpOoZS7qV8QzmvmcIl8p3
        ANnV5xywzykweshMZoGMgzYu+ZMOSf6MHIAi
X-Google-Smtp-Source: ABdhPJyZeDmRtIoHrZer/zChXBCbwlxfGltwbTA1B6igtjh9W8AV/B9+Sho/wNwUpE74tuic5pg5sQ==
X-Received: by 2002:ac2:5e8d:: with SMTP id b13mr929347lfq.246.1606905570565;
        Wed, 02 Dec 2020 02:39:30 -0800 (PST)
Received: from localhost.localdomain (host-89-229-233-64.dynamic.mm.pl. [89.229.233.64])
        by smtp.gmail.com with ESMTPSA id q13sm354236lfp.2.2020.12.02.02.39.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 02:39:29 -0800 (PST)
From:   mariusz.dudek@gmail.com
X-Google-Original-From: mariuszx.dudek@intel.com
To:     andrii.nakryiko@gmail.com, magnus.karlsson@intel.com,
        bjorn.topel@intel.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org, Mariusz Dudek <mariuszx.dudek@intel.com>
Subject: [PATCH v6 bpf-next 2/2] samples/bpf: sample application for eBPF load and socket creation split
Date:   Wed,  2 Dec 2020 11:39:23 +0100
Message-Id: <20201202103923.12447-3-mariuszx.dudek@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201202103923.12447-1-mariuszx.dudek@intel.com>
References: <20201202103923.12447-1-mariuszx.dudek@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mariusz Dudek <mariuszx.dudek@intel.com>

Introduce a sample program to demonstrate the control and data
plane split. For the control plane part a new program called
xdpsock_ctrl_proc is introduced. For the data plane part, some code
was added to xdpsock_user.c to act as the data plane entity.

Application xdpsock_ctrl_proc works as control entity with sudo
privileges (CAP_SYS_ADMIN and CAP_NET_ADMIN are sufficient) and the
extended xdpsock as data plane entity with CAP_NET_RAW capability
only.

Usage example:

sudo ./samples/bpf/xdpsock_ctrl_proc -i <interface>

sudo ./samples/bpf/xdpsock -i <interface> -q <queue_id>
	-n <interval> -N -l -R

Signed-off-by: Mariusz Dudek <mariuszx.dudek@intel.com>
---
 samples/bpf/Makefile            |   4 +-
 samples/bpf/xdpsock.h           |   8 ++
 samples/bpf/xdpsock_ctrl_proc.c | 187 ++++++++++++++++++++++++++++++++
 samples/bpf/xdpsock_user.c      | 146 +++++++++++++++++++++++--
 4 files changed, 335 insertions(+), 10 deletions(-)
 create mode 100644 samples/bpf/xdpsock_ctrl_proc.c

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 05db041f8b18..26fc96ca619e 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -48,6 +48,7 @@ tprogs-y += syscall_tp
 tprogs-y += cpustat
 tprogs-y += xdp_adjust_tail
 tprogs-y += xdpsock
+tprogs-y += xdpsock_ctrl_proc
 tprogs-y += xsk_fwd
 tprogs-y += xdp_fwd
 tprogs-y += task_fd_query
@@ -105,6 +106,7 @@ syscall_tp-objs := syscall_tp_user.o
 cpustat-objs := cpustat_user.o
 xdp_adjust_tail-objs := xdp_adjust_tail_user.o
 xdpsock-objs := xdpsock_user.o
+xdpsock_ctrl_proc-objs := xdpsock_ctrl_proc.o
 xsk_fwd-objs := xsk_fwd.o
 xdp_fwd-objs := xdp_fwd_user.o
 task_fd_query-objs := task_fd_query_user.o $(TRACE_HELPERS)
@@ -202,7 +204,7 @@ TPROGLDLIBS_tracex4		+= -lrt
 TPROGLDLIBS_trace_output	+= -lrt
 TPROGLDLIBS_map_perf_test	+= -lrt
 TPROGLDLIBS_test_overhead	+= -lrt
-TPROGLDLIBS_xdpsock		+= -pthread
+TPROGLDLIBS_xdpsock		+= -pthread -lcap
 TPROGLDLIBS_xsk_fwd		+= -pthread
 
 # Allows pointing LLC/CLANG to a LLVM backend with bpf support, redefine on cmdline:
diff --git a/samples/bpf/xdpsock.h b/samples/bpf/xdpsock.h
index b7eca15c78cc..fd70cce60712 100644
--- a/samples/bpf/xdpsock.h
+++ b/samples/bpf/xdpsock.h
@@ -8,4 +8,12 @@
 
 #define MAX_SOCKS 4
 
+#define SOCKET_NAME "sock_cal_bpf_fd"
+#define MAX_NUM_OF_CLIENTS 10
+
+#define CLOSE_CONN  1
+
+typedef __u64 u64;
+typedef __u32 u32;
+
 #endif /* XDPSOCK_H */
diff --git a/samples/bpf/xdpsock_ctrl_proc.c b/samples/bpf/xdpsock_ctrl_proc.c
new file mode 100644
index 000000000000..384e62e3c6d6
--- /dev/null
+++ b/samples/bpf/xdpsock_ctrl_proc.c
@@ -0,0 +1,187 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2017 - 2018 Intel Corporation. */
+
+#include <errno.h>
+#include <getopt.h>
+#include <libgen.h>
+#include <net/if.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/socket.h>
+#include <sys/un.h>
+#include <unistd.h>
+
+#include <bpf/bpf.h>
+#include <bpf/xsk.h>
+#include "xdpsock.h"
+
+static const char *opt_if = "";
+
+static struct option long_options[] = {
+	{"interface", required_argument, 0, 'i'},
+	{0, 0, 0, 0}
+};
+
+static void usage(const char *prog)
+{
+	const char *str =
+		"  Usage: %s [OPTIONS]\n"
+		"  Options:\n"
+		"  -i, --interface=n	Run on interface n\n"
+		"\n";
+	fprintf(stderr, "%s\n", str);
+
+	exit(0);
+}
+
+static void parse_command_line(int argc, char **argv)
+{
+	int option_index, c;
+
+	opterr = 0;
+
+	for (;;) {
+		c = getopt_long(argc, argv, "i:",
+				long_options, &option_index);
+		if (c == -1)
+			break;
+
+		switch (c) {
+		case 'i':
+			opt_if = optarg;
+			break;
+		default:
+			usage(basename(argv[0]));
+		}
+	}
+}
+
+static int send_xsks_map_fd(int sock, int fd)
+{
+	char cmsgbuf[CMSG_SPACE(sizeof(int))];
+	struct msghdr msg;
+	struct iovec iov;
+	int value = 0;
+
+	if (fd == -1) {
+		fprintf(stderr, "Incorrect fd = %d\n", fd);
+		return -1;
+	}
+	iov.iov_base = &value;
+	iov.iov_len = sizeof(int);
+
+	msg.msg_name = NULL;
+	msg.msg_namelen = 0;
+	msg.msg_iov = &iov;
+	msg.msg_iovlen = 1;
+	msg.msg_flags = 0;
+	msg.msg_control = cmsgbuf;
+	msg.msg_controllen = CMSG_LEN(sizeof(int));
+
+	struct cmsghdr *cmsg = CMSG_FIRSTHDR(&msg);
+
+	cmsg->cmsg_level = SOL_SOCKET;
+	cmsg->cmsg_type = SCM_RIGHTS;
+	cmsg->cmsg_len = CMSG_LEN(sizeof(int));
+
+	*(int *)CMSG_DATA(cmsg) = fd;
+	int ret = sendmsg(sock, &msg, 0);
+
+	if (ret == -1) {
+		fprintf(stderr, "Sendmsg failed with %s", strerror(errno));
+		return -errno;
+	}
+
+	return ret;
+}
+
+int
+main(int argc, char **argv)
+{
+	struct sockaddr_un server;
+	int listening = 1;
+	int rval, msgsock;
+	int ifindex = 0;
+	int flag = 1;
+	int cmd = 0;
+	int sock;
+	int err;
+	int xsks_map_fd;
+
+	parse_command_line(argc, argv);
+
+	ifindex = if_nametoindex(opt_if);
+	if (ifindex == 0) {
+		fprintf(stderr, "Unable to get ifindex for Interface %s. Reason:%s",
+			opt_if, strerror(errno));
+		return -errno;
+	}
+
+	sock = socket(AF_UNIX, SOCK_STREAM, 0);
+	if (sock < 0) {
+		fprintf(stderr, "Opening socket stream failed: %s", strerror(errno));
+		return -errno;
+	}
+
+	server.sun_family = AF_UNIX;
+	strcpy(server.sun_path, SOCKET_NAME);
+
+	setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, &flag, sizeof(int));
+
+	if (bind(sock, (struct sockaddr *)&server, sizeof(struct sockaddr_un))) {
+		fprintf(stderr, "Binding to socket stream failed: %s", strerror(errno));
+		return -errno;
+	}
+
+	listen(sock, MAX_NUM_OF_CLIENTS);
+
+	err = xsk_setup_xdp_prog(ifindex, &xsks_map_fd);
+	if (err) {
+		fprintf(stderr, "Setup of xdp program failed\n");
+		goto close_sock;
+	}
+
+	while (listening) {
+		msgsock = accept(sock, 0, 0);
+		if (msgsock == -1) {
+			fprintf(stderr, "Error accepting connection: %s", strerror(errno));
+			err = -errno;
+			goto close_sock;
+		}
+		err = send_xsks_map_fd(msgsock, xsks_map_fd);
+		if (err <= 0) {
+			fprintf(stderr, "Error %d sending xsks_map_fd\n", err);
+			goto cleanup;
+		}
+		do {
+			rval = read(msgsock, &cmd, sizeof(int));
+			if (rval < 0) {
+				fprintf(stderr, "Error reading stream message");
+			} else {
+				if (cmd != CLOSE_CONN)
+					fprintf(stderr, "Recv unknown cmd = %d\n", cmd);
+				listening = 0;
+				break;
+			}
+		} while (rval > 0);
+	}
+	close(msgsock);
+	close(sock);
+	unlink(SOCKET_NAME);
+
+	/* Unset fd for given ifindex */
+	err = bpf_set_link_xdp_fd(ifindex, -1, 0);
+	if (err) {
+		fprintf(stderr, "Error when unsetting bpf prog_fd for ifindex(%d)\n", ifindex);
+		return err;
+	}
+
+	return 0;
+
+cleanup:
+	close(msgsock);
+close_sock:
+	close(sock);
+	unlink(SOCKET_NAME);
+	return err;
+}
diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index 036bd019e400..0fee7f3aef3c 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -24,10 +24,12 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <sys/capability.h>
 #include <sys/mman.h>
 #include <sys/resource.h>
 #include <sys/socket.h>
 #include <sys/types.h>
+#include <sys/un.h>
 #include <time.h>
 #include <unistd.h>
 
@@ -96,6 +98,7 @@ static bool opt_need_wakeup = true;
 static u32 opt_num_xsks = 1;
 static u32 prog_id;
 static bool opt_busy_poll;
+static bool opt_reduced_cap;
 
 struct xsk_ring_stats {
 	unsigned long rx_npkts;
@@ -154,6 +157,7 @@ struct xsk_socket_info {
 
 static int num_socks;
 struct xsk_socket_info *xsks[MAX_SOCKS];
+int sock;
 
 static unsigned long get_nsecs(void)
 {
@@ -461,6 +465,7 @@ static void *poller(void *arg)
 static void remove_xdp_program(void)
 {
 	u32 curr_prog_id = 0;
+	int cmd = CLOSE_CONN;
 
 	if (bpf_get_link_xdp_id(opt_ifindex, &curr_prog_id, opt_xdp_flags)) {
 		printf("bpf_get_link_xdp_id failed\n");
@@ -472,6 +477,13 @@ static void remove_xdp_program(void)
 		printf("couldn't find a prog id on a given interface\n");
 	else
 		printf("program on interface changed, not removing\n");
+
+	if (opt_reduced_cap) {
+		if (write(sock, &cmd, sizeof(int)) < 0) {
+			fprintf(stderr, "Error writing into stream socket: %s", strerror(errno));
+			exit(EXIT_FAILURE);
+		}
+	}
 }
 
 static void int_exit(int sig)
@@ -854,7 +866,7 @@ static struct xsk_socket_info *xsk_configure_socket(struct xsk_umem_info *umem,
 	xsk->umem = umem;
 	cfg.rx_size = XSK_RING_CONS__DEFAULT_NUM_DESCS;
 	cfg.tx_size = XSK_RING_PROD__DEFAULT_NUM_DESCS;
-	if (opt_num_xsks > 1)
+	if (opt_num_xsks > 1 || opt_reduced_cap)
 		cfg.libbpf_flags = XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD;
 	else
 		cfg.libbpf_flags = 0;
@@ -913,6 +925,7 @@ static struct option long_options[] = {
 	{"app-stats", no_argument, 0, 'a'},
 	{"irq-string", no_argument, 0, 'I'},
 	{"busy-poll", no_argument, 0, 'B'},
+	{"reduce-cap", no_argument, 0, 'R'},
 	{0, 0, 0, 0}
 };
 
@@ -935,7 +948,7 @@ static void usage(const char *prog)
 		"  -m, --no-need-wakeup Turn off use of driver need wakeup flag.\n"
 		"  -f, --frame-size=n   Set the frame size (must be a power of two in aligned mode, default is %d).\n"
 		"  -u, --unaligned	Enable unaligned chunk placement\n"
-		"  -M, --shared-umem	Enable XDP_SHARED_UMEM\n"
+		"  -M, --shared-umem	Enable XDP_SHARED_UMEM (cannot be used with -R)\n"
 		"  -F, --force		Force loading the XDP prog\n"
 		"  -d, --duration=n	Duration in secs to run command.\n"
 		"			Default: forever.\n"
@@ -952,6 +965,7 @@ static void usage(const char *prog)
 		"  -a, --app-stats	Display application (syscall) statistics.\n"
 		"  -I, --irq-string	Display driver interrupt statistics for interface associated with irq-string.\n"
 		"  -B, --busy-poll      Busy poll.\n"
+		"  -R, --reduce-cap	Use reduced capabilities (cannot be used with -M)\n"
 		"\n";
 	fprintf(stderr, str, prog, XSK_UMEM__DEFAULT_FRAME_SIZE,
 		opt_batch_size, MIN_PKT_SIZE, MIN_PKT_SIZE,
@@ -967,7 +981,7 @@ static void parse_command_line(int argc, char **argv)
 	opterr = 0;
 
 	for (;;) {
-		c = getopt_long(argc, argv, "Frtli:q:pSNn:czf:muMd:b:C:s:P:xQaI:B",
+		c = getopt_long(argc, argv, "Frtli:q:pSNn:czf:muMd:b:C:s:P:xQaI:BR",
 				long_options, &option_index);
 		if (c == -1)
 			break;
@@ -1069,6 +1083,9 @@ static void parse_command_line(int argc, char **argv)
 		case 'B':
 			opt_busy_poll = 1;
 			break;
+		case 'R':
+			opt_reduced_cap = true;
+			break;
 		default:
 			usage(basename(argv[0]));
 		}
@@ -1090,6 +1107,11 @@ static void parse_command_line(int argc, char **argv)
 			opt_xsk_frame_size);
 		usage(basename(argv[0]));
 	}
+
+	if (opt_reduced_cap && opt_num_xsks > 1) {
+		fprintf(stderr, "ERROR: -M and -R cannot be used together\n");
+		usage(basename(argv[0]));
+	}
 }
 
 static void kick_tx(struct xsk_socket_info *xsk)
@@ -1487,26 +1509,117 @@ static void apply_setsockopt(struct xsk_socket_info *xsk)
 		exit_with_error(errno);
 }
 
+static int recv_xsks_map_fd_from_ctrl_node(int sock, int *_fd)
+{
+	char cms[CMSG_SPACE(sizeof(int))];
+	struct cmsghdr *cmsg;
+	struct msghdr msg;
+	struct iovec iov;
+	int value;
+	int len;
+
+	iov.iov_base = &value;
+	iov.iov_len = sizeof(int);
+
+	msg.msg_name = 0;
+	msg.msg_namelen = 0;
+	msg.msg_iov = &iov;
+	msg.msg_iovlen = 1;
+	msg.msg_flags = 0;
+	msg.msg_control = (caddr_t)cms;
+	msg.msg_controllen = sizeof(cms);
+
+	len = recvmsg(sock, &msg, 0);
+
+	if (len < 0) {
+		fprintf(stderr, "Recvmsg failed length incorrect.\n");
+		return -EINVAL;
+	}
+
+	if (len == 0) {
+		fprintf(stderr, "Recvmsg failed no data\n");
+		return -EINVAL;
+	}
+
+	cmsg = CMSG_FIRSTHDR(&msg);
+	*_fd = *(int *)CMSG_DATA(cmsg);
+
+	return 0;
+}
+
+static int
+recv_xsks_map_fd(int *xsks_map_fd)
+{
+	struct sockaddr_un server;
+	int err;
+
+	sock = socket(AF_UNIX, SOCK_STREAM, 0);
+	if (sock < 0) {
+		fprintf(stderr, "Error opening socket stream: %s", strerror(errno));
+		return errno;
+	}
+
+	server.sun_family = AF_UNIX;
+	strcpy(server.sun_path, SOCKET_NAME);
+
+	if (connect(sock, (struct sockaddr *)&server, sizeof(struct sockaddr_un)) < 0) {
+		close(sock);
+		fprintf(stderr, "Error connecting stream socket: %s", strerror(errno));
+		return errno;
+	}
+
+	err = recv_xsks_map_fd_from_ctrl_node(sock, xsks_map_fd);
+	if (err) {
+		fprintf(stderr, "Error %d recieving fd\n", err);
+		return err;
+	}
+	return 0;
+}
+
 int main(int argc, char **argv)
 {
+	struct __user_cap_header_struct hdr = { _LINUX_CAPABILITY_VERSION_3, 0 };
+	struct __user_cap_data_struct data[2] = { { 0 } };
 	struct rlimit r = {RLIM_INFINITY, RLIM_INFINITY};
 	bool rx = false, tx = false;
 	struct xsk_umem_info *umem;
 	struct bpf_object *obj;
+	int xsks_map_fd = 0;
 	pthread_t pt;
 	int i, ret;
 	void *bufs;
 
 	parse_command_line(argc, argv);
 
-	if (setrlimit(RLIMIT_MEMLOCK, &r)) {
-		fprintf(stderr, "ERROR: setrlimit(RLIMIT_MEMLOCK) \"%s\"\n",
-			strerror(errno));
-		exit(EXIT_FAILURE);
+	if (opt_reduced_cap) {
+		if (capget(&hdr, data)  < 0)
+			fprintf(stderr, "Error getting capabilities\n");
+
+		data->effective &= CAP_TO_MASK(CAP_NET_RAW);
+		data->permitted &= CAP_TO_MASK(CAP_NET_RAW);
+
+		if (capset(&hdr, data) < 0)
+			fprintf(stderr, "Setting capabilities failed\n");
+
+		if (capget(&hdr, data)  < 0) {
+			fprintf(stderr, "Error getting capabilities\n");
+		} else {
+			fprintf(stderr, "Capabilities EFF %x Caps INH %x Caps Per %x\n",
+				data[0].effective, data[0].inheritable, data[0].permitted);
+			fprintf(stderr, "Capabilities EFF %x Caps INH %x Caps Per %x\n",
+				data[1].effective, data[1].inheritable, data[1].permitted);
+		}
+	} else {
+		if (setrlimit(RLIMIT_MEMLOCK, &r)) {
+			fprintf(stderr, "ERROR: setrlimit(RLIMIT_MEMLOCK) \"%s\"\n",
+				strerror(errno));
+			exit(EXIT_FAILURE);
+		}
+
+		if (opt_num_xsks > 1)
+			load_xdp_program(argv, &obj);
 	}
 
-	if (opt_num_xsks > 1)
-		load_xdp_program(argv, &obj);
 
 	/* Reserve memory for the umem. Use hugepages if unaligned chunk mode */
 	bufs = mmap(NULL, NUM_FRAMES * opt_xsk_frame_size,
@@ -1541,6 +1654,21 @@ int main(int argc, char **argv)
 	if (opt_num_xsks > 1 && opt_bench != BENCH_TXONLY)
 		enter_xsks_into_map(obj);
 
+	if (opt_reduced_cap) {
+		ret = recv_xsks_map_fd(&xsks_map_fd);
+		if (ret) {
+			fprintf(stderr, "Error %d receiving xsks_map_fd\n", ret);
+			exit_with_error(ret);
+		}
+		if (xsks[0]->xsk) {
+			ret = xsk_socket__update_xskmap(xsks[0]->xsk, xsks_map_fd);
+			if (ret) {
+				fprintf(stderr, "Update of BPF map failed(%d)\n", ret);
+				exit_with_error(ret);
+			}
+		}
+	}
+
 	signal(SIGINT, int_exit);
 	signal(SIGTERM, int_exit);
 	signal(SIGABRT, int_exit);
-- 
2.20.1


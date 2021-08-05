Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FDFF3E0F60
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 09:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238528AbhHEHhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 03:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238437AbhHEHhD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 03:37:03 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0566FC061765
        for <netdev@vger.kernel.org>; Thu,  5 Aug 2021 00:36:50 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id b9-20020a05620a1269b02903b8bd5c7d95so3647961qkl.12
        for <netdev@vger.kernel.org>; Thu, 05 Aug 2021 00:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=NQRWp2g2NfStif6k6z29c2YTuuBFYQaoUCZiUHyGFXs=;
        b=sSuBDt7vTpsveB1G8EpKGWXL9qSEMhnP8GIjZl7UxanDODTdp+t3mnwGmh5ceeSDT/
         R+wsNTRbbKA8otSebO7WXTDUsmc8/1CsfBWoitqvxyb6kflycDBOEpU9BZEdoUpiDAFe
         xQmP+xAvZF0XvNv0l8nUnTYFkWkDi7aPBbzX6OL0bWDgXb1NJBrp0S/yhPSSAJrBo+jb
         uib/8cj9z5jRXvqXcUSvyDyk9XALkVx2y5Q8RTMSyM2chP1E+DrkOm+XhgvskoJQBwr/
         KP/DE2DoNtTrFzm/EutJlAIGHRLTXz8JcJ93qQy4FExddWLBp0BW3IHaaNRj1CgpONVt
         eW0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=NQRWp2g2NfStif6k6z29c2YTuuBFYQaoUCZiUHyGFXs=;
        b=i0Qynj+qDS7pk5kfPVzg9IaJWKpj3MyAumDDXKD4mE44YRM/aOHuUquJfpzoMr4XJu
         MnCoSixptMo5ZuDhyagaq0PFmcg5hYTDCFXlRpJeTDv0s3d/UvUqPuFKfQUmBzXOYiAK
         R54nCPKNakzZK9tfQqafN/IUR1FqU86eoZ5e011+M8m6QrPi4o+mIoSuo7qT60+2jokt
         iaVkw+y00lQaGXe+TQ69JxbFjd7vV91+2PV0OET7mXzkbj+9eCrx48bf0DacbyNOz0DN
         1Ulxe7wbuGKhgBPj5PDopZ8/66oTaUNuUBoTT0Q0mfUGCvsxCQD58o6Xq4Kx+QBMpizE
         JHUw==
X-Gm-Message-State: AOAM531kjt+EEqRxeh0aKbPPH4T2gjVgj6ToWGxCwXeYlKoNf9nIvPCs
        gWwVj840EediS+yZOVI+pNAIWy92mjh9dJsajGWHrxmX/VAxIgh1sHl+j8Cgdu8VBzVXaesBZtT
        kbJ0bidUewEg/LAvHAOvhKGzoDiAULhmKeJQmfGemxXnLcqIAotKw6OyDPAg67cpIy/+YTQ==
X-Google-Smtp-Source: ABdhPJwx6D9rd6uBX3FiVecfhaT1WvHHupQSQXuBkntAVWoQCdIxkW+9UhT3sdMCu+ugEi8MTqvUZpD2Rf5Gerk=
X-Received: from coco0920.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:5738])
 (user=lixiaoyan job=sendgmr) by 2002:a05:6214:1230:: with SMTP id
 p16mr3950095qvv.42.1628149009131; Thu, 05 Aug 2021 00:36:49 -0700 (PDT)
Date:   Thu,  5 Aug 2021 07:36:41 +0000
In-Reply-To: <20210805073641.3533280-1-lixiaoyan@google.com>
Message-Id: <20210805073641.3533280-3-lixiaoyan@google.com>
Mime-Version: 1.0
References: <20210805073641.3533280-1-lixiaoyan@google.com>
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH net-next 2/2] selftests/net: toeplitz test
From:   Coco Li <lixiaoyan@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Coco Li <lixiaoyan@google.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To verify that this hash implements the Toeplitz hash function.

Additionally, provide a script toeplitz.sh to run the test in loopback mode
on a networking device of choice (see setup_loopback.sh). Since the
script modifies the NIC setup, it will not be run by selftests
automatically.

Tested:
./toeplitz.sh -i eth0 -irq_prefix <eth0_pattern> -t -6
carrier ready
rxq 0: cpu 14
rxq 1: cpu 20
rxq 2: cpu 17
rxq 3: cpu 23
cpu 14: rx_hash 0x69103ebc [saddr fda8::2 daddr fda8::1 sport 58938 dport 8000] OK rxq 0 (cpu 14)
...
cpu 20: rx_hash 0x257118b9 [saddr fda8::2 daddr fda8::1 sport 59258 dport 8000] OK rxq 1 (cpu 20)
count: pass=111 nohash=0 fail=0
Test Succeeded!

Signed-off-by: Coco Li <lixiaoyan@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
---
 tools/testing/selftests/net/Makefile          |   1 +
 tools/testing/selftests/net/toeplitz.c        | 585 ++++++++++++++++++
 tools/testing/selftests/net/toeplitz.sh       | 199 ++++++
 .../testing/selftests/net/toeplitz_client.sh  |  28 +
 4 files changed, 813 insertions(+)
 create mode 100644 tools/testing/selftests/net/toeplitz.c
 create mode 100755 tools/testing/selftests/net/toeplitz.sh
 create mode 100755 tools/testing/selftests/net/toeplitz_client.sh

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index a0981fcede2c..4f9f73e7a299 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -41,6 +41,7 @@ TEST_GEN_FILES += ioam6_parser
 TEST_GEN_FILES += gro
 TEST_GEN_PROGS = reuseport_bpf reuseport_bpf_cpu reuseport_bpf_numa
 TEST_GEN_PROGS += reuseport_dualstack reuseaddr_conflict tls
+TEST_GEN_FILES += toeplitz
 
 TEST_FILES := settings
 
diff --git a/tools/testing/selftests/net/toeplitz.c b/tools/testing/selftests/net/toeplitz.c
new file mode 100644
index 000000000000..710ac956bdb3
--- /dev/null
+++ b/tools/testing/selftests/net/toeplitz.c
@@ -0,0 +1,585 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Toeplitz test
+ *
+ * 1. Read packets and their rx_hash using PF_PACKET/TPACKET_V3
+ * 2. Compute the rx_hash in software based on the packet contents
+ * 3. Compare the two
+ *
+ * Optionally, either '-C $rx_irq_cpu_list' or '-r $rps_bitmap' may be given.
+ *
+ * If '-C $rx_irq_cpu_list' is given, also
+ *
+ * 4. Identify the cpu on which the packet arrived with PACKET_FANOUT_CPU
+ * 5. Compute the rxqueue that RSS would select based on this rx_hash
+ * 6. Using the $rx_irq_cpu_list map, identify the arriving cpu based on rxq irq
+ * 7. Compare the cpus from 4 and 6
+ *
+ * Else if '-r $rps_bitmap' is given, also
+ *
+ * 4. Identify the cpu on which the packet arrived with PACKET_FANOUT_CPU
+ * 5. Compute the cpu that RPS should select based on rx_hash and $rps_bitmap
+ * 6. Compare the cpus from 4 and 5
+ */
+
+#define _GNU_SOURCE
+
+#include <arpa/inet.h>
+#include <errno.h>
+#include <error.h>
+#include <fcntl.h>
+#include <getopt.h>
+#include <linux/filter.h>
+#include <linux/if_ether.h>
+#include <linux/if_packet.h>
+#include <net/if.h>
+#include <netdb.h>
+#include <netinet/ip.h>
+#include <netinet/ip6.h>
+#include <netinet/tcp.h>
+#include <netinet/udp.h>
+#include <poll.h>
+#include <stdbool.h>
+#include <stddef.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/mman.h>
+#include <sys/socket.h>
+#include <sys/stat.h>
+#include <sys/sysinfo.h>
+#include <sys/time.h>
+#include <sys/types.h>
+#include <unistd.h>
+
+#define TOEPLITZ_KEY_MIN_LEN	40
+#define TOEPLITZ_KEY_MAX_LEN	60
+
+#define TOEPLITZ_STR_LEN(K)	(((K) * 3) - 1)	/* hex encoded: AA:BB:CC:...:ZZ */
+#define TOEPLITZ_STR_MIN_LEN	TOEPLITZ_STR_LEN(TOEPLITZ_KEY_MIN_LEN)
+#define TOEPLITZ_STR_MAX_LEN	TOEPLITZ_STR_LEN(TOEPLITZ_KEY_MAX_LEN)
+
+#define FOUR_TUPLE_MAX_LEN	((sizeof(struct in6_addr) * 2) + (sizeof(uint16_t) * 2))
+
+#define RSS_MAX_CPUS (1 << 16)	/* real constraint is PACKET_FANOUT_MAX */
+
+#define RPS_MAX_CPUS 16UL	/* must be a power of 2 */
+
+/* configuration options (cmdline arguments) */
+static uint16_t cfg_dport =	8000;
+static int cfg_family =		AF_INET6;
+static char *cfg_ifname =	"eth0";
+static int cfg_num_queues;
+static int cfg_num_rps_cpus;
+static bool cfg_sink;
+static int cfg_type =		SOCK_STREAM;
+static int cfg_timeout_msec =	1000;
+static bool cfg_verbose;
+
+/* global vars */
+static int num_cpus;
+static int ring_block_nr;
+static int ring_block_sz;
+
+/* stats */
+static int frames_received;
+static int frames_nohash;
+static int frames_error;
+
+#define log_verbose(args...)	do { if (cfg_verbose) fprintf(stderr, args); } while (0)
+
+/* tpacket ring */
+struct ring_state {
+	int fd;
+	char *mmap;
+	int idx;
+	int cpu;
+};
+
+static unsigned int rx_irq_cpus[RSS_MAX_CPUS];	/* map from rxq to cpu */
+static int rps_silo_to_cpu[RPS_MAX_CPUS];
+static unsigned char toeplitz_key[TOEPLITZ_KEY_MAX_LEN];
+static struct ring_state rings[RSS_MAX_CPUS];
+
+static inline uint32_t toeplitz(const unsigned char *four_tuple,
+				const unsigned char *key)
+{
+	int i, bit, ret = 0;
+	uint32_t key32;
+
+	key32 = ntohl(*((uint32_t *)key));
+	key += 4;
+
+	for (i = 0; i < FOUR_TUPLE_MAX_LEN; i++) {
+		for (bit = 7; bit >= 0; bit--) {
+			if (four_tuple[i] & (1 << bit))
+				ret ^= key32;
+
+			key32 <<= 1;
+			key32 |= !!(key[0] & (1 << bit));
+		}
+		key++;
+	}
+
+	return ret;
+}
+
+/* Compare computed cpu with arrival cpu from packet_fanout_cpu */
+static void verify_rss(uint32_t rx_hash, int cpu)
+{
+	int queue = rx_hash % cfg_num_queues;
+
+	log_verbose(" rxq %d (cpu %d)", queue, rx_irq_cpus[queue]);
+	if (rx_irq_cpus[queue] != cpu) {
+		log_verbose(". error: rss cpu mismatch (%d)", cpu);
+		frames_error++;
+	}
+}
+
+static void verify_rps(uint64_t rx_hash, int cpu)
+{
+	int silo = (rx_hash * cfg_num_rps_cpus) >> 32;
+
+	log_verbose(" silo %d (cpu %d)", silo, rps_silo_to_cpu[silo]);
+	if (rps_silo_to_cpu[silo] != cpu) {
+		log_verbose(". error: rps cpu mismatch (%d)", cpu);
+		frames_error++;
+	}
+}
+
+static void log_rxhash(int cpu, uint32_t rx_hash,
+		       const char *addrs, int addr_len)
+{
+	char saddr[INET6_ADDRSTRLEN], daddr[INET6_ADDRSTRLEN];
+	uint16_t *ports;
+
+	if (!inet_ntop(cfg_family, addrs, saddr, sizeof(saddr)) ||
+	    !inet_ntop(cfg_family, addrs + addr_len, daddr, sizeof(daddr)))
+		error(1, 0, "address parse error");
+
+	ports = (void *)addrs + (addr_len * 2);
+	log_verbose("cpu %d: rx_hash 0x%08x [saddr %s daddr %s sport %02hu dport %02hu]",
+		    cpu, rx_hash, saddr, daddr,
+		    ntohs(ports[0]), ntohs(ports[1]));
+}
+
+/* Compare computed rxhash with rxhash received from tpacket_v3 */
+static void verify_rxhash(const char *pkt, uint32_t rx_hash, int cpu)
+{
+	unsigned char four_tuple[FOUR_TUPLE_MAX_LEN] = {0};
+	uint32_t rx_hash_sw;
+	const char *addrs;
+	int addr_len;
+
+	if (cfg_family == AF_INET) {
+		addr_len = sizeof(struct in_addr);
+		addrs = pkt + offsetof(struct iphdr, saddr);
+	} else {
+		addr_len = sizeof(struct in6_addr);
+		addrs = pkt + offsetof(struct ip6_hdr, ip6_src);
+	}
+
+	memcpy(four_tuple, addrs, (addr_len * 2) + (sizeof(uint16_t) * 2));
+	rx_hash_sw = toeplitz(four_tuple, toeplitz_key);
+
+	if (cfg_verbose)
+		log_rxhash(cpu, rx_hash, addrs, addr_len);
+
+	if (rx_hash != rx_hash_sw) {
+		log_verbose(" != expected 0x%x\n", rx_hash_sw);
+		frames_error++;
+		return;
+	}
+
+	log_verbose(" OK");
+	if (cfg_num_queues)
+		verify_rss(rx_hash, cpu);
+	else if (cfg_num_rps_cpus)
+		verify_rps(rx_hash, cpu);
+	log_verbose("\n");
+}
+
+static char *recv_frame(const struct ring_state *ring, char *frame)
+{
+	struct tpacket3_hdr *hdr = (void *)frame;
+
+	if (hdr->hv1.tp_rxhash)
+		verify_rxhash(frame + hdr->tp_net, hdr->hv1.tp_rxhash,
+			      ring->cpu);
+	else
+		frames_nohash++;
+
+	return frame + hdr->tp_next_offset;
+}
+
+/* A single TPACKET_V3 block can hold multiple frames */
+static void recv_block(struct ring_state *ring)
+{
+	struct tpacket_block_desc *block;
+	char *frame;
+	int i;
+
+	block = (void *)(ring->mmap + ring->idx * ring_block_sz);
+	if (!(block->hdr.bh1.block_status & TP_STATUS_USER))
+		return;
+
+	frame = (char *)block;
+	frame += block->hdr.bh1.offset_to_first_pkt;
+
+	for (i = 0; i < block->hdr.bh1.num_pkts; i++) {
+		frame = recv_frame(ring, frame);
+		frames_received++;
+	}
+
+	block->hdr.bh1.block_status = TP_STATUS_KERNEL;
+	ring->idx = (ring->idx + 1) % ring_block_nr;
+}
+
+/* simple test: sleep once unconditionally and then process all rings */
+static void process_rings(void)
+{
+	int i;
+
+	usleep(1000 * cfg_timeout_msec);
+
+	for (i = 0; i < num_cpus; i++)
+		recv_block(&rings[i]);
+
+	fprintf(stderr, "count: pass=%u nohash=%u fail=%u\n",
+		frames_received - frames_nohash - frames_error,
+		frames_nohash, frames_error);
+}
+
+static char *setup_ring(int fd)
+{
+	struct tpacket_req3 req3 = {0};
+	void *ring;
+
+	req3.tp_retire_blk_tov = cfg_timeout_msec;
+	req3.tp_feature_req_word = TP_FT_REQ_FILL_RXHASH;
+
+	req3.tp_frame_size = 2048;
+	req3.tp_frame_nr = 1 << 10;
+	req3.tp_block_nr = 2;
+
+	req3.tp_block_size = req3.tp_frame_size * req3.tp_frame_nr;
+	req3.tp_block_size /= req3.tp_block_nr;
+
+	if (setsockopt(fd, SOL_PACKET, PACKET_RX_RING, &req3, sizeof(req3)))
+		error(1, errno, "setsockopt PACKET_RX_RING");
+
+	ring_block_sz = req3.tp_block_size;
+	ring_block_nr = req3.tp_block_nr;
+
+	ring = mmap(0, req3.tp_block_size * req3.tp_block_nr,
+		    PROT_READ | PROT_WRITE,
+		    MAP_SHARED | MAP_LOCKED | MAP_POPULATE, fd, 0);
+	if (ring == MAP_FAILED)
+		error(1, 0, "mmap failed");
+
+	return ring;
+}
+
+static void __set_filter(int fd, int off_proto, uint8_t proto, int off_dport)
+{
+	struct sock_filter filter[] = {
+		BPF_STMT(BPF_LD  + BPF_B   + BPF_ABS, SKF_AD_OFF + SKF_AD_PKTTYPE),
+		BPF_JUMP(BPF_JMP + BPF_JEQ + BPF_K, PACKET_HOST, 0, 4),
+		BPF_STMT(BPF_LD  + BPF_B   + BPF_ABS, off_proto),
+		BPF_JUMP(BPF_JMP + BPF_JEQ + BPF_K, proto, 0, 2),
+		BPF_STMT(BPF_LD  + BPF_H   + BPF_ABS, off_dport),
+		BPF_JUMP(BPF_JMP + BPF_JEQ + BPF_K, cfg_dport, 1, 0),
+		BPF_STMT(BPF_RET + BPF_K, 0),
+		BPF_STMT(BPF_RET + BPF_K, 0xFFFF),
+	};
+	struct sock_fprog prog = {};
+
+	prog.filter = filter;
+	prog.len = sizeof(filter) / sizeof(struct sock_filter);
+	if (setsockopt(fd, SOL_SOCKET, SO_ATTACH_FILTER, &prog, sizeof(prog)))
+		error(1, errno, "setsockopt filter");
+}
+
+/* filter on transport protocol and destination port */
+static void set_filter(int fd)
+{
+	const int off_dport = offsetof(struct tcphdr, dest);	/* same for udp */
+	uint8_t proto;
+
+	proto = cfg_type == SOCK_STREAM ? IPPROTO_TCP : IPPROTO_UDP;
+	if (cfg_family == AF_INET)
+		__set_filter(fd, offsetof(struct iphdr, protocol), proto,
+			     sizeof(struct iphdr) + off_dport);
+	else
+		__set_filter(fd, offsetof(struct ip6_hdr, ip6_nxt), proto,
+			     sizeof(struct ip6_hdr) + off_dport);
+}
+
+/* drop everything: used temporarily during setup */
+static void set_filter_null(int fd)
+{
+	struct sock_filter filter[] = {
+		BPF_STMT(BPF_RET + BPF_K, 0),
+	};
+	struct sock_fprog prog = {};
+
+	prog.filter = filter;
+	prog.len = sizeof(filter) / sizeof(struct sock_filter);
+	if (setsockopt(fd, SOL_SOCKET, SO_ATTACH_FILTER, &prog, sizeof(prog)))
+		error(1, errno, "setsockopt filter");
+}
+
+static int create_ring(char **ring)
+{
+	struct fanout_args args = {
+		.id = 1,
+		.type_flags = PACKET_FANOUT_CPU,
+		.max_num_members = RSS_MAX_CPUS
+	};
+	struct sockaddr_ll ll = { 0 };
+	int fd, val;
+
+	fd = socket(PF_PACKET, SOCK_DGRAM, 0);
+	if (fd == -1)
+		error(1, errno, "socket creation failed");
+
+	val = TPACKET_V3;
+	if (setsockopt(fd, SOL_PACKET, PACKET_VERSION, &val, sizeof(val)))
+		error(1, errno, "setsockopt PACKET_VERSION");
+	*ring = setup_ring(fd);
+
+	/* block packets until all rings are added to the fanout group:
+	 * else packets can arrive during setup and get misclassified
+	 */
+	set_filter_null(fd);
+
+	ll.sll_family = AF_PACKET;
+	ll.sll_ifindex = if_nametoindex(cfg_ifname);
+	ll.sll_protocol = cfg_family == AF_INET ? htons(ETH_P_IP) :
+						  htons(ETH_P_IPV6);
+	if (bind(fd, (void *)&ll, sizeof(ll)))
+		error(1, errno, "bind");
+
+	/* must come after bind: verifies all programs in group match */
+	if (setsockopt(fd, SOL_PACKET, PACKET_FANOUT, &args, sizeof(args))) {
+		/* on failure, retry using old API if that is sufficient:
+		 * it has a hard limit of 256 sockets, so only try if
+		 * (a) only testing rxhash, not RSS or (b) <= 256 cpus.
+		 * in this API, the third argument is left implicit.
+		 */
+		if (cfg_num_queues || num_cpus > 256 ||
+		    setsockopt(fd, SOL_PACKET, PACKET_FANOUT,
+			       &args, sizeof(uint32_t)))
+			error(1, errno, "setsockopt PACKET_FANOUT cpu");
+	}
+
+	return fd;
+}
+
+/* setup inet(6) socket to blackhole the test traffic, if arg '-s' */
+static int setup_sink(void)
+{
+	int fd, val;
+
+	fd = socket(cfg_family, cfg_type, 0);
+	if (fd == -1)
+		error(1, errno, "socket %d.%d", cfg_family, cfg_type);
+
+	val = 1 << 20;
+	if (setsockopt(fd, SOL_SOCKET, SO_RCVBUFFORCE, &val, sizeof(val)))
+		error(1, errno, "setsockopt rcvbuf");
+
+	return fd;
+}
+
+static void setup_rings(void)
+{
+	int i;
+
+	for (i = 0; i < num_cpus; i++) {
+		rings[i].cpu = i;
+		rings[i].fd = create_ring(&rings[i].mmap);
+	}
+
+	/* accept packets once all rings in the fanout group are up */
+	for (i = 0; i < num_cpus; i++)
+		set_filter(rings[i].fd);
+}
+
+static void cleanup_rings(void)
+{
+	int i;
+
+	for (i = 0; i < num_cpus; i++) {
+		if (munmap(rings[i].mmap, ring_block_nr * ring_block_sz))
+			error(1, errno, "munmap");
+		if (close(rings[i].fd))
+			error(1, errno, "close");
+	}
+}
+
+static void parse_cpulist(const char *arg)
+{
+	do {
+		rx_irq_cpus[cfg_num_queues++] = strtol(arg, NULL, 10);
+
+		arg = strchr(arg, ',');
+		if (!arg)
+			break;
+		arg++;			// skip ','
+	} while (1);
+}
+
+static void show_cpulist(void)
+{
+	int i;
+
+	for (i = 0; i < cfg_num_queues; i++)
+		fprintf(stderr, "rxq %d: cpu %d\n", i, rx_irq_cpus[i]);
+}
+
+static void show_silos(void)
+{
+	int i;
+
+	for (i = 0; i < cfg_num_rps_cpus; i++)
+		fprintf(stderr, "silo %d: cpu %d\n", i, rps_silo_to_cpu[i]);
+}
+
+static void parse_toeplitz_key(const char *str, int slen, unsigned char *key)
+{
+	int i, ret, off;
+
+	if (slen < TOEPLITZ_STR_MIN_LEN ||
+	    slen > TOEPLITZ_STR_MAX_LEN + 1)
+		error(1, 0, "invalid toeplitz key");
+
+	for (i = 0, off = 0; off < slen; i++, off += 3) {
+		ret = sscanf(str + off, "%hhx", &key[i]);
+		if (ret != 1)
+			error(1, 0, "key parse error at %d off %d len %d",
+			      i, off, slen);
+	}
+}
+
+static void parse_rps_bitmap(const char *arg)
+{
+	unsigned long bitmap;
+	int i;
+
+	bitmap = strtoul(arg, NULL, 0);
+
+	if (bitmap & ~(RPS_MAX_CPUS - 1))
+		error(1, 0, "rps bitmap 0x%lx out of bounds 0..%lu",
+		      bitmap, RPS_MAX_CPUS - 1);
+
+	for (i = 0; i < RPS_MAX_CPUS; i++)
+		if (bitmap & 1UL << i)
+			rps_silo_to_cpu[cfg_num_rps_cpus++] = i;
+}
+
+static void parse_opts(int argc, char **argv)
+{
+	static struct option long_options[] = {
+	    {"dport",	required_argument, 0, 'd'},
+	    {"cpus",	required_argument, 0, 'C'},
+	    {"key",	required_argument, 0, 'k'},
+	    {"iface",	required_argument, 0, 'i'},
+	    {"ipv4",	no_argument, 0, '4'},
+	    {"ipv6",	no_argument, 0, '6'},
+	    {"sink",	no_argument, 0, 's'},
+	    {"tcp",	no_argument, 0, 't'},
+	    {"timeout",	required_argument, 0, 'T'},
+	    {"udp",	no_argument, 0, 'u'},
+	    {"verbose",	no_argument, 0, 'v'},
+	    {"rps",	required_argument, 0, 'r'},
+	    {0, 0, 0, 0}
+	};
+	bool have_toeplitz = false;
+	int index, c;
+
+	while ((c = getopt_long(argc, argv, "46C:d:i:k:r:stT:u:v", long_options, &index)) != -1) {
+		switch (c) {
+		case '4':
+			cfg_family = AF_INET;
+			break;
+		case '6':
+			cfg_family = AF_INET6;
+			break;
+		case 'C':
+			parse_cpulist(optarg);
+			break;
+		case 'd':
+			cfg_dport = strtol(optarg, NULL, 0);
+			break;
+		case 'i':
+			cfg_ifname = optarg;
+			break;
+		case 'k':
+			parse_toeplitz_key(optarg, strlen(optarg),
+					   toeplitz_key);
+			have_toeplitz = true;
+			break;
+		case 'r':
+			parse_rps_bitmap(optarg);
+			break;
+		case 's':
+			cfg_sink = true;
+			break;
+		case 't':
+			cfg_type = SOCK_STREAM;
+			break;
+		case 'T':
+			cfg_timeout_msec = strtol(optarg, NULL, 0);
+			break;
+		case 'u':
+			cfg_type = SOCK_DGRAM;
+			break;
+		case 'v':
+			cfg_verbose = true;
+			break;
+
+		default:
+			error(1, 0, "unknown option %c", optopt);
+			break;
+		}
+	}
+
+	if (!have_toeplitz)
+		error(1, 0, "Must supply rss key ('-k')");
+
+	num_cpus = get_nprocs();
+	if (num_cpus > RSS_MAX_CPUS)
+		error(1, 0, "increase RSS_MAX_CPUS");
+
+	if (cfg_num_queues && cfg_num_rps_cpus)
+		error(1, 0,
+		      "Can't supply both RSS cpus ('-C') and RPS map ('-r')");
+	if (cfg_verbose) {
+		show_cpulist();
+		show_silos();
+	}
+}
+
+int main(int argc, char **argv)
+{
+	const int min_tests = 10;
+	int fd_sink = -1;
+
+	parse_opts(argc, argv);
+
+	if (cfg_sink)
+		fd_sink = setup_sink();
+
+	setup_rings();
+	process_rings();
+	cleanup_rings();
+
+	if (cfg_sink && close(fd_sink))
+		error(1, errno, "close sink");
+
+	if (frames_received - frames_nohash < min_tests)
+		error(1, 0, "too few frames for verification");
+
+	return frames_error;
+}
diff --git a/tools/testing/selftests/net/toeplitz.sh b/tools/testing/selftests/net/toeplitz.sh
new file mode 100755
index 000000000000..0a49907cd4fe
--- /dev/null
+++ b/tools/testing/selftests/net/toeplitz.sh
@@ -0,0 +1,199 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# extended toeplitz test: test rxhash plus, optionally, either (1) rss mapping
+# from rxhash to rx queue ('-rss') or (2) rps mapping from rxhash to cpu
+# ('-rps <rps_map>')
+#
+# irq-pattern-prefix can be derived from /sys/kernel/irq/*/action,
+# which is a driver-specific encoding.
+#
+# invoke as ./toeplitz.sh (-i <iface>) -u|-t -4|-6 \
+# [(-rss -irq_prefix <irq-pattern-prefix>)|(-rps <rps_map>)]
+
+source setup_loopback.sh
+readonly SERVER_IP4="192.168.1.200/24"
+readonly SERVER_IP6="fda8::1/64"
+readonly SERVER_MAC="aa:00:00:00:00:02"
+
+readonly CLIENT_IP4="192.168.1.100/24"
+readonly CLIENT_IP6="fda8::2/64"
+readonly CLIENT_MAC="aa:00:00:00:00:01"
+
+PORT=8000
+KEY="$(</proc/sys/net/core/netdev_rss_key)"
+TEST_RSS=false
+RPS_MAP=""
+PROTO_FLAG=""
+IP_FLAG=""
+DEV="eth0"
+
+# Return the number of rxqs among which RSS is configured to spread packets.
+# This is determined by reading the RSS indirection table using ethtool.
+get_rss_cfg_num_rxqs() {
+	echo $(ethtool -x "${DEV}" |
+		egrep [[:space:]]+[0-9]+:[[:space:]]+ |
+		cut -d: -f2- |
+		awk '{$1=$1};1' |
+		tr ' ' '\n' |
+		sort -u |
+		wc -l)
+}
+
+# Return a list of the receive irq handler cpus.
+# The list is ordered by the irqs, so first rxq-0 cpu, then rxq-1 cpu, etc.
+# Reads /sys/kernel/irq/ in order, so algorithm depends on
+# irq_{rxq-0} < irq_{rxq-1}, etc.
+get_rx_irq_cpus() {
+	CPUS=""
+	# sort so that irq 2 is read before irq 10
+	SORTED_IRQS=$(for i in /sys/kernel/irq/*; do echo $i; done | sort -V)
+	# Consider only as many queues as RSS actually uses. We assume that
+	# if RSS_CFG_NUM_RXQS=N, then RSS uses rxqs 0-(N-1).
+	RSS_CFG_NUM_RXQS=$(get_rss_cfg_num_rxqs)
+	RXQ_COUNT=0
+
+	for i in ${SORTED_IRQS}
+	do
+		[[ "${RXQ_COUNT}" -lt "${RSS_CFG_NUM_RXQS}" ]] || break
+		# lookup relevant IRQs by action name
+		[[ -e "$i/actions" ]] || continue
+		cat "$i/actions" | grep -q "${IRQ_PATTERN}" || continue
+		irqname=$(<"$i/actions")
+
+		# does the IRQ get called
+		irqcount=$(cat "$i/per_cpu_count" | tr -d '0,')
+		[[ -n "${irqcount}" ]] || continue
+
+		# lookup CPU
+		irq=$(basename "$i")
+		cpu=$(cat "/proc/irq/$irq/smp_affinity_list")
+
+		if [[ -z "${CPUS}" ]]; then
+			CPUS="${cpu}"
+		else
+			CPUS="${CPUS},${cpu}"
+		fi
+		RXQ_COUNT=$((RXQ_COUNT+1))
+	done
+
+	echo "${CPUS}"
+}
+
+get_disable_rfs_cmd() {
+	echo "echo 0 > /proc/sys/net/core/rps_sock_flow_entries;"
+}
+
+get_set_rps_bitmaps_cmd() {
+	CMD=""
+	for i in /sys/class/net/${DEV}/queues/rx-*/rps_cpus
+	do
+		CMD="${CMD} echo $1 > ${i};"
+	done
+
+	echo "${CMD}"
+}
+
+get_disable_rps_cmd() {
+	echo "$(get_set_rps_bitmaps_cmd 0)"
+}
+
+die() {
+	echo "$1"
+	exit 1
+}
+
+check_nic_rxhash_enabled() {
+	local -r pattern="receive-hashing:\ on"
+
+	ethtool -k "${DEV}" | grep -q "${pattern}" || die "rxhash must be enabled"
+}
+
+parse_opts() {
+	local prog=$0
+	shift 1
+
+	while [[ "$1" =~ "-" ]]; do
+		if [[ "$1" = "-irq_prefix" ]]; then
+			shift
+			IRQ_PATTERN="^$1-[0-9]*$"
+		elif [[ "$1" = "-u" || "$1" = "-t" ]]; then
+			PROTO_FLAG="$1"
+		elif [[ "$1" = "-4" ]]; then
+			IP_FLAG="$1"
+			SERVER_IP="${SERVER_IP4}"
+			CLIENT_IP="${CLIENT_IP4}"
+		elif [[ "$1" = "-6" ]]; then
+			IP_FLAG="$1"
+			SERVER_IP="${SERVER_IP6}"
+			CLIENT_IP="${CLIENT_IP6}"
+		elif [[ "$1" = "-rss" ]]; then
+			TEST_RSS=true
+		elif [[ "$1" = "-rps" ]]; then
+			shift
+			RPS_MAP="$1"
+		elif [[ "$1" = "-i" ]]; then
+			shift
+			DEV="$1"
+		else
+			die "Usage: ${prog} (-i <iface>) -u|-t -4|-6 \
+			     [(-rss -irq_prefix <irq-pattern-prefix>)|(-rps <rps_map>)]"
+		fi
+		shift
+	done
+}
+
+setup() {
+	setup_loopback_environment "${DEV}"
+
+	# Set up server_ns namespace and client_ns namespace
+	setup_macvlan_ns "${DEV}" server_ns server \
+	"${SERVER_MAC}" "${SERVER_IP}"
+	setup_macvlan_ns "${DEV}" client_ns client \
+	"${CLIENT_MAC}" "${CLIENT_IP}"
+}
+
+cleanup() {
+	cleanup_macvlan_ns server_ns server client_ns client
+	cleanup_loopback "${DEV}"
+}
+
+parse_opts $0 $@
+
+setup
+trap cleanup EXIT
+
+check_nic_rxhash_enabled
+
+# Actual test starts here
+if [[ "${TEST_RSS}" = true ]]; then
+	# RPS/RFS must be disabled because they move packets between cpus,
+	# which breaks the PACKET_FANOUT_CPU identification of RSS decisions.
+	eval "$(get_disable_rfs_cmd) $(get_disable_rps_cmd)" \
+	  ip netns exec server_ns ./toeplitz "${IP_FLAG}" "${PROTO_FLAG}" \
+	  -d "${PORT}" -i "${DEV}" -k "${KEY}" -T 1000 \
+	  -C "$(get_rx_irq_cpus)" -s -v &
+elif [[ ! -z "${RPS_MAP}" ]]; then
+	eval "$(get_disable_rfs_cmd) $(get_set_rps_bitmaps_cmd ${RPS_MAP})" \
+	  ip netns exec server_ns ./toeplitz "${IP_FLAG}" "${PROTO_FLAG}" \
+	  -d "${PORT}" -i "${DEV}" -k "${KEY}" -T 1000 \
+	  -r "0x${RPS_MAP}" -s -v &
+else
+	ip netns exec server_ns ./toeplitz "${IP_FLAG}" "${PROTO_FLAG}" \
+	  -d "${PORT}" -i "${DEV}" -k "${KEY}" -T 1000 -s -v &
+fi
+
+server_pid=$!
+
+ip netns exec client_ns ./toeplitz_client.sh "${PROTO_FLAG}" \
+  "${IP_FLAG}" "${SERVER_IP%%/*}" "${PORT}" &
+
+client_pid=$!
+
+wait "${server_pid}"
+exit_code=$?
+kill -9 "${client_pid}"
+if [[ "${exit_code}" -eq 0 ]]; then
+	echo "Test Succeeded!"
+fi
+exit "${exit_code}"
diff --git a/tools/testing/selftests/net/toeplitz_client.sh b/tools/testing/selftests/net/toeplitz_client.sh
new file mode 100755
index 000000000000..2fef34f4aba1
--- /dev/null
+++ b/tools/testing/selftests/net/toeplitz_client.sh
@@ -0,0 +1,28 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# A simple program for generating traffic for the toeplitz test.
+#
+# This program sends packets periodically for, conservatively, 20 seconds. The
+# intent is for the calling program to kill this program once it is no longer
+# needed, rather than waiting for the 20 second expiration.
+
+send_traffic() {
+	expiration=$((SECONDS+20))
+	while [[ "${SECONDS}" -lt "${expiration}" ]]
+	do
+		if [[ "${PROTO}" == "-u" ]]; then
+			echo "msg $i" | nc "${IPVER}" -u -w 0 "${ADDR}" "${PORT}"
+		else
+			echo "msg $i" | nc "${IPVER}" -w 0 "${ADDR}" "${PORT}"
+		fi
+		sleep 0.001
+	done
+}
+
+PROTO=$1
+IPVER=$2
+ADDR=$3
+PORT=$4
+
+send_traffic
-- 
2.32.0.554.ge1b32706d8-goog


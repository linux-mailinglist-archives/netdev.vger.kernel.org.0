Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 444043A163C
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 15:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236939AbhFIN6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 09:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236832AbhFIN6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 09:58:07 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A628BC0617A8;
        Wed,  9 Jun 2021 06:55:57 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id f17so4087649wmf.2;
        Wed, 09 Jun 2021 06:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1oV/DQR+6uAg1LS3J/53PTF/z6vGGDElflIOEcl8ULM=;
        b=Tqh74Xo0+8K9XzEgkvRPDiMudt1oLUuyRYSizOY6A3ALqUtgM0eutPpsuz36vDNbFT
         jSqunBXi8CYF/IVbiK0JaQZNi+zNi+/i6qeB926+SqzS0FmfQtSjBm6a2LZV9H5VWBCs
         wGHpoU62+AY3XkhsoIddTUbNQ2RSUrXHU9rmFqitwZm95rQbzLT8TRw6Gin2lOz3BQeg
         PRoZaZ3zrbkQ729k4iedhVjCzaI3R8p//jOJvaV7SXDfYlHDfUr8s7X4FIl6i29WLuhS
         y7yC3U+UURJB2T3WcanJxppjXpLF2f0ATZA5fWUsdbwsR2wn8Kw1LZmqAN1oStmMt7RZ
         Mqvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1oV/DQR+6uAg1LS3J/53PTF/z6vGGDElflIOEcl8ULM=;
        b=n6/zE4LSnhm6Mq6Q3jnb5/3z2b05NOFUzxqX6SuKO0IJeHjiu7+SAtTMoSnmvsxFMj
         BL34rASTi+iUUWgSqV1nVTRZOa9WZLch0dJG5cg1e1Oz7DrPg3tNzo+0agVn18w7pNQ9
         6gqCBoFECWQOl/6GUbA+kTrf9uwJNw5ssf6JlTBi1VU2zNm3aJPxwx88aXn1OO16lPxg
         BC3bOxTReX1QDzllsevpifQp+V+JAWur16IGfkHkRRFXw9AJUZ6Q17lmaipiif1VffqE
         PBZLwhxdJ6wQnSD6bVAD3OYdAVgveikkBwmcE0sGPNYsrPJ+7+D+GGYjIK1qquNH6sL1
         3BpQ==
X-Gm-Message-State: AOAM531m/DFJr1ZBKCTfyqrOwq8fnmYDVKGpDsanQ7Wy9CfSRHgc2Dbd
        TH61wg9tlnuaqgGRtqwip/5vDvE6o63DUeY=
X-Google-Smtp-Source: ABdhPJwod548NVF1EY2JrKqKh+q4L0IKZ1p22rA/Wh8RGttQiDQPgtIifyhNHwJKA0pnk/du2n+QcQ==
X-Received: by 2002:a7b:c193:: with SMTP id y19mr28369337wmi.172.1623246955837;
        Wed, 09 Jun 2021 06:55:55 -0700 (PDT)
Received: from balnab.. ([37.17.237.224])
        by smtp.gmail.com with ESMTPSA id q20sm4575wrf.45.2021.06.09.06.55.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 06:55:55 -0700 (PDT)
From:   Jussi Maki <joamaki@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, j.vosburgh@gmail.com,
        andy@greyhouse.net, vfalico@gmail.com, andrii@kernel.org,
        Jussi Maki <joamaki@gmail.com>
Subject: [PATCH bpf-next 3/3] selftests/bpf: Add tests for XDP bonding
Date:   Wed,  9 Jun 2021 13:55:37 +0000
Message-Id: <20210609135537.1460244-4-joamaki@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210609135537.1460244-1-joamaki@gmail.com>
References: <20210609135537.1460244-1-joamaki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a test suite to test XDP bonding implementation
over a pair of veth devices.

Signed-off-by: Jussi Maki <joamaki@gmail.com>
---
 .../selftests/bpf/prog_tests/xdp_bonding.c    | 342 ++++++++++++++++++
 tools/testing/selftests/bpf/vmtest.sh         |  30 +-
 2 files changed, 360 insertions(+), 12 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_bonding.c

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_bonding.c b/tools/testing/selftests/bpf/prog_tests/xdp_bonding.c
new file mode 100644
index 000000000000..fd2b83194127
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_bonding.c
@@ -0,0 +1,342 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/**
+ * Test XDP bonding support
+ *
+ * Sets up two bonded veth pairs between two fresh namespaces
+ * and verifies that XDP_TX program loaded on a bond device
+ * are correctly loaded onto the slave devices and XDP_TX'd
+ * packets are balanced using bonding.
+ */
+
+#define _GNU_SOURCE
+#include <sched.h>
+#include <stdio.h>
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <fcntl.h>
+#include <net/if.h>
+#include <test_progs.h>
+#include <network_helpers.h>
+#include <linux/if_bonding.h>
+#include <linux/limits.h>
+#include <linux/if_ether.h>
+#include <linux/udp.h>
+
+#define BOND1_MAC {0x00, 0x11, 0x22, 0x33, 0x44, 0x55}
+#define BOND1_MAC_STR "00:11:22:33:44:55"
+#define BOND2_MAC {0x00, 0x22, 0x33, 0x44, 0x55, 0x66}
+#define BOND2_MAC_STR "00:22:33:44:55:66"
+#define NPACKETS 100
+
+static int root_netns_fd = -1;
+
+static void restore_root_netns(void)
+{
+	ASSERT_OK(setns(root_netns_fd, CLONE_NEWNET), "restore_root_netns");
+}
+
+int setns_by_name(char *name)
+{
+	int nsfd, err;
+	char nspath[PATH_MAX];
+
+	snprintf(nspath, sizeof(nspath), "%s/%s", "/var/run/netns", name);
+	nsfd = open(nspath, O_RDONLY | O_CLOEXEC);
+	if (nsfd < 0)
+		return -1;
+
+	err = setns(nsfd, CLONE_NEWNET);
+	close(nsfd);
+	return err;
+}
+
+static int get_rx_packets(const char *iface)
+{
+	FILE *f;
+	char line[512];
+	int iface_len = strlen(iface);
+
+	f = fopen("/proc/net/dev", "r");
+	if (!f)
+		return -1;
+
+	while (fgets(line, sizeof(line), f)) {
+		char *p = line;
+
+		while (*p == ' ')
+			p++; /* skip whitespace */
+		if (!strncmp(p, iface, iface_len)) {
+			p += iface_len;
+			if (*p++ != ':')
+				continue;
+			while (*p == ' ')
+				p++; /* skip whitespace */
+			while (*p && *p != ' ')
+				p++; /* skip rx bytes */
+			while (*p == ' ')
+				p++; /* skip whitespace */
+			fclose(f);
+			return atoi(p);
+		}
+	}
+	fclose(f);
+	return -1;
+}
+
+enum {
+	BOND_ONE_NO_ATTACH = 0,
+	BOND_BOTH_AND_ATTACH,
+};
+
+static int bonding_setup(int mode, int xmit_policy, int bond_both_attach)
+{
+#define SYS(fmt, ...)						\
+	({							\
+		char cmd[1024];					\
+		snprintf(cmd, sizeof(cmd), fmt, ##__VA_ARGS__);	\
+		if (!ASSERT_OK(system(cmd), cmd))		\
+			return -1;				\
+	})
+
+	SYS("ip netns add ns_dst");
+	SYS("ip link add veth1_1 type veth peer name veth2_1 netns ns_dst");
+	SYS("ip link add veth1_2 type veth peer name veth2_2 netns ns_dst");
+
+	SYS("modprobe -r bonding &> /dev/null");
+	SYS("modprobe bonding mode=%d packets_per_slave=1 xmit_hash_policy=%d", mode, xmit_policy);
+
+	SYS("ip link add bond1 type bond");
+	SYS("ip link set bond1 address " BOND1_MAC_STR);
+	SYS("ip link set bond1 up");
+	SYS("ip -netns ns_dst link add bond2 type bond");
+	SYS("ip -netns ns_dst link set bond2 address " BOND2_MAC_STR);
+	SYS("ip -netns ns_dst link set bond2 up");
+
+	SYS("ip link set veth1_1 master bond1");
+	if (bond_both_attach == BOND_BOTH_AND_ATTACH) {
+		SYS("ip link set veth1_2 master bond1");
+	} else {
+		SYS("ip link set veth1_2 up");
+		SYS("ip link set dev veth1_2 xdpdrv obj xdp_dummy.o sec xdp_dummy");
+	}
+
+	SYS("ip -netns ns_dst link set veth2_1 master bond2");
+
+	if (bond_both_attach == BOND_BOTH_AND_ATTACH)
+		SYS("ip -netns ns_dst link set veth2_2 master bond2");
+	else
+		SYS("ip -netns ns_dst link set veth2_2 up");
+
+	/* Load a dummy program on sending side as with veth peer needs to have a
+	 * XDP program loaded as well.
+	 */
+	SYS("ip link set dev bond1 xdpdrv obj xdp_dummy.o sec xdp_dummy");
+
+	if (bond_both_attach == BOND_BOTH_AND_ATTACH)
+		SYS("ip -netns ns_dst link set dev bond2 xdpdrv obj xdp_tx.o sec tx");
+
+#undef SYS
+	return 0;
+}
+
+static void bonding_cleanup(void)
+{
+	ASSERT_OK(system("ip link delete veth1_1"), "delete veth1_1");
+	ASSERT_OK(system("ip link delete veth1_2"), "delete veth1_2");
+	ASSERT_OK(system("ip netns delete ns_dst"), "delete ns_dst");
+	ASSERT_OK(system("modprobe -r bonding"), "unload bond");
+}
+
+static int send_udp_packets(int vary_dst_ip)
+{
+	int i, s = -1;
+	int ifindex;
+	uint8_t buf[128] = {};
+	struct ethhdr eh = {
+		.h_source = BOND1_MAC,
+		.h_dest = BOND2_MAC,
+		.h_proto = htons(ETH_P_IP),
+	};
+	struct iphdr *iph = (struct iphdr *)(buf + sizeof(eh));
+	struct udphdr *uh = (struct udphdr *)(buf + sizeof(eh) + sizeof(*iph));
+
+	s = socket(AF_PACKET, SOCK_RAW, IPPROTO_RAW);
+	if (!ASSERT_GE(s, 0, "socket"))
+		goto err;
+
+	ifindex = if_nametoindex("bond1");
+	if (!ASSERT_GT(ifindex, 0, "get bond1 ifindex"))
+		goto err;
+
+	memcpy(buf, &eh, sizeof(eh));
+	iph->ihl = 5;
+	iph->version = 4;
+	iph->tos = 16;
+	iph->id = 1;
+	iph->ttl = 64;
+	iph->protocol = IPPROTO_UDP;
+	iph->saddr = 1;
+	iph->daddr = 2;
+	iph->tot_len = htons(sizeof(buf) - ETH_HLEN);
+	iph->check = 0;
+
+	for (i = 1; i <= NPACKETS; i++) {
+		int n;
+		struct sockaddr_ll saddr_ll = {
+			.sll_ifindex = ifindex,
+			.sll_halen = ETH_ALEN,
+			.sll_addr = BOND2_MAC,
+		};
+
+		/* vary the UDP destination port for even distribution with roundrobin/xor modes */
+		uh->dest++;
+
+		if (vary_dst_ip)
+			iph->daddr++;
+
+		n = sendto(s, buf, sizeof(buf), 0, (struct sockaddr *)&saddr_ll, sizeof(saddr_ll));
+		if (!ASSERT_EQ(n, sizeof(buf), "sendto"))
+			goto err;
+	}
+
+	return 0;
+
+err:
+	if (s >= 0)
+		close(s);
+	return -1;
+}
+
+void test_xdp_bonding_with_mode(char *name, int mode, int xmit_policy)
+{
+	int bond1_rx;
+
+	if (!test__start_subtest(name))
+		return;
+
+	if (bonding_setup(mode, xmit_policy, BOND_BOTH_AND_ATTACH))
+		return;
+
+	if (send_udp_packets(xmit_policy != BOND_XMIT_POLICY_LAYER34))
+		return;
+
+	bond1_rx = get_rx_packets("bond1");
+	ASSERT_TRUE(
+		bond1_rx >= NPACKETS,
+		"expected more received packets");
+
+	switch (mode) {
+	case BOND_MODE_ROUNDROBIN:
+	case BOND_MODE_XOR: {
+		int veth1_rx = get_rx_packets("veth1_1");
+		int veth2_rx = get_rx_packets("veth1_2");
+		int diff = abs(veth1_rx - veth2_rx);
+
+		ASSERT_GE(veth1_rx + veth2_rx, NPACKETS, "expected more packets");
+
+		switch (xmit_policy) {
+		case BOND_XMIT_POLICY_LAYER2:
+			ASSERT_GE(diff, NPACKETS/2,
+				  "expected packets on only one of the interfaces");
+			break;
+		case BOND_XMIT_POLICY_LAYER23:
+		case BOND_XMIT_POLICY_LAYER34:
+			ASSERT_LT(diff, NPACKETS/2,
+				  "expected even distribution of packets");
+			break;
+		default:
+			abort();
+		}
+		break;
+	}
+	default:
+		break;
+	}
+
+	bonding_cleanup();
+}
+
+void test_xdp_bonding_redirect_multi(void)
+{
+	static const char * const ifaces[] = {"bond2", "veth2_1", "veth2_2"};
+	int veth1_rx, veth2_rx;
+	int err;
+
+	if (!test__start_subtest("xdp_bonding_redirect_multi"))
+		return;
+
+	if (bonding_setup(BOND_MODE_ROUNDROBIN, BOND_XMIT_POLICY_LAYER23, BOND_ONE_NO_ATTACH))
+		goto out;
+
+	err = system("ip -netns ns_dst link set dev bond2 xdpdrv "
+		     "obj xdp_redirect_multi_kern.o sec xdp_redirect_map_multi");
+	if (!ASSERT_OK(err, "link set xdpdrv"))
+		goto out;
+
+	/* populate the redirection devmap with the relevant interfaces */
+	if (!ASSERT_OK(setns_by_name("ns_dst"), "could not set netns to ns_dst"))
+		goto out;
+
+	for (int i = 0; i < ARRAY_SIZE(ifaces); i++) {
+		char cmd[512];
+		int ifindex = if_nametoindex(ifaces[i]);
+
+		if (!ASSERT_GT(ifindex, 0, "could not get interface index"))
+			goto out;
+
+		snprintf(cmd, sizeof(cmd),
+			 "ip netns exec ns_dst bpftool map update name map_all key %d 0 0 0 value %d 0 0 0",
+			 i, ifindex);
+
+		if (!ASSERT_OK(system(cmd), "bpftool map update"))
+			goto out;
+	}
+	restore_root_netns();
+
+	send_udp_packets(BOND_MODE_ROUNDROBIN);
+
+	veth1_rx = get_rx_packets("veth1_1");
+	veth2_rx = get_rx_packets("veth1_2");
+
+	ASSERT_LT(veth1_rx, NPACKETS/2, "expected few packets on veth1");
+	ASSERT_GE(veth2_rx, NPACKETS, "expected more packets on veth2");
+out:
+	restore_root_netns();
+	bonding_cleanup();
+}
+
+struct bond_test_case {
+	char *name;
+	int mode;
+	int xmit_policy;
+};
+
+static	struct bond_test_case bond_test_cases[] = {
+	{ "xdp_bonding_roundrobin", BOND_MODE_ROUNDROBIN, BOND_XMIT_POLICY_LAYER23, },
+	{ "xdp_bonding_activebackup", BOND_MODE_ACTIVEBACKUP, BOND_XMIT_POLICY_LAYER23 },
+
+	{ "xdp_bonding_xor_layer2", BOND_MODE_XOR, BOND_XMIT_POLICY_LAYER2, },
+	{ "xdp_bonding_xor_layer23", BOND_MODE_XOR, BOND_XMIT_POLICY_LAYER23, },
+	{ "xdp_bonding_xor_layer34", BOND_MODE_XOR, BOND_XMIT_POLICY_LAYER34, },
+};
+
+void test_xdp_bonding(void)
+{
+	int i;
+
+	root_netns_fd = open("/proc/self/ns/net", O_RDONLY);
+	if (!ASSERT_GE(root_netns_fd, 0, "open /proc/self/ns/net"))
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(bond_test_cases); i++) {
+		struct bond_test_case *test_case = &bond_test_cases[i];
+
+		test_xdp_bonding_with_mode(
+			test_case->name,
+			test_case->mode,
+			test_case->xmit_policy);
+	}
+
+	test_xdp_bonding_redirect_multi();
+}
diff --git a/tools/testing/selftests/bpf/vmtest.sh b/tools/testing/selftests/bpf/vmtest.sh
index 8889b3f55236..68818780e072 100755
--- a/tools/testing/selftests/bpf/vmtest.sh
+++ b/tools/testing/selftests/bpf/vmtest.sh
@@ -106,17 +106,6 @@ download_rootfs()
 		zstd -d | sudo tar -C "$dir" -x
 }
 
-recompile_kernel()
-{
-	local kernel_checkout="$1"
-	local make_command="$2"
-
-	cd "${kernel_checkout}"
-
-	${make_command} olddefconfig
-	${make_command}
-}
-
 mount_image()
 {
 	local rootfs_img="${OUTPUT_DIR}/${ROOTFS_IMAGE}"
@@ -132,6 +121,23 @@ unmount_image()
 	sudo umount "${mount_dir}" &> /dev/null
 }
 
+recompile_kernel()
+{
+	local kernel_checkout="$1"
+	local make_command="$2"
+	local kernel_config="$3"
+
+	cd "${kernel_checkout}"
+
+	${make_command} olddefconfig
+	scripts/config --file ${kernel_config} --module CONFIG_BONDING
+	${make_command}
+	${make_command} modules
+	mount_image
+	sudo ${make_command} INSTALL_MOD_PATH=${OUTPUT_DIR}/${MOUNT_DIR} modules_install
+	unmount_image
+}
+
 update_selftests()
 {
 	local kernel_checkout="$1"
@@ -358,7 +364,7 @@ main()
 	mkdir -p "${mount_dir}"
 	update_kconfig "${kconfig_file}"
 
-	recompile_kernel "${kernel_checkout}" "${make_command}"
+	recompile_kernel "${kernel_checkout}" "${make_command}" "${kconfig_file}"
 
 	if [[ "${update_image}" == "no" && ! -f "${rootfs_img}" ]]; then
 		echo "rootfs image not found in ${rootfs_img}"
-- 
2.30.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08E86588757
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 08:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236006AbiHCG23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 02:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232999AbiHCG22 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 02:28:28 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36F7F3CBCC
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 23:28:27 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id n138so12292932iod.4
        for <netdev@vger.kernel.org>; Tue, 02 Aug 2022 23:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WSZoAhu0aTjRvc0zWZcic9mHShr/PCmy0k6aUGPE+io=;
        b=aVWAZnBRkVsEwt1cQsgZip9Vyjg4dA0v49ioPqTsp6/AggHJo6a0vfL+j7F6OpWpgy
         O61Ohw88rdd5zOwLWGqbrtccL3tGFvYJq1atMYtWM0NyqrxvNO6EOC4T65FyhmTQOjYf
         xNOTX31CEOsv2vhfGRNuMazGTq0kt4Q/IB/p/Aayuaq5IIGc3D5VRf5WW4AySzb4UpFG
         /Dm2wvim/Gy2KfvnTX5ppUmTJqq0ovqBd0S98DwwJpjtpyN6xXc967vTcclJaV0ZqSfw
         fYKQJUVBZFY5dggwVYHo88LQbRdzcFv5GOUkxmf2+94V1H+ZWD7YAZtA990bcm6ZjdAJ
         L+kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WSZoAhu0aTjRvc0zWZcic9mHShr/PCmy0k6aUGPE+io=;
        b=nA3a8zoG3klfNeGwjXTlDzRDPboX1iX+nwX01rmbUzRo22+F3EhzIfnlhNIiNlA1Tn
         82sE4Wqt9rJhvZGRDeZ+MsTbzDd9UeQHRrl9nAjPHQ5ld0+HcetcjE4OKAqjDtnlIZvU
         CkdOWiFEg89M3Y305YwVxHF7sHpL3oZWr+IeKDxlCVqpgahq+RifI6m9ls+kf+gOK0cX
         6A1PCk5TYntT6rpYpKtYoui85BhKAGons9/i58fCfcif9jiZzwZL+rXlhhdCwOltvEXL
         lYv2U4K/TxYnSErFGxeafKeX729chjd8L7kKVEOSLX7pxkz3AvhYU046+YxokB5lK3xN
         8QKQ==
X-Gm-Message-State: AJIora+jMQ/CCyEOYN8ei0mrLknCrohuHfMYtdVnc63V4daskP2Dq6zp
        Xi5YeCIKlp09pqdHS4vn3DQ=
X-Google-Smtp-Source: AGRyM1tvT5iAxljdxiV6B2mjn/a9NVQRVKFwSscI43bQtk5Z543aM1hKKt+SpzBNEGGqFRSqFjh5DA==
X-Received: by 2002:a05:6638:1654:b0:341:6650:df93 with SMTP id a20-20020a056638165400b003416650df93mr9687319jat.287.1659508106611;
        Tue, 02 Aug 2022 23:28:26 -0700 (PDT)
Received: from localhost (cpec09435e3ea83-cmc09435e3ea81.cpe.net.cable.rogers.com. [99.235.148.253])
        by smtp.gmail.com with UTF8SMTPSA id l18-20020a05663814d200b0033f2779e0aasm7407843jak.141.2022.08.02.23.28.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Aug 2022 23:28:26 -0700 (PDT)
From:   Cezar Bulinaru <cbulinaru@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     willemb@google.com, netdev@vger.kernel.org, cbulinaru@gmail.com
Subject: [PATCH v5 net] selftests: add few test cases for tap driver
Date:   Wed,  3 Aug 2022 02:28:16 -0400
Message-Id: <20220803062816.3989-1-cbulinaru@gmail.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Few test cases related to the fix for 924a9bc362a5:
"net: check if protocol extracted by virtio_net_hdr_set_proto is correct"

Need test for the case when a non-standard packet (GSO without NEEDS_CSUM)
sent to the tap device causes a BUG check in the tap driver.

Signed-off-by: Cezar Bulinaru <cbulinaru@gmail.com>

diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
index ffc35a22e914..c95bc935ccb8 100644
--- a/tools/testing/selftests/net/.gitignore
+++ b/tools/testing/selftests/net/.gitignore
@@ -38,3 +38,4 @@ ioam6_parser
 toeplitz
 tun
 cmsg_sender
+tap
diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index db05b3764b77..71e3f9f7f2d6 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -54,7 +54,7 @@ TEST_GEN_FILES += ipsec
 TEST_GEN_FILES += ioam6_parser
 TEST_GEN_FILES += gro
 TEST_GEN_PROGS = reuseport_bpf reuseport_bpf_cpu reuseport_bpf_numa
-TEST_GEN_PROGS += reuseport_dualstack reuseaddr_conflict tls tun
+TEST_GEN_PROGS += reuseport_dualstack reuseaddr_conflict tls tun tap
 TEST_GEN_FILES += toeplitz
 TEST_GEN_FILES += cmsg_sender
 TEST_GEN_FILES += stress_reuseport_listen
diff --git a/tools/testing/selftests/net/tap.c b/tools/testing/selftests/net/tap.c
new file mode 100644
index 000000000000..247c3b3ac1c9
--- /dev/null
+++ b/tools/testing/selftests/net/tap.c
@@ -0,0 +1,434 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define _GNU_SOURCE
+
+#include <errno.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <net/if.h>
+#include <linux/if_tun.h>
+#include <linux/netlink.h>
+#include <linux/rtnetlink.h>
+#include <sys/ioctl.h>
+#include <sys/socket.h>
+#include <linux/virtio_net.h>
+#include <netinet/ip.h>
+#include <netinet/udp.h>
+#include "../kselftest_harness.h"
+
+static const char param_dev_tap_name[] = "xmacvtap0";
+static const char param_dev_dummy_name[] = "xdummy0";
+static unsigned char param_hwaddr_src[] = { 0x00, 0xfe, 0x98, 0x14, 0x22, 0x42 };
+static unsigned char param_hwaddr_dest[] = {
+	0x00, 0xfe, 0x98, 0x94, 0xd2, 0x43
+};
+
+#define MAX_RTNL_PAYLOAD (2048)
+#define PKT_DATA 0xCB
+#define TEST_PACKET_SZ (sizeof(struct virtio_net_hdr) + ETH_HLEN + ETH_MAX_MTU)
+
+static struct rtattr *rtattr_add(struct nlmsghdr *nh, unsigned short type,
+				 unsigned short len)
+{
+	struct rtattr *rta =
+		(struct rtattr *)((uint8_t *)nh + RTA_ALIGN(nh->nlmsg_len));
+	rta->rta_type = type;
+	rta->rta_len = RTA_LENGTH(len);
+	nh->nlmsg_len = RTA_ALIGN(nh->nlmsg_len) + RTA_ALIGN(rta->rta_len);
+	return rta;
+}
+
+static struct rtattr *rtattr_begin(struct nlmsghdr *nh, unsigned short type)
+{
+	return rtattr_add(nh, type, 0);
+}
+
+static void rtattr_end(struct nlmsghdr *nh, struct rtattr *attr)
+{
+	uint8_t *end = (uint8_t *)nh + nh->nlmsg_len;
+
+	attr->rta_len = end - (uint8_t *)attr;
+}
+
+static struct rtattr *rtattr_add_str(struct nlmsghdr *nh, unsigned short type,
+				     const char *s)
+{
+	struct rtattr *rta = rtattr_add(nh, type, strlen(s));
+
+	memcpy(RTA_DATA(rta), s, strlen(s));
+	return rta;
+}
+
+static struct rtattr *rtattr_add_strsz(struct nlmsghdr *nh, unsigned short type,
+				       const char *s)
+{
+	struct rtattr *rta = rtattr_add(nh, type, strlen(s) + 1);
+
+	strcpy(RTA_DATA(rta), s);
+	return rta;
+}
+
+static struct rtattr *rtattr_add_any(struct nlmsghdr *nh, unsigned short type,
+				     const void *arr, size_t len)
+{
+	struct rtattr *rta = rtattr_add(nh, type, len);
+
+	memcpy(RTA_DATA(rta), arr, len);
+	return rta;
+}
+
+static int dev_create(const char *dev, const char *link_type,
+		      int (*fill_rtattr)(struct nlmsghdr *nh),
+		      int (*fill_info_data)(struct nlmsghdr *nh))
+{
+	struct {
+		struct nlmsghdr nh;
+		struct ifinfomsg info;
+		unsigned char data[MAX_RTNL_PAYLOAD];
+	} req;
+	struct rtattr *link_info, *info_data;
+	int ret, rtnl;
+
+	rtnl = socket(AF_NETLINK, SOCK_DGRAM, NETLINK_ROUTE);
+	if (rtnl < 0) {
+		fprintf(stderr, "%s: socket %s\n", __func__, strerror(errno));
+		return 1;
+	}
+
+	memset(&req, 0, sizeof(req));
+	req.nh.nlmsg_len = NLMSG_LENGTH(sizeof(req.info));
+	req.nh.nlmsg_flags = NLM_F_REQUEST | NLM_F_CREATE;
+	req.nh.nlmsg_type = RTM_NEWLINK;
+
+	req.info.ifi_family = AF_UNSPEC;
+	req.info.ifi_type = 1;
+	req.info.ifi_index = 0;
+	req.info.ifi_flags = IFF_BROADCAST | IFF_UP;
+	req.info.ifi_change = 0xffffffff;
+
+	rtattr_add_str(&req.nh, IFLA_IFNAME, dev);
+
+	if (fill_rtattr) {
+		ret = fill_rtattr(&req.nh);
+		if (ret)
+			return ret;
+	}
+
+	link_info = rtattr_begin(&req.nh, IFLA_LINKINFO);
+
+	rtattr_add_strsz(&req.nh, IFLA_INFO_KIND, link_type);
+
+	if (fill_info_data) {
+		info_data = rtattr_begin(&req.nh, IFLA_INFO_DATA);
+		ret = fill_info_data(&req.nh);
+		if (ret)
+			return ret;
+		rtattr_end(&req.nh, info_data);
+	}
+
+	rtattr_end(&req.nh, link_info);
+
+	ret = send(rtnl, &req, req.nh.nlmsg_len, 0);
+	if (ret < 0)
+		fprintf(stderr, "%s: send %s\n", __func__, strerror(errno));
+	ret = (unsigned int)ret != req.nh.nlmsg_len;
+
+	close(rtnl);
+	return ret;
+}
+
+static int dev_delete(const char *dev)
+{
+	struct {
+		struct nlmsghdr nh;
+		struct ifinfomsg info;
+		unsigned char data[MAX_RTNL_PAYLOAD];
+	} req;
+	int ret, rtnl;
+
+	rtnl = socket(AF_NETLINK, SOCK_DGRAM, NETLINK_ROUTE);
+	if (rtnl < 0) {
+		fprintf(stderr, "%s: socket %s\n", __func__, strerror(errno));
+		return 1;
+	}
+
+	memset(&req, 0, sizeof(req));
+	req.nh.nlmsg_len = NLMSG_LENGTH(sizeof(req.info));
+	req.nh.nlmsg_flags = NLM_F_REQUEST;
+	req.nh.nlmsg_type = RTM_DELLINK;
+
+	req.info.ifi_family = AF_UNSPEC;
+
+	rtattr_add_str(&req.nh, IFLA_IFNAME, dev);
+
+	ret = send(rtnl, &req, req.nh.nlmsg_len, 0);
+	if (ret < 0)
+		fprintf(stderr, "%s: send %s\n", __func__, strerror(errno));
+
+	ret = (unsigned int)ret != req.nh.nlmsg_len;
+
+	close(rtnl);
+	return ret;
+}
+
+static int macvtap_fill_rtattr(struct nlmsghdr *nh)
+{
+	int ifindex;
+
+	ifindex = if_nametoindex(param_dev_dummy_name);
+	if (ifindex == 0) {
+		fprintf(stderr, "%s: ifindex  %s\n", __func__, strerror(errno));
+		return -errno;
+	}
+
+	rtattr_add_any(nh, IFLA_LINK, &ifindex, sizeof(ifindex));
+	rtattr_add_any(nh, IFLA_ADDRESS, param_hwaddr_src, ETH_ALEN);
+
+	return 0;
+}
+
+static int opentap(const char *devname)
+{
+	int ifindex;
+	char buf[256];
+	int fd;
+	struct ifreq ifr;
+
+	ifindex = if_nametoindex(devname);
+	if (ifindex == 0) {
+		fprintf(stderr, "%s: ifindex %s\n", __func__, strerror(errno));
+		return -errno;
+	}
+
+	sprintf(buf, "/dev/tap%d", ifindex);
+	fd = open(buf, O_RDWR | O_NONBLOCK);
+	if (fd < 0) {
+		fprintf(stderr, "%s: open %s\n", __func__, strerror(errno));
+		return -errno;
+	}
+
+	memset(&ifr, 0, sizeof(ifr));
+	strcpy(ifr.ifr_name, devname);
+	ifr.ifr_flags = IFF_TAP | IFF_NO_PI | IFF_VNET_HDR | IFF_MULTI_QUEUE;
+	if (ioctl(fd, TUNSETIFF, &ifr, sizeof(ifr)) < 0)
+		return -errno;
+	return fd;
+}
+
+size_t build_eth(uint8_t *buf, uint16_t proto)
+{
+	struct ethhdr *eth = (struct ethhdr *)buf;
+
+	eth->h_proto = htons(proto);
+	memcpy(eth->h_source, param_hwaddr_src, ETH_ALEN);
+	memcpy(eth->h_dest, param_hwaddr_dest, ETH_ALEN);
+
+	return ETH_HLEN;
+}
+
+static uint32_t add_csum(const uint8_t *buf, int len)
+{
+	uint32_t sum = 0;
+	uint16_t *sbuf = (uint16_t *)buf;
+
+	while (len > 1) {
+		sum += *sbuf++;
+		len -= 2;
+	}
+
+	if (len)
+		sum += *(uint8_t *)sbuf;
+
+	return sum;
+}
+
+static uint16_t finish_ip_csum(uint32_t sum)
+{
+	uint16_t lo = sum & 0xffff;
+	uint16_t hi = sum >> 16;
+
+	return ~(lo + hi);
+
+}
+
+static uint16_t build_ip_csum(const uint8_t *buf, int len,
+			      uint32_t sum)
+{
+	sum += add_csum(buf, len);
+	return finish_ip_csum(sum);
+}
+
+static int build_ipv4_header(uint8_t *buf, int payload_len)
+{
+	struct iphdr *iph = (struct iphdr *)buf;
+
+	iph->ihl = 5;
+	iph->version = 4;
+	iph->ttl = 8;
+	iph->tot_len =
+		htons(sizeof(*iph) + sizeof(struct udphdr) + payload_len);
+	iph->id = htons(1337);
+	iph->protocol = IPPROTO_UDP;
+	iph->saddr = htonl((172 << 24) | (17 << 16) | 2);
+	iph->daddr = htonl((172 << 24) | (17 << 16) | 1);
+	iph->check = build_ip_csum(buf, iph->ihl << 2, 0);
+
+	return iph->ihl << 2;
+}
+
+static int build_udp_packet(uint8_t *buf, int payload_len, bool csum_off)
+{
+	const int ip4alen = sizeof(uint32_t);
+	struct udphdr *udph = (struct udphdr *)buf;
+	int len = sizeof(*udph) + payload_len;
+	uint32_t sum = 0;
+
+	udph->source = htons(22);
+	udph->dest = htons(58822);
+	udph->len = htons(len);
+
+	memset(buf + sizeof(struct udphdr), PKT_DATA, payload_len);
+
+	sum = add_csum(buf - 2 * ip4alen, 2 * ip4alen);
+	sum += htons(IPPROTO_UDP) + udph->len;
+
+	if (!csum_off)
+		sum += add_csum(buf, len);
+
+	udph->check = finish_ip_csum(sum);
+
+	return sizeof(*udph) + payload_len;
+}
+
+size_t build_test_packet_valid_udp_gso(uint8_t *buf, size_t payload_len)
+{
+	uint8_t *cur = buf;
+	struct virtio_net_hdr *vh = (struct virtio_net_hdr *)buf;
+
+	vh->hdr_len = ETH_HLEN + sizeof(struct iphdr) + sizeof(struct udphdr);
+	vh->flags = VIRTIO_NET_HDR_F_NEEDS_CSUM;
+	vh->csum_start = ETH_HLEN + sizeof(struct iphdr);
+	vh->csum_offset = __builtin_offsetof(struct udphdr, check);
+	vh->gso_type = VIRTIO_NET_HDR_GSO_UDP;
+	vh->gso_size = ETH_DATA_LEN - sizeof(struct iphdr);
+	cur += sizeof(*vh);
+
+	cur += build_eth(cur, ETH_P_IP);
+	cur += build_ipv4_header(cur, payload_len);
+	cur += build_udp_packet(cur, payload_len, true);
+
+	return cur - buf;
+}
+
+size_t build_test_packet_valid_udp_csum(uint8_t *buf, size_t payload_len)
+{
+	uint8_t *cur = buf;
+	struct virtio_net_hdr *vh = (struct virtio_net_hdr *)buf;
+
+	vh->flags = VIRTIO_NET_HDR_F_DATA_VALID;
+	vh->gso_type = VIRTIO_NET_HDR_GSO_NONE;
+	cur += sizeof(*vh);
+
+	cur += build_eth(cur, ETH_P_IP);
+	cur += build_ipv4_header(cur, payload_len);
+	cur += build_udp_packet(cur, payload_len, false);
+
+	return cur - buf;
+}
+
+size_t build_test_packet_crash_tap_invalid_eth_proto(uint8_t *buf,
+						     size_t payload_len)
+{
+	uint8_t *cur = buf;
+	struct virtio_net_hdr *vh = (struct virtio_net_hdr *)buf;
+
+	vh->hdr_len = ETH_HLEN + sizeof(struct iphdr) + sizeof(struct udphdr);
+	vh->flags = 0;
+	vh->gso_type = VIRTIO_NET_HDR_GSO_UDP;
+	vh->gso_size = ETH_DATA_LEN - sizeof(struct iphdr);
+	cur += sizeof(*vh);
+
+	cur += build_eth(cur, 0);
+	cur += sizeof(struct iphdr) + sizeof(struct udphdr);
+	cur += build_ipv4_header(cur, payload_len);
+	cur += build_udp_packet(cur, payload_len, true);
+	cur += payload_len;
+
+	return cur - buf;
+}
+
+FIXTURE(tap)
+{
+	int fd;
+};
+
+FIXTURE_SETUP(tap)
+{
+	int ret;
+
+	ret = dev_create(param_dev_dummy_name, "dummy", NULL, NULL);
+	EXPECT_EQ(ret, 0);
+
+	ret = dev_create(param_dev_tap_name, "macvtap", macvtap_fill_rtattr,
+			 NULL);
+	EXPECT_EQ(ret, 0);
+
+	self->fd = opentap(param_dev_tap_name);
+	ASSERT_GE(self->fd, 0);
+}
+
+FIXTURE_TEARDOWN(tap)
+{
+	int ret;
+
+	if (self->fd != -1)
+		close(self->fd);
+
+	ret = dev_delete(param_dev_tap_name);
+	EXPECT_EQ(ret, 0);
+
+	ret = dev_delete(param_dev_dummy_name);
+	EXPECT_EQ(ret, 0);
+}
+
+TEST_F(tap, test_packet_valid_udp_gso)
+{
+	uint8_t pkt[TEST_PACKET_SZ];
+	size_t off;
+	int ret;
+
+	memset(pkt, 0, sizeof(pkt));
+	off = build_test_packet_valid_udp_gso(pkt, 1021);
+	ret = write(self->fd, pkt, off);
+	ASSERT_EQ(ret, off);
+}
+
+TEST_F(tap, test_packet_valid_udp_csum)
+{
+	uint8_t pkt[TEST_PACKET_SZ];
+	size_t off;
+	int ret;
+
+	memset(pkt, 0, sizeof(pkt));
+	off = build_test_packet_valid_udp_csum(pkt, 1024);
+	ret = write(self->fd, pkt, off);
+	ASSERT_EQ(ret, off);
+}
+
+TEST_F(tap, test_packet_crash_tap_invalid_eth_proto)
+{
+	uint8_t pkt[TEST_PACKET_SZ];
+	size_t off;
+	int ret;
+
+	memset(pkt, 0, sizeof(pkt));
+	off = build_test_packet_crash_tap_invalid_eth_proto(pkt, 1024);
+	ret = write(self->fd, pkt, off);
+	ASSERT_EQ(ret, -1);
+	ASSERT_EQ(errno, EINVAL);
+}
+
+TEST_HARNESS_MAIN
-- 
2.37.1


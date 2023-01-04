Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D730365D255
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 13:20:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239244AbjADMTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 07:19:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239187AbjADMSz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 07:18:55 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB33413E95;
        Wed,  4 Jan 2023 04:18:53 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id l26so23816907wme.5;
        Wed, 04 Jan 2023 04:18:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kfz2qQO5MMtWT5+aHp7E8tQeyruoYhUB29GfrQCYqUE=;
        b=iB4Bzr5VYHJjOlznzWMvQKoaWIcU9H7quiDgeRbDT6zz20UdkTlJPfN5PbUzvuweVo
         6An1LtdluYBUlhslKFOb8KLpaxFrHYOorJGXfUA5wtvWP6sueHKYsIftlODj8Xk3Nq8p
         3vqUwUA5Sm/GvD3ws6fC58kUbBfCWKF+mJgVkudC204JXV5GKPQr4GU8KK9gA6FuED07
         CJYpJhWSPdiWBzqtMYV9FRPHzR+I5UGutdf0h4Op+sZTIZSlUcGJYb26AQuj2U24Tkkv
         mcGom+x6Zw2WLRMi5lmE0tzAUGQNqPR56DdWb+IlhoKByjqApEjDoW2d28umHwzrIAoG
         E9Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kfz2qQO5MMtWT5+aHp7E8tQeyruoYhUB29GfrQCYqUE=;
        b=vRG6GN+uaEKep7IkG5QqBOPW6Yj+vstgF1hgJZiUMnoq7j/To7F5CDZOixBBhYMT6Z
         N8FkJA2loVGKH4FF90fgR6C6NT0uq9GnUk2KA5Q03rZgMAFGj6fS8f3Crv/cunZNSUto
         jfAxgUNFTDi0m+cVHzFjVmroxSewT6c9kS5NJqwabxIICyxT8TmYg1/XHDEj2h/84kd9
         grW87wWK4GxShYijz3fnsGvsUTscB2kNpkTUT1M0EhxvOvbyhWh5pOsch+Tlrv6VckG6
         ubmbkrAFDh6MUafVzB/XtFR76wMEZll+EShST8UYUOhHe/AK11R6LsNP+pJ3fehUy1ZX
         lBiQ==
X-Gm-Message-State: AFqh2kofA+gazHMN9Izef0QdSmAfB2Nlb3YVEK73vnjcXFC7AFMcikjc
        XYGnB922zZJmQmJvsIOLqIk=
X-Google-Smtp-Source: AMrXdXuOkdR7UpY6t09kJRQRwnkTjZPBXURCO4lW6bDWeWNccJJ366wwukOFPiBGCSIy9oPUCyl5kA==
X-Received: by 2002:a05:600c:1d89:b0:3d3:5cd6:781 with SMTP id p9-20020a05600c1d8900b003d35cd60781mr32927773wms.37.1672834732428;
        Wed, 04 Jan 2023 04:18:52 -0800 (PST)
Received: from localhost.localdomain (h-176-10-254-193.A165.priv.bahnhof.se. [176.10.254.193])
        by smtp.gmail.com with ESMTPSA id w12-20020a05600c474c00b003d04e4ed873sm35013749wmo.22.2023.01.04.04.18.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Jan 2023 04:18:51 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, tirthendu.sarkar@intel.com
Cc:     jonathan.lemon@gmail.com
Subject: [PATCH bpf-next v2 08/15] selftests/xsk: remove namespaces
Date:   Wed,  4 Jan 2023 13:17:37 +0100
Message-Id: <20230104121744.2820-9-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230104121744.2820-1-magnus.karlsson@gmail.com>
References: <20230104121744.2820-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Magnus Karlsson <magnus.karlsson@intel.com>

Remove the namespaces used as they fill no function. This will
simplify the code for speeding up the tests in the following commits.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/test_xsk.sh    | 33 ++++++----------
 tools/testing/selftests/bpf/xsk_prereqs.sh | 12 +-----
 tools/testing/selftests/bpf/xskxceiver.c   | 46 +++-------------------
 tools/testing/selftests/bpf/xskxceiver.h   |  3 --
 4 files changed, 20 insertions(+), 74 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_xsk.sh b/tools/testing/selftests/bpf/test_xsk.sh
index cb315d85148b..b077cf58f825 100755
--- a/tools/testing/selftests/bpf/test_xsk.sh
+++ b/tools/testing/selftests/bpf/test_xsk.sh
@@ -24,8 +24,6 @@
 #      -----------     |     ----------
 #      |  vethX  | --------- |  vethY |
 #      -----------   peer    ----------
-#           |          |          |
-#      namespaceX      |     namespaceY
 #
 # AF_XDP is an address family optimized for high performance packet processing,
 # it is XDP’s user-space interface.
@@ -39,10 +37,9 @@
 # Prerequisites setup by script:
 #
 #   Set up veth interfaces as per the topology shown ^^:
-#   * setup two veth interfaces and one namespace
-#   ** veth<xxxx> in root namespace
-#   ** veth<yyyy> in af_xdp<xxxx> namespace
-#   ** namespace af_xdp<xxxx>
+#   * setup two veth interfaces
+#   ** veth<xxxx>
+#   ** veth<yyyy>
 #   *** xxxx and yyyy are randomly generated 4 digit numbers used to avoid
 #       conflict with any existing interface
 #   * tests the veth and xsk layers of the topology
@@ -103,28 +100,25 @@ VETH0_POSTFIX=$(cat ${URANDOM} | tr -dc '0-9' | fold -w 256 | head -n 1 | head -
 VETH0=ve${VETH0_POSTFIX}
 VETH1_POSTFIX=$(cat ${URANDOM} | tr -dc '0-9' | fold -w 256 | head -n 1 | head --bytes 4)
 VETH1=ve${VETH1_POSTFIX}
-NS0=root
-NS1=af_xdp${VETH1_POSTFIX}
 MTU=1500
 
 trap ctrl_c INT
 
 function ctrl_c() {
-        cleanup_exit ${VETH0} ${VETH1} ${NS1}
+        cleanup_exit ${VETH0} ${VETH1}
 	exit 1
 }
 
 setup_vethPairs() {
 	if [[ $verbose -eq 1 ]]; then
-	        echo "setting up ${VETH0}: namespace: ${NS0}"
+	        echo "setting up ${VETH0}"
 	fi
-	ip netns add ${NS1}
 	ip link add ${VETH0} numtxqueues 4 numrxqueues 4 type veth peer name ${VETH1} numtxqueues 4 numrxqueues 4
 	if [ -f /proc/net/if_inet6 ]; then
 		echo 1 > /proc/sys/net/ipv6/conf/${VETH0}/disable_ipv6
 	fi
 	if [[ $verbose -eq 1 ]]; then
-	        echo "setting up ${VETH1}: namespace: ${NS1}"
+	        echo "setting up ${VETH1}"
 	fi
 
 	if [[ $busy_poll -eq 1 ]]; then
@@ -134,18 +128,15 @@ setup_vethPairs() {
 		echo 200000 > /sys/class/net/${VETH1}/gro_flush_timeout
 	fi
 
-	ip link set ${VETH1} netns ${NS1}
-	ip netns exec ${NS1} ip link set ${VETH1} mtu ${MTU}
+	ip link set ${VETH1} mtu ${MTU}
 	ip link set ${VETH0} mtu ${MTU}
-	ip netns exec ${NS1} ip link set ${VETH1} up
-	ip netns exec ${NS1} ip link set dev lo up
+	ip link set ${VETH1} up
 	ip link set ${VETH0} up
 }
 
 if [ ! -z $ETH ]; then
 	VETH0=${ETH}
 	VETH1=${ETH}
-	NS1=""
 else
 	validate_root_exec
 	validate_veth_support ${VETH0}
@@ -155,7 +146,7 @@ else
 	retval=$?
 	if [ $retval -ne 0 ]; then
 		test_status $retval "${TEST_NAME}"
-		cleanup_exit ${VETH0} ${VETH1} ${NS1}
+		cleanup_exit ${VETH0} ${VETH1}
 		exit $retval
 	fi
 fi
@@ -179,14 +170,14 @@ statusList=()
 TEST_NAME="XSK_SELFTESTS_${VETH0}_SOFTIRQ"
 
 if [[ $debug -eq 1 ]]; then
-    echo "-i" ${VETH0} "-i" ${VETH1},${NS1}
+    echo "-i" ${VETH0} "-i" ${VETH1}
     exit
 fi
 
 exec_xskxceiver
 
 if [ -z $ETH ]; then
-	cleanup_exit ${VETH0} ${VETH1} ${NS1}
+	cleanup_exit ${VETH0} ${VETH1}
 fi
 TEST_NAME="XSK_SELFTESTS_${VETH0}_BUSY_POLL"
 busy_poll=1
@@ -199,7 +190,7 @@ exec_xskxceiver
 ## END TESTS
 
 if [ -z $ETH ]; then
-	cleanup_exit ${VETH0} ${VETH1} ${NS1}
+	cleanup_exit ${VETH0} ${VETH1}
 fi
 
 failures=0
diff --git a/tools/testing/selftests/bpf/xsk_prereqs.sh b/tools/testing/selftests/bpf/xsk_prereqs.sh
index a0b71723a818..ae697a10a056 100755
--- a/tools/testing/selftests/bpf/xsk_prereqs.sh
+++ b/tools/testing/selftests/bpf/xsk_prereqs.sh
@@ -55,21 +55,13 @@ test_exit()
 
 clear_configs()
 {
-	if [ $(ip netns show | grep $3 &>/dev/null; echo $?;) == 0 ]; then
-		[ $(ip netns exec $3 ip link show $2 &>/dev/null; echo $?;) == 0 ] &&
-			{ ip netns exec $3 ip link del $2; }
-		ip netns del $3
-	fi
-	#Once we delete a veth pair node, the entire veth pair is removed,
-	#this is just to be cautious just incase the NS does not exist then
-	#veth node inside NS won't get removed so we explicitly remove it
 	[ $(ip link show $1 &>/dev/null; echo $?;) == 0 ] &&
 		{ ip link del $1; }
 }
 
 cleanup_exit()
 {
-	clear_configs $1 $2 $3
+	clear_configs $1 $2
 }
 
 validate_ip_utility()
@@ -83,7 +75,7 @@ exec_xskxceiver()
 	        ARGS+="-b "
 	fi
 
-	./${XSKOBJ} -i ${VETH0} -i ${VETH1},${NS1} ${ARGS}
+	./${XSKOBJ} -i ${VETH0} -i ${VETH1} ${ARGS}
 
 	retval=$?
 	test_status $retval "${TEST_NAME}"
diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index 72578cebfbf7..4c8f32e1c431 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -55,12 +55,11 @@
  * Flow:
  * -----
  * - Single process spawns two threads: Tx and Rx
- * - Each of these two threads attach to a veth interface within their assigned
- *   namespaces
- * - Each thread Creates one AF_XDP socket connected to a unique umem for each
+ * - Each of these two threads attach to a veth interface
+ * - Each thread creates one AF_XDP socket connected to a unique umem for each
  *   veth interface
- * - Tx thread Transmits 10k packets from veth<xxxx> to veth<yyyy>
- * - Rx thread verifies if all 10k packets were received and delivered in-order,
+ * - Tx thread Transmits a number of packets from veth<xxxx> to veth<yyyy>
+ * - Rx thread verifies if all packets were received and delivered in-order,
  *   and have the right content
  *
  * Enable/disable packet dump mode:
@@ -399,28 +398,6 @@ static void usage(const char *prog)
 	ksft_print_msg(str, prog);
 }
 
-static int switch_namespace(const char *nsname)
-{
-	char fqns[26] = "/var/run/netns/";
-	int nsfd;
-
-	if (!nsname || strlen(nsname) == 0)
-		return -1;
-
-	strncat(fqns, nsname, sizeof(fqns) - strlen(fqns) - 1);
-	nsfd = open(fqns, O_RDONLY);
-
-	if (nsfd == -1)
-		exit_with_error(errno);
-
-	if (setns(nsfd, 0) == -1)
-		exit_with_error(errno);
-
-	print_verbose("NS switched: %s\n", nsname);
-
-	return nsfd;
-}
-
 static bool validate_interface(struct ifobject *ifobj)
 {
 	if (!strcmp(ifobj->ifname, ""))
@@ -438,8 +415,6 @@ static void parse_command_line(struct ifobject *ifobj_tx, struct ifobject *ifobj
 	opterr = 0;
 
 	for (;;) {
-		char *sptr, *token;
-
 		c = getopt_long(argc, argv, "i:Dvb", long_options, &option_index);
 		if (c == -1)
 			break;
@@ -453,11 +428,8 @@ static void parse_command_line(struct ifobject *ifobj_tx, struct ifobject *ifobj
 			else
 				break;
 
-			sptr = strndupa(optarg, strlen(optarg));
-			memcpy(ifobj->ifname, strsep(&sptr, ","), MAX_INTERFACE_NAME_CHARS);
-			token = strsep(&sptr, ",");
-			if (token)
-				memcpy(ifobj->nsname, token, MAX_INTERFACES_NAMESPACE_CHARS);
+			memcpy(ifobj->ifname, optarg,
+			       min_t(size_t, MAX_INTERFACE_NAME_CHARS, strlen(optarg)));
 			interface_nb++;
 			break;
 		case 'D':
@@ -1283,8 +1255,6 @@ static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
 	int ret, ifindex;
 	void *bufs;
 
-	ifobject->ns_fd = switch_namespace(ifobject->nsname);
-
 	if (ifobject->umem->unaligned_mode)
 		mmap_flags |= MAP_HUGETLB;
 
@@ -1843,8 +1813,6 @@ static struct ifobject *ifobject_create(void)
 	if (!ifobj->umem)
 		goto out_umem;
 
-	ifobj->ns_fd = -1;
-
 	return ifobj;
 
 out_umem:
@@ -1856,8 +1824,6 @@ static struct ifobject *ifobject_create(void)
 
 static void ifobject_delete(struct ifobject *ifobj)
 {
-	if (ifobj->ns_fd != -1)
-		close(ifobj->ns_fd);
 	free(ifobj->umem);
 	free(ifobj->xsk_arr);
 	free(ifobj);
diff --git a/tools/testing/selftests/bpf/xskxceiver.h b/tools/testing/selftests/bpf/xskxceiver.h
index edb76d2def9f..dcb908f5bb4c 100644
--- a/tools/testing/selftests/bpf/xskxceiver.h
+++ b/tools/testing/selftests/bpf/xskxceiver.h
@@ -30,7 +30,6 @@
 #define TEST_CONTINUE 1
 #define MAX_INTERFACES 2
 #define MAX_INTERFACE_NAME_CHARS 16
-#define MAX_INTERFACES_NAMESPACE_CHARS 16
 #define MAX_SOCKETS 2
 #define MAX_TEST_NAME_SIZE 32
 #define MAX_TEARDOWN_ITER 10
@@ -133,14 +132,12 @@ typedef void *(*thread_func_t)(void *arg);
 
 struct ifobject {
 	char ifname[MAX_INTERFACE_NAME_CHARS];
-	char nsname[MAX_INTERFACES_NAMESPACE_CHARS];
 	struct xsk_socket_info *xsk;
 	struct xsk_socket_info *xsk_arr;
 	struct xsk_umem_info *umem;
 	thread_func_t func_ptr;
 	validation_func_t validation_func;
 	struct pkt_stream *pkt_stream;
-	int ns_fd;
 	int xsk_map_fd;
 	u32 dst_ip;
 	u32 src_ip;
-- 
2.34.1


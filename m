Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C43603CB025
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 02:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232940AbhGPAkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 20:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232693AbhGPAkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 20:40:24 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 995A9C061764
        for <netdev@vger.kernel.org>; Thu, 15 Jul 2021 17:37:30 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 494C1891B0;
        Fri, 16 Jul 2021 12:37:29 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1626395849;
        bh=RvCe2LG78zJ+Fpaq1fDuA+10/TwnD+ucbZjD8N0Idkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=fmQfGvHwSfNtvDjO8bZk4MEtpDUsgWd+67CZtaUMzo8kP8GkVDRnUv9BtMipQ6bqF
         9AKSDq7rarNoyyj+jU0HjXsEPe+hqGmOGtpQBmkDe5M2ZJlJjCSR+7Qo9e7f7r6AEp
         8THwBcIYBQI3bxziikg6IM4zz7x27QHM17wsqL3OJjcu0VrgzVW06NYpO28ZwsV9gv
         9fEe2oHoSnbVTp+d/lBrWmILcAFa9wm+hapmYnItemh5CcAUf9w5Yqx5jCJ8NW/tYZ
         WDU1vesN9ZOi1cwvAf3oZSeYiGG1vS+wlznoehPaWyKWy2BPtbv3IA2/wjcZOFvHW6
         SFYGRUxffGFiA==
Received: from pat.atlnz.lc (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B60f0d4c90000>; Fri, 16 Jul 2021 12:37:29 +1200
Received: from coled-dl.ws.atlnz.lc (coled-dl.ws.atlnz.lc [10.33.25.26])
        by pat.atlnz.lc (Postfix) with ESMTP id 1891F13EE58;
        Fri, 16 Jul 2021 12:37:29 +1200 (NZST)
Received: by coled-dl.ws.atlnz.lc (Postfix, from userid 1801)
        id 156C42428E7; Fri, 16 Jul 2021 12:37:29 +1200 (NZST)
From:   Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
To:     pablo@netfilter.org
Cc:     kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        kuba@kernel.org, shuah@kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
Subject: [PATCH 3/3] selftests: netfilter: Add RFC-7597 Section 5.1 PSID selftests
Date:   Fri, 16 Jul 2021 12:27:42 +1200
Message-Id: <20210716002742.31078-4-Cole.Dishington@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210716002742.31078-1-Cole.Dishington@alliedtelesis.co.nz>
References: <20210705103959.GG18022@breakpoint.cc>
 <20210716002742.31078-1-Cole.Dishington@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=Sr3uF8G0 c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=e_q4qTt1xDgA:10 a=sF_rvDO487Xu6NHlfHgA:9 a=aALMkOt3x9iH2e2e:21 a=x4vXnrB5FKoW2lLM:21
X-SEG-SpamProfiler-Score: 0
x-atlnz-ls: pat
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add selftests for masquerading into a smaller subset of ports defined by
PSID.

Signed-off-by: Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
---

Notes:
    Thanks for your time reviewing!
   =20
    Changes in v4:
    - Add tests for a=3D0 (A=3D2^16) special case.
    - Update to use offset_length (from iptables change).

 .../netfilter/nat_masquerade_psid.sh          | 182 ++++++++++++++++++
 1 file changed, 182 insertions(+)
 create mode 100644 tools/testing/selftests/netfilter/nat_masquerade_psid=
.sh

diff --git a/tools/testing/selftests/netfilter/nat_masquerade_psid.sh b/t=
ools/testing/selftests/netfilter/nat_masquerade_psid.sh
new file mode 100644
index 000000000000..56c1b509caf6
--- /dev/null
+++ b/tools/testing/selftests/netfilter/nat_masquerade_psid.sh
@@ -0,0 +1,182 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# <:copyright-gpl
+# Copyright (C) 2021 Allied Telesis Labs NZ
+#
+# check that NAT can masquerade using PSID defined ranges.
+#
+# Setup is:
+#
+# nsclient1(veth0) -> (veth1)nsrouter(veth2) -> (veth0)nsclient2
+# Setup a nat masquerade rule with psid defined ranges.
+#
+
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=3D4
+ret=3D0
+ns_all=3D"nsclient1 nsrouter nsclient2"
+
+readonly infile=3D"$(mktemp)"
+readonly outfile=3D"$(mktemp)"
+readonly datalen=3D32
+readonly server_port=3D8080
+
+conntrack -V > /dev/null 2>&1
+if [ $? -ne 0 ];then
+	echo "SKIP: Could not run test without conntrack tool"
+	exit $ksft_skip
+fi
+
+iptables --version > /dev/null 2>&1
+if [ $? -ne 0 ];then
+	echo "SKIP: Could not run test without iptables tool"
+	exit $ksft_skip
+fi
+
+ip -Version > /dev/null 2>&1
+if [ $? -ne 0 ];then
+	echo "SKIP: Could not run test without ip tool"
+	exit $ksft_skip
+fi
+
+ipv4() {
+	echo -n 192.168.$1.$2
+}
+
+cleanup() {
+	for n in $ns_all; do ip netns del $n;done
+
+	if [ -f "${outfile}" ]; then
+		rm "$outfile"
+	fi
+	if [ -f "${infile}" ]; then
+		rm "$infile"
+	fi
+}
+
+server_listen() {
+	ip netns exec nsclient2 nc -l -p "$server_port" > "$outfile" &
+	server_pid=3D$!
+	sleep 0.2
+}
+
+client_connect() {
+	ip netns exec nsclient1 timeout 2 nc -w 1 -p "$port" $(ipv4 2 2) "$serv=
er_port" < $infile
+}
+
+verify_data() {
+	local _ret=3D0
+	wait "$server_pid"
+	cmp "$infile" "$outfile" 2>/dev/null
+	_ret=3D$?
+	rm "$outfile"
+	return $_ret
+}
+
+test_service() {
+	server_listen
+	client_connect
+	verify_data
+}
+
+check_connection() {
+	local _ret=3D0
+	entry=3D$(ip netns exec nsrouter conntrack -p tcp --sport $port -L 2>&1=
)
+	entry=3D${entry##*sport=3D8080 dport=3D}
+	entry=3D${entry%% *}
+
+	if [[ "x$(( ($entry & $psid_mask) / $two_power_j ))" !=3D "x$psid" ]]; =
then
+		_ret=3D1
+		echo "Failed psid mask check for $offset_len:$psid:$psid_length with p=
ort $entry"
+	fi
+
+	if [[ "x$_ret" =3D "x0" ]] &&
+	   [[ "x$offset_mask" !=3D "x0" -a "x$(( ($entry & $offset_mask) ))" =3D=
=3D "x0" ]]; then
+		_ret=3D1
+		echo "Failed offset mask check for $offset_len:$psid:$psid_length with=
 port $entry"
+	fi
+	return $_ret
+}
+
+run_test() {
+	ip netns exec nsrouter iptables -A FORWARD -i veth1 -j ACCEPT
+	ip netns exec nsrouter iptables -P FORWARD DROP
+	ip netns exec nsrouter iptables -A FORWARD -m state --state ESTABLISHED=
,RELATED -j ACCEPT
+	ip netns exec nsrouter iptables -t nat --new psid
+	ip netns exec nsrouter iptables -t nat --insert psid -j MASQUERADE \
+		--psid $offset_len:$psid:$psid_length
+	ip netns exec nsrouter iptables -t nat -I POSTROUTING -o veth2 -j psid
+
+	# calculate psid mask
+	offset=3D$(( 1 << (16 - $offset_len) ))
+	two_power_j=3D$(( $offset / (1 << $psid_length) ))
+	offset_mask=3D$(( ( (1 << $offset_len) - 1 ) << (16 - $offset_len) ))
+	psid_mask=3D$(( ( (1 << $psid_length) - 1) * $two_power_j ))
+
+	# Create file
+	dd if=3D/dev/urandom of=3D"${infile}" bs=3D"${datalen}" count=3D1 >/dev=
/null 2>&1
+
+	# Test multiple ports
+	for p in 1 2 3 4 5; do
+		port=3D1080$p
+
+		test_service
+		if [ $? -ne 0 ]; then
+			ret=3D1
+			break
+		fi
+
+		check_connection
+		if [ $? -ne 0 ]; then
+			ret=3D1
+			break
+		fi
+	done
+
+	# tidy up test rules
+	ip netns exec nsrouter iptables -F
+	ip netns exec nsrouter iptables -t nat -F
+	ip netns exec nsrouter iptables -t nat -X psid
+}
+
+for n in $ns_all; do
+	ip netns add $n
+	ip -net $n link set lo up
+done
+
+for i in 1 2; do
+	ip link add veth0 netns nsclient$i type veth peer name veth$i netns nsr=
outer
+
+	ip -net nsclient$i link set veth0 up
+	ip -net nsclient$i addr add $(ipv4 $i 2)/24 dev veth0
+
+	ip -net nsrouter link set veth$i up
+	ip -net nsrouter addr add $(ipv4 $i 1)/24 dev veth$i
+done
+
+ip -net nsclient1 route add default via $(ipv4 1 1)
+ip -net nsclient2 route add default via $(ipv4 2 1)
+
+ip netns exec nsrouter sysctl -q net.ipv4.conf.all.forwarding=3D1
+
+offset_len=3D0
+psid_length=3D8
+for psid in 0 52; do
+	run_test
+	if [ $? -ne 0 ]; then
+		break
+	fi
+done
+
+offset_len=3D6
+psid_length=3D8
+for psid in 0 52; do
+	run_test
+	if [ $? -ne 0 ]; then
+		break
+	fi
+done
+
+cleanup
+exit $ret
--=20
2.32.0


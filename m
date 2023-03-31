Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80E596D1629
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 05:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbjCaDzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 23:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjCaDzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 23:55:23 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A079FBB9D
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 20:55:20 -0700 (PDT)
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 61AD23F22F
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 03:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1680234918;
        bh=FeO82NmJH8T0m2u1rRW1AaXxCdwDEAqSAxDocDNc1gw=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=QwP5yvfE74q7F+ClZzg+HCtmIXPUPWFxMVHDDU/ptYSkqEIbj6mZvPXnEi2SUTiny
         vmZXrSQ+qikYGqwpVSs95rRGPuRhKbxFG3OZWdsKI/ixgjEehZ4LMOaZWAJBT40svB
         Q55oDzhBZnLo1qNTVKg7S7dOVY50L2g95v1Q+Yiwm7XYu9BcUarJ50vicZMPIjy1IW
         socGeGeNJmepWhEAZdIN20jhCFNjCGRN54pJlQWxAnR+Kp/zlYfJL/4by88fmyqU5P
         n0Igkz4uL5fpRENz029g1h7VfjgJr21P4a9df1EeC/ceowcHM1feY7haymiMZMFMU/
         qUfxcd7fWi9sA==
Received: by mail-pj1-f69.google.com with SMTP id b1-20020a17090a8c8100b002400db03706so5881761pjo.0
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 20:55:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680234917;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FeO82NmJH8T0m2u1rRW1AaXxCdwDEAqSAxDocDNc1gw=;
        b=4cTDbm5EgLhCsZdzrJKXthzeKgPWjCLq4QY6xGhXBaikKuiD0B+rYuSM/joXuN3/Zy
         KuuZxgBPamQRXfwmA4ZCcSeO3JUlFOqvh+QfpnpaXXxkVPa4qVxnnH/ozZ1GuavZN5cd
         gZUBkTlRofwe05B1dTInJTdwn4sUG7Dq8YF1IWkIILE3Ug8QIw2RDZRbjVJbGdepqNFF
         cYDbc+BxZR0XGVXkZY/W9/gfkk8/hWKQ8bO+HDOj6deaSzAvKzzzspzGnBphX1k4g9AY
         s/13BChzYvI67E72/doddHIQNxUdaCdwRSAp7eZz7iEPzvVz6Yv11avk9M5N50l1fXp1
         fbSg==
X-Gm-Message-State: AO0yUKWzTtS+G8I/fjm+NVRpWhL6LY8daZ2VKZGIuWTMgk43+hYTOIej
        /BslqBCIopMyL4h5Z2tcCRtl5o/sE+JQN2ChBjZWWARQ0eh1G5na2L2zTX4VF77/cC1yLcgC3np
        Xd/KGyojhlN+xs+SUgJKkObgOlsxqQDig0w==
X-Received: by 2002:a05:6a20:7187:b0:d9:6c3d:29cf with SMTP id s7-20020a056a20718700b000d96c3d29cfmr20828890pzb.52.1680234916892;
        Thu, 30 Mar 2023 20:55:16 -0700 (PDT)
X-Google-Smtp-Source: AK7set+xRWiKju4x9DgZx/DRyjKwbKs3JEoNSlaF+/dKWp1M0hCDLhI2jaW05/d5Pt+MmavbO3fUFQ==
X-Received: by 2002:a05:6a20:7187:b0:d9:6c3d:29cf with SMTP id s7-20020a056a20718700b000d96c3d29cfmr20828871pzb.52.1680234916489;
        Thu, 30 Mar 2023 20:55:16 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.253])
        by smtp.gmail.com with ESMTPSA id u20-20020aa78494000000b0062dd6c69519sm613310pfn.115.2023.03.30.20.55.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Mar 2023 20:55:16 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id A469660080; Thu, 30 Mar 2023 20:55:15 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 9C6629FB79;
        Thu, 30 Mar 2023 20:55:15 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, Liang Li <liali@redhat.com>
Subject: Re: [PATCH net 2/3] selftests: bonding: re-format bond option tests
In-reply-to: <20230329101859.3458449-3-liuhangbin@gmail.com>
References: <20230329101859.3458449-1-liuhangbin@gmail.com> <20230329101859.3458449-3-liuhangbin@gmail.com>
Comments: In-reply-to Hangbin Liu <liuhangbin@gmail.com>
   message dated "Wed, 29 Mar 2023 18:18:58 +0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <20837.1680234915.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Thu, 30 Mar 2023 20:55:15 -0700
Message-ID: <20838.1680234915@famine>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu <liuhangbin@gmail.com> wrote:

>To improve the testing process for bond options, A new bond library is
>added to our testing setup. The current option_prio.sh file will be
>renamed to bond_options.sh so that all bonding options can be tested here=
.
>Specifically, for priority testing, we will run all tests using module

	Typo here, "module" vs "mode"

>1, 5, and 6. These changes will help us streamline the testing process
>and ensure that our bond options are rigorously evaluated.

	Other than the typo above and a couple more noted below (which
aren't new to this patch; they're in code being copied), looks good to
me.

Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>

>Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
>---
> .../selftests/drivers/net/bonding/Makefile    |   3 +-
> .../selftests/drivers/net/bonding/bond_lib.sh | 145 +++++++++++
> .../drivers/net/bonding/bond_options.sh       | 216 +++++++++++++++
> .../drivers/net/bonding/option_prio.sh        | 245 ------------------
> 4 files changed, 363 insertions(+), 246 deletions(-)
> create mode 100644 tools/testing/selftests/drivers/net/bonding/bond_lib.=
sh
> create mode 100755 tools/testing/selftests/drivers/net/bonding/bond_opti=
ons.sh
> delete mode 100755 tools/testing/selftests/drivers/net/bonding/option_pr=
io.sh
>
>diff --git a/tools/testing/selftests/drivers/net/bonding/Makefile b/tools=
/testing/selftests/drivers/net/bonding/Makefile
>index a39bb2560d9b..4683b06afdba 100644
>--- a/tools/testing/selftests/drivers/net/bonding/Makefile
>+++ b/tools/testing/selftests/drivers/net/bonding/Makefile
>@@ -8,11 +8,12 @@ TEST_PROGS :=3D \
> 	dev_addr_lists.sh \
> 	mode-1-recovery-updelay.sh \
> 	mode-2-recovery-updelay.sh \
>-	option_prio.sh \
>+	bond_options.sh \
> 	bond-eth-type-change.sh
> =

> TEST_FILES :=3D \
> 	lag_lib.sh \
>+	bond_lib.sh \
> 	net_forwarding_lib.sh
> =

> include ../../../lib.mk
>diff --git a/tools/testing/selftests/drivers/net/bonding/bond_lib.sh b/to=
ols/testing/selftests/drivers/net/bonding/bond_lib.sh
>new file mode 100644
>index 000000000000..ca64a82e1385
>--- /dev/null
>+++ b/tools/testing/selftests/drivers/net/bonding/bond_lib.sh
>@@ -0,0 +1,145 @@
>+#!/bin/bash
>+# SPDX-License-Identifier: GPL-2.0
>+#
>+# Topology for Bond mode 1,5,6 testing
>+#
>+#  +---------------------------------------+
>+#  |                 bond0                 |  192.0.2.1/24
>+#  |                   +                   |  2001:db8::1/24
>+#  |       eth0        | eth1   eth2       |  Server
>+#  |         +-------------------+         |
>+#  |         |         |         |         |
>+#  +---------------------------------------+
>+#            |         |         |
>+#            |         |         |
>+#  +---------------------------------------+
>+#  |         |         |         |         |  192.0.2.254/24
>+#  |     +---+---------+---------+---+     |  2001:db8::254/24
>+#  |     |            br0            |     |  Switch
>+#  |     +---+---------+---------+---+     |
>+#  |         |         |         |         |
>+#  +---------------------------------------+
>+#            |         |         |
>+#      +-----+         |         +-----+
>+#      |               |               |
>+#  +-------+       +-------+           |
>+#  |   |   |       |   |   |           +
>+#  |   +   |       |   +   |     ... More clients if needed
>+#  | eth0  |       | eth0  |
>+#  +-------+       +-------+
>+#   Client          Client1
>+#  192.0.2.10      192.0.2.11
>+# 2001:db8::10    2001:db8::11
>+
>+s_ns=3D"s-$(mktemp -u XXXXXX)"
>+sw_ns=3D"sw-$(mktemp -u XXXXXX)"
>+c_ns=3D"c-$(mktemp -u XXXXXX)"
>+s_ip4=3D"192.0.2.1"
>+c_ip4=3D"192.0.2.10"
>+sw_ip4=3D"192.0.2.254"
>+s_ip6=3D"2001:db8::1"
>+c_ip6=3D"2001:db8::10"
>+sw_ip6=3D"2001:db8::254"
>+
>+switch_create()
>+{
>+	ip netns add ${sw_ns}
>+	ip -n ${sw_ns} link add br0 type bridge
>+	ip -n ${sw_ns} link set br0 up
>+	ip -n ${sw_ns} addr add ${sw_ip4}/24 dev br0
>+	ip -n ${sw_ns} addr add ${sw_ip6}/24 dev br0
>+}
>+
>+switch_destroy()
>+{
>+	ip -n ${sw_ns} link del br0
>+	ip netns del ${sw_ns}
>+}
>+
>+server_create()
>+{
>+	ip netns add ${s_ns}
>+	ip -n ${s_ns} link add bond0 type bond mode active-backup miimon 100
>+
>+	for i in $(seq 0 2); do
>+		ip -n ${s_ns} link add eth${i} type veth peer name s${i} netns ${sw_ns=
}
>+
>+		ip -n ${sw_ns} link set s${i} up
>+		ip -n ${sw_ns} link set s${i} master br0
>+		ip -n ${s_ns} link set eth${i} master bond0
>+	done
>+
>+	ip -n ${s_ns} link set bond0 up
>+	ip -n ${s_ns} addr add ${s_ip4}/24 dev bond0
>+	ip -n ${s_ns} addr add ${s_ip6}/24 dev bond0
>+	sleep 2
>+}
>+
>+bond_reset()
>+{
>+	local param=3D"$1"
>+
>+	ip -n ${s_ns} link set bond0 down
>+	ip -n ${s_ns} link del bond0
>+
>+	ip -n ${s_ns} link add bond0 type bond $param
>+	for i in $(seq 0 2); do
>+		ip -n ${s_ns} link set eth$i master bond0
>+	done
>+
>+	ip -n ${s_ns} link set bond0 up
>+	ip -n ${s_ns} addr add ${s_ip4}/24 dev bond0
>+	ip -n ${s_ns} addr add ${s_ip6}/24 dev bond0
>+	sleep 2
>+}
>+
>+server_destroy()
>+{
>+	for i in $(seq 0 2); do
>+		ip -n ${s_ns} link del eth${i}
>+	done
>+	ip netns del ${s_ns}
>+}
>+
>+client_create()
>+{
>+	ip netns add ${c_ns}
>+	ip -n ${c_ns} link add eth0 type veth peer name c0 netns ${sw_ns}
>+
>+	ip -n ${sw_ns} link set c0 up
>+	ip -n ${sw_ns} link set c0 master br0
>+
>+	ip -n ${c_ns} link set eth0 up
>+	ip -n ${c_ns} addr add ${c_ip4}/24 dev eth0
>+	ip -n ${c_ns} addr add ${c_ip6}/24 dev eth0
>+}
>+
>+client_destroy()
>+{
>+	ip -n ${c_ns} link del eth0
>+	ip netns del ${c_ns}
>+}
>+
>+setup_prepare()
>+{
>+	switch_create
>+	server_create
>+	client_create
>+}
>+
>+cleanup()
>+{
>+	pre_cleanup
>+
>+	client_destroy
>+	server_destroy
>+	switch_destroy
>+}
>+
>+bond_check_connection()
>+{
>+	ip netns exec ${s_ns} ping ${c_ip4} -c5 -i 0.1 -I bond0 &>/dev/null
>+	check_err $? "ping failed"
>+	ip netns exec ${s_ns} ping6 ${c_ip6} -c5 -i 0.1 -I bond0 &>/dev/null
>+	check_err $? "ping6 failed"
>+}
>diff --git a/tools/testing/selftests/drivers/net/bonding/bond_options.sh =
b/tools/testing/selftests/drivers/net/bonding/bond_options.sh
>new file mode 100755
>index 000000000000..431ce0e45e3c
>--- /dev/null
>+++ b/tools/testing/selftests/drivers/net/bonding/bond_options.sh
>@@ -0,0 +1,216 @@
>+#!/bin/bash
>+# SPDX-License-Identifier: GPL-2.0
>+#
>+# Test bonding options
>+
>+ALL_TESTS=3D"
>+	prio
>+"
>+
>+REQUIRE_MZ=3Dno
>+NUM_NETIFS=3D0
>+lib_dir=3D$(dirname "$0")
>+source "$lib_dir"/net_forwarding_lib.sh
>+source "$lib_dir"/bond_lib.sh
>+
>+skip_prio()
>+{
>+	local skip=3D1
>+
>+	# check if iproute support prio option
>+	ip -n ${s_ns} link set eth0 type bond_slave prio 10
>+	[[ $? -ne 0 ]] && skip=3D0
>+
>+	# check if kernel support prio option
>+	ip -n ${s_ns} -d link show eth0 | grep -q "prio 10"
>+	[[ $? -ne 0 ]] && skip=3D0
>+
>+	return $skip
>+}
>+
>+skip_ns()
>+{
>+	local skip=3D1
>+
>+	# check if iproute support ns_ip6_target option
>+	ip -n ${s_ns} link add bond1 type bond ns_ip6_target ${sw_ip6}
>+	[[ $? -ne 0 ]] && skip=3D0
>+
>+	# check if kernel support ns_ip6_target option
>+	ip -n ${s_ns} -d link show bond1 | grep -q "ns_ip6_target ${sw_ip6}"
>+	[[ $? -ne 0 ]] && skip=3D0
>+
>+	ip -n ${s_ns} link del bond1
>+
>+	return $skip
>+}
>+
>+active_slave=3D""
>+check_active_slave()
>+{
>+	local target_active_slave=3D$1
>+	active_slave=3D$(cmd_jq "ip -n ${s_ns} -d -j link show bond0" ".[].link=
info.info_data.active_slave")
>+	test "$active_slave" =3D "$target_active_slave"
>+	check_err $? "Current active slave is $active_slave but not $target_act=
ive_slave"
>+}
>+
>+
>+# Test bonding prio option
>+prio_test()
>+{
>+	local param=3D"$1"
>+	RET=3D0
>+
>+	# create bond
>+	bond_reset "${param}"
>+
>+	# check bonding member prio value
>+	ip -n ${s_ns} link set eth0 type bond_slave prio 0
>+	ip -n ${s_ns} link set eth1 type bond_slave prio 10
>+	ip -n ${s_ns} link set eth2 type bond_slave prio 11
>+	cmd_jq "ip -n ${s_ns} -d -j link show eth0" \
>+		".[].linkinfo.info_slave_data | select (.prio =3D=3D 0)" "-e" &> /dev/=
null
>+	check_err $? "eth0 prio is not 0"
>+	cmd_jq "ip -n ${s_ns} -d -j link show eth1" \
>+		".[].linkinfo.info_slave_data | select (.prio =3D=3D 10)" "-e" &> /dev=
/null
>+	check_err $? "eth1 prio is not 10"
>+	cmd_jq "ip -n ${s_ns} -d -j link show eth2" \
>+		".[].linkinfo.info_slave_data | select (.prio =3D=3D 11)" "-e" &> /dev=
/null
>+	check_err $? "eth2 prio is not 11"
>+
>+	bond_check_connection
>+	[ $RET -ne 0 ] && log_test "prio" "$retmsg"
>+
>+	# active salve should be the primary slave

	"salve" -> "slave"

>+	check_active_slave eth1
>+
>+	# active slave should be the higher prio slave
>+	ip -n ${s_ns} link set $active_slave down
>+	ip netns exec ${s_ns} ping $c_ip4 -c5 -I bond0 &>/dev/null
>+	check_err $? "ping failed 2."
>+	check_active_slave eth2
>+
>+	# when only 1 slave is up
>+	ip -n ${s_ns} link set $active_slave down
>+	ip netns exec ${s_ns} ping $c_ip4 -c5 -I bond0 &>/dev/null
>+	check_err $? "ping failed 3."
>+	check_active_slave eth0
>+
>+	# when a higher prio slave change to up
>+	ip -n ${s_ns} link set eth2 up
>+	ip netns exec ${s_ns} ping $c_ip4 -c5 -I bond0 &>/dev/null
>+	check_err $? "ping failed 4."
>+	case $primary_reselect in
>+		"0")
>+			check_active_slave "eth2"
>+			;;
>+		"1")
>+			check_active_slave "eth0"
>+			;;
>+		"2")
>+			check_active_slave "eth0"
>+			;;
>+	esac
>+	local pre_active_slave=3D$active_slave
>+
>+	# when the primary slave change to up
>+	ip -n ${s_ns} link set eth1 up
>+	ip netns exec ${s_ns} ping $c_ip4 -c5 -I bond0 &>/dev/null
>+	check_err $? "ping failed 5."
>+	case $primary_reselect in
>+		"0")
>+			check_active_slave "eth1"
>+			;;
>+		"1")
>+			check_active_slave "$pre_active_slave"
>+			;;
>+		"2")
>+			check_active_slave "$pre_active_slave"
>+			ip -n ${s_ns} link set $active_slave down
>+			ip netns exec ${s_ns} ping $c_ip4 -c5 -I bond0 &>/dev/null
>+			check_err $? "ping failed 6."
>+			check_active_slave "eth1"
>+			;;
>+	esac
>+
>+	# Test changing bond salve prio

	"salve" -> "slave"

>+	if [[ "$primary_reselect" =3D=3D "0" ]];then
>+		ip -n ${s_ns} link set eth0 type bond_slave prio 1000000
>+		ip -n ${s_ns} link set eth1 type bond_slave prio 0
>+		ip -n ${s_ns} link set eth2 type bond_slave prio -50
>+		ip -n ${s_ns} -d link show eth0 | grep -q 'prio 1000000'
>+		check_err $? "eth0 prio is not 1000000"
>+		ip -n ${s_ns} -d link show eth1 | grep -q 'prio 0'
>+		check_err $? "eth1 prio is not 0"
>+		ip -n ${s_ns} -d link show eth2 | grep -q 'prio -50'
>+		check_err $? "eth3 prio is not -50"
>+		check_active_slave "eth1"
>+
>+		ip -n ${s_ns} link set $active_slave down
>+		ip netns exec ${s_ns} ping $c_ip4 -c5 -I bond0 &>/dev/null
>+		check_err $? "ping failed 7."
>+		check_active_slave "eth0"
>+	fi
>+}
>+
>+prio_miimon()
>+{
>+	local primary_reselect
>+	local mode=3D$1
>+
>+	for primary_reselect in 0 1 2; do
>+		prio_test "mode $mode miimon 100 primary eth1 primary_reselect $primar=
y_reselect"
>+		log_test "prio" "$mode miimon primary_reselect $primary_reselect"
>+	done
>+}
>+
>+prio_arp()
>+{
>+	local primary_reselect
>+	local mode=3D$1
>+
>+	for primary_reselect in 0 1 2; do
>+		prio_test "mode active-backup arp_interval 1000 arp_ip_target ${sw_ip4=
} primary eth1 primary_reselect $primary_reselect"
>+		log_test "prio" "$mode arp_ip_target primary_reselect $primary_reselec=
t"
>+	done
>+}
>+
>+prio_ns()
>+{
>+	local primary_reselect
>+	local mode=3D$1
>+
>+	if skip_ns; then
>+		log_test_skip "prio ns" "Current iproute or kernel doesn't support bon=
d option 'ns_ip6_target'."
>+		return 0
>+	fi
>+
>+	for primary_reselect in 0 1 2; do
>+		prio_test "mode active-backup arp_interval 1000 ns_ip6_target ${sw_ip6=
} primary eth1 primary_reselect $primary_reselect"
>+		log_test "prio" "$mode ns_ip6_target primary_reselect $primary_reselec=
t"
>+	done
>+}
>+
>+prio()
>+{
>+	local mode modes=3D"active-backup balance-tlb balance-alb"
>+
>+	if skip_prio; then
>+		log_test_skip "prio" "Current iproute or kernel doesn't support bond o=
ption 'prio'."
>+		return 0
>+	fi
>+
>+	for mode in $modes; do
>+		prio_miimon $mode
>+		prio_arp $mode
>+		prio_ns $mode
>+	done
>+}
>+
>+trap cleanup EXIT
>+
>+setup_prepare
>+setup_wait
>+tests_run
>+
>+exit $EXIT_STATUS
>diff --git a/tools/testing/selftests/drivers/net/bonding/option_prio.sh b=
/tools/testing/selftests/drivers/net/bonding/option_prio.sh
>deleted file mode 100755
>index c32eebff5005..000000000000
>--- a/tools/testing/selftests/drivers/net/bonding/option_prio.sh
>+++ /dev/null
>@@ -1,245 +0,0 @@
>-#!/bin/bash
>-# SPDX-License-Identifier: GPL-2.0
>-#
>-# Test bonding option prio
>-#
>-
>-ALL_TESTS=3D"
>-	prio_arp_ip_target_test
>-	prio_miimon_test
>-"
>-
>-REQUIRE_MZ=3Dno
>-REQUIRE_JQ=3Dno
>-NUM_NETIFS=3D0
>-lib_dir=3D$(dirname "$0")
>-source "$lib_dir"/net_forwarding_lib.sh
>-
>-destroy()
>-{
>-	ip link del bond0 &>/dev/null
>-	ip link del br0 &>/dev/null
>-	ip link del veth0 &>/dev/null
>-	ip link del veth1 &>/dev/null
>-	ip link del veth2 &>/dev/null
>-	ip netns del ns1 &>/dev/null
>-	ip link del veth3 &>/dev/null
>-}
>-
>-cleanup()
>-{
>-	pre_cleanup
>-
>-	destroy
>-}
>-
>-skip()
>-{
>-        local skip=3D1
>-	ip link add name bond0 type bond mode 1 miimon 100 &>/dev/null
>-	ip link add name veth0 type veth peer name veth0_p
>-	ip link set veth0 master bond0
>-
>-	# check if iproute support prio option
>-	ip link set dev veth0 type bond_slave prio 10
>-	[[ $? -ne 0 ]] && skip=3D0
>-
>-	# check if bonding support prio option
>-	ip -d link show veth0 | grep -q "prio 10"
>-	[[ $? -ne 0 ]] && skip=3D0
>-
>-	ip link del bond0 &>/dev/null
>-	ip link del veth0
>-
>-	return $skip
>-}
>-
>-active_slave=3D""
>-check_active_slave()
>-{
>-	local target_active_slave=3D$1
>-	active_slave=3D"$(cat /sys/class/net/bond0/bonding/activev_slave)"
>-	test "$active_slave" =3D "$target_active_slave"
>-	check_err $? "Current active slave is $active_slave but not $target_act=
ive_slave"
>-}
>-
>-
>-# Test bonding prio option with mode=3D$mode monitor=3D$monitor
>-# and primary_reselect=3D$primary_reselect
>-prio_test()
>-{
>-	RET=3D0
>-
>-	local monitor=3D$1
>-	local mode=3D$2
>-	local primary_reselect=3D$3
>-
>-	local bond_ip4=3D"192.169.1.2"
>-	local peer_ip4=3D"192.169.1.1"
>-	local bond_ip6=3D"2009:0a:0b::02"
>-	local peer_ip6=3D"2009:0a:0b::01"
>-
>-
>-	# create veths
>-	ip link add name veth0 type veth peer name veth0_p
>-	ip link add name veth1 type veth peer name veth1_p
>-	ip link add name veth2 type veth peer name veth2_p
>-
>-	# create bond
>-	if [[ "$monitor" =3D=3D "miimon" ]];then
>-		ip link add name bond0 type bond mode $mode miimon 100 primary veth1 p=
rimary_reselect $primary_reselect
>-	elif [[ "$monitor" =3D=3D "arp_ip_target" ]];then
>-		ip link add name bond0 type bond mode $mode arp_interval 1000 arp_ip_t=
arget $peer_ip4 primary veth1 primary_reselect $primary_reselect
>-	elif [[ "$monitor" =3D=3D "ns_ip6_target" ]];then
>-		ip link add name bond0 type bond mode $mode arp_interval 1000 ns_ip6_t=
arget $peer_ip6 primary veth1 primary_reselect $primary_reselect
>-	fi
>-	ip link set bond0 up
>-	ip link set veth0 master bond0
>-	ip link set veth1 master bond0
>-	ip link set veth2 master bond0
>-	# check bonding member prio value
>-	ip link set dev veth0 type bond_slave prio 0
>-	ip link set dev veth1 type bond_slave prio 10
>-	ip link set dev veth2 type bond_slave prio 11
>-	ip -d link show veth0 | grep -q 'prio 0'
>-	check_err $? "veth0 prio is not 0"
>-	ip -d link show veth1 | grep -q 'prio 10'
>-	check_err $? "veth0 prio is not 10"
>-	ip -d link show veth2 | grep -q 'prio 11'
>-	check_err $? "veth0 prio is not 11"
>-
>-	ip link set veth0 up
>-	ip link set veth1 up
>-	ip link set veth2 up
>-	ip link set veth0_p up
>-	ip link set veth1_p up
>-	ip link set veth2_p up
>-
>-	# prepare ping target
>-	ip link add name br0 type bridge
>-	ip link set br0 up
>-	ip link set veth0_p master br0
>-	ip link set veth1_p master br0
>-	ip link set veth2_p master br0
>-	ip link add name veth3 type veth peer name veth3_p
>-	ip netns add ns1
>-	ip link set veth3_p master br0 up
>-	ip link set veth3 netns ns1 up
>-	ip netns exec ns1 ip addr add $peer_ip4/24 dev veth3
>-	ip netns exec ns1 ip addr add $peer_ip6/64 dev veth3
>-	ip addr add $bond_ip4/24 dev bond0
>-	ip addr add $bond_ip6/64 dev bond0
>-	sleep 5
>-
>-	ping $peer_ip4 -c5 -I bond0 &>/dev/null
>-	check_err $? "ping failed 1."
>-	ping6 $peer_ip6 -c5 -I bond0 &>/dev/null
>-	check_err $? "ping6 failed 1."
>-
>-	# active salve should be the primary slave
>-	check_active_slave veth1
>-
>-	# active slave should be the higher prio slave
>-	ip link set $active_slave down
>-	ping $peer_ip4 -c5 -I bond0 &>/dev/null
>-	check_err $? "ping failed 2."
>-	check_active_slave veth2
>-
>-	# when only 1 slave is up
>-	ip link set $active_slave down
>-	ping $peer_ip4 -c5 -I bond0 &>/dev/null
>-	check_err $? "ping failed 3."
>-	check_active_slave veth0
>-
>-	# when a higher prio slave change to up
>-	ip link set veth2 up
>-	ping $peer_ip4 -c5 -I bond0 &>/dev/null
>-	check_err $? "ping failed 4."
>-	case $primary_reselect in
>-		"0")
>-			check_active_slave "veth2"
>-			;;
>-		"1")
>-			check_active_slave "veth0"
>-			;;
>-		"2")
>-			check_active_slave "veth0"
>-			;;
>-	esac
>-	local pre_active_slave=3D$active_slave
>-
>-	# when the primary slave change to up
>-	ip link set veth1 up
>-	ping $peer_ip4 -c5 -I bond0 &>/dev/null
>-	check_err $? "ping failed 5."
>-	case $primary_reselect in
>-		"0")
>-			check_active_slave "veth1"
>-			;;
>-		"1")
>-			check_active_slave "$pre_active_slave"
>-			;;
>-		"2")
>-			check_active_slave "$pre_active_slave"
>-			ip link set $active_slave down
>-			ping $peer_ip4 -c5 -I bond0 &>/dev/null
>-			check_err $? "ping failed 6."
>-			check_active_slave "veth1"
>-			;;
>-	esac
>-
>-	# Test changing bond salve prio
>-	if [[ "$primary_reselect" =3D=3D "0" ]];then
>-		ip link set dev veth0 type bond_slave prio 1000000
>-		ip link set dev veth1 type bond_slave prio 0
>-		ip link set dev veth2 type bond_slave prio -50
>-		ip -d link show veth0 | grep -q 'prio 1000000'
>-		check_err $? "veth0 prio is not 1000000"
>-		ip -d link show veth1 | grep -q 'prio 0'
>-		check_err $? "veth1 prio is not 0"
>-		ip -d link show veth2 | grep -q 'prio -50'
>-		check_err $? "veth3 prio is not -50"
>-		check_active_slave "veth1"
>-
>-		ip link set $active_slave down
>-		ping $peer_ip4 -c5 -I bond0 &>/dev/null
>-		check_err $? "ping failed 7."
>-		check_active_slave "veth0"
>-	fi
>-
>-	cleanup
>-
>-	log_test "prio_test" "Test bonding option 'prio' with mode=3D$mode moni=
tor=3D$monitor and primary_reselect=3D$primary_reselect"
>-}
>-
>-prio_miimon_test()
>-{
>-	local mode
>-	local primary_reselect
>-
>-	for mode in 1 5 6; do
>-		for primary_reselect in 0 1 2; do
>-			prio_test "miimon" $mode $primary_reselect
>-		done
>-	done
>-}
>-
>-prio_arp_ip_target_test()
>-{
>-	local primary_reselect
>-
>-	for primary_reselect in 0 1 2; do
>-		prio_test "arp_ip_target" 1 $primary_reselect
>-	done
>-}
>-
>-if skip;then
>-	log_test_skip "option_prio.sh" "Current iproute doesn't support 'prio'.=
"
>-	exit 0
>-fi
>-
>-trap cleanup EXIT
>-
>-tests_run
>-
>-exit "$EXIT_STATUS"
>-- =

>2.38.1
>

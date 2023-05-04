Return-Path: <netdev+bounces-304-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 511486F6F7D
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 17:58:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 44F1A1C2117D
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 15:58:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C8D5A93D;
	Thu,  4 May 2023 15:58:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624962F48
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 15:58:55 +0000 (UTC)
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6868C59C4;
	Thu,  4 May 2023 08:58:53 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
	by mailout.nyi.internal (Postfix) with ESMTP id 091B25C03AF;
	Thu,  4 May 2023 11:58:50 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 04 May 2023 11:58:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm3; t=1683215930; x=1683302330; bh=2ORXMgnZMkh7X
	2qFN+Nty3xN4NmP1oMZ/3xO5IJoaB4=; b=A28ZEUd8kI53SAe9yB7iQPjTBGs53
	y/lY6BzwWj9Umw6SD+2Un0WfhMYywJxvKqph5mKCVmmRL0xnufDUNehTnASDmCyk
	Gmzdq2fAs7GgaLWm7QP9+rYPyCLJXM4NLAUXUFv69xCE7Kty1P0VIj6TdCoCc3ln
	hvqRWRPMjiiZS4vQTdJ4lWq5sORK1IgaBbhjRDdzUKnj449AMgFzM9dwMtafQBWU
	vp53Ai8LfrrHA8XOiplGw3ncshuw0/5QucALDHKZgK6OUnkyc5V9PqY6LQURyKBw
	Ks2hFaZL93vrNbXn4G6wfhnxHNR6B0uAUMOTAnLIpKQFP+Joju/RuCnQQ==
X-ME-Sender: <xms:OdZTZAIfEMGS5oM2f_ntJuJVoy-WR8hP6dI3Vqqh8l3ROyX4h0nBAQ>
    <xme:OdZTZAIch0nn3xTRTYvZUs26BW4ONDGYHw1wlZR0MGmKNY-2Ll0H0fseKlsFendYH
    SM2cp4oxCORVoo>
X-ME-Received: <xmr:OdZTZAsR6TaqUMTq2Jp9N-CT_YnCrQ2CpzNSrHr70LjoOZ2BfnZZKIMzsWz0KzOzh4YJqoRmrzRlxsS6rI8PONScNxU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeeftddgleehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhephefhtdejvdeiffefudduvdffgeetieeigeeugfduffdvffdtfeehieejtdfh
    jeeknecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:OdZTZNaPk0u0QtM645JcIaSr6U1vN3-h6yfi9N-tEzqJ7xObXBYHjg>
    <xmx:OdZTZHZGmiqeiHQVAz0GK8eKcOgLquUt8WCYLOxK9u6es-gJ1SEFgQ>
    <xmx:OdZTZJCgrIgSGvd0O6Wk26vyuoZKn8VGmI_jk-Q0gJccfiAodQVjXQ>
    <xmx:OtZTZLSwNMcNSMfEU_mIhSwopUOo8ww0sGkAIKKn_Bw7b6MxAM8b-A>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 4 May 2023 11:58:49 -0400 (EDT)
Date: Thu, 4 May 2023 18:58:45 +0300
From: Ido Schimmel <idosch@idosch.org>
To: Vladimir Nikishkin <vladimir@nikishkin.pw>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com,
	eng.alaamohamedsoliman.am@gmail.com, gnault@redhat.com,
	razor@blackwall.org, idosch@nvidia.com, liuhangbin@gmail.com,
	eyal.birger@gmail.com, jtoppins@redhat.com, shuah@kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next v7 2/2] Add tests for vxlan nolocalbypass option.
Message-ID: <ZFPWNXtV7sTmH/aQ@shredder>
References: <20230501162530.26414-1-vladimir@nikishkin.pw>
 <20230501162530.26414-2-vladimir@nikishkin.pw>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230501162530.26414-2-vladimir@nikishkin.pw>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 02, 2023 at 12:25:30AM +0800, Vladimir Nikishkin wrote:
> Add test to make sure that the localbypass option is on by default.
> 
> Add test to change vxlan localbypass to nolocalbypass and check
> that packets are delivered to userspace.

What do you think about this version [1]? I ended up removing the socat
usage because it was unnecessarily complicated (sorry). Note that this
test does not pass without the diff I posted earlier [2].

Without the diff, "nolocalbypass" basically means "Perform a bypass only
if there is a matching local VXLAN device, otherwise encapsulate the
packet and deliver it locally".

With the diff, "nolocalbypass" means "Never perform a bypass,
encapsulate the packet and deliver it locally".

I think my definition better suits the "nolocalbypass" name. It also
means that user space see consistent behavior: Encapsulated packets are
always visible on the loopback device, regardless if there is a matching
local VXLAN device.

It is true that with or without the diff packets will end up in the
local VXLAN device, assuming one exists.

[1]
#!/bin/bash
# SPDX-License-Identifier: GPL-2.0

# This test is for checking the [no]localbypass VXLAN device option. The test
# configures two VXLAN devices in the same network namespace and a tc filter on
# the loopback device that drops encapsulated packets. The test sends packets
# from the first VXLAN device and verifies that by default these packets are
# received by the second VXLAN device. The test then enables the nolocalbypass
# option and verifies that packets are no longer received by the second VXLAN
# device.

ret=0
# Kselftest framework requirement - SKIP code is 4.
ksft_skip=4

TESTS="
	nolocalbypass
"
VERBOSE=0
PAUSE_ON_FAIL=no
PAUSE=no

################################################################################
# Utilities

log_test()
{
	local rc=$1
	local expected=$2
	local msg="$3"

	if [ ${rc} -eq ${expected} ]; then
		printf "TEST: %-60s  [ OK ]\n" "${msg}"
		nsuccess=$((nsuccess+1))
	else
		ret=1
		nfail=$((nfail+1))
		printf "TEST: %-60s  [FAIL]\n" "${msg}"
		if [ "$VERBOSE" = "1" ]; then
			echo "    rc=$rc, expected $expected"
		fi

		if [ "${PAUSE_ON_FAIL}" = "yes" ]; then
		echo
			echo "hit enter to continue, 'q' to quit"
			read a
			[ "$a" = "q" ] && exit 1
		fi
	fi

	if [ "${PAUSE}" = "yes" ]; then
		echo
		echo "hit enter to continue, 'q' to quit"
		read a
		[ "$a" = "q" ] && exit 1
	fi

	[ "$VERBOSE" = "1" ] && echo
}

run_cmd()
{
	local cmd="$1"
	local out
	local stderr="2>/dev/null"

	if [ "$VERBOSE" = "1" ]; then
		printf "COMMAND: $cmd\n"
		stderr=
	fi

	out=$(eval $cmd $stderr)
	rc=$?
	if [ "$VERBOSE" = "1" -a -n "$out" ]; then
		echo "    $out"
	fi

	return $rc
}

tc_check_packets()
{
	local ns=$1; shift
	local id=$1; shift
	local handle=$1; shift
	local count=$1; shift
	local pkts

	sleep 0.1
	pkts=$(tc -n $ns -j -s filter show $id \
		| jq ".[] | select(.options.handle == $handle) | \
		.options.actions[0].stats.packets")
	[[ $pkts == $count ]]
}

################################################################################
# Setup

setup()
{
	ip netns add ns1

	ip -n ns1 link set dev lo up
	ip -n ns1 address add 192.0.2.1/32 dev lo
	ip -n ns1 address add 198.51.100.1/32 dev lo

	ip -n ns1 link add name vx0 up type vxlan id 100 local 198.51.100.1 \
		dstport 4789 nolearning
	ip -n ns1 link add name vx1 up type vxlan id 100 dstport 4790
}

cleanup()
{
	ip netns del ns1 &> /dev/null
}

################################################################################
# Tests

nolocalbypass()
{
	local smac=00:01:02:03:04:05
	local dmac=00:0a:0b:0c:0d:0e

	run_cmd "bridge -n ns1 fdb add $dmac dev vx0 self static dst 192.0.2.1 port 4790"

	run_cmd "tc -n ns1 qdisc add dev vx1 clsact"
	run_cmd "tc -n ns1 filter add dev vx1 ingress pref 1 handle 101 proto all flower src_mac $smac dst_mac $dmac action pass"

	run_cmd "tc -n ns1 qdisc add dev lo clsact"
	run_cmd "tc -n ns1 filter add dev lo ingress pref 1 handle 101 proto ip flower ip_proto udp dst_port 4790 action drop"

	run_cmd "ip -n ns1 -d link show dev vx0 | grep ' localbypass'"
	log_test $? 0 "localbypass enabled"

	run_cmd "ip netns exec ns1 mausezahn vx0 -a $smac -b $dmac -c 1 -p 100 -q"

	tc_check_packets "ns1" "dev vx1 ingress" 101 1
	log_test $? 0 "Packet received by local VXLAN device - localbypass"

	run_cmd "ip -n ns1 link set dev vx0 type vxlan nolocalbypass"

	run_cmd "ip -n ns1 -d link show dev vx0 | grep 'nolocalbypass'"
	log_test $? 0 "localbypass disabled"

	run_cmd "ip netns exec ns1 mausezahn vx0 -a $smac -b $dmac -c 1 -p 100 -q"

	tc_check_packets "ns1" "dev vx1 ingress" 101 1
	log_test $? 0 "Packet not received by local VXLAN device - nolocalbypass"

	run_cmd "ip -n ns1 link set dev vx0 type vxlan localbypass"

	run_cmd "ip -n ns1 -d link show dev vx0 | grep ' localbypass'"
	log_test $? 0 "localbypass enabled"

	run_cmd "ip netns exec ns1 mausezahn vx0 -a $smac -b $dmac -c 1 -p 100 -q"

	tc_check_packets "ns1" "dev vx1 ingress" 101 2
	log_test $? 0 "Packet received by local VXLAN device - localbypass"
}

################################################################################
# Usage

usage()
{
	cat <<EOF
usage: ${0##*/} OPTS

        -t <test>   Test(s) to run (default: all)
                    (options: $TESTS)
        -p          Pause on fail
        -P          Pause after each test before cleanup
        -v          Verbose mode (show commands and output)
EOF
}

################################################################################
# Main

trap cleanup EXIT

while getopts ":t:pPvh" opt; do
	case $opt in
		t) TESTS=$OPTARG ;;
		p) PAUSE_ON_FAIL=yes;;
		P) PAUSE=yes;;
		v) VERBOSE=$(($VERBOSE + 1));;
		h) usage; exit 0;;
		*) usage; exit 1;;
	esac
done

# Make sure we don't pause twice.
[ "${PAUSE}" = "yes" ] && PAUSE_ON_FAIL=no

if [ "$(id -u)" -ne 0 ];then
	echo "SKIP: Need root privileges"
	exit $ksft_skip;
fi

if [ ! -x "$(command -v ip)" ]; then
	echo "SKIP: Could not run test without ip tool"
	exit $ksft_skip
fi

if [ ! -x "$(command -v bridge)" ]; then
	echo "SKIP: Could not run test without bridge tool"
	exit $ksft_skip
fi

if [ ! -x "$(command -v mausezahn)" ]; then
	echo "SKIP: Could not run test without mausezahn tool"
	exit $ksft_skip
fi

if [ ! -x "$(command -v jq)" ]; then
	echo "SKIP: Could not run test without jq tool"
	exit $ksft_skip
fi

ip link help vxlan 2>&1 | grep -q "localbypass"
if [ $? -ne 0 ]; then
	echo "SKIP: iproute2 ip too old, missing VXLAN nolocalbypass support"
	exit $ksft_skip
fi

cleanup

for t in $TESTS
do
	setup; $t; cleanup;
done

if [ "$TESTS" != "none" ]; then
	printf "\nTests passed: %3d\n" ${nsuccess}
	printf "Tests failed: %3d\n"   ${nfail}
fi

exit $ret

[2] https://lore.kernel.org/netdev/ZFOthnnqvElorCM8@shredder/


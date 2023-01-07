Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3DA660EE0
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 13:45:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231865AbjAGMpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 07:45:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbjAGMpj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 07:45:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E9936E0C6
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 04:44:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673095490;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z31Pk8kjNbX6UUxa0/xXwN7xp6ldk2j1Mpp0B/eCW1M=;
        b=GAkh5xKPoXw4GBIhp1MK3NKL+aNJAFbl+SgUjaAi+oV/l+IBhkniF601ZPeNcg/EcSvD0u
        N/iebC+0JDUePFuEw9/WdjAQKC2F0VxhrnUufOV/EzVXSHd6bC01CvTdynJs2i+QPy6R3b
        QzUK2o0Nyas5jqXuAUNc6ELpBblXQ2g=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-362-ejcRiSnYO6e-LXOjcrCgZw-1; Sat, 07 Jan 2023 07:44:49 -0500
X-MC-Unique: ejcRiSnYO6e-LXOjcrCgZw-1
Received: by mail-qt1-f200.google.com with SMTP id e18-20020ac845d2000000b003a6a5cbbebcso2116394qto.20
        for <netdev@vger.kernel.org>; Sat, 07 Jan 2023 04:44:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z31Pk8kjNbX6UUxa0/xXwN7xp6ldk2j1Mpp0B/eCW1M=;
        b=otWbOWT/mtItBmochqfY3qA1qFMsYc6/IQwBmOJsCo73HtkWeobTKsjdAT+3CeRCgi
         BkL0nwN7chwlUUiO9m5ZtByXst9rsrS0ARO4wyhqvuuHWedHodXRjDR26PgHdZ50pOf1
         h/PAjsS/2+QgL6Q0eVZym1MDWsLYwm/aRbHtYq8iyWcdjfOOf5QrcBmEYAarUofjcJ1V
         NNw5wffsy+BMq/5w7mu8XAkltGkPbIh4OFOqoCdp4FXkFguQL78kdfYv54A2WsA/LgGs
         YWPYwF3xhAvTcd6yRBs+PVQHLSjrBrSPVMej0C8Zll+KAu4DD7xfJvrlba+hvQEM+I/g
         +RTA==
X-Gm-Message-State: AFqh2kq/XTxR+pDZpNVXLzsEVwogDEvaVKMv833ZSVcdfv1nAJdaYURb
        vjdSzACDRXdSuX8yz9LDVzxZ2oPlTo8Dsilv6kMSlWQcnLYdlSA+wz0sarUNvt5iCtLS2bzmg9J
        vYGUWM9HHxb2tY9/O
X-Received: by 2002:ac8:7457:0:b0:3a8:2122:7c28 with SMTP id h23-20020ac87457000000b003a821227c28mr86662679qtr.47.1673095488525;
        Sat, 07 Jan 2023 04:44:48 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtu9jDKBlN/p/MpleWPwUELI1K08X1thsAyhFaMHM6X9P1miEpP7zv/ZYEvmTfGe02l/6uztA==
X-Received: by 2002:ac8:7457:0:b0:3a8:2122:7c28 with SMTP id h23-20020ac87457000000b003a821227c28mr86662656qtr.47.1673095488174;
        Sat, 07 Jan 2023 04:44:48 -0800 (PST)
Received: from debian (2a01cb058918ce00e3192ce9ffef0fc4.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:e319:2ce9:ffef:fc4])
        by smtp.gmail.com with ESMTPSA id v4-20020ac873c4000000b003a7f1e16649sm1886548qtp.42.2023.01.07.04.44.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Jan 2023 04:44:47 -0800 (PST)
Date:   Sat, 7 Jan 2023 13:44:43 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Cc:     linux-kselftest@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthias May <matthias.may@westermo.com>
Subject: Re: BUG: tools/testing/selftests/net/l2_tos_ttl_inherit.sh hangs
 when selftest restarted
Message-ID: <Y7lpO9IHtSIyHVej@debian>
References: <924f1062-ab59-9b88-3b43-c44e73a30387@alu.unizg.hr>
 <Y7i5cT1AlyC53hzN@debian>
 <5ef41d3c-8d81-86b3-c571-044636702342@alu.unizg.hr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5ef41d3c-8d81-86b3-c571-044636702342@alu.unizg.hr>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[Cc: Matthias since he's the original author of the script]

On Sat, Jan 07, 2023 at 02:17:07AM +0100, Mirsad Goran Todorovac wrote:
> On 07. 01. 2023. 01:14, Guillaume Nault wrote:
> > On Fri, Jan 06, 2023 at 02:44:11AM +0100, Mirsad Goran Todorovac wrote:
> > > [root@pc-mtodorov linux_torvalds]# tools/testing/selftests/net/l2_tos_ttl_inherit.sh
> > > ┌────────┬───────┬───────┬──────────────┬──────────────┬───────┬────────┐
> > > ├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
> > > │  Type  │ outer | inner │     tos      │      ttl     │  vlan │ result │
> > > ├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
> > > │    gre │     4 │     4 │ inherit 0xc4 │  inherit 116 │ false │Cannot create namespace file "/var/run/netns/testing": File exists
> > > RTNETLINK answers: File exists
> > > RTNETLINK answers: File exists
> > > RTNETLINK answers: File exists
> > 
> > You probably have leftovers from a previous test case. In particular
> > the "testing" network name space already exists, which prevents the
> > script from creating it. You can delete it manually with
> > "ip netns del testing". If this netns is there because of a previous
> > incomplete run of l2_tos_ttl_inherit.sh, then you'll likely need to
> > also remove the tunnel interface it created in your current netns
> > ("ip link del tep0").
> 
> Thanks, it worked :)

Good to know.

> > Ideally this script wouldn't touch the current netns and would clean up
> > its environment in all cases upon exit. I have a patch almost ready
> > that does just that.
> 
> As these interfaces were not cleared by "make kselftest-clean",
> this patch with a cleanup trap would be most welcome.

Yes, I'll send a patch soon.

> However, after the cleanup above, the ./l2_tos_ttl_inherit.sh
> script hangs at the spot where it did in the first place (but
> only on Lenovo desktop 10TX000VCR with BIOS M22KT49A from
> 11/10/2022, AlmaLinux 8.7, and kernel 6.2-rc2; not on Lenovo
> Ideapad3 with Ubuntu 22.10, where it worked like a charm with
> the same kernel RC).
> 
> The point of hang is this:
> 
> [root@pc-mtodorov net]# ./l2_tos_ttl_inherit.sh
> ┌────────┬───────┬───────┬──────────────┬──────────────┬───────┬────────┐
> ├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
> │  Type  │ outer | inner │     tos      │      ttl     │  vlan │ result │
> ├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
> │    gre │     4 │     4 │ inherit 0xb8 │  inherit 102 │ false │     OK │
> │    gre │     4 │     4 │ inherit 0x10 │   inherit 53 │  true │     OK │
> │    gre │     4 │     4 │   fixed 0xa8 │    fixed 230 │ false │     OK │
> │    gre │     4 │     4 │   fixed 0x0c │     fixed 96 │  true │     OK │
> ├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
> │    gre │     4 │     6 │ inherit 0xbc │  inherit 159 │ false │     OK │
> │    gre │     4 │     6 │ inherit 0x5c │  inherit 242 │  true │     OK │
> │    gre │     4 │     6 │   fixed 0x38 │    fixed 113 │ false │     OK │
> │    gre │     4 │     6 │   fixed 0x78 │     fixed 34 │  true │     OK │
> ├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
> │    gre │     4 │ other │ inherit 0xec │   inherit 69 │ false │     OK │
> │    gre │     4 │ other │ inherit 0xf0 │  inherit 201 │  true │     OK │
> │    gre │     4 │ other │   fixed 0xec │     fixed 14 │ false │     OK │
> │    gre │     4 │ other │   fixed 0xe4 │     fixed 15 │  true │     OK │
> ├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
> │  Type  │ outer | inner │     tos      │      ttl     │  vlan │ result │
> ├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
> │    gre │     6 │     4 │ inherit 0xc4 │   inherit 21 │ false │     OK │
> │    gre │     6 │     4 │ inherit 0xc8 │  inherit 230 │  true │     OK │
> │    gre │     6 │     4 │   fixed 0x24 │    fixed 193 │ false │     OK │
> │    gre │     6 │     4 │   fixed 0x1c │    fixed 200 │  true │     OK │
> ├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
> │    gre │     6 │     6 │ inherit 0xe4 │   inherit 81 │ false │     OK │
> │    gre │     6 │     6 │ inherit 0xa4 │  inherit 130 │  true │     OK │
> │    gre │     6 │     6 │   fixed 0x18 │    fixed 140 │ false │     OK │
> │    gre │     6 │     6 │   fixed 0xc8 │    fixed 175 │  true │     OK │
> ├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
> │    gre │     6 │ other │ inherit 0x74 │  inherit 142 │ false │     OK │
> │    gre │     6 │ other │ inherit 0x50 │  inherit 125 │  true │     OK │
> │    gre │     6 │ other │   fixed 0x90 │     fixed 84 │ false │     OK │
> │    gre │     6 │ other │   fixed 0xb8 │    fixed 240 │  true │     OK │
> ├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
> │  Type  │ outer | inner │     tos      │      ttl     │  vlan │ result │
> ├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
> │  vxlan │     4 │     4 │ inherit 0xb4 │   inherit 93 │ false │
> 
> Developers usually ask for bash -x output of the script that failed or hung
> when reporting problems (too long for an email):
> 
> https://domac.alu.unizg.hr/~mtodorov/linux/selftests/net-namespace-20230106/bash-l2_tos_ttl_inherit.html

Tcpdump blocks until it captures an encapsulated ICMP Echo Request. But
it seems that it doesn't see any. When the script is hanging, what's the
result of "ip route get 198.19.0.2"?

The output of following commands might also help debugging the problem (run
them while the script is still hanging):
  ip link show
  ip address show
  ip route show
  tcpdump --immediate-mode -p -v -i veth0 -n # Kill it manually after a few seconds
  ping -c 3 198.19.0.2

Also, can you please try the below patch?

-------- >8 --------

Isolate testing environment and ensure everything is cleaned up on
exit.

diff --git a/tools/testing/selftests/net/l2_tos_ttl_inherit.sh b/tools/testing/selftests/net/l2_tos_ttl_inherit.sh
index dca1e6f777a8..f11756e7df2f 100755
--- a/tools/testing/selftests/net/l2_tos_ttl_inherit.sh
+++ b/tools/testing/selftests/net/l2_tos_ttl_inherit.sh
@@ -12,19 +12,27 @@
 # In addition this script also checks if forcing a specific field in the
 # outer header is working.
 
+# Return 4 by default (Kselftest SKIP code)
+ERR=4
+
 if [ "$(id -u)" != "0" ]; then
 	echo "Please run as root."
-	exit 0
+	exit $ERR
 fi
 if ! which tcpdump > /dev/null 2>&1; then
 	echo "No tcpdump found. Required for this test."
-	exit 0
+	exit $ERR
 fi
 
 expected_tos="0x00"
 expected_ttl="0"
 failed=false
 
+readonly NS0=$(mktemp -u ns0-XXXXXXXX)
+readonly NS1=$(mktemp -u ns1-XXXXXXXX)
+
+RUN_NS0="ip netns exec ${NS0}"
+
 get_random_tos() {
 	# Get a random hex tos value between 0x00 and 0xfc, a multiple of 4
 	echo "0x$(tr -dc '0-9a-f' < /dev/urandom | head -c 1)\
@@ -61,7 +69,6 @@ setup() {
 	local vlan="$5"
 	local test_tos="0x00"
 	local test_ttl="0"
-	local ns="ip netns exec testing"
 
 	# We don't want a test-tos of 0x00,
 	# because this is the value that we get when no tos is set.
@@ -94,14 +101,15 @@ setup() {
 	printf "│%7s │%6s │%6s │%13s │%13s │%6s │" \
 	"$type" "$outer" "$inner" "$tos" "$ttl" "$vlan"
 
-	# Create 'testing' netns, veth pair and connect main ns with testing ns
-	ip netns add testing
-	ip link add type veth
-	ip link set veth1 netns testing
-	ip link set veth0 up
-	$ns ip link set veth1 up
-	ip addr flush dev veth0
-	$ns ip addr flush dev veth1
+	# Create netns NS0 and NS1 and connect them with a veth pair
+	ip netns add "${NS0}"
+	ip netns add "${NS1}"
+	ip link add name veth0 netns "${NS0}" type veth \
+		peer name veth1 netns "${NS1}"
+	ip -netns "${NS0}" link set dev veth0 up
+	ip -netns "${NS1}" link set dev veth1 up
+	ip -netns "${NS0}" address flush dev veth0
+	ip -netns "${NS1}" address flush dev veth1
 
 	local local_addr1=""
 	local local_addr2=""
@@ -127,51 +135,59 @@ setup() {
 		if [ "$type" = "gre" ]; then
 			type="gretap"
 		fi
-		ip addr add 198.18.0.1/24 dev veth0
-		$ns ip addr add 198.18.0.2/24 dev veth1
-		ip link add name tep0 type $type $local_addr1 remote \
-		198.18.0.2 tos $test_tos ttl $test_ttl $vxlan $geneve
-		$ns ip link add name tep1 type $type $local_addr2 remote \
-		198.18.0.1 tos $test_tos ttl $test_ttl $vxlan $geneve
+		ip -netns "${NS0}" address add 198.18.0.1/24 dev veth0
+		ip -netns "${NS1}" address add 198.18.0.2/24 dev veth1
+		ip -netns "${NS0}" link add name tep0 type $type $local_addr1 \
+			remote 198.18.0.2 tos $test_tos ttl $test_ttl         \
+			$vxlan $geneve
+		ip -netns "${NS1}" link add name tep1 type $type $local_addr2 \
+			remote 198.18.0.1 tos $test_tos ttl $test_ttl         \
+			$vxlan $geneve
 	elif [ "$outer" = "6" ]; then
 		if [ "$type" = "gre" ]; then
 			type="ip6gretap"
 		fi
-		ip addr add fdd1:ced0:5d88:3fce::1/64 dev veth0
-		$ns ip addr add fdd1:ced0:5d88:3fce::2/64 dev veth1
-		ip link add name tep0 type $type $local_addr1 \
-		remote fdd1:ced0:5d88:3fce::2 tos $test_tos ttl $test_ttl \
-		$vxlan $geneve
-		$ns ip link add name tep1 type $type $local_addr2 \
-		remote fdd1:ced0:5d88:3fce::1 tos $test_tos ttl $test_ttl \
-		$vxlan $geneve
+		ip -netns "${NS0}" address add fdd1:ced0:5d88:3fce::1/64 \
+			dev veth0 nodad
+		ip -netns "${NS1}" address add fdd1:ced0:5d88:3fce::2/64 \
+			dev veth1 nodad
+		ip -netns "${NS0}" link add name tep0 type $type $local_addr1 \
+			remote fdd1:ced0:5d88:3fce::2 tos $test_tos           \
+			ttl $test_ttl $vxlan $geneve
+		ip -netns "${NS1}" link add name tep1 type $type $local_addr2 \
+			remote fdd1:ced0:5d88:3fce::1 tos $test_tos           \
+			ttl $test_ttl $vxlan $geneve
 	fi
 
 	# Bring L2-tunnel link up and create VLAN on top
-	ip link set tep0 up
-	$ns ip link set tep1 up
-	ip addr flush dev tep0
-	$ns ip addr flush dev tep1
+	ip -netns "${NS0}" link set tep0 up
+	ip -netns "${NS1}" link set tep1 up
+	ip -netns "${NS0}" address flush dev tep0
+	ip -netns "${NS1}" address flush dev tep1
 	local parent
 	if $vlan; then
 		parent="vlan99-"
-		ip link add link tep0 name ${parent}0 type vlan id 99
-		$ns ip link add link tep1 name ${parent}1 type vlan id 99
-		ip link set ${parent}0 up
-		$ns ip link set ${parent}1 up
-		ip addr flush dev ${parent}0
-		$ns ip addr flush dev ${parent}1
+		ip -netns "${NS0}" link add link tep0 name ${parent}0 \
+			type vlan id 99
+		ip -netns "${NS1}" link add link tep1 name ${parent}1 \
+			type vlan id 99
+		ip -netns "${NS0}" link set dev ${parent}0 up
+		ip -netns "${NS1}" link set dev ${parent}1 up
+		ip -netns "${NS0}" address flush dev ${parent}0
+		ip -netns "${NS1}" address flush dev ${parent}1
 	else
 		parent="tep"
 	fi
 
 	# Assign inner IPv4/IPv6 addresses
 	if [ "$inner" = "4" ] || [ "$inner" = "other" ]; then
-		ip addr add 198.19.0.1/24 brd + dev ${parent}0
-		$ns ip addr add 198.19.0.2/24 brd + dev ${parent}1
+		ip -netns "${NS0}" address add 198.19.0.1/24 brd + dev ${parent}0
+		ip -netns "${NS1}" address add 198.19.0.2/24 brd + dev ${parent}1
 	elif [ "$inner" = "6" ]; then
-		ip addr add fdd4:96cf:4eae:443b::1/64 dev ${parent}0
-		$ns ip addr add fdd4:96cf:4eae:443b::2/64 dev ${parent}1
+		ip -netns "${NS0}" address add fdd4:96cf:4eae:443b::1/64 \
+			dev ${parent}0 nodad
+		ip -netns "${NS1}" address add fdd4:96cf:4eae:443b::2/64 \
+			dev ${parent}1 nodad
 	fi
 }
 
@@ -192,10 +208,10 @@ verify() {
 		ping_dst="198.19.0.3" # Generates ARPs which are not IPv4/IPv6
 	fi
 	if [ "$tos_ttl" = "inherit" ]; then
-		ping -i 0.1 $ping_dst -Q "$expected_tos" -t "$expected_ttl" \
-		2>/dev/null 1>&2 & ping_pid="$!"
+		${RUN_NS0} ping -i 0.1 $ping_dst -Q "$expected_tos"          \
+			 -t "$expected_ttl" 2>/dev/null 1>&2 & ping_pid="$!"
 	else
-		ping -i 0.1 $ping_dst 2>/dev/null 1>&2 & ping_pid="$!"
+		${RUN_NS0} ping -i 0.1 $ping_dst 2>/dev/null 1>&2 & ping_pid="$!"
 	fi
 	local tunnel_type_offset tunnel_type_proto req_proto_offset req_offset
 	if [ "$type" = "gre" ]; then
@@ -216,10 +232,12 @@ verify() {
 				req_proto_offset="$((req_proto_offset + 4))"
 				req_offset="$((req_offset + 4))"
 			fi
-			out="$(tcpdump --immediate-mode -p -c 1 -v -i veth0 -n \
-			ip[$tunnel_type_offset] = $tunnel_type_proto and \
-			ip[$req_proto_offset] = 0x01 and \
-			ip[$req_offset] = 0x08 2>/dev/null | head -n 1)"
+			out="$(${RUN_NS0} tcpdump --immediate-mode -p -c 1 -v \
+				-i veth0 -n                                   \
+				ip[$tunnel_type_offset] = $tunnel_type_proto and \
+				ip[$req_proto_offset] = 0x01 and              \
+				ip[$req_offset] = 0x08 2>/dev/null            \
+				| head -n 1)"
 		elif [ "$inner" = "6" ]; then
 			req_proto_offset="44"
 			req_offset="78"
@@ -231,10 +249,12 @@ verify() {
 				req_proto_offset="$((req_proto_offset + 4))"
 				req_offset="$((req_offset + 4))"
 			fi
-			out="$(tcpdump --immediate-mode -p -c 1 -v -i veth0 -n \
-			ip[$tunnel_type_offset] = $tunnel_type_proto and \
-			ip[$req_proto_offset] = 0x3a and \
-			ip[$req_offset] = 0x80 2>/dev/null | head -n 1)"
+			out="$(${RUN_NS0} tcpdump --immediate-mode -p -c 1 -v \
+				-i veth0 -n                                   \
+				ip[$tunnel_type_offset] = $tunnel_type_proto and \
+				ip[$req_proto_offset] = 0x3a and              \
+				ip[$req_offset] = 0x80 2>/dev/null            \
+				| head -n 1)"
 		elif [ "$inner" = "other" ]; then
 			req_proto_offset="36"
 			req_offset="45"
@@ -250,11 +270,13 @@ verify() {
 				expected_tos="0x00"
 				expected_ttl="64"
 			fi
-			out="$(tcpdump --immediate-mode -p -c 1 -v -i veth0 -n \
-			ip[$tunnel_type_offset] = $tunnel_type_proto and \
-			ip[$req_proto_offset] = 0x08 and \
-			ip[$((req_proto_offset + 1))] = 0x06 and \
-			ip[$req_offset] = 0x01 2>/dev/null | head -n 1)"
+			out="$(${RUN_NS0} tcpdump --immediate-mode -p -c 1 -v \
+				-i veth0 -n                                   \
+				ip[$tunnel_type_offset] = $tunnel_type_proto and \
+				ip[$req_proto_offset] = 0x08 and              \
+				ip[$((req_proto_offset + 1))] = 0x06 and      \
+				ip[$req_offset] = 0x01 2>/dev/null            \
+				| head -n 1)"
 		fi
 	elif [ "$outer" = "6" ]; then
 		if [ "$type" = "gre" ]; then
@@ -273,10 +295,12 @@ verify() {
 				req_proto_offset="$((req_proto_offset + 4))"
 				req_offset="$((req_offset + 4))"
 			fi
-			out="$(tcpdump --immediate-mode -p -c 1 -v -i veth0 -n \
-			ip6[$tunnel_type_offset] = $tunnel_type_proto and \
-			ip6[$req_proto_offset] = 0x01 and \
-			ip6[$req_offset] = 0x08 2>/dev/null | head -n 1)"
+			out="$(${RUN_NS0} tcpdump --immediate-mode -p -c 1 -v \
+				-i veth0 -n                                   \
+				ip6[$tunnel_type_offset] = $tunnel_type_proto and \
+				ip6[$req_proto_offset] = 0x01 and             \
+				ip6[$req_offset] = 0x08 2>/dev/null           \
+				| head -n 1)"
 		elif [ "$inner" = "6" ]; then
 			local req_proto_offset="72"
 			local req_offset="106"
@@ -288,10 +312,12 @@ verify() {
 				req_proto_offset="$((req_proto_offset + 4))"
 				req_offset="$((req_offset + 4))"
 			fi
-			out="$(tcpdump --immediate-mode -p -c 1 -v -i veth0 -n \
-			ip6[$tunnel_type_offset] = $tunnel_type_proto and \
-			ip6[$req_proto_offset] = 0x3a and \
-			ip6[$req_offset] = 0x80 2>/dev/null | head -n 1)"
+			out="$(${RUN_NS0} tcpdump --immediate-mode -p -c 1 -v \
+				-i veth0 -n                                   \
+				ip6[$tunnel_type_offset] = $tunnel_type_proto and \
+				ip6[$req_proto_offset] = 0x3a and             \
+				ip6[$req_offset] = 0x80 2>/dev/null           \
+				| head -n 1)"
 		elif [ "$inner" = "other" ]; then
 			local req_proto_offset="64"
 			local req_offset="73"
@@ -307,15 +333,17 @@ verify() {
 				expected_tos="0x00"
 				expected_ttl="64"
 			fi
-			out="$(tcpdump --immediate-mode -p -c 1 -v -i veth0 -n \
-			ip6[$tunnel_type_offset] = $tunnel_type_proto and \
-			ip6[$req_proto_offset] = 0x08 and \
-			ip6[$((req_proto_offset + 1))] = 0x06 and \
-			ip6[$req_offset] = 0x01 2>/dev/null | head -n 1)"
+			out="$(${RUN_NS0} tcpdump --immediate-mode -p -c 1 -v \
+				-i veth0 -n                                   \
+				ip6[$tunnel_type_offset] = $tunnel_type_proto and \
+				ip6[$req_proto_offset] = 0x08 and             \
+				ip6[$((req_proto_offset + 1))] = 0x06 and     \
+				ip6[$req_offset] = 0x01 2>/dev/null           \
+				| head -n 1)"
 		fi
 	fi
 	kill -9 $ping_pid
-	wait $ping_pid 2>/dev/null
+	wait $ping_pid 2>/dev/null || true
 	result="FAIL"
 	if [ "$outer" = "4" ]; then
 		captured_ttl="$(get_field "ttl" "$out")"
@@ -351,11 +379,35 @@ verify() {
 }
 
 cleanup() {
-	ip link del veth0 2>/dev/null
-	ip netns del testing 2>/dev/null
-	ip link del tep0 2>/dev/null
+	ip netns del "${NS0}" 2>/dev/null
+	ip netns del "${NS1}" 2>/dev/null
 }
 
+exit_handler() {
+	# Don't exit immediately if one of the intermediate commands fails.
+	# We might be called at the end of the script, when the network
+	# namespaces have already been deleted. So cleanup() may fail, but we
+	# still need to run until 'exit $ERR' or the script won't return the
+	# correct error code.
+	set +e
+
+	cleanup
+
+	exit $ERR
+}
+
+# Restore the default SIGINT handler (just in case) and exit.
+# The exit handler will take care of cleaning everything up.
+interrupted() {
+	trap - INT
+
+	exit $ERR
+}
+
+set -e
+trap exit_handler EXIT
+trap interrupted INT
+
 printf "┌────────┬───────┬───────┬──────────────┬"
 printf "──────────────┬───────┬────────┐\n"
 for type in gre vxlan geneve; do
@@ -385,6 +437,10 @@ done
 printf "└────────┴───────┴───────┴──────────────┴"
 printf "──────────────┴───────┴────────┘\n"
 
+# All tests done.
+# Set ERR appropriately: it will be returned by the exit handler.
 if $failed; then
-	exit 1
+	ERR=1
+else
+	ERR=0
 fi


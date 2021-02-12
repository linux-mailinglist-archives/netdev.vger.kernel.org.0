Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5600631A501
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 20:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231981AbhBLTHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 14:07:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39820 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231956AbhBLTHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 14:07:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613156743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hsByYhjnXx0UaKhLH2z/9YaCsN4ZQ71XfwnAWpdS4dA=;
        b=DF64h78VtqkNqlklEytDKdMaBMPLKiCPdHZ29GCOZpK9hMurzGhqX0KarMM3VeNWeGtnWM
        FLzutSuR8Dy5jYF/196OAFexYpXSq+5sEDG6vNCnYpLDXfjqKMwj2kLyogw+uDlBhETnt1
        5+b10HxiX/tt/FR2gIy6HXJGBFH6WX4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-J4vAjVASM7q0i7VrDT0Wyg-1; Fri, 12 Feb 2021 14:05:41 -0500
X-MC-Unique: J4vAjVASM7q0i7VrDT0Wyg-1
Received: by mail-wr1-f71.google.com with SMTP id e11so795376wro.19
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 11:05:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hsByYhjnXx0UaKhLH2z/9YaCsN4ZQ71XfwnAWpdS4dA=;
        b=dBn2Hhv7IJQa/hy4bM38+M7K2SGfY2ZIJzwd9BsTbUrMKNqn2VDYrPf1GKPoZoOQ6C
         32RFqP0fmca1zq+bQ74NzKoDEG1kezI0QVv8Q4ZimZMVNOv2r/UYQ1wsqMwIlgbaDHh1
         txiGk+i8PyvC44SNDXt5NMyIBZGr2N88ps5GTt+t1R3ynOM+oAufgYCecnGiIQ1aXkzL
         buQa+bMrUpxUvFkIpa2Qq8RTpiuKtE3vQIYxuv6dMVOXaW7V9RErhpjCW8i4UMlKPd7m
         p8hPjmGfpNWPS6jVC1DmX2LXgHOCoYr6QlhYcrsNjT8sNRP+9Sx50nbaVvyOchwhD/6P
         ri9g==
X-Gm-Message-State: AOAM530vcsREKu1GuGU2V4oyt2srWYn7StGuK5aWJ8ncMpEM/gRVyb5f
        uyQSFXcooDngqNne5urp2FTPUoUEDGBMjbd/yKf14somelyXCcXjpEK6Oo3b/73c6zoFyy/LnpP
        URPgleQXU/HwzACMR
X-Received: by 2002:adf:e98d:: with SMTP id h13mr5276140wrm.246.1613156739557;
        Fri, 12 Feb 2021 11:05:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxtXnjD8Ji6xWfeoAqnB+ZwIR/4VTd0Q7P3dUF3sWD3n10ildjxjFZCllR7mC20cumfK35Cqg==
X-Received: by 2002:adf:e98d:: with SMTP id h13mr5276126wrm.246.1613156739401;
        Fri, 12 Feb 2021 11:05:39 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id s23sm15576125wmc.29.2021.02.12.11.05.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 11:05:38 -0800 (PST)
Date:   Fri, 12 Feb 2021 20:05:37 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 1/2] selftests: tc: Add basic mpls_* matching
 support for tc-flower
Message-ID: <44683bbe2ffbc8ec3288aa854eccdfa95d9d9149.1613155785.git.gnault@redhat.com>
References: <cover.1613155785.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1613155785.git.gnault@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tests in tc_flower.sh for mpls_label, mpls_tc, mpls_bos and
mpls_ttl. For each keyword, test the minimal and maximal values.

Selectively skip these new mpls tests for tc versions that don't
support them.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 tools/testing/selftests/net/forwarding/config |   1 +
 tools/testing/selftests/net/forwarding/lib.sh |  15 ++
 .../selftests/net/forwarding/tc_flower.sh     | 172 +++++++++++++++++-
 3 files changed, 187 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/config b/tools/testing/selftests/net/forwarding/config
index 10e9a3321ae1..a4bd1b087303 100644
--- a/tools/testing/selftests/net/forwarding/config
+++ b/tools/testing/selftests/net/forwarding/config
@@ -10,6 +10,7 @@ CONFIG_NET_ACT_MIRRED=m
 CONFIG_NET_ACT_MPLS=m
 CONFIG_NET_ACT_VLAN=m
 CONFIG_NET_CLS_FLOWER=m
+CONFIG_NET_CLS_MATCHALL=m
 CONFIG_NET_SCH_INGRESS=m
 CONFIG_NET_ACT_GACT=m
 CONFIG_VETH=m
diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 40b3a86a62cf..043a417651f2 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -42,6 +42,21 @@ check_tc_version()
 	fi
 }
 
+# Old versions of tc don't understand "mpls_uc"
+check_tc_mpls_support()
+{
+	local dev=$1; shift
+
+	tc filter add dev $dev ingress protocol mpls_uc pref 1 handle 1 \
+		matchall action pipe &> /dev/null
+	if [[ $? -ne 0 ]]; then
+		echo "SKIP: iproute2 too old; tc is missing MPLS support"
+		return 1
+	fi
+	tc filter del dev $dev ingress protocol mpls_uc pref 1 handle 1 \
+		matchall
+}
+
 check_tc_shblock_support()
 {
 	tc filter help 2>&1 | grep block &> /dev/null
diff --git a/tools/testing/selftests/net/forwarding/tc_flower.sh b/tools/testing/selftests/net/forwarding/tc_flower.sh
index 058c746ee300..7833e770c6ed 100755
--- a/tools/testing/selftests/net/forwarding/tc_flower.sh
+++ b/tools/testing/selftests/net/forwarding/tc_flower.sh
@@ -3,7 +3,8 @@
 
 ALL_TESTS="match_dst_mac_test match_src_mac_test match_dst_ip_test \
 	match_src_ip_test match_ip_flags_test match_pcp_test match_vlan_test \
-	match_ip_tos_test match_indev_test"
+	match_ip_tos_test match_indev_test match_mpls_label_test \
+	match_mpls_tc_test match_mpls_bos_test match_mpls_ttl_test"
 NUM_NETIFS=2
 source tc_common.sh
 source lib.sh
@@ -334,6 +335,175 @@ match_indev_test()
 	log_test "indev match ($tcflags)"
 }
 
+# Unfortunately, mausezahn can't build MPLS headers when used in L2
+# mode, so we have this function to build Label Stack Entries.
+mpls_lse()
+{
+	local label=$1
+	local tc=$2
+	local bos=$3
+	local ttl=$4
+
+	printf "%02x %02x %02x %02x"                        \
+		$((label >> 12))                            \
+		$((label >> 4 & 0xff))                      \
+		$((((label & 0xf) << 4) + (tc << 1) + bos)) \
+		$ttl
+}
+
+match_mpls_label_test()
+{
+	local ethtype="88 47"; readonly ethtype
+	local pkt
+
+	RET=0
+
+	check_tc_mpls_support $h2 || return 0
+
+	tc filter add dev $h2 ingress protocol mpls_uc pref 1 handle 101 \
+		flower $tcflags mpls_label 0 action drop
+	tc filter add dev $h2 ingress protocol mpls_uc pref 2 handle 102 \
+		flower $tcflags mpls_label 1048575 action drop
+
+	pkt="$ethtype $(mpls_lse 1048575 0 1 255)"
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
+
+	tc_check_packets "dev $h2 ingress" 101 1
+	check_fail $? "Matched on a wrong filter (1048575)"
+
+	tc_check_packets "dev $h2 ingress" 102 1
+	check_err $? "Did not match on correct filter (1048575)"
+
+	pkt="$ethtype $(mpls_lse 0 0 1 255)"
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
+
+	tc_check_packets "dev $h2 ingress" 102 2
+	check_fail $? "Matched on a wrong filter (0)"
+
+	tc_check_packets "dev $h2 ingress" 101 1
+	check_err $? "Did not match on correct filter (0)"
+
+	tc filter del dev $h2 ingress protocol mpls_uc pref 2 handle 102 flower
+	tc filter del dev $h2 ingress protocol mpls_uc pref 1 handle 101 flower
+
+	log_test "mpls_label match ($tcflags)"
+}
+
+match_mpls_tc_test()
+{
+	local ethtype="88 47"; readonly ethtype
+	local pkt
+
+	RET=0
+
+	check_tc_mpls_support $h2 || return 0
+
+	tc filter add dev $h2 ingress protocol mpls_uc pref 1 handle 101 \
+		flower $tcflags mpls_tc 0 action drop
+	tc filter add dev $h2 ingress protocol mpls_uc pref 2 handle 102 \
+		flower $tcflags mpls_tc 7 action drop
+
+	pkt="$ethtype $(mpls_lse 0 7 1 255)"
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
+
+	tc_check_packets "dev $h2 ingress" 101 1
+	check_fail $? "Matched on a wrong filter (7)"
+
+	tc_check_packets "dev $h2 ingress" 102 1
+	check_err $? "Did not match on correct filter (7)"
+
+	pkt="$ethtype $(mpls_lse 0 0 1 255)"
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
+
+	tc_check_packets "dev $h2 ingress" 102 2
+	check_fail $? "Matched on a wrong filter (0)"
+
+	tc_check_packets "dev $h2 ingress" 101 1
+	check_err $? "Did not match on correct filter (0)"
+
+	tc filter del dev $h2 ingress protocol mpls_uc pref 2 handle 102 flower
+	tc filter del dev $h2 ingress protocol mpls_uc pref 1 handle 101 flower
+
+	log_test "mpls_tc match ($tcflags)"
+}
+
+match_mpls_bos_test()
+{
+	local ethtype="88 47"; readonly ethtype
+	local pkt
+
+	RET=0
+
+	check_tc_mpls_support $h2 || return 0
+
+	tc filter add dev $h2 ingress protocol mpls_uc pref 1 handle 101 \
+		flower $tcflags mpls_bos 0 action drop
+	tc filter add dev $h2 ingress protocol mpls_uc pref 2 handle 102 \
+		flower $tcflags mpls_bos 1 action drop
+
+	pkt="$ethtype $(mpls_lse 0 0 1 255)"
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
+
+	tc_check_packets "dev $h2 ingress" 101 1
+	check_fail $? "Matched on a wrong filter (1)"
+
+	tc_check_packets "dev $h2 ingress" 102 1
+	check_err $? "Did not match on correct filter (1)"
+
+	# Need to add a second label to properly mark the Bottom of Stack
+	pkt="$ethtype $(mpls_lse 0 0 0 255) $(mpls_lse 0 0 1 255)"
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
+
+	tc_check_packets "dev $h2 ingress" 102 2
+	check_fail $? "Matched on a wrong filter (0)"
+
+	tc_check_packets "dev $h2 ingress" 101 1
+	check_err $? "Did not match on correct filter (0)"
+
+	tc filter del dev $h2 ingress protocol mpls_uc pref 2 handle 102 flower
+	tc filter del dev $h2 ingress protocol mpls_uc pref 1 handle 101 flower
+
+	log_test "mpls_bos match ($tcflags)"
+}
+
+match_mpls_ttl_test()
+{
+	local ethtype="88 47"; readonly ethtype
+	local pkt
+
+	RET=0
+
+	check_tc_mpls_support $h2 || return 0
+
+	tc filter add dev $h2 ingress protocol mpls_uc pref 1 handle 101 \
+		flower $tcflags mpls_ttl 0 action drop
+	tc filter add dev $h2 ingress protocol mpls_uc pref 2 handle 102 \
+		flower $tcflags mpls_ttl 255 action drop
+
+	pkt="$ethtype $(mpls_lse 0 0 1 255)"
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
+
+	tc_check_packets "dev $h2 ingress" 101 1
+	check_fail $? "Matched on a wrong filter (255)"
+
+	tc_check_packets "dev $h2 ingress" 102 1
+	check_err $? "Did not match on correct filter (255)"
+
+	pkt="$ethtype $(mpls_lse 0 0 1 0)"
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
+
+	tc_check_packets "dev $h2 ingress" 102 2
+	check_fail $? "Matched on a wrong filter (0)"
+
+	tc_check_packets "dev $h2 ingress" 101 1
+	check_err $? "Did not match on correct filter (0)"
+
+	tc filter del dev $h2 ingress protocol mpls_uc pref 2 handle 102 flower
+	tc filter del dev $h2 ingress protocol mpls_uc pref 1 handle 101 flower
+
+	log_test "mpls_ttl match ($tcflags)"
+}
+
 setup_prepare()
 {
 	h1=${NETIFS[p1]}
-- 
2.21.3


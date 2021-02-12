Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C71DC31A502
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 20:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbhBLTHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 14:07:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34939 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229451AbhBLTHQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 14:07:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613156748;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dmEDOOj/q/5Q0rPAOyQL+goFQUpKReKeqZSn/wNtP80=;
        b=eRx0IjXFxVq8Bc1hPeuyHZKwxDJmW/4PiJiKW6jkOo1r9n//PCh1149dX4xMNToCfWvwqK
        k1KORPEorhT/H23rAfqrKq46HYI0YdhxUH8HUGiEXCso0L0fTYnxTNOc3abnfnW/bF1j8B
        8sa4ILeB2TVmHR/DOI6qQnOEqScuL80=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-540-baNWuUiGOdKX9uCZ2GDQDQ-1; Fri, 12 Feb 2021 14:05:47 -0500
X-MC-Unique: baNWuUiGOdKX9uCZ2GDQDQ-1
Received: by mail-wr1-f72.google.com with SMTP id o16so908517wrn.1
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 11:05:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dmEDOOj/q/5Q0rPAOyQL+goFQUpKReKeqZSn/wNtP80=;
        b=bVNBCh6LdZvB3Sq7rEKQBzhBEIGLtI8LTD3YUEyx/9IXIlCC3WpT0SOv5aprlt39Zv
         NdZ0vYnguNi5a6C0DGJngUotTUT6ho8xSDLvAjPcQAeQ6n8KfChB7QO1hn18dfEQpAjj
         SY4ePgJVv1Zp1ZJxFS1QFvGQT/QUBw4HN79lRkG78d3ES6UwBgE368KcgG4jYv/kgehU
         xfHR7GpJCgtUpClSoy1wuXz6ApPglZCX8BMsI1NkhP9fLV0Kym1k60JThShxbP6miwy4
         kJaY3NHIlRz6m4Qh+cGI2py6vi3rrvwC5agaTZBEfEA0955I7DdI1FnrcUP3HI4aYaeD
         RJ1A==
X-Gm-Message-State: AOAM531UnSTCe49u1d2JJyjNzBzX0z5O+EVHS/oF6CPeGfKBnOO39DSo
        6p4pFfPtybhOmEmRPl5Ta/lEgHuZ7y8stVYOGmqq0jYHBkC41nyc2CFppDVAJjnTCH6iCpHoVYT
        BFdDJzjmSk0UlUwDs
X-Received: by 2002:a1c:4d03:: with SMTP id o3mr4120827wmh.136.1613156745826;
        Fri, 12 Feb 2021 11:05:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxEcvrkfDjP22xYDCX/mVl3Yql+GoerQawGS7Ke+D2V+zCY8oVjcTcxiEDjVkxxuWTiDla+tQ==
X-Received: by 2002:a1c:4d03:: with SMTP id o3mr4120818wmh.136.1613156745617;
        Fri, 12 Feb 2021 11:05:45 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id d5sm3065393wrp.39.2021.02.12.11.05.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 11:05:45 -0800 (PST)
Date:   Fri, 12 Feb 2021 20:05:43 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 2/2] selftests: tc: Add generic mpls matching
 support for tc-flower
Message-ID: <cb98f1fec4ad8f2d4711e06e8a45436a190d6c23.1613155785.git.gnault@redhat.com>
References: <cover.1613155785.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1613155785.git.gnault@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tests in tc_flower.sh for generic matching on MPLS Label Stack
Entries. The label, tc, bos and ttl fields are tested for the first
and second labels. For each field, the minimal and maximal values are
tested (the former at depth 1 and the later at depth 2).
There are also tests for matching the presence of a label stack entry
at a given depth.

In order to reduce the amount of code, all "lse" subcommands are tested
in match_mpls_lse_test(). Action "continue" is used, so that test
packets are evaluated by all filters. Then, we can verify if each
filter matched the expected number of packets.

Some versions of tc-flower produced invalid json output when dumping
MPLS filters with depth > 1. Skip the test if tc isn't recent enough.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 tools/testing/selftests/net/forwarding/lib.sh |  26 ++++
 .../selftests/net/forwarding/tc_flower.sh     | 137 +++++++++++++++++-
 2 files changed, 162 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 043a417651f2..be71012b8fc5 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -57,6 +57,32 @@ check_tc_mpls_support()
 		matchall
 }
 
+# Old versions of tc produce invalid json output for mpls lse statistics
+check_tc_mpls_lse_stats()
+{
+	local dev=$1; shift
+	local ret;
+
+	tc filter add dev $dev ingress protocol mpls_uc pref 1 handle 1 \
+		flower mpls lse depth 2                                 \
+		action continue &> /dev/null
+
+	if [[ $? -ne 0 ]]; then
+		echo "SKIP: iproute2 too old; tc-flower is missing extended MPLS support"
+		return 1
+	fi
+
+	tc -j filter show dev $dev ingress protocol mpls_uc | jq . &> /dev/null
+	ret=$?
+	tc filter del dev $dev ingress protocol mpls_uc pref 1 handle 1 \
+		flower
+
+	if [[ $ret -ne 0 ]]; then
+		echo "SKIP: iproute2 too old; tc-flower produces invalid json output for extended MPLS filters"
+		return 1
+	fi
+}
+
 check_tc_shblock_support()
 {
 	tc filter help 2>&1 | grep block &> /dev/null
diff --git a/tools/testing/selftests/net/forwarding/tc_flower.sh b/tools/testing/selftests/net/forwarding/tc_flower.sh
index 7833e770c6ed..a554838666c4 100755
--- a/tools/testing/selftests/net/forwarding/tc_flower.sh
+++ b/tools/testing/selftests/net/forwarding/tc_flower.sh
@@ -4,7 +4,8 @@
 ALL_TESTS="match_dst_mac_test match_src_mac_test match_dst_ip_test \
 	match_src_ip_test match_ip_flags_test match_pcp_test match_vlan_test \
 	match_ip_tos_test match_indev_test match_mpls_label_test \
-	match_mpls_tc_test match_mpls_bos_test match_mpls_ttl_test"
+	match_mpls_tc_test match_mpls_bos_test match_mpls_ttl_test \
+	match_mpls_lse_test"
 NUM_NETIFS=2
 source tc_common.sh
 source lib.sh
@@ -504,6 +505,140 @@ match_mpls_ttl_test()
 	log_test "mpls_ttl match ($tcflags)"
 }
 
+match_mpls_lse_test()
+{
+	local ethtype="88 47"; readonly ethtype
+	local pkt
+
+	RET=0
+
+	check_tc_mpls_lse_stats $h2 || return 0
+
+	# Match on first LSE (minimal values for each field)
+	tc filter add dev $h2 ingress protocol mpls_uc pref 1 handle 101 \
+		flower $tcflags mpls lse depth 1 label 0 action continue
+	tc filter add dev $h2 ingress protocol mpls_uc pref 2 handle 102 \
+		flower $tcflags mpls lse depth 1 tc 0 action continue
+	tc filter add dev $h2 ingress protocol mpls_uc pref 3 handle 103 \
+		flower $tcflags mpls lse depth 1 bos 0 action continue
+	tc filter add dev $h2 ingress protocol mpls_uc pref 4 handle 104 \
+		flower $tcflags mpls lse depth 1 ttl 0 action continue
+
+	# Match on second LSE (maximal values for each field)
+	tc filter add dev $h2 ingress protocol mpls_uc pref 5 handle 105 \
+		flower $tcflags mpls lse depth 2 label 1048575 action continue
+	tc filter add dev $h2 ingress protocol mpls_uc pref 6 handle 106 \
+		flower $tcflags mpls lse depth 2 tc 7 action continue
+	tc filter add dev $h2 ingress protocol mpls_uc pref 7 handle 107 \
+		flower $tcflags mpls lse depth 2 bos 1 action continue
+	tc filter add dev $h2 ingress protocol mpls_uc pref 8 handle 108 \
+		flower $tcflags mpls lse depth 2 ttl 255 action continue
+
+	# Match on LSE depth
+	tc filter add dev $h2 ingress protocol mpls_uc pref 9 handle 109 \
+		flower $tcflags mpls lse depth 1 action continue
+	tc filter add dev $h2 ingress protocol mpls_uc pref 10 handle 110 \
+		flower $tcflags mpls lse depth 2 action continue
+	tc filter add dev $h2 ingress protocol mpls_uc pref 11 handle 111 \
+		flower $tcflags mpls lse depth 3 action continue
+
+	# Base packet, matched by all filters (except for stack depth 3)
+	pkt="$ethtype $(mpls_lse 0 0 0 0) $(mpls_lse 1048575 7 1 255)"
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
+
+	# Make a variant of the above packet, with a non-matching value
+	# for each LSE field
+
+	# Wrong label at depth 1
+	pkt="$ethtype $(mpls_lse 1 0 0 0) $(mpls_lse 1048575 7 1 255)"
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
+
+	# Wrong TC at depth 1
+	pkt="$ethtype $(mpls_lse 0 1 0 0) $(mpls_lse 1048575 7 1 255)"
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
+
+	# Wrong BOS at depth 1 (not adding a second LSE here since BOS is set
+	# in the first label, so anything that'd follow wouldn't be considered)
+	pkt="$ethtype $(mpls_lse 0 0 1 0)"
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
+
+	# Wrong TTL at depth 1
+	pkt="$ethtype $(mpls_lse 0 0 0 1) $(mpls_lse 1048575 7 1 255)"
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
+
+	# Wrong label at depth 2
+	pkt="$ethtype $(mpls_lse 0 0 0 0) $(mpls_lse 1048574 7 1 255)"
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
+
+	# Wrong TC at depth 2
+	pkt="$ethtype $(mpls_lse 0 0 0 0) $(mpls_lse 1048575 6 1 255)"
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
+
+	# Wrong BOS at depth 2 (adding a third LSE here since BOS isn't set in
+	# the second label)
+	pkt="$ethtype $(mpls_lse 0 0 0 0) $(mpls_lse 1048575 7 0 255)"
+	pkt="$pkt $(mpls_lse 0 0 1 255)"
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
+
+	# Wrong TTL at depth 2
+	pkt="$ethtype $(mpls_lse 0 0 0 0) $(mpls_lse 1048575 7 1 254)"
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac "$pkt" -q
+
+	# Filters working at depth 1 should match all packets but one
+
+	tc_check_packets "dev $h2 ingress" 101 8
+	check_err $? "Did not match on correct filter"
+
+	tc_check_packets "dev $h2 ingress" 102 8
+	check_err $? "Did not match on correct filter"
+
+	tc_check_packets "dev $h2 ingress" 103 8
+	check_err $? "Did not match on correct filter"
+
+	tc_check_packets "dev $h2 ingress" 104 8
+	check_err $? "Did not match on correct filter"
+
+	# Filters working at depth 2 should match all packets but two (because
+	# of the test packet where the label stack depth is just one)
+
+	tc_check_packets "dev $h2 ingress" 105 7
+	check_err $? "Did not match on correct filter"
+
+	tc_check_packets "dev $h2 ingress" 106 7
+	check_err $? "Did not match on correct filter"
+
+	tc_check_packets "dev $h2 ingress" 107 7
+	check_err $? "Did not match on correct filter"
+
+	tc_check_packets "dev $h2 ingress" 108 7
+	check_err $? "Did not match on correct filter"
+
+	# Finally, verify the filters that only match on LSE depth
+
+	tc_check_packets "dev $h2 ingress" 109 9
+	check_err $? "Did not match on correct filter"
+
+	tc_check_packets "dev $h2 ingress" 110 8
+	check_err $? "Did not match on correct filter"
+
+	tc_check_packets "dev $h2 ingress" 111 1
+	check_err $? "Did not match on correct filter"
+
+	tc filter del dev $h2 ingress protocol mpls_uc pref 11 handle 111 flower
+	tc filter del dev $h2 ingress protocol mpls_uc pref 10 handle 110 flower
+	tc filter del dev $h2 ingress protocol mpls_uc pref 9 handle 109 flower
+	tc filter del dev $h2 ingress protocol mpls_uc pref 8 handle 108 flower
+	tc filter del dev $h2 ingress protocol mpls_uc pref 7 handle 107 flower
+	tc filter del dev $h2 ingress protocol mpls_uc pref 6 handle 106 flower
+	tc filter del dev $h2 ingress protocol mpls_uc pref 5 handle 105 flower
+	tc filter del dev $h2 ingress protocol mpls_uc pref 4 handle 104 flower
+	tc filter del dev $h2 ingress protocol mpls_uc pref 3 handle 103 flower
+	tc filter del dev $h2 ingress protocol mpls_uc pref 2 handle 102 flower
+	tc filter del dev $h2 ingress protocol mpls_uc pref 1 handle 101 flower
+
+	log_test "mpls lse match ($tcflags)"
+}
+
 setup_prepare()
 {
 	h1=${NETIFS[p1]}
-- 
2.21.3


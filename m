Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 617A942EA13
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 09:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236126AbhJOH3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 03:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236050AbhJOH3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 03:29:03 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E2B7C061760;
        Fri, 15 Oct 2021 00:26:57 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id y30so17315035edi.0;
        Fri, 15 Oct 2021 00:26:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AX2BpCwAHsJ9vAVMGMg+034+7Y/IY2VhzAS++Px6BtQ=;
        b=Gl6loNmsS/lpioR+G0SjkAxS4RdAdyW3fzUgX3JY7yXFMfJ6EnQsDW4M+vSGk/F/V2
         JvHqTR4LP/hzaWfq8ImEKbWJJAG/EpIkZoOthUG+eIq6B6jXWaomiZsb2hII7oWEx9yu
         Au6kLkTAvNpPhnFmL93z+F83nbQpWq3q6m6HM4en+xW3wr+TFnSvbFaVh+sbgjIO9ZUS
         vHboQ6fBEp58dxiQEKuVykzUypOkcgtZtT9K4cz9mzPl3E0Dk08eSI1OLrSIL2Il7y62
         SzZc0rAxdOL0+pzsnPVePqXnQQKBJN9zbtXSWxF/Ozmc2DPvf/xnjf6QTtMYGlDj4rUt
         EZDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AX2BpCwAHsJ9vAVMGMg+034+7Y/IY2VhzAS++Px6BtQ=;
        b=FAr6gwSW8iUN6+lgT0AhaVXFpvX0r6dTaVI86d8QMod6DXW94QYDA1QsB9iBblDobo
         XZViASqYgUOgMnNiQoK7CYoin94Yca/8VljJejNmMmFGsxu7E49ZOJb6dg1fWv/gw8Z4
         +X/GM8BTJibBU50fTm8Gwv0HcCjQgyacnsbXsXT7NGWo5UbwahgRy8glOiDhvtTS4rvu
         4EDwWkjiBpW7Vr1ybAXdSMBtytWv/LILUCay5LX5aCRcUzk6h5yoMZs1snVjmCWvwKDz
         0QydoSC9fr/R4d9aokn8VaO2j06Yh7fqWyJqqJCqlOQbyJ+Thu6S6BIAtYDlkxmvvuNc
         eEhg==
X-Gm-Message-State: AOAM532JNyQFEmRrkhhUZ4Z6o55wMZ+6Tol1Py5VXA1YzYBAhkJnJFHg
        svs8j1fzpNwZJcMZBokR7pg=
X-Google-Smtp-Source: ABdhPJwh4HvHQcedjSGAlTEY+pXeFSAT3UYiM/HjyPORXRzWpcbgwIJ8nm8uj/2+P618AoXTaGjfpw==
X-Received: by 2002:aa7:ca0d:: with SMTP id y13mr15325489eds.335.1634282815944;
        Fri, 15 Oct 2021 00:26:55 -0700 (PDT)
Received: from ponky.lan ([2a04:241e:501:3870:bac1:743:3859:80df])
        by smtp.gmail.com with ESMTPSA id l25sm3873107edc.31.2021.10.15.00.26.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 00:26:55 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Yonghong Song <yhs@fb.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/4] selftests: net/fcnal: Test --{force,no}-bind-key-ifindex
Date:   Fri, 15 Oct 2021 10:26:07 +0300
Message-Id: <9b00cba5116604773554db98405691076c66b71a.1634282515.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1634282515.git.cdleonard@gmail.com>
References: <cover.1634282515.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test that applications binding listening sockets to VRFs without
specifying TCP_MD5SIG_FLAG_IFINDEX will work as expected. This would
be broken if __tcp_md5_do_lookup always made a strict comparison on
l3index. See this email:

https://lore.kernel.org/netdev/209548b5-27d2-2059-f2e9-2148f5a0291b@gmail.com/

Applications using tcp_l3mdev_accept=1 and a single global socket (not
bound to any interface) also should have a way to specify keys that are
only for the default VRF, this is done by --force-bind-key-ifindex
without otherwise binding to a device.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
---
 tools/testing/selftests/net/fcnal-test.sh | 60 +++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 13350cd5c8ac..8e67a252b672 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -287,10 +287,16 @@ set_sysctl()
 	echo "SYSCTL: $*"
 	echo
 	run_cmd sysctl -q -w $*
 }
 
+# get sysctl values in NS-A
+get_sysctl()
+{
+	${NSA_CMD} sysctl -n $*
+}
+
 ################################################################################
 # Setup for tests
 
 addr2str()
 {
@@ -1001,10 +1007,64 @@ ipv4_tcp_md5()
 
 	log_start
 	run_cmd nettest -s -I ${NSA_DEV} -M ${MD5_PW} -m ${NS_NET}
 	log_test $? 1 "MD5: VRF: Device must be a VRF - prefix"
 
+	test_ipv4_md5_vrf__vrf_server__no_bind_ifindex
+	test_ipv4_md5_vrf__global_server__bind_ifindex0
+}
+
+test_ipv4_md5_vrf__vrf_server__no_bind_ifindex()
+{
+	log_start
+	show_hint "Simulates applications using VRF without TCP_MD5SIG_FLAG_IFINDEX"
+	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET} --no-bind-key-ifindex &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_PW}
+	log_test $? 0 "MD5: VRF: VRF-bound server, unbound key accepts connection"
+
+	log_start
+	show_hint "Binding both the socket and the key is not required but it works"
+	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET} --force-bind-key-ifindex &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_PW}
+	log_test $? 0 "MD5: VRF: VRF-bound server, bound key accepts connection"
+}
+
+test_ipv4_md5_vrf__global_server__bind_ifindex0()
+{
+	# This particular test needs tcp_l3mdev_accept=1 for Global server to accept VRF connections
+	local old_tcp_l3mdev_accept
+	old_tcp_l3mdev_accept=$(get_sysctl net.ipv4.tcp_l3mdev_accept)
+	set_sysctl net.ipv4.tcp_l3mdev_accept=1
+
+	log_start
+	run_cmd nettest -s -M ${MD5_PW} -m ${NS_NET} --force-bind-key-ifindex &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_PW}
+	log_test $? 2 "MD5: VRF: Global server, Key bound to ifindex=0 rejects VRF connection"
+
+	log_start
+	run_cmd nettest -s -M ${MD5_PW} -m ${NS_NET} --force-bind-key-ifindex &
+	sleep 1
+	run_cmd_nsc nettest -r ${NSA_IP} -X ${MD5_PW}
+	log_test $? 0 "MD5: VRF: Global server, key bound to ifindex=0 accepts non-VRF connection"
+	log_start
+
+	run_cmd nettest -s -M ${MD5_PW} -m ${NS_NET} --no-bind-key-ifindex &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_PW}
+	log_test $? 0 "MD5: VRF: Global server, key not bound to ifindex accepts VRF connection"
+
+	log_start
+	run_cmd nettest -s -M ${MD5_PW} -m ${NS_NET} --no-bind-key-ifindex &
+	sleep 1
+	run_cmd_nsc nettest -r ${NSA_IP} -X ${MD5_PW}
+	log_test $? 0 "MD5: VRF: Global server, key not bound to ifindex accepts non-VRF connection"
+
+	# restore value
+	set_sysctl net.ipv4.tcp_l3mdev_accept="$old_tcp_l3mdev_accept"
 }
 
 ipv4_tcp_novrf()
 {
 	local a
-- 
2.25.1


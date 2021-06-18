Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C141D3AC96A
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 13:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233957AbhFRLG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 07:06:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42657 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233006AbhFRLGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 07:06:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624014282;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0JdavfqLFco3B5XZUP7kTR8q2t6Rf/JfUmb//Btv9sk=;
        b=GUkYwez6ZEAUrrQ/2jnCtUaTtaL8sByBjmnoR18MV+ZlxBogaT8SbfDzmYzUVZQAlpBu4Q
        d9eBIap0kb/fmRO+DW0U0RmxnEnkzg2+FC+XPzYr75uBdt8g1DHXWBrDxZfOIM8URwHErV
        z9nJWT5F7pmIXNIZKtoCfICACuXjgEY=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-5J7NKTdcPDO1ULZoZxwgcA-1; Fri, 18 Jun 2021 07:04:41 -0400
X-MC-Unique: 5J7NKTdcPDO1ULZoZxwgcA-1
Received: by mail-ed1-f72.google.com with SMTP id p24-20020aa7c8980000b0290393c37fdcb8so3333385eds.6
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 04:04:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0JdavfqLFco3B5XZUP7kTR8q2t6Rf/JfUmb//Btv9sk=;
        b=Ri+zu8NVIVZ7neGZ01kWHDlSRPYpvZnM+KkQId8PszKEDgKbdxnUGcTRbQClw+GNwf
         Ha6GJCrDsyFPJ4k1zCW+0IIlzTBwQzdhvA4j0Y1HQ0f4v8LmMDfsja7QCuzOvXyETr9/
         wUBefftmxkiQXOtluU8x9HHy2HIwZMWEGg7By2rQDVHbkcUaNWWgKKWKQ0+LVwswO93C
         SlixvT3soCfjMEiBSMFsDOC+5CLWze8394ImpZHdtnfgCHIV4NNATFy9n1sRemJaOi5j
         o/lfLpuwXknvM5DOtwzl2AhgkM7WC/9nwd6jzjIel5zS2KPDHmIqCdv4fJvSqYZVt18L
         xnag==
X-Gm-Message-State: AOAM5320YVE5sHACy+jltxu7rmsjIkoeiyhjtG/CldSWcw5pylLFL2pU
        qhvUGAIlffexlVjXNfr7ZJAA85oiPZzckIw8swRGjFGrt4A2gdYTvvEWCjNP1Rsl4kVzZsYDmHc
        7nrjmnPA7m/g/QL2L
X-Received: by 2002:a17:906:6d43:: with SMTP id a3mr10564363ejt.142.1624014279859;
        Fri, 18 Jun 2021 04:04:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxnmvcfkf++Dy3zOhLghRrJ4EKnv1Z/2ScWPglJKxnI9VTBzwGZ4TDpflF4qcwnex4hUscoOg==
X-Received: by 2002:a17:906:6d43:: with SMTP id a3mr10564342ejt.142.1624014279688;
        Fri, 18 Jun 2021 04:04:39 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id de10sm904118ejc.65.2021.06.18.04.04.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 04:04:38 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 012F718071D; Fri, 18 Jun 2021 13:04:37 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        Juliusz Chroboczek <jch@irif.fr>
Subject: [PATCH net v2 2/2] selftests/net: Add icmp.sh for testing ICMP dummy address responses
Date:   Fri, 18 Jun 2021 13:04:36 +0200
Message-Id: <20210618110436.91700-2-toke@redhat.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210618110436.91700-1-toke@redhat.com>
References: <20210618110436.91700-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds a new icmp.sh selftest for testing that the kernel will respond
correctly with an ICMP unreachable message with the dummy (192.0.0.8)
source address when there are no IPv4 addresses configured to use as source
addresses.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/testing/selftests/net/icmp.sh | 74 +++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)
 create mode 100755 tools/testing/selftests/net/icmp.sh

diff --git a/tools/testing/selftests/net/icmp.sh b/tools/testing/selftests/net/icmp.sh
new file mode 100755
index 000000000000..e4b04cd1644a
--- /dev/null
+++ b/tools/testing/selftests/net/icmp.sh
@@ -0,0 +1,74 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# Test for checking ICMP response with dummy address instead of 0.0.0.0.
+# Sets up two namespaces like:
+# +----------------------+                          +--------------------+
+# | ns1                  |    v4-via-v6 routes:     | ns2                |
+# |                      |                  '       |                    |
+# |             +--------+   -> 172.16.1.0/24 ->    +--------+           |
+# |             | veth0  +--------------------------+  veth0 |           |
+# |             +--------+   <- 172.16.0.0/24 <-    +--------+           |
+# |           172.16.0.1 |                          | 2001:db8:1::2/64   |
+# |     2001:db8:1::2/64 |                          |                    |
+# +----------------------+                          +--------------------+
+#
+# And then tries to ping 172.16.1.1 from ns1. This results in a "net
+# unreachable" message being sent from ns2, but there is no IPv4 address set in
+# that address space, so the kernel should substitute the dummy address
+# 192.0.0.8 defined in RFC7600.
+
+NS1=ns1
+NS2=ns2
+H1_IP=172.16.0.1/32
+H1_IP6=2001:db8:1::1
+RT1=172.16.1.0/24
+PINGADDR=172.16.1.1
+RT2=172.16.0.0/24
+H2_IP6=2001:db8:1::2
+
+TMPFILE=$(mktemp)
+
+cleanup()
+{
+    rm -f "$TMPFILE"
+    ip netns del $NS1
+    ip netns del $NS2
+}
+
+trap cleanup EXIT
+
+# Namespaces
+ip netns add $NS1
+ip netns add $NS2
+
+# Connectivity
+ip -netns $NS1 link add veth0 type veth peer name veth0 netns $NS2
+ip -netns $NS1 link set dev veth0 up
+ip -netns $NS2 link set dev veth0 up
+ip -netns $NS1 addr add $H1_IP dev veth0
+ip -netns $NS1 addr add $H1_IP6/64 dev veth0 nodad
+ip -netns $NS2 addr add $H2_IP6/64 dev veth0 nodad
+ip -netns $NS1 route add $RT1 via inet6 $H2_IP6
+ip -netns $NS2 route add $RT2 via inet6 $H1_IP6
+
+# Make sure ns2 will respond with ICMP unreachable
+ip netns exec $NS2 sysctl -qw net.ipv4.icmp_ratelimit=0 net.ipv4.ip_forward=1
+
+# Run the test - a ping runs in the background, and we capture ICMP responses
+# with tcpdump; -c 1 means it should exit on the first ping, but add a timeout
+# in case something goes wrong
+ip netns exec $NS1 ping -w 3 -i 0.5 $PINGADDR >/dev/null &
+ip netns exec $NS1 timeout 10 tcpdump -tpni veth0 -c 1 'icmp and icmp[icmptype] != icmp-echo' > $TMPFILE 2>/dev/null
+
+# Parse response and check for dummy address
+# tcpdump output looks like:
+# IP 192.0.0.8 > 172.16.0.1: ICMP net 172.16.1.1 unreachable, length 92
+RESP_IP=$(awk '{print $2}' < $TMPFILE)
+if [[ "$RESP_IP" != "192.0.0.8" ]]; then
+    echo "FAIL - got ICMP response from $RESP_IP, should be 192.0.0.8"
+    exit 1
+else
+    echo "OK"
+    exit 0
+fi
-- 
2.32.0


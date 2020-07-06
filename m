Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50DFA215787
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 14:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729292AbgGFMod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 08:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729125AbgGFMoc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 08:44:32 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B39EC08C5E0
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 05:44:32 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id f12so16053091eja.9
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 05:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4NNoOxff0nhiCp6Y07KXiET4P9UsRV6yVCqRMrClQ08=;
        b=LWykRokaTmYGCqNEmY1w2CbyYxpuoZ4IFwUyN2UXP98ea8Z0BRaVWGpaWgNFEvh13H
         JRxrnjn1lc0s0e4nmGqgRrN2qGll3nIiPYCtvLO6kSS32ghi2ONDDC027n/De5hiibRX
         ZMEaZJKbuaJpkDRH3CXSbR1n5tfQgsRf74sEneUBzB+DcXRj/ER/CfAIAKVm3BaMBzIa
         QhB2tjR/pjRKHHx62mY+/Op1CRNEgrVfWsKjL4JoE8JMiMUl37CWYfdc9FJy8LIEfVMF
         5miZwnJ7wb3MAbLG7WFMRaGSGzCaQ5s0whwDppGx8QqNyNuW1bWE/2JIc7svNnVYhsL/
         YAng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4NNoOxff0nhiCp6Y07KXiET4P9UsRV6yVCqRMrClQ08=;
        b=BYl1L3s8lH9Bh9hu6exlzpryVbHeE1GPNveKj2xvndAdkylWoLh9GzZQzfbHUCM3OD
         E27HFK/prvr6olFHKxzVMrxTp9R9V7RtClyp9or9n/J18pMBQtY2jNxo9dpDQuVEwE5n
         NWNHW3ENgsBYOAyVg0ikZ8SIPRCH4oZGb8pKbjnfjV7zDwW8W2TBtYFNLf20maoMBFZ8
         CTgaPJArK3XUgnFjKoNWMsA16IvmK5U1Nd+4G6ZDc24QrIULs4sq5OQq2mQby+BbTakI
         rulSKT1yct67Rv7Ii9rdfJEqis9DOnElbBfSK+x49Y9p+F0ZLhYCr5n+bXnEzQ1OPgl7
         fRnw==
X-Gm-Message-State: AOAM531sxVyYfPCjDAWw9YpXWD3XKQIccTOjoIheJiqNV4oUhSS8hxz7
        U+BtJB3yrGHu9i/krSa8SzBb7gxs8DH5+g==
X-Google-Smtp-Source: ABdhPJyzJ09NPfBJvmOzre17fK9bY9OTFzZGQ+6qD49u1WlGJgzfsoCqeWeLkqKQP0AgVKpIANFFdg==
X-Received: by 2002:a17:906:4356:: with SMTP id z22mr26801923ejm.414.1594039470723;
        Mon, 06 Jul 2020 05:44:30 -0700 (PDT)
Received: from tsr-vdi-mbaerts.nix.tessares.net (static.23.216.130.94.clients.your-server.de. [94.130.216.23])
        by smtp.gmail.com with ESMTPSA id o6sm20737298edr.94.2020.07.06.05.44.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 05:44:29 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     netdev@vger.kernel.org
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        Christoph Paasch <cpaasch@apple.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, mptcp@lists.01.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] selftests: mptcp: capture pcap on both sides
Date:   Mon,  6 Jul 2020 14:44:08 +0200
Message-Id: <20200706124408.3118005-1-matthieu.baerts@tessares.net>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When investigating performance issues that involve latency / loss /
reordering it is useful to have the pcap from the sender-side as it
allows to easier infer the state of the sender's congestion-control,
loss-recovery, etc.

Allow the selftests to capture a pcap on both sender and receiver so
that this information is not lost when reproducing.

This patch also improves the file names. Instead of:

  ns4-5ee79a56-X4O6gS-ns3-5ee79a56-X4O6gS-MPTCP-MPTCP-10.0.3.1.pcap

We now have something like for the same test:

  5ee79a56-X4O6gS-ns3-ns4-MPTCP-MPTCP-10.0.3.1-10030-connector.pcap
  5ee79a56-X4O6gS-ns3-ns4-MPTCP-MPTCP-10.0.3.1-10030-listener.pcap

It was a connection from ns3 to ns4, better to start with ns3 then. The
port is also added, easier to find the trace we want.

Co-developed-by: Christoph Paasch <cpaasch@apple.com>
Signed-off-by: Christoph Paasch <cpaasch@apple.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 tools/testing/selftests/net/mptcp/mptcp_connect.sh | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.sh b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
index 8f7145c413b9..c0589e071f20 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -395,10 +395,14 @@ do_transfer()
 			capuser="-Z $SUDO_USER"
 		fi
 
-		local capfile="${listener_ns}-${connector_ns}-${cl_proto}-${srv_proto}-${connect_addr}.pcap"
+		local capfile="${rndh}-${connector_ns:0:3}-${listener_ns:0:3}-${cl_proto}-${srv_proto}-${connect_addr}-${port}"
+		local capopt="-i any -s 65535 -B 32768 ${capuser}"
 
-		ip netns exec ${listener_ns} tcpdump -i any -s 65535 -B 32768 $capuser -w $capfile > "$capout" 2>&1 &
-		local cappid=$!
+		ip netns exec ${listener_ns}  tcpdump ${capopt} -w "${capfile}-listener.pcap"  >> "${capout}" 2>&1 &
+		local cappid_listener=$!
+
+		ip netns exec ${connector_ns} tcpdump ${capopt} -w "${capfile}-connector.pcap" >> "${capout}" 2>&1 &
+		local cappid_connector=$!
 
 		sleep 1
 	fi
@@ -423,7 +427,8 @@ do_transfer()
 
 	if $capture; then
 		sleep 1
-		kill $cappid
+		kill ${cappid_listener}
+		kill ${cappid_connector}
 	fi
 
 	local duration
-- 
2.27.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4417F49AF41
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 10:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1454073AbiAYJH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 04:07:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1454220AbiAYI6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 03:58:21 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E81A1C05A18A;
        Tue, 25 Jan 2022 00:17:58 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id f8so17650302pgf.8;
        Tue, 25 Jan 2022 00:17:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1N/NuBvkC5c1RrWF9LLt7oPSfOPWGYs8/12wHJBzBCE=;
        b=SiCzzSYFZKNDyms3R3mcvZU62+loTSzqMnMcW8ALOpgredjN8dZ87aP4aOfrL/A0EF
         V4vkrqegHuh0ZtgcsCeYA0Pj0bDyiRc5hYOPrI/pN+Z10rTaO8930F3Q2dlrxEvmIip3
         wKnQK7d/vPxmWD8nTwG9CvlTGLQPPH1W5s6QOW93dW8U84LWVdWPv9wLtJtvod8YItoo
         B4gtTBSR+hyyFS8H7KCBXuSFTHWUI9arJxveTHiYBPMR7/E5CahwimoP0hGpnNP6tqLN
         //VGNmoSN2jFmXJ5QXqBYLkjej4RcyzmEZ+wvnhfkjsvrut8s8nOcIPC/tg0M187whht
         g6qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1N/NuBvkC5c1RrWF9LLt7oPSfOPWGYs8/12wHJBzBCE=;
        b=4D7YsnfV0Rov2e+nzC95+r1ty9vKh/ThorreqweJG600Nw2r+ejqmJtN1XbTLDQL0q
         emugahJb2sQs8X5BH32sTicjGLJ6TQmEuDIN6Q+bWejkO0a4vee4Wc5klnnDk0ip2BZq
         yu2rYk1F2kVDTvxpkbehKH2/b7DRP6yV5o0nGT/QNMpNv1ICV2kSsAOO8g66oMl116tf
         StHSYDaa1xdwGW2HGL2DENw25dxhg31jH/BS3VU+topyTGrr6HE6zir/p7KqXTAO7cNR
         i7RBL3C6Fw1EBj9zSfi3MKhyigif/ppOFCdQ+SgcIqX4R9zZpwBOdR89eBVtR1JRsrmx
         yfTA==
X-Gm-Message-State: AOAM532UxBbx92Hb8Iqjb9Xyw+QmDnEPM1X2uXVKHEUhpVl+SxbtOdjq
        JiICl9x1sB6KP8dQsEVW7xw3v2Zr3eQ=
X-Google-Smtp-Source: ABdhPJzQnMIHUxdPVfN/uXPhDY4GhQUOK6/oTLhuRIOavQjUcsc90V0KuyKtJ86jpVf72+qhCzhrhQ==
X-Received: by 2002:a63:3808:: with SMTP id f8mr14268204pga.435.1643098678029;
        Tue, 25 Jan 2022 00:17:58 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l21sm18928949pfu.120.2022.01.25.00.17.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 00:17:57 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Mathieu Xhonneux <m.xhonneux@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        William Tu <u9012063@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH bpf 4/7] selftests/bpf/test_lwt_seg6local: use temp netns for testing
Date:   Tue, 25 Jan 2022 16:17:14 +0800
Message-Id: <20220125081717.1260849-5-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220125081717.1260849-1-liuhangbin@gmail.com>
References: <20220125081717.1260849-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use temp netns instead of hard code name for testing in case the
netns already exists.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 .../selftests/bpf/test_lwt_seg6local.sh       | 170 +++++++++---------
 1 file changed, 88 insertions(+), 82 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_lwt_seg6local.sh b/tools/testing/selftests/bpf/test_lwt_seg6local.sh
index 5620919fde9e..826f4423ce02 100755
--- a/tools/testing/selftests/bpf/test_lwt_seg6local.sh
+++ b/tools/testing/selftests/bpf/test_lwt_seg6local.sh
@@ -23,6 +23,12 @@
 
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
+readonly NS1="ns1-$(mktemp -u XXXXXX)"
+readonly NS2="ns2-$(mktemp -u XXXXXX)"
+readonly NS3="ns3-$(mktemp -u XXXXXX)"
+readonly NS4="ns4-$(mktemp -u XXXXXX)"
+readonly NS5="ns5-$(mktemp -u XXXXXX)"
+readonly NS6="ns6-$(mktemp -u XXXXXX)"
 
 msg="skip all tests:"
 if [ $UID != 0 ]; then
@@ -41,23 +47,23 @@ cleanup()
 	fi
 
 	set +e
-	ip netns del ns1 2> /dev/null
-	ip netns del ns2 2> /dev/null
-	ip netns del ns3 2> /dev/null
-	ip netns del ns4 2> /dev/null
-	ip netns del ns5 2> /dev/null
-	ip netns del ns6 2> /dev/null
+	ip netns del ${NS1} 2> /dev/null
+	ip netns del ${NS2} 2> /dev/null
+	ip netns del ${NS3} 2> /dev/null
+	ip netns del ${NS4} 2> /dev/null
+	ip netns del ${NS5} 2> /dev/null
+	ip netns del ${NS6} 2> /dev/null
 	rm -f $TMP_FILE
 }
 
 set -e
 
-ip netns add ns1
-ip netns add ns2
-ip netns add ns3
-ip netns add ns4
-ip netns add ns5
-ip netns add ns6
+ip netns add ${NS1}
+ip netns add ${NS2}
+ip netns add ${NS3}
+ip netns add ${NS4}
+ip netns add ${NS5}
+ip netns add ${NS6}
 
 trap cleanup 0 2 3 6 9
 
@@ -67,78 +73,78 @@ ip link add veth5 type veth peer name veth6
 ip link add veth7 type veth peer name veth8
 ip link add veth9 type veth peer name veth10
 
-ip link set veth1 netns ns1
-ip link set veth2 netns ns2
-ip link set veth3 netns ns2
-ip link set veth4 netns ns3
-ip link set veth5 netns ns3
-ip link set veth6 netns ns4
-ip link set veth7 netns ns4
-ip link set veth8 netns ns5
-ip link set veth9 netns ns5
-ip link set veth10 netns ns6
-
-ip netns exec ns1 ip link set dev veth1 up
-ip netns exec ns2 ip link set dev veth2 up
-ip netns exec ns2 ip link set dev veth3 up
-ip netns exec ns3 ip link set dev veth4 up
-ip netns exec ns3 ip link set dev veth5 up
-ip netns exec ns4 ip link set dev veth6 up
-ip netns exec ns4 ip link set dev veth7 up
-ip netns exec ns5 ip link set dev veth8 up
-ip netns exec ns5 ip link set dev veth9 up
-ip netns exec ns6 ip link set dev veth10 up
-ip netns exec ns6 ip link set dev lo up
+ip link set veth1 netns ${NS1}
+ip link set veth2 netns ${NS2}
+ip link set veth3 netns ${NS2}
+ip link set veth4 netns ${NS3}
+ip link set veth5 netns ${NS3}
+ip link set veth6 netns ${NS4}
+ip link set veth7 netns ${NS4}
+ip link set veth8 netns ${NS5}
+ip link set veth9 netns ${NS5}
+ip link set veth10 netns ${NS6}
+
+ip netns exec ${NS1} ip link set dev veth1 up
+ip netns exec ${NS2} ip link set dev veth2 up
+ip netns exec ${NS2} ip link set dev veth3 up
+ip netns exec ${NS3} ip link set dev veth4 up
+ip netns exec ${NS3} ip link set dev veth5 up
+ip netns exec ${NS4} ip link set dev veth6 up
+ip netns exec ${NS4} ip link set dev veth7 up
+ip netns exec ${NS5} ip link set dev veth8 up
+ip netns exec ${NS5} ip link set dev veth9 up
+ip netns exec ${NS6} ip link set dev veth10 up
+ip netns exec ${NS6} ip link set dev lo up
 
 # All link scope addresses and routes required between veths
-ip netns exec ns1 ip -6 addr add fb00::12/16 dev veth1 scope link
-ip netns exec ns1 ip -6 route add fb00::21 dev veth1 scope link
-ip netns exec ns2 ip -6 addr add fb00::21/16 dev veth2 scope link
-ip netns exec ns2 ip -6 addr add fb00::34/16 dev veth3 scope link
-ip netns exec ns2 ip -6 route add fb00::43 dev veth3 scope link
-ip netns exec ns3 ip -6 route add fb00::65 dev veth5 scope link
-ip netns exec ns3 ip -6 addr add fb00::43/16 dev veth4 scope link
-ip netns exec ns3 ip -6 addr add fb00::56/16 dev veth5 scope link
-ip netns exec ns4 ip -6 addr add fb00::65/16 dev veth6 scope link
-ip netns exec ns4 ip -6 addr add fb00::78/16 dev veth7 scope link
-ip netns exec ns4 ip -6 route add fb00::87 dev veth7 scope link
-ip netns exec ns5 ip -6 addr add fb00::87/16 dev veth8 scope link
-ip netns exec ns5 ip -6 addr add fb00::910/16 dev veth9 scope link
-ip netns exec ns5 ip -6 route add fb00::109 dev veth9 scope link
-ip netns exec ns5 ip -6 route add fb00::109 table 117 dev veth9 scope link
-ip netns exec ns6 ip -6 addr add fb00::109/16 dev veth10 scope link
-
-ip netns exec ns1 ip -6 addr add fb00::1/16 dev lo
-ip netns exec ns1 ip -6 route add fb00::6 dev veth1 via fb00::21
-
-ip netns exec ns2 ip -6 route add fb00::6 encap bpf in obj test_lwt_seg6local.o sec encap_srh dev veth2
-ip netns exec ns2 ip -6 route add fd00::1 dev veth3 via fb00::43 scope link
-
-ip netns exec ns3 ip -6 route add fc42::1 dev veth5 via fb00::65
-ip netns exec ns3 ip -6 route add fd00::1 encap seg6local action End.BPF endpoint obj test_lwt_seg6local.o sec add_egr_x dev veth4
-
-ip netns exec ns4 ip -6 route add fd00::2 encap seg6local action End.BPF endpoint obj test_lwt_seg6local.o sec pop_egr dev veth6
-ip netns exec ns4 ip -6 addr add fc42::1 dev lo
-ip netns exec ns4 ip -6 route add fd00::3 dev veth7 via fb00::87
-
-ip netns exec ns5 ip -6 route add fd00::4 table 117 dev veth9 via fb00::109
-ip netns exec ns5 ip -6 route add fd00::3 encap seg6local action End.BPF endpoint obj test_lwt_seg6local.o sec inspect_t dev veth8
-
-ip netns exec ns6 ip -6 addr add fb00::6/16 dev lo
-ip netns exec ns6 ip -6 addr add fd00::4/16 dev lo
-
-ip netns exec ns1 sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
-ip netns exec ns2 sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
-ip netns exec ns3 sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
-ip netns exec ns4 sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
-ip netns exec ns5 sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
-
-ip netns exec ns6 sysctl net.ipv6.conf.all.seg6_enabled=1 > /dev/null
-ip netns exec ns6 sysctl net.ipv6.conf.lo.seg6_enabled=1 > /dev/null
-ip netns exec ns6 sysctl net.ipv6.conf.veth10.seg6_enabled=1 > /dev/null
-
-ip netns exec ns6 nc -l -6 -u -d 7330 > $TMP_FILE &
-ip netns exec ns1 bash -c "echo 'foobar' | nc -w0 -6 -u -p 2121 -s fb00::1 fb00::6 7330"
+ip netns exec ${NS1} ip -6 addr add fb00::12/16 dev veth1 scope link
+ip netns exec ${NS1} ip -6 route add fb00::21 dev veth1 scope link
+ip netns exec ${NS2} ip -6 addr add fb00::21/16 dev veth2 scope link
+ip netns exec ${NS2} ip -6 addr add fb00::34/16 dev veth3 scope link
+ip netns exec ${NS2} ip -6 route add fb00::43 dev veth3 scope link
+ip netns exec ${NS3} ip -6 route add fb00::65 dev veth5 scope link
+ip netns exec ${NS3} ip -6 addr add fb00::43/16 dev veth4 scope link
+ip netns exec ${NS3} ip -6 addr add fb00::56/16 dev veth5 scope link
+ip netns exec ${NS4} ip -6 addr add fb00::65/16 dev veth6 scope link
+ip netns exec ${NS4} ip -6 addr add fb00::78/16 dev veth7 scope link
+ip netns exec ${NS4} ip -6 route add fb00::87 dev veth7 scope link
+ip netns exec ${NS5} ip -6 addr add fb00::87/16 dev veth8 scope link
+ip netns exec ${NS5} ip -6 addr add fb00::910/16 dev veth9 scope link
+ip netns exec ${NS5} ip -6 route add fb00::109 dev veth9 scope link
+ip netns exec ${NS5} ip -6 route add fb00::109 table 117 dev veth9 scope link
+ip netns exec ${NS6} ip -6 addr add fb00::109/16 dev veth10 scope link
+
+ip netns exec ${NS1} ip -6 addr add fb00::1/16 dev lo
+ip netns exec ${NS1} ip -6 route add fb00::6 dev veth1 via fb00::21
+
+ip netns exec ${NS2} ip -6 route add fb00::6 encap bpf in obj test_lwt_seg6local.o sec encap_srh dev veth2
+ip netns exec ${NS2} ip -6 route add fd00::1 dev veth3 via fb00::43 scope link
+
+ip netns exec ${NS3} ip -6 route add fc42::1 dev veth5 via fb00::65
+ip netns exec ${NS3} ip -6 route add fd00::1 encap seg6local action End.BPF endpoint obj test_lwt_seg6local.o sec add_egr_x dev veth4
+
+ip netns exec ${NS4} ip -6 route add fd00::2 encap seg6local action End.BPF endpoint obj test_lwt_seg6local.o sec pop_egr dev veth6
+ip netns exec ${NS4} ip -6 addr add fc42::1 dev lo
+ip netns exec ${NS4} ip -6 route add fd00::3 dev veth7 via fb00::87
+
+ip netns exec ${NS5} ip -6 route add fd00::4 table 117 dev veth9 via fb00::109
+ip netns exec ${NS5} ip -6 route add fd00::3 encap seg6local action End.BPF endpoint obj test_lwt_seg6local.o sec inspect_t dev veth8
+
+ip netns exec ${NS6} ip -6 addr add fb00::6/16 dev lo
+ip netns exec ${NS6} ip -6 addr add fd00::4/16 dev lo
+
+ip netns exec ${NS1} sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
+ip netns exec ${NS2} sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
+ip netns exec ${NS3} sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
+ip netns exec ${NS4} sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
+ip netns exec ${NS5} sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
+
+ip netns exec ${NS6} sysctl net.ipv6.conf.all.seg6_enabled=1 > /dev/null
+ip netns exec ${NS6} sysctl net.ipv6.conf.lo.seg6_enabled=1 > /dev/null
+ip netns exec ${NS6} sysctl net.ipv6.conf.veth10.seg6_enabled=1 > /dev/null
+
+ip netns exec ${NS6} nc -l -6 -u -d 7330 > $TMP_FILE &
+ip netns exec ${NS1} bash -c "echo 'foobar' | nc -w0 -6 -u -p 2121 -s fb00::1 fb00::6 7330"
 sleep 5 # wait enough time to ensure the UDP datagram arrived to the last segment
 kill -TERM $!
 
-- 
2.31.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8CC49AF35
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 10:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1454707AbiAYJHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 04:07:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1454221AbiAYI6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 03:58:21 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 579C8C0680B2;
        Tue, 25 Jan 2022 00:17:48 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id u11so18491370plh.13;
        Tue, 25 Jan 2022 00:17:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MYJ7WKYUrZnjcwxwbAaMEuMMN/n1nOl9rhHKl2PJEDU=;
        b=mgxlgNayqwsXsbqrpd3A3c9/VBsn0khpUXEw8zSm0sYmdNzkfqDYYUxiZdMkHXdWjg
         HJqmHrEuv5C6e6jyoCz1mun08uidVeM4W0DcNbDc2lMaG0zM77UCc8bRHnedX5YgZkFm
         QRts+yE9hfjsHYRKJCy1q64/htjp1139CNHCL4GjszNEZaHoPdyRo+WyBZZ4Il2YZ0UK
         T5exXeJH8VgeYoNWiNobMYeHDRiGI53NkBwR5gPGCTlz1nmMDxBFVCzmJg5yFbiWem1V
         qADnPLV4S9x+Uo8j8dZjPbzyraj91en+oPlk5AxoAfF3hlS6tE9VrUCK1h358JkcUyWG
         mSeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MYJ7WKYUrZnjcwxwbAaMEuMMN/n1nOl9rhHKl2PJEDU=;
        b=biaB8OYEDTXuOxvz2qiA+8WHK/xHJuxV9KrONtmL6NEq7WgaJl5P0hdFGM5n+pPKLY
         OuboiB0ZGALjNdDM+5rFi4Am45sP2H03vLECsZ6kJX83U3K4+nUblernfstXT+0Q7iB/
         dNqLEY6rTzmmaB/k85RmTBgTD5gA/opiEfzEAmD9lNeg7wTeKDbhkzCbl+54I8vqoyin
         Vvuw2DwuX3wpeb2KEXVnCYcbZPNj5J58wqTKb8Epcx/Qop7dbLgn3YU9UZJ20vff+/GJ
         V/r61nBX1Z8UqmdJN0p3q5GExxaGJjw1JUJjJ8yVMQZz2gakwIPeFf8PrpzNXFzx04oT
         YRBQ==
X-Gm-Message-State: AOAM532QEyeQcdThhUkwxJqo/HR5iPwjyiHf6QIFm4MY/ctAFXd87O1C
        rKe49j08FR/QrIgR/UDFHZ6M7shadQA=
X-Google-Smtp-Source: ABdhPJy7ufgk+W76L/tILcf8BXQJyKQjxw4STY0JrTuvP9oRu8njeujh33YDdYaYdigtpsIGrZN/UQ==
X-Received: by 2002:a17:902:bf02:b0:149:c653:22af with SMTP id bi2-20020a170902bf0200b00149c65322afmr17774166plb.139.1643098667659;
        Tue, 25 Jan 2022 00:17:47 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l21sm18928949pfu.120.2022.01.25.00.17.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 00:17:47 -0800 (PST)
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
Subject: [PATCH bpf 2/7] selftests/bpf/test_xdp_veth: use temp netns for testing
Date:   Tue, 25 Jan 2022 16:17:12 +0800
Message-Id: <20220125081717.1260849-3-liuhangbin@gmail.com>
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
 tools/testing/selftests/bpf/test_xdp_veth.sh | 39 +++++++++++---------
 1 file changed, 21 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_xdp_veth.sh b/tools/testing/selftests/bpf/test_xdp_veth.sh
index a3a1eaee26ea..392d28cc4e58 100755
--- a/tools/testing/selftests/bpf/test_xdp_veth.sh
+++ b/tools/testing/selftests/bpf/test_xdp_veth.sh
@@ -22,6 +22,9 @@ ksft_skip=4
 TESTNAME=xdp_veth
 BPF_FS=$(awk '$3 == "bpf" {print $2; exit}' /proc/mounts)
 BPF_DIR=$BPF_FS/test_$TESTNAME
+readonly NS1="ns1-$(mktemp -u XXXXXX)"
+readonly NS2="ns2-$(mktemp -u XXXXXX)"
+readonly NS3="ns3-$(mktemp -u XXXXXX)"
 
 _cleanup()
 {
@@ -29,9 +32,9 @@ _cleanup()
 	ip link del veth1 2> /dev/null
 	ip link del veth2 2> /dev/null
 	ip link del veth3 2> /dev/null
-	ip netns del ns1 2> /dev/null
-	ip netns del ns2 2> /dev/null
-	ip netns del ns3 2> /dev/null
+	ip netns del ${NS1} 2> /dev/null
+	ip netns del ${NS2} 2> /dev/null
+	ip netns del ${NS3} 2> /dev/null
 	rm -rf $BPF_DIR 2> /dev/null
 }
 
@@ -77,24 +80,24 @@ set -e
 
 trap cleanup_skip EXIT
 
-ip netns add ns1
-ip netns add ns2
-ip netns add ns3
+ip netns add ${NS1}
+ip netns add ${NS2}
+ip netns add ${NS3}
 
-ip link add veth1 index 111 type veth peer name veth11 netns ns1
-ip link add veth2 index 122 type veth peer name veth22 netns ns2
-ip link add veth3 index 133 type veth peer name veth33 netns ns3
+ip link add veth1 index 111 type veth peer name veth11 netns ${NS1}
+ip link add veth2 index 122 type veth peer name veth22 netns ${NS2}
+ip link add veth3 index 133 type veth peer name veth33 netns ${NS3}
 
 ip link set veth1 up
 ip link set veth2 up
 ip link set veth3 up
 
-ip -n ns1 addr add 10.1.1.11/24 dev veth11
-ip -n ns3 addr add 10.1.1.33/24 dev veth33
+ip -n ${NS1} addr add 10.1.1.11/24 dev veth11
+ip -n ${NS3} addr add 10.1.1.33/24 dev veth33
 
-ip -n ns1 link set dev veth11 up
-ip -n ns2 link set dev veth22 up
-ip -n ns3 link set dev veth33 up
+ip -n ${NS1} link set dev veth11 up
+ip -n ${NS2} link set dev veth22 up
+ip -n ${NS3} link set dev veth33 up
 
 mkdir $BPF_DIR
 bpftool prog loadall \
@@ -107,12 +110,12 @@ ip link set dev veth1 xdp pinned $BPF_DIR/progs/redirect_map_0
 ip link set dev veth2 xdp pinned $BPF_DIR/progs/redirect_map_1
 ip link set dev veth3 xdp pinned $BPF_DIR/progs/redirect_map_2
 
-ip -n ns1 link set dev veth11 xdp obj xdp_dummy.o sec xdp
-ip -n ns2 link set dev veth22 xdp obj xdp_tx.o sec xdp
-ip -n ns3 link set dev veth33 xdp obj xdp_dummy.o sec xdp
+ip -n ${NS1} link set dev veth11 xdp obj xdp_dummy.o sec xdp
+ip -n ${NS2} link set dev veth22 xdp obj xdp_tx.o sec xdp
+ip -n ${NS3} link set dev veth33 xdp obj xdp_dummy.o sec xdp
 
 trap cleanup EXIT
 
-ip netns exec ns1 ping -c 1 -W 1 10.1.1.33
+ip netns exec ${NS1} ping -c 1 -W 1 10.1.1.33
 
 exit 0
-- 
2.31.1


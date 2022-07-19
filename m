Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3589D579532
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 10:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236795AbiGSIZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 04:25:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231645AbiGSIZy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 04:25:54 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A86865A2;
        Tue, 19 Jul 2022 01:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658219153; x=1689755153;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=CAAeOGWYGAB27VN2UmCW2WgUwGTXzndU5ncbrTlDjyU=;
  b=P390k6f2/Jctxs+/YX9s4OIBHd7zhPSt53DKL5AKfXdmQDqFFGsGE2FZ
   txq6AQHeczVVKmhC3u5eb1LajVR45XGBpr67IrpSknSiAWyYHnu/3F6yt
   oeOp+zRMoT1YlgRzGeW2nz21tzIqg5248/oieSbaiXCXR12e+AgVAiEKf
   lBNCJ0sZqr8TfLjnBuMF8I+uG4BktZa4jHw9Rit5lyrcT1XUJ4uuGCqQX
   OolbDAHyQjjqTsiJHDChRf+UMOMjH3DfURkN382W0fteflfKDDeGwhPgs
   1bgsGqJ/rpM7dvuwRV/rJuujp+ZrQH3/xmnfVwXlKmV1w29TeVts5l3ej
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10412"; a="348122972"
X-IronPort-AV: E=Sophos;i="5.92,283,1650956400"; 
   d="scan'208";a="348122972"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 01:25:53 -0700
X-IronPort-AV: E=Sophos;i="5.92,283,1650956400"; 
   d="scan'208";a="924685104"
Received: from zhenzhu-mobl1.ccr.corp.intel.com (HELO jiezho4x-mobl1.ccr.corp.intel.com) ([10.255.31.69])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 01:25:47 -0700
From:   Jie2x Zhou <jie2x.zhou@intel.com>
To:     jie2x.zhou@intel.com, ast@kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
        john.fastabend@gmail.com, andrii@kernel.org, martin.lau@linux.dev,
        song@kernel.org, yhs@fb.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, mykolal@fb.com,
        shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Philip Li <philip.li@intel.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH] tools/testing/selftests/bpf/test_xdp_veth.sh: fix Couldn't retrieve pinned program
Date:   Tue, 19 Jul 2022 16:24:30 +0800
Message-Id: <20220719082430.9916-1-jie2x.zhou@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before change:
 selftests: bpf: test_xdp_veth.sh
 Couldn't retrieve pinned program '/sys/fs/bpf/test_xdp_veth/progs/redirect_map_0': No such file or directory
 selftests: xdp_veth [SKIP]
ok 20 selftests: bpf: test_xdp_veth.sh # SKIP

After change:
PING 10.1.1.33 (10.1.1.33) 56(84) bytes of data.
64 bytes from 10.1.1.33: icmp_seq=1 ttl=64 time=0.320 ms--- 10.1.1.33 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.320/0.320/0.320/0.000 ms
selftests: xdp_veth [PASS]

In test:
ls /sys/fs/bpf/test_xdp_veth/progs/redirect_map_0
ls: cannot access '/sys/fs/bpf/test_xdp_veth/progs/redirect_map_0': No such file or directory
ls /sys/fs/bpf/test_xdp_veth/progs/
xdp_redirect_map_0  xdp_redirect_map_1  xdp_redirect_map_2

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Jie2x Zhou <jie2x.zhou@intel.com>
---
 tools/testing/selftests/bpf/test_xdp_veth.sh | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_xdp_veth.sh b/tools/testing/selftests/bpf/test_xdp_veth.sh
index 392d28cc4e58..49936c4c8567 100755
--- a/tools/testing/selftests/bpf/test_xdp_veth.sh
+++ b/tools/testing/selftests/bpf/test_xdp_veth.sh
@@ -106,9 +106,9 @@ bpftool prog loadall \
 bpftool map update pinned $BPF_DIR/maps/tx_port key 0 0 0 0 value 122 0 0 0
 bpftool map update pinned $BPF_DIR/maps/tx_port key 1 0 0 0 value 133 0 0 0
 bpftool map update pinned $BPF_DIR/maps/tx_port key 2 0 0 0 value 111 0 0 0
-ip link set dev veth1 xdp pinned $BPF_DIR/progs/redirect_map_0
-ip link set dev veth2 xdp pinned $BPF_DIR/progs/redirect_map_1
-ip link set dev veth3 xdp pinned $BPF_DIR/progs/redirect_map_2
+ip link set dev veth1 xdp pinned $BPF_DIR/progs/xdp_redirect_map_0
+ip link set dev veth2 xdp pinned $BPF_DIR/progs/xdp_redirect_map_1
+ip link set dev veth3 xdp pinned $BPF_DIR/progs/xdp_redirect_map_2
 
 ip -n ${NS1} link set dev veth11 xdp obj xdp_dummy.o sec xdp
 ip -n ${NS2} link set dev veth22 xdp obj xdp_tx.o sec xdp
-- 
2.36.1


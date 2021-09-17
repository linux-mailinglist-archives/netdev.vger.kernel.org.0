Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF9E441004B
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 22:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236732AbhIQUZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 16:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231656AbhIQUZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 16:25:16 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A49EC061574
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 13:23:54 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id nn5-20020a17090b38c500b0019af1c4b31fso8217846pjb.3
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 13:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G68LQzSZpMRTYksOEIRHyybj5emq5qa1W4kuhkkwq8U=;
        b=mX8tG9BzSL+8xUo7RAA2a0XxrUkF/PLsh12EwDyH8Rfi02f/jN5y8P2HnJ+BktTNmV
         L6h0fBPjg0nblqCVyjmetCieMotIafGn7fdBtkpwFM3nmD3wIs0PbanP0OIQalqKD31B
         10fUYSD0y9H3fssSn88er4/58gpHdycg8hnNKfFzGLZrJVcFAY0ulXvVOhpQZJh4ZO3u
         /IIdwevxkD7XK7oaAkVxQVbUkIvBGwETwXtQfWPlRFEopKamwVsMHYfG5DRyZsnjnG3S
         rCxke5oHzkAin1rmg8mtfU1hXyRdCQg/u1W6WyMRIhoacrNbUaxfyETMB5Bdo2tBSvIB
         WL6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G68LQzSZpMRTYksOEIRHyybj5emq5qa1W4kuhkkwq8U=;
        b=HsK4FowfH3+0Nzofipt9tF6IX5kWb7shE0RdHV7S4mlrdKkP85llSTPmvI1DBoRfPj
         nEuCtKS6hd6gqqtCIvJuycNf76fxvFN48udCaYwtJvPV01I8hBRINfqkXMVLJQS/tDO8
         xQGXDCrCzxn59PTsys3tvUi85NX9XEG3BvWHQBk9ARbI1BHvK3KLCeYmrmixRNPMfmCR
         xpC5Zgt7ZR3Yxc2yk44GNosQroWXULEIyA3BJxypLKcz5s00xDCT5HtlrjLU0NiIxD47
         PxFbZqlc9w2SPdbvosp+QoqUOluyhsC3fJ5V7e6o/m6UX+zm+OgxkcUsli5RoEjHvp0E
         QNDg==
X-Gm-Message-State: AOAM5325YKO0JXZZ/Y4CSLNYpELRwqntjgKYIC9Cl6iVlaiX8fOSAXNe
        t4sSRkLaMLynnPhrpqRCGuuM+VJahXk=
X-Google-Smtp-Source: ABdhPJxkmZwbCSPczv0Y3suJ1WC6HPiM5Z1iqewLOuU1FcyQKyqemmNRYsiau/d6wB5KUrAWg/KEEA==
X-Received: by 2002:a17:902:784e:b0:139:d4ee:899e with SMTP id e14-20020a170902784e00b00139d4ee899emr11322792pln.48.1631910233105;
        Fri, 17 Sep 2021 13:23:53 -0700 (PDT)
Received: from localhost.localdomain ([49.206.116.228])
        by smtp.googlemail.com with ESMTPSA id l6sm6972276pff.74.2021.09.17.13.23.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 13:23:52 -0700 (PDT)
From:   Gokul Sivakumar <gokulkumar792@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Gokul Sivakumar <gokulkumar792@gmail.com>,
        David Ahern <dsahern@gmail.com>, stephen@networkplumber.org
Subject: [PATCH iproute2-next] lib: bpf_legacy: add prog name, load time, uid and btf id in prog info dump
Date:   Sat, 18 Sep 2021 01:53:38 +0530
Message-Id: <20210917202338.1810837-1-gokulkumar792@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The BPF program name is included when dumping the BPF program info and the
kernel only stores the first (BPF_PROG_NAME_LEN - 1) bytes for the program
name.

$ sudo ip link show dev docker0
4: docker0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdpgeneric qdisc noqueue state UP mode DEFAULT group default
    link/ether 02:42:4c:df:a4:54 brd ff:ff:ff:ff:ff:ff
    prog/xdp id 789 name xdp_drop_func tag 57cd311f2e27366b jited

The BPF program load time (ns since boottime), UID of the user who loaded
the program and the BTF ID are also included when dumping the BPF program
information when the user expects a detailed ip link info output.

$ sudo ip -details link show dev docker0
4: docker0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdpgeneric qdisc noqueue state UP mode DEFAULT group default
    link/ether 02:42:4c:df:a4:54 brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 68 maxmtu 65535
    bridge forward_delay 1500 hello_time 200 max_age 2000 ageing_time 30000 stp_state 0 priority 32768 vlan_filt
ering 0 vlan_protocol 802.1Q bridge_id 8000.2:42:4c:df:a4:54 designated_root 8000.2:42:4c:df:a4:54 root_port 0 r
oot_path_cost 0 topology_change 0 topology_change_detected 0 hello_timer    0.00 tcn_timer    0.00 topology_chan
ge_timer    0.00 gc_timer  265.36 vlan_default_pvid 1 vlan_stats_enabled 0 vlan_stats_per_port 0 group_fwd_mask
0 group_address 01:80:c2:00:00:00 mcast_snooping 1 mcast_router 1 mcast_query_use_ifaddr 0 mcast_querier 0 mcast
_hash_elasticity 16 mcast_hash_max 4096 mcast_last_member_count 2 mcast_startup_query_count 2 mcast_last_member_
interval 100 mcast_membership_interval 26000 mcast_querier_interval 25500 mcast_query_interval 12500 mcast_query
_response_interval 1000 mcast_startup_query_interval 3124 mcast_stats_enabled 0 mcast_igmp_version 2 mcast_mld_v
ersion 1 nf_call_iptables 0 nf_call_ip6tables 0 nf_call_arptables 0 addrgenmode eui64 numtxqueues 1 numrxqueues
1 gso_max_size 65536 gso_max_segs 65535
    prog/xdp id 789 name xdp_drop_func tag 57cd311f2e27366b jited load_time 2676682607316255 created_by_uid 0 btf_id 708

Signed-off-by: Gokul Sivakumar <gokulkumar792@gmail.com>
---
 lib/bpf_legacy.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/lib/bpf_legacy.c b/lib/bpf_legacy.c
index 91086aa2..a0643000 100644
--- a/lib/bpf_legacy.c
+++ b/lib/bpf_legacy.c
@@ -203,12 +203,32 @@ int bpf_dump_prog_info(FILE *f, uint32_t id)
 	if (!ret && len) {
 		int jited = !!info.jited_prog_len;
 
+		if (info.name)
+			print_string(PRINT_ANY, "name", "name %s ", info.name);
+
 		print_string(PRINT_ANY, "tag", "tag %s ",
 			     hexstring_n2a(info.tag, sizeof(info.tag),
 					   tmp, sizeof(tmp)));
 		print_uint(PRINT_JSON, "jited", NULL, jited);
 		if (jited && !is_json_context())
 			fprintf(f, "jited ");
+
+		if (show_details) {
+			if (info.load_time) {
+				/* ns since boottime */
+				print_lluint(PRINT_ANY, "load_time",
+					     "load_time %llu ", info.load_time);
+
+				print_luint(PRINT_ANY, "created_by_uid",
+					    "created_by_uid %lu ",
+					    info.created_by_uid);
+			}
+
+			if (info.btf_id)
+				print_luint(PRINT_ANY, "btf_id", "btf_id %lu ",
+					    info.btf_id);
+		}
+
 		dump_ok = 1;
 	}
 
-- 
2.25.1


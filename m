Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9FEC1C49F6
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 01:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbgEDXA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 19:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728281AbgEDXAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 19:00:54 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4BA2C061A0F
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 16:00:53 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id l18so444650wrn.6
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 16:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Sw60zuShd4R0QMy4XD6YSBZB+dxkShgdEI7D6DdG9QQ=;
        b=oJMEpuFQSx3Alo9MuL9oQDoVeeL9jEnqATwlz7rRGEU9fizseHsxreFeOus4kuuQZo
         UqFRsJMxhAe8btCpaf8jIx72llMzr7FBaI6wNysBxPXB0jm8dV09fMF6EziHxa+7Zqrj
         dQP6PUAfuBqKpqD1DEsBXZh0nCFa0LyqvAoUIWGatxbMaRBBz0giXoM4Z3J6zMtLzV08
         NDuS+gABcjcCIuVtr3Sb2N+6Mx1fotYtfng/ljo8WlkV2YNsJrkmSb+uPJJZ7BrCPZkt
         ueHnA/xW0HT01tuZKtR0Hg4R0D4dNOVYwMlaaBscn51Wcn7/LBpZdBmGvTrnT8u/2w4+
         T+wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Sw60zuShd4R0QMy4XD6YSBZB+dxkShgdEI7D6DdG9QQ=;
        b=TsJ1LOy9zipubCQTBb4gn2XuQiXHH1K9mDTSpnOj1B/PoeyHyHWVUVa8P8//foB0ZA
         4t+V3PP8d6Qelakhn4jGDscYP1mqr3OGoen0tCn5lvp/VIEbU9sn3FCdosRjg9w8ywHC
         Zc8prvTSvBQUE30xaFCjuC/bBEjmBbyYc57LGsPLeMAGrB3YYLP/dyDTjumgMvS1G9zJ
         GNxbZeGcVlVtEF2ZvDMuutYzWmSdlz8ACRzLRAUpBsbmdkpivd/78/GE623UxYflP3d5
         yFL+BMVgz1dRl9YtGyOj+ZdiQ8MxTfGaOfwOfoFQMiUvxEjum0UzRcRc1xDoulsSRlJN
         ZUaw==
X-Gm-Message-State: AGi0Pubqz8Vbp811Eb58ezXfFaMUC8w37xwBhBZGE71XuYylavATR0x1
        qIQx2hfwCPkdZDwteNJOiRjPJ7wnUSY=
X-Google-Smtp-Source: APiQypK/PmLLvqlOl8Pp1VCjke2hSb3fLbbAa9/++QBHNfuBP8jW2WIp/BVqF5lbBg+1TfQfOHS/Fw==
X-Received: by 2002:adf:a1c8:: with SMTP id v8mr158134wrv.79.1588633252130;
        Mon, 04 May 2020 16:00:52 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id r23sm15322570wra.74.2020.05.04.16.00.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 16:00:51 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        vinicius.gomes@intel.com, po.liu@nxp.com, xiaoliang.yang_1@nxp.com,
        mingkai.hu@nxp.com, christian.herber@nxp.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        vlad@buslov.dev, jiri@mellanox.com, idosch@mellanox.com,
        kuba@kernel.org
Subject: [PATCH v2 net-next 6/6] docs: net: dsa: sja1105: document intended usage of virtual links
Date:   Tue,  5 May 2020 02:00:34 +0300
Message-Id: <20200504230034.23958-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200504230034.23958-1-olteanv@gmail.com>
References: <20200504230034.23958-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Add some verbiage describing how the hardware features of the switch are
exposed to users through tc-flower.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes from v1:
None.

Changes from RFC:
Patch is new.

 Documentation/networking/dsa/sja1105.rst | 116 +++++++++++++++++++++++
 1 file changed, 116 insertions(+)

diff --git a/Documentation/networking/dsa/sja1105.rst b/Documentation/networking/dsa/sja1105.rst
index 64553d8d91cb..34581629dd3f 100644
--- a/Documentation/networking/dsa/sja1105.rst
+++ b/Documentation/networking/dsa/sja1105.rst
@@ -230,6 +230,122 @@ simultaneously on two ports. The driver checks the consistency of the schedules
 against this restriction and errors out when appropriate. Schedule analysis is
 needed to avoid this, which is outside the scope of the document.
 
+Routing actions (redirect, trap, drop)
+--------------------------------------
+
+The switch is able to offload flow-based redirection of packets to a set of
+destination ports specified by the user. Internally, this is implemented by
+making use of Virtual Links, a TTEthernet concept.
+
+The driver supports 2 types of keys for Virtual Links:
+
+- VLAN-aware virtual links: these match on destination MAC address, VLAN ID and
+  VLAN PCP.
+- VLAN-unaware virtual links: these match on destination MAC address only.
+
+The VLAN awareness state of the bridge (vlan_filtering) cannot be changed while
+there are virtual link rules installed.
+
+Composing multiple actions inside the same rule is supported. When only routing
+actions are requested, the driver creates a "non-critical" virtual link. When
+the action list also contains tc-gate (more details below), the virtual link
+becomes "time-critical" (draws frame buffers from a reserved memory partition,
+etc).
+
+The 3 routing actions that are supported are "trap", "drop" and "redirect".
+
+Example 1: send frames received on swp2 with a DA of 42:be:24:9b:76:20 to the
+CPU and to swp3. This type of key (DA only) when the port's VLAN awareness
+state is off::
+
+  tc qdisc add dev swp2 clsact
+  tc filter add dev swp2 ingress flower skip_sw dst_mac 42:be:24:9b:76:20 \
+          action mirred egress redirect dev swp3 \
+          action trap
+
+Example 2: drop frames received on swp2 with a DA of 42:be:24:9b:76:20, a VID
+of 100 and a PCP of 0::
+
+  tc filter add dev swp2 ingress protocol 802.1Q flower skip_sw \
+          dst_mac 42:be:24:9b:76:20 vlan_id 100 vlan_prio 0 action drop
+
+Time-based ingress policing
+---------------------------
+
+The TTEthernet hardware abilities of the switch can be constrained to act
+similarly to the Per-Stream Filtering and Policing (PSFP) clause specified in
+IEEE 802.1Q-2018 (formerly 802.1Qci). This means it can be used to perform
+tight timing-based admission control for up to 1024 flows (identified by a
+tuple composed of destination MAC address, VLAN ID and VLAN PCP). Packets which
+are received outside their expected reception window are dropped.
+
+This capability can be managed through the offload of the tc-gate action. As
+routing actions are intrinsic to virtual links in TTEthernet (which performs
+explicit routing of time-critical traffic and does not leave that in the hands
+of the FDB, flooding etc), the tc-gate action may never appear alone when
+asking sja1105 to offload it. One (or more) redirect or trap actions must also
+follow along.
+
+Example: create a tc-taprio schedule that is phase-aligned with a tc-gate
+schedule (the clocks must be synchronized by a 1588 application stack, which is
+outside the scope of this document). No packet delivered by the sender will be
+dropped. Note that the reception window is larger than the transmission window
+(and much more so, in this example) to compensate for the packet propagation
+delay of the link (which can be determined by the 1588 application stack).
+
+Receiver (sja1105)::
+
+  tc qdisc add dev swp2 clsact
+  now=$(phc_ctl /dev/ptp1 get | awk '/clock time is/ {print $5}') && \
+          sec=$(echo $now | awk -F. '{print $1}') && \
+          base_time="$(((sec + 2) * 1000000000))" && \
+          echo "base time ${base_time}"
+  tc filter add dev swp2 ingress flower skip_sw \
+          dst_mac 42:be:24:9b:76:20 \
+          action gate base-time ${base_time} \
+          sched-entry OPEN  60000 -1 -1 \
+          sched-entry CLOSE 40000 -1 -1 \
+          action trap
+
+Sender::
+
+  now=$(phc_ctl /dev/ptp0 get | awk '/clock time is/ {print $5}') && \
+          sec=$(echo $now | awk -F. '{print $1}') && \
+          base_time="$(((sec + 2) * 1000000000))" && \
+          echo "base time ${base_time}"
+  tc qdisc add dev eno0 parent root taprio \
+          num_tc 8 \
+          map 0 1 2 3 4 5 6 7 \
+          queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \
+          base-time ${base_time} \
+          sched-entry S 01  50000 \
+          sched-entry S 00  50000 \
+          flags 2
+
+The engine used to schedule the ingress gate operations is the same that the
+one used for the tc-taprio offload. Therefore, the restrictions regarding the
+fact that no two gate actions (either tc-gate or tc-taprio gates) may fire at
+the same time (during the same 200 ns slot) still apply.
+
+To come in handy, it is possible to share time-triggered virtual links across
+more than 1 ingress port, via flow blocks. In this case, the restriction of
+firing at the same time does not apply because there is a single schedule in
+the system, that of the shared virtual link::
+
+  tc qdisc add dev swp2 ingress_block 1 clsact
+  tc qdisc add dev swp3 ingress_block 1 clsact
+  tc filter add block 1 flower skip_sw dst_mac 42:be:24:9b:76:20 \
+          action gate index 2 \
+          base-time 0 \
+          sched-entry OPEN 50000000 -1 -1 \
+          sched-entry CLOSE 50000000 -1 -1 \
+          action trap
+
+Hardware statistics for each flow are also available ("pkts" counts the number
+of dropped frames, which is a sum of frames dropped due to timing violations,
+lack of destination ports and MTU enforcement checks). Byte-level counters are
+not available.
+
 Device Tree bindings and board design
 =====================================
 
-- 
2.17.1


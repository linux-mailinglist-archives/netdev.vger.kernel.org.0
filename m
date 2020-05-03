Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A79A31C2F64
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 23:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729165AbgECVLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 17:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729149AbgECVLD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 17:11:03 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B666C061A0E
        for <netdev@vger.kernel.org>; Sun,  3 May 2020 14:11:03 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id x18so18580173wrq.2
        for <netdev@vger.kernel.org>; Sun, 03 May 2020 14:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=N1T3aTdFG8qfwGJG8KgnnaUyn0oKJpSNw6PtwL6CG3I=;
        b=SfcMXMDDuWIMw2fp9v5otSGpWAlLjSJetgzk+FrIR8y4iGCMVwz+dMj1wQmW/TQ396
         Q8lvV6T/4gMLvWN+uleceIvzCpFsolpytect2f+zpMlHIbRGrF/Mj4SZQv8z8C1YhomE
         ykM+RbAM/KdBJG0KehaJFo35cyF4RaN7upv63mcncJoYNFf2cg6bmlaRg4VQy+8JEnw/
         koWaR2b4B90oECrNPOnGtlT1QNotrR5abW2rMpRyOJHVNQxxOE6QsqZa74ey4XebhKk6
         jgOWw7rQMZSgkPZ+McTMkaEcym3YMvXnbbgISY/cGzHci2/VreGVFtM/9aHsGvB2FTW4
         vajw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=N1T3aTdFG8qfwGJG8KgnnaUyn0oKJpSNw6PtwL6CG3I=;
        b=qRDKP3fO15Bykgx9AAWA7t/SwaaHkJDMe28QiN80guSbHdJrm/IlFRHFseN4f3AHT/
         pgMcFver3JG/6fVjMnZLeUhjSd2HsCdYUql6om0M9uw8/Do9OyBiarbJ9Y9nxDMFSHKL
         jiQ6Z5EK+vg6t5ZdNfWTA0k46DdnNeTFzGH1D2BvSgAzUSFvNoY6A6iKFJU/L5yKT3Ir
         2CMF+DSilSTRHD27X0Li5IGGAz48HIiZ1udO2FcTLrSvWe5UZAITcBgng0dZfYoER6Lg
         ca+u7D2xT+mg3oNLLMfYbPzuJbrIgUL+9VMkYyz3Mv/jGGg/QhfOxHB/QYKKxKxJ454F
         DqTw==
X-Gm-Message-State: AGi0PuYzUps14Zz5IHLpTOrh03ZAcjzocNBGVvnVDpaUoloLjM6Yl/zP
        0YfRhTyyRgvi7lZit4sqM+x8VSEU
X-Google-Smtp-Source: APiQypLlXAHvuhy3h3pCrlc0C06J2UArEdS/Akzk6BeflaZocsfs7kIIlBiG4iB+nyWj3tQGbJ4p6Q==
X-Received: by 2002:adf:fa41:: with SMTP id y1mr15059417wrr.131.1588540261995;
        Sun, 03 May 2020 14:11:01 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id s6sm10252682wmh.17.2020.05.03.14.11.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 May 2020 14:11:01 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        vinicius.gomes@intel.com, po.liu@nxp.com, xiaoliang.yang@nxp.com,
        mingkai.hu@nxp.com, christian.herber@nxp.com,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com,
        alexandru.marginean@nxp.com, vlad@buslov.dev, jiri@mellanox.com,
        idosch@mellanox.com, kuba@kernel.org
Subject: [PATCH net-next 6/6] docs: net: dsa: sja1105: document intended usage of virtual links
Date:   Mon,  4 May 2020 00:10:35 +0300
Message-Id: <20200503211035.19363-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200503211035.19363-1-olteanv@gmail.com>
References: <20200503211035.19363-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Add some verbiage describing how the hardware features of the switch are
exposed to users through tc-flower.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
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


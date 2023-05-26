Return-Path: <netdev+bounces-5680-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F80C7126BF
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 14:35:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3572428186B
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 12:35:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA79F1094E;
	Fri, 26 May 2023 12:34:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AEB3742C4
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 12:34:15 +0000 (UTC)
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A9C5E78
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 05:33:37 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id af79cd13be357-75affe977abso99713185a.0
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 05:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685104365; x=1687696365;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qsGi804HITWDN9g+tpka9+AoDahe4dsB5cL/mI3D60g=;
        b=UdpdW9oVq1LEl5rHDD4FucbyU1UqqGS6L+fViAuZ5I+RPj8lDZzrs58T+ZSFTIFVY9
         5qdQwa8NuHY4eZlVCJJWJuZQW+cSum6roGL7v+VR4poU7XmBDQJiIAiqJj3z0HYvBnIE
         YYW3uJwBC8OW9cP/g8/Lj3qPw+yHVRkN9qT/LQlKLP/0ufu7QFRchkfH7NfnLPaoXBsE
         8y1rhQzkAm0Xm7L87mpvUqFXATJ9cwPoHFa661Dph6J6HKSQ/LRfu0ZiCcaIrwwJQuTx
         gznwjPMBZ0QEjWpi2S8+9fXYtdov17CWC8mxgMRh9dLxrOVUeiNCIaE8iJZlIs3e8KB+
         5CdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685104365; x=1687696365;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qsGi804HITWDN9g+tpka9+AoDahe4dsB5cL/mI3D60g=;
        b=jusZKcRu+YxNqZVEKRsyn2UOffWpWgSxJ9Qnak9yyvCsCcppJ6kDNvVWS1ttd7AJmQ
         Af4kZaPzJ8B/uRtdnT9RJe2AMT/RItKvh9k5NL6MI40Z22MeRrrmwipgXPPyxtEXAIj0
         c+VZNHbZG5Zk3aHrEsQ3R0wfIcHMmC7roBFCjYfeTXcLlDCNT79sMrZIVDjSBaxX66iS
         xbI0kVI1myc2InMkcX+4WE2YheVlNcOCgdh58p8aHX3FXXm6UgaiOTMJWAyURFYyA2SF
         mJtISSjfCkJl3S9gk4zUmKKvvilS9xicJnI6W8VWr7+4KLNwY3DhcWUPh1QCLLs8fZGr
         33wg==
X-Gm-Message-State: AC+VfDx2diMi/c0iqM0DZ9eJFCYeqvfSuxG70D5vxGG3a/bFJDAxkWT3
	oxOpJgFJa1u5mDvvSpmkN0PvwT9BQSjDinnO
X-Google-Smtp-Source: ACHHUZ7LSeFgxkh/rsEn2R9CXJlwVm62y60FVdr7Y2E3JUDofdtiBQ1Owib3KXVl5coW/Sqp/jHD6g==
X-Received: by 2002:a05:620a:b14:b0:75b:23a1:35f8 with SMTP id t20-20020a05620a0b1400b0075b23a135f8mr1633230qkg.9.1685104364775;
        Fri, 26 May 2023 05:32:44 -0700 (PDT)
Received: from imac.redhat.com ([88.97.103.74])
        by smtp.gmail.com with ESMTPSA id d13-20020a05620a166d00b007595614c17bsm1121026qko.57.2023.05.26.05.32.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 05:32:44 -0700 (PDT)
From: Donald Hunter <donald.hunter@gmail.com>
To: netdev@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>
Cc: donald.hunter@redhat.com,
	Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH net-next v1 4/4] netlink: specs: add ynl spec for ovs_flow
Date: Fri, 26 May 2023 13:32:23 +0100
Message-Id: <20230526123223.35755-5-donald.hunter@gmail.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230526123223.35755-1-donald.hunter@gmail.com>
References: <20230526123223.35755-1-donald.hunter@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add a ynl specification for ovs_flow. This spec is sufficient to dump ovs
flows. Some attrs are left as binary blobs because ynl doesn't support C
arrays in struct definitions yet. This will be implemented in a separate
patchset.

Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
---
 Documentation/netlink/specs/ovs_flow.yaml | 822 ++++++++++++++++++++++
 1 file changed, 822 insertions(+)
 create mode 100644 Documentation/netlink/specs/ovs_flow.yaml

diff --git a/Documentation/netlink/specs/ovs_flow.yaml b/Documentation/netlink/specs/ovs_flow.yaml
new file mode 100644
index 000000000000..07a854d7cf8d
--- /dev/null
+++ b/Documentation/netlink/specs/ovs_flow.yaml
@@ -0,0 +1,822 @@
+# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
+
+name: ovs_flow
+version: 1
+protocol: genetlink-legacy
+
+doc:
+  OVS flow configuration over generic netlink.
+
+definitions:
+  -
+    name: ovs-header
+    type: struct
+    doc: |
+      Header for OVS Generic Netlink messages.
+    members:
+      -
+        name: dp-ifindex
+        type: u32
+        doc: |
+          ifindex of local port for datapath (0 to make a request not specific
+          to a datapath).
+  -
+    name: ovs-flow-stats
+    type: struct
+    members:
+      -
+        name: n-packets
+        type: u64
+        doc: Number of matched packets.
+      -
+        name: n-bytes
+        type: u64
+        doc: Number of matched bytes.
+  -
+    name: ovs-key-mpls
+    type: struct
+    members:
+      -
+        name: mpls-lse
+        type: u32
+        byte-order: big-endian
+  -
+    name: ovs-key-ipv4
+    type: struct
+    members:
+      -
+        name: ipv4-src
+        type: u32
+        byte-order: big-endian
+      -
+        name: ipv4-dst
+        type: u32
+        byte-order: big-endian
+      -
+        name: ipv4-proto
+        type: u8
+      -
+        name: ipv4-tos
+        type: u8
+      -
+        name: ipv4-ttl
+        type: u8
+      -
+        name: ipv4-frag
+        type: u8
+        enum: ovs-frag-type
+  -
+    name: ovs-frag-type
+    type: enum
+    entries:
+      -
+        name: none
+        doc: Packet is not a fragment.
+      -
+        name: first
+        doc: Packet is a fragment with offset 0.
+      -
+        name: later
+        doc: Packet is a fragment with nonzero offset.
+      -
+        name: any
+        value: 255
+  -
+    name: ovs-key-tcp
+    type: struct
+    members:
+      -
+        name: tcp-src
+        type: u16
+        byte-order: big-endian
+      -
+        name: tcp-dst
+        type: u16
+        byte-order: big-endian
+  -
+    name: ovs-key-udp
+    type: struct
+    members:
+      -
+        name: udp-src
+        type: u16
+        byte-order: big-endian
+      -
+        name: udp-dst
+        type: u16
+        byte-order: big-endian
+  -
+    name: ovs-key-sctp
+    type: struct
+    members:
+      -
+        name: sctp-src
+        type: u16
+        byte-order: big-endian
+      -
+        name: sctp-dst
+        type: u16
+        byte-order: big-endian
+  -
+    name: ovs-key-icmp
+    type: struct
+    members:
+      -
+        name: icmp-type
+        type: u8
+      -
+        name: icmp-code
+        type: u8
+  -
+    name: ovs-key-ct-tuple-ipv4
+    type: struct
+    members:
+      -
+        name: ipv4-src
+        type: u32
+        byte-order: big-endian
+      -
+        name: ipv4-dst
+        type: u32
+        byte-order: big-endian
+      -
+        name: src-port
+        type: u16
+        byte-order: big-endian
+      -
+        name: dst-port
+        type: u16
+        byte-order: big-endian
+      -
+        name: ipv4-proto
+        type: u8
+  -
+    name: ovs-action-push-vlan
+    type: struct
+    members:
+      -
+        name: vlan_tpid
+        type: u16
+        byte-order: big-endian
+        doc: Tag protocol identifier (TPID) to push.
+      -
+        name: vlan_tci
+        type: u16
+        byte-order: big-endian
+        doc: Tag control identifier (TCI) to push.
+  -
+    name: ovs-ufid-flags
+    type: flags
+    entries:
+      - omit-key
+      - omit-mask
+      - omit-actions
+  -
+    name: ovs-action-hash
+    type: struct
+    members:
+      -
+        name: hash-algorithm
+        type: u32
+        doc: Algorithm used to compute hash prior to recirculation.
+      -
+        name: hash-basis
+        type: u32
+        doc: Basis used for computing hash.
+  -
+    name: ovs-hash-alg
+    type: enum
+    doc: |
+      Data path hash algorithm for computing Datapath hash. The algorithm type only specifies
+      the fields in a flow will be used as part of the hash. Each datapath is free to use its
+      own hash algorithm. The hash value will be opaque to the user space daemon.
+    entries:
+      - ovs-hash-alg-l4
+
+  -
+    name: ovs-action-push-mpls
+    type: struct
+    members:
+      -
+        name: lse
+        type: u32
+        byte-order: big-endian
+        doc: |
+          MPLS label stack entry to push
+      -
+        name: ethertype
+        type: u32
+        byte-order: big-endian
+        doc: |
+          Ethertype to set in the encapsulating ethernet frame.  The only values
+          ethertype should ever be given are ETH_P_MPLS_UC and ETH_P_MPLS_MC,
+          indicating MPLS unicast or multicast. Other are rejected.
+  -
+    name: ovs-action-add-mpls
+    type: struct
+    members:
+      -
+        name: lse
+        type: u32
+        byte-order: big-endian
+        doc: |
+          MPLS label stack entry to push
+      -
+        name: ethertype
+        type: u32
+        byte-order: big-endian
+        doc: |
+          Ethertype to set in the encapsulating ethernet frame.  The only values
+          ethertype should ever be given are ETH_P_MPLS_UC and ETH_P_MPLS_MC,
+          indicating MPLS unicast or multicast. Other are rejected.
+      -
+        name: tun-flags
+        type: u16
+        doc: |
+          MPLS tunnel attributes.
+  -
+    name: ct-state-flags
+    type: flags
+    entries:
+      -
+        name: new
+        doc: Beginning of a new connection.
+      -
+        name: established
+        doc: Part of an existing connenction
+      -
+        name: related
+        doc: Related to an existing connection.
+      -
+        name: reply-dir
+        doc: Flow is in the reply direction.
+      -
+        name: invalid
+        doc: Could not track the connection.
+      -
+        name: tracked
+        doc: Conntrack has occurred.
+      -
+        name: src-nat
+        doc: Packet's source address/port was mangled by NAT.
+      -
+        name: dst-nat
+        doc: Packet's destination address/port was mangled by NAT.
+
+attribute-sets:
+  -
+    name: flow-attrs
+    attributes:
+      -
+        name: key
+        type: nest
+        nested-attributes: key-attrs
+        doc: |
+          Nested attributes specifying the flow key. Always present in
+          notifications. Required for all requests (except dumps).
+      -
+        name: actions
+        type: nest
+        nested-attributes: action-attrs
+        doc: |
+          Nested attributes specifying the actions to take for packets that
+          match the key. Always present in notifications. Required for
+          OVS_FLOW_CMD_NEW requests, optional for OVS_FLOW_CMD_SET requests.  An
+          OVS_FLOW_CMD_SET without OVS_FLOW_ATTR_ACTIONS will not modify the
+          actions.  To clear the actions, an OVS_FLOW_ATTR_ACTIONS without any
+          nested attributes must be given.
+      -
+        name: stats
+        type: binary
+        struct: ovs-flow-stats
+        doc: |
+          Statistics for this flow. Present in notifications if the stats would
+          be nonzero. Ignored in requests.
+      -
+        name: tcp-flags
+        type: u8
+        doc: |
+          An 8-bit value giving the ORed value of all of the TCP flags seen on
+          packets in this flow. Only present in notifications for TCP flows, and
+          only if it would be nonzero. Ignored in requests.
+      -
+        name: used
+        type: u64
+        doc: |
+          A 64-bit integer giving the time, in milliseconds on the system
+          monotonic clock, at which a packet was last processed for this
+          flow. Only present in notifications if a packet has been processed for
+          this flow. Ignored in requests.
+      -
+        name: clear
+        type: flag
+        doc: |
+          If present in a OVS_FLOW_CMD_SET request, clears the last-used time,
+          accumulated TCP flags, and statistics for this flow.  Otherwise
+          ignored in requests. Never present in notifications.
+      -
+        name: mask
+        type: nest
+        nested-attributes: key-attrs
+        doc: |
+          Nested attributes specifying the mask bits for wildcarded flow
+          match. Mask bit value '1' specifies exact match with corresponding
+          flow key bit, while mask bit value '0' specifies a wildcarded
+          match. Omitting attribute is treated as wildcarding all corresponding
+          fields. Optional for all requests. If not present, all flow key bits
+          are exact match bits.
+      -
+        name: probe
+        type: binary
+        doc: |
+          Flow operation is a feature probe, error logging should be suppressed.
+      -
+        name: ufid
+        type: binary
+        doc: |
+          A value between 1-16 octets specifying a unique identifier for the
+          flow. Causes the flow to be indexed by this value rather than the
+          value of the OVS_FLOW_ATTR_KEY attribute. Optional for all
+          requests. Present in notifications if the flow was created with this
+          attribute.
+      -
+        name: ufid-flags
+        type: u32
+        enum: ovs-ufid-flags
+        doc: |
+          A 32-bit value of ORed flags that provide alternative semantics for
+          flow installation and retrieval. Optional for all requests.
+      -
+        name: pad
+        type: binary
+
+  -
+    name: key-attrs
+    attributes:
+      -
+        name: encap
+        type: nest
+        nested-attributes: key-attrs
+      -
+        name: priority
+        type: u32
+      -
+        name: in-port
+        type: u32
+      -
+        name: ethernet
+        type: binary
+        doc: struct ovs_key_ethernet
+      -
+        name: vlan
+        type: u16
+        byte-order: big-endian
+      -
+        name: ethertype
+        type: u16
+        byte-order: big-endian
+      -
+        name: ipv4
+        type: binary
+        struct: ovs-key-ipv4
+      -
+        name: ipv6
+        type: binary
+        doc: struct ovs_key_ipv6
+      -
+        name: tcp
+        type: binary
+        struct: ovs-key-tcp
+      -
+        name: udp
+        type: binary
+        struct: ovs-key-udp
+      -
+        name: icmp
+        type: binary
+        struct: ovs-key-icmp
+      -
+        name: icmpv6
+        type: binary
+        struct: ovs-key-icmp
+      -
+        name: arp
+        type: binary
+        doc: struct ovs_key_arp
+      -
+        name: nd
+        type: binary
+        doc: struct ovs_key_nd
+      -
+        name: skb-mark
+        type: u32
+      -
+        name: tunnel
+        type: nest
+        nested-attributes: tunnel-key-attrs
+      -
+        name: sctp
+        type: binary
+        struct: ovs-key-sctp
+      -
+        name: tcp-flags
+        type: u16
+        byte-order: big-endian
+      -
+        name: dp-hash
+        type: u32
+        doc: Value 0 indicates the hash is not computed by the datapath.
+      -
+        name: recirc-id
+        type: u32
+      -
+        name: mpls
+        type: binary
+        struct: ovs-key-mpls
+      -
+        name: ct-state
+        type: u32
+        enum: ct-state-flags
+        enum-as-flags: true
+      -
+        name: ct-zone
+        type: u16
+        doc: connection tracking zone
+      -
+        name: ct-mark
+        type: u32
+        doc: connection tracking mark
+      -
+        name: ct-labels
+        type: binary
+        doc: 16-octet connection tracking label
+      -
+        name: ct-orig-tuple-ipv4
+        type: binary
+        struct: ovs-key-ct-tuple-ipv4
+      -
+        name: ct-orig-tuple-ipv6
+        type: binary
+        doc: struct ovs_key_ct_tuple_ipv6
+      -
+        name: nsh
+        type: nest
+        nested-attributes: ovs-nsh-key-attrs
+      -
+        name: packet-type
+        type: u32
+        byte-order: big-endian
+        doc: Should not be sent to the kernel
+      -
+        name: nd-extensions
+        type: binary
+        doc: Should not be sent to the kernel
+      -
+        name: tunnel-info
+        type: binary
+        doc: struct ip_tunnel_info
+      -
+        name: ipv6-exthdrs
+        type: binary
+        doc: struct ovs_key_ipv6_exthdr
+  -
+    name: action-attrs
+    attributes:
+      -
+        name: output
+        type: u32
+        doc: ovs port number in datapath
+      -
+        name: userspace
+        type: nest
+        nested-attributes: userspace-attrs
+      -
+        name: set
+        type: nest
+        nested-attributes: key-attrs
+        doc: Replaces the contents of an existing header. The single nested attribute specifies a header to modify and its value.
+      -
+        name: push-vlan
+        type: binary
+        struct: ovs-action-push-vlan
+        doc: Push a new outermost 802.1Q or 802.1ad header onto the packet.
+      -
+        name: pop-vlan
+        type: flag
+        doc: Pop the outermost 802.1Q or 802.1ad header from the packet.
+      -
+        name: sample
+        type: nest
+        nested-attributes: sample-attrs
+        doc: |
+          Probabilistically executes actions, as specified in the nested attributes.
+      -
+        name: recirc
+        type: u32
+        doc: recirc id
+      -
+        name: hash
+        type: binary
+        struct: ovs-action-hash
+      -
+        name: push-mpls
+        type: binary
+        struct: ovs-action-push-mpls
+        doc: |
+          Push a new MPLS label stack entry onto the top of the packets MPLS
+          label stack. Set the ethertype of the encapsulating frame to either
+          ETH_P_MPLS_UC or ETH_P_MPLS_MC to indicate the new packet contents.
+      -
+        name: pop-mpls
+        type: u16
+        byte-order: big-endian
+        doc: ethertype
+      -
+        name: set-masked
+        type: nest
+        nested-attributes: key-attrs
+        doc: |
+          Replaces the contents of an existing header. A nested attribute
+          specifies a header to modify, its value, and a mask. For every bit set
+          in the mask, the corresponding bit value is copied from the value to
+          the packet header field, rest of the bits are left unchanged. The
+          non-masked value bits must be passed in as zeroes. Masking is not
+          supported for the OVS_KEY_ATTR_TUNNEL attribute.
+      -
+        name: ct
+        type: nest
+        nested-attributes: ct-attrs
+        doc: |
+          Track the connection. Populate the conntrack-related entries
+          in the flow key.
+      -
+        name: trunc
+        type: u32
+        doc: struct ovs_action_trunc is a u32 max length
+      -
+        name: push-eth
+        type: binary
+        doc: struct ovs_action_push_eth
+      -
+        name: pop-eth
+        type: flag
+      -
+        name: ct-clear
+        type: flag
+      -
+        name: push-nsh
+        type: nest
+        nested-attributes: ovs-nsh-key-attrs
+        doc: |
+          Push NSH header to the packet.
+      -
+        name: pop-nsh
+        type: flag
+        doc: |
+          Pop the outermost NSH header off the packet.
+      -
+        name: meter
+        type: u32
+        doc: |
+          Run packet through a meter, which may drop the packet, or modify the
+          packet (e.g., change the DSCP field)
+      -
+        name: clone
+        type: nest
+        nested-attributes: action-attrs
+        doc: |
+          Make a copy of the packet and execute a list of actions without
+          affecting the original packet and key.
+      -
+        name: check-pkt-len
+        type: nest
+        nested-attributes: check-pkt-len-attrs
+        doc: |
+          Check the packet length and execute a set of actions if greater than
+          the specified packet length, else execute another set of actions.
+      -
+        name: add-mpls
+        type: binary
+        struct: ovs-action-add-mpls
+        doc: |
+          Push a new MPLS label stack entry at the start of the packet or at the
+          start of the l3 header depending on the value of l3 tunnel flag in the
+          tun_flags field of this OVS_ACTION_ATTR_ADD_MPLS argument.
+      -
+        name: dec-ttl
+        type: nest
+        nested-attributes: dec-ttl-attrs
+  -
+    name: tunnel-key-attrs
+    attributes:
+      -
+        name: id
+        type: u64
+        byte-order: big-endian
+        value: 0
+      -
+        name: ipv4-src
+        type: u32
+        byte-order: big-endian
+      -
+        name: ipv4-dst
+        type: u32
+        byte-order: big-endian
+      -
+        name: tos
+        type: u8
+      -
+        name: ttl
+        type: u8
+      -
+        name: dont-fragment
+        type: flag
+      -
+        name: csum
+        type: flag
+      -
+        name: oam
+        type: flag
+      -
+        name: geneve-opts
+        type: binary
+        sub-type: u32
+      -
+        name: tp-src
+        type: u16
+        byte-order: big-endian
+      -
+        name: tp-dst
+        type: u16
+        byte-order: big-endian
+      -
+        name: vxlan-opts
+        type: nest
+        nested-attributes: vxlan-ext-attrs
+      -
+        name: ipv6-src
+        type: binary
+        doc: |
+          struct in6_addr source IPv6 address
+      -
+        name: ipv6-dst
+        type: binary
+        doc: |
+          struct in6_addr destination IPv6 address
+      -
+        name: pad
+        type: binary
+      -
+        name: erspan-opts
+        type: binary
+        doc: |
+          struct erspan_metadata
+      -
+        name: ipv4-info-bridge
+        type: flag
+  -
+    name: check-pkt-len-attrs
+    attributes:
+      -
+        name: pkt-len
+        type: u16
+      -
+        name: actions-if-greater
+        type: nest
+        nested-attributes: action-attrs
+      -
+        name: actions-if-less-equal
+        type: nest
+        nested-attributes: action-attrs
+  -
+    name: sample-attrs
+    attributes:
+      -
+        name: probability
+        type: u32
+      -
+        name: actions
+        type: nest
+        nested-attributes: action-attrs
+  -
+    name: userspace-attrs
+    attributes:
+      -
+        name: pid
+        type: u32
+      -
+        name: userdata
+        type: binary
+      -
+        name: egress-tun-port
+        type: u32
+      -
+        name: actions
+        type: flag
+  -
+    name: ovs-nsh-key-attrs
+    attributes:
+      -
+        name: base
+        type: binary
+      -
+        name: md1
+        type: binary
+      -
+        name: md2
+        type: binary
+  -
+    name: ct-attrs
+    attributes:
+      -
+        name: commit
+        type: flag
+      -
+        name: zone
+        type: u16
+      -
+        name: mark
+        type: binary
+      -
+        name: labels
+        type: binary
+      -
+        name: helper
+        type: string
+      -
+        name: nat
+        type: nest
+        nested-attributes: nat-attrs
+      -
+        name: force-commit
+        type: flag
+      -
+        name: eventmask
+        type: u32
+      -
+        name: timeout
+        type: string
+  -
+    name: nat-attrs
+    attributes:
+      -
+        name: src
+        type: binary
+      -
+        name: dst
+        type: binary
+      -
+        name: ip-min
+        type: binary
+      -
+        name: ip-max
+        type: binary
+      -
+        name: proto-min
+        type: binary
+      -
+        name: proto-max
+        type: binary
+      -
+        name: persistent
+        type: binary
+      -
+        name: proto-hash
+        type: binary
+      -
+        name: proto-random
+        type: binary
+  -
+    name: dec-ttl-attrs
+    attributes:
+      -
+        name: action
+        type: nest
+        nested-attributes: action-attrs
+  -
+    name: vxlan-ext-attrs
+    attributes:
+      -
+        name: gbp
+        type: u32
+
+operations:
+  fixed-header: ovs-header
+  list:
+    -
+      name: flow-get
+      doc: Get / dump OVS flow configuration and state
+      value: 3
+      attribute-set: flow-attrs
+      do: &flow-get-op
+        request:
+          attributes:
+            - dp-ifindex
+            - key
+            - ufid
+      dump: *flow-get-op
+
+mcast-groups:
+  list:
+    -
+      name: ovs_flow
-- 
2.40.0



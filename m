Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9386BCEE0
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 13:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbjCPMCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 08:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbjCPMCR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 08:02:17 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C78FBC4890
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 05:02:11 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id jl13so1007337qvb.10
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 05:02:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678968130;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k9dSIGiwuzI5Q0tvkQ8vkJsvOjIP5AjMQVuT80GVYwk=;
        b=NU2wgnbehhS2hC20G7LW2PwD37NQP1mk/8pwDHT6fM/iLwaYvLlY+PInLJ/ZnMFeMO
         gPK8vbKPs+j9mv/asn+onb3Cvl11kgXKH/yYF1q75I+HwQJjHBKp76iv2d9kpljWKqOp
         JHbTwI+MP0qIv8/nC1dOgeC4oc6HWb5lYBtru4A7GK1VhGzolMkGOnxdXB7ihtvpjcmG
         AUSCDb1xlZWtYiDUN3YYwqz6beOeLKKAvN0XPEXxmnlCZoBzc+m955bpfNsMTaHdecJd
         ezbIQxx6VSD2i3aHFDtc8fmsaFkAhECzNrY0OvXFtcgSBwkiZpgy6e/NMHEDs7midlzU
         NGAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678968130;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k9dSIGiwuzI5Q0tvkQ8vkJsvOjIP5AjMQVuT80GVYwk=;
        b=d6Ivnnyfh476T2pEPCxOfT5K5ZeP56zISPtgpDUMlcCUfhkDn1Ukp/t7nL+KYVdwBo
         TOgnS/qOOJEsMR9P6f9KIgwrgiOAq3GsMumO9+Gbw8XecPTLYOweKnwnCIcfVMh+rxg/
         /KJ0u5xzKp1JYKmLs1jNk7sGsREZ+5mgTaujeYTAMOje6Trn2prq2c4XuFbM6DgVTNif
         rhfPXnHZ1KnRYyf3JkRkZwJ327EGApQ2ekQlqOE1tlq0y0tUtZHtOhcW3t7c6q7+pwxP
         5T3yMLOejnnzpSwP/yfduMaI3eIE6b3t3ii9kU5Sm+DJvA9kpSkUrxomrW934RCPsaaN
         QlBw==
X-Gm-Message-State: AO0yUKVJ76ekYHRxxC+pRPyIM9B6SzZwjzikvln4NsQBWgtqX87ir8Yr
        UKOkt8nHnmxKjMjeWrN7a7Rn0fURbHBLdA==
X-Google-Smtp-Source: AK7set9a1pLSoPLUfN8fJvp4a55Pn96R9rqOVFvZCj7qD6+G2mFhohLFYDLmwKRZbU50202Q5d6qGg==
X-Received: by 2002:a05:6214:2523:b0:579:5dbc:ab8c with SMTP id gg3-20020a056214252300b005795dbcab8cmr32500458qvb.30.1678968130298;
        Thu, 16 Mar 2023 05:02:10 -0700 (PDT)
Received: from imac.fritz.box ([2a02:8010:60a0:0:dc26:c93f:e030:938d])
        by smtp.gmail.com with ESMTPSA id g14-20020a05620a218e00b007457bc9a047sm5643743qka.50.2023.03.16.05.02.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 05:02:09 -0700 (PDT)
From:   Donald Hunter <donald.hunter@gmail.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     donald.hunter@redhat.com, Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH net-next v1 2/2] netlink: specs: add partial specification for openvswitch
Date:   Thu, 16 Mar 2023 12:01:42 +0000
Message-Id: <20230316120142.94268-3-donald.hunter@gmail.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230316120142.94268-1-donald.hunter@gmail.com>
References: <20230316120142.94268-1-donald.hunter@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The openvswitch family has a user header, uses struct attrs and has
array values and demonstrates these features in the YNL CLI. These specs
are sufficient to create, delete and dump datapaths and to dump vports:

$ ./tools/net/ynl/cli.py \
    --schema Documentation/netlink/genetlink-legacy.yaml \
    --spec Documentation/netlink/specs/ovs_datapath.yaml \
    --do dp-new --json '{ "dp_ifindex": 0, "name": "demo", "upcall_pid": 0}'
None

$ ./tools/net/ynl/cli.py \
    --schema Documentation/netlink/genetlink-legacy.yaml \
    --spec Documentation/netlink/specs/ovs_datapath.yaml \
    --dump dp-get --json '{ "dp_ifindex": 0 }'
[{'dp_ifindex': 3,
  'masks_cache_size': 256,
  'megaflow_stats': {'cache_hits': 0,
                     'mask_hit': 0,
                     'masks': 0,
                     'pad1': 0,
                     'padding': 0},
  'name': 'test',
  'stats': {'flows': 0, 'hit': 0, 'lost': 0, 'missed': 0},
  'user_features': {'dispatch_upcall_per_cpu',
                    'tc_recirc_sharing',
                    'unaligned'}},
 {'dp_ifindex': 39,
  'masks_cache_size': 256,
  'megaflow_stats': {'cache_hits': 0,
                     'mask_hit': 0,
                     'masks': 0,
                     'pad1': 0,
                     'padding': 0},
  'name': 'demo',
  'stats': {'flows': 0, 'hit': 0, 'lost': 0, 'missed': 0},
  'user_features': set()}]

$ ./tools/net/ynl/cli.py \
    --schema Documentation/netlink/genetlink-legacy.yaml \
    --spec Documentation/netlink/specs/ovs_datapath.yaml \
    --do dp-del --json '{ "dp_ifindex": 0, "name": "demo"}'
None

$ ./tools/net/ynl/cli.py \
    --schema Documentation/netlink/genetlink-legacy.yaml \
    --spec Documentation/netlink/specs/ovs_vport.yaml \
    --dump vport-get --json '{ "dp_ifindex": 3 }'
[{'dp_ifindex': 3,
  'ifindex': 3,
  'name': 'test',
  'port_no': 0,
  'stats': {'rx_bytes': 0,
            'rx_dropped': 0,
            'rx_errors': 0,
            'rx_packets': 0,
            'tx_bytes': 0,
            'tx_dropped': 0,
            'tx_errors': 0,
            'tx_packets': 0},
  'type': 'internal',
  'upcall_pid': [0],
  'upcall_stats': {'fail': 0, 'success': 0}}]

Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
---
 Documentation/netlink/specs/ovs_datapath.yaml | 154 ++++++++++++++++++
 Documentation/netlink/specs/ovs_vport.yaml    | 141 ++++++++++++++++
 2 files changed, 295 insertions(+)
 create mode 100644 Documentation/netlink/specs/ovs_datapath.yaml
 create mode 100644 Documentation/netlink/specs/ovs_vport.yaml

diff --git a/Documentation/netlink/specs/ovs_datapath.yaml b/Documentation/netlink/specs/ovs_datapath.yaml
new file mode 100644
index 000000000000..c420f78f7c25
--- /dev/null
+++ b/Documentation/netlink/specs/ovs_datapath.yaml
@@ -0,0 +1,154 @@
+# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
+
+name: ovs_datapath
+version: 2
+protocol: genetlink-legacy
+
+doc:
+  OVS datapath configuration over generic netlink.
+
+definitions:
+  -
+    name: ovs_header
+    type: struct
+    members:
+      -
+        name: dp_ifindex
+        type: u32
+  -
+    name: user_features
+    type: flags
+    entries:
+      -
+        name: unaligned
+        doc: Allow last Netlink attribute to be unaligned
+      -
+        name: vport_pids
+        doc: Allow datapath to associate multiple Netlink PIDs to each vport
+      -
+        name: tc_recirc_sharing
+        doc: Allow tc offload recirc sharing
+      -
+        name: dispatch_upcall_per_cpu
+        doc: Allow per-cpu dispatch of upcalls
+  -
+    name: datapath_stats
+    type: struct
+    members:
+      -
+        name: hit
+        type: u64
+      -
+        name: missed
+        type: u64
+      -
+        name: lost
+        type: u64
+      -
+        name: flows
+        type: u64
+  -
+    name: megaflow_stats
+    type: struct
+    members:
+      -
+        name: mask_hit
+        type: u64
+      -
+        name: masks
+        type: u32
+      -
+        name: padding
+        type: u32
+      -
+        name: cache_hits
+        type: u64
+      -
+        name: pad1
+        type: u64
+
+user-header: ovs_header
+
+attribute-sets:
+  -
+    name: datapath
+    attributes:
+      -
+        name: name
+        type: string
+      -
+        name: upcall_pid
+        doc: upcall pid
+        type: u32
+      -
+        name: stats
+        type: struct
+        struct: datapath_stats
+      -
+        name: megaflow_stats
+        type: struct
+        struct: megaflow_stats
+      -
+        name: user_features
+        type: u32
+        enum: user_features
+        enum-as-flags: true
+      -
+        name: pad
+        type: unused
+      -
+        name: masks_cache_size
+        type: u32
+      -
+        name: per_cpu_pids
+        type: array-nest
+        sub-type: u32
+
+operations:
+  list:
+    -
+      name: dp-get
+      doc: Get / dump OVS data path configuration and state
+      value: 3
+      attribute-set: datapath
+      do: &dp-get-op
+        request:
+          attributes:
+            - name
+        reply:
+          attributes:
+            - name
+            - upcall_pid
+            - stats
+            - megaflow_stats
+            - user_features
+            - masks_cache_size
+            - per_cpu_pids
+      dump: *dp-get-op
+    -
+      name: dp-new
+      doc: Create new OVS data path
+      value: 1
+      attribute-set: datapath
+      do:
+        request:
+          attributes:
+            - dp_ifindex
+            - name
+            - upcall_pid
+            - user_features
+    -
+      name: dp-del
+      doc: Delete existing OVS data path
+      value: 2
+      attribute-set: datapath
+      do:
+        request:
+          attributes:
+            - dp_ifindex
+            - name
+
+mcast-groups:
+  list:
+    -
+      name: ovs_datapath
diff --git a/Documentation/netlink/specs/ovs_vport.yaml b/Documentation/netlink/specs/ovs_vport.yaml
new file mode 100644
index 000000000000..3913aded5e28
--- /dev/null
+++ b/Documentation/netlink/specs/ovs_vport.yaml
@@ -0,0 +1,141 @@
+# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
+
+name: ovs_vport
+version: 2
+protocol: genetlink-legacy
+
+doc:
+  OVS vport configuration over generic netlink.
+
+definitions:
+  -
+    name: ovs_header
+    type: struct
+    members:
+      -
+        name: dp_ifindex
+        type: u32
+  -
+    name: vport_type
+    type: enum
+    entries: [ unspec, netdev, internal, gre, vxlan, geneve ]
+  -
+    name: vport_stats
+    type: struct
+    members:
+      -
+        name: rx_packets
+        type: u64
+      -
+        name: tx_packets
+        type: u64
+      -
+        name: rx_bytes
+        type: u64
+      -
+        name: tx_bytes
+        type: u64
+      -
+        name: rx_errors
+        type: u64
+      -
+        name: tx_errors
+        type: u64
+      -
+        name: rx_dropped
+        type: u64
+      -
+        name: tx_dropped
+        type: u64
+
+
+user-header: ovs_header
+
+attribute-sets:
+  -
+    name: vport-options
+    attributes:
+      -
+        name: dst_port
+        type: u32
+      -
+        name: extension
+        type: u32
+  -
+    name: upcall-stats
+    attributes:
+      -
+        name: success
+        type: u64
+        value: 0
+      -
+        name: fail
+        type: u64
+  -
+    name: vport
+    attributes:
+      -
+        name: port_no
+        type: u32
+      -
+        name: type
+        type: u32
+        enum: vport_type
+      -
+        name: name
+        type: string
+      -
+        name: options
+        type: nest
+        nested-attributes: vport-options
+      -
+        name: upcall_pid
+        type: array-nest
+        sub-type: u32
+      -
+        name: stats
+        type: struct
+        struct: vport_stats
+      -
+        name: pad
+        type: unused
+      -
+        name: ifindex
+        type: u32
+      -
+        name: netnsid
+        type: u32
+      -
+        name: upcall_stats
+        type: nest
+        nested-attributes: upcall-stats
+
+operations:
+  list:
+    -
+      name: vport-get
+      doc: Get / dump OVS vport configuration and state
+      value: 3
+      attribute-set: vport
+      do: &vport-get-op
+        request:
+          attributes:
+            - dp_ifindex
+            - name
+        reply: &dev-all
+          attributes:
+            - dp_ifindex
+            - port_no
+            - type
+            - name
+            - upcall_pid
+            - stats
+            - ifindex
+            - netnsid
+            - upcall_stats
+      dump: *vport-get-op
+
+mcast-groups:
+  list:
+    -
+      name: ovs_vport
-- 
2.39.0


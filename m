Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89DF56C85BF
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 20:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231687AbjCXTTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 15:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231630AbjCXTTb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 15:19:31 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2410E5B91;
        Fri, 24 Mar 2023 12:19:27 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id o44so2331556qvo.4;
        Fri, 24 Mar 2023 12:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679685567;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=baO/JoV/iXYEzhQwMlu7mnvyc24+QpS7jNnl+nSC1E8=;
        b=PiI0ou8xBk2aJt3wwZQP79EL09Nrc2NFr/F9Zl44BxZCBhYhD2tVkQiNLKbjz7XPA4
         yVcNkteeov7b0WNU6tjMX/YoowivDXcMlAJcbO0Xmj1tk4dUiAzB08A8hKFI/5fWa/R6
         y6d67KseseGM/II9oMG4u+8tpmWRChxfb0j6EQGldW44MyuD2zhb120zPhp4/nBBNq2e
         FeTtee2Hg4iQr09/3U9f+Qqm4zwtmlYbqxZs7R2IK+svG+JEGsewpQMchiCYsbuGhePC
         uFUa+G/5Ei5YuHvda6QqBlQplk+cGPa43ll57R1IXFsrQY7Zwp3A9jI+qFcL+/f2e/0G
         TuUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679685567;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=baO/JoV/iXYEzhQwMlu7mnvyc24+QpS7jNnl+nSC1E8=;
        b=X9xz8gbK725tamkCIKiNVxTs6/yivFMbzw+Bj7Lvrs755BUPIR/3R0StHFIeLVGloM
         UensOaGHjWARaMzhjPyr+J3gAgtYpgWFgW9KVE+1aDYM0P17PbjBgh90bDGypknVJbKF
         NM2vU+fik4Ie4ABUTpqVh1XWezid98ZEB3DtFjUJnuwNY8icEtfM3mv5kys9pUQcaPv7
         SkTFLMyw2+XzVe5P0z59WEt3KchN/EkyWudXCQZFzdoHYLqz0Nh5Ttv2qBKawfK5XcRE
         RSbYSjrsOgXZ7DxOU3MZv0hCWrQe7LrnIi2SVQRl9KfkekFiMrDZOtoYvHVUaxz25JxD
         EJKw==
X-Gm-Message-State: AAQBX9eYQaycnkcfV62VrlfNPAyPnR57lCxJyXG+buhcuL12lBZb9poY
        ZZggwcWQVpvaqHjG3cNs9O89k/JXK3MwWg==
X-Google-Smtp-Source: AKy350YGC5nbPO+QWcn8EDd51oowv0KOTjFNeDRhOVf5SjExifDqbsThn36q8RhoNeYfASp673ls7g==
X-Received: by 2002:ad4:5f09:0:b0:5c5:95db:859e with SMTP id fo9-20020ad45f09000000b005c595db859emr7086370qvb.31.1679685567243;
        Fri, 24 Mar 2023 12:19:27 -0700 (PDT)
Received: from imac.redhat.com ([88.97.103.74])
        by smtp.gmail.com with ESMTPSA id cn5-20020ad44a65000000b005dd8b9345e1sm900141qvb.121.2023.03.24.12.19.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 12:19:26 -0700 (PDT)
From:   Donald Hunter <donald.hunter@gmail.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Cc:     donald.hunter@redhat.com, Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH net-next v4 5/7] netlink: specs: add partial specification for openvswitch
Date:   Fri, 24 Mar 2023 19:18:58 +0000
Message-Id: <20230324191900.21828-6-donald.hunter@gmail.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230324191900.21828-1-donald.hunter@gmail.com>
References: <20230324191900.21828-1-donald.hunter@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The openvswitch family has a fixed header, uses struct attrs and has array
values. This partial spec demonstrates these features in the YNL CLI. These
specs are sufficient to create, delete and dump datapaths and to dump vports:

$ ./tools/net/ynl/cli.py \
    --spec Documentation/netlink/specs/ovs_datapath.yaml \
    --do dp-new --json '{ "dp-ifindex": 0, "name": "demo", "upcall-pid": 0}'
None

$ ./tools/net/ynl/cli.py \
    --spec Documentation/netlink/specs/ovs_datapath.yaml \
    --dump dp-get --json '{ "dp-ifindex": 0 }'
[{'dp-ifindex': 3,
  'masks-cache-size': 256,
  'megaflow-stats': {'cache-hits': 0,
                     'mask-hit': 0,
                     'masks': 0,
                     'pad1': 0,
                     'padding': 0},
  'name': 'test',
  'stats': {'flows': 0, 'hit': 0, 'lost': 0, 'missed': 0},
  'user-features': {'dispatch-upcall-per-cpu',
                    'tc-recirc-sharing',
                    'unaligned'}},
 {'dp-ifindex': 48,
  'masks-cache-size': 256,
  'megaflow-stats': {'cache-hits': 0,
                     'mask-hit': 0,
                     'masks': 0,
                     'pad1': 0,
                     'padding': 0},
  'name': 'demo',
  'stats': {'flows': 0, 'hit': 0, 'lost': 0, 'missed': 0},
  'user-features': set()}]

$ ./tools/net/ynl/cli.py \
    --spec Documentation/netlink/specs/ovs_datapath.yaml \
    --do dp-del --json '{ "dp-ifindex": 0, "name": "demo"}'
None

$ ./tools/net/ynl/cli.py \
    --spec Documentation/netlink/specs/ovs_vport.yaml \
    --dump vport-get --json '{ "dp-ifindex": 3 }'
[{'dp-ifindex': 3,
  'ifindex': 3,
  'name': 'test',
  'port-no': 0,
  'stats': {'rx-bytes': 0,
            'rx-dropped': 0,
            'rx-errors': 0,
            'rx-packets': 0,
            'tx-bytes': 0,
            'tx-dropped': 0,
            'tx-errors': 0,
            'tx-packets': 0},
  'type': 'internal',
  'upcall-pid': [0],
  'upcall-stats': {'fail': 0, 'success': 0}}]

Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
---
 Documentation/netlink/specs/ovs_datapath.yaml | 153 ++++++++++++++++++
 Documentation/netlink/specs/ovs_vport.yaml    | 139 ++++++++++++++++
 2 files changed, 292 insertions(+)
 create mode 100644 Documentation/netlink/specs/ovs_datapath.yaml
 create mode 100644 Documentation/netlink/specs/ovs_vport.yaml

diff --git a/Documentation/netlink/specs/ovs_datapath.yaml b/Documentation/netlink/specs/ovs_datapath.yaml
new file mode 100644
index 000000000000..6d71db8c4416
--- /dev/null
+++ b/Documentation/netlink/specs/ovs_datapath.yaml
@@ -0,0 +1,153 @@
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
+    name: ovs-header
+    type: struct
+    members:
+      -
+        name: dp-ifindex
+        type: u32
+  -
+    name: user-features
+    type: flags
+    entries:
+      -
+        name: unaligned
+        doc: Allow last Netlink attribute to be unaligned
+      -
+        name: vport-pids
+        doc: Allow datapath to associate multiple Netlink PIDs to each vport
+      -
+        name: tc-recirc-sharing
+        doc: Allow tc offload recirc sharing
+      -
+        name: dispatch-upcall-per-cpu
+        doc: Allow per-cpu dispatch of upcalls
+  -
+    name: datapath-stats
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
+    name: megaflow-stats
+    type: struct
+    members:
+      -
+        name: mask-hit
+        type: u64
+      -
+        name: masks
+        type: u32
+      -
+        name: padding
+        type: u32
+      -
+        name: cache-hits
+        type: u64
+      -
+        name: pad1
+        type: u64
+
+attribute-sets:
+  -
+    name: datapath
+    attributes:
+      -
+        name: name
+        type: string
+      -
+        name: upcall-pid
+        doc: upcall pid
+        type: u32
+      -
+        name: stats
+        type: binary
+        struct: datapath-stats
+      -
+        name: megaflow-stats
+        type: binary
+        struct: megaflow-stats
+      -
+        name: user-features
+        type: u32
+        enum: user-features
+        enum-as-flags: true
+      -
+        name: pad
+        type: unused
+      -
+        name: masks-cache-size
+        type: u32
+      -
+        name: per-cpu-pids
+        type: binary
+        sub-type: u32
+
+operations:
+  fixed-header: ovs-header
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
+            - upcall-pid
+            - stats
+            - megaflow-stats
+            - user-features
+            - masks-cache-size
+            - per-cpu-pids
+      dump: *dp-get-op
+    -
+      name: dp-new
+      doc: Create new OVS data path
+      value: 1
+      attribute-set: datapath
+      do:
+        request:
+          attributes:
+            - dp-ifindex
+            - name
+            - upcall-pid
+            - user-features
+    -
+      name: dp-del
+      doc: Delete existing OVS data path
+      value: 2
+      attribute-set: datapath
+      do:
+        request:
+          attributes:
+            - dp-ifindex
+            - name
+
+mcast-groups:
+  list:
+    -
+      name: ovs_datapath
diff --git a/Documentation/netlink/specs/ovs_vport.yaml b/Documentation/netlink/specs/ovs_vport.yaml
new file mode 100644
index 000000000000..8e55622ddf11
--- /dev/null
+++ b/Documentation/netlink/specs/ovs_vport.yaml
@@ -0,0 +1,139 @@
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
+    name: ovs-header
+    type: struct
+    members:
+      -
+        name: dp-ifindex
+        type: u32
+  -
+    name: vport-type
+    type: enum
+    entries: [ unspec, netdev, internal, gre, vxlan, geneve ]
+  -
+    name: vport-stats
+    type: struct
+    members:
+      -
+        name: rx-packets
+        type: u64
+      -
+        name: tx-packets
+        type: u64
+      -
+        name: rx-bytes
+        type: u64
+      -
+        name: tx-bytes
+        type: u64
+      -
+        name: rx-errors
+        type: u64
+      -
+        name: tx-errors
+        type: u64
+      -
+        name: rx-dropped
+        type: u64
+      -
+        name: tx-dropped
+        type: u64
+
+attribute-sets:
+  -
+    name: vport-options
+    attributes:
+      -
+        name: dst-port
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
+        name: port-no
+        type: u32
+      -
+        name: type
+        type: u32
+        enum: vport-type
+      -
+        name: name
+        type: string
+      -
+        name: options
+        type: nest
+        nested-attributes: vport-options
+      -
+        name: upcall-pid
+        type: binary
+        sub-type: u32
+      -
+        name: stats
+        type: binary
+        struct: vport-stats
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
+        name: upcall-stats
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
+      fixed-header: ovs-header
+      do: &vport-get-op
+        request:
+          attributes:
+            - dp-ifindex
+            - name
+        reply: &dev-all
+          attributes:
+            - dp-ifindex
+            - port-no
+            - type
+            - name
+            - upcall-pid
+            - stats
+            - ifindex
+            - netnsid
+            - upcall-stats
+      dump: *vport-get-op
+
+mcast-groups:
+  list:
+    -
+      name: ovs_vport
-- 
2.39.0


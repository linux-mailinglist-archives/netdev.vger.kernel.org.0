Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5206C0473
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 20:38:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbjCSTin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 15:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbjCSTif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 15:38:35 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E896C4223
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 12:38:32 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id l27so224404wrb.2
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 12:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679254710;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3ygo9cP42ENNj3ilA9aApLzpVUDVAgd/awYBFmOYHlo=;
        b=EYGQFcREkgSEeSA/WEFcMHanCqlK34lcrtlxo7lOqZzZnj97xB+xXZjWBCbIqOqmG0
         SDtuQq1dNqVpJ/m9MsmhYBFEQfLXBQHwyd2hJp30nd8/VXmckrw8+05loqcG7b1yeZC9
         uWgkubRmhyMAJ5CxO0nJkh3QjKl+E61wLtDUoaadn2+MPd4IY4csfK4BvCx2qchXgcEI
         F3tv3U1zppF0c60dZBoAXKU3RUjjKeiLMczWlGfANe6arvlsnb+XAU9zGY/J8LzZhjTY
         nAUI1Nu90bo8F8HAKW6Q7nDW9dIdzuwkUQSKRyji+JbJkWbSHASLIsUlhb3OYG/7xRY7
         njjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679254710;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3ygo9cP42ENNj3ilA9aApLzpVUDVAgd/awYBFmOYHlo=;
        b=gbKmPdzucixDNXzxvnMxQ+XdsrHlQdG32xj0Cf4Za5i8WxG4Zd2WKyjQ1AdciVd088
         gA1JIOPufy3V+w4oJQEHaSBIAkZXUS78EZllTB3rGGiEMMPwZZObcWiarelGj4Fs4FQ8
         k8jS2IVk0ZCdJNrQ7TZAq4sYc+qeBL6h++tBI/vhqrIiG3ytSh6CAcS7RNw/JX543/DU
         XvnPD8gERIgwnHkXHIFKRsoz2Mm23QSHuAno9ryCZr4VfGKPUtIvVYGzg5gkgT1YbHc6
         R1qH26eXE1Dj2+nq9CGn2ZsJyZu+YqRiCw3v7FFOcLayMcYL6It5Gq/l6isufAzgR0v4
         wkrQ==
X-Gm-Message-State: AO0yUKXv+gPCfNm+YMhCm6VA5uV+4G/cHk//qFq0DZUckTsaG4V0dnGl
        aqhXUwB9Aw8XRlYOHkQ4cJUGqY5dEQ40TQ==
X-Google-Smtp-Source: AK7set9CfWKu5ocR867bR0plro61Bkifv+N2cf9JG1mBbdWUw7+Bgor9eacBFvn9sOgd9qeginee9Q==
X-Received: by 2002:a05:6000:100b:b0:2d5:5610:e7b4 with SMTP id a11-20020a056000100b00b002d55610e7b4mr3285698wrx.64.1679254710634;
        Sun, 19 Mar 2023 12:38:30 -0700 (PDT)
Received: from imac.redhat.com ([88.97.103.74])
        by smtp.gmail.com with ESMTPSA id d5-20020adfef85000000b002cfed482e9asm7204190wro.61.2023.03.19.12.38.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Mar 2023 12:38:30 -0700 (PDT)
From:   Donald Hunter <donald.hunter@gmail.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     donald.hunter@redhat.com, Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH net-next v2 6/6] netlink: specs: add partial specification for openvswitch
Date:   Sun, 19 Mar 2023 19:38:03 +0000
Message-Id: <20230319193803.97453-7-donald.hunter@gmail.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230319193803.97453-1-donald.hunter@gmail.com>
References: <20230319193803.97453-1-donald.hunter@gmail.com>
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

The openvswitch family has a fixed header, uses struct attrs and has array
values. This partial spec demonstrates these features in the YNL CLI. These
specs are sufficient to create, delete and dump datapaths and to dump vports:

$ ./tools/net/ynl/cli.py \
    --schema Documentation/netlink/genetlink-legacy.yaml \
    --spec Documentation/netlink/specs/ovs_datapath.yaml \
    --do dp-new --json '{ "dp-ifindex": 0, "name": "demo", "upcall-pid": 0}'
None

./tools/net/ynl/cli.py \
    --schema Documentation/netlink/genetlink-legacy.yaml \
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
    --schema Documentation/netlink/genetlink-legacy.yaml \
    --spec Documentation/netlink/specs/ovs_datapath.yaml \
    --do dp-del --json '{ "dp-ifindex": 0, "name": "demo"}'
None

$ ./tools/net/ynl/cli.py \
    --schema Documentation/netlink/genetlink-legacy.yaml \
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
index 000000000000..2eefdf9d8cd7
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
+        type: struct
+        struct: datapath-stats
+      -
+        name: megaflow-stats
+        type: struct
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
+        type: array-nest
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
index 000000000000..a0d01adcb435
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
+        type: array-nest
+        sub-type: u32
+      -
+        name: stats
+        type: struct
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


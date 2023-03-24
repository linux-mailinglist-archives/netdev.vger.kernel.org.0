Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0EF6C7D56
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 12:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbjCXLil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 07:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231625AbjCXLii (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 07:38:38 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 708F81DB87;
        Fri, 24 Mar 2023 04:38:31 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id r29so1458763wra.13;
        Fri, 24 Mar 2023 04:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679657909;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=baO/JoV/iXYEzhQwMlu7mnvyc24+QpS7jNnl+nSC1E8=;
        b=R2cXobDHGNb6xe0rxUhk9nEpqCjJj84VR1JJDR5l0g51zDRPG6B7Foe0c2FilWQOCF
         kuTmUBxdszHMgCaghMa9S3viPLL1hNIdei/0TKb58UNyDgKx6lKfQha4+/P0cOWZXzIY
         6EuiXPxocmsJwTW+HmOfn/oAD6tWwEB4qX9RzYupf3vRhV5McWGUhY7LE9XpvRj9hf46
         AyJEJl7fDyloDhjguyCy2okj4z3IOfN3jrSQFVA7CTeWWzNFsmVlOZzudCtYFRRVb/ke
         YakixInGQ4J5+1vugFAd1YY1pXDTKrtSFD5abTM7DjiVVhgTZHEsnZ2+SGhgjc48AyaU
         IqvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679657909;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=baO/JoV/iXYEzhQwMlu7mnvyc24+QpS7jNnl+nSC1E8=;
        b=D0TJNY2ruMc6wiFmFjsPj/dz7T+1RnAkO/G+mIJsTuz4AfJwa9FhdbVEUlWYB0lt9F
         TgJ3i0g2xgMRRFB32MwcKcVzz2cnxAPCzqLZeyepU8rNTlx8nLjkFlZDglz1GAABan79
         6Wdy56yRG6w4J7Y92n0xQZ+iZWzuxNcKO2QZXCz1thukR3kbZticzPQP0LqNJUMl+RM5
         E5qkcQrHJGUYCpFITZgHADN7eWEssOU65l5Fbk2etzCO01Fr+67/yEtKJvcK4lN09B86
         tb6PE2icYbzkmIRrHPy/ctD7KsYIXdLL1h/tbTOQRIKRR/gK8haz0nXWkpgnNToZ5CD/
         xsng==
X-Gm-Message-State: AAQBX9crLOt+3D7K9U3UMM+NEKrPDkwfn0gaYqLl5CU11loFR+iNBG3r
        5qEmwLNy4JYwWBC4UT7SSyjByhu07miDrg==
X-Google-Smtp-Source: AKy350YJb3GyghCATyGiFlKvkQnzfth+opxFp8vdD3nIV63bXkorDGgo8z3Jw5p7Lk9XRNnJAVaVrQ==
X-Received: by 2002:adf:f80c:0:b0:2ce:a8d5:4a89 with SMTP id s12-20020adff80c000000b002cea8d54a89mr1951339wrp.37.1679657909398;
        Fri, 24 Mar 2023 04:38:29 -0700 (PDT)
Received: from imac.fritz.box ([2a02:8010:60a0:0:cd72:bbb4:8d1:483a])
        by smtp.gmail.com with ESMTPSA id t6-20020adff606000000b002d828a9f9ddsm10150954wrp.115.2023.03.24.04.38.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 04:38:28 -0700 (PDT)
From:   Donald Hunter <donald.hunter@gmail.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Cc:     donald.hunter@redhat.com, Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH net-next v3 5/7] netlink: specs: add partial specification for openvswitch
Date:   Fri, 24 Mar 2023 11:37:32 +0000
Message-Id: <20230324113734.1473-6-donald.hunter@gmail.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230324113734.1473-1-donald.hunter@gmail.com>
References: <20230324113734.1473-1-donald.hunter@gmail.com>
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


Return-Path: <netdev+bounces-11153-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 07F0D731C3A
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 17:14:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 34DFF1C20EC2
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 15:14:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FE9A14A80;
	Thu, 15 Jun 2023 15:14:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14FC9BA3A
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 15:14:19 +0000 (UTC)
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3F561FD5
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 08:14:17 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id 3f1490d57ef6-bd20beffda6so1893296276.1
        for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 08:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686842057; x=1689434057;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Zali8/9g5iSrK38gs35jIzibQzOaUNUpEkmLLoH+pPA=;
        b=Rm1FWDPEm5oDndqS6StIQ6BPJbFQ9Jhlv0aFN/aTcbYv/k68sbIOO6r89PswIo4xr8
         5xXqP1T3/6Fs30Otrem9kn/HXhR7hmXL8x70Nm7qbwDrYoZqPGnudn9vTYiWP4RfX1ek
         0Pn5qg2rhdSN44gGNRC67m0m5mLKR5OXBJoIq5z0j7Y6eqrG+bMJftaGOqbfvuWEl/ia
         0PqxqvJi74KELme5a7ln+yk/PSWK6xNghEKVJk35lLSnMBTz+/0oCozbZPAmA7Vvyt9c
         iftIDHhkSO4o5zWVyTYyOB75kTQaXCr0pTK/G9wB19dJr+OWJGoNc2H3Q3gbCd4OZQ/f
         e1RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686842057; x=1689434057;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zali8/9g5iSrK38gs35jIzibQzOaUNUpEkmLLoH+pPA=;
        b=UbMWJMFH7G8VFqFYDMEtKTQaUyEW5bDVvrENdgF1CiINpKIrngGOW7maEWnyRCFyeA
         BQWVtMm+xCyOpbnVdD8WBoX/VTXxRwkMUFF7WBQoKfMypnz3MGYTd9u5RVlvnLemWzjj
         kZ646SBUSI3RkmWlj3gRkNeb1xqOvFi3DckskssNqxiJ9Ueyg0JmxH0RZO3lY8nC4Frg
         z0TB6dPKyD+z/jKtJkrBBXVWxoqdyWooQh4FjSHiq8cNUf6Nv0nla3INCqkV6wGRFAGW
         xt7tHSBUsPTWoqF70KaCeb2t50mXyPsgCKGL0KpNAcJDne2uO8Uq6BdfLKFyyJh1Kx4l
         ffCQ==
X-Gm-Message-State: AC+VfDy5bIsfbEx76wNnnT2fJX1XNYauRFNfDBs+ERupNpshPxOtDBD8
	9WRjUw14DHR7dQHWxAMJEfC9lUieiyE2UA==
X-Google-Smtp-Source: ACHHUZ5L/OVTVBIl4479EcXDa58GLjMSbc7icOQs2cWE6XXmU6UrYGpQ/bry4WivFiiH7D0trPlZNQ==
X-Received: by 2002:a25:dccd:0:b0:bc0:bfa7:7658 with SMTP id y196-20020a25dccd000000b00bc0bfa77658mr4849855ybe.2.1686842056574;
        Thu, 15 Jun 2023 08:14:16 -0700 (PDT)
Received: from imac.fritz.box ([88.97.103.74])
        by smtp.gmail.com with ESMTPSA id b4-20020a25e404000000b00ba83509b758sm4171868ybh.4.2023.06.15.08.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jun 2023 08:14:16 -0700 (PDT)
From: Donald Hunter <donald.hunter@gmail.com>
To: netdev@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>
Cc: donald.hunter@redhat.com,
	Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH net-next v1] netlink: specs: fixup openvswitch specs for code generation
Date: Thu, 15 Jun 2023 16:14:05 +0100
Message-Id: <20230615151405.77649-1-donald.hunter@gmail.com>
X-Mailer: git-send-email 2.39.0
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

Refine the ovs_* specs to align exactly with the ovs netlink UAPI
definitions to enable code generation.

Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
---
 Documentation/netlink/specs/ovs_datapath.yaml | 30 +++++---
 Documentation/netlink/specs/ovs_flow.yaml     | 68 +++++++++++++++----
 Documentation/netlink/specs/ovs_vport.yaml    | 13 +++-
 3 files changed, 87 insertions(+), 24 deletions(-)

diff --git a/Documentation/netlink/specs/ovs_datapath.yaml b/Documentation/netlink/specs/ovs_datapath.yaml
index 6d71db8c4416..f709c26c3e92 100644
--- a/Documentation/netlink/specs/ovs_datapath.yaml
+++ b/Documentation/netlink/specs/ovs_datapath.yaml
@@ -3,6 +3,7 @@
 name: ovs_datapath
 version: 2
 protocol: genetlink-legacy
+uapi-header: linux/openvswitch.h
 
 doc:
   OVS datapath configuration over generic netlink.
@@ -18,6 +19,7 @@ definitions:
   -
     name: user-features
     type: flags
+    name-prefix: ovs-dp-f-
     entries:
       -
         name: unaligned
@@ -33,35 +35,37 @@ definitions:
         doc: Allow per-cpu dispatch of upcalls
   -
     name: datapath-stats
+    enum-name: ovs-dp-stats
     type: struct
     members:
       -
-        name: hit
+        name: n-hit
         type: u64
       -
-        name: missed
+        name: n-missed
         type: u64
       -
-        name: lost
+        name: n-lost
         type: u64
       -
-        name: flows
+        name: n-flows
         type: u64
   -
     name: megaflow-stats
+    enum-name: ovs-dp-megaflow-stats
     type: struct
     members:
       -
-        name: mask-hit
+        name: n-mask-hit
         type: u64
       -
-        name: masks
+        name: n-masks
         type: u32
       -
         name: padding
         type: u32
       -
-        name: cache-hits
+        name: n-cache-hit
         type: u64
       -
         name: pad1
@@ -70,6 +74,8 @@ definitions:
 attribute-sets:
   -
     name: datapath
+    name-prefix: ovs-dp-attr-
+    enum-name: ovs-datapath-attrs
     attributes:
       -
         name: name
@@ -101,12 +107,16 @@ attribute-sets:
         name: per-cpu-pids
         type: binary
         sub-type: u32
+      -
+        name: ifindex
+        type: u32
 
 operations:
   fixed-header: ovs-header
+  name-prefix: ovs-dp-cmd-
   list:
     -
-      name: dp-get
+      name: get
       doc: Get / dump OVS data path configuration and state
       value: 3
       attribute-set: datapath
@@ -125,7 +135,7 @@ operations:
             - per-cpu-pids
       dump: *dp-get-op
     -
-      name: dp-new
+      name: new
       doc: Create new OVS data path
       value: 1
       attribute-set: datapath
@@ -137,7 +147,7 @@ operations:
             - upcall-pid
             - user-features
     -
-      name: dp-del
+      name: del
       doc: Delete existing OVS data path
       value: 2
       attribute-set: datapath
diff --git a/Documentation/netlink/specs/ovs_flow.yaml b/Documentation/netlink/specs/ovs_flow.yaml
index 3b0624c87074..1ecbcd117385 100644
--- a/Documentation/netlink/specs/ovs_flow.yaml
+++ b/Documentation/netlink/specs/ovs_flow.yaml
@@ -3,6 +3,7 @@
 name: ovs_flow
 version: 1
 protocol: genetlink-legacy
+uapi-header: linux/openvswitch.h
 
 doc:
   OVS flow configuration over generic netlink.
@@ -67,6 +68,7 @@ definitions:
         enum: ovs-frag-type
   -
     name: ovs-frag-type
+    name-prefix: ovs-frag-type-
     type: enum
     entries:
       -
@@ -166,6 +168,7 @@ definitions:
         doc: Tag control identifier (TCI) to push.
   -
     name: ovs-ufid-flags
+    name-prefix: ovs-ufid-f-
     type: flags
     entries:
       - omit-key
@@ -176,7 +179,7 @@ definitions:
     type: struct
     members:
       -
-        name: hash-algorithm
+        name: hash-alg
         type: u32
         doc: Algorithm used to compute hash prior to recirculation.
       -
@@ -198,13 +201,13 @@ definitions:
     type: struct
     members:
       -
-        name: lse
+        name: mpls-lse
         type: u32
         byte-order: big-endian
         doc: |
           MPLS label stack entry to push
       -
-        name: ethertype
+        name: mpls-ethertype
         type: u32
         byte-order: big-endian
         doc: |
@@ -216,13 +219,13 @@ definitions:
     type: struct
     members:
       -
-        name: lse
+        name: mpls-lse
         type: u32
         byte-order: big-endian
         doc: |
           MPLS label stack entry to push
       -
-        name: ethertype
+        name: mpls-ethertype
         type: u32
         byte-order: big-endian
         doc: |
@@ -237,6 +240,7 @@ definitions:
   -
     name: ct-state-flags
     type: flags
+    name-prefix: ovs-cs-f-
     entries:
       -
         name: new
@@ -266,6 +270,8 @@ definitions:
 attribute-sets:
   -
     name: flow-attrs
+    enum-name: ovs-flow-attr
+    name-prefix: ovs-flow-attr-
     attributes:
       -
         name: key
@@ -352,6 +358,8 @@ attribute-sets:
 
   -
     name: key-attrs
+    enum-name: ovs-key-attr
+    name-prefix: ovs-key-attr-
     attributes:
       -
         name: encap
@@ -481,6 +489,8 @@ attribute-sets:
         doc: struct ovs_key_ipv6_exthdr
   -
     name: action-attrs
+    enum-name: ovs-action-attr
+    name-prefix: ovs-action-attr-
     attributes:
       -
         name: output
@@ -608,6 +618,8 @@ attribute-sets:
         nested-attributes: dec-ttl-attrs
   -
     name: tunnel-key-attrs
+    enum-name: ovs-tunnel-key-attr
+    name-prefix: ovs-tunnel-key-attr-
     attributes:
       -
         name: id
@@ -676,6 +688,8 @@ attribute-sets:
         type: flag
   -
     name: check-pkt-len-attrs
+    enum-name: ovs-check-pkt-len-attr
+    name-prefix: ovs-check-pkt-len-attr-
     attributes:
       -
         name: pkt-len
@@ -690,6 +704,8 @@ attribute-sets:
         nested-attributes: action-attrs
   -
     name: sample-attrs
+    enum-name: ovs-sample-attr
+    name-prefix: ovs-sample-attr-
     attributes:
       -
         name: probability
@@ -700,6 +716,8 @@ attribute-sets:
         nested-attributes: action-attrs
   -
     name: userspace-attrs
+    enum-name: ovs-userspace-attr
+    name-prefix: ovs-userspace-attr-
     attributes:
       -
         name: pid
@@ -715,6 +733,8 @@ attribute-sets:
         type: flag
   -
     name: ovs-nsh-key-attrs
+    enum-name: ovs-nsh-key-attr
+    name-prefix: ovs-nsh-key-attr-
     attributes:
       -
         name: base
@@ -727,6 +747,8 @@ attribute-sets:
         type: binary
   -
     name: ct-attrs
+    enum-name: ovs-ct-attr
+    name-prefix: ovs-ct-attr-
     attributes:
       -
         name: commit
@@ -758,13 +780,15 @@ attribute-sets:
         type: string
   -
     name: nat-attrs
+    enum-name: ovs-nat-attr
+    name-prefix: ovs-nat-attr-
     attributes:
       -
         name: src
-        type: binary
+        type: flag
       -
         name: dst
-        type: binary
+        type: flag
       -
         name: ip-min
         type: binary
@@ -773,21 +797,23 @@ attribute-sets:
         type: binary
       -
         name: proto-min
-        type: binary
+        type: u16
       -
         name: proto-max
-        type: binary
+        type: u16
       -
         name: persistent
-        type: binary
+        type: flag
       -
         name: proto-hash
-        type: binary
+        type: flag
       -
         name: proto-random
-        type: binary
+        type: flag
   -
     name: dec-ttl-attrs
+    enum-name: ovs-dec-ttl-attr
+    name-prefix: ovs-dec-ttl-attr-
     attributes:
       -
         name: action
@@ -795,16 +821,19 @@ attribute-sets:
         nested-attributes: action-attrs
   -
     name: vxlan-ext-attrs
+    enum-name: ovs-vxlan-ext-
+    name-prefix: ovs-vxlan-ext-
     attributes:
       -
         name: gbp
         type: u32
 
 operations:
+  name-prefix: ovs-flow-cmd-
   fixed-header: ovs-header
   list:
     -
-      name: flow-get
+      name: get
       doc: Get / dump OVS flow configuration and state
       value: 3
       attribute-set: flow-attrs
@@ -824,6 +853,19 @@ operations:
             - stats
             - actions
       dump: *flow-get-op
+    -
+      name: new
+      doc: Create OVS flow configuration in a data path
+      value: 1
+      attribute-set: flow-attrs
+      do:
+        request:
+          attributes:
+            - dp-ifindex
+            - key
+            - ufid
+            - mask
+            - actions
 
 mcast-groups:
   list:
diff --git a/Documentation/netlink/specs/ovs_vport.yaml b/Documentation/netlink/specs/ovs_vport.yaml
index 8e55622ddf11..17336455bec1 100644
--- a/Documentation/netlink/specs/ovs_vport.yaml
+++ b/Documentation/netlink/specs/ovs_vport.yaml
@@ -3,6 +3,7 @@
 name: ovs_vport
 version: 2
 protocol: genetlink-legacy
+uapi-header: linux/openvswitch.h
 
 doc:
   OVS vport configuration over generic netlink.
@@ -18,10 +19,13 @@ definitions:
   -
     name: vport-type
     type: enum
+    enum-name: ovs-vport-type
+    name-prefix: ovs-vport-type-
     entries: [ unspec, netdev, internal, gre, vxlan, geneve ]
   -
     name: vport-stats
     type: struct
+    enum-name: ovs-vport-stats
     members:
       -
         name: rx-packets
@@ -51,6 +55,8 @@ definitions:
 attribute-sets:
   -
     name: vport-options
+    enum-name: ovs-vport-options
+    name-prefix: ovs-tunnel-attr-
     attributes:
       -
         name: dst-port
@@ -60,6 +66,8 @@ attribute-sets:
         type: u32
   -
     name: upcall-stats
+    enum-name: ovs-vport-upcall-attr
+    name-prefix: ovs-vport-upcall-attr-
     attributes:
       -
         name: success
@@ -70,6 +78,8 @@ attribute-sets:
         type: u64
   -
     name: vport
+    name-prefix: ovs-vport-attr-
+    enum-name: ovs-vport-attr
     attributes:
       -
         name: port-no
@@ -108,9 +118,10 @@ attribute-sets:
         nested-attributes: upcall-stats
 
 operations:
+  name-prefix: ovs-vport-cmd-
   list:
     -
-      name: vport-get
+      name: get
       doc: Get / dump OVS vport configuration and state
       value: 3
       attribute-set: vport
-- 
2.39.0



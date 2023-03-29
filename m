Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB276CF640
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 00:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbjC2WRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 18:17:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjC2WRD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 18:17:03 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40842524E
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 15:17:01 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id q8-20020a17090ad38800b0023f116f305bso8304990pju.0
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 15:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680128220;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=d9jeOHXn5gSUtGEg/ClhXgseRumtjKP7q5fC/81ff+M=;
        b=JU3NaeLua0kRdJ5I2a/izYPf7/BCMAxR8qfyBr9HPYGMO/4B/4yV95qAdbI7l2247s
         MFe45BF1HJCZk8kO7j/Hz/CGkK/+obmD/D6o2QjoDy106rfZJaQjvLlREU4oge4ikgW3
         VLZHNm6wIRhopHLR9D5a9d6JHti7EBgWMdSC39bVzKsO5uYvwljmxvTtiTUOxd8IGOpL
         5LZFpSelLnaCSvdX8nK2wEAaKL8Eomw9ryK5b6f1p2B3tags2gnahH9v1gAP/M2A6yOg
         ifnU6ZmIsWIZV4qb7c7xIcAfK8U0/KkdpiUWcUI558QGdhZzpd4LqJttxYBS+3c+qROu
         jqzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680128220;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d9jeOHXn5gSUtGEg/ClhXgseRumtjKP7q5fC/81ff+M=;
        b=BNEh+NONe+PtR4BnbL8m25pqjME0eoUY9CR4xB8u/f6V0NvE72FtGZQIpKvAjNNHoo
         sDo+ZciUovqWjFNIiWQJ0VgWKAe61+VmC4YwIcuh6KiJ5NxYVmXBkmayTwDaXjR2IM+U
         rQPL3Yos6v6ElvTig/kppAs4vLUvDjZncH/bmA+DhttEaqrvb9vCYuRfhrTDb/r7Q5Ut
         bXO8mtioMpfSyU8xxJvhJL6Es4Aml3fA4qhomcQMYmi5MyobZ5hcY2P+L0HdGAjmNVme
         jedfYdgeIzoVNHBIizjNAwuFrXgKny9YtsBwfqxTM/0sHTcsMnLx0fiqh7Q6tRPdwDn+
         /Evg==
X-Gm-Message-State: AAQBX9csYaWGWMYV4N7ih7sEwOpBdBrIRy944mxpDbr5KjZxhzBLMUbO
        uiBbx+fn0YwUeRie1nzaqVdC73Fm4iJHOceaQEmCC9tX7mAdawbOR48OmVihyjEMTw1L00NwGJ4
        G3KzMZ5Xwjw2giLUoaZ67Q1tu4G22/PjmxUPnQWMnvZXTqaJZ+gL6DQ==
X-Google-Smtp-Source: AKy350aA7hTs0hJ3kls9q8rU5lEW6RuxfpfWWOnUl7RStBZ8y8wY1CAhDCKr2+Tg7XAeZ83QMoWN0Yo=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a05:6a00:2443:b0:627:9d8a:a29c with SMTP id
 d3-20020a056a00244300b006279d8aa29cmr10175443pfj.2.1680128220501; Wed, 29 Mar
 2023 15:17:00 -0700 (PDT)
Date:   Wed, 29 Mar 2023 15:16:53 -0700
In-Reply-To: <20230329221655.708489-1-sdf@google.com>
Mime-Version: 1.0
References: <20230329221655.708489-1-sdf@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230329221655.708489-3-sdf@google.com>
Subject: [PATCH net-next v3 2/4] tools: ynl: populate most of the ethtool spec
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Things that are not implemented:
- cable tests
- bitmaks in the requests don't work (needs multi-attr support in ynl.py)
- stats-get seems to return nonsense (not passing a bitmask properly?)
- notifications are not tested

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 Documentation/netlink/specs/ethtool.yaml | 1480 ++++++++++++++++++++--
 1 file changed, 1367 insertions(+), 113 deletions(-)

diff --git a/Documentation/netlink/specs/ethtool.yaml b/Documentation/netlink/specs/ethtool.yaml
index 6d8ae3d9a680..129f413ea349 100644
--- a/Documentation/netlink/specs/ethtool.yaml
+++ b/Documentation/netlink/specs/ethtool.yaml
@@ -6,6 +6,12 @@ protocol: genetlink-legacy
 
 doc: Partial family for Ethtool Netlink.
 
+definitions:
+  -
+    name: udp-tunnel-type
+    type: enum
+    entries: [ vxlan, geneve, vxlan-gpe ]
+
 attribute-sets:
   -
     name: header
@@ -38,6 +44,7 @@ doc: Partial family for Ethtool Netlink.
       -
         name: bit
         type: nest
+        multi-attr: true
         nested-attributes: bitset-bit
   -
     name: bitset
@@ -53,6 +60,22 @@ doc: Partial family for Ethtool Netlink.
         type: nest
         nested-attributes: bitset-bits
 
+  -
+    name: u64-array
+    attributes:
+      -
+        name: u64
+        type: nest
+        multi-attr: true
+        nested-attributes: u64
+  -
+    name: s32-array
+    attributes:
+      -
+        name: s32
+        type: nest
+        multi-attr: true
+        nested-attributes: s32
   -
     name: string
     attributes:
@@ -234,118 +257,1351 @@ doc: Partial family for Ethtool Netlink.
         name: stats
         type: nest
         nested-attributes: mm-stat
+  -
+    name: linkinfo
+    attributes:
+      -
+        name: header
+        type: nest
+        nested-attributes: header
+      -
+        name: port
+        type: u8
+      -
+        name: phyaddr
+        type: u8
+      -
+        name: tp-mdix
+        type: u8
+      -
+        name: tp-mdix-ctrl
+        type: u8
+      -
+        name: transceiver
+        type: u8
+  -
+    name: linkmodes
+    attributes:
+      -
+        name: header
+        type: nest
+        nested-attributes: header
+      -
+        name: autoneg
+        type: u8
+      -
+        name: ours
+        type: nest
+        nested-attributes: bitset
+      -
+        name: peer
+        type: nest
+        nested-attributes: bitset
+      -
+        name: speed
+        type: u32
+      -
+        name: duplex
+        type: u8
+      -
+        name: master-slave-cfg
+        type: u8
+      -
+        name: master-slave-state
+        type: u8
+      -
+        name: master-slave-lanes
+        type: u32
+      -
+        name: rate-matching
+        type: u8
+  -
+    name: linkstate
+    attributes:
+      -
+        name: header
+        type: nest
+        nested-attributes: header
+      -
+        name: link
+        type: u8
+      -
+        name: sqi
+        type: u32
+      -
+        name: sqi-max
+        type: u32
+      -
+        name: ext-state
+        type: u8
+      -
+        name: ext-substate
+        type: u8
+      -
+        name: down-cnt
+        type: u32
+  -
+    name: debug
+    attributes:
+      -
+        name: header
+        type: nest
+        nested-attributes: header
+      -
+        name: msgmask
+        type: nest
+        nested-attributes: bitset
+  -
+    name: wol
+    attributes:
+      -
+        name: header
+        type: nest
+        nested-attributes: header
+      -
+        name: modes
+        type: nest
+        nested-attributes: bitset
+      -
+        name: sopass
+        type: binary
+  -
+    name: features
+    attributes:
+      -
+        name: header
+        type: nest
+        nested-attributes: header
+      -
+        name: hw
+        type: nest
+        nested-attributes: bitset
+      -
+        name: wanted
+        type: nest
+        nested-attributes: bitset
+      -
+        name: active
+        type: nest
+        nested-attributes: bitset
+      -
+        name: nochange
+        type: nest
+        nested-attributes: bitset
+  -
+    name: channels
+    attributes:
+      -
+        name: header
+        type: nest
+        nested-attributes: header
+      -
+        name: rx-max
+        type: u32
+      -
+        name: tx-max
+        type: u32
+      -
+        name: other-max
+        type: u32
+      -
+        name: combined-max
+        type: u32
+      -
+        name: rx-count
+        type: u32
+      -
+        name: tx-count
+        type: u32
+      -
+        name: other-count
+        type: u32
+      -
+        name: combined-count
+        type: u32
 
-operations:
-  enum-model: directional
-  list:
-    -
-      name: strset-get
-      doc: Get string set from the kernel.
-
-      attribute-set: strset
-
-      do: &strset-get-op
-        request:
-          attributes:
-            - header
-            - stringsets
-            - counts-only
-        reply:
-          attributes:
-            - header
-            - stringsets
-      dump: *strset-get-op
-
-    # TODO: fill in the requests in between
-
-    -
-      name: privflags-get
-      doc: Get device private flags.
-
-      attribute-set: privflags
-
-      do: &privflag-get-op
-        request:
-          value: 13
-          attributes:
-            - header
-        reply:
-          value: 14
-          attributes:
-            - header
-            - flags
-      dump: *privflag-get-op
-    -
-      name: privflags-set
-      doc: Set device private flags.
-
-      attribute-set: privflags
-
-      do:
-        request:
-          attributes:
-            - header
-            - flags
-    -
-      name: privflags-ntf
-      doc: Notification for change in device private flags.
-      notify: privflags-get
-
-    -
-      name: rings-get
-      doc: Get ring params.
-
-      attribute-set: rings
-
-      do: &ring-get-op
-        request:
-          attributes:
-            - header
-        reply:
-          attributes:
-            - header
-            - rx-max
-            - rx-mini-max
-            - rx-jumbo-max
-            - tx-max
-            - rx
-            - rx-mini
-            - rx-jumbo
-            - tx
-            - rx-buf-len
-            - tcp-data-split
-            - cqe-size
-            - tx-push
-            - rx-push
-            - tx-push-buf-len
-            - tx-push-buf-len-max
-      dump: *ring-get-op
-    -
-      name: rings-set
-      doc: Set ring params.
-
-      attribute-set: rings
-
-      do:
-        request:
-          attributes:
-            - header
-            - rx
-            - rx-mini
-            - rx-jumbo
-            - tx
-            - rx-buf-len
-            - tcp-data-split
-            - cqe-size
-            - tx-push
-            - rx-push
-    -
-      name: rings-ntf
-      doc: Notification for change in ring params.
-      notify: rings-get
-
-    # TODO: fill in the requests in between
-
+  -
+    name: coalesce
+    attributes:
+      -
+        name: header
+        type: nest
+        nested-attributes: header
+      -
+        name: rx-usecs
+        type: u32
+      -
+        name: rx-max-frames
+        type: u32
+      -
+        name: rx-usecs-irq
+        type: u32
+      -
+        name: rx-max-frames-irq
+        type: u32
+      -
+        name: tx-usecs
+        type: u32
+      -
+        name: tx-max-frames
+        type: u32
+      -
+        name: tx-usecs-irq
+        type: u32
+      -
+        name: tx-max-frames-irq
+        type: u32
+      -
+        name: stats-block-usecs
+        type: u32
+      -
+        name: use-adaptive-rx
+        type: u8
+      -
+        name: use-adaptive-tx
+        type: u8
+      -
+        name: pkt-rate-low
+        type: u32
+      -
+        name: rx-usecs-low
+        type: u32
+      -
+        name: rx-max-frames-low
+        type: u32
+      -
+        name: tx-usecs-low
+        type: u32
+      -
+        name: tx-max-frames-low
+        type: u32
+      -
+        name: pkt-rate-high
+        type: u32
+      -
+        name: rx-usecs-high
+        type: u32
+      -
+        name: rx-max-frames-high
+        type: u32
+      -
+        name: tx-usecs-high
+        type: u32
+      -
+        name: tx-max-frames-high
+        type: u32
+      -
+        name: rate-sample-interval
+        type: u32
+      -
+        name: use-cqe-mode-tx
+        type: u8
+      -
+        name: use-cqe-mode-rx
+        type: u8
+      -
+        name: tx-aggr-max-bytes
+        type: u32
+      -
+        name: tx-aggr-max-frames
+        type: u32
+      -
+        name: tx-aggr-time-usecs
+        type: u32
+  -
+    name: pause-stat
+    attributes:
+      -
+        name: pad
+        type: u32
+      -
+        name: tx-frames
+        type: u64
+      -
+        name: rx-frames
+        type: u64
+  -
+    name: pause
+    attributes:
+      -
+        name: header
+        type: nest
+        nested-attributes: header
+      -
+        name: autoneg
+        type: u8
+      -
+        name: rx
+        type: u8
+      -
+        name: tx
+        type: u8
+      -
+        name: stats
+        type: nest
+        nested-attributes: pause-stat
+      -
+        name: stats-src
+        type: u32
+  -
+    name: eee
+    attributes:
+      -
+        name: header
+        type: nest
+        nested-attributes: header
+      -
+        name: modes-ours
+        type: nest
+        nested-attributes: bitset
+      -
+        name: modes-peer
+        type: nest
+        nested-attributes: bitset
+      -
+        name: active
+        type: u8
+      -
+        name: enabled
+        type: u8
+      -
+        name: tx-lpi-enabled
+        type: u8
+      -
+        name: tx-lpi-timer
+        type: u32
+  -
+    name: tsinfo
+    attributes:
+      -
+        name: header
+        type: nest
+        nested-attributes: header
+      -
+        name: timestamping
+        type: nest
+        nested-attributes: bitset
+      -
+        name: tx-types
+        type: nest
+        nested-attributes: bitset
+      -
+        name: rx-filters
+        type: nest
+        nested-attributes: bitset
+      -
+        name: phc-index
+        type: u32
+  -
+    name: cable-test-nft-nest-result
+    attributes:
+      -
+        name: pair
+        type: u8
+      -
+        name: code
+        type: u8
+  -
+    name: cable-test-nft-nest-fault-length
+    attributes:
+      -
+        name: pair
+        type: u8
+      -
+        name: cm
+        type: u32
+  -
+    name: cable-test-nft-nest
+    attributes:
+      -
+        name: result
+        type: nest
+        nested-attributes: cable-test-nft-nest-result
+      -
+        name: fault-length
+        type: nest
+        nested-attributes: cable-test-nft-nest-fault-length
+  -
+    name: cable-test
+    attributes:
+      -
+        name: header
+        type: nest
+        nested-attributes: header
+      -
+        name: status
+        type: u8
+      -
+        name: nest
+        type: nest
+        nested-attributes: cable-test-nft-nest
+  -
+    name: cable-test-tdr-cfg
+    attributes:
+      -
+        name: first
+        type: u32
+      -
+        name: last
+        type: u32
+      -
+        name: step
+        type: u32
+      -
+        name: pari
+        type: u8
+  -
+    name: cable-test-tdr
+    attributes:
+      -
+        name: header
+        type: nest
+        nested-attributes: header
+      -
+        name: cfg
+        type: nest
+        nested-attributes: cable-test-tdr-cfg
+  -
+    name: tunnel-info-udp-entry
+    attributes:
+      -
+        name: port
+        type: u16
+        byte-order: big-endian
+      -
+        name: type
+        type: u32
+        enum: udp-tunnel-type
+  -
+    name: tunnel-info-udp-table
+    attributes:
+      -
+        name: size
+        type: u32
+      -
+        name: types
+        type: nest
+        nested-attributes: bitset
+      -
+        name: udp-ports
+        type: nest
+        nested-attributes: tunnel-info-udp-entry
+  -
+    name: tunnel-info
+    attributes:
+      -
+        name: header
+        type: nest
+        nested-attributes: header
+      -
+        name: udp-ports
+        type: nest
+        nested-attributes: tunnel-info-udp-table
+  -
+    name: fec-stat
+    attributes:
+      -
+        name: pad
+        type: u8
+      -
+        name: corrected
+        type: nest
+        nested-attributes: u64-array
+      -
+        name: uncorr
+        type: nest
+        nested-attributes: u64-array
+      -
+        name: corr-bits
+        type: nest
+        nested-attributes: u64-array
+  -
+    name: fec
+    attributes:
+      -
+        name: header
+        type: nest
+        nested-attributes: header
+      -
+        name: modes
+        type: nest
+        nested-attributes: bitset
+      -
+        name: auto
+        type: u8
+      -
+        name: active
+        type: u32
+      -
+        name: stats
+        type: nest
+        nested-attributes: fec-stat
+  -
+    name: module-eeprom
+    attributes:
+      -
+        name: header
+        type: nest
+        nested-attributes: header
+      -
+        name: offset
+        type: u32
+      -
+        name: length
+        type: u32
+      -
+        name: page
+        type: u8
+      -
+        name: bank
+        type: u8
+      -
+        name: i2c-address
+        type: u8
+      -
+        name: data
+        type: binary
+  -
+    name: stats-grp
+    attributes:
+      -
+        name: pad
+        type: u32
+      -
+        name: id
+        type: u32
+      -
+        name: ss-id
+        type: u32
+      -
+        name: stat
+        type: nest
+        nested-attributes: u64
+      -
+        name: hist-rx
+        type: nest
+        nested-attributes: u64
+      -
+        name: hist-tx
+        type: nest
+        nested-attributes: u64
+      -
+        name: hist-bkt-low
+        type: u32
+      -
+        name: hist-bkt-hi
+        type: u32
+      -
+        name: hist-bkt-val
+        type: u64
+  -
+    name: stats
+    attributes:
+      -
+        name: pad
+        type: u32
+      -
+        name: header
+        type: nest
+        nested-attributes: header
+      -
+        name: groups
+        type: nest
+        nested-attributes: bitset
+      -
+        name: grp
+        type: nest
+        nested-attributes: stats-grp
+      -
+        name: src
+        type: u32
+  -
+    name: phc-vclocks
+    attributes:
+      -
+        name: header
+        type: nest
+        nested-attributes: header
+      -
+        name: num
+        type: u32
+      -
+        name: index
+        type: nest
+        nested-attributes: s32-array
+  -
+    name: module
+    attributes:
+      -
+        name: header
+        type: nest
+        nested-attributes: header
+      -
+        name: power-mode-policy
+        type: u8
+      -
+        name: power-mode
+        type: u8
+  -
+    name: pse
+    attributes:
+      -
+        name: header
+        type: nest
+        nested-attributes: header
+      -
+        name: admin-state
+        type: u32
+      -
+        name: admin-control
+        type: u32
+      -
+        name: pw-d-status
+        type: u32
+  -
+    name: rss
+    attributes:
+      -
+        name: header
+        type: nest
+        nested-attributes: header
+      -
+        name: context
+        type: u32
+      -
+        name: hfunc
+        type: u32
+      -
+        name: indir
+        type: binary
+      -
+        name: hkey
+        type: binary
+  -
+    name: plca
+    attributes:
+      -
+        name: header
+        type: nest
+        nested-attributes: header
+      -
+        name: version
+        type: u16
+      -
+        name: enabled
+        type: u8
+      -
+        name: status
+        type: u8
+      -
+        name: node-cnt
+        type: u32
+      -
+        name: node-id
+        type: u32
+      -
+        name: to-tmr
+        type: u32
+      -
+        name: burst-cnt
+        type: u32
+      -
+        name: burst-tmr
+        type: u32
+
+operations:
+  enum-model: directional
+  list:
+    -
+      name: strset-get
+      doc: Get string set from the kernel.
+
+      attribute-set: strset
+
+      do: &strset-get-op
+        request:
+          attributes:
+            - header
+            - stringsets
+            - counts-only
+        reply:
+          attributes:
+            - header
+            - stringsets
+      dump: *strset-get-op
+    -
+      name: linkinfo-get
+      doc: Get link info.
+
+      attribute-set: linkinfo
+
+      do: &linkinfo-get-op
+        request:
+          attributes:
+            - header
+        reply:
+          attributes: &linkinfo
+            - header
+            - port
+            - phyaddr
+            - tp-mdix
+            - tp-mdix-ctrl
+            - transceiver
+      dump: *linkinfo-get-op
+    -
+      name: linkinfo-set
+      doc: Set link info.
+
+      attribute-set: linkinfo
+
+      do:
+        request:
+          attributes: *linkinfo
+    -
+      name: linkinfo-ntf
+      doc: Notification for change in link info.
+      notify: linkinfo-get
+    -
+      name: linkmodes-get
+      doc: Get link modes.
+
+      attribute-set: linkmodes
+
+      do: &linkmodes-get-op
+        request:
+          attributes:
+            - header
+        reply:
+          attributes: &linkmodes
+            - header
+            - autoneg
+            - ours
+            - peer
+            - speed
+            - duplex
+            - master-slave-cfg
+            - master-slave-state
+            - master-slave-lanes
+            - rate-matching
+      dump: *linkmodes-get-op
+    -
+      name: linkmodes-set
+      doc: Set link modes.
+
+      attribute-set: linkmodes
+
+      do:
+        request:
+          attributes: *linkmodes
+    -
+      name: linkmodes-ntf
+      doc: Notification for change in link modes.
+      notify: linkmodes-get
+    -
+      name: linkstate-get
+      doc: Get link state.
+
+      attribute-set: linkstate
+
+      do: &linkstate-get-op
+        request:
+          attributes:
+            - header
+        reply:
+          attributes:
+            - header
+            - link
+            - sqi
+            - sqi-max
+            - ext-state
+            - ext-substate
+            - down-cnt
+      dump: *linkstate-get-op
+    -
+      name: debug-get
+      doc: Get debug message mask.
+
+      attribute-set: debug
+
+      do: &debug-get-op
+        request:
+          attributes:
+            - header
+        reply:
+          attributes: &debug
+            - header
+            - msgmask
+      dump: *debug-get-op
+    -
+      name: debug-set
+      doc: Set debug message mask.
+
+      attribute-set: debug
+
+      do:
+        request:
+          attributes: *debug
+    -
+      name: debug-ntf
+      doc: Notification for change in debug message mask.
+      notify: debug-get
+    -
+      name: wol-get
+      doc: Get WOL params.
+
+      attribute-set: wol
+
+      do: &wol-get-op
+        request:
+          attributes:
+            - header
+        reply:
+          attributes: &wol
+            - header
+            - modes
+            - sopass
+      dump: *wol-get-op
+    -
+      name: wol-set
+      doc: Set WOL params.
+
+      attribute-set: wol
+
+      do:
+        request:
+          attributes: *wol
+    -
+      name: wol-ntf
+      doc: Notification for change in WOL params.
+      notify: wol-get
+    -
+      name: features-get
+      doc: Get features.
+
+      attribute-set: features
+
+      do: &feature-get-op
+        request:
+          attributes:
+            - header
+        reply:
+          attributes: &feature
+            - header
+            # User-changeable features.
+            - hw
+            # User-requested features.
+            - wanted
+            # Currently active features.
+            - active
+            # Unchangeable features.
+            - nochange
+      dump: *feature-get-op
+    -
+      name: features-set
+      doc: Set features.
+
+      attribute-set: features
+
+      do: &feature-set-op
+        request:
+          attributes: *feature
+        reply:
+          attributes: *feature
+    -
+      name: features-ntf
+      doc: Notification for change in features.
+      notify: features-get
+    -
+      name: privflags-get
+      doc: Get device private flags.
+
+      attribute-set: privflags
+
+      do: &privflag-get-op
+        request:
+          attributes:
+            - header
+        reply:
+          attributes: &privflag
+            - header
+            - flags
+      dump: *privflag-get-op
+    -
+      name: privflags-set
+      doc: Set device private flags.
+
+      attribute-set: privflags
+
+      do:
+        request:
+          attributes: *privflag
+    -
+      name: privflags-ntf
+      doc: Notification for change in device private flags.
+      notify: privflags-get
+
+    -
+      name: rings-get
+      doc: Get ring params.
+
+      attribute-set: rings
+
+      do: &ring-get-op
+        request:
+          attributes:
+            - header
+        reply:
+          attributes: &ring
+            - header
+            - rx-max
+            - rx-mini-max
+            - rx-jumbo-max
+            - tx-max
+            - rx
+            - rx-mini
+            - rx-jumbo
+            - tx
+            - rx-buf-len
+            - tcp-data-split
+            - cqe-size
+            - tx-push
+            - rx-push
+            - tx-push-buf-len
+            - tx-push-buf-len-max
+      dump: *ring-get-op
+    -
+      name: rings-set
+      doc: Set ring params.
+
+      attribute-set: rings
+
+      do:
+        request:
+          attributes: *ring
+    -
+      name: rings-ntf
+      doc: Notification for change in ring params.
+      notify: rings-get
+    -
+      name: channels-get
+      doc: Get channel params.
+
+      attribute-set: channels
+
+      do: &channel-get-op
+        request:
+          attributes:
+            - header
+        reply:
+          attributes: &channel
+            - header
+            - rx-max
+            - tx-max
+            - other-max
+            - combined-max
+            - rx-count
+            - tx-count
+            - other-count
+            - combined-count
+      dump: *channel-get-op
+    -
+      name: channels-set
+      doc: Set channel params.
+
+      attribute-set: channels
+
+      do:
+        request:
+          attributes: *channel
+    -
+      name: channels-ntf
+      doc: Notification for change in channel params.
+      notify: channels-get
+    -
+      name: coalesce-get
+      doc: Get coalesce params.
+
+      attribute-set: coalesce
+
+      do: &coalesce-get-op
+        request:
+          attributes:
+            - header
+        reply:
+          attributes: &coalesce
+            - header
+            - rx-usecs
+            - rx-max-frames
+            - rx-usecs-irq
+            - rx-max-frames-irq
+            - tx-usecs
+            - tx-max-frames
+            - tx-usecs-irq
+            - tx-max-frames-irq
+            - stats-block-usecs
+            - use-adaptive-rx
+            - use-adaptive-tx
+            - pkt-rate-low
+            - rx-usecs-low
+            - rx-max-frames-low
+            - tx-usecs-low
+            - tx-max-frames-low
+            - pkt-rate-high
+            - rx-usecs-high
+            - rx-max-frames-high
+            - tx-usecs-high
+            - tx-max-frames-high
+            - rate-sample-interval
+            - use-cqe-mode-tx
+            - use-cqe-mode-rx
+            - tx-aggr-max-bytes
+            - tx-aggr-max-frames
+            - tx-aggr-time-usecs
+      dump: *coalesce-get-op
+    -
+      name: coalesce-set
+      doc: Set coalesce params.
+
+      attribute-set: coalesce
+
+      do:
+        request:
+          attributes: *coalesce
+    -
+      name: coalesce-ntf
+      doc: Notification for change in coalesce params.
+      notify: coalesce-get
+    -
+      name: pause-get
+      doc: Get pause params.
+
+      attribute-set: pause
+
+      do: &pause-get-op
+        request:
+          attributes:
+            - header
+        reply:
+          attributes: &pause
+            - header
+            - autoneg
+            - rx
+            - tx
+            - stats
+            - stats-src
+      dump: *pause-get-op
+    -
+      name: pause-set
+      doc: Set pause params.
+
+      attribute-set: pause
+
+      do:
+        request:
+          attributes: *pause
+    -
+      name: pause-ntf
+      doc: Notification for change in pause params.
+      notify: pause-get
+    -
+      name: eee-get
+      doc: Get eee params.
+
+      attribute-set: eee
+
+      do: &eee-get-op
+        request:
+          attributes:
+            - header
+        reply:
+          attributes: &eee
+            - header
+            - modes-ours
+            - modes-peer
+            - active
+            - enabled
+            - tx-lpi-enabled
+            - tx-lpi-timer
+      dump: *eee-get-op
+    -
+      name: eee-set
+      doc: Set eee params.
+
+      attribute-set: eee
+
+      do:
+        request:
+          attributes: *eee
+    -
+      name: eee-ntf
+      doc: Notification for change in eee params.
+      notify: eee-get
+    -
+      name: tsinfo-get
+      doc: Get tsinfo params.
+
+      attribute-set: tsinfo
+
+      do: &tsinfo-get-op
+        request:
+          attributes:
+            - header
+        reply:
+          attributes:
+            - header
+            - timestamping
+            - tx-types
+            - rx-filters
+            - phc-index
+      dump: *tsinfo-get-op
+    -
+      name: cable-test-act
+      doc: Cable test.
+
+      attribute-set: cable-test
+
+      do:
+        request:
+          attributes:
+            - header
+        reply:
+          attributes:
+            - header
+            - cable-test-nft-nest
+    -
+      name: cable-test-tdr-act
+      doc: Cable test TDR.
+
+      attribute-set: cable-test-tdr
+
+      do:
+        request:
+          attributes:
+            - header
+        reply:
+          attributes:
+            - header
+            - cable-test-tdr-cfg
+    -
+      name: tunnel-info-get
+      doc: Get tsinfo params.
+
+      attribute-set: tunnel-info
+
+      do: &tunnel-info-get-op
+        request:
+          attributes:
+            - header
+        reply:
+          attributes:
+            - header
+            - udp-ports
+      dump: *tunnel-info-get-op
+    -
+      name: fec-get
+      doc: Get FEC params.
+
+      attribute-set: fec
+
+      do: &fec-get-op
+        request:
+          attributes:
+            - header
+        reply:
+          attributes: &fec
+            - header
+            - modes
+            - auto
+            - active
+            - stats
+      dump: *fec-get-op
+    -
+      name: fec-set
+      doc: Set FEC params.
+
+      attribute-set: fec
+
+      do:
+        request:
+          attributes: *fec
+    -
+      name: fec-ntf
+      doc: Notification for change in FEC params.
+      notify: fec-get
+    -
+      name: module-eeprom-get
+      doc: Get module EEPROM params.
+
+      attribute-set: module-eeprom
+
+      do: &module-eeprom-get-op
+        request:
+          attributes:
+            - header
+        reply:
+          attributes:
+            - header
+            - offset
+            - length
+            - page
+            - bank
+            - i2c-address
+            - data
+      dump: *module-eeprom-get-op
+    -
+      name: stats-get
+      doc: Get statistics.
+
+      attribute-set: stats
+
+      do: &stats-get-op
+        request:
+          attributes:
+            - header
+            - groups
+        reply:
+          attributes:
+            - header
+            - groups
+            - grp
+            - src
+      dump: *stats-get-op
+    -
+      name: phc-vclocks-get
+      doc: Get PHC VCLOCKs.
+
+      attribute-set: phc-vclocks
+
+      do: &phc-vclocks-get-op
+        request:
+          attributes:
+            - header
+        reply:
+          attributes:
+            - header
+            - num
+      dump: *phc-vclocks-get-op
+    -
+      name: module-get
+      doc: Get module params.
+
+      attribute-set: module
+
+      do: &module-get-op
+        request:
+          attributes:
+            - header
+        reply:
+          attributes: &module
+            - header
+            - power-mode-policy
+            - power-mode
+      dump: *module-get-op
+    -
+      name: module-set
+      doc: Set module params.
+
+      attribute-set: module
+
+      do:
+        request:
+          attributes: *module
+    -
+      name: module-ntf
+      doc: Notification for change in module params.
+      notify: module-get
+    -
+      name: pse-get
+      doc: Get Power Sourcing Equipment params.
+
+      attribute-set: pse
+
+      do: &pse-get-op
+        request:
+          attributes:
+            - header
+        reply:
+          attributes: &pse
+            - header
+            - admin-state
+            - admin-control
+            - pw-d-status
+      dump: *pse-get-op
+    -
+      name: pse-set
+      doc: Set Power Sourcing Equipment params.
+
+      attribute-set: pse
+
+      do:
+        request:
+          attributes: *pse
+    -
+      name: rss-get
+      doc: Get RSS params.
+
+      attribute-set: rss
+
+      do: &rss-get-op
+        request:
+          attributes:
+            - header
+        reply:
+          attributes:
+            - header
+            - context
+            - hfunc
+            - indir
+            - hkey
+      dump: *rss-get-op
+    -
+      name: plca-get
+      doc: Get PLCA params.
+
+      attribute-set: plca
+
+      do: &plca-get-op
+        request:
+          attributes:
+            - header
+        reply:
+          attributes: &plca
+            - header
+            - version
+            - enabled
+            - status
+            - node-cnt
+            - node-id
+            - to-tmr
+            - burst-cnt
+            - burst-tmr
+      dump: *plca-get-op
+    -
+      name: plca-set
+      doc: Set PLCA params.
+
+      attribute-set: plca
+
+      do:
+        request:
+          attributes: *plca
+    -
+      name: plca-get-status
+      doc: Get PLCA status params.
+
+      attribute-set: plca
+
+      do: &plca-get-status-op
+        request:
+          attributes:
+            - header
+        reply:
+          attributes: *plca
+      dump: *plca-get-status-op
+    -
+      name: plca-ntf
+      doc: Notification for change in PLCA params.
+      notify: plca-get
     -
       name: mm-get
       doc: Get MAC Merge configuration and state
@@ -354,11 +1610,9 @@ doc: Partial family for Ethtool Netlink.
 
       do: &mm-get-op
         request:
-          value: 42
           attributes:
             - header
         reply:
-          value: 42
           attributes:
             - header
             - pmac-enabled
-- 
2.40.0.348.gf938b09366-goog


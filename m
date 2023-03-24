Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEE4E6C88A4
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 23:57:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbjCXW5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 18:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231855AbjCXW5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 18:57:05 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D1E1B2DF
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 15:57:02 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id e14-20020a056a00162e00b0062804a7a79bso1645757pfc.23
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 15:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679698622;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gZQeS+BSHYt6SBlWAG9VCfthTAtU4XqLqss8ZJJhtG8=;
        b=imrSWffrDVy8GpTho0YmPuH+LstPXpfRU0Eu+xqNvrX7XeYRyK6bIPGDLGu9CYBkA0
         7rkqIStT0aKzM3FB2qbRrjD4+Ms0AB5PWkOD2+NuJdRSygDT3EKGz5iT7CtyEaDX6d6Q
         Js5h9nE/0EPBk3IDLWdHKNH593qGVG0uwdMkxUbKfkkNIhX2Z/Wwyx5Iwron+m7Lv909
         gF8WOKYpJmJIbSHSDvKUfdf2VRNC7UqTXqsMlGWSYFHhC0c/jd22Gh4wB18JJyrYfSRW
         dJopsnBALvkslEzgPlmJVUwMqiXeaDQtTaTARYK33VaD0VxuAn8lY8hKUsIqmuXN5Lxs
         i8lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679698622;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gZQeS+BSHYt6SBlWAG9VCfthTAtU4XqLqss8ZJJhtG8=;
        b=vrF4hKo+vfwhMBqu0fHaFWydH46E0cI/DwIBx70GU/HEeLUCr18+iZ11TtI9j4rRoa
         6bx/dn8uih4tSpUfFqinOe0SHGs6hVNbaoWK+o70Sq5EYQNFfwi1tQ1iftIMCjZ3XU7c
         rZbIujThHwn/6fWn3+0+GfhKPGABvwMaqU7BqweEmhYoNOeFRgjEgR+68G3G7n5RQLqc
         pUBlLfKnqTqsKlDMfrSE4yGjhb2FB5CjrisYWmGJGmfw4/amhyserDMSzpYtpZCTJduY
         j2KWIdV53uInMrnPvzPeI12OsrPPycAn1Mj5HgCLiAVKn3Xe3bDzzjFcXmJYNQusIYk3
         AGQg==
X-Gm-Message-State: AAQBX9e0W+18DQseQrxk4m/89tB5blrJg1/fYJ0oQteJOC9bfgfEk1Kl
        0vlhRhn2B8MmJM75xSnL79CxLs5HVgdV8z1LhyLtWwjZkX5J1sr4p8a25ZbPB7+ZylaIPExLOvt
        VHk/jAaARlmwLHEs6+2xzJNjwgm4aoiWsg22Pq5OyscMHiQZmtnrE5g==
X-Google-Smtp-Source: AKy350ZKImPG+4/Vd9XIk0Czw1usm0Uq3+jNGsxhsN0OugkoCkS6Hs5BpLGOBrfmlBXDid588+wZeIg=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:902:7484:b0:1a1:fd0d:1bb with SMTP id
 h4-20020a170902748400b001a1fd0d01bbmr1411624pll.13.1679698622027; Fri, 24 Mar
 2023 15:57:02 -0700 (PDT)
Date:   Fri, 24 Mar 2023 15:56:54 -0700
In-Reply-To: <20230324225656.3999785-1-sdf@google.com>
Mime-Version: 1.0
References: <20230324225656.3999785-1-sdf@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230324225656.3999785-3-sdf@google.com>
Subject: [PATCH net-next v2 2/4] tools: ynl: populate most of the ethtool spec
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
 Documentation/netlink/specs/ethtool.yaml | 1476 ++++++++++++++++++++--
 1 file changed, 1365 insertions(+), 111 deletions(-)

diff --git a/Documentation/netlink/specs/ethtool.yaml b/Documentation/netlink/specs/ethtool.yaml
index 4727c067e2ba..9dc13bd3a00a 100644
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
@@ -228,116 +251,1349 @@ doc: Partial family for Ethtool Netlink.
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
@@ -346,11 +1602,9 @@ doc: Partial family for Ethtool Netlink.
 
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


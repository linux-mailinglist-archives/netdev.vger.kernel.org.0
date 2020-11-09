Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0FB2AB19D
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 08:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729660AbgKIHJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 02:09:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41057 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729656AbgKIHJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 02:09:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604905764;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=es+GSQz2MU3igYX62Y5g10wVw6Q1DpGz8rOsY1uqmXw=;
        b=EDisNlc0JJMsfINDYDWjguseIQsxB7AKHqZHY4CZiq9Z68y5xUSArRKi8lp+SV8vXy0NlZ
        K4Z+pgX4j0SKsmmfSXV+LDC9itGxVMFQxgFnKgnHDoZG2hlztR7vjILRI+QW4Tol0+zSj6
        RB3lR8RNVJmelglnrhOC4Av2YATG+C4=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-395-c5-Po_DtNlGetsOb8v0ERg-1; Mon, 09 Nov 2020 02:09:22 -0500
X-MC-Unique: c5-Po_DtNlGetsOb8v0ERg-1
Received: by mail-pf1-f197.google.com with SMTP id 64so5855965pfg.9
        for <netdev@vger.kernel.org>; Sun, 08 Nov 2020 23:09:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=es+GSQz2MU3igYX62Y5g10wVw6Q1DpGz8rOsY1uqmXw=;
        b=tFQlzpOL8jWvkLwlHed9TJELL5tfs9LVbXt6jLrtmHCyUT687iS2JTB9ndTMWt6q5Y
         1efiyFSzUGlnbKX4DrL57cxqKvMF+MeSddgHvmmn6LROxuy+lzCFaEbX3QpfwssI4dPR
         w9c4+DcCmP7vPuzqQOhJfcHnBzFG5eyHhOsrIU3GeAmGYejEevEQlklDpdHYuNmoNfYX
         UqS5B7jBMfXwPDJjlKSIf5aPNh4VFTgFFmA5CuVmGfgLlWd5+K1lxvnXBaY3EA0rxdeG
         sWSISZIc900JK1yWNlp018IYbqfR5v7Fd1gSocoG17h/1y/Il9oeJgeLVs5mHCPorlo1
         4lVw==
X-Gm-Message-State: AOAM533HHFuxappqv1uLOw4OO2nCh+cBaepmoeXQmMyelD81lKlKXBSj
        xlFoLSPBZuKwKMlrQju7xq+8TpF9ghnoGTSaXrfNgC2zplyHcGqRoFF9ZX9VLNCV76cO36mq31N
        2KuQMZpF2kqxx8ag=
X-Received: by 2002:a17:90a:f40c:: with SMTP id ch12mr11351645pjb.42.1604905760183;
        Sun, 08 Nov 2020 23:09:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx7AgecKBQFP4+EtCWqZtIkAuW31K5ioYWeUXNIi2Beyhe6A0XZ1XbmStICRNEPZ3JbLYonqA==
X-Received: by 2002:a17:90a:f40c:: with SMTP id ch12mr11351630pjb.42.1604905759954;
        Sun, 08 Nov 2020 23:09:19 -0800 (PST)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f17sm2492483pfk.70.2020.11.08.23.09.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2020 23:09:19 -0800 (PST)
From:   Hangbin Liu <haliu@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Hangbin Liu <haliu@redhat.com>
Subject: [PATCHv4 iproute2-next 4/5] examples/bpf: move struct bpf_elf_map defined maps to legacy folder
Date:   Mon,  9 Nov 2020 15:08:01 +0800
Message-Id: <20201109070802.3638167-5-haliu@redhat.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201109070802.3638167-1-haliu@redhat.com>
References: <20201029151146.3810859-1-haliu@redhat.com>
 <20201109070802.3638167-1-haliu@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Hangbin Liu <haliu@redhat.com>
---
 examples/bpf/README                        | 14 +++++++++-----
 examples/bpf/{ => legacy}/bpf_cyclic.c     |  2 +-
 examples/bpf/{ => legacy}/bpf_graft.c      |  2 +-
 examples/bpf/{ => legacy}/bpf_map_in_map.c |  2 +-
 examples/bpf/{ => legacy}/bpf_shared.c     |  2 +-
 examples/bpf/{ => legacy}/bpf_tailcall.c   |  2 +-
 6 files changed, 14 insertions(+), 10 deletions(-)
 rename examples/bpf/{ => legacy}/bpf_cyclic.c (95%)
 rename examples/bpf/{ => legacy}/bpf_graft.c (97%)
 rename examples/bpf/{ => legacy}/bpf_map_in_map.c (96%)
 rename examples/bpf/{ => legacy}/bpf_shared.c (97%)
 rename examples/bpf/{ => legacy}/bpf_tailcall.c (98%)

diff --git a/examples/bpf/README b/examples/bpf/README
index 1bbdda3f..732bcc83 100644
--- a/examples/bpf/README
+++ b/examples/bpf/README
@@ -1,8 +1,12 @@
 eBPF toy code examples (running in kernel) to familiarize yourself
 with syntax and features:
 
- - bpf_shared.c		-> Ingress/egress map sharing example
- - bpf_tailcall.c	-> Using tail call chains
- - bpf_cyclic.c		-> Simple cycle as tail calls
- - bpf_graft.c		-> Demo on altering runtime behaviour
- - bpf_map_in_map.c     -> Using map in map example
+ - legacy/bpf_shared.c		-> Ingress/egress map sharing example
+ - legacy/bpf_tailcall.c	-> Using tail call chains
+ - legacy/bpf_cyclic.c		-> Simple cycle as tail calls
+ - legacy/bpf_graft.c		-> Demo on altering runtime behaviour
+ - legacy/bpf_map_in_map.c	-> Using map in map example
+
+Note: Users should use new BTF way to defined the maps, the examples
+in legacy folder which is using struct bpf_elf_map defined maps is not
+recommanded.
diff --git a/examples/bpf/bpf_cyclic.c b/examples/bpf/legacy/bpf_cyclic.c
similarity index 95%
rename from examples/bpf/bpf_cyclic.c
rename to examples/bpf/legacy/bpf_cyclic.c
index 11d1c061..33590730 100644
--- a/examples/bpf/bpf_cyclic.c
+++ b/examples/bpf/legacy/bpf_cyclic.c
@@ -1,4 +1,4 @@
-#include "../../include/bpf_api.h"
+#include "../../../include/bpf_api.h"
 
 /* Cyclic dependency example to test the kernel's runtime upper
  * bound on loops. Also demonstrates on how to use direct-actions,
diff --git a/examples/bpf/bpf_graft.c b/examples/bpf/legacy/bpf_graft.c
similarity index 97%
rename from examples/bpf/bpf_graft.c
rename to examples/bpf/legacy/bpf_graft.c
index 07113d4a..f4c920cc 100644
--- a/examples/bpf/bpf_graft.c
+++ b/examples/bpf/legacy/bpf_graft.c
@@ -1,4 +1,4 @@
-#include "../../include/bpf_api.h"
+#include "../../../include/bpf_api.h"
 
 /* This example demonstrates how classifier run-time behaviour
  * can be altered with tail calls. We start out with an empty
diff --git a/examples/bpf/bpf_map_in_map.c b/examples/bpf/legacy/bpf_map_in_map.c
similarity index 96%
rename from examples/bpf/bpf_map_in_map.c
rename to examples/bpf/legacy/bpf_map_in_map.c
index ff0e623a..575f8812 100644
--- a/examples/bpf/bpf_map_in_map.c
+++ b/examples/bpf/legacy/bpf_map_in_map.c
@@ -1,4 +1,4 @@
-#include "../../include/bpf_api.h"
+#include "../../../include/bpf_api.h"
 
 #define MAP_INNER_ID	42
 
diff --git a/examples/bpf/bpf_shared.c b/examples/bpf/legacy/bpf_shared.c
similarity index 97%
rename from examples/bpf/bpf_shared.c
rename to examples/bpf/legacy/bpf_shared.c
index 21fe6f1e..05b2b9ef 100644
--- a/examples/bpf/bpf_shared.c
+++ b/examples/bpf/legacy/bpf_shared.c
@@ -1,4 +1,4 @@
-#include "../../include/bpf_api.h"
+#include "../../../include/bpf_api.h"
 
 /* Minimal, stand-alone toy map pinning example:
  *
diff --git a/examples/bpf/bpf_tailcall.c b/examples/bpf/legacy/bpf_tailcall.c
similarity index 98%
rename from examples/bpf/bpf_tailcall.c
rename to examples/bpf/legacy/bpf_tailcall.c
index 161eb606..8ebc554c 100644
--- a/examples/bpf/bpf_tailcall.c
+++ b/examples/bpf/legacy/bpf_tailcall.c
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-#include "../../include/bpf_api.h"
+#include "../../../include/bpf_api.h"
 
 #define ENTRY_INIT	3
 #define ENTRY_0		0
-- 
2.25.4


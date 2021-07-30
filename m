Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B18B3E0173
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 14:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238301AbhHDMqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 08:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238246AbhHDMq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 08:46:26 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 506C1C0617B1;
        Wed,  4 Aug 2021 05:45:53 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id l34-20020a05600c1d22b02902573c214807so3839368wms.2;
        Wed, 04 Aug 2021 05:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cTkEzedgsHwcRt0daK5worxXRzwlWwNbUzqq6bWtxEU=;
        b=SOXwPYJQzU3gLnvN54Sb9+eH5Cce0nMx2LODLJMWJ6eHozCURXDWeukcTksQ+GY3JH
         1i/V9sQuvDMNyS49HrsxcoLEXYjKzziDe6Q35/nUVGFHARAU7uw0J5yAX/SCuKyw0bJm
         WTBgGCL8W9V1XdtNadHFJ7jkhMaYkQLgs41Sz6OoymDGxUzQhKbgqTI+rii8tEJhxBBK
         IwIDY3ZxCOQ3DsjepR31pe49lQ2PorcJ+EXzk8fjT5dzKIx6HUkHfEArOFkVBgmpLTD2
         txbYWlARPfuliH/Z7euri1LFXnZAFzsPPgbvVAem1osZNp12Jq7SLTSwB51F53gfFNew
         8FmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cTkEzedgsHwcRt0daK5worxXRzwlWwNbUzqq6bWtxEU=;
        b=ASh1HNF/vS0uTqXnRT+sqH2kDHys3xKmnj3Y4SRYf0DsI9UTV/YKJ70XAuBEAMGwsl
         hAlWgmkTW4RXamlxmNojM70JXKqxYNTyd0zgiF/9vxLqqXuT8wa1FKvGfVMKrW9nVUJO
         HiCzTXvU4KWh+cgEMePEaW7gqhJgmzqU8iu3QlK9DbLpNfUafyQFWEl4pfEpsfFXC8LC
         ngTUvxEtOHvUSzKQdlBwOKXkmsb8z6WYjeC/LTzEBoN8KyeBkYnKTM6rorL8nZqq/vJ0
         dniktCodrJCcFYfxwrJlRIUaFQfqIkwkOCWgMpJBJmEFufyRMcYlNP0hJNHd/xVP6HZz
         mKsg==
X-Gm-Message-State: AOAM530MU6ClIa5be61020ume0tyKEsa+XFWttGkad5x3SoEkIHcBsi+
        qSzrW0yDC8wUONnl4oA1UTnuJ9BmTk0BJlQ=
X-Google-Smtp-Source: ABdhPJyXMZscttekkLiMuP6L6lRP/uqRucrqsLb19fx2QskQFqC6tXPwuqptnl3hUa3StVyDi2xHKA==
X-Received: by 2002:a7b:c18f:: with SMTP id y15mr9624530wmi.117.1628081151672;
        Wed, 04 Aug 2021 05:45:51 -0700 (PDT)
Received: from localhost.localdomain ([77.109.191.101])
        by smtp.gmail.com with ESMTPSA id y4sm2257923wmi.22.2021.08.04.05.45.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 05:45:51 -0700 (PDT)
From:   Jussi Maki <joamaki@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, j.vosburgh@gmail.com,
        andy@greyhouse.net, vfalico@gmail.com, andrii@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        Jussi Maki <joamaki@gmail.com>
Subject: [PATCH bpf-next v5 6/7] selftests/bpf: Fix xdp_tx.c prog section name
Date:   Fri, 30 Jul 2021 06:18:21 +0000
Message-Id: <20210730061822.6600-7-joamaki@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210730061822.6600-1-joamaki@gmail.com>
References: <20210609135537.1460244-1-joamaki@gmail.com>
 <20210730061822.6600-1-joamaki@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The program type cannot be deduced from 'tx' which causes an invalid
argument error when trying to load xdp_tx.o using the skeleton.
Rename the section name to "xdp/tx" so that libbpf can deduce the type.

Signed-off-by: Jussi Maki <joamaki@gmail.com>
---
 tools/testing/selftests/bpf/progs/xdp_tx.c   | 2 +-
 tools/testing/selftests/bpf/test_xdp_veth.sh | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/xdp_tx.c b/tools/testing/selftests/bpf/progs/xdp_tx.c
index 94e6c2b281cb..ece1fbbc0984 100644
--- a/tools/testing/selftests/bpf/progs/xdp_tx.c
+++ b/tools/testing/selftests/bpf/progs/xdp_tx.c
@@ -3,7 +3,7 @@
 #include <linux/bpf.h>
 #include <bpf/bpf_helpers.h>
 
-SEC("tx")
+SEC("xdp/tx")
 int xdp_tx(struct xdp_md *xdp)
 {
 	return XDP_TX;
diff --git a/tools/testing/selftests/bpf/test_xdp_veth.sh b/tools/testing/selftests/bpf/test_xdp_veth.sh
index ba8ffcdaac30..c8e0b7d36f56 100755
--- a/tools/testing/selftests/bpf/test_xdp_veth.sh
+++ b/tools/testing/selftests/bpf/test_xdp_veth.sh
@@ -108,7 +108,7 @@ ip link set dev veth2 xdp pinned $BPF_DIR/progs/redirect_map_1
 ip link set dev veth3 xdp pinned $BPF_DIR/progs/redirect_map_2
 
 ip -n ns1 link set dev veth11 xdp obj xdp_dummy.o sec xdp_dummy
-ip -n ns2 link set dev veth22 xdp obj xdp_tx.o sec tx
+ip -n ns2 link set dev veth22 xdp obj xdp_tx.o sec xdp/tx
 ip -n ns3 link set dev veth33 xdp obj xdp_dummy.o sec xdp_dummy
 
 trap cleanup EXIT
-- 
2.17.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5D5B57A092
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 16:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238599AbiGSOIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 10:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237459AbiGSOH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 10:07:58 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 018CC52459;
        Tue, 19 Jul 2022 06:24:36 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id k30so19544845edk.8;
        Tue, 19 Jul 2022 06:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3V3aFgPFkbCcd7IYkXkvwq3sV487EH6croP4xbXcoWM=;
        b=YS9ww49VydU2UvrGIdDSuGsha0EtriH7fx7I1CNWnppIQIkeyZlnl6fM+Ql8qAan2E
         s8xjItaECGw1CxwfiW/chid7ciRuobRvd4DASvMd5tcyTxOrCVCaOWAi0kWsFuT41hEF
         zCiAQb7mSGSrop6cxA4Xg3k0Zh7lF2t0WPIi2pHEKB+yNSyvFmOnYahDYOjv7dUFKTOO
         uh5lCb83iMtb9f6DPepxF96RuhsomZhbn3DsyIHkWLRMxti1zWgESjrZlP7Go4Md4Eel
         MwC/0Pe0yAaJZAm8L0Q89GF6JL+qjPde3C9Jxt/L44p1/6Svg8u/ttWnIdpyQQq9/EOg
         oS6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3V3aFgPFkbCcd7IYkXkvwq3sV487EH6croP4xbXcoWM=;
        b=eo8eIuNuiPRb9i0UX5ItYrYAQj7+JdQSWCvcwPbJul+66kNtV5BZmnwCCymq/3Y0md
         noixSY+AkX67U0FF1cuBhj7FdU8IVrQFbPcgZh8hnz6wYhDdAgavVgI9UzUVvF6GTBJm
         3udbYOryjDK9LN7EYbAaXwlVDLBkmjL7WxM/DuS41cWUQkk+8Y70a+ipJ2Xm+2GFNEhN
         NFK8WA0Ew3XSLba6akNABcDDbclDhdcb3GrdxAqpIFkFSRv2IOdADQI7WZQoPVG10vwt
         IdBw7pv5CVLJW6kNGEwRg5ljuhg6ZHIC9WINJXlo9KQvrkmE7KD/w77avGCrxhX9r6qc
         agOg==
X-Gm-Message-State: AJIora8pi8gvXbxT/zHWC9EIEsKW2gYo45r4hQ/2lEzhJH+J5qYuPgQ+
        7F+aPsDTSpn0wXEyf2SUtQCa/IzJgWXHPA==
X-Google-Smtp-Source: AGRyM1u36yXZZ12e62DIUQx1q1h0KPjKoxTqMJPIyrzeHnYjwxQhMDNKzzjuTbC9lvlqHZRskAMPMg==
X-Received: by 2002:a05:6402:355:b0:43a:4f13:56d2 with SMTP id r21-20020a056402035500b0043a4f1356d2mr42987160edw.312.1658237074330;
        Tue, 19 Jul 2022 06:24:34 -0700 (PDT)
Received: from localhost (icdhcp-1-189.epfl.ch. [128.178.116.189])
        by smtp.gmail.com with ESMTPSA id 7-20020a170906308700b0072ee0976aa2sm6387202ejv.222.2022.07.19.06.24.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 06:24:33 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: [PATCH bpf-next v6 00/13] New nf_conntrack kfuncs for insertion, changing timeout, status
Date:   Tue, 19 Jul 2022 15:24:17 +0200
Message-Id: <20220719132430.19993-1-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4543; i=memxor@gmail.com; h=from:subject; bh=vEsIX36aWd9V7udaV1TkOUXQmy/EyCG47V7Ei61qvLU=; b=owEBbQKS/ZANAwAKAUzgyIZIvxHKAcsmYgBi1rBllAG5XodNfdu3EMuuRLTOvLZNhe6TEx3/q/RN OSxGMXyJAjMEAAEKAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYtawZQAKCRBM4MiGSL8RyqffD/ 9mH7gW+Pvd3N35+Png1vA00OW/WLivkamGUQB/87KlGObaBWF/LkJG3W2ZPm4/BhDWCfK0yDE7EBxb z4GrQyv9bFr3bFhI7GaBgHZC98QxjkYkbr6TJJoa59vMsDsDUZLdOY86Kuo+wdiA9b+aQ82Cys3y2E j8A9XS9DPUD0A6Pl6VcfEO37p5P7YyM3FrZye7OVzDQqqXMlAbBCjk98yw9LL0wIjQOVCx6PdvlNbp 42JjlsvgtvYx1UiyrrcP+DJl9aYNkTq+7U7evpFlRUyZWBfOzE2gD1AcNuseu+DY746J5dz/TSPMGN NqsKoifg6s4duLeiLqdTztciTf7FGXRYyQJ8QhHL3DTAL5LfOr/gO+631dXb2iO7IGWgo0mhHfZ8iA hQyGyI2cTIvKkGNsaxEFTM2k+sB6vDyxZ8EDHMUzZU0qUQ//z2Inutatn9tFqMyFDmHmw2tNQLsTkj Qe6zVk4NDhMF3NdIQbKlHqfaAcegNmvN35e9U5Ly+GVbbzkz8onFEvJkihuh0XRQHhNSa+5gWwPTud Cy7cCRgHApaJQCQEbJv9gSJSQUwxeG88yutkaaAW758sK59fWm7xnO8k1IHXMAluLkpcx6l26VmwuY +O6XRDK0a6Swu41mKhs/hJuWFPWdfy18TgC8KIIv7kHleVLX6MXuQgVXVlcg==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
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

Introduce the following new kfuncs:
 - bpf_{xdp,skb}_ct_alloc
 - bpf_ct_insert_entry
 - bpf_ct_{set,change}_timeout
 - bpf_ct_{set,change}_status

The setting of timeout and status on allocated or inserted/looked up CT
is same as the ctnetlink interface, hence code is refactored and shared
with the kfuncs. It is ensured allocated CT cannot be passed to kfuncs
that expected inserted CT, and vice versa. Please see individual patches
for details.

Changelog:
----------
v5 -> v6:
v5: https://lore.kernel.org/bpf/20220623192637.3866852-1-memxor@gmail.com

 * Introduce kfunc flags, rework verifier to work with them
 * Add documentation for kfuncs
 * Add comment explaining TRUSTED_ARGS kfunc flag (Alexei)
 * Fix missing offset check for trusted arguments (Alexei)
 * Change nf_conntrack test minimum delta value to 8

v4 -> v5:
v4: https://lore.kernel.org/bpf/cover.1653600577.git.lorenzo@kernel.org

 * Drop read-only PTR_TO_BTF_ID approach, use struct nf_conn___init (Alexei)
 * Drop acquire release pair code that is no longer required (Alexei)
 * Disable writes into nf_conn, use dedicated helpers (Florian, Alexei)
 * Refactor and share ctnetlink code for setting timeout and status
 * Do strict type matching on finding __ref suffix on argument to
   prevent passing nf_conn___init as nf_conn (offset = 0, match on walk)
 * Remove bpf_ct_opts parameter from bpf_ct_insert_entry
 * Update selftests for new additions, add more negative tests

v3 -> v4:
v3: https://lore.kernel.org/bpf/cover.1652870182.git.lorenzo@kernel.org

 * split bpf_xdp_ct_add in bpf_xdp_ct_alloc/bpf_skb_ct_alloc and
   bpf_ct_insert_entry
 * add verifier code to properly populate/configure ct entry
 * improve selftests

v2 -> v3:
v2: https://lore.kernel.org/bpf/cover.1652372970.git.lorenzo@kernel.org

 * add bpf_xdp_ct_add and bpf_ct_refresh_timeout kfunc helpers
 * remove conntrack dependency from selftests
 * add support for forcing kfunc args to be referenced and related selftests

v1 -> v2:
v1: https://lore.kernel.org/bpf/1327f8f5696ff2bc60400e8f3b79047914ccc837.1651595019.git.lorenzo@kernel.org

 * add bpf_ct_refresh_timeout kfunc selftest

Kumar Kartikeya Dwivedi (10):
  bpf: Introduce BTF ID flags and 8-byte BTF set
  tools/resolve_btfids: Add support for resolving kfunc flags
  bpf: Switch to new kfunc flags infrastructure
  bpf: Add support for forcing kfunc args to be trusted
  bpf: Add documentation for kfuncs
  net: netfilter: Deduplicate code in bpf_{xdp,skb}_ct_lookup
  net: netfilter: Add kfuncs to set and change CT timeout
  selftests/bpf: Add verifier tests for trusted kfunc args
  selftests/bpf: Add negative tests for new nf_conntrack kfuncs
  selftests/bpf: Fix test_verifier failed test in unprivileged mode

Lorenzo Bianconi (3):
  net: netfilter: Add kfuncs to allocate and insert CT
  net: netfilter: Add kfuncs to set and change CT status
  selftests/bpf: Add tests for new nf_conntrack kfuncs

 Documentation/bpf/index.rst                   |   1 +
 Documentation/bpf/kfuncs.rst                  | 171 ++++++++
 include/linux/bpf.h                           |   3 +-
 include/linux/btf.h                           |  68 ++--
 include/linux/btf_ids.h                       |  64 +++
 include/net/netfilter/nf_conntrack_core.h     |  19 +
 kernel/bpf/btf.c                              | 120 +++---
 kernel/bpf/verifier.c                         |  14 +-
 net/bpf/test_run.c                            |  75 ++--
 net/ipv4/bpf_tcp_ca.c                         |  18 +-
 net/ipv4/tcp_bbr.c                            |  24 +-
 net/ipv4/tcp_cubic.c                          |  20 +-
 net/ipv4/tcp_dctcp.c                          |  20 +-
 net/netfilter/nf_conntrack_bpf.c              | 365 +++++++++++++-----
 net/netfilter/nf_conntrack_core.c             |  62 +++
 net/netfilter/nf_conntrack_netlink.c          |  54 +--
 tools/bpf/resolve_btfids/main.c               | 115 +++++-
 .../selftests/bpf/bpf_testmod/bpf_testmod.c   |  10 +-
 .../testing/selftests/bpf/prog_tests/bpf_nf.c |  64 ++-
 .../testing/selftests/bpf/progs/test_bpf_nf.c |  85 +++-
 .../selftests/bpf/progs/test_bpf_nf_fail.c    | 134 +++++++
 .../selftests/bpf/verifier/bpf_loop_inline.c  |   1 +
 tools/testing/selftests/bpf/verifier/calls.c  |  53 +++
 23 files changed, 1214 insertions(+), 346 deletions(-)
 create mode 100644 Documentation/bpf/kfuncs.rst
 create mode 100644 tools/testing/selftests/bpf/progs/test_bpf_nf_fail.c

-- 
2.34.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56636558923
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 21:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbiFWTiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 15:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbiFWTiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 15:38:05 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCFE3522CD;
        Thu, 23 Jun 2022 12:26:41 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id h9-20020a17090a648900b001ecb8596e43so558613pjj.5;
        Thu, 23 Jun 2022 12:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GqYaJATAaS0gu8zM9QkkhGTVZAQBDeGyfBo0T1t8t3g=;
        b=h1NYrVxsnGnjGoofwE47E8vBqHsCzYygSe1J//HDhVWaan3LDZyYlAvgA3P00XbcZ/
         euYnO36srV9d7VDRBDeXtB4zx5bB+hkTfZUS65ph2s1MMAhgrXorboCBRQRLDEPjG4fj
         rtbiYdg7k+/p51ctcych1WxLbpa1j0dI1sTwnrsM7JtoGVuzuqys3jUeGgO0L7G0i4qX
         9gy9Ohrxd8x4HwiOVipfkp6nn+3fm+tQOsieHXeDbfPqvTqg64VjMeqAw4lBXvmd4Lw8
         rQJBgmyO1uoasmveWtTPa5TX58iYpw44jPh1fdwJZchkBnJNaTtVSJRJm4j81oJbNrAV
         kOvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GqYaJATAaS0gu8zM9QkkhGTVZAQBDeGyfBo0T1t8t3g=;
        b=uQXMTWdcbwtgJ0fVmAdaD0ssIzwHbyf2t1skFHDAOVX39SqiqIqu4/ZgujW/RIkSsf
         HOg+n17QD/Bs9qh/KuKl751oUvImHPSeVR2WtOxG55LtqcYjJOaLs1EYpTS7D7HFPwn3
         D318R23WzyxgM/wkrKstrL2yzDzwmGycCrnI3vmXgZIgKdcKZdEH2usQzhfwvHDQnFHo
         CMwLJSF3bpeDPzby9vLU3vSIrpVpi5e/JahP+sQU9OuzzH2nKf5WXFRCnpfc0j1/LWwT
         lRyzB/maDShyUMYFR+YSfBvmrodfPgsQddWDGKrcQsN+nvqEWd0SxjkKq9n31kIkG1gQ
         Uulw==
X-Gm-Message-State: AJIora+75LAzZl5zLvDMMi+m8iFeShSIz/psG9y8P117BvhItnjuvUEj
        QhHDm8Nh6E6LGFBne/qhx4m3s/wz8pU4sw==
X-Google-Smtp-Source: AGRyM1vnhKaME3MmoQfbVtOA3KHnYpwH/rrW143o0yh70EOr/96A95TLGShYGITpTcjXTAuyRl1yBw==
X-Received: by 2002:a17:90b:4a12:b0:1e3:15ef:81e1 with SMTP id kk18-20020a17090b4a1200b001e315ef81e1mr5624983pjb.246.1656012400868;
        Thu, 23 Jun 2022 12:26:40 -0700 (PDT)
Received: from localhost ([2405:201:6014:d0c0:79de:f3f4:353c:8616])
        by smtp.gmail.com with ESMTPSA id x4-20020a170902a38400b0015e8d4eb1easm176151pla.52.2022.06.23.12.26.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 12:26:40 -0700 (PDT)
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
Subject: [PATCH bpf-next v5 0/8] New nf_conntrack kfuncs for insertion, changing timeout, status
Date:   Fri, 24 Jun 2022 00:56:29 +0530
Message-Id: <20220623192637.3866852-1-memxor@gmail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3116; h=from:subject; bh=gmmiY7raUMwDluDLULEPPXrRSF89qu/tczGwaXrJM9E=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBitL5Lp5dCqLuevvZpj1yLYi51iIaExLYhtSShXe+u oFjbZw+JAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYrS+SwAKCRBM4MiGSL8RymMDEA C3Joi5tin8iH+GagFPp4uJ2eVyr8iFxBKp6A8OlwtszubjCUeFKp1s96h3jBt/zYnFuRnSIeK3LUSy SVmpb27ZrdUQNxFx+9u1g9RzPZo3xWS97pKseIVg6j8//WiOhSlt77aCq2aYfLIzS6Lbaxwmhk1Cq5 knyGsD6wJ+6S9eNldb8yh6JLjt3+6CHUYjGUskOBQDM2I3ph/k2ftd7WSHMtUNMG+//TqTOQ6EAZmu k1BrbQap+9OklpLfY31i+FNUWxKSWikQZ8WLjTyFN7p+2OmypoPz3RVPeFkjdpUSpBXtyd+7ZD7ehX r7/+4dhCIuJYW6QfvJPoqLagbmo5034IPA4eYhGwnbxtwHsOkmziub73IYHa+zVYug5BoZ7z6CnXYj K7nmLpMS/UqfPpX1Jppji7/QuFP7wnlufRpx4jAhKtavCi7gAmChFsuE7yVXISO7cX1VoPVVoJoWNT yzDmzlxKmtxN+ggGkp+Ua6mjzR8hHC8fZS+lv99lZ98gKKBHfA45h6wiyvJ/2A9ETpm43c4mELBrnJ O/5TEHXiGYU5uc6vqILe9DdvvaGWhSUVbmjS2jmPmwFix6tyn5xpn5j6z85xLmzr6iCiHrTG/BI6PW C2Jko4ObvTunnifrJ8JdHcSNonSdPhrWvJKpqJOPbaQzfARFOvR1D+otbxWg==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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

Kumar Kartikeya Dwivedi (5):
  bpf: Add support for forcing kfunc args to be referenced
  net: netfilter: Deduplicate code in bpf_{xdp,skb}_ct_lookup
  net: netfilter: Add kfuncs to set and change CT timeout
  selftests/bpf: Add verifier tests for forced kfunc ref args
  selftests/bpf: Add negative tests for new nf_conntrack kfuncs

Lorenzo Bianconi (3):
  net: netfilter: Add kfuncs to allocate and insert CT
  net: netfilter: Add kfuncs to set and change CT status
  selftests/bpf: Add tests for new nf_conntrack kfuncs

 include/net/netfilter/nf_conntrack_core.h     |  19 +
 kernel/bpf/btf.c                              |  48 ++-
 net/bpf/test_run.c                            |   5 +
 net/netfilter/nf_conntrack_bpf.c              | 330 +++++++++++++++---
 net/netfilter/nf_conntrack_core.c             |  62 ++++
 net/netfilter/nf_conntrack_netlink.c          |  54 +--
 .../testing/selftests/bpf/prog_tests/bpf_nf.c |  64 +++-
 .../testing/selftests/bpf/progs/test_bpf_nf.c |  85 ++++-
 .../selftests/bpf/progs/test_bpf_nf_fail.c    | 134 +++++++
 tools/testing/selftests/bpf/verifier/calls.c  |  53 +++
 10 files changed, 727 insertions(+), 127 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_bpf_nf_fail.c

-- 
2.36.1

